# change to your local directories!
PD_DIR = /Users/matthias/Pd-0.42.5-extended/pd
GEM_DIR = /Users/matthias/Gem-0.93.1
# osx only:
PD_APP_DIR = /Applications/Pd-extended.app/Contents/Resources



# build flags

UNAME := $(shell uname -s)

# Linux
ifeq ($(UNAME),Linux)
 INCLUDES = -I$(PD_DIR)/src -I. -I$(GEM_DIR)/src `pkg-config --cflags libfreenect`
 CPPFLAGS += -fPIC -DPD -O2 -funroll-loops -fomit-frame-pointer -ffast-math \
    -Wall -W -Wno-unused -Wno-parentheses -Wno-switch -g -DLINUX
 LDFLAGS =  -export_dynamic -shared
 LIBS = `pkg-config --libs libfreenect`
 EXTENSION = pd_linux
 SOURCES = pix_freenect.cc

 all: $(SOURCES:.cc=.$(EXTENSION)) $(SOURCES_OPT:.cc=.$(EXTENSION))

 %.$(EXTENSION): %.o
	gcc $(LDFLAGS) -o $*.$(EXTENSION) $*.o $(LIBS)

 .cc.o:
	g++ $(CPPFLAGS) $(INCLUDES) -o $*.o -c $*.cc

 .c.o:
	gcc $(CPPFLAGS) $(INCLUDES) -o $*.o -c $*.c

 clean:
	rm -f pix_freenect*.o
	rm -f pix_freenect*.$(EXTENSION)
endif

# OSX
ifeq ($(UNAME),Darwin)
 CPPFLAGS += -DDARWIN
 INCLUDES +=  -I$(PD_DIR)/include -I/sw/include/libfreenect -I$(GEM_DIR)/src \
    -I$(PD_DIR)/src -I$(PD_DIR) -I./
 LDFLAGS = -c -arch i386
 LIBS =  -lm -lfreenect
 EXTENSION = pd_darwin
 .SUFFIXES = $(EXTENSION)
 SOURCES = pix_freenect

 all:
	g++ $(LDFLAGS) $(INCLUDES) $(CPPFLAGS) -o $(SOURCES).o -c $(SOURCES).cc
	g++ -o $(SOURCES).$(EXTENSION) -undefined dynamic_lookup -arch i386 -dynamiclib -mmacosx-version-min=10.3 -undefined dynamic_lookup -arch i386 ./*.o -L/sw/lib -lpthread -lfreenect -L$(PD_DIR)/bin -L$(PD_DIR)
	rm -fr ./*.o
 deploy:
	mkdir build/$(SOURCES)
	./embed-MacOSX-dependencies.sh .
	mv *.dylib build/$(SOURCES)
	mv *.$(EXTENSION) build/$(SOURCES)
	cp *.pd build/$(SOURCES)
	rm -fr $(PD_APP_DIR)/extra/$(SOURCES)
	mv build/$(SOURCES) $(PD_APP_DIR)/extra/
 clean:
	rm -f $(SOURCES)*.o
	rm -f $(SOURCES)*.$(EXTENSION)
endif


distro: clean all
	rm *.o
