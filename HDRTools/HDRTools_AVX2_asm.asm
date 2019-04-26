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
;

.586
.xmm
.model flat,c

.data

align 16

data segment align(32)

data_f_1048575 real4 8 dup(1048575.0)
data_dw_1048575 dword 8 dup(1048575)
data_dw_0 dword 8 dup(0)

data_w_128 word 16 dup(128)
data_w_32 word 16 dup(32)
data_w_8 word 16 dup(8)

.code


JPSDR_HDRTools_Convert_Planar420_to_Planar422_8_AVX2 proc src1:dword,src2:dword,dst:dword,w:dword

	public JPSDR_HDRTools_Convert_Planar420_to_Planar422_8_AVX2
	
	push esi
	push edi
	push ebx
	
	vpcmpeqb ymm3,ymm3,ymm3
	
	mov edi,dst
	mov esi,src1
	mov edx,src2
	xor eax,eax
	mov ecx,w	
	mov ebx,32
	
Convert_Planar420_to_Planar422_8_AVX2_1:
	vmovdqa ymm0,YMMWORD ptr[esi+eax]
	vmovdqa ymm1,YMMWORD ptr[edx+eax]
	vpxor ymm2,ymm0,ymm3
	vpxor ymm1,ymm1,ymm3
	vpavgb ymm2,ymm2,ymm1
	vpxor ymm2,ymm2,ymm3
	vpavgb ymm2,ymm2,ymm0
	
	vmovdqa YMMWORD ptr[edi+eax],ymm2
	add eax,ebx
	loop Convert_Planar420_to_Planar422_8_AVX2_1
	
	vzeroupper
	
	pop ebx
	pop edi
	pop esi

	ret

JPSDR_HDRTools_Convert_Planar420_to_Planar422_8_AVX2 endp


JPSDR_HDRTools_Convert_Planar420_to_Planar422_16_AVX2 proc src1:dword,src2:dword,dst:dword,w:dword

	public JPSDR_HDRTools_Convert_Planar420_to_Planar422_16_AVX2
	
	push esi
	push edi
	push ebx
	
	vpcmpeqb ymm3,ymm3,ymm3
	
	mov edi,dst
	mov esi,src1
	mov edx,src2
	xor eax,eax	
	mov ecx,w	
	mov ebx,32
	
Convert_Planar420_to_Planar422_16_AVX2_1:
	vmovdqa ymm0,YMMWORD ptr[esi+eax]
	vmovdqa ymm1,YMMWORD ptr[edx+eax]
	vpxor ymm2,ymm0,ymm3
	vpxor ymm1,ymm1,ymm3
	vpavgw ymm2,ymm2,ymm1
	vpxor ymm2,ymm2,ymm3
	vpavgw ymm2,ymm2,ymm0
	
	vmovdqa YMMWORD ptr[edi+eax],ymm2
	add eax,ebx
	loop Convert_Planar420_to_Planar422_16_AVX2_1
	
	vzeroupper
	
	pop ebx
	pop edi
	pop esi

	ret

JPSDR_HDRTools_Convert_Planar420_to_Planar422_16_AVX2 endp


JPSDR_HDRTools_Convert_Planar422_to_Planar420_8_AVX2 proc src1:dword,src2:dword,dst:dword,w32:dword,h:dword,src_pitch2:dword,dst_pitch:dword

	public JPSDR_HDRTools_Convert_Planar422_to_Planar420_8_AVX2
	
	push esi
	push edi
	push ebx
	
	mov edi,dst
	mov esi,src1
	mov edx,src2
	mov ebx,32
	
Convert_Planar422_to_Planar420_8_AVX2_1:
	xor eax,eax
	mov ecx,w32

Convert_Planar422_to_Planar420_8_AVX2_2:
	vmovdqa ymm0,YMMWORD ptr[esi+eax]
	vpavgb ymm0,ymm0,YMMWORD ptr[edx+eax]
	
	vmovdqa YMMWORD ptr[edi+eax],ymm0
	add eax,ebx
	loop Convert_Planar422_to_Planar420_8_AVX2_2
	
	add esi,src_pitch2
	add edx,src_pitch2
	add edi,dst_pitch
	dec h
	jnz short Convert_Planar422_to_Planar420_8_AVX2_1
	
	vzeroupper
	
	pop ebx
	pop edi
	pop esi

	ret

JPSDR_HDRTools_Convert_Planar422_to_Planar420_8_AVX2 endp


JPSDR_HDRTools_Convert_Planar422_to_Planar420_16_AVX2 proc src1:dword,src2:dword,dst:dword,w16:dword,h:dword,src_pitch2:dword,dst_pitch:dword

	public JPSDR_HDRTools_Convert_Planar422_to_Planar420_16_AVX2
	
	push esi
	push edi
	push ebx
	
	mov edi,dst
	mov esi,src1
	mov edx,src2
	mov ebx,32
	
