#!/usr/bin/env bash
set -o pipefail

basedir="$(cd "$(dirname "${BASH_SOURCE}")" >/dev/null; pwd)" || exit 1

function main() {
    local bintree="${basedir}/lib/bash-bin-tree.bash"
    pushd 'project/bin'
        echo '1111111111111111111111111111'
        "${bintree}" root
        echo '2222222222222222222222222222'
        "${bintree}" sub foo
    popd
}

main "$@"
