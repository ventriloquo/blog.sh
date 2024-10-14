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
  mkdir -p "$SITE_NAME/content"
  mkdir -p "$SITE_NAME/assets"
  mkdir -p "$SITE_NAME/pages"
  mkdir -p "$SITE_NAME/public"
  touch "$SITE_NAME/.site"
  cp ./config.json "$SITE_NAME"
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
> - All variables are defined inside a \`config.json\` file.
> - You **NEED** to have \`smu\` installed. it is a simple program that converts a Markdown-like file to HTML, and it is used by this script. You can clone it from git://git.codemadness.org/smu

To create a site, first, modify the \`name\` key inside the \`config.json\` file, and then, just type

    blog.sh create

This will create a directory with the name specified on the \`name\`
key with the directory structure used by \`blog.sh\`.

The posts are located in the \`content\` directory, the names of each files
needs to be like the following:

    9999.some-post-name

They are organized in descending order, that is \`9998.foo\` will be placed
above \`9999.bar\`.

> You don't need to worry about the numbers, they are just for organization
> purposes and don't show on the index page.

You may have already noticed that there are no file extensions present on the
filename, instead, the title itself is basically a file extension. The reason
for it is that it was easier for my smooth brain to write something that parsed
the filenames without any issues.

## There's one more thing

There are 2 more commands:

- \`serve\`
- \`stop\`

The \`serve\` command uses \`python -m http.server\` to create a server that you
can use to preview your site on your local machine. It also uses \`entr\` to see
changes made inside the \`content\` directory, and if there are any changes, it
rebuilds the website.

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
  echo "<h1 id=\"title\">$SITE_NAME</h1>" >> index.html
  echo "<h4 id=\"links\">" >> index.html
    [[ ! "$SITE_LINK_1_URL" == "null" ]] && echo "<a href=\"$SITE_LINK_1_URL\">$SITE_LINK_1_NAME</a>" >> index.html
    [[ ! "$SITE_LINK_2_URL" == "null" ]] && echo "<a href=\"$SITE_LINK_2_URL\">$SITE_LINK_2_NAME</a>" >> index.html
    [[ ! "$SITE_LINK_3_URL" == "null" ]] && echo "<a href=\"$SITE_LINK_3_URL\">$SITE_LINK_3_NAME</a>" >> index.html
    [[ ! "$SITE_LINK_4_URL" == "null" ]] && echo "<a href=\"$SITE_LINK_4_URL\">$SITE_LINK_4_NAME</a>" >> index.html
    [[ ! "$SITE_LINK_5_URL" == "null" ]] && echo "<a href=\"$SITE_LINK_5_URL\">$SITE_LINK_5_NAME</a>" >> index.html
  echo "</h4>" >> index.html
  echo "<h4 id=\"note\"><i>${SITE_NOTE}</i></h4>" >> index.html
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

serve_site() {
  if [[ -z "$(which entr)" ]]; then
    echo "Please install entr to be able to use this command"
    exit 1
  fi

  if [[ -z "$(which python)" ]]; then
    echo "Please install python to be able to use this command"
    exit 1
  fi

  /bin/ls content/* | entr -p blog.sh build &
  python -m http.server -d public/ &
}

stop_server() {
  killall python
  killall entr
}

version() {
  printf "\e[32mblog.sh \e[34m(v0.0.0)\e[0m\n"
}

case $INPUT in
  "build") build_site;;
  "create") create_site;;
  "serve") serve_site;;
  "stop") stop_server;;
  "version") version;;
  *) cat << EOF

Usage: blog.sh <command>

version - shows blog.sh version
create  - create the website structure
build   - build the website
serve   - start a server
stop    - stop the server

EOF
;;
esac
