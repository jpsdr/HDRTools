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
; AVX512F/DQ

data segment align(64)

sign_bits_f_32 dword 16 dup(7FFFFFFFh)
sign_bits_f_64 qword 8 dup(7FFFFFFFFFFFFFFFh)

.code



;CoeffProductF_AVX512 proc coeff_a:dword,coeff_b:dword,coeff_c:dword,lgth:word
; coeff_a = rcx
; coeff_b = rdx
; coeff_c = r8
; lgth = r9d

CoeffProductF_AVX512 proc public frame

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
	
	vbroadcastss zmm0,dword ptr[rcx]

	mov rsi,rdx 	; coeff_b
	mov rdi,r8		; coeff_c
	mov edx,r9d		; lgth
	mov ecx,r9d		; lgth
	mov rax,512
	mov r8,64
	mov r9,128
	mov r10,192
	mov r11,256
	mov r12,320
	mov r13,384
	mov r14,448

	shr ecx,3
	jz short CoeffProductF_AVX512_1

CoeffProductF_AVX512_loop_1:
	vmulps zmm1,zmm0,ZMMWORD ptr[rsi]
	vmulps zmm2,zmm0,ZMMWORD ptr[rsi+r8]
	vmulps zmm3,zmm0,ZMMWORD ptr[rsi+r9]
	vmulps zmm4,zmm0,ZMMWORD ptr[rsi+r10]
	vmulps zmm5,zmm0,ZMMWORD ptr[rsi+r11]
	vmulps zmm6,zmm0,ZMMWORD ptr[rsi+r12]
	vmulps zmm7,zmm0,ZMMWORD ptr[rsi+r13]
	vmulps zmm8,zmm0,ZMMWORD ptr[rsi+r14]
	vmovaps ZMMWORD ptr[rdi],zmm1
	vmovaps ZMMWORD ptr[rdi+r8],zmm2
	vmovaps ZMMWORD ptr[rdi+r9],zmm3
	vmovaps ZMMWORD ptr[rdi+r10],zmm4
	vmovaps ZMMWORD ptr[rdi+r11],zmm5
	vmovaps ZMMWORD ptr[rdi+r12],zmm6
	vmovaps ZMMWORD ptr[rdi+r13],zmm7
	vmovaps ZMMWORD ptr[rdi+r14],zmm8
	add rsi,rax
	add rdi,rax
	loop CoeffProductF_AVX512_loop_1

CoeffProductF_AVX512_1:
	test edx,4
	jz short CoeffProductF_AVX512_2

	vmulps zmm1,zmm0,ZMMWORD ptr[rsi]
	vmulps zmm2,zmm0,ZMMWORD ptr[rsi+r8]
	vmulps zmm3,zmm0,ZMMWORD ptr[rsi+r9]
	vmulps zmm4,zmm0,ZMMWORD ptr[rsi+r10]
	vmovaps ZMMWORD ptr[rdi],zmm1
	vmovaps ZMMWORD ptr[rdi+r8],zmm2
	vmovaps ZMMWORD ptr[rdi+r9],zmm3
	vmovaps ZMMWORD ptr[rdi+r10],zmm4
	add rsi,r11
	add rdi,r11

CoeffProductF_AVX512_2:
	test edx,2
	jz short CoeffProductF_AVX512_3

	vmulps zmm1,zmm0,ZMMWORD ptr[rsi]
	vmulps zmm2,zmm0,ZMMWORD ptr[rsi+r8]
	vmovaps ZMMWORD ptr[rdi],zmm1
	vmovaps ZMMWORD ptr[rdi+r8],zmm2
	add rsi,r9
	add rdi,r9

CoeffProductF_AVX512_3:
	test edx,1
	jz short CoeffProductF_AVX512_4

	vmulps zmm1,zmm0,ZMMWORD ptr[rsi]
	vmovaps ZMMWORD ptr[rdi],zmm1

CoeffProductF_AVX512_4:
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

CoeffProductF_AVX512 endp


;CoeffProduct2F_AVX512 proc coeff_a:dword,coeff_b:dword,lgth:word
; coeff_a = rcx
; coeff_b = rdx
; lgth = r8d

CoeffProduct2F_AVX512 proc public frame

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

	vbroadcastss zmm0,dword ptr[rcx]

	mov rsi,rdx 	; coeff_b
	mov ecx,r8d		; lgth
	mov edx,r8d		; lgth
	mov rax,512
	mov r8,64
	mov r9,128
	mov r10,192
	mov r11,256
	mov r12,320
	mov r13,384
	mov r14,448

	shr ecx,3
	jz short CoeffProduct2F_AVX512_1

CoeffProduct2F_AVX512_loop_1:
	vmulps zmm1,zmm0,ZMMWORD ptr[rsi]
	vmulps zmm2,zmm0,ZMMWORD ptr[rsi+r8]
	vmulps zmm3,zmm0,ZMMWORD ptr[rsi+r9]
	vmulps zmm4,zmm0,ZMMWORD ptr[rsi+r10]
	vmulps zmm5,zmm0,ZMMWORD ptr[rsi+r11]
	vmulps zmm6,zmm0,ZMMWORD ptr[rsi+r12]
	vmulps zmm7,zmm0,ZMMWORD ptr[rsi+r13]
	vmulps zmm8,zmm0,ZMMWORD ptr[rsi+r14]
	vmovaps ZMMWORD ptr[rsi],zmm1
	vmovaps ZMMWORD ptr[rsi+r8],zmm2
	vmovaps ZMMWORD ptr[rsi+r9],zmm3
	vmovaps ZMMWORD ptr[rsi+r10],zmm4
	vmovaps ZMMWORD ptr[rsi+r11],zmm5
	vmovaps ZMMWORD ptr[rsi+r12],zmm6
	vmovaps ZMMWORD ptr[rsi+r13],zmm7
	vmovaps ZMMWORD ptr[rsi+r14],zmm8
	add rsi,rax
	loop CoeffProduct2F_AVX512_loop_1

CoeffProduct2F_AVX512_1:
	test edx,4
	jz short CoeffProduct2F_AVX512_2

	vmulps zmm1,zmm0,ZMMWORD ptr[rsi]
	vmulps zmm2,zmm0,ZMMWORD ptr[rsi+r8]
	vmulps zmm3,zmm0,ZMMWORD ptr[rsi+r9]
	vmulps zmm4,zmm0,ZMMWORD ptr[rsi+r10]
	vmovaps ZMMWORD ptr[rsi],zmm1
	vmovaps ZMMWORD ptr[rsi+r8],zmm2
	vmovaps ZMMWORD ptr[rsi+r9],zmm3
	vmovaps ZMMWORD ptr[rsi+r10],zmm4
	add rsi,r11

CoeffProduct2F_AVX512_2:
	test edx,2
	jz short CoeffProduct2F_AVX512_3

	vmulps zmm1,zmm0,ZMMWORD ptr[rsi]
	vmulps zmm2,zmm0,ZMMWORD ptr[rsi+r8]
	vmovaps ZMMWORD ptr[rsi],zmm1
	vmovaps ZMMWORD ptr[rsi+r8],zmm2
	add rsi,r9

CoeffProduct2F_AVX512_3:
	test edx,1
	jz short CoeffProduct2F_AVX512_4

	vmulps zmm1,zmm0,ZMMWORD ptr[rsi]
	vmovaps ZMMWORD ptr[rsi],zmm1

CoeffProduct2F_AVX512_4:
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
	
CoeffProduct2F_AVX512 endp	


;CoeffProductD_AVX512 proc coeff_a:dword,coeff_b:dword,coeff_c:dword,lgth:word
; coeff_a = rcx
; coeff_b = rdx
; coeff_c = r8
; lgth = r9d

CoeffProductD_AVX512 proc public frame

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
	
	vbroadcastsd zmm0,qword ptr[rcx]

	mov rsi,rdx 	; coeff_b
	mov rdi,r8		; coeff_c
	mov edx,r9d		; lgth
	mov ecx,r9d		; lgth
	mov rax,512
	mov r8,64
	mov r9,128
	mov r10,192
	mov r11,256
	mov r12,320
	mov r13,384
	mov r14,448

	shr ecx,3
	jz short CoeffProductD_AVX512_1
	
CoeffProductD_AVX512_loop_1:
	vmulpd zmm1,zmm0,ZMMWORD ptr[rsi]
	vmulpd zmm2,zmm0,ZMMWORD ptr[rsi+r8]
	vmulpd zmm3,zmm0,ZMMWORD ptr[rsi+r9]
	vmulpd zmm4,zmm0,ZMMWORD ptr[rsi+r10]
	vmulpd zmm5,zmm0,ZMMWORD ptr[rsi+r11]
	vmulpd zmm6,zmm0,ZMMWORD ptr[rsi+r12]
	vmulpd zmm7,zmm0,ZMMWORD ptr[rsi+r13]
	vmulpd zmm8,zmm0,ZMMWORD ptr[rsi+r14]
	vmovapd ZMMWORD ptr[rdi],zmm1
	vmovapd ZMMWORD ptr[rdi+r8],zmm2
	vmovapd ZMMWORD ptr[rdi+r9],zmm3
	vmovapd ZMMWORD ptr[rdi+r10],zmm4
	vmovapd ZMMWORD ptr[rdi+r11],zmm5
	vmovapd ZMMWORD ptr[rdi+r12],zmm6
	vmovapd ZMMWORD ptr[rdi+r13],zmm7
	vmovapd ZMMWORD ptr[rdi+r14],zmm8
	add rsi,rax
	add rdi,rax
	loop CoeffProductD_AVX512_loop_1

CoeffProductD_AVX512_1:
	test edx,4
	jz short CoeffProductD_AVX512_2

	vmulpd zmm1,zmm0,ZMMWORD ptr[rsi]
	vmulpd zmm2,zmm0,ZMMWORD ptr[rsi+r8]
	vmulpd zmm3,zmm0,ZMMWORD ptr[rsi+r9]
	vmulpd zmm4,zmm0,ZMMWORD ptr[rsi+r10]
	vmovapd ZMMWORD ptr[rdi],zmm1
	vmovapd ZMMWORD ptr[rdi+r8],zmm2
	vmovapd ZMMWORD ptr[rdi+r9],zmm3
	vmovapd ZMMWORD ptr[rdi+r10],zmm4
	add rsi,r11
	add rdi,r11

CoeffProductD_AVX512_2:
	test edx,2
	jz short CoeffProductD_AVX512_3

	vmulpd zmm1,zmm0,ZMMWORD ptr[rsi]
	vmulpd zmm2,zmm0,ZMMWORD ptr[rsi+r8]
	vmovapd ZMMWORD ptr[rdi],zmm1
	vmovapd ZMMWORD ptr[rdi+r8],zmm2
	add rsi,r9
	add rdi,r9

CoeffProductD_AVX512_3:
	test edx,1
	jz short CoeffProductD_AVX512_4

	vmulpd zmm1,zmm0,ZMMWORD ptr[rsi]
	vmovapd ZMMWORD ptr[rdi],zmm1

CoeffProductD_AVX512_4:
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

CoeffProductD_AVX512 endp	


;CoeffProduct2D_AVX512 proc coeff_a:dword,coeff_b:dword,lgth:word
; coeff_a = rcx
; coeff_b = rdx
; lgth = r8d

CoeffProduct2D_AVX512 proc public frame

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
	
	vbroadcastsd zmm0,qword ptr[rcx]

	mov rsi,rdx 	; coeff_b
	mov ecx,r8d		; lgth
	mov edx,r8d		; lgth
	mov rax,512
	mov r8,64
	mov r9,128
	mov r10,192
	mov r11,256
	mov r12,320
	mov r13,384
	mov r14,448

	shr ecx,3
	jz short CoeffProduct2D_AVX512_1

CoeffProduct2D_AVX512_loop_1:
	vmulpd zmm1,zmm0,ZMMWORD ptr[rsi]
	vmulpd zmm2,zmm0,ZMMWORD ptr[rsi+r8]
	vmulpd zmm3,zmm0,ZMMWORD ptr[rsi+r9]
	vmulpd zmm4,zmm0,ZMMWORD ptr[rsi+r10]
	vmulpd zmm5,zmm0,ZMMWORD ptr[rsi+r11]
	vmulpd zmm6,zmm0,ZMMWORD ptr[rsi+r12]
	vmulpd zmm7,zmm0,ZMMWORD ptr[rsi+r13]
	vmulpd zmm8,zmm0,ZMMWORD ptr[rsi+r14]
	vmovapd ZMMWORD ptr[rsi],zmm1
	vmovapd ZMMWORD ptr[rsi+r8],zmm2
	vmovapd ZMMWORD ptr[rsi+r9],zmm3
	vmovapd ZMMWORD ptr[rsi+r10],zmm4
	vmovapd ZMMWORD ptr[rsi+r11],zmm5
	vmovapd ZMMWORD ptr[rsi+r12],zmm6
	vmovapd ZMMWORD ptr[rsi+r13],zmm7
	vmovapd ZMMWORD ptr[rsi+r14],zmm8
	add rsi,rax
	loop CoeffProduct2D_AVX512_loop_1

CoeffProduct2D_AVX512_1:
	test edx,4
	jz short CoeffProduct2D_AVX512_2

	vmulpd zmm1,zmm0,ZMMWORD ptr[rsi]
	vmulpd zmm2,zmm0,ZMMWORD ptr[rsi+r8]
	vmulpd zmm3,zmm0,ZMMWORD ptr[rsi+r9]
	vmulpd zmm4,zmm0,ZMMWORD ptr[rsi+r10]
	vmovapd ZMMWORD ptr[rsi],zmm1
	vmovapd ZMMWORD ptr[rsi+r8],zmm2
	vmovapd ZMMWORD ptr[rsi+r9],zmm3
	vmovapd ZMMWORD ptr[rsi+r10],zmm4
	add rsi,r11

CoeffProduct2D_AVX512_2:
	test edx,2
	jz short CoeffProduct2D_AVX512_3

	vmulpd zmm1,zmm0,ZMMWORD ptr[rsi]
	vmulpd zmm2,zmm0,ZMMWORD ptr[rsi+r8]
	vmovapd ZMMWORD ptr[rsi],zmm1
	vmovapd ZMMWORD ptr[rsi+r8],zmm2
	add rsi,r9

CoeffProduct2D_AVX512_3:
	test edx,1
	jz short CoeffProduct2D_AVX512_4

	vmulpd zmm1,zmm0,ZMMWORD ptr[rsi]
	vmovapd ZMMWORD ptr[rsi],zmm1

CoeffProduct2D_AVX512_4:
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

CoeffProduct2D_AVX512 endp


;CoeffAddProductF_AVX512 proc coeff_a:dword,coeff_b:dword,coeff_c:dword,lgth:word
; coeff_a = rcx
; coeff_b = rdx
; coeff_c = r8
; lgth = r9d

CoeffAddProductF_AVX512 proc public frame

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

	vbroadcastss zmm0,dword ptr[rcx]

	mov rsi,rdx 	; coeff_b
	mov rdi,r8		; coeff_c
	mov edx,r9d		; lgth
	mov ecx,r9d		; lgth
	mov rax,256
	mov r8,64
	mov r9,128
	mov r10,192

	shr ecx,2
	jz short CoeffAddProductF_AVX512_1

CoeffAddProductF_AVX512_loop_1:
	vmulps zmm1,zmm0,ZMMWORD ptr[rsi]
	vmulps zmm3,zmm0,ZMMWORD ptr[rsi+r8]
	vmulps zmm5,zmm0,ZMMWORD ptr[rsi+r9]
	vmulps zmm7,zmm0,ZMMWORD ptr[rsi+r10]
	vaddps zmm2,zmm1,ZMMWORD ptr[rdi]
	vaddps zmm4,zmm3,ZMMWORD ptr[rdi+r8]
	vaddps zmm6,zmm5,ZMMWORD ptr[rdi+r9]
	vaddps zmm8,zmm7,ZMMWORD ptr[rdi+r10]
	vmovaps ZMMWORD ptr[rdi],zmm2
	vmovaps ZMMWORD ptr[rdi+r8],zmm4
	vmovaps ZMMWORD ptr[rdi+r9],zmm6
	vmovaps ZMMWORD ptr[rdi+r10],zmm8
	add rsi,rax
	add rdi,rax
	loop CoeffAddProductF_AVX512_loop_1

