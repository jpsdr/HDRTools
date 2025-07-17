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
; AVX512F/DQ/BW

.xmm
.model flat,c

.data

align 16

data segment align(64)

data_f_1048575 real4 16 dup(1048575.0)
data_f_65535 real4 16 dup(65535.0)
data_dw_1048575 dword 16 dup(1048575)
data_dw_65535 dword 16 dup(65535)
data_dw_0 dword 16 dup(0)

data_w_128 word 32 dup(128)
data_w_32 word 32 dup(32)
data_w_8 word 32 dup(8)

.code


JPSDR_HDRTools_Convert_Planar420_to_Planar422_8_AVX512 proc src1:dword,src2:dword,dst:dword,w:dword

	public JPSDR_HDRTools_Convert_Planar420_to_Planar422_8_AVX512
	
	push esi
	push edi
	push ebx
	
	vpcmpeqb ymm3,ymm3,ymm3
	vinsertf32x8 zmm3,zmm3,ymm3,1
	
	mov edi,dst
	mov esi,src1
	mov edx,src2
	xor eax,eax
	mov ecx,w	
	mov ebx,64
	
Convert_Planar420_to_Planar422_8_AVX512_1:
	vmovdqa64 zmm0,ZMMWORD ptr[esi+eax]
	vmovdqa64 zmm1,ZMMWORD ptr[edx+eax]
	vpxorq zmm2,zmm0,zmm3
	vpxorq zmm1,zmm1,zmm3
	vpavgb zmm2,zmm2,zmm1
	vpxorq zmm2,zmm2,zmm3
	vpavgb zmm2,zmm2,zmm0
	
	vmovdqa64 ZMMWORD ptr[edi+eax],zmm2
	add eax,ebx
	loop Convert_Planar420_to_Planar422_8_AVX512_1
	
	vzeroupper
	
	pop ebx
	pop edi
	pop esi

	ret

JPSDR_HDRTools_Convert_Planar420_to_Planar422_8_AVX512 endp


JPSDR_HDRTools_Convert_Planar420_to_Planar422_16_AVX512 proc src1:dword,src2:dword,dst:dword,w:dword

	public JPSDR_HDRTools_Convert_Planar420_to_Planar422_16_AVX512
	
	push esi
	push edi
	push ebx
	
	vpcmpeqb ymm3,ymm3,ymm3
	vinsertf32x8 zmm3,zmm3,ymm3,1
	
	mov edi,dst
	mov esi,src1
	mov edx,src2
	xor eax,eax	
	mov ecx,w	
	mov ebx,64
	
Convert_Planar420_to_Planar422_16_AVX512_1:
	vmovdqa64 zmm0,ZMMWORD ptr[esi+eax]
	vmovdqa64 zmm1,ZMMWORD ptr[edx+eax]
	vpxorq zmm2,zmm0,zmm3
	vpxorq zmm1,zmm1,zmm3
	vpavgw zmm2,zmm2,zmm1
	vpxorq zmm2,zmm2,zmm3
	vpavgw zmm2,zmm2,zmm0
	
	vmovdqa64 ZMMWORD ptr[edi+eax],zmm2
	add eax,ebx
	loop Convert_Planar420_to_Planar422_16_AVX512_1
	
	vzeroupper
	
	pop ebx
	pop edi
	pop esi

	ret

JPSDR_HDRTools_Convert_Planar420_to_Planar422_16_AVX512 endp


JPSDR_HDRTools_Convert_Planar422_to_Planar420_8_AVX512 proc src1:dword,src2:dword,dst:dword,w64:dword,h:dword,src_pitch2:dword,dst_pitch:dword

	public JPSDR_HDRTools_Convert_Planar422_to_Planar420_8_AVX512
	
	push esi
	push edi
	push ebx
	
	mov edi,dst
	mov esi,src1
	mov edx,src2
	mov ebx,64
	
Convert_Planar422_to_Planar420_8_AVX512_1:
	xor eax,eax
	mov ecx,w64

