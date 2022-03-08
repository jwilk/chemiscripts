#!/usr/bin/env node

// Copyright © 2022 Jakub Wilk <jwilk@jwilk.net>
// SPDX-License-Identifier: MIT

'use strict';

const fs = require('fs');
const vm = require('vm');

const print = console.log;
const repr = JSON.stringify;

const here = __dirname;
const basedir = `${here}/..`;

const html_path = `${basedir}/index.html`;
const html = fs.readFileSync(html_path, 'UTF-8');
const code = html.match(/<script[^>]*>(.*)^var query =/sm)[1];
const mod = {};
vm.createContext(mod);
vm.runInContext(code, mod);

const data_path = `${here}/cases`;
const data = fs.readFileSync(data_path, 'UTF-8');
const paras = data.split(/\n{2,}/);
print(`1..${paras.length}`);
for (const para of paras) {
    const [src, dst] = para.split(/\n/);
    print('###', repr(src));
    const xdst = mod.translate(src);
    if (dst === xdst) {
        print('ok')
    } else {
        print('not ok')
        print('# expected:', repr(dst))
        print('#      got:', repr(xdst))
    }
}

// vim:ts=4 sts=4 sw=4 et ft=javascript