CoeffAddProductF_AVX512_1:
	test edx,2
	jz short CoeffAddProductF_AVX512_2

	vmulps zmm1,zmm0,ZMMWORD ptr[rsi]
	vmulps zmm3,zmm0,ZMMWORD ptr[rsi+r8]
	vaddps zmm2,zmm1,ZMMWORD ptr[rdi]
	vaddps zmm4,zmm3,ZMMWORD ptr[rdi+r8]
	vmovaps ZMMWORD ptr[rdi],zmm2
	vmovaps ZMMWORD ptr[rdi+r8],zmm4
	add rsi,r9
	add rdi,r9

CoeffAddProductF_AVX512_2:
	test edx,1
	jz short CoeffAddProductF_AVX512_3

	vmulps zmm1,zmm0,ZMMWORD ptr[rsi]
	vaddps zmm2,zmm1,ZMMWORD ptr[rdi]
	vmovaps ZMMWORD ptr[rdi],zmm2

CoeffAddProductF_AVX512_3:
	vmovdqa xmm8,XMMWORD ptr[rsp+32]
	vmovdqa xmm7,XMMWORD ptr[rsp+16]
	vmovdqa xmm6,XMMWORD ptr[rsp]
	add rsp,56

	vzeroupper

	pop rsi
	pop rdi

	ret

CoeffAddProductF_AVX512 endp


;CoeffAddProductD_AVX512 proc coeff_a:dword,coeff_b:dword,coeff_c:dword,lgth:word
; coeff_a = rcx
; coeff_b = rdx
; coeff_c = r8
; lgth = r9d

CoeffAddProductD_AVX512 proc public frame

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

	vbroadcastsd zmm0,qword ptr[rcx]

	mov rsi,rdx 	; coeff_b
	mov rdi,r8		; coeff_c
	mov edx,r9d		; lgth
	mov ecx,r9d		; lgth
	mov rax,256
	mov r8,64
	mov r9,128
	mov r10,192

	shr ecx,2
	jz short CoeffAddProductD_AVX512_1

CoeffAddProductD_AVX512_loop_1:
	vmulpd zmm1,zmm0,ZMMWORD ptr[rsi]
	vmulpd zmm3,zmm0,ZMMWORD ptr[rsi+r8]
	vmulpd zmm5,zmm0,ZMMWORD ptr[rsi+r9]
	vmulpd zmm7,zmm0,ZMMWORD ptr[rsi+r10]
	vaddpd zmm2,zmm1,ZMMWORD ptr[rdi]
	vaddpd zmm4,zmm3,ZMMWORD ptr[rdi+r8]
	vaddpd zmm6,zmm5,ZMMWORD ptr[rdi+r9]
	vaddpd zmm8,zmm7,ZMMWORD ptr[rdi+r10]
	vmovapd ZMMWORD ptr[rdi],zmm2
	vmovapd ZMMWORD ptr[rdi+r8],zmm4
	vmovapd ZMMWORD ptr[rdi+r9],zmm6
	vmovapd ZMMWORD ptr[rdi+r10],zmm8
	add rsi,rax
	add rdi,rax
	loop CoeffAddProductD_AVX512_loop_1

CoeffAddProductD_AVX512_1:
	test edx,2
	jz short CoeffAddProductD_AVX512_2

	vmulpd zmm1,zmm0,ZMMWORD ptr[rsi]
	vmulpd zmm3,zmm0,ZMMWORD ptr[rsi+r8]
	vaddpd zmm2,zmm1,ZMMWORD ptr[rdi]
	vaddpd zmm4,zmm3,ZMMWORD ptr[rdi+r8]
	vmovapd ZMMWORD ptr[rdi],zmm2
	vmovapd ZMMWORD ptr[rdi+r8],zmm4
	add rsi,r9
	add rdi,r9

CoeffAddProductD_AVX512_2:
	test edx,1
	jz short CoeffAddProductD_AVX512_3

	vmulpd zmm1,zmm0,ZMMWORD ptr[rsi]
	vaddpd zmm2,zmm1,ZMMWORD ptr[rdi]
	vmovapd ZMMWORD ptr[rdi],zmm2

CoeffAddProductD_AVX512_3:
	vmovdqa xmm8,XMMWORD ptr[rsp+32]
	vmovdqa xmm7,XMMWORD ptr[rsp+16]
	vmovdqa xmm6,XMMWORD ptr[rsp]
	add rsp,56

	vzeroupper

	pop rsi
	pop rdi

	ret

CoeffAddProductD_AVX512 endp


;CoeffAddF_AVX512 proc coeff_a:dword,coeff_b:dword,coeff_c:dword,lgth:word
; coeff_a = rcx
; coeff_b = rdx
; coeff_c = r8
; lgth = r9d

CoeffAddF_AVX512 proc public frame

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

	vbroadcastss zmm0,dword ptr[rcx]

	mov rsi,rdx 	; coeff_b
	mov rdi,r8		; coeff_c
	mov edx,r9d		; lgth
	mov ecx,r9d		; lgth
	mov rax,512
	mov r8,64
	mov r9,128
	mov r10,192
	mov r11,256
	mov r12,320
	mov r13,384
	mov r14,448

	shr ecx,3
	jz short CoeffAddF_AVX512_1

CoeffAddF_AVX512_loop_1:
	vaddps zmm1,zmm0,ZMMWORD ptr[rsi]
	vaddps zmm2,zmm0,ZMMWORD ptr[rsi+r8]
	vaddps zmm3,zmm0,ZMMWORD ptr[rsi+r9]
	vaddps zmm4,zmm0,ZMMWORD ptr[rsi+r10]
	vaddps zmm5,zmm0,ZMMWORD ptr[rsi+r11]
	vaddps zmm6,zmm0,ZMMWORD ptr[rsi+r12]
	vaddps zmm7,zmm0,ZMMWORD ptr[rsi+r13]
	vaddps zmm8,zmm0,ZMMWORD ptr[rsi+r14]
	vmovaps ZMMWORD ptr[rdi],zmm1
	vmovaps ZMMWORD ptr[rdi+r8],zmm2
	vmovaps ZMMWORD ptr[rdi+r9],zmm3
	vmovaps ZMMWORD ptr[rdi+r10],zmm4
	vmovaps ZMMWORD ptr[rdi+r11],zmm5
	vmovaps ZMMWORD ptr[rdi+r12],zmm6
	vmovaps ZMMWORD ptr[rdi+r13],zmm7
	vmovaps ZMMWORD ptr[rdi+r14],zmm8
	add rsi,rax
	add rdi,rax
	loop CoeffAddF_AVX512_loop_1

CoeffAddF_AVX512_1:
	test edx,4
	jz short CoeffAddF_AVX512_2

	vaddps zmm1,zmm0,ZMMWORD ptr[rsi]
	vaddps zmm2,zmm0,ZMMWORD ptr[rsi+r8]
	vaddps zmm3,zmm0,ZMMWORD ptr[rsi+r9]
	vaddps zmm4,zmm0,ZMMWORD ptr[rsi+r10]
	vmovaps ZMMWORD ptr[rdi],zmm1
	vmovaps ZMMWORD ptr[rdi+r8],zmm2
	vmovaps ZMMWORD ptr[rdi+r9],zmm3
	vmovaps ZMMWORD ptr[rdi+r10],zmm4
	add rsi,r11
	add rdi,r11

CoeffAddF_AVX512_2:
	test edx,2
	jz short CoeffAddF_AVX512_3

	vaddps zmm1,zmm0,ZMMWORD ptr[rsi]
	vaddps zmm2,zmm0,ZMMWORD ptr[rsi+r8]
	vmovaps ZMMWORD ptr[rdi],zmm1
	vmovaps ZMMWORD ptr[rdi+r8],zmm2
	add rsi,r9
	add rdi,r9

CoeffAddF_AVX512_3:
	test edx,1
	jz short CoeffAddF_AVX512_4

	vaddps zmm1,zmm0,ZMMWORD ptr[rsi]
	vmovaps ZMMWORD ptr[rdi],zmm1

CoeffAddF_AVX512_4:
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

CoeffAddF_AVX512 endp	


;CoeffAdd2F_AVX512 proc coeff_a:dword,coeff_b:dword,lgth:word
; coeff_a = rcx
; coeff_b = rdx
; lgth = r8d

CoeffAdd2F_AVX512 proc public frame

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

	vbroadcastss zmm0,dword ptr[rcx]

	mov rsi,rdx 	; coeff_b
	mov ecx,r8d		; lgth
	mov edx,r8d		; lgth
	mov rax,512
	mov r8,64
	mov r9,128
	mov r10,192
	mov r11,256
	mov r12,320
	mov r13,384
	mov r14,448

	shr ecx,3
	jz short CoeffAdd2F_AVX512_1

CoeffAdd2F_AVX512_loop_1:
	vaddps zmm1,zmm0,ZMMWORD ptr[rsi]
	vaddps zmm2,zmm0,ZMMWORD ptr[rsi+r8]
	vaddps zmm3,zmm0,ZMMWORD ptr[rsi+r9]
	vaddps zmm4,zmm0,ZMMWORD ptr[rsi+r10]
	vaddps zmm5,zmm0,ZMMWORD ptr[rsi+r11]
	vaddps zmm6,zmm0,ZMMWORD ptr[rsi+r12]
	vaddps zmm7,zmm0,ZMMWORD ptr[rsi+r13]
	vaddps zmm8,zmm0,ZMMWORD ptr[rsi+r14]
	vmovaps ZMMWORD ptr[rsi],zmm1
	vmovaps ZMMWORD ptr[rsi+r8],zmm2
	vmovaps ZMMWORD ptr[rsi+r9],zmm3
	vmovaps ZMMWORD ptr[rsi+r10],zmm4
	vmovaps ZMMWORD ptr[rsi+r11],zmm5
	vmovaps ZMMWORD ptr[rsi+r12],zmm6
	vmovaps ZMMWORD ptr[rsi+r13],zmm7
	vmovaps ZMMWORD ptr[rsi+r14],zmm8
	add rsi,rax
	loop CoeffAdd2F_AVX512_loop_1

CoeffAdd2F_AVX512_1:
	test edx,4
	jz short CoeffAdd2F_AVX512_2

	vaddps zmm1,zmm0,ZMMWORD ptr[rsi]
	vaddps zmm2,zmm0,ZMMWORD ptr[rsi+r8]
	vaddps zmm3,zmm0,ZMMWORD ptr[rsi+r9]
	vaddps zmm4,zmm0,ZMMWORD ptr[rsi+r10]
	vmovaps ZMMWORD ptr[rsi],zmm1
	vmovaps ZMMWORD ptr[rsi+r8],zmm2
	vmovaps ZMMWORD ptr[rsi+r9],zmm3
	vmovaps ZMMWORD ptr[rsi+r10],zmm4
	add rsi,r11

CoeffAdd2F_AVX512_2:
	test edx,2
	jz short CoeffAdd2F_AVX512_3

	vaddps zmm1,zmm0,ZMMWORD ptr[rsi]
	vaddps zmm2,zmm0,ZMMWORD ptr[rsi+r8]
	vmovaps ZMMWORD ptr[rsi],zmm1
	vmovaps ZMMWORD ptr[rsi+r8],zmm2
	add rsi,r9

CoeffAdd2F_AVX512_3:
	test edx,1
	jz short CoeffAdd2F_AVX512_4

	vaddps zmm1,zmm0,ZMMWORD ptr[rsi]
	vmovaps ZMMWORD ptr[rsi],zmm1

CoeffAdd2F_AVX512_4:
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

CoeffAdd2F_AVX512 endp


;CoeffAddD_AVX512 proc coeff_a:dword,coeff_b:dword,coeff_c:dword,lgth:word
; coeff_a = rcx
; coeff_b = rdx
; coeff_c = r8
; lgth = r9d

CoeffAddD_AVX512 proc public frame

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

	vbroadcastsd zmm0,qword ptr[rcx]

	mov rsi,rdx 	; coeff_b
	mov rdi,r8		; coeff_c
	mov edx,r9d		; lgth
	mov ecx,r9d		; lgth
	mov rax,512
	mov r8,64
	mov r9,128
	mov r10,192
	mov r11,256
	mov r12,320
	mov r13,384
	mov r14,448

	shr ecx,3
	jz short CoeffAddD_AVX512_1

CoeffAddD_AVX512_loop_1:
	vaddpd zmm1,zmm0,ZMMWORD ptr[rsi]
	vaddpd zmm2,zmm0,ZMMWORD ptr[rsi+r8]
	vaddpd zmm3,zmm0,ZMMWORD ptr[rsi+r9]
	vaddpd zmm4,zmm0,ZMMWORD ptr[rsi+r10]
	vaddpd zmm5,zmm0,ZMMWORD ptr[rsi+r11]
	vaddpd zmm6,zmm0,ZMMWORD ptr[rsi+r12]
	vaddpd zmm7,zmm0,ZMMWORD ptr[rsi+r13]
	vaddpd zmm8,zmm0,ZMMWORD ptr[rsi+r14]
	vmovapd ZMMWORD ptr[rdi],zmm1
	vmovapd ZMMWORD ptr[rdi+r8],zmm2
	vmovapd ZMMWORD ptr[rdi+r9],zmm3
	vmovapd ZMMWORD ptr[rdi+r10],zmm4
	vmovapd ZMMWORD ptr[rdi+r11],zmm5
	vmovapd ZMMWORD ptr[rdi+r12],zmm6
	vmovapd ZMMWORD ptr[rdi+r13],zmm7
	vmovapd ZMMWORD ptr[rdi+r14],zmm8
	add rsi,rax
	add rdi,rax
	loop CoeffAddD_AVX512_loop_1

CoeffAddD_AVX512_1:
	test edx,4
	jz short CoeffAddD_AVX512_2

	vaddpd zmm1,zmm0,ZMMWORD ptr[rsi]
	vaddpd zmm2,zmm0,ZMMWORD ptr[rsi+r8]
	vaddpd zmm3,zmm0,ZMMWORD ptr[rsi+r9]
	vaddpd zmm4,zmm0,ZMMWORD ptr[rsi+r10]
	vmovapd ZMMWORD ptr[rdi],zmm1
	vmovapd ZMMWORD ptr[rdi+r8],zmm2
	vmovapd ZMMWORD ptr[rdi+r9],zmm3
	vmovapd ZMMWORD ptr[rdi+r10],zmm4
	add rsi,r11
	add rdi,r11

CoeffAddD_AVX512_2:
	test edx,2
	jz short CoeffAddD_AVX512_3

	vaddpd zmm1,zmm0,ZMMWORD ptr[rsi]
	vaddpd zmm2,zmm0,ZMMWORD ptr[rsi+r8]
	vmovapd ZMMWORD ptr[rdi],zmm1
	vmovapd ZMMWORD ptr[rdi+r8],zmm2
	add rsi,r9
	add rdi,r9

CoeffAddD_AVX512_3:
	test edx,1
	jz short CoeffAddD_AVX512_4

	vaddpd zmm1,zmm0,ZMMWORD ptr[rsi]
	vmovapd ZMMWORD ptr[rdi],zmm1

CoeffAddD_AVX512_4:
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

CoeffAddD_AVX512 endp	
	

;CoeffAdd2D_AVX512 proc coeff_a:dword,coeff_b:dword,lgth:word
; coeff_a = rcx
; coeff_b = rdx
; lgth = r8d

CoeffAdd2D_AVX512 proc public frame

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

	vbroadcastsd zmm0,qword ptr[rcx]

	mov rsi,rdx 	; coeff_b
	mov ecx,r8d		; lgth
	mov edx,r8d		; lgth
	mov rax,512
	mov r8,64
	mov r9,128
	mov r10,192
	mov r11,256
	mov r12,320
	mov r13,384
	mov r14,448

	shr ecx,3
	jz short CoeffAdd2D_AVX512_1

CoeffAdd2D_AVX512_loop_1:
	vaddpd zmm1,zmm0,ZMMWORD ptr[rsi]
	vaddpd zmm2,zmm0,ZMMWORD ptr[rsi+r8]
	vaddpd zmm3,zmm0,ZMMWORD ptr[rsi+r9]
	vaddpd zmm4,zmm0,ZMMWORD ptr[rsi+r10]
	vaddpd zmm5,zmm0,ZMMWORD ptr[rsi+r11]
	vaddpd zmm6,zmm0,ZMMWORD ptr[rsi+r12]
	vaddpd zmm7,zmm0,ZMMWORD ptr[rsi+r13]
	vaddpd zmm8,zmm0,ZMMWORD ptr[rsi+r14]
	vmovapd ZMMWORD ptr[rsi],zmm1
	vmovapd ZMMWORD ptr[rsi+r8],zmm2
	vmovapd ZMMWORD ptr[rsi+r9],zmm3
	vmovapd ZMMWORD ptr[rsi+r10],zmm4
	vmovapd ZMMWORD ptr[rsi+r11],zmm5
	vmovapd ZMMWORD ptr[rsi+r12],zmm6
	vmovapd ZMMWORD ptr[rsi+r13],zmm7
	vmovapd ZMMWORD ptr[rsi+r14],zmm8
	add rsi,rax
	loop CoeffAdd2D_AVX512_loop_1

