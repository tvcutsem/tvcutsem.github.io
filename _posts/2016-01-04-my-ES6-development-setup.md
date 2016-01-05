---
title: My ES6 development setup
layout: post
tags: atom es6 node typescript
comments: true
---

I recently switched from TextMate to [Atom](https://atom.io), a lightweight cross-platform text editor and thought it would be useful to write down how to configure the editor and various related tools to be productive with ECMAScript 6.
It also shows how to set up tooling for TypeScript, a typed dialect of JavaScript, which aligns well with ECMAScript 6 and gives you optional static type checking and type inference. IMHO, if you're going to invest in new tooling for ECMAScript 6, going the extra mile to switch to TypeScript is worth it.

## Getting started
 
Install [Node.js](https://nodejs.org/en/) v5 or higher (which comes with many ES6 features [enabled by default](https://nodejs.org/en/docs/es6/)).
 
Install the [Atom](https://atom.io) text editor. Atom is a lightweight, easy-to-extend text editor with a [large repository of plug-ins](https://atom.io/packages).
 
Atom has basic editor support for JavaScript out of the box (such as syntax highlighting).
 
## Configure a JS linting tool
 
When you program in JavaScript, using a linter is a must. It will catch errors like undefined variables, unused variables, duplicate parameter names, forgotten semicolons, features of the language you would rather avoid, etc.
 
[JSHint](http://jshint.com/about/) is my favorite linting tool for JavaScript. Other good options include [JSLint](http://www.jslint.com/) and [ESLint](http://eslint.org/).
 
JSHint is highly configurable (look here for the [list of configurable options](http://jshint.com/docs/options/)). The easiest way to configure it is to set up a .jshintrc file in the root directory of your project. Here's a [good starting point](https://github.com/jshint/jshint/blob/master/examples/.jshintrc) for tweaking your .jshintrc file (comments in the config file are okay). To ensure JSHint doesn't choke on new ES6 features, set the option "esnext" to true (or in the next major release, set "esversion" to 6). I would also recommend to set the option "node" to true, so that JSHint understands your code will run in node.js and functions such as `require` will be available.
 
There is a [jshint atom package](https://atom.io/packages/atom-jshint) that will check your JavaScript files as you type, providing visible error highlighting like so:

<img alt="jshint-atom" width="80%" src="https://i.github-camo.com/ba07bf907da960531cd85f4d96175f178dd91f42/68747470733a2f2f636c6f75642e67697468756275736572636f6e74656e742e636f6d2f6173736574732f3137303237302f333833343236362f35346164366231632d316461662d313165342d396334362d3938653665346162616230372e706e67"></img>
 
To install the plug-in, in Atom, go to your Atom preferences > Packages > Install > search for "jshint".

# Enforcing strict mode

I always configure my JSHint file to require my JavaScript to be in ["strict mode"](https://developer.mozilla.org/en/docs/Web/JavaScript/Reference/Strict_mode). This is a safer subset of JavaScript with better-behaved scoping rules and less "silent errors" (e.g. operations that would silently fail without error will throw an error in strict mode). To enter strict mode, it suffices to add the literal string "use strict" as the first line in your JavaScript file (as shown on the screenshot above). In JSHint, I set the "strict" option to "global" (enforcing a single global "use strict" directive at the top of the file).
 
## Configure typescript (optional)
 
[TypeScript](http://www.typescriptlang.org/) is a typed dialect of JavaScript. It allows you to add optional static type annotations on functions and variables. In addition, it has a good type inferencer that will catch type errors even when your code is mostly unannotated. Finally, it implements most ES6 features and even [some ES7 features](http://blogs.msdn.com/b/typescript/archive/2015/11/03/what-about-async-await.aspx). For a good intro to TypeScript, see [this book](https://basarat.gitbooks.io/typescript/).
 
# Configure typescript plug-in for Atom

Good editor support for TypeScript usually requires a commercial IDE like Visual Studio or WebStorm.
Atom is one of the few open-source editors with very good TypeScript support, via the [atom-typescript](https://atom.io/packages/atom-typescript) package. Install this just like you installed jshint above.
 
<img alt="atom-typescript" src="https://i.github-camo.com/568d6fd0fee3556636a7270276982dcd6f6b2ade/68747470733a2f2f7261772e67697468756275736572636f6e74656e742e636f6d2f547970655374726f6e672f61746f6d2d747970657363726970742d6578616d706c65732f6d61737465722f73637265656e732f666173744572726f72436865636b696e67416e644175746f436f6d706c657465322e676966"></img>
 
# Configure typescript compiler

The atom-typescript package comes pre-bundled with a bleeding-edge TypeScript compiler. The compiler is [configured using a configuration file](https://github.com/Microsoft/TypeScript/wiki/tsconfig.json) called `tsconfig.json` which usually lives in the root of your project. An example file can be found [here](https://github.com/Microsoft/TypeScript/wiki/tsconfig.json#examples).
If you don't yet have a tsconfig file, the atom-typescript plug-in usually detects that the file does not exist and will offer to create it for you with default settings.
 
Two important properties in `tsconfig.json` to check are:

  1. set `target` to 'es6'. This will let the TypeScript compiler generate ECMAScript 6 code, which is almost line-for-line the same as TypeScript code. This will only work if you run the subsequent compiled code on a recent version of node. If you develop for the browser, leave this set to 'es5'. Keep in mind that some ES6 features are not yet enabled by default in node. So if you use them in your TypeScript, you must ensure to start node with the appropriate flags. For instance, I tend to use 'destructuring' a lot (allowing you to write things like `let [a, b] = f(x)`), which at the time of writing requires starting node with `node --harmony_destructuring`.
  2. set `module` to 'commonjs' so your TypeScript modules work just like node's modules and npm packages. If you develop for the browser, it's probably better to set it to 'amd' (for use with libraries like `require.js`).
 
# Configure typescript linter

Just like JSHint lints your JavaScript, you can use [TSLint](https://www.npmjs.com/package/tslint) to lint your TypeScript.
Install the [linter-tslint](https://atom.io/packages/linter-tslint) Atom package for built-in support.

Tslint reads its configuration from tslint.json. An example file can be found [here](https://github.com/palantir/tslint/blob/master/docs/sample.tslint.json). Details about the rules can be found [here](https://www.npmjs.com/package/tslint#supported-rules).

# Set up type definitions for external libraries

Chances are that your JavaScript project is making use of existing JavaScript APIs, either in node.js or from external libraries. Many libraries are not written in TypeScript. Fortunately, TypeScript allows you to describe the types of an untyped API separately in a type definition file (*.d.ts). [tsd](https://github.com/DefinitelyTyped/tsd) is a tool to install and manage such type definition files.
 
To install:
 
    npm install tsd -g
 
You will probably immediately want to install the type definitions for the node.js standard library. To do so:
 
    tsd install node --save
 
This will do two things:

  1. download the node.d.ts type definition file to a directory called `typings`.
  2. create a file `tsd.json` remembering what version of the type definition file was installed.
 
(note: the command is `tsd install <name> --save` and not `tsd install --save <name>`, the latter will fail silently)
 
Using the `tsd.json` file it becomes easier to re-install the type definition files later. `tsd.json` acts similar to `package.json` and the `typings` directory is similar to the `node_modules` directory.
 
Normally your atom-typescript package will pick up the type declarations in the `typings` directory automatically, and any errors about e.g. the type of the node.js `require` function should go away.
 
# Configure source maps

TypeScript code is compiled down to JavaScript code. When compiling to ES6, the source code and the compiled code will map almost one-to-one in many cases, but often the TypeScript compiler will insert some extra code. This causes the line numbers of the original code to diverge from the source code. This can become a problem when debugging: the stack traces and debugger will use JavaScript source lines, not TypeScript source lines.
 
Luckily there exists a translation format called "source maps" that allows JavaScript debuggers to work with external source code compiled down to JavaScript.
 
First, tell the TypeScript compiler to generate source maps. In your `tsconfig.json` file, add the following option:
 
    { "compilerOptions" : { ..., "sourceMap": true } }
 
Now, when you recompile a *.ts file (e.g. by editing and saving it), a *.js.map file will have been created as well.
 
When debugging code in the browser (e.g. using chrome developer tools), the presence of a source map file is enough for the debugger to use the correct line numbers.
In node.js, you need to install a little utility library called [source-map-support](https://www.npmjs.com/package/source-map-support) that will transform node.js stack traces so that source maps are taken into account:
 
    npm install --save-dev source-map-support
 
To enable this library, start node (or a test runner like `mocha`) with the following command-line flag:
 
    node --require source-map-support/register
 
Even better would be to edit your `package.json` to use a `start` script, so you can start your program using a simple `npm start`. Here is an excerpt from my `package.json` file:
 
    "scripts": {
      "start": "node --harmony_destructuring --require source-map-support/register index.js",
    },
 
Happy hacking.
