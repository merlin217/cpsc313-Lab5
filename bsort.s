main:
    irmovq  0x3000, %rsp    # init stack pointer
    irmovq 5, %rdi          # rdi = nelems
    irmovq  $array, %rsi    # rsi = &array 
    call bsort
    halt

swap:
    pushq   %r8             # save values in r8, r9 [3 bub from call, %rsp]
    pushq   %r9             # [3 bub, %rsp]
    rrmovq  %rdi, %r10      # r10 = a 
    rrmovq  %rsi, %r11      # r11 = b
    mrmovq  0(%r10), %r8    # r8 = *a [2 bub]
    mrmovq  0(%r11), %r9    # r9 = *b
    rmmovq  %r8, 0(%r11)    # *b = r8 [2 bub]
    rmmovq  %r9, 0(%r10)    # *a = r9 
    popq    %r9             
    popq    %r8             # restore values in r8, r9 [3 bub, %rsp]
    ret                     # [3 bub, %rsp] -- will cause [4 bub]

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
    subq    %rcx, %r10      # nelems - i
    jle endloop             # if i >= nelems, end loop
    irmovq  8, %r10         
    mulq    %rcx, %r10      # r10 = 8*i
    addq    %r9, %r10       
    mrmovq  0(%r10), %r11   # r11 = array[i]
    mrmovq  -8(%r10), %rdx  # rdx = array[i-1]
    subq    %r11, %rdx      
    jle noswap              # if array[i-1] <= array[i], no swap
    rrmovq  %r10, %rdi      # a = &array[i]
    rrmovq  %r10, %rsi      
    irmovq  8, %rdx 
    subq    %rdx, %rsi      # b = &array[i-1]
    call    swap            # swap(a, b)
    irmovq  1, %r10         
    addq    %r10, %rax      # nswaps++ 
noswap:
    irmovq  1, %rdx         
    addq    %rdx, %rcx      # i++
    jmp forloop



endloop:
    andq    %rax, %rax      
    jne whileloop           # if nswaps != 0, jump

    popq    %r9
    popq    %r8             # restore values in r8, r9
    ret

.pos 0x1000
array:
    .quad 5
    .quad 3
    .quad 1
    .quad 5
    .quad 3