CoeffAdd2D_AVX512_1:
	test edx,4
	jz short CoeffAdd2D_AVX512_2

	vaddpd zmm1,zmm0,ZMMWORD ptr[rsi]
	vaddpd zmm2,zmm0,ZMMWORD ptr[rsi+r8]
	vaddpd zmm3,zmm0,ZMMWORD ptr[rsi+r9]
	vaddpd zmm4,zmm0,ZMMWORD ptr[rsi+r10]
	vmovapd ZMMWORD ptr[rsi],zmm1
	vmovapd ZMMWORD ptr[rsi+r8],zmm2
	vmovapd ZMMWORD ptr[rsi+r9],zmm3
	vmovapd ZMMWORD ptr[rsi+r10],zmm4
	add rsi,r11

CoeffAdd2D_AVX512_2:
	test edx,2
	jz short CoeffAdd2D_AVX512_3

	vaddpd zmm1,zmm0,ZMMWORD ptr[rsi]
	vaddpd zmm2,zmm0,ZMMWORD ptr[rsi+r8]
	vmovapd ZMMWORD ptr[rsi],zmm1
	vmovapd ZMMWORD ptr[rsi+r8],zmm2
	add rsi,r9

CoeffAdd2D_AVX512_3:
	test edx,1
	jz short CoeffAdd2D_AVX512_4

	vaddpd zmm1,zmm0,ZMMWORD ptr[rsi]
	vmovapd ZMMWORD ptr[rsi],zmm1

CoeffAdd2D_AVX512_4:
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

CoeffAdd2D_AVX512 endp


;CoeffSubF_AVX512 proc coeff_a:dword,coeff_b:dword,coeff_c:dword,lgth:word
; coeff_a = rcx
; coeff_b = rdx
; coeff_c = r8
; lgth = r9d

CoeffSubF_AVX512 proc public frame

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

	vbroadcastss zmm0,dword ptr[rcx]

	mov rsi,rdx 	; coeff_b
	mov rdi,r8		; coeff_c
	mov edx,r9d		; lgth
	mov ecx,r9d		; lgth
	mov rax,512
	mov r8,64
	mov r9,128
	mov r10,192
	mov r11,256
	mov r12,320
	mov r13,384
	mov r14,448

	shr ecx,3
	jz short CoeffSubF_AVX512_1
	
CoeffSubF_AVX512_loop_1:
	vsubps zmm1,zmm0,ZMMWORD ptr[rsi]
	vsubps zmm2,zmm0,ZMMWORD ptr[rsi+r8]
	vsubps zmm3,zmm0,ZMMWORD ptr[rsi+r9]
	vsubps zmm4,zmm0,ZMMWORD ptr[rsi+r10]
	vsubps zmm5,zmm0,ZMMWORD ptr[rsi+r11]
	vsubps zmm6,zmm0,ZMMWORD ptr[rsi+r12]
	vsubps zmm7,zmm0,ZMMWORD ptr[rsi+r13]
	vsubps zmm8,zmm0,ZMMWORD ptr[rsi+r14]
	vmovaps ZMMWORD ptr[rdi],zmm1
	vmovaps ZMMWORD ptr[rdi+r8],zmm2
	vmovaps ZMMWORD ptr[rdi+r9],zmm3
	vmovaps ZMMWORD ptr[rdi+r10],zmm4
	vmovaps ZMMWORD ptr[rdi+r11],zmm5
	vmovaps ZMMWORD ptr[rdi+r12],zmm6
	vmovaps ZMMWORD ptr[rdi+r13],zmm7
	vmovaps ZMMWORD ptr[rdi+r14],zmm8
	add rsi,rax
	add rdi,rax
	loop CoeffSubF_AVX512_loop_1

CoeffSubF_AVX512_1:
	test edx,4
	jz short CoeffSubF_AVX512_2

	vsubps zmm1,zmm0,ZMMWORD ptr[rsi]
	vsubps zmm2,zmm0,ZMMWORD ptr[rsi+r8]
	vsubps zmm3,zmm0,ZMMWORD ptr[rsi+r9]
	vsubps zmm4,zmm0,ZMMWORD ptr[rsi+r10]
	vmovaps ZMMWORD ptr[rdi],zmm1
	vmovaps ZMMWORD ptr[rdi+r8],zmm2
	vmovaps ZMMWORD ptr[rdi+r9],zmm3
	vmovaps ZMMWORD ptr[rdi+r10],zmm4
	add rsi,r11
	add rdi,r11

CoeffSubF_AVX512_2:
	test edx,2
	jz short CoeffSubF_AVX512_3

	vsubps zmm1,zmm0,ZMMWORD ptr[rsi]
	vsubps zmm2,zmm0,ZMMWORD ptr[rsi+r8]
	vmovaps ZMMWORD ptr[rdi],zmm1
	vmovaps ZMMWORD ptr[rdi+r8],zmm2
	add rsi,r9
	add rdi,r9

CoeffSubF_AVX512_3:
	test edx,1
	jz short CoeffSubF_AVX512_4

	vsubps zmm1,zmm0,ZMMWORD ptr[rsi]
	vmovaps ZMMWORD ptr[rdi],zmm1

CoeffSubF_AVX512_4:
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

CoeffSubF_AVX512 endp	


;CoeffSub2F_AVX512 proc coeff_a:dword,coeff_b:dword,lgth:word
; coeff_a = rcx
; coeff_b = rdx
; lgth = r8d

CoeffSub2F_AVX512 proc public frame

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

	vbroadcastss zmm0,dword ptr[rcx]

	mov rsi,rdx 	; coeff_b
	mov ecx,r8d		; lgth
	mov edx,r8d		; lgth
	mov rax,512
	mov r8,64
	mov r9,128
	mov r10,192
	mov r11,256
	mov r12,320
	mov r13,384
	mov r14,448

	shr ecx,3
	jz short CoeffSub2F_AVX512_1

CoeffSub2F_AVX512_loop_1:
	vsubps zmm1,zmm0,ZMMWORD ptr[rsi]
	vsubps zmm2,zmm0,ZMMWORD ptr[rsi+r8]
	vsubps zmm3,zmm0,ZMMWORD ptr[rsi+r9]
	vsubps zmm4,zmm0,ZMMWORD ptr[rsi+r10]
	vsubps zmm5,zmm0,ZMMWORD ptr[rsi+r11]
	vsubps zmm6,zmm0,ZMMWORD ptr[rsi+r12]
	vsubps zmm7,zmm0,ZMMWORD ptr[rsi+r13]
	vsubps zmm8,zmm0,ZMMWORD ptr[rsi+r14]
	vmovaps ZMMWORD ptr[rsi],zmm1
	vmovaps ZMMWORD ptr[rsi+r8],zmm2
	vmovaps ZMMWORD ptr[rsi+r9],zmm3
	vmovaps ZMMWORD ptr[rsi+r10],zmm4
	vmovaps ZMMWORD ptr[rsi+r11],zmm5
	vmovaps ZMMWORD ptr[rsi+r12],zmm6
	vmovaps ZMMWORD ptr[rsi+r13],zmm7
	vmovaps ZMMWORD ptr[rsi+r14],zmm8
	add rsi,rax
	loop CoeffSub2F_AVX512_loop_1

CoeffSub2F_AVX512_1:
	test edx,4
	jz short CoeffSub2F_AVX512_2

	vsubps zmm1,zmm0,ZMMWORD ptr[rsi]
	vsubps zmm2,zmm0,ZMMWORD ptr[rsi+r8]
	vsubps zmm3,zmm0,ZMMWORD ptr[rsi+r9]
	vsubps zmm4,zmm0,ZMMWORD ptr[rsi+r10]
	vmovaps ZMMWORD ptr[rsi],zmm1
	vmovaps ZMMWORD ptr[rsi+r8],zmm2
	vmovaps ZMMWORD ptr[rsi+r9],zmm3
	vmovaps ZMMWORD ptr[rsi+r10],zmm4
	add rsi,r11

CoeffSub2F_AVX512_2:
	test edx,2
	jz short CoeffSub2F_AVX512_3

	vsubps zmm1,zmm0,ZMMWORD ptr[rsi]
	vsubps zmm2,zmm0,ZMMWORD ptr[rsi+r8]
	vmovaps ZMMWORD ptr[rsi],zmm1
	vmovaps ZMMWORD ptr[rsi+r8],zmm2
	add rsi,r9

CoeffSub2F_AVX512_3:
	test edx,1
	jz short CoeffSub2F_AVX512_4

	vsubps zmm1,zmm0,ZMMWORD ptr[rsi]
	vmovaps ZMMWORD ptr[rsi],zmm1

CoeffSub2F_AVX512_4:
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

CoeffSub2F_AVX512 endp	


;CoeffSubD_AVX512 proc coeff_a:dword,coeff_b:dword,coeff_c:dword,lgth:word
; coeff_a = rcx
; coeff_b = rdx
; coeff_c = r8
; lgth = r9d

CoeffSubD_AVX512 proc public frame

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

	vbroadcastsd zmm0,qword ptr[rcx]

	mov rsi,rdx 	; coeff_b
	mov rdi,r8		; coeff_c
	mov edx,r9d		; lgth
	mov ecx,r9d		; lgth
	mov rax,512
	mov r8,64
	mov r9,128
	mov r10,192
	mov r11,256
	mov r12,320
	mov r13,384
	mov r14,448

	shr ecx,3
	jz short CoeffSubD_AVX512_1

CoeffSubD_AVX512_loop_1:
	vsubpd zmm1,zmm0,ZMMWORD ptr[rsi]
	vsubpd zmm2,zmm0,ZMMWORD ptr[rsi+r8]
	vsubpd zmm3,zmm0,ZMMWORD ptr[rsi+r9]
	vsubpd zmm4,zmm0,ZMMWORD ptr[rsi+r10]
	vsubpd zmm5,zmm0,ZMMWORD ptr[rsi+r11]
	vsubpd zmm6,zmm0,ZMMWORD ptr[rsi+r12]
	vsubpd zmm7,zmm0,ZMMWORD ptr[rsi+r13]
	vsubpd zmm8,zmm0,ZMMWORD ptr[rsi+r14]
	vmovapd ZMMWORD ptr[rdi],zmm1
	vmovapd ZMMWORD ptr[rdi+r8],zmm2
	vmovapd ZMMWORD ptr[rdi+r9],zmm3
	vmovapd ZMMWORD ptr[rdi+r10],zmm4
	vmovapd ZMMWORD ptr[rdi+r11],zmm5
	vmovapd ZMMWORD ptr[rdi+r12],zmm6
	vmovapd ZMMWORD ptr[rdi+r13],zmm7
	vmovapd ZMMWORD ptr[rdi+r14],zmm8
	add rsi,rax
	add rdi,rax
	loop CoeffSubD_AVX512_loop_1

CoeffSubD_AVX512_1:
	test edx,4
	jz short CoeffSubD_AVX512_2

	vsubpd zmm1,zmm0,ZMMWORD ptr[rsi]
	vsubpd zmm2,zmm0,ZMMWORD ptr[rsi+r8]
	vsubpd zmm3,zmm0,ZMMWORD ptr[rsi+r9]
	vsubpd zmm4,zmm0,ZMMWORD ptr[rsi+r10]
	vmovapd ZMMWORD ptr[rdi],zmm1
	vmovapd ZMMWORD ptr[rdi+r8],zmm2
	vmovapd ZMMWORD ptr[rdi+r9],zmm3
	vmovapd ZMMWORD ptr[rdi+r10],zmm4
	add rsi,r11
	add rdi,r11

CoeffSubD_AVX512_2:
	test edx,2
	jz short CoeffSubD_AVX512_3

	vsubpd zmm1,zmm0,ZMMWORD ptr[rsi]
	vsubpd zmm2,zmm0,ZMMWORD ptr[rsi+r8]
	vmovapd ZMMWORD ptr[rdi],zmm1
	vmovapd ZMMWORD ptr[rdi+r8],zmm2
	add rsi,r9
	add rdi,r9

CoeffSubD_AVX512_3:
	test edx,1
	jz short CoeffSubD_AVX512_4

	vsubpd zmm1,zmm0,ZMMWORD ptr[rsi]
	vmovapd ZMMWORD ptr[rdi],zmm1

CoeffSubD_AVX512_4:
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

CoeffSubD_AVX512 endp	


;CoeffSub2D_AVX512 proc coeff_a:dword,coeff_b:dword,lgth:word
; coeff_a = rcx
; coeff_b = rdx
; lgth = r8d

CoeffSub2D_AVX512 proc public frame

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

	vbroadcastsd zmm0,qword ptr[rcx]

	mov rsi,rdx 	; coeff_b
	mov ecx,r8d		; lgth
	mov edx,r8d		; lgth
	mov rax,512
	mov r8,64
	mov r9,128
	mov r10,192
	mov r11,256
	mov r12,320
	mov r13,384
	mov r14,448

	shr ecx,3
	jz short CoeffSub2D_AVX512_1

CoeffSub2D_AVX512_loop_1:
	vsubpd zmm1,zmm0,ZMMWORD ptr[rsi]
	vsubpd zmm2,zmm0,ZMMWORD ptr[rsi+r8]
	vsubpd zmm3,zmm0,ZMMWORD ptr[rsi+r9]
	vsubpd zmm4,zmm0,ZMMWORD ptr[rsi+r10]
	vsubpd zmm5,zmm0,ZMMWORD ptr[rsi+r11]
	vsubpd zmm6,zmm0,ZMMWORD ptr[rsi+r12]
	vsubpd zmm7,zmm0,ZMMWORD ptr[rsi+r13]
	vsubpd zmm8,zmm0,ZMMWORD ptr[rsi+r14]
	vmovapd ZMMWORD ptr[rsi],zmm1
	vmovapd ZMMWORD ptr[rsi+r8],zmm2
	vmovapd ZMMWORD ptr[rsi+r9],zmm3
	vmovapd ZMMWORD ptr[rsi+r10],zmm4
	vmovapd ZMMWORD ptr[rsi+r11],zmm5
	vmovapd ZMMWORD ptr[rsi+r12],zmm6
	vmovapd ZMMWORD ptr[rsi+r13],zmm7
	vmovapd ZMMWORD ptr[rsi+r14],zmm8
	add rsi,rax
	loop CoeffSub2D_AVX512_loop_1

CoeffSub2D_AVX512_1:
	test edx,4
	jz short CoeffSub2D_AVX512_2

	vsubpd zmm1,zmm0,ZMMWORD ptr[rsi]
	vsubpd zmm2,zmm0,ZMMWORD ptr[rsi+r8]
	vsubpd zmm3,zmm0,ZMMWORD ptr[rsi+r9]
	vsubpd zmm4,zmm0,ZMMWORD ptr[rsi+r10]
	vmovapd ZMMWORD ptr[rsi],zmm1
	vmovapd ZMMWORD ptr[rsi+r8],zmm2
	vmovapd ZMMWORD ptr[rsi+r9],zmm3
	vmovapd ZMMWORD ptr[rsi+r10],zmm4
	add rsi,r11

CoeffSub2D_AVX512_2:
	test edx,2
	jz short CoeffSub2D_AVX512_3

	vsubpd zmm1,zmm0,ZMMWORD ptr[rsi]
	vsubpd zmm2,zmm0,ZMMWORD ptr[rsi+r8]
	vmovapd ZMMWORD ptr[rsi],zmm1
	vmovapd ZMMWORD ptr[rsi+r8],zmm2
	add rsi,r9

CoeffSub2D_AVX512_3:
	test edx,1
	jz short CoeffSub2D_AVX512_4

	vsubpd zmm1,zmm0,ZMMWORD ptr[rsi]
	vmovapd ZMMWORD ptr[rsi],zmm1

CoeffSub2D_AVX512_4:
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

CoeffSub2D_AVX512 endp


;VectorNorme2F_AVX512 proc coeff_x:dword,result:dword,lgth:word
; coeff_x = rcx
; result = rdx
; lgth = r8d

VectorNorme2F_AVX512 proc public frame

	.endprolog

	mov r9,rcx 		; coeff_x
	mov rax,256
	mov ecx,r8d		; lgth
	mov r10,64
	mov r11,192

	vxorps zmm0,zmm0,zmm0

	shr ecx,2
	jz short VectorNorme2F_AVX512_1

