;
;  MatrixClass
;
;  Matrix and vector class allowing several operations.
;  Copyright (C) 2017 JPSDR
;	
;  MatrixClass is free software; you can redistribute it and/or modify
;  it under the terms of the GNU General Public License as published by
;  the Free Software Foundation; either version 2, or (at your option)
;  any later version.
;   
;  MatrixClass is distributed in the hope that it will be useful,
;  but WITHOUT ANY WARRANTY; without even the implied warranty of
;  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
;  GNU General Public License for more details.
;   
;  You should have received a copy of the GNU General Public License
;  along with GNU Make; see the file COPYING.  If not, write to
;  the Free Software Foundation, 675 Mass Ave, Cambridge, MA 02139, USA. 
;
;

data segment align(32)

sign_bits_f_32 dword 8 dup(7FFFFFFFh)
sign_bits_f_64 qword 4 dup(7FFFFFFFFFFFFFFFh)

.code


;CoeffProductF_SSE2 proc coeff_a:dword,coeff_b:dword,coeff_c:dword,lgth:word
; coeff_a = rcx
; coeff_b = rdx
; coeff_c = r8
; lgth = r9d

CoeffProductF_SSE2 proc public frame

	.endprolog
	
	movss xmm0,dword ptr[rcx]
	pshufd xmm0,xmm0,0

	xor rcx,rcx
	mov rax,16
	mov ecx,r9d
	
CoeffProductF_SSE2_1:	
	movaps xmm1,XMMWORD ptr[rdx]
	add rdx,rax
	mulps xmm1,xmm0
	movaps XMMWORD ptr[r8],xmm1
	add r8,rax
	loop CoeffProductF_SSE2_1
	
	ret
	
CoeffProductF_SSE2 endp	


;CoeffProduct2F_SSE2 proc coeff_a:dword,coeff_b:dword,lgth:word
; coeff_a = rcx
; coeff_b = rdx
; lgth = r8d

CoeffProduct2F_SSE2 proc public frame

	.endprolog
	
	movss xmm0,dword ptr[rcx]
	pshufd xmm0,xmm0,0

	xor rcx,rcx
	mov rax,16
	mov ecx,r8d
	
CoeffProduct2F_SSE2_1:	
	movaps xmm1,XMMWORD ptr[rdx]
	mulps xmm1,xmm0
	movaps XMMWORD ptr[rdx],xmm1
	add rdx,rax
	loop CoeffProduct2F_SSE2_1
	
	ret
	
CoeffProduct2F_SSE2 endp	


;CoeffProductF_AVX proc coeff_a:dword,coeff_b:dword,coeff_c:dword,lgth:word
; coeff_a = rcx
; coeff_b = rdx
; coeff_c = r8
; lgth = r9d

CoeffProductF_AVX proc public frame

	push rdi
	.pushreg rdi
	push rsi
	.pushreg rsi
	push r12
	.pushreg r12
	push r13
	.pushreg r13
	push r14
	.pushreg r14
	sub rsp,48
	.allocstack 48
	vmovdqa XMMWORD ptr[rsp],xmm6
	.savexmm128 xmm6,0
	vmovdqa XMMWORD ptr[rsp+16],xmm7
	.savexmm128 xmm7,16
	vmovdqa XMMWORD ptr[rsp+32],xmm8
	.savexmm128 xmm8,32
	.endprolog
	
	vbroadcastss ymm0,dword ptr[rcx]

	mov rsi,rdx 	; coeff_b
	mov rdi,r8		; coeff_c
	mov edx,r9d		; lgth
	mov ecx,r9d		; lgth
	mov rax,256
	mov r8,32
	mov r9,64
	mov r10,96
	mov r11,128
	mov r12,160
	mov r13,192
	mov r14,224

	shr ecx,3
	jz short CoeffProductF_AVX_1

CoeffProductF_AVX_loop_1:
	vmulps ymm1,ymm0,YMMWORD ptr[rsi]
	vmulps ymm2,ymm0,YMMWORD ptr[rsi+r8]
	vmulps ymm3,ymm0,YMMWORD ptr[rsi+r9]
	vmulps ymm4,ymm0,YMMWORD ptr[rsi+r10]
	vmulps ymm5,ymm0,YMMWORD ptr[rsi+r11]
	vmulps ymm6,ymm0,YMMWORD ptr[rsi+r12]
	vmulps ymm7,ymm0,YMMWORD ptr[rsi+r13]
	vmulps ymm8,ymm0,YMMWORD ptr[rsi+r14]
	vmovaps YMMWORD ptr[rdi],ymm1
	vmovaps YMMWORD ptr[rdi+r8],ymm2
	vmovaps YMMWORD ptr[rdi+r9],ymm3
	vmovaps YMMWORD ptr[rdi+r10],ymm4
	vmovaps YMMWORD ptr[rdi+r11],ymm5
	vmovaps YMMWORD ptr[rdi+r12],ymm6
	vmovaps YMMWORD ptr[rdi+r13],ymm7
	vmovaps YMMWORD ptr[rdi+r14],ymm8
	add rsi,rax
	add rdi,rax
	loop CoeffProductF_AVX_loop_1

CoeffProductF_AVX_1:
	test edx,4
	jz short CoeffProductF_AVX_2

	vmulps ymm1,ymm0,YMMWORD ptr[rsi]
	vmulps ymm2,ymm0,YMMWORD ptr[rsi+r8]
	vmulps ymm3,ymm0,YMMWORD ptr[rsi+r9]
	vmulps ymm4,ymm0,YMMWORD ptr[rsi+r10]
	vmovaps YMMWORD ptr[rdi],ymm1
	vmovaps YMMWORD ptr[rdi+r8],ymm2
	vmovaps YMMWORD ptr[rdi+r9],ymm3
	vmovaps YMMWORD ptr[rdi+r10],ymm4
	add rsi,r11
	add rdi,r11

CoeffProductF_AVX_2:
	test edx,2
	jz short CoeffProductF_AVX_3

	vmulps ymm1,ymm0,YMMWORD ptr[rsi]
	vmulps ymm2,ymm0,YMMWORD ptr[rsi+r8]
	vmovaps YMMWORD ptr[rdi],ymm1
	vmovaps YMMWORD ptr[rdi+r8],ymm2
	add rsi,r9
	add rdi,r9

CoeffProductF_AVX_3:
	test edx,1
	jz short CoeffProductF_AVX_4

	vmulps ymm1,ymm0,YMMWORD ptr[rsi]
	vmovaps YMMWORD ptr[rdi],ymm1

CoeffProductF_AVX_4:
	vmovdqa xmm8,XMMWORD ptr[rsp+32]
	vmovdqa xmm7,XMMWORD ptr[rsp+16]
	vmovdqa xmm6,XMMWORD ptr[rsp]
	add rsp,48

	vzeroupper

	pop r14
	pop r13
	pop r12
	pop rsi
	pop rdi

	ret

CoeffProductF_AVX endp	


;CoeffProduct2F_AVX proc coeff_a:dword,coeff_b:dword,lgth:word
; coeff_a = rcx
; coeff_b = rdx
; lgth = r8d

CoeffProduct2F_AVX proc public frame

	push rsi
	.pushreg rsi
	push r12
	.pushreg r12
	push r13
	.pushreg r13
	push r14
	.pushreg r14
	sub rsp,56
	.allocstack 56
	vmovdqa XMMWORD ptr[rsp],xmm6
	.savexmm128 xmm6,0
	vmovdqa XMMWORD ptr[rsp+16],xmm7
	.savexmm128 xmm7,16
	vmovdqa XMMWORD ptr[rsp+32],xmm8
	.savexmm128 xmm8,32
	.endprolog

	vbroadcastss ymm0,dword ptr[rcx]

	mov rsi,rdx 	; coeff_b
	mov ecx,r8d		; lgth
	mov edx,r8d		; lgth
	mov rax,256
	mov r8,32
	mov r9,64
	mov r10,96
	mov r11,128
	mov r12,160
	mov r13,192
	mov r14,224

	shr ecx,3
	jz short CoeffProduct2F_AVX_1

CoeffProduct2F_AVX_loop_1:
	vmulps ymm1,ymm0,YMMWORD ptr[rsi]
	vmulps ymm2,ymm0,YMMWORD ptr[rsi+r8]
	vmulps ymm3,ymm0,YMMWORD ptr[rsi+r9]
	vmulps ymm4,ymm0,YMMWORD ptr[rsi+r10]
	vmulps ymm5,ymm0,YMMWORD ptr[rsi+r11]
	vmulps ymm6,ymm0,YMMWORD ptr[rsi+r12]
	vmulps ymm7,ymm0,YMMWORD ptr[rsi+r13]
	vmulps ymm8,ymm0,YMMWORD ptr[rsi+r14]
	vmovaps YMMWORD ptr[rsi],ymm1
	vmovaps YMMWORD ptr[rsi+r8],ymm2
	vmovaps YMMWORD ptr[rsi+r9],ymm3
	vmovaps YMMWORD ptr[rsi+r10],ymm4
	vmovaps YMMWORD ptr[rsi+r11],ymm5
	vmovaps YMMWORD ptr[rsi+r12],ymm6
	vmovaps YMMWORD ptr[rsi+r13],ymm7
	vmovaps YMMWORD ptr[rsi+r14],ymm8
	add rsi,rax
	loop CoeffProduct2F_AVX_loop_1

CoeffProduct2F_AVX_1:
	test edx,4
	jz short CoeffProduct2F_AVX_2

	vmulps ymm1,ymm0,YMMWORD ptr[rsi]
	vmulps ymm2,ymm0,YMMWORD ptr[rsi+r8]
	vmulps ymm3,ymm0,YMMWORD ptr[rsi+r9]
	vmulps ymm4,ymm0,YMMWORD ptr[rsi+r10]
	vmovaps YMMWORD ptr[rsi],ymm1
	vmovaps YMMWORD ptr[rsi+r8],ymm2
	vmovaps YMMWORD ptr[rsi+r9],ymm3
	vmovaps YMMWORD ptr[rsi+r10],ymm4
	add rsi,r11

CoeffProduct2F_AVX_2:
	test edx,2
	jz short CoeffProduct2F_AVX_3

	vmulps ymm1,ymm0,YMMWORD ptr[rsi]
	vmulps ymm2,ymm0,YMMWORD ptr[rsi+r8]
	vmovaps YMMWORD ptr[rsi],ymm1
	vmovaps YMMWORD ptr[rsi+r8],ymm2
	add rsi,r9

CoeffProduct2F_AVX_3:
	test edx,1
	jz short CoeffProduct2F_AVX_4

	vmulps ymm1,ymm0,YMMWORD ptr[rsi]
	vmovaps YMMWORD ptr[rsi],ymm1

CoeffProduct2F_AVX_4:
	vmovdqa xmm8,XMMWORD ptr[rsp+32]
	vmovdqa xmm7,XMMWORD ptr[rsp+16]
	vmovdqa xmm6,XMMWORD ptr[rsp]
	add rsp,56

	vzeroupper

	pop r14
	pop r13
	pop r12
	pop rsi
	
	ret
	
CoeffProduct2F_AVX endp	


;CoeffProductD_SSE2 proc coeff_a:dword,coeff_b:dword,coeff_c:dword,lgth:word
; coeff_a = rcx
; coeff_b = rdx
; coeff_c = r8
; lgth = r9d

CoeffProductD_SSE2 proc public frame
	
	.endprolog
	
	movsd xmm0,qword ptr[rcx]
	movlhps xmm0,xmm0
	
	xor rcx,rcx
	mov rax,16
	mov ecx,r9d
	
CoeffProductD_SSE2_1:	
	movapd xmm1,XMMWORD ptr[rdx]
	add rdx,rax
	mulpd xmm1,xmm0
	movapd XMMWORD ptr[r8],xmm1
	add r8,rax
	loop CoeffProductD_SSE2_1
	
	ret
	
CoeffProductD_SSE2 endp		


;CoeffProduct2D_SSE2 proc coeff_a:dword,coeff_b:dword,lgth:word
; coeff_a = rcx
; coeff_b = rdx
; lgth = r8d

CoeffProduct2D_SSE2 proc public frame
	
	.endprolog
	
	movsd xmm0,qword ptr[rcx]
	movlhps xmm0,xmm0
	
	xor rcx,rcx
	mov rax,16
	mov ecx,r8d
	
CoeffProduct2D_SSE2_1:	
	movapd xmm1,XMMWORD ptr[rdx]
	mulpd xmm1,xmm0
	movapd XMMWORD ptr[rdx],xmm1
	add rdx,rax
	loop CoeffProduct2D_SSE2_1
	
	ret
	
CoeffProduct2D_SSE2 endp	


;CoeffProductD_AVX proc coeff_a:dword,coeff_b:dword,coeff_c:dword,lgth:word
; coeff_a = rcx
; coeff_b = rdx
; coeff_c = r8
; lgth = r9d

CoeffProductD_AVX proc public frame

	push rdi
	.pushreg rdi
	push rsi
	.pushreg rsi
	push r12
	.pushreg r12
	push r13
	.pushreg r13
	push r14
	.pushreg r14
	sub rsp,48
	.allocstack 48
	vmovdqa XMMWORD ptr[rsp],xmm6
	.savexmm128 xmm6,0
	vmovdqa XMMWORD ptr[rsp+16],xmm7
	.savexmm128 xmm7,16
	vmovdqa XMMWORD ptr[rsp+32],xmm8
	.savexmm128 xmm8,32
	.endprolog
	
	vbroadcastsd ymm0,qword ptr[rcx]

	mov rsi,rdx 	; coeff_b
	mov rdi,r8		; coeff_c
	mov edx,r9d		; lgth
	mov ecx,r9d		; lgth
	mov rax,256
	mov r8,32
	mov r9,64
	mov r10,96
	mov r11,128
	mov r12,160
	mov r13,192
	mov r14,224

	shr ecx,3
	jz short CoeffProductD_AVX_1
	
CoeffProductD_AVX_loop_1:
	vmulpd ymm1,ymm0,YMMWORD ptr[rsi]
	vmulpd ymm2,ymm0,YMMWORD ptr[rsi+r8]
	vmulpd ymm3,ymm0,YMMWORD ptr[rsi+r9]
	vmulpd ymm4,ymm0,YMMWORD ptr[rsi+r10]
	vmulpd ymm5,ymm0,YMMWORD ptr[rsi+r11]
	vmulpd ymm6,ymm0,YMMWORD ptr[rsi+r12]
	vmulpd ymm7,ymm0,YMMWORD ptr[rsi+r13]
	vmulpd ymm8,ymm0,YMMWORD ptr[rsi+r14]
	vmovapd YMMWORD ptr[rdi],ymm1
	vmovapd YMMWORD ptr[rdi+r8],ymm2
	vmovapd YMMWORD ptr[rdi+r9],ymm3
	vmovapd YMMWORD ptr[rdi+r10],ymm4
	vmovapd YMMWORD ptr[rdi+r11],ymm5
	vmovapd YMMWORD ptr[rdi+r12],ymm6
	vmovapd YMMWORD ptr[rdi+r13],ymm7
	vmovapd YMMWORD ptr[rdi+r14],ymm8
	add rsi,rax
	add rdi,rax
	loop CoeffProductD_AVX_loop_1

CoeffProductD_AVX_1:
	test edx,4
	jz short CoeffProductD_AVX_2

	vmulpd ymm1,ymm0,YMMWORD ptr[rsi]
	vmulpd ymm2,ymm0,YMMWORD ptr[rsi+r8]
	vmulpd ymm3,ymm0,YMMWORD ptr[rsi+r9]
	vmulpd ymm4,ymm0,YMMWORD ptr[rsi+r10]
	vmovapd YMMWORD ptr[rdi],ymm1
	vmovapd YMMWORD ptr[rdi+r8],ymm2
	vmovapd YMMWORD ptr[rdi+r9],ymm3
	vmovapd YMMWORD ptr[rdi+r10],ymm4
	add rsi,r11
	add rdi,r11

CoeffProductD_AVX_2:
	test edx,2
	jz short CoeffProductD_AVX_3

	vmulpd ymm1,ymm0,YMMWORD ptr[rsi]
	vmulpd ymm2,ymm0,YMMWORD ptr[rsi+r8]
	vmovapd YMMWORD ptr[rdi],ymm1
	vmovapd YMMWORD ptr[rdi+r8],ymm2
	add rsi,r9
	add rdi,r9

CoeffProductD_AVX_3:
	test edx,1
	jz short CoeffProductD_AVX_4

	vmulpd ymm1,ymm0,YMMWORD ptr[rsi]
	vmovapd YMMWORD ptr[rdi],ymm1

CoeffProductD_AVX_4:
	vmovdqa xmm8,XMMWORD ptr[rsp+32]
	vmovdqa xmm7,XMMWORD ptr[rsp+16]
	vmovdqa xmm6,XMMWORD ptr[rsp]
	add rsp,48

	vzeroupper

	pop r14
	pop r13
	pop r12
	pop rsi
	pop rdi

	ret

CoeffProductD_AVX endp	


;CoeffProduct2D_AVX proc coeff_a:dword,coeff_b:dword,lgth:word
; coeff_a = rcx
; coeff_b = rdx
; lgth = r8d

CoeffProduct2D_AVX proc public frame

	push rsi
	.pushreg rsi
	push r12
	.pushreg r12
	push r13
	.pushreg r13
	push r14
	.pushreg r14
	sub rsp,56
	.allocstack 56
	vmovdqa XMMWORD ptr[rsp],xmm6
	.savexmm128 xmm6,0
	vmovdqa XMMWORD ptr[rsp+16],xmm7
	.savexmm128 xmm7,16
	vmovdqa XMMWORD ptr[rsp+32],xmm8
	.savexmm128 xmm8,32
	.endprolog
	
	vbroadcastsd ymm0,qword ptr[rcx]

	mov rsi,rdx 	; coeff_b
	mov ecx,r8d		; lgth
	mov edx,r8d		; lgth
	mov rax,256
	mov r8,32
	mov r9,64
	mov r10,96
	mov r11,128
	mov r12,160
	mov r13,192
	mov r14,224

	shr ecx,3
	jz short CoeffProduct2D_AVX_1

CoeffProduct2D_AVX_loop_1:
	vmulpd ymm1,ymm0,YMMWORD ptr[rsi]
	vmulpd ymm2,ymm0,YMMWORD ptr[rsi+r8]
	vmulpd ymm3,ymm0,YMMWORD ptr[rsi+r9]
	vmulpd ymm4,ymm0,YMMWORD ptr[rsi+r10]
	vmulpd ymm5,ymm0,YMMWORD ptr[rsi+r11]
	vmulpd ymm6,ymm0,YMMWORD ptr[rsi+r12]
	vmulpd ymm7,ymm0,YMMWORD ptr[rsi+r13]
	vmulpd ymm8,ymm0,YMMWORD ptr[rsi+r14]
	vmovapd YMMWORD ptr[rsi],ymm1
	vmovapd YMMWORD ptr[rsi+r8],ymm2
	vmovapd YMMWORD ptr[rsi+r9],ymm3
	vmovapd YMMWORD ptr[rsi+r10],ymm4
	vmovapd YMMWORD ptr[rsi+r11],ymm5
	vmovapd YMMWORD ptr[rsi+r12],ymm6
	vmovapd YMMWORD ptr[rsi+r13],ymm7
	vmovapd YMMWORD ptr[rsi+r14],ymm8
	add rsi,rax
	loop CoeffProduct2D_AVX_loop_1

CoeffProduct2D_AVX_1:
	test edx,4
	jz short CoeffProduct2D_AVX_2

	vmulpd ymm1,ymm0,YMMWORD ptr[rsi]
	vmulpd ymm2,ymm0,YMMWORD ptr[rsi+r8]
	vmulpd ymm3,ymm0,YMMWORD ptr[rsi+r9]
	vmulpd ymm4,ymm0,YMMWORD ptr[rsi+r10]
	vmovapd YMMWORD ptr[rsi],ymm1
	vmovapd YMMWORD ptr[rsi+r8],ymm2
	vmovapd YMMWORD ptr[rsi+r9],ymm3
	vmovapd YMMWORD ptr[rsi+r10],ymm4
	add rsi,r11

CoeffProduct2D_AVX_2:
	test edx,2
	jz short CoeffProduct2D_AVX_3

	vmulpd ymm1,ymm0,YMMWORD ptr[rsi]
	vmulpd ymm2,ymm0,YMMWORD ptr[rsi+r8]
	vmovapd YMMWORD ptr[rsi],ymm1
	vmovapd YMMWORD ptr[rsi+r8],ymm2
	add rsi,r9

CoeffProduct2D_AVX_3:
	test edx,1
	jz short CoeffProduct2D_AVX_4

	vmulpd ymm1,ymm0,YMMWORD ptr[rsi]
	vmovapd YMMWORD ptr[rsi],ymm1

CoeffProduct2D_AVX_4:
	vmovdqa xmm8,XMMWORD ptr[rsp+32]
	vmovdqa xmm7,XMMWORD ptr[rsp+16]
	vmovdqa xmm6,XMMWORD ptr[rsp]
	add rsp,56

	vzeroupper

	pop r14
	pop r13
	pop r12
	pop rsi

	ret

CoeffProduct2D_AVX endp


;CoeffAddProductF_SSE2 proc coeff_a:dword,coeff_b:dword,coeff_c:dword,lgth:word
; coeff_a = rcx
; coeff_b = rdx
; coeff_c = r8
; lgth = r9d

