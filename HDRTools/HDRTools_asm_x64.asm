;
;  HDRTools()
;
;  Several functions for working on HDR data, and linear to non-linear convertions.
;  Copyright (C) 2018 JPSDR
;	
;  HDRTools is free software; you can redistribute it and/or modify
;  it under the terms of the GNU General Public License as published by
;  the Free Software Foundation; either version 2, or (at your option)
;  any later version.
;   
;  HDRTools is distributed in the hope that it will be useful,
;  but WITHOUT ANY WARRANTY; without even the implied warranty of
;  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
;  GNU General Public License for more details.
;   
;  You should have received a copy of the GNU General Public License
;  along with GNU Make; see the file COPYING.  If not, write to
;  the Free Software Foundation, 675 Mass Ave, Cambridge, MA 02139, USA. 
;
;

.data

align 16

data segment align(32)

data_f_0 real4 8 dup(0.0)
data_f_1 real4 8 dup(1.0)
data_f_1048575 real4 8 dup(1048575.0)
data_f_65535 real4 8 dup(65535.0)
data_dw_1048575 dword 8 dup(1048575)
data_dw_65535 dword 8 dup(65535)
data_dw_0 dword 8 dup(0)
data_dw_128 dword 8 dup(128)
data_dw_32 dword 8 dup(32)
data_dw_8 dword 8 dup(8)
data_dw_RGB32 dword 8 dup(00FFFFFFh)

data_all_1 dword 8 dup(0FFFFFFFFh)

data_HLG_8 word 16 dup(0FF00h)
data_HLG_10 dword 8 dup(0FFC00h)
data_HLG_12 dword 8 dup(0FFF000h)
data_w_128 word 16 dup(128)
data_w_32 word 16 dup(32)
data_w_8 word 16 dup(8)

.code

;JPSDR_HDRTools_LookupRGB32_RGB32HLG proc src:dword,dst:dword,w:dword,h:dword,src_modulo:dword,dst_modulo:dword,lookup:dword
; src = rcx
; dst = rdx
; w = r8d
; h = r9d

JPSDR_HDRTools_LookupRGB32_RGB32HLG proc public frame

src_modulo equ qword ptr[rbp+48]
dst_modulo equ qword ptr[rbp+56]
lookup equ qword ptr[rbp+64]

	push rbp
	.pushreg rbp
	mov rbp,rsp
	push rdi
	.pushreg rdi
	push rsi
	.pushreg rsi
	push rbx
	.pushreg rbx
	.endprolog

	cld
	mov rsi,rcx
	mov rdi,rdx
	mov r10,src_modulo
	mov r11,dst_modulo
	mov rdx,lookup
	mov rbx,00FFFFFFh
	xor rax,rax
	
LookupRGB32_RGB32HLG_1:
	mov ecx,r8d
LookupRGB32_RGB32HLG_2:
	lodsd
	and rax,rbx
	mov eax,dword ptr[rdx+4*rax]
	stosd
	loop LookupRGB32_RGB32HLG_2
	
	add rsi,r10
	add rdi,r11
	dec r9d
	jnz short LookupRGB32_RGB32HLG_1
	
	pop rbx
	pop rsi
	pop rdi
	pop rbp
	
	ret
	
JPSDR_HDRTools_LookupRGB32_RGB32HLG endp


;JPSDR_HDRTools_LookupRGB32_RGB64HLG proc src:dword,dst:dword,w:dword,h:dword,src_modulo:dword,dst_modulo:dword,lookup:dword
; src = rcx
; dst = rdx
; w = r8d
; h = r9d

JPSDR_HDRTools_LookupRGB32_RGB64HLG proc public frame

src_modulo equ qword ptr[rbp+48]
dst_modulo equ qword ptr[rbp+56]
lookup equ qword ptr[rbp+64]

	push rbp
	.pushreg rbp
	mov rbp,rsp
	push rdi
	.pushreg rdi
	push rsi
	.pushreg rsi
	.endprolog

	cld
	mov rsi,rcx
	mov rdi,rdx
	mov r10,src_modulo
	mov r11,dst_modulo
	mov rdx,lookup
	xor rax,rax
	
LookupRGB32_RGB64HLG_1:
	mov ecx,r8d
LookupRGB32_RGB64HLG_2:
	lodsd
	mov rax,qword ptr[rdx+8*rax]
	stosq
	xor rax,rax
	loop LookupRGB32_RGB64HLG_2
	
	add rsi,r10
	add rdi,r11
	dec r9d
	jnz short LookupRGB32_RGB64HLG_1
	
	pop rsi
	pop rdi
	pop rbp
	
	ret
	
JPSDR_HDRTools_LookupRGB32_RGB64HLG endp


;JPSDR_HDRTools_LookupRGB32_RGB64HLGb proc src:dword,dst:dword,w:dword,h:dword,src_modulo:dword,dst_modulo:dword,lookup:dword
; src = rcx
; dst = rdx
; w = r8d
; h = r9d

JPSDR_HDRTools_LookupRGB32_RGB64HLGb proc public frame

src_modulo equ qword ptr[rbp+48]
dst_modulo equ qword ptr[rbp+56]
lookup equ qword ptr[rbp+64]

	push rbp
	.pushreg rbp
	mov rbp,rsp
	push rdi
	.pushreg rdi
	push rsi
	.pushreg rsi
	push rbx
	.pushreg rbx
	.endprolog

	cld
	mov rsi,rcx
	mov rdi,rdx
	mov r10,src_modulo
	mov r11,dst_modulo
	mov rdx,lookup
	mov rbx,00FFFFFFh
	xor rax,rax
	
LookupRGB32_RGB64HLGb_1:
	mov ecx,r8d
LookupRGB32_RGB64HLGb_2:
	lodsd
	and rax,rbx
	mov rax,qword ptr[rdx+8*rax]
	stosq
	xor rax,rax
	loop LookupRGB32_RGB64HLGb_2
	
	add rsi,r10
	add rdi,r11
	dec r9d
	jnz short LookupRGB32_RGB64HLGb_1
	
	pop rbx
	pop rsi
	pop rdi
	pop rbp
	
	ret
	
JPSDR_HDRTools_LookupRGB32_RGB64HLGb endp


;JPSDR_HDRTools_LookupRGB32 proc src:dword,dst:dword,w:dword,h:dword,src_modulo:dword,dst_modulo:dword,lookup:dword
; src = rcx
; dst = rdx
; w = r8d
; h = r9d

JPSDR_HDRTools_LookupRGB32 proc public frame

src_modulo equ qword ptr[rbp+48]
dst_modulo equ qword ptr[rbp+56]
lookup equ qword ptr[rbp+64]

	push rbp
	.pushreg rbp
	mov rbp,rsp
	push rdi
	.pushreg rdi
	push rsi
	.pushreg rsi
	.endprolog

	cld
	mov rsi,rcx
	mov rdi,rdx
	mov r10,src_modulo
	mov r11,dst_modulo
	mov rdx,lookup
	xor rax,rax
	
LookupRGB32_1:
	mov ecx,r8d
LookupRGB32_2:
	lodsb
	mov al,byte ptr[rdx+rax]
	stosb
	lodsb
	mov al,byte ptr[rdx+rax]
	stosb	
	lodsb
	mov al,byte ptr[rdx+rax]
	stosb
	movsb
	loop LookupRGB32_2
	
	add rsi,r10
	add rdi,r11
	dec r9d
	jnz short LookupRGB32_1
	
	pop rsi
	pop rdi
	pop rbp
	
	ret
	
JPSDR_HDRTools_LookupRGB32 endp
	

;JPSDR_HDRTools_LookupRGB32toRGB64 proc src:dword,dst:dword,w:dword,h:dword,src_modulo:dword,dst_modulo:dword,lookup:dword
; src = rcx
; dst = rdx
; w = r8d
; h = r9d

JPSDR_HDRTools_LookupRGB32toRGB64 proc public frame

src_modulo equ qword ptr[rbp+48]
dst_modulo equ qword ptr[rbp+56]
lookup equ qword ptr[rbp+64]

	push rbp
	.pushreg rbp
	mov rbp,rsp
	push rdi
	.pushreg rdi
	push rsi
	.pushreg rsi
	.endprolog

	cld
	mov rsi,rcx
	mov rdi,rdx
	mov r10,src_modulo
	mov r11,dst_modulo
	mov rdx,lookup
	xor rax,rax
	
LookupRGB32toRGB64_1:
	mov ecx,r8d
LookupRGB32toRGB64_2:
	lodsb
	mov ax,word ptr[rdx+2*rax]
	stosw
	lodsb
	mov ax,word ptr[rdx+2*rax]
	stosw	
	lodsb
	mov ax,word ptr[rdx+2*rax]
	stosw
	lodsb
	xor ax,ax
	stosw
	loop LookupRGB32toRGB64_2
	
	add rsi,r10
	add rdi,r11
	dec r9d
	jnz short LookupRGB32toRGB64_1
	
	pop rsi
	pop rdi
	pop rbp
	
	ret
	
JPSDR_HDRTools_LookupRGB32toRGB64 endp

	
;JPSDR_HDRTools_LookupRGB64 proc src:dword,dst:dword,w:dword,h:dword,src_modulo:dword,dst_modulo:dword,lookup:dword
; src = rcx
; dst = rdx
; w = r8d
; h = r9d

JPSDR_HDRTools_LookupRGB64 proc public frame

src_modulo equ qword ptr[rbp+48]
dst_modulo equ qword ptr[rbp+56]
lookup equ qword ptr[rbp+64]

	push rbp
	.pushreg rbp
	mov rbp,rsp
	push rdi
	.pushreg rdi
	push rsi
	.pushreg rsi
	.endprolog

	cld
	mov rsi,rcx
	mov rdi,rdx
	mov r10,src_modulo
	mov r11,dst_modulo
	mov rdx,lookup
	xor rax,rax
	
LookupRGB64_1:
	mov ecx,r8d
LookupRGB64_2:
	lodsw
	mov ax,word ptr[rdx+2*rax]
	stosw
	lodsw
	mov ax,word ptr[rdx+2*rax]
	stosw	
	lodsw
	mov ax,word ptr[rdx+2*rax]
	stosw
	movsw
	loop LookupRGB64_2
	
	add rsi,r10
	add rdi,r11
	dec r9d
	jnz short LookupRGB64_1
	
	pop rsi
	pop rdi
	pop rbp
	
	ret
	
JPSDR_HDRTools_LookupRGB64 endp


;JPSDR_HDRTools_Lookup_Planar8 proc src:dword,dst:dword,w:dword,h:dword,src_modulo:dword,dst_modulo:dword,lookup:dword
; src = rcx
; dst = rdx
; w = r8d
; h = r9d

JPSDR_HDRTools_Lookup_Planar8 proc public frame

src_modulo equ qword ptr[rbp+48]
dst_modulo equ qword ptr[rbp+56]
lookup equ qword ptr[rbp+64]

	push rbp
	.pushreg rbp
	mov rbp,rsp
	push rdi
	.pushreg rdi
	push rsi
	.pushreg rsi
	.endprolog

	cld
	mov rsi,rcx
	mov rdi,rdx
	mov r10,src_modulo
	mov r11,dst_modulo
	mov rdx,lookup
	xor rax,rax
	
Lookup_Planar8_1:
	mov ecx,r8d
Lookup_Planar8_2:
	lodsb
	mov al,byte ptr[rdx+rax]
	stosb
	loop Lookup_Planar8_2
	
	add rsi,r10
	add rdi,r11
	dec r9d
	jnz short Lookup_Planar8_1
	
	pop rsi
	pop rdi
	pop rbp
	
	ret
	
JPSDR_HDRTools_Lookup_Planar8 endp


;JPSDR_HDRTools_Lookup_Planar16 proc src:dword,dst:dword,w:dword,h:dword,src_modulo:dword,dst_modulo:dword,lookup:dword
; src = rcx
; dst = rdx
; w = r8d
; h = r9d

JPSDR_HDRTools_Lookup_Planar16 proc public frame

src_modulo equ qword ptr[rbp+48]
dst_modulo equ qword ptr[rbp+56]
lookup equ qword ptr[rbp+64]

	push rbp
	.pushreg rbp
	mov rbp,rsp
	push rdi
	.pushreg rdi
	push rsi
	.pushreg rsi
	.endprolog

	cld
	mov rsi,rcx
	mov rdi,rdx
	mov r10,src_modulo
	mov r11,dst_modulo
	mov rdx,lookup
	xor rax,rax
	
Lookup_Planar16_1:
	mov ecx,r8d
Lookup_Planar16_2:
	lodsw
	mov ax,word ptr[rdx+2*rax]
	stosw
	loop Lookup_Planar16_2
	
	add rsi,r10
	add rdi,r11
	dec r9d
	jnz short Lookup_Planar16_1
	
	pop rsi
	pop rdi
	pop rbp
	
	ret
	
JPSDR_HDRTools_Lookup_Planar16 endp


;JPSDR_HDRTools_Lookup_Planar32 proc src:dword,dst:dword,w:dword,h:dword,src_modulo:dword,dst_modulo:dword,lookup:dword
; src = rcx
; dst = rdx
; w = r8d
; h = r9d

JPSDR_HDRTools_Lookup_Planar32 proc public frame

src_modulo equ qword ptr[rbp+48]
dst_modulo equ qword ptr[rbp+56]
lookup equ qword ptr[rbp+64]

	push rbp
	.pushreg rbp
	mov rbp,rsp
	push rdi
	.pushreg rdi
	push rsi
	.pushreg rsi
	.endprolog

	cld
	mov rsi,rcx
	mov rdi,rdx
	mov r10,src_modulo
	mov r11,dst_modulo
	mov rdx,lookup
	xor rax,rax
	
Lookup_Planar32_1:
	mov ecx,r8d
Lookup_Planar32_2:
	lodsd
	mov eax,dword ptr[rdx+4*rax]
	stosd
	loop Lookup_Planar32_2
	
	add rsi,r10
	add rdi,r11
	dec r9d
	jnz short Lookup_Planar32_1
	
	pop rsi
	pop rdi
	pop rbp
	
	ret
	
JPSDR_HDRTools_Lookup_Planar32 endp


;JPSDR_HDRTools_Lookup2_Planar32 proc src:dword,dst1:dword,dst2:dword,w:dword,h:dword,src_modulo:dword,
;	dst_modulo1:dword,dst_modulo2:dword,lookup1:dword,lookup2:dword
; src = rcx
; dst1 = rdx
; dst2 = r8
; w = r9d

JPSDR_HDRTools_Lookup2_Planar32 proc public frame

h equ dword ptr[rbp+48]
src_modulo equ qword ptr[rbp+56]
dst_modulo1 equ qword ptr[rbp+64]
dst_modulo2 equ qword ptr[rbp+72]
lookup1 equ qword ptr[rbp+80]
lookup2 equ qword ptr[rbp+88]

	push rbp
	.pushreg rbp
	mov rbp,rsp
	push rdi
	.pushreg rdi
	push rsi
	.pushreg rsi
	push rbx
	.pushreg rbx
	push r12
	.pushreg r12
	push r13
	.pushreg r13
	push r14
	.pushreg r14
	push r15
	.pushreg r15
	.endprolog

	cld
	mov rsi,rcx
	mov rdi,rdx
	mov r10,src_modulo
	mov r11,dst_modulo1
	mov r12,dst_modulo2
	mov rdx,lookup1
	mov rbx,lookup2
	xor rax,rax
	mov r13d,h
	mov r14,4
	
Lookup2_Planar32_1:
	mov ecx,r9d
Lookup2_Planar32_2:
	lodsd
	mov r15,rax
	mov eax,dword ptr[rdx+4*rax]
	stosd
	mov eax,dword ptr[rbx+4*r15]
	mov dword ptr[r8],eax
	add r8,r14
	loop Lookup2_Planar32_2
	
	add rsi,r10
	add rdi,r11
	add r8,r12
	dec r13d
	jnz short Lookup2_Planar32_1
	
	pop r15
	pop r14
	pop r13
	pop r12
	pop rbx
	pop rsi
	pop rdi
	pop rbp
	
	ret
	
JPSDR_HDRTools_Lookup2_Planar32 endp

	
;JPSDR_HDRTools_Move8to16 proc dst:dword,src:dword,w:dword
; dst = rcx
; src = rdx
; w = r8d

JPSDR_HDRTools_Move8to16 proc public frame

	push rsi
	.pushreg rsi
	push rdi
	.pushreg rdi
	.endprolog
	
	cld
	mov rdi,rcx
	xor rax,rax	
	mov rsi,rdx
	mov ecx,r8d
	
	stosb
	dec rcx
	jz short Move8to16_2
	
Move8to16_1:
	lodsb
	stosw
	loop Move8to16_1
	
Move8to16_2:
	
	movsb
	
	pop rdi
	pop rsi

	ret
	
JPSDR_HDRTools_Move8to16 endp	


;JPSDR_HDRTools_Move8to16_SSE2 proc dst:dword,src:dword,w:dword
; dst = rcx
; src = rdx
; w = r8d

JPSDR_HDRTools_Move8to16_SSE2 proc public frame

	.endprolog
	
	mov r9,rcx
	mov r10,16
	xor rax,rax
	mov ecx,r8d
	pxor xmm0,xmm0
		
Move8to16_SSE2_1:
	movdqa xmm1,XMMWORD ptr [rdx+rax]
	movdqa xmm2,xmm0
	movdqa xmm3,xmm0
	punpcklbw xmm2,xmm1
	punpckhbw xmm3,xmm1
	movdqa XMMWORD ptr [r9+2*rax],xmm2
	movdqa XMMWORD ptr [r9+2*rax+16],xmm3
	add rax,r10
	loop Move8to16_SSE2_1
	
	ret
	
JPSDR_HDRTools_Move8to16_SSE2 endp	


;JPSDR_HDRTools_Move8to16_AVX proc dst:dword,src:dword,w:dword
; dst = rcx
; src = rdx
; w = r8d

JPSDR_HDRTools_Move8to16_AVX proc public frame

	sub rsp,24
	.allocstack 24
	vmovdqa XMMWORD ptr[rsp],xmm6
	.savexmm128 xmm6,0
	.endprolog
	
	mov r10,rcx
	mov r9,rdx
	xor rax,rax
	mov rdx,32
	mov ecx,r8d
	vpxor xmm6,xmm6,xmm6
	
	shr rcx,1
	jz short Move8to16_AVX_1
		
Move8to16_AVX_loop_1:
	vmovdqa xmm4,XMMWORD ptr[r9+rax]
	vmovdqa xmm5,XMMWORD ptr[r9+rax+16]
	vpunpcklbw xmm0,xmm6,xmm4
	vpunpckhbw xmm1,xmm6,xmm4
	vpunpcklbw xmm2,xmm6,xmm5
	vpunpckhbw xmm3,xmm6,xmm5
	vmovdqa XMMWORD ptr[r10+2*rax],xmm0
	vmovdqa XMMWORD ptr[r10+2*rax+16],xmm1
	vmovdqa XMMWORD ptr[r10+2*rax+32],xmm2
	vmovdqa XMMWORD ptr[r10+2*rax+48],xmm3
	add rax,rdx
	loop Move8to16_AVX_loop_1
	
Move8to16_AVX_1:
	test r8d,1
	jz short Move8to16_AVX_2

	vmovdqa xmm4,XMMWORD ptr[r9+rax]
	vpunpcklbw xmm0,xmm6,xmm4
	vpunpckhbw xmm1,xmm6,xmm4
	vmovdqa XMMWORD ptr[r10+2*rax],xmm0
	vmovdqa XMMWORD ptr[r10+2*rax+16],xmm1

Move8to16_AVX_2:

	vmovdqa xmm6,XMMWORD ptr[rsp]	
	add rsp,24

	ret
	
JPSDR_HDRTools_Move8to16_AVX endp	


;***************************************************
;**           YUV to RGB functions                **
;***************************************************


;JPSDR_HDRTools_Convert_Planar420_to_Planar422_8_SSE2 proc src1:dword,src2:dword,dst:dword,w:dword
; src1 = rcx
; src2 = rdx
; dst = r8
; w = r9d

JPSDR_HDRTools_Convert_Planar420_to_Planar422_8_SSE2 proc public frame

	.endprolog
		
	pcmpeqb xmm3,xmm3
	
	mov r10,rcx				; r10=src1
	xor rax,rax	
	mov ecx,r9d	
	mov r11,16
	
Convert_Planar420_to_Planar422_8_SSE2_1:
	movdqa xmm0,XMMWORD ptr[r10+rax]
	movdqa xmm1,XMMWORD ptr[rdx+rax]
	movdqa xmm2,xmm0
	pxor xmm0,xmm3
	pxor xmm1,xmm3
	pavgb xmm0,xmm1
	pxor xmm0,xmm3
	pavgb xmm0,xmm2
	
	movdqa XMMWORD ptr[r8+rax],xmm0
	add rax,r11
	loop Convert_Planar420_to_Planar422_8_SSE2_1
	
	ret

JPSDR_HDRTools_Convert_Planar420_to_Planar422_8_SSE2 endp


;JPSDR_HDRTools_Convert_Planar420_to_Planar422_8to16_SSE2 proc src1:dword,src2:dword,dst:dword,w:dword
; src1 = rcx
; src2 = rdx
; dst = r8
; w = r9d

JPSDR_HDRTools_Convert_Planar420_to_Planar422_8to16_SSE2 proc public frame

	.endprolog
		
	pcmpeqb xmm3,xmm3
	
	mov r10,rcx				; r10=src1
	xor rax,rax	
	mov ecx,r9d	
	mov r11,8
	
Convert_Planar420_to_Planar422_8to16_SSE2_1:
	movq xmm0,qword ptr[r10+rax]
	movq xmm1,qword ptr[rdx+rax]
	
	pxor xmm2,xmm2
	pxor xmm3,xmm3
	punpcklbw xmm2,xmm0
	punpcklbw xmm3,xmm1

	movdqa xmm0,xmm2
	pxor xmm2,xmm4
	pxor xmm3,xmm4
	pavgw xmm2,xmm3
	pxor xmm2,xmm4
	pavgw xmm2,xmm0
	
	movdqa XMMWORD ptr[r8+2*rax],xmm2
	add rax,r11
	loop Convert_Planar420_to_Planar422_8to16_SSE2_1
	
	ret

JPSDR_HDRTools_Convert_Planar420_to_Planar422_8to16_SSE2 endp


;JPSDR_HDRTools_Convert_Planar420_to_Planar422_8_AVX proc src1:dword,src2:dword,dst:dword,w:dword
; src1 = rcx
; src2 = rdx
; dst = r8
; w = r9d

JPSDR_HDRTools_Convert_Planar420_to_Planar422_8_AVX proc public frame

	.endprolog
		
	vpcmpeqb xmm3,xmm3,xmm3
	
	mov r10,rcx				; r10=src1
	xor rax,rax	
	mov ecx,r9d	
	mov r11,16
	
Convert_Planar420_to_Planar422_8_AVX_1:
	vmovdqa xmm0,XMMWORD ptr[r10+rax]
	vmovdqa xmm1,XMMWORD ptr[rdx+rax]
	vpxor xmm2,xmm0,xmm3
	vpxor xmm1,xmm1,xmm3
	vpavgb xmm2,xmm2,xmm1
	vpxor xmm2,xmm2,xmm3
	vpavgb xmm2,xmm2,xmm0
	
	vmovdqa XMMWORD ptr[r8+rax],xmm2
	add rax,r11
	loop Convert_Planar420_to_Planar422_8_AVX_1
	
	ret

JPSDR_HDRTools_Convert_Planar420_to_Planar422_8_AVX endp


;JPSDR_HDRTools_Convert_Planar420_to_Planar422_8to16_AVX proc src1:dword,src2:dword,dst:dword,w:dword
; src1 = rcx
; src2 = rdx
; dst = r8
; w = r9d

JPSDR_HDRTools_Convert_Planar420_to_Planar422_8to16_AVX proc public frame

	sub rsp,40
	.allocstack 40
	vmovdqa XMMWORD ptr[rsp],xmm6
	.savexmm128 xmm6,0
	vmovdqa XMMWORD ptr[rsp+16],xmm7
	.savexmm128 xmm7,16
	.endprolog

	vpcmpeqb xmm3,xmm3,xmm3	
	vpxor xmm4,xmm4,xmm4

	mov r10,rcx				; r10=src1
	xor rax,rax	
	mov ecx,r9d	
	mov r11,16

	shr rcx,1
	jz short Convert_Planar420_to_Planar422_8to16_AVX_1

Convert_Planar420_to_Planar422_8to16_AVX_loop_1:
	vmovdqa xmm0,XMMWORD ptr[r10+rax]
	vmovdqa xmm1,XMMWORD ptr[rdx+rax]
	vpunpckhbw xmm5,xmm4,xmm0
	vpunpckhbw xmm6,xmm4,xmm1
	vpunpcklbw xmm0,xmm4,xmm0
	vpunpcklbw xmm1,xmm4,xmm1

	vpxor xmm2,xmm0,xmm3
	vpxor xmm1,xmm1,xmm3
	vpxor xmm7,xmm5,xmm3
	vpxor xmm6,xmm6,xmm3
	vpavgw xmm2,xmm2,xmm1
	vpavgw xmm7,xmm7,xmm6
	vpxor xmm2,xmm2,xmm3
	vpxor xmm7,xmm7,xmm3
	vpavgw xmm2,xmm2,xmm0
	vpavgw xmm7,xmm7,xmm5

	vmovdqa XMMWORD ptr[r8+2*rax],xmm2
	vmovdqa XMMWORD ptr[r8+2*rax+16],xmm7
	add rax,r11
	loop Convert_Planar420_to_Planar422_8to16_AVX_loop_1

Convert_Planar420_to_Planar422_8to16_AVX_1:
	test r9d,1
	jz short Convert_Planar420_to_Planar422_8to16_AVX_2

	vmovq xmm0,qword ptr[r10+rax]
	vmovq xmm1,qword ptr[rdx+rax]
	vpunpcklbw xmm0,xmm4,xmm0
	vpunpcklbw xmm1,xmm4,xmm1
	
	vpxor xmm2,xmm0,xmm3
	vpxor xmm1,xmm1,xmm3
	vpavgw xmm2,xmm2,xmm1
	vpxor xmm2,xmm2,xmm3
	vpavgw xmm2,xmm2,xmm0

	vmovdqa XMMWORD ptr[r8+2*rax],xmm2


Convert_Planar420_to_Planar422_8to16_AVX_2:

	vmovdqa xmm7,XMMWORD ptr[rsp+16]	
	vmovdqa xmm6,XMMWORD ptr[rsp]	
	add rsp,40
	
	ret

JPSDR_HDRTools_Convert_Planar420_to_Planar422_8to16_AVX endp


;JPSDR_HDRTools_Convert_Planar420_to_Planar422_16_SSE2 proc src1:dword,src2:dword,dst:dword,w:dword
; src1 = rcx
; src2 = rdx
; dst = r8
; w = r9d

JPSDR_HDRTools_Convert_Planar420_to_Planar422_16_SSE2 proc public frame

	.endprolog
		
	pcmpeqb xmm3,xmm3
	
	mov r10,rcx				; r10=src1
	xor rax,rax	
	mov ecx,r9d	
	mov r11,16
	
Convert_Planar420_to_Planar422_16_SSE2_1:
	movdqa xmm0,XMMWORD ptr[r10+rax]
	movdqa xmm1,XMMWORD ptr[rdx+rax]
	movdqa xmm2,xmm0
	pxor xmm0,xmm3
	pxor xmm1,xmm3
	pavgw xmm0,xmm1
	pxor xmm0,xmm3
	pavgw xmm0,xmm2
	
	movdqa XMMWORD ptr[r8+rax],xmm0
	add rax,r11
	loop Convert_Planar420_to_Planar422_16_SSE2_1
	
	ret

JPSDR_HDRTools_Convert_Planar420_to_Planar422_16_SSE2 endp


;JPSDR_HDRTools_Convert_Planar420_to_Planar422_16_AVX proc src1:dword,src2:dword,dst:dword,w:dword
; src1 = rcx
; src2 = rdx
; dst = r8
; w = r9d

JPSDR_HDRTools_Convert_Planar420_to_Planar422_16_AVX proc public frame

	.endprolog
		
	vpcmpeqb xmm3,xmm3,xmm3
	
	mov r10,rcx				; r10=src1
	xor rax,rax	
	mov ecx,r9d	
	mov r11,16
	
Convert_Planar420_to_Planar422_16_AVX_1:
	vmovdqa xmm0,XMMWORD ptr[r10+rax]
	vmovdqa xmm1,XMMWORD ptr[rdx+rax]
	vpxor xmm2,xmm0,xmm3
	vpxor xmm1,xmm1,xmm3
	vpavgw xmm2,xmm2,xmm1
	vpxor xmm2,xmm2,xmm3
	vpavgw xmm2,xmm2,xmm0
	
	vmovdqa XMMWORD ptr[r8+rax],xmm2
	add rax,r11
	loop Convert_Planar420_to_Planar422_16_AVX_1
	
	ret

JPSDR_HDRTools_Convert_Planar420_to_Planar422_16_AVX endp


;JPSDR_HDRTools_Convert_Planar422_to_Planar444_8_SSE2 proc src:dword,dst:dword,w:dword
; src = rcx
; dst = rdx
; w = r8d

JPSDR_HDRTools_Convert_Planar422_to_Planar444_8_SSE2 proc public frame

	.endprolog
		
	mov r9,rcx				; r9=src
	xor rax,rax	
	mov ecx,r8d	
	mov r10,16
	
Convert_Planar422_to_Planar444_8_SSE2_1:
	movdqa xmm0,XMMWORD ptr[r9+rax]
	movdqu xmm1,XMMWORD ptr[r9+rax+1]
	movdqa xmm2,xmm0
	pavgb xmm1,xmm0
	movdqa xmm3,xmm0
	punpcklbw xmm2,xmm1
	punpckhbw xmm3,xmm1	
	
	movdqa XMMWORD ptr[rdx+2*rax],xmm2
	movdqa XMMWORD ptr[rdx+2*rax+16],xmm3
	add rax,r10
	loop Convert_Planar422_to_Planar444_8_SSE2_1
	
	ret

JPSDR_HDRTools_Convert_Planar422_to_Planar444_8_SSE2 endp


;JPSDR_HDRTools_Convert_Planar422_to_Planar444_8_AVX proc src:dword,dst:dword,w:dword
; src = rcx
; dst = rdx
; w = r8d

JPSDR_HDRTools_Convert_Planar422_to_Planar444_8_AVX proc public frame

	.endprolog
		
	mov r9,rcx				; r9=src
	xor rax,rax	
	mov ecx,r8d	
	mov r10,16
	
Convert_Planar422_to_Planar444_8_AVX_1:
	vmovdqa xmm0,XMMWORD ptr[r9+rax]
	vmovdqu xmm1,XMMWORD ptr[r9+rax+1]
	vpavgb xmm1,xmm1,xmm0
	vpunpcklbw xmm2,xmm0,xmm1
	vpunpckhbw xmm3,xmm0,xmm1
	
	vmovdqa XMMWORD ptr[rdx+2*rax],xmm2
	vmovdqa XMMWORD ptr[rdx+2*rax+16],xmm3
	add rax,r10
	loop Convert_Planar422_to_Planar444_8_AVX_1
	
	ret

JPSDR_HDRTools_Convert_Planar422_to_Planar444_8_AVX endp


;JPSDR_HDRTools_Convert_Planar422_to_Planar444_8to16_SSE2 proc src:dword,dst:dword,w:dword
; src = rcx
; dst = rdx
; w = r8d

JPSDR_HDRTools_Convert_Planar422_to_Planar444_8to16_SSE2 proc public frame

	.endprolog
		
	mov r9,rcx				; r9=src
	xor rax,rax	
	mov ecx,r8d	
	mov r10,32
	xor r11,r11
	
Convert_Planar422_to_Planar444_8to16_SSE2_1:
	movq xmm0,qword ptr[r9+8*rax]
	movq xmm1,qword ptr[r9+8*rax+1]
	pxor xmm2,xmm2
	pxor xmm3,xmm3
	punpcklbw xmm2,xmm0
	punpcklbw xmm3,xmm1
	
	pavgw xmm3,xmm2
	movdqa xmm0,xmm2	
	punpcklwd xmm2,xmm3
	punpckhwd xmm0,xmm3
	
	movdqa XMMWORD ptr[rdx+r11],xmm2
	movdqa XMMWORD ptr[rdx+r11+16],xmm0
	inc rax
	add r11,r10
	loop Convert_Planar422_to_Planar444_8to16_SSE2_1
	
	ret

JPSDR_HDRTools_Convert_Planar422_to_Planar444_8to16_SSE2 endp


;JPSDR_HDRTools_Convert_Planar422_to_Planar444_8to16_AVX proc src:dword,dst:dword,w:dword
; src = rcx
; dst = rdx
; w = r8d

JPSDR_HDRTools_Convert_Planar422_to_Planar444_8to16_AVX proc public frame

	.endprolog
		
	vpxor xmm4,xmm4,xmm4
	mov r9,rcx				; r9=src
	xor rax,rax	
	mov ecx,r8d	
	mov r10,32
	xor r11,r11
	
Convert_Planar422_to_Planar444_8to16_AVX_1:
	vmovq xmm0,qword ptr[r9+8*rax]
	vmovq xmm1,qword ptr[r9+8*rax+1]	
	vpunpcklbw xmm0,xmm4,xmm0
	vpunpcklbw xmm1,xmm4,xmm1
	
	vpavgw xmm1,xmm1,xmm0
	vpunpcklwd xmm2,xmm0,xmm1
	vpunpckhwd xmm3,xmm0,xmm1
	
	vmovdqa XMMWORD ptr[rdx+r11],xmm2
	vmovdqa XMMWORD ptr[rdx+r11+16],xmm3
	inc rax
	add r11,r10
	loop Convert_Planar422_to_Planar444_8to16_AVX_1
	
	ret

JPSDR_HDRTools_Convert_Planar422_to_Planar444_8to16_AVX endp


;JPSDR_HDRTools_Convert_Planar422_to_Planar444_16_SSE2 proc src:dword,dst:dword,w:dword
; src = rcx
; dst = rdx
; w = r8d

JPSDR_HDRTools_Convert_Planar422_to_Planar444_16_SSE2 proc public frame

	.endprolog
		
	mov r9,rcx				; r9=src
	xor rax,rax	
	mov ecx,r8d	
	mov r10,16
	
Convert_Planar422_to_Planar444_16_SSE2_1:
	movdqa xmm0,XMMWORD ptr[r9+rax]
	movdqu xmm1,XMMWORD ptr[r9+rax+2]
	movdqa xmm2,xmm0
	pavgw xmm1,xmm0
	movdqa xmm3,xmm0
	punpcklwd xmm2,xmm1
	punpckhwd xmm3,xmm1	
	
	movdqa XMMWORD ptr[rdx+2*rax],xmm2
	movdqa XMMWORD ptr[rdx+2*rax+16],xmm3
	add rax,r10
	loop Convert_Planar422_to_Planar444_16_SSE2_1
	
	ret

JPSDR_HDRTools_Convert_Planar422_to_Planar444_16_SSE2 endp


;JPSDR_HDRTools_Convert_Planar422_to_Planar444_16_AVX proc src:dword,dst:dword,w:dword
; src = rcx
; dst = rdx
; w = r8d

JPSDR_HDRTools_Convert_Planar422_to_Planar444_16_AVX proc public frame

	.endprolog
		
	mov r9,rcx				; r9=src
	xor rax,rax	
	mov ecx,r8d	
	mov r10,16
	
Convert_Planar422_to_Planar444_16_AVX_1:
	vmovdqa xmm0,XMMWORD ptr[r9+rax]
	vmovdqu xmm1,XMMWORD ptr[r9+rax+2]
	vpavgw xmm1,xmm1,xmm0
	vpunpcklwd xmm2,xmm0,xmm1
	vpunpckhwd xmm3,xmm0,xmm1
	
	vmovdqa XMMWORD ptr[rdx+2*rax],xmm2
	vmovdqa XMMWORD ptr[rdx+2*rax+16],xmm3
	add rax,r10
	loop Convert_Planar422_to_Planar444_16_AVX_1
	
	ret

JPSDR_HDRTools_Convert_Planar422_to_Planar444_16_AVX endp


;JPSDR_HDRTools_Convert_YV24toRGB32_SSE2 proc src_y:dword,src_u:dword,src_v:dword,dst:dword,w:dword,h:dword,offset_R:word,
; offset_G:word,offset_B:word,lookup:dword,src_modulo_y:dword,src_modulo_u:dword,src_modulo_v:dword,dst_modulo:dword
; src_y = rcx
; src_u = rdx
; src_v = r8
; dst = r9

JPSDR_HDRTools_Convert_YV24toRGB32_SSE2 proc public frame

w equ dword ptr[rbp+48]
h equ dword ptr[rbp+56]
offset_R equ word ptr[rbp+64]
offset_G equ word ptr[rbp+72]
offset_B equ word ptr[rbp+80]
lookup equ qword ptr[rbp+88]
src_modulo_y equ qword ptr[rbp+96]
src_modulo_u equ qword ptr[rbp+104]
src_modulo_v equ qword ptr[rbp+112]
dst_modulo equ qword ptr[rbp+120]

	push rbp
	.pushreg rbp
	mov rbp,rsp
	push rdi
	.pushreg rdi
	push rsi
	.pushreg rsi
	push rbx
	.pushreg rbx
	push r12
	.pushreg r12
	push r13
	.pushreg r13
	push r14
	.pushreg r14
	push r15
	.pushreg r15
	.endprolog

	xor rax,rax
	pxor xmm1,xmm1
	movzx eax,offset_B
	pinsrw xmm1,eax,0
	pinsrw xmm1,eax,4
	movzx eax,offset_G
	pinsrw xmm1,eax,1
	pinsrw xmm1,eax,5
	movzx eax,offset_R
	pinsrw xmm1,eax,2
	pinsrw xmm1,eax,6
	mov rsi,rcx					;rsi=src_y
	mov r11,rdx					;r11=src_u
	mov r12,r8					;r12=src_v
	mov rdi,r9
	mov r9d,w
	mov r10,lookup
	mov r13,4
	mov r14,16
	
	mov r8d,r9d
	shr r8d,2					;r8d=w0
	
	xor rdx,rdx
	xor rbx,rbx
	xor r15,r15

Convert_YV24toRGB32_SSE2_1:
	or r8d,r8d
	jz Convert_YV24toRGB32_SSE2_3
	
	mov ecx,r8d
Convert_YV24toRGB32_SSE2_2:
	pxor xmm2,xmm2
	pxor xmm0,xmm0

	movzx ebx,byte ptr[rsi]
	movzx r15d,byte ptr[r11]
	movzx edx,byte ptr[r12] ; rbx=Y r15=U rdx=V
	movzx eax,word ptr[r10+2*rbx]
	add ax,word ptr[r10+2*rdx+512]
	pinsrw xmm0,eax,2
	movzx eax,word ptr[r10+2*rbx]
	add ax,word ptr[r10+2*r15+1024]
	add ax,word ptr[r10+2*rdx+1536]
	pinsrw xmm0,eax,1
	movzx eax,word ptr[r10+2*rbx]
	add ax,word ptr[r10+2*r15+2048]
	pinsrw xmm0,eax,0
	
	movzx ebx,byte ptr[rsi+1]
	movzx r15d,byte ptr[r11+1]
	movzx edx,byte ptr[r12+1] ; rbx=Y r15=U rdx=V
	movzx eax,word ptr[r10+2*rbx]
	add ax,word ptr[r10+2*rdx+512]
	pinsrw xmm0,eax,6
	movzx eax,word ptr[r10+2*rbx]
	add ax,word ptr[r10+2*r15+1024]
	add ax,word ptr[r10+2*rdx+1536]
	pinsrw xmm0,eax,5
	movzx eax,word ptr[r10+2*rbx]
	add ax,word ptr[r10+2*r15+2048]
	pinsrw xmm0,eax,4

	movzx ebx,byte ptr[rsi+2]
	movzx r15d,byte ptr[r11+2]
	movzx edx,byte ptr[r12+2] ; rbx=Y r15=U rdx=V
	movzx eax,word ptr[r10+2*rbx]
	add ax,word ptr[r10+2*rdx+512]
	pinsrw xmm2,eax,2
	movzx eax,word ptr[r10+2*rbx]
	add ax,word ptr[r10+2*r15+1024]
	add ax,word ptr[r10+2*rdx+1536]
	pinsrw xmm2,eax,1
	movzx eax,word ptr[r10+2*rbx]
	add ax,word ptr[r10+2*r15+2048]
	pinsrw xmm2,eax,0
	
	movzx ebx,byte ptr[rsi+3]
	movzx r15d,byte ptr[r11+3]
	movzx edx,byte ptr[r12+3] ; rbx=Y r15=U rdx=V
	movzx eax,word ptr[r10+2*rbx]
	add ax,word ptr[r10+2*rdx+512]
	add rsi,r13
	pinsrw xmm2,eax,6
	movzx eax,word ptr[r10+2*rbx]
	add ax,word ptr[r10+2*r15+1024]
	add ax,word ptr[r10+2*rdx+1536]
	add r11,r13
	pinsrw xmm2,eax,5
	movzx eax,word ptr[r10+2*rbx]
	add ax,word ptr[r10+2*r15+2048]
	add r12,r13
	pinsrw xmm2,eax,4
	
	paddsw xmm0,xmm1
	paddsw xmm2,xmm1
	psraw xmm0,5
	psraw xmm2,5
	packuswb xmm0,xmm2
	
	movdqa XMMWORD ptr[rdi],xmm0
	
	add rdi,r14
	
	dec ecx
	jnz Convert_YV24toRGB32_SSE2_2
	
Convert_YV24toRGB32_SSE2_3:	
	test r9d,3
	jz Convert_YV24toRGB32_SSE2_5
	
	pxor xmm0,xmm0
	
	test r9d,2
	jnz short Convert_YV24toRGB32_SSE2_4
	
	movzx ebx,byte ptr[rsi]
	movzx r15d,byte ptr[r11]
	movzx edx,byte ptr[r12] ; rbx=Y r15=U rdx=V
	movzx eax,word ptr[r10+2*rbx]
	add ax,word ptr[r10+2*rdx+512]
	inc rsi
	pinsrw xmm0,eax,2
	movzx eax,word ptr[r10+2*rbx]
	add ax,word ptr[r10+2*r15+1024]
	add ax,word ptr[r10+2*rdx+1536]
	inc r11
	pinsrw xmm0,eax,1
	movzx eax,word ptr[r10+2*rbx]
	add ax,word ptr[r10+2*r15+2048]
	inc r12
	pinsrw xmm0,eax,0
	
	paddsw xmm0,xmm1
	psraw xmm0,5
	packuswb xmm0,xmm0
	
	movd dword ptr[rdi],xmm0
	
	add rdi,r13
	
	jmp Convert_YV24toRGB32_SSE2_5
	
Convert_YV24toRGB32_SSE2_4:
	movzx ebx,byte ptr[rsi]
	movzx r15d,byte ptr[r11]
	movzx edx,byte ptr[r12] ; rbx=Y r15=U rdx=V
	movzx eax,word ptr[r10+2*rbx]
	add ax,word ptr[r10+2*rdx+512]
	pinsrw xmm0,eax,2
	movzx eax,word ptr[r10+2*rbx]
	add ax,word ptr[r10+2*r15+1024]
	add ax,word ptr[r10+2*rdx+1536]
	pinsrw xmm0,eax,1
	movzx eax,word ptr[r10+2*rbx]
	add ax,word ptr[r10+2*r15+2048]
	pinsrw xmm0,eax,0
	
	movzx ebx,byte ptr[rsi+1]
	movzx r15d,byte ptr[r11+1]
	movzx edx,byte ptr[r12+1] ; rbx=Y r15=U rdx=V
	movzx eax,word ptr[r10+2*rbx]
	add ax,word ptr[r10+2*rdx+512]
	add rsi,2
	pinsrw xmm0,eax,6
	movzx eax,word ptr[r10+2*rbx]
	add ax,word ptr[r10+2*r15+1024]
	add ax,word ptr[r10+2*rdx+1536]
	add r11,2
	pinsrw xmm0,eax,5
	movzx eax,word ptr[r10+2*rbx]
	add ax,word ptr[r10+2*r15+2048]
	add r12,2
	pinsrw xmm0,eax,4
	
	paddsw xmm0,xmm1
	psraw xmm0,5
	packuswb xmm0,xmm0
	
	movq qword ptr[rdi],xmm0
	
	add rdi,8
	
	test r9d,1
	jz short Convert_YV24toRGB32_SSE2_5
	
	pxor xmm0,xmm0
	
	movzx ebx,byte ptr[rsi]
	movzx r15d,byte ptr[r11]
	movzx edx,byte ptr[r12] ; rbx=Y r15=U rdx=V
	movzx eax,word ptr[r10+2*rbx]
	add ax,word ptr[r10+2*rdx+512]
	inc rsi
	pinsrw xmm0,eax,2
	movzx eax,word ptr[r10+2*rbx]
	add ax,word ptr[r10+2*r15+1024]
	add ax,word ptr[r10+2*rdx+1536]
	inc r11
	pinsrw xmm0,eax,1
	movzx eax,word ptr[r10+2*rbx]
	add ax,word ptr[r10+2*r15+2048]
	inc r12
	pinsrw xmm0,eax,0
	
	paddsw xmm0,xmm1
	psraw xmm0,5
	packuswb xmm0,xmm0
	
	movd dword ptr[rdi],xmm0
	
	add rdi,r13
	
Convert_YV24toRGB32_SSE2_5:	
	add rsi,src_modulo_y
	add r11,src_modulo_u
	add r12,src_modulo_v
	add rdi,dst_modulo
	dec h
	jnz Convert_YV24toRGB32_SSE2_1

	pop r15
	pop r14
	pop r13
	pop r12
	pop rbx
	pop rsi
	pop rdi
	pop rbp
	
	ret

JPSDR_HDRTools_Convert_YV24toRGB32_SSE2 endp


;JPSDR_HDRTools_Convert_YV24toRGB32_AVX proc src_y:dword,src_u:dword,src_v:dword,dst:dword,w:dword,h:dword,offset_R:word,
; offset_G:word,offset_B:word,lookup:dword,src_modulo_y:dword,src_modulo_u:dword,src_modulo_v:dword,dst_modulo:dword
; src_y = rcx
; src_u = rdx
; src_v = r8
; dst = r9

JPSDR_HDRTools_Convert_YV24toRGB32_AVX proc public frame

w equ dword ptr[rbp+48]
h equ dword ptr[rbp+56]
offset_R equ word ptr[rbp+64]
offset_G equ word ptr[rbp+72]
offset_B equ word ptr[rbp+80]
lookup equ qword ptr[rbp+88]
src_modulo_y equ qword ptr[rbp+96]
src_modulo_u equ qword ptr[rbp+104]
src_modulo_v equ qword ptr[rbp+112]
dst_modulo equ qword ptr[rbp+120]

	push rbp
	.pushreg rbp
	mov rbp,rsp
	push rdi
	.pushreg rdi
	push rsi
	.pushreg rsi
	push rbx
	.pushreg rbx
	push r12
	.pushreg r12
	push r13
	.pushreg r13
	push r14
	.pushreg r14
	push r15
	.pushreg r15
	.endprolog

	xor rax,rax
	vpxor xmm2,xmm2,xmm2
	vpxor xmm1,xmm1,xmm1
	vpxor xmm0,xmm0,xmm0
	movzx eax,offset_B
	vpinsrw xmm1,xmm1,eax,0
	vpinsrw xmm1,xmm1,eax,4	
	movzx eax,offset_G
	vpinsrw xmm1,xmm1,eax,1
	vpinsrw xmm1,xmm1,eax,5
	movzx eax,offset_R
	vpinsrw xmm1,xmm1,eax,2
	vpinsrw xmm1,xmm1,eax,6
	mov rsi,rcx					;rsi=src_y
	mov r11,rdx					;r11=src_u
	mov r12,r8					;r12=src_v
	mov rdi,r9
	mov r9d,w
	mov r10,lookup
	mov r13,4
	mov r14,16
	
	mov r8d,r9d
	shr r8d,2					;r8d=w0
	
	xor rdx,rdx
	xor rbx,rbx
	xor r15,r15

Convert_YV24toRGB32_AVX_1:
	or r8d,r8d
	jz Convert_YV24toRGB32_AVX_3
	
	mov ecx,r8d
Convert_YV24toRGB32_AVX_2:
	movzx ebx,byte ptr[rsi]
	movzx r15d,byte ptr[r11]
	movzx edx,byte ptr[r12] ; rbx=Y r15=U rdx=V
	movzx eax,word ptr[r10+2*rbx]
	add ax,word ptr[r10+2*rdx+512]
	vpinsrw xmm0,xmm0,eax,2
	movzx eax,word ptr[r10+2*rbx]
	add ax,word ptr[r10+2*r15+1024]
	add ax,word ptr[r10+2*rdx+1536]
	vpinsrw xmm0,xmm0,eax,1
	movzx eax,word ptr[r10+2*rbx]
	add ax,word ptr[r10+2*r15+2048]
	vpinsrw xmm0,xmm0,eax,0
	
	movzx ebx,byte ptr[rsi+1]
	movzx r15d,byte ptr[r11+1]
	movzx edx,byte ptr[r12+1] ; rbx=Y r15=U rdx=V
	movzx eax,word ptr[r10+2*rbx]
	add ax,word ptr[r10+2*rdx+512]
	vpinsrw xmm0,xmm0,eax,6
	movzx eax,word ptr[r10+2*rbx]
	add ax,word ptr[r10+2*r15+1024]
	add ax,word ptr[r10+2*rdx+1536]
	vpinsrw xmm0,xmm0,eax,5
	movzx eax,word ptr[r10+2*rbx]
	add ax,word ptr[r10+2*r15+2048]
	vpinsrw xmm0,xmm0,eax,4

	movzx ebx,byte ptr[rsi+2]
	movzx r15d,byte ptr[r11+2]
	movzx edx,byte ptr[r12+2] ; rbx=Y r15=U rdx=V
	movzx eax,word ptr[r10+2*rbx]
	add ax,word ptr[r10+2*rdx+512]
	vpinsrw xmm2,xmm2,eax,2
	movzx eax,word ptr[r10+2*rbx]
	add ax,word ptr[r10+2*r15+1024]
	add ax,word ptr[r10+2*rdx+1536]
	vpinsrw xmm2,xmm2,eax,1
	movzx eax,word ptr[r10+2*rbx]
	add ax,word ptr[r10+2*r15+2048]
	vpinsrw xmm2,xmm2,eax,0
	
	movzx ebx,byte ptr[rsi+3]
	movzx r15d,byte ptr[r11+3]
	movzx edx,byte ptr[r12+3] ; rbx=Y r15=U rdx=V
	movzx eax,word ptr[r10+2*rbx]
	add ax,word ptr[r10+2*rdx+512]
	add rsi,r13
	vpinsrw xmm2,xmm2,eax,6
	movzx eax,word ptr[r10+2*rbx]
	add ax,word ptr[r10+2*r15+1024]
	add ax,word ptr[r10+2*rdx+1536]
	add r11,r13
	vpinsrw xmm2,xmm2,eax,5
	movzx eax,word ptr[r10+2*rbx]
	add ax,word ptr[r10+2*r15+2048]
	add r12,r13
	vpinsrw xmm2,xmm2,eax,4
	
	vpaddsw xmm0,xmm0,xmm1
	vpaddsw xmm2,xmm2,xmm1
	vpsraw xmm0,xmm0,5
	vpsraw xmm2,xmm2,5
	vpackuswb xmm3,xmm0,xmm2
	
	vmovdqa XMMWORD ptr[rdi],xmm3
	
	add rdi,r14
	
	dec ecx
	jnz Convert_YV24toRGB32_AVX_2
	
Convert_YV24toRGB32_AVX_3:	
	test r9d,3
	jz Convert_YV24toRGB32_AVX_5
	
	test r9d,2
	jnz short Convert_YV24toRGB32_AVX_4

	movzx ebx,byte ptr[rsi]
	movzx r15d,byte ptr[r11]
	movzx edx,byte ptr[r12] ; rbx=Y r15=U rdx=V
	movzx eax,word ptr[r10+2*rbx]
	add ax,word ptr[r10+2*rdx+512]
	inc rsi
	vpinsrw xmm0,xmm0,eax,2
	movzx eax,word ptr[r10+2*rbx]
	add ax,word ptr[r10+2*r15+1024]
	add ax,word ptr[r10+2*rdx+1536]
	inc r11
	vpinsrw xmm0,xmm0,eax,1
	movzx eax,word ptr[r10+2*rbx]
	add ax,word ptr[r10+2*r15+2048]
	inc r12
	vpinsrw xmm0,xmm0,eax,0
	
	vpaddsw xmm0,xmm0,xmm1
	vpsraw xmm0,xmm0,5
	vpackuswb xmm3,xmm0,xmm0
	
	vmovd dword ptr[rdi],xmm3
	
	add rdi,r13
	
	jmp Convert_YV24toRGB32_AVX_5
	
Convert_YV24toRGB32_AVX_4:	
	movzx ebx,byte ptr[rsi]
	movzx r15d,byte ptr[r11]
	movzx edx,byte ptr[r12] ; rbx=Y r15=U rdx=V
	movzx eax,word ptr[r10+2*rbx]
	add ax,word ptr[r10+2*rdx+512]
	vpinsrw xmm0,xmm0,eax,2
	movzx eax,word ptr[r10+2*rbx]
	add ax,word ptr[r10+2*r15+1024]
	add ax,word ptr[r10+2*rdx+1536]
	vpinsrw xmm0,xmm0,eax,1
	movzx eax,word ptr[r10+2*rbx]
	add ax,word ptr[r10+2*r15+2048]
	vpinsrw xmm0,xmm0,eax,0
	
	movzx ebx,byte ptr[rsi+1]
	movzx r15d,byte ptr[r11+1]
	movzx edx,byte ptr[r12+1] ; rbx=Y r15=U rdx=V
	movzx eax,word ptr[r10+2*rbx]
	add ax,word ptr[r10+2*rdx+512]
	add rsi,2
	vpinsrw xmm0,xmm0,eax,6
	movzx eax,word ptr[r10+2*rbx]
	add ax,word ptr[r10+2*r15+1024]
	add ax,word ptr[r10+2*rdx+1536]
	add r11,2
	vpinsrw xmm0,xmm0,eax,5
	movzx eax,word ptr[r10+2*rbx]
	add ax,word ptr[r10+2*r15+2048]
	add r12,2
	vpinsrw xmm0,xmm0,eax,4
	
	vpaddsw xmm0,xmm0,xmm1
	vpsraw xmm0,xmm0,5
	vpackuswb xmm3,xmm0,xmm0
	
	vmovq qword ptr[rdi],xmm3
	
	add rdi,8
	
	test r9d,1
	jz short Convert_YV24toRGB32_AVX_5
	
	movzx ebx,byte ptr[rsi]
	movzx r15d,byte ptr[r11]
	movzx edx,byte ptr[r12] ; rbx=Y r15=U rdx=V
	movzx eax,word ptr[r10+2*rbx]
	add ax,word ptr[r10+2*rdx+512]
	inc rsi
	vpinsrw xmm0,xmm0,eax,2
	movzx eax,word ptr[r10+2*rbx]
	add ax,word ptr[r10+2*r15+1024]
	add ax,word ptr[r10+2*rdx+1536]
	inc r11
	vpinsrw xmm0,xmm0,eax,1
	movzx eax,word ptr[r10+2*rbx]
	add ax,word ptr[r10+2*r15+2048]
	inc r12
	vpinsrw xmm0,xmm0,eax,0
	
	vpaddsw xmm0,xmm0,xmm1
	vpsraw xmm0,xmm0,5
	vpackuswb xmm3,xmm0,xmm0
	
	vmovd dword ptr[rdi],xmm3
	
	add rdi,r13
	
Convert_YV24toRGB32_AVX_5:	
	add rsi,src_modulo_y
	add r11,src_modulo_u
	add r12,src_modulo_v
	add rdi,dst_modulo
	dec h
	jnz Convert_YV24toRGB32_AVX_1

	pop r15
	pop r14
	pop r13
	pop r12
	pop rbx
	pop rsi
	pop rdi
	pop rbp
	
	ret

JPSDR_HDRTools_Convert_YV24toRGB32_AVX endp


;JPSDR_HDRTools_Convert_8_YV24toRGB64_SSE41 proc src_y:dword,src_u:dword,src_v:dword,dst:dword,w:dword,h:dword,offset_R:dword,
; offset_G:dword,offset_B:dword,lookup:dword,src_modulo_y:dword,src_modulo_u:dword,src_modulo_v:dword,dst_modulo:dword
; src_y = rcx
; src_u = rdx
; src_v = r8
; dst = r9

JPSDR_HDRTools_Convert_8_YV24toRGB64_SSE41 proc public frame

w equ dword ptr[rbp+48]
h equ dword ptr[rbp+56]
offset_R equ dword ptr[rbp+64]
offset_G equ dword ptr[rbp+72]
offset_B equ dword ptr[rbp+80]
lookup equ qword ptr[rbp+88]
src_modulo_y equ qword ptr[rbp+96]
src_modulo_u equ qword ptr[rbp+104]
src_modulo_v equ qword ptr[rbp+112]
dst_modulo equ qword ptr[rbp+120]

	push rbp
	.pushreg rbp
	mov rbp,rsp
	push rdi
	.pushreg rdi
	push rsi
	.pushreg rsi
	push rbx
	.pushreg rbx
	push r12
	.pushreg r12
	push r13
	.pushreg r13
	push r14
	.pushreg r14
	push r15
	.pushreg r15
	.endprolog

	xor rax,rax
	pxor xmm1,xmm1
	mov eax,offset_B
	pinsrd xmm1,eax,0
	mov eax,offset_G
	pinsrd xmm1,eax,1
	mov eax,offset_R
	pinsrd xmm1,eax,2
	mov rsi,rcx					;rsi=src_y
	mov r11,rdx					;r11=src_u
	mov r12,r8					;r12=src_v
	mov rdi,r9
	mov r9d,w
	mov r10,lookup
	mov r13,2
	mov r14,16
	
	mov r8d,r9d					;r8d=w0
	shr r8d,1
	
	xor rdx,rdx
	xor rbx,rbx
	xor r15,r15

Convert_8_YV24toRGB64_SSE41_1:
	or r8d,r8d
	jz Convert_8_YV24toRGB64_SSE41_3

	mov ecx,r8d
Convert_8_YV24toRGB64_SSE41_2:
	pxor xmm2,xmm2
	pxor xmm0,xmm0

	movzx ebx,byte ptr[rsi]
	movzx r15d,byte ptr[r11]
	movzx edx,byte ptr[r12] ; rbx=Y r15=U rdx=V
	mov eax,dword ptr[r10+4*rbx]
	add eax,dword ptr[r10+4*rdx+1024]
	pinsrd xmm0,eax,2
	mov eax,dword ptr[r10+4*rbx]
	add eax,dword ptr[r10+4*r15+2048]
	add eax,dword ptr[r10+4*rdx+3072]
	pinsrd xmm0,eax,1
	mov eax,dword ptr[r10+4*rbx]
	add eax,dword ptr[r10+4*r15+4096]
	pinsrd xmm0,eax,0

	movzx ebx,byte ptr[rsi+1]
	movzx r15d,byte ptr[r11+1]
	movzx edx,byte ptr[r12+1] ; rbx=Y r15=U rdx=V
	mov eax,dword ptr[r10+4*rbx]
	add eax,dword ptr[r10+4*rdx+1024]
	add rsi,r13
	pinsrd xmm2,eax,2
	mov eax,dword ptr[r10+4*rbx]
	add eax,dword ptr[r10+4*r15+2048]
	add eax,dword ptr[r10+4*rdx+3072]
	add r11,r13
	pinsrd xmm2,eax,1
	mov eax,dword ptr[r10+4*rbx]
	add eax,dword ptr[r10+4*r15+4096]
	add r12,r13
	pinsrd xmm2,eax,0

	paddd xmm0,xmm1
	paddd xmm2,xmm1
	psrad xmm0,8
	psrad xmm2,8
	packusdw xmm0,xmm2
	
	movdqa XMMWORD ptr[rdi],xmm0
	
	add rdi,r14
	
	dec ecx
	jnz Convert_8_YV24toRGB64_SSE41_2
	
Convert_8_YV24toRGB64_SSE41_3:	
	test r9d,1
	jz short Convert_8_YV24toRGB64_SSE41_4
	
	pxor xmm0,xmm0
	
	movzx ebx,byte ptr[rsi]
	movzx r15d,byte ptr[r11]
	movzx edx,byte ptr[r12] ; rbx=Y r15=U rdx=V
	mov eax,dword ptr[r10+4*rbx]
	add eax,dword ptr[r10+4*rdx+1024]
	inc rsi
	pinsrd xmm0,eax,2
	mov eax,dword ptr[r10+4*rbx]
	add eax,dword ptr[r10+4*r15+2048]
	add eax,dword ptr[r10+4*rdx+3072]
	inc r11
	pinsrd xmm0,eax,1
	mov eax,dword ptr[r10+4*rbx]
	add eax,dword ptr[r10+4*r15+4096]
	inc r12
	pinsrd xmm0,eax,0
	
	paddd xmm0,xmm1
	psrad xmm0,8
	packusdw xmm0,xmm0
	
	movq qword ptr[rdi],xmm0
	
	add rdi,8
	
Convert_8_YV24toRGB64_SSE41_4:	
	add rsi,src_modulo_y
	add r11,src_modulo_u
	add r12,src_modulo_v
	add rdi,dst_modulo
	dec h
	jnz Convert_8_YV24toRGB64_SSE41_1

	pop r15
	pop r14
	pop r13
	pop r12
	pop rbx
	pop rsi
	pop rdi
	pop rbp
	
	ret

JPSDR_HDRTools_Convert_8_YV24toRGB64_SSE41 endp


;JPSDR_HDRTools_Convert_10_YV24toRGB64_SSE41 proc src_y:dword,src_u:dword,src_v:dword,dst:dword,w:dword,h:dword,offset_R:dword,
; offset_G:dword,offset_B:dword,lookup:dword,src_modulo_y:dword,src_modulo_u:dword,src_modulo_v:dword,dst_modulo:dword
; src_y = rcx
; src_u = rdx
; src_v = r8
; dst = r9

JPSDR_HDRTools_Convert_10_YV24toRGB64_SSE41 proc public frame

w equ dword ptr[rbp+48]
h equ dword ptr[rbp+56]
offset_R equ dword ptr[rbp+64]
offset_G equ dword ptr[rbp+72]
offset_B equ dword ptr[rbp+80]
lookup equ qword ptr[rbp+88]
src_modulo_y equ qword ptr[rbp+96]
src_modulo_u equ qword ptr[rbp+104]
src_modulo_v equ qword ptr[rbp+112]
dst_modulo equ qword ptr[rbp+120]

	push rbp
	.pushreg rbp
	mov rbp,rsp
	push rdi
	.pushreg rdi
	push rsi
	.pushreg rsi
	push rbx
	.pushreg rbx
	push r12
	.pushreg r12
	push r13
	.pushreg r13
	push r14
	.pushreg r14
	push r15
	.pushreg r15
	.endprolog

	xor rax,rax
	pxor xmm1,xmm1
	mov eax,offset_B
	pinsrd xmm1,eax,0
	mov eax,offset_G
	pinsrd xmm1,eax,1
	mov eax,offset_R
	pinsrd xmm1,eax,2
	mov rsi,rcx					;rsi=src_y
	mov r11,rdx					;r11=src_u
	mov r12,r8					;r12=src_v
	mov rdi,r9
	mov r9d,w
	mov r10,lookup
	mov r13,4
	mov r14,16
	
	mov r8d,r9d					;r8d=w0
	shr r8d,1
	
	xor rdx,rdx
	xor rbx,rbx
	xor r15,r15

Convert_10_YV24toRGB64_SSE41_1:
	or r8d,r8d
	jz Convert_10_YV24toRGB64_SSE41_3

	mov ecx,r8d
Convert_10_YV24toRGB64_SSE41_2:
	pxor xmm2,xmm2
	pxor xmm0,xmm0

	movzx ebx,word ptr[rsi]
	movzx r15d,word ptr[r11]
	movzx edx,word ptr[r12] ; rbx=Y r15=U rdx=V
	mov eax,dword ptr[r10+4*rbx]
	add eax,dword ptr[r10+4*rdx+4096]
	pinsrd xmm0,eax,2
	mov eax,dword ptr[r10+4*rbx]
	add eax,dword ptr[r10+4*r15+8192]
	add eax,dword ptr[r10+4*rdx+12288]
	pinsrd xmm0,eax,1
	mov eax,dword ptr[r10+4*rbx]
	add eax,dword ptr[r10+4*r15+16384]
	pinsrd xmm0,eax,0

	movzx ebx,word ptr[rsi+2]
	movzx r15d,word ptr[r11+2]
	movzx edx,word ptr[r12+2] ; rbx=Y r15=U rdx=V
	mov eax,dword ptr[r10+4*rbx]
	add eax,dword ptr[r10+4*rdx+4096]
	add rsi,r13
	pinsrd xmm2,eax,2
	mov eax,dword ptr[r10+4*rbx]
	add eax,dword ptr[r10+4*r15+8192]
	add eax,dword ptr[r10+4*rdx+12288]
	add r11,r13
	pinsrd xmm2,eax,1
	mov eax,dword ptr[r10+4*rbx]
	add eax,dword ptr[r10+4*r15+16384]
	add r12,r13
	pinsrd xmm2,eax,0

	paddd xmm0,xmm1
	paddd xmm2,xmm1
	psrad xmm0,8
	psrad xmm2,8
	packusdw xmm0,xmm2
	
	movdqa XMMWORD ptr[rdi],xmm0
	
	add rdi,r14
	
	dec ecx
	jnz Convert_10_YV24toRGB64_SSE41_2
	
Convert_10_YV24toRGB64_SSE41_3:
	test r9d,1
	jz short Convert_10_YV24toRGB64_SSE41_4
		
	pxor xmm0,xmm0
	
	movzx ebx,word ptr[rsi]
	movzx r15d,word ptr[r11]
	movzx edx,word ptr[r12] ; rbx=Y r15=U rdx=V
	mov eax,dword ptr[r10+4*rbx]
	add eax,dword ptr[r10+4*rdx+4096]
	add rsi,2
	pinsrd xmm0,eax,2
	mov eax,dword ptr[r10+4*rbx]
	add eax,dword ptr[r10+4*r15+8192]
	add eax,dword ptr[r10+4*rdx+12288]
	add r11,2
	pinsrd xmm0,eax,1
	mov eax,dword ptr[r10+4*rbx]
	add eax,dword ptr[r10+4*r15+16384]
	add r12,2
	pinsrd xmm0,eax,0
	
	paddd xmm0,xmm1
	psrad xmm0,8
	packusdw xmm0,xmm0
	
	movq qword ptr[rdi],xmm0
	
	add rdi,8
	
Convert_10_YV24toRGB64_SSE41_4:	
	add rsi,src_modulo_y
	add r11,src_modulo_u
	add r12,src_modulo_v
	add rdi,dst_modulo
	dec h
	jnz Convert_10_YV24toRGB64_SSE41_1

	pop r15
	pop r14
	pop r13
	pop r12
	pop rbx
	pop rsi
	pop rdi
	pop rbp
	
	ret

JPSDR_HDRTools_Convert_10_YV24toRGB64_SSE41 endp


;JPSDR_HDRTools_Convert_12_YV24toRGB64_SSE41 proc src_y:dword,src_u:dword,src_v:dword,dst:dword,w:dword,h:dword,offset_R:dword,
; offset_G:dword,offset_B:dword,lookup:dword,src_modulo_y:dword,src_modulo_u:dword,src_modulo_v:dword,dst_modulo:dword
; src_y = rcx
; src_u = rdx
; src_v = r8
; dst = r9

JPSDR_HDRTools_Convert_12_YV24toRGB64_SSE41 proc public frame

w equ dword ptr[rbp+48]
h equ dword ptr[rbp+56]
offset_R equ dword ptr[rbp+64]
offset_G equ dword ptr[rbp+72]
offset_B equ dword ptr[rbp+80]
lookup equ qword ptr[rbp+88]
src_modulo_y equ qword ptr[rbp+96]
src_modulo_u equ qword ptr[rbp+104]
src_modulo_v equ qword ptr[rbp+112]
dst_modulo equ qword ptr[rbp+120]

	push rbp
	.pushreg rbp
	mov rbp,rsp
	push rdi
	.pushreg rdi
	push rsi
	.pushreg rsi
	push rbx
	.pushreg rbx
	push r12
	.pushreg r12
	push r13
	.pushreg r13
	push r14
	.pushreg r14
	push r15
	.pushreg r15
	.endprolog

	xor rax,rax
	pxor xmm1,xmm1
	mov eax,offset_B
	pinsrd xmm1,eax,0
	mov eax,offset_G
	pinsrd xmm1,eax,1
	mov eax,offset_R
	pinsrd xmm1,eax,2
	mov rsi,rcx					;rsi=src_y
	mov r11,rdx					;r11=src_u
	mov r12,r8					;r12=src_v
	mov rdi,r9
	mov r9d,w
	mov r10,lookup
	mov r13,4
	mov r14,16
	
	mov r8d,r9d					;r8d=w0
	shr r8d,1
	
	xor rdx,rdx
	xor rbx,rbx
	xor r15,r15

Convert_12_YV24toRGB64_SSE41_1:
	or r8d,r8d
	jz Convert_12_YV24toRGB64_SSE41_3

	mov ecx,r8d
Convert_12_YV24toRGB64_SSE41_2:
	pxor xmm2,xmm2
	pxor xmm0,xmm0

	movzx ebx,word ptr[rsi]
	movzx r15d,word ptr[r11]
	movzx edx,word ptr[r12] ; rbx=Y r15=U rdx=V
	mov eax,dword ptr[r10+4*rbx]
	add eax,dword ptr[r10+4*rdx+16384]
	pinsrd xmm0,eax,2
	mov eax,dword ptr[r10+4*rbx]
	add eax,dword ptr[r10+4*r15+32768]
	add eax,dword ptr[r10+4*rdx+49152]
	pinsrd xmm0,eax,1
	mov eax,dword ptr[r10+4*rbx]
	add eax,dword ptr[r10+4*r15+65536]
	pinsrd xmm0,eax,0

	movzx ebx,word ptr[rsi+2]
	movzx r15d,word ptr[r11+2]
	movzx edx,word ptr[r12+2] ; rbx=Y r15=U rdx=V
	mov eax,dword ptr[r10+4*rbx]
	add eax,dword ptr[r10+4*rdx+16384]
	add rsi,r13
	pinsrd xmm2,eax,2
	mov eax,dword ptr[r10+4*rbx]
	add eax,dword ptr[r10+4*r15+32768]
	add eax,dword ptr[r10+4*rdx+49152]
	add r11,r13
	pinsrd xmm2,eax,1
	mov eax,dword ptr[r10+4*rbx]
	add eax,dword ptr[r10+4*r15+65536]
	add r12,r13
	pinsrd xmm2,eax,0
	
	paddd xmm0,xmm1
	paddd xmm2,xmm1
	psrad xmm0,8
	psrad xmm2,8
	packusdw xmm0,xmm2
	
	movdqa XMMWORD ptr[rdi],xmm0
	
	add rdi,r14
	
	dec ecx
	jnz Convert_12_YV24toRGB64_SSE41_2
	
Convert_12_YV24toRGB64_SSE41_3:
	test r9d,1
	jz short Convert_12_YV24toRGB64_SSE41_4
	
	pxor xmm0,xmm0

	movzx ebx,word ptr[rsi]
	movzx r15d,word ptr[r11]
	movzx edx,word ptr[r12] ; rbx=Y r15=U rdx=V
	mov eax,dword ptr[r10+4*rbx]
	add eax,dword ptr[r10+4*rdx+16384]
	add rsi,2
	pinsrd xmm0,eax,2
	mov eax,dword ptr[r10+4*rbx]
	add eax,dword ptr[r10+4*r15+32768]
	add eax,dword ptr[r10+4*rdx+49152]
	add r11,2
	pinsrd xmm0,eax,1
	mov eax,dword ptr[r10+4*rbx]
	add eax,dword ptr[r10+4*r15+65536]
	add r12,2
	pinsrd xmm0,eax,0
	
	paddd xmm0,xmm1
	psrad xmm0,8
	packusdw xmm0,xmm0
	
	movq qword ptr[rdi],xmm0
	
	add rdi,8
	
Convert_12_YV24toRGB64_SSE41_4:	
	add rsi,src_modulo_y
	add r11,src_modulo_u
	add r12,src_modulo_v
	add rdi,dst_modulo
	dec h
	jnz Convert_12_YV24toRGB64_SSE41_1

	pop r15
	pop r14
	pop r13
	pop r12
	pop rbx
	pop rsi
	pop rdi
	pop rbp
	
	ret

JPSDR_HDRTools_Convert_12_YV24toRGB64_SSE41 endp


;JPSDR_HDRTools_Convert_14_YV24toRGB64_SSE41 proc src_y:dword,src_u:dword,src_v:dword,dst:dword,w:dword,h:dword,offset_R:dword,
; offset_G:dword,offset_B:dword,lookup:dword,src_modulo_y:dword,src_modulo_u:dword,src_modulo_v:dword,dst_modulo:dword
; src_y = rcx
; src_u = rdx
; src_v = r8
; dst = r9

JPSDR_HDRTools_Convert_14_YV24toRGB64_SSE41 proc public frame

w equ dword ptr[rbp+48]
h equ dword ptr[rbp+56]
offset_R equ dword ptr[rbp+64]
offset_G equ dword ptr[rbp+72]
offset_B equ dword ptr[rbp+80]
lookup equ qword ptr[rbp+88]
src_modulo_y equ qword ptr[rbp+96]
src_modulo_u equ qword ptr[rbp+104]
src_modulo_v equ qword ptr[rbp+112]
dst_modulo equ qword ptr[rbp+120]

	push rbp
	.pushreg rbp
	mov rbp,rsp
	push rdi
	.pushreg rdi
	push rsi
	.pushreg rsi
	push rbx
	.pushreg rbx
	push r12
	.pushreg r12
	push r13
	.pushreg r13
	push r14
	.pushreg r14
	push r15
	.pushreg r15
	.endprolog

	xor rax,rax
	pxor xmm1,xmm1
	mov eax,offset_B
	pinsrd xmm1,eax,0
	mov eax,offset_G
	pinsrd xmm1,eax,1
	mov eax,offset_R
	pinsrd xmm1,eax,2
	mov rsi,rcx					;rsi=src_y
	mov r11,rdx					;r11=src_u
	mov r12,r8					;r12=src_v
	mov rdi,r9
	mov r9d,w
	mov r10,lookup
	mov r13,4
	mov r14,16
	
	mov r8d,r9d					;r8d=w0
	shr r8d,1
	
	xor rdx,rdx
	xor rbx,rbx
	xor r15,r15

Convert_14_YV24toRGB64_SSE41_1:
	or r8d,r8d
	jz Convert_14_YV24toRGB64_SSE41_3

	mov ecx,r8d
Convert_14_YV24toRGB64_SSE41_2:
	pxor xmm2,xmm2
	pxor xmm0,xmm0

	movzx ebx,word ptr[rsi]
	movzx r15d,word ptr[r11]
	movzx edx,word ptr[r12] ; rbx=Y r15=U rdx=V
	mov eax,dword ptr[r10+4*rbx]
	add eax,dword ptr[r10+4*rdx+65536]
	pinsrd xmm0,eax,2
	mov eax,dword ptr[r10+4*rbx]
	add eax,dword ptr[r10+4*r15+131072]
	add eax,dword ptr[r10+4*rdx+196608]
	pinsrd xmm0,eax,1
	mov eax,dword ptr[r10+4*rbx]
	add eax,dword ptr[r10+4*r15+262144]
	pinsrd xmm0,eax,0

	movzx ebx,word ptr[rsi+2]
	movzx r15d,word ptr[r11+2]
	movzx edx,word ptr[r12+2] ; rbx=Y r15=U rdx=V
	mov eax,dword ptr[r10+4*rbx]
	add eax,dword ptr[r10+4*rdx+65536]
	add rsi,r13
	pinsrd xmm2,eax,2
	mov eax,dword ptr[r10+4*rbx]
	add eax,dword ptr[r10+4*r15+131072]
	add eax,dword ptr[r10+4*rdx+196608]
	add r11,r13
	pinsrd xmm2,eax,1
	mov eax,dword ptr[r10+4*rbx]
	add eax,dword ptr[r10+4*r15+262144]
	add r12,r13
	pinsrd xmm2,eax,0
	
	paddd xmm0,xmm1
	paddd xmm2,xmm1
	psrad xmm0,8
	psrad xmm2,8
	packusdw xmm0,xmm2
	
	movdqa XMMWORD ptr[rdi],xmm0
	
	add rdi,r14
	
	dec ecx
	jnz Convert_14_YV24toRGB64_SSE41_2
	
Convert_14_YV24toRGB64_SSE41_3:
	test r9d,1
	jz short Convert_14_YV24toRGB64_SSE41_4

	pxor xmm0,xmm0
	
	movzx ebx,word ptr[rsi]
	movzx r15d,word ptr[r11]
	movzx edx,word ptr[r12] ; rbx=Y r15=U rdx=V
	mov eax,dword ptr[r10+4*rbx]
	add eax,dword ptr[r10+4*rdx+65536]
	add rsi,2
	pinsrd xmm0,eax,2
	mov eax,dword ptr[r10+4*rbx]
	add eax,dword ptr[r10+4*r15+131072]
	add eax,dword ptr[r10+4*rdx+196608]
	add r11,2
	pinsrd xmm0,eax,1
	mov eax,dword ptr[r10+4*rbx]
	add eax,dword ptr[r10+4*r15+262144]
	add r12,2
	pinsrd xmm0,eax,0
	
	paddd xmm0,xmm1
	psrad xmm0,8
	packusdw xmm0,xmm0
	
	movq qword ptr[rdi],xmm0
	
	add rdi,8
	
Convert_14_YV24toRGB64_SSE41_4:	
	add rsi,src_modulo_y
	add r11,src_modulo_u
	add r12,src_modulo_v
	add rdi,dst_modulo
	dec h
	jnz Convert_14_YV24toRGB64_SSE41_1

	pop r15
	pop r14
	pop r13
	pop r12
	pop rbx
	pop rsi
	pop rdi
	pop rbp
	
	ret

JPSDR_HDRTools_Convert_14_YV24toRGB64_SSE41 endp


;JPSDR_HDRTools_Convert_16_YV24toRGB64_SSE41 proc src_y:dword,src_u:dword,src_v:dword,dst:dword,w:dword,h:dword,offset_R:dword,
; offset_G:dword,offset_B:dword,lookup:dword,src_modulo_y:dword,src_modulo_u:dword,src_modulo_v:dword,dst_modulo:dword
; src_y = rcx
; src_u = rdx
; src_v = r8
; dst = r9

JPSDR_HDRTools_Convert_16_YV24toRGB64_SSE41 proc public frame

w equ dword ptr[rbp+48]
h equ dword ptr[rbp+56]
offset_R equ dword ptr[rbp+64]
offset_G equ dword ptr[rbp+72]
offset_B equ dword ptr[rbp+80]
lookup equ qword ptr[rbp+88]
src_modulo_y equ qword ptr[rbp+96]
src_modulo_u equ qword ptr[rbp+104]
src_modulo_v equ qword ptr[rbp+112]
dst_modulo equ qword ptr[rbp+120]

	push rbp
	.pushreg rbp
	mov rbp,rsp
	push rdi
	.pushreg rdi
	push rsi
	.pushreg rsi
	push rbx
	.pushreg rbx
	push r12
	.pushreg r12
	push r13
	.pushreg r13
	push r14
	.pushreg r14
	push r15
	.pushreg r15
	.endprolog

	xor rax,rax
	pxor xmm1,xmm1
	mov eax,offset_B
	pinsrd xmm1,eax,0
	mov eax,offset_G
	pinsrd xmm1,eax,1
	mov eax,offset_R
	pinsrd xmm1,eax,2
	mov rsi,rcx					;rsi=src_y
	mov r11,rdx					;r11=src_u
	mov r12,r8					;r12=src_v
	mov rdi,r9
	mov r9d,w
	mov r10,lookup
	mov r13,4
	mov r14,16
	
	mov r8d,r9d					;r8d=w0
	shr r8d,1
	
	xor rdx,rdx
	xor rbx,rbx
	xor r15,r15

Convert_16_YV24toRGB64_SSE41_1:
	or r8d,r8d
	jz Convert_16_YV24toRGB64_SSE41_3

	mov ecx,r8d
Convert_16_YV24toRGB64_SSE41_2:
	pxor xmm2,xmm2
	pxor xmm0,xmm0

	movzx ebx,word ptr[rsi]
	movzx r15d,word ptr[r11]
	movzx edx,word ptr[r12] ; rbx=Y r15=U rdx=V
	mov eax,dword ptr[r10+4*rbx]
	add eax,dword ptr[r10+4*rdx+262144]
	pinsrd xmm0,eax,2
	mov eax,dword ptr[r10+4*rbx]
	add eax,dword ptr[r10+4*r15+524288]
	add eax,dword ptr[r10+4*rdx+786432]
	pinsrd xmm0,eax,1
	mov eax,dword ptr[r10+4*rbx]
	add eax,dword ptr[r10+4*r15+1048576]
	pinsrd xmm0,eax,0

	movzx ebx,word ptr[rsi+2]
	movzx r15d,word ptr[r11+2]
	movzx edx,word ptr[r12+2] ; rbx=Y r15=U rdx=V
	mov eax,dword ptr[r10+4*rbx]
	add eax,dword ptr[r10+4*rdx+262144]
	add rsi,r13
	pinsrd xmm2,eax,2
	mov eax,dword ptr[r10+4*rbx]
	add eax,dword ptr[r10+4*r15+524288]
	add eax,dword ptr[r10+4*rdx+786432]
	add r11,r13
	pinsrd xmm2,eax,1
	mov eax,dword ptr[r10+4*rbx]
	add eax,dword ptr[r10+4*r15+1048576]
	add r12,r13
	pinsrd xmm2,eax,0
	
	paddd xmm0,xmm1
	paddd xmm2,xmm1
	psrad xmm0,8
	psrad xmm2,8
	packusdw xmm0,xmm2
	
	movdqa XMMWORD ptr[rdi],xmm0
	
	add rdi,r14
	
	dec ecx
	jnz Convert_16_YV24toRGB64_SSE41_2
	
Convert_16_YV24toRGB64_SSE41_3:	
	test r9d,1
	jz short Convert_16_YV24toRGB64_SSE41_4

	pxor xmm0,xmm0

	movzx ebx,word ptr[rsi]
	movzx r15d,word ptr[r11]
	movzx edx,word ptr[r12] ; rbx=Y r15=U rdx=V
	mov eax,dword ptr[r10+4*rbx]
	add eax,dword ptr[r10+4*rdx+262144]
	add rsi,2
	pinsrd xmm0,eax,2
	mov eax,dword ptr[r10+4*rbx]
	add eax,dword ptr[r10+4*r15+524288]
	add eax,dword ptr[r10+4*rdx+786432]
	add r11,2
	pinsrd xmm0,eax,1
	mov eax,dword ptr[r10+4*rbx]
	add eax,dword ptr[r10+4*r15+1048576]
	add r12,2
	pinsrd xmm0,eax,0
	
	paddd xmm0,xmm1
	psrad xmm0,8
	packusdw xmm0,xmm0
	
	movq qword ptr[rdi],xmm0
	
	add rdi,8
	
Convert_16_YV24toRGB64_SSE41_4:	
	add rsi,src_modulo_y
	add r11,src_modulo_u
	add r12,src_modulo_v
	add rdi,dst_modulo
	dec h
	jnz Convert_16_YV24toRGB64_SSE41_1

	pop r15
	pop r14
	pop r13
	pop r12
	pop rbx
	pop rsi
	pop rdi
	pop rbp
	
	ret

JPSDR_HDRTools_Convert_16_YV24toRGB64_SSE41 endp


;JPSDR_HDRTools_Convert_8_YV24toRGB64_AVX proc src_y:dword,src_u:dword,src_v:dword,dst:dword,w:dword,h:dword,offset_R:dword,
; offset_G:dword,offset_B:dword,lookup:dword,src_modulo_y:dword,src_modulo_u:dword,src_modulo_v:dword,dst_modulo:dword
; src_y = rcx
; src_u = rdx
; src_v = r8
; dst = r9

JPSDR_HDRTools_Convert_8_YV24toRGB64_AVX proc public frame

w equ dword ptr[rbp+48]
h equ dword ptr[rbp+56]
offset_R equ dword ptr[rbp+64]
offset_G equ dword ptr[rbp+72]
offset_B equ dword ptr[rbp+80]
lookup equ qword ptr[rbp+88]
src_modulo_y equ qword ptr[rbp+96]
src_modulo_u equ qword ptr[rbp+104]
src_modulo_v equ qword ptr[rbp+112]
dst_modulo equ qword ptr[rbp+120]

	push rbp
	.pushreg rbp
	mov rbp,rsp
	push rdi
	.pushreg rdi
	push rsi
	.pushreg rsi
	push rbx
	.pushreg rbx
	push r12
	.pushreg r12
	push r13
	.pushreg r13
	push r14
	.pushreg r14
	push r15
	.pushreg r15
	.endprolog

	xor rax,rax
	vpxor xmm2,xmm2,xmm2
	vpxor xmm1,xmm1,xmm1
	vpxor xmm0,xmm0,xmm0
	mov eax,offset_B
	vpinsrd xmm1,xmm1,eax,0
	mov eax,offset_G
	vpinsrd xmm1,xmm1,eax,1
	mov eax,offset_R
	vpinsrd xmm1,xmm1,eax,2
	mov rsi,rcx					;rsi=src_y
	mov r11,rdx					;r11=src_u
	mov r12,r8					;r12=src_v
	mov rdi,r9
	mov r9d,w
	mov r10,lookup
	mov r13,2
	mov r14,16
	
	mov r8d,r9d					;r8d=w0
	shr r8d,1
	
	xor rdx,rdx
	xor rbx,rbx
	xor r15,r15

Convert_8_YV24toRGB64_AVX_1:
	or r8d,r8d
	jz Convert_8_YV24toRGB64_AVX_3

	mov ecx,r8d
Convert_8_YV24toRGB64_AVX_2:
	movzx ebx,byte ptr[rsi]
	movzx r15d,byte ptr[r11]
	movzx edx,byte ptr[r12] ; rbx=Y r15=U rdx=V
	mov eax,dword ptr[r10+4*rbx]
	add eax,dword ptr[r10+4*rdx+1024]
	vpinsrd xmm0,xmm0,eax,2
	mov eax,dword ptr[r10+4*rbx]
	add eax,dword ptr[r10+4*r15+2048]
	add eax,dword ptr[r10+4*rdx+3072]
	vpinsrd xmm0,xmm0,eax,1
	mov eax,dword ptr[r10+4*rbx]
	add eax,dword ptr[r10+4*r15+4096]
	vpinsrd xmm0,xmm0,eax,0

	movzx ebx,byte ptr[rsi+1]
	movzx r15d,byte ptr[r11+1]
	movzx edx,byte ptr[r12+1] ; rbx=Y r15=U rdx=V
	mov eax,dword ptr[r10+4*rbx]
	add eax,dword ptr[r10+4*rdx+1024]
	add rsi,r13
	vpinsrd xmm2,xmm2,eax,2
	mov eax,dword ptr[r10+4*rbx]
	add eax,dword ptr[r10+4*r15+2048]
	add eax,dword ptr[r10+4*rdx+3072]
	add r11,r13
	vpinsrd xmm2,xmm2,eax,1
	mov eax,dword ptr[r10+4*rbx]
	add eax,dword ptr[r10+4*r15+4096]
	add r12,r13
	vpinsrd xmm2,xmm2,eax,0
	
	vpaddd xmm0,xmm0,xmm1
	vpaddd xmm2,xmm2,xmm1
	vpsrad xmm0,xmm0,8
	vpsrad xmm2,xmm2,8
	vpackusdw xmm3,xmm0,xmm2
	
	vmovdqa XMMWORD ptr[rdi],xmm3
	
	add rdi,r14
	
	dec ecx
	jnz Convert_8_YV24toRGB64_AVX_2
	
Convert_8_YV24toRGB64_AVX_3:
	test r9d,1
	jz short Convert_8_YV24toRGB64_AVX_4

	movzx ebx,byte ptr[rsi]
	movzx r15d,byte ptr[r11]
	movzx edx,byte ptr[r12] ; rbx=Y r15=U rdx=V
	mov eax,dword ptr[r10+4*rbx]
	add eax,dword ptr[r10+4*rdx+1024]
	inc rsi
	vpinsrd xmm0,xmm0,eax,2
	mov eax,dword ptr[r10+4*rbx]
	add eax,dword ptr[r10+4*r15+2048]
	add eax,dword ptr[r10+4*rdx+3072]
	inc r11
	vpinsrd xmm0,xmm0,eax,1
	mov eax,dword ptr[r10+4*rbx]
	add eax,dword ptr[r10+4*r15+4096]
	inc r12
	vpinsrd xmm0,xmm0,eax,0
	
	vpaddd xmm0,xmm0,xmm1
	vpsrad xmm0,xmm0,8
	vpackusdw xmm3,xmm0,xmm0
	
	vmovq qword ptr[rdi],xmm3
	
	add rdi,8

Convert_8_YV24toRGB64_AVX_4:	
	add rsi,src_modulo_y
	add r11,src_modulo_u
	add r12,src_modulo_v
	add rdi,dst_modulo
	dec h
	jnz Convert_8_YV24toRGB64_AVX_1

	pop r15
	pop r14
	pop r13
	pop r12
	pop rbx
	pop rsi
	pop rdi
	pop rbp
	
	ret

JPSDR_HDRTools_Convert_8_YV24toRGB64_AVX endp


;JPSDR_HDRTools_Convert_10_YV24toRGB64_AVX proc src_y:dword,src_u:dword,src_v:dword,dst:dword,w:dword,h:dword,offset_R:dword,
; offset_G:dword,offset_B:dword,lookup:dword,src_modulo_y:dword,src_modulo_u:dword,src_modulo_v:dword,dst_modulo:dword
; src_y = rcx
; src_u = rdx
; src_v = r8
; dst = r9

JPSDR_HDRTools_Convert_10_YV24toRGB64_AVX proc public frame

w equ dword ptr[rbp+48]
h equ dword ptr[rbp+56]
offset_R equ dword ptr[rbp+64]
offset_G equ dword ptr[rbp+72]
offset_B equ dword ptr[rbp+80]
lookup equ qword ptr[rbp+88]
src_modulo_y equ qword ptr[rbp+96]
src_modulo_u equ qword ptr[rbp+104]
src_modulo_v equ qword ptr[rbp+112]
dst_modulo equ qword ptr[rbp+120]

	push rbp
	.pushreg rbp
	mov rbp,rsp
	push rdi
	.pushreg rdi
	push rsi
	.pushreg rsi
	push rbx
	.pushreg rbx
	push r12
	.pushreg r12
	push r13
	.pushreg r13
	push r14
	.pushreg r14
	push r15
	.pushreg r15
	.endprolog

	xor rax,rax
	vpxor xmm2,xmm2,xmm2
	vpxor xmm1,xmm1,xmm1
	vpxor xmm0,xmm0,xmm0
	mov eax,offset_B
	vpinsrd xmm1,xmm1,eax,0
	mov eax,offset_G
	vpinsrd xmm1,xmm1,eax,1
	mov eax,offset_R
	vpinsrd xmm1,xmm1,eax,2
	mov rsi,rcx					;rsi=src_y
	mov r11,rdx					;r11=src_u
	mov r12,r8					;r12=src_v
	mov rdi,r9
	mov r9d,w
	mov r10,lookup
	mov r13,4
	mov r14,16
	
	mov r8d,r9d					;r8d=w0
	shr r8d,1
	
	xor rdx,rdx
	xor rbx,rbx
	xor r15,r15

Convert_10_YV24toRGB64_AVX_1:
	or r8d,r8d
	jz Convert_10_YV24toRGB64_AVX_3

	mov ecx,r8d
Convert_10_YV24toRGB64_AVX_2:
	movzx ebx,word ptr[rsi]
	movzx r15d,word ptr[r11]
	movzx edx,word ptr[r12] ; rbx=Y r15=U rdx=V
	mov eax,dword ptr[r10+4*rbx]
	add eax,dword ptr[r10+4*rdx+4096]
	vpinsrd xmm0,xmm0,eax,2
	mov eax,dword ptr[r10+4*rbx]
	add eax,dword ptr[r10+4*r15+8192]
	add eax,dword ptr[r10+4*rdx+12288]
	vpinsrd xmm0,xmm0,eax,1
	mov eax,dword ptr[r10+4*rbx]
	add eax,dword ptr[r10+4*r15+16384]
	vpinsrd xmm0,xmm0,eax,0
	
	movzx ebx,word ptr[rsi+2]
	movzx r15d,word ptr[r11+2]
	movzx edx,word ptr[r12+2] ; rbx=Y r15=U rdx=V
	mov eax,dword ptr[r10+4*rbx]
	add eax,dword ptr[r10+4*rdx+4096]
	add rsi,r13
	vpinsrd xmm2,xmm2,eax,2
	mov eax,dword ptr[r10+4*rbx]
	add eax,dword ptr[r10+4*r15+8192]
	add eax,dword ptr[r10+4*rdx+12288]
	add r11,r13
	vpinsrd xmm2,xmm2,eax,1
	mov eax,dword ptr[r10+4*rbx]
	add eax,dword ptr[r10+4*r15+16384]
	add r12,r13
	vpinsrd xmm2,xmm2,eax,0
	
	vpaddd xmm0,xmm0,xmm1
	vpaddd xmm2,xmm2,xmm1
	vpsrad xmm0,xmm0,8
	vpsrad xmm2,xmm2,8
	vpackusdw xmm3,xmm0,xmm2
	
	vmovdqa XMMWORD ptr[rdi],xmm3
	
	add rdi,r14
	
	dec ecx
	jnz Convert_10_YV24toRGB64_AVX_2
	
Convert_10_YV24toRGB64_AVX_3:
	test r9d,1
	jz short Convert_10_YV24toRGB64_AVX_4

	movzx ebx,word ptr[rsi]
	movzx r15d,word ptr[r11]
	movzx edx,word ptr[r12] ; rbx=Y r15=U rdx=V
	mov eax,dword ptr[r10+4*rbx]
	add eax,dword ptr[r10+4*rdx+4096]
	add rsi,2
	vpinsrd xmm0,xmm0,eax,2
	mov eax,dword ptr[r10+4*rbx]
	add eax,dword ptr[r10+4*r15+8192]
	add eax,dword ptr[r10+4*rdx+12288]
	add r11,2
	vpinsrd xmm0,xmm0,eax,1
	mov eax,dword ptr[r10+4*rbx]
	add eax,dword ptr[r10+4*r15+16384]
	add r12,2
	vpinsrd xmm0,xmm0,eax,0
	
	vpaddd xmm0,xmm0,xmm1
	vpsrad xmm0,xmm0,8
	vpackusdw xmm3,xmm0,xmm0
	
	vmovq qword ptr[rdi],xmm3
	
	add rdi,8
	
Convert_10_YV24toRGB64_AVX_4:	
	add rsi,src_modulo_y
	add r11,src_modulo_u
	add r12,src_modulo_v
	add rdi,dst_modulo
	dec h
	jnz Convert_10_YV24toRGB64_AVX_1

	pop r15
	pop r14
	pop r13
	pop r12
	pop rbx
	pop rsi
	pop rdi
	pop rbp
	
	ret

JPSDR_HDRTools_Convert_10_YV24toRGB64_AVX endp


;JPSDR_HDRTools_Convert_12_YV24toRGB64_AVX proc src_y:dword,src_u:dword,src_v:dword,dst:dword,w:dword,h:dword,offset_R:dword,
; offset_G:dword,offset_B:dword,lookup:dword,src_modulo_y:dword,src_modulo_u:dword,src_modulo_v:dword,dst_modulo:dword
; src_y = rcx
; src_u = rdx
; src_v = r8
; dst = r9

JPSDR_HDRTools_Convert_12_YV24toRGB64_AVX proc public frame

w equ dword ptr[rbp+48]
h equ dword ptr[rbp+56]
offset_R equ dword ptr[rbp+64]
offset_G equ dword ptr[rbp+72]
offset_B equ dword ptr[rbp+80]
lookup equ qword ptr[rbp+88]
src_modulo_y equ qword ptr[rbp+96]
src_modulo_u equ qword ptr[rbp+104]
src_modulo_v equ qword ptr[rbp+112]
dst_modulo equ qword ptr[rbp+120]

	push rbp
	.pushreg rbp
	mov rbp,rsp
	push rdi
	.pushreg rdi
	push rsi
	.pushreg rsi
	push rbx
	.pushreg rbx
	push r12
	.pushreg r12
	push r13
	.pushreg r13
	push r14
	.pushreg r14
	push r15
	.pushreg r15
	.endprolog

	xor rax,rax
	vpxor xmm2,xmm2,xmm2
	vpxor xmm1,xmm1,xmm1
	vpxor xmm0,xmm0,xmm0
	mov eax,offset_B
	vpinsrd xmm1,xmm1,eax,0
	mov eax,offset_G
	vpinsrd xmm1,xmm1,eax,1
	mov eax,offset_R
	vpinsrd xmm1,xmm1,eax,2
	mov rsi,rcx					;rsi=src_y
	mov r11,rdx					;r11=src_u
	mov r12,r8					;r12=src_v
	mov rdi,r9
	mov r9d,w
	mov r10,lookup
	mov r13,4
	mov r14,16
	
	mov r8d,r9d					;r8d=w0
	shr r8d,1
	
	xor rdx,rdx
	xor rbx,rbx
	xor r15,r15

Convert_12_YV24toRGB64_AVX_1:
	or r8d,r8d
	jz Convert_12_YV24toRGB64_AVX_3

	mov ecx,r8d
Convert_12_YV24toRGB64_AVX_2:
	movzx ebx,word ptr[rsi]
	movzx r15d,word ptr[r11]
	movzx edx,word ptr[r12] ; rbx=Y r15=U rdx=V
	mov eax,dword ptr[r10+4*rbx]
	add eax,dword ptr[r10+4*rdx+16384]
	vpinsrd xmm0,xmm0,eax,2
	mov eax,dword ptr[r10+4*rbx]
	add eax,dword ptr[r10+4*r15+32768]
	add eax,dword ptr[r10+4*rdx+49152]
	vpinsrd xmm0,xmm0,eax,1
	mov eax,dword ptr[r10+4*rbx]
	add eax,dword ptr[r10+4*r15+65536]
	vpinsrd xmm0,xmm0,eax,0

	movzx ebx,word ptr[rsi+2]
	movzx r15d,word ptr[r11+2]
	movzx edx,word ptr[r12+2] ; rbx=Y r15=U rdx=V
	mov eax,dword ptr[r10+4*rbx]
	add eax,dword ptr[r10+4*rdx+16384]
	add rsi,r13
	vpinsrd xmm2,xmm2,eax,2
	mov eax,dword ptr[r10+4*rbx]
	add eax,dword ptr[r10+4*r15+32768]
	add eax,dword ptr[r10+4*rdx+49152]
	add r11,r13
	vpinsrd xmm2,xmm2,eax,1
	mov eax,dword ptr[r10+4*rbx]
	add eax,dword ptr[r10+4*r15+65536]
	add r12,r13
	vpinsrd xmm2,xmm2,eax,0
	
	vpaddd xmm0,xmm0,xmm1
	vpaddd xmm2,xmm2,xmm1
	vpsrad xmm0,xmm0,8
	vpsrad xmm2,xmm2,8
	vpackusdw xmm3,xmm0,xmm2
	
	vmovdqa XMMWORD ptr[rdi],xmm3
	
	add rdi,r14
	
	dec ecx
	jnz Convert_12_YV24toRGB64_AVX_2
	
Convert_12_YV24toRGB64_AVX_3:
	test r9d,1
	jz short Convert_12_YV24toRGB64_AVX_4
	
	movzx ebx,word ptr[rsi]
	movzx r15d,word ptr[r11]
	movzx edx,word ptr[r12] ; rbx=Y r15=U rdx=V
	mov eax,dword ptr[r10+4*rbx]
	add eax,dword ptr[r10+4*rdx+16384]
	add rsi,2
	vpinsrd xmm0,xmm0,eax,2
	mov eax,dword ptr[r10+4*rbx]
	add eax,dword ptr[r10+4*r15+32768]
	add eax,dword ptr[r10+4*rdx+49152]
	add r11,2
	vpinsrd xmm0,xmm0,eax,1
	mov eax,dword ptr[r10+4*rbx]
	add eax,dword ptr[r10+4*r15+65536]
	add r12,2
	vpinsrd xmm0,xmm0,eax,0
	
	vpaddd xmm0,xmm0,xmm1
	vpsrad xmm0,xmm0,8
	vpackusdw xmm3,xmm0,xmm0
	
	vmovq qword ptr[rdi],xmm3
	
	add rdi,8
	
Convert_12_YV24toRGB64_AVX_4:	
	add rsi,src_modulo_y
	add r11,src_modulo_u
	add r12,src_modulo_v
	add rdi,dst_modulo
	dec h
	jnz Convert_12_YV24toRGB64_AVX_1

	pop r15
	pop r14
	pop r13
	pop r12
	pop rbx
	pop rsi
	pop rdi
	pop rbp
	
	ret

JPSDR_HDRTools_Convert_12_YV24toRGB64_AVX endp


;JPSDR_HDRTools_Convert_14_YV24toRGB64_AVX proc src_y:dword,src_u:dword,src_v:dword,dst:dword,w:dword,h:dword,offset_R:dword,
; offset_G:dword,offset_B:dword,lookup:dword,src_modulo_y:dword,src_modulo_u:dword,src_modulo_v:dword,dst_modulo:dword
; src_y = rcx
; src_u = rdx
; src_v = r8
; dst = r9

JPSDR_HDRTools_Convert_14_YV24toRGB64_AVX proc public frame

w equ dword ptr[rbp+48]
h equ dword ptr[rbp+56]
offset_R equ dword ptr[rbp+64]
offset_G equ dword ptr[rbp+72]
offset_B equ dword ptr[rbp+80]
lookup equ qword ptr[rbp+88]
src_modulo_y equ qword ptr[rbp+96]
src_modulo_u equ qword ptr[rbp+104]
src_modulo_v equ qword ptr[rbp+112]
dst_modulo equ qword ptr[rbp+120]

	push rbp
	.pushreg rbp
	mov rbp,rsp
	push rdi
	.pushreg rdi
	push rsi
	.pushreg rsi
	push rbx
	.pushreg rbx
	push r12
	.pushreg r12
	push r13
	.pushreg r13
	push r14
	.pushreg r14
	push r15
	.pushreg r15
	.endprolog

	xor rax,rax
	vpxor xmm2,xmm2,xmm2
	vpxor xmm1,xmm1,xmm1
	vpxor xmm0,xmm0,xmm0
	mov eax,offset_B
	vpinsrd xmm1,xmm1,eax,0
	mov eax,offset_G
	vpinsrd xmm1,xmm1,eax,1
	mov eax,offset_R
	vpinsrd xmm1,xmm1,eax,2
	mov rsi,rcx					;rsi=src_y
	mov r11,rdx					;r11=src_u
	mov r12,r8					;r12=src_v
	mov rdi,r9
	mov r9d,w
	mov r10,lookup
	mov r13,4
	mov r14,16
	
	mov r8d,r9d					;r8d=w0
	shr r8d,1
	
	xor rdx,rdx
	xor rbx,rbx
	xor r15,r15

Convert_14_YV24toRGB64_AVX_1:
	or r8d,r8d
	jz Convert_14_YV24toRGB64_AVX_3

	mov ecx,r8d
Convert_14_YV24toRGB64_AVX_2:
	movzx ebx,word ptr[rsi]
	movzx r15d,word ptr[r11]
	movzx edx,word ptr[r12] ; rbx=Y r15=U rdx=V
	mov eax,dword ptr[r10+4*rbx]
	add eax,dword ptr[r10+4*rdx+65536]
	vpinsrd xmm0,xmm0,eax,2
	mov eax,dword ptr[r10+4*rbx]
	add eax,dword ptr[r10+4*r15+131072]
	add eax,dword ptr[r10+4*rdx+196608]
	vpinsrd xmm0,xmm0,eax,1
	mov eax,dword ptr[r10+4*rbx]
	add eax,dword ptr[r10+4*r15+262144]
	vpinsrd xmm0,xmm0,eax,0

	movzx ebx,word ptr[rsi+2]
	movzx r15d,word ptr[r11+2]
	movzx edx,word ptr[r12+2] ; rbx=Y r15=U rdx=V
	mov eax,dword ptr[r10+4*rbx]
	add eax,dword ptr[r10+4*rdx+65536]
	add rsi,r13
	vpinsrd xmm2,xmm2,eax,2
	mov eax,dword ptr[r10+4*rbx]
	add eax,dword ptr[r10+4*r15+131072]
	add eax,dword ptr[r10+4*rdx+196608]
	add r11,r13
	vpinsrd xmm2,xmm2,eax,1
	mov eax,dword ptr[r10+4*rbx]
	add eax,dword ptr[r10+4*r15+262144]
	add r12,r13
	vpinsrd xmm2,xmm2,eax,0
	
	vpaddd xmm0,xmm0,xmm1
	vpaddd xmm2,xmm2,xmm1
	vpsrad xmm0,xmm0,8
	vpsrad xmm2,xmm2,8
	vpackusdw xmm3,xmm0,xmm2
	
	vmovdqa XMMWORD ptr[rdi],xmm3
	
	add rdi,r14
	
	dec ecx
	jnz Convert_14_YV24toRGB64_AVX_2
	
Convert_14_YV24toRGB64_AVX_3:
	test r9d,1
	jz short Convert_14_YV24toRGB64_AVX_4
	
	movzx ebx,word ptr[rsi]
	movzx r15d,word ptr[r11]
	movzx edx,word ptr[r12] ; rbx=Y r15=U rdx=V
	mov eax,dword ptr[r10+4*rbx]
	add eax,dword ptr[r10+4*rdx+65536]
	add rsi,2
	vpinsrd xmm0,xmm0,eax,2
	mov eax,dword ptr[r10+4*rbx]
	add eax,dword ptr[r10+4*r15+131072]
	add eax,dword ptr[r10+4*rdx+196608]
	add r11,2
	vpinsrd xmm0,xmm0,eax,1
	mov eax,dword ptr[r10+4*rbx]
	add eax,dword ptr[r10+4*r15+262144]
	add r12,2
	vpinsrd xmm0,xmm0,eax,0
	
	vpaddd xmm0,xmm0,xmm1
	vpsrad xmm0,xmm0,8
	vpackusdw xmm3,xmm0,xmm0
	
	vmovq qword ptr[rdi],xmm3
	
	add rdi,8
	
Convert_14_YV24toRGB64_AVX_4:	
	add rsi,src_modulo_y
	add r11,src_modulo_u
	add r12,src_modulo_v
	add rdi,dst_modulo
	dec h
	jnz Convert_14_YV24toRGB64_AVX_1

	pop r15
	pop r14
	pop r13
	pop r12
	pop rbx
	pop rsi
	pop rdi
	pop rbp
	
	ret

JPSDR_HDRTools_Convert_14_YV24toRGB64_AVX endp


;JPSDR_HDRTools_Convert_16_YV24toRGB64_AVX proc src_y:dword,src_u:dword,src_v:dword,dst:dword,w:dword,h:dword,offset_R:dword,
; offset_G:dword,offset_B:dword,lookup:dword,src_modulo_y:dword,src_modulo_u:dword,src_modulo_v:dword,dst_modulo:dword
; src_y = rcx
; src_u = rdx
; src_v = r8
; dst = r9

JPSDR_HDRTools_Convert_16_YV24toRGB64_AVX proc public frame

w equ dword ptr[rbp+48]
h equ dword ptr[rbp+56]
offset_R equ dword ptr[rbp+64]
offset_G equ dword ptr[rbp+72]
offset_B equ dword ptr[rbp+80]
lookup equ qword ptr[rbp+88]
src_modulo_y equ qword ptr[rbp+96]
src_modulo_u equ qword ptr[rbp+104]
src_modulo_v equ qword ptr[rbp+112]
dst_modulo equ qword ptr[rbp+120]

	push rbp
	.pushreg rbp
	mov rbp,rsp
	push rdi
	.pushreg rdi
	push rsi
	.pushreg rsi
	push rbx
	.pushreg rbx
	push r12
	.pushreg r12
	push r13
	.pushreg r13
	push r14
	.pushreg r14
	push r15
	.pushreg r15
	.endprolog

	xor rax,rax
	vpxor xmm2,xmm2,xmm2
	vpxor xmm1,xmm1,xmm1
	vpxor xmm0,xmm0,xmm0
	mov eax,offset_B
	vpinsrd xmm1,xmm1,eax,0
	mov eax,offset_G
	vpinsrd xmm1,xmm1,eax,1
	mov eax,offset_R
	vpinsrd xmm1,xmm1,eax,2
	mov rsi,rcx					;rsi=src_y
	mov r11,rdx					;r11=src_u
	mov r12,r8					;r12=src_v
	mov rdi,r9
	mov r9d,w
	mov r10,lookup
	mov r13,4
	mov r14,16
	
	mov r8d,r9d					;r8d=w0
	shr r8d,1
	
	xor rdx,rdx
	xor rbx,rbx
	xor r15,r15

Convert_16_YV24toRGB64_AVX_1:
	or r8d,r8d
	jz Convert_16_YV24toRGB64_AVX_3

	mov ecx,r8d
Convert_16_YV24toRGB64_AVX_2:
	movzx ebx,word ptr[rsi]
	movzx r15d,word ptr[r11]
	movzx edx,word ptr[r12] ; rbx=Y r15=U rdx=V
	mov eax,dword ptr[r10+4*rbx]
	add eax,dword ptr[r10+4*rdx+262144]
	vpinsrd xmm0,xmm0,eax,2
	mov eax,dword ptr[r10+4*rbx]
	add eax,dword ptr[r10+4*r15+524288]
	add eax,dword ptr[r10+4*rdx+786432]
	vpinsrd xmm0,xmm0,eax,1
	mov eax,dword ptr[r10+4*rbx]
	add eax,dword ptr[r10+4*r15+1048576]
	vpinsrd xmm0,xmm0,eax,0
	
	movzx ebx,word ptr[rsi+2]
	movzx r15d,word ptr[r11+2]
	movzx edx,word ptr[r12+2] ; rbx=Y r15=U rdx=V
	mov eax,dword ptr[r10+4*rbx]
	add eax,dword ptr[r10+4*rdx+262144]
	add rsi,r13
	vpinsrd xmm2,xmm2,eax,2
	mov eax,dword ptr[r10+4*rbx]
	add eax,dword ptr[r10+4*r15+524288]
	add eax,dword ptr[r10+4*rdx+786432]
	add r11,r13
	vpinsrd xmm2,xmm2,eax,1
	mov eax,dword ptr[r10+4*rbx]
	add eax,dword ptr[r10+4*r15+1048576]
	add r12,r13
	vpinsrd xmm2,xmm2,eax,0
	
	vpaddd xmm0,xmm0,xmm1	
	vpaddd xmm2,xmm2,xmm1	
	vpsrad xmm0,xmm0,8
	vpsrad xmm2,xmm2,8
	vpackusdw xmm3,xmm0,xmm2
	
	vmovdqa XMMWORD ptr[rdi],xmm3
	
	add rdi,r14
	
	dec ecx
	jnz Convert_16_YV24toRGB64_AVX_2
	
Convert_16_YV24toRGB64_AVX_3:
	test r9d,1
	jz short Convert_16_YV24toRGB64_AVX_4
	
	movzx ebx,word ptr[rsi]
	movzx r15d,word ptr[r11]
	movzx edx,word ptr[r12] ; rbx=Y r15=U rdx=V
	mov eax,dword ptr[r10+4*rbx]
	add eax,dword ptr[r10+4*rdx+262144]
	add rsi,2
	vpinsrd xmm0,xmm0,eax,2
	mov eax,dword ptr[r10+4*rbx]
	add eax,dword ptr[r10+4*r15+524288]
	add eax,dword ptr[r10+4*rdx+786432]
	add r11,2
	vpinsrd xmm0,xmm0,eax,1
	mov eax,dword ptr[r10+4*rbx]
	add eax,dword ptr[r10+4*r15+1048576]
	add r12,2
	vpinsrd xmm0,xmm0,eax,0
	
	vpaddd xmm0,xmm0,xmm1
	vpsrad xmm0,xmm0,8
	vpackusdw xmm3,xmm0,xmm0
	
	vmovq qword ptr[rdi],xmm3
	
	add rdi,8
	
Convert_16_YV24toRGB64_AVX_4:	
	add rsi,src_modulo_y
	add r11,src_modulo_u
	add r12,src_modulo_v
	add rdi,dst_modulo
	dec h
	jnz Convert_16_YV24toRGB64_AVX_1

	pop r15
	pop r14
	pop r13
	pop r12
	pop rbx
	pop rsi
	pop rdi
	pop rbp
	
	ret

JPSDR_HDRTools_Convert_16_YV24toRGB64_AVX endp


;***************************************************
;**           RGB to YUV functions                **
;***************************************************


;JPSDR_HDRTools_Convert_LinearRGBPStoRGB64_SSE41 proc src_R:dword,src_G:dword,src_B:dword,dst:dword,w:dword,h:dword,lookup:dword,
;	src_modulo_R:dword,src_modulo_G:dword,src_modulo_B:dword,dst_modulo:dword
; src_R = rcx
; src_G = rdx
; src_B = r8
; dst = r9

JPSDR_HDRTools_Convert_LinearRGBPStoRGB64_SSE41 proc public frame

w equ dword ptr[rbp+48]
h equ dword ptr[rbp+56]
lookup equ qword ptr[rbp+64]
src_modulo_R equ qword ptr[rbp+72]
src_modulo_G equ qword ptr[rbp+80]
src_modulo_B equ qword ptr[rbp+88]
dst_modulo equ qword ptr[rbp+96]

	push rbp
	.pushreg rbp
	mov rbp,rsp
	push rdi
	.pushreg rdi
	push rsi
	.pushreg rsi
	push rbx
	.pushreg rbx
	push r12
	.pushreg r12
	push r13
	.pushreg r13
	push r14
	.pushreg r14
	push r15
	.pushreg r15
	.endprolog
	
	movaps xmm3,XMMWORD ptr data_f_1048575
	movaps xmm4,XMMWORD ptr data_f_0
	movaps xmm5,XMMWORD ptr data_f_1
	
	cld
	mov rdi,r9
	mov r9,rcx
	mov r10,rdx			; src_B=r8,src_G=r10,src_R=r9
	mov rbx,lookup
	mov r11d,w
	mov r12,src_modulo_R
	mov r13,src_modulo_G
	mov r14,src_modulo_B
	mov r15,dst_modulo
	xor rax,rax
	
Convert_LinearRGBPStoRGB64_SSE41_1:
	mov ecx,r11d
Convert_LinearRGBPStoRGB64_SSE41_2:
	xor rdx,rdx
	movaps xmm0,XMMWORD ptr[r8]
	movaps xmm1,XMMWORD ptr[r10]
	movaps xmm2,XMMWORD ptr[r9]
	maxps xmm0,xmm4
	maxps xmm1,xmm4
	maxps xmm2,xmm4
	minps xmm0,xmm5
	minps xmm1,xmm5
	minps xmm2,xmm5
	mulps xmm0,xmm3
	mulps xmm1,xmm3
	mulps xmm2,xmm3
	cvtps2dq xmm0,xmm0
	cvtps2dq xmm1,xmm1
	cvtps2dq xmm2,xmm2
	
	pextrd eax,xmm0,0
	mov ax,word ptr[rbx+2*rax]
	stosw
	pextrd eax,xmm1,0
	mov ax,word ptr[rbx+2*rax]
	stosw
	pextrd eax,xmm2,0
	mov ax,word ptr[rbx+2*rax]
	stosw
	xor eax,eax
	stosw
	dec ecx
	jz Convert_LinearRGBPStoRGB64_SSE41_3
	inc rdx
	
	pextrd eax,xmm0,1
	mov ax,word ptr[rbx+2*rax]
	stosw
	pextrd eax,xmm1,1
	mov ax,word ptr[rbx+2*rax]
	stosw
	pextrd eax,xmm2,1
	mov ax,word ptr[rbx+2*rax]
	stosw
	xor eax,eax
	stosw
	dec ecx
	jz short Convert_LinearRGBPStoRGB64_SSE41_3
	inc rdx

	pextrd eax,xmm0,2
	mov ax,word ptr[rbx+2*rax]
	stosw
	pextrd eax,xmm1,2
	mov ax,word ptr[rbx+2*rax]
	stosw
	pextrd eax,xmm2,2
	mov ax,word ptr[rbx+2*rax]
	stosw
	xor eax,eax
	stosw
	dec ecx
	jz short Convert_LinearRGBPStoRGB64_SSE41_3
	inc rdx

	pextrd eax,xmm0,3
	mov ax,word ptr[rbx+2*rax]
	stosw
	pextrd eax,xmm1,3
	mov ax,word ptr[rbx+2*rax]
	stosw
	pextrd eax,xmm2,3
	mov ax,word ptr[rbx+2*rax]
	stosw
	xor eax,eax
	stosw
	dec ecx
	
Convert_LinearRGBPStoRGB64_SSE41_3:
	inc rdx	
	shl rdx,2	
	add r8,rdx
	add r10,rdx
	add r9,rdx	
	or ecx,ecx
	jnz Convert_LinearRGBPStoRGB64_SSE41_2
	
	add rdi,r15
	add r8,r14
	add r10,r13
	add r9,r12
	dec h
	jnz Convert_LinearRGBPStoRGB64_SSE41_1
	
	pop r15
	pop r14
	pop r13
	pop r12
	pop rbx
	pop rsi
	pop rdi
	pop rbp

	ret

JPSDR_HDRTools_Convert_LinearRGBPStoRGB64_SSE41 endp


;JPSDR_HDRTools_Convert_LinearRGBPStoRGB64_AVX proc src_R:dword,src_G:dword,src_B:dword,dst:dword,w:dword,h:dword,lookup:dword,
;	src_modulo_R:dword,src_modulo_G:dword,src_modulo_B:dword,dst_modulo:dword
; src_R = rcx
; src_G = rdx
; src_B = r8
; dst = r9

JPSDR_HDRTools_Convert_LinearRGBPStoRGB64_AVX proc public frame

w equ dword ptr[rbp+48]
h equ dword ptr[rbp+56]
lookup equ qword ptr[rbp+64]
src_modulo_R equ qword ptr[rbp+72]
src_modulo_G equ qword ptr[rbp+80]
src_modulo_B equ qword ptr[rbp+88]
dst_modulo equ qword ptr[rbp+96]

	push rbp
	.pushreg rbp
	mov rbp,rsp
	push rdi
	.pushreg rdi
	push rsi
	.pushreg rsi
	push rbx
	.pushreg rbx
	push r12
	.pushreg r12
	push r13
	.pushreg r13
	push r14
	.pushreg r14
	push r15
	.pushreg r15
	.endprolog	

	vmovaps ymm3,YMMWORD ptr data_f_1048575
	vmovaps ymm4,YMMWORD ptr data_f_0
	vmovaps ymm5,YMMWORD ptr data_f_1
	
	cld
	mov rdi,r9
	mov r9,rcx
	mov r10,rdx			; src_B=r8,src_G=r10,src_R=r9
	mov rbx,lookup
	mov r11d,w
	mov r12,src_modulo_R
	mov r13,src_modulo_G
	mov r14,src_modulo_B
	mov r15,dst_modulo
	xor rax,rax
	
Convert_LinearRGBPStoRGB64_AVX_1:
	mov ecx,r11d
Convert_LinearRGBPStoRGB64_AVX_2:
	xor rdx,rdx
	vmaxps ymm0,ymm4,YMMWORD ptr[r8]
	vmaxps ymm1,ymm4,YMMWORD ptr[r10]
	vmaxps ymm2,ymm4,YMMWORD ptr[r9]
	vminps ymm0,ymm0,ymm5
	vminps ymm1,ymm1,ymm5
	vminps ymm2,ymm2,ymm5
	vmulps ymm0,ymm0,ymm3
	vmulps ymm1,ymm1,ymm3
	vmulps ymm2,ymm2,ymm3
	vcvtps2dq ymm0,ymm0
	vcvtps2dq ymm1,ymm1
	vcvtps2dq ymm2,ymm2
	
	vpextrd eax,xmm0,0
	mov ax,word ptr[rbx+2*rax]
	stosw
	vpextrd eax,xmm1,0
	mov ax,word ptr[rbx+2*rax]
	stosw
	vpextrd eax,xmm2,0
	mov ax,word ptr[rbx+2*rax]
	stosw
	xor eax,eax
	stosw
	dec ecx
	jz Convert_LinearRGBPStoRGB64_AVX_3
	inc rdx
	
	vpextrd eax,xmm0,1
	mov ax,word ptr[rbx+2*rax]
	stosw
	vpextrd eax,xmm1,1
	mov ax,word ptr[rbx+2*rax]
	stosw
	vpextrd eax,xmm2,1
	mov ax,word ptr[rbx+2*rax]
	stosw
	xor eax,eax
	stosw
	dec ecx
	jz Convert_LinearRGBPStoRGB64_AVX_3
	inc rdx

	vpextrd eax,xmm0,2
	mov ax,word ptr[rbx+2*rax]
	stosw
	vpextrd eax,xmm1,2
	mov ax,word ptr[rbx+2*rax]
	stosw
	vpextrd eax,xmm2,2
	mov ax,word ptr[rbx+2*rax]
	stosw
	xor eax,eax
	stosw
	dec ecx
	jz Convert_LinearRGBPStoRGB64_AVX_3
	inc rdx

	vpextrd eax,xmm0,3
	mov ax,word ptr[rbx+2*rax]
	stosw
	vpextrd eax,xmm1,3
	mov ax,word ptr[rbx+2*rax]
	stosw
	vpextrd eax,xmm2,3
	mov ax,word ptr[rbx+2*rax]
	stosw
	xor eax,eax
	stosw
	dec ecx
	jz Convert_LinearRGBPStoRGB64_AVX_3
	inc rdx
	
	vextractf128 xmm0,ymm0,1
	vextractf128 xmm1,ymm1,1
	vextractf128 xmm2,ymm2,1
	
	vpextrd eax,xmm0,0
	mov ax,word ptr[rbx+2*rax]
	stosw
	vpextrd eax,xmm1,0
	mov ax,word ptr[rbx+2*rax]
	stosw
	vpextrd eax,xmm2,0
	mov ax,word ptr[rbx+2*rax]
	stosw
	xor eax,eax
	stosw
	dec ecx
	jz Convert_LinearRGBPStoRGB64_AVX_3
	inc rdx	
	
	vpextrd eax,xmm0,1
	mov ax,word ptr[rbx+2*rax]
	stosw
	vpextrd eax,xmm1,1
	mov ax,word ptr[rbx+2*rax]
	stosw
	vpextrd eax,xmm2,1
	mov ax,word ptr[rbx+2*rax]
	stosw
	xor eax,eax
	stosw
	dec ecx
	jz short Convert_LinearRGBPStoRGB64_AVX_3
	inc rdx	

	vpextrd eax,xmm0,2
	mov ax,word ptr[rbx+2*rax]
	stosw
	vpextrd eax,xmm1,2
	mov ax,word ptr[rbx+2*rax]
	stosw
	vpextrd eax,xmm2,2
	mov ax,word ptr[rbx+2*rax]
	stosw
	xor eax,eax
	stosw
	dec ecx
	jz short Convert_LinearRGBPStoRGB64_AVX_3
	inc rdx		

	vpextrd eax,xmm0,3
	mov ax,word ptr[rbx+2*rax]
	stosw
	vpextrd eax,xmm1,3
	mov ax,word ptr[rbx+2*rax]
	stosw
	vpextrd eax,xmm2,3
	mov ax,word ptr[rbx+2*rax]
	stosw
	xor eax,eax
	stosw
	dec ecx
	
Convert_LinearRGBPStoRGB64_AVX_3:
	inc rdx	
	shl rdx,2	
	add r8,rdx
	add r10,rdx
	add r9,rdx	
	or ecx,ecx
	jnz Convert_LinearRGBPStoRGB64_AVX_2
	
	add rdi,r15
	add r8,r14
	add r10,r13
	add r9,r12
	dec h
	jnz Convert_LinearRGBPStoRGB64_AVX_1
	
	vzeroupper
	
	pop r15
	pop r14
	pop r13
	pop r12
	pop rbx
	pop rsi
	pop rdi
	pop rbp

	ret

JPSDR_HDRTools_Convert_LinearRGBPStoRGB64_AVX endp


;JPSDR_HDRTools_Convert_RGBPStoRGB64_SSE41 proc src_R:dword,src_G:dword,src_B:dword,dst:dword,w:dword,h:dword,
;	src_pitch_R:dword,src_pitch_G:dword,src_pitch_B:dword,dst_pitch:dword
; src_R = rcx
; src_G = rdx
; src_B = r8
; dst = r9

JPSDR_HDRTools_Convert_RGBPStoRGB64_SSE41 proc public frame

w equ dword ptr[rbp+48]
h equ dword ptr[rbp+56]
src_pitch_R equ qword ptr[rbp+64]
src_pitch_G equ qword ptr[rbp+72]
src_pitch_B equ qword ptr[rbp+80]
dst_pitch equ qword ptr[rbp+88]

	push rbp
	.pushreg rbp
	mov rbp,rsp
	push rsi
	.pushreg rsi
	push rbx
	.pushreg rbx
	push r12
	.pushreg r12
	push r13
	.pushreg r13
	push r14
	.pushreg r14
	push r15
	.pushreg r15
	sub rsp,32
	.allocstack 32
	movdqa XMMWORD ptr[rsp],xmm6
	.savexmm128 xmm6,0
	movdqa XMMWORD ptr[rsp+16],xmm7
	.savexmm128 xmm7,16
	.endprolog	

	movaps xmm3,XMMWORD ptr data_f_65535
	pxor xmm4,xmm4
	
	mov rsi,rcx			; src_B=r8,src_G=rdx,src_R=rsi
	
	mov r11d,w
	mov r12,src_pitch_R
	mov r13,src_pitch_G
	mov r14,src_pitch_B
	mov r15,dst_pitch
	mov rbx,4
	mov r10d,h
	
Convert_RGBPStoRGB64_SSE41_1:
	mov ecx,r11d
	xor rax,rax
	shr ecx,2
	jz short Convert_RGBPStoRGB64_SSE41_3
Convert_RGBPStoRGB64_SSE41_2:
	movaps xmm0,XMMWORD ptr[r8+4*rax]
	movaps xmm1,XMMWORD ptr[rsi+4*rax]
	movaps xmm2,XMMWORD ptr[rdx+4*rax]
	mulps xmm0,xmm3
	mulps xmm1,xmm3
	mulps xmm2,xmm3
	cvtps2dq xmm0,xmm0
	cvtps2dq xmm1,xmm1
	cvtps2dq xmm2,xmm2
	
	packusdw xmm0,xmm0					;0000B4B3B2B1
	packusdw xmm1,xmm1					;0000R4R3R2R1
	packusdw xmm2,xmm2					;0000G4G3G2G1
	
	punpcklwd xmm0,xmm1             	;R4B4R3B3R2B2R1B1
	punpcklwd xmm2,xmm4             	;0G40G30G20G1
	movdqa xmm1,xmm0					;R4B4R3B3R2B2R1B1
	punpcklwd xmm0,xmm2             	;0R2G2B20R1G1B1
	punpckhwd xmm1,xmm2             	;0R4G4B40R3G3B3
	movdqa XMMWORD ptr[r9+8*rax],xmm0
	movdqa XMMWORD ptr[r9+8*rax+16],xmm1
	add rax,rbx
loop Convert_RGBPStoRGB64_SSE41_2

Convert_RGBPStoRGB64_SSE41_3:
	mov ecx,r11d
	and ecx,3
	jz short Convert_RGBPStoRGB64_SSE41_5
	
	movaps xmm0,XMMWORD ptr[r8+4*rax]
	movaps xmm1,XMMWORD ptr[rsi+4*rax]
	movaps xmm2,XMMWORD ptr[rdx+4*rax]
	mulps xmm0,xmm3
	mulps xmm1,xmm3
	mulps xmm2,xmm3
	cvtps2dq xmm0,xmm0
	cvtps2dq xmm1,xmm1
	cvtps2dq xmm2,xmm2
	
	packusdw xmm0,xmm0					;0000B4B3B2B1
	packusdw xmm1,xmm1					;0000R4R3R2R1
	packusdw xmm2,xmm2					;0000G4G3G2G1
	
	punpcklwd xmm0,xmm1             	;R4B4R3B3R2B2R1B1
	punpcklwd xmm2,xmm4             	;0G40G30G20G1
	movdqa xmm1,xmm0					;R4B4R3B3R2B2R1B1
	punpcklwd xmm0,xmm2             	;0R2G2B20R1G1B1
	punpckhwd xmm1,xmm2             	;0R4G4B40R3G3B3
	
	test ecx,2
	jnz short Convert_RGBPStoRGB64_SSE41_4
	movq qword ptr[r9+8*rax],xmm0
	jmp short Convert_RGBPStoRGB64_SSE41_5
	
Convert_RGBPStoRGB64_SSE41_4:
	movdqa XMMWORD ptr[r9+8*rax],xmm0
	test ecx,1
	jz short Convert_RGBPStoRGB64_SSE41_5
	movq qword ptr[r9+8*rax+16],xmm1
	
Convert_RGBPStoRGB64_SSE41_5:
	add rsi,r12
	add rdx,r13
	add r8,r14
	add r9,r15
	dec r10d
	jnz Convert_RGBPStoRGB64_SSE41_1
	
	movdqa xmm7,XMMWORD ptr[rsp+16]
	movdqa xmm6,XMMWORD ptr[rsp]
	add rsp,32
	
	pop r15
	pop r14
	pop r13
	pop r12
	pop rbx
	pop rsi
	pop rbp

	ret

JPSDR_HDRTools_Convert_RGBPStoRGB64_SSE41 endp


;JPSDR_HDRTools_Convert_RGBPStoRGB64_AVX proc src_R:dword,src_G:dword,src_B:dword,dst:dword,w:dword,h:dword,
;	src_pitch_R:dword,src_pitch_G:dword,src_pitch_B:dword,dst_pitch:dword
; src_R = rcx
; src_G = rdx
; src_B = r8
; dst = r9

JPSDR_HDRTools_Convert_RGBPStoRGB64_AVX proc public frame

w equ dword ptr[rbp+48]
h equ dword ptr[rbp+56]
src_pitch_R equ qword ptr[rbp+64]
src_pitch_G equ qword ptr[rbp+72]
src_pitch_B equ qword ptr[rbp+80]
dst_pitch equ qword ptr[rbp+88]

	push rbp
	.pushreg rbp
	mov rbp,rsp
	push rsi
	.pushreg rsi
	push rbx
	.pushreg rbx
	push r12
	.pushreg r12
	push r13
	.pushreg r13
	push r14
	.pushreg r14
	push r15
	.pushreg r15
	sub rsp,32
	.allocstack 32
	vmovdqa XMMWORD ptr[rsp],xmm6
	.savexmm128 xmm6,0
	vmovdqa XMMWORD ptr[rsp+16],xmm7
	.savexmm128 xmm7,16
	.endprolog	

	vmovaps ymm3,YMMWORD ptr data_f_65535
	vpxor xmm4,xmm4,xmm4
	
	mov rsi,rcx			; src_B=r8,src_G=rdx,src_R=rsi
	
	mov r11d,w
	mov r12,src_pitch_R
	mov r13,src_pitch_G
	mov r14,src_pitch_B
	mov r15,dst_pitch
	mov rbx,8
	mov r10d,h
	
Convert_RGBPStoRGB64_AVX_1:
	mov ecx,r11d
	xor rax,rax
	shr ecx,3
	jz Convert_RGBPStoRGB64_AVX_3
Convert_RGBPStoRGB64_AVX_2:
	vmulps ymm0,ymm3,YMMWORD ptr[r8+4*rax]
	vmulps ymm1,ymm3,YMMWORD ptr[rsi+4*rax]
	vmulps ymm2,ymm3,YMMWORD ptr[rdx+4*rax]
	vcvtps2dq ymm0,ymm0
	vcvtps2dq ymm1,ymm1
	vcvtps2dq ymm2,ymm2
	
	vextractf128 xmm5,ymm0,1
	vextractf128 xmm6,ymm1,1
	vextractf128 xmm7,ymm2,1	
	
	packusdw xmm0,xmm0					;0000B4B3B2B1
	packusdw xmm1,xmm1					;0000R4R3R2R1
	packusdw xmm2,xmm2					;0000G4G3G2G1
	
	vpunpcklwd xmm0,xmm0,xmm1             	;R4B4R3B3R2B2R1B1
	vpunpcklwd xmm2,xmm2,xmm4             	;0G40G30G20G1
	vpunpckhwd xmm1,xmm0,xmm2             	;0R4G4B40R3G3B3
	vpunpcklwd xmm0,xmm0,xmm2             	;0R2G2B20R1G1B1
	
	packusdw xmm5,xmm5					;0000B8B7B6B5
	packusdw xmm6,xmm6					;0000R8R7R6R5
	packusdw xmm7,xmm7					;0000G8G7G6G5
	
	vpunpcklwd xmm5,xmm5,xmm6             	;R8B8R7B7R6B6R5B5
	vpunpcklwd xmm7,xmm7,xmm4             	;0G80G70G60G5
	vpunpckhwd xmm6,xmm5,xmm7             	;0R8G8B80R7G7B7
	vpunpcklwd xmm5,xmm5,xmm7             	;0R6G6B60R5G5B5
		
	vmovdqa XMMWORD ptr[r9+8*rax],xmm0
	vmovdqa XMMWORD ptr[r9+8*rax+16],xmm1
	vmovdqa XMMWORD ptr[r9+8*rax+32],xmm5
	vmovdqa XMMWORD ptr[r9+8*rax+48],xmm6
	add rax,8
	dec ecx
	jnz Convert_RGBPStoRGB64_AVX_2

Convert_RGBPStoRGB64_AVX_3:
	mov ecx,r11d
	and ecx,7
	jz Convert_RGBPStoRGB64_AVX_7
	
	vmulps ymm0,ymm3,YMMWORD ptr[r8+4*rax]
	vmulps ymm1,ymm3,YMMWORD ptr[rsi+4*rax]
	vmulps ymm2,ymm3,YMMWORD ptr[rdx+4*rax]
	vcvtps2dq ymm0,ymm0
	vcvtps2dq ymm1,ymm1
	vcvtps2dq ymm2,ymm2
	
	vextractf128 xmm5,ymm0,1
	vextractf128 xmm6,ymm1,1
	vextractf128 xmm7,ymm2,1	
	
	packusdw xmm0,xmm0					;0000B4B3B2B1
	packusdw xmm1,xmm1					;0000R4R3R2R1
	packusdw xmm2,xmm2					;0000G4G3G2G1
	
	vpunpcklwd xmm0,xmm0,xmm1             	;R4B4R3B3R2B2R1B1
	vpunpcklwd xmm2,xmm2,xmm4             	;0G40G30G20G1
	vpunpckhwd xmm1,xmm0,xmm2             	;0R4G4B40R3G3B3
	vpunpcklwd xmm0,xmm0,xmm2             	;0R2G2B20R1G1B1
	
	packusdw xmm5,xmm5					;0000B8B7B6B5
	packusdw xmm6,xmm6					;0000R8R7R6R5
	packusdw xmm7,xmm7					;0000G8G7G6G5
	
	vpunpcklwd xmm5,xmm5,xmm6             	;R8B8R7B7R6B6R5B5
	vpunpcklwd xmm7,xmm7,xmm4             	;0G80G70G60G5
	vpunpckhwd xmm6,xmm5,xmm7             	;0R8G8B80R7G7B7
	vpunpcklwd xmm5,xmm5,xmm7             	;0R6G6B60R5G5B5	
	
	test ecx,4
	jnz short Convert_RGBPStoRGB64_AVX_5
	test ecx,2
	jnz short Convert_RGBPStoRGB64_AVX_4
	vmovq qword ptr[r9+8*rax],xmm0
	jmp short Convert_RGBPStoRGB64_AVX_7
	
Convert_RGBPStoRGB64_AVX_4:
	vmovdqa XMMWORD ptr[r9+8*rax],xmm0
	test ecx,1
	jz short Convert_RGBPStoRGB64_AVX_7
	vmovq qword ptr[r9+8*rax+16],xmm1
	jmp short Convert_RGBPStoRGB64_AVX_7
	
Convert_RGBPStoRGB64_AVX_5:
	vmovdqa XMMWORD ptr[r9+8*rax],xmm0
	vmovdqa XMMWORD ptr[r9+8*rax+16],xmm1
	test ecx,2
	jnz short Convert_RGBPStoRGB64_AVX_6
	test ecx,1
	jz short Convert_RGBPStoRGB64_AVX_7
	vmovq qword ptr[r9+8*rax+32],xmm5
	jmp short Convert_RGBPStoRGB64_AVX_7
	
Convert_RGBPStoRGB64_AVX_6:
	vmovdqa XMMWORD ptr[r9+8*rax+32],xmm5
	test ecx,1
	jz short Convert_RGBPStoRGB64_AVX_7
	vmovq qword ptr[r9+8*rax+48],xmm6
	
Convert_RGBPStoRGB64_AVX_7:
	add rsi,r12
	add rdx,r13
	add r8,r14
	add r9,r15
	dec r10d
	jnz Convert_RGBPStoRGB64_AVX_1
	
	vmovdqa xmm7,XMMWORD ptr[rsp+16]
	vmovdqa xmm6,XMMWORD ptr[rsp]
	add rsp,32
	
	vzeroupper
	
	pop r15
	pop r14
	pop r13
	pop r12
	pop rbx
	pop rsi
	pop rbp

	ret

JPSDR_HDRTools_Convert_RGBPStoRGB64_AVX endp


;JPSDR_HDRTools_Convert_RGB32toYV24_SSE2 proc src:dword,dst_y:dword,dst_u:dword,dst_v:dword,w:dword,h:dword,offset_Y:word,
; offset_U:word,offset_V:word,lookup:dword,src_modulo:dword,dst_modulo_y:dword,dst_modulo_u:dword,dst_modulo_v:dword
;Min_Y:word,Max_Y:word,Min_U:word,Max_U:word,Min_V:word,Max_V:word
; src = rcx
; dst_y = rdx
; dst_u = r8
; dst_v = r9

JPSDR_HDRTools_Convert_RGB32toYV24_SSE2 proc public frame

w equ dword ptr[rbp+48]
h equ dword ptr[rbp+56]
offset_Y equ word ptr[rbp+64]
offset_U equ word ptr[rbp+72]
offset_V equ word ptr[rbp+80]
lookup equ qword ptr[rbp+88]
src_modulo equ qword ptr[rbp+96]
dst_modulo_y equ qword ptr[rbp+104]
dst_modulo_u equ qword ptr[rbp+112]
dst_modulo_v equ qword ptr[rbp+120]
Min_Y equ word ptr[rbp+128]
Max_Y equ word ptr[rbp+136]
Min_U equ word ptr[rbp+144]
Max_U equ word ptr[rbp+152]
Min_V equ word ptr[rbp+160]
Max_V equ word ptr[rbp+168]

	push rbp
	.pushreg rbp
	mov rbp,rsp
	push rdi
	.pushreg rdi
	push rsi
	.pushreg rsi
	push rbx
	.pushreg rbx
	push r12
	.pushreg r12
	push r13
	.pushreg r13
	push r14
	.pushreg r14
	push r15
	.pushreg r15
	.endprolog

	xor rax,rax
	pxor xmm4,xmm4
	pxor xmm3,xmm3
	pxor xmm2,xmm2		
	pxor xmm1,xmm1
	pxor xmm0,xmm0
	movzx eax,offset_Y
	pinsrw xmm1,eax,0
	pinsrw xmm1,eax,1
	movzx eax,offset_U
	pinsrw xmm1,eax,2
	pinsrw xmm1,eax,3
	movzx eax,offset_V
	pinsrw xmm1,eax,4
	pinsrw xmm1,eax,5
	movzx eax,Min_Y
	pinsrw xmm2,eax,0
	pinsrw xmm2,eax,1
	movzx eax,Max_Y
	pinsrw xmm3,eax,0
	pinsrw xmm3,eax,1
	movzx eax,Min_U
	pinsrw xmm2,eax,2
	pinsrw xmm2,eax,3
	movzx eax,Max_U
	pinsrw xmm3,eax,2
	pinsrw xmm3,eax,3
	movzx eax,Min_V
	pinsrw xmm2,eax,4
	pinsrw xmm2,eax,5
	movzx eax,Max_V
	pinsrw xmm3,eax,4
	pinsrw xmm3,eax,5

	mov rsi,rcx
	mov r10,lookup
	mov rdi,rdx				;rdi=dst_y
	mov r11,r8				;r11=dst_u
	mov r12,r9				;r12=dst_v
	mov r13,2
	mov r14,8
	mov r9d,w
	
	xor rdx,rdx
	xor rbx,rbx
	xor r15,r15
	
	mov r8d,r9d
	shr r8d,1				;r8d=w0
	
Convert_RGB32toYV24_SSE2_1:
	or r8d,r8d
	jz Convert_RGB32toYV24_SSE2_3
	
	mov ecx,r8d
Convert_RGB32toYV24_SSE2_2:
	movzx edx,byte ptr[rsi]
	movzx r15d,byte ptr[rsi+1]
	movzx ebx,byte ptr[rsi+2] ; rbx=R r15=G rdx=B	
	movzx eax,word ptr[r10+2*rbx]
	add ax,word ptr[r10+2*r15+512]
	add ax,word ptr[r10+2*rdx+1024]
	pinsrw xmm0,eax,0
	movzx eax,word ptr[r10+2*rbx+1536]
	add ax,word ptr[r10+2*r15+2048]
	add ax,word ptr[r10+2*rdx+2560]
	pinsrw xmm0,eax,2
	movzx eax,word ptr[r10+2*rbx+3072]
	add ax,word ptr[r10+2*r15+3584]
	add ax,word ptr[r10+2*rdx+4096]
	pinsrw xmm0,eax,4
	movzx edx,byte ptr[rsi+4]
	movzx r15d,byte ptr[rsi+5]
	movzx ebx,byte ptr[rsi+6] ; rbx=R r15=G rdx=B
	movzx eax,word ptr[r10+2*rbx]
	add ax,word ptr[r10+2*r15+512]
	add ax,word ptr[r10+2*rdx+1024]
	pinsrw xmm0,eax,1
	movzx eax,word ptr[r10+2*rbx+1536]
	add ax,word ptr[r10+2*r15+2048]
	add ax,word ptr[r10+2*rdx+2560]
	pinsrw xmm0,eax,3
	movzx eax,word ptr[r10+2*rbx+3072]
	add ax,word ptr[r10+2*r15+3584]
	add ax,word ptr[r10+2*rdx+4096]
	pinsrw xmm0,eax,5

	paddsw xmm0,xmm1
	psraw xmm0,6
	pmaxsw xmm0,xmm2
	pminsw xmm0,xmm3
	packuswb xmm0,xmm4
	
	pextrw eax,xmm0,0
	add rsi,r14
	mov word ptr[rdi],ax
	pextrw eax,xmm0,1
	add rdi,r13
	mov word ptr[r11],ax
	pextrw eax,xmm0,2
	add r11,r13
	mov word ptr[r12],ax	
	add r12,r13
	
	dec ecx
	jnz Convert_RGB32toYV24_SSE2_2
	
Convert_RGB32toYV24_SSE2_3:
	test r9d,1
	jz Convert_RGB32toYV24_SSE2_4
	
	movzx edx,byte ptr[rsi]
	movzx r15d,byte ptr[rsi+1]
	movzx ebx,byte ptr[rsi+2] ; rbx=R r15=G rdx=B
	movzx eax,word ptr[r10+2*rbx]
	add ax,word ptr[r10+2*r15+512]
	add ax,word ptr[r10+2*rdx+1024]
	pinsrw xmm0,eax,0
	movzx eax,word ptr[r10+2*rbx+1536]
	add ax,word ptr[r10+2*r15+2048]
	add ax,word ptr[r10+2*rdx+2560]
	pinsrw xmm0,eax,2
	movzx eax,word ptr[r10+2*rbx+3072]
	add ax,word ptr[r10+2*r15+3584]
	add ax,word ptr[r10+2*rdx+4096]
	pinsrw xmm0,eax,4
	
	paddsw xmm0,xmm1
	psraw xmm0,6
	pmaxsw xmm0,xmm2
	pminsw xmm0,xmm3
	packuswb xmm0,xmm0
	
	pextrw eax,xmm0,0
	add rsi,4
	mov byte ptr[rdi],al
	pextrw eax,xmm0,2
	inc rdi
	mov byte ptr[r11],al
	pextrw eax,xmm0,4
	inc r11
	mov byte ptr[r12],al
	inc r12
		
Convert_RGB32toYV24_SSE2_4:	
	add rsi,src_modulo
	add rdi,dst_modulo_y
	add r11,dst_modulo_u
	add r12,dst_modulo_v
	dec h
	jnz Convert_RGB32toYV24_SSE2_1

	pop r15
	pop r14
	pop r13
	pop r12
	pop rbx
	pop rsi
	pop rdi
	pop rbp

	ret

JPSDR_HDRTools_Convert_RGB32toYV24_SSE2 endp


;JPSDR_HDRTools_Convert_RGB32toYV24_AVX proc src:dword,dst_y:dword,dst_u:dword,dst_v:dword,w:dword,h:dword,offset_Y:word,
; offset_U:word,offset_V:word,lookup:dword,src_modulo:dword,dst_modulo_y:dword,dst_modulo_u:dword,dst_modulo_v:dword
;Min_Y:word,Max_Y:word,Min_U:word,Max_U:word,Min_V:word,Max_V:word
; src = rcx
; dst_y = rdx
; dst_u = r8
; dst_v = r9

JPSDR_HDRTools_Convert_RGB32toYV24_AVX proc public frame

w equ dword ptr[rbp+48]
h equ dword ptr[rbp+56]
offset_Y equ word ptr[rbp+64]
offset_U equ word ptr[rbp+72]
offset_V equ word ptr[rbp+80]
lookup equ qword ptr[rbp+88]
src_modulo equ qword ptr[rbp+96]
dst_modulo_y equ qword ptr[rbp+104]
dst_modulo_u equ qword ptr[rbp+112]
dst_modulo_v equ qword ptr[rbp+120]
Min_Y equ word ptr[rbp+128]
Max_Y equ word ptr[rbp+136]
Min_U equ word ptr[rbp+144]
Max_U equ word ptr[rbp+152]
Min_V equ word ptr[rbp+160]
Max_V equ word ptr[rbp+168]

	push rbp
	.pushreg rbp
	mov rbp,rsp
	push rdi
	.pushreg rdi
	push rsi
	.pushreg rsi
	push rbx
	.pushreg rbx
	push r12
	.pushreg r12
	push r13
	.pushreg r13
	push r14
	.pushreg r14
	push r15
	.pushreg r15
	.endprolog

	xor rax,rax
	vpxor xmm4,xmm4,xmm4
	vpxor xmm3,xmm3,xmm3
	vpxor xmm2,xmm2,xmm2
	vpxor xmm1,xmm1,xmm1
	vpxor xmm0,xmm0,xmm0
	movzx eax,offset_Y
	vpinsrw xmm1,xmm1,eax,0
	vpinsrw xmm1,xmm1,eax,1	
	movzx eax,offset_U
	vpinsrw xmm1,xmm1,eax,2
	vpinsrw xmm1,xmm1,eax,3
	movzx eax,offset_V
	vpinsrw xmm1,xmm1,eax,4
	vpinsrw xmm1,xmm1,eax,5
	movzx eax,Min_Y
	vpinsrw xmm2,xmm2,eax,0
	vpinsrw xmm2,xmm2,eax,1
	movzx eax,Max_Y
	vpinsrw xmm3,xmm3,eax,0
	vpinsrw xmm3,xmm3,eax,1
	movzx eax,Min_U
	vpinsrw xmm2,xmm2,eax,2
	vpinsrw xmm2,xmm2,eax,3
	movzx eax,Max_U
	vpinsrw xmm3,xmm3,eax,2
	vpinsrw xmm3,xmm3,eax,3
	movzx eax,Min_V
	vpinsrw xmm2,xmm2,eax,4
	vpinsrw xmm2,xmm2,eax,5
	movzx eax,Max_V
	vpinsrw xmm3,xmm3,eax,4
	vpinsrw xmm3,xmm3,eax,5	

	mov rsi,rcx
	mov r10,lookup
	mov rdi,rdx				;rdi=dst_y
	mov r11,r8				;r11=dst_u
	mov r12,r9				;r12=dst_v
	mov r13,2
	mov r14,8
	mov r9d,w
	
	xor rdx,rdx
	xor rbx,rbx
	xor r15,r15
	
	mov r8d,r9d
	shr r8d,1				;r8d=w0
	
Convert_RGB32toYV24_AVX_1:
	or r8d,r8d
	jz Convert_RGB32toYV24_AVX_3
	
	mov ecx,r8d
Convert_RGB32toYV24_AVX_2:
	movzx edx,byte ptr[rsi]
	movzx r15d,byte ptr[rsi+1]
	movzx ebx,byte ptr[rsi+2] ; rbx=R r15=G rdx=B	
	movzx eax,word ptr[r10+2*rbx]
	add ax,word ptr[r10+2*r15+512]
	add ax,word ptr[r10+2*rdx+1024]
	vpinsrw xmm0,xmm0,eax,0
	movzx eax,word ptr[r10+2*rbx+1536]
	add ax,word ptr[r10+2*r15+2048]
	add ax,word ptr[r10+2*rdx+2560]
	vpinsrw xmm0,xmm0,eax,2
	movzx eax,word ptr[r10+2*rbx+3072]
	add ax,word ptr[r10+2*r15+3584]
	add ax,word ptr[r10+2*rdx+4096]
	vpinsrw xmm0,xmm0,eax,4
	movzx edx,byte ptr[rsi+4]
	movzx r15d,byte ptr[rsi+5]
	movzx ebx,byte ptr[rsi+6] ; rbx=R r15=G rdx=B
	movzx eax,word ptr[r10+2*rbx]
	add ax,word ptr[r10+2*r15+512]
	add ax,word ptr[r10+2*rdx+1024]
	vpinsrw xmm0,xmm0,eax,1
	movzx eax,word ptr[r10+2*rbx+1536]
	add ax,word ptr[r10+2*r15+2048]
	add ax,word ptr[r10+2*rdx+2560]
	vpinsrw xmm0,xmm0,eax,3
	movzx eax,word ptr[r10+2*rbx+3072]
	add ax,word ptr[r10+2*r15+3584]
	add ax,word ptr[r10+2*rdx+4096]
	vpinsrw xmm0,xmm0,eax,5

	vpaddsw xmm0,xmm0,xmm1
	vpsraw xmm0,xmm0,6
	vpmaxsw xmm0,xmm0,xmm2
	vpminsw xmm0,xmm0,xmm3
	vpackuswb xmm0,xmm0,xmm4
	
	vpextrw eax,xmm0,0
	add rsi,r14
	mov word ptr[rdi],ax
	vpextrw eax,xmm0,1
	add rdi,r13
	mov word ptr[r11],ax
	vpextrw eax,xmm0,2
	add r11,r13
	mov word ptr[r12],ax	
	add r12,r13
	
	dec ecx
	jnz Convert_RGB32toYV24_AVX_2
	
Convert_RGB32toYV24_AVX_3:
	test r9d,1
	jz Convert_RGB32toYV24_AVX_4
	
	movzx edx,byte ptr[rsi]
	movzx r15d,byte ptr[rsi+1]
	movzx ebx,byte ptr[rsi+2] ; rbx=R r15=G rdx=B
	movzx eax,word ptr[r10+2*rbx]
	add ax,word ptr[r10+2*r15+512]
	add ax,word ptr[r10+2*rdx+1024]
	vpinsrw xmm0,xmm0,eax,0
	movzx eax,word ptr[r10+2*rbx+1536]
	add ax,word ptr[r10+2*r15+2048]
	add ax,word ptr[r10+2*rdx+2560]
	vpinsrw xmm0,xmm0,eax,2
	movzx eax,word ptr[r10+2*rbx+3072]
	add ax,word ptr[r10+2*r15+3584]
	add ax,word ptr[r10+2*rdx+4096]
	vpinsrw xmm0,xmm0,eax,4
	
	vpaddsw xmm0,xmm0,xmm1
	vpsraw xmm0,xmm0,6
	vpmaxsw xmm0,xmm0,xmm2
	vpminsw xmm0,xmm0,xmm3
	vpackuswb xmm0,xmm0,xmm0
	
	vpextrw eax,xmm0,0
	add rsi,4
	mov byte ptr[rdi],al
	vpextrw eax,xmm0,2
	inc rdi
	mov byte ptr[r11],al
	vpextrw eax,xmm0,4
	inc r11
	mov byte ptr[r12],al
	inc r12
		
Convert_RGB32toYV24_AVX_4:	
	add rsi,src_modulo
	add rdi,dst_modulo_y
	add r11,dst_modulo_u
	add r12,dst_modulo_v
	dec h
	jnz Convert_RGB32toYV24_AVX_1

	pop r15
	pop r14
	pop r13
	pop r12
	pop rbx
	pop rsi
	pop rdi
	pop rbp

	ret

JPSDR_HDRTools_Convert_RGB32toYV24_AVX endp


;JPSDR_HDRTools_Convert_RGB64toYV24_SSE41 proc src:dword,dst_y:dword,dst_u:dword,dst_v:dword,w:dword,h:dword,offset_Y:dword,
; offset_U:dword,offset_V:dword,lookup:dword,src_modulo:dword,dst_modulo_y:dword,dst_modulo_u:dword,dst_modulo_v:dword
;Min_Y:word,Max_Y:word,Min_U:word,Max_U:word,Min_V:word,Max_V:word
; src = rcx
; dst_y = rdx
; dst_u = r8
; dst_v = r9

JPSDR_HDRTools_Convert_RGB64toYV24_SSE41 proc public frame

w equ dword ptr[rbp+48]
h equ dword ptr[rbp+56]
offset_Y equ dword ptr[rbp+64]
offset_U equ dword ptr[rbp+72]
offset_V equ dword ptr[rbp+80]
lookup equ qword ptr[rbp+88]
src_modulo equ qword ptr[rbp+96]
dst_modulo_y equ qword ptr[rbp+104]
dst_modulo_u equ qword ptr[rbp+112]
dst_modulo_v equ qword ptr[rbp+120]
Min_Y equ word ptr[rbp+128]
Max_Y equ word ptr[rbp+136]
Min_U equ word ptr[rbp+144]
Max_U equ word ptr[rbp+152]
Min_V equ word ptr[rbp+160]
Max_V equ word ptr[rbp+168]

	push rbp
	.pushreg rbp
	mov rbp,rsp
	push rdi
	.pushreg rdi
	push rsi
	.pushreg rsi
	push rbx
	.pushreg rbx
	push r12
	.pushreg r12
	push r13
	.pushreg r13
	push r14
	.pushreg r14
	push r15
	.pushreg r15
	.endprolog

	pxor xmm4,xmm4
	pxor xmm3,xmm3
	pxor xmm2,xmm2		
	pxor xmm1,xmm1
	pxor xmm0,xmm0
	mov eax,offset_Y
	pinsrd xmm1,eax,0
	mov eax,offset_U
	pinsrd xmm1,eax,1
	mov eax,offset_V
	pinsrd xmm1,eax,2
	movzx eax,Min_Y
	pinsrw xmm2,eax,0
	pinsrw xmm2,eax,1
	movzx eax,Max_Y
	pinsrw xmm3,eax,0
	pinsrw xmm3,eax,1
	movzx eax,Min_U
	pinsrw xmm2,eax,2
	pinsrw xmm2,eax,3
	movzx eax,Max_U
	pinsrw xmm3,eax,2
	pinsrw xmm3,eax,3
	movzx eax,Min_V
	pinsrw xmm2,eax,4
	pinsrw xmm2,eax,5
	movzx eax,Max_V
	pinsrw xmm3,eax,4
	pinsrw xmm3,eax,5

	mov rsi,rcx
	mov r10,lookup
	mov rdi,rdx				;rdi=dst_y
	mov r11,r8				;r11=dst_u
	mov r12,r9				;r12=dst_v
	mov r13,4
	mov r14,16
	mov r9d,w
	
	xor rax,rax
	xor rdx,rdx
	xor rbx,rbx
	xor r15,r15
	
	mov r8d,r9d
	shr r8d,1				;r8d=w0
	
Convert_RGB64toYV24_SSE41_1:
	or r8d,r8d
	jz Convert_RGB64toYV24_SSE41_3
	
	mov ecx,r8d
Convert_RGB64toYV24_SSE41_2:
	movzx edx,word ptr[rsi]
	movzx r15d,word ptr[rsi+2]
	movzx ebx,word ptr[rsi+4] ; rbx=R r15=G rdx=B	
	mov eax,dword ptr[r10+4*rbx]
	add eax,dword ptr[r10+4*r15+262144]
	add eax,dword ptr[r10+4*rdx+524288]
	pinsrd xmm0,eax,0
	mov eax,dword ptr[r10+4*rbx+786432]
	add eax,dword ptr[r10+4*r15+1048576]
	add eax,dword ptr[r10+4*rdx+1310720]
	pinsrd xmm0,eax,1
	mov eax,dword ptr[r10+4*rbx+1572864]
	add eax,dword ptr[r10+4*r15+1835008]
	add eax,dword ptr[r10+4*rdx+2097152]
	pinsrd xmm0,eax,2
	
	movzx edx,word ptr[rsi+8]
	movzx r15d,word ptr[rsi+10]
	movzx ebx,word ptr[rsi+12] ; rbx=R r15=G rdx=B
	mov eax,dword ptr[r10+4*rbx]
	add eax,dword ptr[r10+4*r15+262144]
	add eax,dword ptr[r10+4*rdx+524288]
	pinsrd xmm4,eax,0
	mov eax,dword ptr[r10+4*rbx+786432]
	add eax,dword ptr[r10+4*r15+1048576]
	add eax,dword ptr[r10+4*rdx+1310720]
	pinsrd xmm4,eax,1
	mov eax,dword ptr[r10+4*rbx+1572864]
	add eax,dword ptr[r10+4*r15+1835008]
	add eax,dword ptr[r10+4*rdx+2097152]
	pinsrd xmm4,eax,2

	paddd xmm0,xmm1
	paddd xmm4,xmm1
	psrad xmm0,8
	psrad xmm4,8
	packusdw xmm0,xmm4
	movhlps xmm4,xmm0
	punpcklwd xmm0,xmm4
	pmaxuw xmm0,xmm2
	pminuw xmm0,xmm3
	
	pextrd eax,xmm0,0
	add rsi,r14
	mov dword ptr[rdi],eax
	pextrd eax,xmm0,1
	add rdi,r13
	mov dword ptr[r11],eax
	pextrd eax,xmm0,2
	add r11,r13
	mov dword ptr[r12],eax	
	add r12,r13
	
	dec ecx
	jnz Convert_RGB64toYV24_SSE41_2
	
Convert_RGB64toYV24_SSE41_3:
	test r9d,1
	jz Convert_RGB64toYV24_SSE41_4
	
	movzx edx,word ptr[rsi]
	movzx r15d,word ptr[rsi+2]
	movzx ebx,word ptr[rsi+4] ; rbx=R r15=G rdx=B
	mov eax,dword ptr[r10+4*rbx]
	add eax,dword ptr[r10+4*r15+262144]
	add eax,dword ptr[r10+4*rdx+524288]
	pinsrd xmm0,eax,0
	mov eax,dword ptr[r10+4*rbx+786432]
	add eax,dword ptr[r10+4*r15+1048576]
	add eax,dword ptr[r10+4*rdx+1310720]
	pinsrd xmm0,eax,1
	mov eax,dword ptr[r10+4*rbx+1572864]
	add eax,dword ptr[r10+4*r15+1835008]
	add eax,dword ptr[r10+4*rdx+2097152]
	pinsrd xmm0,eax,2
	
	paddd xmm0,xmm1
	psrad xmm0,8
	packusdw xmm0,xmm0
	punpcklwd xmm0,xmm0	
	pmaxuw xmm0,xmm2
	pminuw xmm0,xmm3
	
	pextrw eax,xmm0,0
	add rsi,8
	mov word ptr[rdi],ax
	pextrw eax,xmm0,2
	add rdi,2
	mov word ptr[r11],ax
	pextrw eax,xmm0,4
	add r11,2
	mov word ptr[r12],ax
	add r12,2
		
Convert_RGB64toYV24_SSE41_4:	
	add rsi,src_modulo
	add rdi,dst_modulo_y
	add r11,dst_modulo_u
	add r12,dst_modulo_v
	dec h
	jnz Convert_RGB64toYV24_SSE41_1

	pop r15
	pop r14
	pop r13
	pop r12
	pop rbx
	pop rsi
	pop rdi
	pop rbp

	ret

JPSDR_HDRTools_Convert_RGB64toYV24_SSE41 endp


;JPSDR_HDRTools_Convert_RGB64toYV24_AVX proc src:dword,dst_y:dword,dst_u:dword,dst_v:dword,w:dword,h:dword,offset_Y:dword,
; offset_U:dword,offset_V:dword,lookup:dword,src_modulo:dword,dst_modulo_y:dword,dst_modulo_u:dword,dst_modulo_v:dword
;Min_Y:word,Max_Y:word,Min_U:word,Max_U:word,Min_V:word,Max_V:word
; src = rcx
; dst_y = rdx
; dst_u = r8
; dst_v = r9

JPSDR_HDRTools_Convert_RGB64toYV24_AVX proc public frame

w equ dword ptr[rbp+48]
h equ dword ptr[rbp+56]
offset_Y equ dword ptr[rbp+64]
offset_U equ dword ptr[rbp+72]
offset_V equ dword ptr[rbp+80]
lookup equ qword ptr[rbp+88]
src_modulo equ qword ptr[rbp+96]
dst_modulo_y equ qword ptr[rbp+104]
dst_modulo_u equ qword ptr[rbp+112]
dst_modulo_v equ qword ptr[rbp+120]
Min_Y equ word ptr[rbp+128]
Max_Y equ word ptr[rbp+136]
Min_U equ word ptr[rbp+144]
Max_U equ word ptr[rbp+152]
Min_V equ word ptr[rbp+160]
Max_V equ word ptr[rbp+168]

	push rbp
	.pushreg rbp
	mov rbp,rsp
	push rdi
	.pushreg rdi
	push rsi
	.pushreg rsi
	push rbx
	.pushreg rbx
	push r12
	.pushreg r12
	push r13
	.pushreg r13
	push r14
	.pushreg r14
	push r15
	.pushreg r15
	.endprolog

	vpxor xmm4,xmm4,xmm4
	vpxor xmm3,xmm3,xmm3
	vpxor xmm2,xmm2,xmm2
	vpxor xmm1,xmm1,xmm1
	vpxor xmm0,xmm0,xmm0
	mov eax,offset_Y
	vpinsrd xmm1,xmm1,eax,0
	mov eax,offset_U
	vpinsrd xmm1,xmm1,eax,1
	mov eax,offset_V
	vpinsrd xmm1,xmm1,eax,2
	movzx eax,Min_Y
	vpinsrw xmm2,xmm2,eax,0
	vpinsrw xmm2,xmm2,eax,1
	movzx eax,Max_Y
	vpinsrw xmm3,xmm3,eax,0
	vpinsrw xmm3,xmm3,eax,1
	movzx eax,Min_U
	vpinsrw xmm2,xmm2,eax,2
	vpinsrw xmm2,xmm2,eax,3
	movzx eax,Max_U
	vpinsrw xmm3,xmm3,eax,2
	vpinsrw xmm3,xmm3,eax,3
	movzx eax,Min_V
	vpinsrw xmm2,xmm2,eax,4
	vpinsrw xmm2,xmm2,eax,5
	movzx eax,Max_V
	vpinsrw xmm3,xmm3,eax,4
	vpinsrw xmm3,xmm3,eax,5

	mov rsi,rcx
	mov r10,lookup
	mov rdi,rdx				;rdi=dst_y
	mov r11,r8				;r11=dst_u
	mov r12,r9				;r12=dst_v
	mov r13,4
	mov r14,16
	mov r9d,w
	
	xor rax,rax
	xor rdx,rdx
	xor rbx,rbx
	xor r15,r15
	
	mov r8d,r9d
	shr r8d,1				;r8d=w0
	
Convert_RGB64toYV24_AVX_1:
	or r8d,r8d
	jz Convert_RGB64toYV24_AVX_3
	
	mov ecx,r8d
Convert_RGB64toYV24_AVX_2:
	movzx edx,word ptr[rsi]
	movzx r15d,word ptr[rsi+2]
	movzx ebx,word ptr[rsi+4] ; rbx=R r15=G rdx=B	
	mov eax,dword ptr[r10+4*rbx]
	add eax,dword ptr[r10+4*r15+262144]
	add eax,dword ptr[r10+4*rdx+524288]
	vpinsrd xmm0,xmm0,eax,0
	mov eax,dword ptr[r10+4*rbx+786432]
	add eax,dword ptr[r10+4*r15+1048576]
	add eax,dword ptr[r10+4*rdx+1310720]
	vpinsrd xmm0,xmm0,eax,1
	mov eax,dword ptr[r10+4*rbx+1572864]
	add eax,dword ptr[r10+4*r15+1835008]
	add eax,dword ptr[r10+4*rdx+2097152]
	vpinsrd xmm0,xmm0,eax,2
	
	movzx edx,word ptr[rsi+8]
	movzx r15d,word ptr[rsi+10]
	movzx ebx,word ptr[rsi+12] ; rbx=R r15=G rdx=B
	mov eax,dword ptr[r10+4*rbx]
	add eax,dword ptr[r10+4*r15+262144]
	add eax,dword ptr[r10+4*rdx+524288]
	vpinsrd xmm4,xmm4,eax,0
	mov eax,dword ptr[r10+4*rbx+786432]
	add eax,dword ptr[r10+4*r15+1048576]
	add eax,dword ptr[r10+4*rdx+1310720]
	vpinsrd xmm4,xmm4,eax,1
	mov eax,dword ptr[r10+4*rbx+1572864]
	add eax,dword ptr[r10+4*r15+1835008]
	add eax,dword ptr[r10+4*rdx+2097152]
	vpinsrd xmm4,xmm4,eax,2

	vpaddd xmm0,xmm0,xmm1
	vpaddd xmm4,xmm4,xmm1
	vpsrad xmm0,xmm0,8
	vpsrad xmm4,xmm4,8
	vpackusdw xmm0,xmm0,xmm4
	vmovhlps xmm4,xmm4,xmm0
	vpunpcklwd xmm0,xmm0,xmm4
	vpmaxuw xmm0,xmm0,xmm2
	vpminuw xmm0,xmm0,xmm3
	
	vpextrd eax,xmm0,0
	add rsi,r14
	mov dword ptr[rdi],eax
	vpextrd eax,xmm0,1
	add rdi,r13
	mov dword ptr[r11],eax
	vpextrd eax,xmm0,2
	add r11,r13
	mov dword ptr[r12],eax	
	add r12,r13
	
	dec ecx
	jnz Convert_RGB64toYV24_AVX_2
	
Convert_RGB64toYV24_AVX_3:
	test r9d,1
	jz Convert_RGB64toYV24_AVX_4
	
	movzx edx,word ptr[rsi]
	movzx r15d,word ptr[rsi+2]
	movzx ebx,word ptr[rsi+4] ; rbx=R r15=G rdx=B
	mov eax,dword ptr[r10+4*rbx]
	add eax,dword ptr[r10+4*r15+262144]
	add eax,dword ptr[r10+4*rdx+524288]
	vpinsrd xmm0,xmm0,eax,0
	mov eax,dword ptr[r10+4*rbx+786432]
	add eax,dword ptr[r10+4*r15+1048576]
	add eax,dword ptr[r10+4*rdx+1310720]
	vpinsrd xmm0,xmm0,eax,1
	mov eax,dword ptr[r10+4*rbx+1572864]
	add eax,dword ptr[r10+4*r15+1835008]
	add eax,dword ptr[r10+4*rdx+2097152]
	vpinsrd xmm0,xmm0,eax,2
	
	vpaddd xmm0,xmm0,xmm1
	vpsrad xmm0,xmm0,8
	vpackusdw xmm0,xmm0,xmm0
	vpunpcklwd xmm0,xmm0,xmm0	
	vpmaxuw xmm0,xmm0,xmm2
	vpminuw xmm0,xmm0,xmm3
	
	vpextrw eax,xmm0,0
	add rsi,8
	mov word ptr[rdi],ax
	vpextrw eax,xmm0,2
	add rdi,2
	mov word ptr[r11],ax
	vpextrw eax,xmm0,4
	add r11,2
	mov word ptr[r12],ax
	add r12,2
		
Convert_RGB64toYV24_AVX_4:	
	add rsi,src_modulo
	add rdi,dst_modulo_y
	add r11,dst_modulo_u
	add r12,dst_modulo_v
	dec h
	jnz Convert_RGB64toYV24_AVX_1

	pop r15
	pop r14
	pop r13
	pop r12
	pop rbx
	pop rsi
	pop rdi
	pop rbp

	ret

JPSDR_HDRTools_Convert_RGB64toYV24_AVX endp


;JPSDR_HDRTools_Convert_Planar444_to_Planar422_8 proc src:dword,dst:dword,w:dword,h:dword,src_modulo:dword,dst_modulo:dword
; src = rcx
; dst = rdx
; w = r8d
; h = r9d

JPSDR_HDRTools_Convert_Planar444_to_Planar422_8 proc public frame

src_modulo equ qword ptr[rbp+48]
dst_modulo equ qword ptr[rbp+56]


	push rbp
	.pushreg rbp
	mov rbp,rsp
	push rsi
	.pushreg rsi
	push rdi
	.pushreg rdi
	.endprolog
	
	cld
	mov rsi,rcx
	mov rdi,rdx
	mov r10,src_modulo
	mov r11,dst_modulo
	xor rdx,rdx
	xor rax,rax
	
Convert_Planar444_to_Planar422_8_1:
	mov ecx,r8d
	
Convert_Planar444_to_Planar422_8_2:
	lodsb
	mov dl,al
	lodsb
	add ax,dx
	shr ax,1
	stosb
	loop Convert_Planar444_to_Planar422_8_2
	
	add rsi,r10
	add rdi,r11
	dec r9d
	jnz short Convert_Planar444_to_Planar422_8_1

	pop rdi
	pop rsi
	pop rbp

	ret
	
JPSDR_HDRTools_Convert_Planar444_to_Planar422_8 endp


;JPSDR_HDRTools_Convert_Planar444_to_Planar422_16 proc src:dword,dst:dword,w:dword,h:dword,src_modulo:dword,dst_modulo:dword
; src = rcx
; dst = rdx
; w = r8d
; h = r9d

JPSDR_HDRTools_Convert_Planar444_to_Planar422_16 proc public frame

src_modulo equ qword ptr[rbp+48]
dst_modulo equ qword ptr[rbp+56]


	push rbp
	.pushreg rbp
	mov rbp,rsp
	push rsi
	.pushreg rsi
	push rdi
	.pushreg rdi
	.endprolog
	
	cld
	mov rsi,rcx
	mov rdi,rdx
	mov r10,src_modulo
	mov r11,dst_modulo
	xor rdx,rdx
	xor rax,rax
	
Convert_Planar444_to_Planar422_16_1:
	mov ecx,r8d
	
Convert_Planar444_to_Planar422_16_2:
	lodsw
	mov dx,ax
	lodsw
	add eax,edx
	shr eax,1
	stosw
	loop Convert_Planar444_to_Planar422_16_2
	
	add rsi,r10
	add rdi,r11
	dec r9d
	jnz short Convert_Planar444_to_Planar422_16_1

	pop rdi
	pop rsi
	pop rbp

	ret
	
JPSDR_HDRTools_Convert_Planar444_to_Planar422_16 endp


;JPSDR_HDRTools_Convert_Planar444_to_Planar422_8_SSE2 proc src:dword,dst:dword,w16:dword,h:dword,src_pitch:dword,dst_pitch:dword
; src = rcx
; dst = rdx
; w16 = r8d
; h = r9d

JPSDR_HDRTools_Convert_Planar444_to_Planar422_8_SSE2 proc public frame

src_pitch equ qword ptr[rbp+48]
dst_pitch equ qword ptr[rbp+56]

	push rbp
	.pushreg rbp
	mov rbp,rsp
	push rsi
	.pushreg rsi
	push rdi
	.pushreg rdi
	push rbx
	.pushreg rbx
	push r12
	.pushreg r12
	.endprolog		
	
	mov rsi,rcx
	mov rdi,rdx
	mov rdx,rsi
	mov r10d,r8d
	shr r10d,1
	mov r11,src_pitch
	mov r12,dst_pitch
	mov rbx,16
	add rdx,rbx

Convert_Planar444_to_Planar422_8_SSE2_1:
	xor rax,rax
	or r10d,r10d
	jz short Convert_Planar444_to_Planar422_8_SSE2_3
	
	mov ecx,r10d
Convert_Planar444_to_Planar422_8_SSE2_2:
	movdqa xmm0,XMMWORD ptr[rsi+2*rax]
	movdqa xmm2,XMMWORD ptr[rdx+2*rax]
	movdqa xmm1,xmm0
	movdqa xmm3,xmm2
	psllw xmm1,8
	psllw xmm3,8
	pavgb xmm0,xmm1
	pavgb xmm2,xmm3
	psrlw xmm0,8
	psrlw xmm2,8
	packuswb xmm0,xmm2
	
	movdqa XMMWORD ptr[rdi+rax],xmm0
	add rax,rbx
	loop Convert_Planar444_to_Planar422_8_SSE2_2
	
Convert_Planar444_to_Planar422_8_SSE2_3:	
	test r8d,1
	jz short Convert_Planar444_to_Planar422_8_SSE2_4
	
	movdqa xmm0,XMMWORD ptr[rsi+2*rax]
	movdqa xmm1,xmm0
	psllw xmm1,8
	pavgb xmm0,xmm1
	psrlw xmm0,8
	packuswb xmm0,xmm0
	
	movq qword ptr[rdi+rax],xmm0

Convert_Planar444_to_Planar422_8_SSE2_4:	
	add rsi,r11
	add rdx,r11
	add rdi,r12
	dec r9d
	jnz short Convert_Planar444_to_Planar422_8_SSE2_1

	pop r12
	pop rbx
	pop rdi
	pop rsi
	pop rbp

	ret

JPSDR_HDRTools_Convert_Planar444_to_Planar422_8_SSE2 endp


;JPSDR_HDRTools_Convert_Planar444_to_Planar422_16_SSE41 proc src:dword,dst:dword,w8:dword,h:dword,src_pitch:dword,dst_pitch:dword
; src = rcx
; dst = rdx
; w8 = r8d
; h = r9d

JPSDR_HDRTools_Convert_Planar444_to_Planar422_16_SSE41 proc public frame

src_pitch equ qword ptr[rbp+48]
dst_pitch equ qword ptr[rbp+56]

	push rbp
	.pushreg rbp
	mov rbp,rsp
	push rsi
	.pushreg rsi
	push rdi
	.pushreg rdi
	push rbx
	.pushreg rbx
	push r12
	.pushreg r12
	.endprolog		
	
	mov rsi,rcx
	mov rdi,rdx
	mov rdx,rsi
	mov r10d,r8d
	shr r10d,1
	mov r11,src_pitch
	mov r12,dst_pitch
	mov rbx,16
	add rdx,rbx

Convert_Planar444_to_Planar422_16_SSE41_1:
	xor rax,rax
	or r10d,r10d
	jz short Convert_Planar444_to_Planar422_16_SSE41_3
	
	mov ecx,r10d
Convert_Planar444_to_Planar422_16_SSE41_2:
	movdqa xmm0,XMMWORD ptr[rsi+2*rax]
	movdqa xmm2,XMMWORD ptr[rdx+2*rax]	
	movdqa xmm1,xmm0
	movdqa xmm3,xmm2
	pslld xmm1,16
	pslld xmm3,16
	pavgw xmm0,xmm1
	pavgw xmm2,xmm3
	psrld xmm0,16
	psrld xmm2,16
	packusdw xmm0,xmm2
	
	movdqa XMMWORD ptr[rdi+rax],xmm0
	add rax,rbx
	loop Convert_Planar444_to_Planar422_16_SSE41_2
	
Convert_Planar444_to_Planar422_16_SSE41_3:	
	test r8d,1
	jz short Convert_Planar444_to_Planar422_16_SSE41_4
	
	movdqa xmm0,XMMWORD ptr[rsi+2*rax]
	movdqa xmm1,xmm0
	pslld xmm1,16
	pavgw xmm0,xmm1
	psrld xmm0,16
	packusdw xmm0,xmm0
	
	movq qword ptr[rdi+rax],xmm0

Convert_Planar444_to_Planar422_16_SSE41_4:	
	add rsi,r11
	add rdx,r11
	add rdi,r12
	dec r9d
	jnz short Convert_Planar444_to_Planar422_16_SSE41_1

	pop r12
	pop rbx
	pop rdi
	pop rsi
	pop rbp

	ret

JPSDR_HDRTools_Convert_Planar444_to_Planar422_16_SSE41 endp


;JPSDR_HDRTools_Convert_Planar444_to_Planar422_8_AVX proc src:dword,dst:dword,w16:dword,h:dword,src_pitch:dword,dst_pitch:dword
; src = rcx
; dst = rdx
; w16 = r8d
; h = r9d

JPSDR_HDRTools_Convert_Planar444_to_Planar422_8_AVX proc public frame

src_pitch equ qword ptr[rbp+48]
dst_pitch equ qword ptr[rbp+56]

	push rbp
	.pushreg rbp
	mov rbp,rsp
	push rsi
	.pushreg rsi
	push rdi
	.pushreg rdi
	push rbx
	.pushreg rbx
	push r12
	.pushreg r12
	.endprolog		
	
	mov rsi,rcx
	mov rdi,rdx
	mov rdx,rsi
	mov r10d,r8d
	shr r10d,1
	mov r11,src_pitch
	mov r12,dst_pitch
	mov rbx,16
	add rdx,rbx

Convert_Planar444_to_Planar422_8_AVX_1:
	xor rax,rax
	or r10d,r10d
	jz short Convert_Planar444_to_Planar422_8_AVX_3
	
	mov ecx,r10d
Convert_Planar444_to_Planar422_8_AVX_2:
	vmovdqa xmm0,XMMWORD ptr[rsi+2*rax]
	vmovdqa xmm2,XMMWORD ptr[rdx+2*rax]
	vpsllw xmm1,xmm0,8
	vpsllw xmm3,xmm2,8
	vpavgb xmm0,xmm0,xmm1
	vpavgb xmm2,xmm2,xmm3
	vpsrlw xmm0,xmm0,8
	vpsrlw xmm2,xmm2,8
	vpackuswb xmm0,xmm0,xmm2
	
	vmovdqa XMMWORD ptr[rdi+rax],xmm0
	add rax,rbx
	loop Convert_Planar444_to_Planar422_8_AVX_2
	
Convert_Planar444_to_Planar422_8_AVX_3:	
	test r8d,1
	jz short Convert_Planar444_to_Planar422_8_AVX_4
	
	vmovdqa xmm0,XMMWORD ptr[rsi+2*rax]
	vpsllw xmm1,xmm0,8
	vpavgb xmm0,xmm0,xmm1	
	vpsrlw xmm0,xmm0,8
	vpackuswb xmm0,xmm0,xmm0
	
	vmovq qword ptr[rdi+rax],xmm0

Convert_Planar444_to_Planar422_8_AVX_4:	
	add rsi,r11
	add rdx,r11
	add rdi,r12
	dec r9d
	jnz short Convert_Planar444_to_Planar422_8_AVX_1

	pop r12
	pop rbx
	pop rdi
	pop rsi
	pop rbp

	ret

JPSDR_HDRTools_Convert_Planar444_to_Planar422_8_AVX endp


;JPSDR_HDRTools_Convert_Planar444_to_Planar422_16_AVX proc src:dword,dst:dword,w8:dword,h:dword,src_pitch:dword,dst_pitch:dword
; src = rcx
; dst = rdx
; w8 = r8d
; h = r9d

JPSDR_HDRTools_Convert_Planar444_to_Planar422_16_AVX proc public frame

src_pitch equ qword ptr[rbp+48]
dst_pitch equ qword ptr[rbp+56]

	push rbp
	.pushreg rbp
	mov rbp,rsp
	push rsi
	.pushreg rsi
	push rdi
	.pushreg rdi
	push rbx
	.pushreg rbx
	push r12
	.pushreg r12
	.endprolog		
	
	mov rsi,rcx
	mov rdi,rdx
	mov rdx,rsi
	mov r10d,r8d
	shr r10d,1
	mov r11,src_pitch
	mov r12,dst_pitch
	mov rbx,16
	add rdx,rbx

Convert_Planar444_to_Planar422_16_AVX_1:
	xor rax,rax
	or r10d,r10d
	jz short Convert_Planar444_to_Planar422_16_AVX_3
	
	mov ecx,r10d
Convert_Planar444_to_Planar422_16_AVX_2:
	vmovdqa xmm0,XMMWORD ptr[rsi+2*rax]
	vmovdqa xmm2,XMMWORD ptr[rdx+2*rax]
	vpslld xmm1,xmm0,16
	vpslld xmm3,xmm2,16
	vpavgw xmm0,xmm0,xmm1
	vpavgw xmm2,xmm2,xmm3
	vpsrld xmm0,xmm0,16
	vpsrld xmm2,xmm2,16
	vpackusdw xmm0,xmm0,xmm2
	
	vmovdqa XMMWORD ptr[rdi+rax],xmm0
	add rax,rbx
	loop Convert_Planar444_to_Planar422_16_AVX_2
	
Convert_Planar444_to_Planar422_16_AVX_3:	
	test r8d,1
	jz short Convert_Planar444_to_Planar422_16_AVX_4
	
	vmovdqa xmm0,XMMWORD ptr[rsi+2*rax]
	vpslld xmm1,xmm0,16
	vpavgw xmm0,xmm0,xmm1
	vpsrld xmm0,xmm0,16
	vpackusdw xmm0,xmm0,xmm0
	
	vmovq qword ptr[rdi+rax],xmm0

Convert_Planar444_to_Planar422_16_AVX_4:	
	add rsi,r11
	add rdx,r11
	add rdi,r12
	dec r9d
	jnz short Convert_Planar444_to_Planar422_16_AVX_1

	pop r12
	pop rbx
	pop rdi
	pop rsi
	pop rbp

	ret

JPSDR_HDRTools_Convert_Planar444_to_Planar422_16_AVX endp


;JPSDR_HDRTools_Convert_Planar422_to_Planar420_8_SSE2 proc src1:dword,src2:dword,dst:dword,w16:dword,h:dword,src_pitch2:dword,dst_pitch:dword
; src1 = rcx
; src2 = rdx
; dst = r8
; w16 = r9d

JPSDR_HDRTools_Convert_Planar422_to_Planar420_8_SSE2 proc public frame

h equ dword ptr[rbp+48]
src_pitch2 equ qword ptr[rbp+56]
dst_pitch equ qword ptr[rbp+64]

	push rbp
	.pushreg rbp
	mov rbp,rsp
	push rsi
	.pushreg rsi
	push rbx
	.pushreg rbx
	push r12
	.pushreg r12
	.endprolog		
	
	mov rsi,rcx
	mov r10d,h
	mov rbx,16
	mov r11,src_pitch2
	mov r12,dst_pitch

Convert_Planar422_to_Planar420_8_SSE2_1:
	xor rax,rax
	mov ecx,r9d

Convert_Planar422_to_Planar420_8_SSE2_2:
	movdqa xmm0,XMMWORD ptr[rsi+rax]
	pavgb xmm0,XMMWORD ptr[rdx+rax]
	
	movdqa XMMWORD ptr[r8+rax],xmm0
	add rax,rbx
	loop Convert_Planar422_to_Planar420_8_SSE2_2
	
	add rsi,r11
	add rdx,r11
	add r8,r12
	dec r10d
	jnz short Convert_Planar422_to_Planar420_8_SSE2_1

	pop r12
	pop rbx
	pop rsi
	pop rbp

	ret

JPSDR_HDRTools_Convert_Planar422_to_Planar420_8_SSE2 endp


;JPSDR_HDRTools_Convert_Planar422_to_Planar420_16_SSE2 proc src1:dword,src2:dword,dst:dword,w8:dword,h:dword,src_pitch2:dword,dst_pitch:dword
; src1 = rcx
; src2 = rdx
; dst = r8
; w8 = r9d

JPSDR_HDRTools_Convert_Planar422_to_Planar420_16_SSE2 proc public frame

h equ dword ptr[rbp+48]
src_pitch2 equ qword ptr[rbp+56]
dst_pitch equ qword ptr[rbp+64]

	push rbp
	.pushreg rbp
	mov rbp,rsp
	push rsi
	.pushreg rsi
	push rbx
	.pushreg rbx
	push r12
	.pushreg r12
	.endprolog		
	
	mov rsi,rcx
	mov r10d,h
	mov rbx,16
	mov r11,src_pitch2
	mov r12,dst_pitch

Convert_Planar422_to_Planar420_16_SSE2_1:
	xor rax,rax
	mov ecx,r9d

Convert_Planar422_to_Planar420_16_SSE2_2:
	movdqa xmm0,XMMWORD ptr[rsi+rax]
	pavgw xmm0,XMMWORD ptr[rdx+rax]
	
	movdqa XMMWORD ptr[r8+rax],xmm0
	add rax,rbx
	loop Convert_Planar422_to_Planar420_16_SSE2_2
	
	add rsi,r11
	add rdx,r11
	add r8,r12
	dec r10d
	jnz short Convert_Planar422_to_Planar420_16_SSE2_1

	pop r12
	pop rbx
	pop rsi
	pop rbp

	ret

JPSDR_HDRTools_Convert_Planar422_to_Planar420_16_SSE2 endp


;JPSDR_HDRTools_Convert_Planar422_to_Planar420_8_AVX proc src1:dword,src2:dword,dst:dword,w16:dword,h:dword,src_pitch2:dword,dst_pitch:dword
; src1 = rcx
; src2 = rdx
; dst = r8
; w16 = r9d

JPSDR_HDRTools_Convert_Planar422_to_Planar420_8_AVX proc public frame

h equ dword ptr[rbp+48]
src_pitch2 equ qword ptr[rbp+56]
dst_pitch equ qword ptr[rbp+64]

	push rbp
	.pushreg rbp
	mov rbp,rsp
	push rsi
	.pushreg rsi
	push rbx
	.pushreg rbx
	push r12
	.pushreg r12
	.endprolog		
	
	mov rsi,rcx
	mov r10d,h
	mov rbx,16
	mov r11,src_pitch2
	mov r12,dst_pitch

Convert_Planar422_to_Planar420_8_AVX_1:
	xor rax,rax
	mov ecx,r9d

Convert_Planar422_to_Planar420_8_AVX_2:
	vmovdqa xmm0,XMMWORD ptr[rsi+rax]
	vpavgb xmm0,xmm0,XMMWORD ptr[rdx+rax]
	
	vmovdqa XMMWORD ptr[r8+rax],xmm0
	add rax,rbx
	loop Convert_Planar422_to_Planar420_8_AVX_2
	
	add rsi,r11
	add rdx,r11
	add r8,r12
	dec r10d
	jnz short Convert_Planar422_to_Planar420_8_AVX_1

	pop r12
	pop rbx
	pop rsi
	pop rbp

	ret

JPSDR_HDRTools_Convert_Planar422_to_Planar420_8_AVX endp


;JPSDR_HDRTools_Convert_Planar422_to_Planar420_16_AVX proc src1:dword,src2:dword,dst:dword,w8:dword,h:dword,src_pitch2:dword,dst_pitch:dword
; src1 = rcx
; src2 = rdx
; dst = r8
; w8 = r9d

JPSDR_HDRTools_Convert_Planar422_to_Planar420_16_AVX proc public frame

h equ dword ptr[rbp+48]
src_pitch2 equ qword ptr[rbp+56]
dst_pitch equ qword ptr[rbp+64]

	push rbp
	.pushreg rbp
	mov rbp,rsp
	push rsi
	.pushreg rsi
	push rbx
	.pushreg rbx
	push r12
	.pushreg r12
	.endprolog		
	
	mov rsi,rcx
	mov r10d,h
	mov rbx,16
	mov r11,src_pitch2
	mov r12,dst_pitch

Convert_Planar422_to_Planar420_16_AVX_1:
	xor rax,rax
	mov ecx,r9d

Convert_Planar422_to_Planar420_16_AVX_2:
	vmovdqa xmm0,XMMWORD ptr[rsi+rax]
	vpavgw xmm0,xmm0,XMMWORD ptr[rdx+rax]
	
	vmovdqa XMMWORD ptr[r8+rax],xmm0
	add rax,rbx
	loop Convert_Planar422_to_Planar420_16_AVX_2
	
	add rsi,r11
	add rdx,r11
	add r8,r12
	dec r10d
	jnz short Convert_Planar422_to_Planar420_16_AVX_1

	pop r12
	pop rbx
	pop rsi
	pop rbp

	ret

JPSDR_HDRTools_Convert_Planar422_to_Planar420_16_AVX endp


;***************************************************
;**             XYZ/RGB functions                 **
;***************************************************


;JPSDR_HDRTools_Convert_PackedXYZ_8_SSE2 proc src:dword,dst:dword,w:dword,h:dword,lookup:dword,
;	src_modulo:dword,dst_modulo:dword
; src = rcx
; dst = rdx
; w = r8d
; h = r9d

JPSDR_HDRTools_Convert_PackedXYZ_8_SSE2 proc public frame

lookup equ qword ptr[rbp+48]
src_modulo equ qword ptr[rbp+56]
dst_modulo equ qword ptr[rbp+64]

	push rbp
	.pushreg rbp
	mov rbp,rsp
	push rdi
	.pushreg rdi
	push rsi
	.pushreg rsi
	push rbx
	.pushreg rbx
	push r12
	.pushreg r12
	push r13
	.pushreg r13
	push r14
	.pushreg r14
	push r15
	.pushreg r15
	.endprolog

	xor rax,rax
	mov rsi,rcx
	mov r10,lookup
	mov rdi,rdx				;rdi=dst
	mov r12,src_modulo
	mov r13,dst_modulo
	mov r14,16
	
	xor rdx,rdx
	xor rbx,rbx
	xor r15,r15
	
	mov r11d,r8d
	shr r11d,2				;r11d=w0
	
Convert_PackedXYZ_8_SSE2_1:
	or r11d,r11d
	jz Convert_PackedXYZ_8_SSE2_3
	
	mov ecx,r11d
Convert_PackedXYZ_8_SSE2_2:
	pxor xmm0,xmm0
	movzx edx,byte ptr[rsi]
	movzx r15d,byte ptr[rsi+1]
	movzx ebx,byte ptr[rsi+2] ; rbx=R/X r15=G/Y rdx=B/Z
	movzx eax,word ptr[r10+2*rbx]
	add ax,word ptr[r10+2*r15+512]
	add ax,word ptr[r10+2*rdx+1024]
	pinsrw xmm0,eax,2
	movzx eax,word ptr[r10+2*rbx+1536]
	add ax,word ptr[r10+2*r15+2048]
	add ax,word ptr[r10+2*rdx+2560]
	pinsrw xmm0,eax,1
	movzx eax,word ptr[r10+2*rbx+3072]
	add ax,word ptr[r10+2*r15+3584]
	add ax,word ptr[r10+2*rdx+4096]
	pinsrw xmm0,eax,0
	movzx edx,byte ptr[rsi+4]
	movzx r15d,byte ptr[rsi+5]
	movzx ebx,byte ptr[rsi+6] ; rbx=R/X r15=G/Y rdx=B/Z
	movzx eax,word ptr[r10+2*rbx]
	add ax,word ptr[r10+2*r15+512]
	add ax,word ptr[r10+2*rdx+1024]
	pinsrw xmm0,eax,6
	movzx eax,word ptr[r10+2*rbx+1536]
	add ax,word ptr[r10+2*r15+2048]
	add ax,word ptr[r10+2*rdx+2560]
	pinsrw xmm0,eax,5
	movzx eax,word ptr[r10+2*rbx+3072]
	add ax,word ptr[r10+2*r15+3584]
	add ax,word ptr[r10+2*rdx+4096]
	pinsrw xmm0,eax,4
	
	pxor xmm1,xmm1
	movzx edx,byte ptr[rsi+8]
	movzx r15d,byte ptr[rsi+9]
	movzx ebx,byte ptr[rsi+10] ; rbx=R/X r15=G/Y rdx=B/Z
	movzx eax,word ptr[r10+2*rbx]
	add ax,word ptr[r10+2*r15+512]
	add ax,word ptr[r10+2*rdx+1024]
	pinsrw xmm1,eax,2
	movzx eax,word ptr[r10+2*rbx+1536]
	add ax,word ptr[r10+2*r15+2048]
	add ax,word ptr[r10+2*rdx+2560]
	pinsrw xmm1,eax,1
	movzx eax,word ptr[r10+2*rbx+3072]
	add ax,word ptr[r10+2*r15+3584]
	add ax,word ptr[r10+2*rdx+4096]
	pinsrw xmm1,eax,0
	movzx edx,byte ptr[rsi+12]
	movzx r15d,byte ptr[rsi+13]
	movzx ebx,byte ptr[rsi+14] ; rbx=R/X r15=G/Y rdx=B/Z
	movzx eax,word ptr[r10+2*rbx]
	add ax,word ptr[r10+2*r15+512]
	add ax,word ptr[r10+2*rdx+1024]
	pinsrw xmm1,eax,6
	movzx eax,word ptr[r10+2*rbx+1536]
	add ax,word ptr[r10+2*r15+2048]
	add ax,word ptr[r10+2*rdx+2560]
	pinsrw xmm1,eax,5
	movzx eax,word ptr[r10+2*rbx+3072]
	add ax,word ptr[r10+2*r15+3584]
	add ax,word ptr[r10+2*rdx+4096]
	pinsrw xmm1,eax,4
	
	psraw xmm0,4
	psraw xmm1,4
	packuswb xmm0,xmm1
	
	movdqa XMMWORD ptr[rdi],xmm0
	
	add rsi,r14
	add rdi,r14

	dec ecx
	jnz Convert_PackedXYZ_8_SSE2_2
	
Convert_PackedXYZ_8_SSE2_3:
	test r8d,3
	jz Convert_PackedXYZ_8_SSE2_5
	
	pxor xmm0,xmm0
	test r8d,2
	jnz Convert_PackedXYZ_8_SSE2_4
	
	movzx edx,byte ptr[rsi]
	movzx r15d,byte ptr[rsi+1]
	movzx ebx,byte ptr[rsi+2] ; rbx=R/X r15=G/Y rdx=B/Z
	movzx eax,word ptr[r10+2*rbx]
	add ax,word ptr[r10+2*r15+512]
	add ax,word ptr[r10+2*rdx+1024]
	pinsrw xmm0,eax,2
	movzx eax,word ptr[r10+2*rbx+1536]
	add ax,word ptr[r10+2*r15+2048]
	add ax,word ptr[r10+2*rdx+2560]
	pinsrw xmm0,eax,1
	movzx eax,word ptr[r10+2*rbx+3072]
	add ax,word ptr[r10+2*r15+3584]
	add ax,word ptr[r10+2*rdx+4096]
	pinsrw xmm0,eax,0
	
	psraw xmm0,4
	packuswb xmm0,xmm0
	
	movd dword ptr[rdi],xmm0
	
	add rsi,4
	add rdi,4

	jmp Convert_PackedXYZ_8_SSE2_5
		
Convert_PackedXYZ_8_SSE2_4:
	movzx edx,byte ptr[rsi]
	movzx r15d,byte ptr[rsi+1]
	movzx ebx,byte ptr[rsi+2] ; rbx=R/X r15=G/Y rdx=B/Z
	movzx eax,word ptr[r10+2*rbx]
	add ax,word ptr[r10+2*r15+512]
	add ax,word ptr[r10+2*rdx+1024]
	pinsrw xmm0,eax,2
	movzx eax,word ptr[r10+2*rbx+1536]
	add ax,word ptr[r10+2*r15+2048]
	add ax,word ptr[r10+2*rdx+2560]
	pinsrw xmm0,eax,1
	movzx eax,word ptr[r10+2*rbx+3072]
	add ax,word ptr[r10+2*r15+3584]
	add ax,word ptr[r10+2*rdx+4096]
	pinsrw xmm0,eax,0
	movzx edx,byte ptr[rsi+4]
	movzx r15d,byte ptr[rsi+5]
	movzx ebx,byte ptr[rsi+6] ; rbx=R/X r15=G/Y rdx=B/Z
	movzx eax,word ptr[r10+2*rbx]
	add ax,word ptr[r10+2*r15+512]
	add ax,word ptr[r10+2*rdx+1024]
	pinsrw xmm0,eax,6
	movzx eax,word ptr[r10+2*rbx+1536]
	add ax,word ptr[r10+2*r15+2048]
	add ax,word ptr[r10+2*rdx+2560]
	pinsrw xmm0,eax,5
	movzx eax,word ptr[r10+2*rbx+3072]
	add ax,word ptr[r10+2*r15+3584]
	add ax,word ptr[r10+2*rdx+4096]
	pinsrw xmm0,eax,4
	
	psraw xmm0,4
	packuswb xmm0,xmm0
	
	movq qword ptr[rdi],xmm0
	
	add rsi,8
	add rdi,8
	
	test r8d,1
	jz Convert_PackedXYZ_8_SSE2_5
	
	pxor xmm0,xmm0
	movzx edx,byte ptr[rsi]
	movzx r15d,byte ptr[rsi+1]
	movzx ebx,byte ptr[rsi+2] ; rbx=R/X r15=G/Y rdx=B/Z
	movzx eax,word ptr[r10+2*rbx]
	add ax,word ptr[r10+2*r15+512]
	add ax,word ptr[r10+2*rdx+1024]
	pinsrw xmm0,eax,2
	movzx eax,word ptr[r10+2*rbx+1536]
	add ax,word ptr[r10+2*r15+2048]
	add ax,word ptr[r10+2*rdx+2560]
	pinsrw xmm0,eax,1
	movzx eax,word ptr[r10+2*rbx+3072]
	add ax,word ptr[r10+2*r15+3584]
	add ax,word ptr[r10+2*rdx+4096]
	pinsrw xmm0,eax,0
	
	psraw xmm0,4
	packuswb xmm0,xmm0
	
	movd dword ptr[rdi],xmm0
	
	add rsi,4
	add rdi,4
		
Convert_PackedXYZ_8_SSE2_5:	
	add rsi,r12
	add rdi,r13
	dec r9d
	jnz Convert_PackedXYZ_8_SSE2_1

	pop r15
	pop r14
	pop r13
	pop r12
	pop rbx
	pop rsi
	pop rdi
	pop rbp

	ret

JPSDR_HDRTools_Convert_PackedXYZ_8_SSE2 endp


;JPSDR_HDRTools_Convert_PackedXYZ_8_AVX proc src:dword,dst:dword,w:dword,h:dword,lookup:dword,
;	src_modulo:dword,dst_modulo:dword
; src = rcx
; dst = rdx
; w = r8d
; h = r9d

JPSDR_HDRTools_Convert_PackedXYZ_8_AVX proc public frame

lookup equ qword ptr[rbp+48]
src_modulo equ qword ptr[rbp+56]
dst_modulo equ qword ptr[rbp+64]

	push rbp
	.pushreg rbp
	mov rbp,rsp
	push rdi
	.pushreg rdi
	push rsi
	.pushreg rsi
	push rbx
	.pushreg rbx
	push r12
	.pushreg r12
	push r13
	.pushreg r13
	push r14
	.pushreg r14
	push r15
	.pushreg r15
	.endprolog

	xor rax,rax
	mov rsi,rcx
	mov r10,lookup
	mov rdi,rdx				;rdi=dst
	mov r12,src_modulo
	mov r13,dst_modulo
	mov r14,16
	
	xor rdx,rdx
	xor rbx,rbx
	xor r15,r15
	vpxor xmm0,xmm0,xmm0
	vpxor xmm1,xmm1,xmm1
	
	
	mov r11d,r8d
	shr r11d,2				;r11d=w0
	
Convert_PackedXYZ_8_AVX_1:
	or r11d,r11d
	jz Convert_PackedXYZ_8_AVX_3
	
	mov ecx,r11d
Convert_PackedXYZ_8_AVX_2:
	movzx edx,byte ptr[rsi]
	movzx r15d,byte ptr[rsi+1]
	movzx ebx,byte ptr[rsi+2] ; rbx=R/X r15=G/Y rdx=B/Z
	movzx eax,word ptr[r10+2*rbx]
	add ax,word ptr[r10+2*r15+512]
	add ax,word ptr[r10+2*rdx+1024]
	vpinsrw xmm0,xmm0,eax,2
	movzx eax,word ptr[r10+2*rbx+1536]
	add ax,word ptr[r10+2*r15+2048]
	add ax,word ptr[r10+2*rdx+2560]
	vpinsrw xmm0,xmm0,eax,1
	movzx eax,word ptr[r10+2*rbx+3072]
	add ax,word ptr[r10+2*r15+3584]
	add ax,word ptr[r10+2*rdx+4096]
	vpinsrw xmm0,xmm0,eax,0
	movzx edx,byte ptr[rsi+4]
	movzx r15d,byte ptr[rsi+5]
	movzx ebx,byte ptr[rsi+6] ; rbx=R/X r15=G/Y rdx=B/Z
	movzx eax,word ptr[r10+2*rbx]
	add ax,word ptr[r10+2*r15+512]
	add ax,word ptr[r10+2*rdx+1024]
	vpinsrw xmm0,xmm0,eax,6
	movzx eax,word ptr[r10+2*rbx+1536]
	add ax,word ptr[r10+2*r15+2048]
	add ax,word ptr[r10+2*rdx+2560]
	vpinsrw xmm0,xmm0,eax,5
	movzx eax,word ptr[r10+2*rbx+3072]
	add ax,word ptr[r10+2*r15+3584]
	add ax,word ptr[r10+2*rdx+4096]
	vpinsrw xmm0,xmm0,eax,4
	
	movzx edx,byte ptr[rsi+8]
	movzx r15d,byte ptr[rsi+9]
	movzx ebx,byte ptr[rsi+10] ; rbx=R/X r15=G/Y rdx=B/Z
	movzx eax,word ptr[r10+2*rbx]
	add ax,word ptr[r10+2*r15+512]
	add ax,word ptr[r10+2*rdx+1024]
	vpinsrw xmm1,xmm1,eax,2
	movzx eax,word ptr[r10+2*rbx+1536]
	add ax,word ptr[r10+2*r15+2048]
	add ax,word ptr[r10+2*rdx+2560]
	vpinsrw xmm1,xmm1,eax,1
	movzx eax,word ptr[r10+2*rbx+3072]
	add ax,word ptr[r10+2*r15+3584]
	add ax,word ptr[r10+2*rdx+4096]
	vpinsrw xmm1,xmm1,eax,0
	movzx edx,byte ptr[rsi+12]
	movzx r15d,byte ptr[rsi+13]
	movzx ebx,byte ptr[rsi+14] ; rbx=R/X r15=G/Y rdx=B/Z
	movzx eax,word ptr[r10+2*rbx]
	add ax,word ptr[r10+2*r15+512]
	add ax,word ptr[r10+2*rdx+1024]
	vpinsrw xmm1,xmm1,eax,6
	movzx eax,word ptr[r10+2*rbx+1536]
	add ax,word ptr[r10+2*r15+2048]
	add ax,word ptr[r10+2*rdx+2560]
	vpinsrw xmm1,xmm1,eax,5
	movzx eax,word ptr[r10+2*rbx+3072]
	add ax,word ptr[r10+2*r15+3584]
	add ax,word ptr[r10+2*rdx+4096]
	vpinsrw xmm1,xmm1,eax,4
	
	vpsraw xmm0,xmm0,4
	vpsraw xmm1,xmm1,4
	vpackuswb xmm2,xmm0,xmm1
	
	vmovdqa XMMWORD ptr[rdi],xmm2
	
	add rsi,r14
	add rdi,r14

	dec ecx
	jnz Convert_PackedXYZ_8_AVX_2
	
Convert_PackedXYZ_8_AVX_3:
	test r8d,3
	jz Convert_PackedXYZ_8_AVX_5
	
	test r8d,2
	jnz Convert_PackedXYZ_8_AVX_4
	
	movzx edx,byte ptr[rsi]
	movzx r15d,byte ptr[rsi+1]
	movzx ebx,byte ptr[rsi+2] ; rbx=R/X r15=G/Y rdx=B/Z
	movzx eax,word ptr[r10+2*rbx]
	add ax,word ptr[r10+2*r15+512]
	add ax,word ptr[r10+2*rdx+1024]
	vpinsrw xmm0,xmm0,eax,2
	movzx eax,word ptr[r10+2*rbx+1536]
	add ax,word ptr[r10+2*r15+2048]
	add ax,word ptr[r10+2*rdx+2560]
	vpinsrw xmm0,xmm0,eax,1
	movzx eax,word ptr[r10+2*rbx+3072]
	add ax,word ptr[r10+2*r15+3584]
	add ax,word ptr[r10+2*rdx+4096]
	vpinsrw xmm0,xmm0,eax,0
	
	vpsraw xmm0,xmm0,4
	vpackuswb xmm2,xmm0,xmm0
	
	vmovd dword ptr[rdi],xmm2
	
	add rsi,4
	add rdi,4

	jmp Convert_PackedXYZ_8_AVX_5
		
Convert_PackedXYZ_8_AVX_4:
	movzx edx,byte ptr[rsi]
	movzx r15d,byte ptr[rsi+1]
	movzx ebx,byte ptr[rsi+2] ; rbx=R/X r15=G/Y rdx=B/Z
	movzx eax,word ptr[r10+2*rbx]
	add ax,word ptr[r10+2*r15+512]
	add ax,word ptr[r10+2*rdx+1024]
	vpinsrw xmm0,xmm0,eax,2
	movzx eax,word ptr[r10+2*rbx+1536]
	add ax,word ptr[r10+2*r15+2048]
	add ax,word ptr[r10+2*rdx+2560]
	vpinsrw xmm0,xmm0,eax,1
	movzx eax,word ptr[r10+2*rbx+3072]
	add ax,word ptr[r10+2*r15+3584]
	add ax,word ptr[r10+2*rdx+4096]
	vpinsrw xmm0,xmm0,eax,0
	movzx edx,byte ptr[rsi+4]
	movzx r15d,byte ptr[rsi+5]
	movzx ebx,byte ptr[rsi+6] ; rbx=R/X r15=G/Y rdx=B/Z
	movzx eax,word ptr[r10+2*rbx]
	add ax,word ptr[r10+2*r15+512]
	add ax,word ptr[r10+2*rdx+1024]
	vpinsrw xmm0,xmm0,eax,6
	movzx eax,word ptr[r10+2*rbx+1536]
	add ax,word ptr[r10+2*r15+2048]
	add ax,word ptr[r10+2*rdx+2560]
	vpinsrw xmm0,xmm0,eax,5
	movzx eax,word ptr[r10+2*rbx+3072]
	add ax,word ptr[r10+2*r15+3584]
	add ax,word ptr[r10+2*rdx+4096]
	vpinsrw xmm0,xmm0,eax,4
	
	vpsraw xmm0,xmm0,4
	vpackuswb xmm2,xmm0,xmm0
	
	vmovq qword ptr[rdi],xmm2
	
	add rsi,8
	add rdi,8
	
	test r8d,1
	jz short Convert_PackedXYZ_8_AVX_5
	
	movzx edx,byte ptr[rsi]
	movzx r15d,byte ptr[rsi+1]
	movzx ebx,byte ptr[rsi+2] ; rbx=R/X r15=G/Y rdx=B/Z
	movzx eax,word ptr[r10+2*rbx]
	add ax,word ptr[r10+2*r15+512]
	add ax,word ptr[r10+2*rdx+1024]
	vpinsrw xmm0,xmm0,eax,2
	movzx eax,word ptr[r10+2*rbx+1536]
	add ax,word ptr[r10+2*r15+2048]
	add ax,word ptr[r10+2*rdx+2560]
	vpinsrw xmm0,xmm0,eax,1
	movzx eax,word ptr[r10+2*rbx+3072]
	add ax,word ptr[r10+2*r15+3584]
	add ax,word ptr[r10+2*rdx+4096]
	vpinsrw xmm0,xmm0,eax,0
	
	vpsraw xmm0,xmm0,4
	vpackuswb xmm2,xmm0,xmm0
	
	vmovd dword ptr[rdi],xmm2
	
	add rsi,4
	add rdi,4
		
Convert_PackedXYZ_8_AVX_5:	
	add rsi,r12
	add rdi,r13
	dec r9d
	jnz Convert_PackedXYZ_8_AVX_1

	pop r15
	pop r14
	pop r13
	pop r12
	pop rbx
	pop rsi
	pop rdi
	pop rbp

	ret

JPSDR_HDRTools_Convert_PackedXYZ_8_AVX endp


;JPSDR_HDRTools_Convert_PackedXYZ_16_SSE41 proc src:dword,dst:dword,w:dword,h:dword,lookup:dword,
;	src_modulo:dword,dst_modulo:dword
; src = rcx
; dst = rdx
; w = r8d
; h = r9d

JPSDR_HDRTools_Convert_PackedXYZ_16_SSE41 proc public frame

lookup equ qword ptr[rbp+48]
src_modulo equ qword ptr[rbp+56]
dst_modulo equ qword ptr[rbp+64]

	push rbp
	.pushreg rbp
	mov rbp,rsp
	push rdi
	.pushreg rdi
	push rsi
	.pushreg rsi
	push rbx
	.pushreg rbx
	push r12
	.pushreg r12
	push r13
	.pushreg r13
	push r14
	.pushreg r14
	push r15
	.pushreg r15
	.endprolog

	xor rax,rax
	mov rsi,rcx
	mov r10,lookup
	mov rdi,rdx				;rdi=dst
	mov r12,src_modulo
	mov r13,dst_modulo
	mov r14,16
	
	xor rdx,rdx
	xor rbx,rbx
	xor r15,r15
	
	mov r11d,r8d
	shr r11d,1				;r11d=w0
	
Convert_PackedXYZ_16_SSE41_1:
	or r11d,r11d
	jz Convert_PackedXYZ_16_SSE41_3
	
	mov ecx,r11d
Convert_PackedXYZ_16_SSE41_2:
	pxor xmm0,xmm0
	movzx edx,word ptr[rsi]
	movzx r15d,word ptr[rsi+2]
	movzx ebx,word ptr[rsi+4] ; rbx=R/X r15=G/Y rdx=B/Z
	mov eax,dword ptr[r10+4*rbx]
	add eax,dword ptr[r10+4*r15+262144]
	add eax,dword ptr[r10+4*rdx+524288]
	pinsrd xmm0,eax,2
	mov eax,dword ptr[r10+4*rbx+786432]
	add eax,dword ptr[r10+4*r15+1048576]
	add eax,dword ptr[r10+4*rdx+1310720]
	pinsrd xmm0,eax,1
	mov eax,dword ptr[r10+4*rbx+1572864]
	add eax,dword ptr[r10+4*r15+1835008]
	add eax,dword ptr[r10+4*rdx+2097152]
	pinsrd xmm0,eax,0
	
	pxor xmm1,xmm1
	movzx edx,word ptr[rsi+8]
	movzx r15d,word ptr[rsi+10]
	movzx ebx,word ptr[rsi+12] ; rbx=R/X r15=G/Y rdx=B/Z
	mov eax,dword ptr[r10+4*rbx]
	add eax,dword ptr[r10+4*r15+262144]
	add eax,dword ptr[r10+4*rdx+524288]
	pinsrd xmm1,eax,2
	mov eax,dword ptr[r10+4*rbx+786432]
	add eax,dword ptr[r10+4*r15+1048576]
	add eax,dword ptr[r10+4*rdx+1310720]
	pinsrd xmm1,eax,1
	mov eax,dword ptr[r10+4*rbx+1572864]
	add eax,dword ptr[r10+4*r15+1835008]
	add eax,dword ptr[r10+4*rdx+2097152]
	pinsrd xmm1,eax,0

	psrad xmm0,8
	psrad xmm1,8
	packusdw xmm0,xmm1
	
	movdqa XMMWORD ptr[rdi],xmm0
	
	add rsi,r14
	add rdi,r14

	dec ecx
	jnz Convert_PackedXYZ_16_SSE41_2
	
Convert_PackedXYZ_16_SSE41_3:
	test r8d,1
	jz short Convert_PackedXYZ_16_SSE41_4
	
	pxor xmm0,xmm0
	movzx edx,word ptr[rsi]
	movzx r15d,word ptr[rsi+2]
	movzx ebx,word ptr[rsi+4] ; rbx=R/X r15=G/Y rdx=B/Z
	mov eax,dword ptr[r10+4*rbx]
	add eax,dword ptr[r10+4*r15+262144]
	add eax,dword ptr[r10+4*rdx+524288]
	pinsrd xmm0,eax,2
	mov eax,dword ptr[r10+4*rbx+786432]
	add eax,dword ptr[r10+4*r15+1048576]
	add eax,dword ptr[r10+4*rdx+1310720]
	pinsrd xmm0,eax,1
	mov eax,dword ptr[r10+4*rbx+1572864]
	add eax,dword ptr[r10+4*r15+1835008]
	add eax,dword ptr[r10+4*rdx+2097152]
	pinsrd xmm0,eax,0

	psrad xmm0,8
	packusdw xmm0,xmm0
	
	movq qword ptr[rdi],xmm0
	
	add rsi,8
	add rdi,8

Convert_PackedXYZ_16_SSE41_4:	
	add rsi,r12
	add rdi,r13
	dec r9d
	jnz Convert_PackedXYZ_16_SSE41_1

	pop r15
	pop r14
	pop r13
	pop r12
	pop rbx
	pop rsi
	pop rdi
	pop rbp

	ret

JPSDR_HDRTools_Convert_PackedXYZ_16_SSE41 endp


;JPSDR_HDRTools_Convert_PackedXYZ_16_AVX proc src:dword,dst:dword,w:dword,h:dword,lookup:dword,
;	src_modulo:dword,dst_modulo:dword
; src = rcx
; dst = rdx
; w = r8d
; h = r9d

JPSDR_HDRTools_Convert_PackedXYZ_16_AVX proc public frame

lookup equ qword ptr[rbp+48]
src_modulo equ qword ptr[rbp+56]
dst_modulo equ qword ptr[rbp+64]

	push rbp
	.pushreg rbp
	mov rbp,rsp
	push rdi
	.pushreg rdi
	push rsi
	.pushreg rsi
	push rbx
	.pushreg rbx
	push r12
	.pushreg r12
	push r13
	.pushreg r13
	push r14
	.pushreg r14
	push r15
	.pushreg r15
	.endprolog

	xor rax,rax
	mov rsi,rcx
	mov r10,lookup
	mov rdi,rdx				;rdi=dst
	mov r12,src_modulo
	mov r13,dst_modulo
	mov r14,16
	
	vpxor xmm0,xmm0,xmm0
	vpxor xmm1,xmm1,xmm1
	xor rdx,rdx
	xor rbx,rbx
	xor r15,r15
	
	mov r11d,r8d
	shr r11d,1				;r11d=w0
	
Convert_PackedXYZ_16_AVX_1:
	or r11d,r11d
	jz Convert_PackedXYZ_16_AVX_3
	
	mov ecx,r11d
Convert_PackedXYZ_16_AVX_2:
	movzx edx,word ptr[rsi]
	movzx r15d,word ptr[rsi+2]
	movzx ebx,word ptr[rsi+4] ; rbx=R/X r15=G/Y rdx=B/Z
	mov eax,dword ptr[r10+4*rbx]
	add eax,dword ptr[r10+4*r15+262144]
	add eax,dword ptr[r10+4*rdx+524288]
	vpinsrd xmm0,xmm0,eax,2
	mov eax,dword ptr[r10+4*rbx+786432]
	add eax,dword ptr[r10+4*r15+1048576]
	add eax,dword ptr[r10+4*rdx+1310720]
	vpinsrd xmm0,xmm0,eax,1
	mov eax,dword ptr[r10+4*rbx+1572864]
	add eax,dword ptr[r10+4*r15+1835008]
	add eax,dword ptr[r10+4*rdx+2097152]
	vpinsrd xmm0,xmm0,eax,0
	
	movzx edx,word ptr[rsi+8]
	movzx r15d,word ptr[rsi+10]
	movzx ebx,word ptr[rsi+12] ; rbx=R/X r15=G/Y rdx=B/Z
	mov eax,dword ptr[r10+4*rbx]
	add eax,dword ptr[r10+4*r15+262144]
	add eax,dword ptr[r10+4*rdx+524288]
	vpinsrd xmm1,xmm1,eax,2
	mov eax,dword ptr[r10+4*rbx+786432]
	add eax,dword ptr[r10+4*r15+1048576]
	add eax,dword ptr[r10+4*rdx+1310720]
	vpinsrd xmm1,xmm1,eax,1
	mov eax,dword ptr[r10+4*rbx+1572864]
	add eax,dword ptr[r10+4*r15+1835008]
	add eax,dword ptr[r10+4*rdx+2097152]
	vpinsrd xmm1,xmm1,eax,0

	vpsrad xmm0,xmm0,8
	vpsrad xmm1,xmm1,8
	vpackusdw xmm2,xmm0,xmm1
	
	vmovdqa XMMWORD ptr[rdi],xmm2
	
	add rsi,r14
	add rdi,r14

	dec ecx
	jnz Convert_PackedXYZ_16_AVX_2
	
Convert_PackedXYZ_16_AVX_3:
	test r8d,1
	jz short Convert_PackedXYZ_16_AVX_4
	
	movzx edx,word ptr[rsi]
	movzx r15d,word ptr[rsi+2]
	movzx ebx,word ptr[rsi+4] ; rbx=R/X r15=G/Y rdx=B/Z
	mov eax,dword ptr[r10+4*rbx]
	add eax,dword ptr[r10+4*r15+262144]
	add eax,dword ptr[r10+4*rdx+524288]
	vpinsrd xmm0,xmm0,eax,2
	mov eax,dword ptr[r10+4*rbx+786432]
	add eax,dword ptr[r10+4*r15+1048576]
	add eax,dword ptr[r10+4*rdx+1310720]
	vpinsrd xmm0,xmm0,eax,1
	mov eax,dword ptr[r10+4*rbx+1572864]
	add eax,dword ptr[r10+4*r15+1835008]
	add eax,dword ptr[r10+4*rdx+2097152]
	vpinsrd xmm0,xmm0,eax,0

	vpsrad xmm0,xmm0,8
	vpackusdw xmm2,xmm0,xmm0
	
	vmovq qword ptr[rdi],xmm2
	
	add rsi,8
	add rdi,8

Convert_PackedXYZ_16_AVX_4:	
	add rsi,r12
	add rdi,r13
	dec r9d
	jnz Convert_PackedXYZ_16_AVX_1

	pop r15
	pop r14
	pop r13
	pop r12
	pop rbx
	pop rsi
	pop rdi
	pop rbp

	ret

JPSDR_HDRTools_Convert_PackedXYZ_16_AVX endp


;JPSDR_HDRTools_Convert_PlanarRGBtoXYZ_32_SSE2 proc src1:dword,src2:dword,src3:dword,dst1:dword,dst2:dword,dst3:dword,
;	w:dword,h:dword,Coeff:dword,src_modulo1:dword,src_modulo2:dword,src_modulo3:dword,
;	dst_modulo1:dword,dst_modulo2:dword,dst_modulo3:dword,
; src1 = rcx
; src2 = rdx
; src3 = r8
; dst1 = r9

JPSDR_HDRTools_Convert_PlanarRGBtoXYZ_32_SSE2 proc public frame

dst2 equ qword ptr[rbp+48]
dst3 equ qword ptr[rbp+56]
w equ dword ptr[rbp+64]
h equ dword ptr[rbp+72]
Coeff equ qword ptr[rbp+80]
src_modulo1 equ qword ptr[rbp+88]
src_modulo2 equ qword ptr[rbp+96]
src_modulo3 equ qword ptr[rbp+104]
dst_modulo1 equ qword ptr[rbp+112]
dst_modulo2 equ qword ptr[rbp+120]
dst_modulo3 equ qword ptr[rbp+128]

	push rbp
	.pushreg rbp
	mov rbp,rsp
	push rdi
	.pushreg rdi
	push rsi
	.pushreg rsi
	push rbx
	.pushreg rbx
	push r12
	.pushreg r12
	push r13
	.pushreg r13
	push r14
	.pushreg r14
	push r15
	.pushreg r15
	.endprolog

	mov rsi,Coeff
	movaps xmm0,XMMWORD ptr[rsi]
	movaps xmm1,XMMWORD ptr[rsi+32]
	movaps xmm2,XMMWORD ptr[rsi+64]
	
	mov rsi,rcx
	mov r10,dst2
	mov rdi,dst3
	mov r11,src_modulo1
	mov r12,src_modulo2
	mov r13,src_modulo3
	mov r14,dst_modulo1
	mov r15d,w
	mov rbx,4
	
Convert_PlanarRGBtoXYZ_32_SSE2_1:
	mov ecx,r15d
Convert_PlanarRGBtoXYZ_32_SSE2_2:
	movss xmm3,dword ptr[rsi]
	movss xmm4,dword ptr[rdx]
	movss xmm5,dword ptr[r8]
	
	shufps xmm3,xmm3,0
	shufps xmm4,xmm4,0
	shufps xmm5,xmm5,0
	
	mulps xmm3,xmm0
	mulps xmm4,xmm1
	mulps xmm5,xmm2
	
	addps xmm3,xmm4
	add rsi,rbx
	addps xmm3,xmm5	
	add rdx,rbx
	movhlps xmm4,xmm3
	
	movss dword ptr[r9],xmm3
	add r8,rbx
	shufps xmm3,xmm3,1
	movss dword ptr[rdi],xmm4
	movss dword ptr[r10],xmm3
	
	add r9,rbx
	add rdi,rbx
	add r10,rbx
	
	loop Convert_PlanarRGBtoXYZ_32_SSE2_2

	add rsi,r11
	add rdx,r12
	add r8,r13
	
	add r9,r14
	add r10,dst_modulo2
	add rdi,dst_modulo3
	
	dec h
	jnz short Convert_PlanarRGBtoXYZ_32_SSE2_1
	
	pop r15
	pop r14
	pop r13
	pop r12
	pop rbx
	pop rsi
	pop rdi
	pop rbp

	ret

JPSDR_HDRTools_Convert_PlanarRGBtoXYZ_32_SSE2 endp


;JPSDR_HDRTools_Convert_PlanarXYZtoRGB_32_SSE2 proc src1:dword,src2:dword,src3:dword,dst1:dword,dst2:dword,dst3:dword,
;	w:dword,h:dword,Coeff:dword,src_modulo1:dword,src_modulo2:dword,src_modulo3:dword,
;	dst_modulo1:dword,dst_modulo2:dword,dst_modulo3:dword,
; src1 = rcx
; src2 = rdx
; src3 = r8
; dst1 = r9

JPSDR_HDRTools_Convert_PlanarXYZtoRGB_32_SSE2 proc public frame

dst2 equ qword ptr[rbp+48]
dst3 equ qword ptr[rbp+56]
w equ dword ptr[rbp+64]
h equ dword ptr[rbp+72]
Coeff equ qword ptr[rbp+80]
src_modulo1 equ qword ptr[rbp+88]
src_modulo2 equ qword ptr[rbp+96]
src_modulo3 equ qword ptr[rbp+104]
dst_modulo1 equ qword ptr[rbp+112]
dst_modulo2 equ qword ptr[rbp+120]
dst_modulo3 equ qword ptr[rbp+128]

	push rbp
	.pushreg rbp
	mov rbp,rsp
	push rdi
	.pushreg rdi
	push rsi
	.pushreg rsi
	push rbx
	.pushreg rbx
	push r12
	.pushreg r12
	push r13
	.pushreg r13
	push r14
	.pushreg r14
	push r15
	.pushreg r15
	sub rsp,40
	.allocstack 40
	movdqa XMMWORD ptr[rsp],xmm6
	.savexmm128 xmm6,0
	movdqa XMMWORD ptr[rsp+16],xmm7
	.savexmm128 xmm7,16
	.endprolog

	mov rsi,Coeff
	movaps xmm0,XMMWORD ptr[rsi]
	movaps xmm1,XMMWORD ptr[rsi+32]
	movaps xmm2,XMMWORD ptr[rsi+64]
	movaps xmm6,XMMWORD ptr data_f_0
	movaps xmm7,XMMWORD ptr data_f_1
	
	mov rsi,rcx
	mov r10,dst2
	mov rdi,dst3
	mov r11,src_modulo1
	mov r12,src_modulo2
	mov r13,src_modulo3
	mov r14,dst_modulo1
	mov r15d,w
	mov rbx,4
	
Convert_PlanarXYZtoRGB_32_SSE2_1:
	mov ecx,r15d
Convert_PlanarXYZtoRGB_32_SSE2_2:
	movss xmm3,dword ptr[rsi]
	movss xmm4,dword ptr[rdx]
	movss xmm5,dword ptr[r8]
	
	shufps xmm3,xmm3,0
	shufps xmm4,xmm4,0
	shufps xmm5,xmm5,0
	
	mulps xmm3,xmm0
	mulps xmm4,xmm1
	mulps xmm5,xmm2
	
	addps xmm3,xmm4
	add rsi,rbx
	addps xmm3,xmm5
	maxps xmm3,xmm6
	minps xmm3,xmm7	
	add rdx,rbx
	movhlps xmm4,xmm3
	
	movss dword ptr[r9],xmm3
	add r8,rbx
	shufps xmm3,xmm3,1
	movss dword ptr[rdi],xmm4
	movss dword ptr[r10],xmm3
	
	add r9,rbx
	add rdi,rbx
	add r10,rbx
	
	loop Convert_PlanarXYZtoRGB_32_SSE2_2

	add rsi,r11
	add rdx,r12
	add r8,r13
	
	add r9,r14
	add r10,dst_modulo2
	add rdi,dst_modulo3
	
	dec h
	jnz short Convert_PlanarXYZtoRGB_32_SSE2_1
	
	movdqa xmm7,XMMWORD ptr[rsp+16]
	movdqa xmm6,XMMWORD ptr[rsp]
	add rsp,40
	
	pop r15
	pop r14
	pop r13
	pop r12
	pop rbx
	pop rsi
	pop rdi
	pop rbp

	ret

JPSDR_HDRTools_Convert_PlanarXYZtoRGB_32_SSE2 endp


;JPSDR_HDRTools_Convert_PlanarRGBtoXYZ_32_AVX proc src1:dword,src2:dword,src3:dword,dst1:dword,dst2:dword,dst3:dword,
;	w:dword,h:dword,Coeff:dword,src_modulo1:dword,src_modulo2:dword,src_modulo3:dword,
;	dst_modulo1:dword,dst_modulo2:dword,dst_modulo3:dword,
; src1 = rcx
; src2 = rdx
; src3 = r8
; dst1 = r9

JPSDR_HDRTools_Convert_PlanarRGBtoXYZ_32_AVX proc public frame

dst2 equ qword ptr[rbp+48]
dst3 equ qword ptr[rbp+56]
w equ dword ptr[rbp+64]
h equ dword ptr[rbp+72]
Coeff equ qword ptr[rbp+80]
src_modulo1 equ qword ptr[rbp+88]
src_modulo2 equ qword ptr[rbp+96]
src_modulo3 equ qword ptr[rbp+104]
dst_modulo1 equ qword ptr[rbp+112]
dst_modulo2 equ qword ptr[rbp+120]
dst_modulo3 equ qword ptr[rbp+128]

	push rbp
	.pushreg rbp
	mov rbp,rsp
	push rdi
	.pushreg rdi
	push rsi
	.pushreg rsi
	push rbx
	.pushreg rbx
	push r12
	.pushreg r12
	push r13
	.pushreg r13
	push r14
	.pushreg r14
	push r15
	.pushreg r15
	sub rsp,24
	.allocstack 24
	vmovdqa XMMWORD ptr[rsp],xmm6
	.savexmm128 xmm6,0
	.endprolog

	mov rsi,Coeff
	vmovaps ymm0,YMMWORD ptr[rsi]
	vmovaps ymm1,YMMWORD ptr[rsi+32]
	vmovaps ymm2,YMMWORD ptr[rsi+64]
	
	mov rsi,rcx
	mov r10,dst2
	mov rdi,dst3
	mov r11,src_modulo1
	mov r12,src_modulo2
	mov r13,src_modulo3
	mov r14,dst_modulo1
	mov r15d,w
	mov r14d,r15d
	shr r14d,1
	mov rbx,8
	
Convert_PlanarRGBtoXYZ_32_AVX_1:
	or r14d,r14d
	jz Convert_PlanarRGBtoXYZ_32_AVX_3
	
	mov ecx,r14d
Convert_PlanarRGBtoXYZ_32_AVX_2:
	vmovss xmm3,dword ptr[rsi]
	vmovss xmm6,dword ptr[rsi+4]
	vmovss xmm4,dword ptr[rdx]
	vinsertf128 ymm3,ymm3,xmm6,1
	vmovss xmm6,dword ptr[rdx+4]
	vmovss xmm5,dword ptr[r8]
	vinsertf128 ymm4,ymm4,xmm6,1
	vmovss xmm6,dword ptr[r8+4]
	
	vshufps ymm3,ymm3,ymm3,0
	vinsertf128 ymm5,ymm5,xmm6,1
	vshufps ymm4,ymm4,ymm4,0
	vshufps ymm5,ymm5,ymm5,0

	vmulps ymm3,ymm3,ymm0
	vmulps ymm4,ymm4,ymm1
	vmulps ymm5,ymm5,ymm2

	vaddps ymm3,ymm3,ymm4
	add rsi,rbx
	vaddps ymm3,ymm3,ymm5
	add rdx,rbx
	vextractf128 xmm6,ymm3,1

	vmovhlps xmm4,xmm4,xmm3
	vmovss dword ptr[r9],xmm3
	add r8,rbx
	vshufps xmm3,xmm3,xmm3,1
	vmovss dword ptr[rdi],xmm4
	vmovss dword ptr[r10],xmm3

	vmovhlps xmm4,xmm4,xmm6
	vmovss dword ptr[r9+4],xmm6
	vshufps xmm6,xmm6,xmm6,1
	vmovss dword ptr[rdi+4],xmm4
	vmovss dword ptr[r10+4],xmm6
	
	add r9,rbx
	add rdi,rbx
	add r10,rbx
	
	dec ecx
	jnz Convert_PlanarRGBtoXYZ_32_AVX_2

Convert_PlanarRGBtoXYZ_32_AVX_3:
	test r15d,1
	jz short Convert_PlanarRGBtoXYZ_32_AVX_4

	vbroadcastss xmm3,dword ptr[rsi]
	vbroadcastss xmm4,dword ptr[rdx]
	vbroadcastss xmm5,dword ptr[r8]
	
	vmulps xmm3,xmm3,xmm0
	vmulps xmm4,xmm4,xmm1
	vmulps xmm5,xmm5,xmm2
	
	vaddps xmm3,xmm3,xmm4
	add rsi,4
	vaddps xmm3,xmm3,xmm5	
	add rdx,4
	vmovhlps xmm4,xmm4,xmm3
	
	vmovss dword ptr[r9],xmm3
	add r8,4
	vshufps xmm3,xmm3,xmm3,1
	vmovss dword ptr[rdi],xmm4
	vmovss dword ptr[r10],xmm3
	
	add r9,4
	add rdi,4
	add r10,4
	
Convert_PlanarRGBtoXYZ_32_AVX_4:
	add rsi,r11
	add rdx,r12
	add r8,r13
	
	add r9,dst_modulo1
	add r10,dst_modulo2
	add rdi,dst_modulo3
	
	dec h
	jnz Convert_PlanarRGBtoXYZ_32_AVX_1
	
	vmovdqa xmm6,XMMWORD ptr[rsp]
	add rsp,24

	vzeroupper
	
	pop r15
	pop r14
	pop r13
	pop r12
	pop rbx
	pop rsi
	pop rdi
	pop rbp

	ret

JPSDR_HDRTools_Convert_PlanarRGBtoXYZ_32_AVX endp


;JPSDR_HDRTools_Convert_PlanarXYZtoRGB_32_AVX proc src1:dword,src2:dword,src3:dword,dst1:dword,dst2:dword,dst3:dword,
;	w:dword,h:dword,Coeff:dword,src_modulo1:dword,src_modulo2:dword,src_modulo3:dword,
;	dst_modulo1:dword,dst_modulo2:dword,dst_modulo3:dword,
; src1 = rcx
; src2 = rdx
; src3 = r8
; dst1 = r9

JPSDR_HDRTools_Convert_PlanarXYZtoRGB_32_AVX proc public frame

dst2 equ qword ptr[rbp+48]
dst3 equ qword ptr[rbp+56]
w equ dword ptr[rbp+64]
h equ dword ptr[rbp+72]
Coeff equ qword ptr[rbp+80]
src_modulo1 equ qword ptr[rbp+88]
src_modulo2 equ qword ptr[rbp+96]
src_modulo3 equ qword ptr[rbp+104]
dst_modulo1 equ qword ptr[rbp+112]
dst_modulo2 equ qword ptr[rbp+120]
dst_modulo3 equ qword ptr[rbp+128]

	push rbp
	.pushreg rbp
	mov rbp,rsp
	push rdi
	.pushreg rdi
	push rsi
	.pushreg rsi
	push rbx
	.pushreg rbx
	push r12
	.pushreg r12
	push r13
	.pushreg r13
	push r14
	.pushreg r14
	push r15
	.pushreg r15
	sub rsp,56
	.allocstack 56
	vmovdqa XMMWORD ptr[rsp],xmm6
	.savexmm128 xmm6,0
	vmovdqa XMMWORD ptr[rsp+16],xmm7
	.savexmm128 xmm7,16
	vmovdqa XMMWORD ptr[rsp+32],xmm8
	.savexmm128 xmm8,32
	.endprolog

	mov rsi,Coeff
	vmovaps ymm0,YMMWORD ptr[rsi]
	vmovaps ymm1,YMMWORD ptr[rsi+32]
	vmovaps ymm2,YMMWORD ptr[rsi+64]
	vmovaps ymm7,YMMWORD ptr data_f_1
	vmovaps ymm8,YMMWORD ptr data_f_0
	
	mov rsi,rcx
	mov r10,dst2
	mov rdi,dst3
	mov r11,src_modulo1
	mov r12,src_modulo2
	mov r13,src_modulo3
	mov r14,dst_modulo1
	mov r15d,w
	mov r14d,r15d
	shr r14d,1
	mov rbx,8
	
Convert_PlanarXYZtoRGB_32_AVX_1:
	or r14d,r14d
	jz Convert_PlanarXYZtoRGB_32_AVX_3
	
	mov ecx,r14d
Convert_PlanarXYZtoRGB_32_AVX_2:
	vmovss xmm3,dword ptr[rsi]
	vmovss xmm6,dword ptr[rsi+4]
	vmovss xmm4,dword ptr[rdx]
	vinsertf128 ymm3,ymm3,xmm6,1
	vmovss xmm6,dword ptr[rdx+4]
	vmovss xmm5,dword ptr[r8]
	vinsertf128 ymm4,ymm4,xmm6,1
	vmovss xmm6,dword ptr[r8+4]
	
	vshufps ymm3,ymm3,ymm3,0
	vinsertf128 ymm5,ymm5,xmm6,1
	vshufps ymm4,ymm4,ymm4,0
	vshufps ymm5,ymm5,ymm5,0

	vmulps ymm3,ymm3,ymm0
	vmulps ymm4,ymm4,ymm1
	vmulps ymm5,ymm5,ymm2

	vaddps ymm3,ymm3,ymm4
	add rsi,rbx
	vaddps ymm3,ymm3,ymm5
	vmaxps ymm3,ymm3,ymm8
	vminps ymm3,ymm3,ymm7
	add rdx,rbx
	vextractf128 xmm6,ymm3,1

	vmovhlps xmm4,xmm4,xmm3
	vmovss dword ptr[r9],xmm3
	add r8,rbx
	vshufps xmm3,xmm3,xmm3,1
	vmovss dword ptr[rdi],xmm4
	vmovss dword ptr[r10],xmm3

	vmovhlps xmm4,xmm4,xmm6
	vmovss dword ptr[r9+4],xmm6
	vshufps xmm6,xmm6,xmm6,1
	vmovss dword ptr[rdi+4],xmm4
	vmovss dword ptr[r10+4],xmm6
	
	add r9,rbx
	add rdi,rbx
	add r10,rbx
	
	dec ecx
	jnz Convert_PlanarXYZtoRGB_32_AVX_2

Convert_PlanarXYZtoRGB_32_AVX_3:
	test r15d,1
	jz short Convert_PlanarXYZtoRGB_32_AVX_4

	vbroadcastss xmm3,dword ptr[rsi]
	vbroadcastss xmm4,dword ptr[rdx]
	vbroadcastss xmm5,dword ptr[r8]
	
	vmulps xmm3,xmm3,xmm0
	vmulps xmm4,xmm4,xmm1
	vmulps xmm5,xmm5,xmm2
	
	vaddps xmm3,xmm3,xmm4
	add rsi,4
	vaddps xmm3,xmm3,xmm5
	vmaxps xmm3,xmm3,xmm8
	vminps xmm3,xmm3,xmm7		
	add rdx,4
	vmovhlps xmm4,xmm4,xmm3
	
	vmovss dword ptr[r9],xmm3
	add r8,4
	vshufps xmm3,xmm3,xmm3,1
	vmovss dword ptr[rdi],xmm4
	vmovss dword ptr[r10],xmm3
	
	add r9,4
	add rdi,4
	add r10,4
	
Convert_PlanarXYZtoRGB_32_AVX_4:
	add rsi,r11
	add rdx,r12
	add r8,r13
	
	add r9,dst_modulo1
	add r10,dst_modulo2
	add rdi,dst_modulo3
	
	dec h
	jnz Convert_PlanarXYZtoRGB_32_AVX_1
	
	vmovdqa xmm8,XMMWORD ptr[rsp+32]
	vmovdqa xmm7,XMMWORD ptr[rsp+16]
	vmovdqa xmm6,XMMWORD ptr[rsp]
	add rsp,56

	vzeroupper
	
	pop r15
	pop r14
	pop r13
	pop r12
	pop rbx
	pop rsi
	pop rdi
	pop rbp

	ret

JPSDR_HDRTools_Convert_PlanarXYZtoRGB_32_AVX endp


;***************************************************
;**               HLG functions                   **
;***************************************************


;JPSDR_HDRTools_Convert_RGB64toRGB32_SSE2 proc src:dword,dst:dword,w:dword,h:dword,src_pitch:dword,dst_pitch:dword
; src = rcx
; dst = rdx
; w = r8d
; h = r9d

JPSDR_HDRTools_Convert_RGB64toRGB32_SSE2 proc public frame

src_pitch equ qword ptr[rbp+48]
dst_pitch equ qword ptr[rbp+56]

	push rbp
	.pushreg rbp
	mov rbp,rsp
	push rdi
	.pushreg rdi
	push rsi
	.pushreg rsi
	push rbx
	.pushreg rbx
	push r12
	.pushreg r12
	push r13
	.pushreg r13
	push r14
	.pushreg r14
	.endprolog

	mov rsi,rcx
	mov rdi,rdx
	mov r10,src_pitch
	mov r11,dst_pitch
	
	mov ebx,r8d
	shr ebx,2
	
	movdqa xmm2,XMMWORD ptr data_w_128
	movdqa xmm3,XMMWORD ptr data_dw_RGB32
	
	mov rdx,16
	mov r12,8
	mov r13,2
	mov r14,1
	
	
Convert_RGB64toRGB32_SSE2_1:
	mov ecx,ebx
	xor rax,rax	
	or ecx,ecx
	jz short Convert_RGB64toRGB32_SSE2_3
	
Convert_RGB64toRGB32_SSE2_2:
	movdqa xmm0,XMMWORD ptr[rsi+2*rax]
	movdqa xmm1,XMMWORD ptr[rsi+2*rax+16]
	paddusw xmm0,xmm2
	paddusw xmm1,xmm2
	psrlw xmm0,8
	psrlw xmm1,8
	packuswb xmm0,xmm1
	pand xmm0,xmm3
	movdqa XMMWORD ptr[rdi+rax],xmm0
	add rax,rdx
	loop Convert_RGB64toRGB32_SSE2_2
	
Convert_RGB64toRGB32_SSE2_3:
	test r8d,r13d
	jz short Convert_RGB64toRGB32_SSE2_4
	
	movdqa xmm0,XMMWORD ptr[rsi+2*rax]
	paddusw xmm0,xmm2
	psrlw xmm0,8
	packuswb xmm0,xmm0
	pand xmm0,xmm3
	movq qword ptr[rdi+rax],xmm0
	add rax,r12
	
Convert_RGB64toRGB32_SSE2_4:
	test r8d,r14d
	jz short Convert_RGB64toRGB32_SSE2_5

	movq xmm0,qword ptr[rsi+2*rax]
	paddusw xmm0,xmm2
	psrlw xmm0,8
	packuswb xmm0,xmm0
	pand xmm0,xmm3
	movd dword ptr[rdi+rax],xmm0
	
Convert_RGB64toRGB32_SSE2_5:
	add rsi,r10
	add rdi,r11
	dec r9d
	jnz Convert_RGB64toRGB32_SSE2_1
	
	pop r14
	pop r13
	pop r12
	pop rbx
	pop rsi
	pop rdi
	pop rbp

	ret

JPSDR_HDRTools_Convert_RGB64toRGB32_SSE2 endp


;JPSDR_HDRTools_Convert_RGB64toRGB32_AVX proc src:dword,dst:dword,w:dword,h:dword,src_pitch:dword,dst_pitch:dword
; src = rcx
; dst = rdx
; w = r8d
; h = r9d

JPSDR_HDRTools_Convert_RGB64toRGB32_AVX proc public frame

src_pitch equ qword ptr[rbp+48]
dst_pitch equ qword ptr[rbp+56]

	push rbp
	.pushreg rbp
	mov rbp,rsp
	push rdi
	.pushreg rdi
	push rsi
	.pushreg rsi
	push rbx
	.pushreg rbx
	push r12
	.pushreg r12
	push r13
	.pushreg r13
	push r14
	.pushreg r14
	.endprolog

	mov rsi,rcx
	mov rdi,rdx
	mov r10,src_pitch
	mov r11,dst_pitch
	
	mov ebx,r8d
	shr ebx,2
	
	vmovdqa xmm2,XMMWORD ptr data_w_128
	vmovdqa xmm3,XMMWORD ptr data_dw_RGB32
	
	mov rdx,16
	mov r12,8
	mov r13,2
	mov r14,1
	
	
Convert_RGB64toRGB32_AVX_1:
	mov ecx,ebx
	xor rax,rax	
	or ecx,ecx
	jz short Convert_RGB64toRGB32_AVX_3
	
Convert_RGB64toRGB32_AVX_2:
	vpaddusw xmm0,xmm2,XMMWORD ptr[rsi+2*rax]
	vpaddusw xmm1,xmm2,XMMWORD ptr[rsi+2*rax+16]
	vpsrlw xmm0,xmm0,8
	vpsrlw xmm1,xmm1,8
	vpackuswb xmm0,xmm0,xmm1
	vpand xmm0,xmm0,xmm3
	vmovdqa XMMWORD ptr[rdi+rax],xmm0
	add rax,rdx
	loop Convert_RGB64toRGB32_AVX_2
	
Convert_RGB64toRGB32_AVX_3:
	test r8d,r13d
	jz short Convert_RGB64toRGB32_AVX_4
	
	vpaddusw xmm0,xmm2,XMMWORD ptr[rsi+2*rax]
	vpsrlw xmm0,xmm0,8
	vpackuswb xmm0,xmm0,xmm0
	vpand xmm0,xmm0,xmm3
	vmovq qword ptr[rdi+rax],xmm0
	add rax,r12
	
Convert_RGB64toRGB32_AVX_4:
	test r8d,r14d
	jz short Convert_RGB64toRGB32_AVX_5

	vmovq xmm0,qword ptr[rsi+2*rax]
	vpaddusw xmm0,xmm0,xmm2
	vpsrlw xmm0,xmm0,8
	vpackuswb xmm0,xmm0,xmm0
	vpand xmm0,xmm0,xmm3
	vmovd dword ptr[rdi+rax],xmm0
	
Convert_RGB64toRGB32_AVX_5:
	add rsi,r10
	add rdi,r11
	dec r9d
	jnz short Convert_RGB64toRGB32_AVX_1
	
	pop r14
	pop r13
	pop r12
	pop rbx
	pop rsi
	pop rdi
	pop rbp

	ret

JPSDR_HDRTools_Convert_RGB64toRGB32_AVX endp


;JPSDR_HDRTools_Convert_RGB32toPlaneY16_SSE2 proc src:dword,dst:dword,w:dword,h:dword,
;	lookup:dword,src_modulo:dword,dst_modulo:dword
; src = rcx
; dst = rdx
; w = r8d
; h = r9d

JPSDR_HDRTools_Convert_RGB32toPlaneY16_SSE2 proc public frame

lookup equ qword ptr[rbp+48]
src_modulo equ qword ptr[rbp+56]
dst_modulo equ qword ptr[rbp+64]

	push rbp
	.pushreg rbp
	mov rbp,rsp
	push rdi
	.pushreg rdi
	push rsi
	.pushreg rsi
	push rbx
	.pushreg rbx
	push r12
	.pushreg r12
	push r13
	.pushreg r13
	push r14
	.pushreg r14
	push r15
	.pushreg r15
	.endprolog

	pxor xmm1,xmm1
	pxor xmm0,xmm0

	mov rsi,rcx
	mov rdi,rdx
	mov r14,lookup
	mov r10,src_modulo
	mov r11,dst_modulo
	mov r12,32
	mov r15,16
	xor rax,rax

Convert_RGB32toPlaneY16_SSE2_1:
	mov r13d,r8d
	shr r13d,3
	jz Convert_RGB32toPlaneY16_SSE2_3
	
Convert_RGB32toPlaneY16_SSE2_2:
	movzx rdx,byte ptr[rsi]
	movzx rcx,byte ptr[rsi+1]
	movzx rbx,byte ptr[rsi+2] ; ebx=R ecx=G edx=B
	movzx eax,word ptr[r14+2*rbx]
	add ax,word ptr[r14+2*rcx+512]
	add ax,word ptr[r14+2*rdx+1024]
	pinsrw xmm0,eax,0
	movzx rdx,byte ptr[rsi+4]
	movzx rcx,byte ptr[rsi+5]
	movzx rbx,byte ptr[rsi+6] ; ebx=R ecx=G edx=B
	movzx eax,word ptr[r14+2*rbx]
	add ax,word ptr[r14+2*rcx+512]
	add ax,word ptr[r14+2*rdx+1024]
	pinsrw xmm0,eax,1
	movzx rdx,byte ptr[rsi+8]
	movzx rcx,byte ptr[rsi+9]
	movzx rbx,byte ptr[rsi+10] ; ebx=R ecx=G edx=B
	movzx eax,word ptr[r14+2*rbx]
	add ax,word ptr[r14+2*rcx+512]
	add ax,word ptr[r14+2*rdx+1024]
	pinsrw xmm0,eax,2
	movzx rdx,byte ptr[rsi+12]
	movzx rcx,byte ptr[rsi+13]
	movzx rbx,byte ptr[rsi+14] ; ebx=R ecx=G edx=B
	movzx eax,word ptr[r14+2*rbx]
	add ax,word ptr[r14+2*rcx+512]
	add ax,word ptr[r14+2*rdx+1024]
	pinsrw xmm0,eax,3
	movzx rdx,byte ptr[rsi+16]
	movzx rcx,byte ptr[rsi+17]
	movzx rbx,byte ptr[rsi+18] ; ebx=R ecx=G edx=B
	movzx eax,word ptr[r14+2*rbx]
	add ax,word ptr[r14+2*rcx+512]
	add ax,word ptr[r14+2*rdx+1024]
	pinsrw xmm0,eax,4
	movzx rdx,byte ptr[rsi+20]
	movzx rcx,byte ptr[rsi+21]
	movzx rbx,byte ptr[rsi+22] ; ebx=R ecx=G edx=B
	movzx eax,word ptr[r14+2*rbx]
	add ax,word ptr[r14+2*rcx+512]
	add ax,word ptr[r14+2*rdx+1024]
	pinsrw xmm0,eax,5
	movzx rdx,byte ptr[rsi+24]
	movzx rcx,byte ptr[rsi+25]
	movzx rbx,byte ptr[rsi+26] ; ebx=R ecx=G edx=B
	movzx eax,word ptr[r14+2*rbx]
	add ax,word ptr[r14+2*rcx+512]
	add ax,word ptr[r14+2*rdx+1024]
	pinsrw xmm0,eax,6
	movzx rdx,byte ptr[rsi+28]
	movzx rcx,byte ptr[rsi+29]
	movzx rbx,byte ptr[rsi+30] ; ebx=R ecx=G edx=B
	movzx eax,word ptr[r14+2*rbx]
	add ax,word ptr[r14+2*rcx+512]
	add ax,word ptr[r14+2*rdx+1024]
	pinsrw xmm0,eax,7
	
	psraw xmm0,6
	movdqa xmm2,xmm1
	packuswb xmm0,xmm1
	punpcklbw xmm2,xmm0
	
	movdqa XMMWORD ptr[rdi],xmm2

	add rsi,r12
	add rdi,r15
	
	dec r13d
	jnz Convert_RGB32toPlaneY16_SSE2_2
	
Convert_RGB32toPlaneY16_SSE2_3:	
	test r8d,4
	jz Convert_RGB32toPlaneY16_SSE2_4
	
	movzx rdx,byte ptr[rsi]
	movzx rcx,byte ptr[rsi+1]
	movzx rbx,byte ptr[rsi+2] ; ebx=R ecx=G edx=B
	movzx eax,word ptr[r14+2*rbx]
	add ax,word ptr[r14+2*rcx+512]
	add ax,word ptr[r14+2*rdx+1024]
	pinsrw xmm0,eax,0
	movzx rdx,byte ptr[rsi+4]
	movzx rcx,byte ptr[rsi+5]
	movzx rbx,byte ptr[rsi+6] ; ebx=R ecx=G edx=B
	movzx eax,word ptr[r14+2*rbx]
	add ax,word ptr[r14+2*rcx+512]
	add ax,word ptr[r14+2*rdx+1024]
	pinsrw xmm0,eax,1
	movzx rdx,byte ptr[rsi+8]
	movzx rcx,byte ptr[rsi+9]
	movzx rbx,byte ptr[rsi+10] ; ebx=R ecx=G edx=B
	movzx eax,word ptr[r14+2*rbx]
	add ax,word ptr[r14+2*rcx+512]
	add ax,word ptr[r14+2*rdx+1024]
	pinsrw xmm0,eax,2
	movzx rdx,byte ptr[rsi+12]
	movzx rcx,byte ptr[rsi+13]
	movzx rbx,byte ptr[rsi+14] ; ebx=R ecx=G edx=B
	movzx eax,word ptr[r14+2*rbx]
	add ax,word ptr[r14+2*rcx+512]
	add ax,word ptr[r14+2*rdx+1024]
	pinsrw xmm0,eax,3	
	
	psraw xmm0,6
	movdqa xmm2,xmm1
	packuswb xmm0,xmm1
	punpcklbw xmm2,xmm0
	
	movq qword ptr[rdi],xmm2

	add rsi,r15
	add rdi,8
	
Convert_RGB32toPlaneY16_SSE2_4:
	test r8d,2
	jz short Convert_RGB32toPlaneY16_SSE2_5

	movzx rdx,byte ptr[rsi]
	movzx rcx,byte ptr[rsi+1]
	movzx rbx,byte ptr[rsi+2] ; ebx=R ecx=G edx=B
	movzx eax,word ptr[r14+2*rbx]
	add ax,word ptr[r14+2*rcx+512]
	add ax,word ptr[r14+2*rdx+1024]
	pinsrw xmm0,eax,0
	movzx rdx,byte ptr[rsi+4]
	movzx rcx,byte ptr[rsi+5]
	movzx rbx,byte ptr[rsi+6] ; ebx=R ecx=G edx=B
	movzx eax,word ptr[r14+2*rbx]
	add ax,word ptr[r14+2*rcx+512]
	add ax,word ptr[r14+2*rdx+1024]
	pinsrw xmm0,eax,1
	
	psraw xmm0,6
	movdqa xmm2,xmm1
	packuswb xmm0,xmm1
	punpcklbw xmm2,xmm0
	
	movd dword ptr[rdi],xmm2
	
	add rsi,8
	add rdi,4
	
Convert_RGB32toPlaneY16_SSE2_5:
	test r8d,1
	jz short Convert_RGB32toPlaneY16_SSE2_6

	movzx rdx,byte ptr[rsi]
	movzx rcx,byte ptr[rsi+1]
	movzx rbx,byte ptr[rsi+2] ; ebx=R ecx=G edx=B
	movzx eax,word ptr[r14+2*rbx]
	add ax,word ptr[r14+2*rcx+512]
	add ax,word ptr[r14+2*rdx+1024]
	pinsrw xmm0,eax,0
	
	psraw xmm0,6
	movdqa xmm2,xmm1
	packuswb xmm0,xmm1
	punpcklbw xmm2,xmm0
	
	pextrw eax,xmm2,0
	mov word ptr[rdi],ax

	add rsi,4
	add rdi,2

Convert_RGB32toPlaneY16_SSE2_6:	
	add rsi,r10
	add rdi,r11
	dec r9d
	jnz Convert_RGB32toPlaneY16_SSE2_1

	pop r15
	pop r14
	pop r13
	pop r12
	pop rbx
	pop rsi
	pop rdi
	pop rbp

	ret

JPSDR_HDRTools_Convert_RGB32toPlaneY16_SSE2 endp


;JPSDR_HDRTools_Convert_RGB32toPlaneY16_AVX proc src:dword,dst:dword,w:dword,h:dword,
;	lookup:dword,src_modulo:dword,dst_modulo:dword
; src = rcx
; dst = rdx
; w = r8d
; h = r9d

JPSDR_HDRTools_Convert_RGB32toPlaneY16_AVX proc public frame

lookup equ qword ptr[rbp+48]
src_modulo equ qword ptr[rbp+56]
dst_modulo equ qword ptr[rbp+64]

	push rbp
	.pushreg rbp
	mov rbp,rsp
	push rdi
	.pushreg rdi
	push rsi
	.pushreg rsi
	push rbx
	.pushreg rbx
	push r12
	.pushreg r12
	push r13
	.pushreg r13
	push r14
	.pushreg r14
	push r15
	.pushreg r15
	.endprolog

	vpxor xmm1,xmm1,xmm1
	vpxor xmm0,xmm0,xmm0

	mov rsi,rcx
	mov rdi,rdx
	mov r14,lookup
	mov r10,src_modulo
	mov r11,dst_modulo
	mov r12,32
	mov r15,16
	xor rax,rax

Convert_RGB32toPlaneY16_AVX_1:
	mov r13d,r8d
	shr r13d,3
	jz Convert_RGB32toPlaneY16_AVX_3
	
Convert_RGB32toPlaneY16_AVX_2:
	movzx rdx,byte ptr[rsi]
	movzx rcx,byte ptr[rsi+1]
	movzx rbx,byte ptr[rsi+2] ; ebx=R ecx=G edx=B
	movzx eax,word ptr[r14+2*rbx]
	add ax,word ptr[r14+2*rcx+512]
	add ax,word ptr[r14+2*rdx+1024]
	vpinsrw xmm0,xmm0,eax,0
	movzx rdx,byte ptr[rsi+4]
	movzx rcx,byte ptr[rsi+5]
	movzx rbx,byte ptr[rsi+6] ; ebx=R ecx=G edx=B
	movzx eax,word ptr[r14+2*rbx]
	add ax,word ptr[r14+2*rcx+512]
	add ax,word ptr[r14+2*rdx+1024]
	vpinsrw xmm0,xmm0,eax,1
	movzx rdx,byte ptr[rsi+8]
	movzx rcx,byte ptr[rsi+9]
	movzx rbx,byte ptr[rsi+10] ; ebx=R ecx=G edx=B
	movzx eax,word ptr[r14+2*rbx]
	add ax,word ptr[r14+2*rcx+512]
	add ax,word ptr[r14+2*rdx+1024]
	vpinsrw xmm0,xmm0,eax,2
	movzx rdx,byte ptr[rsi+12]
	movzx rcx,byte ptr[rsi+13]
	movzx rbx,byte ptr[rsi+14] ; ebx=R ecx=G edx=B
	movzx eax,word ptr[r14+2*rbx]
	add ax,word ptr[r14+2*rcx+512]
	add ax,word ptr[r14+2*rdx+1024]
	vpinsrw xmm0,xmm0,eax,3
	movzx rdx,byte ptr[rsi+16]
	movzx rcx,byte ptr[rsi+17]
	movzx rbx,byte ptr[rsi+18] ; ebx=R ecx=G edx=B
	movzx eax,word ptr[r14+2*rbx]
	add ax,word ptr[r14+2*rcx+512]
	add ax,word ptr[r14+2*rdx+1024]
	vpinsrw xmm0,xmm0,eax,4
	movzx rdx,byte ptr[rsi+20]
	movzx rcx,byte ptr[rsi+21]
	movzx rbx,byte ptr[rsi+22] ; ebx=R ecx=G edx=B
	movzx eax,word ptr[r14+2*rbx]
	add ax,word ptr[r14+2*rcx+512]
	add ax,word ptr[r14+2*rdx+1024]
	vpinsrw xmm0,xmm0,eax,5
	movzx rdx,byte ptr[rsi+24]
	movzx rcx,byte ptr[rsi+25]
	movzx rbx,byte ptr[rsi+26] ; ebx=R ecx=G edx=B
	movzx eax,word ptr[r14+2*rbx]
	add ax,word ptr[r14+2*rcx+512]
	add ax,word ptr[r14+2*rdx+1024]
	vpinsrw xmm0,xmm0,eax,6
	movzx rdx,byte ptr[rsi+28]
	movzx rcx,byte ptr[rsi+29]
	movzx rbx,byte ptr[rsi+30] ; ebx=R ecx=G edx=B
	movzx eax,word ptr[r14+2*rbx]
	add ax,word ptr[r14+2*rcx+512]
	add ax,word ptr[r14+2*rdx+1024]
	vpinsrw xmm0,xmm0,eax,7
	
	vpsraw xmm0,xmm0,6
	vpackuswb xmm0,xmm0,xmm1
	vpunpcklbw xmm0,xmm1,xmm0
	
	vmovdqa XMMWORD ptr[rdi],xmm0

	add rsi,r12
	add rdi,r15
	
	dec r13d
	jnz Convert_RGB32toPlaneY16_AVX_2
	
Convert_RGB32toPlaneY16_AVX_3:	
	test r8d,4
	jz Convert_RGB32toPlaneY16_AVX_4
	
	movzx rdx,byte ptr[rsi]
	movzx rcx,byte ptr[rsi+1]
	movzx rbx,byte ptr[rsi+2] ; ebx=R ecx=G edx=B
	movzx eax,word ptr[r14+2*rbx]
	add ax,word ptr[r14+2*rcx+512]
	add ax,word ptr[r14+2*rdx+1024]
	vpinsrw xmm0,xmm0,eax,0
	movzx rdx,byte ptr[rsi+4]
	movzx rcx,byte ptr[rsi+5]
	movzx rbx,byte ptr[rsi+6] ; ebx=R ecx=G edx=B
	movzx eax,word ptr[r14+2*rbx]
	add ax,word ptr[r14+2*rcx+512]
	add ax,word ptr[r14+2*rdx+1024]
	vpinsrw xmm0,xmm0,eax,1
	movzx rdx,byte ptr[rsi+8]
	movzx rcx,byte ptr[rsi+9]
	movzx rbx,byte ptr[rsi+10] ; ebx=R ecx=G edx=B
	movzx eax,word ptr[r14+2*rbx]
	add ax,word ptr[r14+2*rcx+512]
	add ax,word ptr[r14+2*rdx+1024]
	vpinsrw xmm0,xmm0,eax,2
	movzx rdx,byte ptr[rsi+12]
	movzx rcx,byte ptr[rsi+13]
	movzx rbx,byte ptr[rsi+14] ; ebx=R ecx=G edx=B
	movzx eax,word ptr[r14+2*rbx]
	add ax,word ptr[r14+2*rcx+512]
	add ax,word ptr[r14+2*rdx+1024]
	vpinsrw xmm0,xmm0,eax,3	
	
	vpsraw xmm0,xmm0,6
	vpackuswb xmm0,xmm0,xmm1
	vpunpcklbw xmm0,xmm1,xmm0
	
	vmovq qword ptr[rdi],xmm0

	add rsi,r15
	add rdi,8
	
Convert_RGB32toPlaneY16_AVX_4:
	test r8d,2
	jz short Convert_RGB32toPlaneY16_AVX_5

	movzx rdx,byte ptr[rsi]
	movzx rcx,byte ptr[rsi+1]
	movzx rbx,byte ptr[rsi+2] ; ebx=R ecx=G edx=B
	movzx eax,word ptr[r14+2*rbx]
	add ax,word ptr[r14+2*rcx+512]
	add ax,word ptr[r14+2*rdx+1024]
	vpinsrw xmm0,xmm0,eax,0
	movzx rdx,byte ptr[rsi+4]
	movzx rcx,byte ptr[rsi+5]
	movzx rbx,byte ptr[rsi+6] ; ebx=R ecx=G edx=B
	movzx eax,word ptr[r14+2*rbx]
	add ax,word ptr[r14+2*rcx+512]
	add ax,word ptr[r14+2*rdx+1024]
	vpinsrw xmm0,xmm0,eax,1
	
	vpsraw xmm0,xmm0,6
	vpackuswb xmm0,xmm0,xmm1
	vpunpcklbw xmm0,xmm1,xmm0
	
	vmovd dword ptr[rdi],xmm0
	
	add rsi,8
	add rdi,4
	
Convert_RGB32toPlaneY16_AVX_5:
	test r8d,1
	jz short Convert_RGB32toPlaneY16_AVX_6

	movzx rdx,byte ptr[rsi]
	movzx rcx,byte ptr[rsi+1]
	movzx rbx,byte ptr[rsi+2] ; ebx=R ecx=G edx=B
	movzx eax,word ptr[r14+2*rbx]
	add ax,word ptr[r14+2*rcx+512]
	add ax,word ptr[r14+2*rdx+1024]
	vpinsrw xmm0,xmm0,eax,0

	vpsraw xmm0,xmm0,6
	vpackuswb xmm0,xmm0,xmm1
	vpunpcklbw xmm0,xmm1,xmm0
	
	vpextrw eax,xmm0,0
	mov word ptr[rdi],ax

	add rsi,4
	add rdi,2

Convert_RGB32toPlaneY16_AVX_6:	
	add rsi,r10
	add rdi,r11
	dec r9d
	jnz Convert_RGB32toPlaneY16_AVX_1

	pop r15
	pop r14
	pop r13
	pop r12
	pop rbx
	pop rsi
	pop rdi
	pop rbp

	ret

JPSDR_HDRTools_Convert_RGB32toPlaneY16_AVX endp


;JPSDR_HDRTools_Convert_RGB64toPlaneY16_SSE41 proc src:dword,dst:dword,w:dword,h:dword,
;	lookup:dword,src_modulo:dword,dst_modulo:dword
; src = rcx
; dst = rdx
; w = r8d
; h = r9d

JPSDR_HDRTools_Convert_RGB64toPlaneY16_SSE41 proc public frame

lookup equ qword ptr[rbp+48]
src_modulo equ qword ptr[rbp+56]
dst_modulo equ qword ptr[rbp+64]

	push rbp
	.pushreg rbp
	mov rbp,rsp
	push rdi
	.pushreg rdi
	push rsi
	.pushreg rsi
	push rbx
	.pushreg rbx
	push r12
	.pushreg r12
	push r13
	.pushreg r13
	push r14
	.pushreg r14
	push r15
	.pushreg r15
	.endprolog

	pxor xmm1,xmm1
	pxor xmm0,xmm0
	movdqa xmm2,XMMWORD ptr data_HLG_8
	movdqa xmm3,XMMWORD ptr data_dw_128

	mov rsi,rcx
	mov rdi,rdx
	mov r14,lookup
	mov r10,src_modulo
	mov r11,dst_modulo
	mov r12,64
	mov r15,16
	xor rax,rax

Convert_RGB64toPlaneY16_SSE41_1:
	mov r13d,r8d
	shr r13d,3
	jz Convert_RGB64toPlaneY16_SSE41_3
	
Convert_RGB64toPlaneY16_SSE41_2:
	movzx rdx,word ptr[rsi]
	movzx rcx,word ptr[rsi+2]
	movzx rbx,word ptr[rsi+4] ; ebx=R ecx=G edx=B
	mov eax,dword ptr[r14+4*rbx]
	add eax,dword ptr[r14+4*rcx+262144]
	add eax,dword ptr[r14+4*rdx+524288]
	pinsrd xmm0,eax,0
	movzx rdx,word ptr[rsi+8]
	movzx rcx,word ptr[rsi+10]
	movzx rbx,word ptr[rsi+12] ; ebx=R ecx=G edx=B
	mov eax,dword ptr[r14+4*rbx]
	add eax,dword ptr[r14+4*rcx+262144]
	add eax,dword ptr[r14+4*rdx+524288]
	pinsrd xmm0,eax,1
	movzx rdx,word ptr[rsi+16]
	movzx rcx,word ptr[rsi+18]
	movzx rbx,word ptr[rsi+20] ; ebx=R ecx=G edx=B
	mov eax,dword ptr[r14+4*rbx]
	add eax,dword ptr[r14+4*rcx+262144]
	add eax,dword ptr[r14+4*rdx+524288]
	pinsrd xmm0,eax,2	
	movzx rdx,word ptr[rsi+24]
	movzx rcx,word ptr[rsi+26]
	movzx rbx,word ptr[rsi+28] ; ebx=R ecx=G edx=B
	mov eax,dword ptr[r14+4*rbx]
	add eax,dword ptr[r14+4*rcx+262144]
	add eax,dword ptr[r14+4*rdx+524288]
	pinsrd xmm0,eax,3

	movzx rdx,word ptr[rsi+32]
	movzx rcx,word ptr[rsi+34]
	movzx rbx,word ptr[rsi+36] ; ebx=R ecx=G edx=B
	mov eax,dword ptr[r14+4*rbx]
	add eax,dword ptr[r14+4*rcx+262144]
	add eax,dword ptr[r14+4*rdx+524288]
	pinsrd xmm1,eax,0
	movzx rdx,word ptr[rsi+40]
	movzx rcx,word ptr[rsi+42]
	movzx rbx,word ptr[rsi+44] ; ebx=R ecx=G edx=B
	mov eax,dword ptr[r14+4*rbx]
	add eax,dword ptr[r14+4*rcx+262144]
	add eax,dword ptr[r14+4*rdx+524288]
	pinsrd xmm1,eax,1
	movzx rdx,word ptr[rsi+48]
	movzx rcx,word ptr[rsi+50]
	movzx rbx,word ptr[rsi+52] ; ebx=R ecx=G edx=B
	mov eax,dword ptr[r14+4*rbx]
	add eax,dword ptr[r14+4*rcx+262144]
	add eax,dword ptr[r14+4*rdx+524288]
	pinsrd xmm1,eax,2	
	movzx rdx,word ptr[rsi+56]
	movzx rcx,word ptr[rsi+58]
	movzx rbx,word ptr[rsi+60] ; ebx=R ecx=G edx=B
	mov eax,dword ptr[r14+4*rbx]
	add eax,dword ptr[r14+4*rcx+262144]
	add eax,dword ptr[r14+4*rdx+524288]
	pinsrd xmm1,eax,3
	
	psrad xmm0,8
	psrad xmm1,8
	paddd xmm0,xmm3
	paddd xmm1,xmm3
	packusdw xmm0,xmm1
	pand xmm0,xmm2
	
	movdqa XMMWORD ptr[rdi],xmm0

	add rsi,r12
	add rdi,r15
	
	dec r13d
	jnz Convert_RGB64toPlaneY16_SSE41_2
	
Convert_RGB64toPlaneY16_SSE41_3:
	test r8d,4
	jz Convert_RGB64toPlaneY16_SSE41_4

	movzx rdx,word ptr[rsi]
	movzx rcx,word ptr[rsi+2]
	movzx rbx,word ptr[rsi+4] ; ebx=R ecx=G edx=B
	mov eax,dword ptr[r14+4*rbx]
	add eax,dword ptr[r14+4*rcx+262144]
	add eax,dword ptr[r14+4*rdx+524288]
	pinsrd xmm0,eax,0
	movzx rdx,word ptr[rsi+8]
	movzx rcx,word ptr[rsi+10]
	movzx rbx,word ptr[rsi+12] ; ebx=R ecx=G edx=B
	mov eax,dword ptr[r14+4*rbx]
	add eax,dword ptr[r14+4*rcx+262144]
	add eax,dword ptr[r14+4*rdx+524288]
	pinsrd xmm0,eax,1
	movzx rdx,word ptr[rsi+16]
	movzx rcx,word ptr[rsi+18]
	movzx rbx,word ptr[rsi+20] ; ebx=R ecx=G edx=B
	mov eax,dword ptr[r14+4*rbx]
	add eax,dword ptr[r14+4*rcx+262144]
	add eax,dword ptr[r14+4*rdx+524288]
	pinsrd xmm0,eax,2	
	movzx rdx,word ptr[rsi+24]
	movzx rcx,word ptr[rsi+26]
	movzx rbx,word ptr[rsi+28] ; ebx=R ecx=G edx=B
	mov eax,dword ptr[r14+4*rbx]
	add eax,dword ptr[r14+4*rcx+262144]
	add eax,dword ptr[r14+4*rdx+524288]
	pinsrd xmm0,eax,3

	psrad xmm0,8
	paddd xmm0,xmm3
	packusdw xmm0,xmm0
	pand xmm0,xmm2
	
	movq qword ptr[rdi],xmm0

	add rsi,32
	add rdi,8
	
Convert_RGB64toPlaneY16_SSE41_4:	
	test r8d,2
	jz Convert_RGB64toPlaneY16_SSE41_5
	
	movzx rdx,word ptr[rsi]
	movzx rcx,word ptr[rsi+2]
	movzx rbx,word ptr[rsi+4] ; ebx=R ecx=G edx=B
	mov eax,dword ptr[r14+4*rbx]
	add eax,dword ptr[r14+4*rcx+262144]
	add eax,dword ptr[r14+4*rdx+524288]
	pinsrd xmm0,eax,0
	movzx rdx,word ptr[rsi+8]
	movzx rcx,word ptr[rsi+10]
	movzx rbx,word ptr[rsi+12] ; ebx=R ecx=G edx=B
	mov eax,dword ptr[r14+4*rbx]
	add eax,dword ptr[r14+4*rcx+262144]
	add eax,dword ptr[r14+4*rdx+524288]
	pinsrd xmm0,eax,1
	
	psrad xmm0,8
	paddd xmm0,xmm3
	packusdw xmm0,xmm0
	pand xmm0,xmm2
	
	movd dword ptr[rdi],xmm0

	add rsi,r15
	add rdi,4
	
Convert_RGB64toPlaneY16_SSE41_5:
	test r8d,1
	jz short Convert_RGB64toPlaneY16_SSE41_6

	movzx rdx,byte ptr[rsi]
	movzx rcx,byte ptr[rsi+2]
	movzx rbx,byte ptr[rsi+4] ; ebx=R ecx=G edx=B
	mov eax,dword ptr[r14+4*rbx]
	add eax,dword ptr[r14+4*rcx+262144]
	add eax,dword ptr[r14+4*rdx+524288]
	pinsrd xmm0,eax,0
	
	psrad xmm0,8
	paddd xmm0,xmm3
	packusdw xmm0,xmm0
	pand xmm0,xmm2
	
	pextrw eax,xmm0,0
	mov word ptr[rdi],ax
	
	add rsi,8
	add rdi,2
	
Convert_RGB64toPlaneY16_SSE41_6:
	add rsi,r10
	add rdi,r11
	dec r9d
	jnz Convert_RGB64toPlaneY16_SSE41_1

	pop r15
	pop r14
	pop r13
	pop r12
	pop rbx
	pop rsi
	pop rdi
	pop rbp

	ret

JPSDR_HDRTools_Convert_RGB64toPlaneY16_SSE41 endp


;JPSDR_HDRTools_Convert_RGB64toPlaneY16_AVX proc src:dword,dst:dword,w:dword,h:dword,
;	lookup:dword,src_modulo:dword,dst_modulo:dword
; src = rcx
; dst = rdx
; w = r8d
; h = r9d

JPSDR_HDRTools_Convert_RGB64toPlaneY16_AVX proc public frame

lookup equ qword ptr[rbp+48]
src_modulo equ qword ptr[rbp+56]
dst_modulo equ qword ptr[rbp+64]

	push rbp
	.pushreg rbp
	mov rbp,rsp
	push rdi
	.pushreg rdi
	push rsi
	.pushreg rsi
	push rbx
	.pushreg rbx
	push r12
	.pushreg r12
	push r13
	.pushreg r13
	push r14
	.pushreg r14
	push r15
	.pushreg r15
	.endprolog

	vpxor xmm1,xmm1,xmm1
	vpxor xmm0,xmm0,xmm0
	vmovdqa xmm2,XMMWORD ptr data_HLG_8
	vmovdqa xmm3,XMMWORD ptr data_dw_128

	mov rsi,rcx
	mov rdi,rdx
	mov r14,lookup
	mov r10,src_modulo
	mov r11,dst_modulo
	mov r12,64
	mov r15,16
	xor rax,rax

Convert_RGB64toPlaneY16_AVX_1:
	mov r13d,r8d
	shr r13d,3
	jz Convert_RGB64toPlaneY16_AVX_3
	
Convert_RGB64toPlaneY16_AVX_2:
	movzx rdx,word ptr[rsi]
	movzx rcx,word ptr[rsi+2]
	movzx rbx,word ptr[rsi+4] ; ebx=R ecx=G edx=B
	mov eax,dword ptr[r14+4*rbx]
	add eax,dword ptr[r14+4*rcx+262144]
	add eax,dword ptr[r14+4*rdx+524288]
	vpinsrd xmm0,xmm0,eax,0
	movzx rdx,word ptr[rsi+8]
	movzx rcx,word ptr[rsi+10]
	movzx rbx,word ptr[rsi+12] ; ebx=R ecx=G edx=B
	mov eax,dword ptr[r14+4*rbx]
	add eax,dword ptr[r14+4*rcx+262144]
	add eax,dword ptr[r14+4*rdx+524288]
	vpinsrd xmm0,xmm0,eax,1
	movzx rdx,word ptr[rsi+16]
	movzx rcx,word ptr[rsi+18]
	movzx rbx,word ptr[rsi+20] ; ebx=R ecx=G edx=B
	mov eax,dword ptr[r14+4*rbx]
	add eax,dword ptr[r14+4*rcx+262144]
	add eax,dword ptr[r14+4*rdx+524288]
	vpinsrd xmm0,xmm0,eax,2	
	movzx rdx,word ptr[rsi+24]
	movzx rcx,word ptr[rsi+26]
	movzx rbx,word ptr[rsi+28] ; ebx=R ecx=G edx=B
	mov eax,dword ptr[r14+4*rbx]
	add eax,dword ptr[r14+4*rcx+262144]
	add eax,dword ptr[r14+4*rdx+524288]
	vpinsrd xmm0,xmm0,eax,3

	movzx rdx,word ptr[rsi+32]
	movzx rcx,word ptr[rsi+34]
	movzx rbx,word ptr[rsi+36] ; ebx=R ecx=G edx=B
	mov eax,dword ptr[r14+4*rbx]
	add eax,dword ptr[r14+4*rcx+262144]
	add eax,dword ptr[r14+4*rdx+524288]
	vpinsrd xmm1,xmm1,eax,0
	movzx rdx,word ptr[rsi+40]
	movzx rcx,word ptr[rsi+42]
	movzx rbx,word ptr[rsi+44] ; ebx=R ecx=G edx=B
	mov eax,dword ptr[r14+4*rbx]
	add eax,dword ptr[r14+4*rcx+262144]
	add eax,dword ptr[r14+4*rdx+524288]
	vpinsrd xmm1,xmm1,eax,1
	movzx rdx,word ptr[rsi+48]
	movzx rcx,word ptr[rsi+50]
	movzx rbx,word ptr[rsi+52] ; ebx=R ecx=G edx=B
	mov eax,dword ptr[r14+4*rbx]
	add eax,dword ptr[r14+4*rcx+262144]
	add eax,dword ptr[r14+4*rdx+524288]
	vpinsrd xmm1,xmm1,eax,2	
	movzx rdx,word ptr[rsi+56]
	movzx rcx,word ptr[rsi+58]
	movzx rbx,word ptr[rsi+60] ; ebx=R ecx=G edx=B
	mov eax,dword ptr[r14+4*rbx]
	add eax,dword ptr[r14+4*rcx+262144]
	add eax,dword ptr[r14+4*rdx+524288]
	vpinsrd xmm1,xmm1,eax,3
	
	vpsrad xmm0,xmm0,8
	vpsrad xmm1,xmm1,8
	vpaddd xmm0,xmm0,xmm3
	vpaddd xmm1,xmm1,xmm3
	vpackusdw xmm0,xmm0,xmm1
	vpand xmm0,xmm0,xmm2
	
	vmovdqa XMMWORD ptr[rdi],xmm0

	add rsi,r12
	add rdi,r15
	
	dec r13d
	jnz Convert_RGB64toPlaneY16_AVX_2
	
Convert_RGB64toPlaneY16_AVX_3:
	test r8d,4
	jz Convert_RGB64toPlaneY16_AVX_4

	movzx rdx,word ptr[rsi]
	movzx rcx,word ptr[rsi+2]
	movzx rbx,word ptr[rsi+4] ; ebx=R ecx=G edx=B
	mov eax,dword ptr[r14+4*rbx]
	add eax,dword ptr[r14+4*rcx+262144]
	add eax,dword ptr[r14+4*rdx+524288]
	vpinsrd xmm0,xmm0,eax,0
	movzx rdx,word ptr[rsi+8]
	movzx rcx,word ptr[rsi+10]
	movzx rbx,word ptr[rsi+12] ; ebx=R ecx=G edx=B
	mov eax,dword ptr[r14+4*rbx]
	add eax,dword ptr[r14+4*rcx+262144]
	add eax,dword ptr[r14+4*rdx+524288]
	vpinsrd xmm0,xmm0,eax,1
	movzx rdx,word ptr[rsi+16]
	movzx rcx,word ptr[rsi+18]
	movzx rbx,word ptr[rsi+20] ; ebx=R ecx=G edx=B
	mov eax,dword ptr[r14+4*rbx]
	add eax,dword ptr[r14+4*rcx+262144]
	add eax,dword ptr[r14+4*rdx+524288]
	vpinsrd xmm0,xmm0,eax,2	
	movzx rdx,word ptr[rsi+24]
	movzx rcx,word ptr[rsi+26]
	movzx rbx,word ptr[rsi+28] ; ebx=R ecx=G edx=B
	mov eax,dword ptr[r14+4*rbx]
	add eax,dword ptr[r14+4*rcx+262144]
	add eax,dword ptr[r14+4*rdx+524288]
	vpinsrd xmm0,xmm0,eax,3

	vpsrad xmm0,xmm0,8
	vpaddd xmm0,xmm0,xmm3
	vpackusdw xmm0,xmm0,xmm0
	vpand xmm0,xmm0,xmm2
	
	vmovq qword ptr[rdi],xmm0

	add rsi,32
	add rdi,8	
	
Convert_RGB64toPlaneY16_AVX_4:	
	test r8d,2
	jz Convert_RGB64toPlaneY16_AVX_5
	
	movzx rdx,word ptr[rsi]
	movzx rcx,word ptr[rsi+2]
	movzx rbx,word ptr[rsi+4] ; ebx=R ecx=G edx=B
	mov eax,dword ptr[r14+4*rbx]
	add eax,dword ptr[r14+4*rcx+262144]
	add eax,dword ptr[r14+4*rdx+524288]
	vpinsrd xmm0,xmm0,eax,0
	movzx rdx,word ptr[rsi+8]
	movzx rcx,word ptr[rsi+10]
	movzx rbx,word ptr[rsi+12] ; ebx=R ecx=G edx=B
	mov eax,dword ptr[r14+4*rbx]
	add eax,dword ptr[r14+4*rcx+262144]
	add eax,dword ptr[r14+4*rdx+524288]
	vpinsrd xmm0,xmm0,eax,1
	
	vpsrad xmm0,xmm0,8
	vpaddd xmm0,xmm0,xmm3
	vpackusdw xmm0,xmm0,xmm0
	vpand xmm0,xmm0,xmm2
	
	vmovd dword ptr[rdi],xmm0

	add rsi,r15
	add rdi,4
	
Convert_RGB64toPlaneY16_AVX_5:
	test r8d,1
	jz short Convert_RGB64toPlaneY16_AVX_6

	movzx rdx,byte ptr[rsi]
	movzx rcx,byte ptr[rsi+2]
	movzx rbx,byte ptr[rsi+4] ; ebx=R ecx=G edx=B
	mov eax,dword ptr[r14+4*rbx]
	add eax,dword ptr[r14+4*rcx+262144]
	add eax,dword ptr[r14+4*rdx+524288]
	vpinsrd xmm0,xmm0,eax,0
	
	vpsrad xmm0,xmm0,8
	vpaddd xmm0,xmm0,xmm3
	vpackusdw xmm0,xmm0,xmm0
	vpand xmm0,xmm0,xmm2
	
	vpextrw eax,xmm0,0
	mov word ptr[rdi],ax
	
	add rsi,8
	add rdi,2
	
Convert_RGB64toPlaneY16_AVX_6:
	add rsi,r10
	add rdi,r11
	dec r9d
	jnz Convert_RGB64toPlaneY16_AVX_1

	pop r15
	pop r14
	pop r13
	pop r12
	pop rbx
	pop rsi
	pop rdi
	pop rbp

	ret

JPSDR_HDRTools_Convert_RGB64toPlaneY16_AVX endp


;JPSDR_HDRTools_Convert_10_RGB64toPlaneY32_SSE41 proc src:dword,dst:dword,w:dword,h:dword,
;	lookup:dword,src_modulo:dword,dst_modulo:dword
; src = rcx
; dst = rdx
; w = r8d
; h = r9d

JPSDR_HDRTools_Convert_10_RGB64toPlaneY32_SSE41 proc public frame

lookup equ qword ptr[rbp+48]
src_modulo equ qword ptr[rbp+56]
dst_modulo equ qword ptr[rbp+64]

	push rbp
	.pushreg rbp
	mov rbp,rsp
	push rdi
	.pushreg rdi
	push rsi
	.pushreg rsi
	push rbx
	.pushreg rbx
	push r12
	.pushreg r12
	push r13
	.pushreg r13
	push r14
	.pushreg r14
	push r15
	.pushreg r15
	.endprolog

	pxor xmm1,xmm1
	pxor xmm0,xmm0
	movdqa xmm2,XMMWORD ptr data_HLG_10
	movdqa xmm3,XMMWORD ptr data_dw_32

	mov rsi,rcx
	mov rdi,rdx
	mov r14,lookup
	mov r10,src_modulo
	mov r11,dst_modulo
	mov r12,32
	mov r15,16
	xor rax,rax

Convert_10_RGB64toPlaneY32_SSE41_1:
	mov r13d,r8d
	shr r13d,2
	jz Convert_10_RGB64toPlaneY32_SSE41_3
	
Convert_10_RGB64toPlaneY32_SSE41_2:
	movzx rdx,word ptr[rsi]
	movzx rcx,word ptr[rsi+2]
	movzx rbx,word ptr[rsi+4] ; ebx=R ecx=G edx=B
	mov eax,dword ptr[r14+4*rbx]
	add eax,dword ptr[r14+4*rcx+262144]
	add eax,dword ptr[r14+4*rdx+524288]
	pinsrd xmm0,eax,0
	movzx rdx,word ptr[rsi+8]
	movzx rcx,word ptr[rsi+10]
	movzx rbx,word ptr[rsi+12] ; ebx=R ecx=G edx=B
	mov eax,dword ptr[r14+4*rbx]
	add eax,dword ptr[r14+4*rcx+262144]
	add eax,dword ptr[r14+4*rdx+524288]
	pinsrd xmm0,eax,1
	movzx rdx,word ptr[rsi+16]
	movzx rcx,word ptr[rsi+18]
	movzx rbx,word ptr[rsi+20] ; ebx=R ecx=G edx=B
	mov eax,dword ptr[r14+4*rbx]
	add eax,dword ptr[r14+4*rcx+262144]
	add eax,dword ptr[r14+4*rdx+524288]
	pinsrd xmm0,eax,2	
	movzx rdx,word ptr[rsi+24]
	movzx rcx,word ptr[rsi+26]
	movzx rbx,word ptr[rsi+28] ; ebx=R ecx=G edx=B
	mov eax,dword ptr[r14+4*rbx]
	add eax,dword ptr[r14+4*rcx+262144]
	add eax,dword ptr[r14+4*rdx+524288]
	pinsrd xmm0,eax,3

	psrad xmm0,8
	paddd xmm0,xmm3
	packusdw xmm0,xmm1
	punpcklwd xmm0,xmm1
	pslld xmm0,4
	pand xmm0,xmm2
	
	movdqa XMMWORD ptr[rdi],xmm0

	add rsi,r12
	add rdi,r15
	
	dec r13d
	jnz Convert_10_RGB64toPlaneY32_SSE41_2
	
Convert_10_RGB64toPlaneY32_SSE41_3:	
	test r8d,2
	jz Convert_10_RGB64toPlaneY32_SSE41_4
	
	movzx rdx,word ptr[rsi]
	movzx rcx,word ptr[rsi+2]
	movzx rbx,word ptr[rsi+4] ; ebx=R ecx=G edx=B
	mov eax,dword ptr[r14+4*rbx]
	add eax,dword ptr[r14+4*rcx+262144]
	add eax,dword ptr[r14+4*rdx+524288]
	pinsrd xmm0,eax,0
	movzx rdx,word ptr[rsi+8]
	movzx rcx,word ptr[rsi+10]
	movzx rbx,word ptr[rsi+12] ; ebx=R ecx=G edx=B
	mov eax,dword ptr[r14+4*rbx]
	add eax,dword ptr[r14+4*rcx+262144]
	add eax,dword ptr[r14+4*rdx+524288]
	pinsrd xmm0,eax,1
	
	psrad xmm0,8
	paddd xmm0,xmm3
	packusdw xmm0,xmm1
	punpcklwd xmm0,xmm1
	pslld xmm0,4
	pand xmm0,xmm2
	
	movq qword ptr[rdi],xmm0

	add rsi,r15
	add rdi,8
	
Convert_10_RGB64toPlaneY32_SSE41_4:
	test r8d,1
	jz short Convert_10_RGB64toPlaneY32_SSE41_5

	movzx rdx,byte ptr[rsi]
	movzx rcx,byte ptr[rsi+2]
	movzx rbx,byte ptr[rsi+4] ; ebx=R ecx=G edx=B
	mov eax,dword ptr[r14+4*rbx]
	add eax,dword ptr[r14+4*rcx+262144]
	add eax,dword ptr[r14+4*rdx+524288]
	pinsrd xmm0,eax,0
	
	psrad xmm0,8
	paddd xmm0,xmm3
	packusdw xmm0,xmm1
	punpcklwd xmm0,xmm1
	pslld xmm0,4
	pand xmm0,xmm2
	
	movd dword ptr[rdi],xmm0
	
	add rsi,8
	add rdi,4
	
Convert_10_RGB64toPlaneY32_SSE41_5:
	add rsi,r10
	add rdi,r11
	dec r9d
	jnz Convert_10_RGB64toPlaneY32_SSE41_1

	pop r15
	pop r14
	pop r13
	pop r12
	pop rbx
	pop rsi
	pop rdi
	pop rbp

	ret

JPSDR_HDRTools_Convert_10_RGB64toPlaneY32_SSE41 endp


;JPSDR_HDRTools_Convert_10_RGB64toPlaneY32_AVX proc src:dword,dst:dword,w:dword,h:dword,
;	lookup:dword,src_modulo:dword,dst_modulo:dword
; src = rcx
; dst = rdx
; w = r8d
; h = r9d

JPSDR_HDRTools_Convert_10_RGB64toPlaneY32_AVX proc public frame

lookup equ qword ptr[rbp+48]
src_modulo equ qword ptr[rbp+56]
dst_modulo equ qword ptr[rbp+64]

	push rbp
	.pushreg rbp
	mov rbp,rsp
	push rdi
	.pushreg rdi
	push rsi
	.pushreg rsi
	push rbx
	.pushreg rbx
	push r12
	.pushreg r12
	push r13
	.pushreg r13
	push r14
	.pushreg r14
	push r15
	.pushreg r15
	.endprolog

	vpxor xmm1,xmm1,xmm1
	vpxor xmm0,xmm0,xmm0
	vmovdqa xmm2,XMMWORD ptr data_HLG_10
	vmovdqa xmm3,XMMWORD ptr data_dw_32

	mov rsi,rcx
	mov rdi,rdx
	mov r14,lookup
	mov r10,src_modulo
	mov r11,dst_modulo
	mov r12,32
	mov r15,16
	xor rax,rax

Convert_10_RGB64toPlaneY32_AVX_1:
	mov r13d,r8d
	shr r13d,2
	jz Convert_10_RGB64toPlaneY32_AVX_3
	
Convert_10_RGB64toPlaneY32_AVX_2:
	movzx rdx,word ptr[rsi]
	movzx rcx,word ptr[rsi+2]
	movzx rbx,word ptr[rsi+4] ; ebx=R ecx=G edx=B
	mov eax,dword ptr[r14+4*rbx]
	add eax,dword ptr[r14+4*rcx+262144]
	add eax,dword ptr[r14+4*rdx+524288]
	vpinsrd xmm0,xmm0,eax,0
	movzx rdx,word ptr[rsi+8]
	movzx rcx,word ptr[rsi+10]
	movzx rbx,word ptr[rsi+12] ; ebx=R ecx=G edx=B
	mov eax,dword ptr[r14+4*rbx]
	add eax,dword ptr[r14+4*rcx+262144]
	add eax,dword ptr[r14+4*rdx+524288]
	vpinsrd xmm0,xmm0,eax,1
	movzx rdx,word ptr[rsi+16]
	movzx rcx,word ptr[rsi+18]
	movzx rbx,word ptr[rsi+20] ; ebx=R ecx=G edx=B
	mov eax,dword ptr[r14+4*rbx]
	add eax,dword ptr[r14+4*rcx+262144]
	add eax,dword ptr[r14+4*rdx+524288]
	vpinsrd xmm0,xmm0,eax,2	
	movzx rdx,word ptr[rsi+24]
	movzx rcx,word ptr[rsi+26]
	movzx rbx,word ptr[rsi+28] ; ebx=R ecx=G edx=B
	mov eax,dword ptr[r14+4*rbx]
	add eax,dword ptr[r14+4*rcx+262144]
	add eax,dword ptr[r14+4*rdx+524288]
	vpinsrd xmm0,xmm0,eax,3

	vpsrad xmm0,xmm0,8
	vpaddd xmm0,xmm0,xmm3
	vpackusdw xmm0,xmm0,xmm1
	vpunpcklwd xmm0,xmm0,xmm1
	vpslld xmm0,xmm0,4
	vpand xmm0,xmm0,xmm2
	
	vmovdqa XMMWORD ptr[rdi],xmm0

	add rsi,r12
	add rdi,r15
	
	dec r13d
	jnz Convert_10_RGB64toPlaneY32_AVX_2
	
Convert_10_RGB64toPlaneY32_AVX_3:	
	test r8d,2
	jz Convert_10_RGB64toPlaneY32_AVX_4
	
	movzx rdx,word ptr[rsi]
	movzx rcx,word ptr[rsi+2]
	movzx rbx,word ptr[rsi+4] ; ebx=R ecx=G edx=B
	mov eax,dword ptr[r14+4*rbx]
	add eax,dword ptr[r14+4*rcx+262144]
	add eax,dword ptr[r14+4*rdx+524288]
	vpinsrd xmm0,xmm0,eax,0
	movzx rdx,word ptr[rsi+8]
	movzx rcx,word ptr[rsi+10]
	movzx rbx,word ptr[rsi+12] ; ebx=R ecx=G edx=B
	mov eax,dword ptr[r14+4*rbx]
	add eax,dword ptr[r14+4*rcx+262144]
	add eax,dword ptr[r14+4*rdx+524288]
	vpinsrd xmm0,xmm0,eax,1
	
	vpsrad xmm0,xmm0,8
	vpaddd xmm0,xmm0,xmm3
	vpackusdw xmm0,xmm0,xmm1
	vpunpcklwd xmm0,xmm0,xmm1
	vpslld xmm0,xmm0,4
	vpand xmm0,xmm0,xmm2
	
	vmovq qword ptr[rdi],xmm0

	add rsi,r15
	add rdi,8
	
Convert_10_RGB64toPlaneY32_AVX_4:
	test r8d,1
	jz short Convert_10_RGB64toPlaneY32_AVX_5

	movzx rdx,byte ptr[rsi]
	movzx rcx,byte ptr[rsi+2]
	movzx rbx,byte ptr[rsi+4] ; ebx=R ecx=G edx=B
	mov eax,dword ptr[r14+4*rbx]
	add eax,dword ptr[r14+4*rcx+262144]
	add eax,dword ptr[r14+4*rdx+524288]
	vpinsrd xmm0,xmm0,eax,0
	
	vpsrad xmm0,xmm0,8
	vpaddd xmm0,xmm0,xmm3
	vpackusdw xmm0,xmm0,xmm1
	vpunpcklwd xmm0,xmm0,xmm1
	vpslld xmm0,xmm0,4
	vpand xmm0,xmm0,xmm2
	
	vmovd dword ptr[rdi],xmm0
	
	add rsi,8
	add rdi,4
	
Convert_10_RGB64toPlaneY32_AVX_5:
	add rsi,r10
	add rdi,r11
	dec r9d
	jnz Convert_10_RGB64toPlaneY32_AVX_1

	pop r15
	pop r14
	pop r13
	pop r12
	pop rbx
	pop rsi
	pop rdi
	pop rbp

	ret

JPSDR_HDRTools_Convert_10_RGB64toPlaneY32_AVX endp


;JPSDR_HDRTools_Convert_12_RGB64toPlaneY32_SSE41 proc src:dword,dst:dword,w:dword,h:dword,
;	lookup:dword,src_modulo:dword,dst_modulo:dword
; src = rcx
; dst = rdx
; w = r8d
; h = r9d

JPSDR_HDRTools_Convert_12_RGB64toPlaneY32_SSE41 proc public frame

lookup equ qword ptr[rbp+48]
src_modulo equ qword ptr[rbp+56]
dst_modulo equ qword ptr[rbp+64]

	push rbp
	.pushreg rbp
	mov rbp,rsp
	push rdi
	.pushreg rdi
	push rsi
	.pushreg rsi
	push rbx
	.pushreg rbx
	push r12
	.pushreg r12
	push r13
	.pushreg r13
	push r14
	.pushreg r14
	push r15
	.pushreg r15
	.endprolog

	pxor xmm1,xmm1
	pxor xmm0,xmm0
	movdqa xmm2,XMMWORD ptr data_HLG_12
	movdqa xmm3,XMMWORD ptr data_dw_8

	mov rsi,rcx
	mov rdi,rdx
	mov r14,lookup
	mov r10,src_modulo
	mov r11,dst_modulo
	mov r12,32
	mov r15,16
	xor rax,rax

Convert_12_RGB64toPlaneY32_SSE41_1:
	mov r13d,r8d
	shr r13d,2
	jz Convert_12_RGB64toPlaneY32_SSE41_3
	
Convert_12_RGB64toPlaneY32_SSE41_2:
	movzx rdx,word ptr[rsi]
	movzx rcx,word ptr[rsi+2]
	movzx rbx,word ptr[rsi+4] ; ebx=R ecx=G edx=B
	mov eax,dword ptr[r14+4*rbx]
	add eax,dword ptr[r14+4*rcx+262144]
	add eax,dword ptr[r14+4*rdx+524288]
	pinsrd xmm0,eax,0
	movzx rdx,word ptr[rsi+8]
	movzx rcx,word ptr[rsi+10]
	movzx rbx,word ptr[rsi+12] ; ebx=R ecx=G edx=B
	mov eax,dword ptr[r14+4*rbx]
	add eax,dword ptr[r14+4*rcx+262144]
	add eax,dword ptr[r14+4*rdx+524288]
	pinsrd xmm0,eax,1
	movzx rdx,word ptr[rsi+16]
	movzx rcx,word ptr[rsi+18]
	movzx rbx,word ptr[rsi+20] ; ebx=R ecx=G edx=B
	mov eax,dword ptr[r14+4*rbx]
	add eax,dword ptr[r14+4*rcx+262144]
	add eax,dword ptr[r14+4*rdx+524288]
	pinsrd xmm0,eax,2	
	movzx rdx,word ptr[rsi+24]
	movzx rcx,word ptr[rsi+26]
	movzx rbx,word ptr[rsi+28] ; ebx=R ecx=G edx=B
	mov eax,dword ptr[r14+4*rbx]
	add eax,dword ptr[r14+4*rcx+262144]
	add eax,dword ptr[r14+4*rdx+524288]
	pinsrd xmm0,eax,3

	psrad xmm0,8
	paddd xmm0,xmm3
	packusdw xmm0,xmm1
	punpcklwd xmm0,xmm1
	pslld xmm0,8
	pand xmm0,xmm2
	
	movdqa XMMWORD ptr[rdi],xmm0

	add rsi,r12
	add rdi,r15
	
	dec r13d
	jnz Convert_12_RGB64toPlaneY32_SSE41_2
	
Convert_12_RGB64toPlaneY32_SSE41_3:	
	test r8d,2
	jz Convert_12_RGB64toPlaneY32_SSE41_4
	
	movzx rdx,word ptr[rsi]
	movzx rcx,word ptr[rsi+2]
	movzx rbx,word ptr[rsi+4] ; ebx=R ecx=G edx=B
	mov eax,dword ptr[r14+4*rbx]
	add eax,dword ptr[r14+4*rcx+262144]
	add eax,dword ptr[r14+4*rdx+524288]
	pinsrd xmm0,eax,0
	movzx rdx,word ptr[rsi+8]
	movzx rcx,word ptr[rsi+10]
	movzx rbx,word ptr[rsi+12] ; ebx=R ecx=G edx=B
	mov eax,dword ptr[r14+4*rbx]
	add eax,dword ptr[r14+4*rcx+262144]
	add eax,dword ptr[r14+4*rdx+524288]
	pinsrd xmm0,eax,1
	
	psrad xmm0,8
	paddd xmm0,xmm3
	packusdw xmm0,xmm1
	punpcklwd xmm0,xmm1
	pslld xmm0,8
	pand xmm0,xmm2
	
	movq qword ptr[rdi],xmm0

	add rsi,r15
	add rdi,8
	
Convert_12_RGB64toPlaneY32_SSE41_4:
	test r8d,1
	jz short Convert_12_RGB64toPlaneY32_SSE41_5

	movzx rdx,byte ptr[rsi]
	movzx rcx,byte ptr[rsi+2]
	movzx rbx,byte ptr[rsi+4] ; ebx=R ecx=G edx=B
	mov eax,dword ptr[r14+4*rbx]
	add eax,dword ptr[r14+4*rcx+262144]
	add eax,dword ptr[r14+4*rdx+524288]
	pinsrd xmm0,eax,0
	
	psrad xmm0,8
	paddd xmm0,xmm3
	packusdw xmm0,xmm1
	punpcklwd xmm0,xmm1
	pslld xmm0,8
	pand xmm0,xmm2
	
	movd dword ptr[rdi],xmm0
	
	add rsi,8
	add rdi,4
	
Convert_12_RGB64toPlaneY32_SSE41_5:
	add rsi,r10
	add rdi,r11
	dec r9d
	jnz Convert_12_RGB64toPlaneY32_SSE41_1

	pop r15
	pop r14
	pop r13
	pop r12
	pop rbx
	pop rsi
	pop rdi
	pop rbp

	ret

JPSDR_HDRTools_Convert_12_RGB64toPlaneY32_SSE41 endp


;JPSDR_HDRTools_Convert_12_RGB64toPlaneY32_AVX proc src:dword,dst:dword,w:dword,h:dword,
;	lookup:dword,src_modulo:dword,dst_modulo:dword
; src = rcx
; dst = rdx
; w = r8d
; h = r9d

JPSDR_HDRTools_Convert_12_RGB64toPlaneY32_AVX proc public frame

lookup equ qword ptr[rbp+48]
src_modulo equ qword ptr[rbp+56]
dst_modulo equ qword ptr[rbp+64]

	push rbp
	.pushreg rbp
	mov rbp,rsp
	push rdi
	.pushreg rdi
	push rsi
	.pushreg rsi
	push rbx
	.pushreg rbx
	push r12
	.pushreg r12
	push r13
	.pushreg r13
	push r14
	.pushreg r14
	push r15
	.pushreg r15
	.endprolog

	vpxor xmm1,xmm1,xmm1
	vpxor xmm0,xmm0,xmm0
	vmovdqa xmm2,XMMWORD ptr data_HLG_12
	vmovdqa xmm3,XMMWORD ptr data_dw_8

	mov rsi,rcx
	mov rdi,rdx
	mov r14,lookup
	mov r10,src_modulo
	mov r11,dst_modulo
	mov r12,32
	mov r15,16
	xor rax,rax

Convert_12_RGB64toPlaneY32_AVX_1:
	mov r13d,r8d
	shr r13d,2
	jz Convert_12_RGB64toPlaneY32_AVX_3
	
Convert_12_RGB64toPlaneY32_AVX_2:
	movzx rdx,word ptr[rsi]
	movzx rcx,word ptr[rsi+2]
	movzx rbx,word ptr[rsi+4] ; ebx=R ecx=G edx=B
	mov eax,dword ptr[r14+4*rbx]
	add eax,dword ptr[r14+4*rcx+262144]
	add eax,dword ptr[r14+4*rdx+524288]
	vpinsrd xmm0,xmm0,eax,0
	movzx rdx,word ptr[rsi+8]
	movzx rcx,word ptr[rsi+10]
	movzx rbx,word ptr[rsi+12] ; ebx=R ecx=G edx=B
	mov eax,dword ptr[r14+4*rbx]
	add eax,dword ptr[r14+4*rcx+262144]
	add eax,dword ptr[r14+4*rdx+524288]
	vpinsrd xmm0,xmm0,eax,1
	movzx rdx,word ptr[rsi+16]
	movzx rcx,word ptr[rsi+18]
	movzx rbx,word ptr[rsi+20] ; ebx=R ecx=G edx=B
	mov eax,dword ptr[r14+4*rbx]
	add eax,dword ptr[r14+4*rcx+262144]
	add eax,dword ptr[r14+4*rdx+524288]
	vpinsrd xmm0,xmm0,eax,2	
	movzx rdx,word ptr[rsi+24]
	movzx rcx,word ptr[rsi+26]
	movzx rbx,word ptr[rsi+28] ; ebx=R ecx=G edx=B
	mov eax,dword ptr[r14+4*rbx]
	add eax,dword ptr[r14+4*rcx+262144]
	add eax,dword ptr[r14+4*rdx+524288]
	vpinsrd xmm0,xmm0,eax,3

	vpsrad xmm0,xmm0,8
	vpaddd xmm0,xmm0,xmm3
	vpackusdw xmm0,xmm0,xmm1
	vpunpcklwd xmm0,xmm0,xmm1
	vpslld xmm0,xmm0,8
	vpand xmm0,xmm0,xmm2
	
	vmovdqa XMMWORD ptr[rdi],xmm0

	add rsi,r12
	add rdi,r15
	
	dec r13d
	jnz Convert_12_RGB64toPlaneY32_AVX_2
	
Convert_12_RGB64toPlaneY32_AVX_3:	
	test r8d,2
	jz Convert_12_RGB64toPlaneY32_AVX_4
	
	movzx rdx,word ptr[rsi]
	movzx rcx,word ptr[rsi+2]
	movzx rbx,word ptr[rsi+4] ; ebx=R ecx=G edx=B
	mov eax,dword ptr[r14+4*rbx]
	add eax,dword ptr[r14+4*rcx+262144]
	add eax,dword ptr[r14+4*rdx+524288]
	vpinsrd xmm0,xmm0,eax,0
	movzx rdx,word ptr[rsi+8]
	movzx rcx,word ptr[rsi+10]
	movzx rbx,word ptr[rsi+12] ; ebx=R ecx=G edx=B
	mov eax,dword ptr[r14+4*rbx]
	add eax,dword ptr[r14+4*rcx+262144]
	add eax,dword ptr[r14+4*rdx+524288]
	vpinsrd xmm0,xmm0,eax,1
	
	vpsrad xmm0,xmm0,8
	vpaddd xmm0,xmm0,xmm3
	vpackusdw xmm0,xmm0,xmm1
	vpunpcklwd xmm0,xmm0,xmm1
	vpslld xmm0,xmm0,8
	vpand xmm0,xmm0,xmm2
	
	vmovq qword ptr[rdi],xmm0

	add rsi,r15
	add rdi,8
	
Convert_12_RGB64toPlaneY32_AVX_4:
	test r8d,1
	jz short Convert_12_RGB64toPlaneY32_AVX_5

	movzx rdx,byte ptr[rsi]
	movzx rcx,byte ptr[rsi+2]
	movzx rbx,byte ptr[rsi+4] ; ebx=R ecx=G edx=B
	mov eax,dword ptr[r14+4*rbx]
	add eax,dword ptr[r14+4*rcx+262144]
	add eax,dword ptr[r14+4*rdx+524288]
	vpinsrd xmm0,xmm0,eax,0
	
	vpsrad xmm0,xmm0,8
	vpaddd xmm0,xmm0,xmm3
	vpackusdw xmm0,xmm0,xmm1
	vpunpcklwd xmm0,xmm0,xmm1
	vpslld xmm0,xmm0,8
	vpand xmm0,xmm0,xmm2
	
	vmovd dword ptr[rdi],xmm0
	
	add rsi,8
	add rdi,4
	
Convert_12_RGB64toPlaneY32_AVX_5:
	add rsi,r10
	add rdi,r11
	dec r9d
	jnz Convert_12_RGB64toPlaneY32_AVX_1

	pop r15
	pop r14
	pop r13
	pop r12
	pop rbx
	pop rsi
	pop rdi
	pop rbp

	ret

JPSDR_HDRTools_Convert_12_RGB64toPlaneY32_AVX endp


;JPSDR_HDRTools_Convert_16_RGB64toPlaneY32_SSE41 proc src:dword,dst:dword,w:dword,h:dword,
;	lookup:dword,src_modulo:dword,dst_modulo:dword
; src = rcx
; dst = rdx
; w = r8d
; h = r9d

JPSDR_HDRTools_Convert_16_RGB64toPlaneY32_SSE41 proc public frame

lookup equ qword ptr[rbp+48]
src_modulo equ qword ptr[rbp+56]
dst_modulo equ qword ptr[rbp+64]

	push rbp
	.pushreg rbp
	mov rbp,rsp
	push rdi
	.pushreg rdi
	push rsi
	.pushreg rsi
	push rbx
	.pushreg rbx
	push r12
	.pushreg r12
	push r13
	.pushreg r13
	push r14
	.pushreg r14
	push r15
	.pushreg r15
	.endprolog

	pxor xmm1,xmm1
	pxor xmm0,xmm0

	mov rsi,rcx
	mov rdi,rdx
	mov r14,lookup
	mov r10,src_modulo
	mov r11,dst_modulo
	mov r12,32
	mov r15,16
	xor rax,rax

Convert_16_RGB64toPlaneY32_SSE41_1:
	mov r13d,r8d
	shr r13d,2
	jz Convert_16_RGB64toPlaneY32_SSE41_3
	
Convert_16_RGB64toPlaneY32_SSE41_2:
	movzx rdx,word ptr[rsi]
	movzx rcx,word ptr[rsi+2]
	movzx rbx,word ptr[rsi+4] ; ebx=R ecx=G edx=B
	mov eax,dword ptr[r14+4*rbx]
	add eax,dword ptr[r14+4*rcx+262144]
	add eax,dword ptr[r14+4*rdx+524288]
	pinsrd xmm0,eax,0
	movzx rdx,word ptr[rsi+8]
	movzx rcx,word ptr[rsi+10]
	movzx rbx,word ptr[rsi+12] ; ebx=R ecx=G edx=B
	mov eax,dword ptr[r14+4*rbx]
	add eax,dword ptr[r14+4*rcx+262144]
	add eax,dword ptr[r14+4*rdx+524288]
	pinsrd xmm0,eax,1
	movzx rdx,word ptr[rsi+16]
	movzx rcx,word ptr[rsi+18]
	movzx rbx,word ptr[rsi+20] ; ebx=R ecx=G edx=B
	mov eax,dword ptr[r14+4*rbx]
	add eax,dword ptr[r14+4*rcx+262144]
	add eax,dword ptr[r14+4*rdx+524288]
	pinsrd xmm0,eax,2	
	movzx rdx,word ptr[rsi+24]
	movzx rcx,word ptr[rsi+26]
	movzx rbx,word ptr[rsi+28] ; ebx=R ecx=G edx=B
	mov eax,dword ptr[r14+4*rbx]
	add eax,dword ptr[r14+4*rcx+262144]
	add eax,dword ptr[r14+4*rdx+524288]
	pinsrd xmm0,eax,3

	psrad xmm0,8
	packusdw xmm0,xmm1
	punpcklwd xmm0,xmm1
	
	movdqa XMMWORD ptr[rdi],xmm0

	add rsi,r12
	add rdi,r15
	
	dec r13d
	jnz Convert_16_RGB64toPlaneY32_SSE41_2
	
Convert_16_RGB64toPlaneY32_SSE41_3:	
	test r8d,2
	jz Convert_16_RGB64toPlaneY32_SSE41_4
	
	movzx rdx,word ptr[rsi]
	movzx rcx,word ptr[rsi+2]
	movzx rbx,word ptr[rsi+4] ; ebx=R ecx=G edx=B
	mov eax,dword ptr[r14+4*rbx]
	add eax,dword ptr[r14+4*rcx+262144]
	add eax,dword ptr[r14+4*rdx+524288]
	pinsrd xmm0,eax,0
	movzx rdx,word ptr[rsi+8]
	movzx rcx,word ptr[rsi+10]
	movzx rbx,word ptr[rsi+12] ; ebx=R ecx=G edx=B
	mov eax,dword ptr[r14+4*rbx]
	add eax,dword ptr[r14+4*rcx+262144]
	add eax,dword ptr[r14+4*rdx+524288]
	pinsrd xmm0,eax,1
	
	psrad xmm0,8
	packusdw xmm0,xmm1
	punpcklwd xmm0,xmm1
	
	movq qword ptr[rdi],xmm0

	add rsi,r15
	add rdi,8
	
Convert_16_RGB64toPlaneY32_SSE41_4:
	test r8d,1
	jz short Convert_16_RGB64toPlaneY32_SSE41_5

	movzx rdx,byte ptr[rsi]
	movzx rcx,byte ptr[rsi+2]
	movzx rbx,byte ptr[rsi+4] ; ebx=R ecx=G edx=B
	mov eax,dword ptr[r14+4*rbx]
	add eax,dword ptr[r14+4*rcx+262144]
	add eax,dword ptr[r14+4*rdx+524288]
	pinsrd xmm0,eax,0
	
	psrad xmm0,8
	packusdw xmm0,xmm1
	punpcklwd xmm0,xmm1
	
	movd dword ptr[rdi],xmm0
	
	add rsi,8
	add rdi,4
	
Convert_16_RGB64toPlaneY32_SSE41_5:
	add rsi,r10
	add rdi,r11
	dec r9d
	jnz Convert_16_RGB64toPlaneY32_SSE41_1

	pop r15
	pop r14
	pop r13
	pop r12
	pop rbx
	pop rsi
	pop rdi
	pop rbp

	ret

JPSDR_HDRTools_Convert_16_RGB64toPlaneY32_SSE41 endp


;JPSDR_HDRTools_Convert_16_RGB64toPlaneY32_AVX proc src:dword,dst:dword,w:dword,h:dword,
;	lookup:dword,src_modulo:dword,dst_modulo:dword
; src = rcx
; dst = rdx
; w = r8d
; h = r9d

JPSDR_HDRTools_Convert_16_RGB64toPlaneY32_AVX proc public frame

lookup equ qword ptr[rbp+48]
src_modulo equ qword ptr[rbp+56]
dst_modulo equ qword ptr[rbp+64]

	push rbp
	.pushreg rbp
	mov rbp,rsp
	push rdi
	.pushreg rdi
	push rsi
	.pushreg rsi
	push rbx
	.pushreg rbx
	push r12
	.pushreg r12
	push r13
	.pushreg r13
	push r14
	.pushreg r14
	push r15
	.pushreg r15
	.endprolog

	vpxor xmm1,xmm1,xmm1
	vpxor xmm0,xmm0,xmm0

	mov rsi,rcx
	mov rdi,rdx
	mov r14,lookup
	mov r10,src_modulo
	mov r11,dst_modulo
	mov r12,32
	mov r15,16
	xor rax,rax

Convert_16_RGB64toPlaneY32_AVX_1:
	mov r13d,r8d
	shr r13d,2
	jz Convert_16_RGB64toPlaneY32_AVX_3
	
Convert_16_RGB64toPlaneY32_AVX_2:
	movzx rdx,word ptr[rsi]
	movzx rcx,word ptr[rsi+2]
	movzx rbx,word ptr[rsi+4] ; ebx=R ecx=G edx=B
	mov eax,dword ptr[r14+4*rbx]
	add eax,dword ptr[r14+4*rcx+262144]
	add eax,dword ptr[r14+4*rdx+524288]
	vpinsrd xmm0,xmm0,eax,0
	movzx rdx,word ptr[rsi+8]
	movzx rcx,word ptr[rsi+10]
	movzx rbx,word ptr[rsi+12] ; ebx=R ecx=G edx=B
	mov eax,dword ptr[r14+4*rbx]
	add eax,dword ptr[r14+4*rcx+262144]
	add eax,dword ptr[r14+4*rdx+524288]
	vpinsrd xmm0,xmm0,eax,1
	movzx rdx,word ptr[rsi+16]
	movzx rcx,word ptr[rsi+18]
	movzx rbx,word ptr[rsi+20] ; ebx=R ecx=G edx=B
	mov eax,dword ptr[r14+4*rbx]
	add eax,dword ptr[r14+4*rcx+262144]
	add eax,dword ptr[r14+4*rdx+524288]
	vpinsrd xmm0,xmm0,eax,2	
	movzx rdx,word ptr[rsi+24]
	movzx rcx,word ptr[rsi+26]
	movzx rbx,word ptr[rsi+28] ; ebx=R ecx=G edx=B
	mov eax,dword ptr[r14+4*rbx]
	add eax,dword ptr[r14+4*rcx+262144]
	add eax,dword ptr[r14+4*rdx+524288]
	vpinsrd xmm0,xmm0,eax,3

	vpsrad xmm0,xmm0,8
	vpackusdw xmm0,xmm0,xmm1
	vpunpcklwd xmm0,xmm0,xmm1
	
	vmovdqa XMMWORD ptr[rdi],xmm0

	add rsi,r12
	add rdi,r15
	
	dec r13d
	jnz Convert_16_RGB64toPlaneY32_AVX_2
	
Convert_16_RGB64toPlaneY32_AVX_3:	
	test r8d,2
	jz Convert_16_RGB64toPlaneY32_AVX_4
	
	movzx rdx,word ptr[rsi]
	movzx rcx,word ptr[rsi+2]
	movzx rbx,word ptr[rsi+4] ; ebx=R ecx=G edx=B
	mov eax,dword ptr[r14+4*rbx]
	add eax,dword ptr[r14+4*rcx+262144]
	add eax,dword ptr[r14+4*rdx+524288]
	vpinsrd xmm0,xmm0,eax,0
	movzx rdx,word ptr[rsi+8]
	movzx rcx,word ptr[rsi+10]
	movzx rbx,word ptr[rsi+12] ; ebx=R ecx=G edx=B
	mov eax,dword ptr[r14+4*rbx]
	add eax,dword ptr[r14+4*rcx+262144]
	add eax,dword ptr[r14+4*rdx+524288]
	vpinsrd xmm0,xmm0,eax,1
	
	vpsrad xmm0,xmm0,8
	vpackusdw xmm0,xmm0,xmm1
	vpunpcklwd xmm0,xmm0,xmm1
	
	vmovq qword ptr[rdi],xmm0

	add rsi,r15
	add rdi,8
	
Convert_16_RGB64toPlaneY32_AVX_4:
	test r8d,1
	jz short Convert_16_RGB64toPlaneY32_AVX_5

	movzx rdx,byte ptr[rsi]
	movzx rcx,byte ptr[rsi+2]
	movzx rbx,byte ptr[rsi+4] ; ebx=R ecx=G edx=B
	mov eax,dword ptr[r14+4*rbx]
	add eax,dword ptr[r14+4*rcx+262144]
	add eax,dword ptr[r14+4*rdx+524288]
	vpinsrd xmm0,xmm0,eax,0
	
	vpsrad xmm0,xmm0,8
	vpackusdw xmm0,xmm0,xmm1
	vpunpcklwd xmm0,xmm0,xmm1
	
	vmovd dword ptr[rdi],xmm0
	
	add rsi,8
	add rdi,4
	
Convert_16_RGB64toPlaneY32_AVX_5:
	add rsi,r10
	add rdi,r11
	dec r9d
	jnz Convert_16_RGB64toPlaneY32_AVX_1

	pop r15
	pop r14
	pop r13
	pop r12
	pop rbx
	pop rsi
	pop rdi
	pop rbp

	ret

JPSDR_HDRTools_Convert_16_RGB64toPlaneY32_AVX endp


;JPSDR_HDRTools_Convert_RGB64_16toRGB64_8_SSE2 proc src:dword,dst:dword,w:dword,h:dword,
;	src_pitch:dword,dst_pitch:dword
; src = rcx
; dst = rdx
; w = r8d
; h = r9d
JPSDR_HDRTools_Convert_RGB64_16toRGB64_8_SSE2 proc public frame

src_pitch equ qword ptr[rbp+48]
dst_pitch equ qword ptr[rbp+56]

	push rbp
	.pushreg rbp
	mov rbp,rsp
	push rdi
	.pushreg rdi
	push rsi
	.pushreg rsi
	push rbx
	.pushreg rbx
	push r12
	.pushreg r12
	.endprolog

	movdqa xmm1,XMMWORD ptr data_w_128

	mov rsi,rcx
	mov rdi,rdx
	mov ebx,r8d
	mov r10,src_pitch
	mov r11,dst_pitch
	shr ebx,1
	mov rdx,16
	mov r12,1

Convert_RGB64_16toRGB64_8_SSE2_1:
	mov ecx,ebx
	xor rax,rax
	or ecx,ecx
	jz short Convert_RGB64_16toRGB64_8_SSE2_3
	
Convert_RGB64_16toRGB64_8_SSE2_2:
	movdqa xmm0,XMMWORD ptr[rsi+rax]
	paddusw xmm0,xmm1
	psrlw xmm0,8
	movdqa XMMWORD ptr[rdi+rax],xmm0
	add rax,rdx
	loop Convert_RGB64_16toRGB64_8_SSE2_2

Convert_RGB64_16toRGB64_8_SSE2_3:
	test r8d,r12d
	jz short Convert_RGB64_16toRGB64_8_SSE2_4

	movq xmm0,qword ptr[rsi+rax]
	paddusw xmm0,xmm1
	psrlw xmm0,8
	movq qword ptr[rdi+rax],xmm0
	
Convert_RGB64_16toRGB64_8_SSE2_4:
	add rsi,r10
	add rdi,r11
	dec r9d
	jnz short Convert_RGB64_16toRGB64_8_SSE2_1
	
	pop r12
	pop rbx
	pop rsi
	pop rdi
	pop rbp

	ret

JPSDR_HDRTools_Convert_RGB64_16toRGB64_8_SSE2 endp


;JPSDR_HDRTools_Convert_RGB64_16toRGB64_8_AVX proc src:dword,dst:dword,w:dword,h:dword,
;	src_pitch:dword,dst_pitch:dword
; src = rcx
; dst = rdx
; w = r8d
; h = r9d
JPSDR_HDRTools_Convert_RGB64_16toRGB64_8_AVX proc public frame

src_pitch equ qword ptr[rbp+48]
dst_pitch equ qword ptr[rbp+56]

	push rbp
	.pushreg rbp
	mov rbp,rsp
	push rdi
	.pushreg rdi
	push rsi
	.pushreg rsi
	push rbx
	.pushreg rbx
	.endprolog

	vmovdqa xmm4,XMMWORD ptr data_w_128

	mov rsi,rcx
	mov rdi,rdx
	mov ebx,r8d
	mov r10,src_pitch
	mov r11,dst_pitch
	shr ebx,1
	mov rdx,64

Convert_RGB64_16toRGB64_8_AVX_loop_1:
	mov ecx,ebx
	xor rax,rax

	shr ecx,2
	jz short Convert_RGB64_16toRGB64_8_AVX_3
	
Convert_RGB64_16toRGB64_8_AVX_loop_2:
	vpaddusw xmm0,xmm4,XMMWORD ptr[rsi+rax]
	vpaddusw xmm1,xmm4,XMMWORD ptr[rsi+rax+16]
	vpaddusw xmm2,xmm4,XMMWORD ptr[rsi+rax+32]
	vpaddusw xmm3,xmm4,XMMWORD ptr[rsi+rax+48]
	vpsrlw xmm0,xmm0,8
	vpsrlw xmm1,xmm1,8
	vpsrlw xmm2,xmm2,8
	vpsrlw xmm3,xmm3,8
	vmovdqa XMMWORD ptr[rdi+rax],xmm0
	vmovdqa XMMWORD ptr[rdi+rax+16],xmm1
	vmovdqa XMMWORD ptr[rdi+rax+32],xmm2
	vmovdqa XMMWORD ptr[rdi+rax+48],xmm3
	add rax,rdx
	loop Convert_RGB64_16toRGB64_8_AVX_loop_2

Convert_RGB64_16toRGB64_8_AVX_3:
	test ebx,2
	jz short Convert_RGB64_16toRGB64_8_AVX_4

	vpaddusw xmm0,xmm4,XMMWORD ptr[rsi+rax]
	vpaddusw xmm1,xmm4,XMMWORD ptr[rsi+rax+16]
	vpsrlw xmm0,xmm0,8
	vpsrlw xmm1,xmm1,8
	vmovdqa XMMWORD ptr[rdi+rax],xmm0
	vmovdqa XMMWORD ptr[rdi+rax+16],xmm1
	add rax,32

Convert_RGB64_16toRGB64_8_AVX_4:
	test ebx,1
	jz short Convert_RGB64_16toRGB64_8_AVX_5

	vpaddusw xmm0,xmm4,XMMWORD ptr[rsi+rax]
	vpsrlw xmm0,xmm0,8
	vmovdqa XMMWORD ptr[rdi+rax],xmm0
	add rax,16

Convert_RGB64_16toRGB64_8_AVX_5:
	test r8d,1
	jz short Convert_RGB64_16toRGB64_8_AVX_6
	
	vmovq xmm0,qword ptr[rsi+rax]
	vpaddusw xmm0,xmm0,xmm4
	vpsrlw xmm0,xmm0,8
	vmovq qword ptr[rdi+rax],xmm0
	
Convert_RGB64_16toRGB64_8_AVX_6:
	add rsi,r10
	add rdi,r11
	dec r9d
	jnz Convert_RGB64_16toRGB64_8_AVX_loop_1
	
	pop rbx
	pop rsi
	pop rdi
	pop rbp

	ret

JPSDR_HDRTools_Convert_RGB64_16toRGB64_8_AVX endp


;JPSDR_HDRTools_Convert_RGB64_16toRGB64_10_SSE2 proc src:dword,dst:dword,w:dword,h:dword,
;	src_pitch:dword,dst_pitch:dword
; src = rcx
; dst = rdx
; w = r8d
; h = r9d
JPSDR_HDRTools_Convert_RGB64_16toRGB64_10_SSE2 proc public frame

src_pitch equ qword ptr[rbp+48]
dst_pitch equ qword ptr[rbp+56]

	push rbp
	.pushreg rbp
	mov rbp,rsp
	push rdi
	.pushreg rdi
	push rsi
	.pushreg rsi
	push rbx
	.pushreg rbx
	.endprolog

	movdqa xmm1,XMMWORD ptr data_w_32

	mov rsi,rcx
	mov rdi,rdx
	mov ebx,r8d
	mov r10,src_pitch
	mov r11,dst_pitch
	shr ebx,1
	mov rdx,16

Convert_RGB64_16toRGB64_10_SSE2_1:
	mov ecx,ebx
	xor rax,rax
	or ecx,ecx
	jz short Convert_RGB64_16toRGB64_10_SSE2_3
	
Convert_RGB64_16toRGB64_10_SSE2_2:
	movdqa xmm0,XMMWORD ptr[rsi+rax]
	paddusw xmm0,xmm1
	psrlw xmm0,6
	movdqa XMMWORD ptr[rdi+rax],xmm0
	add rax,rdx
	loop Convert_RGB64_16toRGB64_10_SSE2_2
	
Convert_RGB64_16toRGB64_10_SSE2_3:
	test r8d,1
	jz short Convert_RGB64_16toRGB64_10_SSE2_4

	movq xmm0,qword ptr[rsi+rax]
	paddusw xmm0,xmm1
	psrlw xmm0,6
	movq qword ptr[rdi+rax],xmm0
	
Convert_RGB64_16toRGB64_10_SSE2_4:
	add rsi,r10
	add rdi,r11
	dec r9d
	jnz short Convert_RGB64_16toRGB64_10_SSE2_1
	
	pop rbx
	pop rsi
	pop rdi
	pop rbp

	ret

JPSDR_HDRTools_Convert_RGB64_16toRGB64_10_SSE2 endp


;JPSDR_HDRTools_Convert_RGB64_16toRGB64_10_AVX proc src:dword,dst:dword,w:dword,h:dword,
;	src_pitch:dword,dst_pitch:dword
; src = rcx
; dst = rdx
; w = r8d
; h = r9d
JPSDR_HDRTools_Convert_RGB64_16toRGB64_10_AVX proc public frame

src_pitch equ qword ptr[rbp+48]
dst_pitch equ qword ptr[rbp+56]

	push rbp
	.pushreg rbp
	mov rbp,rsp
	push rdi
	.pushreg rdi
	push rsi
	.pushreg rsi
	push rbx
	.pushreg rbx
	.endprolog

	vmovdqa xmm4,XMMWORD ptr data_w_32

	mov rsi,rcx
	mov rdi,rdx
	mov ebx,r8d
	mov r10,src_pitch
	mov r11,dst_pitch
	shr ebx,1
	mov rdx,64

Convert_RGB64_16toRGB64_10_AVX_loop_1:
	mov ecx,ebx
	xor rax,rax

	shr ecx,2
	jz short Convert_RGB64_16toRGB64_10_AVX_3
	
Convert_RGB64_16toRGB64_10_AVX_loop_2:
	vpaddusw xmm0,xmm4,XMMWORD ptr[rsi+rax]
	vpaddusw xmm1,xmm4,XMMWORD ptr[rsi+rax+16]
	vpaddusw xmm2,xmm4,XMMWORD ptr[rsi+rax+32]
	vpaddusw xmm3,xmm4,XMMWORD ptr[rsi+rax+48]
	vpsrlw xmm0,xmm0,6
	vpsrlw xmm1,xmm1,6
	vpsrlw xmm2,xmm2,6
	vpsrlw xmm3,xmm3,6
	vmovdqa XMMWORD ptr[rdi+rax],xmm0
	vmovdqa XMMWORD ptr[rdi+rax+16],xmm1
	vmovdqa XMMWORD ptr[rdi+rax+32],xmm2
	vmovdqa XMMWORD ptr[rdi+rax+48],xmm3
	add rax,rdx
	loop Convert_RGB64_16toRGB64_10_AVX_loop_2

Convert_RGB64_16toRGB64_10_AVX_3:
	test ebx,2
	jz short Convert_RGB64_16toRGB64_10_AVX_4

	vpaddusw xmm0,xmm4,XMMWORD ptr[rsi+rax]
	vpaddusw xmm1,xmm4,XMMWORD ptr[rsi+rax+16]
	vpsrlw xmm0,xmm0,6
	vpsrlw xmm1,xmm1,6
	vmovdqa XMMWORD ptr[rdi+rax],xmm0
	vmovdqa XMMWORD ptr[rdi+rax+16],xmm1
	add rax,32

Convert_RGB64_16toRGB64_10_AVX_4:
	test ebx,1
	jz short Convert_RGB64_16toRGB64_10_AVX_5

	vpaddusw xmm0,xmm4,XMMWORD ptr[rsi+rax]
	vpsrlw xmm0,xmm0,6
	vmovdqa XMMWORD ptr[rdi+rax],xmm0
	add rax,16
	
Convert_RGB64_16toRGB64_10_AVX_5:
	test r8d,1
	jz short Convert_RGB64_16toRGB64_10_AVX_6
	
	vmovq xmm0,qword ptr[rsi+rax]
	vpaddusw xmm0,xmm0,xmm4
	vpsrlw xmm0,xmm0,6
	vmovq qword ptr[rdi+rax],xmm0
	
Convert_RGB64_16toRGB64_10_AVX_6:
	add rsi,r10
	add rdi,r11
	dec r9d
	jnz Convert_RGB64_16toRGB64_10_AVX_loop_1
	
	pop rbx
	pop rsi
	pop rdi
	pop rbp

	ret

JPSDR_HDRTools_Convert_RGB64_16toRGB64_10_AVX endp


;JPSDR_HDRTools_Convert_RGB64_16toRGB64_12_SSE2 proc src:dword,dst:dword,w:dword,h:dword,
;	src_pitch:dword,dst_pitch:dword
; src = rcx
; dst = rdx
; w = r8d
; h = r9d
JPSDR_HDRTools_Convert_RGB64_16toRGB64_12_SSE2 proc public frame

src_pitch equ qword ptr[rbp+48]
dst_pitch equ qword ptr[rbp+56]

	push rbp
	.pushreg rbp
	mov rbp,rsp
	push rdi
	.pushreg rdi
	push rsi
	.pushreg rsi
	push rbx
	.pushreg rbx
	push r12
	.pushreg r12
	.endprolog

	movdqa xmm1,XMMWORD ptr data_w_8

	mov rsi,rcx
	mov rdi,rdx
	mov ebx,r8d
	mov r10,src_pitch
	mov r11,dst_pitch
	shr ebx,1
	mov rdx,16
	mov r12,1

Convert_RGB64_16toRGB64_12_SSE2_1:
	mov ecx,ebx
	xor rax,rax
	or ecx,ecx
	jz short Convert_RGB64_16toRGB64_12_SSE2_3

Convert_RGB64_16toRGB64_12_SSE2_2:
	movdqa xmm0,XMMWORD ptr[rsi+rax]
	paddusw xmm0,xmm1
	psrlw xmm0,4
	movdqa XMMWORD ptr[rdi+rax],xmm0
	add rax,rdx
	loop Convert_RGB64_16toRGB64_12_SSE2_2

Convert_RGB64_16toRGB64_12_SSE2_3:
	test r8d,r12d
	jz short Convert_RGB64_16toRGB64_12_SSE2_4

	movq xmm0,qword ptr[rsi+rax]
	paddusw xmm0,xmm1
	psrlw xmm0,4
	movq qword ptr[rdi+rax],xmm0

Convert_RGB64_16toRGB64_12_SSE2_4:
	add rsi,r10
	add rdi,r11
	dec r9d
	jnz short Convert_RGB64_16toRGB64_12_SSE2_1

	pop r12
	pop rbx
	pop rsi
	pop rdi
	pop rbp

	ret

JPSDR_HDRTools_Convert_RGB64_16toRGB64_12_SSE2 endp


;JPSDR_HDRTools_Convert_RGB64_16toRGB64_12_AVX proc src:dword,dst:dword,w:dword,h:dword,
;	src_pitch:dword,dst_pitch:dword
; src = rcx
; dst = rdx
; w = r8d
; h = r9d
JPSDR_HDRTools_Convert_RGB64_16toRGB64_12_AVX proc public frame

src_pitch equ qword ptr[rbp+48]
dst_pitch equ qword ptr[rbp+56]

	push rbp
	.pushreg rbp
	mov rbp,rsp
	push rdi
	.pushreg rdi
	push rsi
	.pushreg rsi
	push rbx
	.pushreg rbx
	push r12
	.pushreg r12
	.endprolog

	vmovdqa xmm4,XMMWORD ptr data_w_8

	mov rsi,rcx
	mov rdi,rdx
	mov ebx,r8d
	mov r10,src_pitch
	mov r11,dst_pitch
	shr ebx,1
	mov rdx,64

Convert_RGB64_16toRGB64_12_AVX_loop_1:
	mov ecx,ebx
	xor rax,rax

	shr ecx,2
	jz short Convert_RGB64_16toRGB64_12_AVX_3
	
Convert_RGB64_16toRGB64_12_AVX_loop_2:
	vpaddusw xmm0,xmm4,XMMWORD ptr[rsi+rax]
	vpaddusw xmm1,xmm4,XMMWORD ptr[rsi+rax+16]
	vpaddusw xmm2,xmm4,XMMWORD ptr[rsi+rax+32]
	vpaddusw xmm3,xmm4,XMMWORD ptr[rsi+rax+48]
	vpsrlw xmm0,xmm0,4
	vpsrlw xmm1,xmm1,4
	vpsrlw xmm2,xmm2,4
	vpsrlw xmm3,xmm3,4
	vmovdqa XMMWORD ptr[rdi+rax],xmm0
	vmovdqa XMMWORD ptr[rdi+rax+16],xmm1
	vmovdqa XMMWORD ptr[rdi+rax+32],xmm2
	vmovdqa XMMWORD ptr[rdi+rax+48],xmm3
	add rax,rdx
	loop Convert_RGB64_16toRGB64_12_AVX_loop_2

Convert_RGB64_16toRGB64_12_AVX_3:
	test ebx,2
	jz short Convert_RGB64_16toRGB64_12_AVX_4

	vpaddusw xmm0,xmm4,XMMWORD ptr[rsi+rax]
	vpaddusw xmm1,xmm4,XMMWORD ptr[rsi+rax+16]
	vpsrlw xmm0,xmm0,4
	vpsrlw xmm1,xmm1,4
	vmovdqa XMMWORD ptr[rdi+rax],xmm0
	vmovdqa XMMWORD ptr[rdi+rax+16],xmm1
	add rax,32

Convert_RGB64_16toRGB64_12_AVX_4:
	test ebx,1
	jz short Convert_RGB64_16toRGB64_12_AVX_5

	vpaddusw xmm0,xmm4,XMMWORD ptr[rsi+rax]
	vpsrlw xmm0,xmm0,4
	vmovdqa XMMWORD ptr[rdi+rax],xmm0
	add rax,16
	
Convert_RGB64_16toRGB64_12_AVX_5:
	test r8d,1
	jz short Convert_RGB64_16toRGB64_12_AVX_6
	
	vmovq xmm0,qword ptr[rsi+rax]
	vpaddusw xmm0,xmm0,xmm4
	vpsrlw xmm0,xmm0,4
	vmovq qword ptr[rdi+rax],xmm0
	
Convert_RGB64_16toRGB64_12_AVX_6:
	add rsi,r10
	add rdi,r11
	dec r9d
	jnz Convert_RGB64_16toRGB64_12_AVX_loop_1
	
	pop rbx
	pop rsi
	pop rdi
	pop rbp

	ret

JPSDR_HDRTools_Convert_RGB64_16toRGB64_12_AVX endp


;JPSDR_HDRTools_Scale_HLG_SSE2 proc src:dword,dst:dword,w4:dword,h:dword,src_pitch:dword,dst_pitch:dword,
;	Coeff:dword
; src = rcx
; dst = rdx
; w4 = r8d
; h = r9d

JPSDR_HDRTools_Scale_HLG_SSE2 proc public frame

src_pitch equ qword ptr[rbp+48]
dst_pitch equ qword ptr[rbp+56]
Coeff equ qword ptr[rbp+64]

	push rbp
	.pushreg rbp
	mov rbp,rsp
	push rsi
	.pushreg rsi
	push rbx
	.pushreg rbx
	.endprolog

	mov rsi,Coeff
	movss xmm4,dword ptr[rsi]
	shufps xmm4,xmm4,0
	movaps xmm5,XMMWORD ptr data_f_1

	mov rsi,rcx
	mov r10,src_pitch
	mov r11,dst_pitch
	mov rbx,64

Scale_HLG_SSE2_loop_1:
	xor rax,rax
	mov ecx,r8d

	shr rcx,2
	jz short Scale_HLG_SSE2_1

Scale_HLG_SSE2_loop_2:
	movaps xmm0,XMMWORD ptr[rsi+rax]
	movaps xmm1,XMMWORD ptr[rsi+rax+16]
	movaps xmm2,XMMWORD ptr[rsi+rax+32]
	movaps xmm3,XMMWORD ptr[rsi+rax+48]
	mulps xmm0,xmm4
	mulps xmm1,xmm4
	mulps xmm2,xmm4
	mulps xmm3,xmm4
	minps xmm0,xmm5
	minps xmm1,xmm5
	minps xmm2,xmm5
	minps xmm3,xmm5
	movdqa XMMWORD ptr[rdx+rax],xmm0
	movdqa XMMWORD ptr[rdx+rax+16],xmm1
	movdqa XMMWORD ptr[rdx+rax+32],xmm2
	movdqa XMMWORD ptr[rdx+rax+48],xmm3

	add rax,rbx
	loop Scale_HLG_SSE2_loop_2

Scale_HLG_SSE2_1:
	test r8d,2
	je short Scale_HLG_SSE2_2

	movaps xmm0,XMMWORD ptr[rsi+rax]
	movaps xmm1,XMMWORD ptr[rsi+rax+16]
	mulps xmm0,xmm4
	mulps xmm1,xmm4
	minps xmm0,xmm5
	minps xmm1,xmm5
	movdqa XMMWORD ptr[rdx+rax],xmm0
	movdqa XMMWORD ptr[rdx+rax+16],xmm1

	add rax,32

Scale_HLG_SSE2_2:
	test r8d,1
	je short Scale_HLG_SSE2_3

	movaps xmm0,XMMWORD ptr[rsi+rax]
	mulps xmm0,xmm4
	minps xmm0,xmm5
	movdqa XMMWORD ptr[rdx+rax],xmm0

Scale_HLG_SSE2_3:
	add rsi,r10
	add rdx,r11
	dec r9d
	jnz Scale_HLG_SSE2_loop_1
	
	pop rbx
	pop rsi
	pop rbp

	ret

JPSDR_HDRTools_Scale_HLG_SSE2 endp


;JPSDR_HDRTools_Scale_HLG_AVX proc src:dword,dst:dword,w8:dword,h:dword,src_pitch:dword,dst_pitch:dword,
;	Coeff:dword
; src = rcx
; dst = rdx
; w8 = r8d
; h = r9d

JPSDR_HDRTools_Scale_HLG_AVX proc public frame

src_pitch equ qword ptr[rbp+48]
dst_pitch equ qword ptr[rbp+56]
Coeff equ qword ptr[rbp+64]

	push rbp
	.pushreg rbp
	mov rbp,rsp
	push rsi
	.pushreg rsi
	push rbx
	.pushreg rbx
	.endprolog

	mov rsi,Coeff
	vbroadcastss ymm4,dword ptr[rsi]
	vmovaps ymm5,YMMWORD ptr data_f_1

	mov rsi,rcx
	mov r10,src_pitch
	mov r11,dst_pitch
	mov rbx,128

Scale_HLG_AVX_loop_1:
	xor rax,rax
	mov ecx,r8d

	shr rcx,2
	jz short Scale_HLG_AVX_1

Scale_HLG_AVX_loop_2:
	vmulps ymm0,ymm4,YMMWORD ptr[rsi+rax]
	vmulps ymm1,ymm4,YMMWORD ptr[rsi+rax+32]
	vmulps ymm2,ymm4,YMMWORD ptr[rsi+rax+64]
	vmulps ymm3,ymm4,YMMWORD ptr[rsi+rax+96]
	vminps ymm0,ymm0,ymm5
	vminps ymm1,ymm1,ymm5
	vminps ymm2,ymm2,ymm5
	vminps ymm3,ymm3,ymm5
	vmovdqa YMMWORD ptr[rdx+rax],ymm0
	vmovdqa YMMWORD ptr[rdx+rax+32],ymm1
	vmovdqa YMMWORD ptr[rdx+rax+64],ymm2
	vmovdqa YMMWORD ptr[rdx+rax+96],ymm3	

	add rax,rbx
	loop Scale_HLG_AVX_loop_2

Scale_HLG_AVX_1:
	test r8d,2
	jz short Scale_HLG_AVX_2

	vmulps ymm0,ymm4,YMMWORD ptr[rsi+rax]
	vmulps ymm1,ymm4,YMMWORD ptr[rsi+rax+32]
	vminps ymm0,ymm0,ymm5
	vminps ymm1,ymm1,ymm5
	vmovdqa YMMWORD ptr[rdx+rax],ymm0
	vmovdqa YMMWORD ptr[rdx+rax+32],ymm1

	add rax,64

Scale_HLG_AVX_2:
	test r8d,1
	jz short Scale_HLG_AVX_3

	vmulps ymm0,ymm4,YMMWORD ptr[rsi+rax]
	vminps ymm0,ymm0,ymm5
	vmovdqa YMMWORD ptr[rdx+rax],ymm0

Scale_HLG_AVX_3:
	add rsi,r10
	add rdx,r11
	dec r9d
	jnz Scale_HLG_AVX_loop_1
	
	vzeroupper
	
	pop rbx
	pop rsi
	pop rbp

	ret

JPSDR_HDRTools_Scale_HLG_AVX endp


;JPSDR_HDRTools_Scale_20_float_SSE2 proc src:dword,dst:dword,w4:dword,h:dword,src_pitch:dword,dst_pitch:dword
; src = rcx
; dst = rdx
; w4 = r8d
; h = r9d

JPSDR_HDRTools_Scale_20_float_SSE2 proc public frame

src_pitch equ qword ptr[rbp+48]
dst_pitch equ qword ptr[rbp+56]

	push rbp
	.pushreg rbp
	mov rbp,rsp
	push rsi
	.pushreg rsi
	push rbx
	.pushreg rbx
	.endprolog

	movaps xmm4,XMMWORD ptr data_f_1048575

	mov rsi,rcx
	mov r10,src_pitch
	mov r11,dst_pitch
	mov rbx,64

Scale_20_float_SSE2_loop_1:
	xor rax,rax
	mov ecx,r8d

	shr rcx,2
	jz short Scale_20_float_SSE2_1

Scale_20_float_SSE2_loop_2:
	movaps xmm0,XMMWORD ptr[rsi+rax]
	movaps xmm1,XMMWORD ptr[rsi+rax+16]
	movaps xmm2,XMMWORD ptr[rsi+rax+32]
	movaps xmm3,XMMWORD ptr[rsi+rax+46]
	mulps xmm0,xmm4
	mulps xmm1,xmm4
	mulps xmm2,xmm4
	mulps xmm3,xmm4
;	minps xmm0,xmm4
;	minps xmm1,xmm4
;	minps xmm2,xmm4
;	minps xmm3,xmm4
	cvtps2dq xmm0,xmm0
	cvtps2dq xmm1,xmm1
	cvtps2dq xmm2,xmm2
	cvtps2dq xmm3,xmm3
	movdqa XMMWORD ptr[rdx+rax],xmm0
	movdqa XMMWORD ptr[rdx+rax+16],xmm1
	movdqa XMMWORD ptr[rdx+rax+32],xmm2
	movdqa XMMWORD ptr[rdx+rax+46],xmm3

	add rax,rbx
	loop Scale_20_float_SSE2_loop_2

Scale_20_float_SSE2_1:
	test r8d,2
	js short Scale_20_float_SSE2_2

	movaps xmm0,XMMWORD ptr[rsi+rax]
	movaps xmm1,XMMWORD ptr[rsi+rax+16]
	mulps xmm0,xmm4
	mulps xmm1,xmm4
;	minps xmm0,xmm4
;	minps xmm1,xmm4
	cvtps2dq xmm0,xmm0
	cvtps2dq xmm1,xmm1
	movdqa XMMWORD ptr[rdx+rax],xmm0
	movdqa XMMWORD ptr[rdx+rax+16],xmm1

	add rax,32

Scale_20_float_SSE2_2:
	test r8d,1
	js short Scale_20_float_SSE2_3

	movaps xmm0,XMMWORD ptr[rsi+rax]
	mulps xmm0,xmm4
;	minps xmm0,xmm4
	cvtps2dq xmm0,xmm0
	movdqa XMMWORD ptr[rdx+rax],xmm0

Scale_20_float_SSE2_3:
	add rsi,r10
	add rdx,r11
	dec r9d
	jnz Scale_20_float_SSE2_loop_1
	
	pop rbx
	pop rsi
	pop rbp

	ret

JPSDR_HDRTools_Scale_20_float_SSE2 endp


;JPSDR_HDRTools_Scale_20_float_AVX proc src:dword,dst:dword,w8:dword,h:dword,src_pitch:dword,dst_pitch:dword
; src = rcx
; dst = rdx
; w8 = r8d
; h = r9d

JPSDR_HDRTools_Scale_20_float_AVX proc public frame

src_pitch equ qword ptr[rbp+48]
dst_pitch equ qword ptr[rbp+56]

	push rbp
	.pushreg rbp
	mov rbp,rsp
	push rsi
	.pushreg rsi
	push rbx
	.pushreg rbx
	.endprolog

	vmovaps ymm4,YMMWORD ptr data_f_1048575

	mov rsi,rcx
	mov r10,src_pitch
	mov r11,dst_pitch
	mov rbx,128

Scale_20_float_AVX_loop_1:
	xor rax,rax
	mov ecx,r8d

	shr rcx,2
	jz short Scale_20_float_AVX_1

Scale_20_float_AVX_loop_2:
	vmulps ymm0,ymm4,YMMWORD ptr[rsi+rax]
	vmulps ymm1,ymm4,YMMWORD ptr[rsi+rax+32]
	vmulps ymm2,ymm4,YMMWORD ptr[rsi+rax+64]
	vmulps ymm3,ymm4,YMMWORD ptr[rsi+rax+96]
;	vminps ymm0,ymm0,ymm4
;	vminps ymm1,ymm1,ymm4
;	vminps ymm2,ymm2,ymm4
;	vminps ymm3,ymm3,ymm4
	vcvtps2dq ymm0,ymm0
	vcvtps2dq ymm1,ymm1
	vcvtps2dq ymm2,ymm2
	vcvtps2dq ymm3,ymm3
	vmovdqa YMMWORD ptr[rdx+rax],ymm0
	vmovdqa YMMWORD ptr[rdx+rax+32],ymm1
	vmovdqa YMMWORD ptr[rdx+rax+64],ymm2
	vmovdqa YMMWORD ptr[rdx+rax+96],ymm3

	add rax,rbx
	loop Scale_20_float_AVX_loop_2

Scale_20_float_AVX_1:
	test r8d,2
	jz short Scale_20_float_AVX_2

	vmulps ymm0,ymm4,YMMWORD ptr[rsi+rax]
	vmulps ymm1,ymm4,YMMWORD ptr[rsi+rax+32]
;	vminps ymm0,ymm0,ymm4
;	vminps ymm1,ymm1,ymm4
	vcvtps2dq ymm0,ymm0
	vcvtps2dq ymm1,ymm1
	vmovdqa YMMWORD ptr[rdx+rax],ymm0
	vmovdqa YMMWORD ptr[rdx+rax+32],ymm1

	add rax,64

Scale_20_float_AVX_2:
	test r8d,1
	jz short Scale_20_float_AVX_3

	vmulps ymm0,ymm4,YMMWORD ptr[rsi+rax]
;	vminps ymm0,ymm0,ymm4
	vcvtps2dq ymm0,ymm0
	vmovdqa YMMWORD ptr[rdx+rax],ymm0

Scale_20_float_AVX_3:
	add rsi,r10
	add rdx,r11
	dec r9d
	jnz Scale_20_float_AVX_loop_1

	vzeroupper

	pop rbx
	pop rsi
	pop rbp

	ret

JPSDR_HDRTools_Scale_20_float_AVX endp


;JPSDR_HDRTools_Convert_RGBPStoPlaneY32F_SSE2 proc srcR:dword,srcG:dword,srcB:dword,dst:dword,w4:dword,h:dword,
;	src_pitch_R:dword,src_pitch_G:dword,src_pitch_B:dword,dst_pitch:dword,Coeff_R:dword,Coeff_G:dword,Coeff_B:dword
; srcR = rcx
; srcG = rdx
; srcB = r8
; dst = r9

JPSDR_HDRTools_Convert_RGBPStoPlaneY32F_SSE2 proc public frame

w4 equ dword ptr[rbp+48]
h equ dword ptr[rbp+56]
src_pitch_R equ qword ptr[rbp+64]
src_pitch_G equ qword ptr[rbp+72]
src_pitch_B equ qword ptr[rbp+80]
dst_pitch equ qword ptr[rbp+88]
Coeff_R equ qword ptr[rbp+96]
Coeff_G equ qword ptr[rbp+104]
Coeff_B equ qword ptr[rbp+112]

	push rbp
	.pushreg rbp
	mov rbp,rsp
	push rsi
	.pushreg rsi
	push rdi
	.pushreg rdi
	push rbx
	.pushreg rbx
	push r12
	.pushreg r12
	push r13
	.pushreg r13
	push r14
	.pushreg r14
	.endprolog	
	
	mov rsi,Coeff_R
	movss xmm3,dword ptr[rsi]
	shufps xmm3,xmm3,0
	mov rsi,Coeff_G
	movss xmm4,dword ptr[rsi]
	shufps xmm4,xmm4,0
	mov rsi,Coeff_B
	movss xmm5,dword ptr[rsi]
	shufps xmm5,xmm5,0
	
	mov rdi,r9
	mov rsi,rcx		; srcR
	mov r9,rdx		; srcG
	mov r10d,h
	mov r11,src_pitch_R
	mov r12,src_pitch_G
	mov r13,src_pitch_B
	mov r14,dst_pitch
	
	mov ebx,w4
	mov rdx,16
	
Convert_RGBPStoPlaneY32F_SSE2_1:
	xor rax,rax
	mov ecx,ebx
Convert_RGBPStoPlaneY32F_SSE2_2:	
	movaps xmm0,XMMWORD ptr [rsi+rax]
	movaps xmm1,XMMWORD ptr [r9+rax]
	movaps xmm2,XMMWORD ptr [r8+rax]
	mulps xmm0,xmm3
	mulps xmm1,xmm4
	mulps xmm2,xmm5
	addps xmm0,xmm1
	addps xmm0,xmm2
	movdqa XMMWORD ptr [rdi+rax],xmm0
	
	add rax,rdx
	loop Convert_RGBPStoPlaneY32F_SSE2_2
	
	add rsi,r11
	add r9,r12
	add r8,r13
	add rdi,r14
	dec r10d
	jnz short Convert_RGBPStoPlaneY32F_SSE2_1
	
	pop r14
	pop r13
	pop r12
	pop rbx
	pop rdi
	pop rsi
	pop rbp

	ret

JPSDR_HDRTools_Convert_RGBPStoPlaneY32F_SSE2 endp	


;JPSDR_HDRTools_Convert_RGBPStoPlaneY32D_SSE2 proc srcR:dword,srcG:dword,srcB:dword,dst:dword,w4:dword,h:dword,
;	src_pitch_R:dword,src_pitch_G:dword,src_pitch_B:dword,dst_pitch:dword,Coeff_R:dword,Coeff_G:dword,Coeff_B:dword
; srcR = rcx
; srcG = rdx
; srcB = r8
; dst = r9

JPSDR_HDRTools_Convert_RGBPStoPlaneY32D_SSE2 proc public frame

w4 equ dword ptr[rbp+48]
h equ dword ptr[rbp+56]
src_pitch_R equ qword ptr[rbp+64]
src_pitch_G equ qword ptr[rbp+72]
src_pitch_B equ qword ptr[rbp+80]
dst_pitch equ qword ptr[rbp+88]
Coeff_R equ qword ptr[rbp+96]
Coeff_G equ qword ptr[rbp+104]
Coeff_B equ qword ptr[rbp+112]

	push rbp
	.pushreg rbp
	mov rbp,rsp
	push rsi
	.pushreg rsi
	push rdi
	.pushreg rdi
	push rbx
	.pushreg rbx
	push r12
	.pushreg r12
	push r13
	.pushreg r13
	push r14
	.pushreg r14
	sub rsp,16
	.allocstack 16
	movdqa XMMWORD ptr[rsp],xmm6
	.savexmm128 xmm6,0	
	.endprolog	
	
	mov rsi,Coeff_R
	movss xmm3,dword ptr[rsi]
	shufps xmm3,xmm3,0
	mov rsi,Coeff_G
	movss xmm4,dword ptr[rsi]
	shufps xmm4,xmm4,0
	mov rsi,Coeff_B
	movss xmm5,dword ptr[rsi]
	shufps xmm5,xmm5,0
	movaps xmm6,XMMWORD ptr data_f_1048575
	
	mov rdi,r9
	mov rsi,rcx		; srcR
	mov r9,rdx		; srcG
	mov r10d,h
	mov r11,src_pitch_R
	mov r12,src_pitch_G
	mov r13,src_pitch_B
	mov r14,dst_pitch
	
	mov ebx,w4
	mov rdx,16
	
Convert_RGBPStoPlaneY32D_SSE2_1:
	xor rax,rax
	mov ecx,ebx
Convert_RGBPStoPlaneY32D_SSE2_2:	
	movaps xmm0,XMMWORD ptr [rsi+rax]
	movaps xmm1,XMMWORD ptr [r9+rax]
	movaps xmm2,XMMWORD ptr [r8+rax]
	mulps xmm0,xmm3
	mulps xmm1,xmm4
	mulps xmm2,xmm5
	addps xmm0,xmm1
	addps xmm0,xmm2
	mulps xmm0,xmm6
	cvtps2dq xmm0,xmm0	
	movdqa XMMWORD ptr [rdi+rax],xmm0
	
	add rax,rdx
	loop Convert_RGBPStoPlaneY32D_SSE2_2
	
	add rsi,r11
	add r9,r12
	add r8,r13
	add rdi,r14
	dec r10d
	jnz short Convert_RGBPStoPlaneY32D_SSE2_1
	
	movdqa xmm6,XMMWORD ptr[rsp]
	add rsp,16
	
	pop r14
	pop r13
	pop r12
	pop rbx
	pop rdi
	pop rsi
	pop rbp

	ret

JPSDR_HDRTools_Convert_RGBPStoPlaneY32D_SSE2 endp	


;JPSDR_HDRTools_Convert_RGBPStoPlaneY32F_AVX proc srcR:dword,srcG:dword,srcB:dword,dst:dword,w8:dword,h:dword,
;	src_pitch_R:dword,src_pitch_G:dword,src_pitch_B:dword,dst_pitch:dword,Coeff_R:dword,Coeff_G:dword,Coeff_B:dword
; srcR = rcx
; srcG = rdx
; srcB = r8
; dst = r9

JPSDR_HDRTools_Convert_RGBPStoPlaneY32F_AVX proc public frame

w8 equ dword ptr[rbp+48]
h equ dword ptr[rbp+56]
src_pitch_R equ qword ptr[rbp+64]
src_pitch_G equ qword ptr[rbp+72]
src_pitch_B equ qword ptr[rbp+80]
dst_pitch equ qword ptr[rbp+88]
Coeff_R equ qword ptr[rbp+96]
Coeff_G equ qword ptr[rbp+104]
Coeff_B equ qword ptr[rbp+112]

	push rbp
	.pushreg rbp
	mov rbp,rsp
	push rsi
	.pushreg rsi
	push rdi
	.pushreg rdi
	push rbx
	.pushreg rbx
	push r12
	.pushreg r12
	push r13
	.pushreg r13
	push r14
	.pushreg r14
	.endprolog	
	
	mov rsi,Coeff_R
	vbroadcastss ymm3,dword ptr[rsi]
	mov rsi,Coeff_G
	vbroadcastss ymm4,dword ptr[rsi]
	mov rsi,Coeff_B
	vbroadcastss ymm5,dword ptr[rsi]
	
	mov rdi,r9
	mov rsi,rcx		; srcR
	mov r9,rdx		; srcG
	mov r10d,h
	mov r11,src_pitch_R
	mov r12,src_pitch_G
	mov r13,src_pitch_B
	mov r14,dst_pitch
	
	mov ebx,w8
	mov rdx,32
	
Convert_RGBPStoPlaneY32F_AVX_1:
	xor rax,rax
	mov ecx,ebx
Convert_RGBPStoPlaneY32F_AVX_2:	
	vmulps ymm0,ymm3,YMMWORD ptr [rsi+rax]
	vmulps ymm1,ymm4,YMMWORD ptr [r9+rax]
	vmulps ymm2,ymm5,YMMWORD ptr [r8+rax]
	vaddps ymm0,ymm0,ymm1
	vaddps ymm0,ymm0,ymm2
	vmovdqa YMMWORD ptr [rdi+rax],ymm0
	
	add rax,rdx
	loop Convert_RGBPStoPlaneY32F_AVX_2
	
	add rsi,r11
	add r9,r12
	add r8,r13
	add rdi,r14
	dec r10d
	jnz short Convert_RGBPStoPlaneY32F_AVX_1
	
	vzeroupper
	
	pop r14
	pop r13
	pop r12
	pop rbx
	pop rdi
	pop rsi
	pop rbp

	ret

JPSDR_HDRTools_Convert_RGBPStoPlaneY32F_AVX endp


;JPSDR_HDRTools_Convert_RGBPStoPlaneY32D_AVX proc srcR:dword,srcG:dword,srcB:dword,dst:dword,w8:dword,h:dword,
;	src_pitch_R:dword,src_pitch_G:dword,src_pitch_B:dword,dst_pitch:dword,Coeff_R:dword,Coeff_G:dword,Coeff_B:dword
; srcR = rcx
; srcG = rdx
; srcB = r8
; dst = r9

JPSDR_HDRTools_Convert_RGBPStoPlaneY32D_AVX proc public frame

w8 equ dword ptr[rbp+48]
h equ dword ptr[rbp+56]
src_pitch_R equ qword ptr[rbp+64]
src_pitch_G equ qword ptr[rbp+72]
src_pitch_B equ qword ptr[rbp+80]
dst_pitch equ qword ptr[rbp+88]
Coeff_R equ qword ptr[rbp+96]
Coeff_G equ qword ptr[rbp+104]
Coeff_B equ qword ptr[rbp+112]

	push rbp
	.pushreg rbp
	mov rbp,rsp
	push rsi
	.pushreg rsi
	push rdi
	.pushreg rdi
	push rbx
	.pushreg rbx
	push r12
	.pushreg r12
	push r13
	.pushreg r13
	push r14
	.pushreg r14
	sub rsp,16
	.allocstack 16
	vmovdqa XMMWORD ptr[rsp],xmm6
	.savexmm128 xmm6,0	
	.endprolog	
	
	mov rsi,Coeff_R
	vbroadcastss ymm3,dword ptr[rsi]
	mov rsi,Coeff_G
	vbroadcastss ymm4,dword ptr[rsi]
	mov rsi,Coeff_B
	vbroadcastss ymm5,dword ptr[rsi]
	vmovaps ymm6,YMMWORD ptr data_f_1048575
	
	mov rdi,r9
	mov rsi,rcx		; srcR
	mov r9,rdx		; srcG
	mov r10d,h
	mov r11,src_pitch_R
	mov r12,src_pitch_G
	mov r13,src_pitch_B
	mov r14,dst_pitch
	
	mov ebx,w8
	mov rdx,32
	
Convert_RGBPStoPlaneY32D_AVX_1:
	xor rax,rax
	mov ecx,ebx
Convert_RGBPStoPlaneY32D_AVX_2:	
	vmulps ymm0,ymm3,YMMWORD ptr [rsi+rax]
	vmulps ymm1,ymm4,YMMWORD ptr [r9+rax]
	vmulps ymm2,ymm5,YMMWORD ptr [r8+rax]
	vaddps ymm0,ymm0,ymm1
	vaddps ymm0,ymm0,ymm2
	vmulps ymm0,ymm0,ymm6
	vcvtps2dq ymm0,ymm0
	vmovdqa YMMWORD ptr [rdi+rax],ymm0
	
	add rax,rdx
	loop Convert_RGBPStoPlaneY32D_AVX_2
	
	add rsi,r11
	add r9,r12
	add r8,r13
	add rdi,r14
	dec r10d
	jnz short Convert_RGBPStoPlaneY32D_AVX_1
	
	vmovdqa xmm6,XMMWORD ptr[rsp]
	add rsp,16

	vzeroupper
	
	pop r14
	pop r13
	pop r12
	pop rbx
	pop rdi
	pop rsi
	pop rbp

	ret

JPSDR_HDRTools_Convert_RGBPStoPlaneY32D_AVX endp


;JPSDR_HDRTools_Convert_16_RGB64_HLG_OOTF_SSE41 proc dst:dword,srcY:dword,w:dword,h:dword,dst_pitch:dword,src_pitchY:dword
; dst = rcx
; srcY = rdx
; w = r8d
; h = r9d
	
JPSDR_HDRTools_Convert_16_RGB64_HLG_OOTF_SSE41 proc public frame	

dst_pitch equ qword ptr[rbp+48]
src_pitchY equ qword ptr[rbp+56]

	push rbp
	.pushreg rbp
	mov rbp,rsp
	push rsi
	.pushreg rsi
	push rdi
	.pushreg rdi
	push rbx
	.pushreg rbx
	push r12
	.pushreg r12
	.endprolog	
	
	mov rdi,rcx
	mov rsi,rdx
	mov r10d,r8d
	mov r11,dst_pitch
	mov r12,src_pitchY
	mov rdx,8
	shr r10d,1
	mov rbx,1
	pxor xmm4,xmm4
	
Convert_16_RGB64_HLG_OOTF_SSE41_1:
	mov ecx,r10d
	xor rax,rax
	or ecx,ecx
	jz short Convert_16_RGB64_HLG_OOTF_SSE41_3
	
Convert_16_RGB64_HLG_OOTF_SSE41_2:
	movss xmm0,dword ptr[rsi+rax]
	movss xmm1,dword ptr[rsi+rax+4]
	shufps xmm0,xmm0,0
	shufps xmm1,xmm1,0	
	movdqa xmm2,XMMWORD ptr[rdi+2*rax]
	movdqa xmm3,xmm2
	punpcklwd xmm2,xmm4
	punpckhwd xmm3,xmm4
	cvtdq2ps xmm2,xmm2
	cvtdq2ps xmm3,xmm3
	mulps xmm2,xmm0
	mulps xmm3,xmm1
	cvtps2dq xmm2,xmm2
	cvtps2dq xmm3,xmm3
	packusdw xmm2,xmm3
	movdqa XMMWORD ptr[rdi+2*rax],xmm2
	
	add rax,rdx
	loop Convert_16_RGB64_HLG_OOTF_SSE41_2
	
Convert_16_RGB64_HLG_OOTF_SSE41_3:
	test r8d,ebx
	jz short Convert_16_RGB64_HLG_OOTF_SSE41_4
	
	movss xmm0,dword ptr[rsi+rax]
	shufps xmm0,xmm0,0
	movq xmm2,qword ptr[rdi+2*rax]
	punpcklwd xmm2,xmm4
	cvtdq2ps xmm2,xmm2
	mulps xmm2,xmm0
	cvtps2dq xmm2,xmm2
	packusdw xmm2,xmm2
	movq qword ptr[rdi+2*rax],xmm2
	
Convert_16_RGB64_HLG_OOTF_SSE41_4:
	add rdi,r11
	add rsi,r12
	dec r9d
	jnz Convert_16_RGB64_HLG_OOTF_SSE41_1
	
	pop r12
	pop rbx
	pop rdi
	pop rsi
	pop rbp

	ret

JPSDR_HDRTools_Convert_16_RGB64_HLG_OOTF_SSE41 endp


;JPSDR_HDRTools_Convert_16_RGB64_HLG_OOTF_AVX proc dst:dword,srcY:dword,w:dword,h:dword,dst_pitch:dword,src_pitchY:dword
; dst = rcx
; srcY = rdx
; w = r8d
; h = r9d
	
JPSDR_HDRTools_Convert_16_RGB64_HLG_OOTF_AVX proc public frame	

dst_pitch equ qword ptr[rbp+48]
src_pitchY equ qword ptr[rbp+56]

	push rbp
	.pushreg rbp
	mov rbp,rsp
	push rsi
	.pushreg rsi
	push rdi
	.pushreg rdi
	push rbx
	.pushreg rbx
	push r12
	.pushreg r12
	.endprolog	
	
	mov rdi,rcx
	mov rsi,rdx
	mov r10d,r8d
	mov r11,dst_pitch
	mov r12,src_pitchY
	mov rdx,8
	shr r10d,1
	mov rbx,1
	vpxor xmm4,xmm4,xmm4
	
Convert_16_RGB64_HLG_OOTF_AVX_1:
	mov ecx,r10d
	xor rax,rax
	or ecx,ecx
	jz short Convert_16_RGB64_HLG_OOTF_AVX_3
	
Convert_16_RGB64_HLG_OOTF_AVX_2:
	vbroadcastss xmm0,dword ptr[rsi+rax]
	vbroadcastss xmm1,dword ptr[rsi+rax+4]
	vmovdqa xmm2,XMMWORD ptr[rdi+2*rax]
	vinsertf128 ymm0,ymm0,xmm1,1
	vpunpckhwd xmm3,xmm2,xmm4
	vpunpcklwd xmm2,xmm2,xmm4
	vinsertf128 ymm2,ymm2,xmm3,1
	vcvtdq2ps ymm2,ymm2
	vmulps ymm2,ymm2,ymm0
	vcvtps2dq ymm2,ymm2
	vextractf128 xmm3,ymm2,1
	vpackusdw xmm2,xmm2,xmm3
	vmovdqa XMMWORD ptr[rdi+2*rax],xmm2
	
	add rax,rdx
	loop Convert_16_RGB64_HLG_OOTF_AVX_2
	
Convert_16_RGB64_HLG_OOTF_AVX_3:
	test r8d,ebx
	jz short Convert_16_RGB64_HLG_OOTF_AVX_4
	
	vbroadcastss xmm0,dword ptr[rsi+rax]
	vmovq xmm2,qword ptr[rdi+2*rax]
	vpunpcklwd xmm2,xmm2,xmm4
	vcvtdq2ps xmm2,xmm2
	vmulps xmm2,xmm2,xmm0
	vcvtps2dq xmm2,xmm2
	vpackusdw xmm2,xmm2,xmm2
	vmovq qword ptr[rdi+2*rax],xmm2
	
Convert_16_RGB64_HLG_OOTF_AVX_4:
	add rdi,r11
	add rsi,r12
	dec r9d
	jnz Convert_16_RGB64_HLG_OOTF_AVX_1
	
	vzeroupper
	
	pop r12
	pop rbx
	pop rdi
	pop rsi
	pop rbp

	ret

JPSDR_HDRTools_Convert_16_RGB64_HLG_OOTF_AVX endp


;JPSDR_HDRTools_Convert_RGBPS_HLG_OOTF_SSE2 proc dstR:dword,dstG:dword,dstB:dword,srcY:dword,w4:dword,h:dword,
;	dst_pitchR:dword,dst_pitchG:dword,dst_pitchB:dword,src_pitchY:dword
; dstR = rcx
; dstG = rdx
; dstB = r8
; srcY = r9
	
JPSDR_HDRTools_Convert_RGBPS_HLG_OOTF_SSE2 proc public frame	

w4 equ dword ptr[rbp+48]
h equ dword ptr[rbp+56]
dst_pitch_R equ qword ptr[rbp+64]
dst_pitch_G equ qword ptr[rbp+72]
dst_pitch_B equ qword ptr[rbp+80]
src_pitchY equ qword ptr[rbp+88]

	push rbp
	.pushreg rbp
	mov rbp,rsp
	push rsi
	.pushreg rsi
	push rbx
	.pushreg rbx
	push r12
	.pushreg r12
	push r13
	.pushreg r13
	push r14
	.pushreg r14
	push r15
	.pushreg r15
	.endprolog	
	
	mov rsi,r9		; srcY
	mov r9,rcx		; dstR
	mov r10,rdx		; dstG
	
	mov r11d,h
	mov r12,dst_pitch_R
	mov r13,dst_pitch_G
	mov r14,dst_pitch_B
	mov r15,src_pitchY
	
	mov ebx,w4
	mov rdx,16
	
Convert_RGBPS_HLG_OOTF_SSE2_1:
	xor rax,rax
	mov ecx,ebx
Convert_RGBPS_HLG_OOTF_SSE2_2:
	movaps xmm0,XMMWORD ptr[rsi+rax]
	movaps xmm1,XMMWORD ptr[r9+rax]
	movaps xmm2,XMMWORD ptr[r10+rax]
	movaps xmm3,XMMWORD ptr[r8+rax]
	mulps xmm1,xmm0
	mulps xmm2,xmm0
	mulps xmm3,xmm0
	movaps XMMWORD ptr[r9+rax],xmm1
	movaps XMMWORD ptr[r10+rax],xmm2
	movaps XMMWORD ptr[r8+rax],xmm3
	
	add rax,rdx
	loop Convert_RGBPS_HLG_OOTF_SSE2_2
	
	add r9,r12
	add r10,r13
	add r8,r14
	add rsi,r15
	dec r11d
	
	jnz short Convert_RGBPS_HLG_OOTF_SSE2_1
	
	pop r15
	pop r14
	pop r13
	pop r12
	pop rbx
	pop rsi
	pop rbp

	ret

JPSDR_HDRTools_Convert_RGBPS_HLG_OOTF_SSE2 endp


;JPSDR_HDRTools_Convert_RGBPS_HLG_OOTF_AVX proc dstR:dword,dstG:dword,dstB:dword,srcY:dword,w8:dword,h:dword,
;	dst_pitchR:dword,dst_pitchG:dword,dst_pitchB:dword,src_pitchY:dword
; dstR = rcx
; dstG = rdx
; dstB = r8
; srcY = r9
	
JPSDR_HDRTools_Convert_RGBPS_HLG_OOTF_AVX proc public frame	

w8 equ dword ptr[rbp+48]
h equ dword ptr[rbp+56]
dst_pitch_R equ qword ptr[rbp+64]
dst_pitch_G equ qword ptr[rbp+72]
dst_pitch_B equ qword ptr[rbp+80]
src_pitchY equ qword ptr[rbp+88]

	push rbp
	.pushreg rbp
	mov rbp,rsp
	push rsi
	.pushreg rsi
	push rbx
	.pushreg rbx
	push r12
	.pushreg r12
	push r13
	.pushreg r13
	push r14
	.pushreg r14
	push r15
	.pushreg r15
	.endprolog	
	
	mov rsi,r9		; srcY
	mov r9,rcx		; dstR
	mov r10,rdx		; dstG
	
	mov r11d,h
	mov r12,dst_pitch_R
	mov r13,dst_pitch_G
	mov r14,dst_pitch_B
	mov r15,src_pitchY
	
	mov ebx,w8
	mov rdx,32
	
Convert_RGBPS_HLG_OOTF_AVX_1:
	xor rax,rax
	mov ecx,ebx
Convert_RGBPS_HLG_OOTF_AVX_2:
	vmovaps ymm0,YMMWORD ptr[rsi+rax]
	vmulps ymm1,ymm0,YMMWORD ptr[r9+rax]
	vmulps ymm2,ymm0,YMMWORD ptr[r10+rax]
	vmulps ymm3,ymm0,YMMWORD ptr[r8+rax]
	vmovaps YMMWORD ptr[r9+rax],ymm1
	vmovaps YMMWORD ptr[r10+rax],ymm2
	vmovaps YMMWORD ptr[r8+rax],ymm3
	
	add rax,rdx
	loop Convert_RGBPS_HLG_OOTF_AVX_2
	
	add r9,r12
	add r10,r13
	add r8,r14
	add rsi,r15
	dec r11d
	
	jnz short Convert_RGBPS_HLG_OOTF_AVX_1
	
	vzeroupper
	
	pop r15
	pop r14
	pop r13
	pop r12
	pop rbx
	pop rsi
	pop rbp

	ret

JPSDR_HDRTools_Convert_RGBPS_HLG_OOTF_AVX endp


;JPSDR_HDRTools_Convert_RGBPS_HLG_OOTF_Scale_SSE2 proc dstR:dword,dstG:dword,dstB:dword,srcY:dword,w4:dword,h:dword,
;	dst_pitchR:dword,dst_pitchG:dword,dst_pitchB:dword,src_pitchY:dword
; dstR = rcx
; dstG = rdx
; dstB = r8
; srcY = r9
	
JPSDR_HDRTools_Convert_RGBPS_HLG_OOTF_Scale_SSE2 proc public frame	

w4 equ dword ptr[rbp+48]
h equ dword ptr[rbp+56]
dst_pitch_R equ qword ptr[rbp+64]
dst_pitch_G equ qword ptr[rbp+72]
dst_pitch_B equ qword ptr[rbp+80]
src_pitchY equ qword ptr[rbp+88]

	push rbp
	.pushreg rbp
	mov rbp,rsp
	push rsi
	.pushreg rsi
	push rbx
	.pushreg rbx
	push r12
	.pushreg r12
	push r13
	.pushreg r13
	push r14
	.pushreg r14
	push r15
	.pushreg r15
	.endprolog	
	
	mov rsi,r9		; srcY
	mov r9,rcx		; dstR
	mov r10,rdx		; dstG
	
	mov r11d,h
	mov r12,dst_pitch_R
	mov r13,dst_pitch_G
	mov r14,dst_pitch_B
	mov r15,src_pitchY
	movaps xmm4,XMMWORD ptr data_f_1
	
	mov ebx,w4
	mov rdx,16
	
Convert_RGBPS_HLG_OOTF_Scale_SSE2_1:
	xor rax,rax
	mov ecx,ebx
Convert_RGBPS_HLG_OOTF_Scale_SSE2_2:
	movaps xmm0,XMMWORD ptr[rsi+rax]
	movaps xmm1,XMMWORD ptr[r9+rax]
	movaps xmm2,XMMWORD ptr[r10+rax]
	movaps xmm3,XMMWORD ptr[r8+rax]
	mulps xmm1,xmm0
	mulps xmm2,xmm0
	mulps xmm3,xmm0
	minps xmm1,xmm4
	minps xmm2,xmm4
	minps xmm3,xmm4
	movaps XMMWORD ptr[r9+rax],xmm1
	movaps XMMWORD ptr[r10+rax],xmm2
	movaps XMMWORD ptr[r8+rax],xmm3
	
	add rax,rdx
	loop Convert_RGBPS_HLG_OOTF_Scale_SSE2_2
	
	add r9,r12
	add r10,r13
	add r8,r14
	add rsi,r15
	dec r11d
	
	jnz short Convert_RGBPS_HLG_OOTF_Scale_SSE2_1
	
	pop r15
	pop r14
	pop r13
	pop r12
	pop rbx
	pop rsi
	pop rbp

	ret

JPSDR_HDRTools_Convert_RGBPS_HLG_OOTF_Scale_SSE2 endp


;JPSDR_HDRTools_Convert_RGBPS_HLG_OOTF_Scale_AVX proc dstR:dword,dstG:dword,dstB:dword,srcY:dword,w8:dword,h:dword,
;	dst_pitchR:dword,dst_pitchG:dword,dst_pitchB:dword,src_pitchY:dword
; dstR = rcx
; dstG = rdx
; dstB = r8
; srcY = r9
	
JPSDR_HDRTools_Convert_RGBPS_HLG_OOTF_Scale_AVX proc public frame	

w8 equ dword ptr[rbp+48]
h equ dword ptr[rbp+56]
dst_pitch_R equ qword ptr[rbp+64]
dst_pitch_G equ qword ptr[rbp+72]
dst_pitch_B equ qword ptr[rbp+80]
src_pitchY equ qword ptr[rbp+88]

	push rbp
	.pushreg rbp
	mov rbp,rsp
	push rsi
	.pushreg rsi
	push rbx
	.pushreg rbx
	push r12
	.pushreg r12
	push r13
	.pushreg r13
	push r14
	.pushreg r14
	push r15
	.pushreg r15
	.endprolog	
	
	mov rsi,r9		; srcY
	mov r9,rcx		; dstR
	mov r10,rdx		; dstG
	
	mov r11d,h
	mov r12,dst_pitch_R
	mov r13,dst_pitch_G
	mov r14,dst_pitch_B
	mov r15,src_pitchY
	vmovaps ymm4,YMMWORD ptr data_f_1
	
	mov ebx,w8
	mov rdx,32
	
Convert_RGBPS_HLG_OOTF_Scale_AVX_1:
	xor rax,rax
	mov ecx,ebx
Convert_RGBPS_HLG_OOTF_Scale_AVX_2:
	vmovaps ymm0,YMMWORD ptr[rsi+rax]
	vmulps ymm1,ymm0,YMMWORD ptr[r9+rax]
	vmulps ymm2,ymm0,YMMWORD ptr[r10+rax]
	vmulps ymm3,ymm0,YMMWORD ptr[r8+rax]
	vminps ymm1,ymm1,ymm4
	vminps ymm2,ymm2,ymm4
	vminps ymm3,ymm3,ymm4
	vmovaps YMMWORD ptr[r9+rax],ymm1
	vmovaps YMMWORD ptr[r10+rax],ymm2
	vmovaps YMMWORD ptr[r8+rax],ymm3
	
	add rax,rdx
	loop Convert_RGBPS_HLG_OOTF_Scale_AVX_2
	
	add r9,r12
	add r10,r13
	add r8,r14
	add rsi,r15
	dec r11d
	
	jnz short Convert_RGBPS_HLG_OOTF_Scale_AVX_1
	
	vzeroupper
	
	pop r15
	pop r14
	pop r13
	pop r12
	pop rbx
	pop rsi
	pop rbp

	ret

JPSDR_HDRTools_Convert_RGBPS_HLG_OOTF_Scale_AVX endp


;***************************************************
;**           XYZ/HDR/SDR functions               **
;***************************************************


;JPSDR_HDRTools_Scale_20_XYZ_SSE2 proc src:dword,dst:dword,w4:dword,h:dword,src_pitch:dword,dst_pitch:dword,
;	ValMin:dword,Coeff:dword
; src = rcx
; dst = rdx
; w4 = r8d
; h = r9d

JPSDR_HDRTools_Scale_20_XYZ_SSE2 proc public frame

src_pitch equ qword ptr[rbp+48]
dst_pitch equ qword ptr[rbp+56]
ValMin equ qword ptr[rbp+64]
Coeff equ qword ptr[rbp+72]

	push rbp
	.pushreg rbp
	mov rbp,rsp
	push rsi
	.pushreg rsi
	push rbx
	.pushreg rbx
	.endprolog

	mov rsi,ValMin
	movss xmm1,dword ptr[rsi]
	mov rsi,Coeff
	movss xmm2,dword ptr[rsi]
	shufps xmm1,xmm1,0
	shufps xmm2,xmm2,0
	
	movaps xmm3,XMMWORD ptr data_f_1048575
	movaps xmm4,XMMWORD ptr data_f_0
	mulps xmm2,xmm3
	
	mov rsi,rcx
	mov r10,src_pitch
	mov r11,dst_pitch
	mov rbx,16
	
Scale_20_XYZ_SSE2_1:
	xor rax,rax
	mov ecx,r8d
Scale_20_XYZ_SSE2_2:
	movaps xmm0,XMMWORD ptr[rsi+rax]
	addps xmm0,xmm1
	mulps xmm0,xmm2
	minps xmm0,xmm3
	maxps xmm0,xmm4
	cvtps2dq xmm0,xmm0
	movdqa XMMWORD ptr[rdx+rax],xmm0
	
	add rax,rbx
	loop Scale_20_XYZ_SSE2_2
	
	add rsi,r10
	add rdx,r11
	dec r9d
	jnz short Scale_20_XYZ_SSE2_1
	
	pop rbx
	pop rsi
	pop rbp

	ret

JPSDR_HDRTools_Scale_20_XYZ_SSE2 endp


;JPSDR_HDRTools_Scale_20_XYZ_SSE41 proc src:dword,dst:dword,w4:dword,h:dword,src_pitch:dword,dst_pitch:dword,
;	ValMin:dword,Coeff:dword
; src = rcx
; dst = rdx
; w4 = r8d
; h = r9d

JPSDR_HDRTools_Scale_20_XYZ_SSE41 proc public frame

src_pitch equ qword ptr[rbp+48]
dst_pitch equ qword ptr[rbp+56]
ValMin equ qword ptr[rbp+64]
Coeff equ qword ptr[rbp+72]

	push rbp
	.pushreg rbp
	mov rbp,rsp
	push rsi
	.pushreg rsi
	push rbx
	.pushreg rbx
	.endprolog

	mov rsi,ValMin
	movss xmm1,dword ptr[rsi]
	shufps xmm1,xmm1,0
	mov rsi,Coeff
	movss xmm2,dword ptr[rsi]
	shufps xmm2,xmm2,0
	
	movdqa xmm3,XMMWORD ptr data_dw_1048575
	movdqa xmm4,XMMWORD ptr data_dw_0
	mulps xmm2,XMMWORD ptr data_f_1048575
	
	mov rsi,rcx
	mov r10,src_pitch
	mov r11,dst_pitch
	mov rbx,16
	
Scale_20_XYZ_SSE41_1:
	xor rax,rax
	mov ecx,r8d
Scale_20_XYZ_SSE41_2:
	movaps xmm0,XMMWORD ptr[rsi+rax]
	addps xmm0,xmm1
	mulps xmm0,xmm2
	cvtps2dq xmm0,xmm0
	pminsd xmm0,xmm3
	pmaxsd xmm0,xmm4
	movdqa XMMWORD ptr[rdx+rax],xmm0
	
	add rax,rbx
	loop Scale_20_XYZ_SSE41_2
	
	add rsi,r10
	add rdx,r11
	dec r9d
	jnz short Scale_20_XYZ_SSE41_1
	
	pop rbx
	pop rsi
	pop rbp

	ret

JPSDR_HDRTools_Scale_20_XYZ_SSE41 endp


;JPSDR_HDRTools_Scale_20_XYZ_AVX proc src:dword,dst:dword,w8:dword,h:dword,src_pitch:dword,dst_pitch:dword,
;	ValMin:dword,Coeff:dword
; src = rcx
; dst = rdx
; w8 = r8d
; h = r9d

JPSDR_HDRTools_Scale_20_XYZ_AVX proc public frame

src_pitch equ qword ptr[rbp+48]
dst_pitch equ qword ptr[rbp+56]
ValMin equ qword ptr[rbp+64]
Coeff equ qword ptr[rbp+72]

	push rbp
	.pushreg rbp
	mov rbp,rsp
	push rsi
	.pushreg rsi
	push rbx
	.pushreg rbx
	.endprolog

	mov rsi,ValMin
	vbroadcastss ymm1,dword ptr[rsi]
	mov rsi,Coeff
	vbroadcastss ymm2,dword ptr[rsi]
	
	vmovaps ymm3,YMMWORD ptr data_f_1048575
	vmovaps ymm4,YMMWORD ptr data_f_0
	vmulps ymm2,ymm2,ymm3
	
	mov rsi,rcx
	mov r10,src_pitch
	mov r11,dst_pitch
	mov rbx,32
	
Scale_20_XYZ_AVX_1:
	xor rax,rax
	mov ecx,r8d
Scale_20_XYZ_AVX_2:
	vaddps ymm0,ymm1,YMMWORD ptr[rsi+rax]
	vmulps ymm0,ymm0,ymm2
	vminps ymm0,ymm0,ymm3
	vmaxps ymm0,ymm0,ymm4
	vcvtps2dq ymm0,ymm0
	vmovdqa YMMWORD ptr[rdx+rax],ymm0
	
	add rax,rbx
	loop Scale_20_XYZ_AVX_2
	
	add rsi,r10
	add rdx,r11
	dec r9d
	jnz short Scale_20_XYZ_AVX_1
	
	vzeroupper
	
	pop rbx
	pop rsi
	pop rbp

	ret

JPSDR_HDRTools_Scale_20_XYZ_AVX endp


;JPSDR_HDRTools_Scale_20_RGB_SSE2 proc src:dword,dst:dword,w4:dword,h:dword,src_pitch:dword,dst_pitch:dword
; src = rcx
; dst = rdx
; w4 = r8d
; h = r9d

JPSDR_HDRTools_Scale_20_RGB_SSE2 proc public frame

src_pitch equ qword ptr[rbp+48]
dst_pitch equ qword ptr[rbp+56]

	push rbp
	.pushreg rbp
	mov rbp,rsp
	push rsi
	.pushreg rsi
	push rbx
	.pushreg rbx
	.endprolog

	movaps xmm1,XMMWORD ptr data_f_1048575
	movaps xmm2,XMMWORD ptr data_f_0
	
	mov rsi,rcx
	mov r10,src_pitch
	mov r11,dst_pitch
	mov rbx,16
	
Scale_20_RGB_SSE2_1:
	xor rax,rax
	mov ecx,r8d
Scale_20_RGB_SSE2_2:
	movaps xmm0,XMMWORD ptr[rsi+rax]
	mulps xmm0,xmm1
	minps xmm0,xmm1
	maxps xmm0,xmm2
	cvtps2dq xmm0,xmm0
	movdqa XMMWORD ptr[rdx+rax],xmm0
	
	add rax,rbx
	loop Scale_20_RGB_SSE2_2
	
	add rsi,r10
	add rdx,r11
	dec r9d
	jnz short Scale_20_RGB_SSE2_1
	
	pop rbx
	pop rsi
	pop rbp

	ret

JPSDR_HDRTools_Scale_20_RGB_SSE2 endp


;JPSDR_HDRTools_Scale_20_RGB_SSE41 proc src:dword,dst:dword,w4:dword,h:dword,src_pitch:dword,dst_pitch:dword
; src = rcx
; dst = rdx
; w4 = r8d
; h = r9d

JPSDR_HDRTools_Scale_20_RGB_SSE41 proc public frame

src_pitch equ qword ptr[rbp+48]
dst_pitch equ qword ptr[rbp+56]

	push rbp
	.pushreg rbp
	mov rbp,rsp
	push rsi
	.pushreg rsi
	push rbx
	.pushreg rbx
	.endprolog

	movaps xmm1,XMMWORD ptr data_f_1048575
	movdqa xmm2,XMMWORD ptr data_dw_1048575
	movdqa xmm3,XMMWORD ptr data_dw_0
	
	mov rsi,rcx
	mov r10,src_pitch
	mov r11,dst_pitch
	mov rbx,16
	
Scale_20_RGB_SSE41_1:
	xor rax,rax
	mov ecx,r8d
Scale_20_RGB_SSE41_2:
	movaps xmm0,XMMWORD ptr[rsi+rax]
	mulps xmm0,xmm1
	cvtps2dq xmm0,xmm0
	pminsd xmm0,xmm2
	pmaxsd xmm0,xmm3
	movdqa XMMWORD ptr[rdx+rax],xmm0
	
	add rax,rbx
	loop Scale_20_RGB_SSE41_2
	
	add rsi,r10
	add rdx,r11
	dec r9d
	jnz short Scale_20_RGB_SSE41_1
	
	pop rbx
	pop rsi
	pop rbp

	ret

JPSDR_HDRTools_Scale_20_RGB_SSE41 endp


;JPSDR_HDRTools_Scale_20_RGB_AVX proc src:dword,dst:dword,w8:dword,h:dword,src_pitch:dword,dst_pitch:dword
; src = rcx
; dst = rdx
; w8 = r8d
; h = r9d

JPSDR_HDRTools_Scale_20_RGB_AVX proc public frame

src_pitch equ qword ptr[rbp+48]
dst_pitch equ qword ptr[rbp+56]
ValMin equ qword ptr[rbp+64]
Coeff equ qword ptr[rbp+72]

	push rbp
	.pushreg rbp
	mov rbp,rsp
	push rsi
	.pushreg rsi
	push rbx
	.pushreg rbx
	.endprolog

	vmovaps ymm1,YMMWORD ptr data_f_1048575
	vmovaps ymm2,YMMWORD ptr data_f_0
	
	mov rsi,rcx
	mov r10,src_pitch
	mov r11,dst_pitch
	mov rbx,32
	
Scale_20_RGB_AVX_1:
	xor rax,rax
	mov ecx,r8d
Scale_20_RGB_AVX_2:
	vmulps ymm0,ymm1,YMMWORD ptr[rsi+rax]
	vminps ymm0,ymm0,ymm1
	vmaxps ymm0,ymm0,ymm2
	vcvtps2dq ymm0,ymm0
	vmovdqa YMMWORD ptr[rdx+rax],ymm0
	
	add rax,rbx
	loop Scale_20_RGB_AVX_2
	
	add rsi,r10
	add rdx,r11
	dec r9d
	jnz short Scale_20_RGB_AVX_1
	
	vzeroupper
	
	pop rbx
	pop rsi
	pop rbp

	ret

JPSDR_HDRTools_Scale_20_RGB_AVX endp


;JPSDR_HDRTools_Convert_XYZ_HDRtoSDR_32_SSE2 proc src:dword,dst:dword,w4:dword,h:dword,src_pitch:dword,dst_pitch:dword
;	Coeff:dword
; src = rcx
; dst = rdx
; w4 = r8d
; h = r9d

JPSDR_HDRTools_Convert_XYZ_HDRtoSDR_32_SSE2 proc public frame

src_pitch equ qword ptr[rbp+48]
dst_pitch equ qword ptr[rbp+56]
Coeff equ qword ptr[rbp+64]

	push rbp
	.pushreg rbp
	mov rbp,rsp
	push rsi
	.pushreg rsi
	push rbx
	.pushreg rbx
	.endprolog

	mov rsi,Coeff
	movss xmm1,dword ptr[rsi]
	shufps xmm1,xmm1,0
	
	mov rsi,rcx
	mov r10,src_pitch
	mov r11,dst_pitch
	mov rbx,16
	
Convert_XYZ_HDRtoSDR_32_SSE2_1:
	xor rax,rax
	mov ecx,r8d
Convert_XYZ_HDRtoSDR_32_SSE2_2:	
	movaps xmm0,XMMWORD ptr[rsi+rax]
	mulps xmm0,xmm1
	movaps XMMWORD ptr[rdx+rax],xmm0
	
	add rax,rbx
	loop Convert_XYZ_HDRtoSDR_32_SSE2_2
	
	add rsi,r10
	add rdx,r11
	dec r9d
	jnz short Convert_XYZ_HDRtoSDR_32_SSE2_1
	
	pop rbx
	pop rsi
	pop rbp

	ret

JPSDR_HDRTools_Convert_XYZ_HDRtoSDR_32_SSE2 endp


;JPSDR_HDRTools_Convert_XYZ_HDRtoSDR_32_AVX proc src:dword,dst:dword,w8:dword,h:dword,src_pitch:dword,dst_pitch:dword,
;	Coeff:dword
; src = rcx
; dst = rdx
; w8 = r8d
; h = r9d

JPSDR_HDRTools_Convert_XYZ_HDRtoSDR_32_AVX proc public frame

src_pitch equ qword ptr[rbp+48]
dst_pitch equ qword ptr[rbp+56]
Coeff equ qword ptr[rbp+64]

	push rbp
	.pushreg rbp
	mov rbp,rsp
	push rsi
	.pushreg rsi
	push rbx
	.pushreg rbx
	push r12
	.pushreg r12
	push r13
	.pushreg r13
	push r14
	.pushreg r14
	.endprolog

	mov rsi,Coeff
	vbroadcastss ymm4,dword ptr[rsi]

	mov rsi,rcx
	mov r10,src_pitch
	mov r11,dst_pitch
	mov rbx,128
	mov r12,64
	mov r13,2
	mov r14,1
	
Convert_XYZ_HDRtoSDR_32_AVX_loop_1:
	mov ecx,r8d
	xor rax,rax

	shr ecx,2
	jz short Convert_XYZ_HDRtoSDR_32_AVX_1

Convert_XYZ_HDRtoSDR_32_AVX_loop_2:
	vmulps ymm0,ymm4,YMMWORD ptr[rsi+rax]
	vmulps ymm1,ymm4,YMMWORD ptr[rsi+rax+32]
	vmulps ymm2,ymm4,YMMWORD ptr[rsi+rax+64]
	vmulps ymm3,ymm4,YMMWORD ptr[rsi+rax+96]
	vmovaps YMMWORD ptr[rdx+rax],ymm0
	vmovaps YMMWORD ptr[rdx+rax+32],ymm1
	vmovaps YMMWORD ptr[rdx+rax+64],ymm2
	vmovaps YMMWORD ptr[rdx+rax+96],ymm3
	
	add rax,rbx
	loop Convert_XYZ_HDRtoSDR_32_AVX_loop_2

Convert_XYZ_HDRtoSDR_32_AVX_1:
	test r8d,r13d
	jz short Convert_XYZ_HDRtoSDR_32_AVX_2

	vmulps ymm0,ymm4,YMMWORD ptr[rsi+rax]
	vmulps ymm1,ymm4,YMMWORD ptr[rsi+rax+32]
	vmovaps YMMWORD ptr[rdx+rax],ymm0
	vmovaps YMMWORD ptr[rdx+rax+32],ymm1
	
	add rax,r12

Convert_XYZ_HDRtoSDR_32_AVX_2:
	test r8d,r14d
	jz short Convert_XYZ_HDRtoSDR_32_AVX_3

	vmulps ymm0,ymm4,YMMWORD ptr[rsi+rax]
	vmovaps YMMWORD ptr[rdx+rax],ymm0

Convert_XYZ_HDRtoSDR_32_AVX_3:
	add rsi,r10
	add rdx,r11
	dec r9d
	jnz short Convert_XYZ_HDRtoSDR_32_AVX_loop_1
	
	vzeroupper
	
	pop r14
	pop r13
	pop r12
	pop rbx
	pop rsi
	pop rbp

	ret

JPSDR_HDRTools_Convert_XYZ_HDRtoSDR_32_AVX endp


;JPSDR_HDRTools_Convert_XYZ_SDRtoHDR_32_SSE2 proc src:dword,dst:dword,w4:dword,h:dword,src_pitch:dword,dst_pitch:dword,
;	Coeff:dword
; src = rcx
; dst = rdx
; w4 = r8d
; h = r9d

JPSDR_HDRTools_Convert_XYZ_SDRtoHDR_32_SSE2 proc public frame

src_pitch equ qword ptr[rbp+48]
dst_pitch equ qword ptr[rbp+56]
Coeff equ qword ptr[rbp+64]

	push rbp
	.pushreg rbp
	mov rbp,rsp
	push rsi
	.pushreg rsi
	push rbx
	.pushreg rbx
	.endprolog

	mov rsi,Coeff
	movss xmm1,dword ptr[rsi]
	shufps xmm1,xmm1,0
	
	mov rsi,rcx
	mov r10,src_pitch
	mov r11,dst_pitch
	mov rbx,16
	
Convert_XYZ_SDRtoHDR_32_SSE2_1:
	xor rax,rax
	mov ecx,r8d
Convert_XYZ_SDRtoHDR_32_SSE2_2:	
	movaps xmm0,XMMWORD ptr[rsi+rax]
	mulps xmm0,xmm1
	movaps XMMWORD ptr[rdx+rax],xmm0
	
	add rax,rbx
	loop Convert_XYZ_SDRtoHDR_32_SSE2_2
	
	add rsi,r10
	add rdx,r11
	dec r9d
	jnz short Convert_XYZ_SDRtoHDR_32_SSE2_1
	
	pop rbx
	pop rsi
	pop rbp

	ret

JPSDR_HDRTools_Convert_XYZ_SDRtoHDR_32_SSE2 endp


;JPSDR_HDRTools_Convert_XYZ_SDRtoHDR_32_AVX proc src:dword,dst:dword,w8:dword,h:dword,src_pitch:dword,dst_pitch:dword,
;	Coeff:dword
; src = rcx
; dst = rdx
; w8 = r8d
; h = r9d

JPSDR_HDRTools_Convert_XYZ_SDRtoHDR_32_AVX proc public frame

src_pitch equ qword ptr[rbp+48]
dst_pitch equ qword ptr[rbp+56]
Coeff equ qword ptr[rbp+64]

	push rbp
	.pushreg rbp
	mov rbp,rsp
	push rsi
	.pushreg rsi
	push rbx
	.pushreg rbx
	push r12
	.pushreg r12
	push r13
	.pushreg r13
	push r14
	.pushreg r14
	.endprolog

	mov rsi,Coeff
	vbroadcastss ymm4,dword ptr[rsi]
	
	mov rsi,rcx
	mov r10,src_pitch
	mov r11,dst_pitch
	mov rbx,128
	mov r12,64
	mov r13,2
	mov r14,1

Convert_XYZ_SDRtoHDR_32_AVX_loop_1:
	mov ecx,r8d
	xor rax,rax

	shr ecx,2
	jz short Convert_XYZ_SDRtoHDR_32_AVX_1

Convert_XYZ_SDRtoHDR_32_AVX_loop_2:	
	vmulps ymm0,ymm4,YMMWORD ptr[rsi+rax]
	vmulps ymm1,ymm4,YMMWORD ptr[rsi+rax+32]
	vmulps ymm2,ymm4,YMMWORD ptr[rsi+rax+64]
	vmulps ymm3,ymm4,YMMWORD ptr[rsi+rax+96]
	vmovaps YMMWORD ptr[rdx+rax],ymm0
	vmovaps YMMWORD ptr[rdx+rax+32],ymm1
	vmovaps YMMWORD ptr[rdx+rax+64],ymm2
	vmovaps YMMWORD ptr[rdx+rax+96],ymm3
	
	add rax,rbx
	loop Convert_XYZ_SDRtoHDR_32_AVX_loop_2

Convert_XYZ_SDRtoHDR_32_AVX_1:
	test r8d,r13d
	jz short Convert_XYZ_SDRtoHDR_32_AVX_2

	vmulps ymm0,ymm4,YMMWORD ptr[rsi+rax]
	vmulps ymm1,ymm4,YMMWORD ptr[rsi+rax+32]
	vmovaps YMMWORD ptr[rdx+rax],ymm0
	vmovaps YMMWORD ptr[rdx+rax+32],ymm1
	
	add rax,r12

Convert_XYZ_SDRtoHDR_32_AVX_2:
	test r8d,r14d
	jz short Convert_XYZ_SDRtoHDR_32_AVX_3

	vmulps ymm0,ymm4,YMMWORD ptr[rsi+rax]
	vmovaps YMMWORD ptr[rdx+rax],ymm0
	
Convert_XYZ_SDRtoHDR_32_AVX_3:
	add rsi,r10
	add rdx,r11
	dec r9d
	jnz short Convert_XYZ_SDRtoHDR_32_AVX_loop_1
	
	vzeroupper
	
	pop r14
	pop r13
	pop r12
	pop rbx
	pop rsi
	pop rbp

	ret

JPSDR_HDRTools_Convert_XYZ_SDRtoHDR_32_AVX endp


;JPSDR_HDRTools_Convert_XYZ_Hable_HDRtoSDR_SSE2 proc src:dword,dst:dword,w4:dword,h:dword,src_pitch:dword,dst_pitch:dword,
;	Coeff1:dword,Coeff2:dword,Coeff3:dword,Coeff4:dword,Coeff5:dword,Coeff6:dword
; src = rcx
; dst = rdx
; w4 = r8d
; h = r9d

JPSDR_HDRTools_Convert_XYZ_Hable_HDRtoSDR_SSE2 proc public frame

src_pitch equ qword ptr[rbp+48]
dst_pitch equ qword ptr[rbp+56]
Coeff1 equ qword ptr[rbp+64]
Coeff2 equ qword ptr[rbp+72]
Coeff3 equ qword ptr[rbp+80]
Coeff4 equ qword ptr[rbp+88]
Coeff5 equ qword ptr[rbp+96]
Coeff6 equ qword ptr[rbp+104]

	push rbp
	.pushreg rbp
	mov rbp,rsp
	push rsi
	.pushreg rsi
	push rbx
	.pushreg rbx
	sub rsp,48
	.allocstack 48
	movdqa XMMWORD ptr[rsp],xmm6
	.savexmm128 xmm6,0
	movdqa XMMWORD ptr[rsp+16],xmm7
	.savexmm128 xmm7,16
	movdqa XMMWORD ptr[rsp+32],xmm8
	.savexmm128 xmm8,32
	.endprolog

	mov rsi,Coeff1
	movss xmm2,dword ptr[rsi]
	shufps xmm2,xmm2,0
	mov rsi,Coeff2
	movss xmm3,dword ptr[rsi]
	shufps xmm3,xmm3,0
	mov rsi,Coeff3
	movss xmm4,dword ptr[rsi]
	shufps xmm4,xmm4,0
	mov rsi,Coeff4
	movss xmm5,dword ptr[rsi]
	shufps xmm5,xmm5,0
	mov rsi,Coeff5
	movss xmm6,dword ptr[rsi]
	shufps xmm6,xmm6,0
	mov rsi,Coeff6
	movss xmm7,dword ptr[rsi]
	shufps xmm7,xmm7,0
	
	mov rsi,rcx
	mov r10,src_pitch
	mov r11,dst_pitch
	mov rbx,16
	
Convert_XYZ_Hable_HDRtoSDR_SSE2_1:
	xor rax,rax
	mov ecx,r8d
Convert_XYZ_Hable_HDRtoSDR_SSE2_2:	
	movaps xmm0,XMMWORD ptr[rsi+rax]
	
	movaps xmm1,xmm0
	mulps xmm1,xmm2
	movaps xmm8,xmm1
	addps xmm1,xmm5
	mulps xmm1,xmm0
	addps xmm1,xmm6
	
	addps xmm8,xmm3
	mulps xmm8,xmm0
	addps xmm8,xmm4
	divps xmm8,xmm1
	subps xmm8,xmm7
	
	movaps XMMWORD ptr[rdx+rax],xmm8
	
	add rax,rbx
	loop Convert_XYZ_Hable_HDRtoSDR_SSE2_2
	
	add rsi,r10
	add rdx,r11
	dec r9d
	jnz short Convert_XYZ_Hable_HDRtoSDR_SSE2_1
	
	movdqa xmm8,XMMWORD ptr[rsp+32]
	movdqa xmm7,XMMWORD ptr[rsp+16]
	movdqa xmm6,XMMWORD ptr[rsp]
	add rsp,48
	
	pop rbx
	pop rsi
	pop rbp

	ret

JPSDR_HDRTools_Convert_XYZ_Hable_HDRtoSDR_SSE2 endp


;JPSDR_HDRTools_Convert_XYZ_Hable_HDRtoSDR_AVX proc src:dword,dst:dword,w8:dword,h:dword,src_pitch:dword,dst_pitch:dword,
;	Coeff1:dword,Coeff2:dword,Coeff3:dword,Coeff4:dword,Coeff5:dword,Coeff6:dword
; src = rcx
; dst = rdx
; w8 = r8d
; h = r9d

JPSDR_HDRTools_Convert_XYZ_Hable_HDRtoSDR_AVX proc public frame

src_pitch equ qword ptr[rbp+48]
dst_pitch equ qword ptr[rbp+56]
Coeff1 equ qword ptr[rbp+64]
Coeff2 equ qword ptr[rbp+72]
Coeff3 equ qword ptr[rbp+80]
Coeff4 equ qword ptr[rbp+88]
Coeff5 equ qword ptr[rbp+96]
Coeff6 equ qword ptr[rbp+104]

	push rbp
	.pushreg rbp
	mov rbp,rsp
	push rsi
	.pushreg rsi
	push rdi
	.pushreg rdi
	push rbx
	.pushreg rbx
	sub rsp,104
	.allocstack 104
	vmovdqa XMMWORD ptr[rsp],xmm6
	.savexmm128 xmm6,0
	vmovdqa XMMWORD ptr[rsp+16],xmm7
	.savexmm128 xmm7,16
	vmovdqa XMMWORD ptr[rsp+32],xmm8
	.savexmm128 xmm8,32
	vmovdqa XMMWORD ptr[rsp+48],xmm9
	.savexmm128 xmm9,48
	vmovdqa XMMWORD ptr[rsp+64],xmm10
	.savexmm128 xmm10,64
	vmovdqa XMMWORD ptr[rsp+80],xmm11
	.savexmm128 xmm11,80
	.endprolog
	
	mov rsi,Coeff1
	vbroadcastss ymm6,dword ptr[rsi]
	mov rsi,Coeff2
	vbroadcastss ymm7,dword ptr[rsi]
	mov rsi,Coeff3
	vbroadcastss ymm8,dword ptr[rsi]
	mov rsi,Coeff4
	vbroadcastss ymm9,dword ptr[rsi]
	mov rsi,Coeff5
	vbroadcastss ymm10,dword ptr[rsi]
	mov rsi,Coeff6
	vbroadcastss ymm11,dword ptr[rsi]
	
	mov rsi,rcx
	mov rdi,rdx
	mov r10,src_pitch
	mov r11,dst_pitch
	mov rbx,64
	mov rdx,1
	
Convert_XYZ_Hable_HDRtoSDR_AVX_loop_1:
	mov ecx,r8d
	xor rax,rax

	shr ecx,1
	jz short Convert_XYZ_Hable_HDRtoSDR_AVX_1

Convert_XYZ_Hable_HDRtoSDR_AVX_loop_2:	
	vmovaps ymm0,YMMWORD ptr[rsi+rax]
	vmovaps ymm3,YMMWORD ptr[rsi+rax+32]
	
	vmulps ymm1,ymm0,ymm6
	vmulps ymm4,ymm3,ymm6
	vmovaps ymm2,ymm1
	vmovaps ymm5,ymm4
	vaddps ymm1,ymm1,ymm9
	vaddps ymm4,ymm4,ymm9
	vmulps ymm1,ymm1,ymm0
	vmulps ymm4,ymm4,ymm3
	vaddps ymm1,ymm1,ymm10
	vaddps ymm4,ymm4,ymm10

	vaddps ymm2,ymm2,ymm7
	vaddps ymm5,ymm5,ymm7
	vmulps ymm2,ymm2,ymm0
	vmulps ymm5,ymm5,ymm3
	vaddps ymm2,ymm2,ymm8
	vaddps ymm5,ymm5,ymm8
	vdivps ymm2,ymm2,ymm1
	vdivps ymm5,ymm5,ymm4
	vsubps ymm2,ymm2,ymm11
	vsubps ymm5,ymm5,ymm11
	
	vmovaps YMMWORD ptr [rdi+rax],ymm2
	vmovaps YMMWORD ptr [rdi+rax+32],ymm5

	add rax,rbx
	loop Convert_XYZ_Hable_HDRtoSDR_AVX_loop_2

Convert_XYZ_Hable_HDRtoSDR_AVX_1:
	test ebx,edx
	jz short Convert_XYZ_Hable_HDRtoSDR_AVX_2

	vmovaps ymm0,YMMWORD ptr[rsi+rax]
	
	vmulps ymm1,ymm0,ymm6
	vmovaps ymm2,ymm1
	vaddps ymm1,ymm1,ymm9
	vmulps ymm1,ymm1,ymm0
	vaddps ymm1,ymm1,ymm10
	
	vaddps ymm2,ymm2,ymm7
	vmulps ymm2,ymm2,ymm0
	vaddps ymm2,ymm2,ymm8
	vdivps ymm2,ymm2,ymm1
	vsubps ymm2,ymm2,ymm11
	
	vmovaps YMMWORD ptr [rdi+rax],ymm2
	
Convert_XYZ_Hable_HDRtoSDR_AVX_2:
	add rsi,r10
	add rdi,r11
	dec r9d
	jnz Convert_XYZ_Hable_HDRtoSDR_AVX_loop_1
	
	vmovdqa xmm11,XMMWORD ptr[rsp+80]
	vmovdqa xmm10,XMMWORD ptr[rsp+64]
	vmovdqa xmm9,XMMWORD ptr[rsp+48]
	vmovdqa xmm8,XMMWORD ptr[rsp+32]
	vmovdqa xmm7,XMMWORD ptr[rsp+16]
	vmovdqa xmm6,XMMWORD ptr[rsp]
	add rsp,104

	vzeroupper
	
	pop rbx
	pop rdi
	pop rsi
	pop rbp

	ret

JPSDR_HDRTools_Convert_XYZ_Hable_HDRtoSDR_AVX endp


;JPSDR_HDRTools_Convert_XYZ_Mobius_HDRtoSDR_SSE2 proc src:dword,dst:dword,w4:dword,h:dword,src_pitch:dword,dst_pitch:dword,
;	Coeff1:dword,Coeff2:dword,Coeff3:dword,Coeff4:dword
; src = rcx
; dst = rdx
; w4 = r8d
; h = r9d

JPSDR_HDRTools_Convert_XYZ_Mobius_HDRtoSDR_SSE2 proc public frame

src_pitch equ qword ptr[rbp+48]
dst_pitch equ qword ptr[rbp+56]
Coeff1 equ qword ptr[rbp+64]
Coeff2 equ qword ptr[rbp+72]
Coeff3 equ qword ptr[rbp+80]
Coeff4 equ qword ptr[rbp+88]

	push rbp
	.pushreg rbp
	mov rbp,rsp
	push rsi
	.pushreg rsi
	push rbx
	.pushreg rbx
	sub rsp,48
	.allocstack 48
	movdqa XMMWORD ptr[rsp],xmm6
	.savexmm128 xmm6,0
	movdqa XMMWORD ptr[rsp+16],xmm7
	.savexmm128 xmm7,16
	movdqa XMMWORD ptr[rsp+32],xmm8
	.savexmm128 xmm8,32
	.endprolog

	mov rsi,Coeff1
	movss xmm4,dword ptr[rsi]
	shufps xmm4,xmm4,0
	mov rsi,Coeff2
	movss xmm5,dword ptr[rsi]
	shufps xmm5,xmm5,0
	mov rsi,Coeff3
	movss xmm6,dword ptr[rsi]
	shufps xmm6,xmm6,0
	mov rsi,Coeff4
	movss xmm7,dword ptr[rsi]
	shufps xmm7,xmm7,0
	
	movaps xmm8,XMMWORD ptr data_all_1
	
	mov rsi,rcx
	mov r10,src_pitch
	mov r11,dst_pitch
	mov rbx,16
	
Convert_XYZ_Mobius_HDRtoSDR_SSE2_1:
	xor rax,rax
	mov ecx,r8d
Convert_XYZ_Mobius_HDRtoSDR_SSE2_2:	
	movaps xmm0,XMMWORD ptr[rsi+rax]
	
	movaps xmm3,xmm0
	movaps xmm2,xmm0
	movaps xmm1,xmm0
	cmpleps xmm2,xmm4
	addps xmm1,xmm7
	addps xmm0,xmm6
	mulps xmm0,xmm5
	divps xmm0,xmm1
	andps xmm3,xmm2
	xorps xmm2,xmm8
	andps xmm0,xmm2
	orps xmm0,xmm3
	
	movaps XMMWORD ptr [rdx+rax],xmm0
	
	add rax,rbx
	loop Convert_XYZ_Mobius_HDRtoSDR_SSE2_2
	
	add rsi,r10
	add rdx,r11
	dec r9d
	jnz short Convert_XYZ_Mobius_HDRtoSDR_SSE2_1
	
	movdqa xmm8,XMMWORD ptr[rsp+32]
	movdqa xmm7,XMMWORD ptr[rsp+16]
	movdqa xmm6,XMMWORD ptr[rsp]
	add rsp,48
	
	pop rbx
	pop rsi
	pop rbp

	ret

JPSDR_HDRTools_Convert_XYZ_Mobius_HDRtoSDR_SSE2 endp


;JPSDR_HDRTools_Convert_XYZ_Mobius_HDRtoSDR_AVX proc src:dword,dst:dword,w8:dword,h:dword,src_pitch:dword,dst_pitch:dword,
;	Coeff1:dword,Coeff2:dword,Coeff3:dword,Coeff4:dword
; src = rcx
; dst = rdx
; w8 = r8d
; h = r9d

JPSDR_HDRTools_Convert_XYZ_Mobius_HDRtoSDR_AVX proc public frame

src_pitch equ qword ptr[rbp+48]
dst_pitch equ qword ptr[rbp+56]
Coeff1 equ qword ptr[rbp+64]
Coeff2 equ qword ptr[rbp+72]
Coeff3 equ qword ptr[rbp+80]
Coeff4 equ qword ptr[rbp+88]

	push rbp
	.pushreg rbp
	mov rbp,rsp
	push rsi
	.pushreg rsi
	push rdi
	.pushreg rdi
	push rbx
	.pushreg rbx
	sub rsp,120
	.allocstack 120
	vmovdqa XMMWORD ptr[rsp],xmm6
	.savexmm128 xmm6,0
	vmovdqa XMMWORD ptr[rsp+16],xmm7
	.savexmm128 xmm7,16
	vmovdqa XMMWORD ptr[rsp+32],xmm8
	.savexmm128 xmm8,32
	vmovdqa XMMWORD ptr[rsp+48],xmm9
	.savexmm128 xmm9,48
	vmovdqa XMMWORD ptr[rsp+64],xmm10
	.savexmm128 xmm10,64
	vmovdqa XMMWORD ptr[rsp+80],xmm11
	.savexmm128 xmm11,80
	vmovdqa XMMWORD ptr[rsp+96],xmm12
	.savexmm128 xmm12,96
	.endprolog
	
	mov rsi,Coeff1
	vbroadcastss ymm8,dword ptr[rsi]
	mov rsi,Coeff2
	vbroadcastss ymm9,dword ptr[rsi]
	mov rsi,Coeff3
	vbroadcastss ymm10,dword ptr[rsi]
	mov rsi,Coeff4
	vbroadcastss ymm11,dword ptr[rsi]
	
	vmovaps ymm12,YMMWORD ptr data_all_1
	
	mov rsi,rcx
	mov rdi,rdx
	mov r10,src_pitch
	mov r11,dst_pitch
	mov rbx,64
	mov rdx,1
	
Convert_XYZ_Mobius_HDRtoSDR_AVX_loop_1:
	mov ecx,r8d
	xor rax,rax

	shr ecx,1
	jz short Convert_XYZ_Mobius_HDRtoSDR_AVX_1

Convert_XYZ_Mobius_HDRtoSDR_AVX_loop_2:	
	vmovaps ymm0,YMMWORD ptr[rsi+rax]
	vmovaps ymm4,YMMWORD ptr[rsi+rax+32]
	
	vcmpleps ymm2,ymm0,ymm8
	vcmpleps ymm6,ymm4,ymm8
	vaddps ymm1,ymm0,ymm11
	vaddps ymm5,ymm4,ymm11
	vaddps ymm3,ymm0,ymm10
	vaddps ymm7,ymm4,ymm10
	vmulps ymm3,ymm3,ymm9
	vmulps ymm7,ymm7,ymm9
	vdivps ymm3,ymm3,ymm1
	vdivps ymm7,ymm7,ymm5
	vandps ymm0,ymm0,ymm2
	vandps ymm4,ymm4,ymm6
	vxorps ymm2,ymm2,ymm12
	vxorps ymm6,ymm6,ymm12
	vandps ymm3,ymm3,ymm2
	vandps ymm7,ymm7,ymm6
	vorps ymm0,ymm0,ymm3
	vorps ymm4,ymm4,ymm7
	
	vmovaps YMMWORD ptr [rdi+rax],ymm0
	vmovaps YMMWORD ptr [rdi+rax+32],ymm4

	add rax,rbx
	loop Convert_XYZ_Mobius_HDRtoSDR_AVX_loop_2

Convert_XYZ_Mobius_HDRtoSDR_AVX_1:
	test r8d,edx
	jz short Convert_XYZ_Mobius_HDRtoSDR_AVX_2

	vmovaps ymm0,YMMWORD ptr[rsi+rax]
	
	vcmpleps ymm2,ymm0,ymm8
	vaddps ymm1,ymm0,ymm11
	vaddps ymm3,ymm0,ymm10
	vmulps ymm3,ymm3,ymm9
	vdivps ymm3,ymm3,ymm1
	vandps ymm0,ymm0,ymm2
	vxorps ymm2,ymm2,ymm12
	vandps ymm3,ymm3,ymm2
	vorps ymm0,ymm0,ymm3
	
	vmovaps YMMWORD ptr [rdi+rax],ymm0

Convert_XYZ_Mobius_HDRtoSDR_AVX_2:
	add rsi,r10
	add rdi,r11
	dec r9d
	jnz Convert_XYZ_Mobius_HDRtoSDR_AVX_loop_1

	vmovdqa xmm12,XMMWORD ptr[rsp+96]
	vmovdqa xmm11,XMMWORD ptr[rsp+80]
	vmovdqa xmm10,XMMWORD ptr[rsp+64]
	vmovdqa xmm9,XMMWORD ptr[rsp+48]
	vmovdqa xmm8,XMMWORD ptr[rsp+32]
	vmovdqa xmm7,XMMWORD ptr[rsp+16]
	vmovdqa xmm6,XMMWORD ptr[rsp]
	add rsp,120

	vzeroupper
	
	pop rbx
	pop rdi
	pop rsi
	pop rbp

	ret

JPSDR_HDRTools_Convert_XYZ_Mobius_HDRtoSDR_AVX endp


;JPSDR_HDRTools_Convert_XYZ_Reinhard_HDRtoSDR_SSE2 proc src:dword,dst:dword,w4:dword,h:dword,src_pitch:dword,dst_pitch:dword,
;	Coeff1:dword,Coeff2:dword
; src = rcx
; dst = rdx
; w4 = r8d
; h = r9d

JPSDR_HDRTools_Convert_XYZ_Reinhard_HDRtoSDR_SSE2 proc public frame

src_pitch equ qword ptr[rbp+48]
dst_pitch equ qword ptr[rbp+56]
Coeff1 equ qword ptr[rbp+64]
Coeff2 equ qword ptr[rbp+72]

	push rbp
	.pushreg rbp
	mov rbp,rsp
	push rsi
	.pushreg rsi
	push rbx
	.pushreg rbx
	.endprolog

	mov rsi,Coeff1
	movss xmm2,dword ptr[rsi]
	shufps xmm2,xmm2,0
	mov rsi,Coeff2
	movss xmm3,dword ptr[rsi]
	shufps xmm3,xmm3,0
	
	mov rsi,rcx
	mov r10,src_pitch
	mov r11,dst_pitch
	mov rbx,16
	
Convert_XYZ_Reinhard_HDRtoSDR_SSE2_1:
	xor rax,rax
	mov ecx,r8d
Convert_XYZ_Reinhard_HDRtoSDR_SSE2_2:	
	movaps xmm0,XMMWORD ptr[rsi+rax]
	
	movaps xmm1,xmm0
	addps xmm0,xmm3
	divps xmm1,xmm0
	mulps xmm1,xmm2
	
	movaps XMMWORD ptr [rdx+rax],xmm1
	
	add rax,rbx
	loop Convert_XYZ_Reinhard_HDRtoSDR_SSE2_2
	
	add rsi,r10
	add rdx,r11
	dec r9d
	jnz short Convert_XYZ_Reinhard_HDRtoSDR_SSE2_1

	pop rbx
	pop rsi
	pop rbp

	ret

JPSDR_HDRTools_Convert_XYZ_Reinhard_HDRtoSDR_SSE2 endp


;JPSDR_HDRTools_Convert_XYZ_Reinhard_HDRtoSDR_AVX proc src:dword,dst:dword,w8:dword,h:dword,src_pitch:dword,dst_pitch:dword,
;	Coeff1:dword,Coeff2:dword
; src = rcx
; dst = rdx
; w8 = r8d
; h = r9d

JPSDR_HDRTools_Convert_XYZ_Reinhard_HDRtoSDR_AVX proc public frame

src_pitch equ qword ptr[rbp+48]
dst_pitch equ qword ptr[rbp+56]
Coeff1 equ qword ptr[rbp+64]
Coeff2 equ qword ptr[rbp+72]

	push rbp
	.pushreg rbp
	mov rbp,rsp
	push rsi
	.pushreg rsi
	push rdi
	.pushreg rdi
	push rbx
	.pushreg rbx
	.endprolog
	
	mov rsi,Coeff1
	vbroadcastss ymm4,dword ptr[rsi]
	mov rsi,Coeff2
	vbroadcastss ymm5,dword ptr[rsi]
	
	mov rsi,rcx
	mov rdi,rdx
	mov r10,src_pitch
	mov r11,dst_pitch
	mov rbx,64
	mov rdx,1
	
Convert_XYZ_Reinhard_HDRtoSDR_AVX_loop_1:
	mov ecx,r8d
	xor rax,rax

	shr ecx,1
	jz short Convert_XYZ_Reinhard_HDRtoSDR_AVX_1

Convert_XYZ_Reinhard_HDRtoSDR_AVX_loop_2:	
	vmovaps ymm0,YMMWORD ptr[rsi+rax]
	vmovaps ymm2,YMMWORD ptr[rsi+rax+32]
	
	vaddps ymm1,ymm0,ymm5
	vaddps ymm3,ymm2,ymm5
	vdivps ymm0,ymm0,ymm1
	vdivps ymm2,ymm2,ymm3
	vmulps ymm0,ymm0,ymm4
	vmulps ymm2,ymm2,ymm4
	
	vmovaps YMMWORD ptr [rdi+rax],ymm0
	vmovaps YMMWORD ptr [rdi+rax+32],ymm2

	add rax,rbx
	loop Convert_XYZ_Reinhard_HDRtoSDR_AVX_loop_2

Convert_XYZ_Reinhard_HDRtoSDR_AVX_1:
	test r8d,edx
	jz short Convert_XYZ_Reinhard_HDRtoSDR_AVX_2

	vmovaps ymm0,YMMWORD ptr[rsi+rax]
	
	vaddps ymm1,ymm0,ymm5
	vdivps ymm0,ymm0,ymm1
	vmulps ymm0,ymm0,ymm4
	
	vmovaps YMMWORD ptr [rdi+rax],ymm0

Convert_XYZ_Reinhard_HDRtoSDR_AVX_2:
	add rsi,r10
	add rdi,r11
	dec r9d
	jnz short Convert_XYZ_Reinhard_HDRtoSDR_AVX_loop_1
	
	vzeroupper
	
	pop rbx
	pop rdi
	pop rsi
	pop rbp

	ret

JPSDR_HDRTools_Convert_XYZ_Reinhard_HDRtoSDR_AVX endp


;JPSDR_HDRTools_BT2446C_16_XYZ_SSE2 proc src:dword,dst1:dword,dst2:dword,w4:dword,h:dword,src_pitch:dword,
;	dst_pitch1:dword,dst_pitch2:dword,ValMinX:dword,CoeffX:dword,ValMinZ:dword,CoeffZ:dword
; src = rcx
; dst1 = rdx
; dst2 = r8
; w4 = r9d

JPSDR_HDRTools_BT2446C_16_XYZ_SSE2 proc public frame

h equ dword ptr[rbp+48]
src_pitch equ qword ptr[rbp+56]
dst_pitch1 equ qword ptr[rbp+64]
dst_pitch2 equ qword ptr[rbp+72]
ValMinX equ qword ptr[rbp+80]
CoeffX equ qword ptr[rbp+88]
ValMinZ equ qword ptr[rbp+96]
CoeffZ equ qword ptr[rbp+104]

	push rbp
	.pushreg rbp
	mov rbp,rsp
	push rsi
	.pushreg rsi
	push rbx
	.pushreg rbx
	push r12
	.pushreg r12
	push r13
	.pushreg r13
	sub rsp,32
	.allocstack 32
	movdqa XMMWORD ptr[rsp],xmm6
	.savexmm128 xmm6,0
	movdqa XMMWORD ptr[rsp+16],xmm7
	.savexmm128 xmm7,16
	.endprolog

	mov rsi,ValMinX
	movss xmm2,dword ptr[rsi]
	mov rsi,CoeffX
	movss xmm3,dword ptr[rsi]
	mov rsi,ValMinZ
	movss xmm4,dword ptr[rsi]
	mov rsi,CoeffZ
	movss xmm5,dword ptr[rsi]

	shufps xmm2,xmm2,0
	shufps xmm3,xmm3,0
	shufps xmm4,xmm4,0
	shufps xmm5,xmm5,0
	
	movaps xmm6,XMMWORD ptr data_f_65535
	movaps xmm7,XMMWORD ptr data_f_0
	mulps xmm3,xmm6
	mulps xmm5,xmm6
	
	mov rsi,rcx
	mov r10,src_pitch
	mov r11,dst_pitch1
	mov r12,dst_pitch2
	mov r13d,h
	mov rbx,16
	
BT2446C_16_XYZ_SSE2_1:
	xor rax,rax
	mov ecx,r9d
BT2446C_16_XYZ_SSE2_2:
	movaps xmm0,XMMWORD ptr[rdx+rax]
	movaps xmm1,XMMWORD ptr[r8+rax]
	mulps xmm0,XMMWORD ptr[rsi+rax]
	mulps xmm1,XMMWORD ptr[rsi+rax]
	addps xmm0,xmm2
	addps xmm1,xmm4
	mulps xmm0,xmm3
	mulps xmm1,xmm5
	minps xmm0,xmm6
	minps xmm1,xmm6
	maxps xmm0,xmm7
	maxps xmm1,xmm7
	cvtps2dq xmm0,xmm0
	cvtps2dq xmm1,xmm1
	movdqa XMMWORD ptr[rdx+rax],xmm0
	movdqa XMMWORD ptr[r8+rax],xmm1
	
	add rax,rbx
	loop BT2446C_16_XYZ_SSE2_2
	
	add rsi,r10
	add rdx,r11
	add r8,r12
	dec r13d
	jnz short BT2446C_16_XYZ_SSE2_1
	
	movdqa xmm7,XMMWORD ptr[rsp+16]
	movdqa xmm6,XMMWORD ptr[rsp]
	add rsp,32
	
	pop r13
	pop r12
	pop rbx
	pop rsi
	pop rbp

	ret

JPSDR_HDRTools_BT2446C_16_XYZ_SSE2 endp


;JPSDR_HDRTools_BT2446C_16_XYZ_SSE41 proc src:dword,dst1:dword,dst2:dword,w4:dword,h:dword,src_pitch:dword,
;	dst_pitch1:dword,dst_pitch2:dword,ValMinX:dword,CoeffX:dword,ValMinZ:dword,CoeffZ:dword
; src = rcx
; dst1 = rdx
; dst2 = r8
; w4 = r9d

JPSDR_HDRTools_BT2446C_16_XYZ_SSE41 proc public frame

h equ dword ptr[rbp+48]
src_pitch equ qword ptr[rbp+56]
dst_pitch1 equ qword ptr[rbp+64]
dst_pitch2 equ qword ptr[rbp+72]
ValMinX equ qword ptr[rbp+80]
CoeffX equ qword ptr[rbp+88]
ValMinZ equ qword ptr[rbp+96]
CoeffZ equ qword ptr[rbp+104]

	push rbp
	.pushreg rbp
	mov rbp,rsp
	push rsi
	.pushreg rsi
	push rbx
	.pushreg rbx
	push r12
	.pushreg r12
	push r13
	.pushreg r13
	sub rsp,32
	.allocstack 32
	movdqa XMMWORD ptr[rsp],xmm6
	.savexmm128 xmm6,0
	movdqa XMMWORD ptr[rsp+16],xmm7
	.savexmm128 xmm7,16	
	.endprolog

	mov rsi,ValMinX
	movss xmm2,dword ptr[rsi]
	shufps xmm2,xmm2,0
	mov rsi,CoeffX
	movss xmm3,dword ptr[rsi]
	shufps xmm3,xmm3,0

	mov rsi,ValMinZ
	movss xmm4,dword ptr[rsi]
	shufps xmm4,xmm4,0
	mov rsi,CoeffZ
	movss xmm5,dword ptr[rsi]
	shufps xmm5,xmm5,0
	
	movdqa xmm6,XMMWORD ptr data_dw_65535
	movdqa xmm7,XMMWORD ptr data_dw_0
	mulps xmm3,XMMWORD ptr data_f_65535
	mulps xmm5,XMMWORD ptr data_f_65535
	
	mov rsi,rcx
	mov r10,src_pitch
	mov r11,dst_pitch1
	mov r12,dst_pitch2
	mov r13d,h
	mov rbx,16
	
BT2446C_16_XYZ_SSE41_1:
	xor rax,rax
	mov ecx,r9d
BT2446C_16_XYZ_SSE41_2:
	movaps xmm0,XMMWORD ptr[rdx+rax]
	movaps xmm1,XMMWORD ptr[r8+rax]
	mulps xmm0,XMMWORD ptr[rsi+rax]
	mulps xmm1,XMMWORD ptr[rsi+rax]
	addps xmm0,xmm2
	addps xmm1,xmm4
	mulps xmm0,xmm3
	mulps xmm1,xmm5
	cvtps2dq xmm0,xmm0
	cvtps2dq xmm1,xmm1
	pminsd xmm0,xmm6
	pminsd xmm1,xmm6
	pmaxsd xmm0,xmm7
	pmaxsd xmm1,xmm7
	movdqa XMMWORD ptr[rdx+rax],xmm0
	movdqa XMMWORD ptr[r8+rax],xmm1
	
	add rax,rbx
	loop BT2446C_16_XYZ_SSE41_2
	
	add rsi,r10
	add rdx,r11
	add r8,r12
	dec r13d
	jnz short BT2446C_16_XYZ_SSE41_1
	
	movdqa xmm7,XMMWORD ptr[rsp+16]
	movdqa xmm6,XMMWORD ptr[rsp]
	add rsp,32
	
	pop r13
	pop r12
	pop rbx
	pop rsi
	pop rbp

	ret

JPSDR_HDRTools_BT2446C_16_XYZ_SSE41 endp


;JPSDR_HDRTools_BT2446C_16_XYZ_AVX proc src:dword,dst1:dword,dst2:dword,w8:dword,h:dword,src_pitch:dword,
;	dst_pitch1:dword,dst_pitch2:dword,ValMinX:dword,CoeffX:dword,ValMinZ:dword,CoeffZ:dword
; src = rcx
; dst1 = rdx
; dst2 = r8
; w8 = r9d

JPSDR_HDRTools_BT2446C_16_XYZ_AVX proc public frame

h equ dword ptr[rbp+48]
src_pitch equ qword ptr[rbp+56]
dst_pitch1 equ qword ptr[rbp+64]
dst_pitch2 equ qword ptr[rbp+72]
ValMinX equ qword ptr[rbp+80]
CoeffX equ qword ptr[rbp+88]
ValMinZ equ qword ptr[rbp+96]
CoeffZ equ qword ptr[rbp+104]

	push rbp
	.pushreg rbp
	mov rbp,rsp
	push rsi
	.pushreg rsi
	push rbx
	.pushreg rbx
	push r12
	.pushreg r12
	push r13
	.pushreg r13
	sub rsp,48
	.allocstack 48
	vmovdqa XMMWORD ptr[rsp],xmm6
	.savexmm128 xmm6,0
	vmovdqa XMMWORD ptr[rsp+16],xmm7
	.savexmm128 xmm7,16
	vmovdqa XMMWORD ptr[rsp+32],xmm8
	.savexmm128 xmm8,32
	.endprolog

	mov rsi,ValMinX
	vbroadcastss xmm2,dword ptr[rsi]
	mov rsi,CoeffX
	vbroadcastss xmm3,dword ptr[rsi]

	mov rsi,ValMinZ
	vbroadcastss ymm4,dword ptr[rsi]
	mov rsi,CoeffZ
	vbroadcastss xmm5,dword ptr[rsi]
	
	vmovaps ymm6,YMMWORD ptr data_f_65535
	vmovaps ymm7,YMMWORD ptr data_f_0
	vmulps ymm3,ymm3,ymm6
	vmulps ymm5,ymm5,ymm6
	
	mov rsi,rcx
	mov r10,src_pitch
	mov r11,dst_pitch1
	mov r12,dst_pitch2
	mov r13d,h
	mov rbx,32
	
BT2446C_16_XYZ_AVX_1:
	xor rax,rax
	mov ecx,r9d
BT2446C_16_XYZ_AVX_2:
	vmovaps ymm8,YMMWORD ptr[rsi+rax]
	vmulps ymm0,ymm8,YMMWORD ptr[rdx+rax]
	vmulps ymm1,ymm8,YMMWORD ptr[r8+rax]
	vaddps ymm0,ymm0,ymm2
	vaddps ymm1,ymm1,ymm4
	vmulps ymm0,ymm0,ymm3
	vmulps ymm1,ymm1,ymm5
	vminps ymm0,ymm0,ymm6
	vminps ymm1,ymm1,ymm6
	vmaxps ymm0,ymm0,ymm7
	vmaxps ymm1,ymm1,ymm7
	vcvtps2dq ymm0,ymm0
	vcvtps2dq ymm1,ymm1
	vmovdqa YMMWORD ptr[rdx+rax],ymm0
	vmovdqa YMMWORD ptr[r8+rax],ymm1
	
	add rax,rbx
	loop BT2446C_16_XYZ_AVX_2
	
	add rsi,r10
	add rdx,r11
	add r8,r12
	dec r13d
	jnz short BT2446C_16_XYZ_AVX_1
	
	vmovdqa xmm8,XMMWORD ptr[rsp+32]
	vmovdqa xmm7,XMMWORD ptr[rsp+16]
	vmovdqa xmm6,XMMWORD ptr[rsp]
	add rsp,48

	vzeroupper
	
	pop r13
	pop r12
	pop rbx
	pop rsi
	pop rbp

	ret

JPSDR_HDRTools_BT2446C_16_XYZ_AVX endp


;JPSDR_HDRTools_BT2446C_32_XYZ_SSE2 proc src1:dword,src2:dword,dst1:dword,dst2:dword,w4:dword,h:dword,src_pitch1:dword,
;	src_pitch2:dword,dst_pitch1:dword,dst_pitch2:dword
; src1 = rcx
; src2 = rdx
; dst1 = r8
; dst2 = r9

JPSDR_HDRTools_BT2446C_32_XYZ_SSE2 proc public frame

w4 equ dword ptr[rbp+48]
h equ dword ptr[rbp+56]
src_pitch1 equ qword ptr[rbp+64]
src_pitch2 equ qword ptr[rbp+72]
dst_pitch1 equ qword ptr[rbp+80]
dst_pitch2 equ qword ptr[rbp+88]

	push rbp
	.pushreg rbp
	mov rbp,rsp
	push rsi
	.pushreg rsi
	push rbx
	.pushreg rbx
	push r12
	.pushreg r12
	push r13
	.pushreg r13
	push r14
	.pushreg r14
	push r15
	.pushreg r15
	.endprolog

	mov rsi,rcx
	mov r10,src_pitch1
	mov r11,src_pitch2
	mov r12,dst_pitch1
	mov r13,dst_pitch2
	mov r14d,w4
	mov r15d,h
	mov rbx,16
	
BT2446C_32_XYZ_SSE2_1:
	xor rax,rax
	mov ecx,r14d
BT2446C_32_XYZ_SSE2_2:
	movaps xmm0,XMMWORD ptr[r8+rax]
	movaps xmm1,xmm0
	mulps xmm0,XMMWORD ptr[rsi+rax]
	mulps xmm1,XMMWORD ptr[rdx+rax]
	movaps XMMWORD ptr[r8+rax],xmm0
	movaps XMMWORD ptr[r9+rax],xmm1
	
	add rax,rbx
	loop BT2446C_32_XYZ_SSE2_2
	
	add rsi,r10
	add rdx,r11
	add r8,r12
	add r9,r13
	dec r15d
	jnz short BT2446C_32_XYZ_SSE2_1
	
	pop r15
	pop r14
	pop r13
	pop r12
	pop rbx
	pop rsi
	pop rbp

	ret

JPSDR_HDRTools_BT2446C_32_XYZ_SSE2 endp


;JPSDR_HDRTools_BT2446C_32_XYZ_AVX proc src1:dword,src2:dword,dst1:dword,dst2:dword,w8:dword,h:dword,src_pitch1:dword,
;	src_pitch2:dword,dst_pitch1:dword,dst_pitch2:dword
; src1 = rcx
; src2 = rdx
; dst1 = r8
; dst2 = r9

JPSDR_HDRTools_BT2446C_32_XYZ_AVX proc public frame

w8 equ dword ptr[rbp+48]
h equ dword ptr[rbp+56]
src_pitch1 equ qword ptr[rbp+64]
src_pitch2 equ qword ptr[rbp+72]
dst_pitch1 equ qword ptr[rbp+80]
dst_pitch2 equ qword ptr[rbp+88]

	push rbp
	.pushreg rbp
	mov rbp,rsp
	push rsi
	.pushreg rsi
	push rbx
	.pushreg rbx
	push r12
	.pushreg r12
	push r13
	.pushreg r13
	push r14
	.pushreg r14
	push r15
	.pushreg r15
	.endprolog

	mov rsi,rcx
	mov r10,src_pitch1
	mov r11,src_pitch2
	mov r12,dst_pitch1
	mov r13,dst_pitch2
	mov r14d,w8
	mov r15d,h
	mov rbx,64
	
BT2446C_32_XYZ_AVX_loop_1:
	mov ecx,r14d
	xor rax,rax

	shr ecx,1
	jz short BT2446C_32_XYZ_AVX_1

BT2446C_32_XYZ_AVX_loop_2:
	vmovaps ymm2,YMMWORD ptr[r8+rax]
	vmovaps ymm5,YMMWORD ptr[r8+rax+32]
	vmulps ymm0,ymm2,YMMWORD ptr[rsi+rax]
	vmulps ymm3,ymm5,YMMWORD ptr[rsi+rax+32]
	vmulps ymm1,ymm2,YMMWORD ptr[rdx+rax]
	vmulps ymm4,ymm5,YMMWORD ptr[rdx+rax+32]
	vmovaps YMMWORD ptr[r8+rax],ymm0
	vmovaps YMMWORD ptr[r8+rax+32],ymm3
	vmovaps YMMWORD ptr[r9+rax],ymm1
	vmovaps YMMWORD ptr[r9+rax+32],ymm4
	
	add rax,rbx
	loop BT2446C_32_XYZ_AVX_loop_2

BT2446C_32_XYZ_AVX_1:
	test r14d,1
	jz short BT2446C_32_XYZ_AVX_2

	vmovaps ymm2,YMMWORD ptr[r8+rax]
	vmulps ymm0,ymm2,YMMWORD ptr[rsi+rax]
	vmulps ymm1,ymm2,YMMWORD ptr[rdx+rax]
	vmovaps YMMWORD ptr[r8+rax],ymm0
	vmovaps YMMWORD ptr[r9+rax],ymm1

BT2446C_32_XYZ_AVX_2:
	add rsi,r10
	add rdx,r11
	add r8,r12
	add r9,r13
	dec r15d
	jnz BT2446C_32_XYZ_AVX_loop_1
	
	pop r15
	pop r14
	pop r13
	pop r12
	pop rbx
	pop rsi
	pop rbp

	ret

JPSDR_HDRTools_BT2446C_32_XYZ_AVX endp


;JPSDR_HDRTools_Convert_XYZ_ACES_HDRtoSDR_SSE2 proc src:dword,dst:dword,w4:dword,h:dword,src_pitch:dword,dst_pitch:dword,
;	Coeff1:dword,Coeff2:dword,Coeff3:dword,Coeff4:dword,Coeff5:dword
; src = rcx
; dst = rdx
; w4 = r8d
; h = r9d

JPSDR_HDRTools_Convert_XYZ_ACES_HDRtoSDR_SSE2 proc public frame

src_pitch equ qword ptr[rbp+48]
dst_pitch equ qword ptr[rbp+56]
Coeff1 equ qword ptr[rbp+64]
Coeff2 equ qword ptr[rbp+72]
Coeff3 equ qword ptr[rbp+80]
Coeff4 equ qword ptr[rbp+88]
Coeff5 equ qword ptr[rbp+96]

	push rbp
	.pushreg rbp
	mov rbp,rsp
	push rsi
	.pushreg rsi
	push rbx
	.pushreg rbx
	sub rsp,32
	.allocstack 32
	movdqa XMMWORD ptr[rsp],xmm6
	.savexmm128 xmm6,0
	movdqa XMMWORD ptr[rsp+16],xmm7
	.savexmm128 xmm7,16
	.endprolog

	mov rsi,Coeff1
	movss xmm3,dword ptr[rsi]
	shufps xmm3,xmm3,0
	mov rsi,Coeff2
	movss xmm4,dword ptr[rsi]
	shufps xmm4,xmm4,0
	mov rsi,Coeff3
	movss xmm5,dword ptr[rsi]
	shufps xmm5,xmm5,0
	mov rsi,Coeff4
	movss xmm6,dword ptr[rsi]
	shufps xmm6,xmm6,0
	mov rsi,Coeff5
	movss xmm7,dword ptr[rsi]
	shufps xmm7,xmm7,0
	
	mov rsi,rcx
	mov r10,src_pitch
	mov r11,dst_pitch
	mov rbx,16
	
Convert_XYZ_ACES_HDRtoSDR_SSE2_1:
	xor rax,rax
	mov ecx,r8d
Convert_XYZ_ACES_HDRtoSDR_SSE2_2:	
	movaps xmm0,XMMWORD ptr[rsi+rax]
	
	movaps xmm2,xmm0
	movaps xmm1,xmm0
	
	mulps xmm2,xmm5
	addps xmm1,xmm3
	addps xmm2,xmm6
	mulps xmm1,xmm0
	mulps xmm2,xmm0
	addps xmm1,xmm4
	addps xmm2,xmm7
	
	divps xmm1,xmm2
	
	movaps XMMWORD ptr[rdx+rax],xmm1
	
	add rax,rbx
	loop Convert_XYZ_ACES_HDRtoSDR_SSE2_2
	
	add rsi,r10
	add rdx,r11
	dec r9d
	jnz short Convert_XYZ_ACES_HDRtoSDR_SSE2_1
	
	movdqa xmm7,XMMWORD ptr[rsp+16]
	movdqa xmm6,XMMWORD ptr[rsp]
	add rsp,32
	
	pop rbx
	pop rsi
	pop rbp

	ret

JPSDR_HDRTools_Convert_XYZ_ACES_HDRtoSDR_SSE2 endp


;JPSDR_HDRTools_Convert_XYZ_ACES_HDRtoSDR_AVX proc src:dword,dst:dword,w8:dword,h:dword,src_pitch:dword,dst_pitch:dword,
;	Coeff1:dword,Coeff2:dword,Coeff3:dword,Coeff4:dword,Coeff5:dword
; src = rcx
; dst = rdx
; w8 = r8d
; h = r9d

JPSDR_HDRTools_Convert_XYZ_ACES_HDRtoSDR_AVX proc public frame

src_pitch equ qword ptr[rbp+48]
dst_pitch equ qword ptr[rbp+56]
Coeff1 equ qword ptr[rbp+64]
Coeff2 equ qword ptr[rbp+72]
Coeff3 equ qword ptr[rbp+80]
Coeff4 equ qword ptr[rbp+88]
Coeff5 equ qword ptr[rbp+96]

	push rbp
	.pushreg rbp
	mov rbp,rsp
	push rsi
	.pushreg rsi
	push rdi
	.pushreg rdi
	push rbx
	.pushreg rbx
	sub rsp,88
	.allocstack 88
	vmovdqa XMMWORD ptr[rsp],xmm6
	.savexmm128 xmm6,0
	vmovdqa XMMWORD ptr[rsp+16],xmm7
	.savexmm128 xmm7,16
	vmovdqa XMMWORD ptr[rsp+32],xmm8
	.savexmm128 xmm8,32
	vmovdqa XMMWORD ptr[rsp+48],xmm9
	.savexmm128 xmm9,48
	vmovdqa XMMWORD ptr[rsp+64],xmm10
	.savexmm128 xmm10,64
	.endprolog
	
	mov rsi,Coeff1
	vbroadcastss ymm6,dword ptr[rsi]
	mov rsi,Coeff2
	vbroadcastss ymm7,dword ptr[rsi]
	mov rsi,Coeff3
	vbroadcastss ymm8,dword ptr[rsi]
	mov rsi,Coeff4
	vbroadcastss ymm9,dword ptr[rsi]
	mov rsi,Coeff5
	vbroadcastss ymm10,dword ptr[rsi]
	
	mov rsi,rcx
	mov rdi,rdx
	mov r10,src_pitch
	mov r11,dst_pitch
	mov rbx,64
	mov rdx,1
	
Convert_XYZ_ACES_HDRtoSDR_AVX_loop_1:
	mov ecx,r8d
	xor rax,rax

	shr ecx,1
	jz short Convert_XYZ_ACES_HDRtoSDR_AVX_1

Convert_XYZ_ACES_HDRtoSDR_AVX_loop_2:	
	vmovaps ymm0,YMMWORD ptr[rsi+rax]
	vmovaps ymm3,YMMWORD ptr[rsi+rax+32]
	
	vmulps ymm2,ymm0,ymm8
	vmulps ymm5,ymm3,ymm8
	vaddps ymm1,ymm0,ymm6
	vaddps ymm4,ymm3,ymm6
	vaddps ymm2,ymm2,ymm9
	vaddps ymm5,ymm5,ymm9
	vmulps ymm1,ymm1,ymm0
	vmulps ymm4,ymm4,ymm3
	vmulps ymm2,ymm2,ymm0
	vmulps ymm5,ymm5,ymm3
	vaddps ymm1,ymm1,ymm7
	vaddps ymm4,ymm4,ymm7
	vaddps ymm2,ymm2,ymm10
	vaddps ymm5,ymm5,ymm10

	vdivps ymm1,ymm1,ymm2
	vdivps ymm4,ymm4,ymm5

	vmovaps YMMWORD ptr [rdi+rax],ymm1
	vmovaps YMMWORD ptr [rdi+rax+32],ymm4

	add rax,rbx
	loop Convert_XYZ_ACES_HDRtoSDR_AVX_loop_2

Convert_XYZ_ACES_HDRtoSDR_AVX_1:
	test r8d,edx
	jz short Convert_XYZ_ACES_HDRtoSDR_AVX_2

	vmovaps ymm0,YMMWORD ptr[rsi+rax]
	
	vmulps ymm2,ymm0,ymm8
	vaddps ymm1,ymm0,ymm6
	vaddps ymm2,ymm2,ymm9
	vmulps ymm1,ymm1,ymm0
	vmulps ymm2,ymm2,ymm0
	vaddps ymm1,ymm1,ymm7
	vaddps ymm2,ymm2,ymm10
	
	vdivps ymm1,ymm1,ymm2
	
	vmovaps YMMWORD ptr [rdi+rax],ymm1

Convert_XYZ_ACES_HDRtoSDR_AVX_2:
	add rsi,r10
	add rdi,r11
	dec r9d
	jnz Convert_XYZ_ACES_HDRtoSDR_AVX_loop_1
	
	vmovdqa xmm10,XMMWORD ptr[rsp+64]
	vmovdqa xmm9,XMMWORD ptr[rsp+48]
	vmovdqa xmm8,XMMWORD ptr[rsp+32]
	vmovdqa xmm7,XMMWORD ptr[rsp+16]
	vmovdqa xmm6,XMMWORD ptr[rsp]
	add rsp,88

	vzeroupper
	
	pop rbx
	pop rdi
	pop rsi
	pop rbp

	ret

JPSDR_HDRTools_Convert_XYZ_ACES_HDRtoSDR_AVX endp


;JPSDR_HDRTools_Convert_RGB_ACES_HDRtoSDR_SSE2 proc src:dword,dst:dword,w4:dword,h:dword,src_pitch:dword,dst_pitch:dword,
;	Coeff1:dword,Coeff2:dword,Coeff3:dword,Coeff4:dword,Coeff5:dword
; src = rcx
; dst = rdx
; w4 = r8d
; h = r9d

JPSDR_HDRTools_Convert_RGB_ACES_HDRtoSDR_SSE2 proc public frame

src_pitch equ qword ptr[rbp+48]
dst_pitch equ qword ptr[rbp+56]
Coeff1 equ qword ptr[rbp+64]
Coeff2 equ qword ptr[rbp+72]
Coeff3 equ qword ptr[rbp+80]
Coeff4 equ qword ptr[rbp+88]
Coeff5 equ qword ptr[rbp+96]

	push rbp
	.pushreg rbp
	mov rbp,rsp
	push rsi
	.pushreg rsi
	push rbx
	.pushreg rbx
	sub rsp,32
	.allocstack 32
	movdqa XMMWORD ptr[rsp],xmm6
	.savexmm128 xmm6,0
	movdqa XMMWORD ptr[rsp+16],xmm7
	.savexmm128 xmm7,16
	.endprolog

	mov rsi,Coeff1
	movss xmm3,dword ptr[rsi]
	shufps xmm3,xmm3,0
	mov rsi,Coeff2
	movss xmm4,dword ptr[rsi]
	shufps xmm4,xmm4,0
	mov rsi,Coeff3
	movss xmm5,dword ptr[rsi]
	shufps xmm5,xmm5,0
	mov rsi,Coeff4
	movss xmm6,dword ptr[rsi]
	shufps xmm6,xmm6,0
	mov rsi,Coeff5
	movss xmm7,dword ptr[rsi]
	shufps xmm7,xmm7,0
	
	mov rsi,rcx
	mov r10,src_pitch
	mov r11,dst_pitch
	mov rbx,16
	
Convert_RGB_ACES_HDRtoSDR_SSE2_1:
	xor rax,rax
	mov ecx,r8d
Convert_RGB_ACES_HDRtoSDR_SSE2_2:	
	movaps xmm0,XMMWORD ptr[rsi+rax]
	
	movaps xmm2,xmm0
	movaps xmm1,xmm0
	
	mulps xmm2,xmm5
	mulps xmm1,xmm3
	addps xmm2,xmm6
	addps xmm1,xmm4
	mulps xmm2,xmm0
	mulps xmm1,xmm0
	addps xmm2,xmm7
	
	divps xmm1,xmm2
	
	movaps XMMWORD ptr[rdx+rax],xmm1
	
	add rax,rbx
	loop Convert_RGB_ACES_HDRtoSDR_SSE2_2
	
	add rsi,r10
	add rdx,r11
	dec r9d
	jnz short Convert_RGB_ACES_HDRtoSDR_SSE2_1
	
	movdqa xmm7,XMMWORD ptr[rsp+16]
	movdqa xmm6,XMMWORD ptr[rsp]
	add rsp,32
	
	pop rbx
	pop rsi
	pop rbp

	ret

JPSDR_HDRTools_Convert_RGB_ACES_HDRtoSDR_SSE2 endp


;JPSDR_HDRTools_Convert_RGB_ACES_HDRtoSDR_AVX proc src:dword,dst:dword,w8:dword,h:dword,src_pitch:dword,dst_pitch:dword,
;	Coeff1:dword,Coeff2:dword,Coeff3:dword,Coeff4:dword,Coeff5:dword
; src = rcx
; dst = rdx
; w8 = r8d
; h = r9d

JPSDR_HDRTools_Convert_RGB_ACES_HDRtoSDR_AVX proc public frame

src_pitch equ qword ptr[rbp+48]
dst_pitch equ qword ptr[rbp+56]
Coeff1 equ qword ptr[rbp+64]
Coeff2 equ qword ptr[rbp+72]
Coeff3 equ qword ptr[rbp+80]
Coeff4 equ qword ptr[rbp+88]
Coeff5 equ qword ptr[rbp+96]

	push rbp
	.pushreg rbp
	mov rbp,rsp
	push rsi
	.pushreg rsi
	push rdi
	.pushreg rdi
	push rbx
	.pushreg rbx
	sub rsp,88
	.allocstack 88
	vmovdqa XMMWORD ptr[rsp],xmm6
	.savexmm128 xmm6,0
	vmovdqa XMMWORD ptr[rsp+16],xmm7
	.savexmm128 xmm7,16
	vmovdqa XMMWORD ptr[rsp+32],xmm8
	.savexmm128 xmm8,32
	vmovdqa XMMWORD ptr[rsp+48],xmm9
	.savexmm128 xmm9,48
	vmovdqa XMMWORD ptr[rsp+64],xmm10
	.savexmm128 xmm10,64
	.endprolog

	mov rsi,Coeff1
	vbroadcastss ymm6,dword ptr[rsi]
	mov rsi,Coeff2
	vbroadcastss ymm7,dword ptr[rsi]
	mov rsi,Coeff3
	vbroadcastss ymm8,dword ptr[rsi]
	mov rsi,Coeff4
	vbroadcastss ymm9,dword ptr[rsi]
	mov rsi,Coeff5
	vbroadcastss ymm10,dword ptr[rsi]

	mov rsi,rcx
	mov rdi,rdx
	mov r10,src_pitch
	mov r11,dst_pitch
	mov rbx,64
	mov rdx,1

Convert_RGB_ACES_HDRtoSDR_AVX_loop_1:
	mov ecx,r8d
	xor rax,rax

	shr ecx,1
	jz short Convert_RGB_ACES_HDRtoSDR_AVX_1

Convert_RGB_ACES_HDRtoSDR_AVX_loop_2:	
	vmovaps ymm0,YMMWORD ptr[rsi+rax]
	vmovaps ymm3,YMMWORD ptr[rsi+rax+32]

	vmulps ymm2,ymm0,ymm8
	vmulps ymm5,ymm3,ymm8
	vmulps ymm1,ymm0,ymm6
	vmulps ymm4,ymm3,ymm6
	vaddps ymm2,ymm2,ymm9
	vaddps ymm5,ymm5,ymm9
	vaddps ymm1,ymm1,ymm7
	vaddps ymm4,ymm4,ymm7
	vmulps ymm2,ymm2,ymm0
	vmulps ymm5,ymm5,ymm3
	vmulps ymm1,ymm1,ymm0
	vmulps ymm4,ymm4,ymm3
	vaddps ymm2,ymm2,ymm10
	vaddps ymm5,ymm5,ymm10

	vdivps ymm1,ymm1,ymm2
	vdivps ymm4,ymm4,ymm5

	vmovaps YMMWORD ptr [rdi+rax],ymm1
	vmovaps YMMWORD ptr [rdi+rax+32],ymm4

	add rax,rbx
	loop Convert_RGB_ACES_HDRtoSDR_AVX_loop_2

Convert_RGB_ACES_HDRtoSDR_AVX_1:
	test r8d,edx
	jz short Convert_RGB_ACES_HDRtoSDR_AVX_2

	vmovaps ymm0,YMMWORD ptr[rsi+rax]

	vmulps ymm2,ymm0,ymm8
	vmulps ymm1,ymm0,ymm6
	vaddps ymm2,ymm2,ymm9
	vaddps ymm1,ymm1,ymm7
	vmulps ymm2,ymm2,ymm0
	vmulps ymm1,ymm1,ymm0
	vaddps ymm2,ymm2,ymm10

	vdivps ymm1,ymm1,ymm2

	vmovaps YMMWORD ptr [rdi+rax],ymm1

Convert_RGB_ACES_HDRtoSDR_AVX_2:
	add rsi,r10
	add rdi,r11
	dec r9d
	jnz Convert_RGB_ACES_HDRtoSDR_AVX_loop_1
	
	vmovdqa xmm10,XMMWORD ptr[rsp+64]
	vmovdqa xmm9,XMMWORD ptr[rsp+48]
	vmovdqa xmm8,XMMWORD ptr[rsp+32]
	vmovdqa xmm7,XMMWORD ptr[rsp+16]
	vmovdqa xmm6,XMMWORD ptr[rsp]
	add rsp,88

	vzeroupper

	pop rbx
	pop rdi
	pop rsi
	pop rbp

	ret

JPSDR_HDRTools_Convert_RGB_ACES_HDRtoSDR_AVX endp


end
