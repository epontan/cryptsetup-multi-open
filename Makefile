PREFIX = /usr/local

INCS =
LIBS =
CFLAGS = ${DEBUG} -Wall -Os ${INCS} -DVERSION=\"${VERSION}\"
LDFLAGS = ${DEBUG} ${LIBS}
CC = cc
LD = ${CC}

VERSION = git-$$(git rev-list -n1 --abbrev-commit HEAD)
BIN = cryptsetup-multi-open
SRC = cryptsetup-multi-open.c
OBJ = ${SRC:.c=.o}

all: ${BIN}

${BIN}: ${OBJ}
	${LD} -o $@ ${OBJ} ${LDFLAGS}
	@if [ -z "${DEBUG}" ]; then echo "Stripping $@"; strip $@; fi

.c.o:
	${CC} -c ${CFLAGS} $<

debug: DEBUG = -ggdb
debug: all

clean:
	@echo cleaning
	@rm -f ${BIN} ${OBJ}

install: all
	@echo installing executable file to ${DESTDIR}${PREFIX}/bin
	@mkdir -p ${DESTDIR}${PREFIX}/bin
	@cp -f ${BIN} ${DESTDIR}${PREFIX}/bin
	@chmod 755 ${DESTDIR}${PREFIX}/bin/${BIN}

uninstall:
	@echo removing executable file from ${DESTDIR}${PREFIX}/bin
	@rm -f ${DESTDIR}${PREFIX}/bin/${BIN}

.PHONY: all debug clean install uninstall