VectorNorme2F_AVX512_loop_1:
	vmovaps zmm1,ZMMWORD ptr[r9]
	vmovaps zmm2,ZMMWORD ptr[r9+r10]
	vmovaps zmm3,ZMMWORD ptr[r9+2*r10]
	vmovaps zmm4,ZMMWORD ptr[r9+r11]

	vmulps zmm1,zmm1,zmm1
	vmulps zmm2,zmm2,zmm2
	vmulps zmm3,zmm3,zmm3
	vmulps zmm4,zmm4,zmm4

	vaddps zmm1,zmm1,zmm2
	vaddps zmm3,zmm3,zmm4
	vaddps zmm1,zmm1,zmm3
	add r9,rax
	vaddps zmm0,zmm0,zmm1
	loop VectorNorme2F_AVX512_loop_1

VectorNorme2F_AVX512_1:
	test r8d,2
	jz short VectorNorme2F_AVX512_2

	vmovaps zmm1,ZMMWORD ptr[r9]
	vmovaps zmm2,ZMMWORD ptr[r9+r10]
	vmulps zmm1,zmm1,zmm1
	vmulps zmm2,zmm2,zmm2
	vaddps zmm1,zmm1,zmm2
	add r9,128
	vaddps zmm0,zmm0,zmm1

VectorNorme2F_AVX512_2:
	test r8d,1
	jz short VectorNorme2F_AVX512_3

	vmovaps zmm1,ZMMWORD ptr[r9]
	vmulps zmm1,zmm1,zmm1
	vaddps zmm0,zmm0,zmm1

VectorNorme2F_AVX512_3:
	vextractf32x8 ymm2,zmm0,1

	vextractf128 xmm1,ymm0,1
	vextractf128 xmm3,ymm2,1

	vaddps xmm0,xmm0,xmm1
	vaddps xmm2,xmm2,xmm3

	vmovhlps xmm1,xmm1,xmm0
	vmovhlps xmm3,xmm3,xmm2

	vaddps xmm0,xmm0,xmm1
	vaddps xmm2,xmm2,xmm3

	vpsrldq xmm1,xmm0,4
	vpsrldq xmm3,xmm2,4

	vaddss xmm0,xmm0,xmm1
	vaddss xmm2,xmm2,xmm3

	vaddps xmm0,xmm0,xmm2
	vsqrtss xmm0,xmm0,xmm0
	vmovss dword ptr[rdx],xmm0

	vzeroupper

	ret
		
VectorNorme2F_AVX512 endp


;VectorNorme2D_AVX512 proc coeff_x:dword,result:dword,lgth:word
; coeff_x = rcx
; result = rdx
; lgth = r8d

VectorNorme2D_AVX512 proc public frame

	.endprolog

	mov r9,rcx 		; coeff_x
	mov rax,256
	mov ecx,r8d		; lgth
	mov r10,64
	mov r11,192

	vxorps zmm0,zmm0,zmm0

	shr ecx,2
	jz short VectorNorme2D_AVX512_1

VectorNorme2D_AVX512_loop_1:
	vmovapd zmm1,ZMMWORD ptr[r9]
	vmovapd zmm2,ZMMWORD ptr[r9+r10]
	vmovapd zmm3,ZMMWORD ptr[r9+2*r10]
	vmovapd zmm4,ZMMWORD ptr[r9+r11]

	vmulpd zmm1,zmm1,zmm1
	vmulpd zmm2,zmm2,zmm2
	vmulpd zmm3,zmm3,zmm3
	vmulpd zmm4,zmm4,zmm4

	vaddpd zmm1,zmm1,zmm2
	vaddpd zmm3,zmm3,zmm4
	vaddpd zmm1,zmm1,zmm3
	add r9,rax
	vaddpd zmm0,zmm0,zmm1
	loop VectorNorme2D_AVX512_loop_1

VectorNorme2D_AVX512_1:
	test r8d,2
	jz short VectorNorme2D_AVX512_2

	vmovapd zmm1,ZMMWORD ptr[r9]
	vmovapd zmm2,ZMMWORD ptr[r9+r10]
	vmulpd zmm1,zmm1,zmm1
	vmulpd zmm2,zmm2,zmm2
	vaddpd zmm1,zmm1,zmm2
	add r9,128
	vaddpd zmm0,zmm0,zmm1

VectorNorme2D_AVX512_2:
	test r8d,1
	jz short VectorNorme2D_AVX512_3

	vmovapd zmm1,ZMMWORD ptr[r9]
	vmulpd zmm1,zmm1,zmm1
	vaddpd zmm0,zmm0,zmm1

VectorNorme2D_AVX512_3:
	vextractf64x4 ymm2,zmm0,1

	vextractf128 xmm1,ymm0,1
	vextractf128 xmm3,ymm2,1

	vaddpd xmm0,xmm0,xmm1
	vaddpd xmm2,xmm2,xmm3

	vmovhlps xmm1,xmm1,xmm0
	vmovhlps xmm3,xmm3,xmm2

	vaddsd xmm0,xmm0,xmm1
	vaddsd xmm2,xmm2,xmm3

	vaddpd xmm0,xmm0,xmm2
	vsqrtsd xmm0,xmm0,xmm0
	vmovsd qword ptr[rdx],xmm0

	vzeroupper

	ret

VectorNorme2D_AVX512 endp	


;VectorDist2F_AVX512 proc coeff_x:dword,coeff_y:dword,result:dword,lgth:word
; coeff_x = rcx
; coeff_y = rdx
; result = r8
; lgth = r9d

VectorDist2F_AVX512 proc public frame

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
	mov rax,512
	mov r8,64
	mov r9,128
	mov r10,192
	mov r11,256
	mov r12,320
	mov r13,384
	mov r14,448

	vxorps zmm0,zmm0,zmm0

	shr ecx,3
	jz VectorDist2F_AVX512_1

VectorDist2F_AVX512_loop_1:
	vmovaps zmm1,ZMMWORD ptr[rsi]
	vmovaps zmm2,ZMMWORD ptr[rsi+r8]
	vmovaps zmm3,ZMMWORD ptr[rsi+r9]
	vmovaps zmm4,ZMMWORD ptr[rsi+r10]
	vmovaps zmm5,ZMMWORD ptr[rsi+r11]
	vmovaps zmm6,ZMMWORD ptr[rsi+r12]
	vmovaps zmm7,ZMMWORD ptr[rsi+r13]
	vmovaps zmm8,ZMMWORD ptr[rsi+r14]

	vsubps zmm1,zmm1,ZMMWORD ptr[rdi]
	vsubps zmm2,zmm2,ZMMWORD ptr[rdi+r8]
	vsubps zmm3,zmm3,ZMMWORD ptr[rdi+r9]
	vsubps zmm4,zmm4,ZMMWORD ptr[rdi+r10]
	vsubps zmm5,zmm5,ZMMWORD ptr[rdi+r11]
	vsubps zmm6,zmm6,ZMMWORD ptr[rdi+r12]
	vsubps zmm7,zmm7,ZMMWORD ptr[rdi+r13]
	vsubps zmm8,zmm8,ZMMWORD ptr[rdi+r14]

	vmulps zmm1,zmm1,zmm1
	vmulps zmm2,zmm2,zmm2
	vmulps zmm3,zmm3,zmm3
	vmulps zmm4,zmm4,zmm4
	vmulps zmm5,zmm5,zmm5
	vmulps zmm6,zmm6,zmm6
	vmulps zmm7,zmm7,zmm7
	vmulps zmm8,zmm8,zmm8

	vaddps zmm1,zmm1,zmm2
	vaddps zmm3,zmm3,zmm4
	vaddps zmm5,zmm5,zmm6
	vaddps zmm7,zmm7,zmm8
	vaddps zmm1,zmm1,zmm3
	vaddps zmm5,zmm5,zmm7
	add rsi,rax
	vaddps zmm1,zmm1,zmm5
	add rdi,rax
	vaddps zmm0,zmm0,zmm1

	dec ecx
	jnz VectorDist2F_AVX512_loop_1

VectorDist2F_AVX512_1:
	test edx,4
	jz short VectorDist2F_AVX512_2

	vmovaps zmm1,ZMMWORD ptr[rsi]
	vmovaps zmm2,ZMMWORD ptr[rsi+r8]
	vmovaps zmm3,ZMMWORD ptr[rsi+r9]
	vmovaps zmm4,ZMMWORD ptr[rsi+r10]

	vsubps zmm1,zmm1,ZMMWORD ptr[rdi]
	vsubps zmm2,zmm2,ZMMWORD ptr[rdi+r8]
	vsubps zmm3,zmm3,ZMMWORD ptr[rdi+r9]
	vsubps zmm4,zmm4,ZMMWORD ptr[rdi+r10]

	vmulps zmm1,zmm1,zmm1
	vmulps zmm2,zmm2,zmm2
	vmulps zmm3,zmm3,zmm3
	vmulps zmm4,zmm4,zmm4

	vaddps zmm1,zmm1,zmm2
	vaddps zmm3,zmm3,zmm4
	add rsi,r11
	vaddps zmm1,zmm1,zmm3
	add rdi,r11
	vaddps zmm0,zmm0,zmm1

VectorDist2F_AVX512_2:
	test edx,2
	jz short VectorDist2F_AVX512_3

	vmovaps zmm1,ZMMWORD ptr[rsi]
	vmovaps zmm2,ZMMWORD ptr[rsi+r8]
	vsubps zmm1,zmm1,ZMMWORD ptr[rdi]
	vsubps zmm2,zmm2,ZMMWORD ptr[rdi+r8]
	vmulps zmm1,zmm1,zmm1
	vmulps zmm2,zmm2,zmm2

	add rsi,r9
	vaddps zmm1,zmm1,zmm2
	add rdi,r9
	vaddps zmm0,zmm0,zmm1

VectorDist2F_AVX512_3:
	test edx,1
	jz short VectorDist2F_AVX512_4

	vmovaps zmm1,ZMMWORD ptr[rsi]
	vsubps zmm1,zmm1,ZMMWORD ptr[rdi]
	vmulps zmm1,zmm1,zmm1
	vaddps zmm0,zmm0,zmm1

VectorDist2F_AVX512_4:
	vextractf32x8 ymm2,zmm0,1

	vextractf128 xmm1,ymm0,1
	vextractf128 xmm3,ymm2,1

	vaddps xmm0,xmm0,xmm1
	vaddps xmm2,xmm2,xmm3

	vmovhlps xmm1,xmm1,xmm0
	vmovhlps xmm3,xmm3,xmm2

	vaddps xmm0,xmm0,xmm1
	vaddps xmm2,xmm2,xmm3

	vpsrldq xmm1,xmm0,4
	vpsrldq xmm3,xmm2,4

	vaddss xmm0,xmm0,xmm1
	vaddss xmm2,xmm2,xmm3

	vaddps xmm0,xmm0,xmm2
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

VectorDist2F_AVX512 endp


;VectorDist2D_AVX512 proc coeff_a:dword,coeff_x:dword,result:dword,lgth:word
; coeff_a = rcx
; coeff_x = rdx
; result = r8
; lgth = r9d

VectorDist2D_AVX512 proc public frame

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
	mov rax,512
	mov r8,64
	mov r9,128
	mov r10,192
	mov r11,256
	mov r12,320
	mov r13,384
	mov r14,448

	vxorpd zmm0,zmm0,zmm0

	shr ecx,3
	jz VectorDist2D_AVX512_1

VectorDist2D_AVX512_loop_1:
	vmovapd zmm1,ZMMWORD ptr[rsi]
	vmovapd zmm2,ZMMWORD ptr[rsi+r8]
	vmovapd zmm3,ZMMWORD ptr[rsi+r9]
	vmovapd zmm4,ZMMWORD ptr[rsi+r10]
	vmovapd zmm5,ZMMWORD ptr[rsi+r11]
	vmovapd zmm6,ZMMWORD ptr[rsi+r12]
	vmovapd zmm7,ZMMWORD ptr[rsi+r13]
	vmovapd zmm8,ZMMWORD ptr[rsi+r14]

	vsubpd zmm1,zmm1,ZMMWORD ptr[rdi]
	vsubpd zmm2,zmm2,ZMMWORD ptr[rdi+r8]
	vsubpd zmm3,zmm3,ZMMWORD ptr[rdi+r9]
	vsubpd zmm4,zmm4,ZMMWORD ptr[rdi+r10]
	vsubpd zmm5,zmm5,ZMMWORD ptr[rdi+r11]
	vsubpd zmm6,zmm6,ZMMWORD ptr[rdi+r12]
	vsubpd zmm7,zmm7,ZMMWORD ptr[rdi+r13]
	vsubpd zmm8,zmm8,ZMMWORD ptr[rdi+r14]

	vmulpd zmm1,zmm1,zmm1
	vmulpd zmm2,zmm2,zmm2
	vmulpd zmm3,zmm3,zmm3
	vmulpd zmm4,zmm4,zmm4
	vmulpd zmm5,zmm5,zmm5
	vmulpd zmm6,zmm6,zmm6
	vmulpd zmm7,zmm7,zmm7
	vmulpd zmm8,zmm8,zmm8

	vaddpd zmm1,zmm1,zmm2
	vaddpd zmm3,zmm3,zmm4
	vaddpd zmm5,zmm5,zmm6
	vaddpd zmm7,zmm7,zmm8
	vaddpd zmm1,zmm1,zmm3
	vaddpd zmm5,zmm5,zmm7
	add rsi,rax
	vaddpd zmm1,zmm1,zmm5
	add rdi,rax
	vaddpd zmm0,zmm0,zmm1
	
	dec ecx
	jnz VectorDist2D_AVX512_loop_1

VectorDist2D_AVX512_1:
	test edx,4
	jz short VectorDist2D_AVX512_2

	vmovapd zmm1,ZMMWORD ptr[rsi]
	vmovapd zmm2,ZMMWORD ptr[rsi+r8]
	vmovapd zmm3,ZMMWORD ptr[rsi+r9]
	vmovapd zmm4,ZMMWORD ptr[rsi+r10]

	vsubpd zmm1,zmm1,ZMMWORD ptr[rdi]
	vsubpd zmm2,zmm2,ZMMWORD ptr[rdi+r8]
	vsubpd zmm3,zmm3,ZMMWORD ptr[rdi+r9]
	vsubpd zmm4,zmm4,ZMMWORD ptr[rdi+r10]

	vmulpd zmm1,zmm1,zmm1
	vmulpd zmm2,zmm2,zmm2
	vmulpd zmm3,zmm3,zmm3
	vmulpd zmm4,zmm4,zmm4

	vaddpd zmm1,zmm1,zmm2
	vaddpd zmm3,zmm3,zmm4
	add rsi,rax
	vaddpd zmm1,zmm1,zmm3
	add rdi,rax
	vaddpd zmm0,zmm0,zmm1

VectorDist2D_AVX512_2:
	test edx,2
	jz short VectorDist2D_AVX512_3

	vmovapd zmm1,ZMMWORD ptr[rsi]
	vmovapd zmm2,ZMMWORD ptr[rsi+r8]

	vsubpd zmm1,zmm1,ZMMWORD ptr[rdi]
	vsubpd zmm2,zmm2,ZMMWORD ptr[rdi+r8]

	vmulpd zmm1,zmm1,zmm1
	vmulpd zmm2,zmm2,zmm2

	add rsi,rax
	vaddpd zmm1,zmm1,zmm2
	add rdi,rax
	vaddpd zmm0,zmm0,zmm1

VectorDist2D_AVX512_3:
	test edx,1
	jz short VectorDist2D_AVX512_4

	vmovapd zmm1,ZMMWORD ptr[rsi]
	vsubpd zmm1,zmm1,ZMMWORD ptr[rdi]
	vmulpd zmm1,zmm1,zmm1
	vaddpd zmm0,zmm0,zmm1

VectorDist2D_AVX512_4:
	vextractf64x4 ymm2,zmm0,1

	vextractf128 xmm1,ymm0,1
	vextractf128 xmm3,ymm2,1

	vaddpd xmm0,xmm0,xmm1
	vaddpd xmm2,xmm2,xmm3

	vmovhlps xmm1,xmm1,xmm0
	vmovhlps xmm3,xmm3,xmm2

	vaddsd xmm0,xmm0,xmm1
	vaddsd xmm2,xmm2,xmm3

	vaddpd xmm0,xmm0,xmm2
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

VectorDist2D_AVX512 endp	


;VectorNormeF_AVX512 proc coeff_x:dword,result:dword,lgth:word
; coeff_x = rcx
; result = rdx
; lgth = r8d

