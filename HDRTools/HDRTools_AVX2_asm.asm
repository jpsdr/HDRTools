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

.xmm
.model flat,c

.data

align 16

data segment align(32)

data_f_0 real4 8 dup(0.0)
data_f_1 real4 8 dup(1.0)

data_f_1048575 real4 8 dup(1048575.0)
data_f_65535 real4 8 dup(65535.0)
data_dw_1048575 dword 8 dup(1048575)
data_dw_65535 dword 8 dup(65535)
data_dw_0 dword 8 dup(0)

data_w_128 word 16 dup(128)
data_w_32 word 16 dup(32)
data_w_8 word 16 dup(8)

.code


;***************************************************
;**           YUV to RGB functions                **
;***************************************************


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


;***************************************************
;**           RGB to YUV functions                **
;***************************************************


JPSDR_HDRTools_Convert_LinearRGBPStoRGB64_AVX2 proc src_R:dword,src_G:dword,src_B:dword,dst:dword,w:dword,h:dword,lookup:dword,
	src_modulo_R:dword,src_modulo_G:dword,src_modulo_B:dword,dst_modulo:dword
	
	public JPSDR_HDRTools_Convert_LinearRGBPStoRGB64_AVX2
	
	push esi
	push edi
	push ebx
	
	vmovaps ymm3,YMMWORD ptr data_f_1048575
	vmovaps ymm4,YMMWORD ptr data_f_0
	vmovaps ymm5,YMMWORD ptr data_f_1
	
	cld	
	mov edi,dst
	mov ebx,lookup	
	
Convert_LinearRGBPStoRGB64_AVX2_1:
	mov ecx,w
Convert_LinearRGBPStoRGB64_AVX2_2:
	mov esi,src_B
	xor edx,edx
	vmaxps ymm0,ymm4,YMMWORD ptr[esi]
	mov esi,src_G
	vminps ymm0,ymm0,ymm5
	vmaxps ymm1,ymm4,YMMWORD ptr[esi]
	mov esi,src_R
	vminps ymm1,ymm1,ymm5
	vmaxps ymm2,ymm4,YMMWORD ptr[esi]
	vmulps ymm0,ymm0,ymm3
	vminps ymm2,ymm2,ymm5
	
	vmulps ymm1,ymm1,ymm3
	vmulps ymm2,ymm2,ymm3
	vcvtps2dq ymm0,ymm0
	vcvtps2dq ymm1,ymm1
	vcvtps2dq ymm2,ymm2
	
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
	jz Convert_LinearRGBPStoRGB64_AVX2_3
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
	jz Convert_LinearRGBPStoRGB64_AVX2_3
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
	jz Convert_LinearRGBPStoRGB64_AVX2_3
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
	jz Convert_LinearRGBPStoRGB64_AVX2_3
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
	jz Convert_LinearRGBPStoRGB64_AVX2_3
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
	jz short Convert_LinearRGBPStoRGB64_AVX2_3
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
	jz short Convert_LinearRGBPStoRGB64_AVX2_3
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
	
Convert_LinearRGBPStoRGB64_AVX2_3:
	inc edx	
	shl edx,2	
	add src_B,edx
	add src_G,edx
	add src_R,edx	
	or ecx,ecx
	jnz Convert_LinearRGBPStoRGB64_AVX2_2
	
	mov eax,dst_modulo
	mov edx,src_modulo_B
	add edi,eax
	add src_B,edx
	mov eax,src_modulo_G
	mov edx,src_modulo_R
	add src_G,eax
	add src_R,edx
	dec h
	jnz Convert_LinearRGBPStoRGB64_AVX2_1
	
	vzeroupper
	
	pop ebx
	pop edi
	pop esi

	ret

JPSDR_HDRTools_Convert_LinearRGBPStoRGB64_AVX2 endp


JPSDR_HDRTools_Convert_RGBPStoRGB64_AVX2 proc src_R:dword,src_G:dword,src_B:dword,dst:dword,w:dword,h:dword,
	src_pitch_R:dword,src_pitch_G:dword,src_pitch_B:dword,dst_pitch:dword
	
	public JPSDR_HDRTools_Convert_RGBPStoRGB64_AVX2
	
	push esi
	push edi
	push ebx
	
	vmovaps ymm3,YMMWORD ptr data_f_65535
	vpxor xmm4,xmm4,xmm4

	mov esi,src_B
	mov ebx,src_G
	mov edx,src_R
	mov edi,dst
	
