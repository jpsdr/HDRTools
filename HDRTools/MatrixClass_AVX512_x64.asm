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

	xor rcx,rcx
	mov rax,64
	mov ecx,r9d
	
CoeffProductF_AVX512_1:	
	vmulps zmm1,zmm0,ZMMWORD ptr[rdx]
	add rdx,rax
	vmovaps ZMMWORD ptr[r8],zmm1
	add r8,rax
	loop CoeffProductF_AVX512_1
	
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

	xor rcx,rcx
	mov rax,64
	mov ecx,r8d
	
CoeffProduct2F_AVX512_1:	
	vmulps zmm1,zmm0,ZMMWORD ptr[rdx]
	vmovaps ZMMWORD ptr[rdx],zmm1
	add rdx,rax
	loop CoeffProduct2F_AVX512_1
	
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
	
	xor rcx,rcx
	mov rax,64
	mov ecx,r9d
	
CoeffProductD_AVX512_1:	
	vmulpd zmm1,zmm0,ZMMWORD ptr[rdx]
	add rdx,rax
	vmovapd ZMMWORD ptr[r8],zmm1
	add r8,rax
	loop CoeffProductD_AVX512_1
	
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
	
	xor rcx,rcx
	mov rax,64
	mov ecx,r8d
	
CoeffProduct2D_AVX512_1:	
	vmulpd zmm1,zmm0,ZMMWORD ptr[rdx]
	vmovapd ZMMWORD ptr[rdx],zmm1
	add rdx,rax
	loop CoeffProduct2D_AVX512_1
	
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
	
	xor rcx,rcx
	mov rax,64
	mov ecx,r9d
	
CoeffAddProductF_AVX512_1:	
	vmulps zmm1,zmm0,ZMMWORD ptr[rdx]
	add rdx,rax
	vaddps zmm2,zmm1,ZMMWORD ptr[r8]
	vmovaps ZMMWORD ptr[r8],zmm2
	add r8,rax
	loop CoeffAddProductF_AVX512_1
	
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
	
	xor rcx,rcx
	mov rax,64
	mov ecx,r9d

CoeffAddProductD_AVX512_1:	
	vmulpd zmm1,zmm0,ZMMWORD ptr[rdx]
	add rdx,rax
	vaddpd zmm2,zmm1,ZMMWORD ptr[r8]
	vmovapd ZMMWORD ptr[r8],zmm2
	add r8,rax
	loop CoeffAddProductD_AVX512_1
	
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

	xor rcx,rcx
	mov rax,64
	mov ecx,r9d
	
CoeffAddF_AVX512_1:	
	vaddps zmm1,zmm0,ZMMWORD ptr[rdx]
	add rdx,rax
	vmovaps ZMMWORD ptr[r8],zmm1
	add r8,rax
	loop CoeffAddF_AVX512_1
	
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

	xor rcx,rcx
	mov rax,64
	mov ecx,r8d
	
CoeffAdd2F_AVX512_1:	
	vaddps zmm1,zmm0,ZMMWORD ptr[rdx]
	vmovaps ZMMWORD ptr[rdx],zmm1
	add rdx,rax
	loop CoeffAdd2F_AVX512_1
	
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
	
	xor rcx,rcx
	mov rax,64
	mov ecx,r9d
	
CoeffAddD_AVX512_1:	
	vaddpd zmm1,zmm0,ZMMWORD ptr[rdx]
	add rdx,rax
	vmovapd ZMMWORD ptr[r8],zmm1
	add r8,rax
	loop CoeffAddD_AVX512_1
	
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
	
	xor rcx,rcx
	mov rax,64
	mov ecx,r8d
	
CoeffAdd2D_AVX512_1:	
	vaddpd zmm1,zmm0,ZMMWORD ptr[rdx]
	vmovapd ZMMWORD ptr[rdx],zmm1
	add rdx,rax
	loop CoeffAdd2D_AVX512_1
	
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

	xor rcx,rcx
	mov rax,64
	mov ecx,r9d
	
CoeffSubF_AVX512_1:	
	vsubps zmm1,zmm0,ZMMWORD ptr[rdx]
	add rdx,rax
	vmovaps ZMMWORD ptr[r8],zmm1
	add r8,rax
	loop CoeffSubF_AVX512_1
	
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

	xor rcx,rcx
	mov rax,64
	mov ecx,r8d
	
