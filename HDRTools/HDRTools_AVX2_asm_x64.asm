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

;JPSDR_HDRTools_Convert_Planar420_to_Planar422_8_AVX2 proc src1:dword,src2:dword,dst:dword,w:dword
; src1 = rcx
; src2 = rdx
; dst = r8
; w = r9d

JPSDR_HDRTools_Convert_Planar420_to_Planar422_8_AVX2 proc public frame

	.endprolog
		
	vpcmpeqb ymm3,ymm3,ymm3
	
	mov r10,rcx				; r10=src1
	xor rax,rax	
	mov ecx,r9d	
	mov r11,32
	
Convert_Planar420_to_Planar422_8_AVX2_1:
	vmovdqa ymm0,YMMWORD ptr[r10+rax]
	vmovdqa ymm1,YMMWORD ptr[rdx+rax]
	vpxor ymm2,ymm0,ymm3
	vpxor ymm1,ymm1,ymm3
	vpavgb ymm2,ymm2,ymm1
	vpxor ymm2,ymm2,ymm3
	vpavgb ymm2,ymm2,ymm0
	
	vmovdqa YMMWORD ptr[r8+rax],ymm2
	add rax,r11
	loop Convert_Planar420_to_Planar422_8_AVX2_1
	
	vzeroupper
	
	ret

JPSDR_HDRTools_Convert_Planar420_to_Planar422_8_AVX2 endp


;JPSDR_HDRTools_Convert_Planar420_to_Planar422_16_AVX2 proc src1:dword,src2:dword,dst:dword,w:dword
; src1 = rcx
; src2 = rdx
; dst = r8
; w = r9d

JPSDR_HDRTools_Convert_Planar420_to_Planar422_16_AVX2 proc public frame

	.endprolog
		
	vpcmpeqb ymm3,ymm3,ymm3
	
	mov r10,rcx				; r10=src1
	xor rax,rax	
	mov ecx,r9d	
	mov r11,32
	
Convert_Planar420_to_Planar422_16_AVX2_1:
	vmovdqa ymm0,YMMWORD ptr[r10+rax]
	vmovdqa ymm1,YMMWORD ptr[rdx+rax]
	vpxor ymm2,ymm0,ymm3
	vpxor ymm1,ymm1,ymm3
	vpavgw ymm2,ymm2,ymm1
	vpxor ymm2,ymm2,ymm3
	vpavgw ymm2,ymm2,ymm0
	
	vmovdqa YMMWORD ptr[r8+rax],ymm2
	add rax,r11
	loop Convert_Planar420_to_Planar422_16_AVX2_1
	
	vzeroupper
	
	ret

JPSDR_HDRTools_Convert_Planar420_to_Planar422_16_AVX2 endp


;***************************************************
;**           RGB to YUV functions                **
;***************************************************


;JPSDR_HDRTools_Convert_LinearRGBPStoRGB64_AVX2 proc src_R:dword,src_G:dword,src_B:dword,dst:dword,w:dword,h:dword,lookup:dword,
;	src_modulo_R:dword,src_modulo_G:dword,src_modulo_B:dword,dst_modulo:dword
; src_R = rcx
; src_G = rdx
; src_B = r8
; dst = r9

JPSDR_HDRTools_Convert_LinearRGBPStoRGB64_AVX2 proc public frame

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

	vmovaps ymm3,YMMWORD ptr data_f_1048575
	vmovaps ymm4,YMMWORD ptr data_f_0
	vmovaps ymm5,YMMWORD ptr data_f_1
	
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
	
Convert_LinearRGBPStoRGB64_AVX2_1:
	mov ecx,r11d
Convert_LinearRGBPStoRGB64_AVX2_2:
	xor rdx,rdx
	vmaxps ymm0,ymm4,YMMWORD ptr[r8]
	vmaxps ymm1,ymm4,YMMWORD ptr[r10]
	vmaxps ymm2,ymm4,YMMWORD ptr[r9]
	vminps ymm0,ymm0,ymm5
	vminps ymm1,ymm1,ymm5
	vminps ymm2,ymm2,ymm5
	vmulps ymm0,ymm0,ymm3
	vmulps ymm1,ymm1,ymm3
	vmulps ymm2,ymm2,ymm3
	vcvtps2dq ymm0,ymm0
	vcvtps2dq ymm1,ymm1
	vcvtps2dq ymm2,ymm2
	
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
	jz Convert_LinearRGBPStoRGB64_AVX2_3
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
	jz Convert_LinearRGBPStoRGB64_AVX2_3
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
	jz Convert_LinearRGBPStoRGB64_AVX2_3
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
	jz Convert_LinearRGBPStoRGB64_AVX2_3
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
	jz Convert_LinearRGBPStoRGB64_AVX2_3
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
	jz short Convert_LinearRGBPStoRGB64_AVX2_3
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
	jz short Convert_LinearRGBPStoRGB64_AVX2_3
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
	
