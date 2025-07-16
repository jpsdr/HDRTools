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
	
	mov edx,coeff_a
	
	vbroadcastss zmm0,dword ptr[edx]
	
	mov ebx,coeff_b
	mov edx,coeff_c
	mov eax,64
	movzx ecx,lgth
	
CoeffProductF_AVX512_1:	
	vmulps zmm1,zmm0,ZMMWORD ptr[ebx]
	add ebx,eax
	vmovaps ZMMWORD ptr[edx],zmm1
	add edx,eax
	loop CoeffProductF_AVX512_1
	
	vzeroupper
	
	pop ebx
	
	ret
	
CoeffProductF_AVX512 endp
	

CoeffProduct2F_AVX512 proc coeff_a:dword,coeff_b:dword,lgth:word

    public CoeffProduct2F_AVX512
	
	mov edx,coeff_a
	
	vbroadcastss zmm0,dword ptr[edx]
	
	mov edx,coeff_b
	mov eax,64
	movzx ecx,lgth
	
CoeffProduct2F_AVX512_1:	
	vmulps zmm1,zmm0,ZMMWORD ptr[edx]
	vmovaps ZMMWORD ptr[edx],zmm1
	add edx,eax
	loop CoeffProduct2F_AVX512_1
	
	vzeroupper

	ret
	
CoeffProduct2F_AVX512 endp


CoeffProductD_AVX512 proc coeff_a:dword,coeff_b:dword,coeff_c:dword,lgth:word

    public CoeffProductD_AVX512
	
	push ebx
	
	mov edx,coeff_a
	
	vbroadcastsd zmm0,qword ptr[edx]
	
	mov ebx,coeff_b
	mov edx,coeff_c
	mov eax,64
	movzx ecx,lgth
	
CoeffProductD_AVX512_1:	
	vmulpd zmm1,zmm0,ZMMWORD ptr[ebx]
	add ebx,eax
	vmovapd ZMMWORD ptr[edx],zmm1
	add edx,eax
	loop CoeffProductD_AVX512_1
	
	vzeroupper
	
	pop ebx
	
	ret
	
CoeffProductD_AVX512 endp	


CoeffProduct2D_AVX512 proc coeff_a:dword,coeff_b:dword,lgth:word

    public CoeffProduct2D_AVX512
	
	mov edx,coeff_a
	
	vbroadcastsd zmm0,qword ptr[edx]
	
	mov edx,coeff_b
	mov eax,64
	movzx ecx,lgth
	
CoeffProduct2D_AVX512_1:	
	vmulpd zmm1,zmm0,ZMMWORD ptr[edx]
	vmovapd ZMMWORD ptr[edx],zmm1
	add edx,eax
	loop CoeffProduct2D_AVX512_1
	
	vzeroupper
	
	ret
	
CoeffProduct2D_AVX512 endp	


CoeffAddProductF_AVX512 proc coeff_a:dword,coeff_b:dword,coeff_c:dword,lgth:word

    public CoeffAddProductF_AVX512
	
	push ebx
	
	mov edx,coeff_a
	
	vbroadcastss zmm0,dword ptr[edx]
	
	mov ebx,coeff_b
	mov edx,coeff_c
	mov eax,64
	movzx ecx,lgth
	
CoeffAddProductF_AVX512_1:	
	vmulps zmm1,zmm0,ZMMWORD ptr[ebx]
	add ebx,eax
	vaddps zmm2,zmm1,ZMMWORD ptr[edx]
	vmovaps ZMMWORD ptr[edx],zmm2
	add edx,eax
	loop CoeffAddProductF_AVX512_1
	
	vzeroupper
	
	pop ebx
	
	ret
	
CoeffAddProductF_AVX512 endp	


CoeffAddProductD_AVX512 proc coeff_a:dword,coeff_b:dword,coeff_c:dword,lgth:word

    public CoeffAddProductD_AVX512
	
	push ebx
	
	mov edx,coeff_a
	
	vbroadcastsd zmm0,qword ptr[edx]
	
	mov ebx,coeff_b
	mov edx,coeff_c
	mov eax,64
	movzx ecx,lgth
	
CoeffAddProductD_AVX512_1:	
	vmulpd zmm1,zmm0,ZMMWORD ptr[ebx]
	add ebx,eax
	vaddpd zmm2,zmm1,ZMMWORD ptr[edx]
	vmovapd ZMMWORD ptr[edx],zmm2
	add edx,eax
	loop CoeffAddProductD_AVX512_1
	
	vzeroupper
	
	pop ebx
	
	ret
	
CoeffAddProductD_AVX512 endp	


CoeffAddF_AVX512 proc coeff_a:dword,coeff_b:dword,coeff_c:dword,lgth:word

    public CoeffAddF_AVX512
	
	push ebx
	
	mov edx,coeff_a
	
	vbroadcastss zmm0,dword ptr[edx]
	
	mov ebx,coeff_b
	mov edx,coeff_c
	mov eax,64
	movzx ecx,lgth
	
CoeffAddF_AVX512_1:	
	vaddps zmm1,zmm0,ZMMWORD ptr[ebx]
	add ebx,eax
	vmovaps ZMMWORD ptr[edx],zmm1
	add edx,eax
	loop CoeffAddF_AVX512_1
	
	vzeroupper
	
	pop ebx
	
	ret
	