CoeffAddProductF_SSE2 proc public frame
	
	.endprolog
	
	movss xmm0,dword ptr[rcx]
	pshufd xmm0,xmm0,0
	
	xor rcx,rcx
	mov rax,16
	mov ecx,r9d
	
CoeffAddProductF_SSE2_1:	
	movaps xmm1,XMMWORD ptr[rdx]
	movaps xmm2,XMMWORD ptr[r8]
	mulps xmm1,xmm0
	add rdx,rax
	addps xmm2,xmm1
	movaps XMMWORD ptr[r8],xmm2
	add r8,rax
	loop CoeffAddProductF_SSE2_1
	
	ret
	
CoeffAddProductF_SSE2 endp	


;CoeffAddProductF_AVX proc coeff_a:dword,coeff_b:dword,coeff_c:dword,lgth:word
; coeff_a = rcx
; coeff_b = rdx
; coeff_c = r8
; lgth = r9d

CoeffAddProductF_AVX proc public frame

	push rdi
	.pushreg rdi
	push rsi
	.pushreg rsi
	sub rsp,56
	.allocstack 56
	vmovdqa XMMWORD ptr[rsp],xmm6
	.savexmm128 xmm6,0
	vmovdqa XMMWORD ptr[rsp+16],xmm7
	.savexmm128 xmm7,16
	vmovdqa XMMWORD ptr[rsp+32],xmm8
	.savexmm128 xmm8,32
	.endprolog

	vbroadcastss ymm0,dword ptr[rcx]

	mov rsi,rdx 	; coeff_b
	mov rdi,r8		; coeff_c
	mov edx,r9d		; lgth
	mov ecx,r9d		; lgth
	mov rax,128
	mov r8,32
	mov r9,64
	mov r10,96

	shr ecx,2
	jz short CoeffAddProductF_AVX_1

CoeffAddProductF_AVX_loop_1:
	vmulps ymm1,ymm0,YMMWORD ptr[rsi]
	vmulps ymm3,ymm0,YMMWORD ptr[rsi+r8]
	vmulps ymm5,ymm0,YMMWORD ptr[rsi+r9]
	vmulps ymm7,ymm0,YMMWORD ptr[rsi+r10]
	vaddps ymm2,ymm1,YMMWORD ptr[rdi]
	vaddps ymm4,ymm3,YMMWORD ptr[rdi+r8]
	vaddps ymm6,ymm5,YMMWORD ptr[rdi+r9]
	vaddps ymm8,ymm7,YMMWORD ptr[rdi+r10]
	vmovaps YMMWORD ptr[rdi],ymm2
	vmovaps YMMWORD ptr[rdi+r8],ymm4
	vmovaps YMMWORD ptr[rdi+r9],ymm6
	vmovaps YMMWORD ptr[rdi+r10],ymm8
	add rsi,rax
	add rdi,rax
	loop CoeffAddProductF_AVX_loop_1

CoeffAddProductF_AVX_1:
	test edx,2
	jz short CoeffAddProductF_AVX_2

	vmulps ymm1,ymm0,YMMWORD ptr[rsi]
	vmulps ymm3,ymm0,YMMWORD ptr[rsi+r8]
	vaddps ymm2,ymm1,YMMWORD ptr[rdi]
	vaddps ymm4,ymm3,YMMWORD ptr[rdi+r8]
	vmovaps YMMWORD ptr[rdi],ymm2
	vmovaps YMMWORD ptr[rdi+r8],ymm4
	add rsi,r9
	add rdi,r9

CoeffAddProductF_AVX_2:
	test edx,1
	jz short CoeffAddProductF_AVX_3

	vmulps ymm1,ymm0,YMMWORD ptr[rsi]
	vaddps ymm2,ymm1,YMMWORD ptr[rdi]
	vmovaps YMMWORD ptr[rdi],ymm2

CoeffAddProductF_AVX_3:
	vmovdqa xmm8,XMMWORD ptr[rsp+32]
	vmovdqa xmm7,XMMWORD ptr[rsp+16]
	vmovdqa xmm6,XMMWORD ptr[rsp]
	add rsp,56

	vzeroupper

	pop rsi
	pop rdi

	ret

CoeffAddProductF_AVX endp


;CoeffAddProductD_SSE2 proc coeff_a:dword,coeff_b:dword,coeff_c:dword,lgth:word
; coeff_a = rcx
; coeff_b = rdx
; coeff_c = r8
; lgth = r9d

CoeffAddProductD_SSE2 proc public frame
	
	.endprolog
	
	movsd xmm0,qword ptr[rcx]
	movlhps xmm0,xmm0
	
	xor rcx,rcx
	mov rax,16
	mov ecx,r9d

CoeffAddProductD_SSE2_1:	
	movapd xmm1,XMMWORD ptr[rdx]
	movapd xmm2,XMMWORD ptr[r8]
	mulpd xmm1,xmm0
	add rdx,rax
	addpd xmm2,xmm1
	movapd XMMWORD ptr[r8],xmm2
	add r8,rax
	loop CoeffAddProductD_SSE2_1
	
	ret
	
CoeffAddProductD_SSE2 endp	


;CoeffAddProductD_AVX proc coeff_a:dword,coeff_b:dword,coeff_c:dword,lgth:word
; coeff_a = rcx
; coeff_b = rdx
; coeff_c = r8
; lgth = r9d

CoeffAddProductD_AVX proc public frame

	push rdi
	.pushreg rdi
	push rsi
	.pushreg rsi
	sub rsp,56
	.allocstack 56
	vmovdqa XMMWORD ptr[rsp],xmm6
	.savexmm128 xmm6,0
	vmovdqa XMMWORD ptr[rsp+16],xmm7
	.savexmm128 xmm7,16
	vmovdqa XMMWORD ptr[rsp+32],xmm8
	.savexmm128 xmm8,32
	.endprolog

	vbroadcastsd ymm0,qword ptr[rcx]

	mov rsi,rdx 	; coeff_b
	mov rdi,r8		; coeff_c
	mov edx,r9d		; lgth
	mov ecx,r9d		; lgth
	mov rax,128
	mov r8,32
	mov r9,64
	mov r10,96

	shr ecx,2
	jz short CoeffAddProductD_AVX_1

CoeffAddProductD_AVX_loop_1:
	vmulpd ymm1,ymm0,YMMWORD ptr[rsi]
	vmulpd ymm3,ymm0,YMMWORD ptr[rsi+r8]
	vmulpd ymm5,ymm0,YMMWORD ptr[rsi+r9]
	vmulpd ymm7,ymm0,YMMWORD ptr[rsi+r10]
	vaddpd ymm2,ymm1,YMMWORD ptr[rdi]
	vaddpd ymm4,ymm3,YMMWORD ptr[rdi+r8]
	vaddpd ymm6,ymm5,YMMWORD ptr[rdi+r9]
	vaddpd ymm8,ymm7,YMMWORD ptr[rdi+r10]
	vmovapd YMMWORD ptr[rdi],ymm2
	vmovapd YMMWORD ptr[rdi+r8],ymm4
	vmovapd YMMWORD ptr[rdi+r9],ymm6
	vmovapd YMMWORD ptr[rdi+r10],ymm8
	add rsi,rax
	add rdi,rax
	loop CoeffAddProductD_AVX_loop_1

CoeffAddProductD_AVX_1:
	test edx,2
	jz short CoeffAddProductD_AVX_2

	vmulpd ymm1,ymm0,YMMWORD ptr[rsi]
	vmulpd ymm3,ymm0,YMMWORD ptr[rsi+r8]
	vaddpd ymm2,ymm1,YMMWORD ptr[rdi]
	vaddpd ymm4,ymm3,YMMWORD ptr[rdi+r8]
	vmovapd YMMWORD ptr[rdi],ymm2
	vmovapd YMMWORD ptr[rdi+r8],ymm4
	add rsi,r9
	add rdi,r9

CoeffAddProductD_AVX_2:
	test edx,1
	jz short CoeffAddProductD_AVX_3

	vmulpd ymm1,ymm0,YMMWORD ptr[rsi]
	vaddpd ymm2,ymm1,YMMWORD ptr[rdi]
	vmovapd YMMWORD ptr[rdi],ymm2

CoeffAddProductD_AVX_3:
	vmovdqa xmm8,XMMWORD ptr[rsp+32]
	vmovdqa xmm7,XMMWORD ptr[rsp+16]
	vmovdqa xmm6,XMMWORD ptr[rsp]
	add rsp,56

	vzeroupper

	pop rsi
	pop rdi

	ret

CoeffAddProductD_AVX endp


;CoeffAddF_SSE2 proc coeff_a:dword,coeff_b:dword,coeff_c:dword,lgth:word
; coeff_a = rcx
; coeff_b = rdx
; coeff_c = r8
; lgth = r9d

CoeffAddF_SSE2 proc public frame

	.endprolog
	
	movss xmm0,dword ptr[rcx]
	pshufd xmm0,xmm0,0

	xor rcx,rcx
	mov rax,16
	mov ecx,r9d
	
CoeffAddF_SSE2_1:	
	movaps xmm1,XMMWORD ptr[rdx]
	add rdx,rax
	addps xmm1,xmm0
	movaps XMMWORD ptr[r8],xmm1
	add r8,rax
	loop CoeffAddF_SSE2_1
	
	ret
	
CoeffAddF_SSE2 endp	


;CoeffAdd2F_SSE2 proc coeff_a:dword,coeff_b:dword,lgth:word
; coeff_a = rcx
; coeff_b = rdx
; lgth = r8d

CoeffAdd2F_SSE2 proc public frame

	.endprolog
	
	movss xmm0,dword ptr[rcx]
	pshufd xmm0,xmm0,0

	xor rcx,rcx
	mov rax,16
	mov ecx,r8d
	
CoeffAdd2F_SSE2_1:	
	movaps xmm1,XMMWORD ptr[rdx]
	addps xmm1,xmm0
	movaps XMMWORD ptr[rdx],xmm1
	add rdx,rax
	loop CoeffAdd2F_SSE2_1
	
	ret
	
CoeffAdd2F_SSE2 endp	


;CoeffAddF_AVX proc coeff_a:dword,coeff_b:dword,coeff_c:dword,lgth:word
; coeff_a = rcx
; coeff_b = rdx
; coeff_c = r8
; lgth = r9d

CoeffAddF_AVX proc public frame

	push rdi
	.pushreg rdi
	push rsi
	.pushreg rsi
	push r12
	.pushreg r12
	push r13
	.pushreg r13
	push r14
	.pushreg r14
	sub rsp,48
	.allocstack 48
	vmovdqa XMMWORD ptr[rsp],xmm6
	.savexmm128 xmm6,0
	vmovdqa XMMWORD ptr[rsp+16],xmm7
	.savexmm128 xmm7,16
	vmovdqa XMMWORD ptr[rsp+32],xmm8
	.savexmm128 xmm8,32
	.endprolog

	vbroadcastss ymm0,dword ptr[rcx]

	mov rsi,rdx 	; coeff_b
	mov rdi,r8		; coeff_c
	mov edx,r9d		; lgth
	mov ecx,r9d		; lgth
	mov rax,256
	mov r8,32
	mov r9,64
	mov r10,96
	mov r11,128
	mov r12,160
	mov r13,192
	mov r14,224

	shr ecx,3
	jz short CoeffAddF_AVX_1

CoeffAddF_AVX_loop_1:
	vaddps ymm1,ymm0,YMMWORD ptr[rsi]
	vaddps ymm2,ymm0,YMMWORD ptr[rsi+r8]
	vaddps ymm3,ymm0,YMMWORD ptr[rsi+r9]
	vaddps ymm4,ymm0,YMMWORD ptr[rsi+r10]
	vaddps ymm5,ymm0,YMMWORD ptr[rsi+r11]
	vaddps ymm6,ymm0,YMMWORD ptr[rsi+r12]
	vaddps ymm7,ymm0,YMMWORD ptr[rsi+r13]
	vaddps ymm8,ymm0,YMMWORD ptr[rsi+r14]
	vmovaps YMMWORD ptr[rdi],ymm1
	vmovaps YMMWORD ptr[rdi+r8],ymm2
	vmovaps YMMWORD ptr[rdi+r9],ymm3
	vmovaps YMMWORD ptr[rdi+r10],ymm4
	vmovaps YMMWORD ptr[rdi+r11],ymm5
	vmovaps YMMWORD ptr[rdi+r12],ymm6
	vmovaps YMMWORD ptr[rdi+r13],ymm7
	vmovaps YMMWORD ptr[rdi+r14],ymm8
	add rsi,rax
	add rdi,rax
	loop CoeffAddF_AVX_loop_1

CoeffAddF_AVX_1:
	test edx,4
	jz short CoeffAddF_AVX_2

	vaddps ymm1,ymm0,YMMWORD ptr[rsi]
	vaddps ymm2,ymm0,YMMWORD ptr[rsi+r8]
	vaddps ymm3,ymm0,YMMWORD ptr[rsi+r9]
	vaddps ymm4,ymm0,YMMWORD ptr[rsi+r10]
	vmovaps YMMWORD ptr[rdi],ymm1
	vmovaps YMMWORD ptr[rdi+r8],ymm2
	vmovaps YMMWORD ptr[rdi+r9],ymm3
	vmovaps YMMWORD ptr[rdi+r10],ymm4
	add rsi,r11
	add rdi,r11

CoeffAddF_AVX_2:
	test edx,2
	jz short CoeffAddF_AVX_3

	vaddps ymm1,ymm0,YMMWORD ptr[rsi]
	vaddps ymm2,ymm0,YMMWORD ptr[rsi+r8]
	vmovaps YMMWORD ptr[rdi],ymm1
	vmovaps YMMWORD ptr[rdi+r8],ymm2
	add rsi,r9
	add rdi,r9

CoeffAddF_AVX_3:
	test edx,1
	jz short CoeffAddF_AVX_4

	vaddps ymm1,ymm0,YMMWORD ptr[rsi]
	vmovaps YMMWORD ptr[rdi],ymm1

CoeffAddF_AVX_4:
	vmovdqa xmm8,XMMWORD ptr[rsp+32]
	vmovdqa xmm7,XMMWORD ptr[rsp+16]
	vmovdqa xmm6,XMMWORD ptr[rsp]
	add rsp,48

	vzeroupper

	pop r14
	pop r13
	pop r12
	pop rsi
	pop rdi

	ret

CoeffAddF_AVX endp	


;CoeffAdd2F_AVX proc coeff_a:dword,coeff_b:dword,lgth:word
; coeff_a = rcx
; coeff_b = rdx
; lgth = r8d

CoeffAdd2F_AVX proc public frame

	push rsi
	.pushreg rsi
	push r12
	.pushreg r12
	push r13
	.pushreg r13
	push r14
	.pushreg r14
	sub rsp,56
	.allocstack 56
	vmovdqa XMMWORD ptr[rsp],xmm6
	.savexmm128 xmm6,0
	vmovdqa XMMWORD ptr[rsp+16],xmm7
	.savexmm128 xmm7,16
	vmovdqa XMMWORD ptr[rsp+32],xmm8
	.savexmm128 xmm8,32
	.endprolog

	vbroadcastss ymm0,dword ptr[rcx]

	mov rsi,rdx 	; coeff_b
	mov ecx,r8d		; lgth
	mov edx,r8d		; lgth
	mov rax,256
	mov r8,32
	mov r9,64
	mov r10,96
	mov r11,128
	mov r12,160
	mov r13,192
	mov r14,224

	shr ecx,3
	jz short CoeffAdd2F_AVX_1

CoeffAdd2F_AVX_loop_1:
	vaddps ymm1,ymm0,YMMWORD ptr[rsi]
	vaddps ymm2,ymm0,YMMWORD ptr[rsi+r8]
	vaddps ymm3,ymm0,YMMWORD ptr[rsi+r9]
	vaddps ymm4,ymm0,YMMWORD ptr[rsi+r10]
	vaddps ymm5,ymm0,YMMWORD ptr[rsi+r11]
	vaddps ymm6,ymm0,YMMWORD ptr[rsi+r12]
	vaddps ymm7,ymm0,YMMWORD ptr[rsi+r13]
	vaddps ymm8,ymm0,YMMWORD ptr[rsi+r14]
	vmovaps YMMWORD ptr[rsi],ymm1
	vmovaps YMMWORD ptr[rsi+r8],ymm2
	vmovaps YMMWORD ptr[rsi+r9],ymm3
	vmovaps YMMWORD ptr[rsi+r10],ymm4
	vmovaps YMMWORD ptr[rsi+r11],ymm5
	vmovaps YMMWORD ptr[rsi+r12],ymm6
	vmovaps YMMWORD ptr[rsi+r13],ymm7
	vmovaps YMMWORD ptr[rsi+r14],ymm8
	add rsi,rax
	loop CoeffAdd2F_AVX_loop_1

CoeffAdd2F_AVX_1:
	test edx,4
	jz short CoeffAdd2F_AVX_2

	vaddps ymm1,ymm0,YMMWORD ptr[rsi]
	vaddps ymm2,ymm0,YMMWORD ptr[rsi+r8]
	vaddps ymm3,ymm0,YMMWORD ptr[rsi+r9]
	vaddps ymm4,ymm0,YMMWORD ptr[rsi+r10]
	vmovaps YMMWORD ptr[rsi],ymm1
	vmovaps YMMWORD ptr[rsi+r8],ymm2
	vmovaps YMMWORD ptr[rsi+r9],ymm3
	vmovaps YMMWORD ptr[rsi+r10],ymm4
	add rsi,r11

CoeffAdd2F_AVX_2:
	test edx,2
	jz short CoeffAdd2F_AVX_3

	vaddps ymm1,ymm0,YMMWORD ptr[rsi]
	vaddps ymm2,ymm0,YMMWORD ptr[rsi+r8]
	vmovaps YMMWORD ptr[rsi],ymm1
	vmovaps YMMWORD ptr[rsi+r8],ymm2
	add rsi,r9

CoeffAdd2F_AVX_3:
	test edx,1
	jz short CoeffAdd2F_AVX_4

	vaddps ymm1,ymm0,YMMWORD ptr[rsi]
	vmovaps YMMWORD ptr[rsi],ymm1

CoeffAdd2F_AVX_4:
	vmovdqa xmm8,XMMWORD ptr[rsp+32]
	vmovdqa xmm7,XMMWORD ptr[rsp+16]
	vmovdqa xmm6,XMMWORD ptr[rsp]
	add rsp,56

	vzeroupper

	pop r14
	pop r13
	pop r12
	pop rsi

	ret

CoeffAdd2F_AVX endp	


;CoeffAddD_SSE2 proc coeff_a:dword,coeff_b:dword,coeff_c:dword,lgth:word
; coeff_a = rcx
; coeff_b = rdx
; coeff_c = r8
; lgth = r9d

CoeffAddD_SSE2 proc public frame
	
	.endprolog
	
	movsd xmm0,qword ptr[rcx]
	movlhps xmm0,xmm0
	
	xor rcx,rcx
	mov rax,16
	mov ecx,r9d
	
CoeffAddD_SSE2_1:	
	movapd xmm1,XMMWORD ptr[rdx]
	add rdx,rax
	addpd xmm1,xmm0
	movapd XMMWORD ptr[r8],xmm1
	add r8,rax
	loop CoeffAddD_SSE2_1
	
	ret
	
CoeffAddD_SSE2 endp		


;CoeffAdd2D_SSE2 proc coeff_a:dword,coeff_b:dword,lgth:word
; coeff_a = rcx
; coeff_b = rdx
; lgth = r8d

CoeffAdd2D_SSE2 proc public frame
	
	.endprolog
	
	movsd xmm0,qword ptr[rcx]
	movlhps xmm0,xmm0
	
	xor rcx,rcx
	mov rax,16
	mov ecx,r8d
	
CoeffAdd2D_SSE2_1:	
	movapd xmm1,XMMWORD ptr[rdx]
	addpd xmm1,xmm0
	movapd XMMWORD ptr[rdx],xmm1
	add rdx,rax
	loop CoeffAdd2D_SSE2_1
	
	ret
	
CoeffAdd2D_SSE2 endp	


;CoeffAddD_AVX proc coeff_a:dword,coeff_b:dword,coeff_c:dword,lgth:word
; coeff_a = rcx
; coeff_b = rdx
; coeff_c = r8
; lgth = r9d

CoeffAddD_AVX proc public frame

	push rdi
	.pushreg rdi
	push rsi
	.pushreg rsi
	push r12
	.pushreg r12
	push r13
	.pushreg r13
	push r14
	.pushreg r14
	sub rsp,48
	.allocstack 48
	vmovdqa XMMWORD ptr[rsp],xmm6
	.savexmm128 xmm6,0
	vmovdqa XMMWORD ptr[rsp+16],xmm7
	.savexmm128 xmm7,16
	vmovdqa XMMWORD ptr[rsp+32],xmm8
	.savexmm128 xmm8,32
	.endprolog

	vbroadcastsd ymm0,qword ptr[rcx]

	mov rsi,rdx 	; coeff_b
	mov rdi,r8		; coeff_c
	mov edx,r9d		; lgth
	mov ecx,r9d		; lgth
	mov rax,256
	mov r8,32
	mov r9,64
	mov r10,96
	mov r11,128
	mov r12,160
	mov r13,192
	mov r14,224

	shr ecx,3
	jz short CoeffAddD_AVX_1