Convert_LinearRGBPStoRGB64_AVX2_3:
	inc rdx	
	shl rdx,2	
	add r8,rdx
	add r10,rdx
	add r9,rdx	
	or ecx,ecx
	jnz Convert_LinearRGBPStoRGB64_AVX2_2
	
	add rdi,r15
	add r8,r14
	add r10,r13
	add r9,r12
	dec h
	jnz Convert_LinearRGBPStoRGB64_AVX2_1
	
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

JPSDR_HDRTools_Convert_LinearRGBPStoRGB64_AVX2 endp


;JPSDR_HDRTools_Convert_RGBPStoRGB64_AVX2 proc src_R:dword,src_G:dword,src_B:dword,dst:dword,w:dword,h:dword,
;	src_pitch_R:dword,src_pitch_G:dword,src_pitch_B:dword,dst_pitch:dword
; src_R = rcx
; src_G = rdx
; src_B = r8
; dst = r9

JPSDR_HDRTools_Convert_RGBPStoRGB64_AVX2 proc public frame

w equ dword ptr[rbp+48]
h equ dword ptr[rbp+56]
src_pitch_R equ qword ptr[rbp+64]
src_pitch_G equ qword ptr[rbp+72]
src_pitch_B equ qword ptr[rbp+80]
dst_pitch equ qword ptr[rbp+88]

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
	sub rsp,32
	.allocstack 32
	vmovdqa XMMWORD ptr[rsp],xmm6
	.savexmm128 xmm6,0
	vmovdqa XMMWORD ptr[rsp+16],xmm7
	.savexmm128 xmm7,16
	.endprolog	

	vmovaps ymm3,YMMWORD ptr data_f_65535
	vpxor xmm4,xmm4,xmm4
	
	mov rsi,rcx			; src_B=r8,src_G=rdx,src_R=rsi
	
	mov r11d,w
	mov r12,src_pitch_R
	mov r13,src_pitch_G
	mov r14,src_pitch_B
	mov r15,dst_pitch
	mov rbx,8
	mov r10d,h
	
Convert_RGBPStoRGB64_AVX2_1:
	mov ecx,r11d
	xor rax,rax
	shr ecx,3
	jz Convert_RGBPStoRGB64_AVX2_3
Convert_RGBPStoRGB64_AVX2_2:
	vmulps ymm0,ymm3,YMMWORD ptr[r8+4*rax]
	vmulps ymm1,ymm3,YMMWORD ptr[rsi+4*rax]
	vmulps ymm2,ymm3,YMMWORD ptr[rdx+4*rax]
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
		
	vmovdqa XMMWORD ptr[r9+8*rax],xmm0
	vmovdqa XMMWORD ptr[r9+8*rax+16],xmm1
	vmovdqa XMMWORD ptr[r9+8*rax+32],xmm5
	vmovdqa XMMWORD ptr[r9+8*rax+48],xmm6
	add rax,8
	dec ecx
	jnz Convert_RGBPStoRGB64_AVX2_2

Convert_RGBPStoRGB64_AVX2_3:
	mov ecx,r11d
	and ecx,7
	jz Convert_RGBPStoRGB64_AVX2_7
	
	vmulps ymm0,ymm3,YMMWORD ptr[r8+4*rax]
	vmulps ymm1,ymm3,YMMWORD ptr[rsi+4*rax]
	vmulps ymm2,ymm3,YMMWORD ptr[rdx+4*rax]
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
	vmovq qword ptr[r9+8*rax],xmm0
	jmp short Convert_RGBPStoRGB64_AVX2_7
	
Convert_RGBPStoRGB64_AVX2_4:
	vmovdqa XMMWORD ptr[r9+8*rax],xmm0
	test ecx,1
	jz short Convert_RGBPStoRGB64_AVX2_7
	vmovq qword ptr[r9+8*rax+16],xmm1
	jmp short Convert_RGBPStoRGB64_AVX2_7
	
