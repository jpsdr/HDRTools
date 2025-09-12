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

.xmm
.model flat,c

data segment align(64)

sign_bits_f_32 dword 16 dup(7FFFFFFFh)
sign_bits_f_64 qword 8 dup(7FFFFFFFFFFFFFFFh)

.code


CoeffProductF_AVX512 proc coeff_a:dword,coeff_b:dword,coeff_c:dword,lgth:word

    public CoeffProductF_AVX512
	
	push ebx
	push esi
	
	mov edx,coeff_a
	
	vbroadcastss zmm0,dword ptr[edx]
	
	movzx ebx,lgth
	mov esi,coeff_b
	mov edx,coeff_c
	mov ecx,ebx
	mov eax,256

	shr ecx,2
	jz short CoeffProductF_AVX512_1

CoeffProductF_AVX512_loop_1:
	vmulps zmm1,zmm0,ZMMWORD ptr[esi]
	vmulps zmm2,zmm0,ZMMWORD ptr[esi+64]
	vmulps zmm3,zmm0,ZMMWORD ptr[esi+128]
	vmulps zmm4,zmm0,ZMMWORD ptr[esi+192]
	vmovaps ZMMWORD ptr[edx],zmm1
	vmovaps ZMMWORD ptr[edx+64],zmm2
	vmovaps ZMMWORD ptr[edx+128],zmm3
	vmovaps ZMMWORD ptr[edx+192],zmm4
	add esi,eax
	add edx,eax
	loop CoeffProductF_AVX512_loop_1

CoeffProductF_AVX512_1:
	test ebx,2
	jz short CoeffProductF_AVX512_2

	vmulps zmm1,zmm0,ZMMWORD ptr[esi]
	vmulps zmm2,zmm0,ZMMWORD ptr[esi+64]
	vmovaps ZMMWORD ptr[edx],zmm1
	vmovaps ZMMWORD ptr[edx+64],zmm2
	add esi,128
	add edx,128

CoeffProductF_AVX512_2:
	test ebx,1
	jz short CoeffProductF_AVX512_3

	vmulps zmm1,zmm0,ZMMWORD ptr[esi]
	vmovaps ZMMWORD ptr[edx],zmm1

CoeffProductF_AVX512_3:

	vzeroupper
	
	pop esi
	pop ebx
	
	ret
	
CoeffProductF_AVX512 endp
	

CoeffProduct2F_AVX512 proc coeff_a:dword,coeff_b:dword,lgth:word

    public CoeffProduct2F_AVX512
	
	push esi

	mov esi,coeff_a

	vbroadcastss zmm0,dword ptr[esi]

	movzx edx,lgth
	mov esi,coeff_b
	mov ecx,edx
	mov eax,256

	shr ecx,2
	jz short CoeffProduct2F_AVX512_1

CoeffProduct2F_AVX512_loop_1:	
	vmulps zmm1,zmm0,ZMMWORD ptr[esi]
	vmulps zmm2,zmm0,ZMMWORD ptr[esi+64]
	vmulps zmm3,zmm0,ZMMWORD ptr[esi+128]
	vmulps zmm4,zmm0,ZMMWORD ptr[esi+192]
	vmovaps ZMMWORD ptr[esi],zmm1
	vmovaps ZMMWORD ptr[esi+64],zmm2
	vmovaps ZMMWORD ptr[esi+128],zmm3
	vmovaps ZMMWORD ptr[esi+192],zmm4
	add esi,eax
	loop CoeffProduct2F_AVX512_loop_1

CoeffProduct2F_AVX512_1:
	test edx,2
	jz short CoeffProduct2F_AVX512_2

	vmulps zmm1,zmm0,ZMMWORD ptr[esi]
	vmulps zmm2,zmm0,ZMMWORD ptr[esi+64]
	vmovaps ZMMWORD ptr[esi],zmm1
	vmovaps ZMMWORD ptr[esi+64],zmm2
	add esi,128

CoeffProduct2F_AVX512_2:
	test edx,1
	jz short CoeffProduct2F_AVX512_3

	vmulps zmm1,zmm0,ZMMWORD ptr[esi]
	vmovaps ZMMWORD ptr[esi],zmm1

CoeffProduct2F_AVX512_3:
	vzeroupper

	pop esi

	ret
	
CoeffProduct2F_AVX512 endp


CoeffProductD_AVX512 proc coeff_a:dword,coeff_b:dword,coeff_c:dword,lgth:word

    public CoeffProductD_AVX512
	
	push ebx
	push esi

	mov edx,coeff_a

	vbroadcastsd zmm0,qword ptr[edx]

	movzx ebx,lgth
	mov esi,coeff_b
	mov edx,coeff_c
	mov ecx,ebx
	mov eax,256

	shr ecx,2
	jz short CoeffProductD_AVX512_1

CoeffProductD_AVX512_loop_1:
	vmulpd zmm1,zmm0,ZMMWORD ptr[esi]
	vmulpd zmm2,zmm0,ZMMWORD ptr[esi+64]
	vmulpd zmm3,zmm0,ZMMWORD ptr[esi+128]
	vmulpd zmm4,zmm0,ZMMWORD ptr[esi+192]
	vmovapd ZMMWORD ptr[edx],zmm1
	vmovapd ZMMWORD ptr[edx+64],zmm2
	vmovapd ZMMWORD ptr[edx+128],zmm3
	vmovapd ZMMWORD ptr[edx+192],zmm4
	add esi,eax
	add edx,eax
	loop CoeffProductD_AVX512_loop_1

CoeffProductD_AVX512_1:
	test ebx,2
	jz short CoeffProductD_AVX512_2

	vmulpd zmm1,zmm0,ZMMWORD ptr[esi]
	vmulpd zmm2,zmm0,ZMMWORD ptr[esi+64]
	vmovapd ZMMWORD ptr[edx],zmm1
	vmovapd ZMMWORD ptr[edx+64],zmm2
	add esi,128
	add edx,128

CoeffProductD_AVX512_2:
	test ebx,1
	jz short CoeffProductD_AVX512_3

	vmulpd zmm1,zmm0,ZMMWORD ptr[esi]
	vmovapd ZMMWORD ptr[edx],zmm1

CoeffProductD_AVX512_3:
	vzeroupper

	pop esi
	pop ebx

	ret

CoeffProductD_AVX512 endp


CoeffProduct2D_AVX512 proc coeff_a:dword,coeff_b:dword,lgth:word

    public CoeffProduct2D_AVX512

	push esi

	mov esi,coeff_a

	vbroadcastsd zmm0,qword ptr[esi]

	movzx edx,lgth
	mov esi,coeff_b
	mov ecx,edx
	mov eax,256

	shr ecx,2
	jz short CoeffProduct2D_AVX512_1

CoeffProduct2D_AVX512_loop_1:
	vmulpd zmm1,zmm0,ZMMWORD ptr[esi]
	vmulpd zmm2,zmm0,ZMMWORD ptr[esi+64]
	vmulpd zmm3,zmm0,ZMMWORD ptr[esi+128]
	vmulpd zmm4,zmm0,ZMMWORD ptr[esi+192]
	vmovapd ZMMWORD ptr[esi],zmm1
	vmovapd ZMMWORD ptr[esi+64],zmm2
	vmovapd ZMMWORD ptr[esi+128],zmm3
	vmovapd ZMMWORD ptr[esi+192],zmm4
	add esi,eax
	loop CoeffProduct2D_AVX512_loop_1

CoeffProduct2D_AVX512_1:
	test edx,2
	jz short CoeffProduct2D_AVX512_2

	vmulpd zmm1,zmm0,ZMMWORD ptr[esi]
	vmulpd zmm2,zmm0,ZMMWORD ptr[esi+64]
	vmovapd ZMMWORD ptr[esi],zmm1
	vmovapd ZMMWORD ptr[esi+64],zmm2
	add esi,128

CoeffProduct2D_AVX512_2:
	test edx,1
	jz short CoeffProduct2D_AVX512_3

	vmulpd zmm1,zmm0,ZMMWORD ptr[esi]
	vmovapd ZMMWORD ptr[esi],zmm1

CoeffProduct2D_AVX512_3:
	vzeroupper

	pop esi

	ret

CoeffProduct2D_AVX512 endp


CoeffAddProductF_AVX512 proc coeff_a:dword,coeff_b:dword,coeff_c:dword,lgth:word

    public CoeffAddProductF_AVX512

	push ebx
	push esi

	mov edx,coeff_a

	vbroadcastss zmm0,dword ptr[edx]

	movzx ebx,lgth
	mov esi,coeff_b
	mov edx,coeff_c
	mov ecx,ebx
	mov eax,128

	shr ecx,1
	jz short CoeffAddProductF_AVX512_1

CoeffAddProductF_AVX512_loop_1:
	vmulps zmm1,zmm0,ZMMWORD ptr[esi]
	vmulps zmm2,zmm0,ZMMWORD ptr[esi+64]
	vaddps zmm3,zmm1,ZMMWORD ptr[edx]
	vaddps zmm4,zmm2,ZMMWORD ptr[edx+64]
	vmovaps ZMMWORD ptr[edx],zmm3
	vmovaps ZMMWORD ptr[edx+64],zmm4
	add esi,eax
	add edx,eax
	loop CoeffAddProductF_AVX512_loop_1

CoeffAddProductF_AVX512_1:
	test ebx,1
	jz short CoeffAddProductF_AVX512_2

	vmulps zmm1,zmm0,ZMMWORD ptr[esi]
	vaddps zmm3,zmm1,ZMMWORD ptr[edx]
	vmovaps ZMMWORD ptr[edx],zmm3

CoeffAddProductF_AVX512_2:
	vzeroupper

	pop esi
	pop ebx

	ret
	
CoeffAddProductF_AVX512 endp


CoeffAddProductD_AVX512 proc coeff_a:dword,coeff_b:dword,coeff_c:dword,lgth:word

    public CoeffAddProductD_AVX512

	push ebx
	push esi

	mov edx,coeff_a

	vbroadcastsd zmm0,qword ptr[edx]

	movzx ebx,lgth
	mov esi,coeff_b
	mov edx,coeff_c
	mov ecx,ebx
	mov eax,128

	shr ecx,1
	jz short CoeffAddProductD_AVX512_1

CoeffAddProductD_AVX512_loop_1:
	vmulpd zmm1,zmm0,ZMMWORD ptr[esi]
	vmulpd zmm2,zmm0,ZMMWORD ptr[esi+64]
	vaddpd zmm3,zmm1,ZMMWORD ptr[edx]
	vaddpd zmm4,zmm2,ZMMWORD ptr[edx+64]
	vmovapd ZMMWORD ptr[edx],zmm3
	vmovapd ZMMWORD ptr[edx+64],zmm4
	add esi,eax
	add edx,eax
	loop CoeffAddProductD_AVX512_loop_1

CoeffAddProductD_AVX512_1:
	test ebx,1
	jz short CoeffAddProductD_AVX512_2

	vmulpd zmm1,zmm0,ZMMWORD ptr[esi]
	vaddpd zmm3,zmm1,ZMMWORD ptr[edx]
	vmovapd ZMMWORD ptr[edx],zmm3

CoeffAddProductD_AVX512_2:
	vzeroupper

	pop esi
	pop ebx

	ret
	
CoeffAddProductD_AVX512 endp


CoeffAddF_AVX512 proc coeff_a:dword,coeff_b:dword,coeff_c:dword,lgth:word

    public CoeffAddF_AVX512

	push ebx
	push esi

	mov esi,coeff_a

	vbroadcastss zmm0,dword ptr[esi]

	movzx ebx,lgth
	mov esi,coeff_b
	mov edx,coeff_c
	mov ecx,ebx
	mov eax,256

	shr ecx,2
	jz short CoeffAddF_AVX512_1

CoeffAddF_AVX512_loop_1:
	vaddps zmm1,zmm0,ZMMWORD ptr[esi]
	vaddps zmm2,zmm0,ZMMWORD ptr[esi+64]
	vaddps zmm3,zmm0,ZMMWORD ptr[esi+128]
	vaddps zmm4,zmm0,ZMMWORD ptr[esi+192]
	vmovaps ZMMWORD ptr[edx],zmm1
	vmovaps ZMMWORD ptr[edx+64],zmm2
	vmovaps ZMMWORD ptr[edx+128],zmm3
	vmovaps ZMMWORD ptr[edx+192],zmm4
	add esi,eax
	add edx,eax
	loop CoeffAddF_AVX512_loop_1

