
#define C_SYMBOL_NAME(name) name
#define C_LABEL(name) name##:
#define ASM_SIZE_DIRECTIVE(name) .size name,.-name;
#define ALIGNARG(log2) 1<<log2
	
    .globl C_SYMBOL_NAME(mcount)
    .type C_SYMBOL_NAME(mcount), @function
    .align ALIGNARG(4)
C_LABEL(mcount)
    /* Allocate space for 7 registers.  */
    subq    $56,%rsp
    movq    %rax,(%rsp)
    movq    %rcx,8(%rsp)
    movq    %rdx,16(%rsp)
    movq    %rsi,24(%rsp)
    movq    %rdi,32(%rsp)
    movq    %r8,40(%rsp)
    movq    %r9,48(%rsp)

    /* Setup parameter for _mcount_internal.  */
    /* selfpc is the return address on the stack.  */
    movq    56(%rsp),%rsi
    /* Get frompc via the frame pointer.  */
    movq    8(%rbp),%rdi
#ifdef PIC
    call C_SYMBOL_NAME(__mcount_internal2)@PLT
#else
    call C_SYMBOL_NAME(__mcount_internal2)
#endif
    /* Pop the saved registers.  Please note that `mcount' has no
       return value.  */
    movq    48(%rsp),%r9
    movq    40(%rsp),%r8
    movq    32(%rsp),%rdi
    movq    24(%rsp),%rsi
    movq    16(%rsp),%rdx
    movq    8(%rsp),%rcx
    movq    (%rsp),%rax
    addq    $56,%rsp
    ret

    ASM_SIZE_DIRECTIVE(C_SYMBOL_NAME(mcount))

#undef mcount
//weak_alias (_mcount, mcount)

    .globl C_SYMBOL_NAME(__fentry__)
    .type C_SYMBOL_NAME(__fentry__), @function
    .align ALIGNARG(4)
C_LABEL(__fentry__)
    /* Allocate space for 7 registers.  */
    subq    $64,%rsp
    movq    %rax,(%rsp)
    movq    %rcx,8(%rsp)
    movq    %rdx,16(%rsp)
    movq    %rsi,24(%rsp)
    movq    %rdi,32(%rsp)
    movq    %r8,40(%rsp)
    movq    %r9,48(%rsp)

    /* Setup parameter for __mcount_internal.  */
    /* selfpc is the return address on the stack.  */
    movq    64(%rsp),%rsi
    /* caller is the return address above it */
    movq    72(%rsp),%rdi
#ifdef PIC
    call C_SYMBOL_NAME(__mcount_internal2)@PLT
#else
    call C_SYMBOL_NAME(__mcount_internal2)
#endif
    /* Pop the saved registers.  Please note that `__fentry__' has no
       return value.  */
    movq    48(%rsp),%r9
    movq    40(%rsp),%r8
    movq    32(%rsp),%rdi
    movq    24(%rsp),%rsi
    movq    16(%rsp),%rdx
    movq    8(%rsp),%rcx
    movq    (%rsp),%rax
    addq    $64,%rsp
    ret

    ASM_SIZE_DIRECTIVE(C_SYMBOL_NAME(__fentry__))
