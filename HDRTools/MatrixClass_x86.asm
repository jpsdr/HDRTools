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
	push esi
	
	mov edx,coeff_a
	
	vbroadcastss ymm0,dword ptr[edx]
	
	movzx ebx,lgth
	mov esi,coeff_b
	mov edx,coeff_c
	mov ecx,ebx
	mov eax,128

	shr ecx,2
	jz short CoeffProductF_AVX_1

CoeffProductF_AVX_loop_1:
	vmulps ymm1,ymm0,YMMWORD ptr[esi]
	vmulps ymm2,ymm0,YMMWORD ptr[esi+32]
	vmulps ymm3,ymm0,YMMWORD ptr[esi+64]
	vmulps ymm4,ymm0,YMMWORD ptr[esi+96]
	vmovaps YMMWORD ptr[edx],ymm1
	vmovaps YMMWORD ptr[edx+32],ymm2
	vmovaps YMMWORD ptr[edx+64],ymm3
	vmovaps YMMWORD ptr[edx+96],ymm4
	add esi,eax
	add edx,eax
	loop CoeffProductF_AVX_loop_1

CoeffProductF_AVX_1:
	test ebx,2
	jz short CoeffProductF_AVX_2

	vmulps ymm1,ymm0,YMMWORD ptr[esi]
	vmulps ymm2,ymm0,YMMWORD ptr[esi+32]
	vmovaps YMMWORD ptr[edx],ymm1
	vmovaps YMMWORD ptr[edx+32],ymm2
	add esi,64
	add edx,64

CoeffProductF_AVX_2:
	test ebx,1
	jz short CoeffProductF_AVX_3

	vmulps ymm1,ymm0,YMMWORD ptr[esi]
	vmovaps YMMWORD ptr[edx],ymm1

CoeffProductF_AVX_3:

	vzeroupper
	
	pop esi
	pop ebx
	
	ret
	
CoeffProductF_AVX endp
	

CoeffProduct2F_AVX proc coeff_a:dword,coeff_b:dword,lgth:word

    public CoeffProduct2F_AVX
	
	push esi

	mov esi,coeff_a

	vbroadcastss ymm0,dword ptr[esi]

	movzx edx,lgth
	mov esi,coeff_b
	mov ecx,edx
	mov eax,128

	shr ecx,2
	jz short CoeffProduct2F_AVX_1

CoeffProduct2F_AVX_loop_1:	
	vmulps ymm1,ymm0,YMMWORD ptr[esi]
	vmulps ymm2,ymm0,YMMWORD ptr[esi+32]
	vmulps ymm3,ymm0,YMMWORD ptr[esi+64]
	vmulps ymm4,ymm0,YMMWORD ptr[esi+96]
	vmovaps YMMWORD ptr[esi],ymm1
	vmovaps YMMWORD ptr[esi+32],ymm2
	vmovaps YMMWORD ptr[esi+64],ymm3
	vmovaps YMMWORD ptr[esi+96],ymm4
	add esi,eax
	loop CoeffProduct2F_AVX_loop_1

CoeffProduct2F_AVX_1:
	test edx,2
	jz short CoeffProduct2F_AVX_2

	vmulps ymm1,ymm0,YMMWORD ptr[esi]
	vmulps ymm2,ymm0,YMMWORD ptr[esi+32]
	vmovaps YMMWORD ptr[esi],ymm1
	vmovaps YMMWORD ptr[esi+32],ymm2
	add esi,64

CoeffProduct2F_AVX_2:
	test edx,1
	jz short CoeffProduct2F_AVX_3

	vmulps ymm1,ymm0,YMMWORD ptr[esi]
	vmovaps YMMWORD ptr[esi],ymm1

CoeffProduct2F_AVX_3:
	vzeroupper

	pop esi

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
	push esi

	mov edx,coeff_a

	vbroadcastsd ymm0,qword ptr[edx]

	movzx ebx,lgth
	mov esi,coeff_b
	mov edx,coeff_c
	mov ecx,ebx
	mov eax,128

	shr ecx,2
	jz short CoeffProductD_AVX_1

CoeffProductD_AVX_loop_1:
	vmulpd ymm1,ymm0,YMMWORD ptr[esi]
	vmulpd ymm2,ymm0,YMMWORD ptr[esi+32]
	vmulpd ymm3,ymm0,YMMWORD ptr[esi+64]
	vmulpd ymm4,ymm0,YMMWORD ptr[esi+96]
	vmovapd YMMWORD ptr[edx],ymm1
	vmovapd YMMWORD ptr[edx+32],ymm2
	vmovapd YMMWORD ptr[edx+64],ymm3
	vmovapd YMMWORD ptr[edx+96],ymm4
	add esi,eax
	add edx,eax
	loop CoeffProductD_AVX_loop_1

CoeffProductD_AVX_1:
	test ebx,2
	jz short CoeffProductD_AVX_2

	vmulpd ymm1,ymm0,YMMWORD ptr[esi]
	vmulpd ymm2,ymm0,YMMWORD ptr[esi+32]
	vmovapd YMMWORD ptr[edx],ymm1
	vmovapd YMMWORD ptr[edx+32],ymm2
	add esi,64
	add edx,64

CoeffProductD_AVX_2:
	test ebx,1
	jz short CoeffProductD_AVX_3

	vmulpd ymm1,ymm0,YMMWORD ptr[esi]
	vmovapd YMMWORD ptr[edx],ymm1

CoeffProductD_AVX_3:
	vzeroupper

	pop esi
	pop ebx

	ret

CoeffProductD_AVX endp	


CoeffProduct2D_AVX proc coeff_a:dword,coeff_b:dword,lgth:word

    public CoeffProduct2D_AVX

	push esi

	mov esi,coeff_a

	vbroadcastsd ymm0,qword ptr[esi]

	movzx edx,lgth
	mov esi,coeff_b
	mov ecx,edx
	mov eax,128

	shr ecx,2
	jz short CoeffProduct2D_AVX_1

CoeffProduct2D_AVX_loop_1:
	vmulpd ymm1,ymm0,YMMWORD ptr[esi]
	vmulpd ymm2,ymm0,YMMWORD ptr[esi+32]
	vmulpd ymm3,ymm0,YMMWORD ptr[esi+64]
	vmulpd ymm4,ymm0,YMMWORD ptr[esi+96]
	vmovapd YMMWORD ptr[esi],ymm1
	vmovapd YMMWORD ptr[esi+32],ymm2
	vmovapd YMMWORD ptr[esi+64],ymm3
	vmovapd YMMWORD ptr[esi+96],ymm4
	add esi,eax
	loop CoeffProduct2D_AVX_loop_1

CoeffProduct2D_AVX_1:
	test edx,2
	jz short CoeffProduct2D_AVX_2

	vmulpd ymm1,ymm0,YMMWORD ptr[esi]
	vmulpd ymm2,ymm0,YMMWORD ptr[esi+32]
	vmovapd YMMWORD ptr[esi],ymm1
	vmovapd YMMWORD ptr[esi+32],ymm2
	add esi,64

CoeffProduct2D_AVX_2:
	test edx,1
	jz short CoeffProduct2D_AVX_3

	vmulpd ymm1,ymm0,YMMWORD ptr[esi]
	vmovapd YMMWORD ptr[esi],ymm1

CoeffProduct2D_AVX_3:
	vzeroupper

	pop esi

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
	push esi

	mov edx,coeff_a

	vbroadcastss ymm0,dword ptr[edx]

	movzx ebx,lgth
	mov esi,coeff_b
	mov edx,coeff_c
	mov ecx,ebx
	mov eax,64

	shr ecx,1
	jz short CoeffAddProductF_AVX_1

CoeffAddProductF_AVX_loop_1:
	vmulps ymm1,ymm0,YMMWORD ptr[esi]
	vmulps ymm2,ymm0,YMMWORD ptr[esi+32]
	vaddps ymm3,ymm1,YMMWORD ptr[edx]
	vaddps ymm4,ymm2,YMMWORD ptr[edx+32]
	vmovaps YMMWORD ptr[edx],ymm3
	vmovaps YMMWORD ptr[edx+32],ymm4
	add esi,eax
	add edx,eax
	loop CoeffAddProductF_AVX_loop_1

CoeffAddProductF_AVX_1:
	test ebx,1
	jz short CoeffAddProductF_AVX_2

	vmulps ymm1,ymm0,YMMWORD ptr[esi]
	vaddps ymm3,ymm1,YMMWORD ptr[edx]
	vmovaps YMMWORD ptr[edx],ymm3

CoeffAddProductF_AVX_2:
	vzeroupper

	pop esi
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
	push esi

	mov edx,coeff_a

	vbroadcastsd ymm0,qword ptr[edx]

	movzx ebx,lgth
	mov esi,coeff_b
	mov edx,coeff_c
	mov ecx,ebx
	mov eax,64

	shr ecx,1
	jz short CoeffAddProductD_AVX_1

CoeffAddProductD_AVX_loop_1:
	vmulpd ymm1,ymm0,YMMWORD ptr[esi]
	vmulpd ymm2,ymm0,YMMWORD ptr[esi+32]
	vaddpd ymm3,ymm1,YMMWORD ptr[edx]
	vaddpd ymm4,ymm2,YMMWORD ptr[edx+32]
	vmovapd YMMWORD ptr[edx],ymm3
	vmovapd YMMWORD ptr[edx+32],ymm4
	add esi,eax
	add edx,eax
	loop CoeffAddProductD_AVX_loop_1

CoeffAddProductD_AVX_1:
	test ebx,1
	jz short CoeffAddProductD_AVX_2

	vmulpd ymm1,ymm0,YMMWORD ptr[esi]
	vaddpd ymm3,ymm1,YMMWORD ptr[edx]
	vmovapd YMMWORD ptr[edx],ymm3

CoeffAddProductD_AVX_2:
	vzeroupper

	pop esi
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
	push esi

	mov esi,coeff_a

	vbroadcastss ymm0,dword ptr[esi]

	movzx ebx,lgth
	mov esi,coeff_b
	mov edx,coeff_c
	mov ecx,ebx
	mov eax,128

	shr ecx,2
	jz short CoeffAddF_AVX_1

CoeffAddF_AVX_loop_1:
	vaddps ymm1,ymm0,YMMWORD ptr[esi]
	vaddps ymm2,ymm0,YMMWORD ptr[esi+32]
	vaddps ymm3,ymm0,YMMWORD ptr[esi+64]
	vaddps ymm4,ymm0,YMMWORD ptr[esi+96]
	vmovaps YMMWORD ptr[edx],ymm1
	vmovaps YMMWORD ptr[edx+32],ymm2
	vmovaps YMMWORD ptr[edx+64],ymm3
	vmovaps YMMWORD ptr[edx+96],ymm4
	add esi,eax
	add edx,eax
	loop CoeffAddF_AVX_loop_1

CoeffAddF_AVX_1:
	test ebx,2
	jz short CoeffAddF_AVX_2

	vaddps ymm1,ymm0,YMMWORD ptr[esi]
	vaddps ymm2,ymm0,YMMWORD ptr[esi+32]
	vmovaps YMMWORD ptr[edx],ymm1
	vmovaps YMMWORD ptr[edx+32],ymm2
	add esi,64
	add edx,64

CoeffAddF_AVX_2:
	test ebx,1
	jz short CoeffAddF_AVX_3

	vaddps ymm1,ymm0,YMMWORD ptr[esi]
	vmovaps YMMWORD ptr[edx],ymm1