CoeffAddF_AVX512_1:
	test ebx,2
	jz short CoeffAddF_AVX512_2

	vaddps zmm1,zmm0,ZMMWORD ptr[esi]
	vaddps zmm2,zmm0,ZMMWORD ptr[esi+64]
	vmovaps ZMMWORD ptr[edx],zmm1
	vmovaps ZMMWORD ptr[edx+64],zmm2
	add esi,128
	add edx,128

CoeffAddF_AVX512_2:
	test ebx,1
	jz short CoeffAddF_AVX512_3

	vaddps zmm1,zmm0,ZMMWORD ptr[esi]
	vmovaps ZMMWORD ptr[edx],zmm1

CoeffAddF_AVX512_3:
	vzeroupper

	pop esi
	pop ebx

	ret

CoeffAddF_AVX512 endp


CoeffAdd2F_AVX512 proc coeff_a:dword,coeff_b:dword,lgth:word

    public CoeffAdd2F_AVX512

	push esi

	mov esi,coeff_a

	vbroadcastss zmm0,dword ptr[esi]

	movzx edx,lgth
	mov esi,coeff_b
	mov ecx,edx
	mov eax,256

	shr ecx,2
	jz short CoeffAdd2F_AVX512_1

CoeffAdd2F_AVX512_loop_1:
	vaddps zmm1,zmm0,ZMMWORD ptr[esi]
	vaddps zmm2,zmm0,ZMMWORD ptr[esi+64]
	vaddps zmm3,zmm0,ZMMWORD ptr[esi+128]
	vaddps zmm4,zmm0,ZMMWORD ptr[esi+192]
	vmovaps ZMMWORD ptr[esi],zmm1
	vmovaps ZMMWORD ptr[esi+64],zmm2
	vmovaps ZMMWORD ptr[esi+128],zmm3
	vmovaps ZMMWORD ptr[esi+192],zmm4
	add esi,eax
	loop CoeffAdd2F_AVX512_loop_1

CoeffAdd2F_AVX512_1:
	test edx,2
	jz short CoeffAdd2F_AVX512_2

	vaddps zmm1,zmm0,ZMMWORD ptr[esi]
	vaddps zmm2,zmm0,ZMMWORD ptr[esi+64]
	vmovaps ZMMWORD ptr[esi],zmm1
	vmovaps ZMMWORD ptr[esi+64],zmm2
	add esi,128

CoeffAdd2F_AVX512_2:
	test edx,1
	jz short CoeffAdd2F_AVX512_3

	vaddps zmm1,zmm0,ZMMWORD ptr[esi]
	vmovaps ZMMWORD ptr[esi],zmm1

CoeffAdd2F_AVX512_3:
	vzeroupper

	pop esi

	ret

CoeffAdd2F_AVX512 endp


CoeffAddD_AVX512 proc coeff_a:dword,coeff_b:dword,coeff_c:dword,lgth:word

    public CoeffAddD_AVX512

	push ebx
	push esi

	mov esi,coeff_a

	vbroadcastsd zmm0,qword ptr[esi]

	movzx ebx,lgth
	mov esi,coeff_b
	mov edx,coeff_c
	mov ecx,ebx
	mov eax,256

	shr ecx,2
	jz short CoeffAddD_AVX512_1

CoeffAddD_AVX512_loop_1:
	vaddpd zmm1,zmm0,ZMMWORD ptr[esi]
	vaddpd zmm2,zmm0,ZMMWORD ptr[esi+64]
	vaddpd zmm3,zmm0,ZMMWORD ptr[esi+128]
	vaddpd zmm4,zmm0,ZMMWORD ptr[esi+192]
	vmovapd ZMMWORD ptr[edx],zmm1
	vmovapd ZMMWORD ptr[edx+64],zmm2
	vmovapd ZMMWORD ptr[edx+128],zmm3
	vmovapd ZMMWORD ptr[edx+192],zmm4
	add esi,eax
	add edx,eax
	loop CoeffAddD_AVX512_loop_1

CoeffAddD_AVX512_1:
	test ebx,2
	jz short CoeffAddD_AVX512_2

	vaddpd zmm1,zmm0,ZMMWORD ptr[esi]
	vaddpd zmm2,zmm0,ZMMWORD ptr[esi+64]
	vmovapd ZMMWORD ptr[edx],zmm1
	vmovapd ZMMWORD ptr[edx+64],zmm2
	add esi,128
	add edx,128

CoeffAddD_AVX512_2:
	test ebx,1
	jz short CoeffAddD_AVX512_3

	vaddpd zmm1,zmm0,ZMMWORD ptr[esi]
	vmovapd ZMMWORD ptr[edx],zmm1

CoeffAddD_AVX512_3:
	vzeroupper

	pop esi
	pop ebx

	ret

CoeffAddD_AVX512 endp


CoeffAdd2D_AVX512 proc coeff_a:dword,coeff_b:dword,lgth:word

    public CoeffAdd2D_AVX512

	push esi

	mov esi,coeff_a

	vbroadcastsd zmm0,qword ptr[esi]

	movzx edx,lgth
	mov esi,coeff_b
	mov ecx,edx
	mov eax,256

	shr ecx,2
	jz short CoeffAdd2D_AVX512_1

CoeffAdd2D_AVX512_loop_1:
	vaddpd zmm1,zmm0,ZMMWORD ptr[esi]
	vaddpd zmm2,zmm0,ZMMWORD ptr[esi+64]
	vaddpd zmm3,zmm0,ZMMWORD ptr[esi+128]
	vaddpd zmm4,zmm0,ZMMWORD ptr[esi+192]
	vmovapd ZMMWORD ptr[esi],zmm1
	vmovapd ZMMWORD ptr[esi+64],zmm2
	vmovapd ZMMWORD ptr[esi+128],zmm3
	vmovapd ZMMWORD ptr[esi+192],zmm4
	add esi,eax
	loop CoeffAdd2D_AVX512_loop_1

CoeffAdd2D_AVX512_1:
	test edx,2
	jz short CoeffAdd2D_AVX512_2

	vaddpd zmm1,zmm0,ZMMWORD ptr[esi]
	vaddpd zmm2,zmm0,ZMMWORD ptr[esi+64]
	vmovapd ZMMWORD ptr[esi],zmm1
	vmovapd ZMMWORD ptr[esi+64],zmm2
	add esi,128

CoeffAdd2D_AVX512_2:
	test edx,1
	jz short CoeffAdd2D_AVX512_3

	vaddpd zmm1,zmm0,ZMMWORD ptr[esi]
	vmovapd ZMMWORD ptr[esi],zmm1

CoeffAdd2D_AVX512_3:
	vzeroupper

	pop esi

	ret

CoeffAdd2D_AVX512 endp


CoeffSubF_AVX512 proc coeff_a:dword,coeff_b:dword,coeff_c:dword,lgth:word

    public CoeffSubF_AVX512

	push ebx
	push esi

	mov edx,coeff_a

	vbroadcastss zmm0,dword ptr[edx]

	movzx ebx,lgth
	mov esi,coeff_b
	mov edx,coeff_c
	mov ecx,ebx
	mov eax,256

	shr ecx,2
	jz short CoeffSubF_AVX512_1

CoeffSubF_AVX512_loop_1:
	vsubps zmm1,zmm0,ZMMWORD ptr[esi]
	vsubps zmm2,zmm0,ZMMWORD ptr[esi+64]
	vsubps zmm3,zmm0,ZMMWORD ptr[esi+128]
	vsubps zmm4,zmm0,ZMMWORD ptr[esi+192]
	vmovaps ZMMWORD ptr[edx],zmm1
	vmovaps ZMMWORD ptr[edx+64],zmm2
	vmovaps ZMMWORD ptr[edx+128],zmm3
	vmovaps ZMMWORD ptr[edx+192],zmm4
	add esi,eax
	add edx,eax
	loop CoeffSubF_AVX512_loop_1

CoeffSubF_AVX512_1:
	test ebx,2
	jz short CoeffSubF_AVX512_2

	vsubps zmm1,zmm0,ZMMWORD ptr[esi]
	vsubps zmm2,zmm0,ZMMWORD ptr[esi+64]
	vmovaps ZMMWORD ptr[edx],zmm1
	vmovaps ZMMWORD ptr[edx+64],zmm2
	add esi,128
	add edx,128

CoeffSubF_AVX512_2:
	test ebx,1
	jz short CoeffSubF_AVX512_3

	vsubps zmm1,zmm0,ZMMWORD ptr[esi]
	vmovaps ZMMWORD ptr[edx],zmm1

CoeffSubF_AVX512_3:
	vzeroupper

	pop esi
	pop ebx

	ret

CoeffSubF_AVX512 endp
	

CoeffSub2F_AVX512 proc coeff_a:dword,coeff_b:dword,lgth:word

    public CoeffSub2F_AVX512

	push esi

	mov esi,coeff_a

	vbroadcastss zmm0,dword ptr[esi]

	movzx edx,lgth
	mov esi,coeff_b
	mov eax,256
	mov ecx,edx

	shr ecx,2
	jz short CoeffSub2F_AVX512_1

CoeffSub2F_AVX512_loop_1:
	vsubps zmm1,zmm0,ZMMWORD ptr[esi]
	vsubps zmm2,zmm0,ZMMWORD ptr[esi+64]
	vsubps zmm3,zmm0,ZMMWORD ptr[esi+128]
	vsubps zmm4,zmm0,ZMMWORD ptr[esi+192]
	vmovaps ZMMWORD ptr[esi],zmm1
	vmovaps ZMMWORD ptr[esi+64],zmm2
	vmovaps ZMMWORD ptr[esi+128],zmm3
	vmovaps ZMMWORD ptr[esi+192],zmm4
	add esi,eax
	loop CoeffSub2F_AVX512_loop_1

CoeffSub2F_AVX512_1:
	test edx,2
	jz short CoeffSub2F_AVX512_2

	vsubps zmm1,zmm0,ZMMWORD ptr[esi]
	vsubps zmm2,zmm0,ZMMWORD ptr[esi+64]
	vmovaps ZMMWORD ptr[esi],zmm1
	vmovaps ZMMWORD ptr[esi+64],zmm2
	add esi,128

CoeffSub2F_AVX512_2:
	test edx,1
	jz short CoeffSub2F_AVX512_3

	vsubps zmm1,zmm0,ZMMWORD ptr[esi]
	vmovaps ZMMWORD ptr[esi],zmm1

CoeffSub2F_AVX512_3:
	vzeroupper

	pop esi

	ret

CoeffSub2F_AVX512 endp


CoeffSubD_AVX512 proc coeff_a:dword,coeff_b:dword,coeff_c:dword,lgth:word

    public CoeffSubD_AVX512

	push ebx
	push esi

	mov esi,coeff_a

	vbroadcastsd zmm0,qword ptr[esi]

	movzx ebx,lgth
	mov esi,coeff_b
	mov edx,coeff_c
	mov ecx,ebx
	mov eax,256

	shr ecx,2
	jz short CoeffSubD_AVX_1

CoeffSubD_AVX_loop_1:
	vsubpd zmm1,zmm0,ZMMWORD ptr[esi]
	vsubpd zmm2,zmm0,ZMMWORD ptr[esi+64]
	vsubpd zmm3,zmm0,ZMMWORD ptr[esi+128]
	vsubpd zmm4,zmm0,ZMMWORD ptr[esi+192]
	vmovapd ZMMWORD ptr[edx],zmm1
	vmovapd ZMMWORD ptr[edx+64],zmm2
	vmovapd ZMMWORD ptr[edx+128],zmm3
	vmovapd ZMMWORD ptr[edx+192],zmm4
	add esi,eax
	add edx,eax
	loop CoeffSubD_AVX_loop_1

CoeffSubD_AVX_1:
	test ebx,2
	jz short CoeffSubD_AVX_2

	vsubpd zmm1,zmm0,ZMMWORD ptr[esi]
	vsubpd zmm2,zmm0,ZMMWORD ptr[esi+64]
	vmovapd ZMMWORD ptr[edx],zmm1
	vmovapd ZMMWORD ptr[edx+64],zmm2
	add esi,128
	add edx,128

CoeffSubD_AVX_2:
	test ebx,1
	jz short CoeffSubD_AVX_3

	vsubpd zmm1,zmm0,ZMMWORD ptr[esi]
	vmovapd ZMMWORD ptr[edx],zmm1

