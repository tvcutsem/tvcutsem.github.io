---
title: A brief tour of JavaScript's object model
layout: post
tags: javascript proxies
permalink: js-object-model
excerpt_separator: <!--more-->
---
In this post I will give an overview of Javascript's object model. To a first approximation, by "object model", I mean the mental model that a developer has of an object's structure and behavior. At the end, I will hint at how proxies can be used to implement (variations on) this object model in Javascript itself.
<!--more-->

## Objects as Maps

Let's start with the simplest possible model most JS developers have of a Javascript object, and then refine as we go along. At its core, a Javascript object is nothing but a flexible bag of properties, which we can think of as a mapping from strings to values:

{% highlight javascript %}
var point = {
  x: 0,
  y: 0
};
{% endhighlight %}

The <tt>point</tt> object maps the strings "x" and "y" to the value 0.

Javascript has a fairly large set of operations that one can apply to such maps, including the five basic operations applicable to most generic associative containers: property lookup (e.g. <tt>point.x</tt>), property addition (e.g. <tt>point.z = 0</tt>), property update (e.g. <tt>point.x = 1</tt>), property deletion (e.g. <tt>delete point.x;</tt>) and property query (e.g. <tt>"x" in point</tt>).

## Method Properties

One of the beautiful parts of Javascript, I think, is that support for object "methods" doesn't really require a change to this simple object model: in Javascript, a method is really nothing more than a property whose value happens to be a function. This is reflected in the syntax:

{% highlight javascript %}
var point = {
  x: 0,
  y: 0,
  toString: function() { return this.x + "," + this.y; }
};
{% endhighlight %}

The method invocation <tt>point.toString()</tt> is essentially a lookup of the "toString" property in the object, followed by a function call that sets <tt>this</tt> to the receiver object and passes in the arguments: <tt>(point.toString).apply(point, [])</tt>. So, we don't need to adjust our object model to take methods and method invocations into account.

## Prototype inheritance

The above object model is not complete: we know that Javascript objects also have a special "prototype" link that points to a parent object, from which the object may inherit additional properties. Objects created using the object literal syntax <tt>{…}</tt> inherit from the built-in <tt>Object.prototype</tt> object by default. For instance, our <tt>point</tt> object inherits from this object the built-in method <tt>hasOwnProperty</tt>, which allows us to ask whether the object defines a certain property:

{% highlight javascript %}
point.hasOwnProperty("x") // true
{% endhighlight %}

The prototype link of an object can be obtained by calling <tt>Object.getPrototypeOf(point)</tt>, although many browsers also simply represent the prototype link as a regular property of the object with the funny name <tt>__proto__</tt>.

I don't like to think of the prototype link as a normal property because this link has a large influence on virtually every operation applied to a Javascript object. The prototype link is really special, and setting <tt>point.__proto__</tt> to another object has a very large effect on the subsequent behavior of the <tt>point</tt> object. So, I'd like to think of the prototype link as the next addition to our object model: a javascript object = a map of normal properties + a special prototype link.

## Property attributes

