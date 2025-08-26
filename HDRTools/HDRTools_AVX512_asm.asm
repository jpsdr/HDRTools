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

data_f_1 real4 16 dup(1.0)
data_f_0 real4 16 dup(0.0)

data_f_1048575 real4 16 dup(1048575.0)
data_f_65535 real4 16 dup(65535.0)
data_dw_1048575 dword 16 dup(1048575)
data_dw_65535 dword 16 dup(65535)
data_dw_0 dword 16 dup(0)

data_all_1 dword 16 dup(0FFFFFFFFh)

data_w_128 word 32 dup(128)
data_w_32 word 32 dup(32)
data_w_8 word 32 dup(8)

.code

;***************************************************
;**           YUV to RGB functions                **
;***************************************************

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


;***************************************************
;**           RGB to YUV functions                **
;***************************************************


JPSDR_HDRTools_Convert_LinearRGBPStoRGB64_AVX512 proc src_R:dword,src_G:dword,src_B:dword,dst:dword,w:dword,h:dword,lookup:dword,
	src_modulo_R:dword,src_modulo_G:dword,src_modulo_B:dword,dst_modulo:dword
	
	public JPSDR_HDRTools_Convert_LinearRGBPStoRGB64_AVX512
	
	push esi
	push edi
	push ebx
	
	vmovaps zmm6,ZMMWORD ptr data_f_0
	vmovaps zmm7,ZMMWORD ptr data_f_1
	
	cld	
	mov edi,dst
	mov ebx,lookup	
	
Convert_LinearRGBPStoRGB64_AVX512_1:
	mov ecx,w
Convert_LinearRGBPStoRGB64_AVX512_2:
	mov esi,src_B
	xor edx,edx
	vmaxps zmm0,zmm6,ZMMWORD ptr[esi]
	mov esi,src_G
	vminps zmm0,zmm0,zmm7
	vmaxps zmm1,zmm6,ZMMWORD ptr[esi]
	mov esi,src_R
	vminps zmm1,zmm1,zmm7
	vmaxps zmm2,zmm6,ZMMWORD ptr[esi]
	vmulps zmm0,zmm0,ZMMWORD ptr data_f_1048575
	vminps zmm2,zmm2,zmm7
	
	vmulps zmm1,zmm1,ZMMWORD ptr data_f_1048575
	vmulps zmm2,zmm2,ZMMWORD ptr data_f_1048575
	vcvtps2dq zmm0,zmm0
	vcvtps2dq zmm1,zmm1
	vcvtps2dq zmm2,zmm2
	
	; process lower part of zmm
	vpextrd eax,xmm0,0
	mov ax,word ptr[ebx+2*eax]
	stosw
	vpextrd eax,xmm1,0
	mov ax,word ptr[ebx+2*eax]
	stosw
	vpextrd eax,xmm2,0
	mov ax,word ptr[ebx+2*eax]
	stosw
	xor eax,eax
	stosw
	dec ecx
	jz Convert_LinearRGBPStoRGB64_AVX512_3
	inc edx
	
	vpextrd eax,xmm0,1
	mov ax,word ptr[ebx+2*eax]
	stosw
	vpextrd eax,xmm1,1
	mov ax,word ptr[ebx+2*eax]
	stosw
	vpextrd eax,xmm2,1
	mov ax,word ptr[ebx+2*eax]
	stosw
	xor eax,eax
	stosw
	dec ecx
	jz Convert_LinearRGBPStoRGB64_AVX512_3
	inc edx

	vpextrd eax,xmm0,2
	mov ax,word ptr[ebx+2*eax]
	stosw
	vpextrd eax,xmm1,2
	mov ax,word ptr[ebx+2*eax]
	stosw
	vpextrd eax,xmm2,2
	mov ax,word ptr[ebx+2*eax]
	stosw
	xor eax,eax
	stosw
	dec ecx
	jz Convert_LinearRGBPStoRGB64_AVX512_3
	inc edx

	vpextrd eax,xmm0,3
	mov ax,word ptr[ebx+2*eax]
	stosw
	vpextrd eax,xmm1,3
	mov ax,word ptr[ebx+2*eax]
	stosw
	vpextrd eax,xmm2,3
	mov ax,word ptr[ebx+2*eax]
	stosw
	xor eax,eax
	stosw
	dec ecx
	jz Convert_LinearRGBPStoRGB64_AVX512_3
	inc edx
	
	vextracti128 xmm3,ymm0,1
	vextracti128 xmm4,ymm1,1
	vextracti128 xmm5,ymm2,1
	
	vpextrd eax,xmm3,0
	mov ax,word ptr[ebx+2*eax]
	stosw
	vpextrd eax,xmm4,0
	mov ax,word ptr[ebx+2*eax]
	stosw
	vpextrd eax,xmm5,0
	mov ax,word ptr[ebx+2*eax]
	stosw
	xor eax,eax
	stosw
	dec ecx
	jz Convert_LinearRGBPStoRGB64_AVX512_3
	inc edx
	
	vpextrd eax,xmm3,1
	mov ax,word ptr[ebx+2*eax]
	stosw
	vpextrd eax,xmm4,1
	mov ax,word ptr[ebx+2*eax]
	stosw
	vpextrd eax,xmm5,1
	mov ax,word ptr[ebx+2*eax]
	stosw
	xor eax,eax
	stosw
	dec ecx
	jz Convert_LinearRGBPStoRGB64_AVX512_3
	inc edx
	
	vpextrd eax,xmm3,2
	mov ax,word ptr[ebx+2*eax]
	stosw
	vpextrd eax,xmm4,2
	mov ax,word ptr[ebx+2*eax]
	stosw
	vpextrd eax,xmm5,2
	mov ax,word ptr[ebx+2*eax]
	stosw
	xor eax,eax
	stosw
	dec ecx
	jz Convert_LinearRGBPStoRGB64_AVX512_3
	inc edx
	
	vpextrd eax,xmm3,3
	mov ax,word ptr[ebx+2*eax]
	stosw
	vpextrd eax,xmm4,3
	mov ax,word ptr[ebx+2*eax]
	stosw
	vpextrd eax,xmm5,3
	mov ax,word ptr[ebx+2*eax]
	stosw
	xor eax,eax
	stosw
	dec ecx
	jz Convert_LinearRGBPStoRGB64_AVX512_3
	inc edx

	; process higer part of zmm
	vextracti32x8 ymm0,zmm0,1
	vextracti32x8 ymm1,zmm1,1
	vextracti32x8 ymm2,zmm2,1

	vpextrd eax,xmm0,0
	mov ax,word ptr[ebx+2*eax]
	stosw
	vpextrd eax,xmm1,0
	mov ax,word ptr[ebx+2*eax]
	stosw
	vpextrd eax,xmm2,0
	mov ax,word ptr[ebx+2*eax]
	stosw
	xor eax,eax
	stosw
	dec ecx
	jz Convert_LinearRGBPStoRGB64_AVX512_3
	inc edx
	
	vpextrd eax,xmm0,1
	mov ax,word ptr[ebx+2*eax]
	stosw
	vpextrd eax,xmm1,1
	mov ax,word ptr[ebx+2*eax]
	stosw
	vpextrd eax,xmm2,1
	mov ax,word ptr[ebx+2*eax]
	stosw
	xor eax,eax
	stosw
	dec ecx
	jz Convert_LinearRGBPStoRGB64_AVX512_3
	inc edx

	vpextrd eax,xmm0,2
	mov ax,word ptr[ebx+2*eax]
	stosw
	vpextrd eax,xmm1,2
	mov ax,word ptr[ebx+2*eax]
	stosw
	vpextrd eax,xmm2,2
	mov ax,word ptr[ebx+2*eax]
	stosw
	xor eax,eax
	stosw
	dec ecx
	jz Convert_LinearRGBPStoRGB64_AVX512_3
	inc edx

	vpextrd eax,xmm0,3
	mov ax,word ptr[ebx+2*eax]
	stosw
	vpextrd eax,xmm1,3
	mov ax,word ptr[ebx+2*eax]
	stosw
	vpextrd eax,xmm2,3
	mov ax,word ptr[ebx+2*eax]
	stosw
	xor eax,eax
	stosw
	dec ecx
	jz Convert_LinearRGBPStoRGB64_AVX512_3
	inc edx
	
	vextracti128 xmm0,ymm0,1
	vextracti128 xmm1,ymm1,1
	vextracti128 xmm2,ymm2,1
	
	vpextrd eax,xmm0,0
	mov ax,word ptr[ebx+2*eax]
	stosw
	vpextrd eax,xmm1,0
	mov ax,word ptr[ebx+2*eax]
	stosw
	vpextrd eax,xmm2,0
	mov ax,word ptr[ebx+2*eax]
	stosw
	xor eax,eax
	stosw
	dec ecx
	jz Convert_LinearRGBPStoRGB64_AVX512_3
	inc edx
	
	vpextrd eax,xmm0,1
	mov ax,word ptr[ebx+2*eax]
	stosw
	vpextrd eax,xmm1,1
	mov ax,word ptr[ebx+2*eax]
	stosw
	vpextrd eax,xmm2,1
	mov ax,word ptr[ebx+2*eax]
	stosw
	xor eax,eax
	stosw
	dec ecx
	jz Convert_LinearRGBPStoRGB64_AVX512_3
	inc edx
	
	vpextrd eax,xmm0,2
	mov ax,word ptr[ebx+2*eax]
	stosw
	vpextrd eax,xmm1,2
	mov ax,word ptr[ebx+2*eax]
	stosw
	vpextrd eax,xmm2,2
	mov ax,word ptr[ebx+2*eax]
	stosw
	xor eax,eax
	stosw
	dec ecx
	jz short Convert_LinearRGBPStoRGB64_AVX512_3
	inc edx
	
	vpextrd eax,xmm0,3
	mov ax,word ptr[ebx+2*eax]
	stosw
	vpextrd eax,xmm1,3
	mov ax,word ptr[ebx+2*eax]
	stosw
	vpextrd eax,xmm2,3
	mov ax,word ptr[ebx+2*eax]
	stosw
	xor eax,eax
	stosw
	dec ecx
	jz short Convert_LinearRGBPStoRGB64_AVX512_3
	