CoeffAddD_AVX_loop_1:
	vaddpd ymm1,ymm0,YMMWORD ptr[rsi]
	vaddpd ymm2,ymm0,YMMWORD ptr[rsi+r8]
	vaddpd ymm3,ymm0,YMMWORD ptr[rsi+r9]
	vaddpd ymm4,ymm0,YMMWORD ptr[rsi+r10]
	vaddpd ymm5,ymm0,YMMWORD ptr[rsi+r11]
	vaddpd ymm6,ymm0,YMMWORD ptr[rsi+r12]
	vaddpd ymm7,ymm0,YMMWORD ptr[rsi+r13]
	vaddpd ymm8,ymm0,YMMWORD ptr[rsi+r14]
	vmovapd YMMWORD ptr[rdi],ymm1
	vmovapd YMMWORD ptr[rdi+r8],ymm2
	vmovapd YMMWORD ptr[rdi+r9],ymm3
	vmovapd YMMWORD ptr[rdi+r10],ymm4
	vmovapd YMMWORD ptr[rdi+r11],ymm5
	vmovapd YMMWORD ptr[rdi+r12],ymm6
	vmovapd YMMWORD ptr[rdi+r13],ymm7
	vmovapd YMMWORD ptr[rdi+r14],ymm8
	add rsi,rax
	add rdi,rax
	loop CoeffAddD_AVX_loop_1

CoeffAddD_AVX_1:
	test edx,4
	jz short CoeffAddD_AVX_2

	vaddpd ymm1,ymm0,YMMWORD ptr[rsi]
	vaddpd ymm2,ymm0,YMMWORD ptr[rsi+r8]
	vaddpd ymm3,ymm0,YMMWORD ptr[rsi+r9]
	vaddpd ymm4,ymm0,YMMWORD ptr[rsi+r10]
	vmovapd YMMWORD ptr[rdi],ymm1
	vmovapd YMMWORD ptr[rdi+r8],ymm2
	vmovapd YMMWORD ptr[rdi+r9],ymm3
	vmovapd YMMWORD ptr[rdi+r10],ymm4
	add rsi,r11
	add rdi,r11

CoeffAddD_AVX_2:
	test edx,2
	jz short CoeffAddD_AVX_3

	vaddpd ymm1,ymm0,YMMWORD ptr[rsi]
	vaddpd ymm2,ymm0,YMMWORD ptr[rsi+r8]
	vmovapd YMMWORD ptr[rdi],ymm1
	vmovapd YMMWORD ptr[rdi+r8],ymm2
	add rsi,r9
	add rdi,r9

CoeffAddD_AVX_3:
	test edx,1
	jz short CoeffAddD_AVX_4

	vaddpd ymm1,ymm0,YMMWORD ptr[rsi]
	vmovapd YMMWORD ptr[rdi],ymm1

CoeffAddD_AVX_4:
	vmovdqa xmm8,XMMWORD ptr[rsp+32]
	vmovdqa xmm7,XMMWORD ptr[rsp+16]
	vmovdqa xmm6,XMMWORD ptr[rsp]
	add rsp,48

	vzeroupper

	pop r14
	pop r13
	pop r12
	pop rsi
	pop rdi

	ret

CoeffAddD_AVX endp


;CoeffAdd2D_AVX proc coeff_a:dword,coeff_b:dword,lgth:word
; coeff_a = rcx
; coeff_b = rdx
; lgth = r8d

CoeffAdd2D_AVX proc public frame

	push rsi
	.pushreg rsi
	push r12
	.pushreg r12
	push r13
	.pushreg r13
	push r14
	.pushreg r14
	sub rsp,56
	.allocstack 56
	vmovdqa XMMWORD ptr[rsp],xmm6
	.savexmm128 xmm6,0
	vmovdqa XMMWORD ptr[rsp+16],xmm7
	.savexmm128 xmm7,16
	vmovdqa XMMWORD ptr[rsp+32],xmm8
	.savexmm128 xmm8,32
	.endprolog

	vbroadcastsd ymm0,qword ptr[rcx]

	mov rsi,rdx 	; coeff_b
	mov ecx,r8d		; lgth
	mov edx,r8d		; lgth
	mov rax,256
	mov r8,32
	mov r9,64
	mov r10,96
	mov r11,128
	mov r12,160
	mov r13,192
	mov r14,224

	shr ecx,3
	jz short CoeffAdd2D_AVX_1

CoeffAdd2D_AVX_loop_1:
	vaddpd ymm1,ymm0,YMMWORD ptr[rsi]
	vaddpd ymm2,ymm0,YMMWORD ptr[rsi+r8]
	vaddpd ymm3,ymm0,YMMWORD ptr[rsi+r9]
	vaddpd ymm4,ymm0,YMMWORD ptr[rsi+r10]
	vaddpd ymm5,ymm0,YMMWORD ptr[rsi+r11]
	vaddpd ymm6,ymm0,YMMWORD ptr[rsi+r12]
	vaddpd ymm7,ymm0,YMMWORD ptr[rsi+r13]
	vaddpd ymm8,ymm0,YMMWORD ptr[rsi+r14]
	vmovapd YMMWORD ptr[rsi],ymm1
	vmovapd YMMWORD ptr[rsi+r8],ymm2
	vmovapd YMMWORD ptr[rsi+r9],ymm3
	vmovapd YMMWORD ptr[rsi+r10],ymm4
	vmovapd YMMWORD ptr[rsi+r11],ymm5
	vmovapd YMMWORD ptr[rsi+r12],ymm6
	vmovapd YMMWORD ptr[rsi+r13],ymm7
	vmovapd YMMWORD ptr[rsi+r14],ymm8
	add rsi,rax
	loop CoeffAdd2D_AVX_loop_1

CoeffAdd2D_AVX_1:
	test edx,4
	jz short CoeffAdd2D_AVX_2

	vaddpd ymm1,ymm0,YMMWORD ptr[rsi]
	vaddpd ymm2,ymm0,YMMWORD ptr[rsi+r8]
	vaddpd ymm3,ymm0,YMMWORD ptr[rsi+r9]
	vaddpd ymm4,ymm0,YMMWORD ptr[rsi+r10]
	vmovapd YMMWORD ptr[rsi],ymm1
	vmovapd YMMWORD ptr[rsi+r8],ymm2
	vmovapd YMMWORD ptr[rsi+r9],ymm3
	vmovapd YMMWORD ptr[rsi+r10],ymm4
	add rsi,r11

CoeffAdd2D_AVX_2:
	test edx,2
	jz short CoeffAdd2D_AVX_3

	vaddpd ymm1,ymm0,YMMWORD ptr[rsi]
	vaddpd ymm2,ymm0,YMMWORD ptr[rsi+r8]
	vmovapd YMMWORD ptr[rsi],ymm1
	vmovapd YMMWORD ptr[rsi+r8],ymm2
	add rsi,r9

CoeffAdd2D_AVX_3:
	test edx,1
	jz short CoeffAdd2D_AVX_4

	vaddpd ymm1,ymm0,YMMWORD ptr[rsi]
	vmovapd YMMWORD ptr[rsi],ymm1

CoeffAdd2D_AVX_4:
	vmovdqa xmm8,XMMWORD ptr[rsp+32]
	vmovdqa xmm7,XMMWORD ptr[rsp+16]
	vmovdqa xmm6,XMMWORD ptr[rsp]
	add rsp,56

	vzeroupper

	pop r14
	pop r13
	pop r12
	pop rsi

	ret

CoeffAdd2D_AVX endp	


;CoeffSubF_SSE2 proc coeff_a:dword,coeff_b:dword,coeff_c:dword,lgth:word
; coeff_a = rcx
; coeff_b = rdx
; coeff_c = r8
; lgth = r9d

CoeffSubF_SSE2 proc public frame

	.endprolog
	
	movss xmm0,dword ptr[rcx]
	pshufd xmm0,xmm0,0

	xor rcx,rcx
	mov rax,16
	mov ecx,r9d
	
CoeffSubF_SSE2_1:	
	movaps xmm1,xmm0
	subps xmm1,XMMWORD ptr[rdx]
	add rdx,rax
	movaps XMMWORD ptr[r8],xmm1
	add r8,rax
	loop CoeffSubF_SSE2_1
	
	ret
	
CoeffSubF_SSE2 endp	


;CoeffSub2F_SSE2 proc coeff_a:dword,coeff_b:dword,lgth:word
; coeff_a = rcx
; coeff_b = rdx
; lgth = r8d

CoeffSub2F_SSE2 proc public frame

	.endprolog
	
	movss xmm0,dword ptr[rcx]
	pshufd xmm0,xmm0,0

	xor rcx,rcx
	mov rax,16
	mov ecx,r8d
	
CoeffSub2F_SSE2_1:	
	movaps xmm1,xmm0
	subps xmm1,XMMWORD ptr[rdx]
	movaps XMMWORD ptr[rdx],xmm1
	add rdx,rax
	loop CoeffSub2F_SSE2_1
	
	ret
	
CoeffSub2F_SSE2 endp	


;CoeffSubF_AVX proc coeff_a:dword,coeff_b:dword,coeff_c:dword,lgth:word
; coeff_a = rcx
; coeff_b = rdx
; coeff_c = r8
; lgth = r9d

CoeffSubF_AVX proc public frame

	push rdi
	.pushreg rdi
	push rsi
	.pushreg rsi
	push r12
	.pushreg r12
	push r13
	.pushreg r13
	push r14
	.pushreg r14
	sub rsp,48
	.allocstack 48
	vmovdqa XMMWORD ptr[rsp],xmm6
	.savexmm128 xmm6,0
	vmovdqa XMMWORD ptr[rsp+16],xmm7
	.savexmm128 xmm7,16
	vmovdqa XMMWORD ptr[rsp+32],xmm8
	.savexmm128 xmm8,32
	.endprolog

	vbroadcastss ymm0,dword ptr[rcx]

	mov rsi,rdx 	; coeff_b
	mov rdi,r8		; coeff_c
	mov edx,r9d		; lgth
	mov ecx,r9d		; lgth
	mov rax,256
	mov r8,32
	mov r9,64
	mov r10,96
	mov r11,128
	mov r12,160
	mov r13,192
	mov r14,224

	shr ecx,3
	jz short CoeffSubF_AVX_1

CoeffSubF_AVX_loop_1:
	vsubps ymm1,ymm0,YMMWORD ptr[rsi]
	vsubps ymm2,ymm0,YMMWORD ptr[rsi+r8]
	vsubps ymm3,ymm0,YMMWORD ptr[rsi+r9]
	vsubps ymm4,ymm0,YMMWORD ptr[rsi+r10]
	vsubps ymm5,ymm0,YMMWORD ptr[rsi+r11]
	vsubps ymm6,ymm0,YMMWORD ptr[rsi+r12]
	vsubps ymm7,ymm0,YMMWORD ptr[rsi+r13]
	vsubps ymm8,ymm0,YMMWORD ptr[rsi+r14]
	vmovaps YMMWORD ptr[rdi],ymm1
	vmovaps YMMWORD ptr[rdi+r8],ymm2
	vmovaps YMMWORD ptr[rdi+r9],ymm3
	vmovaps YMMWORD ptr[rdi+r10],ymm4
	vmovaps YMMWORD ptr[rdi+r11],ymm5
	vmovaps YMMWORD ptr[rdi+r12],ymm6
	vmovaps YMMWORD ptr[rdi+r13],ymm7
	vmovaps YMMWORD ptr[rdi+r14],ymm8
	add rsi,rax
	add rdi,rax
	loop CoeffSubF_AVX_loop_1

CoeffSubF_AVX_1:
	test edx,4
	jz short CoeffSubF_AVX_2

	vsubps ymm1,ymm0,YMMWORD ptr[rsi]
	vsubps ymm2,ymm0,YMMWORD ptr[rsi+r8]
	vsubps ymm3,ymm0,YMMWORD ptr[rsi+r9]
	vsubps ymm4,ymm0,YMMWORD ptr[rsi+r10]
	vmovaps YMMWORD ptr[rdi],ymm1
	vmovaps YMMWORD ptr[rdi+r8],ymm2
	vmovaps YMMWORD ptr[rdi+r9],ymm3
	vmovaps YMMWORD ptr[rdi+r10],ymm4
	add rsi,r11
	add rdi,r11

CoeffSubF_AVX_2:
	test edx,2
	jz short CoeffSubF_AVX_3

	vsubps ymm1,ymm0,YMMWORD ptr[rsi]
	vsubps ymm2,ymm0,YMMWORD ptr[rsi+r8]
	vmovaps YMMWORD ptr[rdi],ymm1
	vmovaps YMMWORD ptr[rdi+r8],ymm2
	add rsi,r9
	add rdi,r9

CoeffSubF_AVX_3:
	test edx,1
	jz short CoeffSubF_AVX_4

	vsubps ymm1,ymm0,YMMWORD ptr[rsi]
	vmovaps YMMWORD ptr[rdi],ymm1

CoeffSubF_AVX_4:
	vmovdqa xmm8,XMMWORD ptr[rsp+32]
	vmovdqa xmm7,XMMWORD ptr[rsp+16]
	vmovdqa xmm6,XMMWORD ptr[rsp]
	add rsp,48

	vzeroupper

	pop r14
	pop r13
	pop r12
	pop rsi
	pop rdi

	ret

CoeffSubF_AVX endp	


;CoeffSub2F_AVX proc coeff_a:dword,coeff_b:dword,lgth:word
; coeff_a = rcx
; coeff_b = rdx
; lgth = r8d

CoeffSub2F_AVX proc public frame

	push rsi
	.pushreg rsi
	push r12
	.pushreg r12
	push r13
	.pushreg r13
	push r14
	.pushreg r14
	sub rsp,56
	.allocstack 56
	vmovdqa XMMWORD ptr[rsp],xmm6
	.savexmm128 xmm6,0
	vmovdqa XMMWORD ptr[rsp+16],xmm7
	.savexmm128 xmm7,16
	vmovdqa XMMWORD ptr[rsp+32],xmm8
	.savexmm128 xmm8,32
	.endprolog

	vbroadcastss ymm0,dword ptr[rcx]

	mov rsi,rdx 	; coeff_b
	mov ecx,r8d		; lgth
	mov edx,r8d		; lgth
	mov rax,256
	mov r8,32
	mov r9,64
	mov r10,96
	mov r11,128
	mov r12,160
	mov r13,192
	mov r14,224

	shr ecx,3
	jz short CoeffSub2F_AVX_1

CoeffSub2F_AVX_loop_1:
	vsubps ymm1,ymm0,YMMWORD ptr[rsi]
	vsubps ymm2,ymm0,YMMWORD ptr[rsi+r8]
	vsubps ymm3,ymm0,YMMWORD ptr[rsi+r9]
	vsubps ymm4,ymm0,YMMWORD ptr[rsi+r10]
	vsubps ymm5,ymm0,YMMWORD ptr[rsi+r11]
	vsubps ymm6,ymm0,YMMWORD ptr[rsi+r12]
	vsubps ymm7,ymm0,YMMWORD ptr[rsi+r13]
	vsubps ymm8,ymm0,YMMWORD ptr[rsi+r14]
	vmovaps YMMWORD ptr[rsi],ymm1
	vmovaps YMMWORD ptr[rsi+r8],ymm2
	vmovaps YMMWORD ptr[rsi+r9],ymm3
	vmovaps YMMWORD ptr[rsi+r10],ymm4
	vmovaps YMMWORD ptr[rsi+r11],ymm5
	vmovaps YMMWORD ptr[rsi+r12],ymm6
	vmovaps YMMWORD ptr[rsi+r13],ymm7
	vmovaps YMMWORD ptr[rsi+r14],ymm8
	add rsi,rax
	loop CoeffSub2F_AVX_loop_1

CoeffSub2F_AVX_1:
	test edx,4
	jz short CoeffSub2F_AVX_2

	vsubps ymm1,ymm0,YMMWORD ptr[rsi]
	vsubps ymm2,ymm0,YMMWORD ptr[rsi+r8]
	vsubps ymm3,ymm0,YMMWORD ptr[rsi+r9]
	vsubps ymm4,ymm0,YMMWORD ptr[rsi+r10]
	vmovaps YMMWORD ptr[rsi],ymm1
	vmovaps YMMWORD ptr[rsi+r8],ymm2
	vmovaps YMMWORD ptr[rsi+r9],ymm3
	vmovaps YMMWORD ptr[rsi+r10],ymm4
	add rsi,r11

CoeffSub2F_AVX_2:
	test edx,2
	jz short CoeffSub2F_AVX_3

	vsubps ymm1,ymm0,YMMWORD ptr[rsi]
	vsubps ymm2,ymm0,YMMWORD ptr[rsi+r8]
	vmovaps YMMWORD ptr[rsi],ymm1
	vmovaps YMMWORD ptr[rsi+r8],ymm2
	add rsi,r8

CoeffSub2F_AVX_3:
	test edx,1
	jz short CoeffSub2F_AVX_4

	vsubps ymm1,ymm0,YMMWORD ptr[rsi]
	vmovaps YMMWORD ptr[rsi],ymm1

CoeffSub2F_AVX_4:
	vmovdqa xmm8,XMMWORD ptr[rsp+32]
	vmovdqa xmm7,XMMWORD ptr[rsp+16]
	vmovdqa xmm6,XMMWORD ptr[rsp]
	add rsp,56

	vzeroupper

	pop r14
	pop r13
	pop r12
	pop rsi

	ret

CoeffSub2F_AVX endp	


;CoeffSubD_SSE2 proc coeff_a:dword,coeff_b:dword,coeff_c:dword,lgth:word
; coeff_a = rcx
; coeff_b = rdx
; coeff_c = r8
; lgth = r9d

CoeffSubD_SSE2 proc public frame
	
	.endprolog
	
	movsd xmm0,qword ptr[rcx]
	movlhps xmm0,xmm0
	
	xor rcx,rcx
	mov rax,16
	mov ecx,r9d
	
CoeffSubD_SSE2_1:	
	movapd xmm1,xmm0
	subpd xmm1,XMMWORD ptr[rdx]
	add rdx,rax
	movapd XMMWORD ptr[r8],xmm1
	add r8,rax
	loop CoeffSubD_SSE2_1
	
	ret
	
CoeffSubD_SSE2 endp		


;CoeffSub2D_SSE2 proc coeff_a:dword,coeff_b:dword,lgth:word
; coeff_a = rcx
; coeff_b = rdx
; lgth = r8d

CoeffSub2D_SSE2 proc public frame
	
	.endprolog
	
	movsd xmm0,qword ptr[rcx]
	movlhps xmm0,xmm0
	
	xor rcx,rcx
	mov rax,16
	mov ecx,r8d
	
CoeffSub2D_SSE2_1:	
	movapd xmm1,xmm0
	subpd xmm1,XMMWORD ptr[rdx]
	movapd XMMWORD ptr[rdx],xmm1
	add rdx,rax
	loop CoeffSub2D_SSE2_1
	
	ret
	
CoeffSub2D_SSE2 endp	


;CoeffSubD_AVX proc coeff_a:dword,coeff_b:dword,coeff_c:dword,lgth:word
; coeff_a = rcx
; coeff_b = rdx
; coeff_c = r8
; lgth = r9d

CoeffSubD_AVX proc public frame

	push rdi
	.pushreg rdi
	push rsi
	.pushreg rsi
	push r12
	.pushreg r12
	push r13
	.pushreg r13
	push r14
	.pushreg r14
	sub rsp,48
	.allocstack 48
	vmovdqa XMMWORD ptr[rsp],xmm6
	.savexmm128 xmm6,0
	vmovdqa XMMWORD ptr[rsp+16],xmm7
	.savexmm128 xmm7,16
	vmovdqa XMMWORD ptr[rsp+32],xmm8
	.savexmm128 xmm8,32
	.endprolog

	vbroadcastsd ymm0,qword ptr[rcx]

	mov rsi,rdx 	; coeff_b
	mov rdi,r8		; coeff_c
	mov edx,r9d		; lgth
	mov ecx,r9d		; lgth
	mov rax,256
	mov r8,32
	mov r9,64
	mov r10,96
	mov r11,128
	mov r12,160
	mov r13,192
	mov r14,224

	shr ecx,3
	jz short CoeffSubD_AVX_1

CoeffSubD_AVX_loop_1:
	vsubpd ymm1,ymm0,YMMWORD ptr[rsi]
	vsubpd ymm2,ymm0,YMMWORD ptr[rsi+r8]
	vsubpd ymm3,ymm0,YMMWORD ptr[rsi+r9]
	vsubpd ymm4,ymm0,YMMWORD ptr[rsi+r10]
	vsubpd ymm5,ymm0,YMMWORD ptr[rsi+r11]
	vsubpd ymm6,ymm0,YMMWORD ptr[rsi+r12]
	vsubpd ymm7,ymm0,YMMWORD ptr[rsi+r13]
	vsubpd ymm8,ymm0,YMMWORD ptr[rsi+r14]
	vmovapd YMMWORD ptr[rdi],ymm1
	vmovapd YMMWORD ptr[rdi+r8],ymm2
	vmovapd YMMWORD ptr[rdi+r9],ymm3
	vmovapd YMMWORD ptr[rdi+r10],ymm4
	vmovapd YMMWORD ptr[rdi+r11],ymm5
	vmovapd YMMWORD ptr[rdi+r12],ymm6
	vmovapd YMMWORD ptr[rdi+r13],ymm7
	vmovapd YMMWORD ptr[rdi+r14],ymm8
	add rsi,rax
	add rdi,rax
	loop CoeffSubD_AVX_loop_1