Convert_RGBPStoRGB64_AVX2_1:
	mov ecx,w
	xor eax,eax
	shr ecx,3
	jz Convert_RGBPStoRGB64_AVX2_3
	
Convert_RGBPStoRGB64_AVX2_2:
	vmulps ymm0,ymm3,YMMWORD ptr[esi+4*eax]
	vmulps ymm1,ymm3,YMMWORD ptr[edx+4*eax]
	vmulps ymm2,ymm3,YMMWORD ptr[ebx+4*eax]
	vcvtps2dq ymm0,ymm0
	vcvtps2dq ymm1,ymm1
	vcvtps2dq ymm2,ymm2
	
	vextracti128 xmm5,ymm0,1
	vextracti128 xmm6,ymm1,1
	vextracti128 xmm7,ymm2,1	
	
	packusdw xmm0,xmm0					;0000B4B3B2B1
	packusdw xmm1,xmm1					;0000R4R3R2R1
	packusdw xmm2,xmm2					;0000G4G3G2G1
	
	vpunpcklwd xmm0,xmm0,xmm1             	;R4B4R3B3R2B2R1B1
	vpunpcklwd xmm2,xmm2,xmm4             	;0G40G30G20G1
	vpunpckhwd xmm1,xmm0,xmm2             	;0R4G4B40R3G3B3
	vpunpcklwd xmm0,xmm0,xmm2             	;0R2G2B20R1G1B1
	
	packusdw xmm5,xmm5					;0000B8B7B6B5
	packusdw xmm6,xmm6					;0000R8R7R6R5
	packusdw xmm7,xmm7					;0000G8G7G6G5
	
	vpunpcklwd xmm5,xmm5,xmm6             	;R8B8R7B7R6B6R5B5
	vpunpcklwd xmm7,xmm7,xmm4             	;0G80G70G60G5
	vpunpckhwd xmm6,xmm5,xmm7             	;0R8G8B80R7G7B7
	vpunpcklwd xmm5,xmm5,xmm7             	;0R6G6B60R5G5B5
		
	vmovdqa XMMWORD ptr[edi+8*eax],xmm0
	vmovdqa XMMWORD ptr[edi+8*eax+16],xmm1
	vmovdqa XMMWORD ptr[edi+8*eax+32],xmm5
	vmovdqa XMMWORD ptr[edi+8*eax+48],xmm6
	add eax,8
	dec ecx
	jnz Convert_RGBPStoRGB64_AVX2_2

Convert_RGBPStoRGB64_AVX2_3:
	mov ecx,w
	and ecx,7
	jz Convert_RGBPStoRGB64_AVX2_7
	
	vmulps ymm0,ymm3,YMMWORD ptr[esi+4*eax]
	vmulps ymm1,ymm3,YMMWORD ptr[edx+4*eax]
	vmulps ymm2,ymm3,YMMWORD ptr[ebx+4*eax]
	vcvtps2dq ymm0,ymm0
	vcvtps2dq ymm1,ymm1
	vcvtps2dq ymm2,ymm2
	
	vextracti128 xmm5,ymm0,1
	vextracti128 xmm6,ymm1,1
	vextracti128 xmm7,ymm2,1	
	
	packusdw xmm0,xmm0					;0000B4B3B2B1
	packusdw xmm1,xmm1					;0000R4R3R2R1
	packusdw xmm2,xmm2					;0000G4G3G2G1
	
	vpunpcklwd xmm0,xmm0,xmm1             	;R4B4R3B3R2B2R1B1
	vpunpcklwd xmm2,xmm2,xmm4             	;0G40G30G20G1
	vpunpckhwd xmm1,xmm0,xmm2             	;0R4G4B40R3G3B3
	vpunpcklwd xmm0,xmm0,xmm2             	;0R2G2B20R1G1B1
	
	packusdw xmm5,xmm5					;0000B8B7B6B5
	packusdw xmm6,xmm6					;0000R8R7R6R5
	packusdw xmm7,xmm7					;0000G8G7G6G5
	
	vpunpcklwd xmm5,xmm5,xmm6             	;R8B8R7B7R6B6R5B5
	vpunpcklwd xmm7,xmm7,xmm4             	;0G80G70G60G5
	vpunpckhwd xmm6,xmm5,xmm7             	;0R8G8B80R7G7B7
	vpunpcklwd xmm5,xmm5,xmm7             	;0R6G6B60R5G5B5	
	
	test ecx,4
	jnz short Convert_RGBPStoRGB64_AVX2_5
	test ecx,2
	jnz short Convert_RGBPStoRGB64_AVX2_4
	vmovq qword ptr[edi+8*eax],xmm0
	jmp short Convert_RGBPStoRGB64_AVX2_7
	