Convert_LinearRGBPStoRGB64_AVX512_3:
	inc edx	
	shl edx,2	
	add src_B,edx
	add src_G,edx
	add src_R,edx	
	or ecx,ecx
	jnz Convert_LinearRGBPStoRGB64_AVX512_2
	
	mov eax,dst_modulo
	mov edx,src_modulo_B
	add edi,eax
	add src_B,edx
	mov eax,src_modulo_G
	mov edx,src_modulo_R
	add src_G,eax
	add src_R,edx
	dec h
	jnz Convert_LinearRGBPStoRGB64_AVX512_1
	
	vzeroupper
	
	pop ebx
	pop edi
	pop esi

	ret

JPSDR_HDRTools_Convert_LinearRGBPStoRGB64_AVX512 endp


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


;***************************************************
;**             XYZ/RGB functions                 **
;***************************************************


;***************************************************
;**               HLG functions                   **
;***************************************************


JPSDR_HDRTools_Convert_RGB64_16toRGB64_8_AVX512 proc src:dword,dst:dword,w:dword,h:dword,
	src_pitch:dword,dst_pitch:dword

	public JPSDR_HDRTools_Convert_RGB64_16toRGB64_8_AVX512

	push esi
	push edi
	push ebx

	vmovdqa64 zmm4,ZMMWORD ptr data_w_128

	mov esi,src
	mov edi,dst
	mov ebx,w
	shr ebx,3
	mov edx,256

Convert_RGB64_16toRGB64_8_AVX512_loop_1:
	mov ecx,ebx
	xor eax,eax

	shr ecx,2
	jz short Convert_RGB64_16toRGB64_8_AVX512_3
	
Convert_RGB64_16toRGB64_8_AVX512_loop_2:
	vpaddusw zmm0,zmm4,ZMMWORD ptr[esi+eax]
	vpaddusw zmm1,zmm4,ZMMWORD ptr[esi+eax+64]
	vpaddusw zmm2,zmm4,ZMMWORD ptr[esi+eax+128]
	vpaddusw zmm3,zmm4,ZMMWORD ptr[esi+eax+192]
	vpsrlw zmm0,zmm0,8
	vpsrlw zmm1,zmm1,8
	vpsrlw zmm2,zmm2,8
	vpsrlw zmm3,zmm3,8
	vmovdqa64 ZMMWORD ptr[edi+eax],zmm0
	vmovdqa64 ZMMWORD ptr[edi+eax+64],zmm1
	vmovdqa64 ZMMWORD ptr[edi+eax+128],zmm2
	vmovdqa64 ZMMWORD ptr[edi+eax+192],zmm3
	add eax,edx
	loop Convert_RGB64_16toRGB64_8_AVX512_loop_2

Convert_RGB64_16toRGB64_8_AVX512_3:
	test ebx,2
	jz short Convert_RGB64_16toRGB64_8_AVX512_4

	vpaddusw zmm0,zmm4,ZMMWORD ptr[esi+eax]
	vpaddusw zmm1,zmm4,ZMMWORD ptr[esi+eax+64]
	vpsrlw zmm0,zmm0,8
	vpsrlw zmm1,zmm1,8
	vmovdqa64 ZMMWORD ptr[edi+eax],zmm0
	vmovdqa64 ZMMWORD ptr[edi+eax+64],zmm1
	add eax,128

Convert_RGB64_16toRGB64_8_AVX512_4:
	test ebx,1
	jz short Convert_RGB64_16toRGB64_8_AVX512_5

	vpaddusw zmm0,zmm4,ZMMWORD ptr[esi+eax]
	vpsrlw zmm0,zmm0,8
	vmovdqa64 ZMMWORD ptr[edi+eax],zmm0
	add eax,64

Convert_RGB64_16toRGB64_8_AVX512_5:
	test w,6
	jz short Convert_RGB64_16toRGB64_8_AVX512_6
	
	mov ecx,w
	and ecx,7
	shr ecx,1
Convert_RGB64_16toRGB64_8_AVX512_loop_3:
	vpaddusw xmm0,xmm4,XMMWORD ptr[esi+eax]
	vpsrlw xmm0,xmm0,8
	vmovdqa XMMWORD ptr[edi+eax],xmm0
	
	add eax,16
	loop Convert_RGB64_16toRGB64_8_AVX512_loop_3

Convert_RGB64_16toRGB64_8_AVX512_6:
	test w,1
	jz short Convert_RGB64_16toRGB64_8_AVX512_7
	
	vmovq xmm0,qword ptr[esi+eax]
	vpaddusw xmm0,xmm0,xmm4
	vpsrlw xmm0,xmm0,8
	vmovq qword ptr[edi+eax],xmm0
	