CoeffSub2F_AVX512_1:	
	vsubps zmm1,zmm0,ZMMWORD ptr[rdx]
	vmovaps ZMMWORD ptr[rdx],zmm1
	add rdx,rax
	loop CoeffSub2F_AVX512_1
	
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
	
	xor rcx,rcx
	mov rax,64
	mov ecx,r9d
	
CoeffSubD_AVX512_1:	
	vsubpd zmm1,zmm0,ZMMWORD ptr[rdx]
	add rdx,rax
	vmovapd ZMMWORD ptr[r8],zmm1
	add r8,rax
	loop CoeffSubD_AVX512_1
	
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
	
	xor rcx,rcx
	mov rax,64
	mov ecx,r8d
	
CoeffSub2D_AVX512_1:	
	vsubpd zmm1,zmm0,ZMMWORD ptr[rdx]
	vmovapd ZMMWORD ptr[rdx],zmm1
	add rdx,rax
	loop CoeffSub2D_AVX512_1
	
	vzeroupper
		
	ret
	
CoeffSub2D_AVX512 endp


;VectorNorme2F_AVX512 proc coeff_x:dword,result:dword,lgth:word
; coeff_x = rcx
; result = rdx
; lgth = r8d

VectorNorme2F_AVX512 proc public frame

	.endprolog
		
	mov r9,rcx
	vxorps zmm0,zmm0,zmm0
	xor rcx,rcx
	mov rax,64
	mov ecx,r8d
		
VectorNorme2F_AVX512_1:
	vmovaps zmm1,ZMMWORD ptr[r9]
	vmulps zmm1,zmm1,zmm1
	add r9,rax
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
	
	mov r9,rcx
	vxorpd zmm0,zmm0,zmm0
	xor rcx,rcx
	mov rax,64
	mov ecx,r8d
		
VectorNorme2D_AVX512_1:
	vmovapd zmm1,ZMMWORD ptr[r9]
	vmulpd zmm1,zmm1,zmm1
	add r9,rax
	vaddpd zmm0,zmm0,zmm1
	loop VectorNorme2D_AVX512_1

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
		
	mov r10,rcx
	vxorps zmm0,zmm0,zmm0
	xor rcx,rcx
	mov rax,64
	mov ecx,r9d
		
VectorDist2F_AVX512_1:
	vmovaps zmm1,ZMMWORD ptr[r10]
	vsubps zmm1,zmm1,ZMMWORD ptr[rdx]
	add r10,rax
	vmulps zmm1,zmm1,zmm1
	add rdx,rax
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


;VectorDist2D_AVX512 proc coeff_a:dword,coeff_x:dword,result:dword,lgth:word
; coeff_a = rcx
; coeff_x = rdx
; result = r8
; lgth = r9d

VectorDist2D_AVX512 proc public frame

	.endprolog
	
	mov r10,rcx
	vxorpd zmm0,zmm0,zmm0
	xor rcx,rcx
	mov rax,64
	mov ecx,r9d
		
VectorDist2D_AVX512_1:
	vmovapd zmm1,ZMMWORD ptr[r10]
	vsubpd zmm1,zmm1,ZMMWORD ptr[rdx]
	add r10,rax
	vmulpd zmm1,zmm1,zmm1
	add rdx,rax
	vaddpd zmm0,zmm0,zmm1
	loop VectorDist2D_AVX512_1

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
	vxorps zmm0,zmm0,zmm0
	xor rcx,rcx
	mov rax,64
	mov ecx,r8d
		
VectorNormeF_AVX512_1:
	vmovaps zmm1,ZMMWORD ptr[r9]
	vmulps zmm1,zmm1,zmm1
	add r9,rax
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
	vxorpd zmm0,zmm0,zmm0
	xor rcx,rcx
	mov rax,64
	mov ecx,r8d
		
VectorNormeD_AVX512_1:
	vmovapd zmm1,ZMMWORD ptr[r9]
	vmulpd zmm1,zmm1,zmm1
	add r9,rax
	vaddpd zmm0,zmm0,zmm1
	loop VectorNormeD_AVX512_1

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
	vxorps zmm0,zmm0,zmm0
	xor rcx,rcx
	mov rax,64
	mov ecx,r9d
		
