# Pseudoclassical Inheritance

## Classical vs. Prototypal
* Classical: Objects are instances of classes and one class inherits from another class.
* JavaScript has operators that look classical, but behave prototypally. A
  true prototypal inheritance language should have an operator like
  `Object.create` that makes a new object from an existing one, using that
  object as the newly created one's prototype.

## JavaScript's Pseudoclassical Model
### Object Creation Operators
There are three object creation operators in JavaScript that work together to
provide object creation and inheritance.

1. Constructor functions
    * When a `function` is designed to be used with `new`, it is called a
      constructor.
    * Constructors are used to make objects of a type or class
    * This notation can be strange because it is *trying* to look like the old, familiar classical pattern while simultaneously trying to be **something really different**.

2. The `new` operator
    * `new Constructor()` returns a new object with a link to
      `Constructor.prototype`
    * `new` passes `Constructor()` the *new object* as its `this` variable.
      This is how the constructor can customize the new object.
    * **WARNING:** the `new` operator is **required** when calling a
      `Constructor()`. If `new` is omitted, the **global object is clobbered
      by the constructor** - *without warning!* This is a result of the
      `Constructor()` being called with the `function` form, where `this` is
      the **global object**.  This is considered to be a design error.

            function Constructor() {
                this.member = initializer;
                return this; // optional- this is returned by default
            }
        
            // Java programmers: WTF?!
            Constructor.prototype.firstMethod = function(a, b) {...};
            Constructor.prototype.secondMethod = function(c) {...};
        
            var newObject = new Constructor();

3. The `prototype` member of function objects
    * When a `function` object is created, it is given a `prototype` member.
      `prototype` is an object containing a `constructor` member which is a
      reference to the `function` object.
    * The `constructor` member is a *reference* to the function object itself.
    * You can add other members to a function's `prototype`. They will be
      linked to objects created by calling the function with the `new`
      operator.
    * This allows for adding constants and methods to every object created
      without each of those objects being enlarged to contain them. This is
      sometimes called *differential inheritance* because objects are defined
      by the things that make them different than their ancestors.

## Pseudoclassical Inheritance
Classical inheritance can be simulated by assigning an object created by one constructor to the `prototype` member of another.  This does not work *exactly* like the classical model.

    function BiggerConstructor() {};
    BiggerConstructor.prototype = new MyConstructor();
    
A basic example

    function Gizmo(id) {
        this.id = id;
    }

    Gizmo.prototype.toString = function () {
        return 'gizmo' + this.id;
    }
    
An example of pseudoclassical inheritance

    function Hoozit(id) {
        this.id = id;
    }
    
    Hoozit.prototype = new Gizmo();
    Hoozit.prototype.test = function(id) {
        return this.id === id;
    }

This is complicated and ugly!  The `Hoozit`'s constructor is blown away by the instance of the `Gizmo`.

## Public Methods
A public method is a function that uses `this` to access its object.  It can be reused with many objects or pseudoclasses.  The binding to `this` is always dynamic and always very late.  It allows for a very nice reuse pattern.

    function(string) {
        return this.member + string;
    }
    
This can be put in any object and it will work.  Public methods work extremely well with prototypal inheritance and pseudoclassical inheritance.
