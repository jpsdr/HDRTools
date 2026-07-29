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


;JPSDR_HDRTools_Convert_Planar420_to_Planar422_8_AVX512 proc src1:dword,src2:dword,dst:dword,w:dword
; src1 = rcx
; src2 = rdx
; dst = r8
; w = r9d

JPSDR_HDRTools_Convert_Planar420_to_Planar422_8_AVX512 proc public frame

	.endprolog
		
	vpcmpeqb ymm3,ymm3,ymm3
	vinsertf32x8 zmm3,zmm3,ymm3,1
	
	mov r10,rcx				; r10=src1
	xor rax,rax	
	mov ecx,r9d	
	
Convert_Planar420_to_Planar422_8_AVX512_1:
	vmovdqa64 zmm0,ZMMWORD ptr[r10+rax]
	vmovdqa64 zmm1,ZMMWORD ptr[rdx+rax]
	vpxorq zmm2,zmm0,zmm3
	vpxorq zmm1,zmm1,zmm3
	vpavgb zmm2,zmm2,zmm1
	vpxorq zmm2,zmm2,zmm3
	vpavgb zmm2,zmm2,zmm0
	
	vmovdqa64 ZMMWORD ptr[r8+rax],zmm2
	add rax,64
	dec ecx
	jnz short Convert_Planar420_to_Planar422_8_AVX512_1
	
	vzeroupper
	
	ret

JPSDR_HDRTools_Convert_Planar420_to_Planar422_8_AVX512 endp


;JPSDR_HDRTools_Convert_Planar420_to_Planar422_16_AVX512 proc src1:dword,src2:dword,dst:dword,w:dword
; src1 = rcx
; src2 = rdx
; dst = r8
; w = r9d

JPSDR_HDRTools_Convert_Planar420_to_Planar422_16_AVX512 proc public frame

	.endprolog
		
	vpcmpeqb ymm3,ymm3,ymm3
	vinsertf32x8 zmm3,zmm3,ymm3,1
	
	mov r10,rcx				; r10=src1
	xor rax,rax	
	mov ecx,r9d	
	
Convert_Planar420_to_Planar422_16_AVX512_1:
	vmovdqa64 zmm0,ZMMWORD ptr[r10+rax]
	vmovdqa64 zmm1,ZMMWORD ptr[rdx+rax]
	vpxorq zmm2,zmm0,zmm3
	vpxorq zmm1,zmm1,zmm3
	vpavgw zmm2,zmm2,zmm1
	vpxorq zmm2,zmm2,zmm3
	vpavgw zmm2,zmm2,zmm0
	
	vmovdqa64 ZMMWORD ptr[r8+rax],zmm2
	add rax,64
	dec ecx
	jnz short Convert_Planar420_to_Planar422_16_AVX512_1
	
	vzeroupper
	
	ret

JPSDR_HDRTools_Convert_Planar420_to_Planar422_16_AVX512 endp


;***************************************************
;**           RGB to YUV functions                **
;***************************************************


;JPSDR_HDRTools_Convert_LinearRGBPStoRGB64_AVX512 proc src_R:dword,src_G:dword,src_B:dword,dst:dword,w:dword,h:dword,lookup:dword,
;	src_modulo_R:dword,src_modulo_G:dword,src_modulo_B:dword,dst_modulo:dword
; src_R = rcx
; src_G = rdx
; src_B = r8
; dst = r9

JPSDR_HDRTools_Convert_LinearRGBPStoRGB64_AVX512 proc public frame

w equ dword ptr[rbp+48]
h equ dword ptr[rbp+56]
lookup equ qword ptr[rbp+64]
src_modulo_R equ qword ptr[rbp+72]
src_modulo_G equ qword ptr[rbp+80]
src_modulo_B equ qword ptr[rbp+88]
dst_modulo equ qword ptr[rbp+96]

	push rbp
	.pushreg rbp
	mov rbp,rsp
	push rdi
	.pushreg rdi
	push rsi
	.pushreg rsi
	push rbx
	.pushreg rbx
	push r12
	.pushreg r12
	push r13
	.pushreg r13
	push r14
	.pushreg r14
	push r15
	.pushreg r15
	.endprolog	

	vmovaps zmm3,ZMMWORD ptr data_f_1048575
	vmovaps zmm4,ZMMWORD ptr data_f_0
	vmovaps zmm5,ZMMWORD ptr data_f_1
	
	cld
	mov rdi,r9
	mov r9,rcx
	mov r10,rdx			; src_B=r8,src_G=r10,src_R=r9
	mov rbx,lookup
	mov r11d,w
	mov r12,src_modulo_R
	mov r13,src_modulo_G
	mov r14,src_modulo_B
	mov r15,dst_modulo
	xor rax,rax
	
Convert_LinearRGBPStoRGB64_AVX512_1:
	mov ecx,r11d
Convert_LinearRGBPStoRGB64_AVX512_2:
	xor rdx,rdx
	vmaxps zmm0,zmm4,ZMMWORD ptr[r8]
	vmaxps zmm1,zmm4,ZMMWORD ptr[r10]
	vmaxps zmm2,zmm4,ZMMWORD ptr[r9]
	vminps zmm0,zmm0,zmm5
	vminps zmm1,zmm1,zmm5
	vminps zmm2,zmm2,zmm5
	vmulps zmm0,zmm0,zmm3
	vmulps zmm1,zmm1,zmm3
	vmulps zmm2,zmm2,zmm3
	vcvtps2dq zmm0,zmm0
	vcvtps2dq zmm1,zmm1
	vcvtps2dq zmm2,zmm2

	; process lower part of zmm
	vpextrd eax,xmm0,0
	mov ax,word ptr[rbx+2*rax]
	stosw
	vpextrd eax,xmm1,0
	mov ax,word ptr[rbx+2*rax]
	stosw
	vpextrd eax,xmm2,0
	mov ax,word ptr[rbx+2*rax]
	stosw
	xor eax,eax
	stosw
	dec ecx
	jz Convert_LinearRGBPStoRGB64_AVX512_3
	inc rdx
	
	vpextrd eax,xmm0,1
	mov ax,word ptr[rbx+2*rax]
	stosw
	vpextrd eax,xmm1,1
	mov ax,word ptr[rbx+2*rax]
	stosw
	vpextrd eax,xmm2,1
	mov ax,word ptr[rbx+2*rax]
	stosw
	xor eax,eax
	stosw
	dec ecx
	jz Convert_LinearRGBPStoRGB64_AVX512_3
	inc rdx

	vpextrd eax,xmm0,2
	mov ax,word ptr[rbx+2*rax]
	stosw
	vpextrd eax,xmm1,2
	mov ax,word ptr[rbx+2*rax]
	stosw
	vpextrd eax,xmm2,2
	mov ax,word ptr[rbx+2*rax]
	stosw
	xor eax,eax
	stosw
	dec ecx
	jz Convert_LinearRGBPStoRGB64_AVX512_3
	inc rdx

	vpextrd eax,xmm0,3
	mov ax,word ptr[rbx+2*rax]
	stosw
	vpextrd eax,xmm1,3
	mov ax,word ptr[rbx+2*rax]
	stosw
	vpextrd eax,xmm2,3
	mov ax,word ptr[rbx+2*rax]
	stosw
	xor eax,eax
	stosw
	dec ecx
	jz Convert_LinearRGBPStoRGB64_AVX512_3
	inc rdx
	
	vextracti32x4 xmm16,ymm0,1
	vextracti32x4 xmm17,ymm1,1
	vextracti32x4 xmm18,ymm2,1
	
	vpextrd eax,xmm16,0
	mov ax,word ptr[rbx+2*rax]
	stosw
	vpextrd eax,xmm17,0
	mov ax,word ptr[rbx+2*rax]
	stosw
	vpextrd eax,xmm18,0
	mov ax,word ptr[rbx+2*rax]
	stosw
	xor eax,eax
	stosw
	dec ecx
	jz Convert_LinearRGBPStoRGB64_AVX512_3
	inc rdx	
	
	vpextrd eax,xmm16,1
	mov ax,word ptr[rbx+2*rax]
	stosw
	vpextrd eax,xmm17,1
	mov ax,word ptr[rbx+2*rax]
	stosw
	vpextrd eax,xmm18,1
	mov ax,word ptr[rbx+2*rax]
	stosw
	xor eax,eax
	stosw
	dec ecx
	jz Convert_LinearRGBPStoRGB64_AVX512_3
	inc rdx	

	vpextrd eax,xmm16,2
	mov ax,word ptr[rbx+2*rax]
	stosw
	vpextrd eax,xmm17,2
	mov ax,word ptr[rbx+2*rax]
	stosw
	vpextrd eax,xmm18,2
	mov ax,word ptr[rbx+2*rax]
	stosw
	xor eax,eax
	stosw
	dec ecx
	jz Convert_LinearRGBPStoRGB64_AVX512_3
	inc rdx		

	vpextrd eax,xmm16,3
	mov ax,word ptr[rbx+2*rax]
	stosw
	vpextrd eax,xmm17,3
	mov ax,word ptr[rbx+2*rax]
	stosw
	vpextrd eax,xmm18,3
	mov ax,word ptr[rbx+2*rax]
	stosw
	xor eax,eax
	stosw
	dec ecx
	jz Convert_LinearRGBPStoRGB64_AVX512_3
	inc rdx		

	; process higher part of zmm
	vextracti32x8 ymm0,zmm0,1
	vextracti32x8 ymm1,zmm1,1
	vextracti32x8 ymm2,zmm2,1

	vpextrd eax,xmm0,0
	mov ax,word ptr[rbx+2*rax]
	stosw
	vpextrd eax,xmm1,0
	mov ax,word ptr[rbx+2*rax]
	stosw
	vpextrd eax,xmm2,0
	mov ax,word ptr[rbx+2*rax]
	stosw
	xor eax,eax
	stosw
	dec ecx
	jz Convert_LinearRGBPStoRGB64_AVX512_3
	inc rdx
	
	vpextrd eax,xmm0,1
	mov ax,word ptr[rbx+2*rax]
	stosw
	vpextrd eax,xmm1,1
	mov ax,word ptr[rbx+2*rax]
	stosw
	vpextrd eax,xmm2,1
	mov ax,word ptr[rbx+2*rax]
	stosw
	xor eax,eax
	stosw
	dec ecx
	jz Convert_LinearRGBPStoRGB64_AVX512_3
	inc rdx

	vpextrd eax,xmm0,2
	mov ax,word ptr[rbx+2*rax]
	stosw
	vpextrd eax,xmm1,2
	mov ax,word ptr[rbx+2*rax]
	stosw
	vpextrd eax,xmm2,2
	mov ax,word ptr[rbx+2*rax]
	stosw
	xor eax,eax
	stosw
	dec ecx
	jz Convert_LinearRGBPStoRGB64_AVX512_3
	inc rdx

	vpextrd eax,xmm0,3
	mov ax,word ptr[rbx+2*rax]
	stosw
	vpextrd eax,xmm1,3
	mov ax,word ptr[rbx+2*rax]
	stosw
	vpextrd eax,xmm2,3
	mov ax,word ptr[rbx+2*rax]
	stosw
	xor eax,eax
	stosw
	dec ecx
	jz Convert_LinearRGBPStoRGB64_AVX512_3
	inc rdx
	
	vextracti128 xmm0,ymm0,1
	vextracti128 xmm1,ymm1,1
	vextracti128 xmm2,ymm2,1
	
	vpextrd eax,xmm0,0
	mov ax,word ptr[rbx+2*rax]
	stosw
	vpextrd eax,xmm1,0
	mov ax,word ptr[rbx+2*rax]
	stosw
	vpextrd eax,xmm2,0
	mov ax,word ptr[rbx+2*rax]
	stosw
	xor eax,eax
	stosw
	dec ecx
	jz Convert_LinearRGBPStoRGB64_AVX512_3
	inc rdx	
	
	vpextrd eax,xmm0,1
	mov ax,word ptr[rbx+2*rax]
	stosw
	vpextrd eax,xmm1,1
	mov ax,word ptr[rbx+2*rax]
	stosw
	vpextrd eax,xmm2,1
	mov ax,word ptr[rbx+2*rax]
	stosw
	xor eax,eax
	stosw
	dec ecx
	jz short Convert_LinearRGBPStoRGB64_AVX512_3
	inc rdx	

	vpextrd eax,xmm0,2
	mov ax,word ptr[rbx+2*rax]
	stosw
	vpextrd eax,xmm1,2
	mov ax,word ptr[rbx+2*rax]
	stosw
	vpextrd eax,xmm2,2
	mov ax,word ptr[rbx+2*rax]
	stosw
	xor eax,eax
	stosw
	dec ecx
	jz short Convert_LinearRGBPStoRGB64_AVX512_3
	inc rdx		

	vpextrd eax,xmm0,3
	mov ax,word ptr[rbx+2*rax]
	stosw
	vpextrd eax,xmm1,3
	mov ax,word ptr[rbx+2*rax]
	stosw
	vpextrd eax,xmm2,3
	mov ax,word ptr[rbx+2*rax]
	stosw
	xor eax,eax
	stosw
	dec ecx
	
