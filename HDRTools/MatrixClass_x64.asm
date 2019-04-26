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

	.endprolog
	
	vbroadcastss ymm0,dword ptr[rcx]

	xor rcx,rcx
	mov rax,32
	mov ecx,r9d
	
CoeffProductF_AVX_1:	
	vmulps ymm1,ymm0,YMMWORD ptr[rdx]
	add rdx,rax
	vmovaps YMMWORD ptr[r8],ymm1
	add r8,rax
	loop CoeffProductF_AVX_1
	
	vzeroupper
	
	ret
	
CoeffProductF_AVX endp	


;CoeffProduct2F_AVX proc coeff_a:dword,coeff_b:dword,lgth:word
; coeff_a = rcx
; coeff_b = rdx
; lgth = r8d

CoeffProduct2F_AVX proc public frame

	.endprolog
	
	vbroadcastss ymm0,dword ptr[rcx]

	xor rcx,rcx
	mov rax,32
	mov ecx,r8d
	
CoeffProduct2F_AVX_1:	
	vmulps ymm1,ymm0,YMMWORD ptr[rdx]
	vmovaps YMMWORD ptr[rdx],ymm1
	add rdx,rax
	loop CoeffProduct2F_AVX_1
	
	vzeroupper
	
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

	.endprolog
	
	vbroadcastsd ymm0,qword ptr[rcx]
	
	xor rcx,rcx
	mov rax,32
	mov ecx,r9d
	
CoeffProductD_AVX_1:	
	vmulpd ymm1,ymm0,YMMWORD ptr[rdx]
	add rdx,rax
	vmovapd YMMWORD ptr[r8],ymm1
	add r8,rax
	loop CoeffProductD_AVX_1
	
	vzeroupper
		
	ret
	
CoeffProductD_AVX endp	


;CoeffProduct2D_AVX proc coeff_a:dword,coeff_b:dword,lgth:word
; coeff_a = rcx
; coeff_b = rdx
; lgth = r8d

CoeffProduct2D_AVX proc public frame

	.endprolog
	
	vbroadcastsd ymm0,qword ptr[rcx]
	
	xor rcx,rcx
	mov rax,32
	mov ecx,r8d
	
CoeffProduct2D_AVX_1:	
	vmulpd ymm1,ymm0,YMMWORD ptr[rdx]
	vmovapd YMMWORD ptr[rdx],ymm1
	add rdx,rax
	loop CoeffProduct2D_AVX_1
	
	vzeroupper
		
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

	.endprolog
	
	vbroadcastss ymm0,dword ptr[rcx]
	
	xor rcx,rcx
	mov rax,32
	mov ecx,r9d
	
CoeffAddProductF_AVX_1:	
	vmulps ymm1,ymm0,YMMWORD ptr[rdx]
	add rdx,rax
	vaddps ymm2,ymm1,YMMWORD ptr[r8]
	vmovaps YMMWORD ptr[r8],ymm2
	add r8,rax
	loop CoeffAddProductF_AVX_1
	
	vzeroupper
	
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

	.endprolog
	
	vbroadcastsd ymm0,qword ptr[rcx]
	
	xor rcx,rcx
	mov rax,32
	mov ecx,r9d

CoeffAddProductD_AVX_1:	
	vmulpd ymm1,ymm0,YMMWORD ptr[rdx]
	add rdx,rax
	vaddpd ymm2,ymm1,YMMWORD ptr[r8]
	vmovapd YMMWORD ptr[r8],ymm2
	add r8,rax
	loop CoeffAddProductD_AVX_1
	
	vzeroupper
	
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

	.endprolog
	
	vbroadcastss ymm0,dword ptr[rcx]

	xor rcx,rcx
	mov rax,32
	mov ecx,r9d
	
CoeffAddF_AVX_1:	
	vaddps ymm1,ymm0,YMMWORD ptr[rdx]
	add rdx,rax
	vmovaps YMMWORD ptr[r8],ymm1
	add r8,rax
	loop CoeffAddF_AVX_1
	
	vzeroupper
	
	ret
	
