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

	.endprolog
	
	vbroadcastss zmm0,dword ptr[rcx]

	mov r10,rdx 	; coeff_b
	mov edx,r9d		; lgth
	mov ecx,r9d		; lgth
	mov rax,512

	shr ecx,3
	jz short CoeffProductF_AVX512_1

CoeffProductF_AVX512_loop_1:
	vmulps zmm1,zmm0,ZMMWORD ptr[r10]
	vmulps zmm2,zmm0,ZMMWORD ptr[r10+64]
	vmulps zmm3,zmm0,ZMMWORD ptr[r10+128]
	vmulps zmm4,zmm0,ZMMWORD ptr[r10+192]
	vmulps zmm5,zmm0,ZMMWORD ptr[r10+256]
	vmulps zmm16,zmm0,ZMMWORD ptr[r10+320]
	vmulps zmm17,zmm0,ZMMWORD ptr[r10+384]
	vmulps zmm18,zmm0,ZMMWORD ptr[r10+448]
	vmovaps ZMMWORD ptr[r8],zmm1
	vmovaps ZMMWORD ptr[r8+64],zmm2
	vmovaps ZMMWORD ptr[r8+128],zmm3
	vmovaps ZMMWORD ptr[r8+192],zmm4
	vmovaps ZMMWORD ptr[r8+256],zmm5
	vmovaps ZMMWORD ptr[r8+320],zmm16
	vmovaps ZMMWORD ptr[r8+384],zmm17
	vmovaps ZMMWORD ptr[r8+448],zmm18
	add r10,rax
	add r8,rax
	dec ecx
	jnz short CoeffProductF_AVX512_loop_1

CoeffProductF_AVX512_1:
	test edx,4
	jz short CoeffProductF_AVX512_2

	vmulps zmm1,zmm0,ZMMWORD ptr[r10]
	vmulps zmm2,zmm0,ZMMWORD ptr[r10+64]
	vmulps zmm3,zmm0,ZMMWORD ptr[r10+128]
	vmulps zmm4,zmm0,ZMMWORD ptr[r10+192]
	vmovaps ZMMWORD ptr[r8],zmm1
	vmovaps ZMMWORD ptr[r8+64],zmm2
	vmovaps ZMMWORD ptr[r8+128],zmm3
	vmovaps ZMMWORD ptr[r8+192],zmm4
	add r10,256
	add r8,256

CoeffProductF_AVX512_2:
	test edx,2
	jz short CoeffProductF_AVX512_3

	vmulps zmm1,zmm0,ZMMWORD ptr[r10]
	vmulps zmm2,zmm0,ZMMWORD ptr[r10+64]
	vmovaps ZMMWORD ptr[r8],zmm1
	vmovaps ZMMWORD ptr[r8+64],zmm2
	add r10,128
	add r8,128

CoeffProductF_AVX512_3:
	test edx,1
	jz short CoeffProductF_AVX512_4

	vmulps zmm1,zmm0,ZMMWORD ptr[r10]
	vmovaps ZMMWORD ptr[r8],zmm1

CoeffProductF_AVX512_4:

	vzeroupper

	ret

CoeffProductF_AVX512 endp


;CoeffProduct2F_AVX512 proc coeff_a:dword,coeff_b:dword,lgth:word
; coeff_a = rcx
; coeff_b = rdx
; lgth = r8d

CoeffProduct2F_AVX512 proc public frame

	.endprolog

	vbroadcastss zmm0,dword ptr[rcx]

	mov r9,rdx 		; coeff_b
	mov ecx,r8d		; lgth
	mov edx,r8d		; lgth
	mov rax,512

	shr ecx,3
	jz short CoeffProduct2F_AVX512_1

CoeffProduct2F_AVX512_loop_1:
	vmulps zmm1,zmm0,ZMMWORD ptr[r9]
	vmulps zmm2,zmm0,ZMMWORD ptr[r9+64]
	vmulps zmm3,zmm0,ZMMWORD ptr[r9+128]
	vmulps zmm4,zmm0,ZMMWORD ptr[r9+192]
	vmulps zmm5,zmm0,ZMMWORD ptr[r9+256]
	vmulps zmm16,zmm0,ZMMWORD ptr[r9+320]
	vmulps zmm17,zmm0,ZMMWORD ptr[r9+384]
	vmulps zmm18,zmm0,ZMMWORD ptr[r9+448]
	vmovaps ZMMWORD ptr[r9],zmm1
	vmovaps ZMMWORD ptr[r9+64],zmm2
	vmovaps ZMMWORD ptr[r9+128],zmm3
	vmovaps ZMMWORD ptr[r9+192],zmm4
	vmovaps ZMMWORD ptr[r9+256],zmm5
	vmovaps ZMMWORD ptr[r9+320],zmm16
	vmovaps ZMMWORD ptr[r9+384],zmm17
	vmovaps ZMMWORD ptr[r9+448],zmm18
	add r9,rax
	dec ecx
	jnz short CoeffProduct2F_AVX512_loop_1

CoeffProduct2F_AVX512_1:
	test edx,4
	jz short CoeffProduct2F_AVX512_2

	vmulps zmm1,zmm0,ZMMWORD ptr[r9]
	vmulps zmm2,zmm0,ZMMWORD ptr[r9+64]
	vmulps zmm3,zmm0,ZMMWORD ptr[r9+128]
	vmulps zmm4,zmm0,ZMMWORD ptr[r9+192]
	vmovaps ZMMWORD ptr[r9],zmm1
	vmovaps ZMMWORD ptr[r9+64],zmm2
	vmovaps ZMMWORD ptr[r9+128],zmm3
	vmovaps ZMMWORD ptr[r9+192],zmm4
	add r9,256

CoeffProduct2F_AVX512_2:
	test edx,2
	jz short CoeffProduct2F_AVX512_3

	vmulps zmm1,zmm0,ZMMWORD ptr[r9]
	vmulps zmm2,zmm0,ZMMWORD ptr[r9+64]
	vmovaps ZMMWORD ptr[r9],zmm1
	vmovaps ZMMWORD ptr[r9+64],zmm2
	add r9,128

CoeffProduct2F_AVX512_3:
	test edx,1
	jz short CoeffProduct2F_AVX512_4

	vmulps zmm1,zmm0,ZMMWORD ptr[r9]
	vmovaps ZMMWORD ptr[r9],zmm1

CoeffProduct2F_AVX512_4:

	vzeroupper

	ret
	
CoeffProduct2F_AVX512 endp	


;CoeffProductD_AVX512 proc coeff_a:dword,coeff_b:dword,coeff_c:dword,lgth:word
; coeff_a = rcx
; coeff_b = rdx
; coeff_c = r8
; lgth = r9d

CoeffProductD_AVX512 proc public frame

	.endprolog
	
	vbroadcastsd zmm0,qword ptr[rcx]

	mov r10,rdx 	; coeff_b
	mov edx,r9d		; lgth
	mov ecx,r9d		; lgth
	mov rax,512

	shr ecx,3
	jz short CoeffProductD_AVX512_1
	
CoeffProductD_AVX512_loop_1:
	vmulpd zmm1,zmm0,ZMMWORD ptr[r10]
	vmulpd zmm2,zmm0,ZMMWORD ptr[r10+64]
	vmulpd zmm3,zmm0,ZMMWORD ptr[r10+128]
	vmulpd zmm4,zmm0,ZMMWORD ptr[r10+192]
	vmulpd zmm5,zmm0,ZMMWORD ptr[r10+256]
	vmulpd zmm16,zmm0,ZMMWORD ptr[r10+320]
	vmulpd zmm17,zmm0,ZMMWORD ptr[r10+384]
	vmulpd zmm18,zmm0,ZMMWORD ptr[r10+448]
	vmovapd ZMMWORD ptr[r8],zmm1
	vmovapd ZMMWORD ptr[r8+64],zmm2
	vmovapd ZMMWORD ptr[r8+128],zmm3
	vmovapd ZMMWORD ptr[r8+192],zmm4
	vmovapd ZMMWORD ptr[r8+256],zmm5
	vmovapd ZMMWORD ptr[r8+320],zmm16
	vmovapd ZMMWORD ptr[r8+384],zmm17
	vmovapd ZMMWORD ptr[r8+448],zmm18
	add r10,rax
	add r8,rax
	dec ecx
	jnz short CoeffProductD_AVX512_loop_1

CoeffProductD_AVX512_1:
	test edx,4
	jz short CoeffProductD_AVX512_2

	vmulpd zmm1,zmm0,ZMMWORD ptr[r10]
	vmulpd zmm2,zmm0,ZMMWORD ptr[r10+64]
	vmulpd zmm3,zmm0,ZMMWORD ptr[r10+128]
	vmulpd zmm4,zmm0,ZMMWORD ptr[r10+192]
	vmovapd ZMMWORD ptr[r8],zmm1
	vmovapd ZMMWORD ptr[r8+64],zmm2
	vmovapd ZMMWORD ptr[r8+128],zmm3
	vmovapd ZMMWORD ptr[r8+192],zmm4
	add r10,256
	add r8,256

CoeffProductD_AVX512_2:
	test edx,2
	jz short CoeffProductD_AVX512_3

	vmulpd zmm1,zmm0,ZMMWORD ptr[r10]
	vmulpd zmm2,zmm0,ZMMWORD ptr[r10+64]
	vmovapd ZMMWORD ptr[r8],zmm1
	vmovapd ZMMWORD ptr[r8+64],zmm2
	add r10,128
	add r8,128

CoeffProductD_AVX512_3:
	test edx,1
	jz short CoeffProductD_AVX512_4

	vmulpd zmm1,zmm0,ZMMWORD ptr[r10]
	vmovapd ZMMWORD ptr[r8],zmm1

CoeffProductD_AVX512_4:

	vzeroupper

	ret

CoeffProductD_AVX512 endp	


;CoeffProduct2D_AVX512 proc coeff_a:dword,coeff_b:dword,lgth:word
; coeff_a = rcx
; coeff_b = rdx
; lgth = r8d

CoeffProduct2D_AVX512 proc public frame

	.endprolog
	
	vbroadcastsd zmm0,qword ptr[rcx]

	mov r9,rdx	 	; coeff_b
	mov ecx,r8d		; lgth
	mov edx,r8d		; lgth
	mov rax,512

	shr ecx,3
	jz short CoeffProduct2D_AVX512_1

CoeffProduct2D_AVX512_loop_1:
	vmulpd zmm1,zmm0,ZMMWORD ptr[r9]
	vmulpd zmm2,zmm0,ZMMWORD ptr[r9+64]
	vmulpd zmm3,zmm0,ZMMWORD ptr[r9+128]
	vmulpd zmm4,zmm0,ZMMWORD ptr[r9+192]
	vmulpd zmm5,zmm0,ZMMWORD ptr[r9+256]
	vmulpd zmm16,zmm0,ZMMWORD ptr[r9+320]
	vmulpd zmm17,zmm0,ZMMWORD ptr[r9+384]
	vmulpd zmm18,zmm0,ZMMWORD ptr[r9+448]
	vmovapd ZMMWORD ptr[r9],zmm1
	vmovapd ZMMWORD ptr[r9+64],zmm2
	vmovapd ZMMWORD ptr[r9+128],zmm3
	vmovapd ZMMWORD ptr[r9+192],zmm4
	vmovapd ZMMWORD ptr[r9+256],zmm5
	vmovapd ZMMWORD ptr[r9+320],zmm16
	vmovapd ZMMWORD ptr[r9+384],zmm17
	vmovapd ZMMWORD ptr[r9+448],zmm18
	add r9,rax
	dec ecx
	jnz short CoeffProduct2D_AVX512_loop_1

CoeffProduct2D_AVX512_1:
	test edx,4
	jz short CoeffProduct2D_AVX512_2

	vmulpd zmm1,zmm0,ZMMWORD ptr[r9]
	vmulpd zmm2,zmm0,ZMMWORD ptr[r9+64]
	vmulpd zmm3,zmm0,ZMMWORD ptr[r9+128]
	vmulpd zmm4,zmm0,ZMMWORD ptr[r9+192]
	vmovapd ZMMWORD ptr[r9],zmm1
	vmovapd ZMMWORD ptr[r9+64],zmm2
	vmovapd ZMMWORD ptr[r9+128],zmm3
	vmovapd ZMMWORD ptr[r9+192],zmm4
	add r9,256

CoeffProduct2D_AVX512_2:
	test edx,2
	jz short CoeffProduct2D_AVX512_3

	vmulpd zmm1,zmm0,ZMMWORD ptr[r9]
	vmulpd zmm2,zmm0,ZMMWORD ptr[r9+64]
	vmovapd ZMMWORD ptr[r9],zmm1
	vmovapd ZMMWORD ptr[r9+64],zmm2
	add r9,128

CoeffProduct2D_AVX512_3:
	test edx,1
	jz short CoeffProduct2D_AVX512_4

	vmulpd zmm1,zmm0,ZMMWORD ptr[r9]
	vmovapd ZMMWORD ptr[r9],zmm1

CoeffProduct2D_AVX512_4:

	vzeroupper

	ret

CoeffProduct2D_AVX512 endp


;CoeffAddProductF_AVX512 proc coeff_a:dword,coeff_b:dword,coeff_c:dword,lgth:word
; coeff_a = rcx
; coeff_b = rdx
; coeff_c = r8
; lgth = r9d

CoeffAddProductF_AVX512 proc public frame

	.endprolog

	vbroadcastss zmm0,dword ptr[rcx]

	mov r10,rdx 	; coeff_b
	mov edx,r9d		; lgth
	mov ecx,r9d		; lgth
	mov rax,256

	shr ecx,2
	jz short CoeffAddProductF_AVX512_1

