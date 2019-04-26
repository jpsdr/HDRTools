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

.xmm
.model flat,c

data segment align(32)

sign_bits_f_32 dword 8 dup(7FFFFFFFh)
sign_bits_f_64 qword 4 dup(7FFFFFFFFFFFFFFFh)

.code


CoeffProductF_SSE2 proc coeff_a:dword,coeff_b:dword,coeff_c:dword,lgth:word

    public CoeffProductF_SSE2
	
	push ebx
	
	mov edx,coeff_a
	
	movss xmm0,dword ptr[edx]
	pshufd xmm0,xmm0,0
	
	mov ebx,coeff_b
	mov edx,coeff_c
	mov eax,16
	movzx ecx,lgth
	
CoeffProductF_SSE2_1:	
	movaps xmm1,XMMWORD ptr[ebx]
	add ebx,eax
	mulps xmm1,xmm0
	movaps XMMWORD ptr[edx],xmm1
	add edx,eax
	loop CoeffProductF_SSE2_1
	
	pop ebx
	
	ret
	
CoeffProductF_SSE2 endp	


CoeffProduct2F_SSE2 proc coeff_a:dword,coeff_b:dword,lgth:word

    public CoeffProduct2F_SSE2
	
	mov edx,coeff_a
	
	movss xmm0,dword ptr[edx]
	pshufd xmm0,xmm0,0
	
	mov edx,coeff_b
	mov eax,16
	movzx ecx,lgth
	
CoeffProduct2F_SSE2_1:	
	movaps xmm1,XMMWORD ptr[edx]
	mulps xmm1,xmm0
	movaps XMMWORD ptr[edx],xmm1
	add edx,eax
	loop CoeffProduct2F_SSE2_1

	ret
	
CoeffProduct2F_SSE2 endp	


CoeffProductF_AVX proc coeff_a:dword,coeff_b:dword,coeff_c:dword,lgth:word

    public CoeffProductF_AVX
	
	push ebx
	
	mov edx,coeff_a
	
	vbroadcastss ymm0,dword ptr[edx]
	
	mov ebx,coeff_b
	mov edx,coeff_c
	mov eax,32
	movzx ecx,lgth
	
CoeffProductF_AVX_1:	
	vmulps ymm1,ymm0,YMMWORD ptr[ebx]
	add ebx,eax
	vmovaps YMMWORD ptr[edx],ymm1
	add edx,eax
	loop CoeffProductF_AVX_1
	
	vzeroupper
	
	pop ebx
	
	ret
	
CoeffProductF_AVX endp
	

CoeffProduct2F_AVX proc coeff_a:dword,coeff_b:dword,lgth:word

    public CoeffProduct2F_AVX
	
	mov edx,coeff_a
	
	vbroadcastss ymm0,dword ptr[edx]
	
	mov edx,coeff_b
	mov eax,32
	movzx ecx,lgth
	
CoeffProduct2F_AVX_1:	
	vmulps ymm1,ymm0,YMMWORD ptr[edx]
	vmovaps YMMWORD ptr[edx],ymm1
	add edx,eax
	loop CoeffProduct2F_AVX_1
	
	vzeroupper

	ret
	
CoeffProduct2F_AVX endp

	
CoeffProductD_SSE2 proc coeff_a:dword,coeff_b:dword,coeff_c:dword,lgth:word

    public CoeffProductD_SSE2
	
	push ebx
	
	mov edx,coeff_a
	
	movsd xmm0,qword ptr[edx]
	movlhps xmm0,xmm0
	
	mov ebx,coeff_b
	mov edx,coeff_c
	mov eax,16
	movzx ecx,lgth
	
CoeffProductD_SSE2_1:	
	movapd xmm1,XMMWORD ptr[ebx]
	add ebx,eax
	mulpd xmm1,xmm0
	movapd XMMWORD ptr[edx],xmm1
	add edx,eax
	loop CoeffProductD_SSE2_1
	
	pop ebx
	
	ret
	
CoeffProductD_SSE2 endp		


CoeffProduct2D_SSE2 proc coeff_a:dword,coeff_b:dword,lgth:word

    public CoeffProduct2D_SSE2
	
	mov edx,coeff_a
	
	movsd xmm0,qword ptr[edx]
	movlhps xmm0,xmm0
	
	mov edx,coeff_b
	mov eax,16
	movzx ecx,lgth
	
CoeffProduct2D_SSE2_1:	
	movapd xmm1,XMMWORD ptr[edx]
	mulpd xmm1,xmm0
	movapd XMMWORD ptr[edx],xmm1
	add edx,eax
	loop CoeffProduct2D_SSE2_1

	ret
	
CoeffProduct2D_SSE2 endp		


CoeffProductD_AVX proc coeff_a:dword,coeff_b:dword,coeff_c:dword,lgth:word

    public CoeffProductD_AVX
	
	push ebx
	
	mov edx,coeff_a
	
	vbroadcastsd ymm0,qword ptr[edx]
	
	mov ebx,coeff_b
	mov edx,coeff_c
	mov eax,32
	movzx ecx,lgth
	
CoeffProductD_AVX_1:	
	vmulpd ymm1,ymm0,YMMWORD ptr[ebx]
	add ebx,eax
	vmovapd YMMWORD ptr[edx],ymm1
	add edx,eax
	loop CoeffProductD_AVX_1
	
	vzeroupper
	
	pop ebx
	
	ret
	
CoeffProductD_AVX endp	


CoeffProduct2D_AVX proc coeff_a:dword,coeff_b:dword,lgth:word

    public CoeffProduct2D_AVX
	
	mov edx,coeff_a
	
	vbroadcastsd ymm0,qword ptr[edx]
	
	mov edx,coeff_b
	mov eax,32
	movzx ecx,lgth
	
CoeffProduct2D_AVX_1:	
	vmulpd ymm1,ymm0,YMMWORD ptr[edx]
	vmovapd YMMWORD ptr[edx],ymm1
	add edx,eax
	loop CoeffProduct2D_AVX_1
	
	vzeroupper
	
	ret
	
CoeffProduct2D_AVX endp	


CoeffAddProductF_SSE2 proc coeff_a:dword,coeff_b:dword,coeff_c:dword,lgth:word

    public CoeffAddProductF_SSE2
	
	push ebx
	
	mov edx,coeff_a
	
	movss xmm0,dword ptr[edx]
	pshufd xmm0,xmm0,0
	
	mov ebx,coeff_b
	mov edx,coeff_c
	mov eax,16
	movzx ecx,lgth
	
CoeffAddProductF_SSE2_1:	
	movaps xmm1,XMMWORD ptr[ebx]
	movaps xmm2,XMMWORD ptr[edx]
	mulps xmm1,xmm0
	add ebx,eax
	addps xmm2,xmm1
	movaps XMMWORD ptr[edx],xmm2
	add edx,eax
	loop CoeffAddProductF_SSE2_1
	
	pop ebx
	
	ret
	
CoeffAddProductF_SSE2 endp	


CoeffAddProductF_AVX proc coeff_a:dword,coeff_b:dword,coeff_c:dword,lgth:word

    public CoeffAddProductF_AVX
	
	push ebx
	
	mov edx,coeff_a
	
	vbroadcastss ymm0,dword ptr[edx]
	
	mov ebx,coeff_b
	mov edx,coeff_c
	mov eax,32
	movzx ecx,lgth
	
CoeffAddProductF_AVX_1:	
	vmulps ymm1,ymm0,YMMWORD ptr[ebx]
	add ebx,eax
	vaddps ymm2,ymm1,YMMWORD ptr[edx]
	vmovaps YMMWORD ptr[edx],ymm2
	add edx,eax
	loop CoeffAddProductF_AVX_1
	
	vzeroupper
	
	pop ebx
	
	ret
	
CoeffAddProductF_AVX endp	


CoeffAddProductD_SSE2 proc coeff_a:dword,coeff_b:dword,coeff_c:dword,lgth:word

    public CoeffAddProductD_SSE2
	
	push ebx
	
	mov edx,coeff_a
	
	movsd xmm0,qword ptr[edx]
	movlhps xmm0,xmm0
	
	mov ebx,coeff_b
	mov edx,coeff_c
	mov eax,16
	movzx ecx,lgth
	
