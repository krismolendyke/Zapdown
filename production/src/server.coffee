# Node modules.
using 'fs', 'path'
def md: require("#{process.cwd()}/node_modules/node-markdown").Markdown
def _s: require "#{process.cwd()}/node_modules/underscore.string"
def jsdom: require "#{process.cwd()}/node_modules/jsdom"
def hljs: require "#{process.cwd()}/node_modules/highlight.js"

# Globals.
def markdownDir: "#{process.cwd()}/markdown"
def articlesDir: "#{process.cwd()}/markdown/articles"

# Helpers.
helper setup: -> options(); pages(); articles()

helper options: ->
    @options =
        author: 'Kris Molendyke'
        headerTitle: 'Zapdown!'
        headerImg: 'header.png'

helper pages: ->
    files = fs.readdirSync markdownDir
    @pageLinks = []
    for file in files when path.extname(file) is '.md'
        basename = path.basename file, '.md'
        if basename is 'index'
            href = ''
            title = 'Home'
        else
            href = basename
            title = _s.titleize basename.replace /-/g, ' '
        @pageLinks.push href: href, title: title

helper articles: ->
    files = fs.readdirSync articlesDir
    @articleLinks = []
    for file in files when path.extname(file) is '.md'
        basename = path.basename file, '.md'
        href = "article/#{basename}"
        title = _s.titleize basename.replace /-/g, ' '
        @articleLinks.push href: href, title: title

# Routes.
get '/': ->
    setup()
    fs.readFile "#{markdownDir}/index.md", 'UTF-8', (err, data) =>
        @title = 'Home'
        @markdown = md data
        render 'page'

get '/:page': ->
    return unless path.extname(@page) is ''
    filePath = "#{markdownDir}/#{@page}.md"
    path.exists filePath, (exists) =>
        setup()
        @title = _s.titleize @page.replace /-/g, ' '
        if exists
            fs.readFile filePath, 'UTF-8', (err, data) =>
                @markdown = md data
                jsdom.env @markdown, (errors, window) =>
                    @markdown = hljs.initHighlighting window.document
                    render 'page'
        else
            @title = "Page Not Found: #{@page}"
            render 'notFound'

get '/article/:title': ->
    setup()
    fs.readFile "#{articlesDir}/#{@title}.md", 'UTF-8', (err, data) =>
        return render 'error' if err
        @title = _s.titleize @title.replace /-/g, ' '
        @markdown = md data

        jsdom.env @markdown, (errors, window) =>
            @markdown = hljs.initHighlighting window.document
            render 'article'

get '*', ->
    setup()
    @page = params[0]
    @title = "Page Not Found: #{@page}"
    render 'notFound'

# Views.
view page: -> div -> @markdown

view article: -> article -> @markdown

view notFound: ->
    h1 'Yikes!'
    p "Sorry, <strong>#{@page}</strong> could not be found."

view error: ->
    h1 'Whoa.'
    p "Sorry, things went south when looking for #{@title}."

# Layout.
layout ->
    doctype 5
    html ->
        head ->
            link
                rel: 'stylesheet'
                href: '/css/screen.css'
                media: 'screen, projection'
            link
                rel: 'stylesheet'
                href: 'http://fonts.googleapis.com/css?family=Inconsolata&v2'
                type: 'text/css'
            title @title
        body ->
            header ->
                a href: '/', ->
                    if @options.headerImg
                        img src: "/img/#{@options.headerImg}", alt: 'Home'
                    else if @options.headerTitle
                        h1 -> @options.headerTitle
                    else
                        h1 -> 'Zapdown!'
            nav ->
                ul ->
                    for link in @pageLinks
                        li -> a href: "/#{link.href}", -> link.title
                h3 -> 'Articles'
                ul ->
                    for link in @articleLinks
                        li -> a href: "/#{link.href}", -> link.title
            div id: 'content', -> @content
            footer ->
                p -> "&copy; 2011 #{@options.author}"
