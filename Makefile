all:
	./blog.sh create
	./blog.sh build

clean:
	rm -rf public content pages
