#!/bin/sh

INPUT=$1 # DON'T CHANGE THIS

SITE_NAME="foo"
SITE_LANG="en-us"
SITE_AUTHOR="bar"
SITE_NOTE="You could've just used jekyll or Hugo, you know that, right?"
SITE_DESCRIPTION="Here's a description. I know, pretty empty, eh?"
SITE_FAVICON_NAME="fav"
SITE_FAVICON_TYPE="webp"

create_site() {
  [ -z "$(which smu)" ] && echo "smu is not installed! Please install it from https://git.codemadness.org/smu/" && exit 1
  mkdir -p "content"
  mkdir -p "assets"
  mkdir -p "pages"
  mkdir -p "public"
  touch ".site"
  cat << EOF > "pages/head.html"
<!DOCTYPE html>
<head>
  <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
  <meta http-equiv="Content-Language" content="${SITE_LANG}" />
  <meta name="generator" content="blog.sh" />
  <meta name="author" content="${SITE_AUTHOR}" />
  <meta name="description" content="${SITE_DESCRIPTION}" />
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <link rel="icon" href="/assets/${SITE_FAVICON_NAME}.${SITE_FAVICON_TYPE}" type="image/${SITE_FAVICON_TYPE}" />
  <link href="/assets/styles.css" rel="stylesheet">
  <title>${SITE_NAME}</title>
</head>
<body>
EOF

# Links list: [URL NAME]
set -- https://neocities.org/site/tukainpng Neocities \
       https://codeberg.org/tukain Codeberg \
       https://github.com/ventriloquo Github

# If the [URL NAME] pair is not complete, the link will not be visible
[ -z "$(echo $1)" ] || [ -z "$(echo $2)" ]  && SITE_LINK_1_DISPLAY="display: none"
[ -z "$(echo $3)" ] || [ -z "$(echo $4)" ]  && SITE_LINK_2_DISPLAY="display: none"
[ -z "$(echo $5)" ] || [ -z "$(echo $6)" ]  && SITE_LINK_3_DISPLAY="display: none"
[ -z "$(echo $7)" ] || [ -z "$(echo $8)" ]  && SITE_LINK_4_DISPLAY="display: none"
[ -z "$(echo $9)" ] || [ -z "$(echo $10)" ] && SITE_LINK_5_DISPLAY="display: none"

cat << EOF > "pages/navbar.html"
<header>
  <nav>
    <div class="home_link">
      <a class="text" href="/">Início</a>
    </div>
    <div id="nav_list" class="nav_items">
      <a style="$SITE_LINK_1_DISPLAY" href="${1}">${2}</a>
      <a style="$SITE_LINK_2_DISPLAY" href="${3}">${4}</a>
      <a style="$SITE_LINK_3_DISPLAY" href="${5}">${6}</a>
      <a style="$SITE_LINK_4_DISPLAY" href="${7}">${8}</a>
      <a style="$SITE_LINK_5_DISPLAY" href="${9}">${10}</a>
    </div>
    <div>
      <a href="/blog.html">Blog</a>
    </div>
    <button popovertarget="nav_menu" popovertargetaction="toggle" class="nav_menu">Menu</button>
  </nav>
  <div popover="" id="nav_menu">
  <a style="margin: 0; padding: 10px 20px; color: var(--background); background-color: var(--accent); text-align: center" href="/blog.html">Blog</a>
  <hr style="border-color: var(--accent)">
    <a style="$SITE_LINK_1_DISPLAY" href="$SITE_LINK_1_URL">$SITE_LINK_1_NAME</a>
    <a style="$SITE_LINK_2_DISPLAY" href="$SITE_LINK_2_URL">$SITE_LINK_2_NAME</a>
    <a style="$SITE_LINK_3_DISPLAY" href="$SITE_LINK_3_URL">$SITE_LINK_3_NAME</a>
    <a style="$SITE_LINK_4_DISPLAY" href="$SITE_LINK_4_URL">$SITE_LINK_4_NAME</a>
    <a style="$SITE_LINK_5_DISPLAY" href="$SITE_LINK_5_URL">$SITE_LINK_5_NAME</a>
  </div>
</header>
<article>
EOF

cat << EOF > "pages/footer.html"
</article>
<footer><p>Made with <a href="https://codeberg.org/tukain/blog.sh">blog.sh</a></p></footer>
</body>
EOF

cat << EOF > "content/deleteme"
# blog.sh

<p>A <s>simple</s> shitty Blog Generator writen in Posix Shell Script.</p>

## How to use

To create a site, just type:

    ./blog.sh create && ./blog.sh build

This will create the directory structure used by \`blog.sh\` with the default layout and
"build" the website and put it's files on the \`public\` directory.

The posts are located in the \`content\` directory, the names of each files
needs to be like the following:

    1970-01-01
    1991-07-03
    1996-10-01
    2003-11-06
    2004-10-20

They are organized from higher to lower number, that is, \`1991-07-04\` will be placed
above \`1991-07-03\`.

> You may have already noticed that there are no file extensions present on the
> filename. The reason for it is that it was easier for my smooth brain to write 
> something that parsed the filenames without any issues.

The title of each post will be taken from a \`<h1>\` tag present on the post. So
yes, do not use \`<h1>\` tags (one \`#\`) on the post's apart for the title of it.

## How do i configure this thing?

That's the funny part: you edit the source code.

Don't worry, you just need to modify some variables and a \`positional parameter\`.

The variables are:
- \`SITE_NAME\`
- \`SITE_LANG\`
- \`SITE_AUTHOR\`
- \`SITE_NOTE\`
- \`SITE_DESCRIPTION\`
- \`SITE_FAVICON_NAME\`
- \`SITE_FAVICON_TYPE\`

These are all a bunch of strings (as basically anything on shell-scripts), so modify then as
you like it.

And the \`positional parameter\` has this comment on top of if: \`# Links list\`.

> I'm using a \`positional parameter\` because Posix Shell's don't have no arrays on then.

This links list is writen like this:
    set -- https://google.com/ google

It's like a \`key:value\` thing. First you put a URL, and then a NAME. These links are shown on the navbar,
use it to link your social media or something.

## smu syntax

Wellll... If you have already used Markdown, then you are at home... But not quite.

Things like headings

    # Works
    ## Exactly
    ### The
    #### Same
    ##### Way

And the same goes to \`_Italic_\`, \`**Bold**\` and \`***Bold Italic***\`.

Oh, and

    \`inline code\`

too.

### Things that are diferent from Markdown

smu doesn't have a syntax for

- Tables
- Images

But, you can use regular ol' HTML on smu without any problems.

Code Blocks are made by indenting something with about 4 spaces before any text,
anything indented like that will be enclosed inside a \`<code>\` tag.

## Why have you brought this upon this cursed land?

First of all: because I can, and I'm a idiot.

Second: I really liked my experience of using [Org-mode's](https://orgmode.org/)
\`export to HTML\` feature. It's basically a SSG, a basic one, but still one.

So I wanted to create my own, one that is just focused on blog creation (so
it's easier to write) and that was as much portable as it could get.

And here it is, a shitty SSG that takes whatever the hell is on content directory and throws a bunch of HTML out of it.
EOF

}

build_site() {
  [ ! -f ".site" ] && echo "You're not inside the site directory!" && exit 1
  rm -rf ./public
  mkdir -p public/posts

  for FILE in $(/bin/ls ./content)
  do
    cat ./pages/head.html   >  public/posts/"$FILE".html
    cat ./pages/navbar.html >> public/posts/"$FILE".html
    smu ./content/$FILE     >> public/posts/"$FILE".html
    cat ./pages/footer.html >> public/posts/"$FILE".html
  done

  cat ./pages/head.html > index.html
  cat ./pages/navbar.html >> index.html
  echo "<h1>$SITE_NAME</h1>" >> index.html
  [ ! "$SITE_NOTE" = "null" ] && echo "<h4><i>${SITE_NOTE}</i></h4>" >> index.html
  [ ! "$SITE_DESCRIPTION" = "null" ] && echo "<p>${SITE_DESCRIPTION}</p>" >> index.html
  cat ./pages/footer.html >> index.html

  cat ./pages/head.html > blog.html
  cat ./pages/navbar.html >> blog.html

  echo "<h2>Posts</h2>" >> blog.html
  echo "<ul>" >> blog.html

  for PAGE in $(/bin/ls -1 ./public/posts | sort -r | tr '\n' ' ')
  do
    echo "<li><a href=\"/posts/${PAGE}\">$(grep '<h1>' ./public/posts/"$PAGE" | tr '<>/' '\n' | head -n3 | tail -n1 )</a></li>" >> blog.html
  done

  echo "</ul>" >> blog.html
  cat ./pages/footer.html >> blog.html
  mv *.html public
  cp -r ./assets ./public
}

version() {
  printf "\e[32mblog.sh \e[34m(v0.0.2)\e[0m\n"
}

case "$INPUT" in
  "build") build_site;;
  "create") create_site;;
  "version") version;;
  *) cat << EOF

Usage: blog.sh <command>

version - shows blog.sh version
create  - create the website structure
build   - build the website

EOF
;;
esac
