---
title: "Harmony Proxies: Tutorial"
layout: post
tags:
  - ecmascript harmony
  - javascript
  - proxies
permalink: proxies_tutorial
excerpt_separator: <!--more-->
comments: true
---
**Update (July 2015): Proxies are now officially part of the recently released [ECMAScript 2015](http://www.ecma-international.org/ecma-262/6.0/) specification. This tutorial is still relevant, but dated. For up-to-date documentation, see e.g. [Mozilla's MDN page on proxies.](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Proxy)**

The Proxy API enables the creation of dynamic proxies in Javascript. Dynamic proxies are useful for writing generic object or function wrappers or for creating virtual object abstractions. To avoid any confusion: these proxies have nothing to do with web proxy servers.

Perhaps the most compelling use of proxies is the ability to create objects whose properties can be computed dynamically. Proxies encompass all use cases that one would use the SpiderMonkey hook <tt>__noSuchMethod__</tt> for (such as creating mock objects in testing frameworks, Rails ActiveRecord [dynamic finder](http://blog.hasmanythrough.com/2006/8/13/how-dynamic-finders-work)-like capabilities, etc.) but generalize to operations other than method invocation.

<!--more-->

### What platforms support Proxies?

The Proxy API will be part of ECMAScript 6\. To see whether proxies are supported in your browser, check for the presence of a global object named <tt>Proxy</tt>. At the time of writing (August 2012), Firefox, Chrome and node.js support an [older version](http://soft.vub.ac.be/~tvcutsem/invokedynamic/esharmony_reflect) of the API (for which you can find an older version of this tutorial [here](http://soft.vub.ac.be/~tvcutsem/proxies/) and MDN docs [here](https://developer.mozilla.org/en/JavaScript/Reference/Global_Objects/Proxy)). In Chrome, proxies are hidden behind an "experimental Javascript" flag that can be set by visiting [chrome://flags](chrome://flags). In node.js, use the <tt>node --harmony</tt> flag.

Proxies underwent several revisions as they were being prototyped by browser engine implementors. This tutorial discusses the newer, so-called "Direct Proxies" API. At the time of writing (August 2012), no built-in support for this version of the API yet exists in browsers. However, there exists a [shim](https://github.com/tvcutsem/harmony-reflect) that implements the new API on top of the old API. After loading this [reflect.js](https://github.com/tvcutsem/harmony-reflect/blob/master/reflect.js) script, you should be able to run the examples on this page.

### Hello, Proxy!

The following piece of code creates a proxy that intercepts property access and returns for each property <tt>"prop"</tt>, the value <tt>"Hello, prop"</tt>:

{% highlight javascript %}
var p = Proxy({}, {
  get: function(target, name) {
    return 'Hello, '+ name;
  }
});

document.write(p.World); // should print 'Hello, World'
{% endhighlight %}

[Try it in your browser](/assets/proxy_examples/helloproxy.html).

The call <tt>Proxy(target, handler)</tt> returns a new proxy object that wraps an existing target object. All property accesses performed on this proxy will be interpreted by calling the <tt>handler.get</tt> method. That is, the code <tt>p.foo</tt> is interpreted by the VM as if executing the code <tt>handler.get(target,"foo")</tt> instead, where <tt>p = Proxy(target, handler)</tt>.

Property access is not the only operation that can be intercepted by proxies. The following table lists the most important operations that can be performed on a proxy:

<table align="center" style="font-family: Courier, monospace; font-size: 0.8em; padding: 2px;">

<tbody>

<tr style="font-family: Verdana;">

<th>Operation</th>

<th>Intercepted as</th>

</tr>

<tr>

<td>proxy[name]</td>

<td>handler.get(target, name)</td>

</tr>

<tr>

<td>proxy[name] = val</td>

<td>handler.set(target, name, val)</td>

</tr>

<tr>

<td>name in proxy</td>

<td>handler.has(target, name)</td>

</tr>

<tr>

<td>delete proxy[name]</td>

<td>handler.deleteProperty(target, name)</td>

</tr>

<tr>

<td>for (var name in proxy) {...}</td>

<td>handler.enumerate(target).forEach(function (name){...})</td>

</tr>

<tr>

<td>Object.keys(proxy)</td>

<td>handler.keys(target)</td>

</tr>

</tbody>

</table>

Methods on the handler object such as <tt>get</tt>, <tt>set</tt> etc. are called _traps_.

The full proxy handler API additionally traps calls to newer ECMAScript 5 built-in methods such as <tt>Object.keys</tt> and <tt>Object.getOwnPropertyDescriptor</tt>. Fortunately it is not always necessary to implement the full API to build useful proxies, as demonstrated in the following sections.

### A simple profiler

Let's construct a simple kind of generic wrapper: a profiler that counts the number of times each of its properties was accessed:

{% highlight javascript %}
function makeSimpleProfiler(target) {
  var count = Object.create(null);
  return {
    proxy: Proxy(target, {
      get: function(target, name) {
        count[name] = (count[name] || 0) + 1;
        return Reflect.get(target, name);
      }
    }),
    get stats() { return count; }
  };
}
{% endhighlight %}

The function <tt>makeSimpleProfiler</tt> takes as its sole argument the object we want to monitor. It returns a tuple <tt>t</tt> such that <tt>t.proxy</tt> refers to the wrapper that will record profiling data, and <tt>t.stats</tt> can be used to retrieve the profiling information recorded thus far. We can use this abstraction as follows:

{% highlight javascript %}
var subject = { foo: 42, bar: 24 };
var profiler = makeSimpleProfiler(subject);
runApp(profiler.proxy);
plotHistogram(profiler.stats);
{% endhighlight %}

[Try it in your browser](/assets/proxy_examples/profiler.html).

Note that the proxy handler only implements a single trap, the <tt>get</tt> trap. What happens if we apply operations on the proxy object for which no corresponding trap was defined, such as <tt>"foo" in profiler.proxy</tt>? In such cases, the proxy will simply automatically _forward_ the operation to the target object, unmodified. The result would be the same as if we had written <tt>"foo" in subject</tt>.

There is also a way for proxy traps to _explicitly_ forward an operation to the target object. The function <tt>Reflect.get</tt> on line 7 of <tt>makeSimpleProfiler</tt> allows the proxy to forward the operation that it intercepted (in this case, a <tt>get</tt> operation) to the target object. In this particular case, <tt>Reflect.get(target, name)</tt> is more or less equivalent to <tt>target[name]</tt>. There exist similar such <tt>Reflect</tt> forwarding functions for all available traps. For instance, <tt>Reflect.has(target, name)</tt> can be used to forward an intercepted <tt>has</tt> operation, and returns whether or not the target object has the <tt>name</tt> property.

The <tt>Reflect</tt> global object is made available by the <tt>reflect.js</tt> shim. In ECMAScript 6, the <tt>Reflect</tt> object will probably become a proper module.

### Emulating noSuchMethod

Using the Proxy API, it's fairly straightforward to emulate the functionality of SpiderMonkey/Rhino's <tt>__noSuchMethod__</tt> hook in a browser that does not support it natively (e.g. Chrome/v8). All that is required is that the object eventually delegate to a special proxy object that will trap missing invocations:

{% highlight javascript %}
function MyObject() {};
MyObject.prototype = Object.create(NoSuchMethodTrap);
MyObject.prototype.__noSuchMethod__ = function(methodName, args) {
  return 'Hello, '+ methodName;
};

new MyObject().foo() // returns 'Hello, foo'
{% endhighlight %}

Below is the code for the <tt>NoSuchMethodTrap</tt> root object. The <tt>get</tt> handler method short-circuits invocations of <tt>__noSuchMethod__</tt>. If it wouldn't do this, a missing method invocation on an object that didn't implement <tt>__noSuchMethod__</tt> would recursively trigger the hook, leading to an infinite recursion.

{% highlight javascript %}
var NoSuchMethodTrap = Proxy({}, {
  get: function(target, name) {
    if (name === '__noSuchMethod__') {
      throw new Error("receiver does not implement __noSuchMethod__ hook");
    } else {
      return function() {
        var args = Array.prototype.slice.call(arguments);
        return this.__noSuchMethod__(name, args);
      }
    }
  }
});
{% endhighlight %}

[Try it in your browser](/assets/proxy_examples/noSuchMethod.html).

Contrary to the previous example (the profiler), this example illustrates that it's not always necessary for proxies to make good use of their "target" object. In this example, the special "no such method" proxy just uses an empty object as the target, and ignores the <tt>target</tt> parameter of the <tt>get</tt> trap.

### Remote objects

Proxies allow you to create virtual objects that represent remote or persisted objects. To demonstrate this, let's write a wrapper around an existing library for remote object communication in Javascript. Tyler Close's [web_send](http://waterken.sourceforge.net/web_send) library can be used to construct remote references to server-side objects. One can then "invoke" methods on this remote reference via HTTP POST requests. Unfortunately, remote references cannot be used as objects themselves. That is, to send a message to a remote reference <tt>ref</tt>, one writes:

{% highlight javascript %}
Q.post(ref, 'foo', [a,b,c]);
{% endhighlight %}

It would be a lot more natural if one could instead treat <tt>ref</tt> as if it were an object, such that one could call its methods as <tt>ref.foo(a,b,c)</tt>. Using the Proxy API, we can write a wrapper for remote web_send objects to translate property access into <tt>Q.post</tt> calls:

{% highlight javascript %}
function Obj(ref) {
  return Proxy({}, {
    get: function(target, name) {
      return function() {
        var args = Array.prototype.slice.call(arguments);
        return Q.post(ref, name, args);
      };
    }
  });
}
{% endhighlight %}

Now one can use the <tt>Obj</tt> function to write <tt>Obj(ref).foo(a,b,c)</tt>.

### Higher-order Messages

A higher-order message is a message that takes another message as its argument, as explained in [this paper](http://www.metaobject.com/papers/Higher_Order_Messaging_OOPSLA_2005.pdf). Higher-order messages are similar to higher-order functions, but are sometimes more succinct to write. Using the Proxy API, it's straightforward to build higher-order messages. Consider a special object named <tt>_</tt> that turns messages into functions:

{% highlight javascript %}
var msg = _.foo(1,2)
msg.selector; // "foo"
msg.args; // [1,2]
msg(x); // x.foo(1,2)
{% endhighlight %}

Note that <tt>msg</tt> is a function of one argument, as if defined as <tt>function(r) { return r.foo(1,2); }</tt>. The following example is a direct translation from the aforementioned paper and shows how higher-order messages lead to shorter code:

{% highlight javascript %}
var words = "higher order messages are fun and short".split(" ");
String.prototype.longerThan = function(i) { return this.length > i; };
// use HOM to filter and map based on messages rather than functions
document.write(words.filter(_.longerThan(4)).map(_.toUpperCase()));
// without HOM, this would be:
// words.filter(function (s) { return s.longerThan(4) })
//       .map(function (s) { return s.toUpperCase() })
{% endhighlight %}

Finally, here is the code for the <tt>_</tt> object:

{% highlight javascript %}
// turns messages into functions
var _ = Proxy({}, {
  get: function(target, name) {
    return function() {
      var args = Array.prototype.slice.call(arguments);
      var f = function(rcvr) {
        return rcvr[name].apply(rcvr, args);
      };
      f.selector = name;
      f.args = args;
      return f;
    }
  }
});
{% endhighlight %}

[Try it in your browser](/assets/proxy_examples/hom.html).

### Emulating host objects

Proxies give Javascript programmers the ability to emulate much of the weirdness of host objects, such as the DOM. For instance, using proxies it is possible to emulate "live" nodelists. Thus, proxies are a useful building block for self-hosted Javascript DOM implementations, such as [dom.js](https://github.com/andreasgal/dom.js).

### Function Proxies

It's also possible to create proxies for function objects. In Javascript, functions are really objects with two extra capabilities: they can be called (as in <tt>f(1,2,3)</tt>), and constructed (as in <tt>new f(1,2,3)</tt>). To intercept those operations, all you need to do is define the following two additional traps:

<table align="center" style="font-family: Courier, monospace; font-size: 0.8em; padding: 2px;">

<tbody>

<tr style="font-family: Verdana;">

<th>Operation</th>

<th>Intercepted as</th>

</tr>

<tr>

<td>proxy(a,b,c)</td>

<td>handler.apply(target, undefined, [a,b,c])</td>

</tr>

<tr>

<td>new proxy(a,b,c)</td>

<td>handler.construct(target, [a,b,c])</td>

</tr>

</tbody>

</table>

The second argument to the <tt>apply</tt> trap is actually the "this"-binding of the function. When a proxy is called like a normal, stand-alone function, this parameter will be set to <tt>undefined</tt> (not to the global object!). When a proxy for a function is called as a method, as in <tt>obj.proxy(a,b,c)</tt>, then this second argument will be set to <tt>obj</tt>. Here is a simple example of function proxies in action:

{% highlight javascript %}
var handler = {
  get: function(target, name) {
    // can intercept access to the 'prototype' of the function
    if (name === 'prototype') return Object.prototype;
    return 'Hello, '+ name;
  },
  apply: function(target, thisBinding, args) { return args[0]; },
  construct: function(target, args) { return args[1]; }
};
var fproxy = Proxy(function(x,y) { return x+y; },  handler);

fproxy(1,2); // 1
new fproxy(1,2); // 2
fproxy.prototype; // Object.prototype
fproxy.foo; // 'Hello, foo'
{% endhighlight %}

[Try it in your browser](/assets/proxy_examples/hellofproxy.html).

Note that, because function calling and function construction are trapped by different traps, you can use function proxies to reliably detect whether or not your function was called using the <tt>new</tt> keyword.

Function proxies also enable some other idioms that were previously hard to accomplish in pure JS. Thanks to Dave Herman for pointing these out:

First, function proxies make it simple to wrap any non-callable target object as a callable object:

{% highlight javascript %}
function makeCallable(target, call) {
  return Proxy(target, {
    apply: function(target, thisBinding, args) {
      return call.apply(thisBinding, args);
    }
  });
}
{% endhighlight %}

Second, function proxies also make it simple to create pseudo-classes whose instances are callable:

{% highlight javascript %}
function Thing() {
  /* initialize state, etc */
  return makeCallable(this, function() {
    /* actions to perform when instance
       is called like a function */
  });
}
{% endhighlight %}

### Experimenting with new semantics

For the language buffs: Proxies can be used to create an implementation of 'standard' Javascript objects and functions in Javascript itself. Once the semantics of Javascript objects is written down in Javascript itself, it becomes easy to make small changes to the language semantics, and to experiment with those changes. For instance, I prototyped a proposed feature [for observing objects](http://wiki.ecmascript.org/doku.php?id=strawman:observe) in Javascript itself, [using proxies](https://github.com/tvcutsem/harmony-reflect/blob/master/examples/observer.js). As another example, David Bruant implemented [Javascript Arrays](https://github.com/DavidBruant/ProxyArray) in Javascript itself using Proxies. Bob Nystrom illustrates how Proxies could be used to augment Javascript objects with [multiple inheritance](http://journal.stuffwithstuff.com/2011/02/21/multiple-inheritance-in-javascript/).

### Proxy Tips

#### Avoiding runaway recursion

The "get" and "set" traps take as an optional last argument the "initial receiver" of the property access/assignment. In cases where a property is accessed on a proxy directly, this "initial receiver" will be the proxy object itself. Touching the proxy object from within a trap is dangerous as it may easily lead to runaway recursion. This is especially nasty if you think you aren't touching the proxy, but some implicit conversion (e.g. <tt>toString</tt> conversion) does cause a message to be sent to the proxy. For example, printing the receiver for debugging will send a <tt>toString()</tt> message to it, which may lead to infinite recursion. Say we have a simple proxy handler that just forwards all operations to a <tt>target</tt> object. For debugging purposes, we'd like to know the initial receiver of a property access:

{% highlight javascript %}
get: function(target, name, receiver) {
  print(receiver);
  return target[name];
}
{% endhighlight %}

If <tt>p</tt> is a proxy with the above <tt>get</tt> trap, then <tt>p.foo</tt> will go into an infinite loop: first the <tt>get</tt> trap is called with <tt>name="foo"</tt>, which prints <tt>receiver</tt> (that is bound to <tt>p</tt>). This in turn calls <tt>p.toString()</tt>, which calls the <tt>get</tt> trap again, this time with <tt>name="toString"</tt>. Again, <tt>receiver</tt> is bound to <tt>p</tt>, so printing it again will cause another <tt>toString()</tt> invocation, and so on.

#### Proxies as handlers

Proxy handlers can be proxies themselves. The Proxy Tracer below demonstrates how this pattern can be used to "funnel" all operations applied to a proxy handler through a single <tt>get</tt> trap.

##### Proxy Tracer/Probe

A [tracer](/assets/proxy_examples/tracer.html) proxy (view source) that simply prints a description of all operations performed on itself. Useful for debugging, or for learning how operations are intercepted by proxy handlers.

[Try it in your browser](/assets/proxy_examples/tracer.html).

A [probe](/assets/proxy_examples/probe.html) proxy (view source) that, like the tracer above, logs all meta-level operations applied to it, but that is more configurable (the default logger prints the operations, but you can provide your own logger).

[Try it in your browser](/assets/proxy_examples/probe.html).

### More Examples

See [the documentation of the harmony-reflect project](https://github.com/tvcutsem/harmony-reflect/tree/master/examples). Note: the below examples are all written using the old, **deprecated** Proxy API.

*   A generic object tracer [[code]](http://code.google.com/p/es-lab/source/browse/trunk/src/proxies/tracer.html): simply logs all operations performed on an object via the tracer proxy.
*   A [revocable](http://wiki.erights.org/wiki/Walnut/Secure_Distributed_Computing/Capability_Patterns#Revocable_Capabilities) reference [[code]](http://code.google.com/p/es-lab/source/browse/trunk/doc/proxies/revocableRefManual.js): a proxy that forwards all operations to a target object until revoked. After it is revoked, the proxy can no longer be used to affect the target object. Useful if an object only requires temporary access to another object.
*   A revocable reference with [funneling](http://wiki.ecmascript.org/doku.php?id=harmony:proxies#transparent_chains_of_no-op_proxies) [[code]](http://code.google.com/p/es-lab/source/browse/trunk/doc/proxies/revocableRefFunnel.js). Funneling uses a proxy as a handler so that all operations trap a single "get" trap.
*   A generic [membrane](http://wiki.erights.org/wiki/Walnut/Secure_Distributed_Computing/Capability_Patterns#Membranes) [[code]](http://code.google.com/p/es-lab/source/browse/trunk/doc/proxies/membrane.js): a membrane transitively wraps all objects that enter or exit the membrane. When the membrane is revoked, the entire object graph of objects wrapped inside the membrane is disconnected from objects outside of the membrane. Membranes are the basis of security wrappers and can be used to isolate untrusted code.

### Further Reading

*   An [overview](https://github.com/tvcutsem/harmony-reflect/blob/master/doc/traps.md) of all the traps in the API.
*   Documentation of the [handler API](https://github.com/tvcutsem/harmony-reflect/blob/master/doc/handler_api.md) (signatures of all the traps).
*   Documentation for the [Reflect API](https://github.com/tvcutsem/harmony-reflect/blob/master/doc/api.md).
*   Full details of the API are in the [draft specification and proposal](http://wiki.ecmascript.org/doku.php?id=harmony:direct_proxies) (this is not tutorial material).

The following is a list of dated resources that mostly deal with an old version of the Proxy API. They are very useful documents for context, but not for learning the details of how to use the current Proxy API:

*   The first ECMAScript Harmony [proposal](http://wiki.ecmascript.org/doku.php?id=harmony:proxies) (now deprecated by the current [direct proxies](http://wiki.ecmascript.org/doku.php?id=harmony:direct_proxies) API).
*   The Mozilla Developer Network [Proxy documentation](https://developer.mozilla.org/en/JavaScript/Reference/Global_Objects/Proxy).
*   A [conformance test suite](http://hg.ecmascript.org/tests/harmony/) for the specification is available and can be run using a Javascript shell or in a browser.
*   Design background: first half of this [Google Tech Talk](http://www.youtube.com/watch?v=A1R8KGKkDjU) and the following [academic paper](/assets/proxies.pdf), presented at [DLS 2010](http://www.dynamic-languages-symposium.org/).
*   Brendan Eich, on [his blog](http://brendaneich.com/2010/11/proxy-inception/), concisely explains some of the rationale behind Proxies.
*   Sebastian Markbåge, on [his blog](http://blog.calyptus.eu/seb/2010/11/javascript-proxies-leaky-this/), explains the "leaky this" problem: proxies are often used to wrap objects, but the wrapped object may "leak" outside of its wrapper in some cases.
*   Frameworks making use of proxies:
    *   [dom.js](https://github.com/andreasgal/dom.js), a self-hosted JavaScript implementation of a WebIDL-compliant HTML5 DOM.
    *   [mdv](http://code.google.com/p/mdv/), model-driven views.

* * *

<sub>
  [![Creative Commons License](http://i.creativecommons.org/l/by-sa/2.5/80x15.png)](http://creativecommons.org/licenses/by-sa/2.5/)  
This work is licensed under a [CC BY-SA 2.5 Generic License](http://creativecommons.org/licenses/by-sa/2.5/).
</sub>