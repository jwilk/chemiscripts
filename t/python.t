#!/usr/bin/env python3

# Copyright © 2022 Jakub Wilk <jwilk@jwilk.net>
# SPDX-License-Identifier: MIT

import os
import re
import shlex
import subprocess
import sys

here = os.path.dirname(__file__)

def main():
    data_path = here + '/cases'
    with open(data_path, 'rt', encoding='UTF-8') as file:
        data = file.read()
    data = re.split(r'\n{2,}', data)
    print('1', '..', 3 * len(data), sep='')
    exe_path = here + '/../chemiscripts'
    for para in data:
        [src, dst] = para.splitlines()
        print('#', shlex.quote(src))
        proc = subprocess.Popen(
            [exe_path, src],
            stdout=subprocess.PIPE,
            stderr=subprocess.PIPE,
        )
        (stdout, stderr) = proc.communicate()
        if proc.returncode == 0:
            print('ok - exit status')
        else:
            print('not ok - exit status')
            print('# exit status', proc.returncode)
        if not stderr:
            print('ok - stderr')
        else:
            print('not ok - stderr')
            print('# stderr not empty:')
            stderr = stderr.decode('ASCII', 'replace').splitlines()
            for line in stderr:
                print('# |', line)
        stdout = stdout.decode(sys.stdout.encoding, errors=sys.stdout.errors)
        xstdout = dst + '\n'
        if stdout == xstdout:
            print('ok - stdout')
        else:
            print('not ok - stdout')
            print('# expected:', repr(xstdout))
            print('#      got:', repr(stdout))

if __name__ == '__main__':
    main()

# vim:ts=4 sts=4 sw=4 et ft=python
