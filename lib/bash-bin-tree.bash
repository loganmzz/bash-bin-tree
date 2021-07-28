#!/usr/bin/env bash
set -o pipefail

basedir="$(cd "$(dirname "${BASH_SOURCE}")" >/dev/null; pwd)" || exit 1

function bashbintree.init() {
    local initfile=''
    while read -r -d ':' initfile || [[ -n "${initfile}" ]]; do
        [[ -z "${initfile}" ]] || . "${initfile}" || {
            echo "Error encountered while sourcing '${initfile}'" >&2
            return 1
        }
    done <<<"${BASHBINTREE_INITS}"
}

function bashbintree.bin.lookup() {
    local command="$1"; shift
    BASHBINTREE_COMMANDS="${BASHBINTREE_COMMANDS} ${command}"

    local initfile="${BASHBINTREE_DIR}/__init.shrc"
    if [[ -f "${initfile}" ]]; then
        BASHBINTREE_INITS="${BASHBINTREE_INITS}:${initfile}"
    fi

    local binfile="${BASHBINTREE_DIR}/${command}"
    if [[ -f "${binfile}" ]]; then
        BASHBINTREE_INITS="${BASHBINTREE_INITS}" "${binfile}" "$@"
        return $?
    elif [[ -d "${binfile}" ]]; then
        BASHBINTREE_DIR="${binfile}" BASHBINTREE_COMMANDS="${BASHBINTREE_COMMANDS}" BASHBINTREE_INITS="${BASHBINTREE_INITS}" bashbintree.bin.lookup "$@"
        return $?
    else
        echo "Unknown command: '${BASHBINTREE_COMMANDS}'"
        return 1
    fi
}

function main() {
    export -f bashbintree.init

    [[ $# != 0 ]] || {
        echo "!!! Help !!!"
        return 0
    }
    BASHBINTREE_DIR="$(pwd)" bashbintree.bin.lookup "$@"
}

main "$@"
