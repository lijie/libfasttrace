#include <stdio.h>
#include <execinfo.h>
#include "fast_trace.h"

#define	MAX_ADDR_COUNT 256

static struct check_info addr[MAX_ADDR_COUNT];
static int addrpt = 0;
static int enable_check = 0;
static int check_count = 0;
static int check_interval = 1;
static int logfd = 2;
static void (*memory_checker)(void) = NULL;

void fast_trace_enable_check()
{
	enable_check = 1;
}

void fast_trace_disable_check()
{
	enable_check = 0;
}

void fast_trace_set_memory_checker(void (*fn)(void))
{
	memory_checker = fn;
}

void fast_trace_set_check_interval(int n)
{
	check_interval = n;
}

void fast_trace_set_log_fd(int fd)
{
	logfd = fd;
}

void __mcount_internal2(void *pc, unsigned long selfpc)
{
#if 0
	void *array[2];
	int size;
	char **strings;
	int i;
	
	size = backtrace(array, 2);
	strings = backtrace_symbols(array, size);

	for (i = 0; i < size; i++) {
		printf("symbol: %s\n", strings[i]);
	}
	free(strings);
#endif

	if (!enable_check || memory_checker == NULL)
		return;
	
	struct check_info *curr = &addr[addrpt++];
	addrpt = addrpt & (MAX_ADDR_COUNT - 1);

	curr->addr = (unsigned long)pc;
	curr->checked = 0;

      	check_count++;
	if (check_count < check_interval)
		return;

	memory_checker();
	check_count = 0;
	curr->checked = 1;
}

size_t fast_trace_copy_addr_log(unsigned long *a, size_t count)
{
	int i = 0;
	int j = 0;
	for (i = addrpt - 1; i >= 0 && j < count; i--,j++) {
		// dprintf(logfd, "addr %lx\n", addr[i]);
		a[j] = addr[i].addr;
	}

	for (i = MAX_ADDR_COUNT - 1; i <= addrpt && j < count; i--, j++) {
		// dprintf(logfd, "addr %lx\n", addr[i]);
		a[j] = addr[i].addr;
	}
	return (size_t)j;
}

void _mcleanup()
{
	// do nothing
}

void __monstartup()
{
	// do nothing
}