CoeffSubD_AVX_3:
	vzeroupper

	pop esi
	pop ebx

	ret

CoeffSubD_AVX512 endp	


CoeffSub2D_AVX512 proc coeff_a:dword,coeff_b:dword,lgth:word

    public CoeffSub2D_AVX512

	push esi

	mov esi,coeff_a

	vbroadcastsd zmm0,qword ptr[esi]

	movzx edx,lgth
	mov esi,coeff_b
	mov ecx,edx
	mov eax,256

	shr ecx,2
	jz short CoeffSub2D_AVX512_1

CoeffSub2D_AVX512_loop_1:
	vsubpd zmm1,zmm0,ZMMWORD ptr[esi]
	vsubpd zmm2,zmm0,ZMMWORD ptr[esi+64]
	vsubpd zmm3,zmm0,ZMMWORD ptr[esi+128]
	vsubpd zmm4,zmm0,ZMMWORD ptr[esi+192]
	vmovapd ZMMWORD ptr[esi],zmm1
	vmovapd ZMMWORD ptr[esi+64],zmm2
	vmovapd ZMMWORD ptr[esi+128],zmm3
	vmovapd ZMMWORD ptr[esi+192],zmm4
	add esi,eax
	loop CoeffSub2D_AVX512_loop_1

CoeffSub2D_AVX512_1:
	test edx,2
	jz short CoeffSub2D_AVX512_2

	vsubpd zmm1,zmm0,ZMMWORD ptr[esi]
	vsubpd zmm2,zmm0,ZMMWORD ptr[esi+64]
	vmovapd ZMMWORD ptr[esi],zmm1
	vmovapd ZMMWORD ptr[esi+64],zmm2
	add esi,128

CoeffSub2D_AVX512_2:
	test edx,1
	jz short CoeffSub2D_AVX512_3

	vsubpd zmm1,zmm0,ZMMWORD ptr[esi]
	vmovapd ZMMWORD ptr[esi],zmm1

CoeffSub2D_AVX512_3:
	vzeroupper

	pop esi

	ret

CoeffSub2D_AVX512 endp


VectorNorme2F_AVX512 proc coeff_x:dword,result:dword,lgth:word

    public VectorNorme2F_AVX512

	push esi
	push ebx

	mov esi,coeff_x
	movzx edx,lgth
	mov eax,256
	mov ebx,64
	mov ecx,edx

	vxorps zmm0,zmm0,zmm0

	shr ecx,2
	jz short VectorNorme2F_AVX512_1

VectorNorme2F_AVX512_loop_1:
	vmovaps zmm1,ZMMWORD ptr[esi]
	vmovaps zmm2,ZMMWORD ptr[esi+ebx]
	vmovaps zmm3,ZMMWORD ptr[esi+2*ebx]
	vmovaps zmm4,ZMMWORD ptr[esi+192]

	vmulps zmm1,zmm1,zmm1
	vmulps zmm2,zmm2,zmm2
	vmulps zmm3,zmm3,zmm3
	vmulps zmm4,zmm4,zmm4

	vaddps zmm1,zmm1,zmm2
	vaddps zmm3,zmm3,zmm4
	vaddps zmm1,zmm1,zmm3
	add esi,eax
	vaddps zmm0,zmm0,zmm1
	loop VectorNorme2F_AVX512_loop_1

VectorNorme2F_AVX512_1:
	test edx,2
	jz short VectorNorme2F_AVX512_2

	vmovaps zmm1,ZMMWORD ptr[esi]
	vmovaps zmm2,ZMMWORD ptr[esi+ebx]
	vmulps zmm1,zmm1,zmm1
	vmulps zmm2,zmm2,zmm2
	vaddps zmm1,zmm1,zmm2
	add esi,128
	vaddps zmm0,zmm0,zmm1

VectorNorme2F_AVX512_2:
	test edx,1
	jz short VectorNorme2F_AVX512_3

	vmovaps zmm1,ZMMWORD ptr[esi]
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

	mov esi,result

	vpsrldq xmm1,xmm0,4
	vpsrldq xmm3,xmm2,4

	vaddss xmm0,xmm0,xmm1
	vaddss xmm2,xmm2,xmm3

	vaddps xmm0,xmm0,xmm2
	vsqrtss xmm0,xmm0,xmm0
	vmovss dword ptr[esi],xmm0

	pop ebx
	pop esi

	vzeroupper

	ret

VectorNorme2F_AVX512 endp


VectorNorme2D_AVX512 proc coeff_x:dword,result:dword,lgth:word

    public VectorNorme2D_AVX512

	push esi
	push ebx

	mov esi,coeff_x
	movzx edx,lgth
	mov eax,256
	mov ebx,64
	mov ecx,edx

	vxorpd zmm0,zmm0,zmm0

	shr ecx,2
	jz short VectorNorme2D_AVX512_1

VectorNorme2D_AVX512_loop_1:
	vmovapd zmm1,ZMMWORD ptr[esi]
	vmovapd zmm2,ZMMWORD ptr[esi+ebx]
	vmovapd zmm3,ZMMWORD ptr[esi+2*ebx]
	vmovapd zmm4,ZMMWORD ptr[esi+192]

	vmulpd zmm1,zmm1,zmm1
	vmulpd zmm2,zmm2,zmm2
	vmulpd zmm3,zmm3,zmm3
	vmulpd zmm4,zmm4,zmm4

	vaddpd zmm1,zmm1,zmm2
	vaddpd zmm3,zmm3,zmm4
	vaddpd zmm1,zmm1,zmm3
	add esi,eax
	vaddpd zmm0,zmm0,zmm1
	loop VectorNorme2D_AVX512_loop_1

VectorNorme2D_AVX512_1:
	test edx,2
	jz short VectorNorme2D_AVX512_2

	vmovapd zmm1,ZMMWORD ptr[esi]
	vmovapd zmm2,ZMMWORD ptr[esi+ebx]
	vmulpd zmm1,zmm1,zmm1
	vmulpd zmm2,zmm2,zmm2
	vaddpd zmm1,zmm1,zmm2
	add esi,128
	vaddpd zmm0,zmm0,zmm1

VectorNorme2D_AVX512_2:
	test edx,1
	jz short VectorNorme2D_AVX512_3

	vmovapd zmm1,ZMMWORD ptr[esi]
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

	mov esi,result

	vaddsd xmm0,xmm0,xmm1
	vaddsd xmm2,xmm2,xmm3

	vaddpd xmm0,xmm0,xmm2
	vsqrtsd xmm0,xmm0,xmm0
	vmovsd qword ptr[esi],xmm0

	vzeroupper

	pop esi

	ret

VectorNorme2D_AVX512 endp


VectorDist2F_AVX512 proc coeff_x:dword,coeff_y:dword,result:dword,lgth:word

    public VectorDist2F_AVX512

	push esi
	push edi

	mov esi,coeff_x
	mov edi,coeff_y
	movzx edx,lgth
	mov eax,256
	mov ecx,edx

	vxorps zmm0,zmm0,zmm0

	shr ecx,2
	jz short VectorDist2F_AVX512_1

VectorDist2F_AVX512_loop_1:
	vmovaps zmm1,ZMMWORD ptr[esi]
	vmovaps zmm2,ZMMWORD ptr[esi+64]
	vmovaps zmm3,ZMMWORD ptr[esi+128]
	vmovaps zmm4,ZMMWORD ptr[esi+192]

	vsubps zmm1,zmm1,ZMMWORD ptr[edi]
	vsubps zmm2,zmm2,ZMMWORD ptr[edi+64]
	vsubps zmm3,zmm3,ZMMWORD ptr[edi+128]
	vsubps zmm4,zmm4,ZMMWORD ptr[edi+192]

	vmulps zmm1,zmm1,zmm1
	vmulps zmm2,zmm2,zmm2
	vmulps zmm3,zmm3,zmm3
	vmulps zmm4,zmm4,zmm4

	vaddps zmm1,zmm1,zmm2
	vaddps zmm3,zmm3,zmm4
	add esi,eax
	vaddps zmm1,zmm1,zmm3
	add edi,eax
	vaddps zmm0,zmm0,zmm1

	loop VectorDist2F_AVX512_loop_1

VectorDist2F_AVX512_1:
	test edx,2
	jz short VectorDist2F_AVX512_2

	vmovaps zmm1,ZMMWORD ptr[esi]
	vmovaps zmm2,ZMMWORD ptr[esi+64]
	vsubps zmm1,zmm1,ZMMWORD ptr[edi]
	vsubps zmm2,zmm2,ZMMWORD ptr[edi+64]
	vmulps zmm1,zmm1,zmm1
	vmulps zmm2,zmm2,zmm2

	add esi,128
	vaddps zmm1,zmm1,zmm2
	add edi,128
	vaddps zmm0,zmm0,zmm1

VectorDist2F_AVX512_2:
	test edx,1
	jz short VectorDist2F_AVX512_3

	vmovaps zmm1,ZMMWORD ptr[esi]
	vsubps zmm1,zmm1,ZMMWORD ptr[edi]
	vmulps zmm1,zmm1,zmm1
	vaddps zmm0,zmm0,zmm1

VectorDist2F_AVX512_3:
	vextractf32x8 ymm2,zmm0,1

	vextractf128 xmm1,ymm0,1
	vextractf128 xmm3,ymm2,1

	vaddps xmm0,xmm0,xmm1
	vaddps xmm2,xmm2,xmm3

	vmovhlps xmm1,xmm1,xmm0
	vmovhlps xmm3,xmm3,xmm2

	vaddps xmm0,xmm0,xmm1
	vaddps xmm2,xmm2,xmm3

	mov esi,result

	vpsrldq xmm1,xmm0,4
	vpsrldq xmm3,xmm2,4

	vaddss xmm0,xmm0,xmm1
	vaddss xmm2,xmm2,xmm3

	vaddps xmm0,xmm0,xmm2
	vsqrtss xmm0,xmm0,xmm0
	vmovss dword ptr[esi],xmm0

	vzeroupper

	pop edi
	pop esi

	ret

VectorDist2F_AVX512 endp	


VectorDist2D_AVX512 proc coeff_x:dword,coeff_y:dword,result:dword,lgth:word

    public VectorDist2D_AVX512

	push esi
	push edi

	mov esi,coeff_x
	mov edi,coeff_y
	movzx edx,lgth
	mov eax,256
	mov ecx,edx
		
	vxorpd zmm0,zmm0,zmm0

	shr ecx,2
	jz short VectorDist2D_AVX512_1
		
VectorDist2D_AVX512_loop_1:
	vmovapd zmm1,ZMMWORD ptr[esi]
	vmovapd zmm2,ZMMWORD ptr[esi+64]
	vmovapd zmm3,ZMMWORD ptr[esi+128]
	vmovapd zmm4,ZMMWORD ptr[esi+192]

	vsubpd zmm1,zmm1,ZMMWORD ptr[edi]
	vsubpd zmm2,zmm2,ZMMWORD ptr[edi+64]
	vsubpd zmm3,zmm3,ZMMWORD ptr[edi+128]
	vsubpd zmm4,zmm4,ZMMWORD ptr[edi+192]

	vmulpd zmm1,zmm1,zmm1
	vmulpd zmm2,zmm2,zmm2
	vmulpd zmm3,zmm3,zmm3
	vmulpd zmm4,zmm4,zmm4

	vaddpd zmm1,zmm1,zmm2
	vaddpd zmm3,zmm3,zmm4
	add esi,eax
	vaddpd zmm1,zmm1,zmm3
	add edi,eax
	vaddpd zmm0,zmm0,zmm1

	loop VectorDist2D_AVX512_loop_1

VectorDist2D_AVX512_1:
	test edx,2
	jz short VectorDist2D_AVX512_2

	vmovapd zmm1,ZMMWORD ptr[esi]
	vmovapd zmm2,ZMMWORD ptr[esi+64]
	vsubpd zmm1,zmm1,ZMMWORD ptr[edi]
	vsubpd zmm2,zmm2,ZMMWORD ptr[edi+64]
	vmulpd zmm1,zmm1,zmm1
	vmulpd zmm2,zmm2,zmm2

	add esi,128
	vaddpd zmm1,zmm1,zmm2
	add edi,128
	vaddpd zmm0,zmm0,zmm1