CoeffAddProductD_SSE2_1:	
	movapd xmm1,XMMWORD ptr[ebx]
	movapd xmm2,XMMWORD ptr[edx]
	mulpd xmm1,xmm0
	add ebx,eax
	addpd xmm2,xmm1
	movapd XMMWORD ptr[edx],xmm2
	add edx,eax
	loop CoeffAddProductD_SSE2_1
	
	pop ebx
	
	ret
	
CoeffAddProductD_SSE2 endp	


CoeffAddProductD_AVX proc coeff_a:dword,coeff_b:dword,coeff_c:dword,lgth:word

    public CoeffAddProductD_AVX
	
	push ebx
	
	mov edx,coeff_a
	
	vbroadcastsd ymm0,qword ptr[edx]
	
	mov ebx,coeff_b
	mov edx,coeff_c
	mov eax,32
	movzx ecx,lgth
	
CoeffAddProductD_AVX_1:	
	vmulpd ymm1,ymm0,YMMWORD ptr[ebx]
	add ebx,eax
	vaddpd ymm2,ymm1,YMMWORD ptr[edx]
	vmovapd YMMWORD ptr[edx],ymm2
	add edx,eax
	loop CoeffAddProductD_AVX_1
	
	vzeroupper
	
	pop ebx
	
	ret
	
CoeffAddProductD_AVX endp	


CoeffAddF_SSE2 proc coeff_a:dword,coeff_b:dword,coeff_c:dword,lgth:word

    public CoeffAddF_SSE2
	
	push ebx
	
	mov edx,coeff_a
	
	movss xmm0,dword ptr[edx]
	pshufd xmm0,xmm0,0
	
	mov ebx,coeff_b
	mov edx,coeff_c
	mov eax,16
	movzx ecx,lgth
	
CoeffAddF_SSE2_1:	
	movaps xmm1,XMMWORD ptr[ebx]
	add ebx,eax
	addps xmm1,xmm0
	movaps XMMWORD ptr[edx],xmm1
	add edx,eax
	loop CoeffAddF_SSE2_1
	
	pop ebx
	
	ret
	
CoeffAddF_SSE2 endp	


CoeffAdd2F_SSE2 proc coeff_a:dword,coeff_b:dword,lgth:word

    public CoeffAdd2F_SSE2
	
	mov edx,coeff_a
	
	movss xmm0,dword ptr[edx]
	pshufd xmm0,xmm0,0
	
	mov edx,coeff_b
	mov eax,16
	movzx ecx,lgth
	
CoeffAdd2F_SSE2_1:	
	movaps xmm1,XMMWORD ptr[edx]
	addps xmm1,xmm0
	movaps XMMWORD ptr[edx],xmm1
	add edx,eax
	loop CoeffAdd2F_SSE2_1

	ret
	
CoeffAdd2F_SSE2 endp	


CoeffAddF_AVX proc coeff_a:dword,coeff_b:dword,coeff_c:dword,lgth:word

    public CoeffAddF_AVX
	
	push ebx
	
	mov edx,coeff_a
	
	vbroadcastss ymm0,dword ptr[edx]
	
	mov ebx,coeff_b
	mov edx,coeff_c
	mov eax,32
	movzx ecx,lgth
	
CoeffAddF_AVX_1:	
	vaddps ymm1,ymm0,YMMWORD ptr[ebx]
	add ebx,eax
	vmovaps YMMWORD ptr[edx],ymm1
	add edx,eax
	loop CoeffAddF_AVX_1
	
	vzeroupper
	
	pop ebx
	
	ret
	
CoeffAddF_AVX endp
	

CoeffAdd2F_AVX proc coeff_a:dword,coeff_b:dword,lgth:word

    public CoeffAdd2F_AVX
	
	mov edx,coeff_a
	
	vbroadcastss ymm0,dword ptr[edx]
	
	mov edx,coeff_b
	mov eax,32
	movzx ecx,lgth
	
CoeffAdd2F_AVX_1:	
	vaddps ymm1,ymm0,YMMWORD ptr[edx]
	vmovaps YMMWORD ptr[edx],ymm1
	add edx,eax
	loop CoeffAdd2F_AVX_1
	
	vzeroupper

	ret
	
CoeffAdd2F_AVX endp

	
CoeffAddD_SSE2 proc coeff_a:dword,coeff_b:dword,coeff_c:dword,lgth:word

    public CoeffAddD_SSE2
	
	push ebx
	
	mov edx,coeff_a
	
	movsd xmm0,qword ptr[edx]
	movlhps xmm0,xmm0
	
	mov ebx,coeff_b
	mov edx,coeff_c
	mov eax,16
	movzx ecx,lgth
	
CoeffAddD_SSE2_1:	
	movapd xmm1,XMMWORD ptr[ebx]
	add ebx,eax
	addpd xmm1,xmm0
	movapd XMMWORD ptr[edx],xmm1
	add edx,eax
	loop CoeffAddD_SSE2_1
	
	pop ebx
	
	ret
	
CoeffAddD_SSE2 endp		


CoeffAdd2D_SSE2 proc coeff_a:dword,coeff_b:dword,lgth:word

    public CoeffAdd2D_SSE2
	
	mov edx,coeff_a
	
	movsd xmm0,qword ptr[edx]
	movlhps xmm0,xmm0
	
	mov edx,coeff_b
	mov eax,16
	movzx ecx,lgth
	
CoeffAdd2D_SSE2_1:	
	movapd xmm1,XMMWORD ptr[edx]
	addpd xmm1,xmm0
	movapd XMMWORD ptr[edx],xmm1
	add edx,eax
	loop CoeffAdd2D_SSE2_1

	ret
	
CoeffAdd2D_SSE2 endp		


CoeffAddD_AVX proc coeff_a:dword,coeff_b:dword,coeff_c:dword,lgth:word

    public CoeffAddD_AVX
	
	push ebx
	
	mov edx,coeff_a
	
	vbroadcastsd ymm0,qword ptr[edx]
	
	mov ebx,coeff_b
	mov edx,coeff_c
	mov eax,32
	movzx ecx,lgth
	
CoeffAddD_AVX_1:	
	vaddpd ymm1,ymm0,YMMWORD ptr[ebx]
	add ebx,eax
	vmovapd YMMWORD ptr[edx],ymm1
	add edx,eax
	loop CoeffAddD_AVX_1
	
	vzeroupper
	
	pop ebx
	
	ret
	
CoeffAddD_AVX endp	


CoeffAdd2D_AVX proc coeff_a:dword,coeff_b:dword,lgth:word

    public CoeffAdd2D_AVX
	
	mov edx,coeff_a
	
	vbroadcastsd ymm0,qword ptr[edx]
	
	mov edx,coeff_b
	mov eax,32
	movzx ecx,lgth
	
CoeffAdd2D_AVX_1:	
	vaddpd ymm1,ymm0,YMMWORD ptr[edx]
	vmovapd YMMWORD ptr[edx],ymm1
	add edx,eax
	loop CoeffAdd2D_AVX_1
	
	vzeroupper
	
	ret
	
CoeffAdd2D_AVX endp


CoeffSubF_SSE2 proc coeff_a:dword,coeff_b:dword,coeff_c:dword,lgth:word

    public CoeffSubF_SSE2
	
	push ebx
	
	mov edx,coeff_a
	
	movss xmm0,dword ptr[edx]
	pshufd xmm0,xmm0,0
	
	mov ebx,coeff_b
	mov edx,coeff_c
	mov eax,16
	movzx ecx,lgth
	
CoeffSubF_SSE2_1:	
	movaps xmm1,xmm0
	subps xmm1,XMMWORD ptr[ebx]
	add ebx,eax
	movaps XMMWORD ptr[edx],xmm1
	add edx,eax
	loop CoeffSubF_SSE2_1
	
	pop ebx
	
	ret
	
CoeffSubF_SSE2 endp	


CoeffSub2F_SSE2 proc coeff_a:dword,coeff_b:dword,lgth:word

    public CoeffSub2F_SSE2
	
	mov edx,coeff_a
	
	movss xmm0,dword ptr[edx]
	pshufd xmm0,xmm0,0
	
	mov edx,coeff_b
	mov eax,16
	movzx ecx,lgth
	
CoeffSub2F_SSE2_1:	
	movaps xmm1,xmm0
	subps xmm1,XMMWORD ptr[edx]
	movaps XMMWORD ptr[edx],xmm1
	add edx,eax
	loop CoeffSub2F_SSE2_1

	ret
	
CoeffSub2F_SSE2 endp	