CoeffAddF_AVX512 endp
	

CoeffAdd2F_AVX512 proc coeff_a:dword,coeff_b:dword,lgth:word

    public CoeffAdd2F_AVX512
	
	mov edx,coeff_a
	
	vbroadcastss zmm0,dword ptr[edx]
	
	mov edx,coeff_b
	mov eax,64
	movzx ecx,lgth
	
CoeffAdd2F_AVX512_1:	
	vaddps zmm1,zmm0,ZMMWORD ptr[edx]
	vmovaps ZMMWORD ptr[edx],zmm1
	add edx,eax
	loop CoeffAdd2F_AVX512_1
	
	vzeroupper

	ret
	
CoeffAdd2F_AVX512 endp


CoeffAddD_AVX512 proc coeff_a:dword,coeff_b:dword,coeff_c:dword,lgth:word

    public CoeffAddD_AVX512
	
	push ebx
	
	mov edx,coeff_a
	
	vbroadcastsd zmm0,qword ptr[edx]
	
	mov ebx,coeff_b
	mov edx,coeff_c
	mov eax,64
	movzx ecx,lgth
	
CoeffAddD_AVX512_1:	
	vaddpd zmm1,zmm0,ZMMWORD ptr[ebx]
	add ebx,eax
	vmovapd ZMMWORD ptr[edx],zmm1
	add edx,eax
	loop CoeffAddD_AVX512_1
	
	vzeroupper
	
	pop ebx
	
	ret
	
CoeffAddD_AVX512 endp	


CoeffAdd2D_AVX512 proc coeff_a:dword,coeff_b:dword,lgth:word

    public CoeffAdd2D_AVX512
	
	mov edx,coeff_a
	
	vbroadcastsd zmm0,qword ptr[edx]
	
	mov edx,coeff_b
	mov eax,64
	movzx ecx,lgth
	
CoeffAdd2D_AVX512_1:	
	vaddpd zmm1,zmm0,ZMMWORD ptr[edx]
	vmovapd ZMMWORD ptr[edx],zmm1
	add edx,eax
	loop CoeffAdd2D_AVX512_1
	
	vzeroupper
	
	ret
	
CoeffAdd2D_AVX512 endp


CoeffSubF_AVX512 proc coeff_a:dword,coeff_b:dword,coeff_c:dword,lgth:word

    public CoeffSubF_AVX512
	
	push ebx
	
	mov edx,coeff_a
	
	vbroadcastss zmm0,dword ptr[edx]
	
	mov ebx,coeff_b
	mov edx,coeff_c
	mov eax,64
	movzx ecx,lgth
	
CoeffSubF_AVX512_1:	
	vsubps zmm1,zmm0,ZMMWORD ptr[ebx]
	add ebx,eax
	vmovaps ZMMWORD ptr[edx],zmm1
	add edx,eax
	loop CoeffSubF_AVX512_1
	
	vzeroupper
	
	pop ebx
	
	ret
	
CoeffSubF_AVX512 endp
	

CoeffSub2F_AVX512 proc coeff_a:dword,coeff_b:dword,lgth:word

    public CoeffSub2F_AVX512
	
	mov edx,coeff_a
	
	vbroadcastss zmm0,dword ptr[edx]
	
	mov edx,coeff_b
	mov eax,64
	movzx ecx,lgth
	
CoeffSub2F_AVX512_1:	
	vsubps zmm1,zmm0,ZMMWORD ptr[edx]
	vmovaps ZMMWORD ptr[edx],zmm1
	add edx,eax
	loop CoeffSub2F_AVX512_1
	
	vzeroupper

	ret
	
CoeffSub2F_AVX512 endp


CoeffSubD_AVX512 proc coeff_a:dword,coeff_b:dword,coeff_c:dword,lgth:word

    public CoeffSubD_AVX512
	
	push ebx
	
	mov edx,coeff_a
	
	vbroadcastsd zmm0,qword ptr[edx]
	
	mov ebx,coeff_b
	mov edx,coeff_c
	mov eax,64
	movzx ecx,lgth
	
CoeffSubD_AVX_1:	
	vsubpd zmm1,zmm0,ZMMWORD ptr[ebx]
	add ebx,eax
	vmovapd ZMMWORD ptr[edx],zmm1
	add edx,eax
	loop CoeffSubD_AVX_1
	
	vzeroupper
	
	pop ebx
	
	ret
	
CoeffSubD_AVX512 endp	


CoeffSub2D_AVX512 proc coeff_a:dword,coeff_b:dword,lgth:word

    public CoeffSub2D_AVX512
	
	mov edx,coeff_a
	
	vbroadcastsd zmm0,qword ptr[edx]
	
	mov edx,coeff_b
	mov eax,64
	movzx ecx,lgth
	
CoeffSub2D_AVX512_1:	
	vsubpd zmm1,zmm0,ZMMWORD ptr[edx]
	vmovapd ZMMWORD ptr[edx],zmm1
	add edx,eax
	loop CoeffSub2D_AVX512_1
	
	vzeroupper
	
	ret
	