CoeffAddProductF_AVX512_loop_1:
	vmulps zmm1,zmm0,ZMMWORD ptr[r10]
	vmulps zmm2,zmm0,ZMMWORD ptr[r10+64]
	vmulps zmm3,zmm0,ZMMWORD ptr[r10+128]
	vmulps zmm4,zmm0,ZMMWORD ptr[r10+192]
	vaddps zmm1,zmm1,ZMMWORD ptr[r8]
	vaddps zmm2,zmm2,ZMMWORD ptr[r8+64]
	vaddps zmm3,zmm3,ZMMWORD ptr[r8+128]
	vaddps zmm4,zmm4,ZMMWORD ptr[r8+192]
	vmovaps ZMMWORD ptr[r8],zmm1
	vmovaps ZMMWORD ptr[r8+64],zmm2
	vmovaps ZMMWORD ptr[r8+128],zmm3
	vmovaps ZMMWORD ptr[r8+192],zmm4
	add r10,rax
	add r8,rax
	dec ecx
	jnz short CoeffAddProductF_AVX512_loop_1

CoeffAddProductF_AVX512_1:
	test edx,2
	jz short CoeffAddProductF_AVX512_2

	vmulps zmm1,zmm0,ZMMWORD ptr[r10]
	vmulps zmm2,zmm0,ZMMWORD ptr[r10+64]
	vaddps zmm1,zmm1,ZMMWORD ptr[r8]
	vaddps zmm2,zmm2,ZMMWORD ptr[r8+64]
	vmovaps ZMMWORD ptr[r8],zmm1
	vmovaps ZMMWORD ptr[r8+64],zmm2
	add r10,128
	add r8,128

CoeffAddProductF_AVX512_2:
	test edx,1
	jz short CoeffAddProductF_AVX512_3

	vmulps zmm1,zmm0,ZMMWORD ptr[r10]
	vaddps zmm1,zmm1,ZMMWORD ptr[r8]
	vmovaps ZMMWORD ptr[r8],zmm1

CoeffAddProductF_AVX512_3:

	vzeroupper

	ret

CoeffAddProductF_AVX512 endp


;CoeffAddProductD_AVX512 proc coeff_a:dword,coeff_b:dword,coeff_c:dword,lgth:word
; coeff_a = rcx
; coeff_b = rdx
; coeff_c = r8
; lgth = r9d

CoeffAddProductD_AVX512 proc public frame

	.endprolog

	vbroadcastsd zmm0,qword ptr[rcx]

	mov r10,rdx 	; coeff_b
	mov edx,r9d		; lgth
	mov ecx,r9d		; lgth
	mov rax,256

	shr ecx,2
	jz short CoeffAddProductD_AVX512_1

CoeffAddProductD_AVX512_loop_1:
	vmulpd zmm1,zmm0,ZMMWORD ptr[r10]
	vmulpd zmm2,zmm0,ZMMWORD ptr[r10+64]
	vmulpd zmm3,zmm0,ZMMWORD ptr[r10+128]
	vmulpd zmm4,zmm0,ZMMWORD ptr[r10+192]
	vaddpd zmm1,zmm1,ZMMWORD ptr[r8]
	vaddpd zmm2,zmm2,ZMMWORD ptr[r8+64]
	vaddpd zmm3,zmm3,ZMMWORD ptr[r8+128]
	vaddpd zmm4,zmm4,ZMMWORD ptr[r8+192]
	vmovapd ZMMWORD ptr[r8],zmm1
	vmovapd ZMMWORD ptr[r8+64],zmm2
	vmovapd ZMMWORD ptr[r8+128],zmm3
	vmovapd ZMMWORD ptr[r8+192],zmm4
	add r10,rax
	add r8,rax
	dec ecx
	jnz short CoeffAddProductD_AVX512_loop_1

CoeffAddProductD_AVX512_1:
	test edx,2
	jz short CoeffAddProductD_AVX512_2

	vmulpd zmm1,zmm0,ZMMWORD ptr[r10]
	vmulpd zmm2,zmm0,ZMMWORD ptr[r10+64]
	vaddpd zmm1,zmm1,ZMMWORD ptr[r8]
	vaddpd zmm2,zmm2,ZMMWORD ptr[r8+64]
	vmovapd ZMMWORD ptr[r8],zmm1
	vmovapd ZMMWORD ptr[r8+64],zmm2
	add r10,128
	add r8,128

CoeffAddProductD_AVX512_2:
	test edx,1
	jz short CoeffAddProductD_AVX512_3

	vmulpd zmm1,zmm0,ZMMWORD ptr[r10]
	vaddpd zmm1,zmm1,ZMMWORD ptr[r8]
	vmovapd ZMMWORD ptr[r8],zmm1

CoeffAddProductD_AVX512_3:

	vzeroupper

	ret

CoeffAddProductD_AVX512 endp


;CoeffAddF_AVX512 proc coeff_a:dword,coeff_b:dword,coeff_c:dword,lgth:word
; coeff_a = rcx
; coeff_b = rdx
; coeff_c = r8
; lgth = r9d

CoeffAddF_AVX512 proc public frame

	.endprolog

	vbroadcastss zmm0,dword ptr[rcx]

	mov r10,rdx 	; coeff_b
	mov edx,r9d		; lgth
	mov ecx,r9d		; lgth
	mov rax,512

	shr ecx,3
	jz short CoeffAddF_AVX512_1

CoeffAddF_AVX512_loop_1:
	vaddps zmm1,zmm0,ZMMWORD ptr[r10]
	vaddps zmm2,zmm0,ZMMWORD ptr[r10+64]
	vaddps zmm3,zmm0,ZMMWORD ptr[r10+128]
	vaddps zmm4,zmm0,ZMMWORD ptr[r10+192]
	vaddps zmm5,zmm0,ZMMWORD ptr[r10+256]
	vaddps zmm16,zmm0,ZMMWORD ptr[r10+320]
	vaddps zmm17,zmm0,ZMMWORD ptr[r10+384]
	vaddps zmm18,zmm0,ZMMWORD ptr[r10+448]
	vmovaps ZMMWORD ptr[r8],zmm1
	vmovaps ZMMWORD ptr[r8+64],zmm2
	vmovaps ZMMWORD ptr[r8+128],zmm3
	vmovaps ZMMWORD ptr[r8+192],zmm4
	vmovaps ZMMWORD ptr[r8+256],zmm5
	vmovaps ZMMWORD ptr[r8+320],zmm16
	vmovaps ZMMWORD ptr[r8+384],zmm17
	vmovaps ZMMWORD ptr[r8+448],zmm18
	add r10,rax
	add r8,rax
	dec ecx
	jnz short CoeffAddF_AVX512_loop_1

CoeffAddF_AVX512_1:
	test edx,4
	jz short CoeffAddF_AVX512_2

	vaddps zmm1,zmm0,ZMMWORD ptr[r10]
	vaddps zmm2,zmm0,ZMMWORD ptr[r10+64]
	vaddps zmm3,zmm0,ZMMWORD ptr[r10+128]
	vaddps zmm4,zmm0,ZMMWORD ptr[r10+192]
	vmovaps ZMMWORD ptr[r8],zmm1
	vmovaps ZMMWORD ptr[r8+64],zmm2
	vmovaps ZMMWORD ptr[r8+128],zmm3
	vmovaps ZMMWORD ptr[r8+192],zmm4
	add r10,256
	add r8,256

CoeffAddF_AVX512_2:
	test edx,2
	jz short CoeffAddF_AVX512_3

	vaddps zmm1,zmm0,ZMMWORD ptr[r10]
	vaddps zmm2,zmm0,ZMMWORD ptr[r10+64]
	vmovaps ZMMWORD ptr[r8],zmm1
	vmovaps ZMMWORD ptr[r8+64],zmm2
	add r10,128
	add r8,128

CoeffAddF_AVX512_3:
	test edx,1
	jz short CoeffAddF_AVX512_4

	vaddps zmm1,zmm0,ZMMWORD ptr[r10]
	vmovaps ZMMWORD ptr[r8],zmm1

CoeffAddF_AVX512_4:

	vzeroupper

	ret

CoeffAddF_AVX512 endp	


;CoeffAdd2F_AVX512 proc coeff_a:dword,coeff_b:dword,lgth:word
; coeff_a = rcx
; coeff_b = rdx
; lgth = r8d

CoeffAdd2F_AVX512 proc public frame

	.endprolog

	vbroadcastss zmm0,dword ptr[rcx]

	mov r9,rdx 		; coeff_b
	mov ecx,r8d		; lgth
	mov edx,r8d		; lgth
	mov rax,512

	shr ecx,3
	jz short CoeffAdd2F_AVX512_1

CoeffAdd2F_AVX512_loop_1:
	vaddps zmm1,zmm0,ZMMWORD ptr[r9]
	vaddps zmm2,zmm0,ZMMWORD ptr[r9+64]
	vaddps zmm3,zmm0,ZMMWORD ptr[r9+128]
	vaddps zmm4,zmm0,ZMMWORD ptr[r9+192]
	vaddps zmm5,zmm0,ZMMWORD ptr[r9+256]
	vaddps zmm16,zmm0,ZMMWORD ptr[r9+320]
	vaddps zmm17,zmm0,ZMMWORD ptr[r9+384]
	vaddps zmm18,zmm0,ZMMWORD ptr[r9+448]
	vmovaps ZMMWORD ptr[r9],zmm1
	vmovaps ZMMWORD ptr[r9+64],zmm2
	vmovaps ZMMWORD ptr[r9+128],zmm3
	vmovaps ZMMWORD ptr[r9+192],zmm4
	vmovaps ZMMWORD ptr[r9+256],zmm5
	vmovaps ZMMWORD ptr[r9+320],zmm16
	vmovaps ZMMWORD ptr[r9+384],zmm17
	vmovaps ZMMWORD ptr[r9+448],zmm18
	add r9,rax
	dec ecx
	jnz short CoeffAdd2F_AVX512_loop_1

CoeffAdd2F_AVX512_1:
	test edx,4
	jz short CoeffAdd2F_AVX512_2

	vaddps zmm1,zmm0,ZMMWORD ptr[r9]
	vaddps zmm2,zmm0,ZMMWORD ptr[r9+64]
	vaddps zmm3,zmm0,ZMMWORD ptr[r9+128]
	vaddps zmm4,zmm0,ZMMWORD ptr[r9+192]
	vmovaps ZMMWORD ptr[r9],zmm1
	vmovaps ZMMWORD ptr[r9+64],zmm2
	vmovaps ZMMWORD ptr[r9+128],zmm3
	vmovaps ZMMWORD ptr[r9+192],zmm4
	add r9,256

CoeffAdd2F_AVX512_2:
	test edx,2
	jz short CoeffAdd2F_AVX512_3

	vaddps zmm1,zmm0,ZMMWORD ptr[r9]
	vaddps zmm2,zmm0,ZMMWORD ptr[r9+64]
	vmovaps ZMMWORD ptr[r9],zmm1
	vmovaps ZMMWORD ptr[r9+64],zmm2
	add r9,128

CoeffAdd2F_AVX512_3:
	test edx,1
	jz short CoeffAdd2F_AVX512_4

	vaddps zmm1,zmm0,ZMMWORD ptr[r9]
	vmovaps ZMMWORD ptr[r9],zmm1

CoeffAdd2F_AVX512_4:

	vzeroupper

	ret

CoeffAdd2F_AVX512 endp


;CoeffAddD_AVX512 proc coeff_a:dword,coeff_b:dword,coeff_c:dword,lgth:word
; coeff_a = rcx
; coeff_b = rdx
; coeff_c = r8
; lgth = r9d

CoeffAddD_AVX512 proc public frame

	.endprolog

	vbroadcastsd zmm0,qword ptr[rcx]

	mov r10,rdx 	; coeff_b
	mov edx,r9d		; lgth
	mov ecx,r9d		; lgth
	mov rax,512

	shr ecx,3
	jz short CoeffAddD_AVX512_1

CoeffAddD_AVX512_loop_1:
	vaddpd zmm1,zmm0,ZMMWORD ptr[r10]
	vaddpd zmm2,zmm0,ZMMWORD ptr[r10+64]
	vaddpd zmm3,zmm0,ZMMWORD ptr[r10+128]
	vaddpd zmm4,zmm0,ZMMWORD ptr[r10+192]
	vaddpd zmm5,zmm0,ZMMWORD ptr[r10+256]
	vaddpd zmm16,zmm0,ZMMWORD ptr[r10+320]
	vaddpd zmm17,zmm0,ZMMWORD ptr[r10+384]
	vaddpd zmm18,zmm0,ZMMWORD ptr[r10+448]
	vmovapd ZMMWORD ptr[r8],zmm1
	vmovapd ZMMWORD ptr[r8+64],zmm2
	vmovapd ZMMWORD ptr[r8+128],zmm3
	vmovapd ZMMWORD ptr[r8+192],zmm4
	vmovapd ZMMWORD ptr[r8+256],zmm5
	vmovapd ZMMWORD ptr[r8+320],zmm16
	vmovapd ZMMWORD ptr[r8+384],zmm17
	vmovapd ZMMWORD ptr[r8+448],zmm18
	add r10,rax
	add r8,rax
	dec ecx
	jnz short CoeffAddD_AVX512_loop_1