CoeffSubF_AVX proc coeff_a:dword,coeff_b:dword,coeff_c:dword,lgth:word

    public CoeffSubF_AVX
	
	push ebx
	
	mov edx,coeff_a
	
	vbroadcastss ymm0,dword ptr[edx]
	
	mov ebx,coeff_b
	mov edx,coeff_c
	mov eax,32
	movzx ecx,lgth
	
CoeffSubF_AVX_1:	
	vsubps ymm1,ymm0,YMMWORD ptr[ebx]
	add ebx,eax
	vmovaps YMMWORD ptr[edx],ymm1
	add edx,eax
	loop CoeffSubF_AVX_1
	
	vzeroupper
	
	pop ebx
	
	ret
	
CoeffSubF_AVX endp
	

CoeffSub2F_AVX proc coeff_a:dword,coeff_b:dword,lgth:word

    public CoeffSub2F_AVX
	
	mov edx,coeff_a
	
	vbroadcastss ymm0,dword ptr[edx]
	
	mov edx,coeff_b
	mov eax,32
	movzx ecx,lgth
	
CoeffSub2F_AVX_1:	
	vsubps ymm1,ymm0,YMMWORD ptr[edx]
	vmovaps YMMWORD ptr[edx],ymm1
	add edx,eax
	loop CoeffSub2F_AVX_1
	
	vzeroupper

	ret
	
CoeffSub2F_AVX endp

	
CoeffSubD_SSE2 proc coeff_a:dword,coeff_b:dword,coeff_c:dword,lgth:word

    public CoeffSubD_SSE2
	
	push ebx
	
	mov edx,coeff_a
	
	movsd xmm0,qword ptr[edx]
	movlhps xmm0,xmm0
	
	mov ebx,coeff_b
	mov edx,coeff_c
	mov eax,16
	movzx ecx,lgth
	
CoeffSubD_SSE2_1:	
	movapd xmm1,xmm0
	subpd xmm1,XMMWORD ptr[ebx]
	add ebx,eax
	movapd XMMWORD ptr[edx],xmm1
	add edx,eax
	loop CoeffSubD_SSE2_1
	
	pop ebx
	
	ret
	
CoeffSubD_SSE2 endp		


CoeffSub2D_SSE2 proc coeff_a:dword,coeff_b:dword,lgth:word

    public CoeffSub2D_SSE2
	
	mov edx,coeff_a
	
	movsd xmm0,qword ptr[edx]
	movlhps xmm0,xmm0
	
	mov edx,coeff_b
	mov eax,16
	movzx ecx,lgth
	
CoeffSub2D_SSE2_1:	
	movapd xmm1,xmm0
	subpd xmm1,XMMWORD ptr[edx]
	movapd XMMWORD ptr[edx],xmm1
	add edx,eax
	loop CoeffSub2D_SSE2_1

	ret
	
CoeffSub2D_SSE2 endp		


CoeffSubD_AVX proc coeff_a:dword,coeff_b:dword,coeff_c:dword,lgth:word

    public CoeffSubD_AVX
	
	push ebx
	
	mov edx,coeff_a
	
	vbroadcastsd ymm0,qword ptr[edx]
	
	mov ebx,coeff_b
	mov edx,coeff_c
	mov eax,32
	movzx ecx,lgth
	
CoeffSubD_AVX_1:	
	vsubpd ymm1,ymm0,YMMWORD ptr[ebx]
	add ebx,eax
	vmovapd YMMWORD ptr[edx],ymm1
	add edx,eax
	loop CoeffSubD_AVX_1
	
	vzeroupper
	
	pop ebx
	
	ret
	
CoeffSubD_AVX endp	


CoeffSub2D_AVX proc coeff_a:dword,coeff_b:dword,lgth:word

    public CoeffSub2D_AVX
	
	mov edx,coeff_a
	
	vbroadcastsd ymm0,qword ptr[edx]
	
	mov edx,coeff_b
	mov eax,32
	movzx ecx,lgth
	
CoeffSub2D_AVX_1:	
	vsubpd ymm1,ymm0,YMMWORD ptr[edx]
	vmovapd YMMWORD ptr[edx],ymm1
	add edx,eax
	loop CoeffSub2D_AVX_1
	
	vzeroupper
	
	ret
	
CoeffSub2D_AVX endp


VectorNorme2F_SSE2 proc coeff_x:dword,result:dword,lgth:word

    public VectorNorme2F_SSE2
	
	mov eax,16
	mov edx,coeff_x
		
	xorps xmm0,xmm0
	movzx ecx,lgth
		
VectorNorme2F_SSE2_1:
	movaps xmm1,XMMWORD ptr[edx]
	mulps xmm1,xmm1
	add edx,eax
	addps xmm0,xmm1
	loop VectorNorme2F_SSE2_1
		
	movhlps xmm1,xmm0
	addps xmm0,xmm1
	mov edx,result
	movaps xmm1,xmm0
	psrldq xmm1,4
	addss xmm0,xmm1
	sqrtss xmm0,xmm0
	movss dword ptr[edx],xmm0
		
	ret
		
VectorNorme2F_SSE2 endp


VectorNorme2F_AVX proc coeff_x:dword,result:dword,lgth:word

    public VectorNorme2F_AVX
	
	mov eax,32
	mov edx,coeff_x
		
	vxorps ymm0,ymm0,ymm0
	movzx ecx,lgth
		
VectorNorme2F_AVX_1:
	vmovaps ymm1,YMMWORD ptr[edx]
	vmulps ymm1,ymm1,ymm1
	add edx,eax
	vaddps ymm0,ymm0,ymm1
	loop VectorNorme2F_AVX_1
	
	vextractf128 xmm1,ymm0,1
	vaddps xmm0,xmm0,xmm1
		
	vmovhlps xmm1,xmm1,xmm0
	vaddps xmm0,xmm0,xmm1
	mov edx,result
	vpsrldq xmm1,xmm0,4
	vaddss xmm0,xmm0,xmm1
	vsqrtss xmm0,xmm0,xmm0
	vmovss dword ptr[edx],xmm0
	
	vzeroupper
	
	ret
		
VectorNorme2F_AVX endp


VectorNorme2D_SSE2 proc coeff_x:dword,result:dword,lgth:word

    public VectorNorme2D_SSE2
	
	mov eax,16
	mov edx,coeff_x
		
	xorpd xmm0,xmm0
	movzx ecx,lgth
		
VectorNorme2D_SSE2_1:
	movapd xmm1,XMMWORD ptr[edx]
	mulpd xmm1,xmm1
	add edx,eax
	addpd xmm0,xmm1
	loop VectorNorme2D_SSE2_1
	
	movhlps xmm1,xmm0
	mov edx,result
	addsd xmm0,xmm1
	sqrtsd xmm0,xmm0
	movsd qword ptr[edx],xmm0
		
	ret
		
VectorNorme2D_SSE2 endp


VectorNorme2D_AVX proc coeff_x:dword,result:dword,lgth:word

    public VectorNorme2D_AVX
	
	mov eax,32
	mov edx,coeff_x
		
	vxorpd ymm0,ymm0,ymm0
	movzx ecx,lgth
		
VectorNorme2D_AVX_1:
	vmovapd ymm1,YMMWORD ptr[edx]
	vmulpd ymm1,ymm1,ymm1
	add edx,eax
	vaddpd ymm0,ymm0,ymm1
	loop VectorNorme2D_AVX_1
	
	vextractf128 xmm1,ymm0,1
	vaddpd xmm0,xmm0,xmm1
		
	vmovhlps xmm1,xmm1,xmm0
	mov edx,result
	vaddsd xmm0,xmm0,xmm1
	vsqrtsd xmm0,xmm0,xmm0
	vmovsd qword ptr[edx],xmm0
		
	vzeroupper	
		
	ret
		
VectorNorme2D_AVX endp


VectorDist2F_SSE2 proc coeff_x:dword,coeff_y:dword,result:dword,lgth:word

    public VectorDist2F_SSE2
	
	push ebx
		
	mov eax,16
	mov ebx,coeff_x
	mov edx,coeff_y
		
	xorps xmm0,xmm0
	movzx ecx,lgth
		
VectorDist2F_SSE2_1:
	movaps xmm1,XMMWORD ptr[ebx]
	subps xmm1,XMMWORD ptr[edx]
	add ebx,eax
	mulps xmm1,xmm1
	add edx,eax
	addps xmm0,xmm1
	loop VectorDist2F_SSE2_1
		
	movhlps xmm1,xmm0
	addps xmm0,xmm1
	mov edx,result
	movaps xmm1,xmm0
	psrldq xmm1,4
	addss xmm0,xmm1
	sqrtss xmm0,xmm0
	movss dword ptr[edx],xmm0
		
	pop ebx
		
	ret
		