Convert_LinearRGBPStoRGB64_AVX512_3:
	inc rdx	
	shl rdx,2	
	add r8,rdx
	add r10,rdx
	add r9,rdx	
	or ecx,ecx
	jnz Convert_LinearRGBPStoRGB64_AVX512_2
	
	add rdi,r15
	add r8,r14
	add r10,r13
	add r9,r12
	dec h
	jnz Convert_LinearRGBPStoRGB64_AVX512_1

	vzeroupper
	
	pop r15
	pop r14
	pop r13
	pop r12
	pop rbx
	pop rsi
	pop rdi
	pop rbp

	ret

JPSDR_HDRTools_Convert_LinearRGBPStoRGB64_AVX512 endp


;JPSDR_HDRTools_Convert_Planar422_to_Planar420_8_AVX512 proc src1:dword,src2:dword,dst:dword,w64:dword,h:dword,src_pitch2:dword,dst_pitch:dword
; src1 = rcx
; src2 = rdx
; dst = r8
; w64 = r9d

JPSDR_HDRTools_Convert_Planar422_to_Planar420_8_AVX512 proc public frame

h equ dword ptr[rbp+48]
src_pitch2 equ qword ptr[rbp+56]
dst_pitch equ qword ptr[rbp+64]

	push rbp
	.pushreg rbp
	mov rbp,rsp
	push rsi
	.pushreg rsi
	push r12
	.pushreg r12
	.endprolog		
	
	mov rsi,rcx
	mov r10d,h
	mov r11,src_pitch2
	mov r12,dst_pitch

Convert_Planar422_to_Planar420_8_AVX512_1:
	xor rax,rax
	mov ecx,r9d

Convert_Planar422_to_Planar420_8_AVX512_2:
	vmovdqa64 zmm0,ZMMWORD ptr[rsi+rax]
	vpavgb zmm0,zmm0,ZMMWORD ptr[rdx+rax]
	
	vmovdqa64 ZMMWORD ptr[r8+rax],zmm0
	add rax,64
	dec ecx
	jnz short Convert_Planar422_to_Planar420_8_AVX512_2
	
	add rsi,r11
	add rdx,r11
	add r8,r12
	dec r10d
	jnz short Convert_Planar422_to_Planar420_8_AVX512_1
	
	vzeroupper

	pop r12
	pop rsi
	pop rbp

	ret

JPSDR_HDRTools_Convert_Planar422_to_Planar420_8_AVX512 endp


;JPSDR_HDRTools_Convert_Planar422_to_Planar420_16_AVX512 proc src1:dword,src2:dword,dst:dword,w32:dword,h:dword,src_pitch2:dword,dst_pitch:dword
; src1 = rcx
; src2 = rdx
; dst = r8
; w32 = r9d

JPSDR_HDRTools_Convert_Planar422_to_Planar420_16_AVX512 proc public frame

h equ dword ptr[rbp+48]
src_pitch2 equ qword ptr[rbp+56]
dst_pitch equ qword ptr[rbp+64]

	push rbp
	.pushreg rbp
	mov rbp,rsp
	push rsi
	.pushreg rsi
	push r12
	.pushreg r12
	.endprolog		
	
	mov rsi,rcx
	mov r10d,h
	mov r11,src_pitch2
	mov r12,dst_pitch

Convert_Planar422_to_Planar420_16_AVX512_1:
	xor rax,rax
	mov ecx,r9d

Convert_Planar422_to_Planar420_16_AVX512_2:
	vmovdqa64 zmm0,ZMMWORD ptr[rsi+rax]
	vpavgw zmm0,zmm0,ZMMWORD ptr[rdx+rax]
	
	vmovdqa64 ZMMWORD ptr[r8+rax],zmm0
	add rax,64
	dec ecx
	jnz short Convert_Planar422_to_Planar420_16_AVX512_2
	
	add rsi,r11
	add rdx,r11
	add r8,r12
	dec r10d
	jnz short Convert_Planar422_to_Planar420_16_AVX512_1

	vzeroupper
	
	pop r12
	pop rsi
	pop rbp

	ret

JPSDR_HDRTools_Convert_Planar422_to_Planar420_16_AVX512 endp


;***************************************************
;**             XYZ/RGB functions                 **
;***************************************************

;***************************************************
;**               HLG functions                   **
;***************************************************


;JPSDR_HDRTools_Convert_RGB64_16toRGB64_8_AVX512 proc src:dword,dst:dword,w:dword,h:dword,
;	src_pitch:dword,dst_pitch:dword
; src = rcx
; dst = rdx
; w = r8d
; h = r9d
JPSDR_HDRTools_Convert_RGB64_16toRGB64_8_AVX512 proc public frame

src_pitch equ qword ptr[rbp+48]
dst_pitch equ qword ptr[rbp+56]

	push rbp
	.pushreg rbp
	mov rbp,rsp
	push rdi
	.pushreg rdi
	push rsi
	.pushreg rsi
	push rbx
	.pushreg rbx
	push r13
	.pushreg r13
	.endprolog

	vmovdqa64 zmm4,ZMMWORD ptr data_w_128

	mov rsi,rcx
	mov rdi,rdx
	mov ebx,r8d
	mov r10,src_pitch
	mov r11,dst_pitch
	shr ebx,3
	mov rdx,256
	mov r13d,r8d
	and r13d,7
	shr r13d,1

Convert_RGB64_16toRGB64_8_AVX512_loop_1:
	mov ecx,ebx
	xor rax,rax

	shr ecx,2
	jz Convert_RGB64_16toRGB64_8_AVX512_3
	
Convert_RGB64_16toRGB64_8_AVX512_loop_2:
	vpaddusw zmm0,zmm4,ZMMWORD ptr[rsi+rax]
	vpaddusw zmm1,zmm4,ZMMWORD ptr[rsi+rax+64]
	vpaddusw zmm2,zmm4,ZMMWORD ptr[rsi+rax+128]
	vpaddusw zmm3,zmm4,ZMMWORD ptr[rsi+rax+192]
	vpsrlw zmm0,zmm0,8
	vpsrlw zmm1,zmm1,8
	vpsrlw zmm2,zmm2,8
	vpsrlw zmm3,zmm3,8
	vmovdqa64 ZMMWORD ptr[rdi+rax],zmm0
	vmovdqa64 ZMMWORD ptr[rdi+rax+64],zmm1
	vmovdqa64 ZMMWORD ptr[rdi+rax+128],zmm2
	vmovdqa64 ZMMWORD ptr[rdi+rax+192],zmm3
	add rax,rdx
	dec ecx
	jnz short Convert_RGB64_16toRGB64_8_AVX512_loop_2

Convert_RGB64_16toRGB64_8_AVX512_3:
	test ebx,2
	jz short Convert_RGB64_16toRGB64_8_AVX512_4

	vpaddusw zmm0,zmm4,ZMMWORD ptr[rsi+rax]
	vpaddusw zmm1,zmm4,ZMMWORD ptr[rsi+rax+64]
	vpsrlw zmm0,zmm0,8
	vpsrlw zmm1,zmm1,8
	vmovdqa64 ZMMWORD ptr[rdi+rax],zmm0
	vmovdqa64 ZMMWORD ptr[rdi+rax+64],zmm1
	add rax,128

Convert_RGB64_16toRGB64_8_AVX512_4:
	test ebx,1
	jz short Convert_RGB64_16toRGB64_8_AVX512_5

	vpaddusw zmm0,zmm4,ZMMWORD ptr[rsi+rax]
	vpsrlw zmm0,zmm0,8
	vmovdqa64 ZMMWORD ptr[rdi+rax],zmm0
	add rax,64

Convert_RGB64_16toRGB64_8_AVX512_5:
	or r13d,r13d
	jz short Convert_RGB64_16toRGB64_8_AVX512_6

	mov ecx,r13d
Convert_RGB64_16toRGB64_8_AVX512_loop_3:
	vpaddusw xmm0,xmm4,XMMWORD ptr[rsi+rax]
	vpsrlw xmm0,xmm0,8
	vmovdqa XMMWORD ptr[rdi+rax],xmm0
	add rax,16
	dec ecx
	jnz short Convert_RGB64_16toRGB64_8_AVX512_loop_3

Convert_RGB64_16toRGB64_8_AVX512_6:
	test r8d,1
	jz short Convert_RGB64_16toRGB64_8_AVX512_7
	
	vmovq xmm0,qword ptr[rsi+rax]
	vpaddusw xmm0,xmm0,xmm4
	vpsrlw xmm0,xmm0,8
	vmovq qword ptr[rdi+rax],xmm0
	
Convert_RGB64_16toRGB64_8_AVX512_7:
	add rsi,r10
	add rdi,r11
	dec r9d
	jnz Convert_RGB64_16toRGB64_8_AVX512_loop_1
	
	vzeroupper
	
	pop r13
	pop rbx
	pop rsi
	pop rdi
	pop rbp

	ret

JPSDR_HDRTools_Convert_RGB64_16toRGB64_8_AVX512 endp


;JPSDR_HDRTools_Convert_RGB64_16toRGB64_10_AVX512 proc src:dword,dst:dword,w:dword,h:dword,
;	src_pitch:dword,dst_pitch:dword
; src = rcx
; dst = rdx
; w = r8d
; h = r9d
JPSDR_HDRTools_Convert_RGB64_16toRGB64_10_AVX512 proc public frame

src_pitch equ qword ptr[rbp+48]
dst_pitch equ qword ptr[rbp+56]

	push rbp
	.pushreg rbp
	mov rbp,rsp
	push rdi
	.pushreg rdi
	push rsi
	.pushreg rsi
	push rbx
	.pushreg rbx
	push r13
	.pushreg r13
	.endprolog

	vmovdqa64 zmm4,ZMMWORD ptr data_w_32

	mov rsi,rcx
	mov rdi,rdx
	mov ebx,r8d
	mov r10,src_pitch
	mov r11,dst_pitch
	shr ebx,3
	mov rdx,256
	mov r13d,r8d
	and r13d,7
	shr r13d,1

Convert_RGB64_16toRGB64_10_AVX512_loop_1:
	mov ecx,ebx
	xor rax,rax

	shr ecx,2
	jz Convert_RGB64_16toRGB64_10_AVX512_3
	