Convert_RGB64_16toRGB64_8_AVX512_7:
	add esi,src_pitch
	add edi,dst_pitch
	dec h
	jnz Convert_RGB64_16toRGB64_8_AVX512_loop_1
	
	vzeroupper
	
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

	vmovdqa64 zmm4,ZMMWORD ptr data_w_32

	mov esi,src
	mov edi,dst
	mov ebx,w
	shr ebx,3
	mov edx,256

Convert_RGB64_16toRGB64_10_AVX512_loop_1:
	mov ecx,ebx
	xor eax,eax

	shr ecx,2
	jz short Convert_RGB64_16toRGB64_10_AVX512_3
	
Convert_RGB64_16toRGB64_10_AVX512_loop_2:
	vpaddusw zmm0,zmm4,ZMMWORD ptr[esi+eax]
	vpaddusw zmm1,zmm4,ZMMWORD ptr[esi+eax+64]
	vpaddusw zmm2,zmm4,ZMMWORD ptr[esi+eax+128]
	vpaddusw zmm3,zmm4,ZMMWORD ptr[esi+eax+192]
	vpsrlw zmm0,zmm0,6
	vpsrlw zmm1,zmm1,6
	vpsrlw zmm2,zmm2,6
	vpsrlw zmm3,zmm3,6
	vmovdqa64 ZMMWORD ptr[edi+eax],zmm0
	vmovdqa64 ZMMWORD ptr[edi+eax+64],zmm1
	vmovdqa64 ZMMWORD ptr[edi+eax+128],zmm2
	vmovdqa64 ZMMWORD ptr[edi+eax+192],zmm3
	add eax,edx
	loop Convert_RGB64_16toRGB64_10_AVX512_loop_2

Convert_RGB64_16toRGB64_10_AVX512_3:
	test ebx,2
	jz short Convert_RGB64_16toRGB64_10_AVX512_4

	vpaddusw zmm0,zmm4,ZMMWORD ptr[esi+eax]
	vpaddusw zmm1,zmm4,ZMMWORD ptr[esi+eax+64]
	vpsrlw zmm0,zmm0,6
	vpsrlw zmm1,zmm1,6
	vmovdqa64 ZMMWORD ptr[edi+eax],zmm0
	vmovdqa64 ZMMWORD ptr[edi+eax+64],zmm1
	add eax,128

Convert_RGB64_16toRGB64_10_AVX512_4:
	test ebx,1
	jz short Convert_RGB64_16toRGB64_10_AVX512_5

	vpaddusw zmm0,zmm4,ZMMWORD ptr[esi+eax]
	vpsrlw zmm0,zmm0,6
	vmovdqa64 ZMMWORD ptr[edi+eax],zmm0
	add eax,64

Convert_RGB64_16toRGB64_10_AVX512_5:
	test w,6
	jz short Convert_RGB64_16toRGB64_10_AVX512_6
	
	mov ecx,w
	and ecx,7
	shr ecx,1
Convert_RGB64_16toRGB64_10_AVX512_loop_3:
	vpaddusw xmm0,xmm4,XMMWORD ptr[esi+eax]
	vpsrlw xmm0,xmm0,6
	vmovdqa XMMWORD ptr[edi+eax],xmm0
	
	add eax,16
	loop Convert_RGB64_16toRGB64_10_AVX512_loop_3

Convert_RGB64_16toRGB64_10_AVX512_6:
	test w,1
	jz short Convert_RGB64_16toRGB64_10_AVX512_7
	
	vmovq xmm0,qword ptr[esi+eax]
	vpaddusw xmm0,xmm0,xmm4
	vpsrlw xmm0,xmm0,6
	vmovq qword ptr[edi+eax],xmm0
	
Convert_RGB64_16toRGB64_10_AVX512_7:
	add esi,src_pitch
	add edi,dst_pitch
	dec h
	jnz Convert_RGB64_16toRGB64_10_AVX512_loop_1
	
	vzeroupper
	
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

	vmovdqa64 zmm4,ZMMWORD ptr data_w_8

	mov esi,src
	mov edi,dst
	mov ebx,w
	shr ebx,3
	mov edx,256

Convert_RGB64_16toRGB64_12_AVX512_loop_1:
	mov ecx,ebx
	xor eax,eax

	shr ecx,2
	jz short Convert_RGB64_16toRGB64_12_AVX512_3
	
Convert_RGB64_16toRGB64_12_AVX512_loop_2:
	vpaddusw zmm0,zmm4,ZMMWORD ptr[esi+eax]
	vpaddusw zmm1,zmm4,ZMMWORD ptr[esi+eax+64]
	vpaddusw zmm2,zmm4,ZMMWORD ptr[esi+eax+128]
	vpaddusw zmm3,zmm4,ZMMWORD ptr[esi+eax+192]
	vpsrlw zmm0,zmm0,4
	vpsrlw zmm1,zmm1,4
	vpsrlw zmm2,zmm2,4
	vpsrlw zmm3,zmm3,4
	vmovdqa64 ZMMWORD ptr[edi+eax],zmm0
	vmovdqa64 ZMMWORD ptr[edi+eax+64],zmm1
	vmovdqa64 ZMMWORD ptr[edi+eax+128],zmm2
	vmovdqa64 ZMMWORD ptr[edi+eax+192],zmm3
	add eax,edx
	loop Convert_RGB64_16toRGB64_12_AVX512_loop_2

Convert_RGB64_16toRGB64_12_AVX512_3:
	test ebx,2
	jz short Convert_RGB64_16toRGB64_12_AVX512_4

	vpaddusw zmm0,zmm4,ZMMWORD ptr[esi+eax]
	vpaddusw zmm1,zmm4,ZMMWORD ptr[esi+eax+64]
	vpsrlw zmm0,zmm0,4
	vpsrlw zmm1,zmm1,4
	vmovdqa64 ZMMWORD ptr[edi+eax],zmm0
	vmovdqa64 ZMMWORD ptr[edi+eax+64],zmm1
	add eax,128

Convert_RGB64_16toRGB64_12_AVX512_4:
	test ebx,1
	jz short Convert_RGB64_16toRGB64_12_AVX512_5

	vpaddusw zmm0,zmm4,ZMMWORD ptr[esi+eax]
	vpsrlw zmm0,zmm0,4
	vmovdqa64 ZMMWORD ptr[edi+eax],zmm0
	add eax,64

Convert_RGB64_16toRGB64_12_AVX512_5:
	test w,6
	jz short Convert_RGB64_16toRGB64_12_AVX512_6
	
	mov ecx,w
	and ecx,7
	shr ecx,1
Convert_RGB64_16toRGB64_12_AVX512_loop_3:
	vpaddusw xmm0,xmm4,XMMWORD ptr[esi+eax]
	vpsrlw xmm0,xmm0,4
	vmovdqa XMMWORD ptr[edi+eax],xmm0
	
	add eax,16
	loop Convert_RGB64_16toRGB64_12_AVX512_loop_3

Convert_RGB64_16toRGB64_12_AVX512_6:
	test w,1
	jz short Convert_RGB64_16toRGB64_12_AVX512_7
	
	vmovq xmm0,qword ptr[esi+eax]
	vpaddusw xmm0,xmm0,xmm4
	vpsrlw xmm0,xmm0,4
	vmovq qword ptr[edi+eax],xmm0
	