VectorDist2F_SSE2 endp


VectorDist2F_AVX proc coeff_x:dword,coeff_y:dword,result:dword,lgth:word

    public VectorDist2F_AVX
	
	push ebx
		
	mov eax,32
	mov ebx,coeff_x
	mov edx,coeff_y
		
	vxorps ymm0,ymm0,ymm0
		
	movzx ecx,lgth
		
VectorDist2F_AVX_1:
	vmovaps ymm1,YMMWORD ptr[ebx]
	vsubps ymm1,ymm1,YMMWORD ptr[edx]
	add ebx,eax
	vmulps ymm1,ymm1,ymm1
	add edx,eax
	vaddps ymm0,ymm0,ymm1
	loop VectorDist2F_AVX_1
		
	vextractf128 xmm1,ymm0,1
	vaddps xmm0,xmm0,xmm1
		
	vmovhlps xmm1,xmm1,xmm0
	vaddps xmm0,xmm0,xmm1
	mov edx,result
	vpsrldq xmm1,xmm0,4
	vaddss xmm0,xmm0,xmm1
	vsqrtss xmm0,xmm0,xmm0
	vmovss dword ptr[edx],xmm0
		
	vzeroupper
		
	pop ebx
		
	ret
		
VectorDist2F_AVX endp	


VectorDist2D_SSE2 proc coeff_x:dword,coeff_y:dword,result:dword,lgth:word

    public VectorDist2D_SSE2
	
	push ebx
		
	mov eax,16
	mov ebx,coeff_x
	mov edx,coeff_y
		
	xorpd xmm0,xmm0
	movzx ecx,lgth
		
VectorDist2D_SSE2_1:
	movapd xmm1,XMMWORD ptr[ebx]
	subpd xmm1,XMMWORD ptr[edx]
	add ebx,eax
	mulpd xmm1,xmm1
	add edx,eax
	addpd xmm0,xmm1
	loop VectorDist2D_SSE2_1
		
	movhlps xmm1,xmm0
	mov edx,result
	addsd xmm0,xmm1
	sqrtsd xmm0,xmm0
	movsd qword ptr[edx],xmm0
		
	pop ebx
		
	ret
		
VectorDist2D_SSE2 endp


VectorDist2D_AVX proc coeff_x:dword,coeff_y:dword,result:dword,lgth:word

    public VectorDist2D_AVX
	
	push ebx
		
	mov eax,32
	mov ebx,coeff_x
	mov edx,coeff_y
		
	vxorpd ymm0,ymm0,ymm0
		
	movzx ecx,lgth
		
VectorDist2D_AVX_1:
	vmovapd ymm1,YMMWORD ptr[ebx]
	vsubpd ymm1,ymm1,YMMWORD ptr[edx]
	add ebx,eax
	vmulpd ymm1,ymm1,ymm1
	add edx,eax
	vaddpd ymm0,ymm0,ymm1
	loop VectorDist2D_AVX_1
		
	vextractf128 xmm1,ymm0,1
	vaddpd xmm0,xmm0,xmm1
		
	vmovhlps xmm1,xmm1,xmm0
	mov edx,result
	vaddsd xmm0,xmm0,xmm1
	vsqrtsd xmm0,xmm0,xmm0
	vmovsd qword ptr[edx],xmm0
		
	vzeroupper
		
	pop ebx
		
	ret
		
VectorDist2D_AVX endp	


VectorNormeF_SSE2 proc coeff_x:dword,result:dword,lgth:word

    public VectorNorme2F_SSE2
	
	mov eax,16
	mov edx,coeff_x
		
	xorps xmm0,xmm0
	movzx ecx,lgth
		
VectorNormeF_SSE2_1:
	movaps xmm1,XMMWORD ptr[edx]
	mulps xmm1,xmm1
	add edx,eax
	addps xmm0,xmm1
	loop VectorNormeF_SSE2_1
		
	movhlps xmm1,xmm0
	addps xmm0,xmm1
	mov edx,result
	movaps xmm1,xmm0
	psrldq xmm1,4
	addss xmm0,xmm1
	movss dword ptr[edx],xmm0
		
	ret
		
VectorNormeF_SSE2 endp


VectorNormeF_AVX proc coeff_x:dword,result:dword,lgth:word

    public VectorNormeF_AVX
	
	mov eax,32
	mov edx,coeff_x
		
	vxorps ymm0,ymm0,ymm0
	movzx ecx,lgth
		
VectorNormeF_AVX_1:
	vmovaps ymm1,YMMWORD ptr[edx]
	vmulps ymm1,ymm1,ymm1
	add edx,eax
	vaddps ymm0,ymm0,ymm1
	loop VectorNormeF_AVX_1
	
	vextractf128 xmm1,ymm0,1
	vaddps xmm0,xmm0,xmm1
		
	vmovhlps xmm1,xmm1,xmm0
	vaddps xmm0,xmm0,xmm1
	mov edx,result
	vpsrldq xmm1,xmm0,4
	vaddss xmm0,xmm0,xmm1
	vmovss dword ptr[edx],xmm0
	
	vzeroupper
	
	ret
		
VectorNormeF_AVX endp


VectorNormeD_SSE2 proc coeff_x:dword,result:dword,lgth:word

    public VectorNormeD_SSE2
	
	mov eax,16
	mov edx,coeff_x
		
	xorpd xmm0,xmm0
	movzx ecx,lgth
		
VectorNormeD_SSE2_1:
	movapd xmm1,XMMWORD ptr[edx]
	mulpd xmm1,xmm1
	add edx,eax
	addpd xmm0,xmm1
	loop VectorNormeD_SSE2_1
	
	movhlps xmm1,xmm0
	mov edx,result
	addsd xmm0,xmm1
	movsd qword ptr[edx],xmm0
		
	ret
		
VectorNormeD_SSE2 endp


VectorNormeD_AVX proc coeff_x:dword,result:dword,lgth:word

    public VectorNormeD_AVX
	
	mov eax,32
	mov edx,coeff_x
		
	vxorpd ymm0,ymm0,ymm0
	movzx ecx,lgth
		
VectorNormeD_AVX_1:
	vmovapd ymm1,YMMWORD ptr[edx]
	vmulpd ymm1,ymm1,ymm1
	add edx,eax
	vaddpd ymm0,ymm0,ymm1
	loop VectorNormeD_AVX_1
	
	vextractf128 xmm1,ymm0,1
	vaddpd xmm0,xmm0,xmm1
		
	vmovhlps xmm1,xmm1,xmm0
	mov edx,result
	vaddsd xmm0,xmm0,xmm1
	vmovsd qword ptr[edx],xmm0
		
	vzeroupper	
		
	ret
		
VectorNormeD_AVX endp


VectorDistF_SSE2 proc coeff_x:dword,coeff_y:dword,result:dword,lgth:word

    public VectorDistF_SSE2
	
	push ebx
		
	mov eax,16
	mov ebx,coeff_x
	mov edx,coeff_y
		
	xorps xmm0,xmm0
	movzx ecx,lgth
		
VectorDistF_SSE2_1:
	movaps xmm1,XMMWORD ptr[ebx]
	subps xmm1,XMMWORD ptr[edx]
	add ebx,eax
	mulps xmm1,xmm1
	add edx,eax
	addps xmm0,xmm1
	loop VectorDistF_SSE2_1
		
	movhlps xmm1,xmm0
	addps xmm0,xmm1
	mov edx,result
	movaps xmm1,xmm0
	psrldq xmm1,4
	addss xmm0,xmm1
	movss dword ptr[edx],xmm0
		
	pop ebx
		
	ret
		
VectorDistF_SSE2 endp


VectorDistF_AVX proc coeff_x:dword,coeff_y:dword,result:dword,lgth:word

    public VectorDistF_AVX
	
	push ebx
		
	mov eax,32
	mov ebx,coeff_x
	mov edx,coeff_y
		
	vxorps ymm0,ymm0,ymm0
		
	movzx ecx,lgth
		
