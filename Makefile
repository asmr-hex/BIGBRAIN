PACKAGE = BIGBRAIN
VERSION = 0.0.0



BUILD_DIR        = lib
HEADER_DIR       = include
SOURCE_DIR       = src
INSTALL_BASE_DIR = /usr/local


CC       = g++
CC_FLAGS = -fPIC -Wall
LD_FLAGS = -dynamiclib
INCLUDE  = -I $(HEADER_DIR)


#  recursive wildcard function
rwildcard=$(foreach d,$(wildcard $1*),$(call rwildcard,$d/,$2)$(filter $(subst *,%,$2),$d))


HEADERS     = $(call rwildcard, $(HEADER_DIR)/, *.hpp)
SOURCE      = $(call rwildcard, $(SOURCE_DIR)/, *.cpp)
LIB_HEADERS = $(call rwildcard, $(SOURCE_DIR)/, *.hpp)
EXTERN_LIBS =
DIST_ETC    = Makefile README.md
DIST        = $(HEADERS) $(LIB_HEADERS) $(LIB_SOURCE) $(DIST_ETC)


TARGET_EXT = .dylib
TARGET     = lib$(PACKAGE)$(TARGET_EXT)

.PHONY: all clean install uninstall

all: $(TARGET)

$(TARGET): $(patsubst %.cpp, %.o, $(SOURCE))
	@echo Linking...
	mkdir $(BUILD_DIR)
	$(CC) $(LD_FLAGS) $(CC_FLAGS) $^ $(EXTERN_LIBS) -o $(patsubst %,$(BUILD_DIR)/%, $(TARGET))

%.o : %.cpp
	@echo Compiling...
	$(CC) -MD -c $(INCLUDE) $< -o $(patsubst %.cpp, %.o, $<)


install: $(BUILD_DIR)/$(TARGET)
	mkdir -p $(INSTALL_BASE_DIR)/include/$(PACKAGE)
	cp -R include/$(PACKAGE)/* $(INSTALL_BASE_DIR)/include/$(PACKAGE)
	mkdir -p $(INSTALL_BASE_DIR)/lib
	cp $(BUILD_DIR)/$(TARGET) $(INSTALL_BASE_DIR)/lib

uninstall:
	rm -r $(INSTALL_BASE_DIR)/include/$(PACKAGE)
	rm $(INSTALL_BASE_DIR)/lib/$(TARGET)


clean: 
	rm -rf $(call rwildcard, src/, *.d *.o) $(BUILD_DIR)