Convert_RGB64_16toRGB64_10_AVX512_loop_2:
	vpaddusw zmm0,zmm4,ZMMWORD ptr[rsi+rax]
	vpaddusw zmm1,zmm4,ZMMWORD ptr[rsi+rax+64]
	vpaddusw zmm2,zmm4,ZMMWORD ptr[rsi+rax+128]
	vpaddusw zmm3,zmm4,ZMMWORD ptr[rsi+rax+192]
	vpsrlw zmm0,zmm0,6
	vpsrlw zmm1,zmm1,6
	vpsrlw zmm2,zmm2,6
	vpsrlw zmm3,zmm3,6
	vmovdqa64 ZMMWORD ptr[rdi+rax],zmm0
	vmovdqa64 ZMMWORD ptr[rdi+rax+64],zmm1
	vmovdqa64 ZMMWORD ptr[rdi+rax+128],zmm2
	vmovdqa64 ZMMWORD ptr[rdi+rax+192],zmm3
	add rax,rdx
	dec ecx
	jnz short Convert_RGB64_16toRGB64_10_AVX512_loop_2

Convert_RGB64_16toRGB64_10_AVX512_3:
	test ebx,2
	jz short Convert_RGB64_16toRGB64_10_AVX512_4

	vpaddusw zmm0,zmm4,ZMMWORD ptr[rsi+rax]
	vpaddusw zmm1,zmm4,ZMMWORD ptr[rsi+rax+64]
	vpsrlw zmm0,zmm0,6
	vpsrlw zmm1,zmm1,6
	vmovdqa64 ZMMWORD ptr[rdi+rax],zmm0
	vmovdqa64 ZMMWORD ptr[rdi+rax+64],zmm1
	add rax,128

Convert_RGB64_16toRGB64_10_AVX512_4:
	test ebx,1
	jz short Convert_RGB64_16toRGB64_10_AVX512_5

	vpaddusw zmm0,zmm4,ZMMWORD ptr[rsi+rax]
	vpsrlw zmm0,zmm0,6
	vmovdqa64 ZMMWORD ptr[rdi+rax],zmm0
	add rax,64

Convert_RGB64_16toRGB64_10_AVX512_5:
	or r13d,r13d	
	jz short Convert_RGB64_16toRGB64_10_AVX512_6

	mov ecx,r13d
Convert_RGB64_16toRGB64_10_AVX512_loop_3:
	vpaddusw xmm0,xmm4,XMMWORD ptr[rsi+rax]
	vpsrlw xmm0,xmm0,6
	vmovdqa XMMWORD ptr[rdi+rax],xmm0
	add rax,16
	dec ecx
	jnz short Convert_RGB64_16toRGB64_10_AVX512_loop_3

Convert_RGB64_16toRGB64_10_AVX512_6:
	test r8d,1
	jz short Convert_RGB64_16toRGB64_10_AVX512_7
	
	vmovq xmm0,qword ptr[rsi+rax]
	vpaddusw xmm0,xmm0,xmm4
	vpsrlw xmm0,xmm0,6
	vmovq qword ptr[rdi+rax],xmm0
	
Convert_RGB64_16toRGB64_10_AVX512_7:
	add rsi,r10
	add rdi,r11
	dec r9d
	jnz Convert_RGB64_16toRGB64_10_AVX512_loop_1
	
	vzeroupper
	
	pop r13
	pop rbx
	pop rsi
	pop rdi
	pop rbp

	ret

JPSDR_HDRTools_Convert_RGB64_16toRGB64_10_AVX512 endp


;JPSDR_HDRTools_Convert_RGB64_16toRGB64_12_AVX512 proc src:dword,dst:dword,w:dword,h:dword,
;	src_pitch:dword,dst_pitch:dword
; src = rcx
; dst = rdx
; w = r8d
; h = r9d
JPSDR_HDRTools_Convert_RGB64_16toRGB64_12_AVX512 proc public frame

src_pitch equ qword ptr[rbp+48]
dst_pitch equ qword ptr[rbp+56]

	push rbp
	.pushreg rbp
	mov rbp,rsp
	push rdi
	.pushreg rdi
	push rsi
	.pushreg rsi
	push rbx
	.pushreg rbx
	push r13
	.pushreg r13
	.endprolog

	vmovdqa64 zmm4,ZMMWORD ptr data_w_8

	mov rsi,rcx
	mov rdi,rdx
	mov ebx,r8d
	mov r10,src_pitch
	mov r11,dst_pitch
	shr ebx,3
	mov rdx,256
	mov r13d,r8d
	and r13d,7
	shr r13d,1

Convert_RGB64_16toRGB64_12_AVX512_loop_1:
	mov ecx,ebx
	xor rax,rax

	shr ecx,2
	jz Convert_RGB64_16toRGB64_12_AVX512_3
	
Convert_RGB64_16toRGB64_12_AVX512_loop_2:
	vpaddusw zmm0,zmm4,ZMMWORD ptr[rsi+rax]
	vpaddusw zmm1,zmm4,ZMMWORD ptr[rsi+rax+64]
	vpaddusw zmm2,zmm4,ZMMWORD ptr[rsi+rax+128]
	vpaddusw zmm3,zmm4,ZMMWORD ptr[rsi+rax+192]
	vpsrlw zmm0,zmm0,4
	vpsrlw zmm1,zmm1,4
	vpsrlw zmm2,zmm2,4
	vpsrlw zmm3,zmm3,4
	vmovdqa64 ZMMWORD ptr[rdi+rax],zmm0
	vmovdqa64 ZMMWORD ptr[rdi+rax+64],zmm1
	vmovdqa64 ZMMWORD ptr[rdi+rax+128],zmm2
	vmovdqa64 ZMMWORD ptr[rdi+rax+192],zmm3
	add rax,rdx
	dec ecx
	jnz short Convert_RGB64_16toRGB64_12_AVX512_loop_2

Convert_RGB64_16toRGB64_12_AVX512_3:
	test ebx,2
	jz short Convert_RGB64_16toRGB64_12_AVX512_4

	vpaddusw zmm0,zmm4,ZMMWORD ptr[rsi+rax]
	vpaddusw zmm1,zmm4,ZMMWORD ptr[rsi+rax+64]
	vpsrlw zmm0,zmm0,4
	vpsrlw zmm1,zmm1,4
	vmovdqa64 ZMMWORD ptr[rdi+rax],zmm0
	vmovdqa64 ZMMWORD ptr[rdi+rax+64],zmm1
	add rax,128

Convert_RGB64_16toRGB64_12_AVX512_4:
	test ebx,1
	jz short Convert_RGB64_16toRGB64_12_AVX512_5

	vpaddusw zmm0,zmm4,ZMMWORD ptr[rsi+rax]
	vpsrlw zmm0,zmm0,4
	vmovdqa64 ZMMWORD ptr[rdi+rax],zmm0
	add rax,64
	
Convert_RGB64_16toRGB64_12_AVX512_5:
	or r13d,r13d	
	jz short Convert_RGB64_16toRGB64_12_AVX512_6

	mov ecx,r13d
Convert_RGB64_16toRGB64_12_AVX512_loop_3:
	vpaddusw xmm0,xmm4,XMMWORD ptr[rsi+rax]
	vpsrlw xmm0,xmm0,4
	vmovdqa XMMWORD ptr[rdi+rax],xmm0
	add rax,16
	dec ecx
	jnz short Convert_RGB64_16toRGB64_12_AVX512_loop_3

Convert_RGB64_16toRGB64_12_AVX512_6:
	test r8d,1
	jz short Convert_RGB64_16toRGB64_12_AVX512_7
	
	vmovq xmm0,qword ptr[rsi+rax]
	vpaddusw xmm0,xmm0,xmm4
	vpsrlw xmm0,xmm0,4
	vmovq qword ptr[rdi+rax],xmm0
	
Convert_RGB64_16toRGB64_12_AVX512_7:
	add rsi,r10
	add rdi,r11
	dec r9d
	jnz Convert_RGB64_16toRGB64_12_AVX512_loop_1
	
	vzeroupper
	
	pop r13
	pop rbx
	pop rsi
	pop rdi
	pop rbp

	ret

JPSDR_HDRTools_Convert_RGB64_16toRGB64_12_AVX512 endp


;JPSDR_HDRTools_Scale_HLG_AVX512 proc src:dword,dst:dword,w8:dword,h:dword,src_pitch:dword,dst_pitch:dword,
;	Coeff:dword
; src = rcx
; dst = rdx
; w16 = r8d
; h = r9d

JPSDR_HDRTools_Scale_HLG_AVX512 proc public frame

src_pitch equ qword ptr[rbp+48]
dst_pitch equ qword ptr[rbp+56]
Coeff equ qword ptr[rbp+64]

	push rbp
	.pushreg rbp
	mov rbp,rsp
	push rsi
	.pushreg rsi
	push rbx
	.pushreg rbx
	.endprolog

	mov rsi,Coeff
	vbroadcastss zmm4,dword ptr[rsi]
	vmovaps zmm5,ZMMWORD ptr data_f_1

	mov rsi,rcx
	mov r10,src_pitch
	mov r11,dst_pitch
	mov rbx,256

Scale_HLG_AVX512_loop_1:
	xor rax,rax
	mov ecx,r8d

	shr ecx,2
	jz short Scale_HLG_AVX512_1

Scale_HLG_AVX512_loop_2:
	vmulps zmm0,zmm4,ZMMWORD ptr[rsi+rax]
	vmulps zmm1,zmm4,ZMMWORD ptr[rsi+rax+64]
	vmulps zmm2,zmm4,ZMMWORD ptr[rsi+rax+128]
	vmulps zmm3,zmm4,ZMMWORD ptr[rsi+rax+192]
	vminps zmm0,zmm0,zmm5
	vminps zmm1,zmm1,zmm5
	vminps zmm2,zmm2,zmm5
	vminps zmm3,zmm3,zmm5
	vmovdqa64 ZMMWORD ptr[rdx+rax],zmm0
	vmovdqa64 ZMMWORD ptr[rdx+rax+64],zmm1
	vmovdqa64 ZMMWORD ptr[rdx+rax+128],zmm2
	vmovdqa64 ZMMWORD ptr[rdx+rax+192],zmm3	

	add rax,rbx
	dec ecx
	jnz short Scale_HLG_AVX512_loop_2

Scale_HLG_AVX512_1:
	test r8d,2
	jz short Scale_HLG_AVX512_2

	vmulps zmm0,zmm4,ZMMWORD ptr[rsi+rax]
	vmulps zmm1,zmm4,ZMMWORD ptr[rsi+rax+64]
	vminps zmm0,zmm0,zmm5
	vminps zmm1,zmm1,zmm5
	vmovdqa64 ZMMWORD ptr[rdx+rax],zmm0
	vmovdqa64 ZMMWORD ptr[rdx+rax+64],zmm1

	add rax,128

Scale_HLG_AVX512_2:
	test r8d,1
	jz short Scale_HLG_AVX512_3

	vmulps zmm0,zmm4,ZMMWORD ptr[rsi+rax]
	vminps zmm0,zmm0,zmm5
	vmovdqa64 ZMMWORD ptr[rdx+rax],zmm0

Scale_HLG_AVX512_3:
	add rsi,r10
	add rdx,r11
	dec r9d
	jnz Scale_HLG_AVX512_loop_1
	
	vzeroupper
	
	pop rbx
	pop rsi
	pop rbp

	ret

JPSDR_HDRTools_Scale_HLG_AVX512 endp