Convert_RGB64_16toRGB64_12_AVX512_7:
	add esi,src_pitch
	add edi,dst_pitch
	dec h
	jnz Convert_RGB64_16toRGB64_12_AVX512_loop_1
	
	vzeroupper
	
	pop ebx
	pop edi
	pop esi

	ret

JPSDR_HDRTools_Convert_RGB64_16toRGB64_12_AVX512 endp


JPSDR_HDRTools_Scale_HLG_AVX512 proc src:dword,dst:dword,w16:dword,h:dword,src_pitch:dword,dst_pitch:dword,
	Coeff:dword

	public JPSDR_HDRTools_Scale_HLG_AVX512

	push esi
	push edi
	push ebx
	
	mov esi,Coeff
	vbroadcastss zmm4,dword ptr[esi]
	vmovaps zmm5,ZMMWORD ptr data_f_1
	
	mov esi,src
	mov edi,dst
	mov ebx,w16
	mov edx,256
	
Scale_HLG_AVX512_loop_1:
	xor eax,eax
	mov ecx,ebx
	
	shr ecx,2
	jz short Scale_HLG_AVX512_1

Scale_HLG_AVX512_loop_2:	
	vmulps zmm0,zmm4,ZMMWORD ptr[esi+eax]
	vmulps zmm1,zmm4,ZMMWORD ptr[esi+eax+64]
	vmulps zmm2,zmm4,ZMMWORD ptr[esi+eax+128]
	vmulps zmm3,zmm4,ZMMWORD ptr[esi+eax+192]
	vminps zmm0,zmm0,zmm5
	vminps zmm1,zmm1,zmm5
	vminps zmm2,zmm2,zmm5
	vminps zmm3,zmm3,zmm5
	vmovdqa64 ZMMWORD ptr[edi+eax],zmm0
	vmovdqa64 ZMMWORD ptr[edi+eax+64],zmm1
	vmovdqa64 ZMMWORD ptr[edi+eax+128],zmm2
	vmovdqa64 ZMMWORD ptr[edi+eax+192],zmm3

	add eax,edx
	loop Scale_HLG_AVX512_loop_2

Scale_HLG_AVX512_1:
	test ebx,2
	jz short Scale_HLG_AVX512_2

	vmulps zmm0,zmm4,ZMMWORD ptr[esi+eax]
	vmulps zmm1,zmm4,ZMMWORD ptr[esi+eax+64]
	vminps zmm0,zmm0,zmm5
	vminps zmm1,zmm1,zmm5
	vmovdqa64 ZMMWORD ptr[edi+eax],zmm0
	vmovdqa64 ZMMWORD ptr[edi+eax+64],zmm1

	add eax,128

Scale_HLG_AVX512_2:
	test ebx,1
	jz short Scale_HLG_AVX512_3

	vmulps zmm0,zmm4,ZMMWORD ptr[esi+eax]
	vminps zmm0,zmm0,zmm5
	vmovdqa64 ZMMWORD ptr[edi+eax],zmm0

Scale_HLG_AVX512_3:	
	add esi,src_pitch
	add edi,dst_pitch
	dec h
	jnz Scale_HLG_AVX512_loop_1
	
	vzeroupper
	
	pop ebx
	pop edi
	pop esi

	ret

JPSDR_HDRTools_Scale_HLG_AVX512 endp


JPSDR_HDRTools_Scale_20_float_AVX512 proc src:dword,dst:dword,w16:dword,h:dword,src_pitch:dword,dst_pitch:dword

	public JPSDR_HDRTools_Scale_20_float_AVX512

	push esi
	push edi
	push ebx

	vmovaps zmm4,ZMMWORD ptr data_f_1048575

	mov esi,src
	mov edi,dst
	mov ebx,w16
	mov edx,256

Scale_20_float_AVX512_loop_1:
	xor eax,eax
	mov ecx,ebx

	shr ecx,2
	jz short Scale_20_float_AVX512_1

Scale_20_float_AVX512_loop_2:	
	vmulps zmm0,zmm4,ZMMWORD ptr[esi+eax]
	vmulps zmm1,zmm4,ZMMWORD ptr[esi+eax+64]
	vmulps zmm2,zmm4,ZMMWORD ptr[esi+eax+128]
	vmulps zmm3,zmm4,ZMMWORD ptr[esi+eax+192]
;	vminps zmm0,zmm0,zmm4
;	vminps zmm1,zmm1,zmm4
;	vminps zmm2,zmm2,zmm4
;	vminps zmm3,zmm3,zmm4
	vcvtps2dq zmm0,zmm0
	vcvtps2dq zmm1,zmm1
	vcvtps2dq zmm2,zmm2
	vcvtps2dq zmm3,zmm3
	vmovdqa64 ZMMWORD ptr[edi+eax],zmm0
	vmovdqa64 ZMMWORD ptr[edi+eax+64],zmm1
	vmovdqa64 ZMMWORD ptr[edi+eax+128],zmm2
	vmovdqa64 ZMMWORD ptr[edi+eax+192],zmm3

	add eax,edx
	loop Scale_20_float_AVX512_loop_2

Scale_20_float_AVX512_1:
	test ebx,2
	js short Scale_20_float_AVX512_2

	vmulps zmm0,zmm4,ZMMWORD ptr[esi+eax]
	vmulps zmm1,zmm4,ZMMWORD ptr[esi+eax+64]
;	vminps zmm0,zmm0,zmm4
;	vminps zmm1,zmm1,zmm4
	vcvtps2dq zmm0,zmm0
	vcvtps2dq zmm1,zmm1
	vmovdqa64 ZMMWORD ptr[edi+eax],zmm0
	vmovdqa64 ZMMWORD ptr[edi+eax+64],zmm1

	add eax,128

Scale_20_float_AVX512_2:
	test ebx,1
	js short Scale_20_float_AVX512_3

	vmulps zmm0,zmm4,ZMMWORD ptr[esi+eax]
;	vminps zmm0,zmm0,zmm4
	vcvtps2dq zmm0,zmm0
	vmovdqa64 ZMMWORD ptr[edi+eax],zmm0

Scale_20_float_AVX512_3:
	add esi,src_pitch
	add edi,dst_pitch
	dec h
	jnz Scale_20_float_AVX512_loop_1

	vzeroupper

	pop ebx
	pop edi
	pop esi

	ret

JPSDR_HDRTools_Scale_20_float_AVX512 endp


JPSDR_HDRTools_Convert_RGBPStoPlaneY32F_AVX512 proc srcR:dword,srcG:dword,srcB:dword,dst:dword,w16:dword,h:dword,
	src_pitchR:dword,src_pitchG:dword,src_pitchB:dword,dst_pitch:dword,Coeff_R:dword,Coeff_G:dword,Coeff_B:dword
	
	public JPSDR_HDRTools_Convert_RGBPStoPlaneY32F_AVX512

	push esi
	push edi
	push ebx
	
	mov esi,Coeff_R
	vbroadcastss zmm3,dword ptr[esi]
	mov esi,Coeff_G
	vbroadcastss zmm4,dword ptr[esi]
	mov esi,Coeff_B
	vbroadcastss zmm5,dword ptr[esi]
	
	mov edi,dst
	mov ebx,w16
	mov edx,64
	
Convert_RGBPStoPlaneY32F_AVX512_1:
	mov esi,srcR
	xor eax,eax
	mov ecx,ebx