VectorNormeF_AVX512 proc public frame

	.endprolog

	mov r9,rcx
	mov rax,256
	mov ecx,r8d
	mov r10,64
	mov r11,192
	
	vxorps zmm0,zmm0,zmm0

	shr ecx,2
	jz short VectorNormeF_AVX512_1

VectorNormeF_AVX512_loop_1:
	vmovaps zmm1,ZMMWORD ptr[r9]
	vmovaps zmm2,ZMMWORD ptr[r9+r10]
	vmovaps zmm3,ZMMWORD ptr[r9+2*r10]
	vmovaps zmm4,ZMMWORD ptr[r9+r11]

	vmulps zmm1,zmm1,zmm1
	vmulps zmm2,zmm2,zmm2
	vmulps zmm3,zmm3,zmm3
	vmulps zmm4,zmm4,zmm4

	vaddps zmm1,zmm1,zmm2
	vaddps zmm3,zmm3,zmm4
	vaddps zmm1,zmm1,zmm3
	add r9,rax
	vaddps zmm0,zmm0,zmm1

	loop VectorNormeF_AVX512_loop_1

VectorNormeF_AVX512_1:
	test r8d,2
	jz short VectorNormeF_AVX512_2

	vmovaps zmm1,ZMMWORD ptr[r9]
	vmovaps zmm2,ZMMWORD ptr[r9+r10]
	vmulps zmm1,zmm1,zmm1
	vmulps zmm2,zmm2,zmm2
	vaddps zmm1,zmm1,zmm2
	add r9,128
	vaddps zmm0,zmm0,zmm1

VectorNormeF_AVX512_2:
	test r8d,1
	jz short VectorNormeF_AVX512_3

	vmovaps zmm1,ZMMWORD ptr[r9]
	vmulps zmm1,zmm1,zmm1
	vaddps zmm0,zmm0,zmm1

VectorNormeF_AVX512_3:
	vextractf32x8 ymm2,zmm0,1

	vextractf128 xmm1,ymm0,1
	vextractf128 xmm3,ymm2,1

	vaddps xmm0,xmm0,xmm1
	vaddps xmm2,xmm2,xmm3

	vmovhlps xmm1,xmm1,xmm0
	vmovhlps xmm3,xmm3,xmm2

	vaddps xmm0,xmm0,xmm1
	vaddps xmm2,xmm2,xmm3

	vpsrldq xmm1,xmm0,4
	vpsrldq xmm3,xmm2,4

	vaddss xmm0,xmm0,xmm1
	vaddss xmm2,xmm2,xmm3

	vaddps xmm0,xmm0,xmm2
	vmovss dword ptr[rdx],xmm0

	vzeroupper

	ret

VectorNormeF_AVX512 endp


;VectorNormeD_AVX512 proc coeff_x:dword,result:dword,lgth:word
; coeff_x = rcx
; result = rdx
; lgth = r8d

VectorNormeD_AVX512 proc public frame

	.endprolog

	mov r9,rcx
	mov rax,256
	mov ecx,r8d
	mov r10,64
	mov r11,192
	
	vxorpd zmm0,zmm0,zmm0

	shr ecx,2
	jz short VectorNormeD_AVX512_1

VectorNormeD_AVX512_loop_1:
	vmovapd zmm1,ZMMWORD ptr[r9]
	vmovapd zmm2,ZMMWORD ptr[r9+r10]
	vmovapd zmm3,ZMMWORD ptr[r9+2*r10]
	vmovapd zmm4,ZMMWORD ptr[r9+r11]

	vmulpd zmm1,zmm1,zmm1
	vmulpd zmm2,zmm2,zmm2
	vmulpd zmm3,zmm3,zmm3
	vmulpd zmm4,zmm4,zmm4

	vaddpd zmm1,zmm1,zmm2
	vaddpd zmm3,zmm3,zmm4
	vaddpd zmm1,zmm1,zmm3
	add r9,rax
	vaddpd zmm0,zmm0,zmm1

	loop VectorNormeD_AVX512_loop_1

VectorNormeD_AVX512_1:
	test r8d,2
	jz short VectorNormeD_AVX512_2

	vmovapd zmm1,ZMMWORD ptr[r9]
	vmovapd zmm2,ZMMWORD ptr[r9+r10]
	vmulpd zmm1,zmm1,zmm1
	vmulpd zmm2,zmm2,zmm2
	vaddpd zmm1,zmm1,zmm2
	add r9,128
	vaddpd zmm0,zmm0,zmm1

VectorNormeD_AVX512_2:
	test r8d,1
	jz short VectorNormeD_AVX512_3

	vmovapd zmm1,ZMMWORD ptr[r9]
	vmulpd zmm1,zmm1,zmm1
	vaddpd zmm0,zmm0,zmm1

VectorNormeD_AVX512_3:
	vextractf64x4 ymm2,zmm0,1

	vextractf128 xmm1,ymm0,1
	vextractf128 xmm3,ymm2,1

	vaddpd xmm0,xmm0,xmm1
	vaddpd xmm2,xmm2,xmm3

	vmovhlps xmm1,xmm1,xmm0
	vmovhlps xmm3,xmm3,xmm2

	vaddsd xmm0,xmm0,xmm1
	vaddsd xmm2,xmm2,xmm3

	vaddpd xmm0,xmm0,xmm2
	vmovsd qword ptr[rdx],xmm0

	vzeroupper

	ret

VectorNormeD_AVX512 endp	


;VectorDistF_AVX512 proc coeff_x:dword,coeff_y:dword,result:dword,lgth:word
; coeff_x = rcx
; coeff_y = rdx
; result = r8
; lgth = r9d

VectorDistF_AVX512 proc public frame

	push rsi
	.pushreg rsi
	.endprolog

	mov rsi,rcx
	mov rax,256
	mov ecx,r9d
	mov r10,64
	mov r11,192

	vxorps zmm0,zmm0,zmm0

	shr ecx,2
	jz short VectorDistF_AVX512_1

VectorDistF_AVX512_loop_1:
	vmovaps zmm1,ZMMWORD ptr[rsi]
	vmovaps zmm2,ZMMWORD ptr[rsi+r10]
	vmovaps zmm3,ZMMWORD ptr[rsi+2*r10]
	vmovaps zmm4,ZMMWORD ptr[rsi+r11]

	vsubps zmm1,zmm1,ZMMWORD ptr[rdx]
	vsubps zmm2,zmm2,ZMMWORD ptr[rdx+r10]
	vsubps zmm3,zmm3,ZMMWORD ptr[rdx+2*r10]
	vsubps zmm4,zmm4,ZMMWORD ptr[rdx+r11]

	vmulps zmm1,zmm1,zmm1
	vmulps zmm2,zmm2,zmm2
	vmulps zmm3,zmm3,zmm3
	vmulps zmm4,zmm4,zmm4

	vaddps zmm1,zmm1,zmm2
	vaddps zmm3,zmm3,zmm4
	add rsi,rax
	vaddps zmm1,zmm1,zmm3
	add rdx,rax
	vaddps zmm0,zmm0,zmm1

	loop VectorDistF_AVX512_loop_1

VectorDistF_AVX512_1:
	test r9d,2
	jz short VectorDistF_AVX512_2

	vmovaps zmm1,ZMMWORD ptr[rsi]
	vmovaps zmm2,ZMMWORD ptr[rsi+r10]
	vsubps zmm1,zmm1,ZMMWORD ptr[rdx]
	vsubps zmm2,zmm2,ZMMWORD ptr[rdx+r10]
	vmulps zmm1,zmm1,zmm1
	vmulps zmm2,zmm2,zmm2

	add rsi,128
	vaddps zmm1,zmm1,zmm2
	add rdx,128
	vaddps zmm0,zmm0,zmm1

VectorDistF_AVX512_2:
	test r9d,1
	jz short VectorDistF_AVX512_3

	vmovaps zmm1,ZMMWORD ptr[rsi]
	vsubps zmm1,zmm1,ZMMWORD ptr[rdx]
	vmulps zmm1,zmm1,zmm1
	vaddps zmm0,zmm0,zmm1

VectorDistF_AVX512_3:
	vextractf32x8 ymm2,zmm0,1

	vextractf128 xmm1,ymm0,1
	vextractf128 xmm3,ymm2,1

	vaddps xmm0,xmm0,xmm1
	vaddps xmm2,xmm2,xmm3

	vmovhlps xmm1,xmm1,xmm0
	vmovhlps xmm3,xmm3,xmm2

	vaddps xmm0,xmm0,xmm1
	vaddps xmm2,xmm2,xmm3

	vpsrldq xmm1,xmm0,4
	vpsrldq xmm3,xmm2,4

	vaddss xmm0,xmm0,xmm1
	vaddss xmm2,xmm2,xmm3

	vaddps xmm0,xmm0,xmm2
	vmovss dword ptr[r8],xmm0

	vzeroupper

	pop rsi

	ret

VectorDistF_AVX512 endp


;VectorDistD_AVX512 proc coeff_a:dword,coeff_x:dword,result:dword,lgth:word
; coeff_a = rcx
; coeff_x = rdx
; result = r8
; lgth = r9d

VectorDistD_AVX512 proc public frame

	push rsi
	.pushreg rsi
	.endprolog

	mov rsi,rcx
	mov rax,256
	mov ecx,r9d
	mov r10,64
	mov r11,192

	vxorpd zmm0,zmm0,zmm0

	shr ecx,2
	jz short VectorDistD_AVX512_1

VectorDistD_AVX512_loop_1:
	vmovapd zmm1,ZMMWORD ptr[rsi]
	vmovapd zmm2,ZMMWORD ptr[rsi+r10]
	vmovapd zmm3,ZMMWORD ptr[rsi+2*r10]
	vmovapd zmm4,ZMMWORD ptr[rsi+r11]

	vsubpd zmm1,zmm1,ZMMWORD ptr[rdx]
	vsubpd zmm2,zmm2,ZMMWORD ptr[rdx+r10]
	vsubpd zmm3,zmm3,ZMMWORD ptr[rdx+2*r10]
	vsubpd zmm4,zmm4,ZMMWORD ptr[rdx+r11]

	vmulpd zmm1,zmm1,zmm1
	vmulpd zmm2,zmm2,zmm2
	vmulpd zmm3,zmm3,zmm3
	vmulpd zmm4,zmm4,zmm4

	vaddpd zmm1,zmm1,zmm2
	vaddpd zmm3,zmm3,zmm4
	add rsi,rax
	vaddpd zmm1,zmm1,zmm3
	add rdx,rax
	vaddpd zmm0,zmm0,zmm1

	loop VectorDistD_AVX512_loop_1

VectorDistD_AVX512_1:
	test r9d,2
	jz short VectorDistD_AVX512_2

	vmovapd zmm1,ZMMWORD ptr[rsi]
	vmovapd zmm2,ZMMWORD ptr[rsi+r10]
	vsubpd zmm1,zmm1,ZMMWORD ptr[rdx]
	vsubpd zmm2,zmm2,ZMMWORD ptr[rdx+r10]
	vmulpd zmm1,zmm1,zmm1
	vmulpd zmm2,zmm2,zmm2

	add rsi,128
	vaddpd zmm1,zmm1,zmm2
	add rdx,128
	vaddpd zmm0,zmm0,zmm1

VectorDistD_AVX512_2:
	test r9d,1
	jz short VectorDistD_AVX512_3

	vmovapd zmm1,ZMMWORD ptr[rsi]
	vsubpd zmm1,zmm1,ZMMWORD ptr[rdx]
	vmulpd zmm1,zmm1,zmm1
	vaddpd zmm0,zmm0,zmm1

VectorDistD_AVX512_3:
	vextractf64x4 ymm2,zmm0,1

	vextractf128 xmm1,ymm0,1
	vextractf128 xmm3,ymm2,1

	vaddpd xmm0,xmm0,xmm1
	vaddpd xmm2,xmm2,xmm3

	vmovhlps xmm1,xmm1,xmm0
	vmovhlps xmm3,xmm3,xmm2

	vaddsd xmm0,xmm0,xmm1
	vaddsd xmm2,xmm2,xmm3

	vaddpd xmm0,xmm0,xmm2
	vmovsd qword ptr[r8],xmm0

	vzeroupper

	pop rsi

	ret

VectorDistD_AVX512 endp	


;VectorNorme1F_AVX512 proc coeff_x:dword,result:dword,lgth:word
; coeff_x = rcx
; result = rdx
; lgth = r8d

VectorNorme1F_AVX512 proc public frame

	.endprolog

	mov r9,rcx
	mov rax,256
	mov r10,64
	mov r11,192
	mov ecx,r8d

	vxorps zmm0,zmm0,zmm0
	vmovaps zmm5,ZMMWORD ptr sign_bits_f_32

	shr ecx,2
	jz short VectorNorme1F_AVX512_1

VectorNorme1F_AVX512_loop_1:
	vandps zmm1,zmm5,ZMMWORD ptr[r9]
	vandps zmm2,zmm5,ZMMWORD ptr[r9+r10]
	vandps zmm3,zmm5,ZMMWORD ptr[r9+2*r10]
	vandps zmm4,zmm5,ZMMWORD ptr[r9+r11]

	vaddps zmm1,zmm1,zmm2
	vaddps zmm3,zmm3,zmm4
	vaddps zmm1,zmm1,zmm3
	add r9,rax
	vaddps zmm0,zmm0,zmm1

	loop VectorNorme1F_AVX512_loop_1

VectorNorme1F_AVX512_1:
	test r8d,2
	jz short VectorNorme1F_AVX512_2

	vandps zmm1,zmm5,ZMMWORD ptr[r9]
	vandps zmm2,zmm5,ZMMWORD ptr[r9+r10]

	vaddps zmm1,zmm1,zmm2
	add r9,128
	vaddps zmm0,zmm0,zmm1

VectorNorme1F_AVX512_2:
	test r8d,1
	jz short VectorNorme1F_AVX512_3

	vandps zmm1,zmm5,ZMMWORD ptr[r9]
	vaddps zmm0,zmm0,zmm1

VectorNorme1F_AVX512_3:
	vextractf32x8 ymm2,zmm0,1

	vextractf128 xmm1,ymm0,1
	vextractf128 xmm3,ymm2,1

	vaddps xmm0,xmm0,xmm1
	vaddps xmm2,xmm2,xmm3

	vmovhlps xmm1,xmm1,xmm0
	vmovhlps xmm3,xmm3,xmm2

	vaddps xmm0,xmm0,xmm1
	vaddps xmm2,xmm2,xmm3

	vpsrldq xmm1,xmm0,4
	vpsrldq xmm3,xmm2,4

	vaddss xmm0,xmm0,xmm1
	vaddss xmm2,xmm2,xmm3

	vaddps xmm0,xmm0,xmm2
	vmovss dword ptr[rdx],xmm0

	vzeroupper

	ret

VectorNorme1F_AVX512 endp


;VectorNorme1D_AVX512 proc coeff_x:dword,result:dword,lgth:word
; coeff_x = rcx
; result = rdx
; lgth = r8d

VectorNorme1D_AVX512 proc public frame

	.endprolog

	mov r9,rcx
	mov rax,256
	mov r10,64
	mov r11,192
	mov ecx,r8d

	vxorpd zmm0,zmm0,zmm0
	vmovapd zmm5,ZMMWORD ptr sign_bits_f_64

	shr ecx,2
	jz short VectorNorme1D_AVX512_1

VectorNorme1D_AVX512_loop_1:
	vandpd zmm1,zmm5,ZMMWORD ptr[r9]
	vandpd zmm2,zmm5,ZMMWORD ptr[r9+r10]
	vandpd zmm3,zmm5,ZMMWORD ptr[r9+2*r10]
	vandpd zmm4,zmm5,ZMMWORD ptr[r9+r11]

	vaddpd zmm1,zmm1,zmm2
	vaddpd zmm3,zmm3,zmm4
	vaddpd zmm1,zmm1,zmm3
	add r9,rax
	vaddpd zmm0,zmm0,zmm1

	loop VectorNorme1D_AVX512_loop_1

VectorNorme1D_AVX512_1:
	test r8d,2
	jz short VectorNorme1D_AVX512_2

	vandpd zmm1,zmm5,ZMMWORD ptr[r9]
	vandpd zmm2,zmm5,ZMMWORD ptr[r9+r10]

	vaddpd zmm1,zmm1,zmm2
	add r9,128
	vaddpd zmm0,zmm0,zmm1

VectorNorme1D_AVX512_2:
	test r8d,1
	jz short VectorNorme1D_AVX512_3

	vandpd zmm1,zmm5,ZMMWORD ptr[r9]
	vaddpd zmm0,zmm0,zmm1