;JPSDR_HDRTools_Scale_20_float_AVX512 proc src:dword,dst:dword,w16:dword,h:dword,src_pitch:dword,dst_pitch:dword
; src = rcx
; dst = rdx
; w16 = r8d
; h = r9d

JPSDR_HDRTools_Scale_20_float_AVX512 proc public frame

src_pitch equ qword ptr[rbp+48]
dst_pitch equ qword ptr[rbp+56]

	push rbp
	.pushreg rbp
	mov rbp,rsp
	push rsi
	.pushreg rsi
	push rbx
	.pushreg rbx
	.endprolog

	vmovaps zmm4,ZMMWORD ptr data_f_1048575

	mov rsi,rcx
	mov r10,src_pitch
	mov r11,dst_pitch
	mov rbx,256

Scale_20_float_AVX512_loop_1:
	xor rax,rax
	mov ecx,r8d

	shr ecx,2
	jz short Scale_20_float_AVX512_1

Scale_20_float_AVX512_loop_2:
	vmulps zmm0,zmm4,ZMMWORD ptr[rsi+rax]
	vmulps zmm1,zmm4,ZMMWORD ptr[rsi+rax+64]
	vmulps zmm2,zmm4,ZMMWORD ptr[rsi+rax+128]
	vmulps zmm3,zmm4,ZMMWORD ptr[rsi+rax+192]
;	vminps zmm0,zmm0,zmm4
;	vminps zmm1,zmm1,zmm4
;	vminps zmm2,zmm2,zmm4
;	vminps zmm3,zmm3,zmm4
	vcvtps2dq zmm0,zmm0
	vcvtps2dq zmm1,zmm1
	vcvtps2dq zmm2,zmm2
	vcvtps2dq zmm3,zmm3
	vmovdqa64 ZMMWORD ptr[rdx+rax],zmm0
	vmovdqa64 ZMMWORD ptr[rdx+rax+64],zmm1
	vmovdqa64 ZMMWORD ptr[rdx+rax+128],zmm2
	vmovdqa64 ZMMWORD ptr[rdx+rax+192],zmm3

	add rax,rbx
	dec ecx
	jnz short Scale_20_float_AVX512_loop_2

Scale_20_float_AVX512_1:
	test r8d,2
	jz short Scale_20_float_AVX512_2

	vmulps zmm0,zmm4,ZMMWORD ptr[rsi+rax]
	vmulps zmm1,zmm4,ZMMWORD ptr[rsi+rax+64]
;	vminps zmm0,zmm0,zmm4
;	vminps zmm1,zmm1,zmm4
	vcvtps2dq zmm0,zmm0
	vcvtps2dq zmm1,zmm1
	vmovdqa64 ZMMWORD ptr[rdx+rax],zmm0
	vmovdqa64 ZMMWORD ptr[rdx+rax+64],zmm1

	add rax,128

Scale_20_float_AVX512_2:
	test r8d,1
	jz short Scale_20_float_AVX512_3

	vmulps zmm0,zmm4,ZMMWORD ptr[rsi+rax]
;	vminps zmm0,zmm0,zmm4
	vcvtps2dq zmm0,zmm0
	vmovdqa64 ZMMWORD ptr[rdx+rax],zmm0

Scale_20_float_AVX512_3:
	add rsi,r10
	add rdx,r11
	dec r9d
	jnz Scale_20_float_AVX512_loop_1

	vzeroupper

	pop rbx
	pop rsi
	pop rbp

	ret

JPSDR_HDRTools_Scale_20_float_AVX512 endp


;JPSDR_HDRTools_Convert_RGBPStoPlaneY32F_AVX512 proc srcR:dword,srcG:dword,srcB:dword,dst:dword,w16:dword,h:dword,
;	src_pitch_R:dword,src_pitch_G:dword,src_pitch_B:dword,dst_pitch:dword,Coeff_R:dword,Coeff_G:dword,Coeff_B:dword
; srcR = rcx
; srcG = rdx
; srcB = r8
; dst = r9

JPSDR_HDRTools_Convert_RGBPStoPlaneY32F_AVX512 proc public frame

w16 equ dword ptr[rbp+48]
h equ dword ptr[rbp+56]
src_pitch_R equ qword ptr[rbp+64]
src_pitch_G equ qword ptr[rbp+72]
src_pitch_B equ qword ptr[rbp+80]
dst_pitch equ qword ptr[rbp+88]
Coeff_R equ qword ptr[rbp+96]
Coeff_G equ qword ptr[rbp+104]
Coeff_B equ qword ptr[rbp+112]

	push rbp
	.pushreg rbp
	mov rbp,rsp
	push rsi
	.pushreg rsi
	push rdi
	.pushreg rdi
	push rbx
	.pushreg rbx
	push r12
	.pushreg r12
	push r13
	.pushreg r13
	.endprolog	
	
	mov rsi,Coeff_R
	vbroadcastss zmm3,dword ptr[rsi]
	mov rsi,Coeff_G
	vbroadcastss zmm4,dword ptr[rsi]
	mov rsi,Coeff_B
	vbroadcastss zmm5,dword ptr[rsi]
	
	mov rdi,r9
	mov rsi,rcx		; srcR
	mov r9,rdx		; srcG
	mov r10d,h
	mov r11,src_pitch_R
	mov r12,src_pitch_G
	mov r13,src_pitch_B
	mov rdx,dst_pitch
	
	mov ebx,w16
	
Convert_RGBPStoPlaneY32F_AVX512_1:
	xor rax,rax
	mov ecx,ebx
Convert_RGBPStoPlaneY32F_AVX512_2:	
	vmulps zmm0,zmm3,ZMMWORD ptr [rsi+rax]
	vmulps zmm1,zmm4,ZMMWORD ptr [r9+rax]
	vmulps zmm2,zmm5,ZMMWORD ptr [r8+rax]
	vaddps zmm0,zmm0,zmm1
	vaddps zmm0,zmm0,zmm2
	vmovdqa64 ZMMWORD ptr [rdi+rax],zmm0
	
	add rax,64
	dec ecx
	jnz short Convert_RGBPStoPlaneY32F_AVX512_2
	
	add rsi,r11
	add r9,r12
	add r8,r13
	add rdi,rdx
	dec r10d
	jnz short Convert_RGBPStoPlaneY32F_AVX512_1
	
	vzeroupper
	
	pop r13
	pop r12
	pop rbx
	pop rdi
	pop rsi
	pop rbp

	ret

JPSDR_HDRTools_Convert_RGBPStoPlaneY32F_AVX512 endp


;JPSDR_HDRTools_Convert_RGBPStoPlaneY32D_AVX512 proc srcR:dword,srcG:dword,srcB:dword,dst:dword,w16:dword,h:dword,
;	src_pitch_R:dword,src_pitch_G:dword,src_pitch_B:dword,dst_pitch:dword,Coeff_R:dword,Coeff_G:dword,Coeff_B:dword
; srcR = rcx
; srcG = rdx
; srcB = r8
; dst = r9

JPSDR_HDRTools_Convert_RGBPStoPlaneY32D_AVX512 proc public frame

w16 equ dword ptr[rbp+48]
h equ dword ptr[rbp+56]
src_pitch_R equ qword ptr[rbp+64]
src_pitch_G equ qword ptr[rbp+72]
src_pitch_B equ qword ptr[rbp+80]
dst_pitch equ qword ptr[rbp+88]
Coeff_R equ qword ptr[rbp+96]
Coeff_G equ qword ptr[rbp+104]
Coeff_B equ qword ptr[rbp+112]

	push rbp
	.pushreg rbp
	mov rbp,rsp
	push rsi
	.pushreg rsi
	push rdi
	.pushreg rdi
	push rbx
	.pushreg rbx
	push r12
	.pushreg r12
	push r13
	.pushreg r13
	.endprolog	
	
	mov rsi,Coeff_R
	vbroadcastss zmm3,dword ptr[rsi]
	mov rsi,Coeff_G
	vbroadcastss zmm4,dword ptr[rsi]
	mov rsi,Coeff_B
	vbroadcastss zmm5,dword ptr[rsi]
	vmovaps zmm16,ZMMWORD ptr data_f_1048575
	
	mov rdi,r9
	mov rsi,rcx		; srcR
	mov r9,rdx		; srcG
	mov r10d,h
	mov r11,src_pitch_R
	mov r12,src_pitch_G
	mov r13,src_pitch_B
	mov rdx,dst_pitch
	
	mov ebx,w16
	
Convert_RGBPStoPlaneY32D_AVX512_1:
	xor rax,rax
	mov ecx,ebx
Convert_RGBPStoPlaneY32D_AVX512_2:	
	vmulps zmm0,zmm3,ZMMWORD ptr [rsi+rax]
	vmulps zmm1,zmm4,ZMMWORD ptr [r9+rax]
	vmulps zmm2,zmm5,ZMMWORD ptr [r8+rax]
	vaddps zmm0,zmm0,zmm1
	vaddps zmm0,zmm0,zmm2
	vmulps zmm0,zmm0,zmm16
	vcvtps2dq zmm0,zmm0
	vmovdqa64 ZMMWORD ptr [rdi+rax],zmm0
	
	add rax,64
	dec ecx
	jnz short Convert_RGBPStoPlaneY32D_AVX512_2
	
	add rsi,r11
	add r9,r12
	add r8,r13
	add rdi,rdx
	dec r10d
	jnz short Convert_RGBPStoPlaneY32D_AVX512_1
	
	vzeroupper
	
	pop r13
	pop r12
	pop rbx
	pop rdi
	pop rsi
	pop rbp

	ret

JPSDR_HDRTools_Convert_RGBPStoPlaneY32D_AVX512 endp


;JPSDR_HDRTools_Convert_RGBPS_HLG_OOTF_AVX512 proc dstR:dword,dstG:dword,dstB:dword,srcY:dword,w16:dword,h:dword,
;	dst_pitchR:dword,dst_pitchG:dword,dst_pitchB:dword,src_pitchY:dword
; dstR = rcx
; dstG = rdx
; dstB = r8
; srcY = r9
	
JPSDR_HDRTools_Convert_RGBPS_HLG_OOTF_AVX512 proc public frame	

w16 equ dword ptr[rbp+48]
h equ dword ptr[rbp+56]
dst_pitch_R equ qword ptr[rbp+64]
dst_pitch_G equ qword ptr[rbp+72]
dst_pitch_B equ qword ptr[rbp+80]
src_pitchY equ qword ptr[rbp+88]

	push rbp
	.pushreg rbp
	mov rbp,rsp
	push rsi
	.pushreg rsi
	push rbx
	.pushreg rbx
	push r12
	.pushreg r12
	push r13
	.pushreg r13
	push r14
	.pushreg r14
	.endprolog	
	
	mov rsi,r9		; srcY
	mov r9,rcx		; dstR
	mov r10,rdx		; dstG
	
	mov r11d,h
	mov r12,dst_pitch_R
	mov r13,dst_pitch_G
	mov r14,dst_pitch_B
	mov rdx,src_pitchY
	
	mov ebx,w16
	
Convert_RGBPS_HLG_OOTF_AVX512_1:
	xor rax,rax
	mov ecx,ebx
Convert_RGBPS_HLG_OOTF_AVX512_2:
	vmovaps zmm0,ZMMWORD ptr[rsi+rax]
	vmulps zmm1,zmm0,ZMMWORD ptr[r9+rax]
	vmulps zmm2,zmm0,ZMMWORD ptr[r10+rax]
	vmulps zmm3,zmm0,ZMMWORD ptr[r8+rax]
	vmovaps ZMMWORD ptr[r9+rax],zmm1
	vmovaps ZMMWORD ptr[r10+rax],zmm2
	vmovaps ZMMWORD ptr[r8+rax],zmm3
	
	add rax,64
	dec ecx
	jnz short Convert_RGBPS_HLG_OOTF_AVX512_2
	
	add r9,r12
	add r10,r13
	add r8,r14
	add rsi,rdx
	dec r11d
	
	jnz short Convert_RGBPS_HLG_OOTF_AVX512_1
	
	vzeroupper
	
	pop r14
	pop r13
	pop r12
	pop rbx
	pop rsi
	pop rbp

	ret

