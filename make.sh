#!/bin/sh

gcc -Wall -g -O2 -fPIC -c fast_trace.c -o fast_trace.o
gcc -Wall -g -O2 -fPIC -DPIC -c mcount.S -o mcount.o
ar -r libfasttrace.a fast_trace.o mcount.o