CoeffAddF_AVX_3:
	vzeroupper

	pop esi
	pop ebx

	ret

CoeffAddF_AVX endp


CoeffAdd2F_AVX proc coeff_a:dword,coeff_b:dword,lgth:word

    public CoeffAdd2F_AVX

	push esi

	mov esi,coeff_a

	vbroadcastss ymm0,dword ptr[esi]

	movzx edx,lgth
	mov esi,coeff_b
	mov ecx,edx
	mov eax,128

	shr ecx,2
	jz short CoeffAdd2F_AVX_1

CoeffAdd2F_AVX_loop_1:
	vaddps ymm1,ymm0,YMMWORD ptr[esi]
	vaddps ymm2,ymm0,YMMWORD ptr[esi+32]
	vaddps ymm3,ymm0,YMMWORD ptr[esi+64]
	vaddps ymm4,ymm0,YMMWORD ptr[esi+96]
	vmovaps YMMWORD ptr[esi],ymm1
	vmovaps YMMWORD ptr[esi+32],ymm2
	vmovaps YMMWORD ptr[esi+64],ymm3
	vmovaps YMMWORD ptr[esi+96],ymm4
	add esi,eax
	loop CoeffAdd2F_AVX_loop_1

CoeffAdd2F_AVX_1:
	test edx,2
	jz short CoeffAdd2F_AVX_2

	vaddps ymm1,ymm0,YMMWORD ptr[esi]
	vaddps ymm2,ymm0,YMMWORD ptr[esi+32]
	vmovaps YMMWORD ptr[esi],ymm1
	vmovaps YMMWORD ptr[esi+32],ymm2
	add esi,64

CoeffAdd2F_AVX_2:
	test edx,1
	jz short CoeffAdd2F_AVX_3

	vaddps ymm1,ymm0,YMMWORD ptr[esi]
	vmovaps YMMWORD ptr[esi],ymm1

CoeffAdd2F_AVX_3:
	vzeroupper

	pop esi

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
	push esi

	mov esi,coeff_a

	vbroadcastsd ymm0,qword ptr[esi]

	movzx ebx,lgth
	mov esi,coeff_b
	mov edx,coeff_c
	mov ecx,ebx
	mov eax,128

	shr ecx,2
	jz short CoeffAddD_AVX_1

CoeffAddD_AVX_loop_1:
	vaddpd ymm1,ymm0,YMMWORD ptr[esi]
	vaddpd ymm2,ymm0,YMMWORD ptr[esi+32]
	vaddpd ymm3,ymm0,YMMWORD ptr[esi+64]
	vaddpd ymm4,ymm0,YMMWORD ptr[esi+96]
	vmovapd YMMWORD ptr[edx],ymm1
	vmovapd YMMWORD ptr[edx+32],ymm2
	vmovapd YMMWORD ptr[edx+64],ymm3
	vmovapd YMMWORD ptr[edx+96],ymm4
	add esi,eax
	add edx,eax
	loop CoeffAddD_AVX_loop_1

CoeffAddD_AVX_1:
	test ebx,2
	jz short CoeffAddD_AVX_2

	vaddpd ymm1,ymm0,YMMWORD ptr[esi]
	vaddpd ymm2,ymm0,YMMWORD ptr[esi+32]
	vmovapd YMMWORD ptr[edx],ymm1
	vmovapd YMMWORD ptr[edx+32],ymm2
	add esi,64
	add edx,64

CoeffAddD_AVX_2:
	test ebx,1
	jz short CoeffAddD_AVX_3

	vaddpd ymm1,ymm0,YMMWORD ptr[esi]
	vmovapd YMMWORD ptr[edx],ymm1

CoeffAddD_AVX_3:
	vzeroupper

	pop esi
	pop ebx

	ret

CoeffAddD_AVX endp


CoeffAdd2D_AVX proc coeff_a:dword,coeff_b:dword,lgth:word

    public CoeffAdd2D_AVX

	push esi

	mov esi,coeff_a

	vbroadcastsd ymm0,qword ptr[esi]

	movzx edx,lgth
	mov esi,coeff_b
	mov ecx,edx
	mov eax,128

	shr ecx,2
	jz short CoeffAdd2D_AVX_1

CoeffAdd2D_AVX_loop_1:
	vaddpd ymm1,ymm0,YMMWORD ptr[esi]
	vaddpd ymm2,ymm0,YMMWORD ptr[esi+32]
	vaddpd ymm3,ymm0,YMMWORD ptr[esi+64]
	vaddpd ymm4,ymm0,YMMWORD ptr[esi+96]
	vmovapd YMMWORD ptr[esi],ymm1
	vmovapd YMMWORD ptr[esi+32],ymm2
	vmovapd YMMWORD ptr[esi+64],ymm3
	vmovapd YMMWORD ptr[esi+96],ymm4
	add esi,eax
	loop CoeffAdd2D_AVX_loop_1

CoeffAdd2D_AVX_1:
	test edx,2
	jz short CoeffAdd2D_AVX_2

	vaddpd ymm1,ymm0,YMMWORD ptr[esi]
	vaddpd ymm2,ymm0,YMMWORD ptr[esi+32]
	vmovapd YMMWORD ptr[esi],ymm1
	vmovapd YMMWORD ptr[esi+32],ymm2
	add esi,64

CoeffAdd2D_AVX_2:
	test edx,1
	jz short CoeffAdd2D_AVX_3

	vaddpd ymm1,ymm0,YMMWORD ptr[esi]
	vmovapd YMMWORD ptr[esi],ymm1

CoeffAdd2D_AVX_3:
	vzeroupper

	pop esi

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
	push esi

	mov edx,coeff_a

	vbroadcastss ymm0,dword ptr[edx]

	movzx ebx,lgth
	mov esi,coeff_b
	mov edx,coeff_c
	mov ecx,ebx
	mov eax,128

	shr ecx,2
	jz short CoeffSubF_AVX_1

CoeffSubF_AVX_loop_1:
	vsubps ymm1,ymm0,YMMWORD ptr[esi]
	vsubps ymm2,ymm0,YMMWORD ptr[esi+32]
	vsubps ymm3,ymm0,YMMWORD ptr[esi+64]
	vsubps ymm4,ymm0,YMMWORD ptr[esi+96]
	vmovaps YMMWORD ptr[edx],ymm1
	vmovaps YMMWORD ptr[edx+32],ymm2
	vmovaps YMMWORD ptr[edx+64],ymm3
	vmovaps YMMWORD ptr[edx+96],ymm4
	add esi,eax
	add edx,eax
	loop CoeffSubF_AVX_loop_1

CoeffSubF_AVX_1:
	test ebx,2
	jz short CoeffSubF_AVX_2

	vsubps ymm1,ymm0,YMMWORD ptr[esi]
	vsubps ymm2,ymm0,YMMWORD ptr[esi+32]
	vmovaps YMMWORD ptr[edx],ymm1
	vmovaps YMMWORD ptr[edx+32],ymm2
	add esi,64
	add edx,64

CoeffSubF_AVX_2:
	test ebx,1
	jz short CoeffSubF_AVX_3

	vsubps ymm1,ymm0,YMMWORD ptr[esi]
	vmovaps YMMWORD ptr[edx],ymm1

CoeffSubF_AVX_3:
	vzeroupper

	pop esi
	pop ebx

	ret

CoeffSubF_AVX endp
	

CoeffSub2F_AVX proc coeff_a:dword,coeff_b:dword,lgth:word

    public CoeffSub2F_AVX

	push esi

	mov esi,coeff_a

	vbroadcastss ymm0,dword ptr[esi]

	movzx edx,lgth
	mov esi,coeff_b
	mov ecx,edx
	mov eax,128

	shr ecx,2
	jz short CoeffSub2F_AVX_1

CoeffSub2F_AVX_loop_1:
	vsubps ymm1,ymm0,YMMWORD ptr[esi]
	vsubps ymm2,ymm0,YMMWORD ptr[esi+32]
	vsubps ymm3,ymm0,YMMWORD ptr[esi+64]
	vsubps ymm4,ymm0,YMMWORD ptr[esi+96]
	vmovaps YMMWORD ptr[esi],ymm1
	vmovaps YMMWORD ptr[esi+32],ymm2
	vmovaps YMMWORD ptr[esi+64],ymm3
	vmovaps YMMWORD ptr[esi+96],ymm4
	add esi,eax
	loop CoeffSub2F_AVX_loop_1

CoeffSub2F_AVX_1:
	test edx,2
	jz short CoeffSub2F_AVX_2

	vsubps ymm1,ymm0,YMMWORD ptr[esi]
	vsubps ymm2,ymm0,YMMWORD ptr[esi+32]
	vmovaps YMMWORD ptr[esi],ymm1
	vmovaps YMMWORD ptr[esi+32],ymm2
	add esi,64

CoeffSub2F_AVX_2:
	test edx,1
	jz short CoeffSub2F_AVX_3

	vsubps ymm1,ymm0,YMMWORD ptr[esi]
	vmovaps YMMWORD ptr[esi],ymm1

CoeffSub2F_AVX_3:
	vzeroupper

	pop esi

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
	push esi

	mov edx,coeff_a

	vbroadcastsd ymm0,qword ptr[edx]

	movzx ebx,lgth
	mov esi,coeff_b
	mov edx,coeff_c
	mov ecx,ebx
	mov eax,128

	shr ecx,2
	jz short CoeffSubD_AVX_1

CoeffSubD_AVX_loop_1:
	vsubpd ymm1,ymm0,YMMWORD ptr[esi]
	vsubpd ymm2,ymm0,YMMWORD ptr[esi+32]
	vsubpd ymm3,ymm0,YMMWORD ptr[esi+64]
	vsubpd ymm4,ymm0,YMMWORD ptr[esi+96]
	vmovapd YMMWORD ptr[edx],ymm1
	vmovapd YMMWORD ptr[edx+32],ymm2
	vmovapd YMMWORD ptr[edx+64],ymm3
	vmovapd YMMWORD ptr[edx+96],ymm4
	add esi,eax
	add edx,eax
	loop CoeffSubD_AVX_loop_1

CoeffSubD_AVX_1:
	test ebx,2
	jz short CoeffSubD_AVX_2

	vsubpd ymm1,ymm0,YMMWORD ptr[esi]
	vsubpd ymm2,ymm0,YMMWORD ptr[esi+32]
	vmovapd YMMWORD ptr[edx],ymm1
	vmovapd YMMWORD ptr[edx+32],ymm2
	add esi,64
	add edx,64

CoeffSubD_AVX_2:
	test ebx,1
	jz short CoeffSubD_AVX_3

	vsubpd ymm1,ymm0,YMMWORD ptr[esi]
	vmovapd YMMWORD ptr[edx],ymm1

CoeffSubD_AVX_3:
	vzeroupper

	pop esi
	pop ebx

	ret

CoeffSubD_AVX endp	


CoeffSub2D_AVX proc coeff_a:dword,coeff_b:dword,lgth:word

    public CoeffSub2D_AVX

	push esi

	mov esi,coeff_a

	vbroadcastsd ymm0,qword ptr[esi]

	movzx edx,lgth
	mov esi,coeff_b
	mov ecx,edx
	mov eax,128

	shr ecx,2
	jz short CoeffSub2D_AVX_1

