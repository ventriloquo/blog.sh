#!/usr/bin/env bash

# DON'T CHANGE THIS
INPUT=$1
SITE_NAME=$(cat ./config.json | jq -r .name)
SITE_LANG="$(cat ./config.json | jq -r .lang)"
SITE_AUTHOR="$(cat ./config.json | jq -r .author)"
SITE_DESCRIPTION="$(cat ./config.json | jq -r .description)"
SITE_NOTE="$(cat ./config.json | jq -r .note)"
SITE_FAVICON_NAME="$(cat ./config.json | jq -r .favicon.filename)"
SITE_FAVICON_TYPE="$(cat ./config.json | jq -r .favicon.extension)"
SITE_LINK_1_NAME="$(cat ./config.json | jq -r .links[0])"
SITE_LINK_1_URL="$(cat ./config.json | jq -r .links[1])"
SITE_LINK_2_NAME="$(cat ./config.json | jq -r .links[2])"
SITE_LINK_2_URL="$(cat ./config.json | jq -r .links[3])"
SITE_LINK_3_NAME="$(cat ./config.json | jq -r .links[4])"
SITE_LINK_3_URL="$(cat ./config.json | jq -r .links[5])"
SITE_LINK_4_NAME="$(cat ./config.json | jq -r .links[6])"
SITE_LINK_4_URL="$(cat ./config.json | jq -r .links[7])"
SITE_LINK_5_NAME="$(cat ./config.json | jq -r .links[8])"
SITE_LINK_5_URL="$(cat ./config.json | jq -r .links[9])"