VectorDistF_AVX_1:
	vmovaps ymm1,YMMWORD ptr[ebx]
	vsubps ymm1,ymm1,YMMWORD ptr[edx]
	add ebx,eax
	vmulps ymm1,ymm1,ymm1
	add edx,eax
	vaddps ymm0,ymm0,ymm1
	loop VectorDistF_AVX_1
		
	vextractf128 xmm1,ymm0,1
	vaddps xmm0,xmm0,xmm1
		
	vmovhlps xmm1,xmm1,xmm0
	vaddps xmm0,xmm0,xmm1
	mov edx,result
	vpsrldq xmm1,xmm0,4
	vaddss xmm0,xmm0,xmm1
	vmovss dword ptr[edx],xmm0
		
	vzeroupper
		
	pop ebx
		
	ret
		
VectorDistF_AVX endp	


VectorDistD_SSE2 proc coeff_x:dword,coeff_y:dword,result:dword,lgth:word

    public VectorDistD_SSE2
	
	push ebx
		
	mov eax,16
	mov ebx,coeff_x
	mov edx,coeff_y
		
	xorpd xmm0,xmm0
	movzx ecx,lgth
		
VectorDistD_SSE2_1:
	movapd xmm1,XMMWORD ptr[ebx]
	subpd xmm1,XMMWORD ptr[edx]
	add ebx,eax
	mulpd xmm1,xmm1
	add edx,eax
	addpd xmm0,xmm1
	loop VectorDistD_SSE2_1
		
	movhlps xmm1,xmm0
	mov edx,result
	addsd xmm0,xmm1
	movsd qword ptr[edx],xmm0
		
	pop ebx
		
	ret
		
VectorDistD_SSE2 endp


VectorDistD_AVX proc coeff_x:dword,coeff_y:dword,result:dword,lgth:word

    public VectorDistD_AVX
	
	push ebx
		
	mov eax,32
	mov ebx,coeff_x
	mov edx,coeff_y
		
	vxorpd ymm0,ymm0,ymm0
		
	movzx ecx,lgth
		
VectorDistD_AVX_1:
	vmovapd ymm1,YMMWORD ptr[ebx]
	vsubpd ymm1,ymm1,YMMWORD ptr[edx]
	add ebx,eax
	vmulpd ymm1,ymm1,ymm1
	add edx,eax
	vaddpd ymm0,ymm0,ymm1
	loop VectorDistD_AVX_1
		
	vextractf128 xmm1,ymm0,1
	vaddpd xmm0,xmm0,xmm1
		
	vmovhlps xmm1,xmm1,xmm0
	mov edx,result
	vaddsd xmm0,xmm0,xmm1
	vmovsd qword ptr[edx],xmm0
		
	vzeroupper
		
	pop ebx
		
	ret
		
VectorDistD_AVX endp


VectorNorme1F_SSE2 proc coeff_x:dword,result:dword,lgth:word

    public VectorNorme1F_SSE2
	
	mov eax,16
	mov edx,coeff_x
		
	xorps xmm0,xmm0
	movaps xmm2,XMMWORD ptr sign_bits_f_32
	movzx ecx,lgth
		
VectorNorme1F_SSE2_1:
	movaps xmm1,XMMWORD ptr[edx]
	andps xmm1,xmm2
	add edx,eax
	addps xmm0,xmm1
	loop VectorNorme1F_SSE2_1
		
	movhlps xmm1,xmm0
	addps xmm0,xmm1
	mov edx,result
	movaps xmm1,xmm0
	psrldq xmm1,4
	addss xmm0,xmm1
	movss dword ptr[edx],xmm0
		
	ret
		
VectorNorme1F_SSE2 endp


VectorNorme1F_AVX proc coeff_x:dword,result:dword,lgth:word

    public VectorNorme1F_AVX
	
	mov eax,32
	mov edx,coeff_x
		
	vxorps ymm0,ymm0,ymm0
	vmovaps ymm2,YMMWORD ptr sign_bits_f_32
	movzx ecx,lgth
		
VectorNorme1F_AVX_1:
	vandps ymm1,ymm2,YMMWORD ptr[edx]
	add edx,eax
	vaddps ymm0,ymm0,ymm1
	loop VectorNorme1F_AVX_1
	
	vextractf128 xmm1,ymm0,1
	vaddps xmm0,xmm0,xmm1
		
	vmovhlps xmm1,xmm1,xmm0
	vaddps xmm0,xmm0,xmm1
	mov edx,result
	vpsrldq xmm1,xmm0,4
	vaddss xmm0,xmm0,xmm1
	vmovss dword ptr[edx],xmm0
	
	vzeroupper
	
	ret
		
VectorNorme1F_AVX endp


VectorNorme1D_SSE2 proc coeff_x:dword,result:dword,lgth:word

    public VectorNorme1D_SSE2
	
	mov eax,16
	mov edx,coeff_x
		
	xorpd xmm0,xmm0
	movapd xmm2,XMMWORD ptr sign_bits_f_64
	movzx ecx,lgth
		
VectorNorme1D_SSE2_1:
	movapd xmm1,XMMWORD ptr[edx]
	andpd xmm1,xmm2
	add edx,eax
	addpd xmm0,xmm1
	loop VectorNorme1D_SSE2_1
	
	movhlps xmm1,xmm0
	mov edx,result
	addsd xmm0,xmm1
	movsd qword ptr[edx],xmm0
		
	ret
		
VectorNorme1D_SSE2 endp


VectorNorme1D_AVX proc coeff_x:dword,result:dword,lgth:word

    public VectorNorme1D_AVX
	
	mov eax,32
	mov edx,coeff_x
		
	vxorpd ymm0,ymm0,ymm0
	vmovapd ymm2,YMMWORD ptr sign_bits_f_64
	movzx ecx,lgth
		
VectorNorme1D_AVX_1:
	vandpd ymm1,ymm2,YMMWORD ptr[edx]
	add edx,eax
	vaddpd ymm0,ymm0,ymm1
	loop VectorNorme1D_AVX_1
	
	vextractf128 xmm1,ymm0,1
	vaddpd xmm0,xmm0,xmm1
		
	vmovhlps xmm1,xmm1,xmm0
	mov edx,result
	vaddsd xmm0,xmm0,xmm1
	vmovsd qword ptr[edx],xmm0
		
	vzeroupper	
		
	ret
		
VectorNorme1D_AVX endp


VectorDist1F_SSE2 proc coeff_x:dword,coeff_y:dword,result:dword,lgth:word

    public VectorDist1F_SSE2
	
	push ebx
		
	mov eax,16
	mov ebx,coeff_x
	mov edx,coeff_y
		
	xorps xmm0,xmm0
	movaps xmm2,XMMWORD ptr sign_bits_f_32
	movzx ecx,lgth
		
VectorDist1F_SSE2_1:
	movaps xmm1,XMMWORD ptr[ebx]
	subps xmm1,XMMWORD ptr[edx]
	add ebx,eax
	andps xmm1,xmm2
	add edx,eax
	addps xmm0,xmm1
	loop VectorDist1F_SSE2_1
		
	movhlps xmm1,xmm0
	addps xmm0,xmm1
	mov edx,result
	movaps xmm1,xmm0
	psrldq xmm1,4
	addss xmm0,xmm1
	movss dword ptr[edx],xmm0
		
	pop ebx
		
	ret
		
VectorDist1F_SSE2 endp


VectorDist1F_AVX proc coeff_x:dword,coeff_y:dword,result:dword,lgth:word

    public VectorDist1F_AVX
	
	push ebx
		
	mov eax,32
	mov ebx,coeff_x
	mov edx,coeff_y
		
	vxorps ymm0,ymm0,ymm0
	vmovaps ymm2,YMMWORD ptr sign_bits_f_32
		
	movzx ecx,lgth
		
VectorDist1F_AVX_1:
	vmovaps ymm1,YMMWORD ptr[ebx]
	vsubps ymm1,ymm1,YMMWORD ptr[edx]
	add ebx,eax
	vandps ymm1,ymm1,ymm2
	add edx,eax
	vaddps ymm0,ymm0,ymm1
	loop VectorDist1F_AVX_1
		
	vextractf128 xmm1,ymm0,1
	vaddps xmm0,xmm0,xmm1
		
	vmovhlps xmm1,xmm1,xmm0
	vaddps xmm0,xmm0,xmm1
	mov edx,result
	vpsrldq xmm1,xmm0,4
	vaddss xmm0,xmm0,xmm1
	vmovss dword ptr[edx],xmm0
		
	vzeroupper
		
	pop ebx
		
	ret
		
VectorDist1F_AVX endp	


