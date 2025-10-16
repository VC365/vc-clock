NAME="vc-clock"
all:
	@echo "crystal build (NEW)"
	@echo "c build"
crystal:
	@shards build --release $(NAME)
c:
	mkdir -p "bin/c"
	@gcc -O2 -s -DNDEBUG -w -lm src/main.c -o bin/c/$(NAME)  \
		$(shell pkg-config --cflags --libs gtk+-2.0 librsvg-2.0)

.PHONY: all crystal c