CoeffSub2D_AVX_loop_1:
	vsubpd ymm1,ymm0,YMMWORD ptr[esi]
	vsubpd ymm2,ymm0,YMMWORD ptr[esi+32]
	vsubpd ymm3,ymm0,YMMWORD ptr[esi+64]
	vsubpd ymm4,ymm0,YMMWORD ptr[esi+96]
	vmovapd YMMWORD ptr[esi],ymm1
	vmovapd YMMWORD ptr[esi+32],ymm2
	vmovapd YMMWORD ptr[esi+64],ymm3
	vmovapd YMMWORD ptr[esi+96],ymm4
	add esi,eax
	loop CoeffSub2D_AVX_loop_1

CoeffSub2D_AVX_1:
	test edx,2
	jz short CoeffSub2D_AVX_2

	vsubpd ymm1,ymm0,YMMWORD ptr[esi]
	vsubpd ymm2,ymm0,YMMWORD ptr[esi+32]
	vmovapd YMMWORD ptr[esi],ymm1
	vmovapd YMMWORD ptr[esi+32],ymm2
	add esi,64

CoeffSub2D_AVX_2:
	test edx,1
	jz short CoeffSub2D_AVX_3

	vsubpd ymm1,ymm0,YMMWORD ptr[esi]
	vmovapd YMMWORD ptr[esi],ymm1

CoeffSub2D_AVX_3:
	vzeroupper

	pop esi

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

	push esi
	push ebx

	mov esi,coeff_x

	movzx edx,lgth
	mov eax,128
	mov ebx,32
	mov ecx,edx

	vxorps ymm0,ymm0,ymm0

	shr ecx,2
	jz short VectorNorme2F_AVX_1

VectorNorme2F_AVX_loop_1:
	vmovaps ymm1,YMMWORD ptr[esi]
	vmovaps ymm2,YMMWORD ptr[esi+ebx]
	vmovaps ymm3,YMMWORD ptr[esi+2*ebx]
	vmovaps ymm4,YMMWORD ptr[esi+96]

	vmulps ymm1,ymm1,ymm1
	vmulps ymm2,ymm2,ymm2
	vmulps ymm3,ymm3,ymm3
	vmulps ymm4,ymm4,ymm4

	vaddps ymm1,ymm1,ymm2
	vaddps ymm3,ymm3,ymm4
	vaddps ymm1,ymm1,ymm3
	add esi,eax
	vaddps ymm0,ymm0,ymm1
	loop VectorNorme2F_AVX_loop_1

VectorNorme2F_AVX_1:
	test edx,2
	jz short VectorNorme2F_AVX_2

	vmovaps ymm1,YMMWORD ptr[esi]
	vmovaps ymm2,YMMWORD ptr[esi+ebx]
	vmulps ymm1,ymm1,ymm1
	vmulps ymm2,ymm2,ymm2

	vaddps ymm1,ymm1,ymm2
	add esi,64
	vaddps ymm0,ymm0,ymm1

VectorNorme2F_AVX_2:
	test edx,1
	jz short VectorNorme2F_AVX_3

	vmovaps ymm1,YMMWORD ptr[esi]
	vmulps ymm1,ymm1,ymm1
	vaddps ymm0,ymm0,ymm1

VectorNorme2F_AVX_3:
	vextractf128 xmm1,ymm0,1
	vaddps xmm0,xmm0,xmm1

	vmovhlps xmm1,xmm1,xmm0
	vaddps xmm0,xmm0,xmm1
	mov esi,result
	vpsrldq xmm1,xmm0,4
	vaddss xmm0,xmm0,xmm1
	vsqrtss xmm0,xmm0,xmm0
	vmovss dword ptr[esi],xmm0

	vzeroupper

	pop ebx
	pop esi

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

	push esi
	push ebx

	mov esi,coeff_x
	movzx edx,lgth
	mov eax,128
	mov ebx,32
	mov ecx,edx

	vxorpd ymm0,ymm0,ymm0

	shr ecx,2
	jz short VectorNorme2D_AVX_1

VectorNorme2D_AVX_loop_1:
	vmovapd ymm1,YMMWORD ptr[esi]
	vmovapd ymm2,YMMWORD ptr[esi+ebx]
	vmovapd ymm3,YMMWORD ptr[esi+2*ebx]
	vmovapd ymm4,YMMWORD ptr[esi+96]

	vmulpd ymm1,ymm1,ymm1
	vmulpd ymm2,ymm2,ymm2
	vmulpd ymm3,ymm3,ymm3
	vmulpd ymm4,ymm4,ymm4

	vaddpd ymm1,ymm1,ymm2
	vaddpd ymm3,ymm3,ymm4
	vaddpd ymm1,ymm1,ymm3
	add esi,eax
	vaddpd ymm0,ymm0,ymm1
	loop VectorNorme2D_AVX_loop_1

VectorNorme2D_AVX_1:
	test edx,2
	jz short VectorNorme2D_AVX_2

	vmovapd ymm1,YMMWORD ptr[esi]
	vmovapd ymm2,YMMWORD ptr[esi+ebx]
	vmulpd ymm1,ymm1,ymm1
	vmulpd ymm2,ymm2,ymm2

	vaddpd ymm1,ymm1,ymm2
	add esi,64
	vaddpd ymm0,ymm0,ymm1

VectorNorme2D_AVX_2:
	test edx,1
	jz short VectorNorme2D_AVX_3

	vmovapd ymm1,YMMWORD ptr[esi]
	vmulpd ymm1,ymm1,ymm1
	vaddpd ymm0,ymm0,ymm1

VectorNorme2D_AVX_3:
	vextractf128 xmm1,ymm0,1
	vaddpd xmm0,xmm0,xmm1

	vmovhlps xmm1,xmm1,xmm0
	mov esi,result
	vaddsd xmm0,xmm0,xmm1
	vsqrtsd xmm0,xmm0,xmm0
	vmovsd qword ptr[esi],xmm0

	vzeroupper

	pop ebx
	pop esi

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

	push esi
	push edi

	mov esi,coeff_x
	mov edi,coeff_y
	movzx edx,lgth
	mov eax,128
	mov ecx,edx

	vxorps ymm0,ymm0,ymm0

	shr ecx,2
	jz short VectorDist2F_AVX_1

VectorDist2F_AVX_loop_1:
	vmovaps ymm1,YMMWORD ptr[esi]
	vmovaps ymm2,YMMWORD ptr[esi+32]
	vmovaps ymm3,YMMWORD ptr[esi+64]
	vmovaps ymm4,YMMWORD ptr[esi+96]

	vsubps ymm1,ymm1,YMMWORD ptr[edi]
	vsubps ymm2,ymm2,YMMWORD ptr[edi+32]
	vsubps ymm3,ymm3,YMMWORD ptr[edi+64]
	vsubps ymm4,ymm4,YMMWORD ptr[edi+96]

	vmulps ymm1,ymm1,ymm1
	vmulps ymm2,ymm2,ymm2
	vmulps ymm3,ymm3,ymm3
	vmulps ymm4,ymm4,ymm4

	vaddps ymm1,ymm1,ymm2
	vaddps ymm3,ymm3,ymm4
	add esi,eax
	vaddps ymm1,ymm1,ymm3
	add edi,eax
	vaddps ymm0,ymm0,ymm1

	loop VectorDist2F_AVX_loop_1

VectorDist2F_AVX_1:
	test edx,2
	jz short VectorDist2F_AVX_2

	vmovaps ymm1,YMMWORD ptr[esi]
	vmovaps ymm2,YMMWORD ptr[esi+32]
	vsubps ymm1,ymm1,YMMWORD ptr[edi]
	vsubps ymm2,ymm2,YMMWORD ptr[edi+32]
	vmulps ymm1,ymm1,ymm1
	vmulps ymm2,ymm2,ymm2

	add esi,64
	vaddps ymm1,ymm1,ymm2
	add edi,64
	vaddps ymm0,ymm0,ymm1

VectorDist2F_AVX_2:
	test edx,1
	jz short VectorDist2F_AVX_3

	vmovaps ymm1,YMMWORD ptr[esi]
	vsubps ymm1,ymm1,YMMWORD ptr[edi]
	vmulps ymm1,ymm1,ymm1
	vaddps ymm0,ymm0,ymm1

VectorDist2F_AVX_3:
	vextractf128 xmm1,ymm0,1
	vaddps xmm0,xmm0,xmm1

	vmovhlps xmm1,xmm1,xmm0
	vaddps xmm0,xmm0,xmm1
	mov edi,result
	vpsrldq xmm1,xmm0,4
	vaddss xmm0,xmm0,xmm1
	vsqrtss xmm0,xmm0,xmm0
	vmovss dword ptr[edi],xmm0

	vzeroupper

	pop edi
	pop esi

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

	push esi
	push edi

	mov esi,coeff_x
	mov edi,coeff_y
	movzx edx,lgth
	mov eax,128
	mov ecx,edx

	vxorps ymm0,ymm0,ymm0

	shr ecx,2
	jz short VectorDist2D_AVX_1

VectorDist2D_AVX_loop_1:
	vmovapd ymm1,YMMWORD ptr[esi]
	vmovapd ymm2,YMMWORD ptr[esi+32]
	vmovapd ymm3,YMMWORD ptr[esi+64]
	vmovapd ymm4,YMMWORD ptr[esi+96]

	vsubpd ymm1,ymm1,YMMWORD ptr[edi]
	vsubpd ymm2,ymm2,YMMWORD ptr[edi+32]
	vsubpd ymm3,ymm3,YMMWORD ptr[edi+64]
	vsubpd ymm4,ymm4,YMMWORD ptr[edi+96]

	vmulpd ymm1,ymm1,ymm1
	vmulpd ymm2,ymm2,ymm2
	vmulpd ymm3,ymm3,ymm3
	vmulpd ymm4,ymm4,ymm4

	vaddpd ymm1,ymm1,ymm2
	vaddpd ymm3,ymm3,ymm4
	add esi,eax
	vaddpd ymm1,ymm1,ymm3
	add edi,eax
	vaddpd ymm0,ymm0,ymm1

	loop VectorDist2D_AVX_loop_1

VectorDist2D_AVX_1:
	test edx,2
	jz short VectorDist2D_AVX_2

	vmovapd ymm1,YMMWORD ptr[esi]
	vmovapd ymm2,YMMWORD ptr[esi+32]
	vsubpd ymm1,ymm1,YMMWORD ptr[edi]
	vsubpd ymm2,ymm2,YMMWORD ptr[edi+32]
	vmulpd ymm1,ymm1,ymm1
	vmulpd ymm2,ymm2,ymm2

	add esi,64
	vaddpd ymm1,ymm1,ymm2
	add edi,64
	vaddpd ymm0,ymm0,ymm1

VectorDist2D_AVX_2:
	test edx,1
	jz short VectorDist2D_AVX_3

	vmovapd ymm1,YMMWORD ptr[esi]
	vsubpd ymm1,ymm1,YMMWORD ptr[edi]
	vmulpd ymm1,ymm1,ymm1
	vaddpd ymm0,ymm0,ymm1

VectorDist2D_AVX_3:
	vextractf128 xmm1,ymm0,1
	vaddpd xmm0,xmm0,xmm1

	vmovhlps xmm1,xmm1,xmm0
	mov edi,result
	vaddsd xmm0,xmm0,xmm1
	vsqrtsd xmm0,xmm0,xmm0
	vmovsd qword ptr[edi],xmm0

	vzeroupper

	pop edi
	pop esi

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

	push ebx
	push esi

	mov esi,coeff_x
	movzx edx,lgth
	mov eax,128
	mov ebx,32
	mov ecx,edx

	vxorps ymm0,ymm0,ymm0

	shr ecx,2
	jz short VectorNormeF_AVX_1