Convert_Planar422_to_Planar420_8_AVX512_2:
	vmovdqa64 zmm0,ZMMWORD ptr[esi+eax]
	vpavgb zmm0,zmm0,ZMMWORD ptr[edx+eax]
	
	vmovdqa64 ZMMWORD ptr[edi+eax],zmm0
	add eax,ebx
	loop Convert_Planar422_to_Planar420_8_AVX512_2
	
	add esi,src_pitch2
	add edx,src_pitch2
	add edi,dst_pitch
	dec h
	jnz short Convert_Planar422_to_Planar420_8_AVX512_1
	
	vzeroupper
	
	pop ebx
	pop edi
	pop esi

	ret

JPSDR_HDRTools_Convert_Planar422_to_Planar420_8_AVX512 endp


JPSDR_HDRTools_Convert_Planar422_to_Planar420_16_AVX512 proc src1:dword,src2:dword,dst:dword,w32:dword,h:dword,src_pitch2:dword,dst_pitch:dword

	public JPSDR_HDRTools_Convert_Planar422_to_Planar420_16_AVX512
	
	push esi
	push edi
	push ebx
	
	mov edi,dst
	mov esi,src1
	mov edx,src2
	mov ebx,64
	
Convert_Planar422_to_Planar420_16_AVX512_1:
	xor eax,eax
	mov ecx,w32

Convert_Planar422_to_Planar420_16_AVX512_2:
	vmovdqa64 zmm0,ZMMWORD ptr[esi+eax]
	vpavgw zmm0,zmm0,ZMMWORD ptr[edx+eax]
	
	vmovdqa64 ZMMWORD ptr[edi+eax],zmm0
	add eax,ebx
	loop Convert_Planar422_to_Planar420_16_AVX512_2
	
	add esi,src_pitch2
	add edx,src_pitch2
	add edi,dst_pitch
	dec h
	jnz short Convert_Planar422_to_Planar420_16_AVX512_1
	
	vzeroupper
	
	pop ebx
	pop edi
	pop esi

	ret

JPSDR_HDRTools_Convert_Planar422_to_Planar420_16_AVX512 endp


JPSDR_HDRTools_Scale_20_XYZ_AVX512 proc src:dword,dst:dword,w16:dword,h:dword,src_pitch:dword,dst_pitch:dword,
	ValMin:dword,Coeff:dword

	public JPSDR_HDRTools_Scale_20_XYZ_AVX512

	push esi
	push edi
	push ebx
	
	mov esi,ValMin
	vmovss xmm1,dword ptr[esi]
	mov esi,Coeff
	vmovss xmm2,dword ptr[esi]

	vshufps xmm1,xmm1,xmm1,0
	vshufps xmm2,xmm2,xmm2,0

	vinsertf128 ymm1,ymm1,xmm1,1
	vinsertf128 ymm2,ymm2,xmm2,1

	vinsertf32x8 zmm1,zmm1,ymm1,1
	vinsertf32x8 zmm2,zmm2,ymm2,1

	vmovdqa64 zmm3,ZMMWORD ptr data_dw_1048575
	vmovdqa64 zmm4,ZMMWORD ptr data_dw_0
	vmulps zmm2,zmm2,ZMMWORD ptr data_f_1048575
	
	mov esi,src
	mov edi,dst
	mov ebx,w16
	mov edx,64
	
Scale_20_XYZ_AVX512_1:
	xor eax,eax
	mov ecx,ebx
Scale_20_XYZ_AVX512_2:	
	vaddps zmm0,zmm1,ZMMWORD ptr[esi+eax]
	vmulps zmm0,zmm0,zmm2
	vcvtps2dq zmm0,zmm0
	vpminsd zmm0,zmm0,zmm3
	vpmaxsd zmm0,zmm0,zmm4
	vmovdqa64 ZMMWORD ptr[edi+eax],zmm0
	
	add eax,edx
	loop Scale_20_XYZ_AVX512_2
	
	add esi,src_pitch
	add edi,dst_pitch
	dec h
	jnz short Scale_20_XYZ_AVX512_1
	
	vzeroupper
	
	pop ebx
	pop edi
	pop esi

	ret

JPSDR_HDRTools_Scale_20_XYZ_AVX512 endp