CoeffAddD_AVX512_1:
	test edx,4
	jz short CoeffAddD_AVX512_2

	vaddpd zmm1,zmm0,ZMMWORD ptr[r10]
	vaddpd zmm2,zmm0,ZMMWORD ptr[r10+64]
	vaddpd zmm3,zmm0,ZMMWORD ptr[r10+128]
	vaddpd zmm4,zmm0,ZMMWORD ptr[r10+192]
	vmovapd ZMMWORD ptr[r8],zmm1
	vmovapd ZMMWORD ptr[r8+64],zmm2
	vmovapd ZMMWORD ptr[r8+128],zmm3
	vmovapd ZMMWORD ptr[r8+192],zmm4
	add r10,256
	add r8,256

CoeffAddD_AVX512_2:
	test edx,2
	jz short CoeffAddD_AVX512_3

	vaddpd zmm1,zmm0,ZMMWORD ptr[r10]
	vaddpd zmm2,zmm0,ZMMWORD ptr[r10+64]
	vmovapd ZMMWORD ptr[r8],zmm1
	vmovapd ZMMWORD ptr[r8+64],zmm2
	add r10,128
	add r8,128

CoeffAddD_AVX512_3:
	test edx,1
	jz short CoeffAddD_AVX512_4

	vaddpd zmm1,zmm0,ZMMWORD ptr[r10]
	vmovapd ZMMWORD ptr[r8],zmm1

CoeffAddD_AVX512_4:

	vzeroupper

	ret

CoeffAddD_AVX512 endp	
	

;CoeffAdd2D_AVX512 proc coeff_a:dword,coeff_b:dword,lgth:word
; coeff_a = rcx
; coeff_b = rdx
; lgth = r8d

CoeffAdd2D_AVX512 proc public frame

	.endprolog

	vbroadcastsd zmm0,qword ptr[rcx]

	mov r9,rdx	 	; coeff_b
	mov ecx,r8d		; lgth
	mov edx,r8d		; lgth
	mov rax,512

	shr ecx,3
	jz short CoeffAdd2D_AVX512_1

CoeffAdd2D_AVX512_loop_1:
	vaddpd zmm1,zmm0,ZMMWORD ptr[r9]
	vaddpd zmm2,zmm0,ZMMWORD ptr[r9+64]
	vaddpd zmm3,zmm0,ZMMWORD ptr[r9+128]
	vaddpd zmm4,zmm0,ZMMWORD ptr[r9+192]
	vaddpd zmm5,zmm0,ZMMWORD ptr[r9+256]
	vaddpd zmm16,zmm0,ZMMWORD ptr[r9+320]
	vaddpd zmm17,zmm0,ZMMWORD ptr[r9+384]
	vaddpd zmm18,zmm0,ZMMWORD ptr[r9+448]
	vmovapd ZMMWORD ptr[r9],zmm1
	vmovapd ZMMWORD ptr[r9+64],zmm2
	vmovapd ZMMWORD ptr[r9+128],zmm3
	vmovapd ZMMWORD ptr[r9+192],zmm4
	vmovapd ZMMWORD ptr[r9+256],zmm5
	vmovapd ZMMWORD ptr[r9+320],zmm16
	vmovapd ZMMWORD ptr[r9+384],zmm17
	vmovapd ZMMWORD ptr[r9+448],zmm18
	add r9,rax
	dec ecx
	jnz short CoeffAdd2D_AVX512_loop_1

CoeffAdd2D_AVX512_1:
	test edx,4
	jz short CoeffAdd2D_AVX512_2

	vaddpd zmm1,zmm0,ZMMWORD ptr[r9]
	vaddpd zmm2,zmm0,ZMMWORD ptr[r9+64]
	vaddpd zmm3,zmm0,ZMMWORD ptr[r9+128]
	vaddpd zmm4,zmm0,ZMMWORD ptr[r9+192]
	vmovapd ZMMWORD ptr[r9],zmm1
	vmovapd ZMMWORD ptr[r9+64],zmm2
	vmovapd ZMMWORD ptr[r9+128],zmm3
	vmovapd ZMMWORD ptr[r9+192],zmm4
	add r9,256

CoeffAdd2D_AVX512_2:
	test edx,2
	jz short CoeffAdd2D_AVX512_3

	vaddpd zmm1,zmm0,ZMMWORD ptr[r9]
	vaddpd zmm2,zmm0,ZMMWORD ptr[r9+64]
	vmovapd ZMMWORD ptr[r9],zmm1
	vmovapd ZMMWORD ptr[r9+64],zmm2
	add r9,128

CoeffAdd2D_AVX512_3:
	test edx,1
	jz short CoeffAdd2D_AVX512_4

	vaddpd zmm1,zmm0,ZMMWORD ptr[r9]
	vmovapd ZMMWORD ptr[r9],zmm1

CoeffAdd2D_AVX512_4:

	vzeroupper

	ret

CoeffAdd2D_AVX512 endp


;CoeffSubF_AVX512 proc coeff_a:dword,coeff_b:dword,coeff_c:dword,lgth:word
; coeff_a = rcx
; coeff_b = rdx
; coeff_c = r8
; lgth = r9d

CoeffSubF_AVX512 proc public frame

	.endprolog

	vbroadcastss zmm0,dword ptr[rcx]

	mov r10,rdx 	; coeff_b
	mov edx,r9d		; lgth
	mov ecx,r9d		; lgth
	mov rax,512

	shr ecx,3
	jz short CoeffSubF_AVX512_1
	
CoeffSubF_AVX512_loop_1:
	vsubps zmm1,zmm0,ZMMWORD ptr[r10]
	vsubps zmm2,zmm0,ZMMWORD ptr[r10+64]
	vsubps zmm3,zmm0,ZMMWORD ptr[r10+128]
	vsubps zmm4,zmm0,ZMMWORD ptr[r10+192]
	vsubps zmm5,zmm0,ZMMWORD ptr[r10+256]
	vsubps zmm16,zmm0,ZMMWORD ptr[r10+320]
	vsubps zmm17,zmm0,ZMMWORD ptr[r10+384]
	vsubps zmm18,zmm0,ZMMWORD ptr[r10+448]
	vmovaps ZMMWORD ptr[r8],zmm1
	vmovaps ZMMWORD ptr[r8+64],zmm2
	vmovaps ZMMWORD ptr[r8+128],zmm3
	vmovaps ZMMWORD ptr[r8+192],zmm4
	vmovaps ZMMWORD ptr[r8+256],zmm5
	vmovaps ZMMWORD ptr[r8+320],zmm16
	vmovaps ZMMWORD ptr[r8+384],zmm17
	vmovaps ZMMWORD ptr[r8+448],zmm18
	add r10,rax
	add r8,rax
	dec ecx
	jnz short CoeffSubF_AVX512_loop_1

CoeffSubF_AVX512_1:
	test edx,4
	jz short CoeffSubF_AVX512_2

	vsubps zmm1,zmm0,ZMMWORD ptr[r10]
	vsubps zmm2,zmm0,ZMMWORD ptr[r10+64]
	vsubps zmm3,zmm0,ZMMWORD ptr[r10+128]
	vsubps zmm4,zmm0,ZMMWORD ptr[r10+192]
	vmovaps ZMMWORD ptr[r8],zmm1
	vmovaps ZMMWORD ptr[r8+64],zmm2
	vmovaps ZMMWORD ptr[r8+128],zmm3
	vmovaps ZMMWORD ptr[r8+192],zmm4
	add r10,256
	add r8,256

CoeffSubF_AVX512_2:
	test edx,2
	jz short CoeffSubF_AVX512_3

	vsubps zmm1,zmm0,ZMMWORD ptr[r10]
	vsubps zmm2,zmm0,ZMMWORD ptr[r10+64]
	vmovaps ZMMWORD ptr[r8],zmm1
	vmovaps ZMMWORD ptr[r8+64],zmm2
	add r10,128
	add r8,128

CoeffSubF_AVX512_3:
	test edx,1
	jz short CoeffSubF_AVX512_4

	vsubps zmm1,zmm0,ZMMWORD ptr[r10]
	vmovaps ZMMWORD ptr[r8],zmm1

CoeffSubF_AVX512_4:

	vzeroupper

	ret

CoeffSubF_AVX512 endp	


;CoeffSub2F_AVX512 proc coeff_a:dword,coeff_b:dword,lgth:word
; coeff_a = rcx
; coeff_b = rdx
; lgth = r8d

CoeffSub2F_AVX512 proc public frame

	.endprolog

	vbroadcastss zmm0,dword ptr[rcx]

	mov r9,rdx 		; coeff_b
	mov ecx,r8d		; lgth
	mov edx,r8d		; lgth
	mov rax,512

	shr ecx,3
	jz short CoeffSub2F_AVX512_1

CoeffSub2F_AVX512_loop_1:
	vsubps zmm1,zmm0,ZMMWORD ptr[r9]
	vsubps zmm2,zmm0,ZMMWORD ptr[r9+64]
	vsubps zmm3,zmm0,ZMMWORD ptr[r9+128]
	vsubps zmm4,zmm0,ZMMWORD ptr[r9+192]
	vsubps zmm5,zmm0,ZMMWORD ptr[r9+256]
	vsubps zmm16,zmm0,ZMMWORD ptr[r9+320]
	vsubps zmm17,zmm0,ZMMWORD ptr[r9+384]
	vsubps zmm18,zmm0,ZMMWORD ptr[r9+448]
	vmovaps ZMMWORD ptr[r9],zmm1
	vmovaps ZMMWORD ptr[r9+64],zmm2
	vmovaps ZMMWORD ptr[r9+128],zmm3
	vmovaps ZMMWORD ptr[r9+192],zmm4
	vmovaps ZMMWORD ptr[r9+256],zmm5
	vmovaps ZMMWORD ptr[r9+320],zmm16
	vmovaps ZMMWORD ptr[r9+384],zmm17
	vmovaps ZMMWORD ptr[r9+448],zmm18
	add r9,rax
	dec ecx
	jnz short CoeffSub2F_AVX512_loop_1

CoeffSub2F_AVX512_1:
	test edx,4
	jz short CoeffSub2F_AVX512_2

	vsubps zmm1,zmm0,ZMMWORD ptr[r9]
	vsubps zmm2,zmm0,ZMMWORD ptr[r9+64]
	vsubps zmm3,zmm0,ZMMWORD ptr[r9+128]
	vsubps zmm4,zmm0,ZMMWORD ptr[r9+192]
	vmovaps ZMMWORD ptr[r9],zmm1
	vmovaps ZMMWORD ptr[r9+64],zmm2
	vmovaps ZMMWORD ptr[r9+128],zmm3
	vmovaps ZMMWORD ptr[r9+192],zmm4
	add r9,256

CoeffSub2F_AVX512_2:
	test edx,2
	jz short CoeffSub2F_AVX512_3

	vsubps zmm1,zmm0,ZMMWORD ptr[r9]
	vsubps zmm2,zmm0,ZMMWORD ptr[r9+64]
	vmovaps ZMMWORD ptr[r9],zmm1
	vmovaps ZMMWORD ptr[r9+64],zmm2
	add r9,128

CoeffSub2F_AVX512_3:
	test edx,1
	jz short CoeffSub2F_AVX512_4

	vsubps zmm1,zmm0,ZMMWORD ptr[r9]
	vmovaps ZMMWORD ptr[r9],zmm1

CoeffSub2F_AVX512_4:

	vzeroupper

	ret

CoeffSub2F_AVX512 endp	


;CoeffSubD_AVX512 proc coeff_a:dword,coeff_b:dword,coeff_c:dword,lgth:word
; coeff_a = rcx
; coeff_b = rdx
; coeff_c = r8
; lgth = r9d

CoeffSubD_AVX512 proc public frame

	.endprolog

	vbroadcastsd zmm0,qword ptr[rcx]

	mov r10,rdx 	; coeff_b
	mov edx,r9d		; lgth
	mov ecx,r9d		; lgth
	mov rax,512

	shr ecx,3
	jz short CoeffSubD_AVX512_1

CoeffSubD_AVX512_loop_1:
	vsubpd zmm1,zmm0,ZMMWORD ptr[r10]
	vsubpd zmm2,zmm0,ZMMWORD ptr[r10+64]
	vsubpd zmm3,zmm0,ZMMWORD ptr[r10+128]
	vsubpd zmm4,zmm0,ZMMWORD ptr[r10+192]
	vsubpd zmm5,zmm0,ZMMWORD ptr[r10+256]
	vsubpd zmm16,zmm0,ZMMWORD ptr[r10+320]
	vsubpd zmm17,zmm0,ZMMWORD ptr[r10+384]
	vsubpd zmm18,zmm0,ZMMWORD ptr[r10+448]
	vmovapd ZMMWORD ptr[r8],zmm1
	vmovapd ZMMWORD ptr[r8+64],zmm2
	vmovapd ZMMWORD ptr[r8+128],zmm3
	vmovapd ZMMWORD ptr[r8+192],zmm4
	vmovapd ZMMWORD ptr[r8+256],zmm5
	vmovapd ZMMWORD ptr[r8+320],zmm16
	vmovapd ZMMWORD ptr[r8+384],zmm17
	vmovapd ZMMWORD ptr[r8+448],zmm18
	add r10,rax
	add r8,rax
	dec ecx
	jnz short CoeffSubD_AVX512_loop_1

CoeffSubD_AVX512_1:
	test edx,4
	jz short CoeffSubD_AVX512_2

	vsubpd zmm1,zmm0,ZMMWORD ptr[r10]
	vsubpd zmm2,zmm0,ZMMWORD ptr[r10+64]
	vsubpd zmm3,zmm0,ZMMWORD ptr[r10+128]
	vsubpd zmm4,zmm0,ZMMWORD ptr[r10+192]
	vmovapd ZMMWORD ptr[r8],zmm1
	vmovapd ZMMWORD ptr[r8+64],zmm2
	vmovapd ZMMWORD ptr[r8+128],zmm3
	vmovapd ZMMWORD ptr[r8+192],zmm4
	add r10,256
	add r8,256