CoeffSub2D_AVX512 endp


VectorNorme2F_AVX512 proc coeff_x:dword,result:dword,lgth:word

    public VectorNorme2F_AVX512
	
	mov eax,64
	mov edx,coeff_x
		
	vxorps zmm0,zmm0,zmm0
	movzx ecx,lgth
		
VectorNorme2F_AVX512_1:
	vmovaps zmm1,ZMMWORD ptr[edx]
	vmulps zmm1,zmm1,zmm1
	add edx,eax
	vaddps zmm0,zmm0,zmm1
	loop VectorNorme2F_AVX512_1
	
	vextractf32x8 ymm2,zmm0,1

	vextractf128 xmm1,ymm0,1
	vextractf128 xmm3,ymm2,1
	
	vaddps xmm0,xmm0,xmm1
	vaddps xmm2,xmm2,xmm3
		
	vmovhlps xmm1,xmm1,xmm0
	vmovhlps xmm3,xmm3,xmm2
	
	vaddps xmm0,xmm0,xmm1
	vaddps xmm2,xmm2,xmm3
	
	mov edx,result

	vpsrldq xmm1,xmm0,4
	vpsrldq xmm3,xmm2,4

	vaddss xmm0,xmm0,xmm1
	vaddss xmm2,xmm2,xmm3

	vaddps xmm0,xmm0,xmm2
	vsqrtss xmm0,xmm0,xmm0
	vmovss dword ptr[edx],xmm0
	
	vzeroupper
	
	ret
		
VectorNorme2F_AVX512 endp


VectorNorme2D_AVX512 proc coeff_x:dword,result:dword,lgth:word

    public VectorNorme2D_AVX512
	
	mov eax,64
	mov edx,coeff_x
		
	vxorpd zmm0,zmm0,zmm0
	movzx ecx,lgth
		
VectorNorme2D_AVX512_1:
	vmovapd zmm1,ZMMWORD ptr[edx]
	vmulpd zmm1,zmm1,zmm1
	add edx,eax
	vaddpd zmm0,zmm0,zmm1
	loop VectorNorme2D_AVX512_1

	vextractf64x4 ymm2,zmm0,1
	
	vextractf128 xmm1,ymm0,1
	vextractf128 xmm3,ymm2,1

	vaddpd xmm0,xmm0,xmm1
	vaddpd xmm2,xmm2,xmm3
		
	vmovhlps xmm1,xmm1,xmm0
	vmovhlps xmm3,xmm3,xmm2

	mov edx,result

	vaddsd xmm0,xmm0,xmm1
	vaddsd xmm2,xmm2,xmm3

	vaddpd xmm0,xmm0,xmm2
	vsqrtsd xmm0,xmm0,xmm0
	vmovsd qword ptr[edx],xmm0
		
	vzeroupper	
		
	ret
		
VectorNorme2D_AVX512 endp


VectorDist2F_AVX512 proc coeff_x:dword,coeff_y:dword,result:dword,lgth:word

    public VectorDist2F_AVX512
	
	push ebx
		
	mov eax,64
	mov ebx,coeff_x
	mov edx,coeff_y
		
	vxorps zmm0,zmm0,zmm0
		
	movzx ecx,lgth
		
VectorDist2F_AVX512_1:
	vmovaps zmm1,ZMMWORD ptr[ebx]
	vsubps zmm1,zmm1,ZMMWORD ptr[edx]
	add ebx,eax
	vmulps zmm1,zmm1,zmm1
	add edx,eax
	vaddps zmm0,zmm0,zmm1
	loop VectorDist2F_AVX512_1

	vextractf32x8 ymm2,zmm0,1
		
	vextractf128 xmm1,ymm0,1
	vextractf128 xmm3,ymm2,1

	vaddps xmm0,xmm0,xmm1
	vaddps xmm2,xmm2,xmm3
		
	vmovhlps xmm1,xmm1,xmm0
	vmovhlps xmm3,xmm3,xmm2

	vaddps xmm0,xmm0,xmm1
	vaddps xmm2,xmm2,xmm3

	mov edx,result

	vpsrldq xmm1,xmm0,4
	vpsrldq xmm3,xmm2,4

	vaddss xmm0,xmm0,xmm1
	vaddss xmm2,xmm2,xmm3

	vaddps xmm0,xmm0,xmm2
	vsqrtss xmm0,xmm0,xmm0
	vmovss dword ptr[edx],xmm0
		
	vzeroupper
		
	pop ebx
		
	ret
		
VectorDist2F_AVX512 endp	


VectorDist2D_AVX512 proc coeff_x:dword,coeff_y:dword,result:dword,lgth:word

    public VectorDist2D_AVX512
	
	push ebx
		
	mov eax,64
	mov ebx,coeff_x
	mov edx,coeff_y
		
	vxorpd zmm0,zmm0,zmm0
		
	movzx ecx,lgth
		
