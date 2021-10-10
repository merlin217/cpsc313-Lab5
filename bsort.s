main:
    irmovq  0x3000, %rsp    # init stack pointer
    irmovq 5, %rdi          # rdi = nelems
    irmovq  $array, %rsi    # rsi = &array 
    call bsort
    halt

bsort:
    pushq   %r8             # save values in r8, r9
    pushq   %r9         
    rrmovq  %rdi, %r8       # r8 = nelems
    rrmovq  %rsi, %r9       # r9 = &array

whileloop:
    xorq    %rax, %rax      # nswaps = 0
    irmovq  1, %rcx         # i = 1
forloop:
    rrmovq  %r8, %r10       # r10 = nelems
    subq    %rcx, %r10      # nelems - i                 [3 bub]
    irmovq  8, %r10         #
    jle endloop             # if i >= nelems, end loop   [2 bub]
    mulq    %rcx, %r10      # r10 = 8*i                  [1 bub]
    addq    %r9, %r10       #                            [3 bub]
    mrmovq  0(%r10), %r11   # r11 = array[i]             [3 bub]
    mrmovq  -8(%r10), %rdx  # rdx = array[i-1]           
    subq    %r11, %rdx      #                            [3 bub]
    jle noswap              # if array[i-1] <= array[i], no swap   [2 bub]
    irmovq  8, %rdx         
    rrmovq  %r10, %rsi      
    rrmovq  %r10, %rdi      # a = &array[i]              
    subq    %rdx, %rsi      # b = &array[i-1]            [2 bub]

    # swap
    pushq   %r8             # save value in r8
    rrmovq  %rdi, %r10      # r10 = a 
    rrmovq  %rsi, %r11      # r11 = b                    [1 bub]
    mrmovq  0(%r10), %r8    # r8 = *a                    [1 bub]
    pushq   %r9             # save value in r9
    mrmovq  0(%r11), %r9    # r9 = *b
    rmmovq  %r8, 0(%r11)    # *b = r8                    [1 bub]
    rmmovq  %r9, 0(%r10)    # *a = r9                    [1 bub]

    irmovq  1, %r10
    popq    %r9             # restore r8 from stack
    addq    %r10, %rax      # nswaps++                 # [2 bub]
    popq    %r8             # restore r9 from stack
noswap:
    irmovq  1, %rdx                                 
    addq    %rdx, %rcx      # i++                        [3 bub]
    jmp forloop



endloop:
    andq    %rax, %rax      
    jne whileloop           # if nswaps != 0, jump      [2 bub]

    popq    %r9
    popq    %r8             # restore values in r8, r9  [3 bub]
    ret

.pos 0x1000
array:
    .quad 5
    .quad 3
    .quad 1
    .quad 5
    .quad 3