VectorNormeF_AVX_loop_1:
	vmovaps ymm1,YMMWORD ptr[esi]
	vmovaps ymm2,YMMWORD ptr[esi+ebx]
	vmovaps ymm3,YMMWORD ptr[esi+2*ebx]
	vmovaps ymm4,YMMWORD ptr[esi+96]

	vmulps ymm1,ymm1,ymm1
	vmulps ymm2,ymm2,ymm2
	vmulps ymm3,ymm3,ymm3
	vmulps ymm4,ymm4,ymm4

	vaddps ymm1,ymm1,ymm2
	vaddps ymm3,ymm3,ymm4
	vaddps ymm1,ymm1,ymm3
	add esi,eax
	vaddps ymm0,ymm0,ymm1

	loop VectorNormeF_AVX_loop_1

VectorNormeF_AVX_1:
	test edx,2
	jz short VectorNormeF_AVX_2

	vmovaps ymm1,YMMWORD ptr[esi]
	vmovaps ymm2,YMMWORD ptr[esi+ebx]
	vmulps ymm1,ymm1,ymm1
	vmulps ymm2,ymm2,ymm2

	vaddps ymm1,ymm1,ymm2
	add esi,64
	vaddps ymm0,ymm0,ymm1

VectorNormeF_AVX_2:
	test edx,1
	jz short VectorNormeF_AVX_3

	vmovaps ymm1,YMMWORD ptr[esi]
	vmulps ymm1,ymm1,ymm1
	vaddps ymm0,ymm0,ymm1

VectorNormeF_AVX_3:
	vextractf128 xmm1,ymm0,1
	vaddps xmm0,xmm0,xmm1

	vmovhlps xmm1,xmm1,xmm0
	vaddps xmm0,xmm0,xmm1
	mov esi,result
	vpsrldq xmm1,xmm0,4
	vaddss xmm0,xmm0,xmm1
	vmovss dword ptr[esi],xmm0

	vzeroupper

	pop esi
	pop ebx

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

	push ebx
	push esi

	mov esi,coeff_x
	movzx edx,lgth
	mov eax,128
	mov ebx,32
	mov ecx,edx

	vxorpd ymm0,ymm0,ymm0

	shr ecx,2
	jz short VectorNormeD_AVX_1

VectorNormeD_AVX_loop_1:
	vmovapd ymm1,YMMWORD ptr[esi]
	vmovapd ymm2,YMMWORD ptr[esi+ebx]
	vmovapd ymm3,YMMWORD ptr[esi+2*ebx]
	vmovapd ymm4,YMMWORD ptr[esi+96]

	vmulpd ymm1,ymm1,ymm1
	vmulpd ymm2,ymm2,ymm2
	vmulpd ymm3,ymm3,ymm3
	vmulpd ymm4,ymm4,ymm4

	vaddpd ymm1,ymm1,ymm2
	vaddpd ymm3,ymm3,ymm4
	vaddpd ymm1,ymm1,ymm3
	add esi,eax
	vaddpd ymm0,ymm0,ymm1

	loop VectorNormeD_AVX_loop_1

VectorNormeD_AVX_1:
	test edx,2
	jz short VectorNormeD_AVX_2

	vmovapd ymm1,YMMWORD ptr[esi]
	vmovapd ymm2,YMMWORD ptr[esi+ebx]
	vmulpd ymm1,ymm1,ymm1
	vmulpd ymm2,ymm2,ymm2

	vaddpd ymm1,ymm1,ymm2
	add esi,64
	vaddpd ymm0,ymm0,ymm1

VectorNormeD_AVX_2:
	test edx,1
	jz short VectorNormeD_AVX_3

	vmovapd ymm1,YMMWORD ptr[esi]
	vmulpd ymm1,ymm1,ymm1
	vaddpd ymm0,ymm0,ymm1

VectorNormeD_AVX_3:
	vextractf128 xmm1,ymm0,1
	vaddpd xmm0,xmm0,xmm1

	vmovhlps xmm1,xmm1,xmm0
	mov esi,result
	vaddsd xmm0,xmm0,xmm1
	vmovsd qword ptr[esi],xmm0

	vzeroupper	

	pop esi
	pop ebx

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
	push esi
	push edi

	mov esi,coeff_x
	mov edi,coeff_y
	movzx edx,lgth
	mov eax,128
	mov ebx,32
	mov ecx,edx

	vxorps ymm0,ymm0,ymm0

	shr ecx,2
	jz short VectorDistF_AVX_1

VectorDistF_AVX_loop_1:
	vmovaps ymm1,YMMWORD ptr[esi]
	vmovaps ymm2,YMMWORD ptr[esi+ebx]
	vmovaps ymm3,YMMWORD ptr[esi+2*ebx]
	vmovaps ymm4,YMMWORD ptr[esi+96]

	vsubps ymm1,ymm1,YMMWORD ptr[edi]
	vsubps ymm2,ymm2,YMMWORD ptr[edi+ebx]
	vsubps ymm3,ymm3,YMMWORD ptr[edi+2*ebx]
	vsubps ymm4,ymm4,YMMWORD ptr[edi+96]

	vmulps ymm1,ymm1,ymm1
	vmulps ymm2,ymm2,ymm2
	vmulps ymm3,ymm3,ymm3
	vmulps ymm4,ymm4,ymm4

	vaddps ymm1,ymm1,ymm2
	vaddps ymm3,ymm3,ymm4
	add esi,eax
	vaddps ymm1,ymm1,ymm3
	add edi,eax
	vaddps ymm0,ymm0,ymm1

	loop VectorDistF_AVX_loop_1

VectorDistF_AVX_1:
	test edx,2
	jz short VectorDistF_AVX_2

	vmovaps ymm1,YMMWORD ptr[esi]
	vmovaps ymm2,YMMWORD ptr[esi+ebx]
	vsubps ymm1,ymm1,YMMWORD ptr[edi]
	vsubps ymm2,ymm2,YMMWORD ptr[edi+ebx]
	vmulps ymm1,ymm1,ymm1
	vmulps ymm2,ymm2,ymm2

	add esi,64
	vaddps ymm1,ymm1,ymm2
	add edi,64
	vaddps ymm0,ymm0,ymm1

VectorDistF_AVX_2:
	test edx,1
	jz short VectorDistF_AVX_3

	vmovaps ymm1,YMMWORD ptr[esi]
	vsubps ymm1,ymm1,YMMWORD ptr[edi]
	vmulps ymm1,ymm1,ymm1
	vaddps ymm0,ymm0,ymm1

VectorDistF_AVX_3:
	vextractf128 xmm1,ymm0,1
	vaddps xmm0,xmm0,xmm1

	vmovhlps xmm1,xmm1,xmm0
	vaddps xmm0,xmm0,xmm1
	mov edi,result
	vpsrldq xmm1,xmm0,4
	vaddss xmm0,xmm0,xmm1
	vmovss dword ptr[edi],xmm0

	vzeroupper

	pop edi
	pop esi
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
	push esi
	push edi

	mov esi,coeff_x
	mov edi,coeff_y
	movzx edx,lgth
	mov eax,128
	mov ebx,32
	mov ecx,edx

	vxorpd ymm0,ymm0,ymm0

	shr ecx,2
	jz short VectorDistD_AVX_1

VectorDistD_AVX_loop_1:
	vmovapd ymm1,YMMWORD ptr[esi]
	vmovapd ymm2,YMMWORD ptr[esi+ebx]
	vmovapd ymm3,YMMWORD ptr[esi+2*ebx]
	vmovapd ymm4,YMMWORD ptr[esi+96]

	vsubpd ymm1,ymm1,YMMWORD ptr[edi]
	vsubpd ymm2,ymm2,YMMWORD ptr[edi+ebx]
	vsubpd ymm3,ymm3,YMMWORD ptr[edi+2*ebx]
	vsubpd ymm4,ymm4,YMMWORD ptr[edi+96]

	vmulpd ymm1,ymm1,ymm1
	vmulpd ymm2,ymm2,ymm2
	vmulpd ymm3,ymm3,ymm3
	vmulpd ymm4,ymm4,ymm4

	vaddpd ymm1,ymm1,ymm2
	vaddpd ymm3,ymm3,ymm4
	add esi,eax
	vaddpd ymm1,ymm1,ymm3
	add edi,eax
	vaddpd ymm0,ymm0,ymm1

	loop VectorDistD_AVX_loop_1

VectorDistD_AVX_1:
	test edx,2
	jz short VectorDistD_AVX_2

	vmovapd ymm1,YMMWORD ptr[esi]
	vmovapd ymm2,YMMWORD ptr[esi+ebx]
	vsubpd ymm1,ymm1,YMMWORD ptr[edi]
	vsubpd ymm2,ymm2,YMMWORD ptr[edi+ebx]
	vmulpd ymm1,ymm1,ymm1
	vmulpd ymm2,ymm2,ymm2

	add esi,64
	vaddpd ymm1,ymm1,ymm2
	add edi,64
	vaddpd ymm0,ymm0,ymm1

VectorDistD_AVX_2:
	test edx,1
	jz short VectorDistD_AVX_3

	vmovapd ymm1,YMMWORD ptr[esi]
	vsubpd ymm1,ymm1,YMMWORD ptr[edi]
	vmulpd ymm1,ymm1,ymm1
	vaddpd ymm0,ymm0,ymm1

VectorDistD_AVX_3:
	vextractf128 xmm1,ymm0,1
	vaddpd xmm0,xmm0,xmm1

	vmovhlps xmm1,xmm1,xmm0
	mov edi,result
	vaddsd xmm0,xmm0,xmm1
	vmovsd qword ptr[edi],xmm0

	vzeroupper

	pop edi
	pop esi
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

	push ebx
	push esi

	mov esi,coeff_x
	movzx edx,lgth
	mov eax,128
	mov ebx,32
	mov ecx,edx

	vxorps ymm0,ymm0,ymm0
	vmovaps ymm5,YMMWORD ptr sign_bits_f_32

	shr ecx,2
	jz short VectorNorme1F_AVX_1

VectorNorme1F_AVX_loop_1:
	vandps ymm1,ymm5,YMMWORD ptr[esi]
	vandps ymm2,ymm5,YMMWORD ptr[esi+ebx]
	vandps ymm3,ymm5,YMMWORD ptr[esi+2*ebx]
	vandps ymm4,ymm5,YMMWORD ptr[esi+96]

	vaddps ymm1,ymm1,ymm2
	vaddps ymm3,ymm3,ymm4
	vaddps ymm1,ymm1,ymm3
	add esi,eax
	vaddps ymm0,ymm0,ymm1

	loop VectorNorme1F_AVX_loop_1

VectorNorme1F_AVX_1:
	test edx,2
	jz short VectorNorme1F_AVX_2

	vandps ymm1,ymm5,YMMWORD ptr[esi]
	vandps ymm2,ymm5,YMMWORD ptr[esi+ebx]

	vaddps ymm1,ymm1,ymm2
	add esi,64
	vaddps ymm0,ymm0,ymm1

VectorNorme1F_AVX_2:
	test edx,1
	jz short VectorNorme1F_AVX_3

	vandps ymm1,ymm5,YMMWORD ptr[esi]
	vaddps ymm0,ymm0,ymm1

