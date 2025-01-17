TARGET = test.x

CC = gcc
CFLAGS ?= -O2 -Wall -DDEBUG
LDFLAGS = -lm

SRCS = basis.c main.c
OBJS = $(SRCS:.c=.o)

all: $(TARGET)

$(TARGET): $(OBJS)
	$(CC) $(CFLAGS) -o $@ $^ $(LDFLAGS)

%.o: %.c basis.h
	$(CC) $(CFLAGS) -c $< -o $@

clean:
	rm -rf $(OBJS) $(TARGET)