Convert_RGBPStoPlaneY32F_AVX512_2:	
	vmulps zmm0,zmm3,ZMMWORD ptr[esi+eax]
	mov esi,srcG
	vmulps zmm1,zmm4,ZMMWORD ptr[esi+eax]
	mov esi,srcB
	vmulps zmm2,zmm5,ZMMWORD ptr[esi+eax]
	vaddps zmm0,zmm0,zmm1
	mov esi,srcR
	vaddps zmm0,zmm0,zmm2
	vmovdqa64 ZMMWORD ptr[edi+eax],zmm0
	
	add eax,edx
	loop Convert_RGBPStoPlaneY32F_AVX512_2
	
	mov esi,srcR
	add esi,src_pitchR
	mov srcR,esi
	mov esi,srcG
	add esi,src_pitchG
	mov srcG,esi
	mov esi,srcB
	add esi,src_pitchB
	mov srcB,esi
	add edi,dst_pitch
	dec h
	jnz short Convert_RGBPStoPlaneY32F_AVX512_1
	
	vzeroupper
	
	pop ebx
	pop edi
	pop esi

	ret

JPSDR_HDRTools_Convert_RGBPStoPlaneY32F_AVX512 endp	


JPSDR_HDRTools_Convert_RGBPStoPlaneY32D_AVX512 proc srcR:dword,srcG:dword,srcB:dword,dst:dword,w16:dword,h:dword,
	src_pitchR:dword,src_pitchG:dword,src_pitchB:dword,dst_pitch:dword,Coeff_R:dword,Coeff_G:dword,Coeff_B:dword
	
	public JPSDR_HDRTools_Convert_RGBPStoPlaneY32D_AVX512

	push esi
	push edi
	push ebx
	
	mov esi,Coeff_R
	vbroadcastss zmm3,dword ptr[esi]
	mov esi,Coeff_G
	vbroadcastss zmm4,dword ptr[esi]
	mov esi,Coeff_B
	vbroadcastss zmm5,dword ptr[esi]
	vmovaps zmm6,ZMMWORD ptr data_f_1048575
	
	mov edi,dst
	mov ebx,w16
	mov edx,64
	
Convert_RGBPStoPlaneY32D_AVX512_1:
	mov esi,srcR
	xor eax,eax
	mov ecx,ebx
Convert_RGBPStoPlaneY32D_AVX512_2:	
	vmulps zmm0,zmm3,ZMMWORD ptr [esi+eax]
	mov esi,srcG
	vmulps zmm1,zmm4,ZMMWORD ptr [esi+eax]
	mov esi,srcB
	vmulps zmm2,zmm5,ZMMWORD ptr [esi+eax]
	vaddps zmm0,zmm0,zmm1
	mov esi,srcR
	vaddps zmm0,zmm0,zmm2
	vmulps zmm0,zmm0,zmm6
	vcvtps2dq zmm0,zmm0
	vmovdqa64 ZMMWORD ptr [edi+eax],zmm0
	
	add eax,edx
	loop Convert_RGBPStoPlaneY32D_AVX512_2
	
	mov esi,srcR
	add esi,src_pitchR
	mov srcR,esi
	mov esi,srcG
	add esi,src_pitchG
	mov srcG,esi
	mov esi,srcB
	add esi,src_pitchB
	mov srcB,esi
	add edi,dst_pitch
	dec h
	jnz short Convert_RGBPStoPlaneY32D_AVX512_1
	
	vzeroupper
	
	pop ebx
	pop edi
	pop esi

	ret

JPSDR_HDRTools_Convert_RGBPStoPlaneY32D_AVX512 endp


JPSDR_HDRTools_Convert_RGBPS_HLG_OOTF_AVX512 proc dstR:dword,dstG:dword,dstB:dword,srcY:dword,w16:dword,h:dword,
	dst_pitchR:dword,dst_pitchG:dword,dst_pitchB:dword,src_pitchY:dword

	public JPSDR_HDRTools_Convert_RGBPS_HLG_OOTF_AVX512

	push esi
	push edi
	push ebx
	
	mov edi,srcY
	mov ebx,w16
	mov edx,64
	
Convert_RGBPS_HLG_OOTF_AVX512_1:
	xor eax,eax
	mov ecx,ebx
Convert_RGBPS_HLG_OOTF_AVX512_2:
	mov esi,dstR
	vmovaps zmm0,ZMMWORD ptr[edi+eax]
	
	vmulps zmm1,zmm0,ZMMWORD ptr[esi+eax]
	vmovaps ZMMWORD ptr[esi+eax],zmm1
	mov esi,dstG
	vmulps zmm1,zmm0,ZMMWORD ptr[esi+eax]
	vmovaps ZMMWORD ptr[esi+eax],zmm1
	mov esi,dstB
	vmulps zmm1,zmm0,ZMMWORD ptr[esi+eax]
	vmovaps ZMMWORD ptr[esi+eax],zmm1
	
	add eax,edx
	loop Convert_RGBPS_HLG_OOTF_AVX512_2
	
	mov esi,dstR
	add esi,dst_pitchR
	mov dstR,esi
	mov esi,dstG
	add esi,dst_pitchG
	mov dstG,esi
	mov esi,dstB
	add esi,dst_pitchB
	mov dstB,esi
	add edi,src_pitchY
	dec h
	
	jnz short Convert_RGBPS_HLG_OOTF_AVX512_1
	
	vzeroupper
	
	pop ebx
	pop edi
	pop esi

	ret

JPSDR_HDRTools_Convert_RGBPS_HLG_OOTF_AVX512 endp


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
	vbroadcastss xmm0,dword ptr[esi+eax]
	vbroadcastss xmm1,dword ptr[esi+eax+4]
	vbroadcastss xmm5,dword ptr[esi+eax+8]
	vbroadcastss xmm6,dword ptr[esi+eax+12]
	
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
	vbroadcastss xmm0,dword ptr[esi+eax]
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


JPSDR_HDRTools_Convert_RGBPS_HLG_OOTF_Scale_AVX512 proc dstR:dword,dstG:dword,dstB:dword,srcY:dword,w16:dword,h:dword,
	dst_pitchR:dword,dst_pitchG:dword,dst_pitchB:dword,src_pitchY:dword

	public JPSDR_HDRTools_Convert_RGBPS_HLG_OOTF_Scale_AVX512

	push esi
	push edi
	push ebx
	
	vmovaps zmm2,ZMMWORD ptr data_f_1
	
	mov edi,srcY
	mov ebx,w16
	mov edx,64
	
Convert_RGBPS_HLG_OOTF_Scale_AVX512_1:
	xor eax,eax
	mov ecx,ebx
Convert_RGBPS_HLG_OOTF_Scale_AVX512_2:
	mov esi,dstR
	vmovaps zmm0,ZMMWORD ptr[edi+eax]
	
	vmulps zmm1,zmm0,ZMMWORD ptr[esi+eax]
	vminps zmm1,zmm1,zmm2
	vmovaps ZMMWORD ptr[esi+eax],zmm1
	mov esi,dstG
	vmulps zmm1,zmm0,ZMMWORD ptr[esi+eax]
	vminps zmm1,zmm1,zmm2
	vmovaps ZMMWORD ptr[esi+eax],zmm1
	mov esi,dstB
	vmulps zmm1,zmm0,ZMMWORD ptr[esi+eax]
	vminps zmm1,zmm1,zmm2
	vmovaps ZMMWORD ptr[esi+eax],zmm1
	
	add eax,edx
	loop Convert_RGBPS_HLG_OOTF_Scale_AVX512_2
	
	mov esi,dstR
	add esi,dst_pitchR
	mov dstR,esi
	mov esi,dstG
	add esi,dst_pitchG
	mov dstG,esi
	mov esi,dstB
	add esi,dst_pitchB
	mov dstB,esi
	add edi,src_pitchY
	dec h
	
	jnz short Convert_RGBPS_HLG_OOTF_Scale_AVX512_1
	
	vzeroupper
	
	pop ebx
	pop edi
	pop esi

	ret