VectorDist1D_SSE2 proc coeff_x:dword,coeff_y:dword,result:dword,lgth:word

    public VectorDist1D_SSE2
	
	push ebx
		
	mov eax,16
	mov ebx,coeff_x
	mov edx,coeff_y
		
	xorpd xmm0,xmm0
	movapd xmm2,XMMWORD ptr sign_bits_f_64
	movzx ecx,lgth
		
VectorDist1D_SSE2_1:
	movapd xmm1,XMMWORD ptr[ebx]
	subpd xmm1,XMMWORD ptr[edx]
	add ebx,eax
	andpd xmm1,xmm2
	add edx,eax
	addpd xmm0,xmm1
	loop VectorDist1D_SSE2_1
		
	movhlps xmm1,xmm0
	mov edx,result
	addsd xmm0,xmm1
	movsd qword ptr[edx],xmm0
		
	pop ebx
		
	ret
		
VectorDist1D_SSE2 endp


VectorDist1D_AVX proc coeff_x:dword,coeff_y:dword,result:dword,lgth:word

    public VectorDist1D_AVX
	
	push ebx
		
	mov eax,32
	mov ebx,coeff_x
	mov edx,coeff_y
		
	vxorpd ymm0,ymm0,ymm0
	vmovapd ymm2,YMMWORD ptr sign_bits_f_64
		
	movzx ecx,lgth
		
VectorDist1D_AVX_1:
	vmovapd ymm1,YMMWORD ptr[ebx]
	vsubpd ymm1,ymm1,YMMWORD ptr[edx]
	add ebx,eax
	vandpd ymm1,ymm1,ymm2
	add edx,eax
	vaddpd ymm0,ymm0,ymm1
	loop VectorDist1D_AVX_1
		
	vextractf128 xmm1,ymm0,1
	vaddpd xmm0,xmm0,xmm1
		
	vmovhlps xmm1,xmm1,xmm0
	mov edx,result
	vaddsd xmm0,xmm0,xmm1
	vmovsd qword ptr[edx],xmm0
		
	vzeroupper
		
	pop ebx
		
	ret
		
VectorDist1D_AVX endp	


VectorProductF_SSE2 proc coeff_a:dword,coeff_x:dword,result:dword,lgth:word

    public VectorProductF_SSE2
	
	push ebx
		
	mov eax,16
	mov ebx,coeff_a
	mov edx,coeff_x
		
	xorps xmm0,xmm0
	movzx ecx,lgth
		
VectorProductF_SSE2_1:
	movaps xmm1,XMMWORD ptr[ebx]
	add ebx,eax
	mulps xmm1,XMMWORD ptr[edx]
	add edx,eax
	addps xmm0,xmm1
	loop VectorProductF_SSE2_1
		
	movhlps xmm1,xmm0
	addps xmm0,xmm1
	mov edx,result
	movaps xmm1,xmm0
	psrldq xmm1,4
	addss xmm0,xmm1
	movss dword ptr[edx],xmm0
		
	pop ebx
		
	ret
		
VectorProductF_SSE2 endp		
	
		
VectorProductF_AVX proc coeff_a:dword,coeff_x:dword,result:dword,lgth:word

    public VectorProductF_AVX
	
	push ebx
		
	mov eax,32
	mov ebx,coeff_a
	mov edx,coeff_x
		
	vxorps ymm0,ymm0,ymm0
		
	movzx ecx,lgth
		
VectorProductF_AVX_1:
	vmovaps ymm1,YMMWORD ptr[ebx]
	add ebx,eax
	vmulps ymm1,ymm1,YMMWORD ptr[edx]
	add edx,eax
	vaddps ymm0,ymm0,ymm1
	loop VectorProductF_AVX_1
		
	vextractf128 xmm1,ymm0,1
	vaddps xmm0,xmm0,xmm1
		
	vmovhlps xmm1,xmm1,xmm0
	vaddps xmm0,xmm0,xmm1
	mov edx,result
	vpsrldq xmm1,xmm0,4
	vaddss xmm0,xmm0,xmm1
	vmovss dword ptr[edx],xmm0
		
	vzeroupper
		
	pop ebx
		
	ret
		
VectorProductF_AVX endp	

		
VectorProductD_SSE2 proc coeff_a:dword,coeff_x:dword,result:dword,lgth:word

    public VectorProductD_SSE2
	
	push ebx
		
	mov eax,16
	mov ebx,coeff_a
	mov edx,coeff_x
		
	xorpd xmm0,xmm0
	movzx ecx,lgth
		
VectorProductD_SSE2_1:
	movapd xmm1,XMMWORD ptr[ebx]
	add ebx,eax
	mulpd xmm1,XMMWORD ptr[edx]
	add edx,eax
	addpd xmm0,xmm1
	loop VectorProductD_SSE2_1
		
	movhlps xmm1,xmm0
	mov edx,result
	addsd xmm0,xmm1
	movsd qword ptr[edx],xmm0
		
	pop ebx
		
	ret
		
VectorProductD_SSE2 endp		


VectorProductD_AVX proc coeff_a:dword,coeff_x:dword,result:dword,lgth:word

    public VectorProductD_AVX
	
	push ebx
		
	mov eax,32
	mov ebx,coeff_a
	mov edx,coeff_x
		
	vxorpd ymm0,ymm0,ymm0
		
	movzx ecx,lgth
		
VectorProductD_AVX_1:
	vmovapd ymm1,YMMWORD ptr[ebx]
	add ebx,eax
	vmulpd ymm1,ymm1,YMMWORD ptr[edx]
	add edx,eax
	vaddpd ymm0,ymm0,ymm1
	loop VectorProductD_AVX_1
		
	vextractf128 xmm1,ymm0,1
	vaddpd xmm0,xmm0,xmm1
		
	vmovhlps xmm1,xmm1,xmm0
	mov edx,result
	vaddsd xmm0,xmm0,xmm1
	vmovsd qword ptr[edx],xmm0
		
	vzeroupper
		
	pop ebx
		
	ret
		
VectorProductD_AVX endp	


VectorAddF_SSE2 proc coeff_a:dword,coeff_b:dword,coeff_c:dword,lgth:word

    public VectorAddF_SSE2
	
	push ebx

	mov eax,coeff_a
	mov ebx,coeff_b
	mov edx,coeff_c
	movzx ecx,lgth
	
VectorAddF_SSE2_1:	
	movaps xmm0,XMMWORD ptr[eax]
	add eax,16
	addps xmm0,XMMWORD ptr[ebx]
	add ebx,16
	movaps XMMWORD ptr[edx],xmm0
	add edx,16
	loop VectorAddF_SSE2_1
	
	pop ebx
	
	ret
	
VectorAddF_SSE2 endp	


VectorSubF_SSE2 proc coeff_a:dword,coeff_b:dword,coeff_c:dword,lgth:word

    public VectorSubF_SSE2
	
	push ebx

	mov eax,coeff_a
	mov ebx,coeff_b
	mov edx,coeff_c
	movzx ecx,lgth
	
VectorSubF_SSE2_1:	
	movaps xmm0,XMMWORD ptr[eax]
	add eax,16
	subps xmm0,XMMWORD ptr[ebx]
	add ebx,16
	movaps XMMWORD ptr[edx],xmm0
	add edx,16
	loop VectorSubF_SSE2_1
	
	pop ebx
	
	ret
	
VectorSubF_SSE2 endp	


VectorProdF_SSE2 proc coeff_a:dword,coeff_b:dword,coeff_c:dword,lgth:word

    public VectorProdF_SSE2
	
	push ebx

	mov eax,coeff_a
	mov ebx,coeff_b
	mov edx,coeff_c
	movzx ecx,lgth
	
VectorProdF_SSE2_1:	
	movaps xmm0,XMMWORD ptr[eax]
	add eax,16
	mulps xmm0,XMMWORD ptr[ebx]
	add ebx,16
	movaps XMMWORD ptr[edx],xmm0
	add edx,16
	loop VectorProdF_SSE2_1
	
	pop ebx
	
	ret
	
VectorProdF_SSE2 endp


VectorAdd2F_SSE2 proc coeff_a:dword,coeff_b:dword,lgth:word

    public VectorAdd2F_SSE2
	
	push ebx

	mov eax,16
	mov ebx,coeff_a
	mov edx,coeff_b
	movzx ecx,lgth
	