CoeffAddF_AVX endp	


;CoeffAdd2F_AVX proc coeff_a:dword,coeff_b:dword,lgth:word
; coeff_a = rcx
; coeff_b = rdx
; lgth = r8d

CoeffAdd2F_AVX proc public frame

	.endprolog
	
	vbroadcastss ymm0,dword ptr[rcx]

	xor rcx,rcx
	mov rax,32
	mov ecx,r8d
	
CoeffAdd2F_AVX_1:	
	vaddps ymm1,ymm0,YMMWORD ptr[rdx]
	vmovaps YMMWORD ptr[rdx],ymm1
	add rdx,rax
	loop CoeffAdd2F_AVX_1
	
	vzeroupper
	
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

	.endprolog
	
	vbroadcastsd ymm0,qword ptr[rcx]
	
	xor rcx,rcx
	mov rax,32
	mov ecx,r9d
	
CoeffAddD_AVX_1:	
	vaddpd ymm1,ymm0,YMMWORD ptr[rdx]
	add rdx,rax
	vmovapd YMMWORD ptr[r8],ymm1
	add r8,rax
	loop CoeffAddD_AVX_1
	
	vzeroupper
		
	ret
	
CoeffAddD_AVX endp	


;CoeffAdd2D_AVX proc coeff_a:dword,coeff_b:dword,lgth:word
; coeff_a = rcx
; coeff_b = rdx
; lgth = r8d

CoeffAdd2D_AVX proc public frame

	.endprolog
	
	vbroadcastsd ymm0,qword ptr[rcx]
	
	xor rcx,rcx
	mov rax,32
	mov ecx,r8d
	
CoeffAdd2D_AVX_1:	
	vaddpd ymm1,ymm0,YMMWORD ptr[rdx]
	vmovapd YMMWORD ptr[rdx],ymm1
	add rdx,rax
	loop CoeffAdd2D_AVX_1
	
	vzeroupper
		
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

	.endprolog
	
	vbroadcastss ymm0,dword ptr[rcx]

	xor rcx,rcx
	mov rax,32
	mov ecx,r9d
	
CoeffSubF_AVX_1:	
	vsubps ymm1,ymm0,YMMWORD ptr[rdx]
	add rdx,rax
	vmovaps YMMWORD ptr[r8],ymm1
	add r8,rax
	loop CoeffSubF_AVX_1
	
	vzeroupper
	
	ret
	
CoeffSubF_AVX endp	


;CoeffSub2F_AVX proc coeff_a:dword,coeff_b:dword,lgth:word
; coeff_a = rcx
; coeff_b = rdx
; lgth = r8d

CoeffSub2F_AVX proc public frame

	.endprolog
	
	vbroadcastss ymm0,dword ptr[rcx]

	xor rcx,rcx
	mov rax,32
	mov ecx,r8d
	
CoeffSub2F_AVX_1:	
	vsubps ymm1,ymm0,YMMWORD ptr[rdx]
	vmovaps YMMWORD ptr[rdx],ymm1
	add rdx,rax
	loop CoeffSub2F_AVX_1
	
	vzeroupper
	
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

	.endprolog
	
	vbroadcastsd ymm0,qword ptr[rcx]
	
	xor rcx,rcx
	mov rax,32
	mov ecx,r9d
	
CoeffSubD_AVX_1:	
	vsubpd ymm1,ymm0,YMMWORD ptr[rdx]
	add rdx,rax
	vmovapd YMMWORD ptr[r8],ymm1
	add r8,rax
	loop CoeffSubD_AVX_1
	
	vzeroupper
		
	ret
	
CoeffSubD_AVX endp	


;CoeffSub2D_AVX proc coeff_a:dword,coeff_b:dword,lgth:word
; coeff_a = rcx
; coeff_b = rdx
; lgth = r8d

CoeffSub2D_AVX proc public frame

	.endprolog
	
	vbroadcastsd ymm0,qword ptr[rcx]
	
	xor rcx,rcx
	mov rax,32
	mov ecx,r8d
	