JPSDR_HDRTools_Convert_RGBPS_HLG_OOTF_Scale_AVX512 endp


;***************************************************
;**           XYZ/HDR/SDR functions               **
;***************************************************


JPSDR_HDRTools_Scale_20_XYZ_AVX512 proc src:dword,dst:dword,w16:dword,h:dword,src_pitch:dword,dst_pitch:dword,
	ValMin:dword,Coeff:dword

	public JPSDR_HDRTools_Scale_20_XYZ_AVX512

	push esi
	push edi
	push ebx
	
	mov esi,ValMin
	vbroadcastss zmm1,dword ptr[esi]
	mov esi,Coeff
	vbroadcastss zmm2,dword ptr[esi]

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


JPSDR_HDRTools_Convert_XYZ_HDRtoSDR_32_AVX512 proc src:dword,dst:dword,w16:dword,h:dword,src_pitch:dword,dst_pitch:dword,
	Coeff:dword

	public JPSDR_HDRTools_Convert_XYZ_HDRtoSDR_32_AVX512

	push esi
	push edi
	push ebx
	
	mov esi,Coeff
	vbroadcastss zmm4,dword ptr[esi]
	
	mov esi,src
	mov edi,dst
	mov ebx,w16
	mov edx,256
	
Convert_XYZ_HDRtoSDR_32_AVX512_loop_1:
	mov ecx,ebx
	xor eax,eax

	shr ecx,2
	jz short Convert_XYZ_HDRtoSDR_32_AVX512_1

Convert_XYZ_HDRtoSDR_32_AVX512_loop_2:	
	vmulps zmm0,zmm4,ZMMWORD ptr[esi+eax]
	vmulps zmm1,zmm4,ZMMWORD ptr[esi+eax+64]
	vmulps zmm2,zmm4,ZMMWORD ptr[esi+eax+128]
	vmulps zmm3,zmm4,ZMMWORD ptr[esi+eax+192]
	vmovaps ZMMWORD ptr[edi+eax],zmm0
	vmovaps ZMMWORD ptr[edi+eax+64],zmm1
	vmovaps ZMMWORD ptr[edi+eax+128],zmm2
	vmovaps ZMMWORD ptr[edi+eax+192],zmm3
	
	add eax,edx
	loop Convert_XYZ_HDRtoSDR_32_AVX512_loop_2

Convert_XYZ_HDRtoSDR_32_AVX512_1:
	test ebx,2
	jz short Convert_XYZ_HDRtoSDR_32_AVX512_2

	vmulps zmm0,zmm4,ZMMWORD ptr[esi+eax]
	vmulps zmm1,zmm4,ZMMWORD ptr[esi+eax+64]
	vmovaps ZMMWORD ptr[edi+eax],zmm0
	vmovaps ZMMWORD ptr[edi+eax+64],zmm1
	
	add eax,128

Convert_XYZ_HDRtoSDR_32_AVX512_2:
	test ebx,1
	jz short Convert_XYZ_HDRtoSDR_32_AVX512_3

	vmulps zmm0,zmm4,ZMMWORD ptr[esi+eax]
	vmovaps ZMMWORD ptr[edi+eax],zmm0
	
Convert_XYZ_HDRtoSDR_32_AVX512_3:
	add esi,src_pitch
	add edi,dst_pitch
	dec h
	jnz Convert_XYZ_HDRtoSDR_32_AVX512_loop_1
	
	vzeroupper
	
	pop ebx
	pop edi
	pop esi

	ret

JPSDR_HDRTools_Convert_XYZ_HDRtoSDR_32_AVX512 endp	


JPSDR_HDRTools_Convert_XYZ_SDRtoHDR_32_AVX512 proc src:dword,dst:dword,w16:dword,h:dword,src_pitch:dword,dst_pitch:dword,
	Coeff:dword

	public JPSDR_HDRTools_Convert_XYZ_SDRtoHDR_32_AVX512

	push esi
	push edi
	push ebx
	
	mov esi,Coeff
	vbroadcastss zmm4,dword ptr[esi]
	
	mov esi,src
	mov edi,dst
	mov ebx,w16
	mov edx,256
	
Convert_XYZ_SDRtoHDR_32_AVX512_loop_1:
	mov ecx,ebx
	xor eax,eax

	shr ecx,2
	jz short Convert_XYZ_SDRtoHDR_32_AVX512_1

Convert_XYZ_SDRtoHDR_32_AVX512_loop_2:	
	vmulps zmm0,zmm4,ZMMWORD ptr[esi+eax]
	vmulps zmm1,zmm4,ZMMWORD ptr[esi+eax+64]
	vmulps zmm2,zmm4,ZMMWORD ptr[esi+eax+128]
	vmulps zmm3,zmm4,ZMMWORD ptr[esi+eax+192]
	vmovaps ZMMWORD ptr[edi+eax],zmm0
	vmovaps ZMMWORD ptr[edi+eax+64],zmm1
	vmovaps ZMMWORD ptr[edi+eax+128],zmm2
	vmovaps ZMMWORD ptr[edi+eax+192],zmm3
	
	add eax,edx
	loop Convert_XYZ_SDRtoHDR_32_AVX512_loop_2

Convert_XYZ_SDRtoHDR_32_AVX512_1:
	test ebx,2
	jz short Convert_XYZ_SDRtoHDR_32_AVX512_2

	vmulps zmm0,zmm4,ZMMWORD ptr[esi+eax]
	vmulps zmm1,zmm4,ZMMWORD ptr[esi+eax+64]
	vmovaps ZMMWORD ptr[edi+eax],zmm0
	vmovaps ZMMWORD ptr[edi+eax+64],zmm1
	
	add eax,128

Convert_XYZ_SDRtoHDR_32_AVX512_2:
	test ebx,1
	jz short Convert_XYZ_SDRtoHDR_32_AVX512_3

	vmulps zmm0,zmm4,ZMMWORD ptr[esi+eax]
	vmovaps ZMMWORD ptr[edi+eax],zmm0

Convert_XYZ_SDRtoHDR_32_AVX512_3:
	add esi,src_pitch
	add edi,dst_pitch
	dec h
	jnz Convert_XYZ_SDRtoHDR_32_AVX512_loop_1
	
	vzeroupper
	
	pop ebx
	pop edi
	pop esi

	ret

JPSDR_HDRTools_Convert_XYZ_SDRtoHDR_32_AVX512 endp


