# A Survey of the Language

## Key Ideas
* Loose typing
* Objects as general containers
    * vs. objects as rigid instances of classes
    * Objects are just containers of *stuff*
* Prototypal inheritance
    * *Objects can inherit directly from other objects*
    * Uncommon yet powerful manner of performing inheritance
* Lambda
    * "The best idea in the history of programming languages."
    * Functions as first class objects
* Linkage via global variables
    * "One of the worst ideas ever put in a programming language."
    * No linker in the browser- how do components talk to each other? Netscape
      decided to put them all in the global space.


## Values
### Numbers
* Only one type: 64-bit binary floating point, IEEE-754, `Double` in Java
* Does not work well with common understanding of arithmetic, i.e. `0.1 + 0.2
  !== 0.3`
* At best, JavaScript can approximate decimals. Performing arithmetic then
  produces approximations of approximations...
* The solution is to scale to whole numbers, perform arithmetic and scale back
  when computations are complete. Not so great for financial, etc.
  applications!
 * `NaN`
    * The result of `undefined` or erroneous operations.
    * **Toxic!** Any arithmetic operation with `NaN` with an input will result
      with `NaN`.
    * `NaN` is not equal to *anything*, ***including `NaN`***.
    * `NaN === NaN` is `false`.
    * `NaN !== NaN` is `true`.
* `Number(val)`
    * Converts `val` into a number.
    * Produces `NaN` if a problem arises.
    * Can use `+val` for shorthand.
* `parseInt(val, 10)`
    * Converts `val` into a number
    * Stops at the first non-digit character.  i.e. `parseInt('12em') === 12`
    * **Always specify the radix**. `parseInt()` will interpret strings
      beginning with a zero as *octal* if no radix is specified. i.e.
      `parseInt('08') === 0; parseInt('08', 10) === 8`
        * This occurs because `parseInt()` sees the `'0'` first and thinks
          it's getting an octal string. Then, it sees the '`8`', which is not
          a valid octal value and silently stops, leaving a value of `0` as
          the result.
        * This commonly occurs when working with dates and times, for instance
* `Math` Object
    * Modeled after Java's `Math` class.  Not a good thing.
    * `abs`
    * `floor` Useful for converting a floating point number into an integer
    * `log`
    * `max`
    * `pow`
    * `random`
    * `round`
    * `sin`
    * `sqrt`

### Strings
* Sequence of 0 or more 16-bit characters. UCS-2 encoded which is similar to
  UTF-16.
* No character type, simply strings with length of 1.
* Strings are immutable.
* Similar strings are equal (===), unlike in Java.
* `string.length` will give the number of 16-bit characters in a string.
  Extended characters are counted as 2!
* `String(number)` converts a number into a string
* Since strings are objects there are many methods on them.

### Booleans
* `true` & `false` no surprises here!
* `Boolean(val)`
    * Returns `true` if `val` is truthy
    * Returns `false` if `val` is falsy
    * `!!val` is shorthand, like `+` is for `Number(val)`

### `null`
* A value that isn't anything

### `undefined`
* A value which isn't even `null`
* `undefined` is the **default value for variables and parameters**
    * This is confusing because you're defining a variable and simultaneously
      giving it a value of `undefined`
* It is also the value of missing members in objects

### Falsy Values
* `false`
* `null`
* `undefined`
* "" (an empty string)
* `0` (the number zero)
* `NaN`

### Truthy Values
* All other values, *including all objects* are truthy
* "0" and "false" are truthy, for instance, despite *looking* falsy

## Dynamic Objects
* Unification of Object and Hashtable
* `new Object()` produces an empty container of name/value pairs
    * Names can be any string
    * Values can be any value except `undefined`
* Members can be accessed with dot notation or subscript notation
* No hash nature is visible.  No hash codes or rehash methods are available.
* Loosely typed!  Any type can be stored in a variable or passed as a parameter to any function.  JavaScript is not 'untyped', there are a lot of specific types, outlined above.
* Syntactically similar to C, but differs in its type system which allows functions to be values.

## Indentifiers
* Can begin with a letter or `_` or `$`. Followed by zero or more letters,
  digits, `_` or `$`.
* By convention, all variables, parameters, members and function names start with lowercase.  Constructor functions start with uppercase.
* Initial `_` should be reserved for implementations.
* `$` should be reserved for machines. The intention in the JavaScript
  standard was to reserved `$` for macroprocessors and similar to avoid
  conflicts with human-generated code.  Obviously, jQuery ignored this!