Convert_RGBPStoRGB64_AVX2_5:
	vmovdqa XMMWORD ptr[r9+8*rax],xmm0
	vmovdqa XMMWORD ptr[r9+8*rax+16],xmm1
	test ecx,2
	jnz short Convert_RGBPStoRGB64_AVX2_6
	test ecx,1
	jz short Convert_RGBPStoRGB64_AVX2_7
	vmovq qword ptr[r9+8*rax+32],xmm5
	jmp short Convert_RGBPStoRGB64_AVX2_7
	
Convert_RGBPStoRGB64_AVX2_6:
	vmovdqa XMMWORD ptr[r9+8*rax+32],xmm5
	test ecx,1
	jz short Convert_RGBPStoRGB64_AVX2_7
	vmovq qword ptr[r9+8*rax+48],xmm6
	
Convert_RGBPStoRGB64_AVX2_7:
	add rsi,r12
	add rdx,r13
	add r8,r14
	add r9,r15
	dec r10d
	jnz Convert_RGBPStoRGB64_AVX2_1
	
	vmovdqa xmm7,XMMWORD ptr[rsp+16]
	vmovdqa xmm6,XMMWORD ptr[rsp]
	add rsp,32
	
	vzeroupper
	
	pop r15
	pop r14
	pop r13
	pop r12
	pop rbx
	pop rsi
	pop rbp

	ret

JPSDR_HDRTools_Convert_RGBPStoRGB64_AVX2 endp


;JPSDR_HDRTools_Convert_Planar422_to_Planar420_8_AVX2 proc src1:dword,src2:dword,dst:dword,w32:dword,h:dword,src_pitch2:dword,dst_pitch:dword
; src1 = rcx
; src2 = rdx
; dst = r8
; w32 = r9d

JPSDR_HDRTools_Convert_Planar422_to_Planar420_8_AVX2 proc public frame

h equ dword ptr[rbp+48]
src_pitch2 equ qword ptr[rbp+56]
dst_pitch equ qword ptr[rbp+64]

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
	
	mov rsi,rcx
	mov r10d,h
	mov rbx,32
	mov r11,src_pitch2
	mov r12,dst_pitch

Convert_Planar422_to_Planar420_8_AVX2_1:
	xor rax,rax
	mov ecx,r9d

Convert_Planar422_to_Planar420_8_AVX2_2:
	vmovdqa ymm0,YMMWORD ptr[rsi+rax]
	vpavgb ymm0,ymm0,YMMWORD ptr[rdx+rax]
	
	vmovdqa YMMWORD ptr[r8+rax],ymm0
	add rax,rbx
	loop Convert_Planar422_to_Planar420_8_AVX2_2
	
	add rsi,r11
	add rdx,r11
	add r8,r12
	dec r10d
	jnz short Convert_Planar422_to_Planar420_8_AVX2_1
	
	vzeroupper

	pop r12
	pop rbx
	pop rsi
	pop rbp

	ret

JPSDR_HDRTools_Convert_Planar422_to_Planar420_8_AVX2 endp


;JPSDR_HDRTools_Convert_Planar422_to_Planar420_16_AVX2 proc src1:dword,src2:dword,dst:dword,w16:dword,h:dword,src_pitch2:dword,dst_pitch:dword
; src1 = rcx
; src2 = rdx
; dst = r8
; w16 = r9d

JPSDR_HDRTools_Convert_Planar422_to_Planar420_16_AVX2 proc public frame

h equ dword ptr[rbp+48]
src_pitch2 equ qword ptr[rbp+56]
dst_pitch equ qword ptr[rbp+64]

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
	
	mov rsi,rcx
	mov r10d,h
	mov rbx,32
	mov r11,src_pitch2
	mov r12,dst_pitch

Convert_Planar422_to_Planar420_16_AVX2_1:
	xor rax,rax
	mov ecx,r9d

Convert_Planar422_to_Planar420_16_AVX2_2:
	vmovdqa ymm0,YMMWORD ptr[rsi+rax]
	vpavgw ymm0,ymm0,YMMWORD ptr[rdx+rax]
	
	vmovdqa YMMWORD ptr[r8+rax],ymm0
	add rax,rbx
	loop Convert_Planar422_to_Planar420_16_AVX2_2
	
	add rsi,r11
	add rdx,r11
	add r8,r12
	dec r10d
	jnz short Convert_Planar422_to_Planar420_16_AVX2_1

	vzeroupper
	
	pop r12
	pop rbx
	pop rsi
	pop rbp

	ret

JPSDR_HDRTools_Convert_Planar422_to_Planar420_16_AVX2 endp


;***************************************************
;**             XYZ/RGB functions                 **
;***************************************************


;***************************************************
;**               HLG functions                   **
;***************************************************


