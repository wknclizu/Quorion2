from enumerate import *
from reduce import *
from aggregation import *
from enumsType import *
from treenode import *
import globalVar
import copy
import json

BEGIN = 'create or replace TEMP view '
END = ';\n'

def transSelectDataWrap(selectAttrs: list[str], selectAttrAlias: list[str], row_numer: bool = False, max_rn: bool = False) -> str:
    extraAdd = (', row_number()' if row_numer else '') + (', max(rn) as mrn' if max_rn else '')
    if len(selectAttrs) == 0: return ', '.join(selectAttrAlias) + extraAdd
    if len(selectAttrs) != len(selectAttrAlias):
        print("First: " + str(selectAttrs))
        print("Second: " + str(selectAttrAlias))
        raise RuntimeError("Two sides are not equal! ") 

    selectData = []
    for index, alias in enumerate(selectAttrAlias):
        if selectAttrAlias[index] == '': continue
        if selectAttrs[index] != '':
            selectData.append(selectAttrs[index] + ' as ' + selectAttrAlias[index])
        else:
            selectData.append(selectAttrAlias[index])
    
    ret = ', '.join(selectData) + extraAdd
    return ret

def transSelectData(selectAttrs: list[str], selectAttrAlias: list[str], row_numer: bool = False, max_rn: bool = False) -> str:
    ret = transSelectDataWrap(selectAttrs, selectAttrAlias, row_numer, max_rn)
    if (ret == ''): return '*'
    else: return ret