VectorAdd2F_SSE2_1:	
	movaps xmm0,XMMWORD ptr[ebx]
	addps xmm0,XMMWORD ptr[edx]
	add edx,eax
	movaps XMMWORD ptr[ebx],xmm0
	add ebx,eax
	loop VectorAdd2F_SSE2_1
	
	pop ebx
	
	ret
	
VectorAdd2F_SSE2 endp	


VectorSub2F_SSE2 proc coeff_a:dword,coeff_b:dword,lgth:word

    public VectorSub2F_SSE2
	
	push ebx

	mov eax,16
	mov ebx,coeff_a
	mov edx,coeff_b
	movzx ecx,lgth
	
VectorSub2F_SSE2_1:	
	movaps xmm0,XMMWORD ptr[ebx]
	subps xmm0,XMMWORD ptr[edx]
	add edx,eax
	movaps XMMWORD ptr[ebx],xmm0
	add ebx,eax
	loop VectorSub2F_SSE2_1
	
	pop ebx
	
	ret
	
VectorSub2F_SSE2 endp	


VectorInvSubF_SSE2 proc coeff_a:dword,coeff_b:dword,lgth:word

    public VectorInvSubF_SSE2
	
	push ebx

	mov eax,16
	mov ebx,coeff_a
	mov edx,coeff_b
	movzx ecx,lgth
	
VectorInvSubF_SSE2_1:	
	movaps xmm0,XMMWORD ptr[edx]
	subps xmm0,XMMWORD ptr[ebx]
	add edx,eax
	movaps XMMWORD ptr[ebx],xmm0
	add ebx,eax
	loop VectorInvSubF_SSE2_1
	
	pop ebx
	
	ret
	
VectorInvSubF_SSE2 endp	


VectorProd2F_SSE2 proc coeff_a:dword,coeff_b:dword,lgth:word

    public VectorProd2F_SSE2
	
	push ebx

	mov eax,16
	mov ebx,coeff_a
	mov edx,coeff_b
	movzx ecx,lgth
	
VectorProd2F_SSE2_1:	
	movaps xmm0,XMMWORD ptr[ebx]
	mulps xmm0,XMMWORD ptr[edx]
	add edx,eax
	movaps XMMWORD ptr[ebx],xmm0
	add ebx,eax
	loop VectorProd2F_SSE2_1
	
	pop ebx
	
	ret
	
VectorProd2F_SSE2 endp


VectorAddF_AVX proc coeff_a:dword,coeff_b:dword,coeff_c:dword,lgth:word

    public VectorAddF_AVX
	
	push ebx

	mov eax,coeff_a
	mov ebx,coeff_b
	mov edx,coeff_c
	movzx ecx,lgth
	
VectorAddF_AVX_1:	
	vmovaps ymm0,YMMWORD ptr[eax]
	add eax,32
	vaddps ymm0,ymm0,YMMWORD ptr[ebx]
	add ebx,32
	vmovaps YMMWORD ptr[edx],ymm0
	add edx,32
	loop VectorAddF_AVX_1
	
	vzeroupper
	
	pop ebx
	
	ret
	
VectorAddF_AVX endp	


VectorSubF_AVX proc coeff_a:dword,coeff_b:dword,coeff_c:dword,lgth:word

    public VectorSubF_AVX
	
	push ebx

	mov eax,coeff_a
	mov ebx,coeff_b
	mov edx,coeff_c
	movzx ecx,lgth
	
VectorSubF_AVX_1:	
	vmovaps ymm0,YMMWORD ptr[eax]
	add eax,32
	vsubps ymm0,ymm0,YMMWORD ptr[ebx]
	add ebx,32
	vmovaps YMMWORD ptr[edx],ymm0
	add edx,32
	loop VectorSubF_AVX_1
	
	vzeroupper
	
	pop ebx
	
	ret
	
VectorSubF_AVX endp	


VectorProdF_AVX proc coeff_a:dword,coeff_b:dword,coeff_c:dword,lgth:word

    public VectorProdF_AVX
	
	push ebx

	mov eax,coeff_a
	mov ebx,coeff_b
	mov edx,coeff_c
	movzx ecx,lgth
	
VectorProdF_AVX_1:	
	vmovaps ymm0,YMMWORD ptr[eax]
	add eax,32
	vmulps ymm0,ymm0,YMMWORD ptr[ebx]
	add ebx,32
	vmovaps YMMWORD ptr[edx],ymm0
	add edx,32
	loop VectorProdF_AVX_1
	
	vzeroupper
	
	pop ebx
	
	ret
	
VectorProdF_AVX endp


VectorAdd2F_AVX proc coeff_a:dword,coeff_b:dword,lgth:word

    public VectorAdd2F_AVX
	
	push ebx

	mov eax,32
	mov ebx,coeff_a
	mov edx,coeff_b
	movzx ecx,lgth
	
VectorAdd2F_AVX_1:	
	vmovaps ymm0,YMMWORD ptr[ebx]
	vaddps ymm0,ymm0,YMMWORD ptr[edx]
	add edx,eax
	vmovaps YMMWORD ptr[ebx],ymm0
	add ebx,eax
	loop VectorAdd2F_AVX_1
	
	vzeroupper
	
	pop ebx
	
	ret
	
VectorAdd2F_AVX endp	


VectorSub2F_AVX proc coeff_a:dword,coeff_b:dword,lgth:word

    public VectorSub2F_AVX
	
	push ebx

	mov eax,32
	mov ebx,coeff_a
	mov edx,coeff_b
	movzx ecx,lgth
	
VectorSub2F_AVX_1:	
	vmovaps ymm0,YMMWORD ptr[ebx]
	vsubps ymm0,ymm0,YMMWORD ptr[edx]
	add edx,eax
	vmovaps YMMWORD ptr[ebx],ymm0
	add ebx,eax
	loop VectorSub2F_AVX_1
	
	vzeroupper
	
	pop ebx
	
	ret
	
VectorSub2F_AVX endp


VectorInvSubF_AVX proc coeff_a:dword,coeff_b:dword,lgth:word

    public VectorInvSubF_AVX
	
	push ebx

	mov eax,32
	mov ebx,coeff_a
	mov edx,coeff_b
	movzx ecx,lgth
	
VectorInvSubF_AVX_1:	
	vmovaps ymm0,YMMWORD ptr[edx]
	vsubps ymm0,ymm0,YMMWORD ptr[ebx]
	add edx,eax
	vmovaps YMMWORD ptr[ebx],ymm0
	add ebx,eax
	loop VectorInvSubF_AVX_1
	
	vzeroupper
	
	pop ebx
	
	ret
	
VectorInvSubF_AVX endp


VectorProd2F_AVX proc coeff_a:dword,coeff_b:dword,lgth:word

    public VectorProd2F_AVX
	
	push ebx

	mov eax,32
	mov ebx,coeff_a
	mov edx,coeff_b
	movzx ecx,lgth
	
VectorProd2F_AVX_1:	
	vmovaps ymm0,YMMWORD ptr[ebx]
	vmulps ymm0,ymm0,YMMWORD ptr[edx]
	add edx,eax
	vmovaps YMMWORD ptr[ebx],ymm0
	add ebx,eax
	loop VectorProd2F_AVX_1
	
	vzeroupper
	
	pop ebx
	
	ret
	
VectorProd2F_AVX endp
		

VectorAddD_SSE2 proc coeff_a:dword,coeff_b:dword,coeff_c:dword,lgth:word

    public VectorAddD_SSE2
	
	push ebx

	mov eax,coeff_a
	mov ebx,coeff_b
	mov edx,coeff_c
	movzx ecx,lgth
	
VectorAddD_SSE2_1:	
	movapd xmm0,XMMWORD ptr[eax]
	add eax,16
	addpd xmm0,XMMWORD ptr[ebx]
	add ebx,16
	movapd XMMWORD ptr[edx],xmm0
	add edx,16
	loop VectorAddD_SSE2_1
	
	pop ebx
	
	ret
	
VectorAddD_SSE2 endp	


VectorSubD_SSE2 proc coeff_a:dword,coeff_b:dword,coeff_c:dword,lgth:word

    public VectorSubD_SSE2
	
	push ebx

	mov eax,coeff_a
	mov ebx,coeff_b
	mov edx,coeff_c
	movzx ecx,lgth
	
VectorSubD_SSE2_1:	
	movapd xmm0,XMMWORD ptr[eax]
	add eax,16
	subpd xmm0,XMMWORD ptr[ebx]
	add ebx,16
	movapd XMMWORD ptr[edx],xmm0
	add edx,16
	loop VectorSubD_SSE2_1
	
	pop ebx
	
	ret
	
