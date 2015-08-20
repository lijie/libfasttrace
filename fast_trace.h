#ifndef __COMMONPRJ_SRC_UTIL_REDMCOUNT__
#define __COMMONPRJ_SRC_UTIL_REDMCOUNT__

struct check_info {
	unsigned long addr;
	int checked;
};

void fast_trace_enable_check();
void fast_trace_disable_check();
void fast_trace_set_memory_checker(void (*fn)(void));
void fast_trace_set_check_interval(int n);
size_t fast_trace_copy_addr_log(unsigned long *addr, size_t count);

#endif