Convert_Planar422_to_Planar420_16_AVX2_1:
	xor eax,eax
	mov ecx,w16

Convert_Planar422_to_Planar420_16_AVX2_2:
	vmovdqa ymm0,YMMWORD ptr[esi+eax]
	vpavgw ymm0,ymm0,YMMWORD ptr[edx+eax]
	
	vmovdqa YMMWORD ptr[edi+eax],ymm0
	add eax,ebx
	loop Convert_Planar422_to_Planar420_16_AVX2_2
	
	add esi,src_pitch2
	add edx,src_pitch2
	add edi,dst_pitch
	dec h
	jnz short Convert_Planar422_to_Planar420_16_AVX2_1
	
	vzeroupper
	
	pop ebx
	pop edi
	pop esi

	ret

JPSDR_HDRTools_Convert_Planar422_to_Planar420_16_AVX2 endp


JPSDR_HDRTools_Scale_20_XYZ_AVX2 proc src:dword,dst:dword,w8:dword,h:dword,src_pitch:dword,dst_pitch:dword,
	ValMin:dword,Coeff:dword

	public JPSDR_HDRTools_Scale_20_XYZ_AVX2

	push esi
	push edi
	push ebx
	
	mov esi,ValMin
	vmovss xmm1,dword ptr[esi]
	vshufps xmm1,xmm1,xmm1,0
	vinsertf128 ymm1,ymm1,xmm1,1
	mov esi,Coeff
	vmovss xmm2,dword ptr[esi]
	vshufps xmm2,xmm2,xmm2,0
	vinsertf128 ymm2,ymm2,xmm2,1
	
	vmovdqa ymm3,YMMWORD ptr data_dw_1048575
	vmovdqa ymm4,YMMWORD ptr data_dw_0
	vmulps ymm2,ymm2,YMMWORD ptr data_f_1048575
	
	mov esi,src
	mov edi,dst
	mov ebx,w8
	mov edx,32
	
Scale_20_XYZ_AVX2_1:
	mov ecx,ebx
	xor eax,eax
Scale_20_XYZ_AVX2_2:	
	vaddps ymm0,ymm1,YMMWORD ptr [esi+eax]
	vmulps ymm0,ymm0,ymm2
	vcvtps2dq ymm0,ymm0
	vpminsd ymm0,ymm0,ymm3
	vpmaxsd ymm0,ymm0,ymm4
	vmovdqa YMMWORD ptr [edi+eax],ymm0
	
	add eax,edx
	loop Scale_20_XYZ_AVX2_2
	
	add esi,src_pitch
	add edi,dst_pitch
	dec h
	jnz short Scale_20_XYZ_AVX2_1
	
	vzeroupper
	
	pop ebx
	pop edi
	pop esi

	ret

JPSDR_HDRTools_Scale_20_XYZ_AVX2 endp


JPSDR_HDRTools_Scale_20_RGB_AVX2 proc src:dword,dst:dword,w8:dword,h:dword,src_pitch:dword,dst_pitch:dword

	public JPSDR_HDRTools_Scale_20_RGB_AVX2

	push esi
	push edi
	push ebx
	
	vmovaps ymm1,YMMWORD ptr data_f_1048575
	vmovdqa ymm2,YMMWORD ptr data_dw_1048575
	vmovdqa ymm3,YMMWORD ptr data_dw_0
	
	mov esi,src
	mov edi,dst
	mov ebx,w8
	mov edx,32
	
Scale_20_RGB_AVX2_1:
	mov ecx,ebx
	xor eax,eax
Scale_20_RGB_AVX2_2:	
	vmulps ymm0,ymm1,YMMWORD ptr [esi+eax]
	vcvtps2dq ymm0,ymm0
	vpminsd ymm0,ymm0,ymm2
	vpmaxsd ymm0,ymm0,ymm3
	vmovdqa YMMWORD ptr [edi+eax],ymm0
	
	add eax,edx
	loop Scale_20_RGB_AVX2_2
	
	add esi,src_pitch
	add edi,dst_pitch
	dec h
	jnz short Scale_20_RGB_AVX2_1
	
	vzeroupper
	
	pop ebx
	pop edi
	pop esi

	ret

JPSDR_HDRTools_Scale_20_RGB_AVX2 endp


JPSDR_HDRTools_Convert_RGB64_16toRGB64_8_AVX2 proc src:dword,dst:dword,w:dword,h:dword,
	src_pitch:dword,dst_pitch:dword

	public JPSDR_HDRTools_Convert_RGB64_16toRGB64_8_AVX2

	push esi
	push edi
	push ebx

	vmovdqa ymm1,YMMWORD ptr data_w_128

	mov esi,src
	mov edi,dst
	mov ebx,w
	shr ebx,2
	mov edx,32