VectorDist2D_AVX512_2:
	test edx,1
	jz short VectorDist2D_AVX512_3

	vmovapd zmm1,ZMMWORD ptr[esi]
	vsubpd zmm1,zmm1,ZMMWORD ptr[edi]
	vmulpd zmm1,zmm1,zmm1
	vaddpd zmm0,zmm0,zmm1

VectorDist2D_AVX512_3:
	vextractf64x4 ymm2,zmm0,1

	vextractf128 xmm1,ymm0,1
	vextractf128 xmm3,ymm2,1

	vaddpd xmm0,xmm0,xmm1
	vaddpd xmm2,xmm2,xmm3
		
	vmovhlps xmm1,xmm1,xmm0
	vmovhlps xmm3,xmm3,xmm2

	mov esi,result

	vaddsd xmm0,xmm0,xmm1
	vaddsd xmm2,xmm2,xmm3

	vaddpd xmm0,xmm0,xmm2
	vsqrtsd xmm0,xmm0,xmm0
	vmovsd qword ptr[esi],xmm0
		
	vzeroupper

	pop edi
	pop esi
		
	ret
		
VectorDist2D_AVX512 endp	


VectorNormeF_AVX512 proc coeff_x:dword,result:dword,lgth:word

    public VectorNormeF_AVX512

	push ebx
	push esi

	mov esi,coeff_x
	movzx edx,lgth
	mov eax,256
	mov ebx,64
	mov ecx,edx

	vxorps zmm0,zmm0,zmm0

	shr ecx,2
	jz short VectorNormeF_AVX512_1

VectorNormeF_AVX512_loop_1:
	vmovaps zmm1,ZMMWORD ptr[esi]
	vmovaps zmm2,ZMMWORD ptr[esi+ebx]
	vmovaps zmm3,ZMMWORD ptr[esi+2*ebx]
	vmovaps zmm4,ZMMWORD ptr[esi+192]

	vmulps zmm1,zmm1,zmm1
	vmulps zmm2,zmm2,zmm2
	vmulps zmm3,zmm3,zmm3
	vmulps zmm4,zmm4,zmm4

	vaddps zmm1,zmm1,zmm2
	vaddps zmm3,zmm3,zmm4
	vaddps zmm1,zmm1,zmm3
	add esi,eax
	vaddps zmm0,zmm0,zmm1

	loop VectorNormeF_AVX512_loop_1

VectorNormeF_AVX512_1:
	test edx,2
	jz short VectorNormeF_AVX512_2

	vmovaps zmm1,ZMMWORD ptr[esi]
	vmovaps zmm2,ZMMWORD ptr[esi+ebx]
	vmulps zmm1,zmm1,zmm1
	vmulps zmm2,zmm2,zmm2

	vaddps zmm1,zmm1,zmm2
	add esi,128
	vaddps zmm0,zmm0,zmm1

VectorNormeF_AVX512_2:
	test edx,1
	jz short VectorNormeF_AVX512_3

	vmovaps zmm1,ZMMWORD ptr[esi]
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

	mov esi,result

	vpsrldq xmm1,xmm0,4
	vpsrldq xmm3,xmm2,4

	vaddss xmm0,xmm0,xmm1
	vaddss xmm2,xmm2,xmm3

	vaddps xmm0,xmm0,xmm2
	vmovss dword ptr[esi],xmm0

	vzeroupper

	pop esi
	pop ebx

	ret

VectorNormeF_AVX512 endp


VectorNormeD_AVX512 proc coeff_x:dword,result:dword,lgth:word

    public VectorNormeD_AVX512

	push ebx
	push esi

	mov esi,coeff_x
	movzx edx,lgth
	mov eax,256
	mov ebx,64
	mov ecx,edx

	vxorpd zmm0,zmm0,zmm0

	shr ecx,2
	jz short VectorNormeD_AVX512_1

VectorNormeD_AVX512_loop_1:
	vmovapd zmm1,ZMMWORD ptr[esi]
	vmovapd zmm2,ZMMWORD ptr[esi+ebx]
	vmovapd zmm3,ZMMWORD ptr[esi+2*ebx]
	vmovapd zmm4,ZMMWORD ptr[esi+192]

	vmulpd zmm1,zmm1,zmm1
	vmulpd zmm2,zmm2,zmm2
	vmulpd zmm3,zmm3,zmm3
	vmulpd zmm4,zmm4,zmm4

	vaddpd zmm1,zmm1,zmm2
	vaddpd zmm3,zmm3,zmm4
	vaddpd zmm1,zmm1,zmm3
	add esi,eax
	vaddpd zmm0,zmm0,zmm1

	loop VectorNormeD_AVX512_loop_1

VectorNormeD_AVX512_1:
	test edx,2
	jz short VectorNormeD_AVX512_2

	vmovapd zmm1,ZMMWORD ptr[esi]
	vmovapd zmm2,ZMMWORD ptr[esi+ebx]
	vmulpd zmm1,zmm1,zmm1
	vmulpd zmm2,zmm2,zmm2

	vaddpd zmm1,zmm1,zmm2
	add esi,128
	vaddpd zmm0,zmm0,zmm1

VectorNormeD_AVX512_2:
	test edx,1
	jz short VectorNormeD_AVX512_3

	vmovapd zmm1,ZMMWORD ptr[esi]
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

	mov esi,result

	vaddsd xmm0,xmm0,xmm1
	vaddsd xmm2,xmm2,xmm3

	vaddpd xmm0,xmm0,xmm2
	vmovsd qword ptr[esi],xmm0

	vzeroupper	

	pop esi
	pop ebx

	ret

VectorNormeD_AVX512 endp


VectorDistF_AVX512 proc coeff_x:dword,coeff_y:dword,result:dword,lgth:word

    public VectorDistF_AVX512

	push ebx
	push esi
	push edi

	mov esi,coeff_x
	mov edi,coeff_y
	movzx edx,lgth
	mov eax,256
	mov ebx,64
	mov ecx,edx

	vxorps zmm0,zmm0,zmm0

	shr ecx,2
	jz short VectorDistF_AVX512_1

VectorDistF_AVX512_loop_1:
	vmovaps zmm1,ZMMWORD ptr[esi]
	vmovaps zmm2,ZMMWORD ptr[esi+ebx]
	vmovaps zmm3,ZMMWORD ptr[esi+2*ebx]
	vmovaps zmm4,ZMMWORD ptr[esi+192]

	vsubps zmm1,zmm1,ZMMWORD ptr[edi]
	vsubps zmm2,zmm2,ZMMWORD ptr[edi+ebx]
	vsubps zmm3,zmm3,ZMMWORD ptr[edi+2*ebx]
	vsubps zmm4,zmm4,ZMMWORD ptr[edi+192]

	vmulps zmm1,zmm1,zmm1
	vmulps zmm2,zmm2,zmm2
	vmulps zmm3,zmm3,zmm3
	vmulps zmm4,zmm4,zmm4

	vaddps zmm1,zmm1,zmm2
	vaddps zmm3,zmm3,zmm4
	add esi,eax
	vaddps zmm1,zmm1,zmm3
	add edi,eax
	vaddps zmm0,zmm0,zmm1

	loop VectorDistF_AVX512_loop_1

VectorDistF_AVX512_1:
	test edx,2
	jz short VectorDistF_AVX512_2

	vmovaps zmm1,ZMMWORD ptr[esi]
	vmovaps zmm2,ZMMWORD ptr[esi+ebx]
	vsubps zmm1,zmm1,ZMMWORD ptr[edi]
	vsubps zmm2,zmm2,ZMMWORD ptr[edi+ebx]
	vmulps zmm1,zmm1,zmm1
	vmulps zmm2,zmm2,zmm2

	add esi,128
	vaddps zmm1,zmm1,zmm2
	add edi,128
	vaddps zmm0,zmm0,zmm1

VectorDistF_AVX512_2:
	test edx,1
	jz short VectorDistF_AVX512_3

	vmovaps zmm1,ZMMWORD ptr[esi]
	vsubps zmm1,zmm1,ZMMWORD ptr[edi]
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

	mov edi,result

	vpsrldq xmm1,xmm0,4
	vpsrldq xmm3,xmm2,4

	vaddss xmm0,xmm0,xmm1
	vaddss xmm2,xmm2,xmm3

	vaddps xmm0,xmm0,xmm2
	vmovss dword ptr[edi],xmm0

	vzeroupper

	pop edi
	pop esi
	pop ebx

	ret

VectorDistF_AVX512 endp	


VectorDistD_AVX512 proc coeff_x:dword,coeff_y:dword,result:dword,lgth:word

    public VectorDistD_AVX512

	push ebx
	push esi
	push edi

	mov esi,coeff_x
	mov edi,coeff_y
	movzx edx,lgth
	mov eax,256
	mov ebx,64
	mov ecx,edx

	vxorpd zmm0,zmm0,zmm0

	shr ecx,2
	jz short VectorDistD_AVX512_1

VectorDistD_AVX512_loop_1:
	vmovapd zmm1,ZMMWORD ptr[esi]
	vmovapd zmm2,ZMMWORD ptr[esi+ebx]
	vmovapd zmm3,ZMMWORD ptr[esi+2*ebx]
	vmovapd zmm4,ZMMWORD ptr[esi+192]

	vsubpd zmm1,zmm1,ZMMWORD ptr[edi]
	vsubpd zmm2,zmm2,ZMMWORD ptr[edi+ebx]
	vsubpd zmm3,zmm3,ZMMWORD ptr[edi+2*ebx]
	vsubpd zmm4,zmm4,ZMMWORD ptr[edi+192]

	vmulpd zmm1,zmm1,zmm1
	vmulpd zmm2,zmm2,zmm2
	vmulpd zmm3,zmm3,zmm3
	vmulpd zmm4,zmm4,zmm4

	vaddpd zmm1,zmm1,zmm2
	vaddpd zmm3,zmm3,zmm4
	add esi,eax
	vaddpd zmm1,zmm1,zmm3
	add edi,eax
	vaddpd zmm0,zmm0,zmm1

	loop VectorDistD_AVX512_loop_1

VectorDistD_AVX512_1:
	test edx,2
	jz short VectorDistD_AVX512_2

	vmovapd zmm1,ZMMWORD ptr[esi]
	vmovapd zmm2,ZMMWORD ptr[esi+ebx]
	vsubpd zmm1,zmm1,ZMMWORD ptr[edi]
	vsubpd zmm2,zmm2,ZMMWORD ptr[edi+ebx]
	vmulpd zmm1,zmm1,zmm1
	vmulpd zmm2,zmm2,zmm2

	add esi,128
	vaddpd zmm1,zmm1,zmm2
	add edi,128
	vaddpd zmm0,zmm0,zmm1


VectorDistD_AVX512_2:
	test edx,1
	jz short VectorDistD_AVX512_3

	vmovapd zmm1,ZMMWORD ptr[esi]
	vsubpd zmm1,zmm1,ZMMWORD ptr[edi]
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

	mov edi,result

	vaddsd xmm0,xmm0,xmm1
	vaddsd xmm2,xmm2,xmm3

	vaddpd xmm0,xmm0,xmm2
	vmovsd qword ptr[edi],xmm0

	vzeroupper

	pop edi
	pop esi
	pop ebx

	ret

VectorDistD_AVX512 endp


VectorNorme1F_AVX512 proc coeff_x:dword,result:dword,lgth:word

    public VectorNorme1F_AVX512

	push ebx
	push esi

	mov esi,coeff_x
	movzx edx,lgth
	mov eax,256
	mov ebx,64
	mov ecx,edx

	vxorps zmm0,zmm0,zmm0
	vmovaps zmm5,ZMMWORD ptr sign_bits_f_32
	
	shr ecx,2
	jz short VectorNorme1F_AVX512_1

VectorNorme1F_AVX512_loop_1:
	vandps zmm1,zmm5,ZMMWORD ptr[esi]
	vandps zmm2,zmm5,ZMMWORD ptr[esi+ebx]
	vandps zmm3,zmm5,ZMMWORD ptr[esi+2*ebx]
	vandps zmm4,zmm5,ZMMWORD ptr[esi+192]

	vaddps zmm1,zmm1,zmm2
	vaddps zmm3,zmm3,zmm4
	vaddps zmm1,zmm1,zmm3
	add esi,eax
	vaddps zmm0,zmm0,zmm1

	loop VectorNorme1F_AVX512_loop_1