JPSDR_HDRTools_Convert_RGBPS_HLG_OOTF_AVX512 endp


;JPSDR_HDRTools_Convert_16_RGB64_HLG_OOTF_AVX512 proc dst:dword,srcY:dword,w:dword,h:dword,dst_pitch:dword,src_pitchY:dword
; dst = rcx
; srcY = rdx
; w = r8d
; h = r9d
	
JPSDR_HDRTools_Convert_16_RGB64_HLG_OOTF_AVX512 proc public frame	

dst_pitch equ qword ptr[rbp+48]
src_pitchY equ qword ptr[rbp+56]

	push rbp
	.pushreg rbp
	mov rbp,rsp
	push rsi
	.pushreg rsi
	push rdi
	.pushreg rdi
	push rbx
	.pushreg rbx
	.endprolog
	
	mov rdi,rcx
	mov rsi,rdx
	mov r10d,r8d
	mov r11,dst_pitch
	mov rdx,src_pitchY
	shr r10d,2
	mov ebx,r8d
	and ebx,3
	pxor xmm4,xmm4
	
Convert_16_RGB64_HLG_OOTF_AVX512_1:
	mov ecx,r10d
	xor rax,rax
	or ecx,ecx
	jz Convert_16_RGB64_HLG_OOTF_AVX512_3
	
Convert_16_RGB64_HLG_OOTF_AVX512_2:
	vbroadcastss xmm0,dword ptr[rsi+rax]
	vbroadcastss xmm1,dword ptr[rsi+rax+4]
	vbroadcastss xmm5,dword ptr[rsi+rax+8]
	vbroadcastss xmm16,dword ptr[rsi+rax+12]
	
	vmovdqa xmm2,XMMWORD ptr[rdi+2*rax]
	vmovdqa32 xmm17,XMMWORD ptr[rdi+2*rax+16]

	vinsertf128 ymm0,ymm0,xmm1,1
	vpunpckhwd xmm3,xmm2,xmm4
	vinsertf32x4 ymm1,ymm5,xmm16,1
	vpunpcklwd xmm2,xmm2,xmm4
	vpunpckhwd xmm16,xmm17,xmm4
	vpunpcklwd xmm17,xmm17,xmm4

	vinserti128 ymm2,ymm2,xmm3,1	
	vinserti32x4 ymm17,ymm17,xmm16,1	

	vinsertf32x8 zmm0,zmm0,ymm1,1
	vinserti32x8 zmm2,zmm2,ymm17,1

	vcvtdq2ps zmm2,zmm2
	vmulps zmm2,zmm2,zmm0	
	vcvtps2dq zmm2,zmm2
	
	vextracti32x8 ymm1,zmm2,1
	vextracti128 xmm3,ymm2,1
	vextracti128 xmm0,ymm1,1
	
	vpackusdw xmm2,xmm2,xmm3
	vpackusdw xmm1,xmm1,xmm0

	vmovdqa XMMWORD ptr[rdi+2*rax],xmm2
	vmovdqa XMMWORD ptr[rdi+2*rax+16],xmm1
	
	add rax,16
	dec ecx
	jnz Convert_16_RGB64_HLG_OOTF_AVX512_2
	
Convert_16_RGB64_HLG_OOTF_AVX512_3:
	or ebx,ebx
	jz short Convert_16_RGB64_HLG_OOTF_AVX512_4
	
	mov ecx,ebx
Convert_16_RGB64_HLG_OOTF_AVX512_5:
	vbroadcastss xmm0,dword ptr[rsi+rax]
	vmovq xmm2,qword ptr[rdi+2*rax]
	vpunpcklwd xmm2,xmm2,xmm4
	vcvtdq2ps xmm2,xmm2
	vmulps xmm2,xmm2,xmm0
	vcvtps2dq xmm2,xmm2
	vpackusdw xmm2,xmm2,xmm2
	vmovq qword ptr[rdi+2*rax],xmm2
	add rax,4
	dec ecx
	jnz short Convert_16_RGB64_HLG_OOTF_AVX512_5
	
Convert_16_RGB64_HLG_OOTF_AVX512_4:
	add rdi,r11
	add rsi,rdx
	dec r9d
	jnz Convert_16_RGB64_HLG_OOTF_AVX512_1
	
	vzeroupper

	pop rbx
	pop rdi
	pop rsi
	pop rbp

	ret

JPSDR_HDRTools_Convert_16_RGB64_HLG_OOTF_AVX512 endp


;JPSDR_HDRTools_Convert_RGBPS_HLG_OOTF_Scale_AVX512 proc dstR:dword,dstG:dword,dstB:dword,srcY:dword,w16:dword,h:dword,
;	dst_pitchR:dword,dst_pitchG:dword,dst_pitchB:dword,src_pitchY:dword
; dstR = rcx
; dstG = rdx
; dstB = r8
; srcY = r9
	
JPSDR_HDRTools_Convert_RGBPS_HLG_OOTF_Scale_AVX512 proc public frame	

w16 equ dword ptr[rbp+48]
h equ dword ptr[rbp+56]
dst_pitch_R equ qword ptr[rbp+64]
dst_pitch_G equ qword ptr[rbp+72]
dst_pitch_B equ qword ptr[rbp+80]
src_pitchY equ qword ptr[rbp+88]

	push rbp
	.pushreg rbp
	mov rbp,rsp
	push rsi
	.pushreg rsi
	push rbx
	.pushreg rbx
	push r12
	.pushreg r12
	push r13
	.pushreg r13
	push r14
	.pushreg r14
	.endprolog	
	
	mov rsi,r9		; srcY
	mov r9,rcx		; dstR
	mov r10,rdx		; dstG
	
	mov r11d,h
	mov r12,dst_pitch_R
	mov r13,dst_pitch_G
	mov r14,dst_pitch_B
	mov rdx,src_pitchY
	vmovaps zmm4,ZMMWORD ptr data_f_1
	
	mov ebx,w16
	
Convert_RGBPS_HLG_OOTF_Scale_AVX512_1:
	xor rax,rax
	mov ecx,ebx
Convert_RGBPS_HLG_OOTF_Scale_AVX512_2:
	vmovaps zmm0,ZMMWORD ptr[rsi+rax]
	vmulps zmm1,zmm0,ZMMWORD ptr[r9+rax]
	vmulps zmm2,zmm0,ZMMWORD ptr[r10+rax]
	vmulps zmm3,zmm0,ZMMWORD ptr[r8+rax]
	vminps zmm1,zmm1,zmm4
	vminps zmm2,zmm2,zmm4
	vminps zmm3,zmm3,zmm4
	vmovaps ZMMWORD ptr[r9+rax],zmm1
	vmovaps ZMMWORD ptr[r10+rax],zmm2
	vmovaps ZMMWORD ptr[r8+rax],zmm3
	
	add rax,64
	dec ecx
	jnz short Convert_RGBPS_HLG_OOTF_Scale_AVX512_2
	
	add r9,r12
	add r10,r13
	add r8,r14
	add rsi,rdx
	dec r11d
	
	jnz short Convert_RGBPS_HLG_OOTF_Scale_AVX512_1
	
	vzeroupper
	
	pop r14
	pop r13
	pop r12
	pop rbx
	pop rsi
	pop rbp

	ret

JPSDR_HDRTools_Convert_RGBPS_HLG_OOTF_Scale_AVX512 endp


;***************************************************
;**           XYZ/HDR/SDR functions               **
;***************************************************


;JPSDR_HDRTools_Scale_20_XYZ_AVX512 proc src:dword,dst:dword,w16:dword,h:dword,src_pitch:dword,dst_pitch:dword,
;	ValMin:dword,Coeff:dword
; src = rcx
; dst = rdx
; w16 = r8d
; h = r9d

JPSDR_HDRTools_Scale_20_XYZ_AVX512 proc public frame

src_pitch equ qword ptr[rbp+48]
dst_pitch equ qword ptr[rbp+56]
ValMin equ qword ptr[rbp+64]
Coeff equ qword ptr[rbp+72]

	push rbp
	.pushreg rbp
	mov rbp,rsp
	push rsi
	.pushreg rsi
	.endprolog

	mov rsi,ValMin
	vbroadcastss zmm1,dword ptr[rsi]
	mov rsi,Coeff
	vbroadcastss zmm2,dword ptr[rsi]
	
	vmovdqa64 zmm3,ZMMWORD ptr data_dw_1048575
	vmovdqa64 zmm4,ZMMWORD ptr data_dw_0
	vmulps zmm2,zmm2,ZMMWORD ptr data_f_1048575
	
	mov rsi,rcx
	mov r10,src_pitch
	mov r11,dst_pitch
	
Scale_20_XYZ_AVX512_1:
	xor rax,rax
	mov ecx,r8d
Scale_20_XYZ_AVX512_2:
	vaddps zmm0,zmm1,ZMMWORD ptr[rsi+rax]
	vmulps zmm0,zmm0,zmm2
	vcvtps2dq zmm0,zmm0
	vpminsd zmm0,zmm0,zmm3
	vpmaxsd zmm0,zmm0,zmm4
	vmovdqa64 ZMMWORD ptr[rdx+rax],zmm0
	
	add rax,64
	dec ecx
	jnz short Scale_20_XYZ_AVX512_2
	
	add rsi,r10
	add rdx,r11
	dec r9d
	jnz short Scale_20_XYZ_AVX512_1
	
	vzeroupper
	
	pop rsi
	pop rbp

	ret

JPSDR_HDRTools_Scale_20_XYZ_AVX512 endp


;JPSDR_HDRTools_Scale_20_RGB_AVX512 proc src:dword,dst:dword,w16:dword,h:dword,src_pitch:dword,dst_pitch:dword
; src = rcx
; dst = rdx
; w16 = r8d
; h = r9d

JPSDR_HDRTools_Scale_20_RGB_AVX512 proc public frame

src_pitch equ qword ptr[rbp+48]
dst_pitch equ qword ptr[rbp+56]
ValMin equ qword ptr[rbp+64]
Coeff equ qword ptr[rbp+72]

	push rbp
	.pushreg rbp
	mov rbp,rsp
	push rsi
	.pushreg rsi
	.endprolog

	vmovaps zmm1,ZMMWORD ptr data_f_1048575
	vmovdqa64 zmm2,ZMMWORD ptr data_dw_1048575
	vmovdqa64 zmm3,ZMMWORD ptr data_dw_0
	
	mov rsi,rcx
	mov r10,src_pitch
	mov r11,dst_pitch
	
Scale_20_RGB_AVX512_1:
	xor rax,rax
	mov ecx,r8d
Scale_20_RGB_AVX512_2:
	vmulps zmm0,zmm1,ZMMWORD ptr[rsi+rax]
	vcvtps2dq zmm0,zmm0
	vpminsd zmm0,zmm0,zmm2
	vpmaxsd zmm0,zmm0,zmm3
	vmovdqa64 ZMMWORD ptr[rdx+rax],zmm0
	
	add rax,64
	dec ecx
	jnz short Scale_20_RGB_AVX512_2
	
	add rsi,r10
	add rdx,r11
	dec r9d
	jnz short Scale_20_RGB_AVX512_1
	
	vzeroupper
	
	pop rsi
	pop rbp

	ret