VectorDistF_AVX512_1:
	vmovaps zmm1,ZMMWORD ptr[r10]
	vsubps zmm1,zmm1,ZMMWORD ptr[rdx]
	add r10,rax
	vmulps zmm1,zmm1,zmm1
	add rdx,rax
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

	vpsrldq xmm1,xmm0,4
	vpsrldq xmm3,xmm2,4

	vaddss xmm0,xmm0,xmm1
	vaddss xmm2,xmm2,xmm3

	vaddps xmm0,xmm0,xmm2
	vmovss dword ptr[r8],xmm0
		
	vzeroupper
	
	ret
		
VectorDistF_AVX512 endp


;VectorDistD_AVX512 proc coeff_a:dword,coeff_x:dword,result:dword,lgth:word
; coeff_a = rcx
; coeff_x = rdx
; result = r8
; lgth = r9d

VectorDistD_AVX512 proc public frame

	.endprolog
	
	mov r10,rcx
	vxorpd zmm0,zmm0,zmm0
	xor rcx,rcx
	mov rax,64
	mov ecx,r9d
		
VectorDistD_AVX512_1:
	vmovapd zmm1,ZMMWORD ptr[r10]
	vsubpd zmm1,zmm1,ZMMWORD ptr[rdx]
	add r10,rax
	vmulpd zmm1,zmm1,zmm1
	add rdx,rax
	vaddpd zmm0,zmm0,zmm1
	loop VectorDistD_AVX512_1

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
	vxorps zmm0,zmm0,zmm0
	vmovaps zmm2,ZMMWORD ptr sign_bits_f_32
	xor rcx,rcx
	mov rax,64
	mov ecx,r8d
		
VectorNorme1F_AVX512_1:
	vandps zmm1,zmm2,ZMMWORD ptr[r9]
	add r9,rax
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
	vxorpd zmm0,zmm0,zmm0
	vmovapd zmm2,ZMMWORD ptr sign_bits_f_64
	xor rcx,rcx
	mov rax,64
	mov ecx,r8d
		
VectorNorme1D_AVX512_1:
	vandpd zmm1,zmm2,ZMMWORD ptr[r9]
	add r9,rax
	vaddpd zmm0,zmm0,zmm1
	loop VectorNorme1D_AVX512_1

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
	vxorps zmm0,zmm0,zmm0
	vmovaps zmm2,ZMMWORD ptr sign_bits_f_32
	xor rcx,rcx
	mov rax,64
	mov ecx,r9d
		
VectorDist1F_AVX512_1:
	vmovaps zmm1,ZMMWORD ptr[r10]
	vsubps zmm1,zmm1,ZMMWORD ptr[rdx]
	add r10,rax
	vandps zmm1,zmm1,zmm2
	add rdx,rax
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

	vpsrldq xmm1,xmm0,4
	vpsrldq xmm3,xmm2,4

	vaddss xmm0,xmm0,xmm1
	vaddss xmm2,xmm2,xmm3

	vaddps xmm0,xmm0,xmm2
	vmovss dword ptr[r8],xmm0
		
	vzeroupper
	
	ret
		
VectorDist1F_AVX512 endp


;VectorDist1D_AVX512 proc coeff_a:dword,coeff_x:dword,result:dword,lgth:word
; coeff_a = rcx
; coeff_x = rdx
; result = r8
; lgth = r9d

VectorDist1D_AVX512 proc public frame

	.endprolog
	
	mov r10,rcx
	vxorpd zmm0,zmm0,zmm0
	vmovapd zmm2,ZMMWORD ptr sign_bits_f_64
	xor rcx,rcx
	mov rax,64
	mov ecx,r9d
		
VectorDist1D_AVX512_1:
	vmovapd zmm1,ZMMWORD ptr[r10]
	vsubpd zmm1,zmm1,ZMMWORD ptr[rdx]
	add r10,rax
	vandpd zmm1,zmm1,zmm2
	add rdx,rax
	vaddpd zmm0,zmm0,zmm1
	loop VectorDist1D_AVX512_1

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
	vxorps zmm0,zmm0,zmm0
	xor rcx,rcx
	mov rax,64
	mov ecx,r9d
		
VectorProductF_AVX512_1:
	vmovaps zmm1,ZMMWORD ptr[r10]
	add r10,rax
	vmulps zmm1,zmm1,ZMMWORD ptr[rdx]
	add rdx,rax
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
	vxorpd zmm0,zmm0,zmm0
	xor rcx,rcx
	mov rax,64
	mov ecx,r9d
		
VectorProductD_AVX512_1:
	vmovapd zmm1,ZMMWORD ptr[r10]
	add r10,rax
	vmulpd zmm1,zmm1,ZMMWORD ptr[rdx]
	add rdx,rax
	vaddpd zmm0,zmm0,zmm1
	loop VectorProductD_AVX512_1

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
	mov r11,64
	xor rcx,rcx
	mov ecx,r9d
	
