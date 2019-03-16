## about this Makefile:
##   SDL2 is a dependency, this Makefile asumes it's available
##   directly for the compiler and linker.
##   if that's not the case, please fill the SDL_info.mk file
##   with the right paths

include SDL_info.mk

CPP	:= g++
CPP_FLAGS := -fPIC -shared -std=c++17 -Wall -Wextra -O3

ROOT	:= .
LIBDIR	:= $(ROOT)/lib
INCDIR	:= $(ROOT)/include
SRCDIR	:= $(ROOT)/src
OBJDIR	:= $(ROOT)/obj

SRC		:= $(notdir $(wildcard $(SRCDIR)/*.cpp ))
OBJ		:= $(addprefix $(OBJDIR)/, $(patsubst %.cpp, %.o, $(SRC)))
LIBRARIES	:= -lm -lSDL2main


ifeq ($(OS),Windows_NT)
	CPP_FLAGS	+= -D WINDOWS
	TARGET		:= libEngine.dll
else
	UNAME_S	:= $(shell uname -s)
	ifeq ($(UNAME_S),Linux)
		CPP_FLAGS	+= -D LINUX
		TARGET	:= libEngine.so
	else
		CPP_Flags	+= -D MACOS
		TARGET	:= libEngine.dylib
	endif
endif

.PHONY : clean directories link build

build: directories link

directories:
	@mkdir -p $(OBJDIR)
	@mkdir -p $(LIBDIR)

clean:
	$(RM) -r $(OBJDIR)
	$(RM) -r $(LIBDIR)

$(OBJDIR)/%.o : $(SRCDIR)/%.cpp
	$(CPP) $(CPP_FLAGS) -I$(INCDIR) -I$(SDL_INCLUDE) -L$(SDL_LIB) -c -o $@ $<

link: $(OBJ)
	$(CPP) $(CPP_FLAGS) -I$(INCDIR) -I$(SDL_INCLUDE) -L$(SDL_LIB) $^ -o $(LIBDIR)/$(TARGET) $(LIBRARIES) -lSDL2