CoeffSub2D_AVX_1:	
	vsubpd ymm1,ymm0,YMMWORD ptr[rdx]
	vmovapd YMMWORD ptr[rdx],ymm1
	add rdx,rax
	loop CoeffSub2D_AVX_1
	
	vzeroupper
		
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
		
	mov r9,rcx
	vxorps ymm0,ymm0,ymm0
	xor rcx,rcx
	mov rax,32
	mov ecx,r8d
		
VectorNorme2F_AVX_1:
	vmovaps ymm1,YMMWORD ptr[r9]
	vmulps ymm1,ymm1,ymm1
	add r9,rax
	vaddps ymm0,ymm0,ymm1
	loop VectorNorme2F_AVX_1
		
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
	
	mov r9,rcx
	vxorpd ymm0,ymm0,ymm0
	xor rcx,rcx
	mov rax,32
	mov ecx,r8d
		
VectorNorme2D_AVX_1:
	vmovapd ymm1,YMMWORD ptr[r9]
	vmulpd ymm1,ymm1,ymm1
	add r9,rax
	vaddpd ymm0,ymm0,ymm1
	loop VectorNorme2D_AVX_1
		
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

	.endprolog
		
	mov r10,rcx
	vxorps ymm0,ymm0,ymm0
	xor rcx,rcx
	mov rax,32
	mov ecx,r9d
		
VectorDist2F_AVX_1:
	vmovaps ymm1,YMMWORD ptr[r10]
	vsubps ymm1,ymm1,YMMWORD ptr[rdx]
	add r10,rax
	vmulps ymm1,ymm1,ymm1
	add rdx,rax
	vaddps ymm0,ymm0,ymm1
	loop VectorDist2F_AVX_1
		
	vextractf128 xmm1,ymm0,1
	vaddps xmm0,xmm0,xmm1
		
	vmovhlps xmm1,xmm1,xmm0
	vaddps xmm0,xmm0,xmm1
	vpsrldq xmm1,xmm0,4
	vaddss xmm0,xmm0,xmm1
	vsqrtss xmm0,xmm0,xmm0
	vmovss dword ptr[r8],xmm0
		
	vzeroupper
	
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

	.endprolog
	
	mov r10,rcx
	vxorpd ymm0,ymm0,ymm0
	xor rcx,rcx
	mov rax,32
	mov ecx,r9d
		
VectorDist2D_AVX_1:
	vmovapd ymm1,YMMWORD ptr[r10]
	vsubpd ymm1,ymm1,YMMWORD ptr[rdx]
	add r10,rax
	vmulpd ymm1,ymm1,ymm1
	add rdx,rax
	vaddpd ymm0,ymm0,ymm1
	loop VectorDist2D_AVX_1
		
	vextractf128 xmm1,ymm0,1
	vaddpd xmm0,xmm0,xmm1
		
	vmovhlps xmm1,xmm1,xmm0
	vaddsd xmm0,xmm0,xmm1
	vsqrtsd xmm0,xmm0,xmm0
	vmovsd qword ptr[r8],xmm0
		
	vzeroupper
		
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
	vxorps ymm0,ymm0,ymm0
	xor rcx,rcx
	mov rax,32
	mov ecx,r8d
		
VectorNormeF_AVX_1:
	vmovaps ymm1,YMMWORD ptr[r9]
	vmulps ymm1,ymm1,ymm1
	add r9,rax
	vaddps ymm0,ymm0,ymm1
	loop VectorNormeF_AVX_1
		
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
	vxorpd ymm0,ymm0,ymm0
	xor rcx,rcx
	mov rax,32
	mov ecx,r8d
		
VectorNormeD_AVX_1:
	vmovapd ymm1,YMMWORD ptr[r9]
	vmulpd ymm1,ymm1,ymm1
	add r9,rax
	vaddpd ymm0,ymm0,ymm1
	loop VectorNormeD_AVX_1
		
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

	.endprolog
		
	mov r10,rcx
	vxorps ymm0,ymm0,ymm0
	xor rcx,rcx
	mov rax,32
	mov ecx,r9d
		
