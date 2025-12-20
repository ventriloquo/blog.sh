<div align="center"><img src="assets/logo.webp"></div>

# blog.sh

<p>A <s>simple</s> shitty Blog Generator writen in Posix Shell Script.</p>

## How to use

To create a site, just type:

    ./blog.sh create && ./blog.sh build

This will create the directory structure used by `blog.sh` with the default
layout and "build" the website and put it's files on the `public` directory.

The posts are located in the `content` directory, the names of each files
needs to be like the following:

    1970-01-01-title.md
    1991-07-03-title.md
    1996-10-01-title.md
    2003-11-06-title.md
    2004-10-20-title.md

They are organized from higher to lower number, that is, `1991-07-04` will be
placed above `1991-07-03`.

> **THIS IS REQUIRED** SINCE COMMIT: [9a93901afb](https://codeberg.org/tukain/blog.sh/commit/9a93901afb50c4c1241b1a7c40d0b3e292a99e6c)
>
> This `YEAR-MONTH-DAY-TITLE` format is used to create directories and
> sub-directories on witch the posts are stored
>
> Like this:
>
>     2025-10-01-title.md => /posts/2025/10/01/title

The title of each post will be taken from a `<h1>` tag present on the top of
the post.

## How do i configure this thing?

That's the funny part: you edit the source code.

Don't worry, you just need to modify some variables that are on the top of the
script.

The variables are:
- `SITE_NAME`
- `SITE_URL`
- `SITE_LANG`
- `SITE_AUTHOR`
- `SITE_NOTE`
- `SITE_DESCRIPTION`
- `SITE_FAVICON_NAME`
- `SITE_FAVICON_TYPE`
- `BLOG_DIR`
- `CREATE_HOMEPAGE`
- `LATEST_POSTS_TEXT`
- `SOCIAL_LINKS`

These are all a bunch of strings (as basically anything on shell-scripts), so
modify then as you like it.

The `SOCIAL_LINKS` variable is written in the following format:

    SOCIAL_LINKS="https://gnu.org/    Gnu \
                  https://google.com/ Google"

It's like a `key:value` thing. First you put a `URL`, and then a `NAME`. These
links are shown on the navbar, use it to link your social media or something.

> You can't create a `NAME` with spaces.

## smu syntax

Wellll... If you have already used Markdown, then you are at home...
But not quite.

Things like headings

    # Works
    ## Exactly
    ### The
    #### Same
    ##### Way

And the same goes to `_Italic_`, `**Bold**` and `***Bold Italic***`.

Oh, and

    `inline code`

too.

### Things that are diferent from Markdown

smu doesn't have a syntax for

- Tables
- Images

But, you can use regular ol' HTML on smu without any problems.

Code Blocks are made by indenting something with about 4 spaces before any text,
anything indented like that will be enclosed inside a `<code>` tag.

## Why have you brought this upon this cursed land?

First of all: because I can, and I'm a idiot.

Second: I really liked my experience of using [Org-mode's](https://orgmode.org/)
`export to HTML` feature. It's basically a SSG, a basic one, but still one.

So I wanted to create my own, one that is just focused on blog creation (so
it's easier to write) and that was as much portable as it could get.

And here it is, a shitty SSG that takes whatever the hell is on content
directory and throws a bunch of HTML out of it.