VectorAddF_AVX512_1:	
	vmovaps zmm0,ZMMWORD ptr[r10]
	add r10,r11
	vaddps zmm0,zmm0,ZMMWORD ptr[rdx]
	add rdx,r11
	vmovaps ZMMWORD ptr[r8],zmm0
	add r8,r11
	loop VectorAddF_AVX512_1
	
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
	mov r11,64
	xor rcx,rcx
	mov ecx,r9d
	
VectorSubF_AVX512_1:	
	vmovaps zmm0,ZMMWORD ptr[r10]
	add r10,r11
	vsubps zmm0,zmm0,ZMMWORD ptr[rdx]
	add rdx,r11
	vmovaps ZMMWORD ptr[r8],zmm0
	add r8,r11
	loop VectorSubF_AVX512_1
	
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
	mov r11,64
	xor rcx,rcx
	mov ecx,r9d
	
VectorProdF_AVX512_1:	
	vmovaps zmm0,ZMMWORD ptr[r10]
	add r10,r11
	vmulps zmm0,zmm0,ZMMWORD ptr[rdx]
	add rdx,r11
	vmovaps ZMMWORD ptr[r8],zmm0
	add r8,r11
	loop VectorProdF_AVX512_1
	
	ret
	
VectorProdF_AVX512 endp


;VectorAdd2F_AVX512 proc coeff_a:dword,coeff_b:dword,lgth:word
; coeff_a = rcx
; coeff_b = rdx
; lgth = r8d

VectorAdd2F_AVX512 proc public frame

	.endprolog

	mov r9,rcx
	mov r10,64
	xor rcx,rcx
	mov ecx,r8d
	
VectorAdd2F_AVX512_1:	
	vmovaps zmm0,ZMMWORD ptr[r9]
	vaddps zmm0,zmm0,ZMMWORD ptr[rdx]
	add rdx,r10
	vmovaps ZMMWORD ptr[r9],zmm0
	add r9,r10
	loop VectorAdd2F_AVX512_1
	
	ret
	
VectorAdd2F_AVX512 endp


;VectorSub2F_AVX512 proc coeff_a:dword,coeff_b:dword,lgth:word
; coeff_a = rcx
; coeff_b = rdx
; lgth = r8d

VectorSub2F_AVX512 proc public frame

	.endprolog

	mov r9,rcx
	mov r10,64
	xor rcx,rcx
	mov ecx,r8d
	
VectorSub2F_AVX512_1:	
	vmovaps zmm0,ZMMWORD ptr[r9]
	vsubps zmm0,zmm0,ZMMWORD ptr[rdx]
	add rdx,r10
	vmovaps ZMMWORD ptr[r9],zmm0
	add r9,r10
	loop VectorSub2F_AVX512_1
	
	ret
	
VectorSub2F_AVX512 endp


;VectorInvSubF_AVX512 proc coeff_a:dword,coeff_b:dword,lgth:word
; coeff_a = rcx
; coeff_b = rdx
; lgth = r8d

VectorInvSubF_AVX512 proc public frame

	.endprolog

	mov r9,rcx
	mov r10,64
	xor rcx,rcx
	mov ecx,r8d
	
VectorInvSubF_AVX512_1:	
	vmovaps zmm0,ZMMWORD ptr[rdx]
	vsubps zmm0,zmm0,ZMMWORD ptr[r9]
	add rdx,r10
	vmovaps ZMMWORD ptr[r9],zmm0
	add r9,r10
	loop VectorInvSubF_AVX512_1
	
	ret
	
VectorInvSubF_AVX512 endp


;VectorProd2F_AVX512 proc coeff_a:dword,coeff_b:dword,lgth:word
; coeff_a = rcx
; coeff_b = rdx
; lgth = r8d

VectorProd2F_AVX512 proc public frame

	.endprolog

	mov r9,rcx
	mov r10,64
	xor rcx,rcx
	mov ecx,r8d
	
VectorProd2F_AVX512_1:	
	vmovaps zmm0,ZMMWORD ptr[r9]
	vmulps zmm0,zmm0,ZMMWORD ptr[rdx]
	add rdx,r10
	vmovaps ZMMWORD ptr[r9],zmm0
	add r9,r10
	loop VectorProd2F_AVX512_1
	
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
	mov r11,64
	xor rcx,rcx
	mov ecx,r9d
	
