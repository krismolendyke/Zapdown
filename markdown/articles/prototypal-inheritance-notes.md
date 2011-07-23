# Prototypal Inheritance

* Instead of organizing objects into rigid class forms JavaScript can create
  new objects that are similar to existing objects. Those objects can then be
  customized.
* Customizing a new object is a lot less work than making a class and less
  overhead is involved.
* Keys
    * The `Object.create()` method
    * Functions
* In Pseudoprototypal Inheritance there were three was to create objects:
    1. Constructor functions
    1. The `new` operator
    1. The `prototype` member of functions
* An upcoming version of JavaScript will include the `Object.create()` method
  which combines those three methods into one.

        if (typeof Object.create) !== 'function') {
            Object.create = function(o) {
                function F() {}; // Constructor function
                F.prototype = o; // `prototype` member of function
                return new F();  // `new` operator
            }
        }

* So, prototypal inheritance is *class free*. Objects inherit from objects.
* An object contains a secret link to another object. Mozilla exposes this
  link as `__proto__`
* If the access of a member of an object fails, the member will be searched
  for in the prototype chain.
* If an object's member masks a prototype's member (up the chain), then
  deleting the object's member will expose the prototype's member.

## Creating an Object
    var oldObject = {
        firstMethod: function () {...},
        secondMethod: function () {...}
    };
    
    var newObject = Object.create(oldObject);
    newObject.thirdMethod = function () {...};
    var myDoppelganger = Object.create(newObject);
    myDoppelganger.firstMethod();
    
If `newObject` has a `foo` property then the prototype chain will not be consulted when accessing member `foo`.  This is true for data members and functions.

Changes to `oldObject` have immediate effect on `newObject`.  Changes to `newObject` have *no effect* on `oldObject`.

There is no limit to the length of the prototype chain.  Common sense should be consulted!

## Augmenting an Object

`Object.create` can be used to quickly produce new objects that have the same state and behavior as existing objects.  Each new instance can be augmented by assigning new methods and members.

