#!/bin/sh
INPUT=$1 # DON'T CHANGE THIS
set -e

################################################################################

TUTORIAL="true"
SITE_NAME="Foo Bar"
SITE_URL="https://foo.bar"
SITE_FEED="true"
SITE_LANG="en-us"
SITE_AUTHOR="bar"
SITE_NOTE="You could've just used jekyll or Hugo, you know that, right?"
SITE_DESCRIPTION="Here's a description. I know, pretty empty, eh?"
SITE_FAVICON_NAME="fav"
SITE_FAVICON_TYPE="webp"
BLOG_DIR="log"
USE_DEFAULT_CSS="true"
CREATE_NAVBAR="true"
CREATE_FOOTER="true"
LATEST_POSTS_TEXT="Latest posts:"
SOCIAL_LINKS="https://neocities.org/site/tukainpng Neocities \
              https://codeberg.org/tukain          Codeberg \
              https://github.com/ventriloquo       Github"

################################################################################

mkdir -p content pages temp/log public/log
[ "$TUTORIAL" = "true" ] && cat README > content/1970-01-01-00-Delete-me.gmi

slug_basename() {
  basename $(echo $FILE \
      | awk -F'[0-9]{4}-[0-9]{2}-[0-9]{2}-[0-9]{2}-' '{print $2}' \
      | sed \
        -e 's/ç/c/g' \
        -e 's/ã/a/g' \
        -e 's/â/a/g' \
        -e 's/á/a/g' \
        -e 's/à/a/g' \
        -e 's/í/i/g' \
        -e 's/é/e/g' \
        -e 's/è/e/g' \
        -e 's/ê/e/g' \
        -e 's/ô/o/g' \
        -e 's/ó/o/g' \
        -e 's/ò/o/g' \
        -e 's/ò/o/g' \
        -e 's/õ/o/g') .gmi
}

post_dates() {
  POST_YEAR=$(echo $FILE  | awk -F'-' '{print $1}')
  POST_MONTH=$(echo $FILE | awk -F'-' '{print $2}')
  POST_DAY=$(echo $FILE   | awk -F'-' '{print $3}')
}

if [ "$USE_DEFAULT_CSS" = "true" ]; then
  mkdir -p assets
  cat << EOF > assets/styles.css
:root {
  --border: solid .2em var(--grey);
}

@media only screen and (prefers-color-scheme: dark) {
  :root {
    --background: #1d2021;
    --foreground: #ebdbb2;
    --grey:       #282828;
    --accent:     #98971a;
  }
}

@media only screen and (prefers-color-scheme: light) {
  :root {
    --background: #fbf1c7;
    --foreground: #3c3836;
    --grey:       #ebdbb2;
    --accent:     #458588;
  }
}

*::-webkit-scrollbar {
  display: none;
}

* {
  margin: 0;
  padding: 0;
}

html {
  position: relative;
  min-height: 100%;
  font-family: "Sans Serif", sans, system-ui;
  scroll-behavior: smooth;
  background-color: var(--grey);
}

body {
  background-color: var(--background);
  color: var(--foreground);
  max-width: 100ch;
  display: block;
  margin: auto;
}

header {
  position: sticky;
  top: 0;
}

nav {
  display: flex;
  flex-wrap: wrap;
  flex-direction: row;
  justify-content: space-between;
  align-items: center;
  z-index: 20;
  border-bottom: solid .1em var(--grey);
  background-color: var(--background);
  a {
  	text-decoration: none;
  	display: inline-block;
  	padding: 1em;
  	transition: all 300ms;
  	color: var(--foreground);
	&[href^="http"] {
  		text-decoration: none;
	}
	&[href^="http"]::after {
  		content: "";
	}
  }
}

.nav_items {
  display: flex;
  flex-direction: row;
}

#nav_menu:popover-open {
	background-color: var(--background);
  	display: flex;
  	flex-wrap: wrap;
  	flex-direction: column;
  	padding: 0.5em;
  	border: none;
  	z-index: 1;
  	animation: top-to-bottom 300ms both;
  	min-height: 100vh;
  	width: calc(100% - 1em);
	a {
  		margin: 1em;
  	}
  	hr {
  		color: var(--foreground);
	}
}

.nav_menu {
	display: none;
  	border: none;
  	color: var(--foreground);
  	padding: 1em;
  	background-color: var(--background);
}

nav a:hover, .nav_menu:hover {
  opacity: 80%;
}

nav a:hover {
  background-color: var(--accent);
  color: var(--background);
}

@keyframes top-to-bottom {
  from {
    opacity: 0;
    transform: translateY(-20px);
  }
  to {
    opacity: 1;
    transform: translateY(0);
  }
}

li {
  line-height: 2.0;
  list-style-position: inside;
}