CoeffSubD_AVX512_2:
	test edx,2
	jz short CoeffSubD_AVX512_3

	vsubpd zmm1,zmm0,ZMMWORD ptr[r10]
	vsubpd zmm2,zmm0,ZMMWORD ptr[r10+64]
	vmovapd ZMMWORD ptr[r8],zmm1
	vmovapd ZMMWORD ptr[r8+64],zmm2
	add r10,128
	add r8,128

CoeffSubD_AVX512_3:
	test edx,1
	jz short CoeffSubD_AVX512_4

	vsubpd zmm1,zmm0,ZMMWORD ptr[r10]
	vmovapd ZMMWORD ptr[r8],zmm1

CoeffSubD_AVX512_4:

	vzeroupper

	ret

CoeffSubD_AVX512 endp	


;CoeffSub2D_AVX512 proc coeff_a:dword,coeff_b:dword,lgth:word
; coeff_a = rcx
; coeff_b = rdx
; lgth = r8d

CoeffSub2D_AVX512 proc public frame

	.endprolog

	vbroadcastsd zmm0,qword ptr[rcx]

	mov r9,rdx	 	; coeff_b
	mov ecx,r8d		; lgth
	mov edx,r8d		; lgth
	mov rax,512

	shr ecx,3
	jz short CoeffSub2D_AVX512_1

CoeffSub2D_AVX512_loop_1:
	vsubpd zmm1,zmm0,ZMMWORD ptr[r9]
	vsubpd zmm2,zmm0,ZMMWORD ptr[r9+64]
	vsubpd zmm3,zmm0,ZMMWORD ptr[r9+128]
	vsubpd zmm4,zmm0,ZMMWORD ptr[r9+192]
	vsubpd zmm5,zmm0,ZMMWORD ptr[r9+256]
	vsubpd zmm16,zmm0,ZMMWORD ptr[r9+320]
	vsubpd zmm17,zmm0,ZMMWORD ptr[r9+384]
	vsubpd zmm18,zmm0,ZMMWORD ptr[r9+448]
	vmovapd ZMMWORD ptr[r9],zmm1
	vmovapd ZMMWORD ptr[r9+64],zmm2
	vmovapd ZMMWORD ptr[r9+128],zmm3
	vmovapd ZMMWORD ptr[r9+192],zmm4
	vmovapd ZMMWORD ptr[r9+256],zmm5
	vmovapd ZMMWORD ptr[r9+320],zmm16
	vmovapd ZMMWORD ptr[r9+384],zmm17
	vmovapd ZMMWORD ptr[r9+448],zmm18
	add r9,rax
	dec ecx
	jnz short CoeffSub2D_AVX512_loop_1

CoeffSub2D_AVX512_1:
	test edx,4
	jz short CoeffSub2D_AVX512_2

	vsubpd zmm1,zmm0,ZMMWORD ptr[r9]
	vsubpd zmm2,zmm0,ZMMWORD ptr[r9+64]
	vsubpd zmm3,zmm0,ZMMWORD ptr[r9+128]
	vsubpd zmm4,zmm0,ZMMWORD ptr[r9+192]
	vmovapd ZMMWORD ptr[r9],zmm1
	vmovapd ZMMWORD ptr[r9+64],zmm2
	vmovapd ZMMWORD ptr[r9+128],zmm3
	vmovapd ZMMWORD ptr[r9+192],zmm4
	add r9,256

CoeffSub2D_AVX512_2:
	test edx,2
	jz short CoeffSub2D_AVX512_3

	vsubpd zmm1,zmm0,ZMMWORD ptr[r9]
	vsubpd zmm2,zmm0,ZMMWORD ptr[r9+64]
	vmovapd ZMMWORD ptr[r9],zmm1
	vmovapd ZMMWORD ptr[r9+64],zmm2
	add r9,128

CoeffSub2D_AVX512_3:
	test edx,1
	jz short CoeffSub2D_AVX512_4

	vsubpd zmm1,zmm0,ZMMWORD ptr[r9]
	vmovapd ZMMWORD ptr[r9],zmm1

CoeffSub2D_AVX512_4:

	vzeroupper

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

	vxorps zmm0,zmm0,zmm0

	shr ecx,2
	jz short VectorNorme2F_AVX512_1

VectorNorme2F_AVX512_loop_1:
	vmovaps zmm1,ZMMWORD ptr[r9]
	vmovaps zmm2,ZMMWORD ptr[r9+64]
	vmovaps zmm3,ZMMWORD ptr[r9+128]
	vmovaps zmm4,ZMMWORD ptr[r9+192]

	vmulps zmm1,zmm1,zmm1
	vmulps zmm2,zmm2,zmm2
	vmulps zmm3,zmm3,zmm3
	vmulps zmm4,zmm4,zmm4

	vaddps zmm1,zmm1,zmm2
	vaddps zmm3,zmm3,zmm4
	vaddps zmm1,zmm1,zmm3
	add r9,rax
	vaddps zmm0,zmm0,zmm1
	dec ecx
	jnz short VectorNorme2F_AVX512_loop_1

VectorNorme2F_AVX512_1:
	test r8d,2
	jz short VectorNorme2F_AVX512_2

	vmovaps zmm1,ZMMWORD ptr[r9]
	vmovaps zmm2,ZMMWORD ptr[r9+64]
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

	vxorps zmm0,zmm0,zmm0

	shr ecx,2
	jz short VectorNorme2D_AVX512_1

VectorNorme2D_AVX512_loop_1:
	vmovapd zmm1,ZMMWORD ptr[r9]
	vmovapd zmm2,ZMMWORD ptr[r9+64]
	vmovapd zmm3,ZMMWORD ptr[r9+128]
	vmovapd zmm4,ZMMWORD ptr[r9+192]

	vmulpd zmm1,zmm1,zmm1
	vmulpd zmm2,zmm2,zmm2
	vmulpd zmm3,zmm3,zmm3
	vmulpd zmm4,zmm4,zmm4

	vaddpd zmm1,zmm1,zmm2
	vaddpd zmm3,zmm3,zmm4
	vaddpd zmm1,zmm1,zmm3
	add r9,rax
	vaddpd zmm0,zmm0,zmm1
	dec ecx
	jnz short VectorNorme2D_AVX512_loop_1

VectorNorme2D_AVX512_1:
	test r8d,2
	jz short VectorNorme2D_AVX512_2

	vmovapd zmm1,ZMMWORD ptr[r9]
	vmovapd zmm2,ZMMWORD ptr[r9+64]
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

	.endprolog

	mov r10,rcx 	; coeff_x
	mov r11,rdx 	; coeff_y
	mov ecx,r9d		; lgth
	mov edx,r9d		; lgth
	mov rax,512

	vxorps zmm0,zmm0,zmm0

	shr ecx,3
	jz VectorDist2F_AVX512_1

VectorDist2F_AVX512_loop_1:
	vmovaps zmm1,ZMMWORD ptr[r10]
	vmovaps zmm2,ZMMWORD ptr[r10+64]
	vmovaps zmm3,ZMMWORD ptr[r10+128]
	vmovaps zmm4,ZMMWORD ptr[r10+192]
	vmovaps zmm5,ZMMWORD ptr[r10+256]
	vmovaps zmm16,ZMMWORD ptr[r10+320]
	vmovaps zmm17,ZMMWORD ptr[r10+384]
	vmovaps zmm18,ZMMWORD ptr[r10+448]

	vsubps zmm1,zmm1,ZMMWORD ptr[r11]
	vsubps zmm2,zmm2,ZMMWORD ptr[r11+64]
	vsubps zmm3,zmm3,ZMMWORD ptr[r11+128]
	vsubps zmm4,zmm4,ZMMWORD ptr[r11+192]
	vsubps zmm5,zmm5,ZMMWORD ptr[r11+256]
	vsubps zmm16,zmm16,ZMMWORD ptr[r11+320]
	vsubps zmm17,zmm17,ZMMWORD ptr[r11+384]
	vsubps zmm18,zmm18,ZMMWORD ptr[r11+448]

	vmulps zmm1,zmm1,zmm1
	vmulps zmm2,zmm2,zmm2
	vmulps zmm3,zmm3,zmm3
	vmulps zmm4,zmm4,zmm4
	vmulps zmm5,zmm5,zmm5
	vmulps zmm16,zmm16,zmm16
	vmulps zmm17,zmm17,zmm17
	vmulps zmm18,zmm18,zmm18

	vaddps zmm1,zmm1,zmm2
	vaddps zmm3,zmm3,zmm4
	vaddps zmm5,zmm5,zmm16
	vaddps zmm17,zmm17,zmm18
	vaddps zmm1,zmm1,zmm3
	vaddps zmm5,zmm5,zmm17
	add r10,rax
	vaddps zmm1,zmm1,zmm5
	add r11,rax
	vaddps zmm0,zmm0,zmm1

	dec ecx
	jnz VectorDist2F_AVX512_loop_1

VectorDist2F_AVX512_1:
	test edx,4
	jz short VectorDist2F_AVX512_2

	vmovaps zmm1,ZMMWORD ptr[r10]
	vmovaps zmm2,ZMMWORD ptr[r10+64]
	vmovaps zmm3,ZMMWORD ptr[r10+128]
	vmovaps zmm4,ZMMWORD ptr[r10+192]

	vsubps zmm1,zmm1,ZMMWORD ptr[r11]
	vsubps zmm2,zmm2,ZMMWORD ptr[r11+64]
	vsubps zmm3,zmm3,ZMMWORD ptr[r11+128]
	vsubps zmm4,zmm4,ZMMWORD ptr[r11+192]

	vmulps zmm1,zmm1,zmm1
	vmulps zmm2,zmm2,zmm2
	vmulps zmm3,zmm3,zmm3
	vmulps zmm4,zmm4,zmm4

	vaddps zmm1,zmm1,zmm2
	vaddps zmm3,zmm3,zmm4
	add r10,256
	vaddps zmm1,zmm1,zmm3
	add r11,256
	vaddps zmm0,zmm0,zmm1

VectorDist2F_AVX512_2:
	test edx,2
	jz short VectorDist2F_AVX512_3

	vmovaps zmm1,ZMMWORD ptr[r10]
	vmovaps zmm2,ZMMWORD ptr[r10+64]
	vsubps zmm1,zmm1,ZMMWORD ptr[r11]
	vsubps zmm2,zmm2,ZMMWORD ptr[r11+64]
	vmulps zmm1,zmm1,zmm1
	vmulps zmm2,zmm2,zmm2

	add r10,128
	vaddps zmm1,zmm1,zmm2
	add r11,128
	vaddps zmm0,zmm0,zmm1

VectorDist2F_AVX512_3:
	test edx,1
	jz short VectorDist2F_AVX512_4

	vmovaps zmm1,ZMMWORD ptr[r10]
	vsubps zmm1,zmm1,ZMMWORD ptr[r11]
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
	vmovss dword ptr[r8],xmm0

	vzeroupper

	ret

VectorDist2F_AVX512 endp


;VectorDist2D_AVX512 proc coeff_x:dword,coeff_y:dword,result:dword,lgth:word
; coeff_x = rcx
; coeff_y = rdx
; result = r8
; lgth = r9d

VectorDist2D_AVX512 proc public frame

	.endprolog

	mov r10,rcx 	; coeff_x
	mov r11,rdx 	; coeff_y
	mov ecx,r9d		; lgth
	mov edx,r9d		; lgth
	mov rax,512

	vxorpd zmm0,zmm0,zmm0

	shr ecx,3
	jz VectorDist2D_AVX512_1

VectorDist2D_AVX512_loop_1:
	vmovapd zmm1,ZMMWORD ptr[r10]
	vmovapd zmm2,ZMMWORD ptr[r10+64]
	vmovapd zmm3,ZMMWORD ptr[r10+128]
	vmovapd zmm4,ZMMWORD ptr[r10+192]
	vmovapd zmm5,ZMMWORD ptr[r10+256]
	vmovapd zmm16,ZMMWORD ptr[r10+320]
	vmovapd zmm17,ZMMWORD ptr[r10+384]
	vmovapd zmm18,ZMMWORD ptr[r10+448]

	vsubpd zmm1,zmm1,ZMMWORD ptr[r11]
	vsubpd zmm2,zmm2,ZMMWORD ptr[r11+64]
	vsubpd zmm3,zmm3,ZMMWORD ptr[r11+128]
	vsubpd zmm4,zmm4,ZMMWORD ptr[r11+192]
	vsubpd zmm5,zmm5,ZMMWORD ptr[r11+256]
	vsubpd zmm16,zmm16,ZMMWORD ptr[r11+320]
	vsubpd zmm17,zmm17,ZMMWORD ptr[r11+384]
	vsubpd zmm18,zmm18,ZMMWORD ptr[r11+448]

	vmulpd zmm1,zmm1,zmm1
	vmulpd zmm2,zmm2,zmm2
	vmulpd zmm3,zmm3,zmm3
	vmulpd zmm4,zmm4,zmm4
	vmulpd zmm5,zmm5,zmm5
	vmulpd zmm16,zmm16,zmm16
	vmulpd zmm17,zmm17,zmm17
	vmulpd zmm18,zmm18,zmm18

	vaddpd zmm1,zmm1,zmm2
	vaddpd zmm3,zmm3,zmm4
	vaddpd zmm5,zmm5,zmm16
	vaddpd zmm17,zmm17,zmm18
	vaddpd zmm1,zmm1,zmm3
	vaddpd zmm5,zmm5,zmm17
	add r10,rax
	vaddpd zmm1,zmm1,zmm5
	add r11,rax
	vaddpd zmm0,zmm0,zmm1
	
	dec ecx
	jnz VectorDist2D_AVX512_loop_1