VectorNorme1F_AVX512_1:
	test edx,2
	jz short VectorNorme1F_AVX512_2

	vandps zmm1,zmm5,ZMMWORD ptr[esi]
	vandps zmm2,zmm5,ZMMWORD ptr[esi+ebx]

	vaddps zmm1,zmm1,zmm2
	add esi,128
	vaddps zmm0,zmm0,zmm1

VectorNorme1F_AVX512_2:
	test edx,1
	jz short VectorNorme1F_AVX512_3

	vandps zmm1,zmm5,ZMMWORD ptr[esi]
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

	mov esi,result

	vpsrldq xmm1,xmm0,4
	vpsrldq xmm3,xmm2,4

	vaddss xmm0,xmm0,xmm1
	vaddss xmm2,xmm2,xmm3

	vaddps xmm0,xmm0,xmm2
	vmovss dword ptr[esi],xmm0

	vzeroupper

	pop esi
	pop ebx

	ret

VectorNorme1F_AVX512 endp


VectorNorme1D_AVX512 proc coeff_x:dword,result:dword,lgth:word

    public VectorNorme1D_AVX512

	push ebx
	push esi

	mov esi,coeff_x
	movzx edx,lgth
	mov eax,256
	mov ebx,64
	mov ecx,edx

	vxorpd zmm0,zmm0,zmm0
	vmovapd zmm5,ZMMWORD ptr sign_bits_f_64

	shr ecx,2
	jz short VectorNorme1D_AVX512_1

VectorNorme1D_AVX512_loop_1:
	vandpd zmm1,zmm5,ZMMWORD ptr[esi]
	vandpd zmm2,zmm5,ZMMWORD ptr[esi+ebx]
	vandpd zmm3,zmm5,ZMMWORD ptr[esi+2*ebx]
	vandpd zmm4,zmm5,ZMMWORD ptr[esi+192]

	vaddpd zmm1,zmm1,zmm2
	vaddpd zmm3,zmm3,zmm4
	vaddpd zmm1,zmm1,zmm3
	add esi,eax
	vaddpd zmm0,zmm0,zmm1

	loop VectorNorme1D_AVX512_loop_1

VectorNorme1D_AVX512_1:
	test edx,2
	jz short VectorNorme1D_AVX512_2

	vandpd zmm1,zmm5,ZMMWORD ptr[esi]
	vandpd zmm2,zmm5,ZMMWORD ptr[esi+ebx]

	vaddpd zmm1,zmm1,zmm2
	add esi,128
	vaddpd zmm0,zmm0,zmm1

VectorNorme1D_AVX512_2:
	test edx,1
	jz short VectorNorme1D_AVX512_3

	vandpd zmm1,zmm5,ZMMWORD ptr[esi]
	vaddpd zmm0,zmm0,zmm1

VectorNorme1D_AVX512_3:
	vextractf64x4 ymm2,zmm0,1

	vextractf128 xmm1,ymm0,1
	vextractf128 xmm3,ymm2,1

	vaddpd xmm0,xmm0,xmm1
	vaddpd xmm2,xmm2,xmm3

	vmovhlps xmm1,xmm1,xmm0
	vmovhlps xmm3,xmm3,xmm2

	mov esi,result

	vaddsd xmm0,xmm0,xmm1
	vaddsd xmm2,xmm2,xmm3

	vaddpd xmm0,xmm0,xmm2
	vmovsd qword ptr[esi],xmm0

	vzeroupper	

	pop esi
	pop ebx

	ret

VectorNorme1D_AVX512 endp


VectorDist1F_AVX512 proc coeff_x:dword,coeff_y:dword,result:dword,lgth:word

    public VectorDist1F_AVX512

	push ebx
	push esi
	push edi

	mov esi,coeff_x
	mov edi,coeff_y
	movzx edx,lgth
	mov eax,256
	mov ebx,64
	mov ecx,edx

	vxorps zmm0,zmm0,zmm0
	vmovaps zmm5,ZMMWORD ptr sign_bits_f_32

	shr ecx,2
	jz short VectorDist1F_AVX512_1

VectorDist1F_AVX512_loop_1:
	vmovaps zmm1,ZMMWORD ptr[esi]
	vmovaps zmm2,ZMMWORD ptr[esi+ebx]
	vmovaps zmm3,ZMMWORD ptr[esi+2*ebx]
	vmovaps zmm4,ZMMWORD ptr[esi+192]

	vsubps zmm1,zmm1,ZMMWORD ptr[edi]
	vsubps zmm2,zmm2,ZMMWORD ptr[edi+ebx]
	vsubps zmm3,zmm3,ZMMWORD ptr[edi+2*ebx]
	vsubps zmm4,zmm4,ZMMWORD ptr[edi+192]

	vandps zmm1,zmm1,zmm5
	vandps zmm2,zmm2,zmm5
	vandps zmm3,zmm3,zmm5
	vandps zmm4,zmm4,zmm5

	vaddps zmm1,zmm1,zmm2
	vaddps zmm3,zmm3,zmm4
	add esi,eax
	vaddps zmm1,zmm1,zmm3
	add edi,eax
	vaddps zmm0,zmm0,zmm1

	loop VectorDist1F_AVX512_loop_1

VectorDist1F_AVX512_1:
	test edx,2
	jz short VectorDist1F_AVX512_2

	vmovaps zmm1,ZMMWORD ptr[esi]
	vmovaps zmm2,ZMMWORD ptr[esi+ebx]
	vsubps zmm1,zmm1,ZMMWORD ptr[edi]
	vsubps zmm2,zmm2,ZMMWORD ptr[edi+ebx]
	vandps zmm1,zmm1,zmm5
	vandps zmm2,zmm2,zmm5

	add esi,128
	vaddps zmm1,zmm1,zmm2
	add edi,128
	vaddps zmm0,zmm0,zmm1

VectorDist1F_AVX512_2:
	test edx,1
	jz short VectorDist1F_AVX512_3

	vmovaps zmm1,ZMMWORD ptr[esi]
	vsubps zmm1,zmm1,ZMMWORD ptr[edi]
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

	mov edi,result

	vpsrldq xmm1,xmm0,4
	vpsrldq xmm3,xmm2,4

	vaddss xmm0,xmm0,xmm1
	vaddss xmm2,xmm2,xmm3

	vaddps xmm0,xmm0,xmm2
	vmovss dword ptr[edi],xmm0

	vzeroupper

	pop edi
	pop esi
	pop ebx

	ret

VectorDist1F_AVX512 endp	


VectorDist1D_AVX512 proc coeff_x:dword,coeff_y:dword,result:dword,lgth:word

    public VectorDist1D_AVX512

	push ebx
	push esi
	push edi

	mov esi,coeff_x
	mov edi,coeff_y
	movzx edx,lgth
	mov eax,256
	mov ebx,64
	mov ecx,edx

	vxorpd zmm0,zmm0,zmm0
	vmovapd zmm5,ZMMWORD ptr sign_bits_f_64

	shr ecx,2
	jz short VectorDist1D_AVX512_1

VectorDist1D_AVX512_loop_1:
	vmovapd zmm1,ZMMWORD ptr[esi]
	vmovapd zmm2,ZMMWORD ptr[esi+ebx]
	vmovapd zmm3,ZMMWORD ptr[esi+2*ebx]
	vmovapd zmm4,ZMMWORD ptr[esi+192]

	vsubpd zmm1,zmm1,ZMMWORD ptr[edi]
	vsubpd zmm2,zmm2,ZMMWORD ptr[edi+ebx]
	vsubpd zmm3,zmm3,ZMMWORD ptr[edi+2*ebx]
	vsubpd zmm4,zmm4,ZMMWORD ptr[edi+192]

	vandpd zmm1,zmm1,zmm5
	vandpd zmm2,zmm2,zmm5
	vandpd zmm3,zmm3,zmm5
	vandpd zmm4,zmm4,zmm5

	vaddpd zmm1,zmm1,zmm2
	vaddpd zmm3,zmm3,zmm4
	add esi,eax
	vaddpd zmm1,zmm1,zmm3
	add edi,eax
	vaddpd zmm0,zmm0,zmm1

	loop VectorDist1D_AVX512_loop_1

VectorDist1D_AVX512_1:
	test edx,2
	jz short VectorDist1D_AVX512_2

	vmovapd zmm1,ZMMWORD ptr[esi]
	vmovapd zmm2,ZMMWORD ptr[esi+ebx]
	vsubpd zmm1,zmm1,ZMMWORD ptr[edi]
	vsubpd zmm2,zmm2,ZMMWORD ptr[edi+ebx]
	vandpd zmm1,zmm1,zmm5
	vandpd zmm2,zmm2,zmm5

	add esi,128
	vaddpd zmm1,zmm1,zmm2
	add edi,128
	vaddpd zmm0,zmm0,zmm1

VectorDist1D_AVX512_2:
	test edx,1
	jz short VectorDist1D_AVX512_3

	vmovapd zmm1,ZMMWORD ptr[esi]
	vsubpd zmm1,zmm1,ZMMWORD ptr[edi]
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

	mov edi,result

	vaddsd xmm0,xmm0,xmm1
	vaddsd xmm2,xmm2,xmm3

	vaddpd xmm0,xmm0,xmm2
	vmovsd qword ptr[edi],xmm0

	vzeroupper

	pop edi
	pop esi
	pop ebx

	ret

VectorDist1D_AVX512 endp	


VectorProductF_AVX512 proc coeff_a:dword,coeff_x:dword,result:dword,lgth:word

    public VectorProductF_AVX512

	push ebx
	push esi
	push edi

	mov esi,coeff_a
	mov edi,coeff_x
	movzx edx,lgth
	mov eax,256
	mov ebx,64
	mov ecx,edx

	vxorps zmm0,zmm0,zmm0

	shr ecx,2
	jz short VectorProductF_AVX512_1

VectorProductF_AVX512_loop_1:
	vmovaps zmm1,ZMMWORD ptr[esi]
	vmovaps zmm2,ZMMWORD ptr[esi+ebx]
	vmovaps zmm3,ZMMWORD ptr[esi+2*ebx]
	vmovaps zmm4,ZMMWORD ptr[esi+192]

	vmulps zmm1,zmm1,ZMMWORD ptr[edi]
	vmulps zmm2,zmm2,ZMMWORD ptr[edi+ebx]
	vmulps zmm3,zmm3,ZMMWORD ptr[edi+2*ebx]
	vmulps zmm4,zmm4,ZMMWORD ptr[edi+192]

	vaddps zmm1,zmm1,zmm2
	vaddps zmm3,zmm3,zmm4
	add esi,eax
	vaddps zmm1,zmm1,zmm3
	add edi,eax
	vaddps zmm0,zmm0,zmm1

	loop VectorProductF_AVX512_loop_1

VectorProductF_AVX512_1:
	test edx,2
	jz short VectorProductF_AVX512_2

	vmovaps zmm1,ZMMWORD ptr[esi]
	vmovaps zmm2,ZMMWORD ptr[esi+ebx]
	vmulps zmm1,zmm1,ZMMWORD ptr[edi]
	vmulps zmm2,zmm2,ZMMWORD ptr[edi+ebx]

	add esi,128
	vaddps zmm1,zmm1,zmm2
	add edi,128
	vaddps zmm0,zmm0,zmm1

VectorProductF_AVX512_2:
	test edx,1
	jz short VectorProductF_AVX512_3

	vmovaps zmm1,ZMMWORD ptr[esi]
	vmulps zmm1,zmm1,ZMMWORD ptr[edi]
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

	mov edi,result

	vpsrldq xmm1,xmm0,4
	vpsrldq xmm3,xmm2,4

	vaddss xmm0,xmm0,xmm1
	vaddss xmm2,xmm2,xmm3

	vaddps xmm0,xmm0,xmm2
	vmovss dword ptr[edi],xmm0

	vzeroupper

	pop edi
	pop esi
	pop ebx

	ret

VectorProductF_AVX512 endp	

		
VectorProductD_AVX512 proc coeff_a:dword,coeff_x:dword,result:dword,lgth:word

    public VectorProductD_AVX512

	push ebx
	push esi
	push edi

	mov esi,coeff_a
	mov edi,coeff_x
	movzx edx,lgth
	mov eax,256
	mov ebx,64
	mov ecx,edx

	vxorpd zmm0,zmm0,zmm0

	shr ecx,2
	jz short VectorProductD_AVX512_1