VectorDistF_AVX_1:
	vmovaps ymm1,YMMWORD ptr[r10]
	vsubps ymm1,ymm1,YMMWORD ptr[rdx]
	add r10,rax
	vmulps ymm1,ymm1,ymm1
	add rdx,rax
	vaddps ymm0,ymm0,ymm1
	loop VectorDistF_AVX_1
		
	vextractf128 xmm1,ymm0,1
	vaddps xmm0,xmm0,xmm1
		
	vmovhlps xmm1,xmm1,xmm0
	vaddps xmm0,xmm0,xmm1
	vpsrldq xmm1,xmm0,4
	vaddss xmm0,xmm0,xmm1
	vmovss dword ptr[r8],xmm0
		
	vzeroupper
	
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

	.endprolog
	
	mov r10,rcx
	vxorpd ymm0,ymm0,ymm0
	xor rcx,rcx
	mov rax,32
	mov ecx,r9d
		
VectorDistD_AVX_1:
	vmovapd ymm1,YMMWORD ptr[r10]
	vsubpd ymm1,ymm1,YMMWORD ptr[rdx]
	add r10,rax
	vmulpd ymm1,ymm1,ymm1
	add rdx,rax
	vaddpd ymm0,ymm0,ymm1
	loop VectorDistD_AVX_1
		
	vextractf128 xmm1,ymm0,1
	vaddpd xmm0,xmm0,xmm1
		
	vmovhlps xmm1,xmm1,xmm0
	vaddsd xmm0,xmm0,xmm1
	vmovsd qword ptr[r8],xmm0
		
	vzeroupper
		
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
	vxorps ymm0,ymm0,ymm0
	vmovaps ymm2,YMMWORD ptr sign_bits_f_32
	xor rcx,rcx
	mov rax,32
	mov ecx,r8d
		
VectorNorme1F_AVX_1:
	vandps ymm1,ymm2,YMMWORD ptr[r9]
	add r9,rax
	vaddps ymm0,ymm0,ymm1
	loop VectorNorme1F_AVX_1
		
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
	vxorpd ymm0,ymm0,ymm0
	vmovapd ymm2,YMMWORD ptr sign_bits_f_64
	xor rcx,rcx
	mov rax,32
	mov ecx,r8d
		
VectorNorme1D_AVX_1:
	vandpd ymm1,ymm2,YMMWORD ptr[r9]
	add r9,rax
	vaddpd ymm0,ymm0,ymm1
	loop VectorNorme1D_AVX_1
		
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

	.endprolog
		
	mov r10,rcx
	vxorps ymm0,ymm0,ymm0
	vmovaps ymm2,YMMWORD ptr sign_bits_f_32
	xor rcx,rcx
	mov rax,32
	mov ecx,r9d
		
VectorDist1F_AVX_1:
	vmovaps ymm1,YMMWORD ptr[r10]
	vsubps ymm1,ymm1,YMMWORD ptr[rdx]
	add r10,rax
	vandps ymm1,ymm1,ymm2
	add rdx,rax
	vaddps ymm0,ymm0,ymm1
	loop VectorDist1F_AVX_1
		
	vextractf128 xmm1,ymm0,1
	vaddps xmm0,xmm0,xmm1
		
	vmovhlps xmm1,xmm1,xmm0
	vaddps xmm0,xmm0,xmm1
	vpsrldq xmm1,xmm0,4
	vaddss xmm0,xmm0,xmm1
	vmovss dword ptr[r8],xmm0
		
	vzeroupper
	
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

	.endprolog
	
	mov r10,rcx
	vxorpd ymm0,ymm0,ymm0
	vmovapd ymm2,YMMWORD ptr sign_bits_f_64
	xor rcx,rcx
	mov rax,32
	mov ecx,r9d
		