JPSDR_HDRTools_Scale_20_RGB_AVX512 endp


;JPSDR_HDRTools_Convert_XYZ_HDRtoSDR_32_AVX512 proc src:dword,dst:dword,w16:dword,h:dword,src_pitch:dword,dst_pitch:dword,
;	Coeff:dword
; src = rcx
; dst = rdx
; w16 = r8d
; h = r9d

JPSDR_HDRTools_Convert_XYZ_HDRtoSDR_32_AVX512 proc public frame

src_pitch equ qword ptr[rbp+48]
dst_pitch equ qword ptr[rbp+56]
Coeff equ qword ptr[rbp+64]

	push rbp
	.pushreg rbp
	mov rbp,rsp
	push rsi
	.pushreg rsi
	push rbx
	.pushreg rbx
	push r12
	.pushreg r12
	.endprolog

	mov rsi,Coeff
	vbroadcastss zmm4,dword ptr[rsi]

	mov rsi,rcx
	mov r10,src_pitch
	mov r11,dst_pitch
	mov rbx,256
	mov r12,128
	
Convert_XYZ_HDRtoSDR_32_AVX512_loop_1:
	mov ecx,r8d
	xor rax,rax

	shr ecx,2
	jz short Convert_XYZ_HDRtoSDR_32_AVX512_1

Convert_XYZ_HDRtoSDR_32_AVX512_loop_2:
	vmulps zmm0,zmm4,ZMMWORD ptr[rsi+rax]
	vmulps zmm1,zmm4,ZMMWORD ptr[rsi+rax+64]
	vmulps zmm2,zmm4,ZMMWORD ptr[rsi+rax+128]
	vmulps zmm3,zmm4,ZMMWORD ptr[rsi+rax+192]
	vmovaps ZMMWORD ptr[rdx+rax],zmm0
	vmovaps ZMMWORD ptr[rdx+rax+64],zmm1
	vmovaps ZMMWORD ptr[rdx+rax+128],zmm2
	vmovaps ZMMWORD ptr[rdx+rax+192],zmm3
	
	add rax,rbx
	dec ecx
	jnz short Convert_XYZ_HDRtoSDR_32_AVX512_loop_2

Convert_XYZ_HDRtoSDR_32_AVX512_1:
	test r8d,2
	jz short Convert_XYZ_HDRtoSDR_32_AVX512_2

	vmulps zmm0,zmm4,ZMMWORD ptr[rsi+rax]
	vmulps zmm1,zmm4,ZMMWORD ptr[rsi+rax+64]
	vmovaps ZMMWORD ptr[rdx+rax],zmm0
	vmovaps ZMMWORD ptr[rdx+rax+64],zmm1
	
	add rax,r12

Convert_XYZ_HDRtoSDR_32_AVX512_2:
	test r8d,1
	jz short Convert_XYZ_HDRtoSDR_32_AVX512_3

	vmulps zmm0,zmm4,ZMMWORD ptr[rsi+rax]
	vmovaps ZMMWORD ptr[rdx+rax],zmm0

Convert_XYZ_HDRtoSDR_32_AVX512_3:
	add rsi,r10
	add rdx,r11
	dec r9d
	jnz Convert_XYZ_HDRtoSDR_32_AVX512_loop_1
	
	vzeroupper
	
	pop r12
	pop rbx
	pop rsi
	pop rbp

	ret

JPSDR_HDRTools_Convert_XYZ_HDRtoSDR_32_AVX512 endp


;JPSDR_HDRTools_Convert_XYZ_SDRtoHDR_32_AVX512 proc src:dword,dst:dword,w16:dword,h:dword,src_pitch:dword,dst_pitch:dword,
;	Coeff:dword
; src = rcx
; dst = rdx
; w16 = r8d
; h = r9d

JPSDR_HDRTools_Convert_XYZ_SDRtoHDR_32_AVX512 proc public frame

src_pitch equ qword ptr[rbp+48]
dst_pitch equ qword ptr[rbp+56]
Coeff equ qword ptr[rbp+64]

	push rbp
	.pushreg rbp
	mov rbp,rsp
	push rsi
	.pushreg rsi
	push rbx
	.pushreg rbx
	push r12
	.pushreg r12
	.endprolog

	mov rsi,Coeff
	vbroadcastss zmm4,dword ptr[rsi]
	
	mov rsi,rcx
	mov r10,src_pitch
	mov r11,dst_pitch
	mov rbx,256
	mov r12,128

Convert_XYZ_SDRtoHDR_32_AVX512_loop_1:
	mov ecx,r8d
	xor rax,rax

	shr ecx,2
	jz short Convert_XYZ_SDRtoHDR_32_AVX512_1

Convert_XYZ_SDRtoHDR_32_AVX512_loop_2:	
	vmulps zmm0,zmm4,ZMMWORD ptr[rsi+rax]
	vmulps zmm1,zmm4,ZMMWORD ptr[rsi+rax+64]
	vmulps zmm2,zmm4,ZMMWORD ptr[rsi+rax+128]
	vmulps zmm3,zmm4,ZMMWORD ptr[rsi+rax+192]
	vmovaps ZMMWORD ptr[rdx+rax],zmm0
	vmovaps ZMMWORD ptr[rdx+rax+64],zmm1
	vmovaps ZMMWORD ptr[rdx+rax+128],zmm2
	vmovaps ZMMWORD ptr[rdx+rax+192],zmm3
	
	add rax,rbx
	dec ecx
	jnz short Convert_XYZ_SDRtoHDR_32_AVX512_loop_2

Convert_XYZ_SDRtoHDR_32_AVX512_1:
	test r8d,2
	jz short Convert_XYZ_SDRtoHDR_32_AVX512_2

	vmulps zmm0,zmm4,ZMMWORD ptr[rsi+rax]
	vmulps zmm1,zmm4,ZMMWORD ptr[rsi+rax+64]
	vmovaps ZMMWORD ptr[rdx+rax],zmm0
	vmovaps ZMMWORD ptr[rdx+rax+64],zmm1
	
	add rax,r12

Convert_XYZ_SDRtoHDR_32_AVX512_2:
	test r8d,1
	jz short Convert_XYZ_SDRtoHDR_32_AVX512_3

	vmulps zmm0,zmm4,ZMMWORD ptr[rsi+rax]
	vmovaps ZMMWORD ptr[rdx+rax],zmm0
	
Convert_XYZ_SDRtoHDR_32_AVX512_3:
	add rsi,r10
	add rdx,r11
	dec r9d
	jnz Convert_XYZ_SDRtoHDR_32_AVX512_loop_1
	
	vzeroupper
	
	pop r12
	pop rbx
	pop rsi
	pop rbp

	ret

JPSDR_HDRTools_Convert_XYZ_SDRtoHDR_32_AVX512 endp


;JPSDR_HDRTools_Convert_XYZ_Hable_HDRtoSDR_AVX512 proc src:dword,dst:dword,w16:dword,h:dword,src_pitch:dword,dst_pitch:dword,
;	Coeff1:dword,Coeff2:dword,Coeff3:dword,Coeff4:dword,Coeff5:dword,Coeff6:dword
; src = rcx
; dst = rdx
; w16 = r8d
; h = r9d

JPSDR_HDRTools_Convert_XYZ_Hable_HDRtoSDR_AVX512 proc public frame

src_pitch equ qword ptr[rbp+48]
dst_pitch equ qword ptr[rbp+56]
Coeff1 equ qword ptr[rbp+64]
Coeff2 equ qword ptr[rbp+72]
Coeff3 equ qword ptr[rbp+80]
Coeff4 equ qword ptr[rbp+88]
Coeff5 equ qword ptr[rbp+96]
Coeff6 equ qword ptr[rbp+104]

	push rbp
	.pushreg rbp
	mov rbp,rsp
	push rsi
	.pushreg rsi
	push rdi
	.pushreg rdi
	.endprolog
	
	mov rsi,Coeff1
	vbroadcastss zmm16,dword ptr[rsi]
	mov rsi,Coeff2
	vbroadcastss zmm17,dword ptr[rsi]
	mov rsi,Coeff3
	vbroadcastss zmm18,dword ptr[rsi]
	mov rsi,Coeff4
	vbroadcastss zmm19,dword ptr[rsi]
	mov rsi,Coeff5
	vbroadcastss zmm20,dword ptr[rsi]
	mov rsi,Coeff6
	vbroadcastss zmm21,dword ptr[rsi]
	
	mov rsi,rcx
	mov rdi,rdx
	mov r10,src_pitch
	mov r11,dst_pitch
	mov rdx,128
	
Convert_XYZ_Hable_HDRtoSDR_AVX512_loop_1:
	mov ecx,r8d
	xor rax,rax

	shr ecx,1
	jz Convert_XYZ_Hable_HDRtoSDR_AVX512_1

Convert_XYZ_Hable_HDRtoSDR_AVX512_loop_2:	
	vmovaps zmm0,ZMMWORD ptr[rsi+rax]
	vmovaps zmm3,ZMMWORD ptr[rsi+rax+64]
	
	vmulps zmm1,zmm0,zmm16
	vmulps zmm4,zmm3,zmm16
	vmovaps zmm2,zmm1
	vmovaps zmm5,zmm4
	vaddps zmm1,zmm1,zmm19
	vaddps zmm4,zmm4,zmm19
	vmulps zmm1,zmm1,zmm0
	vmulps zmm4,zmm4,zmm3
	vaddps zmm1,zmm1,zmm20
	vaddps zmm4,zmm4,zmm20

	vaddps zmm2,zmm2,zmm17
	vaddps zmm5,zmm5,zmm17
	vmulps zmm2,zmm2,zmm0
	vmulps zmm5,zmm5,zmm3
	vaddps zmm2,zmm2,zmm18
	vaddps zmm5,zmm5,zmm18
	vdivps zmm2,zmm2,zmm1
	vdivps zmm5,zmm5,zmm4
	vsubps zmm2,zmm2,zmm21
	vsubps zmm5,zmm5,zmm21
	
	vmovaps ZMMWORD ptr [rdi+rax],zmm2
	vmovaps ZMMWORD ptr [rdi+rax+64],zmm5

	add rax,rdx
	dec ecx
	jnz Convert_XYZ_Hable_HDRtoSDR_AVX512_loop_2

Convert_XYZ_Hable_HDRtoSDR_AVX512_1:
	test r8d,1
	jz short Convert_XYZ_Hable_HDRtoSDR_AVX512_2

	vmovaps zmm0,ZMMWORD ptr[rsi+rax]
	
	vmulps zmm1,zmm0,zmm16
	vmovaps zmm2,zmm1
	vaddps zmm1,zmm1,zmm19
	vmulps zmm1,zmm1,zmm0
	vaddps zmm1,zmm1,zmm20
	
	vaddps zmm2,zmm2,zmm17
	vmulps zmm2,zmm2,zmm0
	vaddps zmm2,zmm2,zmm18
	vdivps zmm2,zmm2,zmm1
	vsubps zmm2,zmm2,zmm21
	
	vmovaps ZMMWORD ptr [rdi+rax],zmm2
	
Convert_XYZ_Hable_HDRtoSDR_AVX512_2:
	add rsi,r10
	add rdi,r11
	dec r9d
	jnz Convert_XYZ_Hable_HDRtoSDR_AVX512_loop_1
	
	vzeroupper
	
	pop rdi
	pop rsi
	pop rbp

	ret

JPSDR_HDRTools_Convert_XYZ_Hable_HDRtoSDR_AVX512 endp