VectorProductD_AVX512_loop_1:
	vmovapd zmm1,ZMMWORD ptr[esi]
	vmovapd zmm2,ZMMWORD ptr[esi+ebx]
	vmovapd zmm3,ZMMWORD ptr[esi+2*ebx]
	vmovapd zmm4,ZMMWORD ptr[esi+192]

	vmulpd zmm1,zmm1,ZMMWORD ptr[edi]
	vmulpd zmm2,zmm2,ZMMWORD ptr[edi+ebx]
	vmulpd zmm3,zmm3,ZMMWORD ptr[edi+2*ebx]
	vmulpd zmm4,zmm4,ZMMWORD ptr[edi+192]

	vaddpd zmm1,zmm1,zmm2
	vaddpd zmm3,zmm3,zmm4
	add esi,eax
	vaddpd zmm1,zmm1,zmm3
	add edi,eax
	vaddpd zmm0,zmm0,zmm1

	loop VectorProductD_AVX512_loop_1

VectorProductD_AVX512_1:
	test edx,2
	jz short VectorProductD_AVX512_2

	vmovapd zmm1,ZMMWORD ptr[esi]
	vmovapd zmm2,ZMMWORD ptr[esi+ebx]
	vmulpd zmm1,zmm1,ZMMWORD ptr[edi]
	vmulpd zmm2,zmm2,ZMMWORD ptr[edi+ebx]

	add esi,128
	vaddpd zmm1,zmm1,zmm2
	add edi,128
	vaddpd zmm0,zmm0,zmm1

VectorProductD_AVX512_2:
	test edx,1
	jz short VectorProductD_AVX512_3

	vmovapd zmm1,ZMMWORD ptr[esi]
	vmulpd zmm1,zmm1,ZMMWORD ptr[edi]
	vaddpd zmm0,zmm0,zmm1

VectorProductD_AVX512_3:
	vextractf64x4 ymm2,zmm0,1

	vextractf128 xmm1,ymm0,1
	vextractf128 xmm3,ymm2,1

	vaddpd xmm0,xmm0,xmm1
	vaddpd xmm2,xmm2,xmm3

	vmovhlps xmm1,xmm1,xmm0
	vmovhlps xmm3,xmm3,xmm2

	mov edi,result

	vaddsd xmm0,xmm0,xmm1
	vaddsd xmm2,xmm2,xmm3

	vaddpd xmm0,xmm0,xmm2
	vmovsd qword ptr[edi],xmm0

	vzeroupper

	pop edi
	pop esi
	pop ebx

	ret

VectorProductD_AVX512 endp	


VectorAddF_AVX512 proc coeff_a:dword,coeff_b:dword,coeff_c:dword,lgth:word

    public VectorAddF_AVX512

	push ebx
	push esi
	push edi

	movzx edx,lgth
	mov esi,coeff_a
	mov ebx,coeff_b
	mov edi,coeff_c
	mov ecx,edx
	mov eax,256

	shr ecx,2
	jz short VectorAddF_AVX512_1

VectorAddF_AVX512_loop_1:
	vmovaps zmm0,ZMMWORD ptr[esi]
	vmovaps zmm1,ZMMWORD ptr[esi+64]
	vmovaps zmm2,ZMMWORD ptr[esi+128]
	vmovaps zmm3,ZMMWORD ptr[esi+192]

	vaddps zmm0,zmm0,ZMMWORD ptr[ebx]
	vaddps zmm1,zmm1,ZMMWORD ptr[ebx+64]
	vaddps zmm2,zmm2,ZMMWORD ptr[ebx+128]
	vaddps zmm3,zmm3,ZMMWORD ptr[ebx+192]

	vmovaps ZMMWORD ptr[edi],zmm0
	vmovaps ZMMWORD ptr[edi+64],zmm1
	vmovaps ZMMWORD ptr[edi+128],zmm2
	vmovaps ZMMWORD ptr[edi+192],zmm3

	add esi,eax
	add ebx,eax
	add edi,eax
	loop VectorAddF_AVX512_loop_1

VectorAddF_AVX512_1:
	test edx,2
	jz short VectorAddF_AVX512_2

	vmovaps zmm0,ZMMWORD ptr[esi]
	vmovaps zmm1,ZMMWORD ptr[esi+64]
	vaddps zmm0,zmm0,ZMMWORD ptr[ebx]
	vaddps zmm1,zmm1,ZMMWORD ptr[ebx+64]
	vmovaps ZMMWORD ptr[edi],zmm0
	vmovaps ZMMWORD ptr[edi+64],zmm1

	add esi,128
	add ebx,128
	add edi,128

VectorAddF_AVX512_2:
	test edx,1
	jz short VectorAddF_AVX512_3

	vmovaps zmm0,ZMMWORD ptr[esi]
	vaddps zmm0,zmm0,ZMMWORD ptr[ebx]
	vmovaps ZMMWORD ptr[edi],zmm0

VectorAddF_AVX512_3:
	vzeroupper

	pop edi
	pop esi
	pop ebx

	ret

VectorAddF_AVX512 endp	


VectorSubF_AVX512 proc coeff_a:dword,coeff_b:dword,coeff_c:dword,lgth:word

    public VectorSubF_AVX512

	push ebx
	push esi
	push edi

	movzx edx,lgth
	mov esi,coeff_a
	mov ebx,coeff_b
	mov edi,coeff_c
	mov ecx,edx
	mov eax,256

	shr ecx,2
	jz short VectorSubF_AVX512_1

VectorSubF_AVX512_loop_1:
	vmovaps zmm0,ZMMWORD ptr[esi]
	vmovaps zmm1,ZMMWORD ptr[esi+64]
	vmovaps zmm2,ZMMWORD ptr[esi+128]
	vmovaps zmm3,ZMMWORD ptr[esi+192]

	vsubps zmm0,zmm0,ZMMWORD ptr[ebx]
	vsubps zmm1,zmm1,ZMMWORD ptr[ebx+64]
	vsubps zmm2,zmm2,ZMMWORD ptr[ebx+128]
	vsubps zmm3,zmm3,ZMMWORD ptr[ebx+192]

	vmovaps ZMMWORD ptr[edi],zmm0
	vmovaps ZMMWORD ptr[edi+64],zmm1
	vmovaps ZMMWORD ptr[edi+128],zmm2
	vmovaps ZMMWORD ptr[edi+192],zmm3

	add esi,eax
	add ebx,eax
	add edi,eax
	loop VectorSubF_AVX512_loop_1

VectorSubF_AVX512_1:
	test edx,2
	jz short VectorSubF_AVX512_2

	vmovaps zmm0,ZMMWORD ptr[esi]
	vmovaps zmm1,ZMMWORD ptr[esi+64]
	vsubps zmm0,zmm0,ZMMWORD ptr[ebx]
	vsubps zmm1,zmm1,ZMMWORD ptr[ebx+64]
	vmovaps ZMMWORD ptr[edi],zmm0
	vmovaps ZMMWORD ptr[edi+64],zmm1

	add esi,128
	add ebx,128
	add edi,128

VectorSubF_AVX512_2:
	test edx,1
	jz short VectorSubF_AVX512_3

	vmovaps zmm0,ZMMWORD ptr[esi]
	vsubps zmm0,zmm0,ZMMWORD ptr[ebx]
	vmovaps ZMMWORD ptr[edi],zmm0

VectorSubF_AVX512_3:
	vzeroupper

	pop edi
	pop esi
	pop ebx

	ret

VectorSubF_AVX512 endp	


VectorProdF_AVX512 proc coeff_a:dword,coeff_b:dword,coeff_c:dword,lgth:word

    public VectorProdF_AVX512

	push ebx
	push esi
	push edi

	movzx edx,lgth
	mov esi,coeff_a
	mov ebx,coeff_b
	mov edi,coeff_c
	mov ecx,edx
	mov eax,256

	shr ecx,2
	jz short VectorProdF_AVX512_1

VectorProdF_AVX512_loop_1:
	vmovaps zmm0,ZMMWORD ptr[esi]
	vmovaps zmm1,ZMMWORD ptr[esi+64]
	vmovaps zmm2,ZMMWORD ptr[esi+128]
	vmovaps zmm3,ZMMWORD ptr[esi+192]

	vmulps zmm0,zmm0,ZMMWORD ptr[ebx]
	vmulps zmm1,zmm1,ZMMWORD ptr[ebx+64]
	vmulps zmm2,zmm2,ZMMWORD ptr[ebx+128]
	vmulps zmm3,zmm3,ZMMWORD ptr[ebx+192]

	vmovaps ZMMWORD ptr[edi],zmm0
	vmovaps ZMMWORD ptr[edi+64],zmm1
	vmovaps ZMMWORD ptr[edi+128],zmm2
	vmovaps ZMMWORD ptr[edi+192],zmm3

	add esi,eax
	add ebx,eax
	add edi,eax
	loop VectorProdF_AVX512_loop_1

VectorProdF_AVX512_1:
	test edx,2
	jz short VectorProdF_AVX512_2

	vmovaps zmm0,ZMMWORD ptr[esi]
	vmovaps zmm1,ZMMWORD ptr[esi+64]
	vmulps zmm0,zmm0,ZMMWORD ptr[ebx]
	vmulps zmm1,zmm1,ZMMWORD ptr[ebx+64]
	vmovaps ZMMWORD ptr[edi],zmm0
	vmovaps ZMMWORD ptr[edi+64],zmm1

	add esi,128
	add ebx,128
	add edi,128

VectorProdF_AVX512_2:
	test edx,1
	jz short VectorProdF_AVX512_3

	vmovaps zmm0,ZMMWORD ptr[esi]
	vmulps zmm0,zmm0,ZMMWORD ptr[ebx]
	vmovaps ZMMWORD ptr[edi],zmm0

VectorProdF_AVX512_3:
	vzeroupper

	pop edi
	pop esi
	pop ebx

	ret

VectorProdF_AVX512 endp


VectorAdd2F_AVX512 proc coeff_a:dword,coeff_b:dword,lgth:word

    public VectorAdd2F_AVX512

	push ebx
	push esi
	push edi

	movzx edx,lgth
	mov edi,coeff_a
	mov esi,coeff_b
	mov ecx,edx
	mov eax,256
	mov ebx,64

	shr ecx,2
	jz short VectorAdd2F_AVX512_1

VectorAdd2F_AVX512_loop_1:
	vmovaps zmm0,ZMMWORD ptr[edi]
	vmovaps zmm1,ZMMWORD ptr[edi+ebx]
	vmovaps zmm2,ZMMWORD ptr[edi+2*ebx]
	vmovaps zmm3,ZMMWORD ptr[edi+192]

	vaddps zmm0,zmm0,ZMMWORD ptr[esi]
	vaddps zmm1,zmm1,ZMMWORD ptr[esi+ebx]
	vaddps zmm2,zmm2,ZMMWORD ptr[esi+2*ebx]
	vaddps zmm3,zmm3,ZMMWORD ptr[esi+192]

	vmovaps ZMMWORD ptr[edi],zmm0
	vmovaps ZMMWORD ptr[edi+ebx],zmm1
	vmovaps ZMMWORD ptr[edi+2*ebx],zmm2
	vmovaps ZMMWORD ptr[edi+192],zmm3

	add esi,eax
	add edi,eax
	loop VectorAdd2F_AVX512_loop_1

VectorAdd2F_AVX512_1:
	test edx,2
	jz short VectorAdd2F_AVX512_2

	vmovaps zmm0,ZMMWORD ptr[edi]
	vmovaps zmm1,ZMMWORD ptr[edi+ebx]
	vaddps zmm0,zmm0,ZMMWORD ptr[esi]
	vaddps zmm1,zmm1,ZMMWORD ptr[esi+ebx]
	vmovaps ZMMWORD ptr[edi],zmm0
	vmovaps ZMMWORD ptr[edi+ebx],zmm1

	add esi,128
	add edi,128

VectorAdd2F_AVX512_2:
	test edx,1
	jz short VectorAdd2F_AVX512_3

	vmovaps zmm0,ZMMWORD ptr[edi]
	vaddps zmm0,zmm0,ZMMWORD ptr[esi]
	vmovaps ZMMWORD ptr[edi],zmm0

VectorAdd2F_AVX512_3:
	vzeroupper

	pop edi
	pop esi
	pop ebx

	ret

