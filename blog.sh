#!/usr/bin/env bash

# DON'T CHANGE THIS
INPUT=$1

# Variables
SITE_NAME="foo"
SITE_LANG="en-us"
SITE_AUTHOR="bar"
SITE_DESCRIPTION="<h2>A <s>simple</s> shitty Static Site Generator</h2><img src='/assets/img/what.webp'>"
SITE_FAVICON_NAME="fav"
SITE_FAVICON_TYPE="webp"

create_site() {
  [[ -z "$(which smu)" ]] && echo "smu is not installed! Please install it from http://git.codemadness.org/smu/"
  mkdir -p "$SITE_NAME/content"
  mkdir -p "$SITE_NAME/assets"
  mkdir -p "$SITE_NAME/pages"
  mkdir -p "$SITE_NAME/public"
  touch "$SITE_NAME/.site"
  cat << EOF > "$SITE_NAME/pages/head.html"
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
<article>
EOF

  cat << EOF > "$SITE_NAME/pages/footer.html"
</article>
</body>
<footer><p>Made with <a href="https://codeberg.org/tukain/blog.sh">blog.sh</a></p></footer>
EOF

  cat << EOF > "$SITE_NAME/content/9999.readme"
# blog.sh

<center>A <s>simple</s> shitty Static Site Generator writen in bash.</center>

## How to use

> Before you proceed on reading all of this yappanese
>
> - All variables are defined inside the script, any modifications you may want to add need to be done there.
> - You **NEED** to have \`smu\` installed. it is a simple program that converts a Markdown-like file to HTML, and it is used by this script. You can clone it from git://git.codemadness.org/smu

To create a site, first, modify the \`SITE_NAME\` variable, and then, just type

    blog.sh new

This will create a directory with the name specified on the \`SITE_NAME\`
variable with the directory structure used by \`blog.sh\`.

The posts are located in the \`content\` directory, the names of each files
needs to be like the following:

    9999.some-post-name

above \`9999.bar\`.

> You don't need to worry about the numbers, they are just for organization
> purposes and don't show on the index page.

You may have already noticed that there are no file extensions present on the
filename, instead, the title itself is basically a file extension. The reason
for it is that it was easier for my smooth brain to write something that parsed
the filenames without any issues.

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

Because I can, and I'm a idiot.

<img src="/assets/img/monkey.webp">
EOF

}

build_site() {
  [[ ! -f ".site" ]] && echo "You're not inside the site directory!" && exit 1
  rm -rf ./public
  mkdir -p public

  for FILE in $(/bin/ls ./content)
  do
    cat ./pages/head.html > public/$FILE.html
    smu ./content/$FILE >> public/$FILE.html
    cat ./pages/footer.html >> public/$FILE.html
  done

  cat ./pages/head.html > index.html
  echo "<h1>$SITE_NAME</h1>" >> index.html
  echo "<h4><a href=\"https://neocities.org/site/tukainpng\">Neocities</a> <a href=\"https://codeberg.org/tukain\">Codeberg</a></h4>" >> index.html
  echo "<h4><i>Made with <a href=\"https://codeberg.org/tukain/blog.sh\">blog.sh</a></i></h4>" >> index.html
  [[ ! -z "$SITE_DESCRIPTION" ]] && echo "<p>${SITE_DESCRIPTION}</p>" >> index.html
  echo "<h2>Posts</h2>" >> index.html
  echo "<ul>" >> index.html

  for PAGE in $(/bin/ls -t ./public)
  do
    echo "<li><a href=\"${PAGE}\">$(echo $PAGE | awk -F'.' '{print $2}')</a></li>" >> index.html
  done

  echo "</ul>" >> index.html
  cat ./pages/footer.html >> index.html
  mv index.html public
  cp -r ./assets ./public
}

version() {
  printf "\e[32mblog.sh \e[34m(v0.0.0)\e[0m\n"
}

case $INPUT in
  "build") build_site;;
  "create") create_site;;
  "version") version;;
  *) cat << EOF

Usage: blog.sh <command>

version - shows blog.sh version
build   - build the website
create  - create the website file structure

EOF
;;
esac