;JPSDR_HDRTools_Convert_RGB64_16toRGB64_8_AVX2 proc src:dword,dst:dword,w:dword,h:dword,
;	src_pitch:dword,dst_pitch:dword
; src = rcx
; dst = rdx
; w = r8d
; h = r9d
JPSDR_HDRTools_Convert_RGB64_16toRGB64_8_AVX2 proc public frame

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
	.endprolog

	vmovdqa ymm4,YMMWORD ptr data_w_128

	mov rsi,rcx
	mov rdi,rdx
	mov ebx,r8d
	mov r10,src_pitch
	mov r11,dst_pitch
	shr ebx,2
	mov rdx,128

Convert_RGB64_16toRGB64_8_AVX2_loop_1:
	mov ecx,ebx
	xor rax,rax

	shr ecx,2
	jz Convert_RGB64_16toRGB64_8_AVX2_3
	
Convert_RGB64_16toRGB64_8_AVX2_loop_2:
	vpaddusw ymm0,ymm4,YMMWORD ptr[rsi+rax]
	vpaddusw ymm1,ymm4,YMMWORD ptr[rsi+rax+32]
	vpaddusw ymm2,ymm4,YMMWORD ptr[rsi+rax+64]
	vpaddusw ymm3,ymm4,YMMWORD ptr[rsi+rax+96]
	vpsrlw ymm0,ymm0,8
	vpsrlw ymm1,ymm1,8
	vpsrlw ymm2,ymm2,8
	vpsrlw ymm3,ymm3,8
	vmovdqa YMMWORD ptr[rdi+rax],ymm0
	vmovdqa YMMWORD ptr[rdi+rax+32],ymm1
	vmovdqa YMMWORD ptr[rdi+rax+64],ymm2
	vmovdqa YMMWORD ptr[rdi+rax+96],ymm3
	add rax,rdx
	loop Convert_RGB64_16toRGB64_8_AVX2_loop_2

Convert_RGB64_16toRGB64_8_AVX2_3:
	test ebx,2
	jz short Convert_RGB64_16toRGB64_8_AVX2_4

	vpaddusw ymm0,ymm4,YMMWORD ptr[rsi+rax]
	vpaddusw ymm1,ymm4,YMMWORD ptr[rsi+rax+32]
	vpsrlw ymm0,ymm0,8
	vpsrlw ymm1,ymm1,8
	vmovdqa YMMWORD ptr[rdi+rax],ymm0
	vmovdqa YMMWORD ptr[rdi+rax+32],ymm1
	add rax,64

Convert_RGB64_16toRGB64_8_AVX2_4:
	test ebx,1
	jz short Convert_RGB64_16toRGB64_8_AVX2_5

	vpaddusw ymm0,ymm4,YMMWORD ptr[rsi+rax]
	vpsrlw ymm0,ymm0,8
	vmovdqa YMMWORD ptr[rdi+rax],ymm0
	add rax,32
	
Convert_RGB64_16toRGB64_8_AVX2_5:
	test r8d,2
	jz short Convert_RGB64_16toRGB64_8_AVX2_6

	vpaddusw xmm0,xmm4,XMMWORD ptr[rsi+rax]
	vpsrlw xmm0,xmm0,8
	vmovdqa XMMWORD ptr[rdi+rax],xmm0
	add rax,16

Convert_RGB64_16toRGB64_8_AVX2_6:
	test r8d,1
	jz short Convert_RGB64_16toRGB64_8_AVX2_7
	
	vmovq xmm0,qword ptr[rsi+rax]
	vpaddusw xmm0,xmm0,xmm4
	vpsrlw xmm0,xmm0,8
	vmovq qword ptr[rdi+rax],xmm0
	
Convert_RGB64_16toRGB64_8_AVX2_7:
	add rsi,r10
	add rdi,r11
	dec r9d
	jnz Convert_RGB64_16toRGB64_8_AVX2_loop_1
	
	vzeroupper
	
	pop rbx
	pop rsi
	pop rdi
	pop rbp

	ret

JPSDR_HDRTools_Convert_RGB64_16toRGB64_8_AVX2 endp


;JPSDR_HDRTools_Convert_RGB64_16toRGB64_10_AVX2 proc src:dword,dst:dword,w:dword,h:dword,
;	src_pitch:dword,dst_pitch:dword
; src = rcx
; dst = rdx
; w = r8d
; h = r9d
JPSDR_HDRTools_Convert_RGB64_16toRGB64_10_AVX2 proc public frame

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
	.endprolog

	vmovdqa ymm4,YMMWORD ptr data_w_32

	mov rsi,rcx
	mov rdi,rdx
	mov ebx,r8d
	mov r10,src_pitch
	mov r11,dst_pitch
	shr ebx,2
	mov rdx,128