## Reserved words 
There are many!  A bunch of which are not actually in use in the language.

## Comments 
`//` and `/* */`.  The first style is preferred for clarity.

## Arithmetic Operators `+ - * / %`

### `+` Addition and Concatenation
* Used for both addition and concatenation. This is a language mistake for a
  loosely typed language. If both operands are numbers, they are added.
  Otherwise, convert them both to strings and concatenate them. 
  i.e. `'$' + 3 + 4 = '$34'`. Operator overloading is dangerous in a loosely typed language.
* The `+` used as unary operator is useful to convert strings to numbers. i.e.
  `+"42" = 42`
* `Number("42") = 42`
* `parseInt("42", 10) = 42`
* `+"3" + (+"4") = 7` Use parens to avoid confusion between `+ +` and `++`,
  another operator.

### `/` Division
* Can produce non-integer results, i.e. `10 / 3 = 3.333333335`. Remember to
watch out for decimal approximations.

### `==`  and `!=` Coercive Comparison
* These **perform type coercion!**
* It is always better to use `===` and `!==` which do not do type coercion.

        ''        == '0'       // false
        0         == ''        // true
        0         == '0'       // true
        false     == 'false'   // false
        false     == '0'       // true
        false     == undefined // false
        false     == null      // false
        null      == undefined // true
        ' \t\r\n' == 0         // true

### `===` and `!==` Non-coercive Comparison
* These do not perform type coercion.  **Always use these!**
* The `===` and `!==` operators compare *object references*, not *object values* and **return true only if both operands are the same object**

        ''        === '0'       // false
        0         === ''        // false
        0         === '0'       // false
        false     === 'false'   // false
        false     === undefined // false
        false     === null      // false
        null      === undefined // false
        ' \t\r\n' === 0         // false

### Comparison `== != < > <= >=`

## Logical `&& || !`

### `&&` The Guard Operator, Logical And
* Performs differently than in most other C-style languages. 
* If the first operand is truthy, return the value of the second operand. If
  the first operand is falsy, return the value of the first operand.
* Useful for avoiding `null` references.  For instance, the following logic:

        if(a) {
            return a.member;
        } else {
            return a;
        }

    can be expressed with `&&` like so:
    
        return a && a.member; # Guard against null reference to member

### `||` The Default Operator, Logical Or
* If first operand is truthy, return the value of the first operand.  If the first operand is falsy, return the second operand.
* Useful for filling in default values

        var last = input || numItems; # If input is falsy, assign numItems

### `!` Prefix, Logical Not
* If the operand is truthy, the result is `false`.  Otherwise, the result is `true`.
* `!!` produces booleans, effectively the opposite results of `!`

### Bitwise `& | ^ >> >>> <<`
* JavaScript makes these operators available, but not integers required for them to operate on.  What happens is the 64-bit floating point operands are converted to signed 32-bit integers before they are operated upon, and then the result is converted back to 64-bit floating point.

### Ternary `?:`

## Statements
### `break` Statement
* Statements can have labels and `break` statements can refer to those labels

        loop: for(;;) {
            ...
            if(...) {
                break loop;
            }
        }

### `for` Statement
* Iterate through all of the **elements** of an *array*
        
        for(var i = 0; i < array.length; i+= 1) {
            // Within this loop, i is the index of the current member
            // array[i] is the current element
        }

### `for .. in` Statement
* Iterate through all of the **members** of an *object*
        
        for(var name in object) {
            if(object.hasOwnProperty(name)) {
                // Within this loop, name is the key of the current member
                // object[name] is the current value
            }
        }
        
* `hasOwnProperty()` is essential due to the way JavaScript handles inheritance.  Without `hasOwnProperty()`, `for .. in` will iterate over the **methods** of the object as well as its data members.  Use it to filter out the methods.

### `switch` Statement
* A multiway branch
* The `switch` value need not be a number, it can be a string
* The `case` values can be expressions
* **Warning:** `case`s fall through to the next `case` unless a disruptive statement like `break` ends that `case`

        switch(expression) {
            case ';':
            case ',':
            case '.':
                punctuation();
                break;
            default:
                noneOfTheAbove();
        }

### `throw` Statement
* Added in 1999, useable in 2005 due to syntax errors in browsers
* Error objects can be thrown using an object constructor or an object literal
    * Object constructor

            throw new Error(reason);
    
    * Object literal
    
            throw {
                name: exceptionName,
                message: reason
            };