;JPSDR_HDRTools_Convert_XYZ_Mobius_HDRtoSDR_AVX512 proc src:dword,dst:dword,w16:dword,h:dword,src_pitch:dword,dst_pitch:dword,
;	Coeff1:dword,Coeff2:dword,Coeff3:dword,Coeff4:dword
; src = rcx
; dst = rdx
; w16 = r8d
; h = r9d

JPSDR_HDRTools_Convert_XYZ_Mobius_HDRtoSDR_AVX512 proc public frame

src_pitch equ qword ptr[rbp+48]
dst_pitch equ qword ptr[rbp+56]
Coeff1 equ qword ptr[rbp+64]
Coeff2 equ qword ptr[rbp+72]
Coeff3 equ qword ptr[rbp+80]
Coeff4 equ qword ptr[rbp+88]

	push rbp
	.pushreg rbp
	mov rbp,rsp
	push rsi
	.pushreg rsi
	push rdi
	.pushreg rdi
	.endprolog
	
	mov rsi,Coeff1
	vbroadcastss zmm18,dword ptr[rsi]
	mov rsi,Coeff2
	vbroadcastss zmm19,dword ptr[rsi]
	mov rsi,Coeff3
	vbroadcastss zmm20,dword ptr[rsi]
	mov rsi,Coeff4
	vbroadcastss zmm21,dword ptr[rsi]
	
	vmovaps zmm22,ZMMWORD ptr data_all_1
	
	mov rsi,rcx
	mov rdi,rdx
	mov r10,src_pitch
	mov r11,dst_pitch
	mov rdx,128
	
Convert_XYZ_Mobius_HDRtoSDR_AVX512_loop_1:
	mov ecx,r8d
	xor rax,rax

	shr ecx,1
	jz Convert_XYZ_Mobius_HDRtoSDR_AVX512_1

Convert_XYZ_Mobius_HDRtoSDR_AVX512_loop_2:	
	vmovaps zmm0,ZMMWORD ptr[rsi+rax]
	vmovaps zmm4,ZMMWORD ptr[rsi+rax+64]
	
	;vcmpleps zmm2,zmm0,zmm8
	;vcmpleps zmm6,zmm4,zmm8
	vxorps zmm2,zmm2,zmm2
	vxorps zmm16,zmm16,zmm16
	vcmpps k1,zmm0,zmm18,2
	vcmpps k2,zmm4,zmm18,2
	vorps zmm2 {k1},zmm2,zmm22
	vorps zmm16 {k2},zmm16,zmm22
	vaddps zmm1,zmm0,zmm21
	vaddps zmm5,zmm4,zmm21
	vaddps zmm3,zmm0,zmm20
	vaddps zmm17,zmm4,zmm20
	vmulps zmm3,zmm3,zmm19
	vmulps zmm17,zmm17,zmm19
	vdivps zmm3,zmm3,zmm1
	vdivps zmm17,zmm17,zmm5
	vandps zmm0,zmm0,zmm2
	vandps zmm4,zmm4,zmm16
	vxorps zmm2,zmm2,zmm22
	vxorps zmm16,zmm16,zmm22
	vandps zmm3,zmm3,zmm2
	vandps zmm17,zmm17,zmm16
	vorps zmm0,zmm0,zmm3
	vorps zmm4,zmm4,zmm17
	
	vmovaps ZMMWORD ptr [rdi+rax],zmm0
	vmovaps ZMMWORD ptr [rdi+rax+64],zmm4

	add rax,rdx
	dec ecx
	jnz Convert_XYZ_Mobius_HDRtoSDR_AVX512_loop_2

Convert_XYZ_Mobius_HDRtoSDR_AVX512_1:
	test r8d,1
	jz short Convert_XYZ_Mobius_HDRtoSDR_AVX512_2

	vmovaps zmm0,ZMMWORD ptr[rsi+rax]
	
	;vcmpleps zmm2,zmm0,zmm8
	vxorps zmm2,zmm2,zmm2
	vcmpps k1,zmm0,zmm18,2
	vaddps zmm1,zmm0,zmm21
	vaddps zmm3,zmm0,zmm20
	vorps zmm2 {k1},zmm2,zmm22
	vmulps zmm3,zmm3,zmm19
	vdivps zmm3,zmm3,zmm1
	vandps zmm0,zmm0,zmm2
	vxorps zmm2,zmm2,zmm22
	vandps zmm3,zmm3,zmm2
	vorps zmm0,zmm0,zmm3
	
	vmovaps ZMMWORD ptr [rdi+rax],zmm0

Convert_XYZ_Mobius_HDRtoSDR_AVX512_2:
	add rsi,r10
	add rdi,r11
	dec r9d
	jnz Convert_XYZ_Mobius_HDRtoSDR_AVX512_loop_1

	vzeroupper
	
	pop rdi
	pop rsi
	pop rbp

	ret

JPSDR_HDRTools_Convert_XYZ_Mobius_HDRtoSDR_AVX512 endp


;JPSDR_HDRTools_Convert_XYZ_Reinhard_HDRtoSDR_AVX512 proc src:dword,dst:dword,w16:dword,h:dword,src_pitch:dword,dst_pitch:dword,
;	Coeff1:dword,Coeff2:dword
; src = rcx
; dst = rdx
; w16 = r8d
; h = r9d

JPSDR_HDRTools_Convert_XYZ_Reinhard_HDRtoSDR_AVX512 proc public frame

src_pitch equ qword ptr[rbp+48]
dst_pitch equ qword ptr[rbp+56]
Coeff1 equ qword ptr[rbp+64]
Coeff2 equ qword ptr[rbp+72]

	push rbp
	.pushreg rbp
	mov rbp,rsp
	push rsi
	.pushreg rsi
	push rdi
	.pushreg rdi
	.endprolog
	
	mov rsi,Coeff1
	vbroadcastss zmm4,dword ptr[rsi]
	mov rsi,Coeff2
	vbroadcastss zmm5,dword ptr[rsi]
	
	mov rsi,rcx
	mov rdi,rdx
	mov r10,src_pitch
	mov r11,dst_pitch
	mov rdx,128
	
Convert_XYZ_Reinhard_HDRtoSDR_AVX512_loop_1:
	mov ecx,r8d
	xor rax,rax

	shr ecx,1
	jz short Convert_XYZ_Reinhard_HDRtoSDR_AVX512_1

Convert_XYZ_Reinhard_HDRtoSDR_AVX512_loop_2:	
	vmovaps zmm0,ZMMWORD ptr[rsi+rax]
	vmovaps zmm2,ZMMWORD ptr[rsi+rax+64]
	
	vaddps zmm1,zmm0,zmm5
	vaddps zmm3,zmm2,zmm5
	vdivps zmm0,zmm0,zmm1
	vdivps zmm2,zmm2,zmm3
	vmulps zmm0,zmm0,zmm4
	vmulps zmm2,zmm2,zmm4
	
	vmovaps ZMMWORD ptr [rdi+rax],zmm0
	vmovaps ZMMWORD ptr [rdi+rax+64],zmm2

	add rax,rdx
	dec ecx
	jnz short Convert_XYZ_Reinhard_HDRtoSDR_AVX512_loop_2

Convert_XYZ_Reinhard_HDRtoSDR_AVX512_1:
	test r8d,1
	jz short Convert_XYZ_Reinhard_HDRtoSDR_AVX512_2

	vmovaps zmm0,ZMMWORD ptr[rsi+rax]
	
	vaddps zmm1,zmm0,zmm5
	vdivps zmm0,zmm0,zmm1
	vmulps zmm0,zmm0,zmm4
	
	vmovaps ZMMWORD ptr [rdi+rax],zmm0

Convert_XYZ_Reinhard_HDRtoSDR_AVX512_2:
	add rsi,r10
	add rdi,r11
	dec r9d
	jnz Convert_XYZ_Reinhard_HDRtoSDR_AVX512_loop_1
	
	vzeroupper
	
	pop rdi
	pop rsi
	pop rbp

	ret

JPSDR_HDRTools_Convert_XYZ_Reinhard_HDRtoSDR_AVX512 endp


;JPSDR_HDRTools_BT2446C_16_XYZ_AVX512 proc src:dword,dst1:dword,dst2:dword,w16:dword,h:dword,src_pitch:dword,
;	dst_pitch1:dword,dst_pitch2:dword,ValMinX:dword,CoeffX:dword,ValMinZ:dword,CoeffZ:dword
; src = rcx
; dst1 = rdx
; dst2 = r8
; w16 = r9d

JPSDR_HDRTools_BT2446C_16_XYZ_AVX512 proc public frame

h equ dword ptr[rbp+48]
src_pitch equ qword ptr[rbp+56]
dst_pitch1 equ qword ptr[rbp+64]
dst_pitch2 equ qword ptr[rbp+72]
ValMinX equ qword ptr[rbp+80]
CoeffX equ qword ptr[rbp+88]
ValMinZ equ qword ptr[rbp+96]
CoeffZ equ qword ptr[rbp+104]

	push rbp
	.pushreg rbp
	mov rbp,rsp
	push rsi
	.pushreg rsi
	push r12
	.pushreg r12
	push r13
	.pushreg r13
	.endprolog

	mov rsi,ValMinX
	vbroadcastss zmm2,dword ptr[rsi]
	mov rsi,CoeffX
	vbroadcastss zmm3,dword ptr[rsi]
	mov rsi,ValMinZ
	vbroadcastss zmm4,dword ptr[rsi]
	mov rsi,CoeffZ
	vbroadcastss zmm5,dword ptr[rsi]
	
	vmovdqa64 zmm16,ZMMWORD ptr data_dw_65535
	vmovdqa64 zmm17,ZMMWORD ptr data_dw_0
	vmulps zmm3,zmm3,ZMMWORD ptr data_f_65535
	vmulps zmm5,zmm5,ZMMWORD ptr data_f_65535
	
	mov rsi,rcx
	mov r10,src_pitch
	mov r11,dst_pitch1
	mov r12,dst_pitch2
	mov r13d,h
	
BT2446C_16_XYZ_AVX512_1:
	xor rax,rax
	mov ecx,r9d
BT2446C_16_XYZ_AVX512_2:
	vmovaps zmm18,ZMMWORD ptr[rsi+rax]
	vmulps zmm0,zmm18,ZMMWORD ptr[rdx+rax]
	vmulps zmm1,zmm18,ZMMWORD ptr[r8+rax]	
	vaddps zmm0,zmm0,zmm2
	vaddps zmm1,zmm1,zmm4
	vmulps zmm0,zmm0,zmm3
	vmulps zmm1,zmm1,zmm5
	vcvtps2dq zmm0,zmm0
	vcvtps2dq zmm1,zmm1
	vpminsd zmm0,zmm0,zmm16
	vpminsd zmm1,zmm1,zmm16
	vpmaxsd zmm0,zmm0,zmm17
	vpmaxsd zmm1,zmm1,zmm17
	vmovdqa64 ZMMWORD ptr[rdx+rax],zmm0
	vmovdqa64 ZMMWORD ptr[r8+rax],zmm1
	
	add rax,64
	dec ecx
	jnz short BT2446C_16_XYZ_AVX512_2
	
	add rsi,r10
	add rdx,r11
	add r8,r12
	dec r13d
	jnz short BT2446C_16_XYZ_AVX512_1
	
	vzeroupper
	
	pop r13
	pop r12
	pop rsi
	pop rbp

	ret

JPSDR_HDRTools_BT2446C_16_XYZ_AVX512 endp


;JPSDR_HDRTools_BT2446C_32_XYZ_AVX512 proc src1:dword,src2:dword,dst1:dword,dst2:dword,w16:dword,h:dword,src_pitch1:dword,
;	src_pitch2:dword,dst_pitch1:dword,dst_pitch2:dword
; src1 = rcx
; src2 = rdx
; dst1 = r8
; dst2 = r9

