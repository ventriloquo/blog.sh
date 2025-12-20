#!/bin/sh

INPUT=$1 # DON'T CHANGE THIS

SITE_NAME="foo"
SITE_URL="https://foo.bar"
SITE_LANG="en-us"
SITE_AUTHOR="bar"
SITE_NOTE="You could've just used jekyll or Hugo, you know that, right?"
SITE_DESCRIPTION="Here's a description. I know, pretty empty, eh?"
SITE_FAVICON_NAME="fav"
SITE_FAVICON_TYPE="webp"

create_site() {
  command -v smu >/dev/null 2>&1 || {
    printf "\033[31mERROR: smu is not installed!\033[0m\n"
    printf "Please install it from: "
    printf "\033[34mhttps://git.codemadness.org/smu/\033[0m\n"
    exit 1
  }
  mkdir -p "content"
  mkdir -p "assets"
  mkdir -p "pages"
  mkdir -p "public"
  touch ".site"
  cat << EOF > "pages/head.html"
<!DOCTYPE html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<meta http-equiv="Content-Language" content="$SITE_LANG" />
<meta name="generator" content="blog.sh" />
<meta name="author" content="$SITE_AUTHOR" />
<meta name="description" content="$SITE_DESCRIPTION" />
<meta name="viewport" content="width=device-width, initial-scale=1">
<link
  rel="icon"
  href="/assets/$SITE_FAVICON_NAME.$SITE_FAVICON_TYPE"
  type="image/$SITE_FAVICON_TYPE" />
<link href="/assets/styles.css" rel="stylesheet">
<title>$SITE_NAME</title>
</head>
<body>
EOF

# Links list: [URL NAME]
set -- https://neocities.org/site/tukainpng Neocities \
       https://codeberg.org/tukain Codeberg \
       https://github.com/ventriloquo Github

# If the [URL NAME] pair is not complete, the link will not be visible
[ -z "$1" ] || [ -z "$2" ]    && SITE_LINK_1_DISPLAY="display: none"
[ -z "$3" ] || [ -z "$4" ]    && SITE_LINK_2_DISPLAY="display: none"
[ -z "$5" ] || [ -z "$6" ]    && SITE_LINK_3_DISPLAY="display: none"
[ -z "$7" ] || [ -z "$8" ]    && SITE_LINK_4_DISPLAY="display: none"
[ -z "$9" ] || [ -z "${10}" ] && SITE_LINK_5_DISPLAY="display: none"

cat << EOF > "pages/navbar.html"
<header>
<nav>
<div class="home_link">
<a class="text" href="/">Início</a>
</div>
<div id="nav_list" class="nav_items">
<a style="$SITE_LINK_1_DISPLAY" href="$1">$2</a>
<a style="$SITE_LINK_2_DISPLAY" href="$3">$4</a>
<a style="$SITE_LINK_3_DISPLAY" href="$5">$6</a>
<a style="$SITE_LINK_4_DISPLAY" href="$7">$8</a>
<a style="$SITE_LINK_5_DISPLAY" href="$9">${10}</a>
</div>
<div class="nav_items">
<a href="/blog.html">Blog</a>
</div>
<button
  popovertarget="nav_menu"
  popovertargetaction="toggle"
  class="nav_menu">Menu</button>
</nav>
<div popover="" id="nav_menu">
<a style="margin: 0;
  padding: 10px 20px;
  color: var(--background);
  background-color: var(--accent);
  text-align: center"
  href="/blog.html">Blog</a>
<hr style="border-color: var(--accent)">
<a style="$SITE_LINK_1_DISPLAY" href="$1">$2</a>
<a style="$SITE_LINK_2_DISPLAY" href="$3">$4</a>
<a style="$SITE_LINK_3_DISPLAY" href="$5">$6</a>
<a style="$SITE_LINK_4_DISPLAY" href="$7">$8</a>
<a style="$SITE_LINK_5_DISPLAY" href="$9">${10}</a>
</div>
</header>
<article>
EOF

cat << EOF > "pages/footer.html"
</article>
<footer>
<p>Made with <a href="https://codeberg.org/tukain/blog.sh">blog.sh</a></p>
</footer>
</body>
EOF

cat README.md > "content/1970-01-01-deleteme.md"

}