VectorNorme1F_AVX_3:
	vextractf128 xmm1,ymm0,1
	vaddps xmm0,xmm0,xmm1

	vmovhlps xmm1,xmm1,xmm0
	vaddps xmm0,xmm0,xmm1
	mov esi,result
	vpsrldq xmm1,xmm0,4
	vaddss xmm0,xmm0,xmm1
	vmovss dword ptr[esi],xmm0

	vzeroupper

	pop esi
	pop ebx

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

	push ebx
	push esi

	mov esi,coeff_x
	movzx edx,lgth
	mov eax,128
	mov ebx,32
	mov ecx,edx

	vxorpd ymm0,ymm0,ymm0
	vmovapd ymm5,YMMWORD ptr sign_bits_f_64

	shr ecx,2
	jz short VectorNorme1D_AVX_1

VectorNorme1D_AVX_loop_1:
	vandpd ymm1,ymm5,YMMWORD ptr[esi]
	vandpd ymm2,ymm5,YMMWORD ptr[esi+ebx]
	vandpd ymm3,ymm5,YMMWORD ptr[esi+2*ebx]
	vandpd ymm4,ymm5,YMMWORD ptr[esi+96]

	vaddpd ymm1,ymm1,ymm2
	vaddpd ymm3,ymm3,ymm4
	vaddpd ymm1,ymm1,ymm3
	add esi,eax
	vaddpd ymm0,ymm0,ymm1

	loop VectorNorme1D_AVX_loop_1

VectorNorme1D_AVX_1:
	test edx,2
	jz short VectorNorme1D_AVX_2

	vandpd ymm1,ymm5,YMMWORD ptr[esi]
	vandpd ymm2,ymm5,YMMWORD ptr[esi+ebx]

	vaddpd ymm1,ymm1,ymm2
	add esi,64
	vaddpd ymm0,ymm0,ymm1

VectorNorme1D_AVX_2:
	test edx,1
	jz short VectorNorme1D_AVX_3

	vandpd ymm1,ymm5,YMMWORD ptr[esi]
	vaddpd ymm0,ymm0,ymm1

VectorNorme1D_AVX_3:
	vextractf128 xmm1,ymm0,1
	vaddpd xmm0,xmm0,xmm1

	vmovhlps xmm1,xmm1,xmm0
	mov esi,result
	vaddsd xmm0,xmm0,xmm1
	vmovsd qword ptr[esi],xmm0

	vzeroupper	

	pop esi
	pop ebx

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
	push esi
	push edi

	mov esi,coeff_x
	mov edi,coeff_y
	movzx edx,lgth
	mov eax,128
	mov ebx,32
	mov ecx,edx

	vxorps ymm0,ymm0,ymm0
	vmovaps ymm5,YMMWORD ptr sign_bits_f_32

	shr ecx,2
	jz short VectorDist1F_AVX_1

VectorDist1F_AVX_loop_1:
	vmovaps ymm1,YMMWORD ptr[esi]
	vmovaps ymm2,YMMWORD ptr[esi+ebx]
	vmovaps ymm3,YMMWORD ptr[esi+2*ebx]
	vmovaps ymm4,YMMWORD ptr[esi+96]

	vsubps ymm1,ymm1,YMMWORD ptr[edi]
	vsubps ymm2,ymm2,YMMWORD ptr[edi+ebx]
	vsubps ymm3,ymm3,YMMWORD ptr[edi+2*ebx]
	vsubps ymm4,ymm4,YMMWORD ptr[edi+96]

	vandps ymm1,ymm1,ymm5
	vandps ymm2,ymm2,ymm5
	vandps ymm3,ymm3,ymm5
	vandps ymm4,ymm4,ymm5

	vaddps ymm1,ymm1,ymm2
	vaddps ymm3,ymm3,ymm4
	add esi,eax
	vaddps ymm1,ymm1,ymm3
	add edi,eax
	vaddps ymm0,ymm0,ymm1

	loop VectorDist1F_AVX_loop_1

VectorDist1F_AVX_1:
	test edx,2
	jz short VectorDist1F_AVX_2

	vmovaps ymm1,YMMWORD ptr[esi]
	vmovaps ymm2,YMMWORD ptr[esi+ebx]
	vsubps ymm1,ymm1,YMMWORD ptr[edi]
	vsubps ymm2,ymm2,YMMWORD ptr[edi+ebx]
	vandps ymm1,ymm1,ymm5
	vandps ymm2,ymm2,ymm5

	add esi,64
	vaddps ymm1,ymm1,ymm2
	add edi,64
	vaddps ymm0,ymm0,ymm1

VectorDist1F_AVX_2:
	test edx,1
	jz short VectorDist1F_AVX_3

	vmovaps ymm1,YMMWORD ptr[esi]
	vsubps ymm1,ymm1,YMMWORD ptr[edi]
	vandps ymm1,ymm1,ymm5
	vaddps ymm0,ymm0,ymm1

VectorDist1F_AVX_3:
	vextractf128 xmm1,ymm0,1
	vaddps xmm0,xmm0,xmm1

	vmovhlps xmm1,xmm1,xmm0
	vaddps xmm0,xmm0,xmm1
	mov edi,result
	vpsrldq xmm1,xmm0,4
	vaddss xmm0,xmm0,xmm1
	vmovss dword ptr[edi],xmm0

	vzeroupper

	pop edi
	pop esi
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
	push esi
	push edi

	mov esi,coeff_x
	mov edi,coeff_y
	movzx edx,lgth
	mov eax,128
	mov ebx,32
	mov ecx,edx

	vxorpd ymm0,ymm0,ymm0
	vmovapd ymm5,YMMWORD ptr sign_bits_f_64

	shr ecx,2
	jz short VectorDist1D_AVX_1

VectorDist1D_AVX_loop_1:
	vmovapd ymm1,YMMWORD ptr[esi]
	vmovapd ymm2,YMMWORD ptr[esi+ebx]
	vmovapd ymm3,YMMWORD ptr[esi+2*ebx]
	vmovapd ymm4,YMMWORD ptr[esi+96]

	vsubpd ymm1,ymm1,YMMWORD ptr[edi]
	vsubpd ymm2,ymm2,YMMWORD ptr[edi+ebx]
	vsubpd ymm3,ymm3,YMMWORD ptr[edi+2*ebx]
	vsubpd ymm4,ymm4,YMMWORD ptr[edi+96]

	vandpd ymm1,ymm1,ymm5
	vandpd ymm2,ymm2,ymm5
	vandpd ymm3,ymm3,ymm5
	vandpd ymm4,ymm4,ymm5

	vaddpd ymm1,ymm1,ymm2
	vaddpd ymm3,ymm3,ymm4
	add esi,eax
	vaddpd ymm1,ymm1,ymm3
	add edi,eax
	vaddpd ymm0,ymm0,ymm1

	loop VectorDist1D_AVX_loop_1

VectorDist1D_AVX_1:
	test edx,2
	jz short VectorDist1D_AVX_2

	vmovapd ymm1,YMMWORD ptr[esi]
	vmovapd ymm2,YMMWORD ptr[esi+ebx]
	vsubpd ymm1,ymm1,YMMWORD ptr[edi]
	vsubpd ymm2,ymm2,YMMWORD ptr[edi+ebx]
	vandpd ymm1,ymm1,ymm5
	vandpd ymm2,ymm2,ymm5

	add esi,64
	vaddpd ymm1,ymm1,ymm2
	add edi,64
	vaddpd ymm0,ymm0,ymm1

VectorDist1D_AVX_2:
	test edx,1
	jz short VectorDist1D_AVX_3

	vmovapd ymm1,YMMWORD ptr[esi]
	vsubpd ymm1,ymm1,YMMWORD ptr[edi]
	vandpd ymm1,ymm1,ymm5
	vaddpd ymm0,ymm0,ymm1

VectorDist1D_AVX_3:
	vextractf128 xmm1,ymm0,1
	vaddpd xmm0,xmm0,xmm1

	vmovhlps xmm1,xmm1,xmm0
	mov edi,result
	vaddsd xmm0,xmm0,xmm1
	vmovsd qword ptr[edi],xmm0

	vzeroupper

	pop edi
	pop esi
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
	push esi
	push edi

	mov esi,coeff_a
	mov edi,coeff_x
	movzx edx,lgth
	mov eax,128
	mov ebx,32
	mov ecx,edx

	vxorps ymm0,ymm0,ymm0

	shr ecx,2
	jz short VectorProductF_AVX_1

VectorProductF_AVX_loop_1:
	vmovaps ymm1,YMMWORD ptr[esi]
	vmovaps ymm2,YMMWORD ptr[esi+ebx]
	vmovaps ymm3,YMMWORD ptr[esi+2*ebx]
	vmovaps ymm4,YMMWORD ptr[esi+96]

	vmulps ymm1,ymm1,YMMWORD ptr[edi]
	vmulps ymm2,ymm2,YMMWORD ptr[edi+ebx]
	vmulps ymm3,ymm3,YMMWORD ptr[edi+2*ebx]
	vmulps ymm4,ymm4,YMMWORD ptr[edi+96]

	vaddps ymm1,ymm1,ymm2
	vaddps ymm3,ymm3,ymm4
	add esi,eax
	vaddps ymm1,ymm1,ymm3
	add edi,eax
	vaddps ymm0,ymm0,ymm1

	loop VectorProductF_AVX_loop_1

VectorProductF_AVX_1:
	test edx,2
	jz short VectorProductF_AVX_2

	vmovaps ymm1,YMMWORD ptr[esi]
	vmovaps ymm2,YMMWORD ptr[esi+ebx]
	vmulps ymm1,ymm1,YMMWORD ptr[edi]
	vmulps ymm2,ymm2,YMMWORD ptr[edi+ebx]

	add esi,64
	vaddps ymm1,ymm1,ymm2
	add edi,64
	vaddps ymm0,ymm0,ymm1

VectorProductF_AVX_2:
	test edx,1
	jz short VectorProductF_AVX_3

	vmovaps ymm1,YMMWORD ptr[esi]
	vmulps ymm1,ymm1,YMMWORD ptr[edi]
	vaddps ymm0,ymm0,ymm1

VectorProductF_AVX_3:
	vextractf128 xmm1,ymm0,1
	vaddps xmm0,xmm0,xmm1

	vmovhlps xmm1,xmm1,xmm0
	vaddps xmm0,xmm0,xmm1
	mov edi,result
	vpsrldq xmm1,xmm0,4
	vaddss xmm0,xmm0,xmm1
	vmovss dword ptr[edi],xmm0

	vzeroupper

	pop edi
	pop esi
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
	push esi
	push edi

	mov esi,coeff_a
	mov edi,coeff_x
	movzx edx,lgth
	mov eax,128
	mov ebx,32
	mov ecx,edx

	vxorpd ymm0,ymm0,ymm0

	shr ecx,2
	jz short VectorProductD_AVX_1

VectorProductD_AVX_loop_1:
	vmovapd ymm1,YMMWORD ptr[esi]
	vmovapd ymm2,YMMWORD ptr[esi+ebx]
	vmovapd ymm3,YMMWORD ptr[esi+2*ebx]
	vmovapd ymm4,YMMWORD ptr[esi+96]

	vmulpd ymm1,ymm1,YMMWORD ptr[edi]
	vmulpd ymm2,ymm2,YMMWORD ptr[edi+ebx]
	vmulpd ymm3,ymm3,YMMWORD ptr[edi+2*ebx]
	vmulpd ymm4,ymm4,YMMWORD ptr[edi+96]

	vaddpd ymm1,ymm1,ymm2
	vaddpd ymm3,ymm3,ymm4
	add esi,eax
	vaddpd ymm1,ymm1,ymm3
	add edi,eax
	vaddpd ymm0,ymm0,ymm1

	loop VectorProductD_AVX_loop_1