JPSDR_HDRTools_Convert_XYZ_Hable_HDRtoSDR_AVX512 proc src:dword,dst:dword,w16:dword,h:dword,src_pitch:dword,dst_pitch:dword,
	Coeff1:dword,Coeff2:dword,Coeff3:dword,Coeff4:dword,Coeff5:dword,Coeff6:dword

	public JPSDR_HDRTools_Convert_XYZ_Hable_HDRtoSDR_AVX512

	push esi
	push edi
	push ebx
	
	mov esi,Coeff1
	vbroadcastss zmm2,dword ptr[esi]
	mov esi,Coeff2
	vbroadcastss zmm3,dword ptr[esi]
	mov esi,Coeff3
	vbroadcastss zmm4,dword ptr[esi]
	mov esi,Coeff4
	vbroadcastss zmm5,dword ptr[esi]
	mov esi,Coeff5
	vbroadcastss zmm6,dword ptr[esi]
	mov esi,Coeff6
	vbroadcastss zmm7,dword ptr[esi]
	
	mov esi,src
	mov edi,dst
	mov ebx,w16
	mov edx,64
	
Convert_XYZ_Hable_HDRtoSDR_AVX512_1:
	xor eax,eax
	mov ecx,ebx
Convert_XYZ_Hable_HDRtoSDR_AVX512_2:
	vmovaps zmm0,ZMMWORD ptr[esi+eax]
	
	vmulps zmm1,zmm0,zmm2
	vaddps zmm1,zmm1,zmm5
	vmulps zmm1,zmm1,zmm0
	vaddps zmm1,zmm1,zmm6
	
	vmulps zmm0,zmm0,zmm2
	vaddps zmm0,zmm0,zmm3
	vmulps zmm0,zmm0,ZMMWORD ptr[esi+eax]
	vaddps zmm0,zmm0,zmm4
	vdivps zmm0,zmm0,zmm1
	vsubps zmm0,zmm0,zmm7
	
	vmovaps ZMMWORD ptr[edi+eax],zmm0
	
	add eax,edx
	loop Convert_XYZ_Hable_HDRtoSDR_AVX512_2
	
	add esi,src_pitch
	add edi,dst_pitch
	dec h
	jnz short Convert_XYZ_Hable_HDRtoSDR_AVX512_1
	
	vzeroupper
	
	pop ebx
	pop edi
	pop esi

	ret

JPSDR_HDRTools_Convert_XYZ_Hable_HDRtoSDR_AVX512 endp


JPSDR_HDRTools_Convert_XYZ_Mobius_HDRtoSDR_AVX512 proc src:dword,dst:dword,w16:dword,h:dword,src_pitch:dword,dst_pitch:dword,
	Coeff1:dword,Coeff2:dword,Coeff3:dword,Coeff4:dword

	public JPSDR_HDRTools_Convert_XYZ_Mobius_HDRtoSDR_AVX512

	push esi
	push edi
	push ebx
	
	mov esi,Coeff1
	vbroadcastss zmm4,dword ptr[esi]
	mov esi,Coeff2
	vbroadcastss zmm5,dword ptr[esi]
	mov esi,Coeff3
	vbroadcastss zmm6,dword ptr[esi]
	mov esi,Coeff4
	vbroadcastss zmm7,dword ptr[esi]
	
	mov esi,src
	mov edi,dst
	mov ebx,w16
	mov edx,64
	
Convert_XYZ_Mobius_HDRtoSDR_AVX512_1:
	xor eax,eax
	mov ecx,ebx
Convert_XYZ_Mobius_HDRtoSDR_AVX512_2:
	vmovaps zmm0,ZMMWORD ptr[esi+eax]
	
	;vcmpleps zmm2,zmm0,zmm4
	vxorps zmm2,zmm2,zmm2
	vcmpps k0,zmm0,zmm4,2
	vaddps zmm1,zmm0,zmm7
	vaddps zmm3,zmm0,zmm6
	vorps zmm2 {k0},zmm2,ZMMWORD ptr data_all_1
	vmulps zmm3,zmm3,zmm5
	vdivps zmm3,zmm3,zmm1
	vandps zmm0,zmm0,zmm2
	vxorps zmm2,zmm2,ZMMWORD ptr data_all_1
	vandps zmm3,zmm3,zmm2
	vorps zmm0,zmm0,zmm3
	
	vmovaps ZMMWORD ptr [edi+eax],zmm0
	
	add eax,edx
	loop Convert_XYZ_Mobius_HDRtoSDR_AVX512_2
	
	add esi,src_pitch
	add edi,dst_pitch
	dec h
	jnz short Convert_XYZ_Mobius_HDRtoSDR_AVX512_1
	
	vzeroupper
	
	pop ebx
	pop edi
	pop esi

	ret

JPSDR_HDRTools_Convert_XYZ_Mobius_HDRtoSDR_AVX512 endp


JPSDR_HDRTools_Convert_XYZ_Reinhard_HDRtoSDR_AVX512 proc src:dword,dst:dword,w16:dword,h:dword,src_pitch:dword,dst_pitch:dword,
	Coeff1:dword,Coeff2:dword

	public JPSDR_HDRTools_Convert_XYZ_Reinhard_HDRtoSDR_AVX512

	push esi
	push edi
	push ebx
	
	mov esi,Coeff1
	vbroadcastss zmm4,dword ptr[esi]
	mov esi,Coeff2
	vbroadcastss zmm5,dword ptr[esi]
	
	mov esi,src
	mov edi,dst
	mov ebx,w16
	mov edx,128
	
Convert_XYZ_Reinhard_HDRtoSDR_AVX512_loop_1:
	mov ecx,ebx
	xor eax,eax

	shr ecx,1
	jz short Convert_XYZ_Reinhard_HDRtoSDR_AVX512_1

Convert_XYZ_Reinhard_HDRtoSDR_AVX512_loop_2:
	vmovaps zmm0,ZMMWORD ptr[esi+eax]
	vmovaps zmm2,ZMMWORD ptr[esi+eax+64]
	
	vaddps zmm1,zmm0,zmm5
	vaddps zmm3,zmm2,zmm5
	vdivps zmm0,zmm0,zmm1
	vdivps zmm2,zmm2,zmm3
	vmulps zmm0,zmm0,zmm4
	vmulps zmm2,zmm2,zmm4
	
	vmovaps ZMMWORD ptr [edi+eax],zmm0
	vmovaps ZMMWORD ptr [edi+eax+64],zmm2
	
	add eax,edx
	loop Convert_XYZ_Reinhard_HDRtoSDR_AVX512_loop_2

Convert_XYZ_Reinhard_HDRtoSDR_AVX512_1:
	test ebx,1
	jz short Convert_XYZ_Reinhard_HDRtoSDR_AVX512_2

	vmovaps zmm0,ZMMWORD ptr[esi+eax]
	
	vaddps zmm1,zmm0,zmm3
	vdivps zmm0,zmm0,zmm1
	vmulps zmm0,zmm0,zmm2
	
	vmovaps ZMMWORD ptr [edi+eax],zmm0

Convert_XYZ_Reinhard_HDRtoSDR_AVX512_2:	
	add esi,src_pitch
	add edi,dst_pitch
	dec h
	jnz Convert_XYZ_Reinhard_HDRtoSDR_AVX512_loop_1
	
	vzeroupper
	
	pop ebx
	pop edi
	pop esi

	ret

JPSDR_HDRTools_Convert_XYZ_Reinhard_HDRtoSDR_AVX512 endp