Convert_RGBPStoRGB64_AVX2_4:
	vmovdqa XMMWORD ptr[edi+8*eax],xmm0
	test ecx,1
	jz short Convert_RGBPStoRGB64_AVX2_7
	vmovq qword ptr[edi+8*eax+16],xmm1
	jmp short Convert_RGBPStoRGB64_AVX2_7
	
Convert_RGBPStoRGB64_AVX2_5:
	vmovdqa XMMWORD ptr[edi+8*eax],xmm0
	vmovdqa XMMWORD ptr[edi+8*eax+16],xmm1
	test ecx,2
	jnz short Convert_RGBPStoRGB64_AVX2_6
	test ecx,1
	jz short Convert_RGBPStoRGB64_AVX2_7
	vmovq qword ptr[edi+8*eax+32],xmm5
	jmp short Convert_RGBPStoRGB64_AVX2_7
	
Convert_RGBPStoRGB64_AVX2_6:
	vmovdqa XMMWORD ptr[edi+8*eax+32],xmm5
	test ecx,1
	jz short Convert_RGBPStoRGB64_AVX2_7
	vmovq qword ptr[edi+8*eax+48],xmm6
	
Convert_RGBPStoRGB64_AVX2_7:
	add esi,src_pitch_B
	add ebx,src_pitch_G
	add edx,src_pitch_R
	add edi,dst_pitch
	dec h
	jnz Convert_RGBPStoRGB64_AVX2_1
	
	vzeroupper
	
	pop ebx
	pop edi
	pop esi

	ret

JPSDR_HDRTools_Convert_RGBPStoRGB64_AVX2 endp


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


;***************************************************
;**             XYZ/RGB functions                 **
;***************************************************


;***************************************************
;**               HLG functions                   **
;***************************************************


JPSDR_HDRTools_Convert_RGB64_16toRGB64_8_AVX2 proc src:dword,dst:dword,w:dword,h:dword,
	src_pitch:dword,dst_pitch:dword

	public JPSDR_HDRTools_Convert_RGB64_16toRGB64_8_AVX2

	push esi
	push edi
	push ebx

	vmovdqa ymm4,YMMWORD ptr data_w_128

	mov esi,src
	mov edi,dst
	mov ebx,w
	shr ebx,2
	mov edx,128

Convert_RGB64_16toRGB64_8_AVX2_loop_1:
	mov ecx,ebx
	xor eax,eax

	shr ecx,2
	jz short Convert_RGB64_16toRGB64_8_AVX2_3
	
Convert_RGB64_16toRGB64_8_AVX2_loop_2:
	vpaddusw ymm0,ymm4,YMMWORD ptr[esi+eax]
	vpaddusw ymm1,ymm4,YMMWORD ptr[esi+eax+32]
	vpaddusw ymm2,ymm4,YMMWORD ptr[esi+eax+64]
	vpaddusw ymm3,ymm4,YMMWORD ptr[esi+eax+96]
	vpsrlw ymm0,ymm0,8
	vpsrlw ymm1,ymm1,8
	vpsrlw ymm2,ymm2,8
	vpsrlw ymm3,ymm3,8
	vmovdqa YMMWORD ptr[edi+eax],ymm0
	vmovdqa YMMWORD ptr[edi+eax+32],ymm1
	vmovdqa YMMWORD ptr[edi+eax+64],ymm2
	vmovdqa YMMWORD ptr[edi+eax+96],ymm3
	add eax,edx
	loop Convert_RGB64_16toRGB64_8_AVX2_loop_2

Convert_RGB64_16toRGB64_8_AVX2_3:
	test ebx,2
	jz short Convert_RGB64_16toRGB64_8_AVX2_4

	vpaddusw ymm0,ymm4,YMMWORD ptr[esi+eax]
	vpaddusw ymm1,ymm4,YMMWORD ptr[esi+eax+32]
	vpsrlw ymm0,ymm0,8
	vpsrlw ymm1,ymm1,8
	vmovdqa YMMWORD ptr[edi+eax],ymm0
	vmovdqa YMMWORD ptr[edi+eax+32],ymm1
	add eax,64