create_site() {
  [[ -z "$(which smu)" ]] && echo "smu is not installed! Please install it from https://git.codemadness.org/smu/" && exit 1
  [[ -z "$(which jq)" ]] && echo "jq is not installed! Please install it from your package repo!" && exit 1
  [[ ! -f "config.json" ]] && echo "You don't have a config.json file!" && exit 1
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

echo "<header><nav><ul><li><a href=\"/\">Home</a></li></ul><ul class=\"link\">" > "pages/navbar.html"
  [[ ! "$SITE_LINK_1_URL" == "null" ]] && echo "<li><a href=\"$SITE_LINK_1_URL\">[$SITE_LINK_1_NAME]</a> </li>" >> "pages/navbar.html"
  [[ ! "$SITE_LINK_2_URL" == "null" ]] && echo "<li><a href=\"$SITE_LINK_2_URL\">[$SITE_LINK_2_NAME]</a> </li>" >> "pages/navbar.html"
  [[ ! "$SITE_LINK_3_URL" == "null" ]] && echo "<li><a href=\"$SITE_LINK_3_URL\">[$SITE_LINK_3_NAME]</a> </li>" >> "pages/navbar.html"
  [[ ! "$SITE_LINK_4_URL" == "null" ]] && echo "<li><a href=\"$SITE_LINK_4_URL\">[$SITE_LINK_4_NAME]</a> </li>" >> "pages/navbar.html"
  [[ ! "$SITE_LINK_5_URL" == "null" ]] && echo "<li><a href=\"$SITE_LINK_5_URL\">[$SITE_LINK_5_NAME]</a> </li>" >> "pages/navbar.html"
echo "</ul><ul><li><a href=\"/blog.html\">Blog</a></li></ul></nav></header><article>" >> "pages/navbar.html"

  cat << EOF > "pages/footer.html"
</article>
<footer><p>Made with <a href="https://codeberg.org/tukain/blog.sh">blog.sh</a></p></footer>
</body>
EOF

  cat << EOF > "content/deleteme"
# blog.sh

<center>A <s>simple</s> shitty Static Site Generator writen in bash.</center>

> Before you proceed on reading all of this yappanese
>
> - All variables are defined inside a \`config.json\` file.
> - You **NEED** to have \`smu\` installed. it is a simple program that converts a Markdown-like file to HTML, and it is used by this script. You can clone it from git://git.codemadness.org/smu

## How to use

To create a site, first, modify the \`name\` key inside the \`config.json\` file, and then, just type

    blog.sh create

This will create a directory with the name specified on the \`name\`
key with the directory structure used by \`blog.sh\`.

The posts are located in the \`content\` directory, the names of each files
needs to be like the following:

    1970-01-01
    1991-07-03
    1996-10-01
    2003-11-06
    2004-10-20

They are organized in ascending order, that is, \`1991-07-04\` will be placed
above \`1991-07-03\`.

> You don't need to worry about the numbers, they are just for organization
> purposes and don't show on the index page.

> Oh, and you don't _need_ to care about it either, that is, if you just want to
> see the circus taking fire.

You may have already noticed that there are no file extensions present on the
filename. The reason for it is that it was easier for my smooth brain to write 
something that parsed the filenames without any issues.

The title of each post will be taken from a \`<h1>\` tag present on the post. So
yes, do not use \`<h1>\` tags (one \`#\`) on the post's apart for the title of it.

## The config.json file

Yeah... I'm using json to configure this thing, idk, it's easier to just use \`jq\`
and don't think much about it.

The config looks like this:

    {
      "name": "foo",
      "author": "bar",
      "lang": "en-us",
      "description": "lorem ipsum",
      "note": "You could've just used jekyll or Hugo, you know that, right?",
      "favicon": {
        "filename": "fav",
        "extension": "webp"
      },
      "links": [
        "Neocities", "https://neocities.org/site/tukainpng",
        "Codeberg", "https://codeberg.org/tukain"
      ]
    }

If you don't have a \`config.json\` file on the directory that you're currently,
then you won't be able to use the \`create\` command.

## smu syntax

Wellll..... If you have already used Markdown, then you are at home... But not quite.

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

<img src="/assets/img/monkey.webp">

Second, I really liked my experience of using [Org-mode's](https://orgmode.org/)
\`export to HTML\` feature. It's basically a SSG, a basic one, but still one.

So I wanted to create my own, one that is just focused on blog creation (so
it's easier to write) and that was as much portable as it could get.

And here it is, a shitty SSG that takes whatever the hell is on the config file
and on the content directory and throws a bunch of HTML out of it.
EOF

}

build_site() {
  [[ ! -f ".site" ]] && echo "You're not inside the site directory!" && exit 1
  rm -rf ./public
  mkdir -p public/posts

  for FILE in $(/bin/ls ./content)
  do
    cat ./pages/head.html   >  public/posts/$FILE.html
    cat ./pages/navbar.html >> public/posts/$FILE.html
    smu ./content/$FILE     >> public/posts/$FILE.html
    cat ./pages/footer.html >> public/posts/$FILE.html
  done

  cat ./pages/head.html > index.html
  cat ./pages/navbar.html >> index.html
  echo "<h1>$SITE_NAME</h1>" >> index.html
  echo "<h4><i>${SITE_NOTE}</i></h4>" >> index.html
  [[ ! -z "$SITE_DESCRIPTION" ]] && echo "<p>${SITE_DESCRIPTION}</p>" >> index.html
  cat ./pages/footer.html >> index.html

  cat ./pages/head.html > blog.html
  cat ./pages/navbar.html >> blog.html

  echo "<h2>Posts</h2>" >> blog.html
  echo "<ul>" >> blog.html

  for PAGE in $(/bin/ls -1 ./public/posts | sort -r | tr '\n' ' ')
  do
    echo "<li><a href=\"/posts/${PAGE}\">$(grep '<h1>' ./public/posts/$PAGE | tr '<>/' '\n' | head -n3 | tail -n1 )</a></li>" >> blog.html
  done

  echo "</ul>" >> blog.html
  cat ./pages/footer.html >> blog.html
  mv *.html public
  cp -r ./assets ./public
}

version() {
  printf "\e[32mblog.sh \e[34m(v0.0.1)\e[0m\n"
}

case $INPUT in
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