CoeffSubD_AVX_1:
	test edx,4
	jz short CoeffSubD_AVX_2

	vsubpd ymm1,ymm0,YMMWORD ptr[rsi]
	vsubpd ymm2,ymm0,YMMWORD ptr[rsi+r8]
	vsubpd ymm3,ymm0,YMMWORD ptr[rsi+r9]
	vsubpd ymm4,ymm0,YMMWORD ptr[rsi+r10]
	vmovapd YMMWORD ptr[rdi],ymm1
	vmovapd YMMWORD ptr[rdi+r8],ymm2
	vmovapd YMMWORD ptr[rdi+r9],ymm3
	vmovapd YMMWORD ptr[rdi+r10],ymm4
	add rsi,r11
	add rdi,r11

CoeffSubD_AVX_2:
	test edx,2
	jz short CoeffSubD_AVX_3

	vsubpd ymm1,ymm0,YMMWORD ptr[rsi]
	vsubpd ymm2,ymm0,YMMWORD ptr[rsi+r8]
	vmovapd YMMWORD ptr[rdi],ymm1
	vmovapd YMMWORD ptr[rdi+r8],ymm2
	add rsi,r9
	add rdi,r9

CoeffSubD_AVX_3:
	test edx,1
	jz short CoeffSubD_AVX_4

	vsubpd ymm1,ymm0,YMMWORD ptr[rsi]
	vmovapd YMMWORD ptr[rdi],ymm1

CoeffSubD_AVX_4:
	vmovdqa xmm8,XMMWORD ptr[rsp+32]
	vmovdqa xmm7,XMMWORD ptr[rsp+16]
	vmovdqa xmm6,XMMWORD ptr[rsp]
	add rsp,48

	vzeroupper

	pop r14
	pop r13
	pop r12
	pop rsi
	pop rdi

	ret

CoeffSubD_AVX endp	


;CoeffSub2D_AVX proc coeff_a:dword,coeff_b:dword,lgth:word
; coeff_a = rcx
; coeff_b = rdx
; lgth = r8d

CoeffSub2D_AVX proc public frame

	push rsi
	.pushreg rsi
	push r12
	.pushreg r12
	push r13
	.pushreg r13
	push r14
	.pushreg r14
	sub rsp,56
	.allocstack 56
	vmovdqa XMMWORD ptr[rsp],xmm6
	.savexmm128 xmm6,0
	vmovdqa XMMWORD ptr[rsp+16],xmm7
	.savexmm128 xmm7,16
	vmovdqa XMMWORD ptr[rsp+32],xmm8
	.savexmm128 xmm8,32
	.endprolog

	vbroadcastsd ymm0,qword ptr[rcx]

	mov rsi,rdx 	; coeff_b
	mov ecx,r8d		; lgth
	mov edx,r8d		; lgth
	mov rax,256
	mov r8,32
	mov r9,64
	mov r10,96
	mov r11,128
	mov r12,160
	mov r13,192
	mov r14,224

	shr ecx,3
	jz short CoeffSub2D_AVX_1

CoeffSub2D_AVX_loop_1:
	vsubpd ymm1,ymm0,YMMWORD ptr[rsi]
	vsubpd ymm2,ymm0,YMMWORD ptr[rsi+r8]
	vsubpd ymm3,ymm0,YMMWORD ptr[rsi+r9]
	vsubpd ymm4,ymm0,YMMWORD ptr[rsi+r10]
	vsubpd ymm5,ymm0,YMMWORD ptr[rsi+r11]
	vsubpd ymm6,ymm0,YMMWORD ptr[rsi+r12]
	vsubpd ymm7,ymm0,YMMWORD ptr[rsi+r13]
	vsubpd ymm8,ymm0,YMMWORD ptr[rsi+r14]
	vmovapd YMMWORD ptr[rsi],ymm1
	vmovapd YMMWORD ptr[rsi+r8],ymm2
	vmovapd YMMWORD ptr[rsi+r9],ymm3
	vmovapd YMMWORD ptr[rsi+r10],ymm4
	vmovapd YMMWORD ptr[rsi+r11],ymm5
	vmovapd YMMWORD ptr[rsi+r12],ymm6
	vmovapd YMMWORD ptr[rsi+r13],ymm7
	vmovapd YMMWORD ptr[rsi+r14],ymm8
	add rsi,rax
	loop CoeffSub2D_AVX_loop_1

CoeffSub2D_AVX_1:
	test edx,4
	jz short CoeffSub2D_AVX_2

	vsubpd ymm1,ymm0,YMMWORD ptr[rsi]
	vsubpd ymm2,ymm0,YMMWORD ptr[rsi+r8]
	vsubpd ymm3,ymm0,YMMWORD ptr[rsi+r9]
	vsubpd ymm4,ymm0,YMMWORD ptr[rsi+r10]
	vmovapd YMMWORD ptr[rsi],ymm1
	vmovapd YMMWORD ptr[rsi+r8],ymm2
	vmovapd YMMWORD ptr[rsi+r9],ymm3
	vmovapd YMMWORD ptr[rsi+r10],ymm4
	add rsi,r11

CoeffSub2D_AVX_2:
	test edx,2
	jz short CoeffSub2D_AVX_3

	vsubpd ymm1,ymm0,YMMWORD ptr[rsi]
	vsubpd ymm2,ymm0,YMMWORD ptr[rsi+r8]
	vmovapd YMMWORD ptr[rsi],ymm1
	vmovapd YMMWORD ptr[rsi+r8],ymm2
	add rsi,r9

CoeffSub2D_AVX_3:
	test edx,1
	jz short CoeffSub2D_AVX_4

	vsubpd ymm1,ymm0,YMMWORD ptr[rsi]
	vmovapd YMMWORD ptr[rsi],ymm1

CoeffSub2D_AVX_4:
	vmovdqa xmm8,XMMWORD ptr[rsp+32]
	vmovdqa xmm7,XMMWORD ptr[rsp+16]
	vmovdqa xmm6,XMMWORD ptr[rsp]
	add rsp,56

	vzeroupper

	pop r14
	pop r13
	pop r12
	pop rsi

	ret

CoeffSub2D_AVX endp


;VectorNorme2F_SSE2 proc coeff_x:dword,result:dword,lgth:word
; coeff_x = rcx
; result = rdx
; lgth = r8d

VectorNorme2F_SSE2 proc public frame
		
	.endprolog
		
	mov r9,rcx
	xorps xmm0,xmm0
	xor rcx,rcx
	mov rax,16
	mov ecx,r8d
		
VectorNorme2F_SSE2_1:
	movaps xmm1,XMMWORD ptr[r9]
	mulps xmm1,xmm1
	add r9,rax
	addps xmm0,xmm1
	loop VectorNorme2F_SSE2_1
		
	movhlps xmm1,xmm0
	addps xmm0,xmm1
	movaps xmm1,xmm0
	psrldq xmm1,4
	addss xmm0,xmm1
	sqrtss xmm0,xmm0
	movss dword ptr[rdx],xmm0
		
	ret
		
VectorNorme2F_SSE2 endp	


;VectorNorme2F_AVX proc coeff_x:dword,result:dword,lgth:word
; coeff_x = rcx
; result = rdx
; lgth = r8d

VectorNorme2F_AVX proc public frame

	.endprolog

	mov r9,rcx 		; coeff_x
	mov rax,128
	mov ecx,r8d		; lgth
	mov r10,32
	mov r11,96

	vxorps ymm0,ymm0,ymm0

	shr ecx,2
	jz short VectorNorme2F_AVX_1

VectorNorme2F_AVX_loop_1:
	vmovaps ymm1,YMMWORD ptr[r9]
	vmovaps ymm2,YMMWORD ptr[r9+r10]
	vmovaps ymm3,YMMWORD ptr[r9+2*r10]
	vmovaps ymm4,YMMWORD ptr[r9+r11]

	vmulps ymm1,ymm1,ymm1
	vmulps ymm2,ymm2,ymm2
	vmulps ymm3,ymm3,ymm3
	vmulps ymm4,ymm4,ymm4

	vaddps ymm1,ymm1,ymm2
	vaddps ymm3,ymm3,ymm4
	vaddps ymm1,ymm1,ymm3
	add r9,rax
	vaddps ymm0,ymm0,ymm1
	loop VectorNorme2F_AVX_loop_1

VectorNorme2F_AVX_1:
	test r8d,2
	jz short VectorNorme2F_AVX_2

	vmovaps ymm1,YMMWORD ptr[r9]
	vmovaps ymm2,YMMWORD ptr[r9+r10]
	vmulps ymm1,ymm1,ymm1
	vmulps ymm2,ymm2,ymm2

	vaddps ymm1,ymm1,ymm2
	add r9,64
	vaddps ymm0,ymm0,ymm1

VectorNorme2F_AVX_2:
	test r8d,1
	jz short VectorNorme2F_AVX_3

	vmovaps ymm1,YMMWORD ptr[r9]
	vmulps ymm1,ymm1,ymm1
	vaddps ymm0,ymm0,ymm1

VectorNorme2F_AVX_3:
	vextractf128 xmm1,ymm0,1
	vaddps xmm0,xmm0,xmm1

	vmovhlps xmm1,xmm1,xmm0
	vaddps xmm0,xmm0,xmm1
	vpsrldq xmm1,xmm0,4
	vaddss xmm0,xmm0,xmm1
	vsqrtss xmm0,xmm0,xmm0
	vmovss dword ptr[rdx],xmm0

	vzeroupper

	ret

VectorNorme2F_AVX endp


;VectorNorme2D_SSE2 proc coeff_x:dword,result:dword,lgth:word
; coeff_x = rcx
; result = rdx
; lgth = r8d

VectorNorme2D_SSE2 proc public frame
		
	.endprolog
		
	mov r9,rcx
	xorpd xmm0,xmm0
	xor rcx,rcx
	mov rax,16
	mov ecx,r8d
		
VectorNorme2D_SSE2_1:
	movapd xmm1,XMMWORD ptr[r9]
	mulpd xmm1,xmm1
	add r9,rax
	addpd xmm0,xmm1
	loop VectorNorme2D_SSE2_1
		
	movhlps xmm1,xmm0
	addsd xmm0,xmm1
	sqrtsd xmm0,xmm0
	movsd qword ptr[rdx],xmm0
		
	ret
		
VectorNorme2D_SSE2 endp	


;VectorNorme2D_AVX proc coeff_x:dword,result:dword,lgth:word
; coeff_x = rcx
; result = rdx
; lgth = r8d

VectorNorme2D_AVX proc public frame

	.endprolog

	mov r9,rcx 		; coeff_x
	mov rax,128
	mov ecx,r8d		; lgth
	mov r10,32
	mov r11,96

	vxorps ymm0,ymm0,ymm0

	shr ecx,2
	jz short VectorNorme2D_AVX_1

VectorNorme2D_AVX_loop_1:
	vmovapd ymm1,YMMWORD ptr[r9]
	vmovapd ymm2,YMMWORD ptr[r9+r10]
	vmovapd ymm3,YMMWORD ptr[r9+2*r10]
	vmovapd ymm4,YMMWORD ptr[r9+r11]

	vmulpd ymm1,ymm1,ymm1
	vmulpd ymm2,ymm2,ymm2
	vmulpd ymm3,ymm3,ymm3
	vmulpd ymm4,ymm4,ymm4

	vaddpd ymm1,ymm1,ymm2
	vaddpd ymm3,ymm3,ymm4
	vaddpd ymm1,ymm1,ymm3
	add r9,rax
	vaddpd ymm0,ymm0,ymm1
	loop VectorNorme2D_AVX_loop_1

VectorNorme2D_AVX_1:
	test r8d,2
	jz short VectorNorme2D_AVX_2

	vmovapd ymm1,YMMWORD ptr[r9]
	vmovapd ymm2,YMMWORD ptr[r9+r10]
	vmulpd ymm1,ymm1,ymm1
	vmulpd ymm2,ymm2,ymm2

	vaddpd ymm1,ymm1,ymm2
	add r9,64
	vaddpd ymm0,ymm0,ymm1

VectorNorme2D_AVX_2:
	test r8d,1
	jz short VectorNorme2D_AVX_3

	vmovapd ymm1,YMMWORD ptr[r9]
	vmulpd ymm1,ymm1,ymm1
	vaddpd ymm0,ymm0,ymm1

VectorNorme2D_AVX_3:
	vextractf128 xmm1,ymm0,1
	vaddpd xmm0,xmm0,xmm1

	vmovhlps xmm1,xmm1,xmm0
	vaddsd xmm0,xmm0,xmm1
	vsqrtsd xmm0,xmm0,xmm0
	vmovsd qword ptr[rdx],xmm0

	vzeroupper

	ret

VectorNorme2D_AVX endp	


;VectorDist2F_SSE2 proc coeff_x:dword,coeff_y:dword,result:dword,lgth:word
; coeff_x = rcx
; coeff_y = rdx
; result = r8
; lgth = r9d

VectorDist2F_SSE2 proc public frame
		
	.endprolog
		
	mov r10,rcx
	xorps xmm0,xmm0
	xor rcx,rcx
	mov rax,16
	mov ecx,r9d
		
VectorDist2F_SSE2_1:
	movaps xmm1,XMMWORD ptr[r10]
	subps xmm1,XMMWORD ptr[rdx]
	add r10,rax
	mulps xmm1,xmm1
	add rdx,rax
	addps xmm0,xmm1
	loop VectorDist2F_SSE2_1
		
	movhlps xmm1,xmm0
	addps xmm0,xmm1
	movaps xmm1,xmm0
	psrldq xmm1,4
	addss xmm0,xmm1
	sqrtss xmm0,xmm0
	movss dword ptr[r8],xmm0
		
	ret
		
VectorDist2F_SSE2 endp


;VectorDist2F_AVX proc coeff_x:dword,coeff_y:dword,result:dword,lgth:word
; coeff_x = rcx
; coeff_y = rdx
; result = r8
; lgth = r9d

VectorDist2F_AVX proc public frame

	push rbx
	.pushreg rbx
	push rdi
	.pushreg rdi
	push rsi
	.pushreg rsi
	push r12
	.pushreg r12
	push r13
	.pushreg r13
	push r14
	.pushreg r14
	sub rsp,56
	.allocstack 56
	vmovdqa XMMWORD ptr[rsp],xmm6
	.savexmm128 xmm6,0
	vmovdqa XMMWORD ptr[rsp+16],xmm7
	.savexmm128 xmm7,16
	vmovdqa XMMWORD ptr[rsp+32],xmm8
	.savexmm128 xmm8,32
	.endprolog

	mov rsi,rcx 	; coeff_x
	mov rdi,rdx 	; coeff_y
	mov rbx,r8		; result
	mov ecx,r9d		; lgth
	mov edx,r9d		; lgth
	mov rax,256
	mov r8,32
	mov r9,64
	mov r10,96
	mov r11,128
	mov r12,160
	mov r13,192
	mov r14,224

	vxorps ymm0,ymm0,ymm0

	shr ecx,3
	jz VectorDist2F_AVX_1

VectorDist2F_AVX_loop_1:
	vmovaps ymm1,YMMWORD ptr[rsi]
	vmovaps ymm2,YMMWORD ptr[rsi+r8]
	vmovaps ymm3,YMMWORD ptr[rsi+r9]
	vmovaps ymm4,YMMWORD ptr[rsi+r10]
	vmovaps ymm5,YMMWORD ptr[rsi+r11]
	vmovaps ymm6,YMMWORD ptr[rsi+r12]
	vmovaps ymm7,YMMWORD ptr[rsi+r13]
	vmovaps ymm8,YMMWORD ptr[rsi+r14]

	vsubps ymm1,ymm1,YMMWORD ptr[rdi]
	vsubps ymm2,ymm2,YMMWORD ptr[rdi+r8]
	vsubps ymm3,ymm3,YMMWORD ptr[rdi+r9]
	vsubps ymm4,ymm4,YMMWORD ptr[rdi+r10]
	vsubps ymm5,ymm5,YMMWORD ptr[rdi+r11]
	vsubps ymm6,ymm6,YMMWORD ptr[rdi+r12]
	vsubps ymm7,ymm7,YMMWORD ptr[rdi+r13]
	vsubps ymm8,ymm8,YMMWORD ptr[rdi+r14]

	vmulps ymm1,ymm1,ymm1
	vmulps ymm2,ymm2,ymm2
	vmulps ymm3,ymm3,ymm3
	vmulps ymm4,ymm4,ymm4
	vmulps ymm5,ymm5,ymm5
	vmulps ymm6,ymm6,ymm6
	vmulps ymm7,ymm7,ymm7
	vmulps ymm8,ymm8,ymm8

	vaddps ymm1,ymm1,ymm2
	vaddps ymm3,ymm3,ymm4
	vaddps ymm5,ymm5,ymm6
	vaddps ymm7,ymm7,ymm8
	vaddps ymm1,ymm1,ymm3
	vaddps ymm5,ymm5,ymm7
	add rsi,rax
	vaddps ymm1,ymm1,ymm5
	add rdi,rax
	vaddps ymm0,ymm0,ymm1

	dec ecx
	jnz VectorDist2F_AVX_loop_1

VectorDist2F_AVX_1:
	test edx,4
	jz short VectorDist2F_AVX_2

	vmovaps ymm1,YMMWORD ptr[rsi]
	vmovaps ymm2,YMMWORD ptr[rsi+r8]
	vmovaps ymm3,YMMWORD ptr[rsi+r9]
	vmovaps ymm4,YMMWORD ptr[rsi+r10]

	vsubps ymm1,ymm1,YMMWORD ptr[rdi]
	vsubps ymm2,ymm2,YMMWORD ptr[rdi+r8]
	vsubps ymm3,ymm3,YMMWORD ptr[rdi+r9]
	vsubps ymm4,ymm4,YMMWORD ptr[rdi+r10]

	vmulps ymm1,ymm1,ymm1
	vmulps ymm2,ymm2,ymm2
	vmulps ymm3,ymm3,ymm3
	vmulps ymm4,ymm4,ymm4

	vaddps ymm1,ymm1,ymm2
	vaddps ymm3,ymm3,ymm4
	add rsi,r11
	vaddps ymm1,ymm1,ymm3
	add rdi,r11
	vaddps ymm0,ymm0,ymm1

VectorDist2F_AVX_2:
	test edx,2
	jz short VectorDist2F_AVX_3

	vmovaps ymm1,YMMWORD ptr[rsi]
	vmovaps ymm2,YMMWORD ptr[rsi+r8]
	vsubps ymm1,ymm1,YMMWORD ptr[rdi]
	vsubps ymm2,ymm2,YMMWORD ptr[rdi+r8]
	vmulps ymm1,ymm1,ymm1
	vmulps ymm2,ymm2,ymm2

	add rsi,r9
	vaddps ymm1,ymm1,ymm2
	add rdi,r9
	vaddps ymm0,ymm0,ymm1

VectorDist2F_AVX_3:
	test edx,1
	jz short VectorDist2F_AVX_4

	vmovaps ymm1,YMMWORD ptr[rsi]
	vsubps ymm1,ymm1,YMMWORD ptr[rdi]
	vmulps ymm1,ymm1,ymm1
	vaddps ymm0,ymm0,ymm1

VectorDist2F_AVX_4:
	vextractf128 xmm1,ymm0,1
	vaddps xmm0,xmm0,xmm1

	vmovhlps xmm1,xmm1,xmm0
	vaddps xmm0,xmm0,xmm1
	vpsrldq xmm1,xmm0,4
	vaddss xmm0,xmm0,xmm1
	vsqrtss xmm0,xmm0,xmm0
	vmovss dword ptr[rbx],xmm0

	vmovdqa xmm8,XMMWORD ptr[rsp+32]
	vmovdqa xmm7,XMMWORD ptr[rsp+16]
	vmovdqa xmm6,XMMWORD ptr[rsp]
	add rsp,56

	vzeroupper

	pop r14
	pop r13
	pop r12
	pop rsi
	pop rdi
	pop rbx

	ret

VectorDist2F_AVX endp


;VectorDist2D_SSE2 proc coeff_a:dword,coeff_x:dword,result:dword,lgth:word
; coeff_a = rcx
; coeff_x = rdx
; result = r8
; lgth = r9d

VectorDist2D_SSE2 proc public frame
		
	.endprolog
		
	mov r10,rcx
	xorpd xmm0,xmm0
	xor rcx,rcx
	mov rax,16
	mov ecx,r9d
		
VectorDist2D_SSE2_1:
	movapd xmm1,XMMWORD ptr[r10]
	subpd xmm1,XMMWORD ptr[rdx]
	add r10,rax
	mulpd xmm1,xmm1
	add rdx,rax
	addpd xmm0,xmm1
	loop VectorDist2D_SSE2_1
		
	movhlps xmm1,xmm0
	addsd xmm0,xmm1
	sqrtsd xmm0,xmm0
	movsd qword ptr[r8],xmm0
		
	ret
		
VectorDist2D_SSE2 endp


;VectorDist2D_AVX proc coeff_a:dword,coeff_x:dword,result:dword,lgth:word
; coeff_a = rcx
; coeff_x = rdx
; result = r8
; lgth = r9d

