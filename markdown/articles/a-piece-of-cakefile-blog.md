# A Piece of Cakefile
### Simplifying Large CoffeeScript Project Builds With Cake

## Introduction
In [my last post](http://goo.gl/aeCV5 "Flavored Coffee: Test Driving Client-side Development with Jasmine &amp; CoffeeScript | Visibiz") I described some methods for test-driving [CoffeeScript](http://jashkenas.github.com/coffee-script/ "CoffeeScript") development.  If you caught the buzz, by now you may have a sprawling CoffeeScript codebase that is quickly outgrowing a simple

    coffee --watch --compile 

command for production compilation and deployment... you're ready for a slice of [Cake](http://jashkenas.github.com/coffee-script/#cake "CoffeeScript")!

## The Ingredients
* [node.js](http://nodejs.org/ "node.js")
* [Node Package Manager (npm)](http://npmjs.org/ "npm - Node Package Manager")
* My [sample project at github](http://goo.gl/LMhGA), to play along at home if you'd like

You'll want to [build and install node](https://github.com/joyent/node/wiki/Installation) from its latest at [github](https://github.com/joyent/node).  Then install `npm` and CoffeeScript:

    $ curl http://npmjs.org/install.sh | sh
    $ npm install coffee-script -g

Now you're ready to enjoy some Cake with your Coffee!  

*Note: npm just turned 1.0 and the `-g` flag tells npm to install CoffeeScript globally, so it is available across your projects and system. You can read more about it on the [node blog post](http://blog.nodejs.org/2011/03/23/npm-1-0-global-vs-local-installation/ "npm 1.0: Global vs Local installation &laquo; node blog").*

## A Taste of Cake
In addition to being a logical progression of the classic `make` and `rake` build system names, `cake` borrows some familiar concepts from those systems.  A `Cakefile` defines tasks that `cake` can perform, written in essentially a tiny CoffeeScript [DSL](http://en.wikipedia.org/wiki/Domain-specific_language "Domain-specific language - Wikipedia, the free encyclopedia").  

That means that all of CoffeeScript's [lovely syntax](http://jashkenas.github.com/coffee-script/#language "CoffeeScript") is available for use. Additionally, since `cake` depends on `node`, you have all of the power of [`node`'s API](http://nodejs.org/docs/v0.4.5/api/ "Node.js Manual &amp; Documentation") and libraries at your finger tips.  That's [kind of a big deal](http://www.youtube.com/watch?v=Bcech3F-FvI "YouTube - Anchorman - Im kind of a big deal").  

## Organizing a CoffeeScript Project
Since I like [test-driven development](http://en.wikipedia.org/wiki/Test-driven_development "Test-driven development - Wikipedia, the free encyclopedia"), I have some general project organization patterns that I like to follow.  Here's a simple example:

    Cakefile
    /production
        /coffee-script
            intro.coffee
            MyGreatClass.coffee
            outro.coffee
        /js
    /test
        /coffee-script
            MyGreatClassSpec.coffee
        /js

Note the implied ordering of the production CoffeeScript files.  Logically, the contents of `intro.coffee` should precede `MyGreatClass.coffee` and `outro.coffee` should wrap things up.  My goal is to generate a single production JavaScript file from those three CoffeeScript files, concatenated in that order before compilation.  CoffeeScript's creator, [Jeremy Ashkenas](https://github.com/jashkenas), has a [great little example](https://github.com/jashkenas/coffee-script/wiki/%5BHowTo%5D-Compiling-and-Setting-Up-Build-Tools) of how to do this, which I'll expand on.

CoffeeScript has a `-j [FILE]` command line switch that lets you easily concatenate file names in order into a single, `FILE.coffee`.  However, if we're [reading a directory asynchronously](http://nodejs.org/docs/v0.4.7/api/fs.html#fs.readdir "fs - Node.js Manual &amp; Documentation") in node, even if our `*.coffee` files are explicitly named to fall into proper order, there is no guarantee that they will be returned in that order.

If you notice tasks or file reads occurring in a seemingly random order, this asynchronous behavior is most likely the culprit.  Of course, there are methods to enforce specific ordering of events that I'll discuss below.

## Cakefile Setup

In order to guarantee the proper ordering of our application's component files, we need to establish an array of those file names, iterate over them and concatenate each file's contents.  To give you an idea of how I currently like to set up my Cakefile, here's what I'd call the preamble, the portion before I define any tasks.

    fs     = require 'fs'
    {exec} = require 'child_process'
    util   = require 'util'

    prodSrcCoffeeDir     = 'production/src/coffee-script'
    testSrcCoffeeDir     = 'test/src/coffee-script'

    prodTargetJsDir      = 'production/src/js'
    testTargetJsDir      = 'test/src/js'

    prodTargetFileName   = 'app'
    prodTargetCoffeeFile = "#{prodSrcCoffeeDir}/#{prodTargetFileName}.coffee"
    prodTargetJsFile     = "#{prodTargetJsDir}/#{prodTargetFileName}.js"

    prodCoffeeOpts = "--bare --output #{prodTargetJsDir} --compile #{prodTargetCoffeeFile}"
    testCoffeeOpts = "--output #{testTargetJsDir}"

    prodCoffeeFiles = [
        'intro'
        'core'
        'outro'
    ]

Like any node application, I require a few modules first.  Then I simply assign a few values for project-specific directory layout, `coffee` options for test and production code, and finally the aforementioned array of CoffeeScript files I'd like concatenated in a particular order.  Now let's take a look at a task that concatenates and builds our production CoffeeScript.

## Cakefile Build Task

    task 'build', 'Build a single JavaScript file from prod files', ->
        util.log "Building #{prodTargetJsFile}"
        appContents = new Array remaining = prodCoffeeFiles.length
        util.log "Appending #{prodCoffeeFiles.length} files to #{prodTargetCoffeeFile}"
    
        for file, index in prodCoffeeFiles then do (file, index) ->
            fs.readFile "#{prodSrcCoffeeDir}/#{file}.coffee"
                      , 'utf8'
                      , (err, fileContents) ->
                util.log err if err
            
                appContents[index] = fileContents
                util.log "[#{index + 1}] #{file}.coffee"
                process() if --remaining is 0

        process = ->
            fs.writeFile prodTargetCoffeeFile
                       , appContents.join('\n\n')
                       , 'utf8'
                       , (err) ->
                util.log err if err
            
                exec "coffee #{prodCoffeeOpts}", (err, stdout, stderr) ->
                    util.log err if err
                    message = "Compiled #{prodTargetJsFile}"
                    util.log message
                    fs.unlink prodTargetCoffeeFile, (err) -> util.log err if err

I won't step through this code as it's pretty easy to follow.  I shamelessly lifted a few patterns from [Jeremy's Wiki](https://github.com/jashkenas/coffee-script/wiki/%5BHowTo%5D-Compiling-and-Setting-Up-Build-Tools) and they have served my projects well.  What you should take away from this `task` is that to guarantee small component concatenation order in a large CoffeeScript project, you'll need to specify that ordering in your Cakefile.  It is not sufficient to hand node a directory which will `ls` or `dir` your project files in the correct order and expect them to be arranged and built that way!

For ease of development, the last task we'll take a look at is a simple `cake watch` task that will look for changes to our individual CoffeeScript files and invoke our `cake build` task when it sees them.  This is the task that makes developing your project in CoffeeScript extra pleasant.

## Cakefile Watch Task

    task 'watch', 'Watch prod source files and build changes', ->
        util.log "Watching for changes in #{prodSrcCoffeeDir}"

        for file in prodCoffeeFiles then do (file) ->
            fs.watchFile "#{prodSrcCoffeeDir}/#{file}.coffee", (curr, prev) ->
                if +curr.mtime isnt +prev.mtime
                    util.log "Saw change in #{prodSrcCoffeeDir}/#{file}.coffee"
                    invoke 'build'

Again, this is pretty simple CoffeeScript to follow.  We're making use of node's [watchFile](http://nodejs.org/docs/v0.4.7/api/fs.html#fs.watchFile "fs - Node.js Manual &amp; Documentation") `fs` method to look for changes to all `*.coffee` files in our production source directory.  When modification times differ, we are invoking the `build` task outlined above.  With this task, you can fire up your command line and execute:

    cake watch
    
in your project's root (where your `Cakefile` should be!) and go on your way happily hacking CoffeeScript all day long.

## A Piece of...
`cake`, even with the simplest Cakefile tasks, can help you organize and streamline your CoffeeScript workflow.  I have tried to illustrate how `cake` can help bring order to your growing CoffeeScript project in a sensible and lightweight manner.  A half hour spent writing a `Cakefile` and tweaking your project structure can mean a big return on time and effort as your project matures.

There isn't a whole lot of documentation available detailing writing even simple Cakefile tasks at the moment and I hope I've helped to fill that gap a bit with this post.  If you'd like to explore more in-depth examples I'd suggest cruising github for [successful CoffeeScript projects](https://github.com/languages/CoffeeScript) and studying their Cakefiles.  There's also the brief [annotated `cake` source](http://jashkenas.github.com/coffee-script/documentation/docs/cake.html "cake.coffee") that can help shed some light onto this build system.

With the power of node's API and the clarity of CoffeeScript's syntax, you've got another great excuse to love `cake`.

## Sample Skeleton CoffeeScript & Cake Project
I've updated my earlier skeleton project for beginning JasmineBDD and CoffeeScript with some of the `cake` tasks and ideas described in this post.  Feel free to take a look, clone/fork/etc., try it out and enjoy!  My project is [available on github](http://goo.gl/LMhGA).

## P.S. - Other Cakefile Task Ideas
* Integrate task success/failure messages with a local notification system (i.e. [Growl](http://search.npmjs.org/#/growl "npm registry")).  My example project illustrates this.
* Create a task to minify/obfuscate your production JavaScript output.  I use [uglify.js](https://github.com/mishoo/UglifyJS) in my example.
* Roll your [favorite JavaScript test framework](http://goo.gl/aeCV5 "Flavored Coffee: Test Driving Client-side Development with Jasmine &amp; CoffeeScript | Visibiz") into a task that executes as part of your `watch` task for a mini-CIT loop while you work.