JPSDR_HDRTools_Scale_20_RGB_AVX512 proc src:dword,dst:dword,w16:dword,h:dword,src_pitch:dword,dst_pitch:dword

	public JPSDR_HDRTools_Scale_20_RGB_AVX512

	push esi
	push edi
	push ebx
	
	vmovaps zmm1,ZMMWORD ptr data_f_1048575
	vmovdqa64 zmm2,ZMMWORD ptr data_dw_1048575
	vmovdqa64 zmm3,ZMMWORD ptr data_dw_0
	
	mov esi,src
	mov edi,dst
	mov ebx,w16
	mov edx,64
	
Scale_20_RGB_AVX512_1:
	xor eax,eax
	mov ecx,ebx
Scale_20_RGB_AVX512_2:	
	vmulps zmm0,zmm1,ZMMWORD ptr[esi+eax]
	vcvtps2dq zmm0,zmm0
	vpminsd zmm0,zmm0,zmm2
	vpmaxsd zmm0,zmm0,zmm3
	vmovdqa64 ZMMWORD ptr[edi+eax],zmm0
	
	add eax,edx
	loop Scale_20_RGB_AVX512_2
	
	add esi,src_pitch
	add edi,dst_pitch
	dec h
	jnz short Scale_20_RGB_AVX512_1
	
	vzeroupper
	
	pop ebx
	pop edi
	pop esi

	ret

JPSDR_HDRTools_Scale_20_RGB_AVX512 endp


JPSDR_HDRTools_Convert_RGB64_16toRGB64_8_AVX512 proc src:dword,dst:dword,w:dword,h:dword,
	src_pitch:dword,dst_pitch:dword

	public JPSDR_HDRTools_Convert_RGB64_16toRGB64_8_AVX512

	push esi
	push edi
	push ebx

	vmovdqa64 zmm1,ZMMWORD ptr data_w_128

	mov esi,src
	mov edi,dst
	mov ebx,w
	shr ebx,3
	mov edx,64

Convert_RGB64_16toRGB64_8_AVX512_1:
	mov ecx,ebx
	xor eax,eax
	or ecx,ecx
	jz short Convert_RGB64_16toRGB64_8_AVX512_3
	
Convert_RGB64_16toRGB64_8_AVX512_2:
	vmovdqa64 zmm0,ZMMWORD ptr[esi+eax]
	vpaddusw zmm0,zmm0,zmm1
	vpsrlw zmm0,zmm0,8
	vmovdqa64 ZMMWORD ptr[edi+eax],zmm0
	add eax,edx
	loop Convert_RGB64_16toRGB64_8_AVX512_2

Convert_RGB64_16toRGB64_8_AVX512_3:
	test w,6
	jz short Convert_RGB64_16toRGB64_8_AVX512_4
	
	mov ecx,w
	and ecx,7
	shr ecx,1
Convert_RGB64_16toRGB64_8_AVX512_6:
	vmovdqa xmm0,XMMWORD ptr[esi+eax]
	vpaddusw xmm0,xmm0,xmm1
	vpsrlw xmm0,xmm0,8
	vmovdqa XMMWORD ptr[edi+eax],xmm0
	
	add eax,16
	loop Convert_RGB64_16toRGB64_8_AVX512_6

Convert_RGB64_16toRGB64_8_AVX512_4:
	test w,1
	jz short Convert_RGB64_16toRGB64_8_AVX512_5
	
	vmovq xmm0,qword ptr[esi+eax]
	vpaddusw xmm0,xmm0,xmm1
	vpsrlw xmm0,xmm0,8
	vmovq qword ptr[edi+eax],xmm0
	
Convert_RGB64_16toRGB64_8_AVX512_5:
	add esi,src_pitch
	add edi,dst_pitch
	dec h
	jnz short Convert_RGB64_16toRGB64_8_AVX512_1
	
	pop ebx
	pop edi
	pop esi

	ret

JPSDR_HDRTools_Convert_RGB64_16toRGB64_8_AVX512 endp	