VectorSubD_SSE2 endp	


VectorProdD_SSE2 proc coeff_a:dword,coeff_b:dword,coeff_c:dword,lgth:word

    public VectorProdD_SSE2
	
	push ebx

	mov eax,coeff_a
	mov ebx,coeff_b
	mov edx,coeff_c
	movzx ecx,lgth
	
VectorProdD_SSE2_1:	
	movapd xmm0,XMMWORD ptr[eax]
	add eax,16
	mulpd xmm0,XMMWORD ptr[ebx]
	add ebx,16
	movapd XMMWORD ptr[edx],xmm0
	add edx,16
	loop VectorProdD_SSE2_1
	
	pop ebx
	
	ret
	
VectorProdD_SSE2 endp


VectorAdd2D_SSE2 proc coeff_a:dword,coeff_b:dword,lgth:word

    public VectorAdd2D_SSE2
	
	push ebx

	mov eax,16
	mov ebx,coeff_a
	mov edx,coeff_b
	movzx ecx,lgth
	
VectorAdd2D_SSE2_1:	
	movapd xmm0,XMMWORD ptr[ebx]
	addpd xmm0,XMMWORD ptr[edx]
	add edx,eax
	movapd XMMWORD ptr[ebx],xmm0
	add ebx,eax
	loop VectorAdd2D_SSE2_1
	
	pop ebx
	
	ret
	
VectorAdd2D_SSE2 endp	


VectorSub2D_SSE2 proc coeff_a:dword,coeff_b:dword,lgth:word

    public VectorSub2D_SSE2
	
	push ebx

	mov eax,16
	mov ebx,coeff_a
	mov edx,coeff_b
	movzx ecx,lgth
	
VectorSub2D_SSE2_1:	
	movapd xmm0,XMMWORD ptr[ebx]
	subpd xmm0,XMMWORD ptr[edx]
	add edx,eax
	movapd XMMWORD ptr[ebx],xmm0
	add ebx,eax
	loop VectorSub2D_SSE2_1
	
	pop ebx
	
	ret
	
VectorSub2D_SSE2 endp	


VectorInvSubD_SSE2 proc coeff_a:dword,coeff_b:dword,lgth:word

    public VectorInvSubD_SSE2
	
	push ebx

	mov eax,16
	mov ebx,coeff_a
	mov edx,coeff_b
	movzx ecx,lgth
	
VectorInvSubD_SSE2_1:	
	movapd xmm0,XMMWORD ptr[edx]
	subpd xmm0,XMMWORD ptr[ebx]
	add edx,eax
	movapd XMMWORD ptr[ebx],xmm0
	add ebx,eax
	loop VectorInvSubD_SSE2_1
	
	pop ebx
	
	ret
	
VectorInvSubD_SSE2 endp	


VectorProd2D_SSE2 proc coeff_a:dword,coeff_b:dword,lgth:word

    public VectorProd2D_SSE2
	
	push ebx

	mov eax,16
	mov ebx,coeff_a
	mov edx,coeff_b
	movzx ecx,lgth
	
VectorProd2D_SSE2_1:	
	movapd xmm0,XMMWORD ptr[ebx]
	mulpd xmm0,XMMWORD ptr[edx]
	add edx,eax
	movapd XMMWORD ptr[ebx],xmm0
	add ebx,eax
	loop VectorProd2D_SSE2_1
	
	pop ebx
	
	ret
	
VectorProd2D_SSE2 endp


VectorAddD_AVX proc coeff_a:dword,coeff_b:dword,coeff_c:dword,lgth:word

    public VectorAddD_AVX
	
	push ebx

	mov eax,coeff_a
	mov ebx,coeff_b
	mov edx,coeff_c
	movzx ecx,lgth
	
VectorAddD_AVX_1:	
	vmovapd ymm0,YMMWORD ptr[eax]
	add eax,32
	vaddpd ymm0,ymm0,YMMWORD ptr[ebx]
	add ebx,32
	vmovapd YMMWORD ptr[edx],ymm0
	add edx,32
	loop VectorAddD_AVX_1
	
	vzeroupper
	
	pop ebx
	
	ret
	
VectorAddD_AVX endp	


VectorSubD_AVX proc coeff_a:dword,coeff_b:dword,coeff_c:dword,lgth:word

    public VectorSubD_AVX
	
	push ebx

	mov eax,coeff_a
	mov ebx,coeff_b
	mov edx,coeff_c
	movzx ecx,lgth
	
VectorSubD_AVX_1:	
	vmovapd ymm0,YMMWORD ptr[eax]
	add eax,32
	vsubpd ymm0,ymm0,YMMWORD ptr[ebx]
	add ebx,32
	vmovapd YMMWORD ptr[edx],ymm0
	add edx,32
	loop VectorSubD_AVX_1
	
	vzeroupper
	
	pop ebx
	
	ret
	
VectorSubD_AVX endp	


VectorProdD_AVX proc coeff_a:dword,coeff_b:dword,coeff_c:dword,lgth:word

    public VectorProdD_AVX
	
	push ebx

	mov eax,coeff_a
	mov ebx,coeff_b
	mov edx,coeff_c
	movzx ecx,lgth
	
VectorProdD_AVX_1:	
	vmovapd ymm0,YMMWORD ptr[eax]
	add eax,32
	vmulpd ymm0,ymm0,YMMWORD ptr[ebx]
	add ebx,32
	vmovapd YMMWORD ptr[edx],ymm0
	add edx,32
	loop VectorProdD_AVX_1
	
	vzeroupper
	
	pop ebx
	
	ret
	
VectorProdD_AVX endp


VectorAdd2D_AVX proc coeff_a:dword,coeff_b:dword,lgth:word

    public VectorAdd2D_AVX
	
	push ebx

	mov eax,32
	mov ebx,coeff_a
	mov edx,coeff_b
	movzx ecx,lgth
	
VectorAdd2D_AVX_1:	
	vmovapd ymm0,YMMWORD ptr[ebx]
	vaddpd ymm0,ymm0,YMMWORD ptr[edx]
	add edx,eax
	vmovapd YMMWORD ptr[ebx],ymm0
	add ebx,eax
	loop VectorAdd2D_AVX_1
	
	vzeroupper
	
	pop ebx
	
	ret
	
VectorAdd2D_AVX endp	


VectorSub2D_AVX proc coeff_a:dword,coeff_b:dword,lgth:word

    public VectorSub2D_AVX
	
	push ebx

	mov eax,32
	mov ebx,coeff_a
	mov edx,coeff_b
	movzx ecx,lgth
	
VectorSub2D_AVX_1:	
	vmovapd ymm0,YMMWORD ptr[ebx]
	vsubpd ymm0,ymm0,YMMWORD ptr[edx]
	add edx,eax
	vmovapd YMMWORD ptr[ebx],ymm0
	add ebx,eax
	loop VectorSub2D_AVX_1
	
	vzeroupper
	
	pop ebx
	
	ret
	
VectorSub2D_AVX endp


VectorInvSubD_AVX proc coeff_a:dword,coeff_b:dword,lgth:word

    public VectorInvSubD_AVX
	
	push ebx

	mov eax,32
	mov ebx,coeff_a
	mov edx,coeff_b
	movzx ecx,lgth
	
VectorInvSubD_AVX_1:	
	vmovapd ymm0,YMMWORD ptr[edx]
	vsubpd ymm0,ymm0,YMMWORD ptr[ebx]
	add edx,eax
	vmovapd YMMWORD ptr[ebx],ymm0
	add ebx,eax
	loop VectorInvSubD_AVX_1
	
	vzeroupper
	
	pop ebx
	
	ret
	
VectorInvSubD_AVX endp


VectorProd2D_AVX proc coeff_a:dword,coeff_b:dword,lgth:word

    public VectorProd2D_AVX
	
	push ebx

	mov eax,32
	mov ebx,coeff_a
	mov edx,coeff_b
	movzx ecx,lgth
	
VectorProd2D_AVX_1:	
	vmovapd ymm0,YMMWORD ptr[ebx]
	vmulpd ymm0,ymm0,YMMWORD ptr[edx]
	add edx,eax
	vmovapd YMMWORD ptr[ebx],ymm0
	add ebx,eax
	loop VectorProd2D_AVX_1
	
	vzeroupper
	
	pop ebx
	
	ret
	
VectorProd2D_AVX endp
		
		
end