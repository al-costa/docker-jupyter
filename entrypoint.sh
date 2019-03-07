#!/bin/bash
#
#  Author: André Costa
#  Date: 2019-03-07
#
#  https://www.linkedin.com/in/a-l-costa
#

set -euo pipefail
[ -n "${DEBUG:-}" ] && set -x

srcdir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

if [ $# -gt 0 ]; then
    exec $@
else
    jupyter notebook
fi