VectorProductD_AVX_1:
	test edx,2
	jz short VectorProductD_AVX_2

	vmovapd ymm1,YMMWORD ptr[esi]
	vmovapd ymm2,YMMWORD ptr[esi+ebx]
	vmulpd ymm1,ymm1,YMMWORD ptr[edi]
	vmulpd ymm2,ymm2,YMMWORD ptr[edi+ebx]

	add esi,64
	vaddpd ymm1,ymm1,ymm2
	add edi,64
	vaddpd ymm0,ymm0,ymm1

VectorProductD_AVX_2:
	test edx,1
	jz short VectorProductD_AVX_3

	vmovapd ymm1,YMMWORD ptr[esi]
	vmulpd ymm1,ymm1,YMMWORD ptr[edi]
	vaddpd ymm0,ymm0,ymm1

VectorProductD_AVX_3:
	vextractf128 xmm1,ymm0,1
	vaddpd xmm0,xmm0,xmm1

	vmovhlps xmm1,xmm1,xmm0
	mov edi,result
	vaddsd xmm0,xmm0,xmm1
	vmovsd qword ptr[edi],xmm0

	vzeroupper

	pop edi
	pop esi
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
	push esi
	push edi

	movzx edx,lgth
	mov esi,coeff_a
	mov ebx,coeff_b
	mov edi,coeff_c
	mov ecx,edx
	mov eax,128

	shr ecx,2
	jz short VectorAddF_AVX_1

VectorAddF_AVX_loop_1:
	vmovaps ymm0,YMMWORD ptr[esi]
	vmovaps ymm1,YMMWORD ptr[esi+32]
	vmovaps ymm2,YMMWORD ptr[esi+64]
	vmovaps ymm3,YMMWORD ptr[esi+96]

	vaddps ymm0,ymm0,YMMWORD ptr[ebx]
	vaddps ymm1,ymm1,YMMWORD ptr[ebx+32]
	vaddps ymm2,ymm2,YMMWORD ptr[ebx+64]
	vaddps ymm3,ymm3,YMMWORD ptr[ebx+96]

	vmovaps YMMWORD ptr[edi],ymm0
	vmovaps YMMWORD ptr[edi+32],ymm1
	vmovaps YMMWORD ptr[edi+64],ymm2
	vmovaps YMMWORD ptr[edi+96],ymm3

	add esi,eax
	add ebx,eax
	add edi,eax
	loop VectorAddF_AVX_loop_1

VectorAddF_AVX_1:
	test edx,2
	jz short VectorAddF_AVX_2

	vmovaps ymm0,YMMWORD ptr[esi]
	vmovaps ymm1,YMMWORD ptr[esi+32]
	vaddps ymm0,ymm0,YMMWORD ptr[ebx]
	vaddps ymm1,ymm1,YMMWORD ptr[ebx+32]
	vmovaps YMMWORD ptr[edi],ymm0
	vmovaps YMMWORD ptr[edi+32],ymm1

	add esi,64
	add ebx,64
	add edi,64

VectorAddF_AVX_2:
	test edx,1
	jz short VectorAddF_AVX_3

	vmovaps ymm0,YMMWORD ptr[esi]
	vaddps ymm0,ymm0,YMMWORD ptr[ebx]
	vmovaps YMMWORD ptr[edi],ymm0

VectorAddF_AVX_3:
	vzeroupper

	pop edi
	pop esi
	pop ebx

	ret

VectorAddF_AVX endp	


VectorSubF_AVX proc coeff_a:dword,coeff_b:dword,coeff_c:dword,lgth:word

    public VectorSubF_AVX

	push ebx
	push esi
	push edi

	movzx edx,lgth
	mov esi,coeff_a
	mov ebx,coeff_b
	mov edi,coeff_c
	mov ecx,edx
	mov eax,128

	shr ecx,2
	jz short VectorSubF_AVX_1

VectorSubF_AVX_loop_1:
	vmovaps ymm0,YMMWORD ptr[esi]
	vmovaps ymm1,YMMWORD ptr[esi+32]
	vmovaps ymm2,YMMWORD ptr[esi+64]
	vmovaps ymm3,YMMWORD ptr[esi+96]

	vsubps ymm0,ymm0,YMMWORD ptr[ebx]
	vsubps ymm1,ymm1,YMMWORD ptr[ebx+32]
	vsubps ymm2,ymm2,YMMWORD ptr[ebx+64]
	vsubps ymm3,ymm3,YMMWORD ptr[ebx+96]

	vmovaps YMMWORD ptr[edi],ymm0
	vmovaps YMMWORD ptr[edi+32],ymm1
	vmovaps YMMWORD ptr[edi+64],ymm2
	vmovaps YMMWORD ptr[edi+96],ymm3

	add esi,eax
	add ebx,eax
	add edi,eax
	loop VectorSubF_AVX_loop_1

VectorSubF_AVX_1:
	test edx,2
	jz short VectorSubF_AVX_2

	vmovaps ymm0,YMMWORD ptr[esi]
	vmovaps ymm1,YMMWORD ptr[esi+32]
	vsubps ymm0,ymm0,YMMWORD ptr[ebx]
	vsubps ymm1,ymm1,YMMWORD ptr[ebx+32]
	vmovaps YMMWORD ptr[edi],ymm0
	vmovaps YMMWORD ptr[edi+32],ymm1

	add esi,64
	add ebx,64
	add edi,64

VectorSubF_AVX_2:
	test edx,1
	jz short VectorSubF_AVX_3

	vmovaps ymm0,YMMWORD ptr[esi]
	vsubps ymm0,ymm0,YMMWORD ptr[ebx]
	vmovaps YMMWORD ptr[edi],ymm0

VectorSubF_AVX_3:
	vzeroupper

	pop edi
	pop esi
	pop ebx

	ret

VectorSubF_AVX endp	


VectorProdF_AVX proc coeff_a:dword,coeff_b:dword,coeff_c:dword,lgth:word

    public VectorProdF_AVX

	push ebx
	push esi
	push edi

	movzx edx,lgth
	mov esi,coeff_a
	mov ebx,coeff_b
	mov edi,coeff_c
	mov ecx,edx
	mov eax,128

	shr ecx,2
	jz short VectorProdF_AVX_1

VectorProdF_AVX_loop_1:
	vmovaps ymm0,YMMWORD ptr[esi]
	vmovaps ymm1,YMMWORD ptr[esi+32]
	vmovaps ymm2,YMMWORD ptr[esi+64]
	vmovaps ymm3,YMMWORD ptr[esi+96]

	vmulps ymm0,ymm0,YMMWORD ptr[ebx]
	vmulps ymm1,ymm1,YMMWORD ptr[ebx+32]
	vmulps ymm2,ymm2,YMMWORD ptr[ebx+64]
	vmulps ymm3,ymm3,YMMWORD ptr[ebx+96]

	vmovaps YMMWORD ptr[edi],ymm0
	vmovaps YMMWORD ptr[edi+32],ymm1
	vmovaps YMMWORD ptr[edi+64],ymm2
	vmovaps YMMWORD ptr[edi+96],ymm3

	add esi,eax
	add ebx,eax
	add edi,eax
	loop VectorProdF_AVX_loop_1

VectorProdF_AVX_1:
	test edx,2
	jz short VectorProdF_AVX_2

	vmovaps ymm0,YMMWORD ptr[esi]
	vmovaps ymm1,YMMWORD ptr[esi+32]
	vmulps ymm0,ymm0,YMMWORD ptr[ebx]
	vmulps ymm1,ymm1,YMMWORD ptr[ebx+32]
	vmovaps YMMWORD ptr[edi],ymm0
	vmovaps YMMWORD ptr[edi+32],ymm1

	add esi,64
	add ebx,64
	add edi,64

VectorProdF_AVX_2:
	test edx,1
	jz short VectorProdF_AVX_3

	vmovaps ymm0,YMMWORD ptr[esi]
	vmulps ymm0,ymm0,YMMWORD ptr[ebx]
	vmovaps YMMWORD ptr[edi],ymm0

VectorProdF_AVX_3:
	vzeroupper

	pop edi
	pop esi
	pop ebx

	ret

VectorProdF_AVX endp


VectorAdd2F_AVX proc coeff_a:dword,coeff_b:dword,lgth:word

    public VectorAdd2F_AVX

	push ebx
	push esi
	push edi

	movzx edx,lgth
	mov edi,coeff_a
	mov esi,coeff_b
	mov ecx,edx
	mov eax,128
	mov ebx,32

	shr ecx,2
	jz short VectorAdd2F_AVX_1

VectorAdd2F_AVX_loop_1:
	vmovaps ymm0,YMMWORD ptr[edi]
	vmovaps ymm1,YMMWORD ptr[edi+ebx]
	vmovaps ymm2,YMMWORD ptr[edi+2*ebx]
	vmovaps ymm3,YMMWORD ptr[edi+96]

	vaddps ymm0,ymm0,YMMWORD ptr[esi]
	vaddps ymm1,ymm1,YMMWORD ptr[esi+ebx]
	vaddps ymm2,ymm2,YMMWORD ptr[esi+2*ebx]
	vaddps ymm3,ymm3,YMMWORD ptr[esi+96]

	vmovaps YMMWORD ptr[edi],ymm0
	vmovaps YMMWORD ptr[edi+ebx],ymm1
	vmovaps YMMWORD ptr[edi+2*ebx],ymm2
	vmovaps YMMWORD ptr[edi+96],ymm3

	add esi,eax
	add edi,eax
	loop VectorAdd2F_AVX_loop_1

VectorAdd2F_AVX_1:
	test edx,2
	jz short VectorAdd2F_AVX_2

	vmovaps ymm0,YMMWORD ptr[edi]
	vmovaps ymm1,YMMWORD ptr[edi+ebx]
	vaddps ymm0,ymm0,YMMWORD ptr[esi]
	vaddps ymm1,ymm1,YMMWORD ptr[esi+ebx]
	vmovaps YMMWORD ptr[edi],ymm0
	vmovaps YMMWORD ptr[edi+ebx],ymm1

	add esi,64
	add edi,64

VectorAdd2F_AVX_2:
	test edx,1
	jz short VectorAdd2F_AVX_3

	vmovaps ymm0,YMMWORD ptr[edi]
	vaddps ymm0,ymm0,YMMWORD ptr[esi]
	vmovaps YMMWORD ptr[edi],ymm0

VectorAdd2F_AVX_3:
	vzeroupper

	pop edi
	pop esi
	pop ebx

	ret

VectorAdd2F_AVX endp	


VectorSub2F_AVX proc coeff_a:dword,coeff_b:dword,lgth:word

    public VectorSub2F_AVX

	push ebx
	push esi
	push edi

	movzx edx,lgth
	mov edi,coeff_a
	mov esi,coeff_b
	mov ecx,edx
	mov eax,128
	mov ebx,32

	shr ecx,2
	jz short VectorSub2F_AVX_1