### `try` Statement
* There are no exception types in JavaScript, so there will always only be a single `catch` clause on a `try` statement.  Switching on the caught error can filter errors by name
        
        try {
            ...
        } catch(e) {
            switch(e.name) {
                case 'Error':
                    ...
                    break;
                default:
                    throw e; # throw on!
            }
        }

* Several error types are available, but in general, `Error` is the only one you'll want to use

        Error, EvalError, RangeError, SyntaxError, TypeError, URIError

### `with` Statement
* Intended to be a convenience for dealing with deeply nested objects
* Error-prone, **do not use!**

### `function` Statement
    function name(parameters) { statements; }

### `var` Statement
* Define variables used by `function`s
* Types are not specified
* Initial values are not required
* `undefined` is the default initial value if none is specified
        
        var name;
        var numErrors = 0;
        var a, b, c;

### `return` Statement
    return expression; // Or...
    return;

* If there is no *expression*, `undefined` is returned... **except** for constructors, whose default return value is `this`!
        
## Scope
* In JavaScript, `{ blocks }` do not have scope!  Only `function`s have scope!
* A variable defined *anywhere* in a function is available *anywhere* in a function
* Variables defined in a `function` are not visible outside of that `function`
* Defining a variable several times results in a single variable and no warning is given.  It is wise to **define all vars at the beginning of a function.**
* Global variables go into a global object.  Avoid it!

## Object Linkage
* Objects can be created with a secret link to another object
* If an attempt to access a name fails, the secret linked object will be used
* The secret link is not used when storing (assignment).  New members are only added to the primary object.
* The `Object.create(o)` method makes a new empty object with a link to object `o`
* The end of the linkage chain is always `Object.prototype`

## Object Methods
* All objects are linked directly or indirectly to `Object.prototype`
* All objects inherit some basic methods, not many of which are useful.  `hasOwnProperty(name)` is a useful one which is truthy if `name` is a true member of this object, and hasn't come from somewhere in the object's inheritance chain
* No `copy()` method
* No `equals()` method

## Object Construction
* Three ways to create an object

        new Object();
        {}; // Recommended!
        Object.create(Object.prototype);

## Object Reference
* Objects are **passed by reference, never by copy/value**
* The `===` operator compares *object references*, not *object values* and **returns `true` only if both operands are the same object**

## `delete` Operator
* For removing members from objects

        delete myObject[name];
        
* Deleting a member from an object exposes any parent's member with the same name!

## Arrays
* Inherit from `Object`
* Very efficient for *sparse* arrays.  Not very efficient otherwise.
* No need to declare a length or type when creating an array.  Subsequently, you can put anything you want in an `Array`
* `length` is a special member on *arrays only*, not objects
* `length` **does not contain the number of things in the array!**  It contains *1 more than the highest integer subscript in the array.*

        for(var i = 0; i < a.length; i += 1) {
            ...
        }

* **WARNING:** do not use the `for .. in` statement with arrays!  It works, but it is not guaranteed to return elements in the correct order.
* Array literal syntax `[]` is similar to the object literal syntax `{}`
    * It can contain any number of expressions, separated by commas
            
            var myList = ['oats', 'peas', 'beans'];
            
    * New items can be appended
    
            myList[myList.length] = 'barley';
            
* The dot notation *should not be used with arrays!*  This is due to syntactic confusing with index/number access.
* `[]` is the preferred way of creating a new array, vs. `new Array()`
* Array methods
        
        concat, join, pop, push, slice, sort, splice

* `delete` can be used on an array, but it leaves a 'hole' in the array, which is generally not the kind of behavior you want when trying to removed something from an array.  Use `splice()` instead.
        
        delete array[number]; // Removes element, but leaves hole in numbering
        array.splice(number, 1); // Removes element and renumbers all following elements

        var myArray = ['a', 'b', 'c', 'd'];
        delete myArray[1];    // ['a', undefined, 'c', 'd']
        myArray.splice(1, 1); // ['a', 'c', 'd']
        
## Arrays vs. Objects
* Use objects when names are arbitrary strings
* Use arrays when names are sequential integers
* In JavaScript, "associative array" really means `Object`

## Functions
* Functions are first-class objects
    * JavaScript `function`s have the *lambda* property- they can be passed, returned and stored just like any other value
    * `function`s can inherit from `Object` and can store name/value pairs.  This means that it's possible for a `function` to have a method!

### `function` Operator
* The `function` **operator** takes an optional name, a parameter list and a block of statements, and returns a `function` object

        function name(parameters) {
            statements
        }
        
