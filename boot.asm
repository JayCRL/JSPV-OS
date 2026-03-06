[ORG 0x7c00]        ; 告诉编译器程序加载到 0x7c00
[SECTION .text]
[BITS 16]
global _start

_start:
    ; 1. 立即关中断并初始化段寄存器
    cli
    xor ax, ax
    mov ds, ax
    mov es, ax
    mov ss, ax
    mov sp, 0x7c00  ; 设置栈顶到程序下方，安全区域
    sti

    ; 2. 设置视频模式（清屏/80x25 文本模式）
    mov ax, 0x0003
    int 0x10

    ; 3. 打印字符串
    mov si, msg

print_loop:
    lodsb          ; 取 [ds:si] 到 al
    or al, al      ; 检查是否为 0
    jz halt

    mov ah, 0x0e   ; BIOS 电传输出
    mov bx, 0x0007 ; 页号0，黑底白字
    int 0x10
    jmp print_loop

halt:
    hlt            ; 处理器暂停，比 jmp $ 更省 CPU
    jmp halt

msg:
    db "Hello, Welcome To JSPV-OS!", 10, 13, 0

; 填充至 512 字节
times 510 - ($ - $$) db 0
dw 0xaa55          ; 引导标志