Convert_RGB64_16toRGB64_10_AVX2_loop_1:
	mov ecx,ebx
	xor rax,rax

	shr ecx,2
	jz Convert_RGB64_16toRGB64_10_AVX2_3
	
Convert_RGB64_16toRGB64_10_AVX2_loop_2:
	vpaddusw ymm0,ymm4,YMMWORD ptr[rsi+rax]
	vpaddusw ymm1,ymm4,YMMWORD ptr[rsi+rax+32]
	vpaddusw ymm2,ymm4,YMMWORD ptr[rsi+rax+64]
	vpaddusw ymm3,ymm4,YMMWORD ptr[rsi+rax+96]
	vpsrlw ymm0,ymm0,6
	vpsrlw ymm1,ymm1,6
	vpsrlw ymm2,ymm2,6
	vpsrlw ymm3,ymm3,6
	vmovdqa YMMWORD ptr[rdi+rax],ymm0
	vmovdqa YMMWORD ptr[rdi+rax+32],ymm1
	vmovdqa YMMWORD ptr[rdi+rax+64],ymm2
	vmovdqa YMMWORD ptr[rdi+rax+96],ymm3
	add rax,rdx
	loop Convert_RGB64_16toRGB64_10_AVX2_loop_2

Convert_RGB64_16toRGB64_10_AVX2_3:
	test ebx,2
	jz short Convert_RGB64_16toRGB64_10_AVX2_4

	vpaddusw ymm0,ymm4,YMMWORD ptr[rsi+rax]
	vpaddusw ymm1,ymm4,YMMWORD ptr[rsi+rax+32]
	vpsrlw ymm0,ymm0,6
	vpsrlw ymm1,ymm1,6
	vmovdqa YMMWORD ptr[rdi+rax],ymm0
	vmovdqa YMMWORD ptr[rdi+rax+32],ymm1
	add rax,64

Convert_RGB64_16toRGB64_10_AVX2_4:
	test ebx,1
	jz short Convert_RGB64_16toRGB64_10_AVX2_5

	vpaddusw ymm0,ymm4,YMMWORD ptr[rsi+rax]
	vpsrlw ymm0,ymm0,6
	vmovdqa YMMWORD ptr[rdi+rax],ymm0
	add rax,32
	
Convert_RGB64_16toRGB64_10_AVX2_5:
	test r8d,2
	jz short Convert_RGB64_16toRGB64_10_AVX2_6

	vpaddusw xmm0,xmm4,XMMWORD ptr[rsi+rax]
	vpsrlw xmm0,xmm0,6
	vmovdqa XMMWORD ptr[rdi+rax],xmm0
	add rax,16

Convert_RGB64_16toRGB64_10_AVX2_6:
	test r8d,1
	jz short Convert_RGB64_16toRGB64_10_AVX2_7
	
	vmovq xmm0,qword ptr[rsi+rax]
	vpaddusw xmm0,xmm0,xmm4
	vpsrlw xmm0,xmm0,6
	vmovq qword ptr[rdi+rax],xmm0
	
Convert_RGB64_16toRGB64_10_AVX2_7:
	add rsi,r10
	add rdi,r11
	dec r9d
	jnz Convert_RGB64_16toRGB64_10_AVX2_loop_1
	
	vzeroupper
	
	pop rbx
	pop rsi
	pop rdi
	pop rbp

	ret

JPSDR_HDRTools_Convert_RGB64_16toRGB64_10_AVX2 endp


;JPSDR_HDRTools_Convert_RGB64_16toRGB64_12_AVX2 proc src:dword,dst:dword,w:dword,h:dword,
;	src_pitch:dword,dst_pitch:dword
; src = rcx
; dst = rdx
; w = r8d
; h = r9d
JPSDR_HDRTools_Convert_RGB64_16toRGB64_12_AVX2 proc public frame

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
	.endprolog

	vmovdqa ymm4,YMMWORD ptr data_w_8

	mov rsi,rcx
	mov rdi,rdx
	mov ebx,r8d
	mov r10,src_pitch
	mov r11,dst_pitch
	shr ebx,2
	mov rdx,128

Convert_RGB64_16toRGB64_12_AVX2_loop_1:
	mov ecx,ebx
	xor rax,rax

	shr ecx,2
	jz Convert_RGB64_16toRGB64_12_AVX2_3
	
