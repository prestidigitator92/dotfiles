#!/bin/bash

RED=`echo -e '\033[31m'`
GREEN=`echo -e '\033[32m'`
MAGENTA=`echo -e '\033[35m'`
BLUE=`echo -e '\033[34m'`
YELLOW=`echo -e '\033[33m'`
CYAN=`echo -e '\033[36m'`
UNDERLINE=`echo -e '\033[4m'`
NORMAL=`echo -e '\033[0m'`
CWD=`pwd`

tee \
    | sed '1{/^$/d}' \
    | sed '/^Time: [0-9]\+ ms, Memory: /,+1d' \
    | sed "/^PHPUnit /,+1d" \
    | sed "/^Configuration read from /,+1d" \
    | sed "/^There were [0-9]\+ errors:/,+1d" \
    | sed "/^There was 1 error:/,+1d" \
    | sed -r "s/\x1B\[([0-9]{1,2}(;[0-9]{1,2})?)?[m|K]//g" \
    | sed -e "s#$CWD#.#g" \
    | sed -e "s#\./src\(/[A-Za-z.-]\+\)\+#${UNDERLINE}&${NORMAL}#g" \
    | sed -e "s#\(::\|->\)\(\$\?\w\+\(()\)\?\)#\1${BLUE}\2${NORMAL}#g" \
    | sed -e "s#\(on line \|:\)\([0-9]\+\)#\1${YELLOW}\2${NORMAL}#g" \
    | sed -e "s#^Catchable fatal error: #${RED}&${NORMAL}#" \
    | sed -e "s#^Call Stack:#${RED}&${NORMAL}#" \
    | sed -e "s#^Fatal error: #${RED}&${NORMAL}#" \
    | sed -e "s#^Notice: #${RED}&${NORMAL}#" \
    | sed -e "s#^BadMethodCallException: #${RED}&${NORMAL}#" \
    | sed -e "s#^FAILURES!#${RED}&${NORMAL}#" \
    | sed -e "s/^OK (.*$/${GREEN}&${NORMAL}/" \
    | sed -e "s#\([A-Za-z.]\+[\\]\)\+[A-Za-z.]\+#${GREEN}&${NORMAL}#g" \
    | sed -e "s/\(instance of \)\([^ ]\+\)\( given,\)/\1${GREEN}\2${NORMAL}\3/g" \
    | sed -e "s/^[0-9. ]\{21\}//g"