* A `function` can appear anywhere that an expression can appear
* A `function` in JavaScript is known as *lambda* in most other languages
* Lambda is a source of enormous expressive power, and unlike most powerful constructs, it is secure.

### `function` Statement
* The `function` **statement** is really just shorthand for a `var` statement with a `function` value

        function foo() {}
        
    expands to
    
        var foo = function foo() {};

* Inner functions- `function`s do not have to be defined at the top level, or left-edge, they can be defined inside of other `function`s

### `function` Scope
* An inner `function` has access to the variables and parameters of `function`s that it is contained within.  This is knows as "Static Scoping" or "Lexical Scoping".
* **Closure**- the scope that an inner function has continues even after its parent functions have returned.  This is **closure!**  How can you have access to a variable in a `function` that has returned?  How is that useful?

        function fade(id) {
            var dom = document.getElementById(id);
            var level = 1;
            function step() {
                var h = level.toString(16); 
                // level is _not_ a copy- it is the real reference to level!
                dom.style.backgroundColor = '#ffff' + h + h;
                // as is dom, a reference
                if(level < 15) {
                    level += 1;
                    setTimeout(step, 100);
                }
            }
            setTimeout(step, 100);
        }

    `dom` and `level` are available even after `fade()` returns.  Another great thing about closure is that calling `fade()` on two different DOM elements will not interfere with each other.  Each call to `fade()` creates its own instances of these variables, and they are not visible to each other!
    
### Function Objects
* Functions are objects and can contain name/value pairs
* This can serve the same purpose as `static` members in other languages
* Not recommended

### Method
* Since `function`s are values, they can be stored in objects
* A `function` in an object is called a **method**

### Function Invocation
* Extra arguments to a `function` are ignored
* Missing arguments to a `function` are valued as `undefined`
* There is no *implicit* type checking on `function` arguments
* There are four ways to invoke a `function`.  Function and method form are the most frequently used.

    1. Function form
            
            functionObject(arguments);
            
        Similar to method form, but the special pseudoparameter `this` is set to the **global object!**  This is the *worst* thing.  It is just not useful at all.  
        
        It makes it difficult to write a helper function within a method because the helper function does not get access to the outer `this`.  A common work around for the helper function not having access to the surrounding method's `this` is to include a variable in the method and set it to `this`.  The helper function will then have access to that value.
        
            var that = this; // helper function can access reference to that
    
    1. Method form
    
            thisObject.methodName(arguments);
            thisObject['methodName'](arguments);
            
        Calling the *method* of an object.  The special pseudoparameter `this` is set to *thisObject*, the object calling the function.  This allows the *method* to have access to *thisObject*.  More generally, it allows methods to have a reference to the object of interest.
    
    1. Constructor form
    
            new FunctionObject(arguments);
            
        Looks like function form, but has the `new` prefix.  When a function is called with the `new` operator, a new object is created and assigned to `this`.  `this` inherits from the function's `prototype`.  If the function does not *explicitly* return a value, `this` will be return, **not** `undefined` like regular function calls.  This is used in the pseudoclassical style.
            
    1. Apply form
    
            functionObject.apply(thisObject, [arguments]);
            
### `this`
* `this` is an extra parameter that is available to *every* function.  Its value depends on the calling form.
    * In **function** invocation form, `this` is **the global object**- *dangerous!*
    * In **method** invocation form, `this` is **the object**- very useful
    * In **constructor** form, `this` is **the new object** being constructed
* `this` gives methods access to their objects.
* `this` is bound at invocation time.

### `arguments`
* Whenever a function is invoked it gets a special parameter called `arguments`, in addition to its parameters
* `arguments` contains all of the arguments from the invocation and is an *array-like object*
* `arguments.length` is the number of arguments passed

        function sum() {
            var i;
            var n = arguments.length;
            var total = 0;
            for(i = 0; i < n; i += 1) {
                total += arguments[i];
            }
            return total;
        }

        var ten = sum(1, 2, 3, 4);
        
### `typeof` Operator
* A prefix operator that returns a **string** identifying the type of a value.  This went out the door to the standard incorrect.

        Type      typeof
        ----------------------------
        object    'object'
        function  'function'
        array     'object'    YIKES!
        number    'number'
        string    'string'
        boolean   'boolean'
        null      'object'    YIKES!
        undefined 'undefined'
        
* The **only use for `typeof`** is testing for `undefined` variables

        if(typeof foo !== 'undefined') {
            // foo has been declared with a value (not undefined)
        }