VectorDist2D_AVX512_1:
	vmovapd zmm1,ZMMWORD ptr[ebx]
	vsubpd zmm1,zmm1,ZMMWORD ptr[edx]
	add ebx,eax
	vmulpd zmm1,zmm1,zmm1
	add edx,eax
	vaddpd zmm0,zmm0,zmm1
	loop VectorDist2D_AVX512_1

	vextractf64x4 ymm2,zmm0,1

	vextractf128 xmm1,ymm0,1
	vextractf128 xmm3,ymm2,1

	vaddpd xmm0,xmm0,xmm1
	vaddpd xmm2,xmm2,xmm3
		
	vmovhlps xmm1,xmm1,xmm0
	vmovhlps xmm3,xmm3,xmm2

	mov edx,result

	vaddsd xmm0,xmm0,xmm1
	vaddsd xmm2,xmm2,xmm3

	vaddpd xmm0,xmm0,xmm2
	vsqrtsd xmm0,xmm0,xmm0
	vmovsd qword ptr[edx],xmm0
		
	vzeroupper
		
	pop ebx
		
	ret
		
VectorDist2D_AVX512 endp	


VectorNormeF_AVX512 proc coeff_x:dword,result:dword,lgth:word

    public VectorNormeF_AVX512
	
	mov eax,64
	mov edx,coeff_x
		
	vxorps zmm0,zmm0,zmm0
	movzx ecx,lgth
		
VectorNormeF_AVX512_1:
	vmovaps zmm1,ZMMWORD ptr[edx]
	vmulps zmm1,zmm1,zmm1
	add edx,eax
	vaddps zmm0,zmm0,zmm1
	loop VectorNormeF_AVX512_1

	vextractf32x8 ymm2,zmm0,1
	
	vextractf128 xmm1,ymm0,1
	vextractf128 xmm3,ymm2,1

	vaddps xmm0,xmm0,xmm1
	vaddps xmm2,xmm2,xmm3

	vmovhlps xmm1,xmm1,xmm0
	vmovhlps xmm3,xmm3,xmm2

	vaddps xmm0,xmm0,xmm1
	vaddps xmm2,xmm2,xmm3

	mov edx,result

	vpsrldq xmm1,xmm0,4
	vpsrldq xmm3,xmm2,4

	vaddss xmm0,xmm0,xmm1
	vaddss xmm2,xmm2,xmm3

	vaddps xmm0,xmm0,xmm2
	vmovss dword ptr[edx],xmm0
	
	vzeroupper
	
	ret
		
VectorNormeF_AVX512 endp


VectorNormeD_AVX512 proc coeff_x:dword,result:dword,lgth:word

    public VectorNormeD_AVX512
	
	mov eax,64
	mov edx,coeff_x
		
	vxorpd zmm0,zmm0,zmm0
	movzx ecx,lgth
		
VectorNormeD_AVX512_1:
	vmovapd zmm1,ZMMWORD ptr[edx]
	vmulpd zmm1,zmm1,zmm1
	add edx,eax
	vaddpd zmm0,zmm0,zmm1
	loop VectorNormeD_AVX512_1

	vextractf64x4 ymm2,zmm0,1
	
	vextractf128 xmm1,ymm0,1
	vextractf128 xmm3,ymm2,1

	vaddpd xmm0,xmm0,xmm1
	vaddpd xmm2,xmm2,xmm3

	vmovhlps xmm1,xmm1,xmm0
	vmovhlps xmm3,xmm3,xmm2

	mov edx,result

	vaddsd xmm0,xmm0,xmm1
	vaddsd xmm2,xmm2,xmm3

	vaddpd xmm0,xmm0,xmm2
	vmovsd qword ptr[edx],xmm0
		
	vzeroupper	
		
	ret
		
VectorNormeD_AVX512 endp


VectorDistF_AVX512 proc coeff_x:dword,coeff_y:dword,result:dword,lgth:word

    public VectorDistF_AVX512
	
	push ebx
		
	mov eax,64
	mov ebx,coeff_x
	mov edx,coeff_y
		
	vxorps zmm0,zmm0,zmm0
		
	movzx ecx,lgth
		
VectorDistF_AVX512_1:
	vmovaps zmm1,ZMMWORD ptr[ebx]
	vsubps zmm1,zmm1,ZMMWORD ptr[edx]
	add ebx,eax
	vmulps zmm1,zmm1,zmm1
	add edx,eax
	vaddps zmm0,zmm0,zmm1
	loop VectorDistF_AVX512_1
		
	vextractf32x8 ymm2,zmm0,1

	vextractf128 xmm1,ymm0,1
	vextractf128 xmm3,ymm2,1

	vaddps xmm0,xmm0,xmm1
	vaddps xmm2,xmm2,xmm3
		
	vmovhlps xmm1,xmm1,xmm0
	vmovhlps xmm3,xmm3,xmm2

	vaddps xmm0,xmm0,xmm1
	vaddps xmm2,xmm2,xmm3

	mov edx,result

	vpsrldq xmm1,xmm0,4
	vpsrldq xmm3,xmm2,4

	vaddss xmm0,xmm0,xmm1
	vaddss xmm2,xmm2,xmm3

	vaddps xmm0,xmm0,xmm2
	vmovss dword ptr[edx],xmm0
		
	vzeroupper
		
	pop ebx
		
	ret
		
VectorDistF_AVX512 endp	


