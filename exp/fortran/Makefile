TARGET = test.x

FC = gfortran

FFLAGS ?= -O2 -Wall
LDFLAGS = -lm

# 源文件
SRCS = basis.f90 main.f90

OBJS = $(SRCS:.f90=.o)

all: $(TARGET)

$(TARGET): $(OBJS)
	$(FC) $(FFLAGS) -o $@ $^ $(LDFLAGS)

%.o: %.f90
	$(FC) $(FFLAGS) -c $< -o $@

clean:
	rm -f $(OBJS) $(TARGET) *.mod