VectorAddD_AVX512_1:	
	vmovapd zmm0,ZMMWORD ptr[r10]
	add r10,r11
	vaddpd zmm0,zmm0,ZMMWORD ptr[rdx]
	add rdx,r11
	vmovapd ZMMWORD ptr[r8],zmm0
	add r8,r11
	loop VectorAddD_AVX512_1
	
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
	mov r11,64
	xor rcx,rcx
	mov ecx,r9d
	
VectorSubD_AVX512_1:	
	vmovapd zmm0,ZMMWORD ptr[r10]
	add r10,r11
	vsubpd zmm0,zmm0,ZMMWORD ptr[rdx]
	add rdx,r11
	vmovapd ZMMWORD ptr[r8],zmm0
	add r8,r11
	loop VectorSubD_AVX512_1
	
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
	mov r11,64
	xor rcx,rcx
	mov ecx,r9d
	
VectorProdD_AVX512_1:	
	vmovapd zmm0,ZMMWORD ptr[r10]
	add r10,r11
	vmulpd zmm0,zmm0,ZMMWORD ptr[rdx]
	add rdx,r11
	vmovapd ZMMWORD ptr[r8],zmm0
	add r8,r11
	loop VectorProdD_AVX512_1
	
	ret
	
VectorProdD_AVX512 endp


;VectorAdd2D_AVX512 proc coeff_a:dword,coeff_b:dword,lgth:word
; coeff_a = rcx
; coeff_b = rdx
; lgth = r8d

VectorAdd2D_AVX512 proc public frame

	.endprolog

	mov r9,rcx
	mov r10,64
	xor rcx,rcx
	mov ecx,r8d
	
VectorAdd2D_AVX512_1:	
	vmovapd zmm0,ZMMWORD ptr[r9]
	vaddpd zmm0,zmm0,ZMMWORD ptr[rdx]
	add rdx,r10
	vmovapd ZMMWORD ptr[r9],zmm0
	add r9,r10
	loop VectorAdd2D_AVX512_1
	
	ret
	
VectorAdd2D_AVX512 endp


;VectorSub2D_AVX512 proc coeff_a:dword,coeff_b:dword,lgth:word
; coeff_a = rcx
; coeff_b = rdx
; lgth = r8d

VectorSub2D_AVX512 proc public frame

	.endprolog

	mov r9,rcx
	mov r10,64
	xor rcx,rcx
	mov ecx,r8d
	
VectorSub2D_AVX512_1:	
	vmovapd zmm0,ZMMWORD ptr[r9]
	vsubpd zmm0,zmm0,ZMMWORD ptr[rdx]
	add rdx,r10
	vmovapd ZMMWORD ptr[r9],zmm0
	add r9,r10
	loop VectorSub2D_AVX512_1
	
	ret
	
VectorSub2D_AVX512 endp


;VectorInvSubD_AVX512 proc coeff_a:dword,coeff_b:dword,lgth:word
; coeff_a = rcx
; coeff_b = rdx
; lgth = r8d

VectorInvSubD_AVX512 proc public frame

	.endprolog

	mov r9,rcx
	mov r10,64
	xor rcx,rcx
	mov ecx,r8d
	
VectorInvSubD_AVX512_1:	
	vmovapd zmm0,ZMMWORD ptr[rdx]
	vsubpd zmm0,zmm0,ZMMWORD ptr[r9]
	add rdx,r10
	vmovapd ZMMWORD ptr[r9],zmm0
	add r9,r10
	loop VectorInvSubD_AVX512_1
	
	ret
	
VectorInvSubD_AVX512 endp


;VectorProd2D_AVX512 proc coeff_a:dword,coeff_b:dword,lgth:word
; coeff_a = rcx
; coeff_b = rdx
; lgth = r8d

VectorProd2D_AVX512 proc public frame

	.endprolog

	mov r9,rcx
	mov r10,64
	xor rcx,rcx
	mov ecx,r8d
	
VectorProd2D_AVX512_1:	
	vmovapd zmm0,ZMMWORD ptr[r9]
	vmulpd zmm0,zmm0,ZMMWORD ptr[rdx]
	add rdx,r10
	vmovapd ZMMWORD ptr[r9],zmm0
	add r9,r10
	loop VectorProd2D_AVX512_1
	
	ret
	
VectorProd2D_AVX512 endp


end