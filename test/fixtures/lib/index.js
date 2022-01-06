'use strict';

require('./');
require('./index');

require('./index/');
require('./index/index');
require('./index/index.js');

require('./dir-no-index/');
require('./dir-no-index/test');
require('./dir-no-index/test.js');

require('./js');
require('./js.js');
require('./jsx');
require('./jsx.jsx');
require('./ts');
require('./ts.ts');
require('./tsx');
require('./tsx.tsx');

require('./css.css');
require('./less.less');
require('./sass.sass');
require('./scss.scss');
require('./styl.styl');

require('deps-js'); // ../node_modules/deps-js, without "main" in package.json, exists file "index.js"
require('deps-js-main'); // ../node_modules/deps-js-main, with `"main": "main"` in package.json, exists file "main.js"
require('deps-js-main-js'); // ../node_modules/deps-js-main-js, with `"main": "main.js"` in package.json, exists file "main.js"

import moduleA from 'deps-es-module'; // ../node_modules/deps-es-module, with `"module": "es/module"` in package.json, exists file "es/module.js"
import moduleB from 'deps-es-module-js'; // ../node_modules/deps-es-module-js, with `"module": "es/module.js"` in package.json, exists file "es/module.js"

import moduleC from 'deps-es-module-main'; // ../node_modules/deps-es-module-main, with `"module": "es/module"` and `"main": "lib/main"` in package.json, exists file "es/module.js" and "lib/main.js"
import moduleD from 'deps-es-module-main-js'; // ../node_modules/deps-es-module-main, with `"module": "es/module.js"` and `"main": "lib/main.js"` in package.json, exists file "es/module.js" and "lib/main.js"

require('deps-js-browser'); // ../node_modules/deps-js-browser, with `"browser": "browser"` in package.json, exists file "browser.js"
require('deps-js-browser-js'); // ../node_modules/deps-js-browser-js, with `"browser": "browser.js"` in package.json, exists file "browser.js"

require('deps-jsx'); // ../node_modules/deps-jsx, without "main" in package.json, exists file "main.jsx"
require('deps-jsx-main'); // ../node_modules/deps-jsx-main, with "main": "main" in package.json, exists file "main.jsx"
require('deps-jsx-main-jsx'); // ../node_modules/deps-jsx-main-jsx, with "main": "main.jsx" in package.json, exists file "main.jsx"

require('deps-ts'); // ../node_modules/deps-ts, without "main" in package.json, exists file "index.ts"
require('deps-ts-main'); // ../node_modules/deps-ts-main, with "main": "main" in package.json, exists file "main.ts"
require('deps-ts-main-ts'); // ../node_modules/deps-ts-main-ts, with "main": "main.jsx" in package.json, and exists main.jsx file

require('deps-tsx'); // ../node_modules/deps-tsx, without "main" in package.json, exists file "index.tsx"
require('deps-tsx-main'); // ../node_modules/deps-tsx-main, with "main": "main" in package.json, exists file "main.tsx"
require('deps-tsx-main-tsx'); // ../node_modules/deps-tsx-main-tsx, with "main": "main.tsx" in package.json, exists file "main.tsx"

require('deps-vue');
require('deps-vue-main');
require('deps-vue-main-vue');

require('deps-json');
require('deps-json-main');
require('deps-json-main-json');

require('../components/AwesomeComponent');
require('../components/AwesomeComponent.jsx');
require('components/AwesomeComponent.jsx');
