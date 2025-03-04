#!/bin/bash

python="/usr/bin/python3"

SCRIPT=$(readlink -f $0)
SCRIPT_PATH=$(dirname "${SCRIPT}")

PYTHON_ENV="venv/bin/python"

INPUT_DIR="query/$2"
INPUT_DIR_PATH="${SCRIPT_PATH}/${INPUT_DIR}"
DDL_NAME=$1
g=${3:-M}
y=${4:-N}
b=${5:-2}
m=${6:-0}

# Suffix function
function FileSuffix() {
    local filename="$1"
    if [ -n "$filename" ]; then
        echo "${filename##*.}"
    fi
}

function IsSuffix() {
    local filename="$1"
    if [ "$(FileSuffix ${filename})" = "sql" ]
    then
        return 0
    else 
        return 1
    fi
}

for dir in $(find ${INPUT_DIR} -type d);
do
    if [ $dir != ${INPUT_DIR} ]; then
        CUR_PATH="${SCRIPT_PATH}/${dir}"
        for file in $(ls ${CUR_PATH})
        do
            LOG_FILE="${CUR_PATH}/rewrite_time.txt"
            rm -f ${LOG_FILE}
            touch ${LOG_FILE}
            filename="${file%.*}"
            IsSuffix ${file}
            ret=$?
            if [ $ret -eq 0 ] && [ ${filename} = "query" ]
            then
                $PYTHON_ENV main.py "${CUR_PATH}" "${DDL_NAME}" -b "$b" -m "$m" -g "$g" -y "$y" | grep "Rewrite time(s)" >> ${LOG_FILE}
            fi
        done
    fi
done