The object model just described (objects as maps of strings -> values + a prototype link) is sufficiently accurate to describe user-defined objects in Ecmascript 3\. However, Ecmascript 5 extends the Javascript object model with a number of new features, most notably property attributes, non-extensible objects and accessor properties. John Resig has a nice [blog post](http://ejohn.org/blog/ecmascript-5-objects-and-properties/) on the subject. I'll only briefly summarize the most salient features here.

Let's start with property attributes. Basically, in ES5, every Javascript property is associated with three _attributes_, which are simply boolean flags indicating whether the property is:

*   writable: the property can be updated
*   enumerable: the property shows up in <tt>for-in</tt> loops
*   configurable: the property's attributes can be updated

Property attributes can be queried and updated using the wordy ES5 built-ins <tt>Object.getOwnPropertyDescriptor</tt> and <tt>Object.defineProperty</tt>. For example:

{% highlight javascript %}
Object.getOwnPropertyDescriptor(point, "x")
// returns {
//   value: 0,
//   writable: true,
//   enumerable: true,
//   configurable: true }
Object.defineProperty(point, "x", {
  value: 1,
  writable: false,
  enumerable: false,
  configurable: false
});
{% endhighlight %}

This turns "x" into a non-writable, non-configurable property, which is basically like a "final" field in Java. The objects returned by <tt>getOwnPropertyDescriptor</tt> and passed into <tt>defineProperty</tt> are collectively called _property descriptors_, since they describe the properties of objects.

So, in ES5, we need to adjust our object model so that Javascript objects are no longer simple mappings from strings to _values_ but rather from strings to _property descriptors_.

## Non-extensible objects

ES5 adds the ability to make objects non-extensible: after calling <tt>Object.preventExtensions(point)</tt>, any attempt to add non-existent properties to the <tt>point</tt> object will fail. This is sometimes useful to protect objects used as external interfaces from inadvertent modifications by client objects. Once an object is made non-extensible, it will forever remain non-extensible.

To model extensibility, we need to extend the Javascript object model with a boolean flag that models whether or not the object is extensible. So now, a Javascript object = a mapping from strings to property descriptors + a prototype link + an extensibility flag.

## Accessor properties

ES5 standardized the notion of "getters" and "setters", i.e. computed properties. For instance, a point whose "y" coordinate is always equal to its "x" coordinate can be defined as follows:

{% highlight javascript %}
function makeDiagonalPoint(x) {
  return {
    get x() { return x; },
    set x(v) { x = v; },
    get y() { return x; },
    set y(v) { x = v; }
  };
};

var dpoint = makeDiagonalPoint(0);
dpoint.x // 0
dpoint.y = 1
dpoint.x // 1
{% endhighlight %}

ES5 calls properties implemented using getters/setters _accessor_ properties. By contrast, regular properties are called _data_ properties. This point object has two accessor properties "x" and "y". The property descriptor for an accessor property has a slightly different layout than that for a data property:

{% highlight javascript %}
Object.getOwnPropertyDescriptor(dpoint, "x")
// returns {
//   get: function() { return x; },
//   set: function(v) { x = v; },
//   enumerable: true,
//   configurable: true
// }
{% endhighlight %}

Accessor property descriptors don't have "value" and "writable" attributes. Instead, they have "get" and "set" attributes pointing to the respective getter/setter functions that are invoked when the property is accessed/updated. If a getter/setter function is missing, the corresponding "get"/"set" attribute is set to <tt>undefined</tt>. Accessing/updating an accessor property with an undefined getter/setter fails.

To accommodate accessor properties, we don't need to further extend our object model, other than by noting that a Javascript object maps strings to property descriptors, which can now be either data or accessor property descriptors.

So, in conclusion, a Javascript object =

*   a mapping of strings to data or accessor property descriptors
*   + a prototype link
*   + an extensibility flag

This is an accurate model of user-defined ES5 objects.

## Implementing your own objects

The object model described above can be thought of as the interface to a Javascript object. With the introduction of [proxies]({% post_url 2012-02-07-designing-the-ecmascript-reflection-api %}) in ES6, Javascript developers actually gain the power to _implement_ this interface, and define their own objects. Not only could you emulate Javascript's default object model in Javascript, you could define small variations to explore different object models.

Examples of such variations include Javascript objects with lazy property initialization, non-extractable or bound-only methods, objects with infinite properties, objects with multiple prototype links supporting multiple-inheritance, etc. There's already some inspiration to be had on github, thanks to [David Bruant](https://github.com/DavidBruant/HarmonyProxyLab) and [Brandon Benvie](https://github.com/Benvie/meta-objects).

I recently gave a [talk at ECOOP](http://soft.vub.ac.be/~tvcutsem/invokedynamic/presentations/JSMop_ECOOP.pdf) that explores these ideas in more detail. The talk builds up by describing Javascript's object model, ties this up to the literature on meta-object protocols, and finally shows how Javascript's Proxy API makes the Javascript meta-object protocol explicit for the first time, allowing developers to implement their own objects. Prototype implementations of proxies are currently available in Firefox and Chrome. To experiment with the latest version of the specified ES6 Proxy API, I recommend using the [reflect.js](https://github.com/tvcutsem/harmony-reflect) shim.