#!/bin/sh
INPUT=$1 # DON'T CHANGE THIS

################################################################################

SITE_NAME="foo"
SITE_URL="https://foo.bar"
SITE_LANG="en-us"
SITE_AUTHOR="bar"
SITE_NOTE="You could've just used jekyll or Hugo, you know that, right?"
SITE_DESCRIPTION="Here's a description. I know, pretty empty, eh?"
SITE_FAVICON_NAME="fav"
SITE_FAVICON_TYPE="webp"
BLOG_DIR="blog"
CREATE_HOMEPAGE="true"
CREATE_404="true"
CREATE_NAVBAR="true"
CREATE_FOOTER="true"
LATEST_POSTS_TEXT="Latest posts:"
SOCIAL_LINKS="https://neocities.org/site/tukainpng Neocities \
              https://codeberg.org/tukain          Codeberg \
              https://github.com/ventriloquo       Github"

################################################################################

create_site() {
  command -v smu >/dev/null 2>&1 || {
    printf "\033[31mERROR: smu is not installed!\033[0m

Please install it from:
\033[34mhttps://git.codemadness.org/smu/\033[0m\n"
    exit 1
  }

  mkdir -p content assets pages public
  touch ".site"
  cat << EOF > "pages/head.html"
<!DOCTYPE html>
<html lang="$SITE_LANG">
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
<a href="/$BLOG_DIR">Blog</a>
</div>
<button
  popovertarget="nav_menu"
  popovertargetaction="toggle"
  class="nav_menu">Menu</button>
</nav>
<div popover="" id="nav_menu">
<a style="margin: 0;
  padding: 10px 20px;
  margin: .5em 0;
  text-align: center"
  href="/$BLOG_DIR">Blog</a>
<hr style="border-color: var(--accent)">
<a style="$SITE_LINK_1_DISPLAY" href="$1">$2</a>
<a style="$SITE_LINK_2_DISPLAY" href="$3">$4</a>
<a style="$SITE_LINK_3_DISPLAY" href="$5">$6</a>
<a style="$SITE_LINK_4_DISPLAY" href="$7">$8</a>
<a style="$SITE_LINK_5_DISPLAY" href="$9">${10}</a>
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

cat README.md > "content/1970-01-01-deleteme.md"

}

build_site() {
  [ ! -f "./pages/head.html" ] && \
    echo "\033[31mERROR:\033[0m There's no \"head.html\" on the \"pages\" directory!" && \
    echo "Please, run the command \"./blog.sh create\" to make a default \"head.html\"" && \
    exit 1
  [ ! -f "./pages/navbar.html" ] && echo "\033[33mWARNING:\033[0m There's no \"navbar.html\" on the \"pages\" directory!"
  [ ! -f "./pages/footer.html" ] && echo "\033[33mWARNING:\033[0m There's no \"footer.html\" on the \"pages\" directory!"
  [ ! -f ".site" ] && echo "You're not inside the site directory!" && exit 1

  rm -rf ./public
  mkdir -p public/posts

  for FILE in $(ls ./content)
  do
    POST_YEAR=$(echo $FILE  | awk -F'-' '{print $1}')
    POST_MONTH=$(echo $FILE | awk -F'-' '{print $2}')
    POST_DAY=$(echo $FILE   | awk -F'-' '{print $3}')
    OUT_DIR_BASENAME=$(basename $(echo $FILE \
      | awk -F'[0-9]{4}-[0-9]{2}-[0-9]{2}-' '{print $2}') .md)
    OUT_DIR="public/posts/$POST_YEAR/$POST_MONTH/$POST_DAY/$OUT_DIR_BASENAME"
    OUT_FILE="$OUT_DIR/index.html"
    mkdir -p $OUT_DIR
    cat ./pages/head.html   >  $OUT_FILE
    [ -f "./pages/navbar.html" ] && cat ./pages/navbar.html >> $OUT_FILE
    echo "<main>
            <time>$POST_DAY/$POST_MONTH/$POST_YEAR</time>
            $(smu ./content/$FILE | sed 's/<a /<a target="_blank" /g')
          </main>" >> $OUT_FILE
    [ -f "./pages/footer.html" ] && cat ./pages/footer.html >> $OUT_FILE
  done

  BLOG_OUTPUT="$BLOG_DIR/index.html"
  mkdir -p $BLOG_DIR
  cat ./pages/head.html   > $BLOG_OUTPUT
  cat ./pages/navbar.html >> $BLOG_OUTPUT

  printf "<main>
          <h2>Posts<small style='margin-left: calc(100%% - 8.5ch)'><a href='/rss.xml'>RSS</a>
          </small>
          </h2>
          <table>
          <tbody>" >> $BLOG_OUTPUT

  POST_OUTPUT="./public/posts/*/*/*/*"
  for PAGE in $(ls -1d $POST_OUTPUT | sort -r | tr '\n\:' ' ')
  do
    POST_YEAR=$(echo $PAGE | awk -F'/' '{print $4}')
    POST_MONTH=$(echo $PAGE | awk -F'/' '{print $5}')
    POST_DAY=$(echo $PAGE| awk -F'/' '{print $6}')
    printf "<tr class='blog_item'>
            <td style='padding-right: .5em'>
            $POST_DAY/$POST_MONTH/$POST_YEAR
            </td><td><a href=\"$(echo $PAGE \
              | sed 's/.\/public//')/\">
            $(grep '<h1>' $PAGE/index.html \
            | head -n 1 \
            | sed -e 's/<h1>//' -e 's/<\/h1>/\n/' )
            </a></td>
            </tr>"          >> $BLOG_OUTPUT
  done

  echo "</tbody></table></main>"   >> $BLOG_OUTPUT
  cat ./pages/footer.html   >> $BLOG_OUTPUT
  mv $BLOG_DIR public
  cp -r ./assets ./public

  if [ "$CREATE_HOMEPAGE" = "true" ]; then
    cat ./pages/head.html > index.html
    cat ./pages/navbar.html >> index.html
    echo "<main><h1>$SITE_NAME</h1>" >> index.html
    [ "$SITE_NOTE" ]        && echo "<h4><i>$SITE_NOTE</i></h4>"  >> index.html
    [ "$SITE_DESCRIPTION" ] && echo "<p>$SITE_DESCRIPTION</p>"    >> index.html

    BLOG_OUTPUT="index.html"

    printf "<h3>$LATEST_POSTS_TEXT</h3>
            <table>
            <tbody>" >> $BLOG_OUTPUT

    for PAGE in $(ls -1d $POST_OUTPUT | sort -r | head -n5 | tr '\n\:' ' ')
    do
      POST_YEAR=$( echo $PAGE | awk -F'/' '{print $4}')
      POST_MONTH=$(echo $PAGE | awk -F'/' '{print $5}')
      POST_DAY=$(  echo $PAGE | awk -F'/' '{print $6}')
      printf "<tr class='blog_item'><td style='padding-right: .5em'>
              $POST_DAY/$POST_MONTH/$POST_YEAR
              </td><td>
              <a href=\"$(echo $PAGE | sed 's/.\/public//')/\">
              $(grep '<h1>' $PAGE/index.html \
              | head -n 1 \
              | sed -e 's/<h1>//' -e 's/<\/h1>/\n/')
              </a></td></tr>" >> $BLOG_OUTPUT
    done

    echo "</tbody></table>" >> $BLOG_OUTPUT
  fi

  echo "</main>" >> index.html
  cat ./pages/footer.html >> index.html
  mv index.html public

  if [ "$CREATE_404" = "true" ]; then
    cat ./pages/head.html > public/404.html
    cat ./pages/head.html > public/not_found.html
    [ -f "./pages/navbar.html" ] && cat ./pages/navbar.html >> public/404.html
    [ -f "./pages/navbar.html" ] && cat ./pages/navbar.html >> public/not_found.html

    echo "
    <main>
      <h1>404</h1>
      <h4>Not Found</h4>
    </main>" >> public/404.html

    echo "
    <main>
      <h1>404</h1>
      <h4>Not Found</h4>
    </main>" >> public/not_found.html

    [ -f "./pages/footer.html" ] && cat ./pages/footer.html >> public/404.html
    [ -f "./pages/footer.html" ] && cat ./pages/footer.html >> public/not_found.html
  fi

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

for PAGE in $(ls -1d $POST_OUTPUT | sort -r | tr '\n' ' ')
do
  POST_URL=$(echo $PAGE | sed 's/\.\/public\/posts\///')
  POST_YEAR=$(echo $PAGE | awk -F'/' '{print $4}')
  POST_MONTH=$(echo $PAGE | awk -F'/' '{print $5}')
  POST_DAY=$(echo $PAGE| awk -F'/' '{print $6}')
  echo "<item>
          <title>$(cat $PAGE/index.html \
                  | grep "<h1>" $PAGE/index.html \
                  | head -n1 \
                  | xargs \
                  | sed -e 's/<h1>//' -e 's/<\/h1>//')</title>
          <link>$SITE_URL/posts/$POST_URL/</link>
          <guid>$SITE_URL/posts/$POST_URL/</guid>
          <pubDate>$(date '+%a, %d %b %Y %T GMT' --date=$POST_YEAR-$POST_MONTH-$POST_DAY)</pubDate>
          <description><![CDATA[$(cat $PAGE/index.html | tail -n+54 | head -n-5)]]></description>
        </item>" >> ./public/rss.xml
done

cat << EOF >> ./public/rss.xml
</channel>
</rss>
EOF

}

version() {
  printf "\033[32mblog.sh \033[34m(v0.0.4)\033[0m\n"
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