VectorDist2D_AVX proc public frame

	push rbx
	.pushreg rbx
	push rdi
	.pushreg rdi
	push rsi
	.pushreg rsi
	push r12
	.pushreg r12
	push r13
	.pushreg r13
	push r14
	.pushreg r14
	sub rsp,56
	.allocstack 56
	vmovdqa XMMWORD ptr[rsp],xmm6
	.savexmm128 xmm6,0
	vmovdqa XMMWORD ptr[rsp+16],xmm7
	.savexmm128 xmm7,16
	vmovdqa XMMWORD ptr[rsp+32],xmm8
	.savexmm128 xmm8,32
	.endprolog

	mov rsi,rcx 	; coeff_x
	mov rdi,rdx 	; coeff_y
	mov rbx,r8		; result
	mov ecx,r9d		; lgth
	mov edx,r9d		; lgth
	mov rax,256
	mov r8,32
	mov r9,64
	mov r10,96
	mov r11,128
	mov r12,160
	mov r13,192
	mov r14,224

	vxorpd ymm0,ymm0,ymm0

	shr ecx,3
	jz VectorDist2D_AVX_1

VectorDist2D_AVX_loop_1:
	vmovapd ymm1,YMMWORD ptr[rsi]
	vmovapd ymm2,YMMWORD ptr[rsi+r8]
	vmovapd ymm3,YMMWORD ptr[rsi+r9]
	vmovapd ymm4,YMMWORD ptr[rsi+r10]
	vmovapd ymm5,YMMWORD ptr[rsi+r11]
	vmovapd ymm6,YMMWORD ptr[rsi+r12]
	vmovapd ymm7,YMMWORD ptr[rsi+r13]
	vmovapd ymm8,YMMWORD ptr[rsi+r14]

	vsubpd ymm1,ymm1,YMMWORD ptr[rdi]
	vsubpd ymm2,ymm2,YMMWORD ptr[rdi+r8]
	vsubpd ymm3,ymm3,YMMWORD ptr[rdi+r9]
	vsubpd ymm4,ymm4,YMMWORD ptr[rdi+r10]
	vsubpd ymm5,ymm5,YMMWORD ptr[rdi+r11]
	vsubpd ymm6,ymm6,YMMWORD ptr[rdi+r12]
	vsubpd ymm7,ymm7,YMMWORD ptr[rdi+r13]
	vsubpd ymm8,ymm8,YMMWORD ptr[rdi+r14]

	vmulpd ymm1,ymm1,ymm1
	vmulpd ymm2,ymm2,ymm2
	vmulpd ymm3,ymm3,ymm3
	vmulpd ymm4,ymm4,ymm4
	vmulpd ymm5,ymm5,ymm5
	vmulpd ymm6,ymm6,ymm6
	vmulpd ymm7,ymm7,ymm7
	vmulpd ymm8,ymm8,ymm8

	vaddpd ymm1,ymm1,ymm2
	vaddpd ymm3,ymm3,ymm4
	vaddpd ymm5,ymm5,ymm6
	vaddpd ymm7,ymm7,ymm8
	vaddpd ymm1,ymm1,ymm3
	vaddpd ymm5,ymm5,ymm7
	add rsi,rax
	vaddpd ymm1,ymm1,ymm5
	add rdi,rax
	vaddpd ymm0,ymm0,ymm1

	dec ecx
	jnz VectorDist2D_AVX_loop_1

VectorDist2D_AVX_1:
	test edx,4
	jz short VectorDist2D_AVX_2

	vmovapd ymm1,YMMWORD ptr[rsi]
	vmovapd ymm2,YMMWORD ptr[rsi+r8]
	vmovapd ymm3,YMMWORD ptr[rsi+r9]
	vmovapd ymm4,YMMWORD ptr[rsi+r10]

	vsubpd ymm1,ymm1,YMMWORD ptr[rdi]
	vsubpd ymm2,ymm2,YMMWORD ptr[rdi+r8]
	vsubpd ymm3,ymm3,YMMWORD ptr[rdi+r9]
	vsubpd ymm4,ymm4,YMMWORD ptr[rdi+r10]

	vmulpd ymm1,ymm1,ymm1
	vmulpd ymm2,ymm2,ymm2
	vmulpd ymm3,ymm3,ymm3
	vmulpd ymm4,ymm4,ymm4

	vaddpd ymm1,ymm1,ymm2
	vaddpd ymm3,ymm3,ymm4
	add rsi,r11
	vaddpd ymm1,ymm1,ymm3
	add rdi,r11
	vaddpd ymm0,ymm0,ymm1

VectorDist2D_AVX_2:
	test edx,2
	jz short VectorDist2D_AVX_3

	vmovapd ymm1,YMMWORD ptr[rsi]
	vmovapd ymm2,YMMWORD ptr[rsi+r8]
	vsubpd ymm1,ymm1,YMMWORD ptr[rdi]
	vsubpd ymm2,ymm2,YMMWORD ptr[rdi+r8]
	vmulpd ymm1,ymm1,ymm1
	vmulpd ymm2,ymm2,ymm2

	add rsi,r9
	vaddpd ymm1,ymm1,ymm2
	add rdi,r9
	vaddpd ymm0,ymm0,ymm1

VectorDist2D_AVX_3:
	test edx,1
	jz short VectorDist2D_AVX_4

	vmovapd ymm1,YMMWORD ptr[rsi]
	vsubpd ymm1,ymm1,YMMWORD ptr[rdi]
	vmulpd ymm1,ymm1,ymm1
	vaddpd ymm0,ymm0,ymm1

VectorDist2D_AVX_4:
	vextractf128 xmm1,ymm0,1
	vaddpd xmm0,xmm0,xmm1

	vmovhlps xmm1,xmm1,xmm0
	vaddsd xmm0,xmm0,xmm1
	vsqrtsd xmm0,xmm0,xmm0
	vmovsd qword ptr[rbx],xmm0

	vmovdqa xmm8,XMMWORD ptr[rsp+32]
	vmovdqa xmm7,XMMWORD ptr[rsp+16]
	vmovdqa xmm6,XMMWORD ptr[rsp]
	add rsp,56

	vzeroupper

	pop r14
	pop r13
	pop r12
	pop rsi
	pop rdi
	pop rbx

	ret

VectorDist2D_AVX endp	


;VectorNormeF_SSE2 proc coeff_x:dword,result:dword,lgth:word
; coeff_x = rcx
; result = rdx
; lgth = r8d

VectorNormeF_SSE2 proc public frame
		
	.endprolog
		
	mov r9,rcx
	xorps xmm0,xmm0
	xor rcx,rcx
	mov rax,16
	mov ecx,r8d
		
VectorNormeF_SSE2_1:
	movaps xmm1,XMMWORD ptr[r9]
	mulps xmm1,xmm1
	add r9,rax
	addps xmm0,xmm1
	loop VectorNormeF_SSE2_1
		
	movhlps xmm1,xmm0
	addps xmm0,xmm1
	movaps xmm1,xmm0
	psrldq xmm1,4
	addss xmm0,xmm1
	movss dword ptr[rdx],xmm0
		
	ret
		
VectorNormeF_SSE2 endp	


;VectorNormeF_AVX proc coeff_x:dword,result:dword,lgth:word
; coeff_x = rcx
; result = rdx
; lgth = r8d

VectorNormeF_AVX proc public frame

	.endprolog

	mov r9,rcx
	mov rax,128
	mov ecx,r8d
	mov r10,32
	mov r11,96

	vxorps ymm0,ymm0,ymm0

	shr ecx,2
	jz short VectorNormeF_AVX_1

VectorNormeF_AVX_loop_1:
	vmovaps ymm1,YMMWORD ptr[r9]
	vmovaps ymm2,YMMWORD ptr[r9+r10]
	vmovaps ymm3,YMMWORD ptr[r9+2*r10]
	vmovaps ymm4,YMMWORD ptr[r9+r11]

	vmulps ymm1,ymm1,ymm1
	vmulps ymm2,ymm2,ymm2
	vmulps ymm3,ymm3,ymm3
	vmulps ymm4,ymm4,ymm4

	vaddps ymm1,ymm1,ymm2
	vaddps ymm3,ymm3,ymm4
	vaddps ymm1,ymm1,ymm3
	add r9,rax
	vaddps ymm0,ymm0,ymm1
	loop VectorNormeF_AVX_loop_1

VectorNormeF_AVX_1:
	test r8d,2
	jz short VectorNormeF_AVX_2

	vmovaps ymm1,YMMWORD ptr[r9]
	vmovaps ymm2,YMMWORD ptr[r9+r10]
	vmulps ymm1,ymm1,ymm1
	vmulps ymm2,ymm2,ymm2

	vaddps ymm1,ymm1,ymm2
	add r9,64
	vaddps ymm0,ymm0,ymm1

VectorNormeF_AVX_2:
	test r8d,1
	jz short VectorNormeF_AVX_3

	vmovaps ymm1,YMMWORD ptr[r9]
	vmulps ymm1,ymm1,ymm1
	vaddps ymm0,ymm0,ymm1

VectorNormeF_AVX_3:
	vextractf128 xmm1,ymm0,1
	vaddps xmm0,xmm0,xmm1

	vmovhlps xmm1,xmm1,xmm0
	vaddps xmm0,xmm0,xmm1
	vpsrldq xmm1,xmm0,4
	vaddss xmm0,xmm0,xmm1
	vmovss dword ptr[rdx],xmm0

	vzeroupper

	ret

VectorNormeF_AVX endp


;VectorNormeD_SSE2 proc coeff_x:dword,result:dword,lgth:word
; coeff_x = rcx
; result = rdx
; lgth = r8d

VectorNormeD_SSE2 proc public frame
		
	.endprolog
		
	mov r9,rcx
	xorpd xmm0,xmm0
	xor rcx,rcx
	mov rax,16
	mov ecx,r8d
		
VectorNormeD_SSE2_1:
	movapd xmm1,XMMWORD ptr[r9]
	mulpd xmm1,xmm1
	add r9,rax
	addpd xmm0,xmm1
	loop VectorNormeD_SSE2_1
		
	movhlps xmm1,xmm0
	addsd xmm0,xmm1
	movsd qword ptr[rdx],xmm0
		
	ret
		
VectorNormeD_SSE2 endp	


;VectorNormeD_AVX proc coeff_x:dword,result:dword,lgth:word
; coeff_x = rcx
; result = rdx
; lgth = r8d

VectorNormeD_AVX proc public frame

	.endprolog

	mov r9,rcx
	xor rcx,rcx
	mov rax,128
	mov ecx,r8d
	mov r10,32
	mov r11,96

	vxorpd ymm0,ymm0,ymm0

	shr ecx,2
	jz short VectorNormeD_AVX_1

VectorNormeD_AVX_loop_1:
	vmovapd ymm1,YMMWORD ptr[r9]
	vmovapd ymm2,YMMWORD ptr[r9+r10]
	vmovapd ymm3,YMMWORD ptr[r9+2*r10]
	vmovapd ymm4,YMMWORD ptr[r9+r11]

	vmulpd ymm1,ymm1,ymm1
	vmulpd ymm2,ymm2,ymm2
	vmulpd ymm3,ymm3,ymm3
	vmulpd ymm4,ymm4,ymm4

	vaddpd ymm1,ymm1,ymm2
	vaddpd ymm3,ymm3,ymm4
	vaddpd ymm1,ymm1,ymm3
	add r9,rax
	vaddpd ymm0,ymm0,ymm1

	loop VectorNormeD_AVX_loop_1

VectorNormeD_AVX_1:
	test r8d,2
	jz short VectorNormeD_AVX_2

	vmovapd ymm1,YMMWORD ptr[r9]
	vmovapd ymm2,YMMWORD ptr[r9+r10]
	vmulpd ymm1,ymm1,ymm1
	vmulpd ymm2,ymm2,ymm2

	vaddpd ymm1,ymm1,ymm2
	add r9,64
	vaddpd ymm0,ymm0,ymm1

VectorNormeD_AVX_2:
	test r8d,1
	jz short VectorNormeD_AVX_3

	vmovapd ymm1,YMMWORD ptr[r9]
	vmulpd ymm1,ymm1,ymm1
	vaddpd ymm0,ymm0,ymm1

VectorNormeD_AVX_3:
	vextractf128 xmm1,ymm0,1
	vaddpd xmm0,xmm0,xmm1

	vmovhlps xmm1,xmm1,xmm0
	vaddsd xmm0,xmm0,xmm1
	vmovsd qword ptr[rdx],xmm0

	vzeroupper

	ret

VectorNormeD_AVX endp	


;VectorDistF_SSE2 proc coeff_x:dword,coeff_y:dword,result:dword,lgth:word
; coeff_x = rcx
; coeff_y = rdx
; result = r8
; lgth = r9d

VectorDistF_SSE2 proc public frame
		
	.endprolog
		
	mov r10,rcx
	xorps xmm0,xmm0
	xor rcx,rcx
	mov rax,16
	mov ecx,r9d
		
VectorDistF_SSE2_1:
	movaps xmm1,XMMWORD ptr[r10]
	subps xmm1,XMMWORD ptr[rdx]
	add r10,rax
	mulps xmm1,xmm1
	add rdx,rax
	addps xmm0,xmm1
	loop VectorDistF_SSE2_1
		
	movhlps xmm1,xmm0
	addps xmm0,xmm1
	movaps xmm1,xmm0
	psrldq xmm1,4
	addss xmm0,xmm1
	movss dword ptr[r8],xmm0
		
	ret
		
VectorDistF_SSE2 endp


;VectorDistF_AVX proc coeff_x:dword,coeff_y:dword,result:dword,lgth:word
; coeff_x = rcx
; coeff_y = rdx
; result = r8
; lgth = r9d

VectorDistF_AVX proc public frame

	push rsi
	.pushreg rsi
	.endprolog

	mov rsi,rcx
	mov rax,128
	mov ecx,r9d
	mov r10,32
	mov r11,96

	vxorps ymm0,ymm0,ymm0

	shr ecx,2
	jz short VectorDistF_AVX_1

VectorDistF_AVX_loop_1:
	vmovaps ymm1,YMMWORD ptr[rsi]
	vmovaps ymm2,YMMWORD ptr[rsi+r10]
	vmovaps ymm3,YMMWORD ptr[rsi+2*r10]
	vmovaps ymm4,YMMWORD ptr[rsi+r11]

	vsubps ymm1,ymm1,YMMWORD ptr[rdx]
	vsubps ymm2,ymm2,YMMWORD ptr[rdx+r10]
	vsubps ymm3,ymm3,YMMWORD ptr[rdx+2*r10]
	vsubps ymm4,ymm4,YMMWORD ptr[rdx+r11]

	vmulps ymm1,ymm1,ymm1
	vmulps ymm2,ymm2,ymm2
	vmulps ymm3,ymm3,ymm3
	vmulps ymm4,ymm4,ymm4

	vaddps ymm1,ymm1,ymm2
	vaddps ymm3,ymm3,ymm4
	add rsi,rax
	vaddps ymm1,ymm1,ymm3
	add rdx,rax
	vaddps ymm0,ymm0,ymm1

	loop VectorDistF_AVX_loop_1

VectorDistF_AVX_1:
	test r9d,2
	jz short VectorDistF_AVX_2

	vmovaps ymm1,YMMWORD ptr[rsi]
	vmovaps ymm2,YMMWORD ptr[rsi+r10]
	vsubps ymm1,ymm1,YMMWORD ptr[rdx]
	vsubps ymm2,ymm2,YMMWORD ptr[rdx+r10]
	vmulps ymm1,ymm1,ymm1
	vmulps ymm2,ymm2,ymm2

	add rsi,64
	vaddps ymm1,ymm1,ymm2
	add rdx,64
	vaddps ymm0,ymm0,ymm1

VectorDistF_AVX_2:
	test r9d,1
	jz short VectorDistF_AVX_3

	vmovaps ymm1,YMMWORD ptr[rsi]
	vsubps ymm1,ymm1,YMMWORD ptr[rdx]
	vmulps ymm1,ymm1,ymm1
	vaddps ymm0,ymm0,ymm1

VectorDistF_AVX_3:
	vextractf128 xmm1,ymm0,1
	vaddps xmm0,xmm0,xmm1

	vmovhlps xmm1,xmm1,xmm0
	vaddps xmm0,xmm0,xmm1
	vpsrldq xmm1,xmm0,4
	vaddss xmm0,xmm0,xmm1
	vmovss dword ptr[r8],xmm0

	vzeroupper

	pop rsi

	ret

VectorDistF_AVX endp


;VectorDistD_SSE2 proc coeff_a:dword,coeff_x:dword,result:dword,lgth:word
; coeff_a = rcx
; coeff_x = rdx
; result = r8
; lgth = r9d

VectorDistD_SSE2 proc public frame
		
	.endprolog
		
	mov r10,rcx
	xorpd xmm0,xmm0
	xor rcx,rcx
	mov rax,16
	mov ecx,r9d
		
VectorDistD_SSE2_1:
	movapd xmm1,XMMWORD ptr[r10]
	subpd xmm1,XMMWORD ptr[rdx]
	add r10,rax
	mulpd xmm1,xmm1
	add rdx,rax
	addpd xmm0,xmm1
	loop VectorDistD_SSE2_1
		
	movhlps xmm1,xmm0
	addsd xmm0,xmm1
	movsd qword ptr[r8],xmm0
		
	ret
		
VectorDistD_SSE2 endp


;VectorDistD_AVX proc coeff_a:dword,coeff_x:dword,result:dword,lgth:word
; coeff_a = rcx
; coeff_x = rdx
; result = r8
; lgth = r9d

VectorDistD_AVX proc public frame

	push rsi
	.pushreg rsi
	.endprolog

	mov rsi,rcx
	mov rax,128
	mov ecx,r9d
	mov r10,32
	mov r11,96

	vxorpd ymm0,ymm0,ymm0

	shr ecx,2
	jz short VectorDistD_AVX_1

VectorDistD_AVX_loop_1:
	vmovapd ymm1,YMMWORD ptr[rsi]
	vmovapd ymm2,YMMWORD ptr[rsi+r10]
	vmovapd ymm3,YMMWORD ptr[rsi+2*r10]
	vmovapd ymm4,YMMWORD ptr[rsi+r11]

	vsubpd ymm1,ymm1,YMMWORD ptr[rdx]
	vsubpd ymm2,ymm2,YMMWORD ptr[rdx+r10]
	vsubpd ymm3,ymm3,YMMWORD ptr[rdx+2*r10]
	vsubpd ymm4,ymm4,YMMWORD ptr[rdx+r11]

	vmulpd ymm1,ymm1,ymm1
	vmulpd ymm2,ymm2,ymm2
	vmulpd ymm3,ymm3,ymm3
	vmulpd ymm4,ymm4,ymm4

	vaddpd ymm1,ymm1,ymm2
	vaddpd ymm3,ymm3,ymm4
	add rsi,rax
	vaddpd ymm1,ymm1,ymm3
	add rdx,rax
	vaddpd ymm0,ymm0,ymm1

	loop VectorDistD_AVX_loop_1

VectorDistD_AVX_1:
	test r9d,2
	jz short VectorDistD_AVX_2

	vmovapd ymm1,YMMWORD ptr[rsi]
	vmovapd ymm2,YMMWORD ptr[rsi+r10]
	vsubpd ymm1,ymm1,YMMWORD ptr[rdx]
	vsubpd ymm2,ymm2,YMMWORD ptr[rdx+r10]
	vmulpd ymm1,ymm1,ymm1
	vmulpd ymm2,ymm2,ymm2

	add rsi,64
	vaddpd ymm1,ymm1,ymm2
	add rdx,64
	vaddpd ymm0,ymm0,ymm1

VectorDistD_AVX_2:
	test r9d,1
	jz short VectorDistD_AVX_3

	vmovapd ymm1,YMMWORD ptr[rsi]
	vsubpd ymm1,ymm1,YMMWORD ptr[rdx]
	vmulpd ymm1,ymm1,ymm1
	vaddpd ymm0,ymm0,ymm1

VectorDistD_AVX_3:
	vextractf128 xmm1,ymm0,1
	vaddpd xmm0,xmm0,xmm1

	vmovhlps xmm1,xmm1,xmm0
	vaddsd xmm0,xmm0,xmm1
	vmovsd qword ptr[r8],xmm0

	vzeroupper

	pop rsi

	ret

VectorDistD_AVX endp	


;VectorNorme1F_SSE2 proc coeff_x:dword,result:dword,lgth:word
; coeff_x = rcx
; result = rdx
; lgth = r8d

VectorNorme1F_SSE2 proc public frame
		
	.endprolog
		
	mov r9,rcx
	xorps xmm0,xmm0
	movaps xmm2,XMMWORD ptr sign_bits_f_32
	xor rcx,rcx
	mov rax,16
	mov ecx,r8d
		
VectorNorme1F_SSE2_1:
	movaps xmm1,XMMWORD ptr[r9]
	andps xmm1,xmm2
	add r9,rax
	addps xmm0,xmm1
	loop VectorNorme1F_SSE2_1
		
	movhlps xmm1,xmm0
	addps xmm0,xmm1
	movaps xmm1,xmm0
	psrldq xmm1,4
	addss xmm0,xmm1
	movss dword ptr[rdx],xmm0
		
	ret
		
VectorNorme1F_SSE2 endp	


;VectorNorme1F_AVX proc coeff_x:dword,result:dword,lgth:word
; coeff_x = rcx
; result = rdx
; lgth = r8d

VectorNorme1F_AVX proc public frame

	.endprolog

	mov r9,rcx
	mov rax,128
	mov r10,32
	mov r11,96
	mov ecx,r8d

	vxorps ymm0,ymm0,ymm0
	vmovaps ymm5,YMMWORD ptr sign_bits_f_32

	shr ecx,2
	jz short VectorNorme1F_AVX_1