def codeGenD(reduceList: list[ReducePhase], enumerateList: list[EnumeratePhase], finalResult: str, outPath: str, aggList: list[AggReducePhase] = [], isFreeConnex: bool = True, Agg: Aggregation = None):
    outFile = open(outPath, 'w+')
    dropView = []
    queries = ""
    # 0. aggReduceList
    for agg in aggList:
        # outFile.write('\n# AggReduce' + str(agg.aggReducePhaseId) + '\n')
        
        if len(agg.prepareView) != 0:
            # outFile.write('# 0. Prepare\n')
            for prepare in agg.prepareView:
                if prepare.reduceType == ReduceType.CreateBagView:
                    line = BEGIN + prepare.viewName + ' as select ' + transSelectData(prepare.selectAttrs, prepare.selectAttrAlias) + ' from ' + ', '.join(prepare.joinTableList) + ((' where ' + ' and '.join(prepare.whereCondList)) if len(prepare.whereCondList) else '') + END
                elif prepare.reduceType == ReduceType.CreateAuxView:
                    line = BEGIN + prepare.viewName + ' as select ' + transSelectData(prepare.selectAttrs, prepare.selectAttrAlias) + ' from ' + prepare.fromTable
                    line += ' where ' if len(prepare.whereCondList) else ''
                    line += ' and '.join(prepare.whereCondList) + END
                else:   # TableAgg
                    line = BEGIN + prepare.viewName + ' as select ' + transSelectData(prepare.selectAttrs, prepare.selectAttrAlias) + ' from ' + prepare.fromTable + ', ' + ', '.join(prepare.joinTableList) + ' where ' + ' and '.join(prepare.whereCondList) + END
                
                dropView.append(prepare.viewName)
                queries += line
                outFile.write(line)
                
        def getAggViewLine(aggView: AggView, isWith: bool):
            if isWith:
                line = 'with ' + aggView.viewName + ' as (select '
            else:
                line = BEGIN + aggView.viewName + ' as select '
            line += transSelectData(aggView.selectAttrs, aggView.selectAttrAlias) + ' from ' + aggView.fromTable
            line += (' where ' + ' and '.join(aggView.selfComp)) if len(aggView.selfComp) else ''
            if len(aggView.groupBy):
                line += ' group by ' + ','.join(aggView.groupBy)
            if isWith:
                line += ')\n'
            else:
                line += END
            return line
        
        if 'Join' in agg.aggJoin.viewName:
            line = BEGIN + agg.aggJoin.viewName + ' as (\n' + getAggViewLine(agg.aggView, True) + 'select ' + transSelectData(agg.aggJoin.selectAttrs, agg.aggJoin.selectAttrAlias) + ' from '
            if agg.aggJoin.fromTable != '':
                joinSentence = agg.aggJoin.fromTable
                if agg.aggJoin._joinFlag == ' JOIN ':
                    joinSentence += ' join ' + agg.aggJoin.joinTable + ' using(' + ','.join(agg.aggJoin.alterJoinKey) + ')'
                else:
                    joinSentence += ', ' + agg.aggJoin.joinTable
                line += joinSentence
            else:
                line += agg.aggJoin.joinTable
            line += ' where ' if len(agg.aggJoin.whereCondList) else ''
            line += ' and '.join(agg.aggJoin.whereCondList) + ');\n'
            dropView.append(agg.aggJoin.viewName)
            queries += line
            outFile.write(line)
        else:
            outFile.write(getAggViewLine(agg.aggView, False))
    
    # 1. reduceList rewrite
    for reduce in reduceList:
        # outFile.write('\n# Reduce' + str(reduce.reducePhaseId) + '\n')
        
        if len(reduce.prepareView) != 0:
            # outFile.write('# 0. Prepare\n')
            for prepare in reduce.prepareView:
                if prepare.reduceType == ReduceType.CreateBagView:
                    line = BEGIN + prepare.viewName + ' as select ' + transSelectData(prepare.selectAttrs, prepare.selectAttrAlias) + ' from ' + ', '.join(prepare.joinTableList) + ((' where ' + ' and '.join(prepare.whereCondList)) if len(prepare.whereCondList) else '') + END
                elif prepare.reduceType == ReduceType.CreateAuxView:
                    line = BEGIN + prepare.viewName + ' as select ' + transSelectData(prepare.selectAttrs, prepare.selectAttrAlias) + ' from ' + prepare.fromTable
                    line += ' where ' if len(prepare.whereCondList) else ''
                    line += ' and '.join(prepare.whereCondList) + END
                else:   # TableAgg
                    line = BEGIN + prepare.viewName + ' as select ' + transSelectData(prepare.selectAttrs, prepare.selectAttrAlias) + ' from ' + prepare.fromTable + ', ' + ', '.join(prepare.joinTableList) + ' where ' + ' and '.join(prepare.whereCondList) + END
                
                dropView.append(prepare.viewName)
                queries += line
                outFile.write(line)
        
        if reduce.semiView is not None and not 'Aux' in reduce.semiView.viewName:
            # outFile.write('# +. SemiJoin\n')
            # TODO: Add change for auxNode creation
            line = BEGIN + reduce.semiView.viewName + ' as select ' + transSelectData(reduce.semiView.selectAttrs, reduce.semiView.selectAttrAlias) + ' from ' + reduce.semiView.fromTable + ' where (' + ', '.join(reduce.semiView.inLeft) + ') in (select ' + '(' * (True if globalVar.get_value('GEN_TYPE') == 'DuckDB' else False)
            line += ', '.join(reduce.semiView.inRight) + ')' * (True if globalVar.get_value('GEN_TYPE') == 'DuckDB' else False)
            line += ' from ' + reduce.semiView.joinTable
            line += ' where ' if len(reduce.semiView.whereCondList) != 0 else ''
            line += ' and '.join(reduce.semiView.whereCondList) + ')' 
            line += ' and ' if len(reduce.semiView.outerWhereCondList) else ''
            line += ' and '.join(reduce.semiView.outerWhereCondList) + END
            queries += line
            outFile.write(line)
            dropView.append(reduce.semiView.viewName)
            continue
        
        '''0: normal, 1: with 2: without with'''
        def getOrderViewLine(orderView: CreateOrderView, isWith: int):
            if not isWith:
                line = BEGIN + orderView.viewName + ' as select '
            elif isWith == 1:
                line = 'with ' + orderView.viewName + ' as (select '
            else:
                line = orderView.viewName + ' as (select '
            line += transSelectData(orderView.selectAttrs, orderView.selectAttrAlias, row_numer=True) + ' over (partition by ' + ', '.join(orderView.joinKey) + ' order by ' + ', '.join(orderView.orderKey) + (' DESC' if not orderView.AESC else '') + ') as rn ' + 'from ' + orderView.fromTable
            line += ' where ' if len(orderView.selfComp) != 0 else ''
            line += ' and '.join(orderView.selfComp)
            if isWith:
                line += ')\n'
            else:
                line += END
            return line
        
        def getMinViewLine(minView: SelectMinAttr, isWith: int):
            if not isWith:
                line = BEGIN + minView.viewName + ' as select '
            elif isWith == 1:
                line = 'with ' + minView.viewName + ' as (select '
            else:
                line = minView.viewName + ' as (select '
            line += transSelectData(minView.selectAttrs, minView.selectAttrAlias) + ' from ' + minView.fromTable
            line += ' where ' + minView.whereCond if minView.whereCond != '' else ''
            line += ' group by ' + ', '.join(minView.groupBy) if len(minView.groupBy) else ''
            if isWith:
                line += ')\n'
            else:
                line += END
            return line
        
        if not reduce.joinView:
            continue
        line = BEGIN + reduce.joinView.viewName + ' as (\n'
        if reduce.orderView:
            line += getOrderViewLine(reduce.orderView, 1)
        if reduce.minView:
            if 'with' in line:
                line += ',' + getMinViewLine(reduce.minView, 2)
            else:
                line += getMinViewLine(reduce.minView, 1)
            
        line += 'select ' + transSelectData(reduce.joinView.selectAttrs, reduce.joinView.selectAttrAlias) + ' from '
        joinSentence = reduce.joinView.fromTable
        if reduce.joinView._joinFlag == ' JOIN ':
            joinSentence +=' join ' + reduce.joinView.joinTable + ' using(' + ', '.join(reduce.joinView.alterJoinKey) + ')'
        else:
            joinSentence += ', ' + reduce.joinView.joinTable
        whereSentence = reduce.joinView.joinCond + (' and ' if reduce.joinView.joinCond != '' and len(reduce.joinView.whereCondList) else '') + ' and '.join(reduce.joinView.whereCondList)
        line += joinSentence + ((' where ' + whereSentence) if whereSentence != '' else '')
        line += ');\n'
        queries += line
        outFile.write(line)
        
        if reduce.bagAuxView:
            # outFile.write('# 5. bagAuxView\n')
            line = BEGIN + reduce.bagAuxView.viewName + ' as select ' + transSelectData(reduce.bagAuxView.selectAttrs, reduce.bagAuxView.selectAttrAlias) + ' from ' + reduce.bagAuxView.joinTableList[0]
            if (len(reduce.bagAuxView.joinKey) != len(reduce.bagAuxView.joinTableList) - 1):
                raise RuntimeError("Error JoinKey number (wrong bag internal table join)! ")
            for i in range(1, len(reduce.bagAuxView.joinTableList)):
                line += ' join ' + reduce.bagAuxView.joinTableList[i] + ' using(' + ','.join(reduce.bagAuxView.joinKey[i-1]) + ')'
            line += (' where ' + ' and '.join(reduce.bagAuxView.whereCondList)) if len(reduce.bagAuxView.whereCondList) else ''
            line += END
            dropView.append(reduce.bagAuxView.viewName)
            queries += line
            outFile.write(line)
    
    def addGroupBy(action):
        if not Agg or (Agg and not isFreeConnex):
            return ''
        xannot = [alias for alias in action.selectAttrAlias if alias != 'annot' and alias not in Agg.allAggAlias]

        return ' group by ' + ','.join(xannot) if not isFreeConnex else ''
    
    # 2. enumerateList rewrite
    if len(enumerateList) > 0:
        line = BEGIN + enumerateList[-1].stageEnd.viewName + ' as (\n' if enumerateList[-1].stageEnd else BEGIN + enumerateList[-1].semiEnumerate.viewName + ' as (\n'
        for index, enum in enumerate(enumerateList):
            if enum.semiEnumerate is not None:
                if len(enumerateList) == 1:
                    line += 'select ' + transSelectData(enum.semiEnumerate.selectAttrs, enum.semiEnumerate.selectAttrAlias) + ' from ' + enum.semiEnumerate.fromTable
                    line += ' join ' if len(enum.semiEnumerate.joinKey) != 0 else ', '
                    line += enum.semiEnumerate.joinTable
                    line += ' using(' + ', '.join(enum.semiEnumerate.joinKey) + ')' if len(enum.semiEnumerate.joinKey) != 0 else ''
            
                    if enum.semiEnumerate.joinCond and len(enum.semiEnumerate.whereCondList):
                        line += ' where ' + enum.semiEnumerate.joinCond + ' and ' + ' and '.join(enum.semiEnumerate.whereCondList)
                    elif enum.semiEnumerate.joinCond:
                        line += ' where ' + enum.semiEnumerate.joinCond
                    elif len(enum.semiEnumerate.whereCondList):
                        line += ' where ' + ' and '.join(enum.semiEnumerate.whereCondList)
                    line += ');\n'
                    queries += line
                    outFile.write(line)
                    continue

                # outFile.write('# +. SemiEnumerate\n')
                if 'with' in line:
                    line += ','
                else:
                    line += 'with '
                line += enum.semiEnumerate.viewName + ' as (select ' + transSelectData(enum.semiEnumerate.selectAttrs, enum.semiEnumerate.selectAttrAlias) + ' from ' + enum.semiEnumerate.fromTable
                line += ' join ' if len(enum.semiEnumerate.joinKey) != 0 else ', '
                line += enum.semiEnumerate.joinTable
                line += ' using(' + ', '.join(enum.semiEnumerate.joinKey) + ')' if len(enum.semiEnumerate.joinKey) != 0 else ''
            
                if enum.semiEnumerate.joinCond and len(enum.semiEnumerate.whereCondList):
                    line += ' where ' + enum.semiEnumerate.joinCond + ' and ' + ' and '.join(enum.semiEnumerate.whereCondList)
                elif enum.semiEnumerate.joinCond:
                    line += ' where ' + enum.semiEnumerate.joinCond
                elif len(enum.semiEnumerate.whereCondList):
                    line += ' where ' + ' and '.join(enum.semiEnumerate.whereCondList)
            
                line += ')\n'
                queries += line
                outFile.write(line)
                dropView.append(enum.semiEnumerate.viewName)
                continue
        
            if enum.createSample:
                # outFile.write('# 1. createSample\n')
                if 'with' in line:
                    line += ','
                else:
                    line += 'with '
                line += enum.createSample.viewName + ' as select (' + enum.createSample.selectAttrAlias[0] + ' from ' + enum.createSample.fromTable + ' where ' + enum.createSample.whereCond + ')\n'
            if enum.selectMax:
                # outFile.write('# 2. selectMax\n')
                if 'with' in line:
                    line += ','
                else:
                    line += 'with '
                line += enum.selectMax.viewName + ' as select (' + transSelectData(enum.selectMax.selectAttrs, enum.selectMax.selectAttrAlias, row_numer=False, max_rn=True) + ' from ' + enum.selectMax.fromTable + ' join ' + enum.selectMax.joinTable + ' using(' + ', '.join(enum.selectMax.joinKey) + ') where ' + enum.selectMax.whereCond + ' group by ' + ', '.join(enum.selectMax.groupCond) + ')\n' 
            if enum.selectTarget:
                # outFile.write('# 3. selectTarget\n')
                if 'with' in line:
                    line += ','
                else:
                    line += 'with '
                line += enum.selectTarget.viewName + ' as select ' + ', '.join(enum.selectTarget.selectAttrAlias) + ' from ' + enum.selectTarget.fromTable + ' join ' + enum.selectTarget.joinTable + ' using(' + ', '.join(enum.selectTarget.joinKey) + ')' + ' where ' + enum.selectTarget.whereCond + ')\n'

            if index == len(enumerateList) - 1:
                line += 'select '
            else:
                if 'with' in line:
                    line += ','
                else:
                    line += 'with '
                line += enum.stageEnd.viewName + ' as (select '
            if enum.stageEnd.joinUsingFlag:
                line += ', '.join(enum.stageEnd.selectAttrAlias) + ' from ' + enum.stageEnd.fromTable + ' join ' + enum.stageEnd.joinTable + ' using(' + ', '.join(enum.stageEnd.joinKey) + ')' + ' where ' + enum.stageEnd.whereCond 
            else:
                line += ', '.join(enum.stageEnd.selectAttrAlias) + ' from ' + enum.stageEnd.fromTable + ', ' + enum.stageEnd.joinTable + ' where ' + enum.stageEnd.whereCond 
            line += ' and ' if len(enum.stageEnd.whereCondList) else ''
            line += ' and '.join(enum.stageEnd.whereCondList) + addGroupBy(enum.stageEnd)
            if index != len(enumerateList) - 1:
                line += ')\n'
            else:
                line += ');\n'

        queries += line
        outFile.write(line)
    
    # outFile.write('# Final result: \n')
    queries += finalResult
    outFile.write(finalResult)
    outFile.close()