VectorDistD_AVX512 proc coeff_x:dword,coeff_y:dword,result:dword,lgth:word

    public VectorDistD_AVX512
	
	push ebx
		
	mov eax,64
	mov ebx,coeff_x
	mov edx,coeff_y
		
	vxorpd zmm0,zmm0,zmm0
		
	movzx ecx,lgth
		
VectorDistD_AVX512_1:
	vmovapd zmm1,ZMMWORD ptr[ebx]
	vsubpd zmm1,zmm1,ZMMWORD ptr[edx]
	add ebx,eax
	vmulpd zmm1,zmm1,zmm1
	add edx,eax
	vaddpd zmm0,zmm0,zmm1
	loop VectorDistD_AVX512_1

	vextractf64x4 ymm2,zmm0,1

	vextractf128 xmm1,ymm0,1
	vextractf128 xmm3,ymm2,1

	vaddpd xmm0,xmm0,xmm1
	vaddpd xmm2,xmm2,xmm3
		
	vmovhlps xmm1,xmm1,xmm0
	vmovhlps xmm3,xmm3,xmm2

	mov edx,result

	vaddsd xmm0,xmm0,xmm1
	vaddsd xmm2,xmm2,xmm3

	vaddpd xmm0,xmm0,xmm2
	vmovsd qword ptr[edx],xmm0
		
	vzeroupper
		
	pop ebx
		
	ret
		
VectorDistD_AVX512 endp


VectorNorme1F_AVX512 proc coeff_x:dword,result:dword,lgth:word

    public VectorNorme1F_AVX512
	
	mov eax,64
	mov edx,coeff_x
		
	vxorps zmm0,zmm0,zmm0
	vmovaps zmm2,ZMMWORD ptr sign_bits_f_32
	movzx ecx,lgth
		
VectorNorme1F_AVX512_1:
	vandps zmm1,zmm2,ZMMWORD ptr[edx]
	add edx,eax
	vaddps zmm0,zmm0,zmm1
	loop VectorNorme1F_AVX512_1

	vextractf32x8 ymm2,zmm0,1
	
	vextractf128 xmm1,ymm0,1
	vextractf128 xmm3,ymm2,1

	vaddps xmm0,xmm0,xmm1
	vaddps xmm2,xmm2,xmm3
		
	vmovhlps xmm1,xmm1,xmm0
	vmovhlps xmm3,xmm3,xmm2

	vaddps xmm0,xmm0,xmm1
	vaddps xmm2,xmm2,xmm3

	mov edx,result

	vpsrldq xmm1,xmm0,4
	vpsrldq xmm3,xmm2,4

	vaddss xmm0,xmm0,xmm1
	vaddss xmm2,xmm2,xmm3

	vaddps xmm0,xmm0,xmm2
	vmovss dword ptr[edx],xmm0
	
	vzeroupper
	
	ret
		
VectorNorme1F_AVX512 endp


VectorNorme1D_AVX512 proc coeff_x:dword,result:dword,lgth:word

    public VectorNorme1D_AVX512
	
	mov eax,64
	mov edx,coeff_x
		
	vxorpd zmm0,zmm0,zmm0
	vmovapd zmm2,ZMMWORD ptr sign_bits_f_64
	movzx ecx,lgth
		
VectorNorme1D_AVX512_1:
	vandpd zmm1,zmm2,ZMMWORD ptr[edx]
	add edx,eax
	vaddpd zmm0,zmm0,zmm1
	loop VectorNorme1D_AVX512_1

	vextractf64x4 ymm2,zmm0,1

	vextractf128 xmm1,ymm0,1
	vextractf128 xmm3,ymm2,1

	vaddpd xmm0,xmm0,xmm1
	vaddpd xmm2,xmm2,xmm3
		
	vmovhlps xmm1,xmm1,xmm0
	vmovhlps xmm3,xmm3,xmm2

	mov edx,result

	vaddsd xmm0,xmm0,xmm1
	vaddsd xmm2,xmm2,xmm3

	vaddpd xmm0,xmm0,xmm2
	vmovsd qword ptr[edx],xmm0
		
	vzeroupper	
		
	ret
		
VectorNorme1D_AVX512 endp


VectorDist1F_AVX512 proc coeff_x:dword,coeff_y:dword,result:dword,lgth:word

    public VectorDist1F_AVX512
	
	push ebx
		
	mov eax,64
	mov ebx,coeff_x
	mov edx,coeff_y
		
	vxorps zmm0,zmm0,zmm0
	vmovaps zmm2,ZMMWORD ptr sign_bits_f_32
		
	movzx ecx,lgth
		