Convert_RGB64_16toRGB64_12_AVX2_loop_2:
	vpaddusw ymm0,ymm4,YMMWORD ptr[rsi+rax]
	vpaddusw ymm1,ymm4,YMMWORD ptr[rsi+rax+32]
	vpaddusw ymm2,ymm4,YMMWORD ptr[rsi+rax+64]
	vpaddusw ymm3,ymm4,YMMWORD ptr[rsi+rax+96]
	vpsrlw ymm0,ymm0,4
	vpsrlw ymm1,ymm1,4
	vpsrlw ymm2,ymm2,4
	vpsrlw ymm3,ymm3,4
	vmovdqa YMMWORD ptr[rdi+rax],ymm0
	vmovdqa YMMWORD ptr[rdi+rax+32],ymm1
	vmovdqa YMMWORD ptr[rdi+rax+64],ymm2
	vmovdqa YMMWORD ptr[rdi+rax+96],ymm3
	add rax,rdx
	loop Convert_RGB64_16toRGB64_12_AVX2_loop_2

Convert_RGB64_16toRGB64_12_AVX2_3:
	test ebx,2
	jz short Convert_RGB64_16toRGB64_12_AVX2_4

	vpaddusw ymm0,ymm4,YMMWORD ptr[rsi+rax]
	vpaddusw ymm1,ymm4,YMMWORD ptr[rsi+rax+32]
	vpsrlw ymm0,ymm0,4
	vpsrlw ymm1,ymm1,4
	vmovdqa YMMWORD ptr[rdi+rax],ymm0
	vmovdqa YMMWORD ptr[rdi+rax+32],ymm1
	add rax,64

Convert_RGB64_16toRGB64_12_AVX2_4:
	test ebx,1
	jz short Convert_RGB64_16toRGB64_12_AVX2_5

	vpaddusw ymm0,ymm4,YMMWORD ptr[rsi+rax]
	vpsrlw ymm0,ymm0,4
	vmovdqa YMMWORD ptr[rdi+rax],ymm0
	add rax,32
	
Convert_RGB64_16toRGB64_12_AVX2_5:
	test r8d,2
	jz short Convert_RGB64_16toRGB64_12_AVX2_6

	vpaddusw xmm0,xmm4,XMMWORD ptr[rsi+rax]
	vpsrlw xmm0,xmm0,4
	vmovdqa XMMWORD ptr[rdi+rax],xmm0
	add rax,16

Convert_RGB64_16toRGB64_12_AVX2_6:
	test r8d,1
	jz short Convert_RGB64_16toRGB64_12_AVX2_7
	
	vmovq xmm0,qword ptr[rsi+rax]
	vpaddusw xmm0,xmm0,xmm4
	vpsrlw xmm0,xmm0,4
	vmovq qword ptr[rdi+rax],xmm0
	
Convert_RGB64_16toRGB64_12_AVX2_7:
	add rsi,r10
	add rdi,r11
	dec r9d
	jnz Convert_RGB64_16toRGB64_12_AVX2_loop_1
	
	vzeroupper
	
	pop rbx
	pop rsi
	pop rdi
	pop rbp

	ret

JPSDR_HDRTools_Convert_RGB64_16toRGB64_12_AVX2 endp


;JPSDR_HDRTools_Convert_16_RGB64_HLG_OOTF_AVX2 proc dst:dword,srcY:dword,w:dword,h:dword,dst_pitch:dword,src_pitchY:dword
; dst = rcx
; srcY = rdx
; w = r8d
; h = r9d
	
JPSDR_HDRTools_Convert_16_RGB64_HLG_OOTF_AVX2 proc public frame	

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
	push r12
	.pushreg r12
	.endprolog	
	
	mov rdi,rcx
	mov rsi,rdx
	mov r10d,r8d
	mov r11,dst_pitch
	mov r12,src_pitchY
	mov rdx,8
	shr r10d,1
	mov rbx,1
	vpxor xmm4,xmm4,xmm4
	
Convert_16_RGB64_HLG_OOTF_AVX2_1:
	mov ecx,r10d
	xor rax,rax
	or ecx,ecx
	jz short Convert_16_RGB64_HLG_OOTF_AVX2_3
	
