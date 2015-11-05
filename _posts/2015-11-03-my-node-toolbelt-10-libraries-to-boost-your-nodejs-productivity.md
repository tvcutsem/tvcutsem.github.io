---
title: "My node toolbelt: 10 libraries to boost your node.js productivity"
layout: post
tags: javascript node
excerpt_separator: <!--more-->
comments: true
---

This article surveys 10 libraries that I have found to be tremendously useful while developing
back-end node.js services. They mostly address _generic_ tasks that you will come across again and again: support for configuration, logging, processing command-line arguments, code coverage, asynchronous control flow, unit testing and more. While the focus is mostly on supporting back-end services, some of these libraries can equally well be used for front-end JavaScript development. I picked these 10 libraries based purely on personal experience and am documenting them in the hope they will prove useful to others.

The libraries are discussed in decreasing order of the number of Github stars they had at the time of writing this article, so more popular libraries are discussed first, and the lesser-known gems are discussed near the bottom. Don't let this ranking trick you into thinking that this is a "top 10" article: I'm not comparing these libraries against one another.

Enough intro, let's get started!

<!--more-->

  * [Q](#q)
  * [Request](#request)
  * [Mocha](#mocha)
  * [Commander](#commander)
  * [Istanbul](#istanbul)
  * [Node-measured](#node-measured)
  * [Bunyan](#bunyan)
  * [Node-config](#node-config)
  * [Longjohn](#longjohn)
  * [Memwatch-next](#memwatch-next)

## Q

_Simplifying asynchronous control flow using Promises_

Github stars: 10029

    npm install q

Using abstractions that simplify asynchronous control flow in node is a must. While callback hell [can be avoided](http://callbackhell.com/) with rigor and discipline, [Promises](https://blog.domenic.me/youre-missing-the-point-of-promises/) lead to a fluent, compositional style of programming. Compare standard callback-based control-flow:

```js
step1(function (err, value1) {
    if (err) { return handleError(err); }
    step2(value1, function(err, value2) {
        if (err) { return handleError(err); }
        step3(value2, function(err, value3) {
            if (err) { return handleError(err); }
            step4(value3, function(err, value4) {
                if (err) { return handleError(err); }
                // Do something with value4
            });
        });
    });
});
```

To promise-based control flow:

```js
// now step1 returns Promise rather than taking a callback
step1()
.then(step2)
.then(step3)
.then(step4)
.then(function (value4) {
    // Do something with value4
})
.catch(function (error) {
    // Handle any error from all above steps
})
.done();
```

As of ECMAScript 6, Promises are built-into the standard library. However, built-in Promises have quite a [limited API](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Promise). That's why I prefer to use one of the pre-existing Promise libraries, which provide the same behavior as built-in Promises, but with additional bells and whistles that come in handy in practice.

I prefer to use a library called [Q](https://github.com/kriskowal/q) because of its many utility methods (e.g. `done()` to signal the end of a Promise-chain and excellent support for async stack traces) and because it is compliant with ES6 Promises. Another good alternative would be [Bluebird](https://github.com/petkaantonov/bluebird).

To find out whether a Promise library is compliant with ES6 Promises, look for whether they implement the so-called ["Promises A+"](https://promisesaplus.com/) spec. ES6 Promises are based on that spec.

## Request

_Easily configure and send HTTP Request_

Github stars: 8676

    npm install request

[Request](https://github.com/request/request) is a library to make outgoing HTTP requests. It provides all possible bells and whistles you could wish for and is much more pleasant to use than node's built-in HTTP API. Here's how to call a JSON REST API endpoint:

```js
var request = require('request');

request({
    url: 'http://api.service.com/widget',
    method: 'GET',
    qs: {
      limit: 20 // query-encoded as ?limit=20
    },
    headers: {
      'X-SOME-HEADER': 'value'
    },
    json: true // parses response body as JSON
  }, function (error, response, body) {
  if (!error && response.statusCode == 200) {
    console.log(body)
  }
})
```

You can customize headers, query string, set form fields, and so on. Request also provides a nice `request.defaults()` method that can be used to set common parameters for many requests. For instance, if we are going to make a lot of calls to a particular host that all return JSON data, we may instead write:

```js
var request = require('request');

var callAPI = request.defaults({
  baseUrl: 'http://api.service.com',
  json: true
});

callAPI({
    url: '/widget',
    method: 'GET',
    qs: {
      limit: 20 // query-encoded as ?limit=20
    },
    headers: {
      'X-SOME-HEADER': 'value'
    },
  }, function (error, response, body) {
  if (!error && response.statusCode == 200) {
    console.log(body)
  }
})
```

There's also [request-promise](https://github.com/request/request-promise) which converts request's callback-based API to a promise-based API.

## Mocha

_Simple and flexible unit testing framework_

GitHub stars: 7659

    npm install mocha

[Mocha](https://mochajs.org/) is a simple, flexible unit testing framework for JavaScript. It provides a variety of ways to structure unit tests, but the basic idea is as follows: create a directory `test` and add your test code to that directory, e.g.:

```js
var assert = require('assert'); // built-in nodejs module

describe('Array', function() {
  describe('#indexOf()', function () {
    it('should return -1 when the value is not present', function () {
      assert.equal(-1, [1,2,3].indexOf(5));
      assert.equal(-1, [1,2,3].indexOf(0));
    });
  });
});
```

`describe` and `it` are methods used to group and label unit tests. Each test is a function that is considered passing if it finishes without throwing an exception. Executing `mocha` from the command-line will gather all unit tests under `/test` and call all tests (in sequence), presenting you with nice colored output of the result.

Two extremely useful but less well-known features of mocha are the ability to run only a single unit test and the ability to skip certain tests without having to comment out a single line of code. Often when I am debugging a failing unit test, I only want to re-run this single test to be able to focus on the problem at hand. Just call `describe.only` and Mocha will execute only this test (and all of its subtests), skipping all the other tests, e.g.:

```js
describe('Array', function() {
  describe.only('#indexOf()', function () {
    it('should return -1 when the value is not present', function () {
      assert.equal(-1, [1,2,3].indexOf(5));
      assert.equal(-1, [1,2,3].indexOf(0));
    });
  });
});
```

On the flip side, sometimes I have unit tests that I know are failing or broken. Rather than commenting out such tests, a better approach is to insert `describe.skip`, which lets Mocha skip the tests, but mark them as such in its test runner output, letting you know that some tests are in a pending state:

```js
describe('Array', function() {
  describe.skip('#indexOf()', function () {
    it('should return -1 when the value is not present', function () {
      assert.equal(-1, [1,2,3].indexOf(5));
      assert.equal(-1, [1,2,3].indexOf(0));
    });
  });
});
```

Mocha also works well with promises and asynchronous unit tests: one can simply return a promise from a test case and mocha will automatically wait for the promise to resolve before continuing with the next test.

Mocha is agnostic to the way you write assertions. You can use node's built-in `assert` module (as shown above), but I prefer using [Chai](http://chaijs.com/) which lets you write more fluent BDD-style unit tests, e.g.:


```js
var expect = require('chai').expect;

describe('Array', function() {
  describe('#indexOf()', function () {
    it('should return -1 when the value is not present', function () {
      expect([1,2,3].indexOf(5)).to.equal(-1);
      expect([1,2,3].indexOf(0)).to.equal(0);
    });
  });
});
```

There is also a plug-in for Chai named [chai-as-promised](http://chaijs.com/plugins/chai-as-promised) that lets it work fluently with promises, automatically postponing assertions until the promise is resolved:

```js
Promise.resolve(2 + 2).should.eventually.equal(4);
```

## Commander

_Easily implement rich command-line interfaces_

Github stars: 4401

    npm install commander

Often server-side programs take a variety of command-line arguments to be configured at start-up. [Commander](https://github.com/tj/commander.js) is a complete solution for writing node.js command-line interfaces, automating tasks such as parsing command-line arguments and taking care of generating the necessary 'help' or 'usage' documentation, so you don't have to.

Straight from the library's docs, here's how it works:

```js
var program = require('commander');

program
  .version('0.0.1')
  .option('-p, --peppers', 'Add peppers')
  .option('-P, --pineapple', 'Add pineapple')
  .option('-b, --bbq-sauce', 'Add bbq sauce')
  .option('-c, --cheese [type]', 'Add the specified type of cheese [marble]', 'marble')
  .parse(process.argv);

console.log('you ordered a pizza with:');
if (program.peppers) console.log('  - peppers');
if (program.pineapple) console.log('  - pineapple');
if (program.bbqSauce) console.log('  - bbq');
console.log('  - %s cheese', program.cheese);
```

As you can see, commander supports both short (e.g. `-p`) and long (e.g. `--peppers`) command-line flags. If a flag takes an argument (e.g. `--cheese`), this is indicated using square brackets, with the ability to provide a default value (e.g. `marble`).

Based on this declarative information, Commander can also generate help information, which one can invoke by passing the `--help` flag.

```
$ ./examples/pizza --help

 Usage: pizza [options]

 Options:
 
     -h, --help           output usage information
     -V, --version        output the version number
     -p, --peppers        Add peppers
     -P, --pineapple      Add pineapple
     -b, --bbq            Add bbq sauce
     -c, --cheese <type>  Add the specified type of cheese [marble]
```

If all of this wasn't enough, commander also allows you to easily specify [Git-style subcommands](https://www.npmjs.com/package/commander#git-style-sub-commands), which lets you write applications that can perform a wide variety of tasks with just one executable.

## Istanbul

_A JavaScript code coverage tool_

Github stars: 3267

    npm install istanbul

Unit testing is essential to obtain confidence in your JavaScript code. But unit tests alone are not enough: you need to know what parts of your code are covered by your unit tests, and what parts are not. [Istanbul](https://gotwarlost.github.io/istanbul/) is a code coverage tool for JavaScript. You can use it to verify precisely what lines of code got executed by a unit test suite, for example. Istanbul can generate nice HTML reports with non-executed lines colored in red, allowing you to easily spot parts of your code in need for testing.

<img src="http://onsen.io/blog/content/images/2015/Aug/es5-coverage.png" alt="Istanbul HTML Report" width="640px"/>

Istanbul by default assumes that you provide it with a node.js program as input, it runs the program, and then generates a report when the program terminates. This works well for traditional batch processing applications, but not very well for instrumenting HTTP servers that remain up all the time. If you want to test coverage of, say, an Express app, you can use [istanbul-middleware](https://github.com/gotwarlost/istanbul-middleware) to instrument your server-side code. It will also extend your Express app with a `/coverage` endpoint that serves up the current coverage statistics.

You usually do not want to enable code coverage on an HTTP server by default, because the instrumented code will run a lot slower. I use a setup where I have a normal 'main' file to configure my express app, and an alternative 'main' file that enables code coverage before loading the normal 'main' file. Like this, when I fire up the server in 'coverage' mode, I can write unit tests that hit the server with various requests, and then browse to `/coverage` to check the code coverage of my unit tests on-the-fly. If I notice some code is not triggered, I can add a new unit test to my test suite, rerun the test suite, and simply refresh the `/coverage` page to see the updated code coverage, without restarting the server. I have found this to be an excellent workflow to quickly increase my code coverage.

## Bunyan

_Versatile and structured logging tool_

Github stars: 2293

    npm install bunyan

[Bunyan](https://github.com/trentm/node-bunyan) is a logging library for node (kind of like Log4J for Java, but more lightweight and with some interesting twists). Bunyan lets you create log streams, with support for well-known log levels such as DEBUG, INFO, WARN and ERROR. Bunyan loggers can be configured to write to standard output, file, or custom outputs. For instance, one could define a log stream that logs all messages with log level DEBUG or higher to standard output, and in addition, all messages with log level ERROR or higher to a file:

```js
var log = bunyan.createLogger({
  name: 'myAppLog',
  streams: [
    { level: 'debug',
      stream: process.stdout },
    { level: 'error',
      path: 'logs/myApp_errors.log' }
  ]
});
```

Log messages are formatted using node's `util.format` by default. Here's how to log an INFO message:

```js
log.info("request size: %s bytes, latency: %s seconds", size, time);
```

`bunyan` logs are actually made up of newline-terminated JSON records. Hence, they are _structured_ logs that are very easy to parse and filter. For instance, the following log line:

```js
log.error(err, "error serving request");
```

will generate the following log record:

```
{"name":"myAppLog","hostname":"mymachine.local","pid":39102,"level":50,"err":{"message":"socket hang up","name":"Error","stack":"Error: socket hang up\n    at [...]","code":"ECONNRESET"},"msg":"error serving request request","time":"2015-09-30T13:10:17.803Z","v":0}
```

This is hardly readable, but `bunyan` comes with a command-line tool that allows you to format bunyan log files in a human-readable way. As a bonus, the `bunyan` tool can be used to quickly filter the log. You can easily filter on log level, but it is possible to filter based on arbitrary log data. I typically start my node services as follows:

```js
node myapp.js | ./node_modules/bunyan/bin/bunyan -o short
```

which turns the above raw log record in:

```
13:10:17.803Z ERROR myAppLog: error serving request (err.code=ECONNRESET)
    Error: socket hang up
        at createHangUpError (_http_client.js:215:15)
        at Socket.socketOnEnd (_http_client.js:300:23)
        ...
```

Bunyan offers colorized output to quickly identify certain log levels and allows you to include your own JSON-formatted properties in the log data, and knows how to properly render common node.js objects such as `Error` instances. Here's what this would look like in a shell:

![bunyan](https://camo.githubusercontent.com/3c66ffa5055a798569c1f0637963c990160eb9a4/68747470733a2f2f7261772e6769746875622e636f6d2f7472656e746d2f6e6f64652d62756e79616e2f6d61737465722f746f6f6c732f73637265656e73686f74312e706e67 "Bunyan logger output")

## Node-config

_Configuration management made easy_

Github stars: 1015

    npm install node-config

[Node-config](https://github.com/lorenwest/node-config) is a library to manage configuration files. You basically create a folder in your root project folder named `config` and then write up your configuration data as a JSON config file named `default.json` saved under that directory (node-config supports a variety of other formats as well, and importantly, tolerates comments in your JSON config file).

```
$ mkdir config
$ vi config/default.json

{
  // database configuration goes here
  "dbConfig": {
    "host": "localhost",
    "port": 5984,
    "dbName": "customers"
  }
}
```

Config then allows you to easily access that data:

```js
var config = require('config');
var dbhost = config.get('dbConfig.host');
...
```

So far, this is nothing special, you could as easily just `require` the JSON file. Where node-config adds value is in its support for managing multiple configuration files (e.g. for a development vs a production environment) and in its support for inheritance among configuration files. node-config will select the most appropriate configuration file to load based on certain environment variables (such as `$HOSTNAME` and `$NODE_ENV`). This allows you to seamlessly toggle between, say, development and production configurations.

In addition, node-config has the ability to load more than one configuration file. It will try to load the most specific configuration file for a given environment, and then include values from more general environments, ending with `default.json` at the root. This implies that more specific environments only need to specify the delta w.r.t. the default environment, avoiding the need to duplicate configuration settings.

If you find yourself copying too much configuration information around, or adjusting lots of flags to switch between development and production environments, you should consider using node-config.

## LongJohn

_Avoid debugging asynchronous code without a call stack_

Github stars: 416

    npm install longjohn

A problem when writing asynchronous code is that the call stack is usually very "shallow": it only goes back to the origin of the current event on the event loop, but doesn't show you _where_ that event originated. [Longjohn](https://github.com/mattinsler/longjohn) is a simple little node.js plug-in that makes debugging errors in asynchronous programs more pleasant, by stitching together stack traces across multiple events of the event loop.

If you've done some node.js programming, you have probably come across quite unhelpful errors such as:

```
Error: connect ECONNREFUSED
    at exports._errnoException (util.js:746:11)
    at TCPConnectWrap.afterConnect [as oncomplete] (net.js:1010:19)
```

This tells us that some outgoing TCP connection failed, but we have no clue how to link it back to some place in our code. Enabling longjohn turns the stack trace into:

```
Error: connect ECONNREFUSED
    at exports._errnoException (util.js:746:11)
    at TCPConnectWrap.afterConnect [as oncomplete] (net.js:1010:19)
---------------------------------------------
    at [object Object].Connection.connect (/MyProject/[...]/connection.js:370:19)
```

Now we have a better clue as to where the TCP call was made, and we can debug the problem more quickly.

A word of warning: you should only enable longjohn in development environments, not in production environments. The reason is that capturing these long stack traces introduces quite some overhead (essentially the full stack trace must be saved frequently, even when no errors occur, in order to be able to reconstruct the full stack trace when an error does occur).

If you are using promises, libraries such as [Q](https://github.com/kriskowal/q) offer [similar functionality](https://github.com/kriskowal/q/wiki/API-Reference#qlongstacksupport) to enhance stack traces when promises are rejected with an exception.

## Node-measured

_Measure your code paths_

Github stars: 281

    npm install measured

[Node-measured](https://github.com/felixge/node-measured) is a port of Coda Hale's better-known [metrics](https://github.com/dropwizard/metrics) library for Java. node-measured offers a very small API to define, essentially, performance counters. They allow you to easily keep track of how many times a particular request was fired, how many times you hit your database or your cache, how many times a page was rendered, and so on. For instance:

```js
var Measured = require('measured')
var meter = new Measured.Meter();

app.get('/customers', function(req, res) {
    meter.mark(); // count GET /customer requests per second
    ...
});
```

While counting events is nice, this isn't something you would really need a library for. The benefit of using node-measured is that is can also compute throughput and latency statistics. For instance, if you call `meter.toJSON()` after hitting the server with requests, you will get:

```js
{ mean: 1710.2180279856818,
  count: 10511,
  'currentRate': 1941.4893498239829,
  '1MinuteRate': 168.08263156623656,
  '5MinuteRate': 34.74630977619571,
  '15MinuteRate': 11.646507524106095 }
```

You can also measure how long it took to process the request, and then submit that measurement to a `Histogram`. The `Histogram` object can then calculate various latency percentiles, biased towards the last 5 minutes. Calculating correct latency percentiles over a sliding window can be tricky, and this is something I'd rather delegate to a library such as node-measured.

Coda Hale gave a great [talk](http://codahale.com/codeconf-2011-04-09-metrics-metrics-everywhere.pdf) at CodeConf on why it is a good idea to add pervasive metrics to your code. For bonus points, you can instrument your node.js process to report these metrics automatically to a metrics visualizer such as [Riemann](http://riemann.io/) or [Graphite](http://graphite.wikidot.com/).

## Memwatch-next

_Keep a watch on your service's memory use_

Github stars: 101

    npm install memwatch-next

[Memwatch-next](https://github.com/marcominetti/node-memwatch) is a simple native extension for node.js that gives you the ability to register a callback on various memory-related events, such as when a garbage-collect occurred. It also emits a `leak` event if it detects that memory usage keeps on growing even after several subsequent garbage collections. This is usually (but not necessarily always) the sign of a memory leak. 

Memwatch-next can also let you calculate heap diffs, but I don't tend to use memwatch-next to get to the bottom of a memory leak. Instead, I use memwatch-next to simply monitor my service's memory usage. If memwatch-next emits a leak event, that draws my attention to a potential issue, which I can then investigate further using e.g. the Chrome developer tools.

Here's a typical way in which I used the library, simply logging some useful statistics to draw my attention to potential memory-related performance problems:

```js
var memwatch = require('memwatch-next');

memwatch.on('leak', function(info) {
    log.warn('potential memleak: %s', info.reason);
});
memwatch.on('stats', function(stats) {
    log.info('heap size after full GC: %s MB', (stats.current_base / 1000 / 1000));
});
```

## Summary

If you made it this far, I hope you've found some useful little libraries that you may not yet have come across yourself. The goal of this article was not to list all possible useful node libraries (impossible given the size of the npm ecosystem) nor was it the goal to list my "top 10 favorite libraries". These are just libraries that I see myself reusing in various projects time and again because they solve specific yet general-purpose tasks well.

If you have experiences in using these libraries (both positive and negative) I would love to hear your feedback. Also, if you know of better alternatives to solve the tasks addressed by these libraries, I'm very happy to hear your thoughts as well.