p {
  line-height: 1.5;
  padding-bottom: .5em;
}

a {
  text-decoration: none;
  color: var(--accent);
}

a[href^="http"] {
  text-decoration: underline;
  text-underline-offset: .2em;
}

a[href^="http"]::after {
  content: "\2197";
}

a:hover {
  opacity: 80%;
}

hr {
  border: var(--border);
  border-bottom: none;
}

p > code {
  color: var(--foreground);
  background-color: var(--grey);
  border-radius: 3px;
}

pre, code {
  padding: 3px;
  background-color: var(--grey);
}

pre code {
  overflow-x: scroll;
  display: block;
}

li + br,
li + br + br,
.blog_entry + br,
.blog_entry + br + br,
br:has(+ li),
h1 + br,
h1 + br + br,
h2 + br,
h2 + br + br,
h3 + br,
h3 + br + br,
pre > br {
  display: none !important;
}

pre {
  margin-bottom: 1em;
}

q::before, q::after {
  content: "";
}

blockquote, q {
  background-color: var(--grey);
  color: var(--accent);
  border-left: solid 5px var(--accent);
  padding: 10px 20px;
  display: block;
}

blockquote code, q code, blockquote pre, q pre  {
  background-color: var(--accent);
  color: var(--background);
}

blockquote pre, q pre {
  padding-top: 10px;
  padding-bottom: 10px;
}

p, hr, ul, ol {
  margin-top: 0.5em;
  margin-bottom: 0.5em;
  list-style-position: inside;
}

h1, h2, h3, h4 {
  margin-top: 0.5em;
  margin-bottom: 0.5em;
}

h4:has(i) {
  margin-bottom: 2em;
}

h1 + p, h1 + h4 {
  margin-top: -1em;
}

time {
  color: var(--accent);
  font-size: x-large;
}

img {
  max-height: 400px;
  max-width: 100%;
  object-fit: cover;
  display: block;
  margin: 1em auto;
  border: var(--border);
}

footer {
  display: block;
  margin-left: auto;
  margin-right: auto;
  padding-top: 1em;
  padding-bottom: 1em;
  text-align: center;
  background-color: var(--background);
  border-top: solid .1em var(--grey);
}

main {
  display: block;
  margin-left: auto;
  margin-right: auto;
  padding: 1em;
  min-height: 100vh;
}

.blog_item {
  padding: 3px 10px;
  border-radius: 5px;
  transition: all 300ms;
  text-decoration: none;
  margin: 1px 0;
  display: block;
  line-height: 2.0;
  border: solid 1px var(--grey);
}

.blog_item:hover {
  padding: 1em;
  background-color: var(--accent);
  color: var(--background);
  border-color: var(--accent);
}

.blog_item:hover a {
  color: var(--background);
  text-decoration: underline;
  text-underline-offset: .3em;
}

.button {
  color: var(--foreground);
  background-color: var(--grey);

  &:hover {
    color: var(--background);
    background-color: var(--accent);
  }

  padding: 3px 10px;
  border-radius: 5px;
  transition: all 300ms;
  text-decoration: none;
  margin: 1px 0;
  display: block;
  line-height: 2.0;

  &:active {
    border-radius: 0;
  }
}

li:has(.blog_entry) {
  line-height: 2.0;
  padding-inline-start: 0px;
  margin: 10px 0;
  list-style: none;

  .button {
    border-radius: 0;
  }

  &+li, &:has(+ li) {
    margin-top: 0;
    margin-bottom: 0;
  }

  &+li {
    a {
      margin-top: 1px;
      margin-bottom: 0;
    }
  }

  &:has(+ li) {
    a {
      margin-top: 0;
      margin-bottom: .8px; /* WTF? */
    }
  }

  &:first-child .button {
    margin-top: 10px;
    border-start-start-radius: 5px;
    border-start-end-radius: 5px;
  }

  &:last-child .button {
    margin-bottom: 10px;
    border-end-start-radius: 5px;
    border-end-end-radius: 5px;
  }
}

@view-transition {
  navigation: auto;
}

@media only screen and (max-width: 1280px) {
  nav {
    align-items: center;
  }

  .nav_items {
    display: none;
  }

  .nav_menu, nav a {
    display: inline-block;
    font-size: large;
  }

}
EOF
fi

if [ "$CREATE_NAVBAR" = "true" ]; then
set -- $SOCIAL_LINKS
[ -z "$1" ] || [ -z "$2" ]    && SITE_LINK_1_DISPLAY="display: none"
[ -z "$3" ] || [ -z "$4" ]    && SITE_LINK_2_DISPLAY="display: none"
[ -z "$5" ] || [ -z "$6" ]    && SITE_LINK_3_DISPLAY="display: none"
[ -z "$7" ] || [ -z "$8" ]    && SITE_LINK_4_DISPLAY="display: none"
[ -z "$9" ] || [ -z "${10}" ] && SITE_LINK_5_DISPLAY="display: none"