VectorDist1D_AVX_1:
	vmovapd ymm1,YMMWORD ptr[r10]
	vsubpd ymm1,ymm1,YMMWORD ptr[rdx]
	add r10,rax
	vandpd ymm1,ymm1,ymm2
	add rdx,rax
	vaddpd ymm0,ymm0,ymm1
	loop VectorDist1D_AVX_1
		
	vextractf128 xmm1,ymm0,1
	vaddpd xmm0,xmm0,xmm1
		
	vmovhlps xmm1,xmm1,xmm0
	vaddsd xmm0,xmm0,xmm1
	vmovsd qword ptr[r8],xmm0
		
	vzeroupper
		
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

	.endprolog
		
	mov r10,rcx
	vxorps ymm0,ymm0,ymm0
	xor rcx,rcx
	mov rax,32
	mov ecx,r9d
		
VectorProductF_AVX_1:
	vmovaps ymm1,YMMWORD ptr[r10]
	add r10,rax
	vmulps ymm1,ymm1,YMMWORD ptr[rdx]
	add rdx,rax
	vaddps ymm0,ymm0,ymm1
	loop VectorProductF_AVX_1
		
	vextractf128 xmm1,ymm0,1
	vaddps xmm0,xmm0,xmm1
		
	vmovhlps xmm1,xmm1,xmm0
	vaddps xmm0,xmm0,xmm1
	vpsrldq xmm1,xmm0,4
	vaddss xmm0,xmm0,xmm1
	vmovss dword ptr[r8],xmm0
		
	vzeroupper
	
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

	.endprolog
	
	mov r10,rcx
	vxorpd ymm0,ymm0,ymm0
	xor rcx,rcx
	mov rax,32
	mov ecx,r9d
		
VectorProductD_AVX_1:
	vmovapd ymm1,YMMWORD ptr[r10]
	add r10,rax
	vmulpd ymm1,ymm1,YMMWORD ptr[rdx]
	add rdx,rax
	vaddpd ymm0,ymm0,ymm1
	loop VectorProductD_AVX_1
		
	vextractf128 xmm1,ymm0,1
	vaddpd xmm0,xmm0,xmm1
		
	vmovhlps xmm1,xmm1,xmm0
	vaddsd xmm0,xmm0,xmm1
	vmovsd qword ptr[r8],xmm0
		
	vzeroupper
		
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

	.endprolog

	mov r10,rcx
	mov r11,32
	xor rcx,rcx
	mov ecx,r9d
	
VectorAddF_AVX_1:	
	vmovaps ymm0,YMMWORD ptr[r10]
	add r10,r11
	vaddps ymm0,ymm0,YMMWORD ptr[rdx]
	add rdx,r11
	vmovaps YMMWORD ptr[r8],ymm0
	add r8,r11
	loop VectorAddF_AVX_1
	
	ret
	
VectorAddF_AVX endp


;VectorSubF_AVX proc coeff_a:dword,coeff_b:dword,coeff_c:dword,lgth:word
; coeff_a = rcx
; coeff_b = rdx
; coeff_c = r8
; lgth = r9d

VectorSubF_AVX proc public frame

	.endprolog

	mov r10,rcx
	mov r11,32
	xor rcx,rcx
	mov ecx,r9d
	
VectorSubF_AVX_1:	
	vmovaps ymm0,YMMWORD ptr[r10]
	add r10,r11
	vsubps ymm0,ymm0,YMMWORD ptr[rdx]
	add rdx,r11
	vmovaps YMMWORD ptr[r8],ymm0
	add r8,r11
	loop VectorSubF_AVX_1
	
	ret
	
VectorSubF_AVX endp


;VectorProdF_AVX proc coeff_a:dword,coeff_b:dword,coeff_c:dword,lgth:word
; coeff_a = rcx
; coeff_b = rdx
; coeff_c = r8
; lgth = r9d

VectorProdF_AVX proc public frame

	.endprolog

	mov r10,rcx
	mov r11,32
	xor rcx,rcx
	mov ecx,r9d
	
VectorProdF_AVX_1:	
	vmovaps ymm0,YMMWORD ptr[r10]
	add r10,r11
	vmulps ymm0,ymm0,YMMWORD ptr[rdx]
	add rdx,r11
	vmovaps YMMWORD ptr[r8],ymm0
	add r8,r11
	loop VectorProdF_AVX_1
	
	ret
	