VectorNorme1F_AVX_loop_1:
	vandps ymm1,ymm5,YMMWORD ptr[r9]
	vandps ymm2,ymm5,YMMWORD ptr[r9+r10]
	vandps ymm3,ymm5,YMMWORD ptr[r9+2*r10]
	vandps ymm4,ymm5,YMMWORD ptr[r9+r11]

	vaddps ymm1,ymm1,ymm2
	vaddps ymm3,ymm3,ymm4
	vaddps ymm1,ymm1,ymm3
	add r9,rax
	vaddps ymm0,ymm0,ymm1

	loop VectorNorme1F_AVX_loop_1

VectorNorme1F_AVX_1:
	test r8d,2
	jz short VectorNorme1F_AVX_2

	vandps ymm1,ymm5,YMMWORD ptr[r9]
	vandps ymm2,ymm5,YMMWORD ptr[r9+r10]

	vaddps ymm1,ymm1,ymm2
	add r9,64
	vaddps ymm0,ymm0,ymm1

VectorNorme1F_AVX_2:
	test r8d,1
	jz short VectorNorme1F_AVX_3

	vandps ymm1,ymm5,YMMWORD ptr[r9]
	vaddps ymm0,ymm0,ymm1

VectorNorme1F_AVX_3:
	vextractf128 xmm1,ymm0,1
	vaddps xmm0,xmm0,xmm1

	vmovhlps xmm1,xmm1,xmm0
	vaddps xmm0,xmm0,xmm1
	vpsrldq xmm1,xmm0,4
	vaddss xmm0,xmm0,xmm1
	vmovss dword ptr[rdx],xmm0

	vzeroupper

	ret

VectorNorme1F_AVX endp


;VectorNorme1D_SSE2 proc coeff_x:dword,result:dword,lgth:word
; coeff_x = rcx
; result = rdx
; lgth = r8d

VectorNorme1D_SSE2 proc public frame
		
	.endprolog
		
	mov r9,rcx
	xorpd xmm0,xmm0
	movapd xmm2,XMMWORD ptr sign_bits_f_64
	xor rcx,rcx
	mov rax,16
	mov ecx,r8d
		
VectorNorme1D_SSE2_1:
	movapd xmm1,XMMWORD ptr[r9]
	andpd xmm1,xmm2
	add r9,rax
	addpd xmm0,xmm1
	loop VectorNorme1D_SSE2_1
		
	movhlps xmm1,xmm0
	addsd xmm0,xmm1
	movsd qword ptr[rdx],xmm0
		
	ret
		
VectorNorme1D_SSE2 endp	


;VectorNorme1D_AVX proc coeff_x:dword,result:dword,lgth:word
; coeff_x = rcx
; result = rdx
; lgth = r8d

VectorNorme1D_AVX proc public frame

	.endprolog

	mov r9,rcx
	mov rax,128
	mov r10,32
	mov r11,96
	mov ecx,r8d

	vxorpd ymm0,ymm0,ymm0
	vmovapd ymm5,YMMWORD ptr sign_bits_f_64

	shr ecx,2
	jz short VectorNorme1D_AVX_1

VectorNorme1D_AVX_loop_1:
	vandpd ymm1,ymm5,YMMWORD ptr[r9]
	vandpd ymm2,ymm5,YMMWORD ptr[r9+r10]
	vandpd ymm3,ymm5,YMMWORD ptr[r9+2*r10]
	vandpd ymm4,ymm5,YMMWORD ptr[r9+r11]

	vaddpd ymm1,ymm1,ymm2
	vaddpd ymm3,ymm3,ymm4
	vaddpd ymm1,ymm1,ymm3
	add r9,rax
	vaddpd ymm0,ymm0,ymm1

	loop VectorNorme1D_AVX_loop_1

VectorNorme1D_AVX_1:
	test r8d,2
	jz short VectorNorme1D_AVX_2

	vandpd ymm1,ymm5,YMMWORD ptr[r9]
	vandpd ymm2,ymm5,YMMWORD ptr[r9+r10]

	vaddpd ymm1,ymm1,ymm2
	add r9,64
	vaddpd ymm0,ymm0,ymm1

VectorNorme1D_AVX_2:
	test r8d,1
	jz short VectorNorme1D_AVX_3

	vandpd ymm1,ymm5,YMMWORD ptr[r9]
	vaddpd ymm0,ymm0,ymm1

VectorNorme1D_AVX_3:
	vextractf128 xmm1,ymm0,1
	vaddpd xmm0,xmm0,xmm1

	vmovhlps xmm1,xmm1,xmm0
	vaddsd xmm0,xmm0,xmm1
	vmovsd qword ptr[rdx],xmm0

	vzeroupper

	ret

VectorNorme1D_AVX endp	


;VectorDist1F_SSE2 proc coeff_x:dword,coeff_y:dword,result:dword,lgth:word
; coeff_x = rcx
; coeff_y = rdx
; result = r8
; lgth = r9d

VectorDist1F_SSE2 proc public frame
		
	.endprolog
		
	mov r10,rcx
	xorps xmm0,xmm0
	movaps xmm2,XMMWORD ptr sign_bits_f_32
	xor rcx,rcx
	mov rax,16
	mov ecx,r9d
		
VectorDist1F_SSE2_1:
	movaps xmm1,XMMWORD ptr[r10]
	subps xmm1,XMMWORD ptr[rdx]
	add r10,rax
	andps xmm1,xmm2
	add rdx,rax
	addps xmm0,xmm1
	loop VectorDist1F_SSE2_1
		
	movhlps xmm1,xmm0
	addps xmm0,xmm1
	movaps xmm1,xmm0
	psrldq xmm1,4
	addss xmm0,xmm1
	movss dword ptr[r8],xmm0
		
	ret
		
VectorDist1F_SSE2 endp


;VectorDist1F_AVX proc coeff_x:dword,coeff_y:dword,result:dword,lgth:word
; coeff_x = rcx
; coeff_y = rdx
; result = r8
; lgth = r9d

VectorDist1F_AVX proc public frame

	push rsi
	.pushreg rsi
	.endprolog

	mov rsi,rcx
	mov rax,128
	mov ecx,r9d
	mov r10,32
	mov r11,96

	vxorps ymm0,ymm0,ymm0
	vmovaps ymm5,YMMWORD ptr sign_bits_f_32

	shr ecx,2
	jz short VectorDist1F_AVX_1

VectorDist1F_AVX_loop_1:
	vmovaps ymm1,YMMWORD ptr[rsi]
	vmovaps ymm2,YMMWORD ptr[rsi+r10]
	vmovaps ymm3,YMMWORD ptr[rsi+2*r10]
	vmovaps ymm4,YMMWORD ptr[rsi+r11]

	vsubps ymm1,ymm1,YMMWORD ptr[rdx]
	vsubps ymm2,ymm2,YMMWORD ptr[rdx+r10]
	vsubps ymm3,ymm3,YMMWORD ptr[rdx+2*r10]
	vsubps ymm4,ymm4,YMMWORD ptr[rdx+r11]

	vandps ymm1,ymm1,ymm5
	vandps ymm2,ymm2,ymm5
	vandps ymm3,ymm3,ymm5
	vandps ymm4,ymm4,ymm5

	vaddps ymm1,ymm1,ymm2
	vaddps ymm3,ymm3,ymm4
	add rsi,rax
	vaddps ymm1,ymm1,ymm3
	add rdx,rax
	vaddps ymm0,ymm0,ymm1

	loop VectorDist1F_AVX_loop_1

VectorDist1F_AVX_1:
	test r9d,2
	jz short VectorDist1F_AVX_2

	vmovaps ymm1,YMMWORD ptr[rsi]
	vmovaps ymm2,YMMWORD ptr[rsi+r10]
	vsubps ymm1,ymm1,YMMWORD ptr[rdx]
	vsubps ymm2,ymm2,YMMWORD ptr[rdx+r10]
	vandps ymm1,ymm1,ymm5
	vandps ymm2,ymm2,ymm5

	add rsi,64
	vaddps ymm1,ymm1,ymm2
	add rdx,64
	vaddps ymm0,ymm0,ymm1

VectorDist1F_AVX_2:
	test r9d,1
	jz short VectorDist1F_AVX_3

	vmovaps ymm1,YMMWORD ptr[rsi]
	vsubps ymm1,ymm1,YMMWORD ptr[rdx]
	vandps ymm1,ymm1,ymm5
	vaddps ymm0,ymm0,ymm1

VectorDist1F_AVX_3:
	vextractf128 xmm1,ymm0,1
	vaddps xmm0,xmm0,xmm1

	vmovhlps xmm1,xmm1,xmm0
	vaddps xmm0,xmm0,xmm1
	vpsrldq xmm1,xmm0,4
	vaddss xmm0,xmm0,xmm1
	vmovss dword ptr[r8],xmm0

	vzeroupper

	pop rsi

	ret

VectorDist1F_AVX endp


;VectorDist1D_SSE2 proc coeff_a:dword,coeff_x:dword,result:dword,lgth:word
; coeff_a = rcx
; coeff_x = rdx
; result = r8
; lgth = r9d

VectorDist1D_SSE2 proc public frame
		
	.endprolog
		
	mov r10,rcx
	xorpd xmm0,xmm0
	movapd xmm2,XMMWORD ptr sign_bits_f_64
	xor rcx,rcx
	mov rax,16
	mov ecx,r9d
		
VectorDist1D_SSE2_1:
	movapd xmm1,XMMWORD ptr[r10]
	subpd xmm1,XMMWORD ptr[rdx]
	add r10,rax
	andpd xmm1,xmm2
	add rdx,rax
	addpd xmm0,xmm1
	loop VectorDist1D_SSE2_1
		
	movhlps xmm1,xmm0
	addsd xmm0,xmm1
	movsd qword ptr[r8],xmm0
		
	ret
		
VectorDist1D_SSE2 endp


;VectorDist1D_AVX proc coeff_a:dword,coeff_x:dword,result:dword,lgth:word
; coeff_a = rcx
; coeff_x = rdx
; result = r8
; lgth = r9d

VectorDist1D_AVX proc public frame

	push rsi
	.pushreg rsi
	.endprolog

	mov rsi,rcx
	mov rax,128
	mov ecx,r9d
	mov r10,32
	mov r11,96

	vxorpd ymm0,ymm0,ymm0
	vmovapd ymm5,YMMWORD ptr sign_bits_f_64

	shr ecx,2
	jz short VectorDist1D_AVX_1

VectorDist1D_AVX_loop_1:
	vmovapd ymm1,YMMWORD ptr[rsi]
	vmovapd ymm2,YMMWORD ptr[rsi+r10]
	vmovapd ymm3,YMMWORD ptr[rsi+2*r10]
	vmovapd ymm4,YMMWORD ptr[rsi+96]

	vsubpd ymm1,ymm1,YMMWORD ptr[rdx]
	vsubpd ymm2,ymm2,YMMWORD ptr[rdx+r10]
	vsubpd ymm3,ymm3,YMMWORD ptr[rdx+2*r10]
	vsubpd ymm4,ymm4,YMMWORD ptr[rdx+96]

	vandpd ymm1,ymm1,ymm5
	vandpd ymm2,ymm2,ymm5
	vandpd ymm3,ymm3,ymm5
	vandpd ymm4,ymm4,ymm5

	vaddpd ymm1,ymm1,ymm2
	vaddpd ymm3,ymm3,ymm4
	add rsi,rax
	vaddpd ymm1,ymm1,ymm3
	add rdx,rax
	vaddpd ymm0,ymm0,ymm1

	loop VectorDist1D_AVX_loop_1

VectorDist1D_AVX_1:
	test r9d,2
	jz short VectorDist1D_AVX_2

	vmovapd ymm1,YMMWORD ptr[rsi]
	vmovapd ymm2,YMMWORD ptr[rsi+r10]
	vsubpd ymm1,ymm1,YMMWORD ptr[rdx]
	vsubpd ymm2,ymm2,YMMWORD ptr[rdx+r10]
	vandpd ymm1,ymm1,ymm5
	vandpd ymm2,ymm2,ymm5

	add rsi,64
	vaddpd ymm1,ymm1,ymm2
	add rdx,64
	vaddpd ymm0,ymm0,ymm1

VectorDist1D_AVX_2:
	test r9d,1
	jz short VectorDist1D_AVX_3

	vmovapd ymm1,YMMWORD ptr[rsi]
	vsubpd ymm1,ymm1,YMMWORD ptr[rdx]
	vandpd ymm1,ymm1,ymm5
	vaddpd ymm0,ymm0,ymm1

VectorDist1D_AVX_3:
	vextractf128 xmm1,ymm0,1
	vaddpd xmm0,xmm0,xmm1

	vmovhlps xmm1,xmm1,xmm0
	vaddsd xmm0,xmm0,xmm1
	vmovsd qword ptr[r8],xmm0

	vzeroupper

	pop rsi

	ret

VectorDist1D_AVX endp	


;VectorProductF_SSE2 proc coeff_a:dword,coeff_x:dword,result:dword,lgth:word
; coeff_a = rcx
; coeff_x = rdx
; result = r8
; lgth = r9d

VectorProductF_SSE2 proc public frame
		
	.endprolog
		
	mov r10,rcx
	xorps xmm0,xmm0
	xor rcx,rcx
	mov rax,16
	mov ecx,r9d
		
VectorProductF_SSE2_1:
	movaps xmm1,XMMWORD ptr[r10]
	add r10,rax
	mulps xmm1,XMMWORD ptr[rdx]
	add rdx,rax
	addps xmm0,xmm1
	loop VectorProductF_SSE2_1
		
	movhlps xmm1,xmm0
	addps xmm0,xmm1
	movaps xmm1,xmm0
	psrldq xmm1,4
	addss xmm0,xmm1
	movss dword ptr[r8],xmm0
		
	ret
		
VectorProductF_SSE2 endp		
		
		
;VectorProductF_AVX proc coeff_a:dword,coeff_x:dword,result:dword,lgth:word
; coeff_a = rcx
; coeff_x = rdx
; result = r8
; lgth = r9d

VectorProductF_AVX proc public frame

	push rsi
	.pushreg rsi
	.endprolog

	mov rsi,rcx
	mov rax,128
	mov ecx,r9d
	mov r10,32
	mov r11,96

	vxorps ymm0,ymm0,ymm0

	shr ecx,2
	jz short VectorProductF_AVX_1

VectorProductF_AVX_loop_1:
	vmovaps ymm1,YMMWORD ptr[rsi]
	vmovaps ymm2,YMMWORD ptr[rsi+r10]
	vmovaps ymm3,YMMWORD ptr[rsi+2*r10]
	vmovaps ymm4,YMMWORD ptr[rsi+r11]

	vmulps ymm1,ymm1,YMMWORD ptr[rdx]
	vmulps ymm2,ymm2,YMMWORD ptr[rdx+r10]
	vmulps ymm3,ymm3,YMMWORD ptr[rdx+2*r10]
	vmulps ymm4,ymm4,YMMWORD ptr[rdx+r11]

	vaddps ymm1,ymm1,ymm2
	vaddps ymm3,ymm3,ymm4
	add rsi,rax
	vaddps ymm1,ymm1,ymm3
	add rdx,rax
	vaddps ymm0,ymm0,ymm1

	loop VectorProductF_AVX_loop_1

VectorProductF_AVX_1:
	test r9d,2
	jz short VectorProductF_AVX_2

	vmovaps ymm1,YMMWORD ptr[rsi]
	vmovaps ymm2,YMMWORD ptr[rsi+r10]
	vmulps ymm1,ymm1,YMMWORD ptr[rdx]
	vmulps ymm2,ymm2,YMMWORD ptr[rdx+r10]

	add rsi,64
	vaddps ymm1,ymm1,ymm2
	add rdx,64
	vaddps ymm0,ymm0,ymm1

VectorProductF_AVX_2:
	test r9d,1
	jz short VectorProductF_AVX_3

	vmovaps ymm1,YMMWORD ptr[rsi]
	vmulps ymm1,ymm1,YMMWORD ptr[rdx]
	vaddps ymm0,ymm0,ymm1

VectorProductF_AVX_3:
	vextractf128 xmm1,ymm0,1
	vaddps xmm0,xmm0,xmm1

	vmovhlps xmm1,xmm1,xmm0
	vaddps xmm0,xmm0,xmm1
	vpsrldq xmm1,xmm0,4
	vaddss xmm0,xmm0,xmm1
	vmovss dword ptr[r8],xmm0

	vzeroupper

	pop rsi

	ret

VectorProductF_AVX endp

		
;VectorProductD_SSE2 proc coeff_a:dword,coeff_x:dword,result:dword,lgth:word
; coeff_a = rcx
; coeff_x = rdx
; result = r8
; lgth = r9d

VectorProductD_SSE2 proc public frame
		
	.endprolog
		
	mov r10,rcx
	xorpd xmm0,xmm0
	xor rcx,rcx
	mov rax,16
	mov ecx,r9d
		
VectorProductD_SSE2_1:
	movapd xmm1,XMMWORD ptr[r10]
	add r10,rax
	mulpd xmm1,XMMWORD ptr[rdx]
	add rdx,rax
	addpd xmm0,xmm1
	loop VectorProductD_SSE2_1
		
	movhlps xmm1,xmm0
	addsd xmm0,xmm1
	movsd qword ptr[r8],xmm0
		
	ret
		
VectorProductD_SSE2 endp		


;VectorProductD_AVX proc coeff_a:dword,coeff_x:dword,result:dword,lgth:word
; coeff_a = rcx
; coeff_x = rdx
; result = r8
; lgth = r9d

VectorProductD_AVX proc public frame

	push rsi
	.pushreg rsi
	.endprolog

	mov rsi,rcx
	mov rax,128
	mov ecx,r9d
	mov r10,32
	mov r11,96

	vxorpd ymm0,ymm0,ymm0

	shr ecx,2
	jz short VectorProductD_AVX_1

VectorProductD_AVX_loop_1:
	vmovapd ymm1,YMMWORD ptr[rsi]
	vmovapd ymm2,YMMWORD ptr[rsi+r10]
	vmovapd ymm3,YMMWORD ptr[rsi+2*r10]
	vmovapd ymm4,YMMWORD ptr[rsi+r11]

	vmulpd ymm1,ymm1,YMMWORD ptr[rdx]
	vmulpd ymm2,ymm2,YMMWORD ptr[rdx+r10]
	vmulpd ymm3,ymm3,YMMWORD ptr[rdx+2*r10]
	vmulpd ymm4,ymm4,YMMWORD ptr[rdx+r11]

	vaddpd ymm1,ymm1,ymm2
	vaddpd ymm3,ymm3,ymm4
	add rsi,rax
	vaddpd ymm1,ymm1,ymm3
	add rdx,rax
	vaddpd ymm0,ymm0,ymm1

	loop VectorProductD_AVX_loop_1

VectorProductD_AVX_1:
	test r9d,2
	jz short VectorProductD_AVX_2

	vmovapd ymm1,YMMWORD ptr[rsi]
	vmovapd ymm2,YMMWORD ptr[rsi+r10]
	vmulpd ymm1,ymm1,YMMWORD ptr[rdx]
	vmulpd ymm2,ymm2,YMMWORD ptr[rdx+r10]

	add rsi,64
	vaddpd ymm1,ymm1,ymm2
	add rdx,64
	vaddpd ymm0,ymm0,ymm1

VectorProductD_AVX_2:
	test r9d,1
	jz short VectorProductD_AVX_3

	vmovapd ymm1,YMMWORD ptr[rsi]
	vmulpd ymm1,ymm1,YMMWORD ptr[rdx]
	vaddpd ymm0,ymm0,ymm1

VectorProductD_AVX_3:
	vextractf128 xmm1,ymm0,1
	vaddpd xmm0,xmm0,xmm1

	vmovhlps xmm1,xmm1,xmm0
	vaddsd xmm0,xmm0,xmm1
	vmovsd qword ptr[r8],xmm0

	vzeroupper

	pop rsi

	ret

VectorProductD_AVX endp	


;VectorAddF_SSE2 proc coeff_a:dword,coeff_b:dword,coeff_c:dword,lgth:word
; coeff_a = rcx
; coeff_b = rdx
; coeff_c = r8
; lgth = r9d

VectorAddF_SSE2 proc public frame

	.endprolog

	mov r10,rcx
	mov r11,16
	xor rcx,rcx
	mov ecx,r9d
	
VectorAddF_SSE2_1:	
	movaps xmm0,XMMWORD ptr[r10]
	add r10,r11
	addps xmm0,XMMWORD ptr[rdx]
	add rdx,r11
	movaps XMMWORD ptr[r8],xmm0
	add r8,r11
	loop VectorAddF_SSE2_1
	
	ret
	
VectorAddF_SSE2 endp	


;VectorSubF_SSE2 proc coeff_a:dword,coeff_b:dword,coeff_c:dword,lgth:word
; coeff_a = rcx
; coeff_b = rdx
; coeff_c = r8
; lgth = r9d

VectorSubF_SSE2 proc public frame

	.endprolog

	mov r10,rcx
	mov r11,16
	xor rcx,rcx
	mov ecx,r9d
	
VectorSubF_SSE2_1:	
	movaps xmm0,XMMWORD ptr[r10]
	add r10,r11
	subps xmm0,XMMWORD ptr[rdx]
	add rdx,r11
	movaps XMMWORD ptr[r8],xmm0
	add r8,r11
	loop VectorSubF_SSE2_1
	
	ret
	
VectorSubF_SSE2 endp


;VectorProdF_SSE2 proc coeff_a:dword,coeff_b:dword,coeff_c:dword,lgth:word
; coeff_a = rcx
; coeff_b = rdx
; coeff_c = r8
; lgth = r9d