Convert_RGB64_16toRGB64_8_AVX2_4:
	test ebx,1
	jz short Convert_RGB64_16toRGB64_8_AVX2_5

	vpaddusw ymm0,ymm4,YMMWORD ptr[esi+eax]
	vpsrlw ymm0,ymm0,8
	vmovdqa YMMWORD ptr[edi+eax],ymm0
	add eax,32

Convert_RGB64_16toRGB64_8_AVX2_5:
	test w,2
	jz short Convert_RGB64_16toRGB64_8_AVX2_6
	
	vpaddusw xmm0,xmm4,XMMWORD ptr[esi+eax]
	vpsrlw xmm0,xmm0,8
	vmovdqa XMMWORD ptr[edi+eax],xmm0
	
	add eax,16

Convert_RGB64_16toRGB64_8_AVX2_6:
	test w,1
	jz short Convert_RGB64_16toRGB64_8_AVX2_7
	
	vmovq xmm0,qword ptr[esi+eax]
	vpaddusw xmm0,xmm0,xmm4
	vpsrlw xmm0,xmm0,8
	vmovq qword ptr[edi+eax],xmm0
	
Convert_RGB64_16toRGB64_8_AVX2_7:
	add esi,src_pitch
	add edi,dst_pitch
	dec h
	jnz Convert_RGB64_16toRGB64_8_AVX2_loop_1
	
	vzeroupper
	
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

	vmovdqa ymm4,YMMWORD ptr data_w_32

	mov esi,src
	mov edi,dst
	mov ebx,w
	shr ebx,2
	mov edx,128

Convert_RGB64_16toRGB64_10_AVX2_loop_1:
	mov ecx,ebx
	xor eax,eax

	shr ecx,2
	jz short Convert_RGB64_16toRGB64_10_AVX2_3
	
Convert_RGB64_16toRGB64_10_AVX2_loop_2:
	vpaddusw ymm0,ymm4,YMMWORD ptr[esi+eax]
	vpaddusw ymm1,ymm4,YMMWORD ptr[esi+eax+32]
	vpaddusw ymm2,ymm4,YMMWORD ptr[esi+eax+64]
	vpaddusw ymm3,ymm4,YMMWORD ptr[esi+eax+96]
	vpsrlw ymm0,ymm0,6
	vpsrlw ymm1,ymm1,6
	vpsrlw ymm2,ymm2,6
	vpsrlw ymm3,ymm3,6
	vmovdqa YMMWORD ptr[edi+eax],ymm0
	vmovdqa YMMWORD ptr[edi+eax+32],ymm1
	vmovdqa YMMWORD ptr[edi+eax+64],ymm2
	vmovdqa YMMWORD ptr[edi+eax+96],ymm3
	add eax,edx
	loop Convert_RGB64_16toRGB64_10_AVX2_loop_2

Convert_RGB64_16toRGB64_10_AVX2_3:
	test ebx,2
	jz short Convert_RGB64_16toRGB64_10_AVX2_4

	vpaddusw ymm0,ymm4,YMMWORD ptr[esi+eax]
	vpaddusw ymm1,ymm4,YMMWORD ptr[esi+eax+32]
	vpsrlw ymm0,ymm0,6
	vpsrlw ymm1,ymm1,6
	vmovdqa YMMWORD ptr[edi+eax],ymm0
	vmovdqa YMMWORD ptr[edi+eax+32],ymm1
	add eax,64

Convert_RGB64_16toRGB64_10_AVX2_4:
	test ebx,1
	jz short Convert_RGB64_16toRGB64_10_AVX2_5

	vpaddusw ymm0,ymm4,YMMWORD ptr[esi+eax]
	vpsrlw ymm0,ymm0,6
	vmovdqa YMMWORD ptr[edi+eax],ymm0
	add eax,32

Convert_RGB64_16toRGB64_10_AVX2_5:
	test w,2
	jz short Convert_RGB64_16toRGB64_10_AVX2_6

	vpaddusw xmm0,xmm4,XMMWORD ptr[esi+eax]
	vpsrlw xmm0,xmm0,6
	vmovdqa XMMWORD ptr[edi+eax],xmm0

	add eax,16

Convert_RGB64_16toRGB64_10_AVX2_6:
	test w,1
	jz short Convert_RGB64_16toRGB64_10_AVX2_7
	
	vmovq xmm0,qword ptr[esi+eax]
	vpaddusw xmm0,xmm0,xmm4
	vpsrlw xmm0,xmm0,6
	vmovq qword ptr[edi+eax],xmm0
	