# TODO: final output variables error? 
# def codeGen(reduceList: list[ReducePhase], enumerateList: list[EnumeratePhase], finalResult: str, outPath: str, aggList: list[AggReducePhase] = [], isFreeConnex: bool = True, Agg: Aggregation = None, isFull: bool = True, genType: GenType = GenType.DuckDB):
def codeGen(reduceList: list[ReducePhase], enumerateList: list[EnumeratePhase], finalResult: str, outPath: str, aggList: list[AggReducePhase] = [], isFreeConnex: bool = True, Agg: Aggregation = None, isFull: bool = True, genType: GenType = GenType.DuckDB, planFinalResult: list[dict[str, any]] = []):
    # optimize for DuckDB with subquery rewrite
    '''
    if genType == GenType.DuckDB:
        codeGenD(reduceList, enumerateList, finalResult, outPath, aggList, isFreeConnex, Agg)
        return
    '''
    queries = ""
    outFile = open(outPath, 'w+')
    planOutFile = open(outPath.replace('.sql', '_plan.json'), 'w+')
    dropView = []
    plan = []
    
    # 0. aggReduceList
    for agg in aggList:
        # outFile.write('\n# AggReduce' + str(agg.aggReducePhaseId) + '\n')
        
        if len(agg.prepareView) != 0:
            # outFile.write('# 0. Prepare\n')
            for prepare in agg.prepareView:
                if prepare.reduceType == ReduceType.CreateBagView:
                    line = BEGIN + prepare.viewName + ' as select ' + transSelectData(prepare.selectAttrs, prepare.selectAttrAlias) + ' from ' + ', '.join(prepare.joinTableList) + ((' where ' + ' and '.join(prepare.whereCondList)) if len(prepare.whereCondList) else '') + END
                    
                    print("multi-table join in CreateBagView")
                    planLine = {
                        "operator": "Join",
                        "properties": {
                            "viewName": prepare.viewName,
                            "columns": prepare.selectAttrs if prepare.selectAttrs else [""] * len(prepare.selectAttrAlias),
                            "columnAliases": prepare.selectAttrAlias,
                            "inputView": prepare.joinTableList,  # multiple tables for bag view
                            "conditions": prepare.whereCondList if len(prepare.whereCondList) else []
                        }
                    }
                    plan.append(copy.deepcopy(planLine))
                elif prepare.reduceType == ReduceType.CreateAuxView:
                    line = BEGIN + prepare.viewName + ' as select ' + transSelectData(prepare.selectAttrs, prepare.selectAttrAlias) + ' from ' + prepare.fromTable
                    line += ' where ' if len(prepare.whereCondList) else ''
                    line += ' and '.join(prepare.whereCondList) + END
                    
                    planLine = {
                        "operator": "Select",
                        "properties": {
                            "viewName": prepare.viewName,
                            "columns": prepare.selectAttrs if prepare.selectAttrs else [""] * len(prepare.selectAttrAlias),
                            "columnAliases": prepare.selectAttrAlias,
                            "inputView": prepare.fromTable,
                            "conditions": prepare.whereCondList if len(prepare.whereCondList) else []
                        }
                    }
                    plan.append(copy.deepcopy(planLine))
                else:   # TableAgg
                    line = BEGIN + prepare.viewName + ' as select ' + transSelectData(prepare.selectAttrs, prepare.selectAttrAlias) + ' from ' + prepare.fromTable + ', ' + ', '.join(prepare.joinTableList) + ' where ' + ' and '.join(prepare.whereCondList) + END
                    
                    print("multi-table Join in TableAgg")
                    planLine = {
                        "operator": "Join",
                        "properties": {
                            "viewName": prepare.viewName,
                            "columns": prepare.selectAttrs if prepare.selectAttrs else [""] * len(prepare.selectAttrAlias),
                            "columnAliases": prepare.selectAttrAlias,
                            "joinTables": [prepare.fromTable] + prepare.joinTableList,  # additional joined tables
                            "joinKeys": [],
                            "conditions": prepare.whereCondList
                        }
                    }
                    plan.append(copy.deepcopy(planLine))
                
                dropView.append(prepare.viewName)
                queries += line
                outFile.write(line)
                
        # outFile.write('# 1. aggView\n')
        line = BEGIN + agg.aggView.viewName + ' as select ' + transSelectData(agg.aggView.selectAttrs, agg.aggView.selectAttrAlias) + ' from ' + agg.aggView.fromTable
        line += (' where ' + ' and '.join(agg.aggView.selfComp)) if len(agg.aggView.selfComp) else ''
        if len(agg.aggView.groupBy):
            line += ' group by ' + ','.join(agg.aggView.groupBy)
        line += END
        dropView.append(agg.aggView.viewName)
        queries += line
        outFile.write(line)
        
        planLine = {
            "operator": "Select" if len(agg.aggView.groupBy) == 0 else "GroupBy",
            "properties": {
                "viewName": agg.aggView.viewName,
                "columns": agg.aggView.selectAttrs if agg.aggView.selectAttrs else [""] * len(agg.aggView.selectAttrAlias),
                "columnAliases": agg.aggView.selectAttrAlias,
                "inputView": agg.aggView.fromTable,
                "conditions": agg.aggView.selfComp if len(agg.aggView.selfComp) else [],
                "groupBy": agg.aggView.groupBy if len(agg.aggView.groupBy) else [] # group by in engine
            }
        }
        plan.append(copy.deepcopy(planLine))
        
        if 'Join' in agg.aggJoin.viewName:
            # outFile.write('# 2. aggJoin\n')
            line = BEGIN + agg.aggJoin.viewName + ' as select ' + transSelectData(agg.aggJoin.selectAttrs, agg.aggJoin.selectAttrAlias) + ' from '
            if agg.aggJoin.fromTable != '':
                joinSentence = agg.aggJoin.fromTable
                if agg.aggJoin._joinFlag == ' JOIN ':
                    joinSentence += ' join ' + agg.aggJoin.joinTable + ' using(' + ','.join(agg.aggJoin.alterJoinKey) + ')'
                else:
                    joinSentence += ', ' + agg.aggJoin.joinTable
                line += joinSentence
            else:
                line += agg.aggJoin.joinTable
            line += ' where ' if len(agg.aggJoin.whereCondList) else ''
            line += ' and '.join(agg.aggJoin.whereCondList) + END
            dropView.append(agg.aggJoin.viewName)
            queries += line
            outFile.write(line)
            
            if agg.aggJoin.fromTable != '':
                planLine = {
                    "operator": "Join",
                    "properties": {
                        "viewName": agg.aggJoin.viewName,
                        "columns": agg.aggJoin.selectAttrs if agg.aggJoin.selectAttrs else [""] * len(agg.aggJoin.selectAttrAlias),
                        "columnAliases": agg.aggJoin.selectAttrAlias,
                        "probeTable": agg.aggJoin.fromTable,
                        "buildTable": agg.aggJoin.joinTable,
                        "joinKeys": agg.aggJoin.alterJoinKey,
                        "conditions": agg.aggJoin.whereCondList
                    }
                }
            else:
                planLine = {
                    "operator": "Select",
                    "properties": {
                        "viewName": agg.aggJoin.viewName,
                        "columns": agg.aggJoin.selectAttrs if agg.aggJoin.selectAttrs else [""] * len(agg.aggJoin.selectAttrAlias),
                        "columnAliases": agg.aggJoin.selectAttrAlias,
                        "inputView": agg.aggJoin.joinTable,
                        "conditions": agg.aggJoin.whereCondList
                    }
                }
            plan.append(copy.deepcopy(planLine))
    
    # 1. reduceList rewrite
    for index, reduce in enumerate(reduceList):
        # outFile.write('\n# Reduce' + str(reduce.reducePhaseId) + '\n')
        
        if len(reduce.prepareView) != 0:
            # outFile.write('# 0. Prepare\n')
            for prepare in reduce.prepareView:
                if prepare.reduceType == ReduceType.CreateBagView:
                    line = BEGIN + prepare.viewName + ' as select ' + transSelectData(prepare.selectAttrs, prepare.selectAttrAlias) + ' from ' + ', '.join(prepare.joinTableList) + ((' where ' + ' and '.join(prepare.whereCondList)) if len(prepare.whereCondList) else '') + END
                    
                    print("multi-table join in CreateBagView in reduceList")
                    planLine = {
                        "operator": "Join",
                        "properties": {
                            "viewName": prepare.viewName,
                            "columns": prepare.selectAttrs if prepare.selectAttrs else [""] * len(prepare.selectAttrAlias),
                            "columnAliases": prepare.selectAttrAlias,
                            "inputView": prepare.joinTableList,  # multiple tables for bag view
                            "conditions": prepare.whereCondList if len(prepare.whereCondList) else []
                        }
                    }
                    plan.append(copy.deepcopy(planLine))
                elif prepare.reduceType == ReduceType.CreateAuxView:
                    line = BEGIN + prepare.viewName + ' as select ' + transSelectData(prepare.selectAttrs, prepare.selectAttrAlias) + ' from ' + prepare.fromTable
                    line += ' where ' if len(prepare.whereCondList) else ''
                    line += ' and '.join(prepare.whereCondList) + END
                    
                    planLine = {
                        "operator": "Select",
                        "properties": {
                            "viewName": prepare.viewName,
                            "columns": prepare.selectAttrs if prepare.selectAttrs else [""] * len(prepare.selectAttrAlias),
                            "columnAliases": prepare.selectAttrAlias,
                            "inputView": prepare.fromTable,
                            "conditions": prepare.whereCondList if len(prepare.whereCondList) else []
                        }
                    }
                    plan.append(copy.deepcopy(planLine))
                else:   # TableAgg
                    line = BEGIN + prepare.viewName + ' as select ' + transSelectData(prepare.selectAttrs, prepare.selectAttrAlias) + ' from ' + prepare.fromTable + ', ' + ', '.join(prepare.joinTableList) + ' where ' + ' and '.join(prepare.whereCondList) + END
                    
                    # print("multi-table Join in TableAgg in reduceList")
                    if (len(prepare.joinTableListPlanline) == 0 or len(prepare.joinTableListPlanline) > 1):
                        print("WARNING: multi-table join in TableAgg in reduceList: ", prepare.joinTableListPlanline)
                    for planLine in prepare.joinTableListPlanline:
                        tableName = planLine["properties"]["viewName"]
                        plan.append(copy.deepcopy(planLine))
                    print("tableName: ", tableName)
                    
                    planLine = {
                        "operator": "Join",
                        "properties": {
                            "viewName": prepare.viewName,
                            "columns": prepare.selectAttrs if prepare.selectAttrs else [""] * len(prepare.selectAttrAlias),
                            "columnAliases": prepare.selectAttrAlias,
                            "probeTable": prepare.fromTable,
                            "buildTable": tableName,  # additional joined tables
                            # "joinTables": prepare.joinTableList + [prepare.fromTable],  # additional joined tables
                            "conditions": prepare.whereCondList
                        }
                    }
                    plan.append(copy.deepcopy(planLine))
                
                dropView.append(prepare.viewName)
                queries += line
                outFile.write(line)
        
        if reduce.semiView is not None and not 'Aux' in reduce.semiView.viewName:
            # outFile.write('# +. SemiJoin\n')
            # TODO: Add change for auxNode creation
            if not isFull and index == len(reduceList) - 1:
                line = BEGIN + reduce.semiView.viewName + ' as select distinct ' + transSelectData(reduce.semiView.selectAttrs, reduce.semiView.selectAttrAlias) + ' from ' + reduce.semiView.fromTable + ' where (' + ', '.join(reduce.semiView.inLeft) + ') in (select ' + '(' * (True if globalVar.get_value('GEN_TYPE') == 'DuckDB' else False)
            else:
                line = BEGIN + reduce.semiView.viewName + ' as select ' + transSelectData(reduce.semiView.selectAttrs, reduce.semiView.selectAttrAlias) + ' from ' + reduce.semiView.fromTable + ' where (' + ', '.join(reduce.semiView.inLeft) + ') in (select ' + '(' * (True if globalVar.get_value('GEN_TYPE') == 'DuckDB' else False)
            line += ', '.join(reduce.semiView.inRight) + ')' * (True if globalVar.get_value('GEN_TYPE') == 'DuckDB' else False)
            line += ' from ' + reduce.semiView.joinTable
            line += ' where ' if len(reduce.semiView.whereCondList) != 0 else ''
            line += ' and '.join(reduce.semiView.whereCondList) + ')' 
            line += ' and ' if len(reduce.semiView.outerWhereCondList) else ''
            line += ' and '.join(reduce.semiView.outerWhereCondList) + END
            queries += line
            outFile.write(line)
            dropView.append(reduce.semiView.viewName)
            
            planLine = {
                "operator": "SemiJoin",
                "properties": {
                    "viewName": reduce.semiView.viewName,
                    "columns": reduce.semiView.selectAttrs if reduce.semiView.selectAttrs else [""] * len(reduce.semiView.selectAttrAlias),
                    "columnAliases": reduce.semiView.selectAttrAlias,
                    "probeTable": reduce.semiView.fromTable,
                    "buildTable": reduce.semiView.joinTable,
                    "probeKeys": reduce.semiView.inLeft,
                    "buildKeys": reduce.semiView.inRight,
                    "innerConditions": reduce.semiView.whereCondList if len(reduce.semiView.whereCondList) else [],
                    "outerConditions": reduce.semiView.outerWhereCondList if len(reduce.semiView.outerWhereCondList) else [],
                    "distinct": not isFull and index == len(reduceList) - 1  # indicate if DISTINCT is used
                }
            }
            plan.append(copy.deepcopy(planLine))
            
            continue
                
        # CQC part, if orderView is None, pass do nothing (for aux support relation output case)
        if reduce.orderView is not None:    
            # outFile.write('# 1. orderView\n')
            line = BEGIN + reduce.orderView.viewName + ' as select ' + transSelectData(reduce.orderView.selectAttrs, reduce.orderView.selectAttrAlias, row_numer=True) + ' over (partition by ' + ', '.join(reduce.orderView.joinKey) + ' order by ' + ', '.join(reduce.orderView.orderKey) + (' DESC' if not reduce.orderView.AESC else '') + ') as rn ' + 'from ' + reduce.orderView.fromTable
            line += ' where ' if len(reduce.orderView.selfComp) != 0 else ''
            line += ' and '.join(reduce.orderView.selfComp) + END
            dropView.append(reduce.orderView.viewName)
            queries += line
            outFile.write(line)
            
            print("PLAN: OrderView")
            planLine = {
                "operator": "Select",
                "properties": {
                    "viewName": reduce.orderView.viewName,
                    "columns": reduce.orderView.selectAttrs if reduce.orderView.selectAttrs else [""] * len(reduce.orderView.selectAttrAlias),
                    "columnAliases": reduce.orderView.selectAttrAlias + ["rn"],  # add row number column
                    "inputView": reduce.orderView.fromTable,
                    "conditions": reduce.orderView.selfComp if len(reduce.orderView.selfComp) else [],
                    "windowFunction": {  # window function specification
                        "function": "row_number()",
                        "partitionBy": reduce.orderView.joinKey,
                        "orderBy": reduce.orderView.orderKey,
                        "orderDirection": "DESC" if not reduce.orderView.AESC else "ASC"
                    }
                }
            }
            plan.append(copy.deepcopy(planLine))
        
        # Add optiomization for non-full (delete orderView)
        if reduce.minView is not None:
            # outFile.write('# 2. minView\n')
            line = BEGIN + reduce.minView.viewName + ' as select ' + transSelectData(reduce.minView.selectAttrs, reduce.minView.selectAttrAlias) + ' from ' + reduce.minView.fromTable
            line += ' where ' + reduce.minView.whereCond if reduce.minView.whereCond != '' else ''
            line += ' group by ' + ', '.join(reduce.minView.groupBy) if len(reduce.minView.groupBy) else ''
            line += END
            dropView.append(reduce.minView.viewName)
            queries += line
            outFile.write(line)
            
            if len(reduce.minView.groupBy) > 0:
                planLine = {
                    "operator": "GroupBy",
                    "properties": {
                        "viewName": reduce.minView.viewName,
                        "columns": reduce.minView.selectAttrs if reduce.minView.selectAttrs else [""] * len(reduce.minView.selectAttrAlias),
                        "columnAliases": reduce.minView.selectAttrAlias,
                        "inputView": reduce.minView.fromTable,
                        "conditions": [reduce.minView.whereCond] if reduce.minView.whereCond != '' else [],
                        "groupBy": reduce.minView.groupBy
                    }
                }
            else:
                planLine = {
                    "operator": "Select",
                    "properties": {
                        "viewName": reduce.minView.viewName,
                        "columns": reduce.minView.selectAttrs if reduce.minView.selectAttrs else [""] * len(reduce.minView.selectAttrAlias),
                        "columnAliases": reduce.minView.selectAttrAlias,
                        "inputView": reduce.minView.fromTable,
                        "conditions": [reduce.minView.whereCond] if reduce.minView.whereCond != '' else []
                    }
                }
            plan.append(copy.deepcopy(planLine))
            # outFile.write('# 3. joinView\n')
            if not isFull and index == len(reduceList) - 1:
                line = BEGIN + reduce.joinView.viewName + ' as select distinct ' + transSelectData(reduce.joinView.selectAttrs, reduce.joinView.selectAttrAlias) + ' from '
            else:
                line = BEGIN + reduce.joinView.viewName + ' as select ' + transSelectData(reduce.joinView.selectAttrs, reduce.joinView.selectAttrAlias) + ' from '
            joinSentence = reduce.joinView.fromTable
            if reduce.joinView._joinFlag == ' JOIN ':
                joinSentence +=' join ' + reduce.joinView.joinTable + ' using(' + ', '.join(reduce.joinView.alterJoinKey) + ')'
            else:
                joinSentence += ', ' + reduce.joinView.joinTable
            whereSentence = reduce.joinView.joinCond + (' and ' if reduce.joinView.joinCond != '' and len(reduce.joinView.whereCondList) else '') + ' and '.join(reduce.joinView.whereCondList)
            line += joinSentence + ((' where ' + whereSentence) if whereSentence != '' else '') + END
            dropView.append(reduce.joinView.viewName)
            queries += line
            outFile.write(line)
            
            allConditions = []
            if reduce.joinView.joinCond != '':
                allConditions.append(reduce.joinView.joinCond)
            allConditions.extend(reduce.joinView.whereCondList)
            
            planLine = {
                "operator": "Join",
                "properties": {
                    "viewName": reduce.joinView.viewName,
                    "columns": reduce.joinView.selectAttrs if reduce.joinView.selectAttrs else [""] * len(reduce.joinView.selectAttrAlias),
                    "columnAliases": reduce.joinView.selectAttrAlias,
                    "probeTable": reduce.joinView.fromTable,
                    "buildTable": reduce.joinView.joinTable,
                    "joinKeys": reduce.joinView.alterJoinKey if reduce.joinView._joinFlag == ' JOIN ' else [],
                    "conditions": allConditions,
                    "distinct": not isFull and index == len(reduceList) - 1,
                    "joinType": "INNER"
                }
            }
            plan.append(copy.deepcopy(planLine))
        
        if reduce.bagAuxView:
            # outFile.write('# 5. bagAuxView\n')
            line = BEGIN + reduce.bagAuxView.viewName + ' as select ' + transSelectData(reduce.bagAuxView.selectAttrs, reduce.bagAuxView.selectAttrAlias) + ' from ' + reduce.bagAuxView.joinTableList[0]
            if (len(reduce.bagAuxView.joinKey) != len(reduce.bagAuxView.joinTableList) - 1):
                raise RuntimeError("Error JoinKey number (wrong bag internal table join)! ")
            for i in range(1, len(reduce.bagAuxView.joinTableList)):
                line += ' join ' + reduce.bagAuxView.joinTableList[i] + ' using(' + ','.join(reduce.bagAuxView.joinKey[i-1]) + ')'
            line += (' where ' + ' and '.join(reduce.bagAuxView.whereCondList)) if len(reduce.bagAuxView.whereCondList) else ''
            line += END
            dropView.append(reduce.bagAuxView.viewName)
            queries += line
            outFile.write(line)
            
            print("multi-table join in bagAuxView in reduceList")
            planLine = {
                "operator": "Join",
                "properties": {
                    "viewName": reduce.bagAuxView.viewName,
                    "columns": reduce.bagAuxView.selectAttrs if reduce.bagAuxView.selectAttrs else [""] * len(reduce.bagAuxView.selectAttrAlias),
                    "columnAliases": reduce.bagAuxView.selectAttrAlias,
                    "joinTables": [reduce.bagAuxView.fromTable] + reduce.bagAuxView.joinTableList,  # additional joined tables
                    "joinKeys": reduce.bagAuxView.joinKey,  # keys for each join
                    "conditions": reduce.bagAuxView.whereCondList if len(reduce.bagAuxView.whereCondList) else [],
                    "joinType": "INNER"  # bag aux view uses inner joins
                }
            }
            plan.append(copy.deepcopy(planLine))
    
    def addGroupBy(action):
        if not Agg or (Agg and not isFreeConnex):
            return ''
        xannot = [alias for alias in action.selectAttrAlias if alias != 'annot' and alias not in Agg.allAggAlias]
        return ' group by ' + ','.join(xannot) if not isFreeConnex else ''
    
    # 2. enumerateList rewrite
    for index, enum in enumerate(enumerateList):
        # outFile.write('\n# Enumerate' + str(enum.enumeratePhaseId) + '\n')
        if enum.semiEnumerate is not None:
            # outFile.write('# +. SemiEnumerate\n')
            if not isFull and index != len(enumerateList) - 1:
                line = BEGIN + enum.semiEnumerate.viewName + ' as select distinct ' + transSelectData(enum.semiEnumerate.selectAttrs, enum.semiEnumerate.selectAttrAlias) + ' from ' + enum.semiEnumerate.fromTable
            else:
                line = BEGIN + enum.semiEnumerate.viewName + ' as select ' + transSelectData(enum.semiEnumerate.selectAttrs, enum.semiEnumerate.selectAttrAlias) + ' from ' + enum.semiEnumerate.fromTable
            line += ' join ' if len(enum.semiEnumerate.joinKey) != 0 else ', '
            line += enum.semiEnumerate.joinTable
            line += ' using(' + ', '.join(enum.semiEnumerate.joinKey) + ')' if len(enum.semiEnumerate.joinKey) != 0 else ''
            
            if enum.semiEnumerate.joinCond and len(enum.semiEnumerate.whereCondList):
                line += ' where ' + enum.semiEnumerate.joinCond + ' and ' + ' and '.join(enum.semiEnumerate.whereCondList)
            elif enum.semiEnumerate.joinCond:
                line += ' where ' + enum.semiEnumerate.joinCond
            elif len(enum.semiEnumerate.whereCondList):
                line += ' where ' + ' and '.join(enum.semiEnumerate.whereCondList)
            
            line += END
            queries += line
            outFile.write(line)
            dropView.append(enum.semiEnumerate.viewName)
            
            # generate plan for SemiEnumerate
            conditions = []  # all conditions (join conditions + where conditions)
            
            if enum.semiEnumerate.joinCond:
                conditions.append(enum.semiEnumerate.joinCond)
            if len(enum.semiEnumerate.whereCondList):
                conditions.extend(enum.semiEnumerate.whereCondList)
            
            # determine join type based on join keys and join conditions
            hasJoinKeys = len(enum.semiEnumerate.joinKey) > 0
            hasJoinConditions = enum.semiEnumerate.joinCond is not None
            if hasJoinKeys or hasJoinConditions:
                # INNER JOIN (either with USING clause or with join conditions)
                planLine = {
                    "operator": "Join",
                    "properties": {
                        "viewName": enum.semiEnumerate.viewName,
                        "columns": enum.semiEnumerate.selectAttrs if enum.semiEnumerate.selectAttrs else [""] * len(enum.semiEnumerate.selectAttrAlias),
                        "columnAliases": enum.semiEnumerate.selectAttrAlias,
                        "probeTable": enum.semiEnumerate.fromTable,
                        "buildTable": enum.semiEnumerate.joinTable,
                        "joinKeys": enum.semiEnumerate.joinKey,  # for USING clause
                        "conditions": conditions,  # all conditions (join + where)
                        "distinct": not isFull and index != len(enumerateList) - 1,
                        "joinType": "INNER"
                    }
                }
            else:
                # CROSS JOIN (cartesian product) - no join keys and no join conditions
                print("PLAN: CrossJoin")
                planLine = {
                    "operator": "Join",
                    "properties": {
                        "viewName": enum.semiEnumerate.viewName,
                        "columns": enum.semiEnumerate.selectAttrs if enum.semiEnumerate.selectAttrs else [""] * len(enum.semiEnumerate.selectAttrAlias),
                        "columnAliases": enum.semiEnumerate.selectAttrAlias,
                        "probeTable": enum.semiEnumerate.fromTable,
                        "buildTable": enum.semiEnumerate.joinTable,
                        "joinKeys": [],
                        "conditions": conditions,  # where conditions still apply to cross join result
                        "distinct": not isFull and index != len(enumerateList) - 1,
                        "joinType": "CROSS"
                    }
                }
            plan.append(copy.deepcopy(planLine))
            
            continue
        
        if enum.createSample:
            # outFile.write('# 1. createSample\n')
            line = BEGIN + enum.createSample.viewName + ' as select ' + enum.createSample.selectAttrAlias[0] + ' from ' + enum.createSample.fromTable + ' where ' + enum.createSample.whereCond + END
            dropView.append(enum.createSample.viewName)
            queries += line
            outFile.write(line)
            
            planLine = {
                "operator": "Select",
                "properties": {
                    "viewName": enum.createSample.viewName,
                    "columns": [""] * len(enum.createSample.selectAttrAlias),  # columns are empty for sample
                    "columnAliases": enum.createSample.selectAttrAlias,
                    "inputView": enum.createSample.fromTable,
                    "conditions": [enum.createSample.whereCond]
                }
            }
            plan.append(copy.deepcopy(planLine))
        
        if enum.selectMax:
            # outFile.write('# 2. selectMax\n')
            line = BEGIN + enum.selectMax.viewName + ' as select ' + transSelectData(enum.selectMax.selectAttrs, enum.selectMax.selectAttrAlias, row_numer=False, max_rn=True) + ' from ' + enum.selectMax.fromTable + ' join ' + enum.selectMax.joinTable + ' using(' + ', '.join(enum.selectMax.joinKey) + ') where ' + enum.selectMax.whereCond + ' group by ' + ', '.join(enum.selectMax.groupCond) + END 
            dropView.append(enum.selectMax.viewName)
            queries += line
            outFile.write(line)
            
            print("PLAN: SelectMax + 2 steps")
            # generate plan for SelectMax - split into JOIN + GroupBy
            # Step 1: Join operation
            joinPlan = {
                "operator": "Join",
                "properties": {
                    "viewName": enum.selectMax.viewName + "_join",  # intermediate view name
                    "columns": enum.selectMax.selectAttrs if enum.selectMax.selectAttrs else [""] * len(enum.selectMax.selectAttrAlias),
                    "columnAliases": enum.selectMax.selectAttrAlias,
                    "probeTable": enum.selectMax.fromTable,
                    "buildTable": enum.selectMax.joinTable,
                    "joinKeys": enum.selectMax.joinKey,
                    "conditions": [enum.selectMax.whereCond],
                    "joinType": "INNER"
                }
            }
            plan.append(copy.deepcopy(joinPlan))
            
            # Step 2: GroupBy operation with MAX aggregation
            groupByPlan = {
                "operator": "GroupBy",
                "properties": {
                    "viewName": enum.selectMax.viewName,
                    "columns": enum.selectMax.selectAttrs if enum.selectMax.selectAttrs else [""] * len(enum.selectMax.selectAttrAlias),
                    "columnAliases": enum.selectMax.selectAttrAlias + ["mrn"],  # add max row number column
                    "inputView": enum.selectMax.viewName + "_join",  # input from previous join
                    "conditions": [],  # no additional conditions in GroupBy
                    "groupBy": enum.selectMax.groupCond,
                    "aggregation": "MAX"  # MAX aggregation on row numbers
                }
            }
            plan.append(copy.deepcopy(groupByPlan))
        
        if enum.selectTarget:
            # outFile.write('# 3. selectTarget\n')
            line = BEGIN + enum.selectTarget.viewName + ' as select ' + ', '.join(enum.selectTarget.selectAttrAlias) + ' from ' + enum.selectTarget.fromTable + ' join ' + enum.selectTarget.joinTable + ' using(' + ', '.join(enum.selectTarget.joinKey) + ')' + ' where ' + enum.selectTarget.whereCond + END
            dropView.append(enum.selectTarget.viewName)
            queries += line
            outFile.write(line)
            
            planLine = {
                "operator": "Join",
                "properties": {
                    "viewName": enum.selectTarget.viewName,
                    "columns": [""] * len(enum.selectTarget.selectAttrAlias),  # columns are aliases only
                    "columnAliases": enum.selectTarget.selectAttrAlias,
                    "probeTable": enum.selectTarget.fromTable,
                    "buildTable": enum.selectTarget.joinTable,
                    "joinKeys": enum.selectTarget.joinKey,
                    "conditions": [enum.selectTarget.whereCond],
                    "joinType": "INNER"
                }
            }
            plan.append(copy.deepcopy(planLine))
        
        # outFile.write('# 4. stageEnd\n')
        if not isFull and index != len(enumerateList) - 1:
            if enum.stageEnd.joinUsingFlag:
                line = BEGIN + enum.stageEnd.viewName + ' as select distinct ' + ', '.join(enum.stageEnd.selectAttrAlias) + ' from ' + enum.stageEnd.fromTable + ' join ' + enum.stageEnd.joinTable + ' using(' + ', '.join(enum.stageEnd.joinKey) + ')' + ' where ' + enum.stageEnd.whereCond 
            else:
                line = BEGIN + enum.stageEnd.viewName + ' as select distinct ' + ', '.join(enum.stageEnd.selectAttrAlias) + ' from ' + enum.stageEnd.fromTable + ', ' + enum.stageEnd.joinTable + ' where ' + enum.stageEnd.whereCond 
        else:
            if enum.stageEnd.joinUsingFlag:
                line = BEGIN + enum.stageEnd.viewName + ' as select ' + ', '.join(enum.stageEnd.selectAttrAlias) + ' from ' + enum.stageEnd.fromTable + ' join ' + enum.stageEnd.joinTable + ' using(' + ', '.join(enum.stageEnd.joinKey) + ')' + ' where ' + enum.stageEnd.whereCond 
            else:
                line = BEGIN + enum.stageEnd.viewName + ' as select ' + ', '.join(enum.stageEnd.selectAttrAlias) + ' from ' + enum.stageEnd.fromTable + ', ' + enum.stageEnd.joinTable + ' where ' + enum.stageEnd.whereCond 
        line += ' and ' if len(enum.stageEnd.whereCondList) else ''
        line += ' and '.join(enum.stageEnd.whereCondList) + addGroupBy(enum.stageEnd) + END
        dropView.append(enum.stageEnd.viewName)
        queries += line
        outFile.write(line)
        
        # generate plan for StageEnd
        conditions = []  # all conditions (join conditions + where conditions)
        if enum.stageEnd.whereCond:
            conditions.append(enum.stageEnd.whereCond)
        if len(enum.stageEnd.whereCondList):
            conditions.extend(enum.stageEnd.whereCondList)
            
        groupByClause = addGroupBy(enum.stageEnd)
        hasGroupBy = groupByClause.strip() != ''
        
        print("PLAN: StageEnd + 2 steps")
        # determine join type based on join flags and keys
        if enum.stageEnd.joinUsingFlag and len(enum.stageEnd.joinKey) > 0:
            # Join with USING clause
            # Step 1: Join operation
            joinPlan = {
                "operator": "Join",
                "properties": {
                    "viewName": enum.stageEnd.viewName + "_join" if hasGroupBy else enum.stageEnd.viewName,
                    "columns": [""] * len(enum.stageEnd.selectAttrAlias),
                    "columnAliases": enum.stageEnd.selectAttrAlias,
                    "probeTable": enum.stageEnd.fromTable,
                    "buildTable": enum.stageEnd.joinTable,
                    "joinKeys": enum.stageEnd.joinKey,  # for USING clause
                    "conditions": conditions,  # all conditions
                    "distinct": not isFull and index != len(enumerateList) - 1 and not hasGroupBy,
                    "joinType": "INNER"
                }
            }
            plan.append(copy.deepcopy(joinPlan))
            
            # Step 2: GroupBy operation (if needed)
            if hasGroupBy:
                groupByPlan = {
                    "operator": "GroupBy",
                    "properties": {
                        "viewName": enum.stageEnd.viewName,
                        "columns": [""] * len(enum.stageEnd.selectAttrAlias),
                        "columnAliases": enum.stageEnd.selectAttrAlias,
                        "inputView": enum.stageEnd.viewName + "_join",  # input from previous join
                        "conditions": [],  # no additional conditions in GroupBy
                        "groupBy": groupByClause.replace(" group by ", "").split(","),
                        "distinct": not isFull and index != len(enumerateList) - 1
                    }
                }
                plan.append(copy.deepcopy(groupByPlan))
        else:
            # Comma join - may be cross join or join with conditions
            hasJoinConditions = enum.stageEnd.whereCond is not None
            actualJoinType = "INNER" if hasJoinConditions else "CROSS"
            
            # Step 1: Join operation
            joinPlan = {
                "operator": "Join",
                "properties": {
                    "viewName": enum.stageEnd.viewName + "_join" if hasGroupBy else enum.stageEnd.viewName,
                    "columns": [""] * len(enum.stageEnd.selectAttrAlias),
                    "columnAliases": enum.stageEnd.selectAttrAlias,
                    "probeTable": enum.stageEnd.fromTable,
                    "buildTable": enum.stageEnd.joinTable,
                    "joinKeys": [],  # comma join has no USING keys
                    "conditions": conditions,  # all conditions
                    "distinct": not isFull and index != len(enumerateList) - 1 and not hasGroupBy,
                    "joinType": actualJoinType
                }
            }
            plan.append(copy.deepcopy(joinPlan))
            
            # Step 2: GroupBy operation (if needed)
            if hasGroupBy:
                groupByPlan = {
                    "operator": "GroupBy",
                    "properties": {
                        "viewName": enum.stageEnd.viewName,
                        "columns": [""] * len(enum.stageEnd.selectAttrAlias),
                        "columnAliases": enum.stageEnd.selectAttrAlias,
                        "inputView": enum.stageEnd.viewName + "_join",  # input from previous join
                        "conditions": [],  # no additional conditions in GroupBy
                        "groupBy": groupByClause.replace(" group by ", "").split(","),
                        "distinct": not isFull and index != len(enumerateList) - 1
                    }
                }
                plan.append(copy.deepcopy(groupByPlan))
    
    # outFile.write('# Final result: \n')
    queries += finalResult
    outFile.write(finalResult)
    
    ''' drop view summary
    if len(dropView):
        line = '\n# drop view ' + ', '.join(dropView) + END
        outFile.write(line)
    '''
    outFile.close()
    
    for planLine in planFinalResult:
        plan.append(copy.deepcopy(planLine))
    planOutFile.write(json.dumps({"plan": plan}, indent=2))
    planOutFile.close()
    return queries