VectorNorme1D_AVX512_3:
	vextractf64x4 ymm2,zmm0,1

	vextractf128 xmm1,ymm0,1
	vextractf128 xmm3,ymm2,1

	vaddpd xmm0,xmm0,xmm1
	vaddpd xmm2,xmm2,xmm3

	vmovhlps xmm1,xmm1,xmm0
	vmovhlps xmm3,xmm3,xmm2

	vaddsd xmm0,xmm0,xmm1
	vaddsd xmm2,xmm2,xmm3

	vaddpd xmm0,xmm0,xmm2
	vmovsd qword ptr[rdx],xmm0

	vzeroupper

	ret

VectorNorme1D_AVX512 endp	


;VectorDist1F_AVX512 proc coeff_x:dword,coeff_y:dword,result:dword,lgth:word
; coeff_x = rcx
; coeff_y = rdx
; result = r8
; lgth = r9d

VectorDist1F_AVX512 proc public frame

	push rsi
	.pushreg rsi
	.endprolog

	mov rsi,rcx
	mov rax,256
	mov ecx,r9d
	mov r10,64
	mov r11,192

	vxorps zmm0,zmm0,zmm0
	vmovaps zmm5,ZMMWORD ptr sign_bits_f_32

	shr ecx,2
	jz short VectorDist1F_AVX512_1

VectorDist1F_AVX512_loop_1:
	vmovaps zmm1,ZMMWORD ptr[rsi]
	vmovaps zmm2,ZMMWORD ptr[rsi+r10]
	vmovaps zmm3,ZMMWORD ptr[rsi+2*r10]
	vmovaps zmm4,ZMMWORD ptr[rsi+r11]

	vsubps zmm1,zmm1,ZMMWORD ptr[rdx]
	vsubps zmm2,zmm2,ZMMWORD ptr[rdx+r10]
	vsubps zmm3,zmm3,ZMMWORD ptr[rdx+2*r10]
	vsubps zmm4,zmm4,ZMMWORD ptr[rdx+r11]

	vandps zmm1,zmm1,zmm5
	vandps zmm2,zmm2,zmm5
	vandps zmm3,zmm3,zmm5
	vandps zmm4,zmm4,zmm5

	vaddps zmm1,zmm1,zmm2
	vaddps zmm3,zmm3,zmm4
	add rsi,rax
	vaddps zmm1,zmm1,zmm3
	add rdx,rax
	vaddps zmm0,zmm0,zmm1

	loop VectorDist1F_AVX512_loop_1

VectorDist1F_AVX512_1:
	test r9d,2
	jz short VectorDist1F_AVX512_2

	vmovaps zmm1,ZMMWORD ptr[rsi]
	vmovaps zmm2,ZMMWORD ptr[rsi+r10]
	vsubps zmm1,zmm1,ZMMWORD ptr[rdx]
	vsubps zmm2,zmm2,ZMMWORD ptr[rdx+r10]
	vandps zmm1,zmm1,zmm5
	vandps zmm2,zmm2,zmm5

	add rsi,128
	vaddps zmm1,zmm1,zmm2
	add rdx,128
	vaddps zmm0,zmm0,zmm1

VectorDist1F_AVX512_2:
	test r9d,1
	jz short VectorDist1F_AVX512_3

	vmovaps zmm1,ZMMWORD ptr[rsi]
	vsubps zmm1,zmm1,ZMMWORD ptr[rdx]
	vandps zmm1,zmm1,zmm5
	vaddps zmm0,zmm0,zmm1

VectorDist1F_AVX512_3:
	vextractf32x8 ymm2,zmm0,1

	vextractf128 xmm1,ymm0,1
	vextractf128 xmm3,ymm2,1

	vaddps xmm0,xmm0,xmm1
	vaddps xmm2,xmm2,xmm3

	vmovhlps xmm1,xmm1,xmm0
	vmovhlps xmm3,xmm3,xmm2

	vaddps xmm0,xmm0,xmm1
	vaddps xmm2,xmm2,xmm3

	vpsrldq xmm1,xmm0,4
	vpsrldq xmm3,xmm2,4

	vaddss xmm0,xmm0,xmm1
	vaddss xmm2,xmm2,xmm3

	vaddps xmm0,xmm0,xmm2
	vmovss dword ptr[r8],xmm0

	vzeroupper

	pop rsi

	ret

VectorDist1F_AVX512 endp


;VectorDist1D_AVX512 proc coeff_a:dword,coeff_x:dword,result:dword,lgth:word
; coeff_a = rcx
; coeff_x = rdx
; result = r8
; lgth = r9d

VectorDist1D_AVX512 proc public frame

	push rsi
	.pushreg rsi
	.endprolog

	mov rsi,rcx
	mov rax,256
	mov ecx,r9d
	mov r10,64
	mov r11,192

	vxorpd zmm0,zmm0,zmm0
	vmovapd zmm5,ZMMWORD ptr sign_bits_f_64

	shr ecx,2
	jz short VectorDist1D_AVX512_1

VectorDist1D_AVX512_loop_1:
	vmovapd zmm1,ZMMWORD ptr[rsi]
	vmovapd zmm2,ZMMWORD ptr[rsi+r10]
	vmovapd zmm3,ZMMWORD ptr[rsi+2*r10]
	vmovapd zmm4,ZMMWORD ptr[rsi+r11]

	vsubpd zmm1,zmm1,ZMMWORD ptr[rdx]
	vsubpd zmm2,zmm2,ZMMWORD ptr[rdx+r10]
	vsubpd zmm3,zmm3,ZMMWORD ptr[rdx+2*r10]
	vsubpd zmm4,zmm4,ZMMWORD ptr[rdx+r11]

	vandpd zmm1,zmm1,zmm5
	vandpd zmm2,zmm2,zmm5
	vandpd zmm3,zmm3,zmm5
	vandpd zmm4,zmm4,zmm5

	vaddpd zmm1,zmm1,zmm2
	vaddpd zmm3,zmm3,zmm4
	add rsi,rax
	vaddpd zmm1,zmm1,zmm3
	add rdx,rax
	vaddpd zmm0,zmm0,zmm1

	loop VectorDist1D_AVX512_loop_1

VectorDist1D_AVX512_1:
	test r9d,2
	jz short VectorDist1D_AVX512_2

	vmovapd zmm1,ZMMWORD ptr[rsi]
	vmovapd zmm2,ZMMWORD ptr[rsi+r10]
	vsubpd zmm1,zmm1,ZMMWORD ptr[rdx]
	vsubpd zmm2,zmm2,ZMMWORD ptr[rdx+r10]
	vandpd zmm1,zmm1,zmm5
	vandpd zmm2,zmm2,zmm5

	add rsi,128
	vaddpd zmm1,zmm1,zmm2
	add rdx,128
	vaddpd zmm0,zmm0,zmm1

VectorDist1D_AVX512_2:
	test r9d,1
	jz short VectorDist1D_AVX512_3

	vmovapd zmm1,ZMMWORD ptr[rsi]
	vsubpd zmm1,zmm1,ZMMWORD ptr[rdx]
	vandpd zmm1,zmm1,zmm5
	vaddpd zmm0,zmm0,zmm1

VectorDist1D_AVX512_3:
	vextractf64x4 ymm2,zmm0,1

	vextractf128 xmm1,ymm0,1
	vextractf128 xmm3,ymm2,1

	vaddpd xmm0,xmm0,xmm1
	vaddpd xmm2,xmm2,xmm3

	vmovhlps xmm1,xmm1,xmm0
	vmovhlps xmm3,xmm3,xmm2

	vaddsd xmm0,xmm0,xmm1
	vaddsd xmm2,xmm2,xmm3

	vaddpd xmm0,xmm0,xmm2
	vmovsd qword ptr[r8],xmm0

	vzeroupper

	pop rsi

	ret

VectorDist1D_AVX512 endp	

		
;VectorProductF_AVX512 proc coeff_a:dword,coeff_x:dword,result:dword,lgth:word
; coeff_a = rcx
; coeff_x = rdx
; result = r8
; lgth = r9d

VectorProductF_AVX512 proc public frame

	push rsi
	.pushreg rsi
	.endprolog

	mov rsi,rcx
	mov rax,256
	mov ecx,r9d
	mov r10,64
	mov r11,192

	vxorps zmm0,zmm0,zmm0

	shr ecx,2
	jz short VectorProductF_AVX512_1

VectorProductF_AVX512_loop_1:
	vmovaps zmm1,ZMMWORD ptr[rsi]
	vmovaps zmm2,ZMMWORD ptr[rsi+r10]
	vmovaps zmm3,ZMMWORD ptr[rsi+2*r10]
	vmovaps zmm4,ZMMWORD ptr[rsi+r11]

	vmulps zmm1,zmm1,ZMMWORD ptr[rdx]
	vmulps zmm2,zmm2,ZMMWORD ptr[rdx+r10]
	vmulps zmm3,zmm3,ZMMWORD ptr[rdx+2*r10]
	vmulps zmm4,zmm4,ZMMWORD ptr[rdx+r11]

	vaddps zmm1,zmm1,zmm2
	vaddps zmm3,zmm3,zmm4
	add rsi,rax
	vaddps zmm1,zmm1,zmm3
	add rdx,rax
	vaddps zmm0,zmm0,zmm1

	loop VectorProductF_AVX512_loop_1

VectorProductF_AVX512_1:
	test r9d,2
	jz short VectorProductF_AVX512_2

	vmovaps zmm1,ZMMWORD ptr[rsi]
	vmovaps zmm2,ZMMWORD ptr[rsi+r10]
	vmulps zmm1,zmm1,ZMMWORD ptr[rdx]
	vmulps zmm2,zmm2,ZMMWORD ptr[rdx+r10]

	add rsi,128
	vaddps zmm1,zmm1,zmm2
	add rdx,128
	vaddps zmm0,zmm0,zmm1


VectorProductF_AVX512_2:
	test r9d,1
	jz short VectorProductF_AVX512_3

	vmovaps zmm1,ZMMWORD ptr[rsi]
	vmulps zmm1,zmm1,ZMMWORD ptr[rdx]
	vaddps zmm0,zmm0,zmm1

VectorProductF_AVX512_3:
	vextractf32x8 ymm2,zmm0,1

	vextractf128 xmm1,ymm0,1
	vextractf128 xmm3,ymm2,1

	vaddps xmm0,xmm0,xmm1
	vaddps xmm2,xmm2,xmm3

	vmovhlps xmm1,xmm1,xmm0
	vmovhlps xmm3,xmm3,xmm2

	vaddps xmm0,xmm0,xmm1
	vaddps xmm2,xmm2,xmm3

	vpsrldq xmm1,xmm0,4
	vpsrldq xmm3,xmm2,4

	vaddss xmm0,xmm0,xmm1
	vaddss xmm2,xmm2,xmm3

	vaddps xmm0,xmm0,xmm2
	vmovss dword ptr[r8],xmm0

	vzeroupper

	pop rsi

	ret

VectorProductF_AVX512 endp


;VectorProductD_AVX512 proc coeff_a:dword,coeff_x:dword,result:dword,lgth:word
; coeff_a = rcx
; coeff_x = rdx
; result = r8
; lgth = r9d

VectorProductD_AVX512 proc public frame

	push rsi
	.pushreg rsi
	.endprolog

	mov rsi,rcx
	mov rax,256
	mov ecx,r9d
	mov r10,64
	mov r11,192

	vxorpd zmm0,zmm0,zmm0

	shr ecx,2
	jz short VectorProductD_AVX512_1

VectorProductD_AVX512_loop_1:
	vmovapd zmm1,ZMMWORD ptr[rsi]
	vmovapd zmm2,ZMMWORD ptr[rsi+r10]
	vmovapd zmm3,ZMMWORD ptr[rsi+2*r10]
	vmovapd zmm4,ZMMWORD ptr[rsi+r11]

	vmulpd zmm1,zmm1,ZMMWORD ptr[rdx]
	vmulpd zmm2,zmm2,ZMMWORD ptr[rdx+r10]
	vmulpd zmm3,zmm3,ZMMWORD ptr[rdx+2*r10]
	vmulpd zmm4,zmm4,ZMMWORD ptr[rdx+r11]

	vaddpd zmm1,zmm1,zmm2
	vaddpd zmm3,zmm3,zmm4
	add rsi,rax
	vaddpd zmm1,zmm1,zmm3
	add rdx,rax
	vaddpd zmm0,zmm0,zmm1

	loop VectorProductD_AVX512_loop_1

VectorProductD_AVX512_1:
	test r9d,2
	jz short VectorProductD_AVX512_2

	vmovapd zmm1,ZMMWORD ptr[rsi]
	vmovapd zmm2,ZMMWORD ptr[rsi+r10]
	vmulpd zmm1,zmm1,ZMMWORD ptr[rdx]
	vmulpd zmm2,zmm2,ZMMWORD ptr[rdx+r10]

	add rsi,128
	vaddpd zmm1,zmm1,zmm2
	add rdx,128
	vaddpd zmm0,zmm0,zmm1

VectorProductD_AVX512_2:
	test r9d,1
	jz short VectorProductD_AVX512_3

	vmovapd zmm1,ZMMWORD ptr[rsi]
	vmulpd zmm1,zmm1,ZMMWORD ptr[rdx]
	vaddpd zmm0,zmm0,zmm1

VectorProductD_AVX512_3:
	vextractf64x4 ymm2,zmm0,1

	vextractf128 xmm1,ymm0,1
	vextractf128 xmm3,ymm2,1

	vaddpd xmm0,xmm0,xmm1
	vaddpd xmm2,xmm2,xmm3

	vmovhlps xmm1,xmm1,xmm0
	vmovhlps xmm3,xmm3,xmm2

	vaddsd xmm0,xmm0,xmm1
	vaddsd xmm2,xmm2,xmm3

	vaddpd xmm0,xmm0,xmm2
	vmovsd qword ptr[r8],xmm0

	vzeroupper

	pop rsi

	ret

VectorProductD_AVX512 endp	


;VectorAddF_AVX512 proc coeff_a:dword,coeff_b:dword,coeff_c:dword,lgth:word
; coeff_a = rcx
; coeff_b = rdx
; coeff_c = r8
; lgth = r9d

VectorAddF_AVX512 proc public frame

	push rsi
	.pushreg rsi
	.endprolog

	mov rsi,rcx
	mov rax,256
	mov ecx,r9d
	mov r10,64
	mov r11,192

	shr ecx,2
	jz short VectorAddF_AVX512_1

VectorAddF_AVX512_loop_1:
	vmovaps zmm0,ZMMWORD ptr[rsi]
	vmovaps zmm1,ZMMWORD ptr[rsi+r10]
	vmovaps zmm2,ZMMWORD ptr[rsi+2*r10]
	vmovaps zmm3,ZMMWORD ptr[rsi+r11]

	vaddps zmm0,zmm0,ZMMWORD ptr[rdx]
	vaddps zmm1,zmm1,ZMMWORD ptr[rdx+r10]
	vaddps zmm2,zmm2,ZMMWORD ptr[rdx+2*r10]
	vaddps zmm3,zmm3,ZMMWORD ptr[rdx+r11]

	vmovaps ZMMWORD ptr[r8],zmm0
	vmovaps ZMMWORD ptr[r8+r10],zmm1
	vmovaps ZMMWORD ptr[r8+2*r10],zmm2
	vmovaps ZMMWORD ptr[r8+r11],zmm3

	add rsi,rax
	add rdx,rax
	add r8,rax
	loop VectorAddF_AVX512_loop_1

VectorAddF_AVX512_1:
	test r9d,2
	jz short VectorAddF_AVX512_2

	vmovaps zmm0,ZMMWORD ptr[rsi]
	vmovaps zmm1,ZMMWORD ptr[rsi+r10]
	vaddps zmm0,zmm0,ZMMWORD ptr[rdx]
	vaddps zmm1,zmm1,ZMMWORD ptr[rdx+r10]
	vmovaps ZMMWORD ptr[r8],zmm0
	vmovaps ZMMWORD ptr[r8+r10],zmm1

	add rsi,128
	add rdx,128
	add r8,128

VectorAddF_AVX512_2:
	test r9d,1
	jz short VectorAddF_AVX512_3

	vmovaps zmm0,ZMMWORD ptr[rsi]
	vaddps zmm0,zmm0,ZMMWORD ptr[rdx]
	vmovaps ZMMWORD ptr[r8],zmm0

VectorAddF_AVX512_3:
	vzeroupper

	pop rsi

	ret

VectorAddF_AVX512 endp