Convert_RGB64_16toRGB64_10_AVX2_7:
	add esi,src_pitch
	add edi,dst_pitch
	dec h
	jnz Convert_RGB64_16toRGB64_10_AVX2_loop_1
	
	vzeroupper
	
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

	vmovdqa ymm4,YMMWORD ptr data_w_8

	mov esi,src
	mov edi,dst
	mov ebx,w
	shr ebx,2
	mov edx,128

Convert_RGB64_16toRGB64_12_AVX2_loop_1:
	mov ecx,ebx
	xor eax,eax

	shr ecx,2
	jz short Convert_RGB64_16toRGB64_12_AVX2_3
	
Convert_RGB64_16toRGB64_12_AVX2_loop_2:
	vpaddusw ymm0,ymm4,YMMWORD ptr[esi+eax]
	vpaddusw ymm1,ymm4,YMMWORD ptr[esi+eax+32]
	vpaddusw ymm2,ymm4,YMMWORD ptr[esi+eax+64]
	vpaddusw ymm3,ymm4,YMMWORD ptr[esi+eax+96]
	vpsrlw ymm0,ymm0,4
	vpsrlw ymm1,ymm1,4
	vpsrlw ymm2,ymm2,4
	vpsrlw ymm3,ymm3,4
	vmovdqa YMMWORD ptr[edi+eax],ymm0
	vmovdqa YMMWORD ptr[edi+eax+32],ymm1
	vmovdqa YMMWORD ptr[edi+eax+64],ymm2
	vmovdqa YMMWORD ptr[edi+eax+96],ymm3
	add eax,edx
	loop Convert_RGB64_16toRGB64_12_AVX2_loop_2

Convert_RGB64_16toRGB64_12_AVX2_3:
	test ebx,2
	jz short Convert_RGB64_16toRGB64_12_AVX2_4

	vpaddusw ymm0,ymm4,YMMWORD ptr[esi+eax]
	vpaddusw ymm1,ymm4,YMMWORD ptr[esi+eax+32]
	vpsrlw ymm0,ymm0,4
	vpsrlw ymm1,ymm1,4
	vmovdqa YMMWORD ptr[edi+eax],ymm0
	vmovdqa YMMWORD ptr[edi+eax+32],ymm1
	add eax,64

Convert_RGB64_16toRGB64_12_AVX2_4:
	test ebx,1
	jz short Convert_RGB64_16toRGB64_12_AVX2_5

	vpaddusw ymm0,ymm4,YMMWORD ptr[esi+eax]
	vpsrlw ymm0,ymm0,4
	vmovdqa YMMWORD ptr[edi+eax],ymm0
	add eax,32

Convert_RGB64_16toRGB64_12_AVX2_5:
	test w,2
	jz short Convert_RGB64_16toRGB64_12_AVX2_6
	
	vpaddusw xmm0,xmm4,XMMWORD ptr[esi+eax]
	vpsrlw xmm0,xmm0,4
	vmovdqa XMMWORD ptr[edi+eax],xmm0
	
	add eax,16

Convert_RGB64_16toRGB64_12_AVX2_6:
	test w,1
	jz short Convert_RGB64_16toRGB64_12_AVX2_7
	
	vmovq xmm0,qword ptr[esi+eax]
	vpaddusw xmm0,xmm0,xmm4
	vpsrlw xmm0,xmm0,4
	vmovq qword ptr[edi+eax],xmm0
	
Convert_RGB64_16toRGB64_12_AVX2_7:
	add esi,src_pitch
	add edi,dst_pitch
	dec h
	jnz Convert_RGB64_16toRGB64_12_AVX2_loop_1
	
	vzeroupper
	
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
	vpxor xmm4,xmm4,xmm4
	
Convert_16_RGB64_HLG_OOTF_AVX2_1:
	mov ecx,ebx
	xor eax,eax
	or ecx,ecx
	jz short Convert_16_RGB64_HLG_OOTF_AVX2_3
	
Convert_16_RGB64_HLG_OOTF_AVX2_2:
	vbroadcastss xmm0,dword ptr[esi+eax]
	vbroadcastss xmm1,dword ptr[esi+eax+4]
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
	
	vbroadcastss xmm0,dword ptr[esi+eax]
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


;***************************************************
;**           XYZ/HDR/SDR functions               **
;***************************************************