VectorProdF_SSE2 proc public frame

	.endprolog

	mov r10,rcx
	mov r11,16
	xor rcx,rcx
	mov ecx,r9d
	
VectorProdF_SSE2_1:	
	movaps xmm0,XMMWORD ptr[r10]
	add r10,r11
	mulps xmm0,XMMWORD ptr[rdx]
	add rdx,r11
	movaps XMMWORD ptr[r8],xmm0
	add r8,r11
	loop VectorProdF_SSE2_1
	
	ret
	
VectorProdF_SSE2 endp


;VectorAdd2F_SSE2 proc coeff_a:dword,coeff_b:dword,lgth:word
; coeff_a = rcx
; coeff_b = rdx
; lgth = r8d

VectorAdd2F_SSE2 proc public frame

	.endprolog

	mov r9,rcx
	mov r10,16
	xor rcx,rcx
	mov ecx,r8d
	
VectorAdd2F_SSE2_1:	
	movaps xmm0,XMMWORD ptr[r9]
	addps xmm0,XMMWORD ptr[rdx]
	add rdx,r10
	movaps XMMWORD ptr[r9],xmm0
	add r9,r10
	loop VectorAdd2F_SSE2_1
	
	ret
	
VectorAdd2F_SSE2 endp


;VectorSub2F_SSE2 proc coeff_a:dword,coeff_b:dword,lgth:word
; coeff_a = rcx
; coeff_b = rdx
; lgth = r8d

VectorSub2F_SSE2 proc public frame

	.endprolog

	mov r9,rcx
	mov r10,16
	xor rcx,rcx
	mov ecx,r8d
	
VectorSub2F_SSE2_1:	
	movaps xmm0,XMMWORD ptr[r9]
	subps xmm0,XMMWORD ptr[rdx]
	add rdx,r10
	movaps XMMWORD ptr[r9],xmm0
	add r9,r10
	loop VectorSub2F_SSE2_1
	
	ret
	
VectorSub2F_SSE2 endp


;VectorInvSubF_SSE2 proc coeff_a:dword,coeff_b:dword,lgth:word
; coeff_a = rcx
; coeff_b = rdx
; lgth = r8d

VectorInvSubF_SSE2 proc public frame

	.endprolog

	mov r9,rcx
	mov r10,16
	xor rcx,rcx
	mov ecx,r8d
	
VectorInvSubF_SSE2_1:	
	movaps xmm0,XMMWORD ptr[rdx]
	subps xmm0,XMMWORD ptr[r9]
	add rdx,r10
	movaps XMMWORD ptr[r9],xmm0
	add r9,r10
	loop VectorInvSubF_SSE2_1
	
	ret
	
VectorInvSubF_SSE2 endp


;VectorProd2F_SSE2 proc coeff_a:dword,coeff_b:dword,lgth:word
; coeff_a = rcx
; coeff_b = rdx
; lgth = r8d

VectorProd2F_SSE2 proc public frame

	.endprolog

	mov r9,rcx
	mov r10,16
	xor rcx,rcx
	mov ecx,r8d
	
VectorProd2F_SSE2_1:	
	movaps xmm0,XMMWORD ptr[r9]
	mulps xmm0,XMMWORD ptr[rdx]
	add rdx,r10
	movaps XMMWORD ptr[r9],xmm0
	add r9,r10
	loop VectorProd2F_SSE2_1
	
	ret
	
VectorProd2F_SSE2 endp


;VectorAddF_AVX proc coeff_a:dword,coeff_b:dword,coeff_c:dword,lgth:word
; coeff_a = rcx
; coeff_b = rdx
; coeff_c = r8
; lgth = r9d

VectorAddF_AVX proc public frame

	push rsi
	.pushreg rsi
	.endprolog

	mov rsi,rcx
	mov rax,128
	mov ecx,r9d
	mov r10,32
	mov r11,96

	shr ecx,2
	jz short VectorAddF_AVX_1

VectorAddF_AVX_loop_1:
	vmovaps ymm0,YMMWORD ptr[rsi]
	vmovaps ymm1,YMMWORD ptr[rsi+r10]
	vmovaps ymm2,YMMWORD ptr[rsi+2*r10]
	vmovaps ymm3,YMMWORD ptr[rsi+r11]

	vaddps ymm0,ymm0,YMMWORD ptr[rdx]
	vaddps ymm1,ymm1,YMMWORD ptr[rdx+r10]
	vaddps ymm2,ymm2,YMMWORD ptr[rdx+2*r10]
	vaddps ymm3,ymm3,YMMWORD ptr[rdx+r11]

	vmovaps YMMWORD ptr[r8],ymm0
	vmovaps YMMWORD ptr[r8+r10],ymm1
	vmovaps YMMWORD ptr[r8+2*r10],ymm2
	vmovaps YMMWORD ptr[r8+r11],ymm3

	add rsi,rax
	add rdx,rax
	add r8,rax
	loop VectorAddF_AVX_loop_1

VectorAddF_AVX_1:
	test r9d,2
	jz short VectorAddF_AVX_2

	vmovaps ymm0,YMMWORD ptr[rsi]
	vmovaps ymm1,YMMWORD ptr[rsi+r10]
	vaddps ymm0,ymm0,YMMWORD ptr[rdx]
	vaddps ymm1,ymm1,YMMWORD ptr[rdx+r10]
	vmovaps YMMWORD ptr[r8],ymm0
	vmovaps YMMWORD ptr[r8+r10],ymm1

	add rsi,64
	add rdx,64
	add r8,64

VectorAddF_AVX_2:
	test r9d,1
	jz short VectorAddF_AVX_3

	vmovaps ymm0,YMMWORD ptr[rsi]
	vaddps ymm0,ymm0,YMMWORD ptr[rdx]
	vmovaps YMMWORD ptr[r8],ymm0

VectorAddF_AVX_3:
	vzeroupper

	pop rsi

	ret

VectorAddF_AVX endp


;VectorSubF_AVX proc coeff_a:dword,coeff_b:dword,coeff_c:dword,lgth:word
; coeff_a = rcx
; coeff_b = rdx
; coeff_c = r8
; lgth = r9d

VectorSubF_AVX proc public frame

	push rsi
	.pushreg rsi
	.endprolog

	mov rsi,rcx
	mov rax,128
	mov ecx,r9d
	mov r10,32
	mov r11,96

	shr ecx,2
	jz short VectorSubF_AVX_1

VectorSubF_AVX_loop_1:
	vmovaps ymm0,YMMWORD ptr[rsi]
	vmovaps ymm1,YMMWORD ptr[rsi+r10]
	vmovaps ymm2,YMMWORD ptr[rsi+2*r10]
	vmovaps ymm3,YMMWORD ptr[rsi+r11]

	vsubps ymm0,ymm0,YMMWORD ptr[rdx]
	vsubps ymm1,ymm1,YMMWORD ptr[rdx+r10]
	vsubps ymm2,ymm2,YMMWORD ptr[rdx+2*r10]
	vsubps ymm3,ymm3,YMMWORD ptr[rdx+r11]

	vmovaps YMMWORD ptr[r8],ymm0
	vmovaps YMMWORD ptr[r8+r10],ymm1
	vmovaps YMMWORD ptr[r8+2*r10],ymm2
	vmovaps YMMWORD ptr[r8+r11],ymm3

	add rsi,rax
	add rdx,rax
	add r8,rax
	loop VectorSubF_AVX_loop_1

VectorSubF_AVX_1:
	test r9d,2
	jz short VectorSubF_AVX_2

	vmovaps ymm0,YMMWORD ptr[rsi]
	vmovaps ymm1,YMMWORD ptr[rsi+r10]
	vsubps ymm0,ymm0,YMMWORD ptr[rdx]
	vsubps ymm1,ymm1,YMMWORD ptr[rdx+r10]
	vmovaps YMMWORD ptr[r8],ymm0
	vmovaps YMMWORD ptr[r8+r10],ymm1

	add rsi,64
	add rdx,64
	add r8,64

VectorSubF_AVX_2:
	test r9d,1
	jz short VectorSubF_AVX_3

	vmovaps ymm0,YMMWORD ptr[rsi]
	vsubps ymm0,ymm0,YMMWORD ptr[rdx]
	vmovaps YMMWORD ptr[r8],ymm0

VectorSubF_AVX_3:
	vzeroupper

	pop rsi

	ret

VectorSubF_AVX endp


;VectorProdF_AVX proc coeff_a:dword,coeff_b:dword,coeff_c:dword,lgth:word
; coeff_a = rcx
; coeff_b = rdx
; coeff_c = r8
; lgth = r9d

VectorProdF_AVX proc public frame

	push rsi
	.pushreg rsi
	.endprolog

	mov rsi,rcx
	mov rax,128
	mov ecx,r9d
	mov r10,32
	mov r11,96

	shr ecx,2
	jz short VectorProdF_AVX_1

VectorProdF_AVX_loop_1:
	vmovaps ymm0,YMMWORD ptr[rsi]
	vmovaps ymm1,YMMWORD ptr[rsi+r10]
	vmovaps ymm2,YMMWORD ptr[rsi+2*r10]
	vmovaps ymm3,YMMWORD ptr[rsi+r11]

	vmulps ymm0,ymm0,YMMWORD ptr[rdx]
	vmulps ymm1,ymm1,YMMWORD ptr[rdx+r10]
	vmulps ymm2,ymm2,YMMWORD ptr[rdx+2*r10]
	vmulps ymm3,ymm3,YMMWORD ptr[rdx+r11]

	vmovaps YMMWORD ptr[r8],ymm0
	vmovaps YMMWORD ptr[r8+r10],ymm1
	vmovaps YMMWORD ptr[r8+2*r10],ymm2
	vmovaps YMMWORD ptr[r8+r11],ymm3

	add rsi,rax
	add rdx,rax
	add r8,rax
	loop VectorProdF_AVX_loop_1

VectorProdF_AVX_1:
	test r9d,2
	jz short VectorProdF_AVX_2

	vmovaps ymm0,YMMWORD ptr[rsi]
	vmovaps ymm1,YMMWORD ptr[rsi+r10]
	vmulps ymm0,ymm0,YMMWORD ptr[rdx]
	vmulps ymm1,ymm1,YMMWORD ptr[rdx+r10]
	vmovaps YMMWORD ptr[r8],ymm0
	vmovaps YMMWORD ptr[r8+r10],ymm1

	add rsi,64
	add rdx,64
	add r8,64

VectorProdF_AVX_2:
	test r9d,1
	jz short VectorProdF_AVX_3

	vmovaps ymm0,YMMWORD ptr[rsi]
	vmulps ymm0,ymm0,YMMWORD ptr[rdx]
	vmovaps YMMWORD ptr[r8],ymm0

VectorProdF_AVX_3:
	vzeroupper

	pop rsi

	ret

VectorProdF_AVX endp


;VectorAdd2F_AVX proc coeff_a:dword,coeff_b:dword,lgth:word
; coeff_a = rcx
; coeff_b = rdx
; lgth = r8d

VectorAdd2F_AVX proc public frame

	push rsi
	.pushreg rsi
	.endprolog

	mov rsi,rcx
	mov rax,128
	mov ecx,r8d
	mov r9,32
	mov r10,64
	mov r11,96

	shr ecx,2
	jz short VectorAdd2F_AVX_1

VectorAdd2F_AVX_loop_1:
	vmovaps ymm0,YMMWORD ptr[rsi]
	vmovaps ymm1,YMMWORD ptr[rsi+r9]
	vmovaps ymm2,YMMWORD ptr[rsi+r10]
	vmovaps ymm3,YMMWORD ptr[rsi+r11]

	vaddps ymm0,ymm0,YMMWORD ptr[rdx]
	vaddps ymm1,ymm1,YMMWORD ptr[rdx+r9]
	vaddps ymm2,ymm2,YMMWORD ptr[rdx+r10]
	vaddps ymm3,ymm3,YMMWORD ptr[rdx+r11]

	vmovaps YMMWORD ptr[rsi],ymm0
	vmovaps YMMWORD ptr[rsi+r9],ymm1
	vmovaps YMMWORD ptr[rsi+r10],ymm2
	vmovaps YMMWORD ptr[rsi+r11],ymm3

	add rdx,rax
	add rsi,rax
	loop VectorAdd2F_AVX_loop_1

VectorAdd2F_AVX_1:
	test r8d,2
	jz short VectorAdd2F_AVX_2

	vmovaps ymm0,YMMWORD ptr[rsi]
	vmovaps ymm1,YMMWORD ptr[rsi+r9]
	vaddps ymm0,ymm0,YMMWORD ptr[rdx]
	vaddps ymm1,ymm1,YMMWORD ptr[rdx+r9]
	vmovaps YMMWORD ptr[rsi],ymm0
	vmovaps YMMWORD ptr[rsi+r9],ymm1

	add rdx,r10
	add rsi,r10

VectorAdd2F_AVX_2:
	test r8d,1
	jz short VectorAdd2F_AVX_3

	vmovaps ymm0,YMMWORD ptr[rsi]
	vaddps ymm0,ymm0,YMMWORD ptr[rdx]
	vmovaps YMMWORD ptr[rsi],ymm0

VectorAdd2F_AVX_3:
	vzeroupper

	pop rsi

	ret

VectorAdd2F_AVX endp


;VectorSub2F_AVX proc coeff_a:dword,coeff_b:dword,lgth:word
; coeff_a = rcx
; coeff_b = rdx
; lgth = r8d

VectorSub2F_AVX proc public frame

	push rsi
	.pushreg rsi
	.endprolog

	mov rsi,rcx
	mov rax,128
	mov ecx,r8d
	mov r9,32
	mov r10,64
	mov r11,96

	shr ecx,2
	jz short VectorSub2F_AVX_1

VectorSub2F_AVX_loop_1:
	vmovaps ymm0,YMMWORD ptr[rsi]
	vmovaps ymm1,YMMWORD ptr[rsi+r9]
	vmovaps ymm2,YMMWORD ptr[rsi+r10]
	vmovaps ymm3,YMMWORD ptr[rsi+r11]

	vsubps ymm0,ymm0,YMMWORD ptr[rdx]
	vsubps ymm1,ymm1,YMMWORD ptr[rdx+r9]
	vsubps ymm2,ymm2,YMMWORD ptr[rdx+r10]
	vsubps ymm3,ymm3,YMMWORD ptr[rdx+r11]

	vmovaps YMMWORD ptr[rsi],ymm0
	vmovaps YMMWORD ptr[rsi+r9],ymm1
	vmovaps YMMWORD ptr[rsi+r10],ymm2
	vmovaps YMMWORD ptr[rsi+r11],ymm3

	add rdx,rax
	add rsi,rax
	loop VectorSub2F_AVX_loop_1

VectorSub2F_AVX_1:
	test r8d,2
	jz short VectorSub2F_AVX_2

	vmovaps ymm0,YMMWORD ptr[rsi]
	vmovaps ymm1,YMMWORD ptr[rsi+r9]
	vsubps ymm0,ymm0,YMMWORD ptr[rdx]
	vsubps ymm1,ymm1,YMMWORD ptr[rdx+r9]
	vmovaps YMMWORD ptr[rsi],ymm0
	vmovaps YMMWORD ptr[rsi+r9],ymm1

	add rdx,r10
	add rsi,r10

VectorSub2F_AVX_2:
	test r8d,1
	jz short VectorSub2F_AVX_3

	vmovaps ymm0,YMMWORD ptr[rsi]
	vsubps ymm0,ymm0,YMMWORD ptr[rdx]
	vmovaps YMMWORD ptr[rsi],ymm0

VectorSub2F_AVX_3:
	vzeroupper

	pop rsi

	ret

VectorSub2F_AVX endp


;VectorInvSubF_AVX proc coeff_a:dword,coeff_b:dword,lgth:word
; coeff_a = rcx
; coeff_b = rdx
; lgth = r8d

VectorInvSubF_AVX proc public frame

	push rsi
	.pushreg rsi
	.endprolog

	mov rsi,rcx
	mov rax,128
	mov ecx,r8d
	mov r9,32
	mov r10,64
	mov r11,96

	shr ecx,2
	jz short VectorInvSubF_AVX_1

VectorInvSubF_AVX_loop_1:
	vmovaps ymm0,YMMWORD ptr[rdx]
	vmovaps ymm1,YMMWORD ptr[rdx+r9]
	vmovaps ymm2,YMMWORD ptr[rdx+r10]
	vmovaps ymm3,YMMWORD ptr[rdx+r11]

	vsubps ymm0,ymm0,YMMWORD ptr[rsi]
	vsubps ymm1,ymm1,YMMWORD ptr[rsi+r9]
	vsubps ymm2,ymm2,YMMWORD ptr[rsi+r10]
	vsubps ymm3,ymm3,YMMWORD ptr[rsi+r11]

	vmovaps YMMWORD ptr[rsi],ymm0
	vmovaps YMMWORD ptr[rsi+r9],ymm1
	vmovaps YMMWORD ptr[rsi+r10],ymm2
	vmovaps YMMWORD ptr[rsi+r11],ymm3

	add rdx,rax
	add rsi,rax
	loop VectorInvSubF_AVX_loop_1

VectorInvSubF_AVX_1:
	test r8d,2
	jz short VectorInvSubF_AVX_2

	vmovaps ymm0,YMMWORD ptr[rdx]
	vmovaps ymm1,YMMWORD ptr[rdx+r9]
	vsubps ymm0,ymm0,YMMWORD ptr[rsi]
	vsubps ymm1,ymm1,YMMWORD ptr[rsi+r9]
	vmovaps YMMWORD ptr[rsi],ymm0
	vmovaps YMMWORD ptr[rsi+r9],ymm1

	add rdx,r10
	add rsi,r10

VectorInvSubF_AVX_2:
	test r8d,1
	jz short VectorInvSubF_AVX_3

	vmovaps ymm0,YMMWORD ptr[rdx]
	vsubps ymm0,ymm0,YMMWORD ptr[rsi]
	vmovaps YMMWORD ptr[rsi],ymm0

VectorInvSubF_AVX_3:
	vzeroupper

	pop rsi

	ret

VectorInvSubF_AVX endp


;VectorProd2F_AVX proc coeff_a:dword,coeff_b:dword,lgth:word
; coeff_a = rcx
; coeff_b = rdx
; lgth = r8d

VectorProd2F_AVX proc public frame

	push rsi
	.pushreg rsi
	.endprolog

	mov rsi,rcx
	mov rax,128
	mov ecx,r8d
	mov r9,32
	mov r10,64
	mov r11,96

	shr ecx,2
	jz short VectorProd2F_AVX_1

VectorProd2F_AVX_loop_1:
	vmovaps ymm0,YMMWORD ptr[rsi]
	vmovaps ymm1,YMMWORD ptr[rsi+r9]
	vmovaps ymm2,YMMWORD ptr[rsi+r10]
	vmovaps ymm3,YMMWORD ptr[rsi+r11]

	vmulps ymm0,ymm0,YMMWORD ptr[rdx]
	vmulps ymm1,ymm1,YMMWORD ptr[rdx+r9]
	vmulps ymm2,ymm2,YMMWORD ptr[rdx+r10]
	vmulps ymm3,ymm3,YMMWORD ptr[rdx+r11]

	vmovaps YMMWORD ptr[rsi],ymm0
	vmovaps YMMWORD ptr[rsi+r9],ymm1
	vmovaps YMMWORD ptr[rsi+r10],ymm2
	vmovaps YMMWORD ptr[rsi+r11],ymm3

	add rdx,rax
	add rsi,rax
	loop VectorProd2F_AVX_loop_1

VectorProd2F_AVX_1:
	test r8d,2
	jz short VectorProd2F_AVX_2

	vmovaps ymm0,YMMWORD ptr[rsi]
	vmovaps ymm1,YMMWORD ptr[rsi+r9]
	vmulps ymm0,ymm0,YMMWORD ptr[rdx]
	vmulps ymm1,ymm1,YMMWORD ptr[rdx+r9]
	vmovaps YMMWORD ptr[rsi],ymm0
	vmovaps YMMWORD ptr[rsi+r9],ymm1

	add rdx,r10
	add rsi,r10

VectorProd2F_AVX_2:
	test r8d,1
	jz short VectorProd2F_AVX_3

	vmovaps ymm0,YMMWORD ptr[rsi]
	vmulps ymm0,ymm0,YMMWORD ptr[rdx]
	vmovaps YMMWORD ptr[rsi],ymm0

VectorProd2F_AVX_3:
	vzeroupper

	pop rsi

	ret

VectorProd2F_AVX endp


;VectorAddD_SSE2 proc coeff_a:dword,coeff_b:dword,coeff_c:dword,lgth:word
; coeff_a = rcx
; coeff_b = rdx
; coeff_c = r8
; lgth = r9d

VectorAddD_SSE2 proc public frame

	.endprolog

	mov r10,rcx
	mov r11,16
	xor rcx,rcx
	mov ecx,r9d
	
VectorAddD_SSE2_1:	
	movapd xmm0,XMMWORD ptr[r10]
	add r10,r11
	addpd xmm0,XMMWORD ptr[rdx]
	add rdx,r11
	movapd XMMWORD ptr[r8],xmm0
	add r8,r11
	loop VectorAddD_SSE2_1
	
	ret
	
VectorAddD_SSE2 endp	


;VectorSubD_SSE2 proc coeff_a:dword,coeff_b:dword,coeff_c:dword,lgth:word
; coeff_a = rcx
; coeff_b = rdx
; coeff_c = r8
; lgth = r9d

