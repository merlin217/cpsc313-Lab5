main:
    irmovq  0x3000, %rsp     # init stack pointer
    irmovq 5, %rdi           # rdi = nelems
    irmovq  $array, %rsi     # rsi = &array 
    call bsort
    halt

bsort:
    # setting constants
    pushq   %r8              # save regs for caller         [3 bub from call]
    rrmovq  %rdi, %r8        # r8 = nelems
    pushq   %r9              #                              [2 bub]
    rrmovq  %rsi, %r9        # r9 = &array
    # increments
    pushq   %rbx             #                              [2 bub]
    irmovq  8, %rbx          
    pushq   %rbp             #                              [2 bub]
    irmovq  1, %rbp                         

whileloop: 
    rrmovq  %r8, %rdi
    rrmovq  %r9, %rcx        # rcx = &array
    xorq    %rax, %rax       # nswaps = 0
    mulq    %rbx, %rdi       # rdi = 8*nelems               [1 bub]
forloop: 
    addq    %rbx, %rcx       # rcx = &array[i] increments per loop
    subq    %rbx, %rdi       # decrement nelems             [2 bub in loop 1 only; 0 otherwise]
    jle endloop              #                              [2 bub]
    mrmovq  -8(%rcx), %rdx   # rdx = array[i-1]             
    mrmovq  0(%rcx), %r11    # r11 = array[i]               
    subq    %r11, %rdx       #                              [3 bub]
    jle forloop              # if a[i-1] <= a[i], no swap   [2 bub]

    # swap
    addq    %r11, %rdx       # restore a[i]
    rmmovq  %r11, -8(%rcx)   # a[i-1] = a[i]
    rmmovq  %rdx, 0(%rcx)    # a[i] = a[i-1]                [2 bub]
    addq    %rbp, %rax       # nswaps++

    jmp forloop

endloop:
    andq    %rax, %rax      
    jne whileloop           # if nswaps != 0, jump      [2 bub]

    popq    %rbp            # restore caller regs     
    popq    %rbx            #                           [3 bub]  
    popq    %r9             #                           [3 bub]
    popq    %r8             #                           [3 bub]
    ret


.pos 0x1000
array:
    .quad 5
    .quad 3
    .quad 1
    .quad 5
    .quad 3