cat << EOF > "pages/navbar.html"
<header>
<nav>
<div class="home_link">
<a class="text" href="/">Home</a>
</div>
<div class="nav_items">
<a href="/$BLOG_DIR">Blog</a>
</div>
<button
  popovertarget="nav_menu"
  popovertargetaction="toggle"
  class="nav_menu">Menu</button>
</nav>
<div popover="" id="nav_menu">
<div style="display: flex; flex-wrap: wrap; justify-content: space-between; align-items: center; border: solid .1em var(--grey)">
<a style="margin: 0;
  padding: 1em;
  text-align: center"
  href="/">Home</a>
<a style="margin: 0;
  padding: 1em;
  text-align: center"
  href="/$BLOG_DIR">Blog</a>
</div>
<div style="display: flex; flex-wrap: wrap; flex-direction: column; align-items: center; margin-top: .3em; border: solid .1em var(--grey);">
<a style="$SITE_LINK_1_DISPLAY" href="$1">$2</a>
<a style="$SITE_LINK_2_DISPLAY" href="$3">$4</a>
<a style="$SITE_LINK_3_DISPLAY" href="$5">$6</a>
<a style="$SITE_LINK_4_DISPLAY" href="$7">$8</a>
<a style="$SITE_LINK_5_DISPLAY" href="$9">${10}</a>
</div>
</div>
</header>
EOF
fi

if [ "$CREATE_FOOTER" = "true" ]; then
cat << EOF > "pages/footer.html"
<footer>
<p>Made with <a href="https://codeberg.org/tukain/blog.sh">blog.sh</a></p>
</footer>
</body>
</html>
EOF
fi

create_html() {

local OLD_IFS="$IFS"
local IFS="
"
local INSIDE_PRE=0

cat << EOF
<!DOCTYPE html>
<html lang="pt-br">
  <head>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <meta name="generator" content="blog.sh" />
    <meta name="author" content="$SITE_AUTHOR" />
    <link
      rel="icon"
      href="/assets/fav.webp"
      type="image/webp" />
    <link rel="stylesheet" href="/assets/styles.css">
    <title>$SITE_NAME</title>
  </head>
$([ -f "./pages/navbar.html" ] && cat ./pages/navbar.html)
  <main>
EOF

for LINE in $(cat $1)
do
  if [ $LINE = '```' ]; then
    if [ "$INSIDE_PRE" -eq 0 ]; then
      printf '<pre>'
      INSIDE_PRE=1
    else
      printf '</pre>'
      INSIDE_PRE=0
    fi
    else
      echo $LINE | sed \
        -e 's#=> \([^ ]*\) \(.*\)#<a href="\1">\2</a>#' \
        -e 's#=> \(.*\)#<a href="\1">\1</a>#' \
        -e 's/^### \(.*\)/<h3>\1<\/h3>/' \
        -e 's/^## \(.*\)/<h2>\1<\/h2>/' \
        -e 's/^# \(.*\)/<h1>\1<\/h1>/' \
        -e 's#^\* \(.*\)#<li>\1</li>#' \
        -e 's#^> \(.*\)#<blockquote><p>\1</p></blockquote>#' \
        -e 's#^---------.*$#<hr>#' \
        -e 's/$/<br><br>/g'
  fi
done

cat << EOF
  </main>
  $([ -f "./pages/footer.html" ] && cat ./pages/footer.html)
  </body>
</html>
EOF

local IFS="OLD_IFS"
}

