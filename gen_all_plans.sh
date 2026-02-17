#!/bin/bash
# Batch generate join tree plans for all query.sql files under query/

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
GEN_PLANS="$SCRIPT_DIR/gen_plans.py"

success=0
fail=0
skip=0
fail_list=""

for sql_file in $(find "$SCRIPT_DIR/query" -name "query.sql" | sort); do
    rel_path="${sql_file#$SCRIPT_DIR/}"
    echo "========== $rel_path =========="
    output=$(python3 "$GEN_PLANS" "$sql_file" 2>&1)
    exit_code=$?
    echo "$output"
    if [ $exit_code -eq 0 ]; then
        success=$((success + 1))
    else
        fail=$((fail + 1))
        fail_list="$fail_list  $rel_path\n"
    fi
    echo ""
done

echo "=============================="
echo "Done. Success: $success, Failed: $fail"
if [ $fail -gt 0 ]; then
    echo "Failed queries:"
    echo -e "$fail_list"
fi