;VectorSubF_AVX512 proc coeff_a:dword,coeff_b:dword,coeff_c:dword,lgth:word
; coeff_a = rcx
; coeff_b = rdx
; coeff_c = r8
; lgth = r9d

VectorSubF_AVX512 proc public frame

	push rsi
	.pushreg rsi
	.endprolog

	mov rsi,rcx
	mov rax,256
	mov ecx,r9d
	mov r10,64
	mov r11,192

	shr ecx,2
	jz short VectorSubF_AVX512_1

VectorSubF_AVX512_loop_1:
	vmovaps zmm0,ZMMWORD ptr[rsi]
	vmovaps zmm1,ZMMWORD ptr[rsi+r10]
	vmovaps zmm2,ZMMWORD ptr[rsi+2*r10]
	vmovaps zmm3,ZMMWORD ptr[rsi+r11]

	vsubps zmm0,zmm0,ZMMWORD ptr[rdx]
	vsubps zmm1,zmm1,ZMMWORD ptr[rdx+r10]
	vsubps zmm2,zmm2,ZMMWORD ptr[rdx+2*r10]
	vsubps zmm3,zmm3,ZMMWORD ptr[rdx+r11]

	vmovaps ZMMWORD ptr[r8],zmm0
	vmovaps ZMMWORD ptr[r8+r10],zmm1
	vmovaps ZMMWORD ptr[r8+2*r10],zmm2
	vmovaps ZMMWORD ptr[r8+r11],zmm3

	add rsi,rax
	add rdx,rax
	add r8,rax
	loop VectorSubF_AVX512_loop_1

VectorSubF_AVX512_1:
	test r9d,2
	jz short VectorSubF_AVX512_2

	vmovaps zmm0,ZMMWORD ptr[rsi]
	vmovaps zmm1,ZMMWORD ptr[rsi+r10]
	vsubps zmm0,zmm0,ZMMWORD ptr[rdx]
	vsubps zmm1,zmm1,ZMMWORD ptr[rdx+r10]
	vmovaps ZMMWORD ptr[r8],zmm0
	vmovaps ZMMWORD ptr[r8+r10],zmm1

	add rsi,128
	add rdx,128
	add r8,128

VectorSubF_AVX512_2:
	test r9d,1
	jz short VectorSubF_AVX512_3

	vmovaps zmm0,ZMMWORD ptr[rsi]
	vsubps zmm0,zmm0,ZMMWORD ptr[rdx]
	vmovaps ZMMWORD ptr[r8],zmm0

VectorSubF_AVX512_3:
	vzeroupper

	pop rsi

	ret

VectorSubF_AVX512 endp


;VectorProdF_AVX512 proc coeff_a:dword,coeff_b:dword,coeff_c:dword,lgth:word
; coeff_a = rcx
; coeff_b = rdx
; coeff_c = r8
; lgth = r9d

VectorProdF_AVX512 proc public frame

	push rsi
	.pushreg rsi
	.endprolog

	mov rsi,rcx
	mov rax,256
	mov ecx,r9d
	mov r10,64
	mov r11,192

	shr ecx,2
	jz short VectorProdF_AVX512_1

VectorProdF_AVX512_loop_1:
	vmovaps zmm0,ZMMWORD ptr[rsi]
	vmovaps zmm1,ZMMWORD ptr[rsi+r10]
	vmovaps zmm2,ZMMWORD ptr[rsi+2*r10]
	vmovaps zmm3,ZMMWORD ptr[rsi+r11]

	vmulps zmm0,zmm0,ZMMWORD ptr[rdx]
	vmulps zmm1,zmm1,ZMMWORD ptr[rdx+r10]
	vmulps zmm2,zmm2,ZMMWORD ptr[rdx+2*r10]
	vmulps zmm3,zmm3,ZMMWORD ptr[rdx+r11]

	vmovaps ZMMWORD ptr[r8],zmm0
	vmovaps ZMMWORD ptr[r8+r10],zmm1
	vmovaps ZMMWORD ptr[r8+2*r10],zmm2
	vmovaps ZMMWORD ptr[r8+r11],zmm3

	add rsi,rax
	add rdx,rax
	add r8,rax
	loop VectorProdF_AVX512_loop_1

VectorProdF_AVX512_1:
	test r9d,2
	jz short VectorProdF_AVX512_2

	vmovaps zmm0,ZMMWORD ptr[rsi]
	vmovaps zmm1,ZMMWORD ptr[rsi+r10]
	vmulps zmm0,zmm0,ZMMWORD ptr[rdx]
	vmulps zmm1,zmm1,ZMMWORD ptr[rdx+r10]
	vmovaps ZMMWORD ptr[r8],zmm0
	vmovaps ZMMWORD ptr[r8+r10],zmm1

	add rsi,128
	add rdx,128
	add r8,128

VectorProdF_AVX512_2:
	test r9d,1
	jz short VectorProdF_AVX512_3

	vmovaps zmm0,ZMMWORD ptr[rsi]
	vmulps zmm0,zmm0,ZMMWORD ptr[rdx]
	vmovaps ZMMWORD ptr[r8],zmm0

VectorProdF_AVX512_3:
	vzeroupper

	pop rsi

	ret

VectorProdF_AVX512 endp


;VectorAdd2F_AVX512 proc coeff_a:dword,coeff_b:dword,lgth:word
; coeff_a = rcx
; coeff_b = rdx
; lgth = r8d

VectorAdd2F_AVX512 proc public frame

	push rsi
	.pushreg rsi
	.endprolog

	mov rsi,rcx
	mov rax,256
	mov ecx,r8d
	mov r9,64
	mov r10,128
	mov r11,192

	shr ecx,2
	jz short VectorAdd2F_AVX512_1

VectorAdd2F_AVX512_loop_1:
	vmovaps zmm0,ZMMWORD ptr[rsi]
	vmovaps zmm1,ZMMWORD ptr[rsi+r9]
	vmovaps zmm2,ZMMWORD ptr[rsi+r10]
	vmovaps zmm3,ZMMWORD ptr[rsi+r11]

	vaddps zmm0,zmm0,ZMMWORD ptr[rdx]
	vaddps zmm1,zmm1,ZMMWORD ptr[rdx+r9]
	vaddps zmm2,zmm2,ZMMWORD ptr[rdx+r10]
	vaddps zmm3,zmm3,ZMMWORD ptr[rdx+r11]

	vmovaps ZMMWORD ptr[rsi],zmm0
	vmovaps ZMMWORD ptr[rsi+r9],zmm1
	vmovaps ZMMWORD ptr[rsi+r10],zmm2
	vmovaps ZMMWORD ptr[rsi+r11],zmm3

	add rdx,rax
	add rsi,rax
	loop VectorAdd2F_AVX512_loop_1

VectorAdd2F_AVX512_1:
	test r8d,2
	jz short VectorAdd2F_AVX512_2

	vmovaps zmm0,ZMMWORD ptr[rsi]
	vmovaps zmm1,ZMMWORD ptr[rsi+r9]
	vaddps zmm0,zmm0,ZMMWORD ptr[rdx]
	vaddps zmm1,zmm1,ZMMWORD ptr[rdx+r9]
	vmovaps ZMMWORD ptr[rsi],zmm0
	vmovaps ZMMWORD ptr[rsi+r9],zmm1

	add rdx,r10
	add rsi,r10

VectorAdd2F_AVX512_2:
	test r8d,1
	jz short VectorAdd2F_AVX512_3

	vmovaps zmm0,ZMMWORD ptr[rsi]
	vaddps zmm0,zmm0,ZMMWORD ptr[rdx]
	vmovaps ZMMWORD ptr[rsi],zmm0

VectorAdd2F_AVX512_3:
	vzeroupper

	pop rsi

	ret

VectorAdd2F_AVX512 endp


;VectorSub2F_AVX512 proc coeff_a:dword,coeff_b:dword,lgth:word
; coeff_a = rcx
; coeff_b = rdx
; lgth = r8d

VectorSub2F_AVX512 proc public frame

	push rsi
	.pushreg rsi
	.endprolog

	mov rsi,rcx
	mov rax,256
	mov ecx,r8d
	mov r9,64
	mov r10,128
	mov r11,192

	shr ecx,2
	jz short VectorSub2F_AVX512_1

VectorSub2F_AVX512_loop_1:
	vmovaps zmm0,ZMMWORD ptr[rsi]
	vmovaps zmm1,ZMMWORD ptr[rsi+r9]
	vmovaps zmm2,ZMMWORD ptr[rsi+r10]
	vmovaps zmm3,ZMMWORD ptr[rsi+r11]

	vsubps zmm0,zmm0,ZMMWORD ptr[rdx]
	vsubps zmm1,zmm1,ZMMWORD ptr[rdx+r9]
	vsubps zmm2,zmm2,ZMMWORD ptr[rdx+r10]
	vsubps zmm3,zmm3,ZMMWORD ptr[rdx+r11]

	vmovaps ZMMWORD ptr[rsi],zmm0
	vmovaps ZMMWORD ptr[rsi+r9],zmm1
	vmovaps ZMMWORD ptr[rsi+r10],zmm2
	vmovaps ZMMWORD ptr[rsi+r11],zmm3

	add rdx,rax
	add rsi,rax
	loop VectorSub2F_AVX512_loop_1

VectorSub2F_AVX512_1:
	test r8d,2
	jz short VectorSub2F_AVX512_2

	vmovaps zmm0,ZMMWORD ptr[rsi]
	vmovaps zmm1,ZMMWORD ptr[rsi+r9]
	vsubps zmm0,zmm0,ZMMWORD ptr[rdx]
	vsubps zmm1,zmm1,ZMMWORD ptr[rdx+r9]
	vmovaps ZMMWORD ptr[rsi],zmm0
	vmovaps ZMMWORD ptr[rsi+r9],zmm1

	add rdx,r10
	add rsi,r10

VectorSub2F_AVX512_2:
	test r8d,1
	jz short VectorSub2F_AVX512_3

	vmovaps zmm0,ZMMWORD ptr[rsi]
	vsubps zmm0,zmm0,ZMMWORD ptr[rdx]
	vmovaps ZMMWORD ptr[rsi],zmm0

VectorSub2F_AVX512_3:
	vzeroupper

	pop rsi

	ret

VectorSub2F_AVX512 endp


;VectorInvSubF_AVX512 proc coeff_a:dword,coeff_b:dword,lgth:word
; coeff_a = rcx
; coeff_b = rdx
; lgth = r8d

VectorInvSubF_AVX512 proc public frame

	push rsi
	.pushreg rsi
	.endprolog

	mov rsi,rcx
	mov rax,256
	mov ecx,r8d
	mov r9,64
	mov r10,128
	mov r11,192

	shr ecx,2
	jz short VectorInvSubF_AVX512_1

VectorInvSubF_AVX512_loop_1:
	vmovaps zmm0,ZMMWORD ptr[rdx]
	vmovaps zmm1,ZMMWORD ptr[rdx+r9]
	vmovaps zmm2,ZMMWORD ptr[rdx+r10]
	vmovaps zmm3,ZMMWORD ptr[rdx+r11]

	vsubps zmm0,zmm0,ZMMWORD ptr[rsi]
	vsubps zmm1,zmm1,ZMMWORD ptr[rsi+r9]
	vsubps zmm2,zmm2,ZMMWORD ptr[rsi+r10]
	vsubps zmm3,zmm3,ZMMWORD ptr[rsi+r11]

	vmovaps ZMMWORD ptr[rsi],zmm0
	vmovaps ZMMWORD ptr[rsi+r9],zmm1
	vmovaps ZMMWORD ptr[rsi+r10],zmm2
	vmovaps ZMMWORD ptr[rsi+r11],zmm3

	add rdx,rax
	add rsi,rax
	loop VectorInvSubF_AVX512_loop_1

VectorInvSubF_AVX512_1:
	test r8d,2
	jz short VectorInvSubF_AVX512_2

	vmovaps zmm0,ZMMWORD ptr[rdx]
	vmovaps zmm1,ZMMWORD ptr[rdx+r9]
	vsubps zmm0,zmm0,ZMMWORD ptr[rsi]
	vsubps zmm1,zmm1,ZMMWORD ptr[rsi+r9]
	vmovaps ZMMWORD ptr[rsi],zmm0
	vmovaps ZMMWORD ptr[rsi+r9],zmm1

	add rdx,r10
	add rsi,r10

VectorInvSubF_AVX512_2:
	test r8d,1
	jz short VectorInvSubF_AVX512_3

	vmovaps zmm0,ZMMWORD ptr[rdx]
	vsubps zmm0,zmm0,ZMMWORD ptr[rsi]
	vmovaps ZMMWORD ptr[rsi],zmm0

VectorInvSubF_AVX512_3:
	vzeroupper

	pop rsi

	ret

VectorInvSubF_AVX512 endp


;VectorProd2F_AVX512 proc coeff_a:dword,coeff_b:dword,lgth:word
; coeff_a = rcx
; coeff_b = rdx
; lgth = r8d

VectorProd2F_AVX512 proc public frame

	push rsi
	.pushreg rsi
	.endprolog

	mov rsi,rcx
	mov rax,256
	mov ecx,r8d
	mov r9,64
	mov r10,128
	mov r11,192

	shr ecx,2
	jz short VectorProd2F_AVX512_1

VectorProd2F_AVX512_loop_1:
	vmovaps zmm0,ZMMWORD ptr[rsi]
	vmovaps zmm1,ZMMWORD ptr[rsi+r9]
	vmovaps zmm2,ZMMWORD ptr[rsi+r10]
	vmovaps zmm3,ZMMWORD ptr[rsi+r11]

	vmulps zmm0,zmm0,ZMMWORD ptr[rdx]
	vmulps zmm1,zmm1,ZMMWORD ptr[rdx+r9]
	vmulps zmm2,zmm2,ZMMWORD ptr[rdx+r10]
	vmulps zmm3,zmm3,ZMMWORD ptr[rdx+r11]

	vmovaps ZMMWORD ptr[rsi],zmm0
	vmovaps ZMMWORD ptr[rsi+r9],zmm1
	vmovaps ZMMWORD ptr[rsi+r10],zmm2
	vmovaps ZMMWORD ptr[rsi+r11],zmm3

	add rdx,rax
	add rsi,rax
	loop VectorProd2F_AVX512_loop_1

VectorProd2F_AVX512_1:
	test r8d,2
	jz short VectorProd2F_AVX512_2

	vmovaps zmm0,ZMMWORD ptr[rsi]
	vmovaps zmm1,ZMMWORD ptr[rsi+r9]
	vmulps zmm0,zmm0,ZMMWORD ptr[rdx]
	vmulps zmm1,zmm1,ZMMWORD ptr[rdx+r9]
	vmovaps ZMMWORD ptr[rsi],zmm0
	vmovaps ZMMWORD ptr[rsi+r9],zmm1

	add rdx,r10
	add rsi,r10

VectorProd2F_AVX512_2:
	test r8d,1
	jz short VectorProd2F_AVX512_3

	vmovaps zmm0,ZMMWORD ptr[rsi]
	vmulps zmm0,zmm0,ZMMWORD ptr[rdx]
	vmovaps ZMMWORD ptr[rsi],zmm0

VectorProd2F_AVX512_3:
	vzeroupper

	pop rsi

	ret

VectorProd2F_AVX512 endp


;VectorAddD_AVX512 proc coeff_a:dword,coeff_b:dword,coeff_c:dword,lgth:word
; coeff_a = rcx
; coeff_b = rdx
; coeff_c = r8
; lgth = r9d

VectorAddD_AVX512 proc public frame

	push rsi
	.pushreg rsi
	.endprolog

	mov rsi,rcx
	mov rax,256
	mov ecx,r9d
	mov r10,64
	mov r11,192

	shr ecx,2
	jz short VectorAddD_AVX512_1

VectorAddD_AVX512_loop_1:
	vmovapd zmm0,ZMMWORD ptr[rsi]
	vmovapd zmm1,ZMMWORD ptr[rsi+r10]
	vmovapd zmm2,ZMMWORD ptr[rsi+2*r10]
	vmovapd zmm3,ZMMWORD ptr[rsi+r11]

	vaddpd zmm0,zmm0,ZMMWORD ptr[rdx]
	vaddpd zmm1,zmm1,ZMMWORD ptr[rdx+r10]
	vaddpd zmm2,zmm2,ZMMWORD ptr[rdx+2*r10]
	vaddpd zmm3,zmm3,ZMMWORD ptr[rdx+r11]

	vmovapd ZMMWORD ptr[r8],zmm0
	vmovapd ZMMWORD ptr[r8+r10],zmm1
	vmovapd ZMMWORD ptr[r8+2*r10],zmm2
	vmovapd ZMMWORD ptr[r8+r11],zmm3

	add rsi,rax
	add rdx,rax
	add r8,rax
	loop VectorAddD_AVX512_loop_1

