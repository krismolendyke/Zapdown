# A micro-framework for publishing [Markdown](http://daringfireball.net/projects/markdown "Markdown")

The author of Markdown, [John Gruber](http://daringfireball.net/ "Daring Fireball"), has remarked:

> "The idea for Markdown is to make it easy to read, write, and edit prose. HTML is a publishing format; Markdown is a writing format."

**Zapdown!** aims to make publishing Markdown simple by letting you forget about HTML as a publishing format altogether.  **Read, write, edit and publish prose.**

You can read more [about Zapdown!](/about "About Zapdown!") and how to quickly get it up and running for yourself.

# Getting started

Using **Zapdown!** is easy.  All you need to do is:

1. Write some Markdown.
1. Save it with a `.md` extension in one of the two following places:
    * `markdown/` and it will appear as a *page* link above **Articles**
    * `markdown/articles/` and it will appear as an *article* link, below the *page* links
1. `$ cake run`

Then you can visit [http://localhost:5678](http://localhost:5678 "Zapdown! localhost") and read your published Markdown!

# File names

In addition to placing your Markdown files in the correct folder and naming them with a `.md` extension you should name them with dashed titles.  This naming convention dictates the titles of your *pages* and *articles* as they appear in navigation links and browser titles.

For instance, a file named, `my-great-article.md`, will be translated into a navigation link that looks like this: [My Great Article](#).

# Whoa, whoa, whoa!  What's going on here?

Hand waving, mostly.  **Zapdown!** is built on a lot of other amazing open source projects.

At its core it is just a pile of [CoffeeScript](http://jashkenas.github.com/coffee-script/) on top of [node.js](http://nodejs.org/) and a few modules.  The fun [Zappa](https://github.com/mauricemach/zappa) framework allows for writing small web applications in CoffeeScript, in a single file.  That file is `production/src/server.coffee`.  It's pretty small and allows you to customize **Zapdown!** easily.

The `server.coffee` file makes use of a few node.js modules, most notably [node-markdown](https://github.com/andris9/node-markdown) for translating Markdown into HTML and a slightly modified [highlight.js](https://github.com/krismolendyke/highlight.js) for marking up `<code>` blocks on the server.

**Zapdown!** also uses the [Compass](http://compass-style.org/) CSS framework with its [Susy](http://susy.oddbird.net/tutorial/) flexible grid layout plugin.

So, that's about it.  There's a lot going on beneath **Zapdown!** but not a lot to it.