VectorProdF_AVX endp


;VectorAdd2F_AVX proc coeff_a:dword,coeff_b:dword,lgth:word
; coeff_a = rcx
; coeff_b = rdx
; lgth = r8d

VectorAdd2F_AVX proc public frame

	.endprolog

	mov r9,rcx
	mov r10,32
	xor rcx,rcx
	mov ecx,r8d
	
VectorAdd2F_AVX_1:	
	vmovaps ymm0,YMMWORD ptr[r9]
	vaddps ymm0,ymm0,YMMWORD ptr[rdx]
	add rdx,r10
	vmovaps YMMWORD ptr[r9],ymm0
	add r9,r10
	loop VectorAdd2F_AVX_1
	
	ret
	
VectorAdd2F_AVX endp


;VectorSub2F_AVX proc coeff_a:dword,coeff_b:dword,lgth:word
; coeff_a = rcx
; coeff_b = rdx
; lgth = r8d

VectorSub2F_AVX proc public frame

	.endprolog

	mov r9,rcx
	mov r10,32
	xor rcx,rcx
	mov ecx,r8d
	
VectorSub2F_AVX_1:	
	vmovaps ymm0,YMMWORD ptr[r9]
	vsubps ymm0,ymm0,YMMWORD ptr[rdx]
	add rdx,r10
	vmovaps YMMWORD ptr[r9],ymm0
	add r9,r10
	loop VectorSub2F_AVX_1
	
	ret
	
VectorSub2F_AVX endp


;VectorInvSubF_AVX proc coeff_a:dword,coeff_b:dword,lgth:word
; coeff_a = rcx
; coeff_b = rdx
; lgth = r8d

VectorInvSubF_AVX proc public frame

	.endprolog

	mov r9,rcx
	mov r10,32
	xor rcx,rcx
	mov ecx,r8d
	
VectorInvSubF_AVX_1:	
	vmovaps ymm0,YMMWORD ptr[rdx]
	vsubps ymm0,ymm0,YMMWORD ptr[r9]
	add rdx,r10
	vmovaps YMMWORD ptr[r9],ymm0
	add r9,r10
	loop VectorInvSubF_AVX_1
	
	ret
	
VectorInvSubF_AVX endp


;VectorProd2F_AVX proc coeff_a:dword,coeff_b:dword,lgth:word
; coeff_a = rcx
; coeff_b = rdx
; lgth = r8d

VectorProd2F_AVX proc public frame

	.endprolog

	mov r9,rcx
	mov r10,32
	xor rcx,rcx
	mov ecx,r8d
	
VectorProd2F_AVX_1:	
	vmovaps ymm0,YMMWORD ptr[r9]
	vmulps ymm0,ymm0,YMMWORD ptr[rdx]
	add rdx,r10
	vmovaps YMMWORD ptr[r9],ymm0
	add r9,r10
	loop VectorProd2F_AVX_1
	
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

	.endprolog

	mov r10,rcx
	mov r11,32
	xor rcx,rcx
	mov ecx,r9d
	
VectorAddD_AVX_1:	
	vmovapd ymm0,YMMWORD ptr[r10]
	add r10,r11
	vaddpd ymm0,ymm0,YMMWORD ptr[rdx]
	add rdx,r11
	vmovapd YMMWORD ptr[r8],ymm0
	add r8,r11
	loop VectorAddD_AVX_1
	
	ret
	
VectorAddD_AVX endp


;VectorSubD_AVX proc coeff_a:dword,coeff_b:dword,coeff_c:dword,lgth:word
; coeff_a = rcx
; coeff_b = rdx
; coeff_c = r8
; lgth = r9d

VectorSubD_AVX proc public frame

	.endprolog

	mov r10,rcx
	mov r11,32
	xor rcx,rcx
	mov ecx,r9d
	