VectorSub2F_AVX_loop_1:
	vmovaps ymm0,YMMWORD ptr[edi]
	vmovaps ymm1,YMMWORD ptr[edi+ebx]
	vmovaps ymm2,YMMWORD ptr[edi+2*ebx]
	vmovaps ymm3,YMMWORD ptr[edi+96]

	vsubps ymm0,ymm0,YMMWORD ptr[esi]
	vsubps ymm1,ymm1,YMMWORD ptr[esi+ebx]
	vsubps ymm2,ymm2,YMMWORD ptr[esi+2*ebx]
	vsubps ymm3,ymm3,YMMWORD ptr[esi+96]

	vmovaps YMMWORD ptr[edi],ymm0
	vmovaps YMMWORD ptr[edi+ebx],ymm1
	vmovaps YMMWORD ptr[edi+2*ebx],ymm2
	vmovaps YMMWORD ptr[edi+96],ymm3

	add esi,eax
	add edi,eax
	loop VectorSub2F_AVX_loop_1

VectorSub2F_AVX_1:
	test edx,2
	jz short VectorSub2F_AVX_2

	vmovaps ymm0,YMMWORD ptr[edi]
	vmovaps ymm1,YMMWORD ptr[edi+ebx]
	vsubps ymm0,ymm0,YMMWORD ptr[esi]
	vsubps ymm1,ymm1,YMMWORD ptr[esi+ebx]
	vmovaps YMMWORD ptr[edi],ymm0
	vmovaps YMMWORD ptr[edi+ebx],ymm1

	add esi,64
	add edi,64

VectorSub2F_AVX_2:
	test edx,1
	jz short VectorSub2F_AVX_3

	vmovaps ymm0,YMMWORD ptr[edi]
	vsubps ymm0,ymm0,YMMWORD ptr[esi]
	vmovaps YMMWORD ptr[edi],ymm0

VectorSub2F_AVX_3:
	vzeroupper

	pop edi
	pop esi
	pop ebx

	ret

VectorSub2F_AVX endp


VectorInvSubF_AVX proc coeff_a:dword,coeff_b:dword,lgth:word

    public VectorInvSubF_AVX

	push ebx
	push esi
	push edi

	movzx edx,lgth
	mov edi,coeff_a
	mov esi,coeff_b
	mov ecx,edx
	mov eax,128
	mov ebx,32

	shr ecx,2
	jz short VectorInvSubF_AVX_1

VectorInvSubF_AVX_loop_1:
	vmovaps ymm0,YMMWORD ptr[esi]
	vmovaps ymm1,YMMWORD ptr[esi+ebx]
	vmovaps ymm2,YMMWORD ptr[esi+2*ebx]
	vmovaps ymm3,YMMWORD ptr[esi+96]

	vsubps ymm0,ymm0,YMMWORD ptr[edi]
	vsubps ymm1,ymm1,YMMWORD ptr[edi+ebx]
	vsubps ymm2,ymm2,YMMWORD ptr[edi+2*ebx]
	vsubps ymm3,ymm3,YMMWORD ptr[edi+96]

	vmovaps YMMWORD ptr[edi],ymm0
	vmovaps YMMWORD ptr[edi+ebx],ymm1
	vmovaps YMMWORD ptr[edi+2*ebx],ymm2
	vmovaps YMMWORD ptr[edi+96],ymm3

	add esi,eax
	add edi,eax
	loop VectorInvSubF_AVX_loop_1

VectorInvSubF_AVX_1:
	test edx,2
	jz short VectorInvSubF_AVX_2

	vmovaps ymm0,YMMWORD ptr[esi]
	vmovaps ymm1,YMMWORD ptr[esi+ebx]
	vsubps ymm0,ymm0,YMMWORD ptr[edi]
	vsubps ymm1,ymm1,YMMWORD ptr[edi+ebx]
	vmovaps YMMWORD ptr[edi],ymm0
	vmovaps YMMWORD ptr[edi+ebx],ymm1

	add esi,64
	add edi,64

VectorInvSubF_AVX_2:
	test edx,1
	jz short VectorInvSubF_AVX_3

	vmovaps ymm0,YMMWORD ptr[esi]
	vsubps ymm0,ymm0,YMMWORD ptr[edi]
	vmovaps YMMWORD ptr[edi],ymm0

VectorInvSubF_AVX_3:
	vzeroupper

	pop edi
	pop esi
	pop ebx

	ret

VectorInvSubF_AVX endp


VectorProd2F_AVX proc coeff_a:dword,coeff_b:dword,lgth:word

    public VectorProd2F_AVX

	push ebx
	push esi
	push edi

	movzx edx,lgth
	mov edi,coeff_a
	mov esi,coeff_b
	mov ecx,edx
	mov eax,128
	mov ebx,32

	shr ecx,2
	jz short VectorProd2F_AVX_1
	
VectorProd2F_AVX_loop_1:
	vmovaps ymm0,YMMWORD ptr[edi]
	vmovaps ymm1,YMMWORD ptr[edi+ebx]
	vmovaps ymm2,YMMWORD ptr[edi+2*ebx]
	vmovaps ymm3,YMMWORD ptr[edi+96]

	vmulps ymm0,ymm0,YMMWORD ptr[esi]
	vmulps ymm1,ymm1,YMMWORD ptr[esi+ebx]
	vmulps ymm2,ymm2,YMMWORD ptr[esi+2*ebx]
	vmulps ymm3,ymm3,YMMWORD ptr[esi+96]

	vmovaps YMMWORD ptr[edi],ymm0
	vmovaps YMMWORD ptr[edi+ebx],ymm1
	vmovaps YMMWORD ptr[edi+2*ebx],ymm2
	vmovaps YMMWORD ptr[edi+96],ymm3

	add esi,eax
	add edi,eax
	loop VectorProd2F_AVX_loop_1

VectorProd2F_AVX_1:
	test edx,2
	jz short VectorProd2F_AVX_2

	vmovaps ymm0,YMMWORD ptr[edi]
	vmovaps ymm1,YMMWORD ptr[edi+ebx]
	vmulps ymm0,ymm0,YMMWORD ptr[esi]
	vmulps ymm1,ymm1,YMMWORD ptr[esi+ebx]
	vmovaps YMMWORD ptr[edi],ymm0
	vmovaps YMMWORD ptr[edi+ebx],ymm1

	add esi,64
	add edi,64

VectorProd2F_AVX_2:
	test edx,1
	jz short VectorProd2F_AVX_3

	vmovaps ymm0,YMMWORD ptr[edi]
	vmulps ymm0,ymm0,YMMWORD ptr[esi]
	vmovaps YMMWORD ptr[edi],ymm0
	
VectorProd2F_AVX_3:
	vzeroupper
	
	pop edi
	pop esi
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
	push esi
	push edi

	movzx edx,lgth
	mov esi,coeff_a
	mov ebx,coeff_b
	mov edi,coeff_c
	mov ecx,edx
	mov eax,128

	shr ecx,2
	jz short VectorAddD_AVX_1

VectorAddD_AVX_loop_1:
	vmovapd ymm0,YMMWORD ptr[esi]
	vmovapd ymm1,YMMWORD ptr[esi+32]
	vmovapd ymm2,YMMWORD ptr[esi+64]
	vmovapd ymm3,YMMWORD ptr[esi+96]

	vaddpd ymm0,ymm0,YMMWORD ptr[ebx]
	vaddpd ymm1,ymm1,YMMWORD ptr[ebx+32]
	vaddpd ymm2,ymm2,YMMWORD ptr[ebx+64]
	vaddpd ymm3,ymm3,YMMWORD ptr[ebx+96]

	vmovapd YMMWORD ptr[edi],ymm0
	vmovapd YMMWORD ptr[edi+32],ymm1
	vmovapd YMMWORD ptr[edi+64],ymm2
	vmovapd YMMWORD ptr[edi+96],ymm3

	add esi,eax
	add ebx,eax
	add edi,eax
	loop VectorAddD_AVX_loop_1

VectorAddD_AVX_1:
	test edx,2
	jz short VectorAddD_AVX_2

	vmovapd ymm0,YMMWORD ptr[esi]
	vmovapd ymm1,YMMWORD ptr[esi+32]
	vaddpd ymm0,ymm0,YMMWORD ptr[ebx]
	vaddpd ymm1,ymm1,YMMWORD ptr[ebx+32]
	vmovapd YMMWORD ptr[edi],ymm0
	vmovapd YMMWORD ptr[edi+32],ymm1

	add esi,64
	add ebx,64
	add edi,64

VectorAddD_AVX_2:
	test edx,1
	jz short VectorAddD_AVX_3

	vmovapd ymm0,YMMWORD ptr[esi]
	vaddpd ymm0,ymm0,YMMWORD ptr[ebx]
	vmovapd YMMWORD ptr[edi],ymm0

VectorAddD_AVX_3:
	vzeroupper

	pop edi
	pop esi
	pop ebx

	ret

VectorAddD_AVX endp	


VectorSubD_AVX proc coeff_a:dword,coeff_b:dword,coeff_c:dword,lgth:word

    public VectorSubD_AVX

	push ebx
	push esi
	push edi

	movzx edx,lgth
	mov esi,coeff_a
	mov ebx,coeff_b
	mov edi,coeff_c
	mov ecx,edx
	mov eax,128

	shr ecx,2
	jz short VectorSubD_AVX_1

VectorSubD_AVX_loop_1:
	vmovapd ymm0,YMMWORD ptr[esi]
	vmovapd ymm1,YMMWORD ptr[esi+32]
	vmovapd ymm2,YMMWORD ptr[esi+64]
	vmovapd ymm3,YMMWORD ptr[esi+96]

	vsubpd ymm0,ymm0,YMMWORD ptr[ebx]
	vsubpd ymm1,ymm1,YMMWORD ptr[ebx+32]
	vsubpd ymm2,ymm2,YMMWORD ptr[ebx+64]
	vsubpd ymm3,ymm3,YMMWORD ptr[ebx+96]

	vmovapd YMMWORD ptr[edi],ymm0
	vmovapd YMMWORD ptr[edi+32],ymm1
	vmovapd YMMWORD ptr[edi+64],ymm2
	vmovapd YMMWORD ptr[edi+96],ymm3

	add esi,eax
	add ebx,eax
	add edi,eax
	loop VectorSubD_AVX_loop_1

VectorSubD_AVX_1:
	test edx,2
	jz short VectorSubD_AVX_2

	vmovapd ymm0,YMMWORD ptr[esi]
	vmovapd ymm1,YMMWORD ptr[esi+32]
	vsubpd ymm0,ymm0,YMMWORD ptr[ebx]
	vsubpd ymm1,ymm1,YMMWORD ptr[ebx+32]
	vmovapd YMMWORD ptr[edi],ymm0
	vmovapd YMMWORD ptr[edi+32],ymm1

	add esi,64
	add ebx,64
	add edi,64

VectorSubD_AVX_2:
	test edx,1
	jz short VectorSubD_AVX_3

	vmovapd ymm0,YMMWORD ptr[esi]
	vsubpd ymm0,ymm0,YMMWORD ptr[ebx]
	vmovapd YMMWORD ptr[edi],ymm0

VectorSubD_AVX_3:
	vzeroupper

	pop edi
	pop esi
	pop ebx

	ret

VectorSubD_AVX endp	


VectorProdD_AVX proc coeff_a:dword,coeff_b:dword,coeff_c:dword,lgth:word

    public VectorProdD_AVX

	push ebx
	push esi
	push edi

	movzx edx,lgth
	mov esi,coeff_a
	mov ebx,coeff_b
	mov edi,coeff_c
	mov ecx,edx
	mov eax,128

	shr ecx,2
	jz short VectorProdD_AVX_1