JPSDR_HDRTools_Convert_RGB64_16toRGB64_10_AVX512 proc src:dword,dst:dword,w:dword,h:dword,
	src_pitch:dword,dst_pitch:dword

	public JPSDR_HDRTools_Convert_RGB64_16toRGB64_10_AVX512

	push esi
	push edi
	push ebx

	vmovdqa64 zmm1,ZMMWORD ptr data_w_32

	mov esi,src
	mov edi,dst
	mov ebx,w
	shr ebx,3
	mov edx,64

Convert_RGB64_16toRGB64_10_AVX512_1:
	mov ecx,ebx
	xor eax,eax
	or ecx,ecx
	jz short Convert_RGB64_16toRGB64_10_AVX512_3
	
Convert_RGB64_16toRGB64_10_AVX512_2:
	vmovdqa64 zmm0,ZMMWORD ptr[esi+eax]
	vpaddusw zmm0,zmm0,zmm1
	vpsrlw zmm0,zmm0,6
	vmovdqa64 ZMMWORD ptr[edi+eax],zmm0
	add eax,edx
	loop Convert_RGB64_16toRGB64_10_AVX512_2

Convert_RGB64_16toRGB64_10_AVX512_3:
	test w,6
	jz short Convert_RGB64_16toRGB64_10_AVX512_4
	
	mov ecx,w
	and ecx,7
	shr ecx,1
Convert_RGB64_16toRGB64_10_AVX512_6:
	vmovdqa xmm0,XMMWORD ptr[esi+eax]
	vpaddusw xmm0,xmm0,xmm1
	vpsrlw xmm0,xmm0,6
	vmovdqa XMMWORD ptr[edi+eax],xmm0
	
	add eax,16
	loop Convert_RGB64_16toRGB64_10_AVX512_6

Convert_RGB64_16toRGB64_10_AVX512_4:
	test w,1
	jz short Convert_RGB64_16toRGB64_10_AVX512_5
	
	vmovq xmm0,qword ptr[esi+eax]
	vpaddusw xmm0,xmm0,xmm1
	vpsrlw xmm0,xmm0,6
	vmovq qword ptr[edi+eax],xmm0
	
Convert_RGB64_16toRGB64_10_AVX512_5:
	add esi,src_pitch
	add edi,dst_pitch
	dec h
	jnz short Convert_RGB64_16toRGB64_10_AVX512_1
	
	pop ebx
	pop edi
	pop esi

	ret

JPSDR_HDRTools_Convert_RGB64_16toRGB64_10_AVX512 endp	


JPSDR_HDRTools_Convert_RGB64_16toRGB64_12_AVX512 proc src:dword,dst:dword,w:dword,h:dword,
	src_pitch:dword,dst_pitch:dword

	public JPSDR_HDRTools_Convert_RGB64_16toRGB64_12_AVX512

	push esi
	push edi
	push ebx

	vmovdqa64 zmm1,ZMMWORD ptr data_w_8

	mov esi,src
	mov edi,dst
	mov ebx,w
	shr ebx,3
	mov edx,64

Convert_RGB64_16toRGB64_12_AVX512_1:
	mov ecx,ebx
	xor eax,eax
	or ecx,ecx
	jz short Convert_RGB64_16toRGB64_12_AVX512_3
	
Convert_RGB64_16toRGB64_12_AVX512_2:
	vmovdqa64 zmm0,ZMMWORD ptr[esi+eax]
	vpaddusw zmm0,zmm0,zmm1
	vpsrlw zmm0,zmm0,4
	vmovdqa64 ZMMWORD ptr[edi+eax],zmm0
	add eax,edx
	loop Convert_RGB64_16toRGB64_12_AVX512_2

Convert_RGB64_16toRGB64_12_AVX512_3:
	test w,6
	jz short Convert_RGB64_16toRGB64_12_AVX512_4
	
	mov ecx,w
	and ecx,7
	shr ecx,1
Convert_RGB64_16toRGB64_12_AVX512_6:
	vmovdqa xmm0,XMMWORD ptr[esi+eax]
	vpaddusw xmm0,xmm0,xmm1
	vpsrlw xmm0,xmm0,4
	vmovdqa XMMWORD ptr[edi+eax],xmm0
	
	add eax,16
	loop Convert_RGB64_16toRGB64_12_AVX512_6