VectorAdd2F_AVX512 endp	


VectorSub2F_AVX512 proc coeff_a:dword,coeff_b:dword,lgth:word

    public VectorSub2F_AVX512

	push ebx
	push esi
	push edi

	movzx edx,lgth
	mov edi,coeff_a
	mov esi,coeff_b
	mov ecx,edx
	mov eax,256
	mov ebx,64

	shr ecx,2
	jz short VectorSub2F_AVX512_1

VectorSub2F_AVX512_loop_1:
	vmovaps zmm0,ZMMWORD ptr[edi]
	vmovaps zmm1,ZMMWORD ptr[edi+ebx]
	vmovaps zmm2,ZMMWORD ptr[edi+2*ebx]
	vmovaps zmm3,ZMMWORD ptr[edi+192]

	vsubps zmm0,zmm0,ZMMWORD ptr[esi]
	vsubps zmm1,zmm1,ZMMWORD ptr[esi+ebx]
	vsubps zmm2,zmm2,ZMMWORD ptr[esi+2*ebx]
	vsubps zmm3,zmm3,ZMMWORD ptr[esi+192]

	vmovaps ZMMWORD ptr[edi],zmm0
	vmovaps ZMMWORD ptr[edi+ebx],zmm1
	vmovaps ZMMWORD ptr[edi+2*ebx],zmm2
	vmovaps ZMMWORD ptr[edi+192],zmm3

	add esi,eax
	add edi,eax
	loop VectorSub2F_AVX512_loop_1

VectorSub2F_AVX512_1:
	test edx,2
	jz short VectorSub2F_AVX512_2

	vmovaps zmm0,ZMMWORD ptr[edi]
	vmovaps zmm1,ZMMWORD ptr[edi+ebx]
	vsubps zmm0,zmm0,ZMMWORD ptr[esi]
	vsubps zmm1,zmm1,ZMMWORD ptr[esi+ebx]
	vmovaps ZMMWORD ptr[edi],zmm0
	vmovaps ZMMWORD ptr[edi+ebx],zmm1

	add esi,128
	add edi,128

VectorSub2F_AVX512_2:
	test edx,1
	jz short VectorSub2F_AVX512_3

	vmovaps zmm0,ZMMWORD ptr[edi]
	vsubps zmm0,zmm0,ZMMWORD ptr[esi]
	vmovaps ZMMWORD ptr[edi],zmm0

VectorSub2F_AVX512_3:
	vzeroupper

	pop edi
	pop esi
	pop ebx

	ret

VectorSub2F_AVX512 endp


VectorInvSubF_AVX512 proc coeff_a:dword,coeff_b:dword,lgth:word

    public VectorInvSubF_AVX512

	push ebx
	push esi
	push edi

	movzx edx,lgth
	mov edi,coeff_a
	mov esi,coeff_b
	mov ecx,edx
	mov eax,256
	mov ebx,64

	shr ecx,2
	jz short VectorInvSubF_AVX512_1

VectorInvSubF_AVX512_loop_1:
	vmovaps zmm0,ZMMWORD ptr[esi]
	vmovaps zmm1,ZMMWORD ptr[esi+ebx]
	vmovaps zmm2,ZMMWORD ptr[esi+2*ebx]
	vmovaps zmm3,ZMMWORD ptr[esi+192]

	vsubps zmm0,zmm0,ZMMWORD ptr[edi]
	vsubps zmm1,zmm1,ZMMWORD ptr[edi+ebx]
	vsubps zmm2,zmm2,ZMMWORD ptr[edi+2*ebx]
	vsubps zmm3,zmm3,ZMMWORD ptr[edi+192]

	vmovaps ZMMWORD ptr[edi],zmm0
	vmovaps ZMMWORD ptr[edi+ebx],zmm1
	vmovaps ZMMWORD ptr[edi+2*ebx],zmm2
	vmovaps ZMMWORD ptr[edi+192],zmm3

	add esi,eax
	add edi,eax
	loop VectorInvSubF_AVX512_loop_1

VectorInvSubF_AVX512_1:
	test edx,2
	jz short VectorInvSubF_AVX512_2

	vmovaps zmm0,ZMMWORD ptr[esi]
	vmovaps zmm1,ZMMWORD ptr[esi+ebx]
	vsubps zmm0,zmm0,ZMMWORD ptr[edi]
	vsubps zmm1,zmm1,ZMMWORD ptr[edi+ebx]
	vmovaps ZMMWORD ptr[edi],zmm0
	vmovaps ZMMWORD ptr[edi+ebx],zmm1

	add esi,128
	add edi,128

VectorInvSubF_AVX512_2:
	test edx,1
	jz short VectorInvSubF_AVX512_3

	vmovaps zmm0,ZMMWORD ptr[esi]
	vsubps zmm0,zmm0,ZMMWORD ptr[edi]
	vmovaps ZMMWORD ptr[edi],zmm0

VectorInvSubF_AVX512_3:
	vzeroupper

	pop edi
	pop esi
	pop ebx

	ret

VectorInvSubF_AVX512 endp


VectorProd2F_AVX512 proc coeff_a:dword,coeff_b:dword,lgth:word

    public VectorProd2F_AVX512

	push ebx
	push esi
	push edi

	movzx edx,lgth
	mov edi,coeff_a
	mov esi,coeff_b
	mov ecx,edx
	mov eax,256
	mov ebx,64

	shr ecx,2
	jz short VectorProd2F_AVX512_1

VectorProd2F_AVX512_loop_1:
	vmovaps zmm0,ZMMWORD ptr[edi]
	vmovaps zmm1,ZMMWORD ptr[edi+ebx]
	vmovaps zmm2,ZMMWORD ptr[edi+2*ebx]
	vmovaps zmm3,ZMMWORD ptr[edi+192]

	vmulps zmm0,zmm0,ZMMWORD ptr[esi]
	vmulps zmm1,zmm1,ZMMWORD ptr[esi+ebx]
	vmulps zmm2,zmm2,ZMMWORD ptr[esi+2*ebx]
	vmulps zmm3,zmm3,ZMMWORD ptr[esi+192]

	vmovaps ZMMWORD ptr[edi],zmm0
	vmovaps ZMMWORD ptr[edi+ebx],zmm1
	vmovaps ZMMWORD ptr[edi+2*ebx],zmm2
	vmovaps ZMMWORD ptr[edi+192],zmm3

	add esi,eax
	add edi,eax
	loop VectorProd2F_AVX512_loop_1

VectorProd2F_AVX512_1:
	test edx,2
	jz short VectorProd2F_AVX512_2

	vmovaps zmm0,ZMMWORD ptr[edi]
	vmovaps zmm1,ZMMWORD ptr[edi+ebx]
	vmulps zmm0,zmm0,ZMMWORD ptr[esi]
	vmulps zmm1,zmm1,ZMMWORD ptr[esi+ebx]
	vmovaps ZMMWORD ptr[edi],zmm0
	vmovaps ZMMWORD ptr[edi+ebx],zmm1

	add esi,128
	add edi,128

VectorProd2F_AVX512_2:
	test edx,1
	jz short VectorProd2F_AVX512_3

	vmovaps zmm0,ZMMWORD ptr[edi]
	vmulps zmm0,zmm0,ZMMWORD ptr[esi]
	vmovaps ZMMWORD ptr[edi],zmm0

VectorProd2F_AVX512_3:
	vzeroupper

	pop edi
	pop esi
	pop ebx

	ret

VectorProd2F_AVX512 endp
		

VectorAddD_AVX512 proc coeff_a:dword,coeff_b:dword,coeff_c:dword,lgth:word

    public VectorAddD_AVX512

	push ebx
	push esi
	push edi

	movzx edx,lgth
	mov esi,coeff_a
	mov ebx,coeff_b
	mov edi,coeff_c
	mov ecx,edx
	mov eax,256

	shr ecx,2
	jz short VectorAddD_AVX512_1

VectorAddD_AVX512_loop_1:
	vmovapd zmm0,ZMMWORD ptr[esi]
	vmovapd zmm1,ZMMWORD ptr[esi+64]
	vmovapd zmm2,ZMMWORD ptr[esi+128]
	vmovapd zmm3,ZMMWORD ptr[esi+192]

	vaddpd zmm0,zmm0,ZMMWORD ptr[ebx]
	vaddpd zmm1,zmm1,ZMMWORD ptr[ebx+64]
	vaddpd zmm2,zmm2,ZMMWORD ptr[ebx+128]
	vaddpd zmm3,zmm3,ZMMWORD ptr[ebx+192]

	vmovapd ZMMWORD ptr[edi],zmm0
	vmovapd ZMMWORD ptr[edi+64],zmm1
	vmovapd ZMMWORD ptr[edi+128],zmm2
	vmovapd ZMMWORD ptr[edi+192],zmm3

	add esi,eax
	add ebx,eax
	add edi,eax
	loop VectorAddD_AVX512_loop_1

VectorAddD_AVX512_1:
	test edx,2
	jz short VectorAddD_AVX512_2

	vmovapd zmm0,ZMMWORD ptr[esi]
	vmovapd zmm1,ZMMWORD ptr[esi+64]
	vaddpd zmm0,zmm0,ZMMWORD ptr[ebx]
	vaddpd zmm1,zmm1,ZMMWORD ptr[ebx+64]
	vmovapd ZMMWORD ptr[edi],zmm0
	vmovapd ZMMWORD ptr[edi+64],zmm1

	add esi,128
	add ebx,128
	add edi,128

VectorAddD_AVX512_2:
	test edx,1
	jz short VectorAddD_AVX512_3

	vmovapd zmm0,ZMMWORD ptr[esi]
	vaddpd zmm0,zmm0,ZMMWORD ptr[ebx]
	vmovapd ZMMWORD ptr[edi],zmm0

VectorAddD_AVX512_3:
	vzeroupper

	pop edi
	pop esi
	pop ebx

	ret

VectorAddD_AVX512 endp	


VectorSubD_AVX512 proc coeff_a:dword,coeff_b:dword,coeff_c:dword,lgth:word

    public VectorSubD_AVX512

	push ebx
	push esi
	push edi

	movzx edx,lgth
	mov esi,coeff_a
	mov ebx,coeff_b
	mov edi,coeff_c
	mov ecx,edx
	mov eax,256

	shr ecx,2
	jz short VectorSubD_AVX512_1

VectorSubD_AVX512_loop_1:
	vmovapd zmm0,ZMMWORD ptr[esi]
	vmovapd zmm1,ZMMWORD ptr[esi+64]
	vmovapd zmm2,ZMMWORD ptr[esi+128]
	vmovapd zmm3,ZMMWORD ptr[esi+192]

	vsubpd zmm0,zmm0,ZMMWORD ptr[ebx]
	vsubpd zmm1,zmm1,ZMMWORD ptr[ebx+64]
	vsubpd zmm2,zmm2,ZMMWORD ptr[ebx+128]
	vsubpd zmm3,zmm3,ZMMWORD ptr[ebx+192]

	vmovapd ZMMWORD ptr[edi],zmm0
	vmovapd ZMMWORD ptr[edi+64],zmm1
	vmovapd ZMMWORD ptr[edi+128],zmm2
	vmovapd ZMMWORD ptr[edi+192],zmm3

	add esi,eax
	add ebx,eax
	add edi,eax
	loop VectorSubD_AVX512_loop_1

VectorSubD_AVX512_1:
	test edx,2
	jz short VectorSubD_AVX512_2

	vmovapd zmm0,ZMMWORD ptr[esi]
	vmovapd zmm1,ZMMWORD ptr[esi+64]
	vsubpd zmm0,zmm0,ZMMWORD ptr[ebx]
	vsubpd zmm1,zmm1,ZMMWORD ptr[ebx+64]
	vmovapd ZMMWORD ptr[edi],zmm0
	vmovapd ZMMWORD ptr[edi+64],zmm1

	add esi,128
	add ebx,128
	add edi,128

VectorSubD_AVX512_2:
	test edx,1
	jz short VectorSubD_AVX512_3

	vmovapd zmm0,ZMMWORD ptr[esi]
	vsubpd zmm0,zmm0,ZMMWORD ptr[ebx]
	vmovapd ZMMWORD ptr[edi],zmm0

VectorSubD_AVX512_3:
	vzeroupper

	pop edi
	pop esi
	pop ebx

	ret

VectorSubD_AVX512 endp	


