import json
from enumerate import *
from reduce import *
from aggregation import *
from enumsType import *
from treenode import *
from codegen import transSelectData, addTerminationPolicy

import globalVar

BEGIN = 'create or replace TEMP view '
END = ';\n'

def codeGenYa(semiUp: list[SemiUpPhase], semiDown: list[SemiJoin], lastUp: Union[list[AggReducePhase], list[Join2tables]], finalResult: str, outPath: str, genType: GenType = GenType.DuckDB, isAgg: bool = False, planFinalResult: list[dict[str, any]] = []):
    outFile = open(outPath, 'w')
    queries = ""
    planOutFile = open(outPath.replace('.sql', '.json'), 'w+')
    plan = []

    for semi in semiUp:
        for prepare in semi.prepareView:
            if prepare.reduceType == ReduceType.CreateBagView:
                line = BEGIN + prepare.viewName + ' as select ' + transSelectData(prepare.selectAttrs, prepare.selectAttrAlias) + ' from ' + ', '.join(prepare.joinTableList) + ((' where ' + ' and '.join(prepare.whereCondList)) if len(prepare.whereCondList) else '') + END
                planLine = {
                    "operator": "Select",
                    "properties": {
                        "viewName": prepare.viewName,
                        "columns": prepare.selectAttrs,
                        "columnAliases": prepare.selectAttrAlias,
                        "inputView": prepare.joinTableList,
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
                        "columns": prepare.selectAttrs,
                        "columnAliases": prepare.selectAttrAlias,
                        "inputView": prepare.fromTable,
                        "conditions": prepare.whereCondList if len(prepare.whereCondList) else []
                    }
                }
                plan.append(copy.deepcopy(planLine))
            else:   # TableAgg
                line = BEGIN + prepare.viewName + ' as select ' + transSelectData(prepare.selectAttrs, prepare.selectAttrAlias) + ' from ' + prepare.fromTable + ', ' + ', '.join(prepare.joinTableList) + ' where ' + ' and '.join(prepare.whereCondList) + END
                
                planLine = {
                    "operator": "Select",
                    "properties": {
                        "viewName": prepare.viewName,
                        "columns": prepare.selectAttrs,
                        "columnAliases": prepare.selectAttrAlias,
                        "inputView": prepare.fromTable,
                        "joinTables": prepare.joinTableList,
                        "conditions": prepare.whereCondList
                    }
                }
                plan.append(copy.deepcopy(planLine))
            queries += line
            outFile.write(line)

        if semi.semiView is not None and not 'Aux' in semi.semiView.viewName:
            # outFile.write('# +. SemiJoin\n')
            # TODO: Add change for auxNode creation
            line = BEGIN + semi.semiView.viewName + ' as select ' + transSelectData(semi.semiView.selectAttrs, semi.semiView.selectAttrAlias) + ' from ' + semi.semiView.fromTable
            if len(semi.semiView.inLeft):
                line += ' where (' + ', '.join(semi.semiView.inLeft) + ') in (select ' + '(' * (True if globalVar.get_value('GEN_TYPE') == 'DuckDB' else False) + ', '.join(semi.semiView.inRight) + ')' * (True if globalVar.get_value('GEN_TYPE') == 'DuckDB' else False) + ' from ' + semi.semiView.joinTable
            
            if len(semi.semiView.inLeft):
                line += ' where ' if len(semi.semiView.whereCondList) else ''
                line += ' and '.join(semi.semiView.whereCondList) + ')'
            
            if len(semi.semiView.outerWhereCondList):
                if not len(semi.semiView.inLeft):
                    line += ' where '
                else:
                    line += ' and '
            line += ' and '.join(semi.semiView.outerWhereCondList) + END
            queries += line
            outFile.write(line)
            
            planLine = {
                "operator": "SemiJoin",
                "properties": {
                    "viewName": semi.semiView.viewName,
                    "columns": semi.semiView.selectAttrs if semi.semiView.selectAttrs else [""] * len(semi.semiView.selectAttrAlias),
                    "columnAliases": semi.semiView.selectAttrAlias,
                    "probeTable": semi.semiView.fromTable,
                    "buildTable": semi.semiView.joinTable,
                    "probeKeys": semi.semiView.inLeft,
                    "buildKeys": semi.semiView.inRight,
                    "innerConditions": semi.semiView.whereCondList if len(semi.semiView.whereCondList) else [],
                    "outerConditions": semi.semiView.outerWhereCondList if len(semi.semiView.outerWhereCondList) else []
                }
            }
            plan.append(copy.deepcopy(planLine))

    for semi in semiDown:
        # outFile.write('# +. SemiJoin\n')
        # TODO: Add change for auxNode creation
        line = BEGIN + semi.viewName + ' as select ' + transSelectData(semi.selectAttrs, semi.selectAttrAlias) + ' from ' + semi.fromTable
        if len(semi.inLeft):
            line += ' where (' + ', '.join(semi.inLeft) + ') in (select ' + '(' * (True if globalVar.get_value('GEN_TYPE') == 'DuckDB' else False) + ', '.join(semi.inRight) + ')' * (True if globalVar.get_value('GEN_TYPE') == 'DuckDB' else False) + ' from ' + semi.joinTable
        
        if len(semi.inLeft):
            line += ' where ' if len(semi.whereCondList) else ''
            line += ' and '.join(semi.whereCondList) + ')'

        if len(semi.outerWhereCondList):
            if not len(semi.inLeft):
                line += ' where '
            else:
                line += ' and '
        line += ' and '.join(semi.outerWhereCondList) + END
        queries += line
        outFile.write(line)
        
        planLine = {
            "operator": "SemiJoin",
            "properties": {
                "viewName": semi.viewName,
                "columns": semi.selectAttrs if semi.selectAttrs else [""] * len(semi.selectAttrAlias),
                "columnAliases": semi.selectAttrAlias,
                "probeTable": semi.fromTable,
                "buildTable": semi.joinTable,
                "probeKeys": semi.inLeft,
                "buildKeys": semi.inRight,
                "innerConditions": semi.whereCondList if len(semi.whereCondList) else [],
                "outerConditions": semi.outerWhereCondList if len(semi.outerWhereCondList) else []
            }
        }
        plan.append(copy.deepcopy(planLine))

    for last in lastUp:
        if isAgg:
            line = BEGIN + last.aggView.viewName + ' as select ' + transSelectData(last.aggView.selectAttrs, last.aggView.selectAttrAlias) + ' from ' + last.aggView.fromTable
            line += (' where ' + ' and '.join(last.aggView.selfComp)) if len(last.aggView.selfComp) else ''
            if len(last.aggView.groupBy):
                line += ' group by ' + ','.join(last.aggView.groupBy)
            line += END
            queries += line
            outFile.write(line)
            
            planLine = {
                "operator": "Select" if len(last.aggView.groupBy) == 0 else "GroupBy",
                "properties": {
                    "viewName": last.aggView.viewName,
                    "columns": last.aggView.selectAttrs,
                    "columnAliases": last.aggView.selectAttrAlias,
                    "inputView": last.aggView.fromTable,
                    "conditions": last.aggView.selfComp if len(last.aggView.selfComp) else [],
                    "groupBy": last.aggView.groupBy if len(last.aggView.groupBy) else []
                }
            }
            plan.append(copy.deepcopy(planLine))
            
            if 'Join' in last.aggJoin.viewName:
                line = BEGIN + last.aggJoin.viewName + ' as select ' + transSelectData(last.aggJoin.selectAttrs, last.aggJoin.selectAttrAlias) + ' from '
                if last.aggJoin.fromTable != '':
                    joinSentence = last.aggJoin.fromTable
                    if last.aggJoin._joinFlag == ' JOIN ':
                        joinSentence += ' join ' + last.aggJoin.joinTable + ' using(' + ','.join(last.aggJoin.alterJoinKey) + ')'
                    else:
                        joinSentence += ', ' + last.aggJoin.joinTable
                    line += joinSentence
                else:
                    line += last.aggJoin.joinTable
                line += ' where ' if len(last.aggJoin.whereCondList) else ''
                line += ' and '.join(last.aggJoin.whereCondList) + END
                queries += line
                outFile.write(line)
                
                if last.aggJoin.fromTable != '':
                    planLine = {
                        "operator": "Join",
                        "properties": {
                            "viewName": last.aggJoin.viewName,
                            "columns": last.aggJoin.selectAttrs if last.aggJoin.selectAttrs else [""] * len(last.aggJoin.selectAttrAlias),
                            "columnAliases": last.aggJoin.selectAttrAlias,
                            "probeTable": last.aggJoin.fromTable,
                            "buildTable": last.aggJoin.joinTable,
                            "joinKeys": last.aggJoin.alterJoinKey,
                            "conditions": last.aggJoin.whereCondList
                        }
                    }
                else:
                    planLine = {
                        "operator": "Select",
                        "properties": {
                            "viewName": last.aggJoin.viewName,
                            "columns": last.aggJoin.selectAttrs if last.aggJoin.selectAttrs else [""] * len(last.aggJoin.selectAttrAlias),
                            "columnAliases": last.aggJoin.selectAttrAlias,
                            "inputView": last.aggJoin.joinTable,
                            "conditions": last.aggJoin.whereCondList
                        }
                    }
                plan.append(copy.deepcopy(planLine))
        else:
            line = BEGIN + last.viewName + ' as select ' + transSelectData(last.selectAttrs, last.selectAttrAlias) + ' from '
            joinSentence = last.fromTable
            if last._joinFlag == ' JOIN ':
                joinSentence +=' join ' + last.joinTable + ' using(' + ', '.join(last.alterJoinKey) + ')'
            else:
                joinSentence += ', ' + last.joinTable
            whereSentence = last.joinCond + (' and ' if last.joinCond != '' and len(last.whereCondList) else '') + ' and '.join(last.whereCondList)
            line += joinSentence + ((' where ' + whereSentence) if whereSentence != '' else '') + END
            queries += line
            outFile.write(line)
            
            planLine = {
                "operator": "Join",
                "properties": {
                    "viewName": last.viewName,
                    "columns": last.selectAttrs if last.selectAttrs else [""] * len(last.selectAttrAlias),
                    "columnAliases": last.selectAttrAlias,
                    "probeTable": last.fromTable,
                    "buildTable": last.joinTable,
                    "joinKeys": last.alterJoinKey,
                    "joinCondition": last.joinCond,
                    "conditions": last.whereCondList
                }
            }
            plan.append(copy.deepcopy(planLine))

    queries += finalResult
    outFile.write(finalResult)
    outFile.close()
    
    for planLine in planFinalResult:
        plan.append(planLine)
    addTerminationPolicy(plan)
    planOutFile.write(json.dumps({"plan": plan}, indent=2))
    planOutFile.close()
    
    return queries