VectorAddD_AVX512_1:
	test r9d,2
	jz short VectorAddD_AVX512_2

	vmovapd zmm0,ZMMWORD ptr[rsi]
	vmovapd zmm1,ZMMWORD ptr[rsi+r10]
	vaddpd zmm0,zmm0,ZMMWORD ptr[rdx]
	vaddpd zmm1,zmm1,ZMMWORD ptr[rdx+r10]
	vmovapd ZMMWORD ptr[r8],zmm0
	vmovapd ZMMWORD ptr[r8+r10],zmm1

	add rsi,128
	add rdx,128
	add r8,128

VectorAddD_AVX512_2:
	test r9d,1
	jz short VectorAddD_AVX512_3

	vmovapd zmm0,ZMMWORD ptr[rsi]
	vaddpd zmm0,zmm0,ZMMWORD ptr[rdx]
	vmovapd ZMMWORD ptr[r8],zmm0

VectorAddD_AVX512_3:
	vzeroupper

	pop rsi

	ret

VectorAddD_AVX512 endp


;VectorSubD_AVX512 proc coeff_a:dword,coeff_b:dword,coeff_c:dword,lgth:word
; coeff_a = rcx
; coeff_b = rdx
; coeff_c = r8
; lgth = r9d

VectorSubD_AVX512 proc public frame

	push rsi
	.pushreg rsi
	.endprolog

	mov rsi,rcx
	mov rax,256
	mov ecx,r9d
	mov r10,64
	mov r11,192

	shr ecx,2
	jz short VectorSubD_AVX512_1

VectorSubD_AVX512_loop_1:
	vmovapd zmm0,ZMMWORD ptr[rsi]
	vmovapd zmm1,ZMMWORD ptr[rsi+r10]
	vmovapd zmm2,ZMMWORD ptr[rsi+2*r10]
	vmovapd zmm3,ZMMWORD ptr[rsi+r11]

	vsubpd zmm0,zmm0,ZMMWORD ptr[rdx]
	vsubpd zmm1,zmm1,ZMMWORD ptr[rdx+r10]
	vsubpd zmm2,zmm2,ZMMWORD ptr[rdx+2*r10]
	vsubpd zmm3,zmm3,ZMMWORD ptr[rdx+r11]

	vmovapd ZMMWORD ptr[r8],zmm0
	vmovapd ZMMWORD ptr[r8+r10],zmm1
	vmovapd ZMMWORD ptr[r8+2*r10],zmm2
	vmovapd ZMMWORD ptr[r8+r11],zmm3

	add rsi,rax
	add rdx,rax
	add r8,rax
	loop VectorSubD_AVX512_loop_1

VectorSubD_AVX512_1:
	test r9d,2
	jz short VectorSubD_AVX512_2

	vmovapd zmm0,ZMMWORD ptr[rsi]
	vmovapd zmm1,ZMMWORD ptr[rsi+r10]
	vsubpd zmm0,zmm0,ZMMWORD ptr[rdx]
	vsubpd zmm1,zmm1,ZMMWORD ptr[rdx+r10]
	vmovapd ZMMWORD ptr[r8],zmm0
	vmovapd ZMMWORD ptr[r8+r10],zmm1

	add rsi,128
	add rdx,128
	add r8,128

VectorSubD_AVX512_2:
	test r9d,1
	jz short VectorSubD_AVX512_3

	vmovapd zmm0,ZMMWORD ptr[rsi]
	vsubpd zmm0,zmm0,ZMMWORD ptr[rdx]
	vmovapd ZMMWORD ptr[r8],zmm0

VectorSubD_AVX512_3:
	vzeroupper

	pop rsi

	ret

VectorSubD_AVX512 endp


;VectorProdD_AVX512 proc coeff_a:dword,coeff_b:dword,coeff_c:dword,lgth:word
; coeff_a = rcx
; coeff_b = rdx
; coeff_c = r8
; lgth = r9d

VectorProdD_AVX512 proc public frame

	push rsi
	.pushreg rsi
	.endprolog

	mov rsi,rcx
	mov rax,256
	mov ecx,r9d
	mov r10,64
	mov r11,192

	shr ecx,2
	jz short VectorProdD_AVX512_1

VectorProdD_AVX512_loop_1:
	vmovapd zmm0,ZMMWORD ptr[rsi]
	vmovapd zmm1,ZMMWORD ptr[rsi+r10]
	vmovapd zmm2,ZMMWORD ptr[rsi+2*r10]
	vmovapd zmm3,ZMMWORD ptr[rsi+r11]

	vmulpd zmm0,zmm0,ZMMWORD ptr[rdx]
	vmulpd zmm1,zmm1,ZMMWORD ptr[rdx+r10]
	vmulpd zmm2,zmm2,ZMMWORD ptr[rdx+2*r10]
	vmulpd zmm3,zmm3,ZMMWORD ptr[rdx+r11]

	vmovapd ZMMWORD ptr[r8],zmm0
	vmovapd ZMMWORD ptr[r8+r10],zmm1
	vmovapd ZMMWORD ptr[r8+2*r10],zmm2
	vmovapd ZMMWORD ptr[r8+r11],zmm3

	add rsi,rax
	add rdx,rax
	add r8,rax
	loop VectorProdD_AVX512_loop_1

VectorProdD_AVX512_1:
	test r9d,2
	jz short VectorProdD_AVX512_2

	vmovapd zmm0,ZMMWORD ptr[rsi]
	vmovapd zmm1,ZMMWORD ptr[rsi+r10]
	vmulpd zmm0,zmm0,ZMMWORD ptr[rdx]
	vmulpd zmm1,zmm1,ZMMWORD ptr[rdx+r10]
	vmovapd ZMMWORD ptr[r8],zmm0
	vmovapd ZMMWORD ptr[r8+r10],zmm1

	add rsi,128
	add rdx,128
	add r8,128

VectorProdD_AVX512_2:
	test r9d,1
	jz short VectorProdD_AVX512_3

	vmovapd zmm0,ZMMWORD ptr[rsi]
	vmulpd zmm0,zmm0,ZMMWORD ptr[rdx]
	vmovapd ZMMWORD ptr[r8],zmm0

VectorProdD_AVX512_3:
	vzeroupper

	pop rsi

	ret

VectorProdD_AVX512 endp


;VectorAdd2D_AVX512 proc coeff_a:dword,coeff_b:dword,lgth:word
; coeff_a = rcx
; coeff_b = rdx
; lgth = r8d

VectorAdd2D_AVX512 proc public frame

	push rsi
	.pushreg rsi
	.endprolog

	mov rsi,rcx
	mov rax,256
	mov ecx,r8d
	mov r9,64
	mov r10,128
	mov r11,192

	shr ecx,2
	jz short VectorAdd2D_AVX512_1

VectorAdd2D_AVX512_loop_1:
	vmovapd zmm0,ZMMWORD ptr[rsi]
	vmovapd zmm1,ZMMWORD ptr[rsi+r9]
	vmovapd zmm2,ZMMWORD ptr[rsi+r10]
	vmovapd zmm3,ZMMWORD ptr[rsi+r11]

	vaddpd zmm0,zmm0,ZMMWORD ptr[rdx]
	vaddpd zmm1,zmm1,ZMMWORD ptr[rdx+r9]
	vaddpd zmm2,zmm2,ZMMWORD ptr[rdx+r10]
	vaddpd zmm3,zmm3,ZMMWORD ptr[rdx+r11]

	vmovapd ZMMWORD ptr[rsi],zmm0
	vmovapd ZMMWORD ptr[rsi+r9],zmm1
	vmovapd ZMMWORD ptr[rsi+r10],zmm2
	vmovapd ZMMWORD ptr[rsi+r11],zmm3

	add rdx,rax
	add rsi,rax
	loop VectorAdd2D_AVX512_loop_1

VectorAdd2D_AVX512_1:
	test r8d,2
	jz short VectorAdd2D_AVX512_2

	vmovapd zmm0,ZMMWORD ptr[rsi]
	vmovapd zmm1,ZMMWORD ptr[rsi+r9]
	vaddpd zmm0,zmm0,ZMMWORD ptr[rdx]
	vaddpd zmm1,zmm1,ZMMWORD ptr[rdx+r9]
	vmovapd ZMMWORD ptr[rsi],zmm0
	vmovapd ZMMWORD ptr[rsi+r9],zmm1

	add rdx,r10
	add rsi,r10

VectorAdd2D_AVX512_2:
	test r8d,1
	jz short VectorAdd2D_AVX512_3

	vmovapd zmm0,ZMMWORD ptr[rsi]
	vaddpd zmm0,zmm0,ZMMWORD ptr[rdx]
	vmovapd ZMMWORD ptr[rsi],zmm0

VectorAdd2D_AVX512_3:
	vzeroupper

	pop rsi

	ret

VectorAdd2D_AVX512 endp


;VectorSub2D_AVX512 proc coeff_a:dword,coeff_b:dword,lgth:word
; coeff_a = rcx
; coeff_b = rdx
; lgth = r8d

VectorSub2D_AVX512 proc public frame

	push rsi
	.pushreg rsi
	.endprolog

	mov rsi,rcx
	mov rax,256
	mov ecx,r8d
	mov r9,64
	mov r10,128
	mov r11,192

	shr ecx,2
	jz short VectorSub2D_AVX512_1

VectorSub2D_AVX512_loop_1:
	vmovapd zmm0,ZMMWORD ptr[rsi]
	vmovapd zmm1,ZMMWORD ptr[rsi+r9]
	vmovapd zmm2,ZMMWORD ptr[rsi+r10]
	vmovapd zmm3,ZMMWORD ptr[rsi+r11]

	vsubpd zmm0,zmm0,ZMMWORD ptr[rdx]
	vsubpd zmm1,zmm1,ZMMWORD ptr[rdx+r9]
	vsubpd zmm2,zmm2,ZMMWORD ptr[rdx+r10]
	vsubpd zmm3,zmm3,ZMMWORD ptr[rdx+r11]

	vmovapd ZMMWORD ptr[rsi],zmm0
	vmovapd ZMMWORD ptr[rsi+r9],zmm1
	vmovapd ZMMWORD ptr[rsi+r10],zmm2
	vmovapd ZMMWORD ptr[rsi+r11],zmm3

	add rdx,rax
	add rsi,rax
	loop VectorSub2D_AVX512_loop_1

VectorSub2D_AVX512_1:
	test r8d,2
	jz short VectorSub2D_AVX512_2

	vmovapd zmm0,ZMMWORD ptr[rsi]
	vmovapd zmm1,ZMMWORD ptr[rsi+r9]
	vsubpd zmm0,zmm0,ZMMWORD ptr[rdx]
	vsubpd zmm1,zmm1,ZMMWORD ptr[rdx+r9]
	vmovapd ZMMWORD ptr[rsi],zmm0
	vmovapd ZMMWORD ptr[rsi+r9],zmm1

	add rdx,r10
	add rsi,r10

VectorSub2D_AVX512_2:
	test r8d,1
	jz short VectorSub2D_AVX512_3

	vmovapd zmm0,ZMMWORD ptr[rsi]
	vsubpd zmm0,zmm0,ZMMWORD ptr[rdx]
	vmovapd ZMMWORD ptr[rsi],zmm0

VectorSub2D_AVX512_3:
	vzeroupper

	pop rsi

	ret

VectorSub2D_AVX512 endp


;VectorInvSubD_AVX512 proc coeff_a:dword,coeff_b:dword,lgth:word
; coeff_a = rcx
; coeff_b = rdx
; lgth = r8d

VectorInvSubD_AVX512 proc public frame

	push rsi
	.pushreg rsi
	.endprolog

	mov rsi,rcx
	mov rax,256
	mov ecx,r8d
	mov r9,64
	mov r10,128
	mov r11,192

	shr ecx,2
	jz short VectorInvSubD_AVX512_1

VectorInvSubD_AVX512_loop_1:
	vmovapd zmm0,ZMMWORD ptr[rdx]
	vmovapd zmm1,ZMMWORD ptr[rdx+r9]
	vmovapd zmm2,ZMMWORD ptr[rdx+r10]
	vmovapd zmm3,ZMMWORD ptr[rdx+r11]

	vsubpd zmm0,zmm0,ZMMWORD ptr[rsi]
	vsubpd zmm1,zmm1,ZMMWORD ptr[rsi+r9]
	vsubpd zmm2,zmm2,ZMMWORD ptr[rsi+r10]
	vsubpd zmm3,zmm3,ZMMWORD ptr[rsi+r11]

	vmovapd ZMMWORD ptr[rsi],zmm0
	vmovapd ZMMWORD ptr[rsi+r9],zmm1
	vmovapd ZMMWORD ptr[rsi+r10],zmm2
	vmovapd ZMMWORD ptr[rsi+r11],zmm3

	add rdx,rax
	add rsi,rax
	loop VectorInvSubD_AVX512_loop_1

VectorInvSubD_AVX512_1:
	test r8d,2
	jz short VectorInvSubD_AVX512_2

	vmovapd zmm0,ZMMWORD ptr[rdx]
	vmovapd zmm1,ZMMWORD ptr[rdx+r9]
	vsubpd zmm0,zmm0,ZMMWORD ptr[rsi]
	vsubpd zmm1,zmm1,ZMMWORD ptr[rsi+r9]
	vmovapd ZMMWORD ptr[rsi],zmm0
	vmovapd ZMMWORD ptr[rsi+r9],zmm1

	add rdx,r10
	add rsi,r10

VectorInvSubD_AVX512_2:
	test r8d,1
	jz short VectorInvSubD_AVX512_3

	vmovapd zmm0,ZMMWORD ptr[rdx]
	vsubpd zmm0,zmm0,ZMMWORD ptr[rsi]
	vmovapd ZMMWORD ptr[rsi],zmm0

VectorInvSubD_AVX512_3:
	vzeroupper

	pop rsi

	ret

VectorInvSubD_AVX512 endp


;VectorProd2D_AVX512 proc coeff_a:dword,coeff_b:dword,lgth:word
; coeff_a = rcx
; coeff_b = rdx
; lgth = r8d

VectorProd2D_AVX512 proc public frame

	push rsi
	.pushreg rsi
	.endprolog

	mov rsi,rcx
	mov rax,256
	mov ecx,r8d
	mov r9,64
	mov r10,128
	mov r11,192

	shr ecx,2
	jz short VectorProd2D_AVX512_1

VectorProd2D_AVX512_loop_1:
	vmovapd zmm0,ZMMWORD ptr[rsi]
	vmovapd zmm1,ZMMWORD ptr[rsi+r9]
	vmovapd zmm2,ZMMWORD ptr[rsi+r10]
	vmovapd zmm3,ZMMWORD ptr[rsi+r11]

	vmulpd zmm0,zmm0,ZMMWORD ptr[rdx]
	vmulpd zmm1,zmm1,ZMMWORD ptr[rdx+r9]
	vmulpd zmm2,zmm2,ZMMWORD ptr[rdx+r10]
	vmulpd zmm3,zmm3,ZMMWORD ptr[rdx+r11]

	vmovapd ZMMWORD ptr[rsi],zmm0
	vmovapd ZMMWORD ptr[rsi+r9],zmm1
	vmovapd ZMMWORD ptr[rsi+r10],zmm2
	vmovapd ZMMWORD ptr[rsi+r11],zmm3

	add rdx,rax
	add rsi,rax
	loop VectorProd2D_AVX512_loop_1

VectorProd2D_AVX512_1:
	test r8d,2
	jz short VectorProd2D_AVX512_2

	vmovapd zmm0,ZMMWORD ptr[rsi]
	vmovapd zmm1,ZMMWORD ptr[rsi+r9]
	vmulpd zmm0,zmm0,ZMMWORD ptr[rdx]
	vmulpd zmm1,zmm1,ZMMWORD ptr[rdx+r9]
	vmovapd ZMMWORD ptr[rsi],zmm0
	vmovapd ZMMWORD ptr[rsi+r9],zmm1

	add rdx,r10
	add rsi,r10

VectorProd2D_AVX512_2:
	test r8d,1
	jz short VectorProd2D_AVX512_3

	vmovapd zmm0,ZMMWORD ptr[rsi]
	vmulpd zmm0,zmm0,ZMMWORD ptr[rdx]
	vmovapd ZMMWORD ptr[rsi],zmm0

VectorProd2D_AVX512_3:
	vzeroupper

	pop rsi

	ret

VectorProd2D_AVX512 endp

end