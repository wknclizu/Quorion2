#!/bin/bash
# Batch rewrite for all plan_*.json in each query subdirectory.
# For each plan, runs both Yann+ (-y N) and Yannakakis (-y Y).
#
# Usage: bash auto_rewrite_plans.sh <ddl> <query_dir> [genType]
# Example: bash auto_rewrite_plans.sh tpch tpch/q7 M
# Mode: M: Mysql, D: DuckDB, PG: PostgreSQL

SCRIPT=$(readlink -f "$0")
SCRIPT_PATH=$(dirname "${SCRIPT}")
PYTHON_ENV="/usr/bin/python3"

DDL_NAME=$1
INPUT_DIR="query/$2"
g=${3:-M}

if [ -z "$DDL_NAME" ] || [ -z "$2" ]; then
    echo "Usage: bash auto_rewrite_plans.sh <ddl> <query_dir> [genType]"
    echo "  e.g. bash auto_rewrite_plans.sh tpch tpch/q7 M"
    exit 1
fi

success=0
fail=0

for dir in $(find "${INPUT_DIR}" -type d | sort); do
    if [ "$dir" = "${INPUT_DIR}" ]; then
        continue
    fi

    CUR_PATH="${SCRIPT_PATH}/${dir}"

    # Find all plan_*.json files in this directory
    plan_files=$(find "${CUR_PATH}" -maxdepth 1 -name "plan_*.json" | sort)
    if [ -z "$plan_files" ]; then
        continue
    fi

    LOG_FILE="${CUR_PATH}/rewrite_time.txt"
    rm -f "${LOG_FILE}"
    touch "${LOG_FILE}"

    for plan_path in $plan_files; do
        plan_file=$(basename "$plan_path")

        for y in N Y; do
            if [ "$y" = "N" ]; then
                mode_label="Yann+"
            else
                mode_label="Yannakakis"
            fi

            echo "=== ${dir} | ${plan_file} | ${mode_label} ==="
            $PYTHON_ENV main.py "${CUR_PATH}" "${DDL_NAME}" -g "$g" -y "$y" -p "$plan_file" 2>&1
            ret=$?
            if [ $ret -eq 0 ]; then
                success=$((success + 1))
                echo "  -> OK" | tee -a "${LOG_FILE}"
            else
                fail=$((fail + 1))
                echo "  -> FAILED (exit $ret)" | tee -a "${LOG_FILE}"
            fi
        done
    done
done

echo ""
echo "=============================="
echo "Done. Success: $success, Failed: $fail"
