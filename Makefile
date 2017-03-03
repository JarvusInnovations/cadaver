# cadaver Makefile: generated from Makefile.in

PACKAGE = cadaver
VERSION = 0.23.3

SHELL = /bin/sh


# Installation paths.
prefix = /usr/local
exec_prefix = ${prefix}
bindir = ${exec_prefix}/bin
mandir = ${datarootdir}/man
man1dir = $(mandir)/man1
datarootdir = ${prefix}/share
datadir = $(prefix)/share
docdir = $(prefix)/doc/cadaver

# intl stuff
localedir = $(datadir)/locale
gnulocaledir = $(prefix)/share/locale
gettextsrcdir = $(prefix)/share/gettext
aliaspath = $(localedir):.

# Build paths
top_srcdir = .
top_builddir = .


# Toolchain settings.
CC = gcc
INCLUDES = -I$(top_srcdir)/src
CPPFLAGS = -DHAVE_CONFIG_H -I$(top_builddir) -I$(top_srcdir)/lib  -no-cpp-precomp  -DLOCALEDIR=\"$(localedir)\"
CFLAGS = -g -O2 -I$(top_srcdir)/lib/neon
ALL_CFLAGS = $(CPPFLAGS) $(INCLUDES) $(CFLAGS)
LDFLAGS =  -flat_namespace
LIBS = -lreadline  -lcurses -lintl -Wl,-framework -Wl,CoreFoundation -Llib/neon -lneon  -dynamic -Wl,-search_paths_first -lkrb5 -lexpat

TARGET = $(PACKAGE)
SUBDIRS = lib/neon lib/intl
OBJECTS = src/cadaver.o src/common.o src/commands.o src/ls.o	\
	 src/cmdline.o src/options.o src/utils.o src/edit.o \
	src/version.o src/search.o 
LIBOBJS = lib/basename.o lib/dirname.o lib/rpmatch.o lib/yesno.o	\
	lib/glob.o lib/getpass.o lib/tempname.o lib/mkstemp.o \
	 ${LIBOBJDIR}lib/netrc$U.o
ALLOBJS = $(OBJECTS) $(LIBOBJS)

# Installation programs
INSTALL_PROGRAM = ${INSTALL}
INSTALL_DATA = ${INSTALL} -m 644
INSTALL = /usr/local/opt/coreutils/libexec/gnubin/install -c

all: $(TARGET)

.PHONY: subdirs install clean distclean

$(TARGET): $(ALLOBJS) subdirs
	$(CC) $(LDFLAGS) -o $(TARGET) $(ALLOBJS) $(LIBS)

.c.o:
	$(CC) $(ALL_CFLAGS) -o $@ -c $<

subdirs:
	for d in $(SUBDIRS); do (cd $$d; $(MAKE)); done

clean:
	rm -f $(OBJECTS) $(LIBOBJS) $(TARGET) *~
	for d in $(SUBDIRS); do (cd $$d; $(MAKE) clean); done

distclean: clean
	rm -f Makefile config.*
	for d in $(SUBDIRS); do (cd $$d; $(MAKE) distclean); done

install: $(TARGET) install-nls
	@echo "Creating directories..."
	$(INSTALL) -d $(DESTDIR)$(bindir)
	$(INSTALL) -d $(DESTDIR)$(man1dir)
	@echo "Installing $(TARGET) executable..."
	$(INSTALL_PROGRAM) $(TARGET) $(DESTDIR)$(bindir)/$(TARGET)
	@echo "Installing man page..."
	$(INSTALL_DATA) $(top_srcdir)/doc/cadaver.1 $(DESTDIR)$(man1dir)/cadaver.1

install-nls:
	@cd po && $(MAKE) install

Makefile: Makefile.in
	@./config.status Makefile

# Deps
src/cadaver.o: src/cadaver.c config.h src/common.h	\
	src/options.h src/cmdline.h src/commands.h src/cadaver.h
src/options.o: src/options.c config.h src/options.h src/cadaver.h src/common.h 
src/cmdline.o: src/cmdline.c src/cmdline.h src/cadaver.h lib/basename.h \
	lib/glob.h src/commands.h src/common.h
src/commands.o: src/commands.c src/commands.h src/cadaver.h \
	lib/basename.h src/options.h src/common.h
src/edit.o: src/edit.c src/cadaver.h src/options.h src/common.h
src/common.o: src/common.c src/common.h config.h
src/ls.o: src/ls.c src/commands.h src/cadaver.h config.h
src/search.o: src/search.c src/commands.h src/cadaver.h config.h
src/utils.o: src/utils.c src/utils.h src/cadaver.h config.h
src/version.o: src/version.c src/utils.h src/cadaver.h config.h
lib/netrc.o: lib/netrc.c lib/netrc.h config.h
lib/getpass.o: lib/getpass.c lib/getpass.h config.h
lib/tempname.o: lib/tempname.c config.h
lib/mkstemp.o: lib/mkstemp.c src/common.h config.h
lib/yesno.o: lib/yesno.c src/common.h config.h