VectorDist2D_AVX512_1:
	test edx,4
	jz short VectorDist2D_AVX512_2

	vmovapd zmm1,ZMMWORD ptr[r10]
	vmovapd zmm2,ZMMWORD ptr[r10+64]
	vmovapd zmm3,ZMMWORD ptr[r10+128]
	vmovapd zmm4,ZMMWORD ptr[r10+129]

	vsubpd zmm1,zmm1,ZMMWORD ptr[r11]
	vsubpd zmm2,zmm2,ZMMWORD ptr[r11+64]
	vsubpd zmm3,zmm3,ZMMWORD ptr[r11+128]
	vsubpd zmm4,zmm4,ZMMWORD ptr[r11+192]

	vmulpd zmm1,zmm1,zmm1
	vmulpd zmm2,zmm2,zmm2
	vmulpd zmm3,zmm3,zmm3
	vmulpd zmm4,zmm4,zmm4

	vaddpd zmm1,zmm1,zmm2
	vaddpd zmm3,zmm3,zmm4
	add r10,256
	vaddpd zmm1,zmm1,zmm3
	add r11,256
	vaddpd zmm0,zmm0,zmm1

VectorDist2D_AVX512_2:
	test edx,2
	jz short VectorDist2D_AVX512_3

	vmovapd zmm1,ZMMWORD ptr[r10]
	vmovapd zmm2,ZMMWORD ptr[r10+64]

	vsubpd zmm1,zmm1,ZMMWORD ptr[r11]
	vsubpd zmm2,zmm2,ZMMWORD ptr[r11+64]

	vmulpd zmm1,zmm1,zmm1
	vmulpd zmm2,zmm2,zmm2

	add r10,128
	vaddpd zmm1,zmm1,zmm2
	add r11,128
	vaddpd zmm0,zmm0,zmm1

VectorDist2D_AVX512_3:
	test edx,1
	jz short VectorDist2D_AVX512_4

	vmovapd zmm1,ZMMWORD ptr[r10]
	vsubpd zmm1,zmm1,ZMMWORD ptr[r11]
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
	vmovsd qword ptr[r8],xmm0

	vzeroupper

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
	
	vxorps zmm0,zmm0,zmm0

	shr ecx,2
	jz short VectorNormeF_AVX512_1

VectorNormeF_AVX512_loop_1:
	vmovaps zmm1,ZMMWORD ptr[r9]
	vmovaps zmm2,ZMMWORD ptr[r9+64]
	vmovaps zmm3,ZMMWORD ptr[r9+128]
	vmovaps zmm4,ZMMWORD ptr[r9+192]

	vmulps zmm1,zmm1,zmm1
	vmulps zmm2,zmm2,zmm2
	vmulps zmm3,zmm3,zmm3
	vmulps zmm4,zmm4,zmm4

	vaddps zmm1,zmm1,zmm2
	vaddps zmm3,zmm3,zmm4
	vaddps zmm1,zmm1,zmm3
	add r9,rax
	vaddps zmm0,zmm0,zmm1

	dec ecx
	jnz short VectorNormeF_AVX512_loop_1

VectorNormeF_AVX512_1:
	test r8d,2
	jz short VectorNormeF_AVX512_2

	vmovaps zmm1,ZMMWORD ptr[r9]
	vmovaps zmm2,ZMMWORD ptr[r9+64]
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
	
	vxorpd zmm0,zmm0,zmm0

	shr ecx,2
	jz short VectorNormeD_AVX512_1

VectorNormeD_AVX512_loop_1:
	vmovapd zmm1,ZMMWORD ptr[r9]
	vmovapd zmm2,ZMMWORD ptr[r9+64]
	vmovapd zmm3,ZMMWORD ptr[r9+128]
	vmovapd zmm4,ZMMWORD ptr[r9+192]

	vmulpd zmm1,zmm1,zmm1
	vmulpd zmm2,zmm2,zmm2
	vmulpd zmm3,zmm3,zmm3
	vmulpd zmm4,zmm4,zmm4

	vaddpd zmm1,zmm1,zmm2
	vaddpd zmm3,zmm3,zmm4
	vaddpd zmm1,zmm1,zmm3
	add r9,rax
	vaddpd zmm0,zmm0,zmm1

	dec ecx
	jnz short VectorNormeD_AVX512_loop_1

VectorNormeD_AVX512_1:
	test r8d,2
	jz short VectorNormeD_AVX512_2

	vmovapd zmm1,ZMMWORD ptr[r9]
	vmovapd zmm2,ZMMWORD ptr[r9+64]
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

	.endprolog

	mov r10,rcx
	mov rax,256
	mov ecx,r9d

	vxorps zmm0,zmm0,zmm0

	shr ecx,2
	jz short VectorDistF_AVX512_1

VectorDistF_AVX512_loop_1:
	vmovaps zmm1,ZMMWORD ptr[r10]
	vmovaps zmm2,ZMMWORD ptr[r10+64]
	vmovaps zmm3,ZMMWORD ptr[r10+128]
	vmovaps zmm4,ZMMWORD ptr[r10+192]

	vsubps zmm1,zmm1,ZMMWORD ptr[rdx]
	vsubps zmm2,zmm2,ZMMWORD ptr[rdx+64]
	vsubps zmm3,zmm3,ZMMWORD ptr[rdx+128]
	vsubps zmm4,zmm4,ZMMWORD ptr[rdx+192]

	vmulps zmm1,zmm1,zmm1
	vmulps zmm2,zmm2,zmm2
	vmulps zmm3,zmm3,zmm3
	vmulps zmm4,zmm4,zmm4

	vaddps zmm1,zmm1,zmm2
	vaddps zmm3,zmm3,zmm4
	add r10,rax
	vaddps zmm1,zmm1,zmm3
	add rdx,rax
	vaddps zmm0,zmm0,zmm1

	dec ecx
	jnz short VectorDistF_AVX512_loop_1

VectorDistF_AVX512_1:
	test r9d,2
	jz short VectorDistF_AVX512_2

	vmovaps zmm1,ZMMWORD ptr[r10]
	vmovaps zmm2,ZMMWORD ptr[r10+64]
	vsubps zmm1,zmm1,ZMMWORD ptr[rdx]
	vsubps zmm2,zmm2,ZMMWORD ptr[rdx+64]
	vmulps zmm1,zmm1,zmm1
	vmulps zmm2,zmm2,zmm2

	add r10,128
	vaddps zmm1,zmm1,zmm2
	add rdx,128
	vaddps zmm0,zmm0,zmm1

VectorDistF_AVX512_2:
	test r9d,1
	jz short VectorDistF_AVX512_3

	vmovaps zmm1,ZMMWORD ptr[r10]
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

	ret

VectorDistF_AVX512 endp


;VectorDistD_AVX512 proc coeff_x:dword,coeff_y:dword,result:dword,lgth:word
; coeff_x = rcx
; coeff_y = rdx
; result = r8
; lgth = r9d

VectorDistD_AVX512 proc public frame

	.endprolog

	mov r10,rcx
	mov rax,256
	mov ecx,r9d

	vxorpd zmm0,zmm0,zmm0

	shr ecx,2
	jz short VectorDistD_AVX512_1

VectorDistD_AVX512_loop_1:
	vmovapd zmm1,ZMMWORD ptr[r10]
	vmovapd zmm2,ZMMWORD ptr[r10+64]
	vmovapd zmm3,ZMMWORD ptr[r10+128]
	vmovapd zmm4,ZMMWORD ptr[r10+192]

	vsubpd zmm1,zmm1,ZMMWORD ptr[rdx]
	vsubpd zmm2,zmm2,ZMMWORD ptr[rdx+64]
	vsubpd zmm3,zmm3,ZMMWORD ptr[rdx+128]
	vsubpd zmm4,zmm4,ZMMWORD ptr[rdx+192]

	vmulpd zmm1,zmm1,zmm1
	vmulpd zmm2,zmm2,zmm2
	vmulpd zmm3,zmm3,zmm3
	vmulpd zmm4,zmm4,zmm4

	vaddpd zmm1,zmm1,zmm2
	vaddpd zmm3,zmm3,zmm4
	add r10,rax
	vaddpd zmm1,zmm1,zmm3
	add rdx,rax
	vaddpd zmm0,zmm0,zmm1

	dec ecx
	jnz short VectorDistD_AVX512_loop_1

VectorDistD_AVX512_1:
	test r9d,2
	jz short VectorDistD_AVX512_2

	vmovapd zmm1,ZMMWORD ptr[r10]
	vmovapd zmm2,ZMMWORD ptr[r10+64]
	vsubpd zmm1,zmm1,ZMMWORD ptr[rdx]
	vsubpd zmm2,zmm2,ZMMWORD ptr[rdx+64]
	vmulpd zmm1,zmm1,zmm1
	vmulpd zmm2,zmm2,zmm2

	add r10,128
	vaddpd zmm1,zmm1,zmm2
	add rdx,128
	vaddpd zmm0,zmm0,zmm1

VectorDistD_AVX512_2:
	test r9d,1
	jz short VectorDistD_AVX512_3

	vmovapd zmm1,ZMMWORD ptr[r10]
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
	mov ecx,r8d

	vxorps zmm0,zmm0,zmm0
	vmovaps zmm5,ZMMWORD ptr sign_bits_f_32

	shr ecx,2
	jz short VectorNorme1F_AVX512_1

VectorNorme1F_AVX512_loop_1:
	vandps zmm1,zmm5,ZMMWORD ptr[r9]
	vandps zmm2,zmm5,ZMMWORD ptr[r9+64]
	vandps zmm3,zmm5,ZMMWORD ptr[r9+128]
	vandps zmm4,zmm5,ZMMWORD ptr[r9+192]

	vaddps zmm1,zmm1,zmm2
	vaddps zmm3,zmm3,zmm4
	vaddps zmm1,zmm1,zmm3
	add r9,rax
	vaddps zmm0,zmm0,zmm1

	dec ecx
	jnz short VectorNorme1F_AVX512_loop_1

VectorNorme1F_AVX512_1:
	test r8d,2
	jz short VectorNorme1F_AVX512_2

	vandps zmm1,zmm5,ZMMWORD ptr[r9]
	vandps zmm2,zmm5,ZMMWORD ptr[r9+64]

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
	mov ecx,r8d

	vxorpd zmm0,zmm0,zmm0
	vmovapd zmm5,ZMMWORD ptr sign_bits_f_64

	shr ecx,2
	jz short VectorNorme1D_AVX512_1

VectorNorme1D_AVX512_loop_1:
	vandpd zmm1,zmm5,ZMMWORD ptr[r9]
	vandpd zmm2,zmm5,ZMMWORD ptr[r9+64]
	vandpd zmm3,zmm5,ZMMWORD ptr[r9+128]
	vandpd zmm4,zmm5,ZMMWORD ptr[r9+192]

	vaddpd zmm1,zmm1,zmm2
	vaddpd zmm3,zmm3,zmm4
	vaddpd zmm1,zmm1,zmm3
	add r9,rax
	vaddpd zmm0,zmm0,zmm1

	dec ecx
	jnz short VectorNorme1D_AVX512_loop_1

VectorNorme1D_AVX512_1:
	test r8d,2
	jz short VectorNorme1D_AVX512_2

	vandpd zmm1,zmm5,ZMMWORD ptr[r9]
	vandpd zmm2,zmm5,ZMMWORD ptr[r9+64]

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

	.endprolog

	mov r10,rcx
	mov rax,256
	mov ecx,r9d

	vxorps zmm0,zmm0,zmm0
	vmovaps zmm5,ZMMWORD ptr sign_bits_f_32

	shr ecx,2
	jz short VectorDist1F_AVX512_1

VectorDist1F_AVX512_loop_1:
	vmovaps zmm1,ZMMWORD ptr[r10]
	vmovaps zmm2,ZMMWORD ptr[r10+64]
	vmovaps zmm3,ZMMWORD ptr[r10+128]
	vmovaps zmm4,ZMMWORD ptr[r10+192]

	vsubps zmm1,zmm1,ZMMWORD ptr[rdx]
	vsubps zmm2,zmm2,ZMMWORD ptr[rdx+64]
	vsubps zmm3,zmm3,ZMMWORD ptr[rdx+128]
	vsubps zmm4,zmm4,ZMMWORD ptr[rdx+192]

	vandps zmm1,zmm1,zmm5
	vandps zmm2,zmm2,zmm5
	vandps zmm3,zmm3,zmm5
	vandps zmm4,zmm4,zmm5

	vaddps zmm1,zmm1,zmm2
	vaddps zmm3,zmm3,zmm4
	add r10,rax
	vaddps zmm1,zmm1,zmm3
	add rdx,rax
	vaddps zmm0,zmm0,zmm1

	dec ecx
	jnz short VectorDist1F_AVX512_loop_1

VectorDist1F_AVX512_1:
	test r9d,2
	jz short VectorDist1F_AVX512_2

	vmovaps zmm1,ZMMWORD ptr[r10]
	vmovaps zmm2,ZMMWORD ptr[r10+64]
	vsubps zmm1,zmm1,ZMMWORD ptr[rdx]
	vsubps zmm2,zmm2,ZMMWORD ptr[rdx+64]
	vandps zmm1,zmm1,zmm5
	vandps zmm2,zmm2,zmm5

	add r10,128
	vaddps zmm1,zmm1,zmm2
	add rdx,128
	vaddps zmm0,zmm0,zmm1