JPSDR_HDRTools_BT2446C_32_XYZ_AVX512 proc public frame

w16 equ dword ptr[rbp+48]
h equ dword ptr[rbp+56]
src_pitch1 equ qword ptr[rbp+64]
src_pitch2 equ qword ptr[rbp+72]
dst_pitch1 equ qword ptr[rbp+80]
dst_pitch2 equ qword ptr[rbp+88]

	push rbp
	.pushreg rbp
	mov rbp,rsp
	push rsi
	.pushreg rsi
	push rbx
	.pushreg rbx
	push r12
	.pushreg r12
	push r13
	.pushreg r13
	push r14
	.pushreg r14
	push r15
	.pushreg r15
	.endprolog

	mov rsi,rcx
	mov r10,src_pitch1
	mov r11,src_pitch2
	mov r12,dst_pitch1
	mov r13,dst_pitch2
	mov r14d,w16
	mov r15d,h
	mov rbx,128
	
BT2446C_32_XYZ_AVX512_loop_1:
	mov ecx,r14d
	xor rax,rax

	shr ecx,1
	jz short BT2446C_32_XYZ_AVX512_1

BT2446C_32_XYZ_AVX512_loop_2:
	vmovaps zmm2,ZMMWORD ptr[r8+rax]
	vmovaps zmm5,ZMMWORD ptr[r8+rax+64]
	vmulps zmm0,zmm2,ZMMWORD ptr[rsi+rax]
	vmulps zmm3,zmm5,ZMMWORD ptr[rsi+rax+64]
	vmulps zmm1,zmm2,ZMMWORD ptr[rdx+rax]
	vmulps zmm4,zmm5,ZMMWORD ptr[rdx+rax+64]
	vmovaps ZMMWORD ptr[r8+rax],zmm0
	vmovaps ZMMWORD ptr[r8+rax+64],zmm3
	vmovaps ZMMWORD ptr[r9+rax],zmm1
	vmovaps ZMMWORD ptr[r9+rax+64],zmm4
	
	add rax,rbx
	dec ecx
	jnz short BT2446C_32_XYZ_AVX512_loop_2

BT2446C_32_XYZ_AVX512_1:
	test r14d,1
	jz short BT2446C_32_XYZ_AVX512_2

	vmovaps zmm2,ZMMWORD ptr[r8+rax]
	vmulps zmm0,zmm2,ZMMWORD ptr[rsi+rax]
	vmulps zmm1,zmm2,ZMMWORD ptr[rdx+rax]
	vmovaps ZMMWORD ptr[r8+rax],zmm0
	vmovaps ZMMWORD ptr[r9+rax],zmm1

BT2446C_32_XYZ_AVX512_2:
	add rsi,r10
	add rdx,r11
	add r8,r12
	add r9,r13
	dec r15d
	jnz BT2446C_32_XYZ_AVX512_loop_1
	
	pop r15
	pop r14
	pop r13
	pop r12
	pop rbx
	pop rsi
	pop rbp

	ret

JPSDR_HDRTools_BT2446C_32_XYZ_AVX512 endp


;JPSDR_HDRTools_Convert_XYZ_ACES_HDRtoSDR_AVX512 proc src:dword,dst:dword,w16:dword,h:dword,src_pitch:dword,dst_pitch:dword,
;	Coeff1:dword,Coeff2:dword,Coeff3:dword,Coeff4:dword,Coeff5:dword
; src = rcx
; dst = rdx
; w16 = r8d
; h = r9d

JPSDR_HDRTools_Convert_XYZ_ACES_HDRtoSDR_AVX512 proc public frame

src_pitch equ qword ptr[rbp+48]
dst_pitch equ qword ptr[rbp+56]
Coeff1 equ qword ptr[rbp+64]
Coeff2 equ qword ptr[rbp+72]
Coeff3 equ qword ptr[rbp+80]
Coeff4 equ qword ptr[rbp+88]
Coeff5 equ qword ptr[rbp+96]

	push rbp
	.pushreg rbp
	mov rbp,rsp
	push rsi
	.pushreg rsi
	push rdi
	.pushreg rdi
	.endprolog
	
	mov rsi,Coeff1
	vbroadcastss zmm16,dword ptr[rsi]
	mov rsi,Coeff2
	vbroadcastss zmm17,dword ptr[rsi]
	mov rsi,Coeff3
	vbroadcastss zmm18,dword ptr[rsi]
	mov rsi,Coeff4
	vbroadcastss zmm19,dword ptr[rsi]
	mov rsi,Coeff5
	vbroadcastss zmm20,dword ptr[rsi]
	
	mov rsi,rcx
	mov rdi,rdx
	mov r10,src_pitch
	mov r11,dst_pitch
	mov rdx,128
	
Convert_XYZ_ACES_HDRtoSDR_AVX512_loop_1:
	mov ecx,r8d
	xor rax,rax

	shr ecx,1
	jz Convert_XYZ_ACES_HDRtoSDR_AVX512_1

Convert_XYZ_ACES_HDRtoSDR_AVX512_loop_2:	
	vmovaps zmm0,ZMMWORD ptr[rsi+rax]
	vmovaps zmm3,ZMMWORD ptr[rsi+rax+64]
	
	vmulps zmm2,zmm0,zmm18
	vmulps zmm5,zmm3,zmm18
	vaddps zmm1,zmm0,zmm16
	vaddps zmm4,zmm3,zmm16
	vaddps zmm2,zmm2,zmm19
	vaddps zmm5,zmm5,zmm19
	vmulps zmm1,zmm1,zmm0
	vmulps zmm4,zmm4,zmm3
	vmulps zmm2,zmm2,zmm0
	vmulps zmm5,zmm5,zmm3
	vaddps zmm1,zmm1,zmm17
	vaddps zmm4,zmm4,zmm17
	vaddps zmm2,zmm2,zmm20
	vaddps zmm5,zmm5,zmm20

	vdivps zmm1,zmm1,zmm2
	vdivps zmm4,zmm4,zmm5

	vmovaps ZMMWORD ptr [rdi+rax],zmm1
	vmovaps ZMMWORD ptr [rdi+rax+64],zmm4

	add rax,rdx
	dec ecx
	jnz Convert_XYZ_ACES_HDRtoSDR_AVX512_loop_2

Convert_XYZ_ACES_HDRtoSDR_AVX512_1:
	test r8d,1
	jz short Convert_XYZ_ACES_HDRtoSDR_AVX512_2

	vmovaps zmm0,ZMMWORD ptr[rsi+rax]
	
	vmulps zmm2,zmm0,zmm18
	vaddps zmm1,zmm0,zmm16
	vaddps zmm2,zmm2,zmm19
	vmulps zmm1,zmm1,zmm0
	vmulps zmm2,zmm2,zmm0
	vaddps zmm1,zmm1,zmm17
	vaddps zmm2,zmm2,zmm20
	
	vdivps zmm1,zmm1,zmm2
	
	vmovaps ZMMWORD ptr [rdi+rax],zmm1

Convert_XYZ_ACES_HDRtoSDR_AVX512_2:
	add rsi,r10
	add rdi,r11
	dec r9d
	jnz Convert_XYZ_ACES_HDRtoSDR_AVX512_loop_1
	
	vzeroupper

	pop rdi
	pop rsi
	pop rbp

	ret

JPSDR_HDRTools_Convert_XYZ_ACES_HDRtoSDR_AVX512 endp


;JPSDR_HDRTools_Convert_RGB_ACES_HDRtoSDR_AVX512 proc src:dword,dst:dword,w16:dword,h:dword,src_pitch:dword,dst_pitch:dword,
;	Coeff1:dword,Coeff2:dword,Coeff3:dword,Coeff4:dword,Coeff5:dword
; src = rcx
; dst = rdx
; w16 = r8d
; h = r9d

JPSDR_HDRTools_Convert_RGB_ACES_HDRtoSDR_AVX512 proc public frame

src_pitch equ qword ptr[rbp+48]
dst_pitch equ qword ptr[rbp+56]
Coeff1 equ qword ptr[rbp+64]
Coeff2 equ qword ptr[rbp+72]
Coeff3 equ qword ptr[rbp+80]
Coeff4 equ qword ptr[rbp+88]
Coeff5 equ qword ptr[rbp+96]

	push rbp
	.pushreg rbp
	mov rbp,rsp
	push rsi
	.pushreg rsi
	push rdi
	.pushreg rdi
	.endprolog

	mov rsi,Coeff1
	vbroadcastss zmm16,dword ptr[rsi]
	mov rsi,Coeff2
	vbroadcastss zmm17,dword ptr[rsi]
	mov rsi,Coeff3
	vbroadcastss zmm18,dword ptr[rsi]
	mov rsi,Coeff4
	vbroadcastss zmm19,dword ptr[rsi]
	mov rsi,Coeff5
	vbroadcastss zmm20,dword ptr[rsi]

	mov rsi,rcx
	mov rdi,rdx
	mov r10,src_pitch
	mov r11,dst_pitch
	mov rdx,128

Convert_RGB_ACES_HDRtoSDR_AVX512_loop_1:
	mov ecx,r8d
	xor rax,rax

	shr ecx,1
	jz Convert_RGB_ACES_HDRtoSDR_AVX512_1

Convert_RGB_ACES_HDRtoSDR_AVX512_loop_2:	
	vmovaps zmm0,ZMMWORD ptr[rsi+rax]
	vmovaps zmm3,ZMMWORD ptr[rsi+rax+64]

	vmulps zmm2,zmm0,zmm18
	vmulps zmm5,zmm3,zmm18
	vmulps zmm1,zmm0,zmm16
	vmulps zmm4,zmm3,zmm16
	vaddps zmm2,zmm2,zmm19
	vaddps zmm5,zmm5,zmm19
	vaddps zmm1,zmm1,zmm17
	vaddps zmm4,zmm4,zmm17
	vmulps zmm2,zmm2,zmm0
	vmulps zmm5,zmm5,zmm3
	vmulps zmm1,zmm1,zmm0
	vmulps zmm4,zmm4,zmm3
	vaddps zmm2,zmm2,zmm20
	vaddps zmm5,zmm5,zmm20

	vdivps zmm1,zmm1,zmm2
	vdivps zmm4,zmm4,zmm5

	vmovaps ZMMWORD ptr [rdi+rax],zmm1
	vmovaps ZMMWORD ptr [rdi+rax+64],zmm4

	add rax,rdx
	dec ecx
	jnz Convert_RGB_ACES_HDRtoSDR_AVX512_loop_2

Convert_RGB_ACES_HDRtoSDR_AVX512_1:
	test r8d,1
	jz short Convert_RGB_ACES_HDRtoSDR_AVX512_2

	vmovaps zmm0,ZMMWORD ptr[rsi+rax]

	vmulps zmm2,zmm0,zmm18
	vmulps zmm1,zmm0,zmm16
	vaddps zmm2,zmm2,zmm19
	vaddps zmm1,zmm1,zmm17
	vmulps zmm2,zmm2,zmm0
	vmulps zmm1,zmm1,zmm0
	vaddps zmm2,zmm2,zmm20

	vdivps zmm1,zmm1,zmm2

	vmovaps ZMMWORD ptr [rdi+rax],zmm1

Convert_RGB_ACES_HDRtoSDR_AVX512_2:
	add rsi,r10
	add rdi,r11
	dec r9d
	jnz Convert_RGB_ACES_HDRtoSDR_AVX512_loop_1

	vzeroupper

	pop rdi
	pop rsi
	pop rbp

	ret

JPSDR_HDRTools_Convert_RGB_ACES_HDRtoSDR_AVX512 endp

end