Convert_RGB64_16toRGB64_8_AVX2_1:
	mov ecx,ebx
	xor eax,eax
	or ecx,ecx
	jz short Convert_RGB64_16toRGB64_8_AVX2_3
	
Convert_RGB64_16toRGB64_8_AVX2_2:
	vmovdqa ymm0,YMMWORD ptr[esi+eax]
	vpaddusw ymm0,ymm0,ymm1
	vpsrlw ymm0,ymm0,8
	vmovdqa YMMWORD ptr[edi+eax],ymm0
	add eax,edx
	loop Convert_RGB64_16toRGB64_8_AVX2_2

Convert_RGB64_16toRGB64_8_AVX2_3:
	test w,2
	jz short Convert_RGB64_16toRGB64_8_AVX2_4
	
	vmovdqa xmm0,XMMWORD ptr[esi+eax]
	vpaddusw xmm0,xmm0,xmm1
	vpsrlw xmm0,xmm0,8
	vmovdqa XMMWORD ptr[edi+eax],xmm0
	
	add eax,16

Convert_RGB64_16toRGB64_8_AVX2_4:
	test w,1
	jz short Convert_RGB64_16toRGB64_8_AVX2_5
	
	vmovq xmm0,qword ptr[esi+eax]
	vpaddusw xmm0,xmm0,xmm1
	vpsrlw xmm0,xmm0,8
	vmovq qword ptr[edi+eax],xmm0
	
Convert_RGB64_16toRGB64_8_AVX2_5:
	add esi,src_pitch
	add edi,dst_pitch
	dec h
	jnz short Convert_RGB64_16toRGB64_8_AVX2_1
	
	pop ebx
	pop edi
	pop esi

	ret

JPSDR_HDRTools_Convert_RGB64_16toRGB64_8_AVX2 endp	


JPSDR_HDRTools_Convert_RGB64_16toRGB64_10_AVX2 proc src:dword,dst:dword,w:dword,h:dword,
	src_pitch:dword,dst_pitch:dword

	public JPSDR_HDRTools_Convert_RGB64_16toRGB64_10_AVX2

	push esi
	push edi
	push ebx

	vmovdqa ymm1,YMMWORD ptr data_w_32

	mov esi,src
	mov edi,dst
	mov ebx,w
	shr ebx,2
	mov edx,32

Convert_RGB64_16toRGB64_10_AVX2_1:
	mov ecx,ebx
	xor eax,eax
	or ecx,ecx
	jz short Convert_RGB64_16toRGB64_10_AVX2_3
	
Convert_RGB64_16toRGB64_10_AVX2_2:
	vmovdqa ymm0,YMMWORD ptr[esi+eax]
	vpaddusw ymm0,ymm0,ymm1
	vpsrlw ymm0,ymm0,6
	vmovdqa YMMWORD ptr[edi+eax],ymm0
	add eax,edx
	loop Convert_RGB64_16toRGB64_10_AVX2_2

Convert_RGB64_16toRGB64_10_AVX2_3:
	test w,2
	jz short Convert_RGB64_16toRGB64_10_AVX2_4
	
	vmovdqa xmm0,XMMWORD ptr[esi+eax]
	vpaddusw xmm0,xmm0,xmm1
	vpsrlw xmm0,xmm0,6
	vmovdqa XMMWORD ptr[edi+eax],xmm0
	
	add eax,16

Convert_RGB64_16toRGB64_10_AVX2_4:
	test w,1
	jz short Convert_RGB64_16toRGB64_10_AVX2_5
	
	vmovq xmm0,qword ptr[esi+eax]
	vpaddusw xmm0,xmm0,xmm1
	vpsrlw xmm0,xmm0,6
	vmovq qword ptr[edi+eax],xmm0
	
Convert_RGB64_16toRGB64_10_AVX2_5:
	add esi,src_pitch
	add edi,dst_pitch
	dec h
	jnz short Convert_RGB64_16toRGB64_10_AVX2_1
	
	pop ebx
	pop edi
	pop esi

	ret

JPSDR_HDRTools_Convert_RGB64_16toRGB64_10_AVX2 endp	


JPSDR_HDRTools_Convert_RGB64_16toRGB64_12_AVX2 proc src:dword,dst:dword,w:dword,h:dword,
	src_pitch:dword,dst_pitch:dword

	public JPSDR_HDRTools_Convert_RGB64_16toRGB64_12_AVX2

	push esi
	push edi
	push ebx

	vmovdqa ymm1,YMMWORD ptr data_w_8

	mov esi,src
	mov edi,dst
	mov ebx,w
	shr ebx,2
	mov edx,32