VectorDist1F_AVX512_2:
	test r9d,1
	jz short VectorDist1F_AVX512_3

	vmovaps zmm1,ZMMWORD ptr[r10]
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

	ret

VectorDist1F_AVX512 endp


;VectorDist1D_AVX512 proc coeff_x:dword,coeff_y:dword,result:dword,lgth:word
; coeff_x = rcx
; coeff_y = rdx
; result = r8
; lgth = r9d

VectorDist1D_AVX512 proc public frame

	.endprolog

	mov r10,rcx
	mov rax,256
	mov ecx,r9d

	vxorpd zmm0,zmm0,zmm0
	vmovapd zmm5,ZMMWORD ptr sign_bits_f_64

	shr ecx,2
	jz short VectorDist1D_AVX512_1

VectorDist1D_AVX512_loop_1:
	vmovapd zmm1,ZMMWORD ptr[r10]
	vmovapd zmm2,ZMMWORD ptr[r10+64]
	vmovapd zmm3,ZMMWORD ptr[r10+128]
	vmovapd zmm4,ZMMWORD ptr[r10+192]

	vsubpd zmm1,zmm1,ZMMWORD ptr[rdx]
	vsubpd zmm2,zmm2,ZMMWORD ptr[rdx+64]
	vsubpd zmm3,zmm3,ZMMWORD ptr[rdx+128]
	vsubpd zmm4,zmm4,ZMMWORD ptr[rdx+192]

	vandpd zmm1,zmm1,zmm5
	vandpd zmm2,zmm2,zmm5
	vandpd zmm3,zmm3,zmm5
	vandpd zmm4,zmm4,zmm5

	vaddpd zmm1,zmm1,zmm2
	vaddpd zmm3,zmm3,zmm4
	add r10,rax
	vaddpd zmm1,zmm1,zmm3
	add rdx,rax
	vaddpd zmm0,zmm0,zmm1

	dec ecx
	jnz short VectorDist1D_AVX512_loop_1

VectorDist1D_AVX512_1:
	test r9d,2
	jz short VectorDist1D_AVX512_2

	vmovapd zmm1,ZMMWORD ptr[r10]
	vmovapd zmm2,ZMMWORD ptr[r10+64]
	vsubpd zmm1,zmm1,ZMMWORD ptr[rdx]
	vsubpd zmm2,zmm2,ZMMWORD ptr[rdx+64]
	vandpd zmm1,zmm1,zmm5
	vandpd zmm2,zmm2,zmm5

	add r10,128
	vaddpd zmm1,zmm1,zmm2
	add rdx,128
	vaddpd zmm0,zmm0,zmm1

VectorDist1D_AVX512_2:
	test r9d,1
	jz short VectorDist1D_AVX512_3

	vmovapd zmm1,ZMMWORD ptr[r10]
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

	ret

VectorDist1D_AVX512 endp	

		
;VectorProductF_AVX512 proc coeff_a:dword,coeff_x:dword,result:dword,lgth:word
; coeff_a = rcx
; coeff_x = rdx
; result = r8
; lgth = r9d

VectorProductF_AVX512 proc public frame

	.endprolog

	mov r10,rcx
	mov rax,256
	mov ecx,r9d

	vxorps zmm0,zmm0,zmm0

	shr ecx,2
	jz short VectorProductF_AVX512_1

VectorProductF_AVX512_loop_1:
	vmovaps zmm1,ZMMWORD ptr[r10]
	vmovaps zmm2,ZMMWORD ptr[r10+64]
	vmovaps zmm3,ZMMWORD ptr[r10+128]
	vmovaps zmm4,ZMMWORD ptr[r10+192]

	vmulps zmm1,zmm1,ZMMWORD ptr[rdx]
	vmulps zmm2,zmm2,ZMMWORD ptr[rdx+64]
	vmulps zmm3,zmm3,ZMMWORD ptr[rdx+128]
	vmulps zmm4,zmm4,ZMMWORD ptr[rdx+192]

	vaddps zmm1,zmm1,zmm2
	vaddps zmm3,zmm3,zmm4
	add r10,rax
	vaddps zmm1,zmm1,zmm3
	add rdx,rax
	vaddps zmm0,zmm0,zmm1

	dec ecx
	jnz short VectorProductF_AVX512_loop_1

VectorProductF_AVX512_1:
	test r9d,2
	jz short VectorProductF_AVX512_2

	vmovaps zmm1,ZMMWORD ptr[r10]
	vmovaps zmm2,ZMMWORD ptr[r10+64]
	vmulps zmm1,zmm1,ZMMWORD ptr[rdx]
	vmulps zmm2,zmm2,ZMMWORD ptr[rdx+64]

	add r10,128
	vaddps zmm1,zmm1,zmm2
	add rdx,128
	vaddps zmm0,zmm0,zmm1


VectorProductF_AVX512_2:
	test r9d,1
	jz short VectorProductF_AVX512_3

	vmovaps zmm1,ZMMWORD ptr[r10]
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

	ret

VectorProductF_AVX512 endp


;VectorProductD_AVX512 proc coeff_a:dword,coeff_x:dword,result:dword,lgth:word
; coeff_a = rcx
; coeff_x = rdx
; result = r8
; lgth = r9d

VectorProductD_AVX512 proc public frame

	.endprolog

	mov r10,rcx
	mov rax,256
	mov ecx,r9d

	vxorpd zmm0,zmm0,zmm0

	shr ecx,2
	jz short VectorProductD_AVX512_1

VectorProductD_AVX512_loop_1:
	vmovapd zmm1,ZMMWORD ptr[r10]
	vmovapd zmm2,ZMMWORD ptr[r10+64]
	vmovapd zmm3,ZMMWORD ptr[r10+128]
	vmovapd zmm4,ZMMWORD ptr[r10+192]

	vmulpd zmm1,zmm1,ZMMWORD ptr[rdx]
	vmulpd zmm2,zmm2,ZMMWORD ptr[rdx+64]
	vmulpd zmm3,zmm3,ZMMWORD ptr[rdx+128]
	vmulpd zmm4,zmm4,ZMMWORD ptr[rdx+192]

	vaddpd zmm1,zmm1,zmm2
	vaddpd zmm3,zmm3,zmm4
	add r10,rax
	vaddpd zmm1,zmm1,zmm3
	add rdx,rax
	vaddpd zmm0,zmm0,zmm1

	dec ecx
	jnz short VectorProductD_AVX512_loop_1

VectorProductD_AVX512_1:
	test r9d,2
	jz short VectorProductD_AVX512_2

	vmovapd zmm1,ZMMWORD ptr[r10]
	vmovapd zmm2,ZMMWORD ptr[r10+64]
	vmulpd zmm1,zmm1,ZMMWORD ptr[rdx]
	vmulpd zmm2,zmm2,ZMMWORD ptr[rdx+64]

	add r10,128
	vaddpd zmm1,zmm1,zmm2
	add rdx,128
	vaddpd zmm0,zmm0,zmm1

VectorProductD_AVX512_2:
	test r9d,1
	jz short VectorProductD_AVX512_3

	vmovapd zmm1,ZMMWORD ptr[r10]
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

	ret

VectorProductD_AVX512 endp	


;VectorAddF_AVX512 proc coeff_a:dword,coeff_b:dword,coeff_c:dword,lgth:word
; coeff_a = rcx
; coeff_b = rdx
; coeff_c = r8
; lgth = r9d

VectorAddF_AVX512 proc public frame

	.endprolog

	mov r10,rcx
	mov rax,256
	mov ecx,r9d

	shr ecx,2
	jz short VectorAddF_AVX512_1

VectorAddF_AVX512_loop_1:
	vmovaps zmm0,ZMMWORD ptr[r10]
	vmovaps zmm1,ZMMWORD ptr[r10+64]
	vmovaps zmm2,ZMMWORD ptr[r10+128]
	vmovaps zmm3,ZMMWORD ptr[r10+192]

	vaddps zmm0,zmm0,ZMMWORD ptr[rdx]
	vaddps zmm1,zmm1,ZMMWORD ptr[rdx+64]
	vaddps zmm2,zmm2,ZMMWORD ptr[rdx+128]
	vaddps zmm3,zmm3,ZMMWORD ptr[rdx+192]

	vmovaps ZMMWORD ptr[r8],zmm0
	vmovaps ZMMWORD ptr[r8+64],zmm1
	vmovaps ZMMWORD ptr[r8+128],zmm2
	vmovaps ZMMWORD ptr[r8+192],zmm3

	add r10,rax
	add rdx,rax
	add r8,rax

	dec ecx
	jnz short VectorAddF_AVX512_loop_1

VectorAddF_AVX512_1:
	test r9d,2
	jz short VectorAddF_AVX512_2

	vmovaps zmm0,ZMMWORD ptr[r10]
	vmovaps zmm1,ZMMWORD ptr[r10+64]
	vaddps zmm0,zmm0,ZMMWORD ptr[rdx]
	vaddps zmm1,zmm1,ZMMWORD ptr[rdx+64]
	vmovaps ZMMWORD ptr[r8],zmm0
	vmovaps ZMMWORD ptr[r8+64],zmm1

	add r10,128
	add rdx,128
	add r8,128

VectorAddF_AVX512_2:
	test r9d,1
	jz short VectorAddF_AVX512_3

	vmovaps zmm0,ZMMWORD ptr[r10]
	vaddps zmm0,zmm0,ZMMWORD ptr[rdx]
	vmovaps ZMMWORD ptr[r8],zmm0

VectorAddF_AVX512_3:
	vzeroupper

	ret

VectorAddF_AVX512 endp


;VectorSubF_AVX512 proc coeff_a:dword,coeff_b:dword,coeff_c:dword,lgth:word
; coeff_a = rcx
; coeff_b = rdx
; coeff_c = r8
; lgth = r9d

VectorSubF_AVX512 proc public frame

	.endprolog

	mov r10,rcx
	mov rax,256
	mov ecx,r9d

	shr ecx,2
	jz short VectorSubF_AVX512_1

VectorSubF_AVX512_loop_1:
	vmovaps zmm0,ZMMWORD ptr[r10]
	vmovaps zmm1,ZMMWORD ptr[r10+64]
	vmovaps zmm2,ZMMWORD ptr[r10+128]
	vmovaps zmm3,ZMMWORD ptr[r10+192]

	vsubps zmm0,zmm0,ZMMWORD ptr[rdx]
	vsubps zmm1,zmm1,ZMMWORD ptr[rdx+64]
	vsubps zmm2,zmm2,ZMMWORD ptr[rdx+128]
	vsubps zmm3,zmm3,ZMMWORD ptr[rdx+192]

	vmovaps ZMMWORD ptr[r8],zmm0
	vmovaps ZMMWORD ptr[r8+64],zmm1
	vmovaps ZMMWORD ptr[r8+128],zmm2
	vmovaps ZMMWORD ptr[r8+192],zmm3

	add r10,rax
	add rdx,rax
	add r8,rax
	
	dec ecx
	jnz short VectorSubF_AVX512_loop_1

VectorSubF_AVX512_1:
	test r9d,2
	jz short VectorSubF_AVX512_2

	vmovaps zmm0,ZMMWORD ptr[r10]
	vmovaps zmm1,ZMMWORD ptr[r10+64]
	vsubps zmm0,zmm0,ZMMWORD ptr[rdx]
	vsubps zmm1,zmm1,ZMMWORD ptr[rdx+64]
	vmovaps ZMMWORD ptr[r8],zmm0
	vmovaps ZMMWORD ptr[r8+64],zmm1

	add r10,128
	add rdx,128
	add r8,128

VectorSubF_AVX512_2:
	test r9d,1
	jz short VectorSubF_AVX512_3

	vmovaps zmm0,ZMMWORD ptr[r10]
	vsubps zmm0,zmm0,ZMMWORD ptr[rdx]
	vmovaps ZMMWORD ptr[r8],zmm0

VectorSubF_AVX512_3:
	vzeroupper

	ret

VectorSubF_AVX512 endp


;VectorProdF_AVX512 proc coeff_a:dword,coeff_b:dword,coeff_c:dword,lgth:word
; coeff_a = rcx
; coeff_b = rdx
; coeff_c = r8
; lgth = r9d

VectorProdF_AVX512 proc public frame

	.endprolog

	mov r10,rcx
	mov rax,256
	mov ecx,r9d

	shr ecx,2
	jz short VectorProdF_AVX512_1

VectorProdF_AVX512_loop_1:
	vmovaps zmm0,ZMMWORD ptr[r10]
	vmovaps zmm1,ZMMWORD ptr[r10+64]
	vmovaps zmm2,ZMMWORD ptr[r10+128]
	vmovaps zmm3,ZMMWORD ptr[r10+192]

	vmulps zmm0,zmm0,ZMMWORD ptr[rdx]
	vmulps zmm1,zmm1,ZMMWORD ptr[rdx+64]
	vmulps zmm2,zmm2,ZMMWORD ptr[rdx+128]
	vmulps zmm3,zmm3,ZMMWORD ptr[rdx+192]

	vmovaps ZMMWORD ptr[r8],zmm0
	vmovaps ZMMWORD ptr[r8+64],zmm1
	vmovaps ZMMWORD ptr[r8+128],zmm2
	vmovaps ZMMWORD ptr[r8+192],zmm3

	add r10,rax
	add rdx,rax
	add r8,rax
	
	dec ecx
	jnz short VectorProdF_AVX512_loop_1