Convert_RGB64_16toRGB64_12_AVX512_4:
	test w,1
	jz short Convert_RGB64_16toRGB64_12_AVX512_5
	
	vmovq xmm0,qword ptr[esi+eax]
	vpaddusw xmm0,xmm0,xmm1
	vpsrlw xmm0,xmm0,4
	vmovq qword ptr[edi+eax],xmm0
	
Convert_RGB64_16toRGB64_12_AVX512_5:
	add esi,src_pitch
	add edi,dst_pitch
	dec h
	jnz short Convert_RGB64_16toRGB64_12_AVX512_1
	
	pop ebx
	pop edi
	pop esi

	ret

JPSDR_HDRTools_Convert_RGB64_16toRGB64_12_AVX512 endp


JPSDR_HDRTools_Convert_16_RGB64_HLG_OOTF_AVX512 proc dst:dword,srcY:dword,w:dword,h:dword,dst_pitch:dword,src_pitchY:dword

	public JPSDR_HDRTools_Convert_16_RGB64_HLG_OOTF_AVX512

	push esi
	push edi
	push ebx
	
	mov ebx,w
	shr ebx,2
	mov esi,srcY
	mov edi,dst
	mov edx,16
	pxor xmm4,xmm4
	
Convert_16_RGB64_HLG_OOTF_AVX512_1:
	mov ecx,ebx
	xor eax,eax
	or ecx,ecx
	jz Convert_16_RGB64_HLG_OOTF_AVX512_3
	
Convert_16_RGB64_HLG_OOTF_AVX512_2:
	vmovss xmm0,dword ptr[esi+eax]
	vmovss xmm1,dword ptr[esi+eax+4]
	vmovss xmm5,dword ptr[esi+eax+8]
	vmovss xmm6,dword ptr[esi+eax+12]

	vshufps xmm0,xmm0,xmm0,0	
	vshufps xmm1,xmm1,xmm1,0
	vshufps xmm5,xmm5,xmm5,0
	vshufps xmm6,xmm6,xmm6,0
	
	vmovdqa xmm2,XMMWORD ptr[edi+2*eax]
	vmovdqa xmm7,XMMWORD ptr[edi+2*eax+16]
	
	vinsertf128 ymm0,ymm0,xmm1,1
	vpunpckhwd xmm3,xmm2,xmm4
	vinsertf128 ymm1,ymm5,xmm6,1
	vpunpcklwd xmm2,xmm2,xmm4
	vpunpckhwd xmm6,xmm7,xmm4
	vpunpcklwd xmm7,xmm7,xmm4

	vinserti128 ymm2,ymm2,xmm3,1	
	vinserti128 ymm7,ymm7,xmm6,1	

	vinsertf32x8 zmm0,zmm0,ymm1,1
	vinserti32x8 zmm2,zmm2,ymm7,1

	vcvtdq2ps zmm2,zmm2
	vmulps zmm2,zmm2,zmm0	
	vcvtps2dq zmm2,zmm2
	
	vextracti32x8 ymm1,zmm2,1
	vextracti128 xmm3,ymm2,1
	vextracti128 xmm0,ymm1,1
	
	vpackusdw xmm2,xmm2,xmm3
	vpackusdw xmm1,xmm1,xmm0
	
	vmovdqa XMMWORD ptr[edi+2*eax],xmm2
	vmovdqa XMMWORD ptr[edi+2*eax+16],xmm1
	
	add eax,edx
	dec ecx
	jnz Convert_16_RGB64_HLG_OOTF_AVX512_2
	
Convert_16_RGB64_HLG_OOTF_AVX512_3:
	test w,3
	jz short Convert_16_RGB64_HLG_OOTF_AVX512_4
	
	mov ecx,w
	and ecx,3
Convert_16_RGB64_HLG_OOTF_AVX512_5:
	vmovss xmm0,dword ptr[esi+eax]
	vshufps xmm0,xmm0,xmm0,0
	vmovq xmm2,qword ptr[edi+2*eax]
	vpunpcklwd xmm2,xmm2,xmm4
	vcvtdq2ps xmm2,xmm2
	vmulps xmm2,xmm2,xmm0
	vcvtps2dq xmm2,xmm2
	vpackusdw xmm2,xmm2,xmm2
	vmovq qword ptr[edi+2*eax],xmm2
	add eax,4
	loop Convert_16_RGB64_HLG_OOTF_AVX512_5
	
