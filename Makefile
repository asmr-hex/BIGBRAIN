PACKAGE = BIGBRAIN
VERSION = 0.0.0

# compiler: gcc for C; g++ for C++
CC       = g++
CC_FLAGS = -fPIC -Wall
LD_FLAGS = -dynamiclib
INC      = -I include

BUILD_DIR = lib

PREFIX = /usr/local

# define recursive wildcard function
rwildcard=$(foreach d,$(wildcard $1*),$(call rwildcard,$d/,$2)$(filter $(subst *,%,$2),$d))


HEADERS     = $(call rwildcard, include/, *.hpp)
LIB_HEADERS = $(call rwildcard, src/, *.hpp)
LIB_SOURCE  = $(call rwildcard, src/, *.cpp)
EXTERN_LIBS =
DIST_ETC    = Makefile README.md
DIST        = $(HEADERS) $(LIB_HEADERS) $(LIB_SOURCE) $(DIST_ETC)

LIB_EXT = .dylib

.PHONY: all clean install uninstall

all: $(PACKAGE)$(LIB_EXT)

$(PACKAGE)$(LIB_EXT): $(patsubst %.cpp, %.o, $(LIB_SOURCE))
	@echo Linking...
	mkdir $(BUILD_DIR)
	$(CC) $(LD_FLAGS) $(CC_FLAGS) $^ $(EXTERN_LIBS) -o $(patsubst %,$(BUILD_DIR)/lib%$(LIB_EXT), $(PACKAGE))

%.o : %.cpp
	@echo Compiling...
	$(CC) -MD -c $(INC) $< -o $(patsubst %.cpp, %.o, $<)


install: $(BUILD_DIR)/lib$(PACKAGE)$(LIB_EXT)
	mkdir -p $(PREFIX)/include/$(PACKAGE)
	cp -R include/$(PACKAGE)/* $(PREFIX)/include/$(PACKAGE)
	mkdir -p $(PREFIX)/lib
	cp $(BUILD_DIR)/lib$(PACKAGE)$(LIB_EXT) $(PREFIX)/lib

uninstall:
	rm -r $(PREFIX)/include/$(PACKAGE)
	rm $(PREFIX)/lib/lib$(PACKAGE)$(LIB_EXT)


clean: 
	rm -rf $(call rwildcard, src/, *.d *.o) $(BUILD_DIR)