VectorProdF_AVX512_1:
	test r9d,2
	jz short VectorProdF_AVX512_2

	vmovaps zmm0,ZMMWORD ptr[r10]
	vmovaps zmm1,ZMMWORD ptr[r10+64]
	vmulps zmm0,zmm0,ZMMWORD ptr[rdx]
	vmulps zmm1,zmm1,ZMMWORD ptr[rdx+64]
	vmovaps ZMMWORD ptr[r8],zmm0
	vmovaps ZMMWORD ptr[r8+64],zmm1

	add r10,128
	add rdx,128
	add r8,128

VectorProdF_AVX512_2:
	test r9d,1
	jz short VectorProdF_AVX512_3

	vmovaps zmm0,ZMMWORD ptr[r10]
	vmulps zmm0,zmm0,ZMMWORD ptr[rdx]
	vmovaps ZMMWORD ptr[r8],zmm0

VectorProdF_AVX512_3:
	vzeroupper

	ret

VectorProdF_AVX512 endp


;VectorAdd2F_AVX512 proc coeff_a:dword,coeff_b:dword,lgth:word
; coeff_a = rcx
; coeff_b = rdx
; lgth = r8d

VectorAdd2F_AVX512 proc public frame

	.endprolog

	mov r9,rcx
	mov rax,256
	mov ecx,r8d

	shr ecx,2
	jz short VectorAdd2F_AVX512_1

VectorAdd2F_AVX512_loop_1:
	vmovaps zmm0,ZMMWORD ptr[r9]
	vmovaps zmm1,ZMMWORD ptr[r9+64]
	vmovaps zmm2,ZMMWORD ptr[r9+128]
	vmovaps zmm3,ZMMWORD ptr[r9+192]

	vaddps zmm0,zmm0,ZMMWORD ptr[rdx]
	vaddps zmm1,zmm1,ZMMWORD ptr[rdx+64]
	vaddps zmm2,zmm2,ZMMWORD ptr[rdx+128]
	vaddps zmm3,zmm3,ZMMWORD ptr[rdx+192]

	vmovaps ZMMWORD ptr[r9],zmm0
	vmovaps ZMMWORD ptr[r9+64],zmm1
	vmovaps ZMMWORD ptr[r9+128],zmm2
	vmovaps ZMMWORD ptr[r9+192],zmm3

	add rdx,rax
	add r9,rax

	dec ecx
	jnz short VectorAdd2F_AVX512_loop_1

VectorAdd2F_AVX512_1:
	test r8d,2
	jz short VectorAdd2F_AVX512_2

	vmovaps zmm0,ZMMWORD ptr[r9]
	vmovaps zmm1,ZMMWORD ptr[r9+64]
	vaddps zmm0,zmm0,ZMMWORD ptr[rdx]
	vaddps zmm1,zmm1,ZMMWORD ptr[rdx+64]
	vmovaps ZMMWORD ptr[r9],zmm0
	vmovaps ZMMWORD ptr[r9+64],zmm1

	add rdx,128
	add r9,128

VectorAdd2F_AVX512_2:
	test r8d,1
	jz short VectorAdd2F_AVX512_3

	vmovaps zmm0,ZMMWORD ptr[r9]
	vaddps zmm0,zmm0,ZMMWORD ptr[rdx]
	vmovaps ZMMWORD ptr[r9],zmm0

VectorAdd2F_AVX512_3:
	vzeroupper

	ret

VectorAdd2F_AVX512 endp


;VectorSub2F_AVX512 proc coeff_a:dword,coeff_b:dword,lgth:word
; coeff_a = rcx
; coeff_b = rdx
; lgth = r8d

VectorSub2F_AVX512 proc public frame

	.endprolog

	mov r9,rcx
	mov rax,256
	mov ecx,r8d

	shr ecx,2
	jz short VectorSub2F_AVX512_1

VectorSub2F_AVX512_loop_1:
	vmovaps zmm0,ZMMWORD ptr[r9]
	vmovaps zmm1,ZMMWORD ptr[r9+64]
	vmovaps zmm2,ZMMWORD ptr[r9+128]
	vmovaps zmm3,ZMMWORD ptr[r9+192]

	vsubps zmm0,zmm0,ZMMWORD ptr[rdx]
	vsubps zmm1,zmm1,ZMMWORD ptr[rdx+64]
	vsubps zmm2,zmm2,ZMMWORD ptr[rdx+128]
	vsubps zmm3,zmm3,ZMMWORD ptr[rdx+192]

	vmovaps ZMMWORD ptr[r9],zmm0
	vmovaps ZMMWORD ptr[r9+64],zmm1
	vmovaps ZMMWORD ptr[r9+128],zmm2
	vmovaps ZMMWORD ptr[r9+192],zmm3

	add rdx,rax
	add r9,rax
	
	dec ecx
	jnz short VectorSub2F_AVX512_loop_1

VectorSub2F_AVX512_1:
	test r8d,2
	jz short VectorSub2F_AVX512_2

	vmovaps zmm0,ZMMWORD ptr[r9]
	vmovaps zmm1,ZMMWORD ptr[r9+64]
	vsubps zmm0,zmm0,ZMMWORD ptr[rdx]
	vsubps zmm1,zmm1,ZMMWORD ptr[rdx+64]
	vmovaps ZMMWORD ptr[r9],zmm0
	vmovaps ZMMWORD ptr[r9+64],zmm1

	add rdx,128
	add r9,128

VectorSub2F_AVX512_2:
	test r8d,1
	jz short VectorSub2F_AVX512_3

	vmovaps zmm0,ZMMWORD ptr[r9]
	vsubps zmm0,zmm0,ZMMWORD ptr[rdx]
	vmovaps ZMMWORD ptr[r9],zmm0

VectorSub2F_AVX512_3:
	vzeroupper

	ret

VectorSub2F_AVX512 endp


;VectorInvSubF_AVX512 proc coeff_a:dword,coeff_b:dword,lgth:word
; coeff_a = rcx
; coeff_b = rdx
; lgth = r8d

VectorInvSubF_AVX512 proc public frame

	.endprolog

	mov r9,rcx
	mov rax,256
	mov ecx,r8d

	shr ecx,2
	jz short VectorInvSubF_AVX512_1

VectorInvSubF_AVX512_loop_1:
	vmovaps zmm0,ZMMWORD ptr[rdx]
	vmovaps zmm1,ZMMWORD ptr[rdx+64]
	vmovaps zmm2,ZMMWORD ptr[rdx+128]
	vmovaps zmm3,ZMMWORD ptr[rdx+192]

	vsubps zmm0,zmm0,ZMMWORD ptr[r9]
	vsubps zmm1,zmm1,ZMMWORD ptr[r9+64]
	vsubps zmm2,zmm2,ZMMWORD ptr[r9+128]
	vsubps zmm3,zmm3,ZMMWORD ptr[r9+192]

	vmovaps ZMMWORD ptr[r9],zmm0
	vmovaps ZMMWORD ptr[r9+64],zmm1
	vmovaps ZMMWORD ptr[r9+128],zmm2
	vmovaps ZMMWORD ptr[r9+192],zmm3

	add rdx,rax
	add r9,rax
	
	dec ecx
	jnz short VectorInvSubF_AVX512_loop_1

VectorInvSubF_AVX512_1:
	test r8d,2
	jz short VectorInvSubF_AVX512_2

	vmovaps zmm0,ZMMWORD ptr[rdx]
	vmovaps zmm1,ZMMWORD ptr[rdx+64]
	vsubps zmm0,zmm0,ZMMWORD ptr[r9]
	vsubps zmm1,zmm1,ZMMWORD ptr[r9+64]
	vmovaps ZMMWORD ptr[r9],zmm0
	vmovaps ZMMWORD ptr[r9+64],zmm1

	add rdx,128
	add r9,128

VectorInvSubF_AVX512_2:
	test r8d,1
	jz short VectorInvSubF_AVX512_3

	vmovaps zmm0,ZMMWORD ptr[rdx]
	vsubps zmm0,zmm0,ZMMWORD ptr[r9]
	vmovaps ZMMWORD ptr[r9],zmm0

VectorInvSubF_AVX512_3:
	vzeroupper

	ret

VectorInvSubF_AVX512 endp


;VectorProd2F_AVX512 proc coeff_a:dword,coeff_b:dword,lgth:word
; coeff_a = rcx
; coeff_b = rdx
; lgth = r8d

VectorProd2F_AVX512 proc public frame

	.endprolog

	mov r9,rcx
	mov rax,256
	mov ecx,r8d

	shr ecx,2
	jz short VectorProd2F_AVX512_1

VectorProd2F_AVX512_loop_1:
	vmovaps zmm0,ZMMWORD ptr[r9]
	vmovaps zmm1,ZMMWORD ptr[r9+64]
	vmovaps zmm2,ZMMWORD ptr[r9+128]
	vmovaps zmm3,ZMMWORD ptr[r9+192]

	vmulps zmm0,zmm0,ZMMWORD ptr[rdx]
	vmulps zmm1,zmm1,ZMMWORD ptr[rdx+64]
	vmulps zmm2,zmm2,ZMMWORD ptr[rdx+128]
	vmulps zmm3,zmm3,ZMMWORD ptr[rdx+192]

	vmovaps ZMMWORD ptr[r9],zmm0
	vmovaps ZMMWORD ptr[r9+64],zmm1
	vmovaps ZMMWORD ptr[r9+128],zmm2
	vmovaps ZMMWORD ptr[r9+192],zmm3

	add rdx,rax
	add r9,rax
	
	dec ecx
	jnz short VectorProd2F_AVX512_loop_1

VectorProd2F_AVX512_1:
	test r8d,2
	jz short VectorProd2F_AVX512_2

	vmovaps zmm0,ZMMWORD ptr[r9]
	vmovaps zmm1,ZMMWORD ptr[r9+64]
	vmulps zmm0,zmm0,ZMMWORD ptr[rdx]
	vmulps zmm1,zmm1,ZMMWORD ptr[rdx+64]
	vmovaps ZMMWORD ptr[r9],zmm0
	vmovaps ZMMWORD ptr[r9+64],zmm1

	add rdx,128
	add r9,128

VectorProd2F_AVX512_2:
	test r8d,1
	jz short VectorProd2F_AVX512_3

	vmovaps zmm0,ZMMWORD ptr[r9]
	vmulps zmm0,zmm0,ZMMWORD ptr[rdx]
	vmovaps ZMMWORD ptr[r9],zmm0

VectorProd2F_AVX512_3:
	vzeroupper

	ret

VectorProd2F_AVX512 endp


;VectorAddD_AVX512 proc coeff_a:dword,coeff_b:dword,coeff_c:dword,lgth:word
; coeff_a = rcx
; coeff_b = rdx
; coeff_c = r8
; lgth = r9d

VectorAddD_AVX512 proc public frame

	.endprolog

	mov r10,rcx
	mov rax,256
	mov ecx,r9d

	shr ecx,2
	jz short VectorAddD_AVX512_1

VectorAddD_AVX512_loop_1:
	vmovapd zmm0,ZMMWORD ptr[r10]
	vmovapd zmm1,ZMMWORD ptr[r10+64]
	vmovapd zmm2,ZMMWORD ptr[r10+128]
	vmovapd zmm3,ZMMWORD ptr[r10+192]

	vaddpd zmm0,zmm0,ZMMWORD ptr[rdx]
	vaddpd zmm1,zmm1,ZMMWORD ptr[rdx+64]
	vaddpd zmm2,zmm2,ZMMWORD ptr[rdx+128]
	vaddpd zmm3,zmm3,ZMMWORD ptr[rdx+192]

	vmovapd ZMMWORD ptr[r8],zmm0
	vmovapd ZMMWORD ptr[r8+64],zmm1
	vmovapd ZMMWORD ptr[r8+128],zmm2
	vmovapd ZMMWORD ptr[r8+192],zmm3

	add r10,rax
	add rdx,rax
	add r8,rax

	dec ecx
	jnz short VectorAddD_AVX512_loop_1

VectorAddD_AVX512_1:
	test r9d,2
	jz short VectorAddD_AVX512_2

	vmovapd zmm0,ZMMWORD ptr[r10]
	vmovapd zmm1,ZMMWORD ptr[r10+64]
	vaddpd zmm0,zmm0,ZMMWORD ptr[rdx]
	vaddpd zmm1,zmm1,ZMMWORD ptr[rdx+64]
	vmovapd ZMMWORD ptr[r8],zmm0
	vmovapd ZMMWORD ptr[r8+64],zmm1

	add r10,128
	add rdx,128
	add r8,128

VectorAddD_AVX512_2:
	test r9d,1
	jz short VectorAddD_AVX512_3

	vmovapd zmm0,ZMMWORD ptr[r10]
	vaddpd zmm0,zmm0,ZMMWORD ptr[rdx]
	vmovapd ZMMWORD ptr[r8],zmm0

VectorAddD_AVX512_3:
	vzeroupper

	ret

VectorAddD_AVX512 endp


;VectorSubD_AVX512 proc coeff_a:dword,coeff_b:dword,coeff_c:dword,lgth:word
; coeff_a = rcx
; coeff_b = rdx
; coeff_c = r8
; lgth = r9d

VectorSubD_AVX512 proc public frame

	.endprolog

	mov r10,rcx
	mov rax,256
	mov ecx,r9d

	shr ecx,2
	jz short VectorSubD_AVX512_1

