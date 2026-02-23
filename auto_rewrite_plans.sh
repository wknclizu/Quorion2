#!/bin/bash
# Batch rewrite for all plan_*.json in each query subdirectory.
# For each plan, runs both Yann+ (-y N) and Yannakakis (-y Y).
#
# Usage: bash auto_rewrite_plans.sh <ddl> <query_dir> [genType] [hintMode]
# Example: bash auto_rewrite_plans.sh tpch tpch/q7 M F
#   genType: M(Mysql) / D(DuckDB) / PG(PostgreSQL), default M
#   hintMode: F(force hint) / A(auto parser) / B(both), default F

SCRIPT=$(readlink -f "$0")
SCRIPT_PATH=$(dirname "${SCRIPT}")
PYTHON_ENV="/usr/bin/python3"

DDL_NAME=$1
INPUT_DIR="query/$2"
g=${3:-M}
HM=${4:-F}

if [ -z "$DDL_NAME" ] || [ -z "$2" ]; then
    echo "Usage: bash auto_rewrite_plans.sh <ddl> <query_dir> [genType] [hintMode]"
    echo "  genType: M(Mysql) / D(DuckDB) / PG(PostgreSQL), default M"
    echo "  hintMode: F(force hint) / A(auto parser) / B(both), default F"
    echo "  e.g. bash auto_rewrite_plans.sh tpch tpch/q7 M F"
    exit 1
fi

success=0
fail=0

run_one() {
    local cur_path=$1 y=$2 plan_arg=$3 hm=$4 label=$5
    echo "=== ${label} ==="
    $PYTHON_ENV main.py "${cur_path}" "${DDL_NAME}" -g "$g" -y "$y" -H "$hm" $plan_arg 2>&1
    ret=$?
    if [ $ret -eq 0 ]; then
        success=$((success + 1))
        echo "  -> OK" | tee -a "${cur_path}/rewrite_time.txt"
    else
        fail=$((fail + 1))
        echo "  -> FAILED (exit $ret)" | tee -a "${cur_path}/rewrite_time.txt"
    fi
}

for dir in $(find "${INPUT_DIR}" -type d | sort); do
    CUR_PATH="${SCRIPT_PATH}/${dir}"

    plan_files=$(find "${CUR_PATH}" -maxdepth 1 -regex '.*/plan_[0-9]+\.json' | sort)
    if [ -z "$plan_files" ]; then
        continue
    fi

    LOG_FILE="${CUR_PATH}/rewrite_time.txt"
    rm -f "${LOG_FILE}"
    touch "${LOG_FILE}"

    # Force hint mode: run per plan file
    if [ "$HM" = "F" ] || [ "$HM" = "B" ]; then
        for plan_path in $plan_files; do
            plan_file=$(basename "$plan_path")
            for y in N Y; do
                [ "$y" = "N" ] && ml="Yann+" || ml="Yannakakis"
                run_one "$CUR_PATH" "$y" "-p $plan_file" "F" "${dir} | ${plan_file} | ${ml} | hint=F"
            done
        done
    fi

    # Auto mode: run once per directory (no plan hint)
    if [ "$HM" = "A" ] || [ "$HM" = "B" ]; then
        for y in N Y; do
            [ "$y" = "N" ] && ml="Yann+" || ml="Yannakakis"
            run_one "$CUR_PATH" "$y" "" "A" "${dir} | auto | ${ml} | hint=A"
        done
    fi
done

echo ""
echo "=============================="
echo "Done. Success: $success, Failed: $fail"