Convert_16_RGB64_HLG_OOTF_AVX2_2:
	vbroadcastss xmm0,dword ptr[rsi+rax]
	vbroadcastss xmm1,dword ptr[rsi+rax+4]
	vmovdqa xmm2,XMMWORD ptr[rdi+2*rax]
	vinsertf128 ymm0,ymm0,xmm1,1
	vpunpckhwd xmm3,xmm2,xmm4
	vpunpcklwd xmm2,xmm2,xmm4
	vinserti128 ymm2,ymm2,xmm3,1
	vcvtdq2ps ymm2,ymm2
	vmulps ymm2,ymm2,ymm0
	vcvtps2dq ymm2,ymm2
	vextracti128 xmm3,ymm2,1
	vpackusdw xmm2,xmm2,xmm3
	vmovdqa XMMWORD ptr[rdi+2*rax],xmm2
	
	add rax,rdx
	loop Convert_16_RGB64_HLG_OOTF_AVX2_2
	
Convert_16_RGB64_HLG_OOTF_AVX2_3:
	test r8d,ebx
	jz short Convert_16_RGB64_HLG_OOTF_AVX2_4
	
	vbroadcastss xmm0,dword ptr[rsi+rax]
	vmovq xmm2,qword ptr[rdi+2*rax]
	vpunpcklwd xmm2,xmm2,xmm4
	vcvtdq2ps xmm2,xmm2
	vmulps xmm2,xmm2,xmm0
	vcvtps2dq xmm2,xmm2
	vpackusdw xmm2,xmm2,xmm2
	vmovq qword ptr[rdi+2*rax],xmm2
	
Convert_16_RGB64_HLG_OOTF_AVX2_4:
	add rdi,r11
	add rsi,r12
	dec r9d
	jnz Convert_16_RGB64_HLG_OOTF_AVX2_1
	
	vzeroupper
	
	pop r12
	pop rbx
	pop rdi
	pop rsi
	pop rbp

	ret

JPSDR_HDRTools_Convert_16_RGB64_HLG_OOTF_AVX2 endp


;***************************************************
;**           XYZ/HDR/SDR functions               **
;***************************************************


;JPSDR_HDRTools_Scale_20_XYZ_AVX2 proc src:dword,dst:dword,w8:dword,h:dword,src_pitch:dword,dst_pitch:dword,
;	ValMin:dword,Coeff:dword
; src = rcx
; dst = rdx
; w8 = r8d
; h = r9d

JPSDR_HDRTools_Scale_20_XYZ_AVX2 proc public frame

src_pitch equ qword ptr[rbp+48]
dst_pitch equ qword ptr[rbp+56]
ValMin equ qword ptr[rbp+64]
Coeff equ qword ptr[rbp+72]

	push rbp
	.pushreg rbp
	mov rbp,rsp
	push rsi
	.pushreg rsi
	push rbx
	.pushreg rbx
	.endprolog

	mov rsi,ValMin
	vbroadcastss ymm1,dword ptr[rsi]
	mov rsi,Coeff
	vbroadcastss ymm2,dword ptr[rsi]
	
	vmovdqa ymm3,YMMWORD ptr data_dw_1048575
	vmovdqa ymm4,YMMWORD ptr data_dw_0
	vmulps ymm2,ymm2,YMMWORD ptr data_f_1048575
	
	mov rsi,rcx
	mov r10,src_pitch
	mov r11,dst_pitch
	mov rbx,32
	
Scale_20_XYZ_AVX2_1:
	xor rax,rax
	mov ecx,r8d
Scale_20_XYZ_AVX2_2:
	vaddps ymm0,ymm1,YMMWORD ptr[rsi+rax]
	vmulps ymm0,ymm0,ymm2
	vcvtps2dq ymm0,ymm0
	vpminsd ymm0,ymm0,ymm3
	vpmaxsd ymm0,ymm0,ymm4
	vmovdqa YMMWORD ptr[rdx+rax],ymm0
	
	add rax,rbx
	loop Scale_20_XYZ_AVX2_2
	
	add rsi,r10
	add rdx,r11
	dec r9d
	jnz short Scale_20_XYZ_AVX2_1
	
	vzeroupper
	
	pop rbx
	pop rsi
	pop rbp

	ret

JPSDR_HDRTools_Scale_20_XYZ_AVX2 endp


;JPSDR_HDRTools_Scale_20_RGB_AVX2 proc src:dword,dst:dword,w8:dword,h:dword,src_pitch:dword,dst_pitch:dword
; src = rcx
; dst = rdx
; w8 = r8d
; h = r9d

JPSDR_HDRTools_Scale_20_RGB_AVX2 proc public frame