VectorSubD_SSE2 proc public frame

	.endprolog

	mov r10,rcx
	mov r11,16
	xor rcx,rcx
	mov ecx,r9d
	
VectorSubD_SSE2_1:	
	movapd xmm0,XMMWORD ptr[r10]
	add r10,r11
	subpd xmm0,XMMWORD ptr[rdx]
	add rdx,r11
	movapd XMMWORD ptr[r8],xmm0
	add r8,r11
	loop VectorSubD_SSE2_1
	
	ret
	
VectorSubD_SSE2 endp


;VectorProdD_SSE2 proc coeff_a:dword,coeff_b:dword,coeff_c:dword,lgth:word
; coeff_a = rcx
; coeff_b = rdx
; coeff_c = r8
; lgth = r9d

VectorProdD_SSE2 proc public frame

	.endprolog

	mov r10,rcx
	mov r11,16
	xor rcx,rcx
	mov ecx,r9d
	
VectorProdD_SSE2_1:	
	movapd xmm0,XMMWORD ptr[r10]
	add r10,r11
	mulpd xmm0,XMMWORD ptr[rdx]
	add rdx,r11
	movapd XMMWORD ptr[r8],xmm0
	add r8,r11
	loop VectorProdD_SSE2_1
	
	ret
	
VectorProdD_SSE2 endp


;VectorAdd2D_SSE2 proc coeff_a:dword,coeff_b:dword,lgth:word
; coeff_a = rcx
; coeff_b = rdx
; lgth = r8d

VectorAdd2D_SSE2 proc public frame

	.endprolog

	mov r9,rcx
	mov r10,16
	xor rcx,rcx
	mov ecx,r8d
	
VectorAdd2D_SSE2_1:	
	movapd xmm0,XMMWORD ptr[r9]
	addpd xmm0,XMMWORD ptr[rdx]
	add rdx,r10
	movapd XMMWORD ptr[r9],xmm0
	add r9,r10
	loop VectorAdd2D_SSE2_1
	
	ret
	
VectorAdd2D_SSE2 endp


;VectorSub2D_SSE2 proc coeff_a:dword,coeff_b:dword,lgth:word
; coeff_a = rcx
; coeff_b = rdx
; lgth = r8d

VectorSub2D_SSE2 proc public frame

	.endprolog

	mov r9,rcx
	mov r10,16
	xor rcx,rcx
	mov ecx,r8d
	
VectorSub2D_SSE2_1:	
	movapd xmm0,XMMWORD ptr[r9]
	subpd xmm0,XMMWORD ptr[rdx]
	add rdx,r10
	movapd XMMWORD ptr[r9],xmm0
	add r9,r10
	loop VectorSub2D_SSE2_1
	
	ret
	
VectorSub2D_SSE2 endp


;VectorInvSubD_SSE2 proc coeff_a:dword,coeff_b:dword,lgth:word
; coeff_a = rcx
; coeff_b = rdx
; lgth = r8d

VectorInvSubD_SSE2 proc public frame

	.endprolog

	mov r9,rcx
	mov r10,16
	xor rcx,rcx
	mov ecx,r8d
	
VectorInvSubD_SSE2_1:	
	movapd xmm0,XMMWORD ptr[rdx]
	subpd xmm0,XMMWORD ptr[r9]
	add rdx,r10
	movapd XMMWORD ptr[r9],xmm0
	add r9,r10
	loop VectorInvSubD_SSE2_1
	
	ret
	
VectorInvSubD_SSE2 endp


;VectorProd2D_SSE2 proc coeff_a:dword,coeff_b:dword,lgth:word
; coeff_a = rcx
; coeff_b = rdx
; lgth = r8d

VectorProd2D_SSE2 proc public frame

	.endprolog

	mov r9,rcx
	mov r10,16
	xor rcx,rcx
	mov ecx,r8d
	
VectorProd2D_SSE2_1:	
	movapd xmm0,XMMWORD ptr[r9]
	mulpd xmm0,XMMWORD ptr[rdx]
	add rdx,r10
	movapd XMMWORD ptr[r9],xmm0
	add r9,r10
	loop VectorProd2D_SSE2_1
	
	ret
	
VectorProd2D_SSE2 endp


;VectorAddD_AVX proc coeff_a:dword,coeff_b:dword,coeff_c:dword,lgth:word
; coeff_a = rcx
; coeff_b = rdx
; coeff_c = r8
; lgth = r9d

VectorAddD_AVX proc public frame

	push rsi
	.pushreg rsi
	.endprolog

	mov rsi,rcx
	mov rax,128
	mov ecx,r9d
	mov r10,32
	mov r11,96

	shr ecx,2
	jz short VectorAddD_AVX_1

VectorAddD_AVX_loop_1:
	vmovapd ymm0,YMMWORD ptr[rsi]
	vmovapd ymm1,YMMWORD ptr[rsi+r10]
	vmovapd ymm2,YMMWORD ptr[rsi+2*r10]
	vmovapd ymm3,YMMWORD ptr[rsi+r11]

	vaddpd ymm0,ymm0,YMMWORD ptr[rdx]
	vaddpd ymm1,ymm1,YMMWORD ptr[rdx+r10]
	vaddpd ymm2,ymm2,YMMWORD ptr[rdx+2*r10]
	vaddpd ymm3,ymm3,YMMWORD ptr[rdx+r11]

	vmovapd YMMWORD ptr[r8],ymm0
	vmovapd YMMWORD ptr[r8+r10],ymm1
	vmovapd YMMWORD ptr[r8+2*r10],ymm2
	vmovapd YMMWORD ptr[r8+r11],ymm3

	add rsi,rax
	add rdx,rax
	add r8,rax
	loop VectorAddD_AVX_loop_1

VectorAddD_AVX_1:
	test r9d,2
	jz short VectorAddD_AVX_2

	vmovapd ymm0,YMMWORD ptr[rsi]
	vmovapd ymm1,YMMWORD ptr[rsi+r10]
	vaddpd ymm0,ymm0,YMMWORD ptr[rdx]
	vaddpd ymm1,ymm1,YMMWORD ptr[rdx+r10]
	vmovapd YMMWORD ptr[r8],ymm0
	vmovapd YMMWORD ptr[r8+r10],ymm1

	add rsi,64
	add rdx,64
	add r8,64

VectorAddD_AVX_2:
	test r9d,1
	jz short VectorAddD_AVX_3

	vmovapd ymm0,YMMWORD ptr[rsi]
	vaddpd ymm0,ymm0,YMMWORD ptr[rdx]
	vmovapd YMMWORD ptr[r8],ymm0

VectorAddD_AVX_3:
	vzeroupper

	pop rsi

	ret

VectorAddD_AVX endp


;VectorSubD_AVX proc coeff_a:dword,coeff_b:dword,coeff_c:dword,lgth:word
; coeff_a = rcx
; coeff_b = rdx
; coeff_c = r8
; lgth = r9d

VectorSubD_AVX proc public frame

	push rsi
	.pushreg rsi
	.endprolog

	mov rsi,rcx
	mov rax,128
	mov ecx,r9d
	mov r10,32
	mov r11,96

	shr ecx,2
	jz short VectorSubD_AVX_1

VectorSubD_AVX_loop_1:
	vmovapd ymm0,YMMWORD ptr[rsi]
	vmovapd ymm1,YMMWORD ptr[rsi+r10]
	vmovapd ymm2,YMMWORD ptr[rsi+2*r10]
	vmovapd ymm3,YMMWORD ptr[rsi+r11]

	vsubpd ymm0,ymm0,YMMWORD ptr[rdx]
	vsubpd ymm1,ymm1,YMMWORD ptr[rdx+r10]
	vsubpd ymm2,ymm2,YMMWORD ptr[rdx+2*r10]
	vsubpd ymm3,ymm3,YMMWORD ptr[rdx+r11]

	vmovapd YMMWORD ptr[r8],ymm0
	vmovapd YMMWORD ptr[r8+r10],ymm1
	vmovapd YMMWORD ptr[r8+2*r10],ymm2
	vmovapd YMMWORD ptr[r8+r11],ymm3

	add rsi,rax
	add rdx,rax
	add r8,rax
	loop VectorSubD_AVX_loop_1

VectorSubD_AVX_1:
	test r9d,2
	jz short VectorSubD_AVX_2

	vmovapd ymm0,YMMWORD ptr[rsi]
	vmovapd ymm1,YMMWORD ptr[rsi+r10]
	vsubpd ymm0,ymm0,YMMWORD ptr[rdx]
	vsubpd ymm1,ymm1,YMMWORD ptr[rdx+r10]
	vmovapd YMMWORD ptr[r8],ymm0
	vmovapd YMMWORD ptr[r8+r10],ymm1

	add rsi,64
	add rdx,64
	add r8,64

VectorSubD_AVX_2:
	test r9d,1
	jz short VectorSubD_AVX_3

	vmovapd ymm0,YMMWORD ptr[rsi]
	vsubpd ymm0,ymm0,YMMWORD ptr[rdx]
	vmovapd YMMWORD ptr[r8],ymm0

VectorSubD_AVX_3:
	vzeroupper

	pop rsi

	ret

VectorSubD_AVX endp


;VectorProdD_AVX proc coeff_a:dword,coeff_b:dword,coeff_c:dword,lgth:word
; coeff_a = rcx
; coeff_b = rdx
; coeff_c = r8
; lgth = r9d

VectorProdD_AVX proc public frame

	push rsi
	.pushreg rsi
	.endprolog

	mov rsi,rcx
	mov rax,128
	mov ecx,r9d
	mov r10,32
	mov r11,96

	shr ecx,2
	jz short VectorProdD_AVX_1

VectorProdD_AVX_loop_1:
	vmovapd ymm0,YMMWORD ptr[rsi]
	vmovapd ymm1,YMMWORD ptr[rsi+r10]
	vmovapd ymm2,YMMWORD ptr[rsi+2*r10]
	vmovapd ymm3,YMMWORD ptr[rsi+r11]

	vmulpd ymm0,ymm0,YMMWORD ptr[rdx]
	vmulpd ymm1,ymm1,YMMWORD ptr[rdx+r10]
	vmulpd ymm2,ymm2,YMMWORD ptr[rdx+2*r10]
	vmulpd ymm3,ymm3,YMMWORD ptr[rdx+r11]

	vmovapd YMMWORD ptr[r8],ymm0
	vmovapd YMMWORD ptr[r8+r10],ymm1
	vmovapd YMMWORD ptr[r8+2*r10],ymm2
	vmovapd YMMWORD ptr[r8+r11],ymm3

	add rsi,rax
	add rdx,rax
	add r8,rax
	loop VectorProdD_AVX_loop_1

VectorProdD_AVX_1:
	test r9d,2
	jz short VectorProdD_AVX_2

	vmovapd ymm0,YMMWORD ptr[rsi]
	vmovapd ymm1,YMMWORD ptr[rsi+r10]
	vmulpd ymm0,ymm0,YMMWORD ptr[rdx]
	vmulpd ymm1,ymm1,YMMWORD ptr[rdx+r10]
	vmovapd YMMWORD ptr[r8],ymm0
	vmovapd YMMWORD ptr[r8+r10],ymm1

	add rsi,64
	add rdx,64
	add r8,64

VectorProdD_AVX_2:
	test r9d,1
	jz short VectorProdD_AVX_3

	vmovapd ymm0,YMMWORD ptr[rsi]
	vmulpd ymm0,ymm0,YMMWORD ptr[rdx]
	vmovapd YMMWORD ptr[r8],ymm0

VectorProdD_AVX_3:
	vzeroupper

	pop rsi

	ret

VectorProdD_AVX endp


;VectorAdd2D_AVX proc coeff_a:dword,coeff_b:dword,lgth:word
; coeff_a = rcx
; coeff_b = rdx
; lgth = r8d

VectorAdd2D_AVX proc public frame

	push rsi
	.pushreg rsi
	.endprolog

	mov rsi,rcx
	mov rax,128
	mov ecx,r8d
	mov r9,32
	mov r10,64
	mov r11,96

	shr ecx,2
	jz short VectorAdd2D_AVX_1

VectorAdd2D_AVX_loop_1:
	vmovapd ymm0,YMMWORD ptr[rsi]
	vmovapd ymm1,YMMWORD ptr[rsi+r9]
	vmovapd ymm2,YMMWORD ptr[rsi+r10]
	vmovapd ymm3,YMMWORD ptr[rsi+r11]

	vaddpd ymm0,ymm0,YMMWORD ptr[rdx]
	vaddpd ymm1,ymm1,YMMWORD ptr[rdx+r9]
	vaddpd ymm2,ymm2,YMMWORD ptr[rdx+r10]
	vaddpd ymm3,ymm3,YMMWORD ptr[rdx+r11]

	vmovapd YMMWORD ptr[rsi],ymm0
	vmovapd YMMWORD ptr[rsi+r9],ymm1
	vmovapd YMMWORD ptr[rsi+r10],ymm2
	vmovapd YMMWORD ptr[rsi+r11],ymm3

	add rdx,rax
	add rsi,rax
	loop VectorAdd2D_AVX_loop_1

VectorAdd2D_AVX_1:
	test r8d,2
	jz short VectorAdd2D_AVX_2

	vmovapd ymm0,YMMWORD ptr[rsi]
	vmovapd ymm1,YMMWORD ptr[rsi+r9]
	vaddpd ymm0,ymm0,YMMWORD ptr[rdx]
	vaddpd ymm1,ymm1,YMMWORD ptr[rdx+r9]
	vmovapd YMMWORD ptr[rsi],ymm0
	vmovapd YMMWORD ptr[rsi+r9],ymm1

	add rdx,r10
	add rsi,r10

VectorAdd2D_AVX_2:
	test r8d,1
	jz short VectorAdd2D_AVX_3

	vmovapd ymm0,YMMWORD ptr[rsi]
	vaddpd ymm0,ymm0,YMMWORD ptr[rdx]
	vmovapd YMMWORD ptr[rsi],ymm0

VectorAdd2D_AVX_3:
	vzeroupper

	pop rsi

	ret

VectorAdd2D_AVX endp


;VectorSub2D_AVX proc coeff_a:dword,coeff_b:dword,lgth:word
; coeff_a = rcx
; coeff_b = rdx
; lgth = r8d

VectorSub2D_AVX proc public frame

	push rsi
	.pushreg rsi
	.endprolog

	mov rsi,rcx
	mov rax,128
	mov ecx,r8d
	mov r9,32
	mov r10,64
	mov r11,96

	shr ecx,2
	jz short VectorSub2D_AVX_1

VectorSub2D_AVX_loop_1:
	vmovapd ymm0,YMMWORD ptr[rsi]
	vmovapd ymm1,YMMWORD ptr[rsi+r9]
	vmovapd ymm2,YMMWORD ptr[rsi+r10]
	vmovapd ymm3,YMMWORD ptr[rsi+r11]

	vsubpd ymm0,ymm0,YMMWORD ptr[rdx]
	vsubpd ymm1,ymm1,YMMWORD ptr[rdx+r9]
	vsubpd ymm2,ymm2,YMMWORD ptr[rdx+r10]
	vsubpd ymm3,ymm3,YMMWORD ptr[rdx+r11]

	vmovapd YMMWORD ptr[rsi],ymm0
	vmovapd YMMWORD ptr[rsi+r9],ymm1
	vmovapd YMMWORD ptr[rsi+r10],ymm2
	vmovapd YMMWORD ptr[rsi+r11],ymm3

	add rdx,rax
	add rsi,rax
	loop VectorSub2D_AVX_loop_1

VectorSub2D_AVX_1:
	test r8d,2
	jz short VectorSub2D_AVX_2

	vmovapd ymm0,YMMWORD ptr[rsi]
	vmovapd ymm1,YMMWORD ptr[rsi+r9]
	vsubpd ymm0,ymm0,YMMWORD ptr[rdx]
	vsubpd ymm1,ymm1,YMMWORD ptr[rdx+r9]
	vmovapd YMMWORD ptr[rsi],ymm0
	vmovapd YMMWORD ptr[rsi+r9],ymm1

	add rdx,r10
	add rsi,r10

VectorSub2D_AVX_2:
	test r8d,1
	jz short VectorSub2D_AVX_3

	vmovapd ymm0,YMMWORD ptr[rsi]
	vsubpd ymm0,ymm0,YMMWORD ptr[rdx]
	vmovapd YMMWORD ptr[rsi],ymm0

VectorSub2D_AVX_3:
	vzeroupper

	pop rsi

	ret

VectorSub2D_AVX endp


;VectorInvSubD_AVX proc coeff_a:dword,coeff_b:dword,lgth:word
; coeff_a = rcx
; coeff_b = rdx
; lgth = r8d

VectorInvSubD_AVX proc public frame

	push rsi
	.pushreg rsi
	.endprolog

	mov rsi,rcx
	mov rax,128
	mov ecx,r8d
	mov r9,32
	mov r10,64
	mov r11,96

	shr ecx,2
	jz short VectorInvSubD_AVX_1

VectorInvSubD_AVX_loop_1:
	vmovapd ymm0,YMMWORD ptr[rdx]
	vmovapd ymm1,YMMWORD ptr[rdx+r9]
	vmovapd ymm2,YMMWORD ptr[rdx+r10]
	vmovapd ymm3,YMMWORD ptr[rdx+r11]

	vsubpd ymm0,ymm0,YMMWORD ptr[rsi]
	vsubpd ymm1,ymm1,YMMWORD ptr[rsi+r9]
	vsubpd ymm2,ymm2,YMMWORD ptr[rsi+r10]
	vsubpd ymm3,ymm3,YMMWORD ptr[rsi+r11]

	vmovapd YMMWORD ptr[rsi],ymm0
	vmovapd YMMWORD ptr[rsi+r9],ymm1
	vmovapd YMMWORD ptr[rsi+r10],ymm2
	vmovapd YMMWORD ptr[rsi+r11],ymm3

	add rdx,rax
	add rsi,rax
	loop VectorInvSubD_AVX_loop_1

VectorInvSubD_AVX_1:
	test r8d,2
	jz short VectorInvSubD_AVX_2

	vmovapd ymm0,YMMWORD ptr[rdx]
	vmovapd ymm1,YMMWORD ptr[rdx+r9]
	vsubpd ymm0,ymm0,YMMWORD ptr[rsi]
	vsubpd ymm1,ymm1,YMMWORD ptr[rsi+r9]
	vmovapd YMMWORD ptr[rsi],ymm0
	vmovapd YMMWORD ptr[rsi+r9],ymm1

	add rdx,r10
	add rsi,r10

VectorInvSubD_AVX_2:
	test r8d,1
	jz short VectorInvSubD_AVX_3

	vmovapd ymm0,YMMWORD ptr[rdx]
	vsubpd ymm0,ymm0,YMMWORD ptr[rsi]
	vmovapd YMMWORD ptr[rsi],ymm0

VectorInvSubD_AVX_3:
	vzeroupper

	pop rsi

	ret

VectorInvSubD_AVX endp


;VectorProd2D_AVX proc coeff_a:dword,coeff_b:dword,lgth:word
; coeff_a = rcx
; coeff_b = rdx
; lgth = r8d

VectorProd2D_AVX proc public frame

	push rsi
	.pushreg rsi
	.endprolog

	mov rsi,rcx
	mov rax,128
	mov ecx,r8d
	mov r9,32
	mov r10,64
	mov r11,96

	shr ecx,2
	jz short VectorProd2D_AVX_1
	
VectorProd2D_AVX_loop_1:
	vmovapd ymm0,YMMWORD ptr[rsi]
	vmovapd ymm1,YMMWORD ptr[rsi+r9]
	vmovapd ymm2,YMMWORD ptr[rsi+r10]
	vmovapd ymm3,YMMWORD ptr[rsi+r11]

	vmulpd ymm0,ymm0,YMMWORD ptr[rdx]
	vmulpd ymm1,ymm1,YMMWORD ptr[rdx+r9]
	vmulpd ymm2,ymm2,YMMWORD ptr[rdx+r10]
	vmulpd ymm3,ymm3,YMMWORD ptr[rdx+r11]

	vmovapd YMMWORD ptr[rsi],ymm0
	vmovapd YMMWORD ptr[rsi+r9],ymm1
	vmovapd YMMWORD ptr[rsi+r10],ymm2
	vmovapd YMMWORD ptr[rsi+r11],ymm3

	add rdx,rax
	add rsi,rax
	loop VectorProd2D_AVX_loop_1

VectorProd2D_AVX_1:
	test r8d,2
	jz short VectorProd2D_AVX_2

	vmovapd ymm0,YMMWORD ptr[rsi]
	vmovapd ymm1,YMMWORD ptr[rsi+r9]
	vmulpd ymm0,ymm0,YMMWORD ptr[rdx]
	vmulpd ymm1,ymm1,YMMWORD ptr[rdx+r9]
	vmovapd YMMWORD ptr[rsi],ymm0
	vmovapd YMMWORD ptr[rsi+r9],ymm1

	add rdx,r10
	add rsi,r10

VectorProd2D_AVX_2:
	test r8d,1
	jz short VectorProd2D_AVX_3

	vmovapd ymm0,YMMWORD ptr[rsi]
	vmulpd ymm0,ymm0,YMMWORD ptr[rdx]
	vmovapd YMMWORD ptr[rsi],ymm0

VectorProd2D_AVX_3:
	vzeroupper

	pop rsi

	ret
	
VectorProd2D_AVX endp

end