VectorProdD_AVX512 proc coeff_a:dword,coeff_b:dword,coeff_c:dword,lgth:word

    public VectorProdD_AVX512

	push ebx
	push esi
	push edi

	movzx edx,lgth
	mov esi,coeff_a
	mov ebx,coeff_b
	mov edi,coeff_c
	mov ecx,edx
	mov eax,256

	shr ecx,2
	jz short VectorProdD_AVX512_1

VectorProdD_AVX512_loop_1:
	vmovapd zmm0,ZMMWORD ptr[esi]
	vmovapd zmm1,ZMMWORD ptr[esi+64]
	vmovapd zmm2,ZMMWORD ptr[esi+128]
	vmovapd zmm3,ZMMWORD ptr[esi+192]

	vmulpd zmm0,zmm0,ZMMWORD ptr[ebx]
	vmulpd zmm1,zmm1,ZMMWORD ptr[ebx+64]
	vmulpd zmm2,zmm2,ZMMWORD ptr[ebx+128]
	vmulpd zmm3,zmm3,ZMMWORD ptr[ebx+192]

	vmovapd ZMMWORD ptr[edi],zmm0
	vmovapd ZMMWORD ptr[edi+64],zmm1
	vmovapd ZMMWORD ptr[edi+128],zmm2
	vmovapd ZMMWORD ptr[edi+192],zmm3

	add esi,eax
	add ebx,eax
	add edi,eax
	loop VectorProdD_AVX512_loop_1

VectorProdD_AVX512_1:
	test edx,2
	jz short VectorProdD_AVX512_2

	vmovapd zmm0,ZMMWORD ptr[esi]
	vmovapd zmm1,ZMMWORD ptr[esi+64]
	vmulpd zmm0,zmm0,ZMMWORD ptr[ebx]
	vmulpd zmm1,zmm1,ZMMWORD ptr[ebx+64]
	vmovapd ZMMWORD ptr[edi],zmm0
	vmovapd ZMMWORD ptr[edi+64],zmm1

	add esi,128
	add ebx,128
	add edi,128

VectorProdD_AVX512_2:
	test edx,1
	jz short VectorProdD_AVX512_3

	vmovapd zmm0,ZMMWORD ptr[esi]
	vmulpd zmm0,zmm0,ZMMWORD ptr[ebx]
	vmovapd ZMMWORD ptr[edi],zmm0

VectorProdD_AVX512_3:
	vzeroupper

	pop edi
	pop esi
	pop ebx

	ret

VectorProdD_AVX512 endp


VectorAdd2D_AVX512 proc coeff_a:dword,coeff_b:dword,lgth:word

    public VectorAdd2D_AVX512

	push ebx
	push esi
	push edi

	movzx edx,lgth
	mov edi,coeff_a
	mov esi,coeff_b
	mov ecx,edx
	mov eax,256
	mov ebx,64

	shr ecx,2
	jz short VectorAdd2D_AVX512_1

VectorAdd2D_AVX512_loop_1:
	vmovapd zmm0,ZMMWORD ptr[edi]
	vmovapd zmm1,ZMMWORD ptr[edi+ebx]
	vmovapd zmm2,ZMMWORD ptr[edi+2*ebx]
	vmovapd zmm3,ZMMWORD ptr[edi+192]

	vaddpd zmm0,zmm0,ZMMWORD ptr[esi]
	vaddpd zmm1,zmm1,ZMMWORD ptr[esi+ebx]
	vaddpd zmm2,zmm2,ZMMWORD ptr[esi+2*ebx]
	vaddpd zmm3,zmm3,ZMMWORD ptr[esi+192]

	vmovapd ZMMWORD ptr[edi],zmm0
	vmovapd ZMMWORD ptr[edi+ebx],zmm1
	vmovapd ZMMWORD ptr[edi+2*ebx],zmm2
	vmovapd ZMMWORD ptr[edi+192],zmm3

	add esi,eax
	add edi,eax
	loop VectorAdd2D_AVX512_loop_1

VectorAdd2D_AVX512_1:
	test edx,2
	jz short VectorAdd2D_AVX512_2

	vmovapd zmm0,ZMMWORD ptr[edi]
	vmovapd zmm1,ZMMWORD ptr[edi+ebx]
	vaddpd zmm0,zmm0,ZMMWORD ptr[esi]
	vaddpd zmm1,zmm1,ZMMWORD ptr[esi+ebx]
	vmovapd ZMMWORD ptr[edi],zmm0
	vmovapd ZMMWORD ptr[edi+ebx],zmm1

	add esi,128
	add edi,128

VectorAdd2D_AVX512_2:
	test edx,1
	jz short VectorAdd2D_AVX512_3

	vmovapd zmm0,ZMMWORD ptr[edi]
	vaddpd zmm0,zmm0,ZMMWORD ptr[esi]
	vmovapd ZMMWORD ptr[edi],zmm0

VectorAdd2D_AVX512_3:
	vzeroupper

	pop edi
	pop esi
	pop ebx

	ret

VectorAdd2D_AVX512 endp	


VectorSub2D_AVX512 proc coeff_a:dword,coeff_b:dword,lgth:word

    public VectorSub2D_AVX512

	push ebx
	push esi
	push edi

	movzx edx,lgth
	mov edi,coeff_a
	mov esi,coeff_b
	mov ecx,edx
	mov eax,256
	mov ebx,64

	shr ecx,2
	jz short VectorSub2D_AVX512_1

VectorSub2D_AVX512_loop_1:
	vmovapd zmm0,ZMMWORD ptr[edi]
	vmovapd zmm1,ZMMWORD ptr[edi+ebx]
	vmovapd zmm2,ZMMWORD ptr[edi+2*ebx]
	vmovapd zmm3,ZMMWORD ptr[edi+192]

	vsubpd zmm0,zmm0,ZMMWORD ptr[esi]
	vsubpd zmm1,zmm1,ZMMWORD ptr[esi+ebx]
	vsubpd zmm2,zmm2,ZMMWORD ptr[esi+2*ebx]
	vsubpd zmm3,zmm3,ZMMWORD ptr[esi+192]

	vmovapd ZMMWORD ptr[edi],zmm0
	vmovapd ZMMWORD ptr[edi+ebx],zmm1
	vmovapd ZMMWORD ptr[edi+2*ebx],zmm2
	vmovapd ZMMWORD ptr[edi+192],zmm3

	add esi,eax
	add edi,eax
	loop VectorSub2D_AVX512_loop_1

VectorSub2D_AVX512_1:
	test edx,2
	jz short VectorSub2D_AVX512_2

	vmovapd zmm0,ZMMWORD ptr[edi]
	vmovapd zmm1,ZMMWORD ptr[edi+ebx]
	vsubpd zmm0,zmm0,ZMMWORD ptr[esi]
	vsubpd zmm1,zmm1,ZMMWORD ptr[esi+ebx]
	vmovapd ZMMWORD ptr[edi],zmm0
	vmovapd ZMMWORD ptr[edi+ebx],zmm1

	add esi,128
	add edi,128

VectorSub2D_AVX512_2:
	test edx,1
	jz short VectorSub2D_AVX512_3

	vmovapd zmm0,ZMMWORD ptr[edi]
	vsubpd zmm0,zmm0,ZMMWORD ptr[esi]
	vmovapd ZMMWORD ptr[edi],zmm0

VectorSub2D_AVX512_3:
	vzeroupper

	pop edi
	pop esi
	pop ebx

	ret

VectorSub2D_AVX512 endp


VectorInvSubD_AVX512 proc coeff_a:dword,coeff_b:dword,lgth:word

    public VectorInvSubD_AVX512

	push ebx
	push esi
	push edi

	movzx edx,lgth
	mov edi,coeff_a
	mov esi,coeff_b
	mov ecx,edx
	mov eax,256
	mov ebx,64

	shr ecx,2
	jz short VectorInvSubD_AVX512_1

VectorInvSubD_AVX512_loop_1:
	vmovapd zmm0,ZMMWORD ptr[esi]
	vmovapd zmm1,ZMMWORD ptr[esi+ebx]
	vmovapd zmm2,ZMMWORD ptr[esi+2*ebx]
	vmovapd zmm3,ZMMWORD ptr[esi+192]

	vsubpd zmm0,zmm0,ZMMWORD ptr[edi]
	vsubpd zmm1,zmm1,ZMMWORD ptr[edi+ebx]
	vsubpd zmm2,zmm2,ZMMWORD ptr[edi+2*ebx]
	vsubpd zmm3,zmm3,ZMMWORD ptr[edi+192]

	vmovapd ZMMWORD ptr[edi],zmm0
	vmovapd ZMMWORD ptr[edi+ebx],zmm1
	vmovapd ZMMWORD ptr[edi+2*ebx],zmm2
	vmovapd ZMMWORD ptr[edi+192],zmm3

	add esi,eax
	add edi,eax
	loop VectorInvSubD_AVX512_loop_1

VectorInvSubD_AVX512_1:
	test edx,2
	jz short VectorInvSubD_AVX512_2

	vmovapd zmm0,ZMMWORD ptr[esi]
	vmovapd zmm1,ZMMWORD ptr[esi+ebx]
	vsubpd zmm0,zmm0,ZMMWORD ptr[edi]
	vsubpd zmm1,zmm1,ZMMWORD ptr[edi+ebx]
	vmovapd ZMMWORD ptr[edi],zmm0
	vmovapd ZMMWORD ptr[edi+ebx],zmm1

	add esi,128
	add edi,128

VectorInvSubD_AVX512_2:
	test edx,1
	jz short VectorInvSubD_AVX512_3

	vmovapd zmm0,ZMMWORD ptr[esi]
	vsubpd zmm0,zmm0,ZMMWORD ptr[edi]
	vmovapd ZMMWORD ptr[edi],zmm0

VectorInvSubD_AVX512_3:
	vzeroupper

	pop edi
	pop esi
	pop ebx

	ret

VectorInvSubD_AVX512 endp


VectorProd2D_AVX512 proc coeff_a:dword,coeff_b:dword,lgth:word

    public VectorProd2D_AVX512

	push ebx
	push esi
	push edi

	movzx edx,lgth
	mov edi,coeff_a
	mov esi,coeff_b
	mov ecx,edx
	mov eax,256
	mov ebx,64

	shr ecx,2
	jz short VectorProd2D_AVX512_1

VectorProd2D_AVX512_loop_1:
	vmovapd zmm0,ZMMWORD ptr[edi]
	vmovapd zmm1,ZMMWORD ptr[edi+ebx]
	vmovapd zmm2,ZMMWORD ptr[edi+2*ebx]
	vmovapd zmm3,ZMMWORD ptr[edi+192]

	vmulpd zmm0,zmm0,ZMMWORD ptr[esi]
	vmulpd zmm1,zmm1,ZMMWORD ptr[esi+ebx]
	vmulpd zmm2,zmm2,ZMMWORD ptr[esi+2*ebx]
	vmulpd zmm3,zmm3,ZMMWORD ptr[esi+192]

	vmovapd ZMMWORD ptr[edi],zmm0
	vmovapd ZMMWORD ptr[edi+ebx],zmm1
	vmovapd ZMMWORD ptr[edi+2*ebx],zmm2
	vmovapd ZMMWORD ptr[edi+192],zmm3

	add esi,eax
	add edi,eax
	loop VectorProd2D_AVX512_loop_1

VectorProd2D_AVX512_1:
	test edx,2
	jz short VectorProd2D_AVX512_2

	vmovapd zmm0,ZMMWORD ptr[edi]
	vmovapd zmm1,ZMMWORD ptr[edi+ebx]
	vmulpd zmm0,zmm0,ZMMWORD ptr[esi]
	vmulpd zmm1,zmm1,ZMMWORD ptr[esi+ebx]
	vmovapd ZMMWORD ptr[edi],zmm0
	vmovapd ZMMWORD ptr[edi+ebx],zmm1

	add esi,128
	add edi,128

VectorProd2D_AVX512_2:
	test edx,1
	jz short VectorProd2D_AVX512_3

	vmovapd zmm0,ZMMWORD ptr[edi]
	vmulpd zmm0,zmm0,ZMMWORD ptr[esi]
	vmovapd ZMMWORD ptr[edi],zmm0

VectorProd2D_AVX512_3:
	vzeroupper

	pop edi
	pop esi
	pop ebx

	ret

VectorProd2D_AVX512 endp

end