src_pitch equ qword ptr[rbp+48]
dst_pitch equ qword ptr[rbp+56]
ValMin equ qword ptr[rbp+64]
Coeff equ qword ptr[rbp+72]

	push rbp
	.pushreg rbp
	mov rbp,rsp
	push rsi
	.pushreg rsi
	push rbx
	.pushreg rbx
	.endprolog

	vmovaps ymm1,YMMWORD ptr data_f_1048575
	vmovdqa ymm2,YMMWORD ptr data_dw_1048575
	vmovdqa ymm3,YMMWORD ptr data_dw_0
	
	mov rsi,rcx
	mov r10,src_pitch
	mov r11,dst_pitch
	mov rbx,32
	
Scale_20_RGB_AVX2_1:
	xor rax,rax
	mov ecx,r8d
Scale_20_RGB_AVX2_2:
	vmulps ymm0,ymm1,YMMWORD ptr[rsi+rax]
	vcvtps2dq ymm0,ymm0
	vpminsd ymm0,ymm0,ymm2
	vpmaxsd ymm0,ymm0,ymm3
	vmovdqa YMMWORD ptr[rdx+rax],ymm0
	
	add rax,rbx
	loop Scale_20_RGB_AVX2_2
	
	add rsi,r10
	add rdx,r11
	dec r9d
	jnz short Scale_20_RGB_AVX2_1
	
	vzeroupper
	
	pop rbx
	pop rsi
	pop rbp

	ret

JPSDR_HDRTools_Scale_20_RGB_AVX2 endp


;JPSDR_HDRTools_BT2446C_16_XYZ_AVX2 proc src:dword,dst1:dword,dst2:dword,w8:dword,h:dword,src_pitch:dword,
;	dst_pitch1:dword,dst_pitch2:dword,ValMinX:dword,CoeffX:dword,ValMinZ:dword,CoeffZ:dword
; src = rcx
; dst1 = rdx
; dst2 = r8
; w8 = r9d

JPSDR_HDRTools_BT2446C_16_XYZ_AVX2 proc public frame

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
	push rbx
	.pushreg rbx
	push r12
	.pushreg r12
	push r13
	.pushreg r13
	sub rsp,48
	.allocstack 48
	vmovdqa XMMWORD ptr[rsp],xmm6
	.savexmm128 xmm6,0
	vmovdqa XMMWORD ptr[rsp+16],xmm7
	.savexmm128 xmm7,16
	vmovdqa XMMWORD ptr[rsp+32],xmm8
	.savexmm128 xmm8,32
	.endprolog

	mov rsi,ValMinX
	vbroadcastss ymm2,dword ptr[rsi]
	mov rsi,CoeffX
	vbroadcastss ymm3,dword ptr[rsi]
	mov rsi,ValMinZ
	vbroadcastss ymm4,dword ptr[rsi]
	mov rsi,CoeffZ
	vbroadcastss ymm5,dword ptr[rsi]

	vmovdqa ymm6,YMMWORD ptr data_dw_65535
	vmovdqa ymm7,YMMWORD ptr data_dw_0
	vmulps ymm3,ymm3,YMMWORD ptr data_f_65535
	vmulps ymm5,ymm5,YMMWORD ptr data_f_65535
	
	mov rsi,rcx
	mov r10,src_pitch
	mov r11,dst_pitch1
	mov r12,dst_pitch2
	mov r13d,h
	mov rbx,32
	
BT2446C_16_XYZ_AVX2_1:
	xor rax,rax
	mov ecx,r9d
BT2446C_16_XYZ_AVX2_2:
	vmovaps ymm8,YMMWORD ptr[rsi+rax]
	vmulps ymm0,ymm8,YMMWORD ptr[rdx+rax]
	vmulps ymm1,ymm8,YMMWORD ptr[r8+rax]	
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
	vmovdqa YMMWORD ptr[rdx+rax],ymm0
	vmovdqa YMMWORD ptr[r8+rax],ymm1
	
	add rax,rbx
	loop BT2446C_16_XYZ_AVX2_2
	
	add rsi,r10
	add rdx,r11
	add r8,r12
	dec r13d
	jnz short BT2446C_16_XYZ_AVX2_1
	
	vmovdqa xmm8,XMMWORD ptr[rsp+32]
	vmovdqa xmm7,XMMWORD ptr[rsp+16]
	vmovdqa xmm6,XMMWORD ptr[rsp]
	add rsp,48
	
	vzeroupper
	
	pop r13
	pop r12
	pop rbx
	pop rsi
	pop rbp

	ret

JPSDR_HDRTools_BT2446C_16_XYZ_AVX2 endp


end