create_capsule() {
  [ -d "assets" ] && cp -r assets public

set -- $SOCIAL_LINKS
[ -z "$1" ] || [ -z "$2" ]    && SITE_LINK_1_DISPLAY="display: none"
[ -z "$3" ] || [ -z "$4" ]    && SITE_LINK_2_DISPLAY="display: none"
[ -z "$5" ] || [ -z "$6" ]    && SITE_LINK_3_DISPLAY="display: none"
[ -z "$7" ] || [ -z "$8" ]    && SITE_LINK_4_DISPLAY="display: none"
[ -z "$9" ] || [ -z "${10}" ] && SITE_LINK_5_DISPLAY="display: none"

  cat << EOF > temp/index.gmi
# $SITE_NAME
## $SITE_NOTE
$SITE_DESCRIPTION

$([ "$LATEST_POSTS_TEXT" ] && echo "## $LATEST_POSTS_TEXT")
```
if [ "$LATEST_POSTS_TEXT" ]; then
  for FILE in $(ls -1 content | head -n5 | sort -r);
  do
    post_dates
    printf "=> /log/posts/$POST_YEAR/$POST_MONTH/$POST_DAY/$(slug_basename) "
    printf "($POST_DAY/$POST_MONTH/$POST_YEAR)\t"
    printf "$(basename "$(echo $FILE | awk -F'[0-9]{4}-[0-9]{2}-[0-9]{2}-[0-9]{2}-' '{print $2}' | tr '-' ' ')" .gmi)\n"
  done
fi
```

$([ "$SOCIAL_LINKS" ] && echo "## Social Media")
=> $1 $2
=> $3 $4
=> $5 $6
=> $7 $8
=> $9 ${10}
EOF

  for FILE in $(ls ./content)
  do
    post_dates
    OUT_DIR_BASENAME=$(slug_basename)
    OUT_DIR="temp/log/posts/$POST_YEAR/$POST_MONTH/$POST_DAY/$OUT_DIR_BASENAME"
    OUT_FILE="$OUT_DIR/index.gmi"
    OUT_DIR_HTML="public/log/posts/$POST_YEAR/$POST_MONTH/$POST_DAY/$OUT_DIR_BASENAME"
    OUT_FILE_HTML="$OUT_DIR_HTML/index.html"
    mkdir -p $OUT_DIR $OUT_DIR_HTML

    cat << EOF > $OUT_FILE
### $POST_DAY/$POST_MONTH/$POST_YEAR

$(cat ./content/$FILE)
EOF

  create_html $OUT_FILE > $OUT_FILE_HTML
  done

  for FILE in $(ls temp/*.gmi)
  do
    create_html $FILE > ./public/$(basename $FILE .gmi).temp
    cat ./public/$(basename $FILE .gmi).temp | sed 's/\.gmi/\.html/g' > ./public/$(basename $FILE .gmi).html
    rm ./public/$(basename $FILE .gmi).temp
  done

if [ "$SITE_FEED" = "true" ]; then
cat << EOF > ./public/rss.xml
<?xml version="1.0" encoding="UTF-8" ?>
<rss version="2.0">
  <channel>
    <title>$SITE_NAME</title>
    <link>$SITE_URL</link>
    <description>RSS Feed of: $SITE_NAME</description>
EOF
fi

  cat << EOF > temp/log/index.gmi
# Blog

EOF

  for FILE in $(ls ./content | sort -r)
  do
    post_dates
    POST_BASENAME=$(slug_basename)
    POST_URL="/log/posts/$POST_YEAR/$POST_MONTH/$POST_DAY/$POST_BASENAME/"
    POST_TITLE="($POST_DAY/$POST_MONTH/$POST_YEAR)\t$(basename "$(echo $FILE \
      | awk -F'[0-9]{4}-[0-9]{2}-[0-9]{2}-[0-9]{2}-' '{print $2}' \
      | tr '-' ' ')" .gmi)"
    printf "=> $POST_URL $POST_TITLE\n" >> temp/log/index.gmi

    if [ "$SITE_FEED" = "true" ]; then
      cat << EOF >> ./public/rss.xml
    <item>
      <title>$(echo $POST_TITLE | sed 's/\\t/\t/g')</title>
      <link>$SITE_URL$POST_URL</link>
      <guid>$SITE_URL$POST_URL</guid>
      <pubDate>$(date '+%a, %d %b %Y %T GMT' --date=$POST_YEAR-$POST_MONTH-$POST_DAY)</pubDate>
    </item>
EOF
    fi

    done

  [ "$SITE_FEED" = "true" ] && printf "\n \n=> /rss.xml RSS\n" >> temp/log/index.gmi

  create_html temp/log/index.gmi | sed \
    -e 's/\t/<spam style="display: inline-block; width: 20px"><\/spam>/g' \
    -e "s/<a href=\"\/$BLOG_DIR\/posts/<a class=\"button blog_entry\" href=\"\/$BLOG_DIR\/posts/g" > public/log/index.html

  if [ "$SITE_FEED" = "true" ]; then
cat << EOF >> ./public/rss.xml
  </channel>
</rss>
EOF
fi

rm -rf temp

}

new_post() {
  [ -z "$EDITOR" ] && EDITOR=vim
  printf "Título do post: "
  read TITLE
  TITLE="$(echo $TITLE | tr ' ' '-')"
  $EDITOR content/"$(date '+%Y-%m-%d')-000-$TITLE"
}

version() {
  printf "\033[32mblog.sh \033[34m(v0.0.5)\033[0m\n"
}

case "$INPUT" in
  "create") create_capsule;;
  "version") version;;
  "new") new_post;;
  *) cat << EOF

Usage: blog.sh <command>

version - shows version number
create  - create the website
new     - new post

EOF
;;
esac