VectorDist1F_AVX512_1:
	vmovaps zmm1,ZMMWORD ptr[ebx]
	vsubps zmm1,zmm1,ZMMWORD ptr[edx]
	add ebx,eax
	vandps zmm1,zmm1,zmm2
	add edx,eax
	vaddps zmm0,zmm0,zmm1
	loop VectorDist1F_AVX512_1
		
	vextractf32x8 ymm2,zmm0,1

	vextractf128 xmm1,ymm0,1
	vextractf128 xmm3,ymm2,1

	vaddps xmm0,xmm0,xmm1
	vaddps xmm2,xmm2,xmm3
		
	vmovhlps xmm1,xmm1,xmm0
	vmovhlps xmm3,xmm3,xmm2

	vaddps xmm0,xmm0,xmm1
	vaddps xmm2,xmm2,xmm3

	mov edx,result

	vpsrldq xmm1,xmm0,4
	vpsrldq xmm3,xmm2,4

	vaddss xmm0,xmm0,xmm1
	vaddss xmm2,xmm2,xmm3

	vaddps xmm0,xmm0,xmm2
	vmovss dword ptr[edx],xmm0
		
	vzeroupper
		
	pop ebx
		
	ret
		
VectorDist1F_AVX512 endp	


VectorDist1D_AVX512 proc coeff_x:dword,coeff_y:dword,result:dword,lgth:word

    public VectorDist1D_AVX512
	
	push ebx
		
	mov eax,64
	mov ebx,coeff_x
	mov edx,coeff_y
		
	vxorpd zmm0,zmm0,zmm0
	vmovapd zmm2,ZMMWORD ptr sign_bits_f_64
		
	movzx ecx,lgth
		
VectorDist1D_AVX512_1:
	vmovapd zmm1,ZMMWORD ptr[ebx]
	vsubpd zmm1,zmm1,ZMMWORD ptr[edx]
	add ebx,eax
	vandpd zmm1,zmm1,zmm2
	add edx,eax
	vaddpd zmm0,zmm0,zmm1
	loop VectorDist1D_AVX512_1

	vextractf64x4 ymm2,zmm0,1

	vextractf128 xmm1,ymm0,1
	vextractf128 xmm3,ymm2,1

	vaddpd xmm0,xmm0,xmm1
	vaddpd xmm2,xmm2,xmm3
		
	vmovhlps xmm1,xmm1,xmm0
	vmovhlps xmm3,xmm3,xmm2

	mov edx,result

	vaddsd xmm0,xmm0,xmm1
	vaddsd xmm2,xmm2,xmm3

	vaddpd xmm0,xmm0,xmm2
	vmovsd qword ptr[edx],xmm0
		
	vzeroupper
		
	pop ebx
		
	ret
		
VectorDist1D_AVX512 endp	


VectorProductF_AVX512 proc coeff_a:dword,coeff_x:dword,result:dword,lgth:word

    public VectorProductF_AVX512
	
	push ebx
		
	mov eax,64
	mov ebx,coeff_a
	mov edx,coeff_x
		
	vxorps zmm0,zmm0,zmm0
		
	movzx ecx,lgth
		
VectorProductF_AVX512_1:
	vmovaps zmm1,ZMMWORD ptr[ebx]
	add ebx,eax
	vmulps zmm1,zmm1,ZMMWORD ptr[edx]
	add edx,eax
	vaddps zmm0,zmm0,zmm1
	loop VectorProductF_AVX512_1

	vextractf32x8 ymm2,zmm0,1

	vextractf128 xmm1,ymm0,1
	vextractf128 xmm3,ymm2,1

	vaddps xmm0,xmm0,xmm1
	vaddps xmm2,xmm2,xmm3
		
	vmovhlps xmm1,xmm1,xmm0
	vmovhlps xmm3,xmm3,xmm2

	vaddps xmm0,xmm0,xmm1
	vaddps xmm2,xmm2,xmm3

	mov edx,result

	vpsrldq xmm1,xmm0,4
	vpsrldq xmm3,xmm2,4

	vaddss xmm0,xmm0,xmm1
	vaddss xmm2,xmm2,xmm3

	vaddps xmm0,xmm0,xmm2
	vmovss dword ptr[edx],xmm0
		
	vzeroupper
		
	pop ebx
		
	ret
		
VectorProductF_AVX512 endp	

		
VectorProductD_AVX512 proc coeff_a:dword,coeff_x:dword,result:dword,lgth:word

    public VectorProductD_AVX512
	
	push ebx
		
	mov eax,64
	mov ebx,coeff_a
	mov edx,coeff_x
		
	vxorpd zmm0,zmm0,zmm0
		
	movzx ecx,lgth
		
VectorProductD_AVX512_1:
	vmovapd zmm1,ZMMWORD ptr[ebx]
	add ebx,eax
	vmulpd zmm1,zmm1,ZMMWORD ptr[edx]
	add edx,eax
	vaddpd zmm0,zmm0,zmm1
	loop VectorProductD_AVX512_1

	vextractf64x4 ymm2,zmm0,1

	vextractf128 xmm1,ymm0,1
	vextractf128 xmm3,ymm2,1

	vaddpd xmm0,xmm0,xmm1
	vaddpd xmm2,xmm2,xmm3
		
	vmovhlps xmm1,xmm1,xmm0
	vmovhlps xmm3,xmm3,xmm2

	mov edx,result

	vaddsd xmm0,xmm0,xmm1
	vaddsd xmm2,xmm2,xmm3

	vaddpd xmm0,xmm0,xmm2
	vmovsd qword ptr[edx],xmm0
		
	vzeroupper
		
	pop ebx
		
	ret
		
VectorProductD_AVX512 endp	