VectorSubD_AVX_1:	
	vmovapd ymm0,YMMWORD ptr[r10]
	add r10,r11
	vsubpd ymm0,ymm0,YMMWORD ptr[rdx]
	add rdx,r11
	vmovapd YMMWORD ptr[r8],ymm0
	add r8,r11
	loop VectorSubD_AVX_1
	
	ret
	
VectorSubD_AVX endp


;VectorProdD_AVX proc coeff_a:dword,coeff_b:dword,coeff_c:dword,lgth:word
; coeff_a = rcx
; coeff_b = rdx
; coeff_c = r8
; lgth = r9d

VectorProdD_AVX proc public frame

	.endprolog

	mov r10,rcx
	mov r11,32
	xor rcx,rcx
	mov ecx,r9d
	
VectorProdD_AVX_1:	
	vmovapd ymm0,YMMWORD ptr[r10]
	add r10,r11
	vmulpd ymm0,ymm0,YMMWORD ptr[rdx]
	add rdx,r11
	vmovapd YMMWORD ptr[r8],ymm0
	add r8,r11
	loop VectorProdD_AVX_1
	
	ret
	
VectorProdD_AVX endp


;VectorAdd2D_AVX proc coeff_a:dword,coeff_b:dword,lgth:word
; coeff_a = rcx
; coeff_b = rdx
; lgth = r8d

VectorAdd2D_AVX proc public frame

	.endprolog

	mov r9,rcx
	mov r10,32
	xor rcx,rcx
	mov ecx,r8d
	
VectorAdd2D_AVX_1:	
	vmovapd ymm0,YMMWORD ptr[r9]
	vaddpd ymm0,ymm0,YMMWORD ptr[rdx]
	add rdx,r10
	vmovapd YMMWORD ptr[r9],ymm0
	add r9,r10
	loop VectorAdd2D_AVX_1
	
	ret
	
VectorAdd2D_AVX endp


;VectorSub2D_AVX proc coeff_a:dword,coeff_b:dword,lgth:word
; coeff_a = rcx
; coeff_b = rdx
; lgth = r8d

VectorSub2D_AVX proc public frame

	.endprolog

	mov r9,rcx
	mov r10,32
	xor rcx,rcx
	mov ecx,r8d
	
VectorSub2D_AVX_1:	
	vmovapd ymm0,YMMWORD ptr[r9]
	vsubpd ymm0,ymm0,YMMWORD ptr[rdx]
	add rdx,r10
	vmovapd YMMWORD ptr[r9],ymm0
	add r9,r10
	loop VectorSub2D_AVX_1
	
	ret
	
VectorSub2D_AVX endp


;VectorInvSubD_AVX proc coeff_a:dword,coeff_b:dword,lgth:word
; coeff_a = rcx
; coeff_b = rdx
; lgth = r8d

VectorInvSubD_AVX proc public frame

	.endprolog

	mov r9,rcx
	mov r10,32
	xor rcx,rcx
	mov ecx,r8d
	
VectorInvSubD_AVX_1:	
	vmovapd ymm0,YMMWORD ptr[rdx]
	vsubpd ymm0,ymm0,YMMWORD ptr[r9]
	add rdx,r10
	vmovapd YMMWORD ptr[r9],ymm0
	add r9,r10
	loop VectorInvSubD_AVX_1
	
	ret
	
VectorInvSubD_AVX endp


;VectorProd2D_AVX proc coeff_a:dword,coeff_b:dword,lgth:word
; coeff_a = rcx
; coeff_b = rdx
; lgth = r8d

VectorProd2D_AVX proc public frame

	.endprolog

	mov r9,rcx
	mov r10,32
	xor rcx,rcx
	mov ecx,r8d
	
VectorProd2D_AVX_1:	
	vmovapd ymm0,YMMWORD ptr[r9]
	vmulpd ymm0,ymm0,YMMWORD ptr[rdx]
	add rdx,r10
	vmovapd YMMWORD ptr[r9],ymm0
	add r9,r10
	loop VectorProd2D_AVX_1
	
	ret
	
VectorProd2D_AVX endp


end