VectorSubD_AVX512_loop_1:
	vmovapd zmm0,ZMMWORD ptr[r10]
	vmovapd zmm1,ZMMWORD ptr[r10+64]
	vmovapd zmm2,ZMMWORD ptr[r10+128]
	vmovapd zmm3,ZMMWORD ptr[r10+192]

	vsubpd zmm0,zmm0,ZMMWORD ptr[rdx]
	vsubpd zmm1,zmm1,ZMMWORD ptr[rdx+64]
	vsubpd zmm2,zmm2,ZMMWORD ptr[rdx+128]
	vsubpd zmm3,zmm3,ZMMWORD ptr[rdx+192]

	vmovapd ZMMWORD ptr[r8],zmm0
	vmovapd ZMMWORD ptr[r8+64],zmm1
	vmovapd ZMMWORD ptr[r8+128],zmm2
	vmovapd ZMMWORD ptr[r8+192],zmm3

	add r10,rax
	add rdx,rax
	add r8,rax
	
	dec ecx
	jnz short VectorSubD_AVX512_loop_1

VectorSubD_AVX512_1:
	test r9d,2
	jz short VectorSubD_AVX512_2

	vmovapd zmm0,ZMMWORD ptr[r10]
	vmovapd zmm1,ZMMWORD ptr[r10+64]
	vsubpd zmm0,zmm0,ZMMWORD ptr[rdx]
	vsubpd zmm1,zmm1,ZMMWORD ptr[rdx+64]
	vmovapd ZMMWORD ptr[r8],zmm0
	vmovapd ZMMWORD ptr[r8+64],zmm1

	add r10,128
	add rdx,128
	add r8,128

VectorSubD_AVX512_2:
	test r9d,1
	jz short VectorSubD_AVX512_3

	vmovapd zmm0,ZMMWORD ptr[r10]
	vsubpd zmm0,zmm0,ZMMWORD ptr[rdx]
	vmovapd ZMMWORD ptr[r8],zmm0

VectorSubD_AVX512_3:
	vzeroupper

	ret

VectorSubD_AVX512 endp


;VectorProdD_AVX512 proc coeff_a:dword,coeff_b:dword,coeff_c:dword,lgth:word
; coeff_a = rcx
; coeff_b = rdx
; coeff_c = r8
; lgth = r9d

VectorProdD_AVX512 proc public frame

	.endprolog

	mov r10,rcx
	mov rax,256
	mov ecx,r9d

	shr ecx,2
	jz short VectorProdD_AVX512_1

VectorProdD_AVX512_loop_1:
	vmovapd zmm0,ZMMWORD ptr[r10]
	vmovapd zmm1,ZMMWORD ptr[r10+64]
	vmovapd zmm2,ZMMWORD ptr[r10+128]
	vmovapd zmm3,ZMMWORD ptr[r10+192]

	vmulpd zmm0,zmm0,ZMMWORD ptr[rdx]
	vmulpd zmm1,zmm1,ZMMWORD ptr[rdx+64]
	vmulpd zmm2,zmm2,ZMMWORD ptr[rdx+128]
	vmulpd zmm3,zmm3,ZMMWORD ptr[rdx+192]

	vmovapd ZMMWORD ptr[r8],zmm0
	vmovapd ZMMWORD ptr[r8+64],zmm1
	vmovapd ZMMWORD ptr[r8+128],zmm2
	vmovapd ZMMWORD ptr[r8+192],zmm3

	add r10,rax
	add rdx,rax
	add r8,rax
	
	dec ecx
	jnz short VectorProdD_AVX512_loop_1

VectorProdD_AVX512_1:
	test r9d,2
	jz short VectorProdD_AVX512_2

	vmovapd zmm0,ZMMWORD ptr[r10]
	vmovapd zmm1,ZMMWORD ptr[r10+64]
	vmulpd zmm0,zmm0,ZMMWORD ptr[rdx]
	vmulpd zmm1,zmm1,ZMMWORD ptr[rdx+64]
	vmovapd ZMMWORD ptr[r8],zmm0
	vmovapd ZMMWORD ptr[r8+64],zmm1

	add r10,128
	add rdx,128
	add r8,128

VectorProdD_AVX512_2:
	test r9d,1
	jz short VectorProdD_AVX512_3

	vmovapd zmm0,ZMMWORD ptr[r10]
	vmulpd zmm0,zmm0,ZMMWORD ptr[rdx]
	vmovapd ZMMWORD ptr[r8],zmm0

VectorProdD_AVX512_3:
	vzeroupper

	ret

VectorProdD_AVX512 endp


;VectorAdd2D_AVX512 proc coeff_a:dword,coeff_b:dword,lgth:word
; coeff_a = rcx
; coeff_b = rdx
; lgth = r8d

VectorAdd2D_AVX512 proc public frame

	.endprolog

	mov r9,rcx
	mov rax,256
	mov ecx,r8d

	shr ecx,2
	jz short VectorAdd2D_AVX512_1

VectorAdd2D_AVX512_loop_1:
	vmovapd zmm0,ZMMWORD ptr[r9]
	vmovapd zmm1,ZMMWORD ptr[r9+64]
	vmovapd zmm2,ZMMWORD ptr[r9+128]
	vmovapd zmm3,ZMMWORD ptr[r9+192]

	vaddpd zmm0,zmm0,ZMMWORD ptr[rdx]
	vaddpd zmm1,zmm1,ZMMWORD ptr[rdx+64]
	vaddpd zmm2,zmm2,ZMMWORD ptr[rdx+128]
	vaddpd zmm3,zmm3,ZMMWORD ptr[rdx+192]

	vmovapd ZMMWORD ptr[r9],zmm0
	vmovapd ZMMWORD ptr[r9+64],zmm1
	vmovapd ZMMWORD ptr[r9+128],zmm2
	vmovapd ZMMWORD ptr[r9+192],zmm3

	add rdx,rax
	add r9,rax
	
	dec ecx
	jnz short VectorAdd2D_AVX512_loop_1

VectorAdd2D_AVX512_1:
	test r8d,2
	jz short VectorAdd2D_AVX512_2

	vmovapd zmm0,ZMMWORD ptr[r9]
	vmovapd zmm1,ZMMWORD ptr[r9+64]
	vaddpd zmm0,zmm0,ZMMWORD ptr[rdx]
	vaddpd zmm1,zmm1,ZMMWORD ptr[rdx+64]
	vmovapd ZMMWORD ptr[r9],zmm0
	vmovapd ZMMWORD ptr[r9+64],zmm1

	add rdx,128
	add r9,128

VectorAdd2D_AVX512_2:
	test r8d,1
	jz short VectorAdd2D_AVX512_3

	vmovapd zmm0,ZMMWORD ptr[r9]
	vaddpd zmm0,zmm0,ZMMWORD ptr[rdx]
	vmovapd ZMMWORD ptr[r9],zmm0

VectorAdd2D_AVX512_3:
	vzeroupper

	ret

VectorAdd2D_AVX512 endp


;VectorSub2D_AVX512 proc coeff_a:dword,coeff_b:dword,lgth:word
; coeff_a = rcx
; coeff_b = rdx
; lgth = r8d

VectorSub2D_AVX512 proc public frame

	.endprolog

	mov r9,rcx
	mov rax,256
	mov ecx,r8d

	shr ecx,2
	jz short VectorSub2D_AVX512_1

VectorSub2D_AVX512_loop_1:
	vmovapd zmm0,ZMMWORD ptr[r9]
	vmovapd zmm1,ZMMWORD ptr[r9+64]
	vmovapd zmm2,ZMMWORD ptr[r9+128]
	vmovapd zmm3,ZMMWORD ptr[r9+192]

	vsubpd zmm0,zmm0,ZMMWORD ptr[rdx]
	vsubpd zmm1,zmm1,ZMMWORD ptr[rdx+64]
	vsubpd zmm2,zmm2,ZMMWORD ptr[rdx+128]
	vsubpd zmm3,zmm3,ZMMWORD ptr[rdx+192]

	vmovapd ZMMWORD ptr[r9],zmm0
	vmovapd ZMMWORD ptr[r9+64],zmm1
	vmovapd ZMMWORD ptr[r9+128],zmm2
	vmovapd ZMMWORD ptr[r9+192],zmm3

	add rdx,rax
	add r9,rax
	
	dec ecx
	jnz short VectorSub2D_AVX512_loop_1

VectorSub2D_AVX512_1:
	test r8d,2
	jz short VectorSub2D_AVX512_2

	vmovapd zmm0,ZMMWORD ptr[r9]
	vmovapd zmm1,ZMMWORD ptr[r9+64]
	vsubpd zmm0,zmm0,ZMMWORD ptr[rdx]
	vsubpd zmm1,zmm1,ZMMWORD ptr[rdx+64]
	vmovapd ZMMWORD ptr[r9],zmm0
	vmovapd ZMMWORD ptr[r9+64],zmm1

	add rdx,128
	add r9,128

VectorSub2D_AVX512_2:
	test r8d,1
	jz short VectorSub2D_AVX512_3

	vmovapd zmm0,ZMMWORD ptr[r9]
	vsubpd zmm0,zmm0,ZMMWORD ptr[rdx]
	vmovapd ZMMWORD ptr[r9],zmm0

VectorSub2D_AVX512_3:
	vzeroupper

	ret

VectorSub2D_AVX512 endp


;VectorInvSubD_AVX512 proc coeff_a:dword,coeff_b:dword,lgth:word
; coeff_a = rcx
; coeff_b = rdx
; lgth = r8d

VectorInvSubD_AVX512 proc public frame

	.endprolog

	mov r9,rcx
	mov rax,256
	mov ecx,r8d

	shr ecx,2
	jz short VectorInvSubD_AVX512_1

VectorInvSubD_AVX512_loop_1:
	vmovapd zmm0,ZMMWORD ptr[rdx]
	vmovapd zmm1,ZMMWORD ptr[rdx+64]
	vmovapd zmm2,ZMMWORD ptr[rdx+128]
	vmovapd zmm3,ZMMWORD ptr[rdx+192]

	vsubpd zmm0,zmm0,ZMMWORD ptr[r9]
	vsubpd zmm1,zmm1,ZMMWORD ptr[r9+64]
	vsubpd zmm2,zmm2,ZMMWORD ptr[r9+128]
	vsubpd zmm3,zmm3,ZMMWORD ptr[r9+192]

	vmovapd ZMMWORD ptr[r9],zmm0
	vmovapd ZMMWORD ptr[r9+64],zmm1
	vmovapd ZMMWORD ptr[r9+128],zmm2
	vmovapd ZMMWORD ptr[r9+192],zmm3

	add rdx,rax
	add r9,rax
	
	dec ecx
	jnz short VectorInvSubD_AVX512_loop_1

VectorInvSubD_AVX512_1:
	test r8d,2
	jz short VectorInvSubD_AVX512_2

	vmovapd zmm0,ZMMWORD ptr[rdx]
	vmovapd zmm1,ZMMWORD ptr[rdx+64]
	vsubpd zmm0,zmm0,ZMMWORD ptr[r9]
	vsubpd zmm1,zmm1,ZMMWORD ptr[r9+64]
	vmovapd ZMMWORD ptr[r9],zmm0
	vmovapd ZMMWORD ptr[r9+64],zmm1

	add rdx,128
	add r9,128

VectorInvSubD_AVX512_2:
	test r8d,1
	jz short VectorInvSubD_AVX512_3

	vmovapd zmm0,ZMMWORD ptr[rdx]
	vsubpd zmm0,zmm0,ZMMWORD ptr[r9]
	vmovapd ZMMWORD ptr[r9],zmm0

VectorInvSubD_AVX512_3:
	vzeroupper

	ret

VectorInvSubD_AVX512 endp


;VectorProd2D_AVX512 proc coeff_a:dword,coeff_b:dword,lgth:word
; coeff_a = rcx
; coeff_b = rdx
; lgth = r8d

VectorProd2D_AVX512 proc public frame

	.endprolog

	mov r9,rcx
	mov rax,256
	mov ecx,r8d

	shr ecx,2
	jz short VectorProd2D_AVX512_1

VectorProd2D_AVX512_loop_1:
	vmovapd zmm0,ZMMWORD ptr[r9]
	vmovapd zmm1,ZMMWORD ptr[r9+64]
	vmovapd zmm2,ZMMWORD ptr[r9+128]
	vmovapd zmm3,ZMMWORD ptr[r9+192]

	vmulpd zmm0,zmm0,ZMMWORD ptr[rdx]
	vmulpd zmm1,zmm1,ZMMWORD ptr[rdx+64]
	vmulpd zmm2,zmm2,ZMMWORD ptr[rdx+128]
	vmulpd zmm3,zmm3,ZMMWORD ptr[rdx+192]

	vmovapd ZMMWORD ptr[r9],zmm0
	vmovapd ZMMWORD ptr[r9+64],zmm1
	vmovapd ZMMWORD ptr[r9+128],zmm2
	vmovapd ZMMWORD ptr[r9+192],zmm3

	add rdx,rax
	add r9,rax
	
	dec ecx
	jnz short VectorProd2D_AVX512_loop_1

VectorProd2D_AVX512_1:
	test r8d,2
	jz short VectorProd2D_AVX512_2

	vmovapd zmm0,ZMMWORD ptr[r9]
	vmovapd zmm1,ZMMWORD ptr[r9+64]
	vmulpd zmm0,zmm0,ZMMWORD ptr[rdx]
	vmulpd zmm1,zmm1,ZMMWORD ptr[rdx+64]
	vmovapd ZMMWORD ptr[r9],zmm0
	vmovapd ZMMWORD ptr[r9+64],zmm1

	add rdx,128
	add r9,128

VectorProd2D_AVX512_2:
	test r8d,1
	jz short VectorProd2D_AVX512_3

	vmovapd zmm0,ZMMWORD ptr[r9]
	vmulpd zmm0,zmm0,ZMMWORD ptr[rdx]
	vmovapd ZMMWORD ptr[r9],zmm0

VectorProd2D_AVX512_3:
	vzeroupper

	ret

VectorProd2D_AVX512 endp

end