VectorProdD_AVX_loop_1:
	vmovapd ymm0,YMMWORD ptr[esi]
	vmovapd ymm1,YMMWORD ptr[esi+32]
	vmovapd ymm2,YMMWORD ptr[esi+64]
	vmovapd ymm3,YMMWORD ptr[esi+96]

	vmulpd ymm0,ymm0,YMMWORD ptr[ebx]
	vmulpd ymm1,ymm1,YMMWORD ptr[ebx+32]
	vmulpd ymm2,ymm2,YMMWORD ptr[ebx+64]
	vmulpd ymm3,ymm3,YMMWORD ptr[ebx+96]

	vmovapd YMMWORD ptr[edi],ymm0
	vmovapd YMMWORD ptr[edi+32],ymm1
	vmovapd YMMWORD ptr[edi+64],ymm2
	vmovapd YMMWORD ptr[edi+96],ymm3

	add esi,eax
	add ebx,eax
	add edi,eax
	loop VectorProdD_AVX_loop_1

VectorProdD_AVX_1:
	test edx,2
	jz short VectorProdD_AVX_2

	vmovapd ymm0,YMMWORD ptr[esi]
	vmovapd ymm1,YMMWORD ptr[esi+32]
	vmulpd ymm0,ymm0,YMMWORD ptr[ebx]
	vmulpd ymm1,ymm1,YMMWORD ptr[ebx+32]
	vmovapd YMMWORD ptr[edi],ymm0
	vmovapd YMMWORD ptr[edi+32],ymm1

	add esi,64
	add ebx,64
	add edi,64

VectorProdD_AVX_2:
	test edx,1
	jz short VectorProdD_AVX_3

	vmovapd ymm0,YMMWORD ptr[esi]
	vmulpd ymm0,ymm0,YMMWORD ptr[ebx]
	vmovapd YMMWORD ptr[edi],ymm0

VectorProdD_AVX_3:
	vzeroupper

	pop edi
	pop esi
	pop ebx

	ret

VectorProdD_AVX endp


VectorAdd2D_AVX proc coeff_a:dword,coeff_b:dword,lgth:word

    public VectorAdd2D_AVX

	push ebx
	push esi
	push edi

	movzx edx,lgth
	mov edi,coeff_a
	mov esi,coeff_b
	mov ecx,edx
	mov eax,128
	mov ebx,32

	shr ecx,2
	jz short VectorAdd2D_AVX_1

VectorAdd2D_AVX_loop_1:
	vmovapd ymm0,YMMWORD ptr[edi]
	vmovapd ymm1,YMMWORD ptr[edi+ebx]
	vmovapd ymm2,YMMWORD ptr[edi+2*ebx]
	vmovapd ymm3,YMMWORD ptr[edi+96]

	vaddpd ymm0,ymm0,YMMWORD ptr[esi]
	vaddpd ymm1,ymm1,YMMWORD ptr[esi+ebx]
	vaddpd ymm2,ymm2,YMMWORD ptr[esi+2*ebx]
	vaddpd ymm3,ymm3,YMMWORD ptr[esi+96]

	vmovapd YMMWORD ptr[edi],ymm0
	vmovapd YMMWORD ptr[edi+ebx],ymm1
	vmovapd YMMWORD ptr[edi+2*ebx],ymm2
	vmovapd YMMWORD ptr[edi+96],ymm3

	add esi,eax
	add edi,eax
	loop VectorAdd2D_AVX_loop_1

VectorAdd2D_AVX_1:
	test edx,2
	jz short VectorAdd2D_AVX_2

	vmovapd ymm0,YMMWORD ptr[edi]
	vmovapd ymm1,YMMWORD ptr[edi+ebx]
	vaddpd ymm0,ymm0,YMMWORD ptr[esi]
	vaddpd ymm1,ymm1,YMMWORD ptr[esi+ebx]
	vmovapd YMMWORD ptr[edi],ymm0
	vmovapd YMMWORD ptr[edi+ebx],ymm1

	add esi,64
	add edi,64

VectorAdd2D_AVX_2:
	test edx,1
	jz short VectorAdd2D_AVX_3

	vmovapd ymm0,YMMWORD ptr[edi]
	vaddpd ymm0,ymm0,YMMWORD ptr[esi]
	vmovapd YMMWORD ptr[edi],ymm0

VectorAdd2D_AVX_3:
	vzeroupper

	pop edi
	pop esi
	pop ebx

	ret

VectorAdd2D_AVX endp	


VectorSub2D_AVX proc coeff_a:dword,coeff_b:dword,lgth:word

    public VectorSub2D_AVX

	push ebx
	push esi
	push edi

	movzx edx,lgth
	mov edi,coeff_a
	mov esi,coeff_b
	mov ecx,edx
	mov eax,128
	mov ebx,32

	shr ecx,2
	jz short VectorSub2D_AVX_1

VectorSub2D_AVX_loop_1:
	vmovapd ymm0,YMMWORD ptr[edi]
	vmovapd ymm1,YMMWORD ptr[edi+ebx]
	vmovapd ymm2,YMMWORD ptr[edi+2*ebx]
	vmovapd ymm3,YMMWORD ptr[edi+96]

	vsubpd ymm0,ymm0,YMMWORD ptr[esi]
	vsubpd ymm1,ymm1,YMMWORD ptr[esi+ebx]
	vsubpd ymm2,ymm2,YMMWORD ptr[esi+2*ebx]
	vsubpd ymm3,ymm3,YMMWORD ptr[esi+96]

	vmovapd YMMWORD ptr[edi],ymm0
	vmovapd YMMWORD ptr[edi+ebx],ymm1
	vmovapd YMMWORD ptr[edi+2*ebx],ymm2
	vmovapd YMMWORD ptr[edi+96],ymm3

	add esi,eax
	add edi,eax
	loop VectorSub2D_AVX_loop_1

VectorSub2D_AVX_1:
	test edx,2
	jz short VectorSub2D_AVX_2

	vmovapd ymm0,YMMWORD ptr[edi]
	vmovapd ymm1,YMMWORD ptr[edi+ebx]
	vsubpd ymm0,ymm0,YMMWORD ptr[esi]
	vsubpd ymm1,ymm1,YMMWORD ptr[esi+ebx]
	vmovapd YMMWORD ptr[edi],ymm0
	vmovapd YMMWORD ptr[edi+ebx],ymm1

	add esi,64
	add edi,64

VectorSub2D_AVX_2:
	test edx,1
	jz short VectorSub2D_AVX_3

	vmovapd ymm0,YMMWORD ptr[edi]
	vsubpd ymm0,ymm0,YMMWORD ptr[esi]
	vmovapd YMMWORD ptr[edi],ymm0

VectorSub2D_AVX_3:
	vzeroupper

	pop edi
	pop esi
	pop ebx

	ret

VectorSub2D_AVX endp


VectorInvSubD_AVX proc coeff_a:dword,coeff_b:dword,lgth:word

    public VectorInvSubD_AVX

	push ebx
	push esi
	push edi

	movzx edx,lgth
	mov edi,coeff_a
	mov esi,coeff_b
	mov ecx,edx
	mov eax,128
	mov ebx,32

	shr ecx,2
	jz short VectorInvSubD_AVX_1

VectorInvSubD_AVX_loop_1:
	vmovapd ymm0,YMMWORD ptr[esi]
	vmovapd ymm1,YMMWORD ptr[esi+ebx]
	vmovapd ymm2,YMMWORD ptr[esi+2*ebx]
	vmovapd ymm3,YMMWORD ptr[esi+96]

	vsubpd ymm0,ymm0,YMMWORD ptr[edi]
	vsubpd ymm1,ymm1,YMMWORD ptr[edi+ebx]
	vsubpd ymm2,ymm2,YMMWORD ptr[edi+2*ebx]
	vsubpd ymm3,ymm3,YMMWORD ptr[edi+96]

	vmovapd YMMWORD ptr[edi],ymm0
	vmovapd YMMWORD ptr[edi+ebx],ymm1
	vmovapd YMMWORD ptr[edi+2*ebx],ymm2
	vmovapd YMMWORD ptr[edi+96],ymm3

	add esi,eax
	add edi,eax
	loop VectorInvSubD_AVX_loop_1

VectorInvSubD_AVX_1:
	test edx,2
	jz short VectorInvSubD_AVX_2

	vmovapd ymm0,YMMWORD ptr[esi]
	vmovapd ymm1,YMMWORD ptr[esi+ebx]
	vsubpd ymm0,ymm0,YMMWORD ptr[edi]
	vsubpd ymm1,ymm1,YMMWORD ptr[edi+ebx]
	vmovapd YMMWORD ptr[edi],ymm0
	vmovapd YMMWORD ptr[edi+ebx],ymm1

	add esi,64
	add edi,64

VectorInvSubD_AVX_2:
	test edx,1
	jz short VectorInvSubD_AVX_3

	vmovapd ymm0,YMMWORD ptr[esi]
	vsubpd ymm0,ymm0,YMMWORD ptr[edi]
	vmovapd YMMWORD ptr[edi],ymm0

VectorInvSubD_AVX_3:
	vzeroupper

	pop edi
	pop esi
	pop ebx

	ret

VectorInvSubD_AVX endp


VectorProd2D_AVX proc coeff_a:dword,coeff_b:dword,lgth:word

    public VectorProd2D_AVX

	push ebx
	push esi
	push edi

	movzx edx,lgth
	mov edi,coeff_a
	mov esi,coeff_b
	mov ecx,edx
	mov eax,128
	mov ebx,32

	shr ecx,2
	jz short VectorProd2D_AVX_1

VectorProd2D_AVX_loop_1:
	vmovapd ymm0,YMMWORD ptr[edi]
	vmovapd ymm1,YMMWORD ptr[edi+ebx]
	vmovapd ymm2,YMMWORD ptr[edi+2*ebx]
	vmovapd ymm3,YMMWORD ptr[edi+96]

	vmulpd ymm0,ymm0,YMMWORD ptr[esi]
	vmulpd ymm1,ymm1,YMMWORD ptr[esi+ebx]
	vmulpd ymm2,ymm2,YMMWORD ptr[esi+2*ebx]
	vmulpd ymm3,ymm3,YMMWORD ptr[esi+96]

	vmovapd YMMWORD ptr[edi],ymm0
	vmovapd YMMWORD ptr[edi+ebx],ymm1
	vmovapd YMMWORD ptr[edi+2*ebx],ymm2
	vmovapd YMMWORD ptr[edi+96],ymm3

	add esi,eax
	add edi,eax
	loop VectorProd2D_AVX_loop_1

VectorProd2D_AVX_1:
	test edx,2
	jz short VectorProd2D_AVX_2

	vmovapd ymm0,YMMWORD ptr[edi]
	vmovapd ymm1,YMMWORD ptr[edi+ebx]
	vmulpd ymm0,ymm0,YMMWORD ptr[esi]
	vmulpd ymm1,ymm1,YMMWORD ptr[esi+ebx]
	vmovapd YMMWORD ptr[edi],ymm0
	vmovapd YMMWORD ptr[edi+ebx],ymm1

	add esi,64
	add edi,64

VectorProd2D_AVX_2:
	test edx,1
	jz short VectorProd2D_AVX_3

	vmovapd ymm0,YMMWORD ptr[edi]
	vmulpd ymm0,ymm0,YMMWORD ptr[esi]
	vmovapd YMMWORD ptr[edi],ymm0

VectorProd2D_AVX_3:
	vzeroupper

	pop edi
	pop esi
	pop ebx

	ret

VectorProd2D_AVX endp

end