Convert_RGB64_16toRGB64_12_AVX2_1:
	mov ecx,ebx
	xor eax,eax
	or ecx,ecx
	jz short Convert_RGB64_16toRGB64_12_AVX2_3
	
Convert_RGB64_16toRGB64_12_AVX2_2:
	vmovdqa ymm0,YMMWORD ptr[esi+eax]
	vpaddusw ymm0,ymm0,ymm1
	vpsrlw ymm0,ymm0,4
	vmovdqa YMMWORD ptr[edi+eax],ymm0
	add eax,edx
	loop Convert_RGB64_16toRGB64_12_AVX2_2

Convert_RGB64_16toRGB64_12_AVX2_3:
	test w,2
	jz short Convert_RGB64_16toRGB64_12_AVX2_4
	
	vmovdqa xmm0,XMMWORD ptr[esi+eax]
	vpaddusw xmm0,xmm0,xmm1
	vpsrlw xmm0,xmm0,4
	vmovdqa XMMWORD ptr[edi+eax],xmm0
	
	add eax,16

Convert_RGB64_16toRGB64_12_AVX2_4:
	test w,1
	jz short Convert_RGB64_16toRGB64_12_AVX2_5
	
	vmovq xmm0,qword ptr[esi+eax]
	vpaddusw xmm0,xmm0,xmm1
	vpsrlw xmm0,xmm0,4
	vmovq qword ptr[edi+eax],xmm0
	
Convert_RGB64_16toRGB64_12_AVX2_5:
	add esi,src_pitch
	add edi,dst_pitch
	dec h
	jnz short Convert_RGB64_16toRGB64_12_AVX2_1
	
	pop ebx
	pop edi
	pop esi

	ret

JPSDR_HDRTools_Convert_RGB64_16toRGB64_12_AVX2 endp


JPSDR_HDRTools_Convert_16_RGB64_HLG_OOTF_AVX2 proc dst:dword,srcY:dword,w:dword,h:dword,dst_pitch:dword,src_pitchY:dword

	public JPSDR_HDRTools_Convert_16_RGB64_HLG_OOTF_AVX2

	push esi
	push edi
	push ebx
	
	mov ebx,w
	shr ebx,1
	mov esi,srcY
	mov edi,dst
	mov edx,8
	pxor xmm4,xmm4
	
Convert_16_RGB64_HLG_OOTF_AVX2_1:
	mov ecx,ebx
	or ecx,ecx
	jz short Convert_16_RGB64_HLG_OOTF_AVX2_3
	
	xor eax,eax
Convert_16_RGB64_HLG_OOTF_AVX2_2:
	vmovss xmm0,dword ptr[esi+eax]
	vmovss xmm1,dword ptr[esi+eax+4]
	vshufps xmm0,xmm0,xmm0,0
	vshufps xmm1,xmm1,xmm1,0
	vmovdqa xmm2,XMMWORD ptr[edi+2*eax]
	vinsertf128 ymm0,ymm0,xmm1,1
	vpunpckhwd xmm3,xmm2,xmm4
	vpunpcklwd xmm2,xmm2,xmm4
	vinserti128 ymm2,ymm2,xmm3,1
	vcvtdq2ps ymm2,ymm2
	vmulps ymm2,ymm2,ymm0
	vcvtps2dq ymm2,ymm2
	vextracti128 xmm3,ymm2,1
	vpackusdw xmm2,xmm2,xmm3
	vmovdqa XMMWORD ptr[edi+2*eax],xmm2
	
	add eax,edx
	loop Convert_16_RGB64_HLG_OOTF_AVX2_2
	
Convert_16_RGB64_HLG_OOTF_AVX2_3:
	test w,1
	jz short Convert_16_RGB64_HLG_OOTF_AVX2_4
	
	vmovss xmm0,dword ptr[esi+eax]
	vshufps xmm0,xmm0,xmm0,0
	vmovq xmm2,qword ptr[edi+2*eax]
	vpunpcklwd xmm2,xmm2,xmm4
	vcvtdq2ps xmm2,xmm2
	vmulps xmm2,xmm2,xmm0
	vcvtps2dq xmm2,xmm2
	vpackusdw xmm2,xmm2,xmm2
	vmovq qword ptr[edi+2*eax],xmm2
	
Convert_16_RGB64_HLG_OOTF_AVX2_4:
	add edi,dst_pitch
	add esi,src_pitchY
	dec h
	jnz Convert_16_RGB64_HLG_OOTF_AVX2_1
	
	vzeroupper
	
	pop ebx
	pop edi
	pop esi

	ret

JPSDR_HDRTools_Convert_16_RGB64_HLG_OOTF_AVX2 endp


end