JPSDR_HDRTools_BT2446C_16_XYZ_AVX512 proc src:dword,dst1:dword,dst2:dword,w16:dword,h:dword,src_pitch:dword,
	dst_pitch1:dword,dst_pitch2:dword,ValMinX:dword,CoeffX:dword,ValMinZ:dword,CoeffZ:dword

	public JPSDR_HDRTools_BT2446C_16_XYZ_AVX512

	push esi
	push edi
	push ebx
	
	mov esi,ValMinX
	vbroadcastss zmm2,dword ptr[esi]
	mov esi,CoeffX
	vbroadcastss zmm3,dword ptr[esi]
	mov esi,ValMinZ
	vbroadcastss zmm4,dword ptr[esi]
	mov esi,CoeffZ
	vbroadcastss zmm5,dword ptr[esi]
	
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


JPSDR_HDRTools_BT2446C_32_XYZ_AVX512 proc src1:dword,src2:dword,dst1:dword,dst2:dword,w16:dword,h:dword,src_pitch1:dword,
	src_pitch2:dword,dst_pitch1:dword,dst_pitch2:dword

	public JPSDR_HDRTools_BT2446C_32_XYZ_AVX512

	push esi
	push edi
	push ebx
	
	mov esi,src1
	mov ebx,src2
	mov edi,dst1
	mov edx,dst2
	
BT2446C_32_XYZ_AVX512_loop_1:
	mov ecx,w16
	xor eax,eax

	shr ecx,1
	jz short BT2446C_32_XYZ_AVX512_1

BT2446C_32_XYZ_AVX512_loop_2:	
	vmovaps zmm2,ZMMWORD ptr[edi+eax]
	vmovaps zmm5,ZMMWORD ptr[edi+eax+64]
	vmulps zmm0,zmm2,ZMMWORD ptr[esi+eax]
	vmulps zmm3,zmm5,ZMMWORD ptr[esi+eax+64]
	vmulps zmm1,zmm2,ZMMWORD ptr[ebx+eax]
	vmulps zmm4,zmm5,ZMMWORD ptr[ebx+eax+64]
	vmovaps ZMMWORD ptr[edi+eax],zmm0
	vmovaps ZMMWORD ptr[edi+eax+64],zmm3
	vmovaps ZMMWORD ptr[edx+eax],zmm1
	vmovaps ZMMWORD ptr[edx+eax+64],zmm4
	
	add eax,128
	loop BT2446C_32_XYZ_AVX512_loop_2

BT2446C_32_XYZ_AVX512_1:
	test w16,1
	jz short BT2446C_32_XYZ_AVX512_2

	vmovaps zmm2,ZMMWORD ptr[edi+eax]
	vmulps zmm0,zmm2,ZMMWORD ptr[esi+eax]
	vmulps zmm1,zmm2,ZMMWORD ptr[ebx+eax]
	vmovaps ZMMWORD ptr[edi+eax],zmm0
	vmovaps ZMMWORD ptr[edx+eax],zmm1

BT2446C_32_XYZ_AVX512_2:
	add esi,src_pitch1
	add ebx,src_pitch2
	add edi,dst_pitch1
	add edx,dst_pitch2
	dec h
	jnz BT2446C_32_XYZ_AVX512_loop_1
	
	pop ebx
	pop edi
	pop esi

	ret

JPSDR_HDRTools_BT2446C_32_XYZ_AVX512 endp


JPSDR_HDRTools_Convert_XYZ_ACES_HDRtoSDR_AVX512 proc src:dword,dst:dword,w16:dword,h:dword,src_pitch:dword,dst_pitch:dword,
	Coeff1:dword,Coeff2:dword,Coeff3:dword,Coeff4:dword,Coeff5:dword

	public JPSDR_HDRTools_Convert_XYZ_ACES_HDRtoSDR_AVX512

	push esi
	push edi
	push ebx
	
	mov esi,Coeff1
	vbroadcastss zmm3,dword ptr[esi]
	mov esi,Coeff2
	vbroadcastss zmm4,dword ptr[esi]
	mov esi,Coeff3
	vbroadcastss zmm5,dword ptr[esi]
	mov esi,Coeff4
	vbroadcastss zmm6,dword ptr[esi]
	mov esi,Coeff5
	vbroadcastss zmm7,dword ptr[esi]
	
	mov esi,src
	mov edi,dst
	mov ebx,w16
	mov edx,64
	
Convert_XYZ_ACES_HDRtoSDR_AVX512_1:
	xor eax,eax
	mov ecx,ebx
Convert_XYZ_ACES_HDRtoSDR_AVX512_2:
	vmovaps zmm0,ZMMWORD ptr[esi+eax]
	
	vmulps zmm2,zmm0,zmm5
	vaddps zmm1,zmm0,zmm3
	vaddps zmm2,zmm2,zmm6
	vmulps zmm1,zmm1,zmm0
	vmulps zmm2,zmm2,zmm0
	vaddps zmm1,zmm1,zmm4
	vaddps zmm2,zmm2,zmm7
	
	vdivps zmm1,zmm1,zmm2
	
	vmovaps ZMMWORD ptr[edi+eax],zmm1
	
	add eax,edx
	loop Convert_XYZ_ACES_HDRtoSDR_AVX512_2
	
	add esi,src_pitch
	add edi,dst_pitch
	dec h
	jnz short Convert_XYZ_ACES_HDRtoSDR_AVX512_1
	
	vzeroupper
	
	pop ebx
	pop edi
	pop esi

	ret

JPSDR_HDRTools_Convert_XYZ_ACES_HDRtoSDR_AVX512 endp


JPSDR_HDRTools_Convert_RGB_ACES_HDRtoSDR_AVX512 proc src:dword,dst:dword,w16:dword,h:dword,src_pitch:dword,dst_pitch:dword,
	Coeff1:dword,Coeff2:dword,Coeff3:dword,Coeff4:dword,Coeff5:dword

	public JPSDR_HDRTools_Convert_RGB_ACES_HDRtoSDR_AVX512

	push esi
	push edi
	push ebx
	
	mov esi,Coeff1
	vbroadcastss zmm3,dword ptr[esi]
	mov esi,Coeff2
	vbroadcastss zmm4,dword ptr[esi]
	mov esi,Coeff3
	vbroadcastss zmm5,dword ptr[esi]
	mov esi,Coeff4
	vbroadcastss zmm6,dword ptr[esi]
	mov esi,Coeff5
	vbroadcastss zmm7,dword ptr[esi]
	
	mov esi,src
	mov edi,dst
	mov ebx,w16
	mov edx,64
	
Convert_RGB_ACES_HDRtoSDR_AVX512_1:
	xor eax,eax
	mov ecx,ebx
Convert_RGB_ACES_HDRtoSDR_AVX512_2:
	vmovaps zmm0,ZMMWORD ptr[esi+eax]
	
	vmulps zmm2,zmm0,zmm5
	vmulps zmm1,zmm0,zmm3
	vaddps zmm2,zmm2,zmm6
	vaddps zmm1,zmm1,zmm4
	vmulps zmm2,zmm2,zmm0
	vmulps zmm1,zmm1,zmm0
	vaddps zmm2,zmm2,zmm7
	
	vdivps zmm1,zmm1,zmm2
	
	vmovaps ZMMWORD ptr[edi+eax],zmm1
	
	add eax,edx
	loop Convert_RGB_ACES_HDRtoSDR_AVX512_2
	
	add esi,src_pitch
	add edi,dst_pitch
	dec h
	jnz short Convert_RGB_ACES_HDRtoSDR_AVX512_1
	
	vzeroupper
	
	pop ebx
	pop edi
	pop esi

	ret

JPSDR_HDRTools_Convert_RGB_ACES_HDRtoSDR_AVX512 endp

end