build_site() {
  [ ! -f ".site" ] && echo "You're not inside the site directory!" && exit 1
  rm -rf ./public
  mkdir -p public/posts

  for FILE in $(ls ./content)
  do
    OUT_FILE="public/posts/$(basename $FILE .md).html"
    cat ./pages/head.html                                     >  $OUT_FILE
    cat ./pages/navbar.html                                   >> $OUT_FILE
    printf "<time>$(echo $FILE | awk -F'-' '{print $3}')/"    >> $OUT_FILE
    printf "$(echo $FILE | awk -F'-' '{print $2}')/"          >> $OUT_FILE
    printf "$(echo $FILE | awk -F'-' '{print $1}')</time>\n"  >> $OUT_FILE
    smu ./content/"$FILE"                                     >> $OUT_FILE
    cat ./pages/footer.html                                   >> $OUT_FILE
  done

  cat ./pages/head.html > index.html
  cat ./pages/navbar.html >> index.html
  echo "<h1>$SITE_NAME</h1>" >> index.html
  [ "$SITE_NOTE" ]        && echo "<h4><i>$SITE_NOTE</i></h4>"  >> index.html
  [ "$SITE_DESCRIPTION" ] && echo "<p>$SITE_DESCRIPTION</p>"    >> index.html
  cat ./pages/footer.html >> index.html

  cat ./pages/head.html > blog.html
  cat ./pages/navbar.html >> blog.html

  printf "<h2>" >> blog.html
  printf "Posts" >> blog.html
  printf "<small style='margin-left: calc(100%% - 8.5ch)'>" >> blog.html
  printf "<a href='/rss.xml'>RSS</a>" >> blog.html
  printf "</small>" >> blog.html
  printf "</h2>" >> blog.html
  printf "<table><tbody>" >> blog.html

  for PAGE in $(ls -1 ./public/posts | sort -r | tr '\n' ' ')
  do
    printf "<tr class='blog_item'>"                     >> blog.html
    printf "<td style='padding-right: .5em'>"           >> blog.html
    printf "$(echo $PAGE | awk -F'-' '{print $3}')/"    >> blog.html
    printf "$(echo $PAGE | awk -F'-' '{print $2}')/"    >> blog.html
    printf "$(echo $PAGE | awk -F'-' '{print $1}')"     >> blog.html
    printf "</td><td><a href=\"/posts/$PAGE\">"         >> blog.html
    printf "$(grep '<h1>' ./public/posts/"$PAGE" \
            | head -n 1 \
            | sed -e 's/<h1>//' -e 's/<\/h1>/\n/' )"    >> blog.html
    printf "</a></td>" >> blog.html
    printf "</tr>" >> blog.html
  done

  printf "</tbody></table>" >> blog.html
  cat ./pages/footer.html >> blog.html
  mv *.html public
  cp -r ./assets ./public
}

build_rss() {

cat << EOF > ./public/rss.xml
<?xml version="1.0" encoding="UTF-8" ?>
<rss version="2.0">
<channel>
<title>$SITE_NAME</title>
<link>$SITE_URL</link>
<description>$SITE_DESCRIPTION</description>
EOF

for PAGE in $(ls -1 ./public/posts | sort -r | tr '\n' ' ')
do
  echo "<item>" >> ./public/rss.xml
  echo "<title>$(grep '<h1>' ./public/posts/"$PAGE" \
               | tr '<>/' '\n' \
               | head -n3 \
               | tail -n1 )</title>" >> ./public/rss.xml
  echo "<link>$SITE_URL/$PAGE</link>" >> ./public/rss.xml
  echo "<id>$SITE_URL/$PAGE</id>" >> ./public/rss.xml
  echo "<pubDate>$(date '+%a, %d %b %Y %T GMT' --date=$(basename $PAGE .html \
                 | awk -F'-' '{print $1 "-" $2 "-" $3}'))</pubDate>" >> ./public/rss.xml
  echo "</item>" >> ./public/rss.xml
done

cat << EOF >> ./public/rss.xml
</channel>
</rss>
EOF

}

version() {
  printf "\033[32mblog.sh \033[34m(v0.0.2)\033[0m\n"
}

case "$INPUT" in
  "build") build_site && build_rss;;
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