VectorAddF_AVX512 proc coeff_a:dword,coeff_b:dword,coeff_c:dword,lgth:word

    public VectorAddF_AVX512
	
	push ebx

	mov eax,coeff_a
	mov ebx,coeff_b
	mov edx,coeff_c
	movzx ecx,lgth
	
VectorAddF_AVX512_1:	
	vmovaps zmm0,ZMMWORD ptr[eax]
	add eax,64
	vaddps zmm0,zmm0,ZMMWORD ptr[ebx]
	add ebx,64
	vmovaps ZMMWORD ptr[edx],zmm0
	add edx,64
	loop VectorAddF_AVX512_1
	
	vzeroupper
	
	pop ebx
	
	ret
	
VectorAddF_AVX512 endp	


VectorSubF_AVX512 proc coeff_a:dword,coeff_b:dword,coeff_c:dword,lgth:word

    public VectorSubF_AVX512
	
	push ebx

	mov eax,coeff_a
	mov ebx,coeff_b
	mov edx,coeff_c
	movzx ecx,lgth
	
VectorSubF_AVX512_1:	
	vmovaps zmm0,ZMMWORD ptr[eax]
	add eax,64
	vsubps zmm0,zmm0,ZMMWORD ptr[ebx]
	add ebx,64
	vmovaps ZMMWORD ptr[edx],zmm0
	add edx,64
	loop VectorSubF_AVX512_1
	
	vzeroupper
	
	pop ebx
	
	ret
	
VectorSubF_AVX512 endp	


VectorProdF_AVX512 proc coeff_a:dword,coeff_b:dword,coeff_c:dword,lgth:word

    public VectorProdF_AVX512
	
	push ebx

	mov eax,coeff_a
	mov ebx,coeff_b
	mov edx,coeff_c
	movzx ecx,lgth
	
VectorProdF_AVX512_1:	
	vmovaps zmm0,ZMMWORD ptr[eax]
	add eax,64
	vmulps zmm0,zmm0,ZMMWORD ptr[ebx]
	add ebx,64
	vmovaps ZMMWORD ptr[edx],zmm0
	add edx,64
	loop VectorProdF_AVX512_1
	
	vzeroupper
	
	pop ebx
	
	ret
	
VectorProdF_AVX512 endp


VectorAdd2F_AVX512 proc coeff_a:dword,coeff_b:dword,lgth:word

    public VectorAdd2F_AVX512
	
	push ebx

	mov eax,64
	mov ebx,coeff_a
	mov edx,coeff_b
	movzx ecx,lgth
	
VectorAdd2F_AVX512_1:	
	vmovaps zmm0,ZMMWORD ptr[ebx]
	vaddps zmm0,zmm0,ZMMWORD ptr[edx]
	add edx,eax
	vmovaps ZMMWORD ptr[ebx],zmm0
	add ebx,eax
	loop VectorAdd2F_AVX512_1
	
	vzeroupper
	
	pop ebx
	
	ret
	
VectorAdd2F_AVX512 endp	


VectorSub2F_AVX512 proc coeff_a:dword,coeff_b:dword,lgth:word

    public VectorSub2F_AVX512
	
	push ebx

	mov eax,64
	mov ebx,coeff_a
	mov edx,coeff_b
	movzx ecx,lgth
	
VectorSub2F_AVX512_1:	
	vmovaps zmm0,ZMMWORD ptr[ebx]
	vsubps zmm0,zmm0,ZMMWORD ptr[edx]
	add edx,eax
	vmovaps ZMMWORD ptr[ebx],zmm0
	add ebx,eax
	loop VectorSub2F_AVX512_1
	
	vzeroupper
	
	pop ebx
	
	ret
	
VectorSub2F_AVX512 endp


VectorInvSubF_AVX512 proc coeff_a:dword,coeff_b:dword,lgth:word

    public VectorInvSubF_AVX512
	
	push ebx

	mov eax,64
	mov ebx,coeff_a
	mov edx,coeff_b
	movzx ecx,lgth
	
VectorInvSubF_AVX512_1:	
	vmovaps zmm0,ZMMWORD ptr[edx]
	vsubps zmm0,zmm0,ZMMWORD ptr[ebx]
	add edx,eax
	vmovaps ZMMWORD ptr[ebx],zmm0
	add ebx,eax
	loop VectorInvSubF_AVX512_1
	
	vzeroupper
	
	pop ebx
	
	ret
	
VectorInvSubF_AVX512 endp


VectorProd2F_AVX512 proc coeff_a:dword,coeff_b:dword,lgth:word

    public VectorProd2F_AVX512
	
	push ebx

	mov eax,64
	mov ebx,coeff_a
	mov edx,coeff_b
	movzx ecx,lgth
	
VectorProd2F_AVX512_1:	
	vmovaps zmm0,ZMMWORD ptr[ebx]
	vmulps zmm0,zmm0,ZMMWORD ptr[edx]
	add edx,eax
	vmovaps ZMMWORD ptr[ebx],zmm0
	add ebx,eax
	loop VectorProd2F_AVX512_1
	
	vzeroupper
	
	pop ebx
	
	ret
	
VectorProd2F_AVX512 endp
		

