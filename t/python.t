#!/usr/bin/env bash

# Copyright © 2020 Jakub Wilk <jwilk@jwilk.net>
# SPDX-License-Identifier: MIT

set -e -u
pdir="${0%/*}/.."
prog="$pdir/chemiscripts"
echo 1..1
in='3(NH4)2S + Sb2S5 -> 6NH4+ + 2SbS4 3+'
xout='3(NH₄)₂S + Sb₂S₅ → 6NH₄⁺ + 2SbS₄³⁺'
out=$("$prog" "$in")
say() { printf "%s\n" "$@"; }
diff=$(diff -u <(say "$xout") <(say "$out")) || true
if [ -z "$diff" ]
then
    echo 'ok 1'
else
    sed -e 's/^/# /' <<< "$diff"
    echo 'not ok 1'
fi

# vim:ts=4 sts=4 sw=4 et ft=sh
