# Flavored Coffee
### Test Driving Client-side Development with Jasmine & CoffeeScript

## Introduction
As the development of our new [cloud based](http://visibiz.com/blog/fred-stluka/fred-stlukas-ieee-talk-cloud-computing "Fred Stluka&#039;s IEEE talk on Cloud Computing... | Visibiz") [Social CRM](http://visibiz.com/blog/ami-assayag/social-future-crm-not-current-social-crm "Social Is The Future of CRM, But Not Like Current Social CRM | Visibiz") system has progressed we have watched the amount of JavaScript in our repository grow.  Much of this code is [jQuery](http://jquery.com/ "jQuery: The Write Less, Do More, JavaScript Library") or [jQueryUI](http://jqueryui.com/ "jQuery UI - Home") and is entirely related to the presentation layer.  There are various [methods](http://www.grails.org/plugin/functional-test "Grails Plugin - Grails Functional Testing") and [tools](http://seleniumhq.org/ "Selenium web application testing system") for automated user-interface testing available to modern web application developers but they can feel very heavyweight.

For logic in our JavaScript code we wanted a fast and lightweight framework that can make our client-side testing as painless and enjoyable as possible.  That's a tall order, and one that required a couple ingredients to achieve.

## The Ingredients: [CoffeeScript](http://jashkenas.github.com/coffee-script/ "CoffeeScript") & [Jasmine](http://pivotal.github.com/jasmine/ "Jasmine: BDD for Javascript | Jasmine")

### CoffeeScript: "It's just JavaScript"
CoffeeScript's golden rule should be reason enough for skeptics to give it a shot.  After a few minutes hacking some CoffeeScript and a short compilation later you'll have nicely formatted, easily debuggable, pure JavaScript.  You can even throw a `--watch` switch on the `coffee` compiler so that your `.coffee` files are compiled into `.js` files as you save them, automatically.

#### A few things to enjoy about CoffeeScript
* [Significant whitespace](http://www.secnetix.de/~olli/Python/block_indentation.hawk) means less `{}`, optional `;`, improved readability and help fending off other [code smells](http://www.codinghorror.com/blog/2006/05/code-smells.html).  It also means that you can clearly define more complex objects.

e.g.,

    myObject = 
        property: 'value'
        nestedObject:
            anotherProperty: 'anotherValue'

* Operators which help eliminate typical JavaScript [operator confusion](http://stackoverflow.com/questions/3904083/confusion-about-typeof) like `is`, `isnt` and `of`
* New Operators like `?:` ([Elvis!](http://groovy.codehaus.org/Operators#Operators-ElvisOperator%28%3F%3A%29)) and `in`
* [List comprehensions](http://en.wikipedia.org/wiki/List_comprehensions)
* Default values for function arguments
* *Simple* class definitions- never type "[prototype](http://eloquentjavascript.net/chapter8.html)" again, unless you're into that kind of thing
* String [variable interpolation](http://en.wikipedia.org/wiki/String_literal#Variable_interpolation)
* Support for a [REPL](http://en.wikipedia.org/wiki/REPL)
* [JavaScript Lint](http://www.javascriptlint.com/) compliant generated code

It is also worth noting that CoffeeScript is never required to be packaged, deployed or run on the client-side, however.  There is never any run-time interpretation of CoffeeScript.

#### The expense of CoffeeScript
* An extra installation step
* An extra compilation step
* If you choose to version compiled JavaScript, redundant files in your code repository  

### CoffeeScript: "It's just JavaScript."
This bears repeating because it really is the **most** important aspect of CoffeeScript!  It means that it can be used with *any* existing JavaScript library.  We've chosen a [behavior-driven development](http://en.wikipedia.org/wiki/Behavior_Driven_Development) (BDD) framework like Jasmine to make our lives easier in this case.  

As a general rule, wherever you can write JavaScript, you can (more) easily write CoffeeScript!

### Jasmine
Jasmine is a JavaScript testing framework that lifts great features from some other well-known and established frameworks like [ScrewUnit](https://github.com/nkallen/screw-unit) and [RSpec](http://rspec.info/ "RSpec.info: Home").  It's lightweight and can be run headless in your favorite [continuous integration server](http://hudson-ci.org/ "Hudson CI").  Jasmine supports testing asyncronous code and has [extensible reporters](https://github.com/larrymyers/jasmine-reporters) for custom test reports to fit your needs.

The syntax Jasmine offers is relatively simple and readable, too.  But like many other robust JavaScript frameworks, multiple and nested function callbacks are the rule, not the exception.  If you begin to test-drive some jQuery code you'll soon find yourself neck deep in `)};` anonymous function callback hell.

Mixing in CoffeeScript's pleasant syntactical and semantic improvements can help pull us out of it.

## CoffeeScript & Jasmine Taste Great Together!
First, let's take a look at a simple and small Jasmine spec written in CoffeeScript.

    it 'should perform some basic arithmetic and logical operations', ->
        expect(2 + 2).toEqual 4
        expect(2 / 2).not.toEqual 4
        expect(true).toBeTruthy()
        expect([0, 1, 2]).toContain 1
        expect(['a', 'b', 'c']).not.toContain 1

That is very readable but it's mostly Jasmine that's responsible for that fact in this simple case, not CoffeeScript.  Next we will take a look at a slightly more involved Jasmine suite aimed at testing some jQuery code to see the power CoffeeScript adds to our recipe.

Let's test-drive a bit of jQuery that updates the background color of a `div` on a `click` event.  Our Jasmine suite with a single spec might look like this:

    describe 'my-div', ->
        it 'should have a red background color when clicked', ->
            red = 'rgb(255, 0, 0)'
            myDiv = $('<div>').attr('id', 'my-div')
            $('body').append myDiv
            expect(myDiv.css('background-color')).not.toEqual red
            myDiv.click()
            expect(myDiv.css('background-color')).toEqual red

Against which we might write this passing jQuery CoffeeScript code:

    $(document).ready -> $('#my-div').live 'click', -> $(this).css('background-color', 'red')

(*Note*: we're binding with the [live](http://api.jquery.com/live/ ".live() &#8211; jQuery API") event handler attachment in this short example because we're appending the `div` in our spec- *after* `document.ready()` has fired.)

Without CoffeeScript our jQuery code would look something like this:

    $(document).ready(function() {
        $('#my-div').live('click', function() {
            return $(this).css('background-color', 'red');
        });
    });

Not bad, but it certainly lacks the elegance and readability that our CoffeeScript one-liner has!

Now let's say we'd like to add a form with a named set of radio button inputs which update a `span` with the value of the selection to our `div`.

Our test code now becomes:

    describe 'my-div', ->
        myDiv = $('<div>').attr('id', 'my-div')

        beforeEach -> $('body').append myDiv
        afterEach -> myDiv.remove()

        it 'should have a red background color when clicked', ->
            red = 'rgb(255, 0, 0)'
            expect(myDiv.css('background-color')).not.toEqual red

            myDiv.click()
            expect(myDiv.css('background-color')).toEqual red
    
        describe 'my-form', ->
            it 'should update selected size on radio button click', ->
                selectedSize = $('<span>').attr('id', 'selected-size')
            
                myDiv.append $('<form>')
                    .attr('id', 'my-form')
                    .append($('<input>')
                        .attr('id', 'small')
                        .attr('name', 'size')
                        .attr('type', 'radio')
                        .val('small'))
                    .append($('<input>')
                        .attr('id', 'large')
                        .attr('name', 'size')
                        .attr('type', 'radio')
                        .val('large'))
                    .append selectedSize

                expect($('#selected-size').text()).toEqual ''
            
                $('#small').click()
                expect(selectedSize.text()).toEqual 'small'

                $('#large').click()
                expect(selectedSize.text()).toEqual 'large'

We've refactored our DOM manipulations to `beforeEach` and `afterEach` blocks and wrapped a spec regarding `#my-form` only in its own nested suite.  This might seem like overkill for a single spec, and it probably is, but when you start writing many specs it really cleans up the test report readability.  Clean test reports make it easier to recognize and fix broken tests faster and easier, which is what test-driving is all about.

Finally, our production code under test bloats to the following:

    $(document).ready -> 
        $('#my-div').live 'click', -> $(this).css('background-color', 'red')

        $('input[name="size"]', '#my-div').live 'click', -> 
            $('#selected-size').text $(this).val()

Not bad!  This was a very simple example, but I hope it clearly illustrates the potential that the combination of CoffeeScript and Jasmine have for reducing client-side testing overhead.

## Enjoy!

CoffeeScript brings to the table an improved, clear syntax and some powerful semantic features over JavaScript all while remaining, "just JavaScript."  Jasmine offers an elegant behavior-driven development [domain-specific language](http://en.wikipedia.org/wiki/Domain-specific_language "Domain-specific language - Wikipedia, the free encyclopedia") for testing and the extensibility to support your working environment.  Adding one to the other is very easy, and the result is just too good to deny!