VectorAddD_AVX512 proc coeff_a:dword,coeff_b:dword,coeff_c:dword,lgth:word

    public VectorAddD_AVX512
	
	push ebx

	mov eax,coeff_a
	mov ebx,coeff_b
	mov edx,coeff_c
	movzx ecx,lgth
	
VectorAddD_AVX512_1:	
	vmovapd zmm0,ZMMWORD ptr[eax]
	add eax,64
	vaddpd zmm0,zmm0,ZMMWORD ptr[ebx]
	add ebx,64
	vmovapd ZMMWORD ptr[edx],zmm0
	add edx,64
	loop VectorAddD_AVX512_1
	
	vzeroupper
	
	pop ebx
	
	ret
	
VectorAddD_AVX512 endp	


VectorSubD_AVX512 proc coeff_a:dword,coeff_b:dword,coeff_c:dword,lgth:word

    public VectorSubD_AVX512
	
	push ebx

	mov eax,coeff_a
	mov ebx,coeff_b
	mov edx,coeff_c
	movzx ecx,lgth
	
VectorSubD_AVX512_1:	
	vmovapd zmm0,ZMMWORD ptr[eax]
	add eax,64
	vsubpd zmm0,zmm0,ZMMWORD ptr[ebx]
	add ebx,64
	vmovapd ZMMWORD ptr[edx],zmm0
	add edx,64
	loop VectorSubD_AVX512_1
	
	vzeroupper
	
	pop ebx
	
	ret
	
VectorSubD_AVX512 endp	


VectorProdD_AVX512 proc coeff_a:dword,coeff_b:dword,coeff_c:dword,lgth:word

    public VectorProdD_AVX512
	
	push ebx

	mov eax,coeff_a
	mov ebx,coeff_b
	mov edx,coeff_c
	movzx ecx,lgth
	
VectorProdD_AVX512_1:	
	vmovapd zmm0,ZMMWORD ptr[eax]
	add eax,64
	vmulpd zmm0,zmm0,ZMMWORD ptr[ebx]
	add ebx,64
	vmovapd ZMMWORD ptr[edx],zmm0
	add edx,64
	loop VectorProdD_AVX512_1
	
	vzeroupper
	
	pop ebx
	
	ret
	
VectorProdD_AVX512 endp


VectorAdd2D_AVX512 proc coeff_a:dword,coeff_b:dword,lgth:word

    public VectorAdd2D_AVX512
	
	push ebx

	mov eax,64
	mov ebx,coeff_a
	mov edx,coeff_b
	movzx ecx,lgth
	
VectorAdd2D_AVX512_1:	
	vmovapd zmm0,ZMMWORD ptr[ebx]
	vaddpd zmm0,zmm0,ZMMWORD ptr[edx]
	add edx,eax
	vmovapd ZMMWORD ptr[ebx],zmm0
	add ebx,eax
	loop VectorAdd2D_AVX512_1
	
	vzeroupper
	
	pop ebx
	
	ret
	
VectorAdd2D_AVX512 endp	


VectorSub2D_AVX512 proc coeff_a:dword,coeff_b:dword,lgth:word

    public VectorSub2D_AVX512
	
	push ebx

	mov eax,64
	mov ebx,coeff_a
	mov edx,coeff_b
	movzx ecx,lgth
	
VectorSub2D_AVX512_1:	
	vmovapd zmm0,ZMMWORD ptr[ebx]
	vsubpd zmm0,zmm0,ZMMWORD ptr[edx]
	add edx,eax
	vmovapd ZMMWORD ptr[ebx],zmm0
	add ebx,eax
	loop VectorSub2D_AVX512_1
	
	vzeroupper
	
	pop ebx
	
	ret
	
VectorSub2D_AVX512 endp


VectorInvSubD_AVX512 proc coeff_a:dword,coeff_b:dword,lgth:word

    public VectorInvSubD_AVX512
	
	push ebx

	mov eax,64
	mov ebx,coeff_a
	mov edx,coeff_b
	movzx ecx,lgth
	
VectorInvSubD_AVX512_1:	
	vmovapd zmm0,ZMMWORD ptr[edx]
	vsubpd zmm0,zmm0,ZMMWORD ptr[ebx]
	add edx,eax
	vmovapd ZMMWORD ptr[ebx],zmm0
	add ebx,eax
	loop VectorInvSubD_AVX512_1
	
	vzeroupper
	
	pop ebx
	
	ret
	
VectorInvSubD_AVX512 endp


VectorProd2D_AVX512 proc coeff_a:dword,coeff_b:dword,lgth:word

    public VectorProd2D_AVX512
	
	push ebx

	mov eax,64
	mov ebx,coeff_a
	mov edx,coeff_b
	movzx ecx,lgth
	
VectorProd2D_AVX512_1:	
	vmovapd zmm0,ZMMWORD ptr[ebx]
	vmulpd zmm0,zmm0,ZMMWORD ptr[edx]
	add edx,eax
	vmovapd ZMMWORD ptr[ebx],zmm0
	add ebx,eax
	loop VectorProd2D_AVX512_1
	
	vzeroupper
	
	pop ebx
	
	ret
	
VectorProd2D_AVX512 endp
		
		
end