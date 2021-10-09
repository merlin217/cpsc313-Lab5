main:
    irmovq  0x3000, %rsp
    irmovq 5, %rdi
    irmovq  $array, %rsi
    call bsort
    halt

swap:
    pushq   %r8
    pushq   %r9
    rrmovq  %rdi, %r10  
    mrmovq  0(%r10), %r8    
    rrmovq  %rsi, %r11  
    mrmovq  0(%r11), %r9    
    rmmovq  %r9, 0(%r10)    
    rmmovq  %r8, 0(%r11)    
    popq    %r9
    popq    %r8
    ret

bsort:
    pushq   %r8
    pushq   %r9
    rrmovq  %rdi, %r8   
    rrmovq  %rsi, %r9   

whileloop:
    xorq    %rax, %rax  
    irmovq  1, %rcx     
forloop:
    rrmovq  %r8, %r10   
    subq    %rcx, %r10  
    jle endloop     
    irmovq  8, %r10     
    mulq    %rcx, %r10  
    addq    %r9, %r10   
    mrmovq  0(%r10), %r11   
    mrmovq  -8(%r10), %rdx  
    subq    %r11, %rdx  
    jle noswap      
    rrmovq  %r10, %rdi  
    rrmovq  %r10, %rsi  
    irmovq  8, %rdx 
    subq    %rdx, %rsi  
    call    swap
    irmovq  1, %r10
    addq    %r10, %rax  
noswap:
    irmovq  1, %rdx
    addq    %rdx, %rcx  
    jmp forloop

endloop:
    andq    %rax, %rax
    jne whileloop

    popq    %r9
    popq    %r8
    ret

.pos 0x1000
array:
    .quad 5
    .quad 3
    .quad 1
    .quad 5
    .quad 3