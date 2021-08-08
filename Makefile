# BubbleFishyMon with gkrellm support
# Type 'make' or 'make bubblefishymon' to build bubblefishymon
# Type 'make bubblefishymon1' to build bubblefishymon for gtk1
# Type 'make gkrellm' to build gkrellm-bfm.so for gkrellm2
# Type 'make gkrellm1' to build gkrellm-bfm.so for gkrellm

# where to install this program
PREFIX ?= /usr/local

# bubblemon configuration
EXTRA = -lX11 -lm
EXTRA += -DENABLE_DUCK
EXTRA += -DENABLE_CPU
EXTRA += -DENABLE_MEMSCREEN
EXTRA += -DENABLE_FISH
EXTRA += -DENABLE_TIME
EXTRA += -DUPSIDE_DOWN_DUCK
# EXTRA += -DKDE_DOCKAPP

# If building for Linux define the network device to monitor.
NET_DEVICE = eth0


###############################################################################
# no user serviceable parts below                                             #
###############################################################################
EXTRA += $(WMAN)

# gtk cflags and gtk lib flags
GTK_CFLAGS = $(shell gtk-config --cflags)
GTK_LIBS = $(shell gtk-config --libs)

GTK2_CFLAGS = $(shell pkg-config gtk+-2.0 --cflags)
GTK2_LIBS = $(shell pkg-config gtk+-2.0 --libs)


# optimization cflags
#CFLAGS = -O3 -Wall ${EXTRA}
CFLAGS = ${EXTRA}

# profiling cflags
# CFLAGS = -ansi -Wall -pg -O3 ${EXTRA} -DPRO
# test coverage cflags
# CFLAGS = -fprofile-arcs -ftest-coverage -Wall -ansi -g ${EXTRA} -DPRO


SHELL = sh
SRCS = fishmon.c bubblemon.c
OBJS = fishmon.o bubblemon.o
BUBBLEFISHYMON = bubblefishymon

# Some stuffs for building gkrellm-bfm
GKRELLM_SRCS = gkrellm-bfm.c
GKRELLM_OBJS = gkrellm-bfm.o
GKRELLM_BFM = gkrellm-bfm.so
LDFLAGS = -shared -Wl

CC = gcc

INSTALLMAN = -m 644

SRCS += sys_blaseball.c
OBJS += sys_blaseball.o
INSTALL = -m 755
INSTALLMAN = -m 644

all: $(BUBBLEFISHYMON)

gkrellm: clean_obj
	$(CC) -DGKRELLM2 -DGKRELLM_BFM -fPIC $(GTK2_CFLAGS) $(CFLAGS) -c $(SRCS) \
		$(GKRELLM_SRCS)
	$(CC) $(GTK2_LIBS) $(LDFLAGS) -o $(GKRELLM_BFM) $(OBJS) $(GKRELLM_OBJS)

gkrellm1: clean_obj
	$(CC) -DGKRELLM_BFM -fPIC $(GTK_CFLAGS) $(CFLAGS) -c $(SRCS) \
		$(GKRELLM_SRCS)
	$(CC) $(GTK_LIBS) $(LDFLAGS) -o $(GKRELLM_BFM) $(OBJS) $(GKRELLM_OBJS)

bubblefishymon: clean_obj
	$(CC) $(GTK2_CFLAGS) $(CFLAGS) -o $(BUBBLEFISHYMON) \
		$(LIBS) $(GTK2_LIBS) $(SRCS)

bubblefishymon1: clean_obj
	$(CC) $(GTK_CFLAGS) $(CFLAGS) -o $(BUBBLEFISHYMON) \
		$(LIBS) $(GTK_LIBS) $(SRCS)

clean_obj:
	rm -rf *.o

clean:
	rm -f bubblefishymon *.o *.bb* *.gcov gmon.* *.da *~ *.so

install: install-man
	install $(INSTALL) $(BUBBLEFISHYMON) $(DESTDIR)/$(PREFIX)/bin
install-strip: install-man
	install -s $(INSTALL) $(BUBBLEFISHYMON) $(DESTDIR)/$(PREFIX)/bin
install-man:
	install -d $(DESTDIR)/$(PREFIX)/bin $(DESTDIR)/$(PREFIX)/share/man/man1
	install $(INSTALL_MAN) doc/bubblefishymon.1 $(DESTDIR)/$(PREFIX)/share/man/man1