Convert_16_RGB64_HLG_OOTF_AVX512_4:
	add edi,dst_pitch
	add esi,src_pitchY
	dec h
	jnz Convert_16_RGB64_HLG_OOTF_AVX512_1
	
	vzeroupper
	
	pop ebx
	pop edi
	pop esi

	ret

JPSDR_HDRTools_Convert_16_RGB64_HLG_OOTF_AVX512 endp


JPSDR_HDRTools_BT2446C_16_XYZ_AVX512 proc src:dword,dst1:dword,dst2:dword,w16:dword,h:dword,src_pitch:dword,
	dst_pitch1:dword,dst_pitch2:dword,ValMinX:dword,CoeffX:dword,ValMinZ:dword,CoeffZ:dword

	public JPSDR_HDRTools_BT2446C_16_XYZ_AVX512

	push esi
	push edi
	push ebx
	
	mov esi,ValMinX
	vmovss xmm2,dword ptr[esi]
	mov esi,CoeffX
	vmovss xmm3,dword ptr[esi]
	mov esi,ValMinZ
	vmovss xmm4,dword ptr[esi]
	mov esi,CoeffZ
	vmovss xmm5,dword ptr[esi]
	
	vshufps xmm2,xmm2,xmm2,0
	vshufps xmm3,xmm3,xmm3,0
	vshufps xmm4,xmm4,xmm4,0
	vshufps xmm5,xmm5,xmm5,0

	vinsertf128 ymm2,ymm2,xmm2,1
	vinsertf128 ymm3,ymm3,xmm3,1
	vinsertf128 ymm4,ymm4,xmm4,1
	vinsertf128 ymm5,ymm5,xmm5,1
	
	vinsertf32x8 zmm2,zmm2,ymm2,1
	vinsertf32x8 zmm3,zmm3,ymm3,1
	vinsertf32x8 zmm4,zmm4,ymm4,1
	vinsertf32x8 zmm5,zmm5,ymm5,1
	
	vmovdqa64 zmm6,ZMMWORD ptr data_dw_65535
	vmovdqa64 zmm7,ZMMWORD ptr data_dw_0
	vmulps zmm3,zmm3,ZMMWORD ptr data_f_65535
	vmulps zmm5,zmm5,ZMMWORD ptr data_f_65535
	
	mov esi,src
	mov edi,dst1
	mov edx,dst2
	mov ebx,64
	
BT2446C_16_XYZ_AVX512_1:
	xor eax,eax
	mov ecx,w16
BT2446C_16_XYZ_AVX512_2:
	vmovaps zmm0,ZMMWORD ptr[edi+eax]
	vmovaps zmm1,ZMMWORD ptr[edx+eax]
	vmulps zmm0,zmm0,ZMMWORD ptr[esi+eax]
	vmulps zmm1,zmm1,ZMMWORD ptr[esi+eax]
	vaddps zmm0,zmm0,zmm2
	vaddps zmm1,zmm1,zmm4
	vmulps zmm0,zmm0,zmm3
	vmulps zmm1,zmm1,zmm5
	vcvtps2dq zmm0,zmm0
	vcvtps2dq zmm1,zmm1
	vpminsd zmm0,zmm0,zmm6
	vpminsd zmm1,zmm1,zmm6
	vpmaxsd zmm0,zmm0,zmm7
	vpmaxsd zmm1,zmm1,zmm7
	vmovdqa64 ZMMWORD ptr[edi+eax],zmm0
	vmovdqa64 ZMMWORD ptr[edx+eax],zmm1
	
	add eax,ebx
	loop BT2446C_16_XYZ_AVX512_2
	
	add esi,src_pitch
	add edi,dst_pitch1
	add edx,dst_pitch2
	dec h
	jnz short BT2446C_16_XYZ_AVX512_1
	
	vzeroupper
	
	pop ebx
	pop edi
	pop esi

	ret

JPSDR_HDRTools_BT2446C_16_XYZ_AVX512 endp


end