JPSDR_HDRTools_Scale_20_XYZ_AVX2 proc src:dword,dst:dword,w8:dword,h:dword,src_pitch:dword,dst_pitch:dword,
	ValMin:dword,Coeff:dword

	public JPSDR_HDRTools_Scale_20_XYZ_AVX2

	push esi
	push edi
	push ebx
	
	mov esi,ValMin
	vbroadcastss ymm1,dword ptr[esi]
	mov esi,Coeff
	vbroadcastss ymm2,dword ptr[esi]
	
	vmovdqa ymm3,YMMWORD ptr data_dw_1048575
	vmovdqa ymm4,YMMWORD ptr data_dw_0
	vmulps ymm2,ymm2,YMMWORD ptr data_f_1048575
	
	mov esi,src
	mov edi,dst
	mov ebx,w8
	mov edx,32
	
Scale_20_XYZ_AVX2_1:
	xor eax,eax
	mov ecx,ebx
Scale_20_XYZ_AVX2_2:	
	vaddps ymm0,ymm1,YMMWORD ptr[esi+eax]
	vmulps ymm0,ymm0,ymm2
	vcvtps2dq ymm0,ymm0
	vpminsd ymm0,ymm0,ymm3
	vpmaxsd ymm0,ymm0,ymm4
	vmovdqa YMMWORD ptr[edi+eax],ymm0
	
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
	xor eax,eax
	mov ecx,ebx
Scale_20_RGB_AVX2_2:	
	vmulps ymm0,ymm1,YMMWORD ptr[esi+eax]
	vcvtps2dq ymm0,ymm0
	vpminsd ymm0,ymm0,ymm2
	vpmaxsd ymm0,ymm0,ymm3
	vmovdqa YMMWORD ptr[edi+eax],ymm0
	
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


JPSDR_HDRTools_BT2446C_16_XYZ_AVX2 proc src:dword,dst1:dword,dst2:dword,w8:dword,h:dword,src_pitch:dword,
	dst_pitch1:dword,dst_pitch2:dword,ValMinX:dword,CoeffX:dword,ValMinZ:dword,CoeffZ:dword

	public JPSDR_HDRTools_BT2446C_16_XYZ_AVX2

	push esi
	push edi
	push ebx
	
	mov esi,ValMinX
	vbroadcastss ymm2,dword ptr[esi]
	mov esi,CoeffX
	vbroadcastss ymm3,dword ptr[esi]
	mov esi,ValMinZ
	vbroadcastss ymm4,dword ptr[esi]
	mov esi,CoeffZ
	vbroadcastss ymm5,dword ptr[esi]
	
	vmovdqa ymm6,YMMWORD ptr data_dw_65535
	vmovdqa ymm7,YMMWORD ptr data_dw_0
	vmulps ymm3,ymm3,YMMWORD ptr data_f_65535
	vmulps ymm5,ymm5,YMMWORD ptr data_f_65535
	
	mov esi,src
	mov edi,dst1
	mov edx,dst2
	mov ebx,32
	
BT2446C_16_XYZ_AVX2_1:
	xor eax,eax
	mov ecx,w8
BT2446C_16_XYZ_AVX2_2:
	vmovaps ymm0,YMMWORD ptr[edi+eax]
	vmovaps ymm1,YMMWORD ptr[edx+eax]
	vmulps ymm0,ymm0,YMMWORD ptr[esi+eax]
	vmulps ymm1,ymm1,YMMWORD ptr[esi+eax]
	vaddps ymm0,ymm0,ymm2
	vaddps ymm1,ymm1,ymm4
	vmulps ymm0,ymm0,ymm3
	vmulps ymm1,ymm1,ymm5
	vcvtps2dq ymm0,ymm0
	vcvtps2dq ymm1,ymm1
	vpminsd ymm0,ymm0,ymm6
	vpminsd ymm1,ymm1,ymm6
	vpmaxsd ymm0,ymm0,ymm7
	vpmaxsd ymm1,ymm1,ymm7
	vmovdqa YMMWORD ptr[edi+eax],ymm0
	vmovdqa YMMWORD ptr[edx+eax],ymm1
	
	add eax,ebx
	loop BT2446C_16_XYZ_AVX2_2
	
	add esi,src_pitch
	add edi,dst_pitch1
	add edx,dst_pitch2
	dec h
	jnz short BT2446C_16_XYZ_AVX2_1
	
	vzeroupper
	
	pop ebx
	pop edi
	pop esi

	ret

JPSDR_HDRTools_BT2446C_16_XYZ_AVX2 endp


end





