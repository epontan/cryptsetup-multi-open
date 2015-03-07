PREFIX = /usr/local

INCS =
LIBS =
CFLAGS = ${DEBUG} -Wall -Os ${INCS} -DVERSION=\"${VERSION}\"
LDFLAGS = ${DEBUG} ${LIBS}
CC = cc
LD = ${CC}

VERSION = $$(git describe)
BIN = cryptsetup-multi-open
SRC = cryptsetup-multi-open.c
OBJ = ${SRC:.c=.o}

all: options ${BIN}

options:
	@echo ${BIN} build options:
	@echo "CFLAGS   = ${CFLAGS}"
	@echo "LDFLAGS  = ${LDFLAGS}"
	@echo "CC       = ${CC}"
	@echo "LD       = ${LD}"

${BIN}: ${OBJ}
	@echo LD $@
	@${LD} -o $@ ${OBJ} ${LDFLAGS}
	@if [ -z "${DEBUG}" ]; then echo "Stripping $@"; strip $@; fi

.c.o:
	@echo CC $@
	@${CC} -c ${CFLAGS} $<

debug: DEBUG = -ggdb
debug: all

clean:
	@echo cleaning
	@rm -rf ${BIN} ${OBJ} ${BIN}-${VERSION}*

dist: clean
	@echo creating dist tarball
	@mkdir -p ${BIN}-${VERSION}
	@cp -R examples/ LICENSE Makefile README.md ${SRC} ${BIN}-${VERSION}
	@sed -i "/^VERSION *=/s/=.*/= ${VERSION}/" ${BIN}-${VERSION}/Makefile
	@tar -cf ${BIN}-${VERSION}.tar ${BIN}-${VERSION}
	@gzip ${BIN}-${VERSION}.tar
	@rm -rf ${BIN}-${VERSION}
	@md5sum ${BIN}-${VERSION}.tar.gz

install: all
	@echo installing executable file to ${DESTDIR}${PREFIX}/bin
	@mkdir -p ${DESTDIR}${PREFIX}/bin
	@cp -f ${BIN} ${DESTDIR}${PREFIX}/bin
	@chmod 755 ${DESTDIR}${PREFIX}/bin/${BIN}

uninstall:
	@echo removing executable file from ${DESTDIR}${PREFIX}/bin
	@rm -f ${DESTDIR}${PREFIX}/bin/${BIN}

.PHONY: all debug clean dist install uninstall
