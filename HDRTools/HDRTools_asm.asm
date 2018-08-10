.586
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
data_dw_0 dword 8 dup(0)
data_dw_128 dword 8 dup(128)
data_dw_32 dword 8 dup(32)
data_dw_8 dword 8 dup(8)
data_dw_RGB32 dword 8 dup(00FFFFFFh)

data_all_1 dword 8 dup(0FFFFFFFFh)

data_HLG_8 word 16 dup(0FF00h)
data_HLG_10 dword 8 dup(0FFC00h)
data_HLG_12 dword 8 dup(0FFF000h)
data_w_128 word 16 dup(128)
data_w_32 word 16 dup(32)
data_w_8 word 16 dup(8)

.code


JPSDR_HDRTools_LookupRGB32_RGB32HLG proc src:dword,dst:dword,w:dword,h:dword,src_modulo:dword,dst_modulo:dword,lookup:dword

	public JPSDR_HDRTools_LookupRGB32_RGB32HLG
	
	push ebx
	push edi
	push esi
	
	cld
	mov ebx,00FFFFFFh
	mov edx,lookup
	mov esi,src
	mov edi,dst
	
LookupRGB32_RGB32HLG_1:
	mov ecx,w
LookupRGB32_RGB32HLG_2:
	lodsd
	and eax,ebx
	mov eax,dword ptr[edx+4*eax]
	stosd
	loop LookupRGB32_RGB32HLG_2
	
	add esi,src_modulo
	add edi,dst_modulo
	dec h
	jnz short LookupRGB32_RGB32HLG_1
	
	pop esi
	pop edi
	pop ebx
	
	ret
	
JPSDR_HDRTools_LookupRGB32_RGB32HLG endp


JPSDR_HDRTools_LookupRGB32_RGB64HLG proc src:dword,dst:dword,w:dword,h:dword,src_modulo:dword,dst_modulo:dword,lookup:dword

	public JPSDR_HDRTools_LookupRGB32_RGB64HLG
	
	push ebx
	push edi
	push esi
	
	cld
	mov edx,lookup
	mov esi,src
	mov edi,dst
	
LookupRGB32_RGB64HLG_1:
	mov ecx,w
LookupRGB32_RGB64HLG_2:
	lodsd
	mov ebx,eax
	mov eax,dword ptr[edx+8*eax]
	stosd
	mov eax,dword ptr[edx+8*ebx+4]
	stosd
	loop LookupRGB32_RGB64HLG_2
	
	add esi,src_modulo
	add edi,dst_modulo
	dec h
	jnz short LookupRGB32_RGB64HLG_1
	
	pop esi
	pop edi
	pop ebx
	
	ret
	
JPSDR_HDRTools_LookupRGB32_RGB64HLG endp


JPSDR_HDRTools_LookupRGB32_RGB64HLGb proc src:dword,dst:dword,w:dword,h:dword,src_modulo:dword,dst_modulo:dword,lookup:dword

	public JPSDR_HDRTools_LookupRGB32_RGB64HLGb
	
	push ebx
	push edi
	push esi
	
	cld
	mov edx,lookup
	mov esi,src
	mov edi,dst
	
LookupRGB32_RGB64HLGb_1:
	mov ecx,w
LookupRGB32_RGB64HLGb_2:
	lodsd
	and eax,00FFFFFFh
	mov ebx,eax
	mov eax,dword ptr[edx+8*eax]
	stosd
	mov eax,dword ptr[edx+8*ebx+4]
	stosd
	loop LookupRGB32_RGB64HLGb_2
	
	add esi,src_modulo
	add edi,dst_modulo
	dec h
	jnz short LookupRGB32_RGB64HLGb_1
	
	pop esi
	pop edi
	pop ebx
	
	ret
	
JPSDR_HDRTools_LookupRGB32_RGB64HLGb endp


JPSDR_HDRTools_LookupRGB32 proc src:dword,dst:dword,w:dword,h:dword,src_modulo:dword,dst_modulo:dword,lookup:dword

	public JPSDR_HDRTools_LookupRGB32
	
	push ebx
	push edi
	push esi
	
	cld
	mov ebx,w
	mov edx,lookup
	mov esi,src
	mov edi,dst
	xor eax,eax
	
LookupRGB32_1:
	mov ecx,ebx
LookupRGB32_2:
	lodsb
	mov al,byte ptr[edx+eax]
	stosb
	lodsb
	mov al,byte ptr[edx+eax]
	stosb	
	lodsb
	mov al,byte ptr[edx+eax]
	stosb
	movsb
	loop LookupRGB32_2
	
	add esi,src_modulo
	add edi,dst_modulo
	dec h
	jnz short LookupRGB32_1
	
	pop esi
	pop edi
	pop ebx
	
	ret
	
JPSDR_HDRTools_LookupRGB32 endp
	

JPSDR_HDRTools_LookupRGB32toRGB64 proc src:dword,dst:dword,w:dword,h:dword,src_modulo:dword,dst_modulo:dword,lookup:dword

	public JPSDR_HDRTools_LookupRGB32toRGB64
	
	push ebx
	push edi
	push esi
	
	cld
	mov ebx,w
	mov edx,lookup
	mov esi,src
	mov edi,dst
	xor eax,eax
	
LookupRGB32toRGB64_1:
	mov ecx,ebx
LookupRGB32toRGB64_2:
	lodsb
	mov ax,word ptr[edx+2*eax]
	stosw
	lodsb
	mov ax,word ptr[edx+2*eax]
	stosw	
	lodsb
	mov ax,word ptr[edx+2*eax]
	stosw
	lodsb
	xor ax,ax
	stosw
	loop LookupRGB32toRGB64_2
	
	add esi,src_modulo
	add edi,dst_modulo
	dec h
	jnz short LookupRGB32toRGB64_1
	
	pop esi
	pop edi
	pop ebx
	
	ret
	
JPSDR_HDRTools_LookupRGB32toRGB64 endp

	
JPSDR_HDRTools_LookupRGB64 proc src:dword,dst:dword,w:dword,h:dword,src_modulo:dword,dst_modulo:dword,lookup:dword

	public JPSDR_HDRTools_LookupRGB64
	
	push ebx
	push edi
	push esi
	
	cld
	mov ebx,w
	mov edx,lookup
	mov esi,src
	mov edi,dst
	xor eax,eax
	
LookupRGB64_1:
	mov ecx,ebx
LookupRGB64_2:
	lodsw
	mov ax,word ptr[edx+2*eax]
	stosw
	lodsw
	mov ax,word ptr[edx+2*eax]
	stosw	
	lodsw
	mov ax,word ptr[edx+2*eax]
	stosw
	movsw
	loop LookupRGB64_2
	
	add esi,src_modulo
	add edi,dst_modulo
	dec h
	jnz short LookupRGB64_1
	
	pop esi
	pop edi
	pop ebx
	
	ret
	
JPSDR_HDRTools_LookupRGB64 endp


JPSDR_HDRTools_Lookup_Planar8 proc src:dword,dst:dword,w:dword,h:dword,src_modulo:dword,dst_modulo:dword,lookup:dword

	public JPSDR_HDRTools_Lookup_Planar8
	
	push ebx
	push edi
	push esi
	
	cld
	mov ebx,w
	mov edx,lookup
	mov esi,src
	mov edi,dst
	xor eax,eax
	
Planar8_1:
	mov ecx,ebx
Planar8_2:
	lodsb
	mov al,byte ptr[edx+eax]
	stosb
	loop Planar8_2
	
	add esi,src_modulo
	add edi,dst_modulo
	dec h
	jnz short Planar8_1
	
	pop esi
	pop edi
	pop ebx
	
	ret
	
JPSDR_HDRTools_Lookup_Planar8 endp


JPSDR_HDRTools_Lookup_Planar16 proc src:dword,dst:dword,w:dword,h:dword,src_modulo:dword,dst_modulo:dword,lookup:dword

	public JPSDR_HDRTools_Lookup_Planar16
	
	push ebx
	push edi
	push esi
	
	cld
	mov ebx,w
	mov edx,lookup
	mov esi,src
	mov edi,dst
	xor eax,eax
	
Planar16_1:
	mov ecx,ebx
Planar16_2:
	lodsw
	mov ax,word ptr[edx+2*eax]
	stosw
	loop Planar16_2
	
	add esi,src_modulo
	add edi,dst_modulo
	dec h
	jnz short Planar16_1
	
	pop esi
	pop edi
	pop ebx
	
	ret
	
JPSDR_HDRTools_Lookup_Planar16 endp

	
JPSDR_HDRTools_Lookup_Planar32 proc src:dword,dst:dword,w:dword,h:dword,src_modulo:dword,dst_modulo:dword,lookup:dword

	public JPSDR_HDRTools_Lookup_Planar32
	
	push ebx
	push edi
	push esi
	
	cld
	mov ebx,w
	mov edx,lookup
	mov esi,src
	mov edi,dst
	
Planar32_1:
	mov ecx,ebx
Planar32_2:
	lodsd
	mov eax,dword ptr[edx+4*eax]
	stosd
	loop Planar32_2
	
	add esi,src_modulo
	add edi,dst_modulo
	dec h
	jnz short Planar32_1
	
	pop esi
	pop edi
	pop ebx
	
	ret
	
JPSDR_HDRTools_Lookup_Planar32 endp
	
	
JPSDR_HDRTools_Move8to16 proc dst:dword,src:dword,w:dword

	public JPSDR_HDRTools_Move8to16
	
	push esi
	push edi
	
	cld
	xor eax,eax
	mov ecx,w		
	mov edi,dst
	mov esi,src
	
	stosb
	dec ecx
	jz short Move8to16_2
	
Move8to16_1:
	lodsb
	stosw
	loop Move8to16_1
	
Move8to16_2:
	movsb
	
	pop edi
	pop esi

	ret
	
JPSDR_HDRTools_Move8to16 endp	
	

JPSDR_HDRTools_Move8to16_SSE2 proc dst:dword,src:dword,w:dword

	public JPSDR_HDRTools_Move8to16_SSE2
	
	push ebx
	push esi
	
	mov edx,dst
	mov esi,src
	mov ebx,16
	xor eax,eax
	mov ecx,w
		
Move8to16_SSE2_1:
	movdqa xmm0,XMMWORD ptr [esi+eax]
	pxor xmm1,xmm1
	pxor xmm2,xmm2
	punpcklbw xmm1,xmm0
	punpckhbw xmm2,xmm0
	movdqa XMMWORD ptr [edx+2*eax],xmm1
	movdqa XMMWORD ptr [edx+2*eax+16],xmm2
	add eax,ebx
	loop Move8to16_SSE2_1
	
	pop esi
	pop ebx

	ret
	
JPSDR_HDRTools_Move8to16_SSE2 endp	


JPSDR_HDRTools_Move8to16_AVX proc dst:dword,src:dword,w:dword

	public JPSDR_HDRTools_Move8to16_AVX
	
	push ebx
	push esi
	
	mov edx,dst
	mov esi,src
	xor eax,eax
	mov ebx,16
	mov ecx,w
	vpxor xmm0,xmm0,xmm0
		
Move8to16_AVX_1:
	vpunpcklbw xmm1,xmm0,XMMWORD ptr [esi+eax]
	vpunpckhbw xmm2,xmm0,XMMWORD ptr [esi+eax]
	vmovdqa XMMWORD ptr [edx+2*eax],xmm1
	vmovdqa XMMWORD ptr [edx+2*eax+16],xmm2
	add eax,ebx
	loop Move8to16_AVX_1
	
	pop esi
	pop ebx

	ret
	
JPSDR_HDRTools_Move8to16_AVX endp	


;***************************************************
;**           YUV to RGB functions                **
;***************************************************
	
JPSDR_HDRTools_Convert_Planar420_to_Planar422_8_SSE2 proc src1:dword,src2:dword,dst:dword,w:dword

	public JPSDR_HDRTools_Convert_Planar420_to_Planar422_8_SSE2
	
	push esi
	push edi
	push ebx
	
	pcmpeqb xmm3,xmm3
	
	mov edi,dst
	mov esi,src1
	mov edx,src2
	xor eax,eax	
	mov ecx,w	
	mov ebx,16
	
Convert_Planar420_to_Planar422_8_SSE2_1:
	movdqa xmm0,XMMWORD ptr[esi+eax]
	movdqa xmm1,XMMWORD ptr[edx+eax]
	movdqa xmm2,xmm0
	pxor xmm0,xmm3
	pxor xmm1,xmm3
	pavgb xmm0,xmm1
	pxor xmm0,xmm3
	pavgb xmm0,xmm2
	
	movdqa XMMWORD ptr[edi+eax],xmm0
	add eax,ebx
	loop Convert_Planar420_to_Planar422_8_SSE2_1
	

	pop ebx
	pop edi
	pop esi

	ret

JPSDR_HDRTools_Convert_Planar420_to_Planar422_8_SSE2 endp


JPSDR_HDRTools_Convert_Planar420_to_Planar422_8to16_SSE2 proc src1:dword,src2:dword,dst:dword,w:dword

	public JPSDR_HDRTools_Convert_Planar420_to_Planar422_8to16_SSE2
	
	push esi
	push edi
	push ebx
	
	pcmpeqb xmm4,xmm4
	
	mov edi,dst
	mov esi,src1
	mov edx,src2
	xor eax,eax	
	mov ecx,w	
	mov ebx,8
	
Convert_Planar420_to_Planar422_8to16_SSE2_1:
	movq xmm0,qword ptr[esi+eax]
	movq xmm1,qword ptr[edx+eax]
	
	pxor xmm2,xmm2
	pxor xmm3,xmm3
	punpcklbw xmm2,xmm0
	punpcklbw xmm3,xmm1

	movdqa xmm0,xmm2
	pxor xmm2,xmm4
	pxor xmm3,xmm4
	pavgw xmm2,xmm3
	pxor xmm2,xmm4
	pavgw xmm2,xmm0
	
	movdqa XMMWORD ptr[edi+2*eax],xmm2
	add eax,ebx
	loop Convert_Planar420_to_Planar422_8to16_SSE2_1
	

	pop ebx
	pop edi
	pop esi

	ret

JPSDR_HDRTools_Convert_Planar420_to_Planar422_8to16_SSE2 endp


JPSDR_HDRTools_Convert_Planar420_to_Planar422_8_AVX proc src1:dword,src2:dword,dst:dword,w:dword

	public JPSDR_HDRTools_Convert_Planar420_to_Planar422_8_AVX
	
	push esi
	push edi
	push ebx
	
	vpcmpeqb xmm3,xmm3,xmm3
	
	mov edi,dst
	mov esi,src1
	mov edx,src2
	xor eax,eax	
	mov ecx,w	
	mov ebx,16
	
Convert_Planar420_to_Planar422_8_AVX_1:
	vmovdqa xmm0,XMMWORD ptr[esi+eax]
	vmovdqa xmm1,XMMWORD ptr[edx+eax]
	vpxor xmm2,xmm0,xmm3
	vpxor xmm1,xmm1,xmm3
	vpavgb xmm2,xmm2,xmm1
	vpxor xmm2,xmm2,xmm3
	vpavgb xmm2,xmm2,xmm0
	
	vmovdqa XMMWORD ptr[edi+eax],xmm2
	add eax,ebx
	loop Convert_Planar420_to_Planar422_8_AVX_1
	
	pop ebx
	pop edi
	pop esi

	ret

JPSDR_HDRTools_Convert_Planar420_to_Planar422_8_AVX endp


JPSDR_HDRTools_Convert_Planar420_to_Planar422_8to16_AVX proc src1:dword,src2:dword,dst:dword,w:dword

	public JPSDR_HDRTools_Convert_Planar420_to_Planar422_8to16_AVX
	
	push esi
	push edi
	push ebx
	
	vpcmpeqb xmm3,xmm3,xmm3
	vpxor xmm4,xmm4,xmm4
	
	mov edi,dst
	mov esi,src1
	mov edx,src2
	xor eax,eax	
	mov ecx,w	
	mov ebx,8
	
Convert_Planar420_to_Planar422_8to16_AVX_1:
	vmovq xmm0,qword ptr[esi+eax]
	vmovq xmm1,qword ptr[edx+eax]
	vpunpcklbw xmm0,xmm4,xmm0
	vpunpcklbw xmm1,xmm4,xmm1
	
	vpxor xmm2,xmm0,xmm3
	vpxor xmm1,xmm1,xmm3
	vpavgw xmm2,xmm2,xmm1
	vpxor xmm2,xmm2,xmm3
	vpavgw xmm2,xmm2,xmm0
	
	vmovdqa XMMWORD ptr[edi+2*eax],xmm2
	add eax,ebx
	loop Convert_Planar420_to_Planar422_8to16_AVX_1
	
	pop ebx
	pop edi
	pop esi

	ret

JPSDR_HDRTools_Convert_Planar420_to_Planar422_8to16_AVX endp


JPSDR_HDRTools_Convert_Planar420_to_Planar422_16_SSE2 proc src1:dword,src2:dword,dst:dword,w:dword

	public JPSDR_HDRTools_Convert_Planar420_to_Planar422_16_SSE2
	
	push esi
	push edi
	push ebx
	
	pcmpeqb xmm3,xmm3
	
	mov edi,dst
	mov esi,src1
	mov edx,src2
	xor eax,eax	
	mov ecx,w	
	mov ebx,16
	
Convert_Planar420_to_Planar422_16_SSE2_1:
	movdqa xmm0,XMMWORD ptr[esi+eax]
	movdqa xmm1,XMMWORD ptr[edx+eax]
	movdqa xmm2,xmm0
	pxor xmm0,xmm3
	pxor xmm1,xmm3
	pavgw xmm0,xmm1
	pxor xmm0,xmm3
	pavgw xmm0,xmm2
	
	movdqa XMMWORD ptr[edi+eax],xmm0
	add eax,ebx
	loop Convert_Planar420_to_Planar422_16_SSE2_1
	

	pop ebx
	pop edi
	pop esi

	ret

JPSDR_HDRTools_Convert_Planar420_to_Planar422_16_SSE2 endp


JPSDR_HDRTools_Convert_Planar420_to_Planar422_16_AVX proc src1:dword,src2:dword,dst:dword,w:dword

	public JPSDR_HDRTools_Convert_Planar420_to_Planar422_16_AVX
	
	push esi
	push edi
	push ebx
	
	vpcmpeqb xmm3,xmm3,xmm3
	
	mov edi,dst
	mov esi,src1
	mov edx,src2
	xor eax,eax	
	mov ecx,w	
	mov ebx,16
	
Convert_Planar420_to_Planar422_16_AVX_1:
	vmovdqa xmm0,XMMWORD ptr[esi+eax]
	vmovdqa xmm1,XMMWORD ptr[edx+eax]
	vpxor xmm2,xmm0,xmm3
	vpxor xmm1,xmm1,xmm3
	vpavgw xmm2,xmm2,xmm1
	vpxor xmm2,xmm2,xmm3
	vpavgw xmm2,xmm2,xmm0
	
	vmovdqa XMMWORD ptr[edi+eax],xmm2
	add eax,ebx
	loop Convert_Planar420_to_Planar422_16_AVX_1
	
	pop ebx
	pop edi
	pop esi

	ret

JPSDR_HDRTools_Convert_Planar420_to_Planar422_16_AVX endp


JPSDR_HDRTools_Convert_Planar422_to_Planar444_8_SSE2 proc src:dword,dst:dword,w:dword

	public JPSDR_HDRTools_Convert_Planar422_to_Planar444_8_SSE2
	
	push edi
	push ebx
	
	mov edx,src
	mov edi,dst
	xor eax,eax	
	mov ecx,w	
	mov ebx,16
	
Convert_Planar422_to_Planar444_8_SSE2_1:
	movdqa xmm0,XMMWORD ptr[edx+eax]
	movdqu xmm1,XMMWORD ptr[edx+eax+1]
	movdqa xmm2,xmm0
	pavgb xmm1,xmm0
	movdqa xmm3,xmm0
	punpcklbw xmm2,xmm1
	punpckhbw xmm3,xmm1	
	
	movdqa XMMWORD ptr[edi+2*eax],xmm2
	movdqa XMMWORD ptr[edi+2*eax+16],xmm3
	add eax,ebx
	loop Convert_Planar422_to_Planar444_8_SSE2_1
	
	pop ebx
	pop edi

	ret

JPSDR_HDRTools_Convert_Planar422_to_Planar444_8_SSE2 endp


JPSDR_HDRTools_Convert_Planar422_to_Planar444_8_AVX proc src:dword,dst:dword,w:dword

	public JPSDR_HDRTools_Convert_Planar422_to_Planar444_8_AVX
	
	push edi
	push ebx
	
	mov edx,src
	mov edi,dst
	xor eax,eax	
	mov ecx,w	
	mov ebx,16
	
Convert_Planar422_to_Planar444_8_AVX_1:
	vmovdqa xmm0,XMMWORD ptr[edx+eax]
	vmovdqu xmm1,XMMWORD ptr[edx+eax+1]
	vpavgb xmm1,xmm1,xmm0
	vpunpcklbw xmm2,xmm0,xmm1
	vpunpckhbw xmm3,xmm0,xmm1
	
	vmovdqa XMMWORD ptr[edi+2*eax],xmm2
	vmovdqa XMMWORD ptr[edi+2*eax+16],xmm3
	add eax,ebx
	loop Convert_Planar422_to_Planar444_8_AVX_1
	
	pop ebx
	pop edi

	ret

JPSDR_HDRTools_Convert_Planar422_to_Planar444_8_AVX endp


JPSDR_HDRTools_Convert_Planar422_to_Planar444_8to16_SSE2 proc src:dword,dst:dword,w:dword

	public JPSDR_HDRTools_Convert_Planar422_to_Planar444_8to16_SSE2
	
	push esi
	push edi
	push ebx
	
	mov esi,src
	mov edi,dst
	xor eax,eax
	xor edx,edx
	mov ecx,w	
	mov ebx,32
	
Convert_Planar422_to_Planar444_8to16_SSE2_1:
	movq xmm0,qword ptr[esi+8*eax]
	movq xmm1,qword ptr[esi+8*eax+1]
	pxor xmm2,xmm2
	pxor xmm3,xmm3
	punpcklbw xmm2,xmm0
	punpcklbw xmm3,xmm1
	
	pavgw xmm3,xmm2
	movdqa xmm0,xmm2	
	punpcklwd xmm2,xmm3
	punpckhwd xmm0,xmm3
	
	movdqa XMMWORD ptr[edi+edx],xmm2
	movdqa XMMWORD ptr[edi+edx+16],xmm0
	inc eax
	add edx,ebx
	loop Convert_Planar422_to_Planar444_8to16_SSE2_1
	
	pop ebx
	pop edi
	pop esi

	ret

JPSDR_HDRTools_Convert_Planar422_to_Planar444_8to16_SSE2 endp


JPSDR_HDRTools_Convert_Planar422_to_Planar444_8to16_AVX proc src:dword,dst:dword,w:dword

	public JPSDR_HDRTools_Convert_Planar422_to_Planar444_8to16_AVX
	
	push esi
	push edi
	push ebx
	
	vpxor xmm4,xmm4,xmm4
	mov esi,src
	mov edi,dst
	xor eax,eax
	xor edx,edx
	mov ecx,w	
	mov ebx,32
	
Convert_Planar422_to_Planar444_8to16_AVX_1:
	vmovq xmm0,qword ptr[esi+8*eax]
	vmovq xmm1,qword ptr[esi+8*eax+1]
	vpunpcklbw xmm0,xmm4,xmm0
	vpunpcklbw xmm1,xmm4,xmm1
	
	vpavgw xmm1,xmm1,xmm0
	vpunpcklwd xmm2,xmm0,xmm1
	vpunpckhwd xmm3,xmm0,xmm1
	
	vmovdqa XMMWORD ptr[edi+edx],xmm2
	vmovdqa XMMWORD ptr[edi+edx+16],xmm3
	inc eax
	add edx,ebx
	loop Convert_Planar422_to_Planar444_8to16_AVX_1
	
	pop ebx
	pop edi
	pop esi

	ret

JPSDR_HDRTools_Convert_Planar422_to_Planar444_8to16_AVX endp


JPSDR_HDRTools_Convert_Planar422_to_Planar444_16_SSE2 proc src:dword,dst:dword,w:dword

	public JPSDR_HDRTools_Convert_Planar422_to_Planar444_16_SSE2
	
	push edi
	push ebx
	
	mov edx,src
	mov edi,dst
	xor eax,eax	
	mov ecx,w	
	mov ebx,16
	
Convert_Planar422_to_Planar444_16_SSE2_1:
	movdqa xmm0,XMMWORD ptr[edx+eax]
	movdqu xmm1,XMMWORD ptr[edx+eax+2]
	movdqa xmm2,xmm0
	pavgw xmm1,xmm0
	movdqa xmm3,xmm0
	punpcklwd xmm2,xmm1
	punpckhwd xmm3,xmm1	
	
	movdqa XMMWORD ptr[edi+2*eax],xmm2
	movdqa XMMWORD ptr[edi+2*eax+16],xmm3
	add eax,ebx
	loop Convert_Planar422_to_Planar444_16_SSE2_1
	
	pop ebx
	pop edi

	ret

JPSDR_HDRTools_Convert_Planar422_to_Planar444_16_SSE2 endp


JPSDR_HDRTools_Convert_Planar422_to_Planar444_16_AVX proc src:dword,dst:dword,w:dword

	public JPSDR_HDRTools_Convert_Planar422_to_Planar444_16_AVX
	
	push edi
	push ebx
	
	mov edx,src
	mov edi,dst
	xor eax,eax	
	mov ecx,w	
	mov ebx,16
	
Convert_Planar422_to_Planar444_16_AVX_1:
	vmovdqa xmm0,XMMWORD ptr[edx+eax]
	vmovdqu xmm1,XMMWORD ptr[edx+eax+2]
	vpavgw xmm1,xmm1,xmm0
	vpunpcklwd xmm2,xmm0,xmm1
	vpunpckhwd xmm3,xmm0,xmm1
	
	vmovdqa XMMWORD ptr[edi+2*eax],xmm2
	vmovdqa XMMWORD ptr[edi+2*eax+16],xmm3
	add eax,ebx
	loop Convert_Planar422_to_Planar444_16_AVX_1
	
	pop ebx
	pop edi

	ret

JPSDR_HDRTools_Convert_Planar422_to_Planar444_16_AVX endp


JPSDR_HDRTools_Convert_YV24toRGB32_SSE2 proc src_y:dword,src_u:dword,src_v:dword,dst:dword,w:dword,h:dword,offset_R:word,
	offset_G:word,offset_B:word,lookup:dword,src_modulo_y:dword,src_modulo_u:dword,src_modulo_v:dword,dst_modulo:dword

	public JPSDR_HDRTools_Convert_YV24toRGB32_SSE2

	local i,w0:dword

	push esi
	push edi
	push ebx

	pxor xmm1,xmm1
	movzx eax,offset_B
	pinsrw xmm1,eax,0
	pinsrw xmm1,eax,4	
	movzx eax,offset_G
	pinsrw xmm1,eax,1
	pinsrw xmm1,eax,5
	movzx eax,offset_R
	pinsrw xmm1,eax,2
	pinsrw xmm1,eax,6
	
	mov eax,w
	shr eax,2
	mov w0,eax
	
Convert_YV24toRGB32_SSE2_1:
	mov edi,lookup

	mov eax,w0
	or eax,eax
	jz Convert_YV24toRGB32_SSE2_3
	
	mov i,eax
Convert_YV24toRGB32_SSE2_2:
	pxor xmm2,xmm2
	pxor xmm0,xmm0

	mov esi,src_y
	movzx ebx,byte ptr[esi]
	mov esi,src_u
	movzx ecx,byte ptr[esi]
	mov esi,src_v
	movzx edx,byte ptr[esi] ; ebx=Y ecx=U edx=V
	movzx eax,word ptr[edi+2*ebx]
	add ax,word ptr[edi+2*edx+512]
	pinsrw xmm0,eax,2
	movzx eax,word ptr[edi+2*ebx]
	add ax,word ptr[edi+2*ecx+1024]
	add ax,word ptr[edi+2*edx+1536]
	pinsrw xmm0,eax,1
	movzx eax,word ptr[edi+2*ebx]
	add ax,word ptr[edi+2*ecx+2048]
	mov esi,src_y
	pinsrw xmm0,eax,0
	
	movzx ebx,byte ptr[esi+1]
	mov esi,src_u
	movzx ecx,byte ptr[esi+1]
	mov esi,src_v
	movzx edx,byte ptr[esi+1] ; ebx=Y ecx=U edx=V
	movzx eax,word ptr[edi+2*ebx]
	add ax,word ptr[edi+2*edx+512]
	pinsrw xmm0,eax,6
	movzx eax,word ptr[edi+2*ebx]
	add ax,word ptr[edi+2*ecx+1024]
	add ax,word ptr[edi+2*edx+1536]
	pinsrw xmm0,eax,5
	movzx eax,word ptr[edi+2*ebx]
	add ax,word ptr[edi+2*ecx+2048]
	mov esi,src_y
	pinsrw xmm0,eax,4
	
	movzx ebx,byte ptr[esi+2]
	mov esi,src_u
	movzx ecx,byte ptr[esi+2]
	mov esi,src_v
	movzx edx,byte ptr[esi+2] ; ebx=Y ecx=U edx=V
	movzx eax,word ptr[edi+2*ebx]
	add ax,word ptr[edi+2*edx+512]
	pinsrw xmm2,eax,2
	movzx eax,word ptr[edi+2*ebx]
	add ax,word ptr[edi+2*ecx+1024]
	add ax,word ptr[edi+2*edx+1536]
	pinsrw xmm2,eax,1
	movzx eax,word ptr[edi+2*ebx]
	add ax,word ptr[edi+2*ecx+2048]
	mov esi,src_y
	pinsrw xmm2,eax,0
	
	movzx ebx,byte ptr[esi+3]
	mov esi,src_u
	movzx ecx,byte ptr[esi+3]
	mov esi,src_v
	movzx edx,byte ptr[esi+3] ; ebx=Y ecx=U edx=V
	movzx eax,word ptr[edi+2*ebx]
	add ax,word ptr[edi+2*edx+512]
	add src_y,4
	pinsrw xmm2,eax,6
	movzx eax,word ptr[edi+2*ebx]
	add ax,word ptr[edi+2*ecx+1024]
	add ax,word ptr[edi+2*edx+1536]
	add src_u,4
	pinsrw xmm2,eax,5
	movzx eax,word ptr[edi+2*ebx]
	add ax,word ptr[edi+2*ecx+2048]
	add src_v,4
	pinsrw xmm2,eax,4	
	
	paddsw xmm0,xmm1
	paddsw xmm2,xmm1
	psraw xmm0,5
	psraw xmm2,5
	
	mov edi,dst
	
	packuswb xmm0,xmm2
	
	movdqa XMMWORD ptr[edi],xmm0
	
	add dst,16
	
	mov edi,lookup
	
	dec i
	jnz Convert_YV24toRGB32_SSE2_2
	
Convert_YV24toRGB32_SSE2_3:
	mov eax,w
	test eax,3
	jz Convert_YV24toRGB32_SSE2_5
	
	pxor xmm0,xmm0
	
	test eax,2
	jnz short Convert_YV24toRGB32_SSE2_4

	mov esi,src_y
	movzx ebx,byte ptr[esi]
	mov esi,src_u
	movzx ecx,byte ptr[esi]
	mov esi,src_v
	movzx edx,byte ptr[esi] ; ebx=Y ecx=U edx=V
	movzx eax,word ptr[edi+2*ebx]
	add ax,word ptr[edi+2*edx+512]
	inc src_y
	pinsrw xmm0,eax,2
	movzx eax,word ptr[edi+2*ebx]
	add ax,word ptr[edi+2*ecx+1024]
	add ax,word ptr[edi+2*edx+1536]
	inc src_u
	pinsrw xmm0,eax,1
	movzx eax,word ptr[edi+2*ebx]
	add ax,word ptr[edi+2*ecx+2048]
	inc src_v
	pinsrw xmm0,eax,0
	
	paddsw xmm0,xmm1
	psraw xmm0,5
	
	mov edi,dst
	
	packuswb xmm0,xmm0
	
	movd dword ptr[edi],xmm0
	
	add dst,4
	
	jmp Convert_YV24toRGB32_SSE2_5
	
Convert_YV24toRGB32_SSE2_4:
	mov esi,src_y
	movzx ebx,byte ptr[esi]
	mov esi,src_u
	movzx ecx,byte ptr[esi]
	mov esi,src_v
	movzx edx,byte ptr[esi] ; ebx=Y ecx=U edx=V
	movzx eax,word ptr[edi+2*ebx]
	add ax,word ptr[edi+2*edx+512]
	pinsrw xmm0,eax,2
	movzx eax,word ptr[edi+2*ebx]
	add ax,word ptr[edi+2*ecx+1024]
	add ax,word ptr[edi+2*edx+1536]
	pinsrw xmm0,eax,1
	movzx eax,word ptr[edi+2*ebx]
	add ax,word ptr[edi+2*ecx+2048]
	mov esi,src_y
	pinsrw xmm0,eax,0
	
	movzx ebx,byte ptr[esi+1]
	mov esi,src_u
	movzx ecx,byte ptr[esi+1]
	mov esi,src_v
	movzx edx,byte ptr[esi+1] ; ebx=Y ecx=U edx=V
	movzx eax,word ptr[edi+2*ebx]
	add ax,word ptr[edi+2*edx+512]
	add src_y,2
	pinsrw xmm0,eax,6
	movzx eax,word ptr[edi+2*ebx]
	add ax,word ptr[edi+2*ecx+1024]
	add ax,word ptr[edi+2*edx+1536]
	add src_u,2
	pinsrw xmm0,eax,5
	movzx eax,word ptr[edi+2*ebx]
	add ax,word ptr[edi+2*ecx+2048]
	add src_v,2
	pinsrw xmm0,eax,4
	
	paddsw xmm0,xmm1
	psraw xmm0,5
	
	mov edi,dst
	
	packuswb xmm0,xmm0
	
	movq qword ptr[edi],xmm0
	
	add dst,8
	
	mov edi,lookup
	
	test w,1
	jz short Convert_YV24toRGB32_SSE2_5

	pxor xmm0,xmm0
	
	mov esi,src_y
	movzx ebx,byte ptr[esi]
	mov esi,src_u
	movzx ecx,byte ptr[esi]
	mov esi,src_v
	movzx edx,byte ptr[esi] ; ebx=Y ecx=U edx=V
	movzx eax,word ptr[edi+2*ebx]
	add ax,word ptr[edi+2*edx+512]
	inc src_y
	pinsrw xmm0,eax,2
	movzx eax,word ptr[edi+2*ebx]
	add ax,word ptr[edi+2*ecx+1024]
	add ax,word ptr[edi+2*edx+1536]
	inc src_u
	pinsrw xmm0,eax,1
	movzx eax,word ptr[edi+2*ebx]
	add ax,word ptr[edi+2*ecx+2048]
	inc src_v
	pinsrw xmm0,eax,0	
	
	paddsw xmm0,xmm1
	psraw xmm0,5
	
	mov edi,dst
	
	packuswb xmm0,xmm0
	
	movd dword ptr[edi],xmm0
	
	add dst,4
	
Convert_YV24toRGB32_SSE2_5:	
	mov edi,dst
	add edi,dst_modulo
	mov dst,edi
	mov eax,src_y
	add eax,src_modulo_y
	mov src_y,eax
	mov eax,src_u
	add eax,src_modulo_u
	mov src_u,eax
	mov eax,src_v
	add eax,src_modulo_v
	mov src_v,eax
	dec h
	jnz Convert_YV24toRGB32_SSE2_1

	pop ebx
	pop edi
	pop esi

	ret

JPSDR_HDRTools_Convert_YV24toRGB32_SSE2 endp


JPSDR_HDRTools_Convert_YV24toRGB32_AVX proc src_y:dword,src_u:dword,src_v:dword,dst:dword,w:dword,h:dword,offset_R:word,
	offset_G:word,offset_B:word,lookup:dword,src_modulo_y:dword,src_modulo_u:dword,src_modulo_v:dword,dst_modulo:dword

	public JPSDR_HDRTools_Convert_YV24toRGB32_AVX

	local i,w0:dword

	push esi
	push edi
	push ebx

	vpxor xmm2,xmm2,xmm2
	vpxor xmm1,xmm1,xmm1
	vpxor xmm0,xmm0,xmm0
	movzx eax,offset_B
	vpinsrw xmm1,xmm1,eax,0
	vpinsrw xmm1,xmm1,eax,4	
	movzx eax,offset_G
	vpinsrw xmm1,xmm1,eax,1
	vpinsrw xmm1,xmm1,eax,5
	movzx eax,offset_R
	vpinsrw xmm1,xmm1,eax,2
	vpinsrw xmm1,xmm1,eax,6
	
	mov eax,w
	shr eax,2
	mov w0,eax
	
Convert_YV24toRGB32_AVX_1:
	mov edi,lookup

	mov eax,w0
	or eax,eax
	jz Convert_YV24toRGB32_AVX_3
	
	mov i,eax
Convert_YV24toRGB32_AVX_2:
	mov esi,src_y
	movzx ebx,byte ptr[esi]
	mov esi,src_u
	movzx ecx,byte ptr[esi]
	mov esi,src_v
	movzx edx,byte ptr[esi] ; ebx=Y ecx=U edx=V
	movzx eax,word ptr[edi+2*ebx]
	add ax,word ptr[edi+2*edx+512]
	vpinsrw xmm0,xmm0,eax,2
	movzx eax,word ptr[edi+2*ebx]
	add ax,word ptr[edi+2*ecx+1024]
	add ax,word ptr[edi+2*edx+1536]
	vpinsrw xmm0,xmm0,eax,1
	movzx eax,word ptr[edi+2*ebx]
	add ax,word ptr[edi+2*ecx+2048]
	mov esi,src_y
	vpinsrw xmm0,xmm0,eax,0
	
	movzx ebx,byte ptr[esi+1]
	mov esi,src_u
	movzx ecx,byte ptr[esi+1]
	mov esi,src_v
	movzx edx,byte ptr[esi+1] ; ebx=Y ecx=U edx=V
	movzx eax,word ptr[edi+2*ebx]
	add ax,word ptr[edi+2*edx+512]
	vpinsrw xmm0,xmm0,eax,6
	movzx eax,word ptr[edi+2*ebx]
	add ax,word ptr[edi+2*ecx+1024]
	add ax,word ptr[edi+2*edx+1536]
	vpinsrw xmm0,xmm0,eax,5
	movzx eax,word ptr[edi+2*ebx]
	add ax,word ptr[edi+2*ecx+2048]
	mov esi,src_y
	vpinsrw xmm0,xmm0,eax,4
	
	movzx ebx,byte ptr[esi+2]
	mov esi,src_u
	movzx ecx,byte ptr[esi+2]
	mov esi,src_v
	movzx edx,byte ptr[esi+2] ; ebx=Y ecx=U edx=V
	movzx eax,word ptr[edi+2*ebx]
	add ax,word ptr[edi+2*edx+512]
	vpinsrw xmm2,xmm2,eax,2
	movzx eax,word ptr[edi+2*ebx]
	add ax,word ptr[edi+2*ecx+1024]
	add ax,word ptr[edi+2*edx+1536]
	vpinsrw xmm2,xmm2,eax,1
	movzx eax,word ptr[edi+2*ebx]
	add ax,word ptr[edi+2*ecx+2048]
	mov esi,src_y
	vpinsrw xmm2,xmm2,eax,0
	
	movzx ebx,byte ptr[esi+3]
	mov esi,src_u
	movzx ecx,byte ptr[esi+3]
	mov esi,src_v
	movzx edx,byte ptr[esi+3] ; ebx=Y ecx=U edx=V
	movzx eax,word ptr[edi+2*ebx]
	add ax,word ptr[edi+2*edx+512]
	add src_y,4
	vpinsrw xmm2,xmm2,eax,6
	movzx eax,word ptr[edi+2*ebx]
	add ax,word ptr[edi+2*ecx+1024]
	add ax,word ptr[edi+2*edx+1536]
	add src_u,4
	vpinsrw xmm2,xmm2,eax,5
	movzx eax,word ptr[edi+2*ebx]
	add ax,word ptr[edi+2*ecx+2048]
	add src_v,4
	vpinsrw xmm2,xmm2,eax,4	
	
	vpaddsw xmm0,xmm0,xmm1
	vpaddsw xmm2,xmm2,xmm1
	vpsraw xmm0,xmm0,5
	vpsraw xmm2,xmm2,5
	
	mov edi,dst
	
	vpackuswb xmm3,xmm0,xmm2
	
	vmovdqa XMMWORD ptr[edi],xmm3
	
	add dst,16
	
	mov edi,lookup
	
	dec i
	jnz Convert_YV24toRGB32_AVX_2
	
Convert_YV24toRGB32_AVX_3:
	mov eax,w
	test eax,3
	jz Convert_YV24toRGB32_AVX_5
	
	test eax,2
	jnz short Convert_YV24toRGB32_AVX_4
	
	mov esi,src_y
	movzx ebx,byte ptr[esi]
	mov esi,src_u
	movzx ecx,byte ptr[esi]
	mov esi,src_v
	movzx edx,byte ptr[esi] ; ebx=Y ecx=U edx=V
	movzx eax,word ptr[edi+2*ebx]
	add ax,word ptr[edi+2*edx+512]
	inc src_y
	vpinsrw xmm0,xmm0,eax,2
	movzx eax,word ptr[edi+2*ebx]
	add ax,word ptr[edi+2*ecx+1024]
	add ax,word ptr[edi+2*edx+1536]
	inc src_u
	vpinsrw xmm0,xmm0,eax,1
	movzx eax,word ptr[edi+2*ebx]
	add ax,word ptr[edi+2*ecx+2048]
	inc src_v
	vpinsrw xmm0,xmm0,eax,0
	
	vpaddsw xmm0,xmm0,xmm1
	vpsraw xmm0,xmm0,5
	
	mov edi,dst
	
	vpackuswb xmm3,xmm0,xmm0
	
	vmovd dword ptr[edi],xmm3
	
	add dst,4
	
	jmp Convert_YV24toRGB32_AVX_5
	
Convert_YV24toRGB32_AVX_4:
	mov esi,src_y
	movzx ebx,byte ptr[esi]
	mov esi,src_u
	movzx ecx,byte ptr[esi]
	mov esi,src_v
	movzx edx,byte ptr[esi] ; ebx=Y ecx=U edx=V
	movzx eax,word ptr[edi+2*ebx]
	add ax,word ptr[edi+2*edx+512]
	vpinsrw xmm0,xmm0,eax,2
	movzx eax,word ptr[edi+2*ebx]
	add ax,word ptr[edi+2*ecx+1024]
	add ax,word ptr[edi+2*edx+1536]
	vpinsrw xmm0,xmm0,eax,1
	movzx eax,word ptr[edi+2*ebx]
	add ax,word ptr[edi+2*ecx+2048]
	mov esi,src_y
	vpinsrw xmm0,xmm0,eax,0
	
	movzx ebx,byte ptr[esi+1]
	mov esi,src_u
	movzx ecx,byte ptr[esi+1]
	mov esi,src_v
	movzx edx,byte ptr[esi+1] ; ebx=Y ecx=U edx=V
	movzx eax,word ptr[edi+2*ebx]
	add ax,word ptr[edi+2*edx+512]
	add src_y,2
	vpinsrw xmm0,xmm0,eax,6
	movzx eax,word ptr[edi+2*ebx]
	add ax,word ptr[edi+2*ecx+1024]
	add ax,word ptr[edi+2*edx+1536]
	add src_u,2
	vpinsrw xmm0,xmm0,eax,5
	movzx eax,word ptr[edi+2*ebx]
	add ax,word ptr[edi+2*ecx+2048]
	add src_v,2
	vpinsrw xmm0,xmm0,eax,4	
	
	vpaddsw xmm0,xmm0,xmm1
	vpsraw xmm0,xmm0,5
	
	mov edi,dst
	
	vpackuswb xmm3,xmm0,xmm0
	
	vmovq qword ptr[edi],xmm3
	
	add dst,8
	
	mov edi,lookup
	
	test w,1
	jz short Convert_YV24toRGB32_AVX_5
	
	mov esi,src_y
	movzx ebx,byte ptr[esi]
	mov esi,src_u
	movzx ecx,byte ptr[esi]
	mov esi,src_v
	movzx edx,byte ptr[esi] ; ebx=Y ecx=U edx=V
	movzx eax,word ptr[edi+2*ebx]
	add ax,word ptr[edi+2*edx+512]
	inc src_y
	vpinsrw xmm0,xmm0,eax,2
	movzx eax,word ptr[edi+2*ebx]
	add ax,word ptr[edi+2*ecx+1024]
	add ax,word ptr[edi+2*edx+1536]
	inc src_u
	vpinsrw xmm0,xmm0,eax,1
	movzx eax,word ptr[edi+2*ebx]
	add ax,word ptr[edi+2*ecx+2048]
	inc src_v
	vpinsrw xmm0,xmm0,eax,0
	
	vpaddsw xmm0,xmm0,xmm1
	vpsraw xmm0,xmm0,5
	
	mov edi,dst
	
	vpackuswb xmm3,xmm0,xmm0
	
	vmovd dword ptr[edi],xmm3
	
	add dst,4
	
Convert_YV24toRGB32_AVX_5:
	mov edi,dst
	add edi,dst_modulo
	mov dst,edi
	mov eax,src_y
	add eax,src_modulo_y
	mov src_y,eax
	mov eax,src_u
	add eax,src_modulo_u
	mov src_u,eax
	mov eax,src_v
	add eax,src_modulo_v
	mov src_v,eax
	dec h
	jnz Convert_YV24toRGB32_AVX_1

	pop ebx
	pop edi
	pop esi

	ret

JPSDR_HDRTools_Convert_YV24toRGB32_AVX endp


JPSDR_HDRTools_Convert_8_YV24toRGB64_SSE41 proc src_y:dword,src_u:dword,src_v:dword,dst:dword,w:dword,h:dword,offset_R:dword,
	offset_G:dword,offset_B:dword,lookup:dword,src_modulo_y:dword,src_modulo_u:dword,src_modulo_v:dword,dst_modulo:dword

	public JPSDR_HDRTools_Convert_8_YV24toRGB64_SSE41

	local i,w0:dword

	push esi
	push edi
	push ebx

	pxor xmm1,xmm1
	mov eax,offset_B
	pinsrd xmm1,eax,0
	mov eax,offset_G
	pinsrd xmm1,eax,1
	mov eax,offset_R
	pinsrd xmm1,eax,2
	
	mov eax,w
	shr eax,1
	mov w0,eax
	
Convert_8_YV24toRGB64_SSE41_1:
	mov edi,lookup

	mov eax,w0
	or eax,eax
	jz Convert_8_YV24toRGB64_SSE41_3
	
	mov i,eax
Convert_8_YV24toRGB64_SSE41_2:
	pxor xmm2,xmm2
	pxor xmm0,xmm0

	mov esi,src_y
	movzx ebx,byte ptr[esi]
	mov esi,src_u
	movzx ecx,byte ptr[esi]
	mov esi,src_v
	movzx edx,byte ptr[esi] ; ebx=Y ecx=U edx=V
	mov eax,dword ptr[edi+4*ebx]
	add eax,dword ptr[edi+4*edx+1024]
	pinsrd xmm0,eax,2
	mov eax,dword ptr[edi+4*ebx]
	add eax,dword ptr[edi+4*ecx+2048]
	add eax,dword ptr[edi+4*edx+3072]
	pinsrd xmm0,eax,1
	mov eax,dword ptr[edi+4*ebx]
	add eax,dword ptr[edi+4*ecx+4096]
	mov esi,src_y
	pinsrd xmm0,eax,0
	
	movzx ebx,byte ptr[esi+1]
	mov esi,src_u
	movzx ecx,byte ptr[esi+1]
	mov esi,src_v
	movzx edx,byte ptr[esi+1] ; ebx=Y ecx=U edx=V
	mov eax,dword ptr[edi+4*ebx]
	add eax,dword ptr[edi+4*edx+1024]
	add src_y,2
	pinsrd xmm2,eax,2
	mov eax,dword ptr[edi+4*ebx]
	add eax,dword ptr[edi+4*ecx+2048]
	add eax,dword ptr[edi+4*edx+3072]
	add src_u,2
	pinsrd xmm2,eax,1
	mov eax,dword ptr[edi+4*ebx]
	add eax,dword ptr[edi+4*ecx+4096]
	add src_v,2
	pinsrd xmm2,eax,0
	
	paddd xmm0,xmm1
	paddd xmm2,xmm1
	psrad xmm0,8
	psrad xmm2,8	
	
	mov edi,dst
	
	packusdw xmm0,xmm2
	
	movdqa XMMWORD ptr[edi],xmm0
	
	add dst,16
	
	mov edi,lookup
	
	dec i
	jnz Convert_8_YV24toRGB64_SSE41_2
	
Convert_8_YV24toRGB64_SSE41_3:	
	test w,1
	jz short Convert_8_YV24toRGB64_SSE41_4
	
	pxor xmm0,xmm0
	
	mov esi,src_y
	movzx ebx,byte ptr[esi]
	mov esi,src_u
	movzx ecx,byte ptr[esi]
	mov esi,src_v
	movzx edx,byte ptr[esi] ; ebx=Y ecx=U edx=V
	mov eax,dword ptr[edi+4*ebx]
	add eax,dword ptr[edi+4*edx+1024]
	inc src_y
	pinsrd xmm0,eax,2
	mov eax,dword ptr[edi+4*ebx]
	add eax,dword ptr[edi+4*ecx+2048]
	add eax,dword ptr[edi+4*edx+3072]
	inc src_u
	pinsrd xmm0,eax,1
	mov eax,dword ptr[edi+4*ebx]
	add eax,dword ptr[edi+4*ecx+4096]
	inc src_v
	pinsrd xmm0,eax,0
	
	paddd xmm0,xmm1
	psrad xmm0,8
	
	mov edi,dst
	
	packusdw xmm0,xmm0
	
	movq qword ptr[edi],xmm0
	
	add dst,8
	
Convert_8_YV24toRGB64_SSE41_4:	
	mov edi,dst
	add edi,dst_modulo
	mov dst,edi
	mov eax,src_y
	add eax,src_modulo_y
	mov src_y,eax
	mov eax,src_u
	add eax,src_modulo_u
	mov src_u,eax
	mov eax,src_v
	add eax,src_modulo_v
	mov src_v,eax
	dec h
	jnz Convert_8_YV24toRGB64_SSE41_1

	pop ebx
	pop edi
	pop esi

	ret

JPSDR_HDRTools_Convert_8_YV24toRGB64_SSE41 endp


JPSDR_HDRTools_Convert_10_YV24toRGB64_SSE41 proc src_y:dword,src_u:dword,src_v:dword,dst:dword,w:dword,h:dword,offset_R:dword,
	offset_G:dword,offset_B:dword,lookup:dword,src_modulo_y:dword,src_modulo_u:dword,src_modulo_v:dword,dst_modulo:dword

	public JPSDR_HDRTools_Convert_10_YV24toRGB64_SSE41

	local i,w0:dword

	push esi
	push edi
	push ebx

	pxor xmm1,xmm1
	mov eax,offset_B
	pinsrd xmm1,eax,0
	mov eax,offset_G
	pinsrd xmm1,eax,1
	mov eax,offset_R
	pinsrd xmm1,eax,2
	
	mov eax,w
	shr eax,1
	mov w0,eax
	
Convert_10_YV24toRGB64_SSE41_1:
	mov edi,lookup

	mov eax,w0
	or eax,eax
	jz Convert_10_YV24toRGB64_SSE41_3
	
	mov i,eax
Convert_10_YV24toRGB64_SSE41_2:
	pxor xmm2,xmm2
	pxor xmm0,xmm0

	mov esi,src_y
	movzx ebx,word ptr[esi]
	mov esi,src_u
	movzx ecx,word ptr[esi]
	mov esi,src_v
	movzx edx,word ptr[esi] ; ebx=Y ecx=U edx=V
	mov eax,dword ptr[edi+4*ebx]
	add eax,dword ptr[edi+4*edx+4096]
	pinsrd xmm0,eax,2
	mov eax,dword ptr[edi+4*ebx]
	add eax,dword ptr[edi+4*ecx+8192]
	add eax,dword ptr[edi+4*edx+12288]
	pinsrd xmm0,eax,1
	mov eax,dword ptr[edi+4*ebx]
	add eax,dword ptr[edi+4*ecx+16384]
	mov esi,src_y
	pinsrd xmm0,eax,0
	
	movzx ebx,word ptr[esi+2]
	mov esi,src_u
	movzx ecx,word ptr[esi+2]
	mov esi,src_v
	movzx edx,word ptr[esi+2] ; ebx=Y ecx=U edx=V
	mov eax,dword ptr[edi+4*ebx]
	add eax,dword ptr[edi+4*edx+4096]
	add src_y,4
	pinsrd xmm2,eax,2
	mov eax,dword ptr[edi+4*ebx]
	add eax,dword ptr[edi+4*ecx+8192]
	add eax,dword ptr[edi+4*edx+12288]
	add src_u,4
	pinsrd xmm2,eax,1
	mov eax,dword ptr[edi+4*ebx]
	add eax,dword ptr[edi+4*ecx+16384]
	add src_v,4
	pinsrd xmm2,eax,0
	
	paddd xmm0,xmm1
	paddd xmm2,xmm1
	psrad xmm0,8
	psrad xmm2,8
	
	mov edi,dst
	
	packusdw xmm0,xmm2
	
	movdqa XMMWORD ptr[edi],xmm0
	
	add dst,16
	
	mov edi,lookup
	
	dec i
	jnz Convert_10_YV24toRGB64_SSE41_2
	
Convert_10_YV24toRGB64_SSE41_3:
	test w,1
	jz short Convert_10_YV24toRGB64_SSE41_4

	pxor xmm0,xmm0

	mov esi,src_y
	movzx ebx,word ptr[esi]
	mov esi,src_u
	movzx ecx,word ptr[esi]
	mov esi,src_v
	movzx edx,word ptr[esi] ; ebx=Y ecx=U edx=V
	mov eax,dword ptr[edi+4*ebx]
	add eax,dword ptr[edi+4*edx+4096]
	add src_y,2
	pinsrd xmm0,eax,2
	mov eax,dword ptr[edi+4*ebx]
	add eax,dword ptr[edi+4*ecx+8192]
	add eax,dword ptr[edi+4*edx+12288]
	add src_u,2
	pinsrd xmm0,eax,1
	mov eax,dword ptr[edi+4*ebx]
	add eax,dword ptr[edi+4*ecx+16384]
	add src_v,2	
	pinsrd xmm0,eax,0
	
	paddd xmm0,xmm1
	psrad xmm0,8
	
	mov edi,dst
	
	packusdw xmm0,xmm0
	
	movq qword ptr[edi],xmm0
	
	add dst,8

Convert_10_YV24toRGB64_SSE41_4:	
	mov edi,dst
	add edi,dst_modulo
	mov dst,edi
	mov eax,src_y
	add eax,src_modulo_y
	mov src_y,eax
	mov eax,src_u
	add eax,src_modulo_u
	mov src_u,eax
	mov eax,src_v
	add eax,src_modulo_v
	mov src_v,eax
	dec h
	jnz Convert_10_YV24toRGB64_SSE41_1

	pop ebx
	pop edi
	pop esi

	ret

JPSDR_HDRTools_Convert_10_YV24toRGB64_SSE41 endp


JPSDR_HDRTools_Convert_12_YV24toRGB64_SSE41 proc src_y:dword,src_u:dword,src_v:dword,dst:dword,w:dword,h:dword,offset_R:dword,
	offset_G:dword,offset_B:dword,lookup:dword,src_modulo_y:dword,src_modulo_u:dword,src_modulo_v:dword,dst_modulo:dword

	public JPSDR_HDRTools_Convert_12_YV24toRGB64_SSE41

	local i,w0:dword

	push esi
	push edi
	push ebx

	pxor xmm1,xmm1
	mov eax,offset_B
	pinsrd xmm1,eax,0
	mov eax,offset_G
	pinsrd xmm1,eax,1
	mov eax,offset_R
	pinsrd xmm1,eax,2
	
	mov eax,w
	shr eax,1
	mov w0,eax
	
Convert_12_YV24toRGB64_SSE41_1:
	mov edi,lookup
	
	mov eax,w0
	or eax,eax
	jz Convert_12_YV24toRGB64_SSE41_3
	
	mov i,eax
Convert_12_YV24toRGB64_SSE41_2:
	pxor xmm2,xmm2
	pxor xmm0,xmm0

	mov esi,src_y
	movzx ebx,word ptr[esi]
	mov esi,src_u
	movzx ecx,word ptr[esi]
	mov esi,src_v
	movzx edx,word ptr[esi] ; ebx=Y ecx=U edx=V
	mov eax,dword ptr[edi+4*ebx]
	add eax,dword ptr[edi+4*edx+16384]
	pinsrd xmm0,eax,2
	mov eax,dword ptr[edi+4*ebx]
	add eax,dword ptr[edi+4*ecx+32768]
	add eax,dword ptr[edi+4*edx+49152]
	pinsrd xmm0,eax,1
	mov eax,dword ptr[edi+4*ebx]
	add eax,dword ptr[edi+4*ecx+65536]
	mov esi,src_y
	pinsrd xmm0,eax,0
	
	movzx ebx,word ptr[esi+2]
	mov esi,src_u
	movzx ecx,word ptr[esi+2]
	mov esi,src_v
	movzx edx,word ptr[esi+2] ; ebx=Y ecx=U edx=V
	mov eax,dword ptr[edi+4*ebx]
	add eax,dword ptr[edi+4*edx+16384]
	add src_y,4
	pinsrd xmm2,eax,2
	mov eax,dword ptr[edi+4*ebx]
	add eax,dword ptr[edi+4*ecx+32768]
	add eax,dword ptr[edi+4*edx+49152]
	add src_u,4
	pinsrd xmm2,eax,1
	mov eax,dword ptr[edi+4*ebx]
	add eax,dword ptr[edi+4*ecx+65536]
	add src_v,4
	pinsrd xmm2,eax,0
	
	paddd xmm0,xmm1
	paddd xmm2,xmm1
	psrad xmm0,8
	psrad xmm2,8
	
	mov edi,dst
	
	packusdw xmm0,xmm2
	
	movdqa XMMWORD ptr[edi],xmm0
	
	add dst,16
	
	mov edi,lookup
	
	dec i
	jnz Convert_12_YV24toRGB64_SSE41_2
	
Convert_12_YV24toRGB64_SSE41_3:
	test w,1
	jz short Convert_12_YV24toRGB64_SSE41_4

	pxor xmm0,xmm0
	
	mov esi,src_y
	movzx ebx,word ptr[esi]
	mov esi,src_u
	movzx ecx,word ptr[esi]
	mov esi,src_v
	movzx edx,word ptr[esi] ; ebx=Y ecx=U edx=V
	mov eax,dword ptr[edi+4*ebx]
	add eax,dword ptr[edi+4*edx+16384]
	add src_y,2
	pinsrd xmm0,eax,2
	mov eax,dword ptr[edi+4*ebx]
	add eax,dword ptr[edi+4*ecx+32768]
	add eax,dword ptr[edi+4*edx+49152]
	add src_u,2
	pinsrd xmm0,eax,1
	mov eax,dword ptr[edi+4*ebx]
	add eax,dword ptr[edi+4*ecx+65536]
	add src_v,2	
	pinsrd xmm0,eax,0
	
	paddd xmm0,xmm1
	psrad xmm0,8
	
	mov edi,dst
	
	packusdw xmm0,xmm0
	
	movq qword ptr[edi],xmm0
	
	add dst,8
	
Convert_12_YV24toRGB64_SSE41_4:	
	mov edi,dst
	add edi,dst_modulo
	mov dst,edi
	mov eax,src_y
	add eax,src_modulo_y
	mov src_y,eax
	mov eax,src_u
	add eax,src_modulo_u
	mov src_u,eax
	mov eax,src_v
	add eax,src_modulo_v
	mov src_v,eax
	dec h
	jnz Convert_12_YV24toRGB64_SSE41_1

	pop ebx
	pop edi
	pop esi

	ret

JPSDR_HDRTools_Convert_12_YV24toRGB64_SSE41 endp


JPSDR_HDRTools_Convert_14_YV24toRGB64_SSE41 proc src_y:dword,src_u:dword,src_v:dword,dst:dword,w:dword,h:dword,offset_R:dword,
	offset_G:dword,offset_B:dword,lookup:dword,src_modulo_y:dword,src_modulo_u:dword,src_modulo_v:dword,dst_modulo:dword

	public JPSDR_HDRTools_Convert_14_YV24toRGB64_SSE41

	local i,w0:dword

	push esi
	push edi
	push ebx

	pxor xmm1,xmm1
	mov eax,offset_B
	pinsrd xmm1,eax,0
	mov eax,offset_G
	pinsrd xmm1,eax,1
	mov eax,offset_R
	pinsrd xmm1,eax,2
	
	mov eax,w
	shr eax,1
	mov w0,eax
	
Convert_14_YV24toRGB64_SSE41_1:
	mov edi,lookup
	mov eax,w0
	or eax,eax
	jz Convert_14_YV24toRGB64_SSE41_3
	
	mov i,eax
Convert_14_YV24toRGB64_SSE41_2:
	pxor xmm2,xmm2
	pxor xmm0,xmm0

	mov esi,src_y
	movzx ebx,word ptr[esi]
	mov esi,src_u
	movzx ecx,word ptr[esi]
	mov esi,src_v
	movzx edx,word ptr[esi] ; ebx=Y ecx=U edx=V
	mov eax,dword ptr[edi+4*ebx]
	add eax,dword ptr[edi+4*edx+65536]
	pinsrd xmm0,eax,2
	mov eax,dword ptr[edi+4*ebx]
	add eax,dword ptr[edi+4*ecx+131072]
	add eax,dword ptr[edi+4*edx+196608]
	pinsrd xmm0,eax,1
	mov eax,dword ptr[edi+4*ebx]
	add eax,dword ptr[edi+4*ecx+262144]
	mov esi,src_y
	pinsrd xmm0,eax,0

	movzx ebx,word ptr[esi+2]
	mov esi,src_u
	movzx ecx,word ptr[esi+2]
	mov esi,src_v
	movzx edx,word ptr[esi+2] ; ebx=Y ecx=U edx=V
	mov eax,dword ptr[edi+4*ebx]
	add eax,dword ptr[edi+4*edx+65536]
	add src_y,4
	pinsrd xmm2,eax,2
	mov eax,dword ptr[edi+4*ebx]
	add eax,dword ptr[edi+4*ecx+131072]
	add eax,dword ptr[edi+4*edx+196608]
	add src_u,4
	pinsrd xmm2,eax,1
	mov eax,dword ptr[edi+4*ebx]
	add eax,dword ptr[edi+4*ecx+262144]
	add src_v,4
	pinsrd xmm2,eax,0
	
	paddd xmm0,xmm1
	paddd xmm2,xmm1
	psrad xmm0,8
	psrad xmm2,8
	
	mov edi,dst
	
	packusdw xmm0,xmm2
	
	movdqa XMMWORD ptr[edi],xmm0
	
	add dst,16
	
	mov edi,lookup
	
	dec i
	jnz Convert_14_YV24toRGB64_SSE41_2
	
Convert_14_YV24toRGB64_SSE41_3:
	test w,1
	jz short Convert_14_YV24toRGB64_SSE41_4
	
	pxor xmm0,xmm0
	
	mov esi,src_y
	movzx ebx,word ptr[esi]
	mov esi,src_u
	movzx ecx,word ptr[esi]
	mov esi,src_v
	movzx edx,word ptr[esi] ; ebx=Y ecx=U edx=V
	mov eax,dword ptr[edi+4*ebx]
	add eax,dword ptr[edi+4*edx+65536]
	add src_y,2
	pinsrd xmm0,eax,2
	mov eax,dword ptr[edi+4*ebx]
	add eax,dword ptr[edi+4*ecx+131072]
	add eax,dword ptr[edi+4*edx+196608]
	add src_u,2
	pinsrd xmm0,eax,1
	mov eax,dword ptr[edi+4*ebx]
	add eax,dword ptr[edi+4*ecx+262144]
	add src_v,2
	pinsrd xmm0,eax,0
	
	paddd xmm0,xmm1
	psrad xmm0,8

	mov edi,dst

	packusdw xmm0,xmm0
	
	movq qword ptr[edi],xmm0
	
	add dst,8	

Convert_14_YV24toRGB64_SSE41_4:	
	mov edi,dst
	add edi,dst_modulo
	mov dst,edi
	mov eax,src_y
	add eax,src_modulo_y
	mov src_y,eax
	mov eax,src_u
	add eax,src_modulo_u
	mov src_u,eax
	mov eax,src_v
	add eax,src_modulo_v
	mov src_v,eax
	dec h
	jnz Convert_14_YV24toRGB64_SSE41_1

	pop ebx
	pop edi
	pop esi

	ret

JPSDR_HDRTools_Convert_14_YV24toRGB64_SSE41 endp


JPSDR_HDRTools_Convert_16_YV24toRGB64_SSE41 proc src_y:dword,src_u:dword,src_v:dword,dst:dword,w:dword,h:dword,offset_R:dword,
	offset_G:dword,offset_B:dword,lookup:dword,src_modulo_y:dword,src_modulo_u:dword,src_modulo_v:dword,dst_modulo:dword

	public JPSDR_HDRTools_Convert_16_YV24toRGB64_SSE41

	local i,w0:dword

	push esi
	push edi
	push ebx

	pxor xmm1,xmm1
	mov eax,offset_B
	pinsrd xmm1,eax,0
	mov eax,offset_G
	pinsrd xmm1,eax,1
	mov eax,offset_R
	pinsrd xmm1,eax,2
	
	mov eax,w
	shr eax,1
	mov w0,eax
	
Convert_16_YV24toRGB64_SSE41_1:
	mov edi,lookup
	mov eax,w0
	or eax,eax
	jz Convert_16_YV24toRGB64_SSE41_3
	
	mov i,eax
Convert_16_YV24toRGB64_SSE41_2:
	pxor xmm2,xmm2
	pxor xmm0,xmm0

	mov esi,src_y
	movzx ebx,word ptr[esi]
	mov esi,src_u
	movzx ecx,word ptr[esi]
	mov esi,src_v
	movzx edx,word ptr[esi] ; ebx=Y ecx=U edx=V
	mov eax,dword ptr[edi+4*ebx]
	add eax,dword ptr[edi+4*edx+262144]
	pinsrd xmm0,eax,2
	mov eax,dword ptr[edi+4*ebx]
	add eax,dword ptr[edi+4*ecx+524288]
	add eax,dword ptr[edi+4*edx+786432]
	pinsrd xmm0,eax,1
	mov eax,dword ptr[edi+4*ebx]
	add eax,dword ptr[edi+4*ecx+1048576]
	mov esi,src_y
	pinsrd xmm0,eax,0

	movzx ebx,word ptr[esi+2]
	mov esi,src_u
	movzx ecx,word ptr[esi+2]
	mov esi,src_v
	movzx edx,word ptr[esi+2] ; ebx=Y ecx=U edx=V
	mov eax,dword ptr[edi+4*ebx]
	add eax,dword ptr[edi+4*edx+262144]
	add src_y,4
	pinsrd xmm2,eax,2
	mov eax,dword ptr[edi+4*ebx]
	add eax,dword ptr[edi+4*ecx+524288]
	add eax,dword ptr[edi+4*edx+786432]
	add src_u,4
	pinsrd xmm2,eax,1
	mov eax,dword ptr[edi+4*ebx]
	add eax,dword ptr[edi+4*ecx+1048576]
	add src_v,4
	pinsrd xmm2,eax,0
	
	paddd xmm0,xmm1
	paddd xmm2,xmm1
	psrad xmm0,8
	psrad xmm2,8
	
	mov edi,dst
	
	packusdw xmm0,xmm2
	
	movdqa XMMWORD ptr[edi],xmm0
	
	add dst,16
	
	mov edi,lookup
	
	dec i
	jnz Convert_16_YV24toRGB64_SSE41_2
	
Convert_16_YV24toRGB64_SSE41_3:	
	test w,1
	jz short Convert_16_YV24toRGB64_SSE41_4
	
	pxor xmm0,xmm0
	
	mov esi,src_y
	movzx ebx,word ptr[esi]
	mov esi,src_u
	movzx ecx,word ptr[esi]
	mov esi,src_v
	movzx edx,word ptr[esi] ; ebx=Y ecx=U edx=V
	mov eax,dword ptr[edi+4*ebx]
	add eax,dword ptr[edi+4*edx+262144]
	add src_y,2
	pinsrd xmm0,eax,2
	mov eax,dword ptr[edi+4*ebx]
	add eax,dword ptr[edi+4*ecx+524288]
	add eax,dword ptr[edi+4*edx+786432]
	add src_u,2
	pinsrd xmm0,eax,1
	mov eax,dword ptr[edi+4*ebx]
	add eax,dword ptr[edi+4*ecx+1048576]
	add src_v,2
	pinsrd xmm0,eax,0
	
	paddd xmm0,xmm1
	psrad xmm0,8
	
	mov edi,dst
	
	packusdw xmm0,xmm0
	
	movq qword ptr[edi],xmm0
	
	add dst,8
	
Convert_16_YV24toRGB64_SSE41_4:
	mov edi,dst
	add edi,dst_modulo
	mov dst,edi
	mov eax,src_y
	add eax,src_modulo_y
	mov src_y,eax
	mov eax,src_u
	add eax,src_modulo_u
	mov src_u,eax
	mov eax,src_v
	add eax,src_modulo_v
	mov src_v,eax
	dec h
	jnz Convert_16_YV24toRGB64_SSE41_1

	pop ebx
	pop edi
	pop esi

	ret

JPSDR_HDRTools_Convert_16_YV24toRGB64_SSE41 endp


JPSDR_HDRTools_Convert_8_YV24toRGB64_AVX proc src_y:dword,src_u:dword,src_v:dword,dst:dword,w:dword,h:dword,offset_R:dword,
	offset_G:dword,offset_B:dword,lookup:dword,src_modulo_y:dword,src_modulo_u:dword,src_modulo_v:dword,dst_modulo:dword

	public JPSDR_HDRTools_Convert_8_YV24toRGB64_AVX

	local i,w0:dword

	push esi
	push edi
	push ebx

	vpxor xmm2,xmm2,xmm2
	vpxor xmm1,xmm1,xmm1
	vpxor xmm0,xmm0,xmm0
	mov eax,offset_B
	vpinsrd xmm1,xmm1,eax,0
	mov eax,offset_G
	vpinsrd xmm1,xmm1,eax,1
	mov eax,offset_R
	vpinsrd xmm1,xmm1,eax,2
	
	mov eax,w
	shr eax,1
	mov w0,eax
	
Convert_8_YV24toRGB64_AVX_1:
	mov edi,lookup
	mov eax,w0
	or eax,eax 
	jz Convert_8_YV24toRGB64_AVX_3
	
	mov i,eax
Convert_8_YV24toRGB64_AVX_2:
	mov esi,src_y
	movzx ebx,byte ptr[esi]
	mov esi,src_u
	movzx ecx,byte ptr[esi]
	mov esi,src_v
	movzx edx,byte ptr[esi] ; ebx=Y ecx=U edx=V
	mov eax,dword ptr[edi+4*ebx]
	add eax,dword ptr[edi+4*edx+1024]
	vpinsrd xmm0,xmm0,eax,2
	mov eax,dword ptr[edi+4*ebx]
	add eax,dword ptr[edi+4*ecx+2048]
	add eax,dword ptr[edi+4*edx+3072]
	vpinsrd xmm0,xmm0,eax,1
	mov eax,dword ptr[edi+4*ebx]
	add eax,dword ptr[edi+4*ecx+4096]
	mov esi,src_y
	vpinsrd xmm0,xmm0,eax,0
	
	movzx ebx,byte ptr[esi+1]
	mov esi,src_u
	movzx ecx,byte ptr[esi+1]
	mov esi,src_v
	movzx edx,byte ptr[esi+1] ; ebx=Y ecx=U edx=V
	mov eax,dword ptr[edi+4*ebx]
	add eax,dword ptr[edi+4*edx+1024]
	add src_y,2
	vpinsrd xmm2,xmm2,eax,2
	mov eax,dword ptr[edi+4*ebx]
	add eax,dword ptr[edi+4*ecx+2048]
	add eax,dword ptr[edi+4*edx+3072]
	add src_u,2
	vpinsrd xmm2,xmm2,eax,1
	mov eax,dword ptr[edi+4*ebx]
	add eax,dword ptr[edi+4*ecx+4096]
	add src_v,2
	vpinsrd xmm2,xmm2,eax,0
		
	vpaddd xmm0,xmm0,xmm1
	vpaddd xmm2,xmm2,xmm1
	vpsrad xmm0,xmm0,8
	vpsrad xmm2,xmm2,8
	
	mov edi,dst
	
	vpackusdw xmm3,xmm0,xmm2
	
	vmovdqa XMMWORD ptr[edi],xmm3
	
	add dst,16
	
	mov edi,lookup
	
	dec i
	jnz Convert_8_YV24toRGB64_AVX_2
	
Convert_8_YV24toRGB64_AVX_3:	
	test w,1
	jz short Convert_8_YV24toRGB64_AVX_4

	mov esi,src_y
	movzx ebx,byte ptr[esi]
	mov esi,src_u
	movzx ecx,byte ptr[esi]
	mov esi,src_v
	movzx edx,byte ptr[esi] ; ebx=Y ecx=U edx=V
	mov eax,dword ptr[edi+4*ebx]
	add eax,dword ptr[edi+4*edx+1024]
	inc src_y
	vpinsrd xmm0,xmm0,eax,2
	mov eax,dword ptr[edi+4*ebx]
	add eax,dword ptr[edi+4*ecx+2048]
	add eax,dword ptr[edi+4*edx+3072]
	inc src_u
	vpinsrd xmm0,xmm0,eax,1
	mov eax,dword ptr[edi+4*ebx]
	add eax,dword ptr[edi+4*ecx+4096]
	inc src_v
	vpinsrd xmm0,xmm0,eax,0
	
	vpaddd xmm0,xmm0,xmm1
	vpsrad xmm0,xmm0,8
	
	mov edi,dst
	
	vpackusdw xmm3,xmm0,xmm0
	
	vmovq qword ptr[edi],xmm3
	
	add dst,8

Convert_8_YV24toRGB64_AVX_4:	
	mov edi,dst
	add edi,dst_modulo
	mov dst,edi
	mov eax,src_y
	add eax,src_modulo_y
	mov src_y,eax
	mov eax,src_u
	add eax,src_modulo_u
	mov src_u,eax
	mov eax,src_v
	add eax,src_modulo_v
	mov src_v,eax
	dec h
	jnz Convert_8_YV24toRGB64_AVX_1

	pop ebx
	pop edi
	pop esi

	ret

JPSDR_HDRTools_Convert_8_YV24toRGB64_AVX endp


JPSDR_HDRTools_Convert_10_YV24toRGB64_AVX proc src_y:dword,src_u:dword,src_v:dword,dst:dword,w:dword,h:dword,offset_R:dword,
	offset_G:dword,offset_B:dword,lookup:dword,src_modulo_y:dword,src_modulo_u:dword,src_modulo_v:dword,dst_modulo:dword

	public JPSDR_HDRTools_Convert_10_YV24toRGB64_AVX

	local i,w0:dword

	push esi
	push edi
	push ebx

	vpxor xmm2,xmm2,xmm2
	vpxor xmm1,xmm1,xmm1
	vpxor xmm0,xmm0,xmm0
	mov eax,offset_B
	vpinsrd xmm1,xmm1,eax,0
	mov eax,offset_G
	vpinsrd xmm1,xmm1,eax,1
	mov eax,offset_R
	vpinsrd xmm1,xmm1,eax,2
	
	mov eax,w
	shr eax,1
	mov w0,eax
	
Convert_10_YV24toRGB64_AVX_1:
	mov edi,lookup
	mov eax,w0
	or eax,eax 
	jz Convert_10_YV24toRGB64_AVX_3
	
	mov i,eax
Convert_10_YV24toRGB64_AVX_2:
	mov esi,src_y
	movzx ebx,word ptr[esi]
	mov esi,src_u
	movzx ecx,word ptr[esi]
	mov esi,src_v
	movzx edx,word ptr[esi] ; ebx=Y ecx=U edx=V
	mov eax,dword ptr[edi+4*ebx]
	add eax,dword ptr[edi+4*edx+4096]
	vpinsrd xmm0,xmm0,eax,2
	mov eax,dword ptr[edi+4*ebx]
	add eax,dword ptr[edi+4*ecx+8192]
	add eax,dword ptr[edi+4*edx+12288]
	vpinsrd xmm0,xmm0,eax,1
	mov eax,dword ptr[edi+4*ebx]
	add eax,dword ptr[edi+4*ecx+16384]
	mov esi,src_y
	vpinsrd xmm0,xmm0,eax,0

	movzx ebx,word ptr[esi+2]
	mov esi,src_u
	movzx ecx,word ptr[esi+2]
	mov esi,src_v
	movzx edx,word ptr[esi+2] ; ebx=Y ecx=U edx=V
	mov eax,dword ptr[edi+4*ebx]
	add eax,dword ptr[edi+4*edx+4096]
	add src_y,4
	vpinsrd xmm2,xmm2,eax,2
	mov eax,dword ptr[edi+4*ebx]
	add eax,dword ptr[edi+4*ecx+8192]
	add eax,dword ptr[edi+4*edx+12288]
	add src_u,4
	vpinsrd xmm2,xmm2,eax,1
	mov eax,dword ptr[edi+4*ebx]
	add eax,dword ptr[edi+4*ecx+16384]
	add src_v,4
	vpinsrd xmm2,xmm2,eax,0

	vpaddd xmm0,xmm0,xmm1
	vpaddd xmm2,xmm2,xmm1
	vpsrad xmm0,xmm0,8
	vpsrad xmm2,xmm2,8
	
	mov edi,dst
	
	vpackusdw xmm3,xmm0,xmm2
	
	vmovdqa XMMWORD ptr[edi],xmm3
	
	add dst,16
	
	mov edi,lookup
	
	dec i
	jnz Convert_10_YV24toRGB64_AVX_2
	
Convert_10_YV24toRGB64_AVX_3:
	test w,1
	jz short Convert_10_YV24toRGB64_AVX_4

	mov esi,src_y
	movzx ebx,word ptr[esi]
	mov esi,src_u
	movzx ecx,word ptr[esi]
	mov esi,src_v
	movzx edx,word ptr[esi] ; ebx=Y ecx=U edx=V
	mov eax,dword ptr[edi+4*ebx]
	add eax,dword ptr[edi+4*edx+4096]
	add src_y,2
	vpinsrd xmm0,xmm0,eax,2
	mov eax,dword ptr[edi+4*ebx]
	add eax,dword ptr[edi+4*ecx+8192]
	add eax,dword ptr[edi+4*edx+12288]
	add src_u,2
	vpinsrd xmm0,xmm0,eax,1
	mov eax,dword ptr[edi+4*ebx]
	add eax,dword ptr[esi+4*ecx+16384]
	add src_v,2
	vpinsrd xmm0,xmm0,eax,0

	vpaddd xmm0,xmm0,xmm1
	vpsrad xmm0,xmm0,8
	
	mov edi,dst
	
	vpackusdw xmm3,xmm0,xmm0
	
	vmovq qword ptr[edi],xmm3
	
	add dst,8
		
Convert_10_YV24toRGB64_AVX_4:
	mov edi,dst
	add edi,dst_modulo
	mov dst,edi
	mov eax,src_y
	add eax,src_modulo_y
	mov src_y,eax
	mov eax,src_u
	add eax,src_modulo_u
	mov src_u,eax
	mov eax,src_v
	add eax,src_modulo_v
	mov src_v,eax
	dec h
	jnz Convert_10_YV24toRGB64_AVX_1

	pop ebx
	pop edi
	pop esi

	ret

JPSDR_HDRTools_Convert_10_YV24toRGB64_AVX endp


JPSDR_HDRTools_Convert_12_YV24toRGB64_AVX proc src_y:dword,src_u:dword,src_v:dword,dst:dword,w:dword,h:dword,offset_R:dword,
	offset_G:dword,offset_B:dword,lookup:dword,src_modulo_y:dword,src_modulo_u:dword,src_modulo_v:dword,dst_modulo:dword

	public JPSDR_HDRTools_Convert_12_YV24toRGB64_AVX

	local i,w0:dword

	push esi
	push edi
	push ebx

	vpxor xmm2,xmm2,xmm2
	vpxor xmm1,xmm1,xmm1
	vpxor xmm0,xmm0,xmm0
	mov eax,offset_B
	vpinsrd xmm1,xmm1,eax,0
	mov eax,offset_G
	vpinsrd xmm1,xmm1,eax,1
	mov eax,offset_R
	vpinsrd xmm1,xmm1,eax,2
	
	mov eax,w
	shr eax,1
	mov w0,eax
	
Convert_12_YV24toRGB64_AVX_1:
	mov edi,lookup
	mov eax,w0
	or eax,eax 
	jz Convert_12_YV24toRGB64_AVX_3
	
	mov i,eax
Convert_12_YV24toRGB64_AVX_2:
	mov esi,src_y
	movzx ebx,word ptr[esi]
	mov esi,src_u
	movzx ecx,word ptr[esi]
	mov esi,src_v
	movzx edx,word ptr[esi] ; ebx=Y ecx=U edx=V
	mov eax,dword ptr[edi+4*ebx]
	add eax,dword ptr[edi+4*edx+16384]
	vpinsrd xmm0,xmm0,eax,2
	mov eax,dword ptr[edi+4*ebx]
	add eax,dword ptr[edi+4*ecx+32768]
	add eax,dword ptr[edi+4*edx+49152]
	vpinsrd xmm0,xmm0,eax,1
	mov eax,dword ptr[edi+4*ebx]
	add eax,dword ptr[edi+4*ecx+65536]
	mov esi,src_y
	vpinsrd xmm0,xmm0,eax,0
	
	movzx ebx,word ptr[esi+2]
	mov esi,src_u
	movzx ecx,word ptr[esi+2]
	mov esi,src_v
	movzx edx,word ptr[esi+2] ; ebx=Y ecx=U edx=V
	mov eax,dword ptr[edi+4*ebx]
	add eax,dword ptr[edi+4*edx+16384]
	add src_y,4
	vpinsrd xmm2,xmm2,eax,2
	mov eax,dword ptr[edi+4*ebx]
	add eax,dword ptr[edi+4*ecx+32768]
	add eax,dword ptr[edi+4*edx+49152]
	add src_u,4
	vpinsrd xmm2,xmm2,eax,1
	mov eax,dword ptr[edi+4*ebx]
	add eax,dword ptr[edi+4*ecx+65536]
	add src_v,4
	vpinsrd xmm2,xmm2,eax,0
	
	vpaddd xmm0,xmm0,xmm1
	vpaddd xmm2,xmm2,xmm1
	vpsrad xmm0,xmm0,8
	vpsrad xmm2,xmm2,8
	
	mov edi,dst
	
	vpackusdw xmm3,xmm0,xmm2
	
	vmovdqa XMMWORD ptr[edi],xmm3
	
	add dst,16
	
	mov edi,lookup
	
	dec i
	jnz Convert_12_YV24toRGB64_AVX_2
	
Convert_12_YV24toRGB64_AVX_3:	
	test w,1
	jz short Convert_12_YV24toRGB64_AVX_4
	
	mov esi,src_y
	movzx ebx,word ptr[esi]
	mov esi,src_u
	movzx ecx,word ptr[esi]
	mov esi,src_v
	movzx edx,word ptr[esi] ; ebx=Y ecx=U edx=V
	mov eax,dword ptr[edi+4*ebx]
	add eax,dword ptr[edi+4*edx+16384]
	add src_y,2
	vpinsrd xmm0,xmm0,eax,2
	mov eax,dword ptr[edi+4*ebx]
	add eax,dword ptr[edi+4*ecx+32768]
	add eax,dword ptr[edi+4*edx+49152]
	add src_u,2
	vpinsrd xmm0,xmm0,eax,1
	mov eax,dword ptr[edi+4*ebx]
	add eax,dword ptr[edi+4*ecx+65536]
	add src_v,2
	vpinsrd xmm0,xmm0,eax,0
	
	vpaddd xmm0,xmm0,xmm1
	vpsrad xmm0,xmm0,8
	
	mov edi,dst
	
	vpackusdw xmm3,xmm0,xmm0
	
	vmovq qword ptr[edi],xmm3
	
	add dst,8
	
Convert_12_YV24toRGB64_AVX_4:
	mov edi,dst
	add edi,dst_modulo
	mov dst,edi
	mov eax,src_y
	add eax,src_modulo_y
	mov src_y,eax
	mov eax,src_u
	add eax,src_modulo_u
	mov src_u,eax
	mov eax,src_v
	add eax,src_modulo_v
	mov src_v,eax
	dec h
	jnz Convert_12_YV24toRGB64_AVX_1

	pop ebx
	pop edi
	pop esi

	ret

JPSDR_HDRTools_Convert_12_YV24toRGB64_AVX endp


JPSDR_HDRTools_Convert_14_YV24toRGB64_AVX proc src_y:dword,src_u:dword,src_v:dword,dst:dword,w:dword,h:dword,offset_R:dword,
	offset_G:dword,offset_B:dword,lookup:dword,src_modulo_y:dword,src_modulo_u:dword,src_modulo_v:dword,dst_modulo:dword

	public JPSDR_HDRTools_Convert_14_YV24toRGB64_AVX

	local i,w0:dword

	push esi
	push edi
	push ebx

	vpxor xmm2,xmm2,xmm2
	vpxor xmm1,xmm1,xmm1
	vpxor xmm0,xmm0,xmm0
	mov eax,offset_B
	vpinsrd xmm1,xmm1,eax,0
	mov eax,offset_G
	vpinsrd xmm1,xmm1,eax,1
	mov eax,offset_R
	vpinsrd xmm1,xmm1,eax,2
	
	mov eax,w
	shr eax,1
	mov w0,eax
	
Convert_14_YV24toRGB64_AVX_1:
	mov edi,lookup
	mov eax,w0
	or eax,eax 
	jz Convert_14_YV24toRGB64_AVX_3
	
	mov i,eax
Convert_14_YV24toRGB64_AVX_2:
	mov esi,src_y
	movzx ebx,word ptr[esi]
	mov esi,src_u
	movzx ecx,word ptr[esi]
	mov esi,src_v
	movzx edx,word ptr[esi] ; ebx=Y ecx=U edx=V
	mov eax,dword ptr[edi+4*ebx]
	add eax,dword ptr[edi+4*edx+65536]
	vpinsrd xmm0,xmm0,eax,2
	mov eax,dword ptr[edi+4*ebx]
	add eax,dword ptr[edi+4*ecx+131072]
	add eax,dword ptr[edi+4*edx+196608]
	vpinsrd xmm0,xmm0,eax,1
	mov eax,dword ptr[edi+4*ebx]
	add eax,dword ptr[edi+4*ecx+262144]
	mov esi,src_y
	vpinsrd xmm0,xmm0,eax,0

	movzx ebx,word ptr[esi+2]
	mov esi,src_u
	movzx ecx,word ptr[esi+2]
	mov esi,src_v
	movzx edx,word ptr[esi+2] ; ebx=Y ecx=U edx=V
	mov eax,dword ptr[edi+4*ebx]
	add eax,dword ptr[edi+4*edx+65536]
	add src_y,4
	vpinsrd xmm2,xmm2,eax,2
	mov eax,dword ptr[edi+4*ebx]
	add eax,dword ptr[edi+4*ecx+131072]
	add eax,dword ptr[edi+4*edx+196608]
	add src_u,4
	vpinsrd xmm2,xmm2,eax,1
	mov eax,dword ptr[edi+4*ebx]
	add eax,dword ptr[edi+4*ecx+262144]
	add src_v,4
	vpinsrd xmm2,xmm2,eax,0
	
	vpaddd xmm0,xmm0,xmm1
	vpaddd xmm2,xmm2,xmm1
	vpsrad xmm0,xmm0,8
	vpsrad xmm2,xmm2,8
	
	mov edi,dst
	
	vpackusdw xmm3,xmm0,xmm2
	
	vmovdqa XMMWORD ptr[edi],xmm3
	
	add dst,16
	
	mov edi,lookup
	
	dec i
	jnz Convert_14_YV24toRGB64_AVX_2
	
Convert_14_YV24toRGB64_AVX_3:
	test w,1
	jz short Convert_14_YV24toRGB64_AVX_4

	mov esi,src_y
	movzx ebx,word ptr[esi]
	mov esi,src_u
	movzx ecx,word ptr[esi]
	mov esi,src_v
	movzx edx,word ptr[esi] ; ebx=Y ecx=U edx=V
	mov eax,dword ptr[edi+4*ebx]
	add eax,dword ptr[edi+4*edx+65536]
	add src_y,2
	vpinsrd xmm0,xmm0,eax,2
	mov eax,dword ptr[edi+4*ebx]
	add eax,dword ptr[edi+4*ecx+131072]
	add eax,dword ptr[edi+4*edx+196608]
	add src_u,2
	vpinsrd xmm0,xmm0,eax,1
	mov eax,dword ptr[edi+4*ebx]
	add eax,dword ptr[edi+4*ecx+262144]
	add src_v,2
	vpinsrd xmm0,xmm0,eax,0
	
	vpaddd xmm0,xmm0,xmm1
	vpsrad xmm0,xmm0,8
	
	mov edi,dst
	
	vpackusdw xmm3,xmm0,xmm0
	
	vmovq qword ptr[edi],xmm3
	
	add dst,8

Convert_14_YV24toRGB64_AVX_4:
	mov edi,dst
	add edi,dst_modulo
	mov dst,edi
	mov eax,src_y
	add eax,src_modulo_y
	mov src_y,eax
	mov eax,src_u
	add eax,src_modulo_u
	mov src_u,eax
	mov eax,src_v
	add eax,src_modulo_v
	mov src_v,eax
	dec h
	jnz Convert_14_YV24toRGB64_AVX_1

	pop ebx
	pop edi
	pop esi

	ret

JPSDR_HDRTools_Convert_14_YV24toRGB64_AVX endp


JPSDR_HDRTools_Convert_16_YV24toRGB64_AVX proc src_y:dword,src_u:dword,src_v:dword,dst:dword,w:dword,h:dword,offset_R:dword,
	offset_G:dword,offset_B:dword,lookup:dword,src_modulo_y:dword,src_modulo_u:dword,src_modulo_v:dword,dst_modulo:dword

	public JPSDR_HDRTools_Convert_16_YV24toRGB64_AVX

	local i,w0:dword

	push esi
	push edi
	push ebx

	vpxor xmm2,xmm2,xmm2
	vpxor xmm1,xmm1,xmm1
	vpxor xmm0,xmm0,xmm0
	mov eax,offset_B
	vpinsrd xmm1,xmm1,eax,0
	mov eax,offset_G
	vpinsrd xmm1,xmm1,eax,1
	mov eax,offset_R
	vpinsrd xmm1,xmm1,eax,2
	
	mov eax,w
	shr eax,1
	mov w0,eax
	
Convert_16_YV24toRGB64_AVX_1:
	mov edi,lookup
	mov eax,w0
	or eax,eax 
	jz Convert_16_YV24toRGB64_AVX_3
	
	mov i,eax
Convert_16_YV24toRGB64_AVX_2:
	mov esi,src_y
	movzx ebx,word ptr[esi]
	mov esi,src_u
	movzx ecx,word ptr[esi]
	mov esi,src_v
	movzx edx,word ptr[esi] ; ebx=Y ecx=U edx=V
	mov eax,dword ptr[edi+4*ebx]
	add eax,dword ptr[edi+4*edx+262144]
	vpinsrd xmm0,xmm0,eax,2
	mov eax,dword ptr[edi+4*ebx]
	add eax,dword ptr[edi+4*ecx+524288]
	add eax,dword ptr[edi+4*edx+786432]
	vpinsrd xmm0,xmm0,eax,1
	mov eax,dword ptr[edi+4*ebx]
	add eax,dword ptr[edi+4*ecx+1048576]
	mov esi,src_y
	vpinsrd xmm0,xmm0,eax,0

	movzx ebx,word ptr[esi+2]
	mov esi,src_u
	movzx ecx,word ptr[esi+2]
	mov esi,src_v
	movzx edx,word ptr[esi+2] ; ebx=Y ecx=U edx=V
	mov eax,dword ptr[edi+4*ebx]
	add eax,dword ptr[edi+4*edx+262144]
	add src_y,4
	vpinsrd xmm2,xmm2,eax,2
	mov eax,dword ptr[edi+4*ebx]
	add eax,dword ptr[edi+4*ecx+524288]
	add eax,dword ptr[edi+4*edx+786432]
	add src_u,4
	vpinsrd xmm2,xmm2,eax,1
	mov eax,dword ptr[edi+4*ebx]
	add eax,dword ptr[edi+4*ecx+1048576]
	add src_v,4
	vpinsrd xmm2,xmm2,eax,0
	
	vpaddd xmm0,xmm0,xmm1
	vpaddd xmm2,xmm2,xmm1
	vpsrad xmm0,xmm0,8
	vpsrad xmm2,xmm2,8
	
	mov edi,dst
	
	vpackusdw xmm3,xmm0,xmm2
	
	vmovdqa XMMWORD ptr[edi],xmm3
	
	add dst,16
	
	mov edi,lookup
	
	dec i
	jnz Convert_16_YV24toRGB64_AVX_2
	
Convert_16_YV24toRGB64_AVX_3:
	test w,1
	jz short Convert_16_YV24toRGB64_AVX_4
	
	mov esi,src_y
	movzx ebx,word ptr[esi]
	mov esi,src_u
	movzx ecx,word ptr[esi]
	mov esi,src_v
	movzx edx,word ptr[esi] ; ebx=Y ecx=U edx=V
	mov eax,dword ptr[edi+4*ebx]
	add eax,dword ptr[edi+4*edx+262144]
	add src_y,2
	vpinsrd xmm0,xmm0,eax,2
	mov eax,dword ptr[edi+4*ebx]
	add eax,dword ptr[edi+4*ecx+524288]
	add eax,dword ptr[edi+4*edx+786432]
	add src_u,2
	vpinsrd xmm0,xmm0,eax,1
	mov eax,dword ptr[edi+4*ebx]
	add eax,dword ptr[edi+4*ecx+1048576]
	add src_v,2
	vpinsrd xmm0,xmm0,eax,0
	
	vpaddd xmm0,xmm0,xmm1
	vpsrad xmm0,xmm0,8
	
	mov edi,dst
	
	vpackusdw xmm3,xmm0,xmm0
	
	vmovq qword ptr[edi],xmm3
	
	add dst,8
	
Convert_16_YV24toRGB64_AVX_4:
	mov edi,dst
	add edi,dst_modulo
	mov dst,edi
	mov eax,src_y
	add eax,src_modulo_y
	mov src_y,eax
	mov eax,src_u
	add eax,src_modulo_u
	mov src_u,eax
	mov eax,src_v
	add eax,src_modulo_v
	mov src_v,eax
	dec h
	jnz Convert_16_YV24toRGB64_AVX_1

	pop ebx
	pop edi
	pop esi

	ret

JPSDR_HDRTools_Convert_16_YV24toRGB64_AVX endp


;***************************************************
;**           RGB to YUV functions                **
;***************************************************


JPSDR_HDRTools_Convert_LinearRGBPStoRGB64_SSE41 proc src_R:dword,src_G:dword,src_B:dword,dst:dword,w:dword,h:dword,lookup:dword,
	src_modulo_R:dword,src_modulo_G:dword,src_modulo_B:dword,dst_modulo:dword
	
	public JPSDR_HDRTools_Convert_LinearRGBPStoRGB64_SSE41
	
	push esi
	push edi
	push ebx
	
	movaps xmm3,XMMWORD ptr data_f_1048575
	movaps xmm4,XMMWORD ptr data_f_0
	movaps xmm5,XMMWORD ptr data_f_1
	
	cld	
	mov edi,dst
	mov ebx,lookup	
	
Convert_LinearRGBPStoRGB64_SSE41_1:
	mov ecx,w
Convert_LinearRGBPStoRGB64_SSE41_2:
	mov esi,src_B
	xor edx,edx
	movaps xmm0,XMMWORD ptr[esi]
	mov esi,src_G
	maxps xmm0,xmm4
	movaps xmm1,XMMWORD ptr[esi]
	mov esi,src_R
	maxps xmm1,xmm4
	movaps xmm2,XMMWORD ptr[esi]
	minps xmm0,xmm5
	maxps xmm2,xmm4
	minps xmm1,xmm5
	minps xmm2,xmm5
	
	mulps xmm0,xmm3
	mulps xmm1,xmm3
	mulps xmm2,xmm3	
	cvtps2dq xmm0,xmm0
	cvtps2dq xmm1,xmm1
	cvtps2dq xmm2,xmm2
	
	pextrd eax,xmm0,0
	mov ax,word ptr[ebx+2*eax]
	stosw
	pextrd eax,xmm1,0
	mov ax,word ptr[ebx+2*eax]
	stosw
	pextrd eax,xmm2,0
	mov ax,word ptr[ebx+2*eax]
	stosw
	xor eax,eax
	stosw
	dec ecx
	jz Convert_LinearRGBPStoRGB64_SSE41_3
	inc edx
	
	pextrd eax,xmm0,1
	mov ax,word ptr[ebx+2*eax]
	stosw
	pextrd eax,xmm1,1
	mov ax,word ptr[ebx+2*eax]
	stosw
	pextrd eax,xmm2,1
	mov ax,word ptr[ebx+2*eax]
	stosw
	xor eax,eax
	stosw
	dec ecx
	jz short Convert_LinearRGBPStoRGB64_SSE41_3
	inc edx

	pextrd eax,xmm0,2
	mov ax,word ptr[ebx+2*eax]
	stosw
	pextrd eax,xmm1,2
	mov ax,word ptr[ebx+2*eax]
	stosw
	pextrd eax,xmm2,2
	mov ax,word ptr[ebx+2*eax]
	stosw
	xor eax,eax
	stosw
	dec ecx
	jz short Convert_LinearRGBPStoRGB64_SSE41_3
	inc edx

	pextrd eax,xmm0,3
	mov ax,word ptr[ebx+2*eax]
	stosw
	pextrd eax,xmm1,3
	mov ax,word ptr[ebx+2*eax]
	stosw
	pextrd eax,xmm2,3
	mov ax,word ptr[ebx+2*eax]
	stosw
	xor eax,eax
	stosw
	dec ecx
	
Convert_LinearRGBPStoRGB64_SSE41_3:
	inc edx	
	shl edx,2	
	add src_B,edx
	add src_G,edx
	add src_R,edx	
	or ecx,ecx
	jnz Convert_LinearRGBPStoRGB64_SSE41_2
	
	mov eax,dst_modulo
	mov edx,src_modulo_B
	add edi,eax
	add src_B,edx
	mov eax,src_modulo_G
	mov edx,src_modulo_R
	add src_G,eax
	add src_R,edx
	dec h
	jnz Convert_LinearRGBPStoRGB64_SSE41_1
	
	pop ebx
	pop edi
	pop esi

	ret

JPSDR_HDRTools_Convert_LinearRGBPStoRGB64_SSE41 endp


JPSDR_HDRTools_Convert_LinearRGBPStoRGB64_AVX proc src_R:dword,src_G:dword,src_B:dword,dst:dword,w:dword,h:dword,lookup:dword,
	src_modulo_R:dword,src_modulo_G:dword,src_modulo_B:dword,dst_modulo:dword
	
	public JPSDR_HDRTools_Convert_LinearRGBPStoRGB64_AVX
	
	push esi
	push edi
	push ebx
	
	vmovaps ymm3,YMMWORD ptr data_f_1048575
	vmovaps ymm4,YMMWORD ptr data_f_0
	vmovaps ymm5,YMMWORD ptr data_f_1
	
	cld	
	mov edi,dst
	mov ebx,lookup	
	
Convert_LinearRGBPStoRGB64_AVX_1:
	mov ecx,w
Convert_LinearRGBPStoRGB64_AVX_2:
	mov esi,src_B
	xor edx,edx
	vmovaps ymm0,YMMWORD ptr[esi]
	mov esi,src_G
	vmaxps ymm0,ymm0,ymm4
	vmovaps ymm1,YMMWORD ptr[esi]
	mov esi,src_R
	vmaxps ymm1,ymm1,ymm4
	vmovaps ymm2,YMMWORD ptr[esi]
	vminps ymm0,ymm0,ymm5
	vmaxps ymm2,ymm2,ymm4
	vminps ymm1,ymm1,ymm5
	vminps ymm2,ymm2,ymm5
	
	vmulps ymm0,ymm0,ymm3
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
	jz Convert_LinearRGBPStoRGB64_AVX_3
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
	jz Convert_LinearRGBPStoRGB64_AVX_3
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
	jz Convert_LinearRGBPStoRGB64_AVX_3
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
	jz Convert_LinearRGBPStoRGB64_AVX_3
	inc edx
	
	vextractf128 xmm0,ymm0,1
	vextractf128 xmm1,ymm1,1
	vextractf128 xmm2,ymm2,1
	
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
	jz Convert_LinearRGBPStoRGB64_AVX_3
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
	jz short Convert_LinearRGBPStoRGB64_AVX_3
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
	jz short Convert_LinearRGBPStoRGB64_AVX_3
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
	
Convert_LinearRGBPStoRGB64_AVX_3:
	inc edx	
	shl edx,2	
	add src_B,edx
	add src_G,edx
	add src_R,edx	
	or ecx,ecx
	jnz Convert_LinearRGBPStoRGB64_AVX_2
	
	mov eax,dst_modulo
	mov edx,src_modulo_B
	add edi,eax
	add src_B,edx
	mov eax,src_modulo_G
	mov edx,src_modulo_R
	add src_G,eax
	add src_R,edx
	dec h
	jnz Convert_LinearRGBPStoRGB64_AVX_1
	
	vzeroupper
	
	pop ebx
	pop edi
	pop esi

	ret

JPSDR_HDRTools_Convert_LinearRGBPStoRGB64_AVX endp


JPSDR_HDRTools_Convert_RGBPStoRGB64_SSE41 proc src_R:dword,src_G:dword,src_B:dword,dst:dword,w:dword,h:dword,
	src_pitch_R:dword,src_pitch_G:dword,src_pitch_B:dword,dst_pitch:dword
	
	public JPSDR_HDRTools_Convert_RGBPStoRGB64_SSE41
	
	push esi
	push edi
	push ebx
	
	movaps xmm3,XMMWORD ptr data_f_65535
	pxor xmm4,xmm4

	mov esi,src_B
	mov ebx,src_G
	mov edx,src_R
	mov edi,dst
	
Convert_RGBPStoRGB64_SSE41_1:
	mov ecx,w
	xor eax,eax
	shr ecx,2
	jz short Convert_RGBPStoRGB64_SSE41_3
Convert_RGBPStoRGB64_SSE41_2:
	movaps xmm0,XMMWORD ptr[esi+4*eax]
	movaps xmm1,XMMWORD ptr[edx+4*eax]
	movaps xmm2,XMMWORD ptr[ebx+4*eax]
	mulps xmm0,xmm3
	mulps xmm1,xmm3
	mulps xmm2,xmm3
	cvtps2dq xmm0,xmm0
	cvtps2dq xmm1,xmm1
	cvtps2dq xmm2,xmm2
	
	packusdw xmm0,xmm0					;0000B4B3B2B1
	packusdw xmm1,xmm1					;0000R4R3R2R1
	packusdw xmm2,xmm2					;0000G4G3G2G1
	
	punpcklwd xmm0,xmm1             	;R4B4R3B3R2B2R1B1
	punpcklwd xmm2,xmm4             	;0G40G30G20G1
	movdqa xmm1,xmm0					;R4B4R3B3R2B2R1B1
	punpcklwd xmm0,xmm2             	;0R2G2B20R1G1B1
	punpckhwd xmm1,xmm2             	;0R4G4B40R3G3B3
	movdqa XMMWORD ptr[edi+8*eax],xmm0
	movdqa XMMWORD ptr[edi+8*eax+16],xmm1
	add eax,4
loop Convert_RGBPStoRGB64_SSE41_2

Convert_RGBPStoRGB64_SSE41_3:
	mov ecx,w
	and ecx,3
	jz short Convert_RGBPStoRGB64_SSE41_5
	
	movaps xmm0,XMMWORD ptr[esi+4*eax]
	movaps xmm1,XMMWORD ptr[edx+4*eax]
	movaps xmm2,XMMWORD ptr[ebx+4*eax]
	mulps xmm0,xmm3
	mulps xmm1,xmm3
	mulps xmm2,xmm3
	cvtps2dq xmm0,xmm0
	cvtps2dq xmm1,xmm1
	cvtps2dq xmm2,xmm2
	
	packusdw xmm0,xmm0					;0000B4B3B2B1
	packusdw xmm1,xmm1					;0000R4R3R2R1
	packusdw xmm2,xmm2					;0000G4G3G2G1
	
	punpcklwd xmm0,xmm1             	;R4B4R3B3R2B2R1B1
	punpcklwd xmm2,xmm4             	;0G40G30G20G1
	movdqa xmm1,xmm0					;R4B4R3B3R2B2R1B1
	punpcklwd xmm0,xmm2             	;0R2G2B20R1G1B1
	punpckhwd xmm1,xmm2             	;0R4G4B40R3G3B3
	
	test ecx,2
	jnz short Convert_RGBPStoRGB64_SSE41_4
	movq qword ptr[edi+8*eax],xmm0
	jmp short Convert_RGBPStoRGB64_SSE41_5
	
Convert_RGBPStoRGB64_SSE41_4:
	movdqa XMMWORD ptr[edi+8*eax],xmm0
	test ecx,1
	jz short Convert_RGBPStoRGB64_SSE41_5
	movq qword ptr[edi+8*eax+16],xmm1
	
Convert_RGBPStoRGB64_SSE41_5:
	add esi,src_pitch_B
	add ebx,src_pitch_G
	add edx,src_pitch_R
	add edi,dst_pitch
	dec h
	jnz Convert_RGBPStoRGB64_SSE41_1
	
	pop ebx
	pop edi
	pop esi

	ret

JPSDR_HDRTools_Convert_RGBPStoRGB64_SSE41 endp


JPSDR_HDRTools_Convert_RGBPStoRGB64_AVX proc src_R:dword,src_G:dword,src_B:dword,dst:dword,w:dword,h:dword,
	src_pitch_R:dword,src_pitch_G:dword,src_pitch_B:dword,dst_pitch:dword
	
	public JPSDR_HDRTools_Convert_RGBPStoRGB64_AVX
	
	push esi
	push edi
	push ebx
	
	vmovaps ymm3,YMMWORD ptr data_f_65535
	vpxor xmm4,xmm4,xmm4

	mov esi,src_B
	mov ebx,src_G
	mov edx,src_R
	mov edi,dst
	
Convert_RGBPStoRGB64_AVX_1:
	mov ecx,w
	xor eax,eax
	shr ecx,3
	jz Convert_RGBPStoRGB64_AVX_3
Convert_RGBPStoRGB64_AVX_2:
	vmovaps ymm0,YMMWORD ptr[esi+4*eax]
	vmovaps ymm1,YMMWORD ptr[edx+4*eax]
	vmovaps ymm2,YMMWORD ptr[ebx+4*eax]
	vmulps ymm0,ymm0,ymm3
	vmulps ymm1,ymm1,ymm3
	vmulps ymm2,ymm2,ymm3
	vcvtps2dq ymm0,ymm0
	vcvtps2dq ymm1,ymm1
	vcvtps2dq ymm2,ymm2
	
	vextractf128 xmm5,ymm0,1
	vextractf128 xmm6,ymm1,1
	vextractf128 xmm7,ymm2,1	
	
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
	jnz Convert_RGBPStoRGB64_AVX_2

Convert_RGBPStoRGB64_AVX_3:
	mov ecx,w
	and ecx,7
	jz Convert_RGBPStoRGB64_AVX_7
	
	vmovaps ymm0,YMMWORD ptr[esi+4*eax]
	vmovaps ymm1,YMMWORD ptr[edx+4*eax]
	vmovaps ymm2,YMMWORD ptr[ebx+4*eax]
	vmulps ymm0,ymm0,ymm3
	vmulps ymm1,ymm1,ymm3
	vmulps ymm2,ymm2,ymm3
	vcvtps2dq ymm0,ymm0
	vcvtps2dq ymm1,ymm1
	vcvtps2dq ymm2,ymm2
	
	vextractf128 xmm5,ymm0,1
	vextractf128 xmm6,ymm1,1
	vextractf128 xmm7,ymm2,1	
	
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
	jnz short Convert_RGBPStoRGB64_AVX_5
	test ecx,2
	jnz short Convert_RGBPStoRGB64_AVX_4
	vmovq qword ptr[edi+8*eax],xmm0
	jmp short Convert_RGBPStoRGB64_AVX_7
	
Convert_RGBPStoRGB64_AVX_4:
	vmovdqa XMMWORD ptr[edi+8*eax],xmm0
	test ecx,1
	jz short Convert_RGBPStoRGB64_AVX_7
	vmovq qword ptr[edi+8*eax+16],xmm1
	jmp short Convert_RGBPStoRGB64_AVX_7
	
Convert_RGBPStoRGB64_AVX_5:
	vmovdqa XMMWORD ptr[edi+8*eax],xmm0
	vmovdqa XMMWORD ptr[edi+8*eax+16],xmm1
	test ecx,2
	jnz short Convert_RGBPStoRGB64_AVX_6
	test ecx,1
	jz short Convert_RGBPStoRGB64_AVX_7
	vmovq qword ptr[edi+8*eax+32],xmm5
	jmp short Convert_RGBPStoRGB64_AVX_7
	
Convert_RGBPStoRGB64_AVX_6:
	vmovdqa XMMWORD ptr[edi+8*eax+32],xmm5
	test ecx,1
	jz short Convert_RGBPStoRGB64_AVX_7
	vmovq qword ptr[edi+8*eax+48],xmm6
	
Convert_RGBPStoRGB64_AVX_7:
	add esi,src_pitch_B
	add ebx,src_pitch_G
	add edx,src_pitch_R
	add edi,dst_pitch
	dec h
	jnz Convert_RGBPStoRGB64_AVX_1
	
	vzeroupper
	
	pop ebx
	pop edi
	pop esi

	ret

JPSDR_HDRTools_Convert_RGBPStoRGB64_AVX endp


JPSDR_HDRTools_Convert_RGB32toYV24_SSE2 proc src:dword,dst_y:dword,dst_u:dword,dst_v:dword,w:dword,h:dword,offset_Y:word,
	offset_U:word,offset_V:word,lookup:dword,src_modulo:dword,dst_modulo_y:dword,dst_modulo_u:dword,dst_modulo_v:dword,
	Min_Y:word,Max_Y:word,Min_U:word,Max_U:word,Min_V:word,Max_V:word

	public JPSDR_HDRTools_Convert_RGB32toYV24_SSE2

	local i,w0:dword

	push esi
	push edi
	push ebx

	pxor xmm4,xmm4
	pxor xmm3,xmm3
	pxor xmm2,xmm2
	pxor xmm1,xmm1
	pxor xmm0,xmm0
	movzx eax,offset_Y
	pinsrw xmm1,eax,0
	pinsrw xmm1,eax,1	
	movzx eax,offset_U
	pinsrw xmm1,eax,2
	pinsrw xmm1,eax,3
	movzx eax,offset_V
	pinsrw xmm1,eax,4
	pinsrw xmm1,eax,5
	movzx eax,Min_Y
	pinsrw xmm2,eax,0
	pinsrw xmm2,eax,1
	movzx eax,Max_Y
	pinsrw xmm3,eax,0
	pinsrw xmm3,eax,1
	movzx eax,Min_U
	pinsrw xmm2,eax,2
	pinsrw xmm2,eax,3
	movzx eax,Max_U
	pinsrw xmm3,eax,2
	pinsrw xmm3,eax,3
	movzx eax,Min_V
	pinsrw xmm2,eax,4
	pinsrw xmm2,eax,5
	movzx eax,Max_V
	pinsrw xmm3,eax,4
	pinsrw xmm3,eax,5

	mov eax,w
	shr eax,1
	mov w0,eax
	
	mov esi,src

Convert_RGB32toYV24_SSE2_1:
	mov edi,lookup
	mov eax,w0
	or eax,eax
	jz Convert_RGB32toYV24_SSE2_3
	
	mov i,eax
Convert_RGB32toYV24_SSE2_2:
	movzx edx,byte ptr[esi]
	movzx ecx,byte ptr[esi+1]
	movzx ebx,byte ptr[esi+2] ; ebx=R ecx=G edx=B
	movzx eax,word ptr[edi+2*ebx]
	add ax,word ptr[edi+2*ecx+512]
	add ax,word ptr[edi+2*edx+1024]
	pinsrw xmm0,eax,0
	movzx eax,word ptr[edi+2*ebx+1536]
	add ax,word ptr[edi+2*ecx+2048]
	add ax,word ptr[edi+2*edx+2560]
	pinsrw xmm0,eax,2
	movzx eax,word ptr[edi+2*ebx+3072]
	add ax,word ptr[edi+2*ecx+3584]
	add ax,word ptr[edi+2*edx+4096]
	pinsrw xmm0,eax,4
	movzx edx,byte ptr[esi+4]
	movzx ecx,byte ptr[esi+5]
	movzx ebx,byte ptr[esi+6] ; ebx=R ecx=G edx=B
	movzx eax,word ptr[edi+2*ebx]
	add ax,word ptr[edi+2*ecx+512]
	add ax,word ptr[edi+2*edx+1024]
	pinsrw xmm0,eax,1
	movzx eax,word ptr[edi+2*ebx+1536]
	add ax,word ptr[edi+2*ecx+2048]
	add ax,word ptr[edi+2*edx+2560]
	pinsrw xmm0,eax,3
	movzx eax,word ptr[edi+2*ebx+3072]
	add ax,word ptr[edi+2*ecx+3584]
	add ax,word ptr[edi+2*edx+4096]
	pinsrw xmm0,eax,5
	
	paddsw xmm0,xmm1
	psraw xmm0,6
	pmaxsw xmm0,xmm2
	pminsw xmm0,xmm3
	packuswb xmm0,xmm4
	
	mov edi,dst_y
	pextrw eax,xmm0,0
	add esi,8
	mov word ptr[edi],ax
	mov edi,dst_u
	pextrw eax,xmm0,1
	add dst_y,2
	mov word ptr[edi],ax
	mov edi,dst_v
	pextrw eax,xmm0,2
	add dst_u,2
	mov word ptr[edi],ax
	add dst_v,2
	
	mov edi,lookup
	
	dec i
	jnz Convert_RGB32toYV24_SSE2_2
	
Convert_RGB32toYV24_SSE2_3:	
	test w,1
	jz Convert_RGB32toYV24_SSE2_4
	
	movzx edx,byte ptr[esi]
	movzx ecx,byte ptr[esi+1]
	movzx ebx,byte ptr[esi+2] ; ebx=R ecx=G edx=B
	movzx eax,word ptr[edi+2*ebx]
	add ax,word ptr[edi+2*ecx+512]
	add ax,word ptr[edi+2*edx+1024]
	pinsrw xmm0,eax,0
	movzx eax,word ptr[edi+2*ebx+1536]
	add ax,word ptr[edi+2*ecx+2048]
	add ax,word ptr[edi+2*edx+2560]
	pinsrw xmm0,eax,2
	movzx eax,word ptr[edi+2*ebx+3072]
	add ax,word ptr[edi+2*ecx+3584]
	add ax,word ptr[edi+2*edx+4096]
	pinsrw xmm0,eax,4
	
	paddsw xmm0,xmm1
	psraw xmm0,6
	pmaxsw xmm0,xmm2
	pminsw xmm0,xmm3
	packuswb xmm0,xmm0
	
	mov edi,dst_y
	pextrw eax,xmm0,0
	add esi,4
	mov byte ptr[edi],al
	mov edi,dst_u
	pextrw eax,xmm0,2
	inc dst_y
	mov byte ptr[edi],al
	mov edi,dst_v
	pextrw eax,xmm0,4
	inc dst_u
	mov byte ptr[edi],al
	inc dst_v
	
Convert_RGB32toYV24_SSE2_4:	
	add esi,src_modulo
	mov eax,dst_y
	add eax,dst_modulo_y
	mov dst_y,eax
	mov eax,dst_u
	add eax,dst_modulo_u
	mov dst_u,eax
	mov eax,dst_v
	add eax,dst_modulo_v
	mov dst_v,eax
	dec h
	jnz Convert_RGB32toYV24_SSE2_1

	pop ebx
	pop edi
	pop esi

	ret

JPSDR_HDRTools_Convert_RGB32toYV24_SSE2 endp


JPSDR_HDRTools_Convert_RGB32toYV24_AVX proc src:dword,dst_y:dword,dst_u:dword,dst_v:dword,w:dword,h:dword,offset_Y:word,
	offset_U:word,offset_V:word,lookup:dword,src_modulo:dword,dst_modulo_y:dword,dst_modulo_u:dword,dst_modulo_v:dword,
	Min_Y:word,Max_Y:word,Min_U:word,Max_U:word,Min_V:word,Max_V:word

	public JPSDR_HDRTools_Convert_RGB32toYV24_AVX

	local i,w0:dword

	push esi
	push edi
	push ebx

	vpxor xmm4,xmm4,xmm4
	vpxor xmm3,xmm3,xmm3
	vpxor xmm2,xmm2,xmm2
	vpxor xmm1,xmm1,xmm1
	vpxor xmm0,xmm0,xmm0
	movzx eax,offset_Y
	vpinsrw xmm1,xmm1,eax,0
	vpinsrw xmm1,xmm1,eax,1	
	movzx eax,offset_U
	vpinsrw xmm1,xmm1,eax,2
	vpinsrw xmm1,xmm1,eax,3
	movzx eax,offset_V
	vpinsrw xmm1,xmm1,eax,4
	vpinsrw xmm1,xmm1,eax,5
	movzx eax,Min_Y
	vpinsrw xmm2,xmm2,eax,0
	vpinsrw xmm2,xmm2,eax,1
	movzx eax,Max_Y
	vpinsrw xmm3,xmm3,eax,0
	vpinsrw xmm3,xmm3,eax,1
	movzx eax,Min_U
	vpinsrw xmm2,xmm2,eax,2
	vpinsrw xmm2,xmm2,eax,3
	movzx eax,Max_U
	vpinsrw xmm3,xmm3,eax,2
	vpinsrw xmm3,xmm3,eax,3
	movzx eax,Min_V
	vpinsrw xmm2,xmm2,eax,4
	vpinsrw xmm2,xmm2,eax,5
	movzx eax,Max_V
	vpinsrw xmm3,xmm3,eax,4
	vpinsrw xmm3,xmm3,eax,5

	mov eax,w
	shr eax,1
	mov w0,eax
	
	mov esi,src

Convert_RGB32toYV24_AVX_1:
	mov edi,lookup
	mov eax,w0
	or eax,eax
	jz Convert_RGB32toYV24_AVX_3
	
	mov i,eax
Convert_RGB32toYV24_AVX_2:
	movzx edx,byte ptr[esi]
	movzx ecx,byte ptr[esi+1]
	movzx ebx,byte ptr[esi+2] ; ebx=R ecx=G edx=B
	movzx eax,word ptr[edi+2*ebx]
	add ax,word ptr[edi+2*ecx+512]
	add ax,word ptr[edi+2*edx+1024]
	vpinsrw xmm0,xmm0,eax,0
	movzx eax,word ptr[edi+2*ebx+1536]
	add ax,word ptr[edi+2*ecx+2048]
	add ax,word ptr[edi+2*edx+2560]
	vpinsrw xmm0,xmm0,eax,2
	movzx eax,word ptr[edi+2*ebx+3072]
	add ax,word ptr[edi+2*ecx+3584]
	add ax,word ptr[edi+2*edx+4096]
	vpinsrw xmm0,xmm0,eax,4
	movzx edx,byte ptr[esi+4]
	movzx ecx,byte ptr[esi+5]
	movzx ebx,byte ptr[esi+6] ; ebx=R ecx=G edx=B
	movzx eax,word ptr[edi+2*ebx]
	add ax,word ptr[edi+2*ecx+512]
	add ax,word ptr[edi+2*edx+1024]
	vpinsrw xmm0,xmm0,eax,1
	movzx eax,word ptr[edi+2*ebx+1536]
	add ax,word ptr[edi+2*ecx+2048]
	add ax,word ptr[edi+2*edx+2560]
	vpinsrw xmm0,xmm0,eax,3
	movzx eax,word ptr[edi+2*ebx+3072]
	add ax,word ptr[edi+2*ecx+3584]
	add ax,word ptr[edi+2*edx+4096]
	vpinsrw xmm0,xmm0,eax,5
	
	vpaddsw xmm0,xmm0,xmm1
	vpsraw xmm0,xmm0,6
	vpmaxsw xmm0,xmm0,xmm2
	vpminsw xmm0,xmm0,xmm3
	vpackuswb xmm0,xmm0,xmm4
	
	mov edi,dst_y
	vpextrw eax,xmm0,0
	add esi,8
	mov word ptr[edi],ax
	mov edi,dst_u
	vpextrw eax,xmm0,1
	add dst_y,2
	mov word ptr[edi],ax
	mov edi,dst_v
	vpextrw eax,xmm0,2
	add dst_u,2
	mov word ptr[edi],ax
	add dst_v,2
	
	mov edi,lookup
	
	dec i
	jnz Convert_RGB32toYV24_AVX_2
	
Convert_RGB32toYV24_AVX_3:	
	test w,1
	jz Convert_RGB32toYV24_AVX_4
	
	movzx edx,byte ptr[esi]
	movzx ecx,byte ptr[esi+1]
	movzx ebx,byte ptr[esi+2] ; ebx=R ecx=G edx=B
	movzx eax,word ptr[esi+2*ebx]
	add ax,word ptr[edi+2*ecx+512]
	add ax,word ptr[edi+2*edx+1024]
	vpinsrw xmm0,xmm0,eax,0
	movzx eax,word ptr[edi+2*ebx+1536]
	add ax,word ptr[edi+2*ecx+2048]
	add ax,word ptr[edi+2*edx+2560]
	vpinsrw xmm0,xmm0,eax,2
	movzx eax,word ptr[edi+2*ebx+3072]
	add ax,word ptr[edi+2*ecx+3584]
	add ax,word ptr[edi+2*edx+4096]
	vpinsrw xmm0,xmm0,eax,4
	
	vpaddsw xmm0,xmm0,xmm1
	vpsraw xmm0,xmm0,6
	vpmaxsw xmm0,xmm0,xmm2
	vpminsw xmm0,xmm0,xmm3
	vpackuswb xmm0,xmm0,xmm0
	
	mov edi,dst_y
	vpextrw eax,xmm0,0
	add esi,4
	mov byte ptr[edi],al
	mov edi,dst_u
	vpextrw eax,xmm0,2
	inc dst_y
	mov byte ptr[edi],al
	mov edi,dst_v
	vpextrw eax,xmm0,4
	inc dst_u
	mov byte ptr[edi],al
	inc dst_v
	
Convert_RGB32toYV24_AVX_4:	
	add esi,src_modulo
	mov eax,dst_y
	add eax,dst_modulo_y
	mov dst_y,eax
	mov eax,dst_u
	add eax,dst_modulo_u
	mov dst_u,eax
	mov eax,dst_v
	add eax,dst_modulo_v
	mov dst_v,eax
	dec h
	jnz Convert_RGB32toYV24_AVX_1

	pop ebx
	pop edi
	pop esi

	ret

JPSDR_HDRTools_Convert_RGB32toYV24_AVX endp


JPSDR_HDRTools_Convert_RGB64toYV24_SSE41 proc src:dword,dst_y:dword,dst_u:dword,dst_v:dword,w:dword,h:dword,offset_Y:dword,
	offset_U:dword,offset_V:dword,lookup:dword,src_modulo:dword,dst_modulo_y:dword,dst_modulo_u:dword,dst_modulo_v:dword,
	Min_Y:word,Max_Y:word,Min_U:word,Max_U:word,Min_V:word,Max_V:word

	public JPSDR_HDRTools_Convert_RGB64toYV24_SSE41

	local i,w0:dword

	push esi
	push edi
	push ebx

	pxor xmm4,xmm4
	pxor xmm3,xmm3
	pxor xmm2,xmm2
	pxor xmm1,xmm1
	pxor xmm0,xmm0
	mov eax,offset_Y
	pinsrd xmm1,eax,0
	mov eax,offset_U
	pinsrd xmm1,eax,1
	mov eax,offset_V
	pinsrd xmm1,eax,2
	movzx eax,Min_Y
	pinsrw xmm2,eax,0
	pinsrw xmm2,eax,1
	movzx eax,Max_Y
	pinsrw xmm3,eax,0
	pinsrw xmm3,eax,1
	movzx eax,Min_U
	pinsrw xmm2,eax,2
	pinsrw xmm2,eax,3
	movzx eax,Max_U
	pinsrw xmm3,eax,2
	pinsrw xmm3,eax,3
	movzx eax,Min_V
	pinsrw xmm2,eax,4
	pinsrw xmm2,eax,5
	movzx eax,Max_V
	pinsrw xmm3,eax,4
	pinsrw xmm3,eax,5

	mov eax,w
	shr eax,1
	mov w0,eax
	
	mov esi,src

Convert_RGB64toYV24_SSE41_1:
	mov edi,lookup
	mov eax,w0
	or eax,eax
	jz Convert_RGB64toYV24_SSE41_3
	
	mov i,eax
Convert_RGB64toYV24_SSE41_2:
	movzx edx,word ptr[esi]
	movzx ecx,word ptr[esi+2]
	movzx ebx,word ptr[esi+4] ; ebx=R ecx=G edx=B
	mov eax,dword ptr[edi+4*ebx]
	add eax,dword ptr[edi+4*ecx+262144]
	add eax,dword ptr[edi+4*edx+524288]
	pinsrd xmm0,eax,0
	mov eax,dword ptr[edi+4*ebx+786432]
	add eax,dword ptr[edi+4*ecx+1048576]
	add eax,dword ptr[edi+4*edx+1310720]
	pinsrd xmm0,eax,1
	mov eax,dword ptr[edi+4*ebx+1572864]
	add eax,dword ptr[edi+4*ecx+1835008]
	add eax,dword ptr[edi+4*edx+2097152]
	pinsrd xmm0,eax,2
	movzx edx,word ptr[esi+8]
	movzx ecx,word ptr[esi+10]
	movzx ebx,word ptr[esi+12] ; ebx=R ecx=G edx=B
	mov eax,dword ptr[edi+4*ebx]
	add eax,dword ptr[edi+4*ecx+262144]
	add eax,dword ptr[edi+4*edx+524288]
	pinsrd xmm4,eax,0
	mov eax,dword ptr[edi+4*ebx+786432]
	add eax,dword ptr[edi+4*ecx+1048576]
	add eax,dword ptr[edi+4*edx+1310720]
	pinsrd xmm4,eax,1
	mov eax,dword ptr[edi+4*ebx+1572864]
	add eax,dword ptr[edi+4*ecx+1835008]
	add eax,dword ptr[edi+4*edx+2097152]
	pinsrd xmm4,eax,2
	
	paddd xmm0,xmm1
	paddd xmm4,xmm1
	psrad xmm0,8
	psrad xmm4,8
	packusdw xmm0,xmm4
	movhlps xmm4,xmm0
	punpcklwd xmm0,xmm4
	pmaxuw xmm0,xmm2
	pminuw xmm0,xmm3
	
	mov edi,dst_y
	pextrd eax,xmm0,0
	add esi,16
	mov dword ptr[edi],eax
	mov edi,dst_u
	pextrd eax,xmm0,1
	add dst_y,4
	mov dword ptr[edi],eax
	mov edi,dst_v
	pextrd eax,xmm0,2
	add dst_u,4
	mov dword ptr[edi],eax
	add dst_v,4
	
	mov edi,lookup
	
	dec i
	jnz Convert_RGB64toYV24_SSE41_2
	
Convert_RGB64toYV24_SSE41_3:	
	test w,1
	jz Convert_RGB64toYV24_SSE41_4
	
	movzx edx,word ptr[esi]
	movzx ecx,word ptr[esi+2]
	movzx ebx,word ptr[esi+4] ; ebx=R ecx=G edx=B
	mov eax,dword ptr[edi+4*ebx]
	add eax,dword ptr[edi+4*ecx+262144]
	add eax,dword ptr[edi+4*edx+524288]
	pinsrd xmm0,eax,0
	mov eax,dword ptr[edi+4*ebx+786432]
	add eax,dword ptr[edi+4*ecx+1048576]
	add eax,dword ptr[edi+4*edx+1310720]
	pinsrd xmm0,eax,1
	mov eax,dword ptr[edi+4*ebx+1572864]
	add eax,dword ptr[edi+4*ecx+1835008]
	add eax,dword ptr[edi+4*edx+2097152]
	pinsrd xmm0,eax,2
	
	paddd xmm0,xmm1
	psrad xmm0,8
	packusdw xmm0,xmm0
	punpcklwd xmm0,xmm0	
	pmaxuw xmm0,xmm2
	pminuw xmm0,xmm3
	
	mov edi,dst_y
	pextrw eax,xmm0,0
	add esi,8
	mov word ptr[edi],ax
	mov edi,dst_u
	pextrw eax,xmm0,2
	add dst_y,2
	mov word ptr[edi],ax
	mov edi,dst_v
	pextrw eax,xmm0,4
	add dst_u,2
	mov word ptr[edi],ax
	add dst_v,2
	
Convert_RGB64toYV24_SSE41_4:	
	add esi,src_modulo
	mov eax,dst_y
	add eax,dst_modulo_y
	mov dst_y,eax
	mov eax,dst_u
	add eax,dst_modulo_u
	mov dst_u,eax
	mov eax,dst_v
	add eax,dst_modulo_v
	mov dst_v,eax
	dec h
	jnz Convert_RGB64toYV24_SSE41_1

	pop ebx
	pop edi
	pop esi

	ret

JPSDR_HDRTools_Convert_RGB64toYV24_SSE41 endp


JPSDR_HDRTools_Convert_RGB64toYV24_AVX proc src:dword,dst_y:dword,dst_u:dword,dst_v:dword,w:dword,h:dword,offset_Y:dword,
	offset_U:dword,offset_V:dword,lookup:dword,src_modulo:dword,dst_modulo_y:dword,dst_modulo_u:dword,dst_modulo_v:dword,
	Min_Y:word,Max_Y:word,Min_U:word,Max_U:word,Min_V:word,Max_V:word

	public JPSDR_HDRTools_Convert_RGB64toYV24_AVX

	local i,w0:dword

	push esi
	push edi
	push ebx

	vpxor xmm4,xmm4,xmm4
	vpxor xmm3,xmm3,xmm3
	vpxor xmm2,xmm2,xmm2
	vpxor xmm1,xmm1,xmm1
	vpxor xmm0,xmm0,xmm0
	mov eax,offset_Y
	vpinsrd xmm1,xmm1,eax,0
	mov eax,offset_U
	vpinsrd xmm1,xmm1,eax,1
	mov eax,offset_V
	vpinsrd xmm1,xmm1,eax,2
	movzx eax,Min_Y
	vpinsrw xmm2,xmm2,eax,0
	vpinsrw xmm2,xmm2,eax,1
	movzx eax,Max_Y
	vpinsrw xmm3,xmm3,eax,0
	vpinsrw xmm3,xmm3,eax,1
	movzx eax,Min_U
	vpinsrw xmm2,xmm2,eax,2
	vpinsrw xmm2,xmm2,eax,3
	movzx eax,Max_U
	vpinsrw xmm3,xmm3,eax,2
	vpinsrw xmm3,xmm3,eax,3
	movzx eax,Min_V
	vpinsrw xmm2,xmm2,eax,4
	vpinsrw xmm2,xmm2,eax,5
	movzx eax,Max_V
	vpinsrw xmm3,xmm3,eax,4
	vpinsrw xmm3,xmm3,eax,5

	mov eax,w
	shr eax,1
	mov w0,eax
	
	mov esi,src

Convert_RGB64toYV24_AVX_1:
	mov edi,lookup
	mov eax,w0
	or eax,eax
	jz Convert_RGB64toYV24_AVX_3
	
	mov i,eax
Convert_RGB64toYV24_AVX_2:
	movzx edx,word ptr[esi]
	movzx ecx,word ptr[esi+2]
	movzx ebx,word ptr[esi+4] ; ebx=R ecx=G edx=B
	mov eax,dword ptr[edi+4*ebx]
	add eax,dword ptr[edi+4*ecx+262144]
	add eax,dword ptr[edi+4*edx+524288]
	vpinsrd xmm0,xmm0,eax,0
	mov eax,dword ptr[edi+4*ebx+786432]
	add eax,dword ptr[edi+4*ecx+1048576]
	add eax,dword ptr[edi+4*edx+1310720]
	vpinsrd xmm0,xmm0,eax,1
	mov eax,dword ptr[edi+4*ebx+1572864]
	add eax,dword ptr[edi+4*ecx+1835008]
	add eax,dword ptr[edi+4*edx+2097152]
	vpinsrd xmm0,xmm0,eax,2
	movzx edx,word ptr[esi+8]
	movzx ecx,word ptr[esi+10]
	movzx ebx,word ptr[esi+12] ; ebx=R ecx=G edx=B
	mov eax,dword ptr[edi+4*ebx]
	add eax,dword ptr[edi+4*ecx+262144]
	add eax,dword ptr[edi+4*edx+524288]
	vpinsrd xmm4,xmm4,eax,0
	mov eax,dword ptr[edi+4*ebx+786432]
	add eax,dword ptr[edi+4*ecx+1048576]
	add eax,dword ptr[edi+4*edx+1310720]
	vpinsrd xmm4,xmm4,eax,1
	mov eax,dword ptr[edi+4*ebx+1572864]
	add eax,dword ptr[edi+4*ecx+1835008]
	add eax,dword ptr[edi+4*edx+2097152]
	vpinsrd xmm4,xmm4,eax,2
	
	vpaddd xmm0,xmm0,xmm1
	vpaddd xmm4,xmm4,xmm1
	vpsrad xmm0,xmm0,8
	vpsrad xmm4,xmm4,8
	vpackusdw xmm0,xmm0,xmm4
	vmovhlps xmm4,xmm4,xmm0
	vpunpcklwd xmm0,xmm0,xmm4
	vpmaxuw xmm0,xmm0,xmm2
	vpminuw xmm0,xmm0,xmm3
	
	mov edi,dst_y
	vpextrd eax,xmm0,0
	add esi,16
	mov dword ptr[edi],eax
	mov edi,dst_u
	vpextrd eax,xmm0,1
	add dst_y,4
	mov dword ptr[edi],eax
	mov edi,dst_v
	vpextrd eax,xmm0,2
	add dst_u,4
	mov dword ptr[edi],eax
	add dst_v,4
	
	mov edi,lookup
	
	dec i
	jnz Convert_RGB64toYV24_AVX_2
	
Convert_RGB64toYV24_AVX_3:	
	test w,1
	jz Convert_RGB64toYV24_AVX_4
	
	movzx edx,word ptr[esi]
	movzx ecx,word ptr[esi+2]
	movzx ebx,word ptr[esi+4] ; ebx=R ecx=G edx=B
	mov eax,dword ptr[edi+4*ebx]
	add eax,dword ptr[edi+4*ecx+262144]
	add eax,dword ptr[edi+4*edx+524288]
	vpinsrd xmm0,xmm0,eax,0
	mov eax,dword ptr[edi+4*ebx+786432]
	add eax,dword ptr[edi+4*ecx+1048576]
	add eax,dword ptr[edi+4*edx+1310720]
	vpinsrd xmm0,xmm0,eax,1
	mov eax,dword ptr[edi+4*ebx+1572864]
	add eax,dword ptr[edi+4*ecx+1835008]
	add eax,dword ptr[edi+4*edx+2097152]
	vpinsrd xmm0,xmm0,eax,2
	
	vpaddd xmm0,xmm0,xmm1
	vpsrad xmm0,xmm0,8
	vpackusdw xmm0,xmm0,xmm0
	vpunpcklwd xmm0,xmm0,xmm0	
	vpmaxuw xmm0,xmm0,xmm2
	vpminuw xmm0,xmm0,xmm3
	
	mov edi,dst_y
	vpextrw eax,xmm0,0
	add esi,8
	mov word ptr[edi],ax
	mov edi,dst_u
	vpextrw eax,xmm0,2
	add dst_y,2
	mov word ptr[edi],ax
	mov edi,dst_v
	vpextrw eax,xmm0,4
	add dst_u,2
	mov word ptr[edi],ax
	add dst_v,2
	
Convert_RGB64toYV24_AVX_4:	
	add esi,src_modulo
	mov eax,dst_y
	add eax,dst_modulo_y
	mov dst_y,eax
	mov eax,dst_u
	add eax,dst_modulo_u
	mov dst_u,eax
	mov eax,dst_v
	add eax,dst_modulo_v
	mov dst_v,eax
	dec h
	jnz Convert_RGB64toYV24_AVX_1

	pop ebx
	pop edi
	pop esi

	ret

JPSDR_HDRTools_Convert_RGB64toYV24_AVX endp


JPSDR_HDRTools_Convert_Planar444_to_Planar422_8 proc src:dword,dst:dword,w:dword,h:dword,src_modulo:dword,dst_modulo:dword

	public JPSDR_HDRTools_Convert_Planar444_to_Planar422_8
	
	push esi
	push edi
	push ebx
	
	cld
	mov edi,dst
	mov esi,src
	mov ebx,src_modulo
	xor edx,edx
	xor eax,eax

Convert_Planar444_to_Planar422_8_1:
	mov ecx,w
	
Convert_Planar444_to_Planar422_8_2:
	lodsb
	mov dl,al
	lodsb
	add ax,dx
	shr ax,1
	stosb
	loop Convert_Planar444_to_Planar422_8_2
	
	add esi,ebx
	add edi,dst_modulo
	dec h
	jnz short Convert_Planar444_to_Planar422_8_1


	pop ebx
	pop edi
	pop esi

	ret

JPSDR_HDRTools_Convert_Planar444_to_Planar422_8 endp


JPSDR_HDRTools_Convert_Planar444_to_Planar422_16 proc src:dword,dst:dword,w:dword,h:dword,src_modulo:dword,dst_modulo:dword

	public JPSDR_HDRTools_Convert_Planar444_to_Planar422_16
	
	push esi
	push edi
	push ebx
	
	cld
	mov edi,dst
	mov esi,src
	mov ebx,src_modulo
	xor edx,edx
	xor eax,eax

Convert_Planar444_to_Planar422_16_1:
	mov ecx,w
	
Convert_Planar444_to_Planar422_16_2:
	lodsw
	mov dx,ax
	lodsw
	add eax,edx
	shr eax,1	
	stosw
	loop Convert_Planar444_to_Planar422_16_2
	
	add esi,ebx
	add edi,dst_modulo
	dec h
	jnz short Convert_Planar444_to_Planar422_16_1


	pop ebx
	pop edi
	pop esi

	ret

JPSDR_HDRTools_Convert_Planar444_to_Planar422_16 endp


JPSDR_HDRTools_Convert_Planar444_to_Planar422_8_SSE2 proc src:dword,dst:dword,w16:dword,h:dword,src_pitch:dword,dst_pitch:dword

	public JPSDR_HDRTools_Convert_Planar444_to_Planar422_8_SSE2
	
	push esi
	push edi
	push ebx
	
	mov edi,dst
	mov esi,src
	mov ebx,16
	mov edx,esi
	add edx,ebx

Convert_Planar444_to_Planar422_8_SSE2_1:
	mov ecx,w16
	xor eax,eax	
	shr ecx,1
	jz short Convert_Planar444_to_Planar422_8_SSE2_3
	
Convert_Planar444_to_Planar422_8_SSE2_2:
	movdqa xmm0,XMMWORD ptr[esi+2*eax]
	movdqa xmm2,XMMWORD ptr[edx+2*eax]
	movdqa xmm1,xmm0
	movdqa xmm3,xmm2
	psllw xmm1,8
	psllw xmm3,8
	pavgb xmm0,xmm1
	pavgb xmm2,xmm3
	psrlw xmm0,8
	psrlw xmm2,8
	packuswb xmm0,xmm2
	
	movdqa XMMWORD ptr[edi+eax],xmm0
	add eax,ebx
	loop Convert_Planar444_to_Planar422_8_SSE2_2
	
Convert_Planar444_to_Planar422_8_SSE2_3:	
	test w16,1
	jz short Convert_Planar444_to_Planar422_8_SSE2_4
	
	movdqa xmm0,XMMWORD ptr[esi+2*eax]
	movdqa xmm1,xmm0
	psllw xmm1,8
	pavgb xmm0,xmm1
	psrlw xmm0,8
	packuswb xmm0,xmm0
	
	movq qword ptr[edi+eax],xmm0

Convert_Planar444_to_Planar422_8_SSE2_4:	
	add esi,src_pitch
	add edx,src_pitch
	add edi,dst_pitch
	dec h
	jnz short Convert_Planar444_to_Planar422_8_SSE2_1


	pop ebx
	pop edi
	pop esi

	ret

JPSDR_HDRTools_Convert_Planar444_to_Planar422_8_SSE2 endp


JPSDR_HDRTools_Convert_Planar444_to_Planar422_16_SSE41 proc src:dword,dst:dword,w8:dword,h:dword,src_pitch:dword,dst_pitch:dword

	public JPSDR_HDRTools_Convert_Planar444_to_Planar422_16_SSE41
	
	push esi
	push edi
	push ebx
	
	mov edi,dst
	mov esi,src
	mov ebx,16
	mov edx,esi
	add edx,ebx

Convert_Planar444_to_Planar422_16_SSE41_1:
	mov ecx,w8
	xor eax,eax
	shr ecx,1
	jz short Convert_Planar444_to_Planar422_16_SSE41_3

Convert_Planar444_to_Planar422_16_SSE41_2:
	movdqa xmm0,XMMWORD ptr[esi+2*eax]
	movdqa xmm2,XMMWORD ptr[edx+2*eax]	
	movdqa xmm1,xmm0
	movdqa xmm3,xmm2
	pslld xmm1,16
	pslld xmm3,16
	pavgw xmm0,xmm1
	pavgw xmm2,xmm3
	psrld xmm0,16
	psrld xmm2,16
	packusdw xmm0,xmm2
	
	movdqa XMMWORD ptr[edi+eax],xmm0
	add eax,ebx
	loop Convert_Planar444_to_Planar422_16_SSE41_2
	
Convert_Planar444_to_Planar422_16_SSE41_3:	
	test w8,1
	jz short Convert_Planar444_to_Planar422_16_SSE41_4
	
	movdqa xmm0,XMMWORD ptr[esi+2*eax]
	movdqa xmm1,xmm0
	pslld xmm1,16
	pavgw xmm0,xmm1
	psrld xmm0,16
	packusdw xmm0,xmm0
	movq qword ptr[edi+eax],xmm0
	
Convert_Planar444_to_Planar422_16_SSE41_4:	
	add esi,src_pitch
	add edx,src_pitch
	add edi,dst_pitch
	dec h
	jnz short Convert_Planar444_to_Planar422_16_SSE41_1


	pop ebx
	pop edi
	pop esi

	ret

JPSDR_HDRTools_Convert_Planar444_to_Planar422_16_SSE41 endp


JPSDR_HDRTools_Convert_Planar444_to_Planar422_8_AVX proc src:dword,dst:dword,w16:dword,h:dword,src_pitch:dword,dst_pitch:dword

	public JPSDR_HDRTools_Convert_Planar444_to_Planar422_8_AVX
	
	push esi
	push edi
	push ebx
	
	mov edi,dst
	mov esi,src
	mov ebx,16
	mov edx,esi
	add edx,ebx

Convert_Planar444_to_Planar422_8_AVX_1:
	mov ecx,w16
	xor eax,eax	
	shr ecx,1
	jz short Convert_Planar444_to_Planar422_8_AVX_3
	
Convert_Planar444_to_Planar422_8_AVX_2:
	vmovdqa xmm0,XMMWORD ptr[esi+2*eax]
	vmovdqa xmm2,XMMWORD ptr[edx+2*eax]
	vpsllw xmm1,xmm0,8
	vpsllw xmm3,xmm2,8
	vpavgb xmm0,xmm0,xmm1
	vpavgb xmm2,xmm2,xmm3
	vpsrlw xmm0,xmm0,8
	vpsrlw xmm2,xmm2,8
	vpackuswb xmm0,xmm0,xmm2
	
	vmovdqa XMMWORD ptr[edi+eax],xmm0
	add eax,ebx
	loop Convert_Planar444_to_Planar422_8_AVX_2
	
Convert_Planar444_to_Planar422_8_AVX_3:	
	test w16,1
	jz short Convert_Planar444_to_Planar422_8_AVX_4
	
	vmovdqa xmm0,XMMWORD ptr[esi+2*eax]
	vpsllw xmm1,xmm0,8
	vpavgb xmm0,xmm0,xmm1
	vpsrlw xmm0,xmm0,8
	vpackuswb xmm0,xmm0,xmm0
	
	vmovq qword ptr[edi+eax],xmm0

Convert_Planar444_to_Planar422_8_AVX_4:	
	add esi,src_pitch
	add edx,src_pitch
	add edi,dst_pitch
	dec h
	jnz short Convert_Planar444_to_Planar422_8_AVX_1


	pop ebx
	pop edi
	pop esi

	ret

JPSDR_HDRTools_Convert_Planar444_to_Planar422_8_AVX endp


JPSDR_HDRTools_Convert_Planar444_to_Planar422_16_AVX proc src:dword,dst:dword,w8:dword,h:dword,src_pitch:dword,dst_pitch:dword

	public JPSDR_HDRTools_Convert_Planar444_to_Planar422_16_AVX
	
	push esi
	push edi
	push ebx
	
	mov edi,dst
	mov esi,src
	mov ebx,16
	mov edx,esi
	add edx,ebx

Convert_Planar444_to_Planar422_16_AVX_1:
	mov ecx,w8
	xor eax,eax
	shr ecx,1
	jz short Convert_Planar444_to_Planar422_16_AVX_3

Convert_Planar444_to_Planar422_16_AVX_2:
	vmovdqa xmm0,XMMWORD ptr[esi+2*eax]
	vmovdqa xmm2,XMMWORD ptr[edx+2*eax]	
	vpslld xmm1,xmm0,16
	vpslld xmm3,xmm2,16
	vpavgw xmm0,xmm0,xmm1
	vpavgw xmm2,xmm2,xmm3
	vpsrld xmm0,xmm0,16
	vpsrld xmm2,xmm2,16
	vpackusdw xmm0,xmm0,xmm2
	
	vmovdqa XMMWORD ptr[edi+eax],xmm0
	add eax,ebx
	loop Convert_Planar444_to_Planar422_16_AVX_2
	
Convert_Planar444_to_Planar422_16_AVX_3:	
	test w8,1
	jz short Convert_Planar444_to_Planar422_16_AVX_4
	
	vmovdqa xmm0,XMMWORD ptr[esi+2*eax]
	vpslld xmm1,xmm0,16
	vpavgw xmm0,xmm0,xmm1
	vpsrld xmm0,xmm0,16
	vpackusdw xmm0,xmm0,xmm0
	vmovq qword ptr[edi+eax],xmm0
	
Convert_Planar444_to_Planar422_16_AVX_4:	
	add esi,src_pitch
	add edx,src_pitch
	add edi,dst_pitch
	dec h
	jnz short Convert_Planar444_to_Planar422_16_AVX_1


	pop ebx
	pop edi
	pop esi

	ret

JPSDR_HDRTools_Convert_Planar444_to_Planar422_16_AVX endp


JPSDR_HDRTools_Convert_Planar422_to_Planar420_8_SSE2 proc src1:dword,src2:dword,dst:dword,w16:dword,h:dword,src_pitch2:dword,dst_pitch:dword

	public JPSDR_HDRTools_Convert_Planar422_to_Planar420_8_SSE2
	
	push esi
	push edi
	push ebx
	
	mov edi,dst
	mov esi,src1
	mov edx,src2
	mov ebx,16
	
Convert_Planar422_to_Planar420_8_SSE2_1:
	xor eax,eax
	mov ecx,w16

Convert_Planar422_to_Planar420_8_SSE2_2:
	movdqa xmm0,XMMWORD ptr[esi+eax]
	pavgb xmm0,XMMWORD ptr[edx+eax]
	
	movdqa XMMWORD ptr[edi+eax],xmm0
	add eax,ebx
	loop Convert_Planar422_to_Planar420_8_SSE2_2
	
	add esi,src_pitch2
	add edx,src_pitch2
	add edi,dst_pitch
	dec h
	jnz short Convert_Planar422_to_Planar420_8_SSE2_1
	
	pop ebx
	pop edi
	pop esi

	ret

JPSDR_HDRTools_Convert_Planar422_to_Planar420_8_SSE2 endp


JPSDR_HDRTools_Convert_Planar422_to_Planar420_16_SSE2 proc src1:dword,src2:dword,dst:dword,w8:dword,h:dword,src_pitch2:dword,dst_pitch:dword

	public JPSDR_HDRTools_Convert_Planar422_to_Planar420_16_SSE2
	
	push esi
	push edi
	push ebx
	
	mov edi,dst
	mov esi,src1
	mov edx,src2
	mov ebx,16
	
Convert_Planar422_to_Planar420_16_SSE2_1:
	xor eax,eax
	mov ecx,w8

Convert_Planar422_to_Planar420_16_SSE2_2:
	movdqa xmm0,XMMWORD ptr[esi+eax]
	pavgw xmm0,XMMWORD ptr[edx+eax]
	
	movdqa XMMWORD ptr[edi+eax],xmm0
	add eax,ebx
	loop Convert_Planar422_to_Planar420_16_SSE2_2
	
	add esi,src_pitch2
	add edx,src_pitch2
	add edi,dst_pitch
	dec h
	jnz short Convert_Planar422_to_Planar420_16_SSE2_1
	
	pop ebx
	pop edi
	pop esi

	ret

JPSDR_HDRTools_Convert_Planar422_to_Planar420_16_SSE2 endp


JPSDR_HDRTools_Convert_Planar422_to_Planar420_8_AVX proc src1:dword,src2:dword,dst:dword,w16:dword,h:dword,src_pitch2:dword,dst_pitch:dword

	public JPSDR_HDRTools_Convert_Planar422_to_Planar420_8_AVX
	
	push esi
	push edi
	push ebx
	
	mov edi,dst
	mov esi,src1
	mov edx,src2
	mov ebx,16
	
Convert_Planar422_to_Planar420_8_AVX_1:
	xor eax,eax
	mov ecx,w16

Convert_Planar422_to_Planar420_8_AVX_2:
	vmovdqa xmm0,XMMWORD ptr[esi+eax]
	vpavgb xmm0,xmm0,XMMWORD ptr[edx+eax]
	
	vmovdqa XMMWORD ptr[edi+eax],xmm0
	add eax,ebx
	loop Convert_Planar422_to_Planar420_8_AVX_2
	
	add esi,src_pitch2
	add edx,src_pitch2
	add edi,dst_pitch
	dec h
	jnz short Convert_Planar422_to_Planar420_8_AVX_1
	
	pop ebx
	pop edi
	pop esi

	ret

JPSDR_HDRTools_Convert_Planar422_to_Planar420_8_AVX endp


JPSDR_HDRTools_Convert_Planar422_to_Planar420_16_AVX proc src1:dword,src2:dword,dst:dword,w8:dword,h:dword,src_pitch2:dword,dst_pitch:dword

	public JPSDR_HDRTools_Convert_Planar422_to_Planar420_16_AVX
	
	push esi
	push edi
	push ebx
	
	mov edi,dst
	mov esi,src1
	mov edx,src2
	mov ebx,16
	
Convert_Planar422_to_Planar420_16_AVX_1:
	xor eax,eax
	mov ecx,w8

Convert_Planar422_to_Planar420_16_AVX_2:
	vmovdqa xmm0,XMMWORD ptr[esi+eax]
	vpavgw xmm0,xmm0,XMMWORD ptr[edx+eax]
	
	vmovdqa XMMWORD ptr[edi+eax],xmm0
	add eax,ebx
	loop Convert_Planar422_to_Planar420_16_AVX_2
	
	add esi,src_pitch2
	add edx,src_pitch2
	add edi,dst_pitch
	dec h
	jnz short Convert_Planar422_to_Planar420_16_AVX_1
	
	pop ebx
	pop edi
	pop esi

	ret

JPSDR_HDRTools_Convert_Planar422_to_Planar420_16_AVX endp


;***************************************************
;**             XYZ/RGB functions                 **
;***************************************************


JPSDR_HDRTools_Convert_PackedXYZ_8_SSE2 proc src:dword,dst:dword,w:dword,h:dword,lookup:dword,
	src_modulo:dword,dst_modulo:dword

	public JPSDR_HDRTools_Convert_PackedXYZ_8_SSE2

	local i,w0:dword

	push esi
	push edi
	push ebx

	mov eax,w
	shr eax,2
	mov w0,eax
	
	mov esi,src

Convert_PackedXYZ_8_SSE2_1:
	mov edi,lookup
	mov eax,w0
	or eax,eax
	jz Convert_PackedXYZ_8_SSE2_3
	
	mov i,eax
Convert_PackedXYZ_8_SSE2_2:
	pxor xmm0,xmm0
	movzx edx,byte ptr[esi]
	movzx ecx,byte ptr[esi+1]
	movzx ebx,byte ptr[esi+2] ; ebx=R/X ecx=G/Y edx=B/Z
	movzx eax,word ptr[edi+2*ebx]
	add ax,word ptr[edi+2*ecx+512]
	add ax,word ptr[edi+2*edx+1024]
	pinsrw xmm0,eax,2
	movzx eax,word ptr[edi+2*ebx+1536]
	add ax,word ptr[edi+2*ecx+2048]
	add ax,word ptr[edi+2*edx+2560]
	pinsrw xmm0,eax,1
	movzx eax,word ptr[edi+2*ebx+3072]
	add ax,word ptr[edi+2*ecx+3584]
	add ax,word ptr[edi+2*edx+4096]
	pinsrw xmm0,eax,0
	movzx edx,byte ptr[esi+4]
	movzx ecx,byte ptr[esi+5]
	movzx ebx,byte ptr[esi+6] ; ebx=R/X ecx=G/Y edx=B/Z
	movzx eax,word ptr[edi+2*ebx]
	add ax,word ptr[edi+2*ecx+512]
	add ax,word ptr[edi+2*edx+1024]
	pinsrw xmm0,eax,6
	movzx eax,word ptr[edi+2*ebx+1536]
	add ax,word ptr[edi+2*ecx+2048]
	add ax,word ptr[edi+2*edx+2560]
	pinsrw xmm0,eax,5
	movzx eax,word ptr[edi+2*ebx+3072]
	add ax,word ptr[edi+2*ecx+3584]
	add ax,word ptr[edi+2*edx+4096]
	pinsrw xmm0,eax,4
	
	pxor xmm1,xmm1
	movzx edx,byte ptr[esi+8]
	movzx ecx,byte ptr[esi+9]
	movzx ebx,byte ptr[esi+10] ; ebx=R/X ecx=G/Y edx=B/Z
	movzx eax,word ptr[edi+2*ebx]
	add ax,word ptr[edi+2*ecx+512]
	add ax,word ptr[edi+2*edx+1024]
	pinsrw xmm1,eax,2
	movzx eax,word ptr[edi+2*ebx+1536]
	add ax,word ptr[edi+2*ecx+2048]
	add ax,word ptr[edi+2*edx+2560]
	pinsrw xmm1,eax,1
	movzx eax,word ptr[edi+2*ebx+3072]
	add ax,word ptr[edi+2*ecx+3584]
	add ax,word ptr[edi+2*edx+4096]
	pinsrw xmm1,eax,0
	movzx edx,byte ptr[esi+12]
	movzx ecx,byte ptr[esi+13]
	movzx ebx,byte ptr[esi+14] ; ebx=R/X ecx=G/Y edx=B/Z
	movzx eax,word ptr[edi+2*ebx]
	add ax,word ptr[edi+2*ecx+512]
	add ax,word ptr[edi+2*edx+1024]
	pinsrw xmm1,eax,6
	movzx eax,word ptr[edi+2*ebx+1536]
	add ax,word ptr[edi+2*ecx+2048]
	add ax,word ptr[edi+2*edx+2560]
	pinsrw xmm1,eax,5
	movzx eax,word ptr[edi+2*ebx+3072]
	add ax,word ptr[edi+2*ecx+3584]
	add ax,word ptr[edi+2*edx+4096]
	pinsrw xmm1,eax,4
	
	psraw xmm0,4
	psraw xmm1,4
	
	mov edi,dst
	
	packuswb xmm0,xmm1
	
	movdqa XMMWORD ptr[edi],xmm0
	
	add esi,16
	add dst,16
	
	mov edi,lookup
		
	dec i
	jnz Convert_PackedXYZ_8_SSE2_2
	
Convert_PackedXYZ_8_SSE2_3:	
	test w,3
	jz Convert_PackedXYZ_8_SSE2_5
	
	pxor xmm0,xmm0
	test w,2
	jnz short Convert_PackedXYZ_8_SSE2_4
	
	movzx edx,byte ptr[esi]
	movzx ecx,byte ptr[esi+1]
	movzx ebx,byte ptr[esi+2] ; ebx=R/X ecx=G/Y edx=B/Z
	movzx eax,word ptr[edi+2*ebx]
	add ax,word ptr[edi+2*ecx+512]
	add ax,word ptr[edi+2*edx+1024]
	pinsrw xmm0,eax,2
	movzx eax,word ptr[edi+2*ebx+1536]
	add ax,word ptr[edi+2*ecx+2048]
	add ax,word ptr[edi+2*edx+2560]
	pinsrw xmm0,eax,1
	movzx eax,word ptr[edi+2*ebx+3072]
	add ax,word ptr[edi+2*ecx+3584]
	add ax,word ptr[edi+2*edx+4096]
	pinsrw xmm0,eax,0
	
	psraw xmm0,4
	
	mov edi,dst
	
	packuswb xmm0,xmm0
	
	movd dword ptr[edi],xmm0
	
	add esi,4
	add dst,4
	
	jmp Convert_PackedXYZ_8_SSE2_5
	
Convert_PackedXYZ_8_SSE2_4:
	movzx edx,byte ptr[esi]
	movzx ecx,byte ptr[esi+1]
	movzx ebx,byte ptr[esi+2] ; ebx=R/X ecx=G/Y edx=B/Z
	movzx eax,word ptr[edi+2*ebx]
	add ax,word ptr[edi+2*ecx+512]
	add ax,word ptr[edi+2*edx+1024]
	pinsrw xmm0,eax,2
	movzx eax,word ptr[edi+2*ebx+1536]
	add ax,word ptr[edi+2*ecx+2048]
	add ax,word ptr[edi+2*edx+2560]
	pinsrw xmm0,eax,1
	movzx eax,word ptr[edi+2*ebx+3072]
	add ax,word ptr[edi+2*ecx+3584]
	add ax,word ptr[edi+2*edx+4096]
	pinsrw xmm0,eax,0
	movzx edx,byte ptr[esi+4]
	movzx ecx,byte ptr[esi+5]
	movzx ebx,byte ptr[esi+6] ; ebx=R/X ecx=G/Y edx=B/Z
	movzx eax,word ptr[edi+2*ebx]
	add ax,word ptr[edi+2*ecx+512]
	add ax,word ptr[edi+2*edx+1024]
	pinsrw xmm0,eax,6
	movzx eax,word ptr[edi+2*ebx+1536]
	add ax,word ptr[edi+2*ecx+2048]
	add ax,word ptr[edi+2*edx+2560]
	pinsrw xmm0,eax,5
	movzx eax,word ptr[edi+2*ebx+3072]
	add ax,word ptr[edi+2*ecx+3584]
	add ax,word ptr[edi+2*edx+4096]
	pinsrw xmm0,eax,4
	
	psraw xmm0,4
	
	mov edi,dst
	
	packuswb xmm0,xmm0
	
	movq qword ptr[edi],xmm0
	
	add esi,8
	add dst,8
	
	mov edi,lookup
	
	test w,1
	jz short Convert_PackedXYZ_8_SSE2_5
	
	pxor xmm0,xmm0
	movzx edx,byte ptr[esi]
	movzx ecx,byte ptr[esi+1]
	movzx ebx,byte ptr[esi+2] ; ebx=R/X ecx=G/Y edx=B/Z
	movzx eax,word ptr[edi+2*ebx]
	add ax,word ptr[edi+2*ecx+512]
	add ax,word ptr[edi+2*edx+1024]
	pinsrw xmm0,eax,2
	movzx eax,word ptr[edi+2*ebx+1536]
	add ax,word ptr[edi+2*ecx+2048]
	add ax,word ptr[edi+2*edx+2560]
	pinsrw xmm0,eax,1
	movzx eax,word ptr[edi+2*ebx+3072]
	add ax,word ptr[edi+2*ecx+3584]
	add ax,word ptr[edi+2*edx+4096]
	pinsrw xmm0,eax,0
	
	psraw xmm0,4
	
	mov edi,dst
	
	packuswb xmm0,xmm0
	
	movd dword ptr[edi],xmm0
	
	add esi,4
	add dst,4
	
Convert_PackedXYZ_8_SSE2_5:	
	mov edi,dst
	add esi,src_modulo
	add edi,dst_modulo
	mov dst,edi
	
	dec h
	jnz Convert_PackedXYZ_8_SSE2_1

	pop ebx
	pop edi
	pop esi

	ret

JPSDR_HDRTools_Convert_PackedXYZ_8_SSE2 endp


JPSDR_HDRTools_Convert_PackedXYZ_8_AVX proc src:dword,dst:dword,w:dword,h:dword,lookup:dword,
	src_modulo:dword,dst_modulo:dword

	public JPSDR_HDRTools_Convert_PackedXYZ_8_AVX

	local i,w0:dword

	push esi
	push edi
	push ebx

	mov eax,w
	shr eax,2
	mov w0,eax
	
	mov esi,src
	vpxor xmm0,xmm0,xmm0
	vpxor xmm1,xmm1,xmm1

Convert_PackedXYZ_8_AVX_1:
	mov edi,lookup
	mov eax,w0
	or eax,eax
	jz Convert_PackedXYZ_8_AVX_3
	
	mov i,eax
Convert_PackedXYZ_8_AVX_2:
	movzx edx,byte ptr[esi]
	movzx ecx,byte ptr[esi+1]
	movzx ebx,byte ptr[esi+2] ; ebx=R/X ecx=G/Y edx=B/Z
	movzx eax,word ptr[edi+2*ebx]
	add ax,word ptr[edi+2*ecx+512]
	add ax,word ptr[edi+2*edx+1024]
	vpinsrw xmm0,xmm0,eax,2
	movzx eax,word ptr[edi+2*ebx+1536]
	add ax,word ptr[edi+2*ecx+2048]
	add ax,word ptr[edi+2*edx+2560]
	vpinsrw xmm0,xmm0,eax,1
	movzx eax,word ptr[edi+2*ebx+3072]
	add ax,word ptr[edi+2*ecx+3584]
	add ax,word ptr[edi+2*edx+4096]
	vpinsrw xmm0,xmm0,eax,0
	movzx edx,byte ptr[esi+4]
	movzx ecx,byte ptr[esi+5]
	movzx ebx,byte ptr[esi+6] ; ebx=R/X ecx=G/Y edx=B/Z
	movzx eax,word ptr[edi+2*ebx]
	add ax,word ptr[edi+2*ecx+512]
	add ax,word ptr[edi+2*edx+1024]
	vpinsrw xmm0,xmm0,eax,6
	movzx eax,word ptr[edi+2*ebx+1536]
	add ax,word ptr[edi+2*ecx+2048]
	add ax,word ptr[edi+2*edx+2560]
	vpinsrw xmm0,xmm0,eax,5
	movzx eax,word ptr[edi+2*ebx+3072]
	add ax,word ptr[edi+2*ecx+3584]
	add ax,word ptr[edi+2*edx+4096]
	vpinsrw xmm0,xmm0,eax,4
	
	movzx edx,byte ptr[esi+8]
	movzx ecx,byte ptr[esi+9]
	movzx ebx,byte ptr[esi+10] ; ebx=R/X ecx=G/Y edx=B/Z
	movzx eax,word ptr[edi+2*ebx]
	add ax,word ptr[edi+2*ecx+512]
	add ax,word ptr[edi+2*edx+1024]
	vpinsrw xmm1,xmm1,eax,2
	movzx eax,word ptr[edi+2*ebx+1536]
	add ax,word ptr[edi+2*ecx+2048]
	add ax,word ptr[edi+2*edx+2560]
	vpinsrw xmm1,xmm1,eax,1
	movzx eax,word ptr[edi+2*ebx+3072]
	add ax,word ptr[edi+2*ecx+3584]
	add ax,word ptr[edi+2*edx+4096]
	vpinsrw xmm1,xmm1,eax,0
	movzx edx,byte ptr[esi+12]
	movzx ecx,byte ptr[esi+13]
	movzx ebx,byte ptr[esi+14] ; ebx=R/X ecx=G/Y edx=B/Z
	movzx eax,word ptr[edi+2*ebx]
	add ax,word ptr[edi+2*ecx+512]
	add ax,word ptr[edi+2*edx+1024]
	vpinsrw xmm1,xmm1,eax,6
	movzx eax,word ptr[edi+2*ebx+1536]
	add ax,word ptr[edi+2*ecx+2048]
	add ax,word ptr[edi+2*edx+2560]
	vpinsrw xmm1,xmm1,eax,5
	movzx eax,word ptr[edi+2*ebx+3072]
	add ax,word ptr[edi+2*ecx+3584]
	add ax,word ptr[edi+2*edx+4096]
	vpinsrw xmm1,xmm1,eax,4
	
	vpsraw xmm0,xmm0,4
	vpsraw xmm1,xmm1,4
	
	mov edi,dst
	
	vpackuswb xmm2,xmm0,xmm1
	
	vmovdqa XMMWORD ptr[edi],xmm2
	
	add esi,16
	add dst,16
	
	mov edi,lookup
	
	dec i
	jnz Convert_PackedXYZ_8_AVX_2
	
Convert_PackedXYZ_8_AVX_3:	
	test w,3
	jz Convert_PackedXYZ_8_AVX_5
	
	test w,2
	jnz short Convert_PackedXYZ_8_AVX_4
	
	movzx edx,byte ptr[esi]
	movzx ecx,byte ptr[esi+1]
	movzx ebx,byte ptr[esi+2] ; ebx=R/X ecx=G/Y edx=B/Z
	movzx eax,word ptr[edi+2*ebx]
	add ax,word ptr[edi+2*ecx+512]
	add ax,word ptr[edi+2*edx+1024]
	vpinsrw xmm0,xmm0,eax,2
	movzx eax,word ptr[edi+2*ebx+1536]
	add ax,word ptr[edi+2*ecx+2048]
	add ax,word ptr[edi+2*edx+2560]
	vpinsrw xmm0,xmm0,eax,1
	movzx eax,word ptr[edi+2*ebx+3072]
	add ax,word ptr[edi+2*ecx+3584]
	add ax,word ptr[edi+2*edx+4096]
	vpinsrw xmm0,xmm0,eax,0
	
	vpsraw xmm0,xmm0,4
	
	mov edi,dst
	
	vpackuswb xmm2,xmm0,xmm0
	
	vmovd dword ptr[edi],xmm2
	
	add esi,4
	add dst,4
	
	jmp Convert_PackedXYZ_8_AVX_5
	
Convert_PackedXYZ_8_AVX_4:
	movzx edx,byte ptr[esi]
	movzx ecx,byte ptr[esi+1]
	movzx ebx,byte ptr[esi+2] ; ebx=R/X ecx=G/Y edx=B/Z
	movzx eax,word ptr[edi+2*ebx]
	add ax,word ptr[edi+2*ecx+512]
	add ax,word ptr[edi+2*edx+1024]
	vpinsrw xmm0,xmm0,eax,2
	movzx eax,word ptr[edi+2*ebx+1536]
	add ax,word ptr[edi+2*ecx+2048]
	add ax,word ptr[edi+2*edx+2560]
	vpinsrw xmm0,xmm0,eax,1
	movzx eax,word ptr[edi+2*ebx+3072]
	add ax,word ptr[edi+2*ecx+3584]
	add ax,word ptr[edi+2*edx+4096]
	vpinsrw xmm0,xmm0,eax,0
	movzx edx,byte ptr[esi+4]
	movzx ecx,byte ptr[esi+5]
	movzx ebx,byte ptr[esi+6] ; ebx=R/X ecx=G/Y edx=B/Z
	movzx eax,word ptr[edi+2*ebx]
	add ax,word ptr[edi+2*ecx+512]
	add ax,word ptr[edi+2*edx+1024]
	vpinsrw xmm0,xmm0,eax,6
	movzx eax,word ptr[edi+2*ebx+1536]
	add ax,word ptr[edi+2*ecx+2048]
	add ax,word ptr[edi+2*edx+2560]
	vpinsrw xmm0,xmm0,eax,5
	movzx eax,word ptr[edi+2*ebx+3072]
	add ax,word ptr[edi+2*ecx+3584]
	add ax,word ptr[edi+2*edx+4096]
	vpinsrw xmm0,xmm0,eax,4
	
	vpsraw xmm0,xmm0,4
	
	mov edi,dst
	
	vpackuswb xmm2,xmm0,xmm0
	
	movq qword ptr[edi],xmm2
	
	add esi,8
	add dst,8
	
	mov edi,lookup
	
	test w,1
	jz short Convert_PackedXYZ_8_AVX_5
	
	movzx edx,byte ptr[esi]
	movzx ecx,byte ptr[esi+1]
	movzx ebx,byte ptr[esi+2] ; ebx=R/X ecx=G/Y edx=B/Z
	movzx eax,word ptr[edi+2*ebx]
	add ax,word ptr[edi+2*ecx+512]
	add ax,word ptr[edi+2*edx+1024]
	vpinsrw xmm0,xmm0,eax,2
	movzx eax,word ptr[edi+2*ebx+1536]
	add ax,word ptr[edi+2*ecx+2048]
	add ax,word ptr[edi+2*edx+2560]
	vpinsrw xmm0,xmm0,eax,1
	movzx eax,word ptr[edi+2*ebx+3072]
	add ax,word ptr[edi+2*ecx+3584]
	add ax,word ptr[edi+2*edx+4096]
	vpinsrw xmm0,xmm0,eax,0
	
	vpsraw xmm0,xmm0,4
	
	mov edi,dst
	
	vpackuswb xmm2,xmm0,xmm0
	
	vmovd dword ptr[edi],xmm2
	
	add esi,4
	add dst,4
	
Convert_PackedXYZ_8_AVX_5:	
	mov edi,dst
	add esi,src_modulo
	add edi,dst_modulo
	mov dst,edi
	
	dec h
	jnz Convert_PackedXYZ_8_AVX_1

	pop ebx
	pop edi
	pop esi

	ret

JPSDR_HDRTools_Convert_PackedXYZ_8_AVX endp


JPSDR_HDRTools_Convert_PackedXYZ_16_SSE41 proc src:dword,dst:dword,w:dword,h:dword,lookup:dword,
	src_modulo:dword,dst_modulo:dword

	public JPSDR_HDRTools_Convert_PackedXYZ_16_SSE41

	local i,w0:dword

	push esi
	push edi
	push ebx

	mov eax,w
	shr eax,1
	mov w0,eax
	
	mov esi,src

Convert_PackedXYZ_16_SSE41_1:
	mov edi,lookup
	mov eax,w0
	or eax,eax
	jz Convert_PackedXYZ_16_SSE41_3
	
	mov i,eax
Convert_PackedXYZ_16_SSE41_2:
	pxor xmm0,xmm0
	movzx edx,word ptr[esi]
	movzx ecx,word ptr[esi+2]
	movzx ebx,word ptr[esi+4] ; ebx=R/X ecx=G/Y edx=B/Z
	mov eax,dword ptr[edi+4*ebx]
	add eax,dword ptr[edi+4*ecx+262144]
	add eax,dword ptr[edi+4*edx+524288]
	pinsrd xmm0,eax,2
	mov eax,dword ptr[edi+4*ebx+786432]
	add eax,dword ptr[edi+4*ecx+1048576]
	add eax,dword ptr[edi+4*edx+1310720]
	pinsrd xmm0,eax,1
	mov eax,dword ptr[edi+4*ebx+1572864]
	add eax,dword ptr[edi+4*ecx+1835008]
	add eax,dword ptr[edi+4*edx+2097152]
	pinsrd xmm0,eax,0

	pxor xmm1,xmm1
	movzx edx,word ptr[esi+8]
	movzx ecx,word ptr[esi+10]
	movzx ebx,word ptr[esi+12] ; ebx=R/X ecx=G/Y edx=B/Z
	mov eax,dword ptr[edi+4*ebx]
	add eax,dword ptr[edi+4*ecx+262144]
	add eax,dword ptr[edi+4*edx+524288]
	pinsrd xmm1,eax,2
	mov eax,dword ptr[edi+4*ebx+786432]
	add eax,dword ptr[edi+4*ecx+1048576]
	add eax,dword ptr[edi+4*edx+1310720]
	pinsrd xmm1,eax,1
	mov eax,dword ptr[edi+4*ebx+1572864]
	add eax,dword ptr[edi+4*ecx+1835008]
	add eax,dword ptr[edi+4*edx+2097152]
	pinsrd xmm1,eax,0
	
	psrad xmm0,8
	psrad xmm1,8
	
	mov edi,dst
	
	packusdw xmm0,xmm1
	
	movdqa XMMWORD ptr[edi],xmm0
	
	add esi,16
	add dst,16
	
	mov edi,lookup
	
	dec i
	jnz Convert_PackedXYZ_16_SSE41_2
	
Convert_PackedXYZ_16_SSE41_3:	
	test w,1
	jz short Convert_PackedXYZ_16_SSE41_4
	
	pxor xmm0,xmm0
	movzx edx,word ptr[esi]
	movzx ecx,word ptr[esi+2]
	movzx ebx,word ptr[esi+4] ; ebx=R/X ecx=G/Y edx=B/Z
	mov eax,dword ptr[edi+4*ebx]
	add eax,dword ptr[edi+4*ecx+262144]
	add eax,dword ptr[edi+4*edx+524288]
	pinsrd xmm0,eax,2
	mov eax,dword ptr[edi+4*ebx+786432]
	add eax,dword ptr[edi+4*ecx+1048576]
	add eax,dword ptr[edi+4*edx+1310720]
	pinsrd xmm0,eax,1
	mov eax,dword ptr[edi+4*ebx+1572864]
	add eax,dword ptr[edi+4*ecx+1835008]
	add eax,dword ptr[edi+4*edx+2097152]
	pinsrd xmm0,eax,0
	
	psrad xmm0,8
	
	mov edi,dst
	
	packusdw xmm0,xmm0
	
	movq qword ptr[edi],xmm0
	
	add esi,8
	add dst,8
	
Convert_PackedXYZ_16_SSE41_4:	
	mov edi,dst
	add esi,src_modulo
	add edi,dst_modulo
	mov dst,edi
	
	dec h
	jnz Convert_PackedXYZ_16_SSE41_1

	pop ebx
	pop edi
	pop esi

	ret

JPSDR_HDRTools_Convert_PackedXYZ_16_SSE41 endp


JPSDR_HDRTools_Convert_PackedXYZ_16_AVX proc src:dword,dst:dword,w:dword,h:dword,lookup:dword,
	src_modulo:dword,dst_modulo:dword

	public JPSDR_HDRTools_Convert_PackedXYZ_16_AVX

	local i,w0:dword

	push esi
	push edi
	push ebx

	mov eax,w
	shr eax,1
	mov w0,eax
	
	vpxor xmm0,xmm0,xmm0
	vpxor xmm1,xmm1,xmm1
	
	mov esi,src

Convert_PackedXYZ_16_AVX_1:
	mov edi,lookup
	mov eax,w0
	or eax,eax
	jz Convert_PackedXYZ_16_AVX_3
	
	mov i,eax
Convert_PackedXYZ_16_AVX_2:
	movzx edx,word ptr[esi]
	movzx ecx,word ptr[esi+2]
	movzx ebx,word ptr[esi+4] ; ebx=R/X ecx=G/Y edx=B/Z
	mov eax,dword ptr[edi+4*ebx]
	add eax,dword ptr[edi+4*ecx+262144]
	add eax,dword ptr[edi+4*edx+524288]
	vpinsrd xmm0,xmm0,eax,2
	mov eax,dword ptr[edi+4*ebx+786432]
	add eax,dword ptr[edi+4*ecx+1048576]
	add eax,dword ptr[edi+4*edx+1310720]
	vpinsrd xmm0,xmm0,eax,1
	mov eax,dword ptr[edi+4*ebx+1572864]
	add eax,dword ptr[edi+4*ecx+1835008]
	add eax,dword ptr[edi+4*edx+2097152]
	vpinsrd xmm0,xmm0,eax,0

	movzx edx,word ptr[esi+8]
	movzx ecx,word ptr[esi+10]
	movzx ebx,word ptr[esi+12] ; ebx=R/X ecx=G/Y edx=B/Z
	mov eax,dword ptr[edi+4*ebx]
	add eax,dword ptr[edi+4*ecx+262144]
	add eax,dword ptr[edi+4*edx+524288]
	vpinsrd xmm1,xmm1,eax,2
	mov eax,dword ptr[edi+4*ebx+786432]
	add eax,dword ptr[edi+4*ecx+1048576]
	add eax,dword ptr[edi+4*edx+1310720]
	vpinsrd xmm1,xmm1,eax,1
	mov eax,dword ptr[edi+4*ebx+1572864]
	add eax,dword ptr[edi+4*ecx+1835008]
	add eax,dword ptr[edi+4*edx+2097152]
	vpinsrd xmm1,xmm1,eax,0
	
	vpsrad xmm0,xmm0,8
	vpsrad xmm1,xmm1,8
	
	mov edi,dst
	
	vpackusdw xmm2,xmm0,xmm1
	
	vmovdqa XMMWORD ptr[edi],xmm2
	
	add esi,16
	add dst,16
	
	mov edi,lookup
	
	dec i
	jnz Convert_PackedXYZ_16_AVX_2
	
Convert_PackedXYZ_16_AVX_3:	
	test w,1
	jz short Convert_PackedXYZ_16_AVX_4
	
	movzx edx,word ptr[esi]
	movzx ecx,word ptr[esi+2]
	movzx ebx,word ptr[esi+4] ; ebx=R/X ecx=G/Y edx=B/Z
	mov eax,dword ptr[edi+4*ebx]
	add eax,dword ptr[edi+4*ecx+262144]
	add eax,dword ptr[edi+4*edx+524288]
	vpinsrd xmm0,xmm0,eax,2
	mov eax,dword ptr[edi+4*ebx+786432]
	add eax,dword ptr[edi+4*ecx+1048576]
	add eax,dword ptr[edi+4*edx+1310720]
	vpinsrd xmm0,xmm0,eax,1
	mov eax,dword ptr[edi+4*ebx+1572864]
	add eax,dword ptr[edi+4*ecx+1835008]
	add eax,dword ptr[edi+4*edx+2097152]
	vpinsrd xmm0,xmm0,eax,0
	
	vpsrad xmm0,xmm0,8
	
	mov edi,dst
	
	vpackusdw xmm2,xmm0,xmm0
	
	vmovq qword ptr[edi],xmm2
	
	add esi,8
	add dst,8
	
Convert_PackedXYZ_16_AVX_4:	
	mov edi,dst
	add esi,src_modulo
	add edi,dst_modulo
	mov dst,edi
	
	dec h
	jnz Convert_PackedXYZ_16_AVX_1

	pop ebx
	pop edi
	pop esi

	ret

JPSDR_HDRTools_Convert_PackedXYZ_16_AVX endp


JPSDR_HDRTools_Convert_PlanarRGBtoXYZ_32_SSE2 proc src1:dword,src2:dword,src3:dword,dst1:dword,dst2:dword,dst3:dword,
	w:dword,h:dword,Coeff:dword,src_modulo1:dword,src_modulo2:dword,src_modulo3:dword,
	dst_modulo1:dword,dst_modulo2:dword,dst_modulo3:dword

	public JPSDR_HDRTools_Convert_PlanarRGBtoXYZ_32_SSE2

	push esi
	push edi
	push ebx
	
	mov esi,Coeff
	movaps xmm0,XMMWORD ptr[esi]
	movaps xmm1,XMMWORD ptr[esi+32]
	movaps xmm2,XMMWORD ptr[esi+64]
	mov eax,src3
	mov edi,dst1
	mov ebx,dst2
	mov edx,dst3
	
Convert_PlanarRGBtoXYZ_32_SSE2_1:
	mov ecx,w
	mov esi,src1
Convert_PlanarRGBtoXYZ_32_SSE2_2:
	add src1,4
	movss xmm3,dword ptr[esi]
	mov esi,src2
	add src2,4
	movss xmm4,dword ptr[esi]
	movss xmm5,dword ptr[eax]
	
	shufps xmm3,xmm3,0
	shufps xmm4,xmm4,0
	shufps xmm5,xmm5,0
	
	mulps xmm3,xmm0
	mulps xmm4,xmm1
	mulps xmm5,xmm2
	
	addps xmm3,xmm4
	add eax,4
	addps xmm3,xmm5
	mov esi,src1
	movhlps xmm4,xmm3
	
	movss dword ptr[edi],xmm3
	shufps xmm3,xmm3,1
	movss dword ptr[edx],xmm4
	movss dword ptr[ebx],xmm3
	
	add edi,4
	add edx,4
	add ebx,4
	
	loop Convert_PlanarRGBtoXYZ_32_SSE2_2

	add esi,src_modulo1
	mov src1,esi
	add eax,src_modulo3
	mov esi,src2
	add esi,src_modulo2
	mov src2,esi
	
	add edi,dst_modulo1
	add ebx,dst_modulo2
	add edx,dst_modulo3
	
	dec h
	jnz short Convert_PlanarRGBtoXYZ_32_SSE2_1
	
	pop ebx
	pop edi
	pop esi

	ret

JPSDR_HDRTools_Convert_PlanarRGBtoXYZ_32_SSE2 endp


JPSDR_HDRTools_Convert_PlanarXYZtoRGB_32_SSE2 proc src1:dword,src2:dword,src3:dword,dst1:dword,dst2:dword,dst3:dword,
	w:dword,h:dword,Coeff:dword,src_modulo1:dword,src_modulo2:dword,src_modulo3:dword,
	dst_modulo1:dword,dst_modulo2:dword,dst_modulo3:dword

	public JPSDR_HDRTools_Convert_PlanarXYZtoRGB_32_SSE2

	push esi
	push edi
	push ebx
	
	mov esi,Coeff
	movaps xmm0,XMMWORD ptr[esi]
	movaps xmm1,XMMWORD ptr[esi+32]
	movaps xmm2,XMMWORD ptr[esi+64]
	movaps xmm6,XMMWORD ptr data_f_0
	movaps xmm7,XMMWORD ptr data_f_1
	mov eax,src3
	mov edi,dst1
	mov ebx,dst2
	mov edx,dst3
	
Convert_PlanarXYZtoRGB_32_SSE2_1:
	mov ecx,w
	mov esi,src1
Convert_PlanarXYZtoRGB_32_SSE2_2:
	add src1,4
	movss xmm3,dword ptr[esi]
	mov esi,src2
	add src2,4
	movss xmm4,dword ptr[esi]
	movss xmm5,dword ptr[eax]
	
	shufps xmm3,xmm3,0
	shufps xmm4,xmm4,0
	shufps xmm5,xmm5,0
	
	mulps xmm3,xmm0
	mulps xmm4,xmm1
	mulps xmm5,xmm2
	
	addps xmm3,xmm4
	add eax,4
	addps xmm3,xmm5
	maxps xmm3,xmm6
	minps xmm3,xmm7
	mov esi,src1
	movhlps xmm4,xmm3
	
	movss dword ptr[edi],xmm3
	shufps xmm3,xmm3,1
	movss dword ptr[edx],xmm4
	movss dword ptr[ebx],xmm3
	
	add edi,4
	add edx,4
	add ebx,4
	
	loop Convert_PlanarXYZtoRGB_32_SSE2_2

	add esi,src_modulo1
	mov src1,esi
	add eax,src_modulo3
	mov esi,src2
	add esi,src_modulo2
	mov src2,esi
	
	add edi,dst_modulo1
	add ebx,dst_modulo2
	add edx,dst_modulo3
	
	dec h
	jnz Convert_PlanarXYZtoRGB_32_SSE2_1
	
	pop ebx
	pop edi
	pop esi

	ret

JPSDR_HDRTools_Convert_PlanarXYZtoRGB_32_SSE2 endp


JPSDR_HDRTools_Convert_PlanarRGBtoXYZ_32_AVX proc src1:dword,src2:dword,src3:dword,dst1:dword,dst2:dword,dst3:dword,
	w:dword,h:dword,Coeff:dword,src_modulo1:dword,src_modulo2:dword,src_modulo3:dword,
	dst_modulo1:dword,dst_modulo2:dword,dst_modulo3:dword

	public JPSDR_HDRTools_Convert_PlanarRGBtoXYZ_32_AVX

	local w0:dword
	
	push esi
	push edi
	push ebx

	mov eax,w
	shr eax,1
	mov w0,eax
	
	mov esi,Coeff
	vmovaps ymm0,YMMWORD ptr[esi]
	vmovaps ymm1,YMMWORD ptr[esi+32]
	vmovaps ymm2,YMMWORD ptr[esi+64]	
	mov eax,src3
	mov edi,dst1
	mov ebx,dst2
	mov edx,dst3

Convert_PlanarRGBtoXYZ_32_AVX_1:
	mov ecx,w0
	or ecx,ecx
	jz Convert_PlanarRGBtoXYZ_32_AVX_3
	
	mov esi,src1
Convert_PlanarRGBtoXYZ_32_AVX_2:
	vmovss xmm3,dword ptr[esi]
	vmovss xmm6,dword ptr[esi+4]
	add src1,8
	vinsertf128 ymm3,ymm3,xmm6,1
	mov esi,src2
	vmovss xmm4,dword ptr[esi]
	vmovss xmm6,dword ptr[esi+4]
	add src2,8
	vinsertf128 ymm4,ymm4,xmm6,1
	vmovss xmm5,dword ptr[eax]
	vmovss xmm6,dword ptr[eax+4]
	add eax,8
	vinsertf128 ymm5,ymm5,xmm6,1
	
	vshufps ymm3,ymm3,ymm3,0
	vshufps ymm4,ymm4,ymm4,0
	vshufps ymm5,ymm5,ymm5,0
	
	vmulps ymm3,ymm3,ymm0
	vmulps ymm4,ymm4,ymm1
	vmulps ymm5,ymm5,ymm2
	
	vaddps ymm3,ymm3,ymm4
	mov esi,src1
	vaddps ymm3,ymm3,ymm5
	vextractf128 xmm6,ymm3,1
	
	vmovhlps xmm4,xmm4,xmm3
	vmovss dword ptr[edi],xmm3
	vshufps xmm3,xmm3,xmm3,1
	vmovss dword ptr[edx],xmm4
	vmovss dword ptr[ebx],xmm3

	vmovhlps xmm4,xmm4,xmm6
	vmovss dword ptr[edi+4],xmm6
	vshufps xmm6,xmm6,xmm6,1
	vmovss dword ptr[edx+4],xmm4
	vmovss dword ptr[ebx+4],xmm6
	
	add edi,8
	add edx,8
	add ebx,8
	
	dec ecx
	jnz Convert_PlanarRGBtoXYZ_32_AVX_2

Convert_PlanarRGBtoXYZ_32_AVX_3:
	test w,1
	jz short Convert_PlanarRGBtoXYZ_32_AVX_4
	
	add src1,4
	vmovss xmm3,dword ptr[esi]
	mov esi,src2
	add src2,4
	vmovss xmm4,dword ptr[esi]
	vmovss xmm5,dword ptr[eax]
	
	vshufps xmm3,xmm3,xmm3,0
	vshufps xmm4,xmm4,xmm4,0
	vshufps xmm5,xmm5,xmm5,0
	
	vmulps xmm3,xmm3,xmm0
	vmulps xmm4,xmm4,xmm1
	vmulps xmm5,xmm5,xmm2
	
	vaddps xmm3,xmm3,xmm4
	add eax,4
	vaddps xmm3,xmm3,xmm5	
	mov esi,src1
	vmovhlps xmm4,xmm4,xmm3
	
	vmovss dword ptr[edi],xmm3
	vshufps xmm3,xmm3,xmm3,1
	vmovss dword ptr[edx],xmm4
	vmovss dword ptr[ebx],xmm3
	
	add edi,4
	add edx,4
	add ebx,4

Convert_PlanarRGBtoXYZ_32_AVX_4:	
	add esi,src_modulo1
	mov src1,esi
	add eax,src_modulo3
	mov esi,src2
	add esi,src_modulo2
	mov src2,esi
	
	add edi,dst_modulo1
	add ebx,dst_modulo2
	add edx,dst_modulo3
	
	dec h
	jnz Convert_PlanarRGBtoXYZ_32_AVX_1
	
	vzeroupper
	
	pop ebx
	pop edi
	pop esi

	ret

JPSDR_HDRTools_Convert_PlanarRGBtoXYZ_32_AVX endp


JPSDR_HDRTools_Convert_PlanarXYZtoRGB_32_AVX proc src1:dword,src2:dword,src3:dword,dst1:dword,dst2:dword,dst3:dword,
	w:dword,h:dword,Coeff:dword,src_modulo1:dword,src_modulo2:dword,src_modulo3:dword,
	dst_modulo1:dword,dst_modulo2:dword,dst_modulo3:dword

	public JPSDR_HDRTools_Convert_PlanarXYZtoRGB_32_AVX

	local w0:dword
	
	push esi
	push edi
	push ebx

	mov eax,w
	shr eax,1
	mov w0,eax
	
	mov esi,Coeff
	vmovaps ymm0,YMMWORD ptr[esi]
	vmovaps ymm1,YMMWORD ptr[esi+32]
	vmovaps ymm2,YMMWORD ptr[esi+64]
	vmovaps ymm7,YMMWORD ptr data_f_1
	mov eax,src3
	mov edi,dst1
	mov ebx,dst2
	mov edx,dst3

Convert_PlanarXYZtoRGB_32_AVX_1:
	mov ecx,w0
	or ecx,ecx
	jz Convert_PlanarXYZtoRGB_32_AVX_3
	
	mov esi,src1
Convert_PlanarXYZtoRGB_32_AVX_2:
	vmovss xmm3,dword ptr[esi]
	vmovss xmm6,dword ptr[esi+4]
	add src1,8
	vinsertf128 ymm3,ymm3,xmm6,1
	mov esi,src2
	vmovss xmm4,dword ptr[esi]
	vmovss xmm6,dword ptr[esi+4]
	add src2,8
	vinsertf128 ymm4,ymm4,xmm6,1
	vmovss xmm5,dword ptr[eax]
	vmovss xmm6,dword ptr[eax+4]
	add eax,8
	vinsertf128 ymm5,ymm5,xmm6,1
	
	vshufps ymm3,ymm3,ymm3,0
	vshufps ymm4,ymm4,ymm4,0
	vshufps ymm5,ymm5,ymm5,0
	
	vmulps ymm3,ymm3,ymm0
	vmulps ymm4,ymm4,ymm1
	vmulps ymm5,ymm5,ymm2
	
	vaddps ymm3,ymm3,ymm4
	mov esi,src1
	vaddps ymm3,ymm3,ymm5
	vmaxps ymm3,ymm3,YMMWORD ptr data_f_0
	vminps ymm3,ymm3,ymm7
	vextractf128 xmm6,ymm3,1
	
	vmovhlps xmm4,xmm4,xmm3
	vmovss dword ptr[edi],xmm3
	vshufps xmm3,xmm3,xmm3,1
	vmovss dword ptr[edx],xmm4
	vmovss dword ptr[ebx],xmm3

	vmovhlps xmm4,xmm4,xmm6
	vmovss dword ptr[edi+4],xmm6
	vshufps xmm6,xmm6,xmm6,1
	vmovss dword ptr[edx+4],xmm4
	vmovss dword ptr[ebx+4],xmm6
	
	add edi,8
	add edx,8
	add ebx,8
	
	dec ecx
	jnz Convert_PlanarXYZtoRGB_32_AVX_2

Convert_PlanarXYZtoRGB_32_AVX_3:
	test w,1
	jz short Convert_PlanarXYZtoRGB_32_AVX_4
	
	add src1,4
	vmovss xmm3,dword ptr[esi]
	mov esi,src2
	add src2,4
	vmovss xmm4,dword ptr[esi]
	vmovss xmm5,dword ptr[eax]
	
	vshufps xmm3,xmm3,xmm3,0
	vshufps xmm4,xmm4,xmm4,0
	vshufps xmm5,xmm5,xmm5,0
	
	vmulps xmm3,xmm3,xmm0
	vmulps xmm4,xmm4,xmm1
	vmulps xmm5,xmm5,xmm2
	
	vaddps xmm3,xmm3,xmm4
	add eax,4
	vaddps xmm3,xmm3,xmm5	
	vmaxps xmm3,xmm3,XMMWORD ptr data_f_0
	vminps xmm3,xmm3,xmm7	
	mov esi,src1
	vmovhlps xmm4,xmm4,xmm3
	
	vmovss dword ptr[edi],xmm3
	vshufps xmm3,xmm3,xmm3,1
	vmovss dword ptr[edx],xmm4
	vmovss dword ptr[ebx],xmm3
	
	add edi,4
	add edx,4
	add ebx,4

Convert_PlanarXYZtoRGB_32_AVX_4:	
	add esi,src_modulo1
	mov src1,esi
	add eax,src_modulo3
	mov esi,src2
	add esi,src_modulo2
	mov src2,esi
	
	add edi,dst_modulo1
	add ebx,dst_modulo2
	add edx,dst_modulo3
	
	dec h
	jnz Convert_PlanarXYZtoRGB_32_AVX_1
	
	vzeroupper
	
	pop ebx
	pop edi
	pop esi

	ret

JPSDR_HDRTools_Convert_PlanarXYZtoRGB_32_AVX endp


;***************************************************
;**               HLG functions                   **
;***************************************************


JPSDR_HDRTools_Convert_RGB64toRGB32_SSE2 proc src:dword,dst:dword,w:dword,h:dword,src_pitch:dword,dst_pitch:dword

	public JPSDR_HDRTools_Convert_RGB64toRGB32_SSE2
	
	push esi
	push edi
	push ebx

	mov ebx,w
	shr ebx,2
	
	movdqa xmm2,XMMWORD ptr data_w_128
	movdqa xmm3,XMMWORD ptr data_dw_RGB32
	
	mov esi,src
	mov edi,dst
	mov edx,16
	
Convert_RGB64toRGB32_SSE2_1:
	mov ecx,ebx
	or ecx,ecx
	jz short Convert_RGB64toRGB32_SSE2_3
	
	xor eax,eax	
Convert_RGB64toRGB32_SSE2_2:
	movdqa xmm0,XMMWORD ptr[esi+2*eax]
	movdqa xmm1,XMMWORD ptr[esi+2*eax+16]
	paddusw xmm0,xmm2
	paddusw xmm1,xmm2
	psrlw xmm0,8
	psrlw xmm1,8
	packuswb xmm0,xmm1
	pand xmm0,xmm3
	movdqa XMMWORD ptr[edi+eax],xmm0
	add eax,edx
	loop Convert_RGB64toRGB32_SSE2_2
	
Convert_RGB64toRGB32_SSE2_3:
	test w,2
	jz short Convert_RGB64toRGB32_SSE2_4
	
	movdqa xmm0,XMMWORD ptr[esi+2*eax]
	paddusw xmm0,xmm2
	psrlw xmm0,8
	packuswb xmm0,xmm0
	pand xmm0,xmm3
	movq qword ptr[edi+eax],xmm0
	add eax,8
	
Convert_RGB64toRGB32_SSE2_4:
	test w,1
	jz short Convert_RGB64toRGB32_SSE2_5

	movq xmm0,qword ptr[esi+2*eax]
	paddusw xmm0,xmm2
	psrlw xmm0,8
	packuswb xmm0,xmm0
	pand xmm0,xmm3
	movd dword ptr[edi+eax],xmm0
	
Convert_RGB64toRGB32_SSE2_5:
	add esi,src_pitch
	add edi,dst_pitch
	dec h
	jnz Convert_RGB64toRGB32_SSE2_1
	
	pop ebx
	pop edi
	pop esi

	ret

JPSDR_HDRTools_Convert_RGB64toRGB32_SSE2 endp
	
	
JPSDR_HDRTools_Convert_RGB64toRGB32_AVX proc src:dword,dst:dword,w:dword,h:dword,src_pitch:dword,dst_pitch:dword

	public JPSDR_HDRTools_Convert_RGB64toRGB32_AVX
	
	push esi
	push edi
	push ebx

	mov ebx,w
	shr ebx,2
	
	vmovdqa xmm2,XMMWORD ptr data_w_128
	vmovdqa xmm3,XMMWORD ptr data_dw_RGB32
	
	mov esi,src
	mov edi,dst
	mov edx,16
	
Convert_RGB64toRGB32_AVX_1:
	mov ecx,ebx
	or ecx,ecx
	jz short Convert_RGB64toRGB32_AVX_3
	
	xor eax,eax	
Convert_RGB64toRGB32_AVX_2:
	vpaddusw xmm0,xmm2,XMMWORD ptr[esi+2*eax]
	vpaddusw xmm1,xmm2,XMMWORD ptr[esi+2*eax+16]
	vpsrlw xmm0,xmm0,8
	vpsrlw xmm1,xmm1,8
	vpackuswb xmm0,xmm0,xmm1
	vpand xmm0,xmm0,xmm3
	vmovdqa XMMWORD ptr[edi+eax],xmm0
	add eax,edx
	loop Convert_RGB64toRGB32_AVX_2
	
Convert_RGB64toRGB32_AVX_3:
	test w,2
	jz short Convert_RGB64toRGB32_AVX_4
	
	vpaddusw xmm0,xmm2,XMMWORD ptr[esi+2*eax]
	vpsrlw xmm0,xmm0,8
	vpackuswb xmm0,xmm0,xmm0
	vpand xmm0,xmm0,xmm3
	vmovq qword ptr[edi+eax],xmm0
	add eax,8
	
Convert_RGB64toRGB32_AVX_4:
	test w,1
	jz short Convert_RGB64toRGB32_AVX_5

	vmovq xmm0,qword ptr[esi+2*eax]
	vpaddusw xmm0,xmm0,xmm2
	vpsrlw xmm0,xmm0,8
	vpackuswb xmm0,xmm0,xmm0
	vpand xmm0,xmm0,xmm3
	vmovd dword ptr[edi+eax],xmm0
	
Convert_RGB64toRGB32_AVX_5:
	add esi,src_pitch
	add edi,dst_pitch
	dec h
	jnz short Convert_RGB64toRGB32_AVX_1
	
	pop ebx
	pop edi
	pop esi

	ret

JPSDR_HDRTools_Convert_RGB64toRGB32_AVX endp
	

JPSDR_HDRTools_Convert_RGB32toPlaneY16_SSE2 proc src:dword,dst:dword,w:dword,h:dword,
	lookup:dword,src_modulo:dword,dst_modulo:dword

	public JPSDR_HDRTools_Convert_RGB32toPlaneY16_SSE2

	local i,w0:dword

	push esi
	push edi
	push ebx

	pxor xmm1,xmm1
	pxor xmm0,xmm0

	mov eax,w
	shr eax,3
	mov w0,eax
	
	mov esi,src

Convert_RGB32toPlaneY16_SSE2_1:
	mov edi,lookup
	
	mov eax,w0
	or eax,eax
	jz Convert_RGB32toPlaneY16_SSE2_3
	
	mov i,eax
Convert_RGB32toPlaneY16_SSE2_2:
	movzx edx,byte ptr[esi]
	movzx ecx,byte ptr[esi+1]
	movzx ebx,byte ptr[esi+2] ; ebx=R ecx=G edx=B
	movzx eax,word ptr[edi+2*ebx]
	add ax,word ptr[edi+2*ecx+512]
	add ax,word ptr[edi+2*edx+1024]
	pinsrw xmm0,eax,0
	movzx edx,byte ptr[esi+4]
	movzx ecx,byte ptr[esi+5]
	movzx ebx,byte ptr[esi+6] ; ebx=R ecx=G edx=B
	movzx eax,word ptr[edi+2*ebx]
	add ax,word ptr[edi+2*ecx+512]
	add ax,word ptr[edi+2*edx+1024]
	pinsrw xmm0,eax,1
	movzx edx,byte ptr[esi+8]
	movzx ecx,byte ptr[esi+9]
	movzx ebx,byte ptr[esi+10] ; ebx=R ecx=G edx=B
	movzx eax,word ptr[edi+2*ebx]
	add ax,word ptr[edi+2*ecx+512]
	add ax,word ptr[edi+2*edx+1024]
	pinsrw xmm0,eax,2
	movzx edx,byte ptr[esi+12]
	movzx ecx,byte ptr[esi+13]
	movzx ebx,byte ptr[esi+14] ; ebx=R ecx=G edx=B
	movzx eax,word ptr[edi+2*ebx]
	add ax,word ptr[edi+2*ecx+512]
	add ax,word ptr[edi+2*edx+1024]
	pinsrw xmm0,eax,3
	movzx edx,byte ptr[esi+16]
	movzx ecx,byte ptr[esi+17]
	movzx ebx,byte ptr[esi+18] ; ebx=R ecx=G edx=B
	movzx eax,word ptr[edi+2*ebx]
	add ax,word ptr[edi+2*ecx+512]
	add ax,word ptr[edi+2*edx+1024]
	pinsrw xmm0,eax,4
	movzx edx,byte ptr[esi+20]
	movzx ecx,byte ptr[esi+21]
	movzx ebx,byte ptr[esi+22] ; ebx=R ecx=G edx=B
	movzx eax,word ptr[edi+2*ebx]
	add ax,word ptr[edi+2*ecx+512]
	add ax,word ptr[edi+2*edx+1024]
	pinsrw xmm0,eax,5
	movzx edx,byte ptr[esi+24]
	movzx ecx,byte ptr[esi+25]
	movzx ebx,byte ptr[esi+26] ; ebx=R ecx=G edx=B
	movzx eax,word ptr[edi+2*ebx]
	add ax,word ptr[edi+2*ecx+512]
	add ax,word ptr[edi+2*edx+1024]
	pinsrw xmm0,eax,6
	movzx edx,byte ptr[esi+28]
	movzx ecx,byte ptr[esi+29]
	movzx ebx,byte ptr[esi+30] ; ebx=R ecx=G edx=B
	movzx eax,word ptr[edi+2*ebx]
	add ax,word ptr[edi+2*ecx+512]
	add ax,word ptr[edi+2*edx+1024]
	mov edi,dst
	pinsrw xmm0,eax,7
	
	psraw xmm0,6
	movdqa xmm2,xmm1
	packuswb xmm0,xmm1
	punpcklbw xmm2,xmm0
	
	movdqa XMMWORD ptr[edi],xmm2
	
	add dst,16
	add esi,32
	
	mov edi,lookup
	
	dec i
	jnz Convert_RGB32toPlaneY16_SSE2_2
	
Convert_RGB32toPlaneY16_SSE2_3:	
	test w,4
	jz Convert_RGB32toPlaneY16_SSE2_4
	
	movzx edx,byte ptr[esi]
	movzx ecx,byte ptr[esi+1]
	movzx ebx,byte ptr[esi+2] ; ebx=R ecx=G edx=B
	movzx eax,word ptr[edi+2*ebx]
	add ax,word ptr[edi+2*ecx+512]
	add ax,word ptr[edi+2*edx+1024]
	pinsrw xmm0,eax,0
	movzx edx,byte ptr[esi+4]
	movzx ecx,byte ptr[esi+5]
	movzx ebx,byte ptr[esi+6] ; ebx=R ecx=G edx=B
	movzx eax,word ptr[edi+2*ebx]
	add ax,word ptr[edi+2*ecx+512]
	add ax,word ptr[edi+2*edx+1024]
	pinsrw xmm0,eax,1
	movzx edx,byte ptr[esi+8]
	movzx ecx,byte ptr[esi+9]
	movzx ebx,byte ptr[esi+10] ; ebx=R ecx=G edx=B
	movzx eax,word ptr[edi+2*ebx]
	add ax,word ptr[edi+2*ecx+512]
	add ax,word ptr[edi+2*edx+1024]
	pinsrw xmm0,eax,2
	movzx edx,byte ptr[esi+12]
	movzx ecx,byte ptr[esi+13]
	movzx ebx,byte ptr[esi+14] ; ebx=R ecx=G edx=B
	movzx eax,word ptr[edi+2*ebx]
	add ax,word ptr[edi+2*ecx+512]
	add ax,word ptr[edi+2*edx+1024]
	mov edi,dst
	pinsrw xmm0,eax,3	
	
	psraw xmm0,6
	movdqa xmm2,xmm1
	packuswb xmm0,xmm1
	punpcklbw xmm2,xmm0
	
	movq qword ptr[edi],xmm2

	add dst,8
	add esi,16
	
	mov edi,lookup
	
Convert_RGB32toPlaneY16_SSE2_4:
	test w,2
	jz short Convert_RGB32toPlaneY16_SSE2_5

	movzx edx,byte ptr[esi]
	movzx ecx,byte ptr[esi+1]
	movzx ebx,byte ptr[esi+2] ; ebx=R ecx=G edx=B
	movzx eax,word ptr[edi+2*ebx]
	add ax,word ptr[edi+2*ecx+512]
	add ax,word ptr[edi+2*edx+1024]
	pinsrw xmm0,eax,0
	movzx edx,byte ptr[esi+4]
	movzx ecx,byte ptr[esi+5]
	movzx ebx,byte ptr[esi+6] ; ebx=R ecx=G edx=B
	movzx eax,word ptr[edi+2*ebx]
	add ax,word ptr[edi+2*ecx+512]
	add ax,word ptr[edi+2*edx+1024]
	mov edi,dst
	pinsrw xmm0,eax,1
	
	psraw xmm0,6
	movdqa xmm2,xmm1
	packuswb xmm0,xmm1
	punpcklbw xmm2,xmm0
	
	movd dword ptr[edi],xmm2

	add dst,4
	add esi,8
	
	mov edi,lookup
	
Convert_RGB32toPlaneY16_SSE2_5:
	test w,1
	jz short Convert_RGB32toPlaneY16_SSE2_6

	movzx edx,byte ptr[esi]
	movzx ecx,byte ptr[esi+1]
	movzx ebx,byte ptr[esi+2] ; ebx=R ecx=G edx=B
	movzx eax,word ptr[edi+2*ebx]
	add ax,word ptr[edi+2*ecx+512]
	add ax,word ptr[edi+2*edx+1024]
	mov edi,dst
	pinsrw xmm0,eax,0
	
	psraw xmm0,6
	movdqa xmm2,xmm1
	packuswb xmm0,xmm1
	punpcklbw xmm2,xmm0
	
	pextrw eax,xmm2,0

	mov word ptr[edi],ax

	add dst,2
	add esi,4
	
Convert_RGB32toPlaneY16_SSE2_6:	
	mov edi,dst
	add esi,src_modulo
	add edi,dst_modulo
	mov dst,edi
	dec h
	jnz Convert_RGB32toPlaneY16_SSE2_1

	pop ebx
	pop edi
	pop esi

	ret

JPSDR_HDRTools_Convert_RGB32toPlaneY16_SSE2 endp


JPSDR_HDRTools_Convert_RGB32toPlaneY16_AVX proc src:dword,dst:dword,w:dword,h:dword,
	lookup:dword,src_modulo:dword,dst_modulo:dword

	public JPSDR_HDRTools_Convert_RGB32toPlaneY16_AVX

	local i,w0:dword

	push esi
	push edi
	push ebx

	vpxor xmm1,xmm1,xmm1
	vpxor xmm0,xmm0,xmm0

	mov eax,w
	shr eax,3
	mov w0,eax
	
	mov esi,src

Convert_RGB32toPlaneY16_AVX_1:
	mov edi,lookup
	
	mov eax,w0
	or eax,eax
	jz Convert_RGB32toPlaneY16_AVX_3
	
	mov i,eax
Convert_RGB32toPlaneY16_AVX_2:
	movzx edx,byte ptr[esi]
	movzx ecx,byte ptr[esi+1]
	movzx ebx,byte ptr[esi+2] ; ebx=R ecx=G edx=B
	movzx eax,word ptr[edi+2*ebx]
	add ax,word ptr[edi+2*ecx+512]
	add ax,word ptr[edi+2*edx+1024]
	vpinsrw xmm0,xmm0,eax,0
	movzx edx,byte ptr[esi+4]
	movzx ecx,byte ptr[esi+5]
	movzx ebx,byte ptr[esi+6] ; ebx=R ecx=G edx=B
	movzx eax,word ptr[edi+2*ebx]
	add ax,word ptr[edi+2*ecx+512]
	add ax,word ptr[edi+2*edx+1024]
	vpinsrw xmm0,xmm0,eax,1
	movzx edx,byte ptr[esi+8]
	movzx ecx,byte ptr[esi+9]
	movzx ebx,byte ptr[esi+10] ; ebx=R ecx=G edx=B
	movzx eax,word ptr[edi+2*ebx]
	add ax,word ptr[edi+2*ecx+512]
	add ax,word ptr[edi+2*edx+1024]
	vpinsrw xmm0,xmm0,eax,2
	movzx edx,byte ptr[esi+12]
	movzx ecx,byte ptr[esi+13]
	movzx ebx,byte ptr[esi+14] ; ebx=R ecx=G edx=B
	movzx eax,word ptr[edi+2*ebx]
	add ax,word ptr[edi+2*ecx+512]
	add ax,word ptr[edi+2*edx+1024]
	vpinsrw xmm0,xmm0,eax,3
	movzx edx,byte ptr[esi+16]
	movzx ecx,byte ptr[esi+17]
	movzx ebx,byte ptr[esi+18] ; ebx=R ecx=G edx=B
	movzx eax,word ptr[edi+2*ebx]
	add ax,word ptr[edi+2*ecx+512]
	add ax,word ptr[edi+2*edx+1024]
	vpinsrw xmm0,xmm0,eax,4
	movzx edx,byte ptr[esi+20]
	movzx ecx,byte ptr[esi+21]
	movzx ebx,byte ptr[esi+22] ; ebx=R ecx=G edx=B
	movzx eax,word ptr[edi+2*ebx]
	add ax,word ptr[edi+2*ecx+512]
	add ax,word ptr[edi+2*edx+1024]
	vpinsrw xmm0,xmm0,eax,5
	movzx edx,byte ptr[esi+24]
	movzx ecx,byte ptr[esi+25]
	movzx ebx,byte ptr[esi+26] ; ebx=R ecx=G edx=B
	movzx eax,word ptr[edi+2*ebx]
	add ax,word ptr[edi+2*ecx+512]
	add ax,word ptr[edi+2*edx+1024]
	vpinsrw xmm0,xmm0,eax,6
	movzx edx,byte ptr[esi+28]
	movzx ecx,byte ptr[esi+29]
	movzx ebx,byte ptr[esi+30] ; ebx=R ecx=G edx=B
	movzx eax,word ptr[edi+2*ebx]
	add ax,word ptr[edi+2*ecx+512]
	add ax,word ptr[edi+2*edx+1024]
	mov edi,dst
	vpinsrw xmm0,xmm0,eax,7
	
	vpsraw xmm0,xmm0,6
	vpackuswb xmm0,xmm0,xmm1
	vpunpcklbw xmm0,xmm1,xmm0
	
	vmovdqa XMMWORD ptr[edi],xmm0
	
	add dst,16
	add esi,32
	
	mov edi,lookup
	
	dec i
	jnz Convert_RGB32toPlaneY16_AVX_2
	
Convert_RGB32toPlaneY16_AVX_3:	
	test w,4
	jz Convert_RGB32toPlaneY16_AVX_4
	
	movzx edx,byte ptr[esi]
	movzx ecx,byte ptr[esi+1]
	movzx ebx,byte ptr[esi+2] ; ebx=R ecx=G edx=B
	movzx eax,word ptr[edi+2*ebx]
	add ax,word ptr[edi+2*ecx+512]
	add ax,word ptr[edi+2*edx+1024]
	vpinsrw xmm0,xmm0,eax,0
	movzx edx,byte ptr[esi+4]
	movzx ecx,byte ptr[esi+5]
	movzx ebx,byte ptr[esi+6] ; ebx=R ecx=G edx=B
	movzx eax,word ptr[edi+2*ebx]
	add ax,word ptr[edi+2*ecx+512]
	add ax,word ptr[edi+2*edx+1024]
	vpinsrw xmm0,xmm0,eax,1
	movzx edx,byte ptr[esi+8]
	movzx ecx,byte ptr[esi+9]
	movzx ebx,byte ptr[esi+10] ; ebx=R ecx=G edx=B
	movzx eax,word ptr[edi+2*ebx]
	add ax,word ptr[edi+2*ecx+512]
	add ax,word ptr[edi+2*edx+1024]
	vpinsrw xmm0,xmm0,eax,2
	movzx edx,byte ptr[esi+12]
	movzx ecx,byte ptr[esi+13]
	movzx ebx,byte ptr[esi+14] ; ebx=R ecx=G edx=B
	movzx eax,word ptr[edi+2*ebx]
	add ax,word ptr[edi+2*ecx+512]
	add ax,word ptr[edi+2*edx+1024]
	mov edi,dst
	vpinsrw xmm0,xmm0,eax,3	
	
	vpsraw xmm0,xmm0,6
	vpackuswb xmm0,xmm0,xmm1
	vpunpcklbw xmm0,xmm1,xmm0
	
	vmovq qword ptr[edi],xmm0
	
	add dst,8
	add esi,16
	
	mov edi,lookup
	
Convert_RGB32toPlaneY16_AVX_4:
	test w,2
	jz short Convert_RGB32toPlaneY16_AVX_5

	movzx edx,byte ptr[esi]
	movzx ecx,byte ptr[esi+1]
	movzx ebx,byte ptr[esi+2] ; ebx=R ecx=G edx=B
	movzx eax,word ptr[edi+2*ebx]
	add ax,word ptr[edi+2*ecx+512]
	add ax,word ptr[edi+2*edx+1024]
	vpinsrw xmm0,xmm0,eax,0
	movzx edx,byte ptr[esi+4]
	movzx ecx,byte ptr[esi+5]
	movzx ebx,byte ptr[esi+6] ; ebx=R ecx=G edx=B
	movzx eax,word ptr[edi+2*ebx]
	add ax,word ptr[edi+2*ecx+512]
	add ax,word ptr[edi+2*edx+1024]
	mov edi,dst
	vpinsrw xmm0,xmm0,eax,1
	
	vpsraw xmm0,xmm0,6
	vpackuswb xmm0,xmm0,xmm1
	vpunpcklbw xmm0,xmm1,xmm0
	
	vmovd dword ptr[edi],xmm0
	
	add dst,4
	add esi,8
	
	mov edi,lookup
	
Convert_RGB32toPlaneY16_AVX_5:
	test w,1
	jz short Convert_RGB32toPlaneY16_AVX_6

	movzx edx,byte ptr[esi]
	movzx ecx,byte ptr[esi+1]
	movzx ebx,byte ptr[esi+2] ; ebx=R ecx=G edx=B
	movzx eax,word ptr[edi+2*ebx]
	add ax,word ptr[edi+2*ecx+512]
	add ax,word ptr[edi+2*edx+1024]
	mov edi,dst
	vpinsrw xmm0,xmm0,eax,0
	
	vpsraw xmm0,xmm0,6
	vpackuswb xmm0,xmm0,xmm1
	vpunpcklbw xmm0,xmm1,xmm0
	
	vpextrw eax,xmm0,0
	
	mov word ptr[edi],ax
	
	add dst,2
	add esi,4
	
Convert_RGB32toPlaneY16_AVX_6:	
	mov edi,dst
	add esi,src_modulo
	add edi,dst_modulo
	mov dst,edi
	dec h
	jnz Convert_RGB32toPlaneY16_AVX_1

	pop ebx
	pop edi
	pop esi

	ret

JPSDR_HDRTools_Convert_RGB32toPlaneY16_AVX endp


JPSDR_HDRTools_Convert_RGB64toPlaneY16_SSE41 proc src:dword,dst:dword,w:dword,h:dword,
	lookup:dword,src_modulo:dword,dst_modulo:dword

	public JPSDR_HDRTools_Convert_RGB64toPlaneY16_SSE41

	local i,w0:dword

	push esi
	push edi
	push ebx

	pxor xmm0,xmm0
	pxor xmm1,xmm1
	movdqa xmm2,XMMWORD ptr data_HLG_8
	movdqa xmm3,XMMWORD ptr data_dw_128

	mov eax,w
	shr eax,3
	mov w0,eax
	
	mov esi,src

Convert_RGB64toPlaneY16_SSE41_1:
	mov edi,lookup
	
	mov eax,w0
	or eax,eax
	jz Convert_RGB64toPlaneY16_SSE41_3
	
	mov i,eax
Convert_RGB64toPlaneY16_SSE41_2:
	movzx edx,word ptr[esi]
	movzx ecx,word ptr[esi+2]
	movzx ebx,word ptr[esi+4] ; ebx=R ecx=G edx=B
	mov eax,dword ptr[edi+4*ebx]
	add eax,dword ptr[edi+4*ecx+262144]
	add eax,dword ptr[edi+4*edx+524288]
	pinsrd xmm0,eax,0
	movzx edx,word ptr[esi+8]
	movzx ecx,word ptr[esi+10]
	movzx ebx,word ptr[esi+12] ; ebx=R ecx=G edx=B
	mov eax,dword ptr[edi+4*ebx]
	add eax,dword ptr[edi+4*ecx+262144]
	add eax,dword ptr[edi+4*edx+524288]
	pinsrd xmm0,eax,1
	movzx edx,word ptr[esi+16]
	movzx ecx,word ptr[esi+18]
	movzx ebx,word ptr[esi+20] ; ebx=R ecx=G edx=B
	mov eax,dword ptr[edi+4*ebx]
	add eax,dword ptr[edi+4*ecx+262144]
	add eax,dword ptr[edi+4*edx+524288]
	pinsrd xmm0,eax,2
	movzx edx,word ptr[esi+24]
	movzx ecx,word ptr[esi+26]
	movzx ebx,word ptr[esi+28] ; ebx=R ecx=G edx=B
	mov eax,dword ptr[edi+4*ebx]
	add eax,dword ptr[edi+4*ecx+262144]
	add eax,dword ptr[edi+4*edx+524288]
	pinsrd xmm0,eax,3

	movzx edx,word ptr[esi+32]
	movzx ecx,word ptr[esi+34]
	movzx ebx,word ptr[esi+36] ; ebx=R ecx=G edx=B
	mov eax,dword ptr[edi+4*ebx]
	add eax,dword ptr[edi+4*ecx+262144]
	add eax,dword ptr[edi+4*edx+524288]
	pinsrd xmm1,eax,0
	movzx edx,word ptr[esi+40]
	movzx ecx,word ptr[esi+42]
	movzx ebx,word ptr[esi+44] ; ebx=R ecx=G edx=B
	mov eax,dword ptr[edi+4*ebx]
	add eax,dword ptr[edi+4*ecx+262144]
	add eax,dword ptr[edi+4*edx+524288]
	pinsrd xmm1,eax,1
	movzx edx,word ptr[esi+48]
	movzx ecx,word ptr[esi+50]
	movzx ebx,word ptr[esi+52] ; ebx=R ecx=G edx=B
	mov eax,dword ptr[edi+4*ebx]
	add eax,dword ptr[edi+4*ecx+262144]
	add eax,dword ptr[edi+4*edx+524288]
	pinsrd xmm1,eax,2
	movzx edx,word ptr[esi+56]
	movzx ecx,word ptr[esi+58]
	movzx ebx,word ptr[esi+60] ; ebx=R ecx=G edx=B
	mov eax,dword ptr[edi+4*ebx]
	add eax,dword ptr[edi+4*ecx+262144]
	add eax,dword ptr[edi+4*edx+524288]
	mov edi,dst
	pinsrd xmm1,eax,3
	
	psrad xmm0,8
	psrad xmm1,8
	paddd xmm0,xmm3
	paddd xmm1,xmm3
	packusdw xmm0,xmm1
	pand xmm0,xmm2
	
	movdqa XMMWORD ptr[edi],xmm0
	
	add dst,16
	add esi,64
	
	mov edi,lookup
	
	dec i
	jnz Convert_RGB64toPlaneY16_SSE41_2
	
Convert_RGB64toPlaneY16_SSE41_3:
	test w,4
	jz Convert_RGB64toPlaneY16_SSE41_4

	movzx edx,word ptr[esi]
	movzx ecx,word ptr[esi+2]
	movzx ebx,word ptr[esi+4] ; ebx=R ecx=G edx=B
	mov eax,dword ptr[edi+4*ebx]
	add eax,dword ptr[edi+4*ecx+262144]
	add eax,dword ptr[edi+4*edx+524288]
	pinsrd xmm0,eax,0
	movzx edx,word ptr[esi+8]
	movzx ecx,word ptr[esi+10]
	movzx ebx,word ptr[esi+12] ; ebx=R ecx=G edx=B
	mov eax,dword ptr[edi+4*ebx]
	add eax,dword ptr[edi+4*ecx+262144]
	add eax,dword ptr[edi+4*edx+524288]
	pinsrd xmm0,eax,1
	movzx edx,word ptr[esi+16]
	movzx ecx,word ptr[esi+18]
	movzx ebx,word ptr[esi+20] ; ebx=R ecx=G edx=B
	mov eax,dword ptr[edi+4*ebx]
	add eax,dword ptr[edi+4*ecx+262144]
	add eax,dword ptr[edi+4*edx+524288]
	pinsrd xmm0,eax,2
	movzx edx,word ptr[esi+24]
	movzx ecx,word ptr[esi+26]
	movzx ebx,word ptr[esi+28] ; ebx=R ecx=G edx=B
	mov eax,dword ptr[edi+4*ebx]
	add eax,dword ptr[edi+4*ecx+262144]
	add eax,dword ptr[edi+4*edx+524288]
	mov edi,dst
	pinsrd xmm0,eax,3
	
	psrad xmm0,8
	paddd xmm0,xmm3
	packusdw xmm0,xmm0
	pand xmm0,xmm2
	
	movq qword ptr[edi],xmm0
	
	add dst,8
	add esi,32
	
	mov edi,lookup	
	
Convert_RGB64toPlaneY16_SSE41_4:	
	test w,2
	jz Convert_RGB64toPlaneY16_SSE41_5
	
	movzx edx,word ptr[esi]
	movzx ecx,word ptr[esi+2]
	movzx ebx,word ptr[esi+4] ; ebx=R ecx=G edx=B
	mov eax,dword ptr[edi+4*ebx]
	add eax,dword ptr[edi+4*ecx+262144]
	add eax,dword ptr[edi+4*edx+524288]
	pinsrd xmm0,eax,0
	movzx edx,word ptr[esi+8]
	movzx ecx,word ptr[esi+10]
	movzx ebx,word ptr[esi+12] ; ebx=R ecx=G edx=B
	mov eax,dword ptr[edi+4*ebx]
	add eax,dword ptr[edi+4*ecx+262144]
	add eax,dword ptr[edi+4*edx+524288]
	mov edi,dst
	pinsrd xmm0,eax,1
	
	psrad xmm0,8
	paddd xmm0,xmm3
	packusdw xmm0,xmm0
	pand xmm0,xmm2
	
	movd dword ptr[edi],xmm0
	
	add dst,4
	add esi,16
	
	mov edi,lookup
	
Convert_RGB64toPlaneY16_SSE41_5:
	test w,1
	jz short Convert_RGB64toPlaneY16_SSE41_6

	movzx edx,word ptr[esi]
	movzx ecx,word ptr[esi+2]
	movzx ebx,word ptr[esi+4] ; ebx=R ecx=G edx=B
	mov eax,dword ptr[edi+4*ebx]
	add eax,dword ptr[edi+4*ecx+262144]
	add eax,dword ptr[edi+4*edx+524288]
	mov edi,dst
	pinsrd xmm0,eax,0
	
	psrad xmm0,8
	paddd xmm0,xmm3
	packusdw xmm0,xmm0
	pand xmm0,xmm2
	
	pextrw eax,xmm0,0
	mov word ptr[edi],ax
	
	add dst,2
	add esi,8
	
Convert_RGB64toPlaneY16_SSE41_6:
	mov edi,dst
	add esi,src_modulo
	add edi,dst_modulo
	mov dst,edi
	dec h
	jnz Convert_RGB64toPlaneY16_SSE41_1

	pop ebx
	pop edi
	pop esi

	ret

JPSDR_HDRTools_Convert_RGB64toPlaneY16_SSE41 endp


JPSDR_HDRTools_Convert_RGB64toPlaneY16_AVX proc src:dword,dst:dword,w:dword,h:dword,
	lookup:dword,src_modulo:dword,dst_modulo:dword

	public JPSDR_HDRTools_Convert_RGB64toPlaneY16_AVX

	local i,w0:dword

	push esi
	push edi
	push ebx

	vpxor xmm1,xmm1,xmm1
	vpxor xmm0,xmm0,xmm0
	vmovdqa xmm2,XMMWORD ptr data_HLG_8
	vmovdqa xmm3,XMMWORD ptr data_dw_128

	mov eax,w
	shr eax,3
	mov w0,eax
	
	mov esi,src

Convert_RGB64toPlaneY16_AVX_1:
	mov edi,lookup
	
	mov eax,w0
	or eax,eax
	jz Convert_RGB64toPlaneY16_AVX_3
	
	mov i,eax
Convert_RGB64toPlaneY16_AVX_2:
	movzx edx,word ptr[esi]
	movzx ecx,word ptr[esi+2]
	movzx ebx,word ptr[esi+4] ; ebx=R ecx=G edx=B
	mov eax,dword ptr[edi+4*ebx]
	add eax,dword ptr[edi+4*ecx+262144]
	add eax,dword ptr[edi+4*edx+524288]
	vpinsrd xmm0,xmm0,eax,0
	movzx edx,word ptr[esi+8]
	movzx ecx,word ptr[esi+10]
	movzx ebx,word ptr[esi+12] ; ebx=R ecx=G edx=B
	mov eax,dword ptr[edi+4*ebx]
	add eax,dword ptr[edi+4*ecx+262144]
	add eax,dword ptr[edi+4*edx+524288]
	vpinsrd xmm0,xmm0,eax,1
	movzx edx,word ptr[esi+16]
	movzx ecx,word ptr[esi+18]
	movzx ebx,word ptr[esi+20] ; ebx=R ecx=G edx=B
	mov eax,dword ptr[edi+4*ebx]
	add eax,dword ptr[edi+4*ecx+262144]
	add eax,dword ptr[edi+4*edx+524288]
	vpinsrd xmm0,xmm0,eax,2
	movzx edx,word ptr[esi+24]
	movzx ecx,word ptr[esi+26]
	movzx ebx,word ptr[esi+28] ; ebx=R ecx=G edx=B
	mov eax,dword ptr[edi+4*ebx]
	add eax,dword ptr[edi+4*ecx+262144]
	add eax,dword ptr[edi+4*edx+524288]
	vpinsrd xmm0,xmm0,eax,3

	movzx edx,word ptr[esi+32]
	movzx ecx,word ptr[esi+34]
	movzx ebx,word ptr[esi+36] ; ebx=R ecx=G edx=B
	mov eax,dword ptr[edi+4*ebx]
	add eax,dword ptr[edi+4*ecx+262144]
	add eax,dword ptr[edi+4*edx+524288]
	vpinsrd xmm1,xmm1,eax,0
	movzx edx,word ptr[esi+40]
	movzx ecx,word ptr[esi+42]
	movzx ebx,word ptr[esi+44] ; ebx=R ecx=G edx=B
	mov eax,dword ptr[edi+4*ebx]
	add eax,dword ptr[edi+4*ecx+262144]
	add eax,dword ptr[edi+4*edx+524288]
	vpinsrd xmm1,xmm1,eax,1
	movzx edx,word ptr[esi+48]
	movzx ecx,word ptr[esi+50]
	movzx ebx,word ptr[esi+52] ; ebx=R ecx=G edx=B
	mov eax,dword ptr[edi+4*ebx]
	add eax,dword ptr[edi+4*ecx+262144]
	add eax,dword ptr[edi+4*edx+524288]
	vpinsrd xmm1,xmm1,eax,2
	movzx edx,word ptr[esi+56]
	movzx ecx,word ptr[esi+58]
	movzx ebx,word ptr[esi+60] ; ebx=R ecx=G edx=B
	mov eax,dword ptr[edi+4*ebx]
	add eax,dword ptr[edi+4*ecx+262144]
	add eax,dword ptr[edi+4*edx+524288]
	mov edi,dst
	vpinsrd xmm1,xmm1,eax,3
	
	vpsrad xmm0,xmm0,8
	vpsrad xmm1,xmm1,8
	vpaddd xmm0,xmm0,xmm3
	vpaddd xmm1,xmm1,xmm3
	vpackusdw xmm0,xmm0,xmm1
	vpand xmm0,xmm0,xmm2
	
	vmovdqa XMMWORD ptr[edi],xmm0
	
	add dst,16
	add esi,64
	
	mov edi,lookup
	
	dec i
	jnz Convert_RGB64toPlaneY16_AVX_2
	
Convert_RGB64toPlaneY16_AVX_3:
	test w,4
	jz Convert_RGB64toPlaneY16_AVX_4

	movzx edx,word ptr[esi]
	movzx ecx,word ptr[esi+2]
	movzx ebx,word ptr[esi+4] ; ebx=R ecx=G edx=B
	mov eax,dword ptr[edi+4*ebx]
	add eax,dword ptr[edi+4*ecx+262144]
	add eax,dword ptr[edi+4*edx+524288]
	vpinsrd xmm0,xmm0,eax,0
	movzx edx,word ptr[esi+8]
	movzx ecx,word ptr[esi+10]
	movzx ebx,word ptr[esi+12] ; ebx=R ecx=G edx=B
	mov eax,dword ptr[edi+4*ebx]
	add eax,dword ptr[edi+4*ecx+262144]
	add eax,dword ptr[edi+4*edx+524288]
	vpinsrd xmm0,xmm0,eax,1
	movzx edx,word ptr[esi+16]
	movzx ecx,word ptr[esi+18]
	movzx ebx,word ptr[esi+20] ; ebx=R ecx=G edx=B
	mov eax,dword ptr[edi+4*ebx]
	add eax,dword ptr[edi+4*ecx+262144]
	add eax,dword ptr[edi+4*edx+524288]
	vpinsrd xmm0,xmm0,eax,2
	movzx edx,word ptr[esi+24]
	movzx ecx,word ptr[esi+26]
	movzx ebx,word ptr[esi+28] ; ebx=R ecx=G edx=B
	mov eax,dword ptr[edi+4*ebx]
	add eax,dword ptr[edi+4*ecx+262144]
	add eax,dword ptr[edi+4*edx+524288]
	mov edi,dst
	vpinsrd xmm0,xmm0,eax,3
	
	vpsrad xmm0,xmm0,8
	vpaddd xmm0,xmm0,xmm3
	vpackusdw xmm0,xmm0,xmm0
	vpand xmm0,xmm0,xmm2
	
	vmovq qword ptr[edi],xmm0
	
	add dst,8
	add esi,32
	
	mov edi,lookup	
	
Convert_RGB64toPlaneY16_AVX_4:	
	test w,2
	jz Convert_RGB64toPlaneY16_AVX_5
	
	movzx edx,word ptr[esi]
	movzx ecx,word ptr[esi+2]
	movzx ebx,word ptr[esi+4] ; ebx=R ecx=G edx=B
	mov eax,dword ptr[edi+4*ebx]
	add eax,dword ptr[edi+4*ecx+262144]
	add eax,dword ptr[edi+4*edx+524288]
	vpinsrd xmm0,xmm0,eax,0
	movzx edx,word ptr[esi+8]
	movzx ecx,word ptr[esi+10]
	movzx ebx,word ptr[esi+12] ; ebx=R ecx=G edx=B
	mov eax,dword ptr[edi+4*ebx]
	add eax,dword ptr[edi+4*ecx+262144]
	add eax,dword ptr[edi+4*edx+524288]
	mov edi,dst
	vpinsrd xmm0,xmm0,eax,1
	
	vpsrad xmm0,xmm0,8
	vpaddd xmm0,xmm0,xmm3
	vpackusdw xmm0,xmm0,xmm0
	vpand xmm0,xmm0,xmm2
	
	vmovd dword ptr[edi],xmm0
	
	add dst,4
	add esi,16
	
	mov edi,lookup
	
Convert_RGB64toPlaneY16_AVX_5:
	test w,1
	jz short Convert_RGB64toPlaneY16_AVX_6

	movzx edx,word ptr[esi]
	movzx ecx,word ptr[esi+2]
	movzx ebx,word ptr[esi+4] ; ebx=R ecx=G edx=B
	mov eax,dword ptr[edi+4*ebx]
	add eax,dword ptr[edi+4*ecx+262144]
	add eax,dword ptr[edi+4*edx+524288]
	mov edi,dst
	vpinsrd xmm0,xmm0,eax,0
	
	vpsrad xmm0,xmm0,8
	vpaddd xmm0,xmm0,xmm3
	vpackusdw xmm0,xmm0,xmm0
	vpand xmm0,xmm0,xmm2
	
	vpextrw eax,xmm0,0
	mov word ptr[edi],ax

	add dst,2
	add esi,8
	
Convert_RGB64toPlaneY16_AVX_6:
	mov edi,dst
	add esi,src_modulo
	add edi,dst_modulo
	mov dst,edi
	dec h
	jnz Convert_RGB64toPlaneY16_AVX_1

	pop ebx
	pop edi
	pop esi

	ret

JPSDR_HDRTools_Convert_RGB64toPlaneY16_AVX endp


JPSDR_HDRTools_Convert_10_RGB64toPlaneY32_SSE41 proc src:dword,dst:dword,w:dword,h:dword,
	lookup:dword,src_modulo:dword,dst_modulo:dword

	public JPSDR_HDRTools_Convert_10_RGB64toPlaneY32_SSE41

	local i,w0:dword

	push esi
	push edi
	push ebx

	pxor xmm1,xmm1
	pxor xmm0,xmm0
	movdqa xmm2,XMMWORD ptr data_HLG_10
	movdqa xmm3,XMMWORD ptr data_dw_32

	mov eax,w
	shr eax,2
	mov w0,eax
	
	mov esi,src

Convert_10_RGB64toPlaneY32_SSE41_1:
	mov edi,lookup
	
	mov eax,w0
	or eax,eax
	jz Convert_10_RGB64toPlaneY32_SSE41_3
	
	mov i,eax
Convert_10_RGB64toPlaneY32_SSE41_2:
	movzx edx,word ptr[esi]
	movzx ecx,word ptr[esi+2]
	movzx ebx,word ptr[esi+4] ; ebx=R ecx=G edx=B
	mov eax,dword ptr[edi+4*ebx]
	add eax,dword ptr[edi+4*ecx+262144]
	add eax,dword ptr[edi+4*edx+524288]
	pinsrd xmm0,eax,0
	movzx edx,word ptr[esi+8]
	movzx ecx,word ptr[esi+10]
	movzx ebx,word ptr[esi+12] ; ebx=R ecx=G edx=B
	mov eax,dword ptr[edi+4*ebx]
	add eax,dword ptr[edi+4*ecx+262144]
	add eax,dword ptr[edi+4*edx+524288]
	pinsrd xmm0,eax,1
	movzx edx,word ptr[esi+16]
	movzx ecx,word ptr[esi+18]
	movzx ebx,word ptr[esi+20] ; ebx=R ecx=G edx=B
	mov eax,dword ptr[edi+4*ebx]
	add eax,dword ptr[edi+4*ecx+262144]
	add eax,dword ptr[edi+4*edx+524288]
	pinsrd xmm0,eax,2
	movzx edx,word ptr[esi+24]
	movzx ecx,word ptr[esi+26]
	movzx ebx,word ptr[esi+28] ; ebx=R ecx=G edx=B
	mov eax,dword ptr[edi+4*ebx]
	add eax,dword ptr[edi+4*ecx+262144]
	add eax,dword ptr[edi+4*edx+524288]
	mov edi,dst
	pinsrd xmm0,eax,3
	
	psrad xmm0,8
	paddd xmm0,xmm3
	packusdw xmm0,xmm1
	punpcklwd xmm0,xmm1
	pslld xmm0,4
	pand xmm0,xmm2
	
	movdqa XMMWORD ptr[edi],xmm0
	
	add dst,16
	add esi,32
	
	mov edi,lookup
	
	dec i
	jnz Convert_10_RGB64toPlaneY32_SSE41_2
	
Convert_10_RGB64toPlaneY32_SSE41_3:	
	test w,2
	jz Convert_10_RGB64toPlaneY32_SSE41_4
	
	movzx edx,word ptr[esi]
	movzx ecx,word ptr[esi+2]
	movzx ebx,word ptr[esi+4] ; ebx=R ecx=G edx=B
	mov eax,dword ptr[edi+4*ebx]
	add eax,dword ptr[edi+4*ecx+262144]
	add eax,dword ptr[edi+4*edx+524288]
	pinsrd xmm0,eax,0
	movzx edx,word ptr[esi+8]
	movzx ecx,word ptr[esi+10]
	movzx ebx,word ptr[esi+12] ; ebx=R ecx=G edx=B
	mov eax,dword ptr[edi+4*ebx]
	add eax,dword ptr[edi+4*ecx+262144]
	add eax,dword ptr[edi+4*edx+524288]
	mov edi,dst
	pinsrd xmm0,eax,1
	
	psrad xmm0,8
	paddd xmm0,xmm3
	packusdw xmm0,xmm1
	punpcklwd xmm0,xmm1
	pslld xmm0,4
	pand xmm0,xmm2
	
	movq qword ptr[edi],xmm0
	
	add dst,8
	add esi,16
	
	mov edi,lookup
	
Convert_10_RGB64toPlaneY32_SSE41_4:
	test w,1
	jz short Convert_10_RGB64toPlaneY32_SSE41_5

	movzx edx,word ptr[esi]
	movzx ecx,word ptr[esi+2]
	movzx ebx,word ptr[esi+4] ; ebx=R ecx=G edx=B
	mov eax,dword ptr[edi+4*ebx]
	add eax,dword ptr[edi+4*ecx+262144]
	add eax,dword ptr[edi+4*edx+524288]
	mov edi,dst
	pinsrd xmm0,eax,0
	
	psrad xmm0,8
	paddd xmm0,xmm3
	packusdw xmm0,xmm1
	punpcklwd xmm0,xmm1
	pslld xmm0,4
	pand xmm0,xmm2
	
	movd dword ptr[edi],xmm0
	
	add dst,4
	add esi,8
	
Convert_10_RGB64toPlaneY32_SSE41_5:
	mov edi,dst
	add esi,src_modulo
	add edi,dst_modulo
	mov dst,edi
	dec h
	jnz Convert_10_RGB64toPlaneY32_SSE41_1

	pop ebx
	pop edi
	pop esi

	ret

JPSDR_HDRTools_Convert_10_RGB64toPlaneY32_SSE41 endp


JPSDR_HDRTools_Convert_10_RGB64toPlaneY32_AVX proc src:dword,dst:dword,w:dword,h:dword,
	lookup:dword,src_modulo:dword,dst_modulo:dword

	public JPSDR_HDRTools_Convert_10_RGB64toPlaneY32_AVX

	local i,w0:dword

	push esi
	push edi
	push ebx

	vpxor xmm1,xmm1,xmm1
	vpxor xmm0,xmm0,xmm0
	vmovdqa xmm2,XMMWORD ptr data_HLG_10
	vmovdqa xmm3,XMMWORD ptr data_dw_32

	mov eax,w
	shr eax,2
	mov w0,eax
	
	mov esi,src

Convert_10_RGB64toPlaneY32_AVX_1:
	mov edi,lookup
	
	mov eax,w0
	or eax,eax
	jz Convert_10_RGB64toPlaneY32_AVX_3
	
	mov i,eax
Convert_10_RGB64toPlaneY32_AVX_2:
	movzx edx,word ptr[esi]
	movzx ecx,word ptr[esi+2]
	movzx ebx,word ptr[esi+4] ; ebx=R ecx=G edx=B
	mov eax,dword ptr[edi+4*ebx]
	add eax,dword ptr[edi+4*ecx+262144]
	add eax,dword ptr[edi+4*edx+524288]
	vpinsrd xmm0,xmm0,eax,0
	movzx edx,word ptr[esi+8]
	movzx ecx,word ptr[esi+10]
	movzx ebx,word ptr[esi+12] ; ebx=R ecx=G edx=B
	mov eax,dword ptr[edi+4*ebx]
	add eax,dword ptr[edi+4*ecx+262144]
	add eax,dword ptr[edi+4*edx+524288]
	vpinsrd xmm0,xmm0,eax,1
	movzx edx,word ptr[esi+16]
	movzx ecx,word ptr[esi+18]
	movzx ebx,word ptr[esi+20] ; ebx=R ecx=G edx=B
	mov eax,dword ptr[edi+4*ebx]
	add eax,dword ptr[edi+4*ecx+262144]
	add eax,dword ptr[edi+4*edx+524288]
	vpinsrd xmm0,xmm0,eax,2
	movzx edx,word ptr[esi+24]
	movzx ecx,word ptr[esi+26]
	movzx ebx,word ptr[esi+28] ; ebx=R ecx=G edx=B
	mov eax,dword ptr[edi+4*ebx]
	add eax,dword ptr[edi+4*ecx+262144]
	add eax,dword ptr[edi+4*edx+524288]
	mov edi,dst
	vpinsrd xmm0,xmm0,eax,3
	
	vpsrad xmm0,xmm0,8
	vpaddd xmm0,xmm0,xmm3
	vpackusdw xmm0,xmm0,xmm1
	vpunpcklwd xmm0,xmm0,xmm1
	vpslld xmm0,xmm0,4
	vpand xmm0,xmm0,xmm2
	
	vmovdqa XMMWORD ptr[edi],xmm0
	
	add dst,16
	add esi,32
	
	mov edi,lookup
	
	dec i
	jnz Convert_10_RGB64toPlaneY32_AVX_2
	
Convert_10_RGB64toPlaneY32_AVX_3:	
	test w,2
	jz Convert_10_RGB64toPlaneY32_AVX_4
	
	movzx edx,word ptr[esi]
	movzx ecx,word ptr[esi+2]
	movzx ebx,word ptr[esi+4] ; ebx=R ecx=G edx=B
	mov eax,dword ptr[edi+4*ebx]
	add eax,dword ptr[edi+4*ecx+262144]
	add eax,dword ptr[edi+4*edx+524288]
	vpinsrd xmm0,xmm0,eax,0
	movzx edx,word ptr[esi+8]
	movzx ecx,word ptr[esi+10]
	movzx ebx,word ptr[esi+12] ; ebx=R ecx=G edx=B
	mov eax,dword ptr[edi+4*ebx]
	add eax,dword ptr[edi+4*ecx+262144]
	add eax,dword ptr[edi+4*edx+524288]
	mov edi,dst
	vpinsrd xmm0,xmm0,eax,1
	
	vpsrad xmm0,xmm0,8
	vpaddd xmm0,xmm0,xmm3
	vpackusdw xmm0,xmm0,xmm1
	vpunpcklwd xmm0,xmm0,xmm1
	vpslld xmm0,xmm0,4
	vpand xmm0,xmm0,xmm2
	
	vmovq qword ptr[edi],xmm0
	
	add dst,8
	add esi,16
	
	mov edi,lookup
	
Convert_10_RGB64toPlaneY32_AVX_4:
	test w,1
	jz short Convert_10_RGB64toPlaneY32_AVX_5

	movzx edx,word ptr[esi]
	movzx ecx,word ptr[esi+2]
	movzx ebx,word ptr[esi+4] ; ebx=R ecx=G edx=B
	mov eax,dword ptr[edi+4*ebx]
	add eax,dword ptr[edi+4*ecx+262144]
	add eax,dword ptr[edi+4*edx+524288]
	mov edi,dst
	vpinsrd xmm0,xmm0,eax,0
	
	vpsrad xmm0,xmm0,8
	vpaddd xmm0,xmm0,xmm3
	vpackusdw xmm0,xmm0,xmm1
	vpunpcklwd xmm0,xmm0,xmm1
	vpslld xmm0,xmm0,4
	vpand xmm0,xmm0,xmm2
	
	vmovd dword ptr[edi],xmm0
	
	add dst,4
	add esi,8
	
Convert_10_RGB64toPlaneY32_AVX_5:
	mov edi,dst
	add esi,src_modulo
	add edi,dst_modulo
	mov dst,edi
	dec h
	jnz Convert_10_RGB64toPlaneY32_AVX_1

	pop ebx
	pop edi
	pop esi

	ret

JPSDR_HDRTools_Convert_10_RGB64toPlaneY32_AVX endp


JPSDR_HDRTools_Convert_12_RGB64toPlaneY32_SSE41 proc src:dword,dst:dword,w:dword,h:dword,
	lookup:dword,src_modulo:dword,dst_modulo:dword

	public JPSDR_HDRTools_Convert_12_RGB64toPlaneY32_SSE41

	local i,w0:dword

	push esi
	push edi
	push ebx

	pxor xmm1,xmm1
	pxor xmm0,xmm0
	movdqa xmm2,XMMWORD ptr data_HLG_12
	movdqa xmm3,XMMWORD ptr data_dw_8

	mov eax,w
	shr eax,2
	mov w0,eax
	
	mov esi,src

Convert_12_RGB64toPlaneY32_SSE41_1:
	mov edi,lookup
	
	mov eax,w0
	or eax,eax
	jz Convert_12_RGB64toPlaneY32_SSE41_3
	
	mov i,eax
Convert_12_RGB64toPlaneY32_SSE41_2:
	movzx edx,word ptr[esi]
	movzx ecx,word ptr[esi+2]
	movzx ebx,word ptr[esi+4] ; ebx=R ecx=G edx=B
	mov eax,dword ptr[edi+4*ebx]
	add eax,dword ptr[edi+4*ecx+262144]
	add eax,dword ptr[edi+4*edx+524288]
	pinsrd xmm0,eax,0
	movzx edx,word ptr[esi+8]
	movzx ecx,word ptr[esi+10]
	movzx ebx,word ptr[esi+12] ; ebx=R ecx=G edx=B
	mov eax,dword ptr[edi+4*ebx]
	add eax,dword ptr[edi+4*ecx+262144]
	add eax,dword ptr[edi+4*edx+524288]
	pinsrd xmm0,eax,1
	movzx edx,word ptr[esi+16]
	movzx ecx,word ptr[esi+18]
	movzx ebx,word ptr[esi+20] ; ebx=R ecx=G edx=B
	mov eax,dword ptr[edi+4*ebx]
	add eax,dword ptr[edi+4*ecx+262144]
	add eax,dword ptr[edi+4*edx+524288]
	pinsrd xmm0,eax,2
	movzx edx,word ptr[esi+24]
	movzx ecx,word ptr[esi+26]
	movzx ebx,word ptr[esi+28] ; ebx=R ecx=G edx=B
	mov eax,dword ptr[edi+4*ebx]
	add eax,dword ptr[edi+4*ecx+262144]
	add eax,dword ptr[edi+4*edx+524288]
	mov edi,dst
	pinsrd xmm0,eax,3
	
	psrad xmm0,8
	paddd xmm0,xmm3
	packusdw xmm0,xmm1
	punpcklwd xmm0,xmm1
	pslld xmm0,8
	pand xmm0,xmm2
	
	movdqa XMMWORD ptr[edi],xmm0
	
	add dst,16
	add esi,32
	
	mov edi,lookup
	
	dec i
	jnz Convert_12_RGB64toPlaneY32_SSE41_2
	
Convert_12_RGB64toPlaneY32_SSE41_3:	
	test w,2
	jz Convert_12_RGB64toPlaneY32_SSE41_4
	
	movzx edx,word ptr[esi]
	movzx ecx,word ptr[esi+2]
	movzx ebx,word ptr[esi+4] ; ebx=R ecx=G edx=B
	mov eax,dword ptr[edi+4*ebx]
	add eax,dword ptr[edi+4*ecx+262144]
	add eax,dword ptr[edi+4*edx+524288]
	pinsrd xmm0,eax,0
	movzx edx,word ptr[esi+8]
	movzx ecx,word ptr[esi+10]
	movzx ebx,word ptr[esi+12] ; ebx=R ecx=G edx=B
	mov eax,dword ptr[edi+4*ebx]
	add eax,dword ptr[edi+4*ecx+262144]
	add eax,dword ptr[edi+4*edx+524288]
	mov edi,dst
	pinsrd xmm0,eax,1
	
	psrad xmm0,8
	paddd xmm0,xmm3
	packusdw xmm0,xmm1
	punpcklwd xmm0,xmm1
	pslld xmm0,8
	pand xmm0,xmm2
	
	movq qword ptr[edi],xmm0
	
	add dst,8
	add esi,16
	
	mov edi,lookup
	
Convert_12_RGB64toPlaneY32_SSE41_4:
	test w,1
	jz short Convert_12_RGB64toPlaneY32_SSE41_5

	movzx edx,word ptr[esi]
	movzx ecx,word ptr[esi+2]
	movzx ebx,word ptr[esi+4] ; ebx=R ecx=G edx=B
	mov eax,dword ptr[edi+4*ebx]
	add eax,dword ptr[edi+4*ecx+262144]
	add eax,dword ptr[edi+4*edx+524288]
	mov edi,dst
	pinsrd xmm0,eax,0
	
	psrad xmm0,8
	paddd xmm0,xmm3
	packusdw xmm0,xmm1
	punpcklwd xmm0,xmm1
	pslld xmm0,8
	pand xmm0,xmm2
	
	movd dword ptr[edi],xmm0
	
	add dst,4
	add esi,8
	
Convert_12_RGB64toPlaneY32_SSE41_5:
	mov edi,dst
	add esi,src_modulo
	add edi,dst_modulo
	mov dst,edi
	dec h
	jnz Convert_12_RGB64toPlaneY32_SSE41_1

	pop ebx
	pop edi
	pop esi

	ret

JPSDR_HDRTools_Convert_12_RGB64toPlaneY32_SSE41 endp


JPSDR_HDRTools_Convert_12_RGB64toPlaneY32_AVX proc src:dword,dst:dword,w:dword,h:dword,
	lookup:dword,src_modulo:dword,dst_modulo:dword

	public JPSDR_HDRTools_Convert_12_RGB64toPlaneY32_AVX

	local i,w0:dword

	push esi
	push edi
	push ebx

	vpxor xmm1,xmm1,xmm1
	vpxor xmm0,xmm0,xmm0
	vmovdqa xmm2,XMMWORD ptr data_HLG_12
	vmovdqa xmm3,XMMWORD ptr data_dw_8

	mov eax,w
	shr eax,2
	mov w0,eax
	
	mov esi,src

Convert_12_RGB64toPlaneY32_AVX_1:
	mov edi,lookup
	
	mov eax,w0
	or eax,eax
	jz Convert_12_RGB64toPlaneY32_AVX_3
	
	mov i,eax
Convert_12_RGB64toPlaneY32_AVX_2:
	movzx edx,word ptr[esi]
	movzx ecx,word ptr[esi+2]
	movzx ebx,word ptr[esi+4] ; ebx=R ecx=G edx=B
	mov eax,dword ptr[edi+4*ebx]
	add eax,dword ptr[edi+4*ecx+262144]
	add eax,dword ptr[edi+4*edx+524288]
	vpinsrd xmm0,xmm0,eax,0
	movzx edx,word ptr[esi+8]
	movzx ecx,word ptr[esi+10]
	movzx ebx,word ptr[esi+12] ; ebx=R ecx=G edx=B
	mov eax,dword ptr[edi+4*ebx]
	add eax,dword ptr[edi+4*ecx+262144]
	add eax,dword ptr[edi+4*edx+524288]
	vpinsrd xmm0,xmm0,eax,1
	movzx edx,word ptr[esi+16]
	movzx ecx,word ptr[esi+18]
	movzx ebx,word ptr[esi+20] ; ebx=R ecx=G edx=B
	mov eax,dword ptr[edi+4*ebx]
	add eax,dword ptr[edi+4*ecx+262144]
	add eax,dword ptr[edi+4*edx+524288]
	vpinsrd xmm0,xmm0,eax,2
	movzx edx,word ptr[esi+24]
	movzx ecx,word ptr[esi+26]
	movzx ebx,word ptr[esi+28] ; ebx=R ecx=G edx=B
	mov eax,dword ptr[edi+4*ebx]
	add eax,dword ptr[edi+4*ecx+262144]
	add eax,dword ptr[edi+4*edx+524288]
	mov edi,dst
	vpinsrd xmm0,xmm0,eax,3
	
	vpsrad xmm0,xmm0,8
	vpaddd xmm0,xmm0,xmm3
	vpackusdw xmm0,xmm0,xmm1
	vpunpcklwd xmm0,xmm0,xmm1
	vpslld xmm0,xmm0,8
	vpand xmm0,xmm0,xmm2
	
	vmovdqa XMMWORD ptr[edi],xmm0
	
	add dst,16
	add esi,32
	
	mov edi,lookup
	
	dec i
	jnz Convert_12_RGB64toPlaneY32_AVX_2
	
Convert_12_RGB64toPlaneY32_AVX_3:	
	test w,2
	jz Convert_12_RGB64toPlaneY32_AVX_4
	
	movzx edx,word ptr[esi]
	movzx ecx,word ptr[esi+2]
	movzx ebx,word ptr[esi+4] ; ebx=R ecx=G edx=B
	mov eax,dword ptr[edi+4*ebx]
	add eax,dword ptr[edi+4*ecx+262144]
	add eax,dword ptr[edi+4*edx+524288]
	vpinsrd xmm0,xmm0,eax,0
	movzx edx,word ptr[esi+8]
	movzx ecx,word ptr[esi+10]
	movzx ebx,word ptr[esi+12] ; ebx=R ecx=G edx=B
	mov eax,dword ptr[edi+4*ebx]
	add eax,dword ptr[edi+4*ecx+262144]
	add eax,dword ptr[edi+4*edx+524288]
	mov edi,dst
	vpinsrd xmm0,xmm0,eax,1
	
	vpsrad xmm0,xmm0,8
	vpaddd xmm0,xmm0,xmm3
	vpackusdw xmm0,xmm0,xmm1
	vpunpcklwd xmm0,xmm0,xmm1
	vpslld xmm0,xmm0,8
	vpand xmm0,xmm0,xmm2
	
	vmovq qword ptr[edi],xmm0
	
	add dst,8
	add esi,16
	
	mov edi,lookup
	
Convert_12_RGB64toPlaneY32_AVX_4:
	test w,1
	jz short Convert_12_RGB64toPlaneY32_AVX_5

	movzx edx,word ptr[esi]
	movzx ecx,word ptr[esi+2]
	movzx ebx,word ptr[esi+4] ; ebx=R ecx=G edx=B
	mov eax,dword ptr[edi+4*ebx]
	add eax,dword ptr[edi+4*ecx+262144]
	add eax,dword ptr[edi+4*edx+524288]
	mov edi,dst
	vpinsrd xmm0,xmm0,eax,0
	
	vpsrad xmm0,xmm0,8
	vpaddd xmm0,xmm0,xmm3
	vpackusdw xmm0,xmm0,xmm1
	vpunpcklwd xmm0,xmm0,xmm1
	vpslld xmm0,xmm0,8
	vpand xmm0,xmm0,xmm2
	
	vmovd dword ptr[edi],xmm0
	
	add dst,4
	add esi,8
	
Convert_12_RGB64toPlaneY32_AVX_5:
	mov edi,dst
	add esi,src_modulo
	add edi,dst_modulo
	mov dst,edi
	dec h
	jnz Convert_12_RGB64toPlaneY32_AVX_1

	pop ebx
	pop edi
	pop esi

	ret

JPSDR_HDRTools_Convert_12_RGB64toPlaneY32_AVX endp


JPSDR_HDRTools_Convert_16_RGB64toPlaneY32_SSE41 proc src:dword,dst:dword,w:dword,h:dword,
	lookup:dword,src_modulo:dword,dst_modulo:dword

	public JPSDR_HDRTools_Convert_16_RGB64toPlaneY32_SSE41

	local i,w0:dword

	push esi
	push edi
	push ebx

	pxor xmm1,xmm1
	pxor xmm0,xmm0

	mov eax,w
	shr eax,2
	mov w0,eax
	
	mov esi,src

Convert_16_RGB64toPlaneY32_SSE41_1:
	mov edi,lookup
	
	mov eax,w0
	or eax,eax
	jz Convert_16_RGB64toPlaneY32_SSE41_3
	
	mov i,eax
Convert_16_RGB64toPlaneY32_SSE41_2:
	movzx edx,word ptr[esi]
	movzx ecx,word ptr[esi+2]
	movzx ebx,word ptr[esi+4] ; ebx=R ecx=G edx=B
	mov eax,dword ptr[edi+4*ebx]
	add eax,dword ptr[edi+4*ecx+262144]
	add eax,dword ptr[edi+4*edx+524288]
	pinsrd xmm0,eax,0
	movzx edx,word ptr[esi+8]
	movzx ecx,word ptr[esi+10]
	movzx ebx,word ptr[esi+12] ; ebx=R ecx=G edx=B
	mov eax,dword ptr[edi+4*ebx]
	add eax,dword ptr[edi+4*ecx+262144]
	add eax,dword ptr[edi+4*edx+524288]
	pinsrd xmm0,eax,1
	movzx edx,word ptr[esi+16]
	movzx ecx,word ptr[esi+18]
	movzx ebx,word ptr[esi+20] ; ebx=R ecx=G edx=B
	mov eax,dword ptr[edi+4*ebx]
	add eax,dword ptr[edi+4*ecx+262144]
	add eax,dword ptr[edi+4*edx+524288]
	pinsrd xmm0,eax,2
	movzx edx,word ptr[esi+24]
	movzx ecx,word ptr[esi+26]
	movzx ebx,word ptr[esi+28] ; ebx=R ecx=G edx=B
	mov eax,dword ptr[edi+4*ebx]
	add eax,dword ptr[edi+4*ecx+262144]
	add eax,dword ptr[edi+4*edx+524288]
	mov edi,dst
	pinsrd xmm0,eax,3
	
	psrad xmm0,8
	packusdw xmm0,xmm1
	punpcklwd xmm0,xmm1
	
	movdqa XMMWORD ptr[edi],xmm0
	
	add dst,16
	add esi,32
	
	mov edi,lookup
	
	dec i
	jnz Convert_16_RGB64toPlaneY32_SSE41_2
	
Convert_16_RGB64toPlaneY32_SSE41_3:	
	test w,2
	jz Convert_16_RGB64toPlaneY32_SSE41_4
	
	movzx edx,word ptr[esi]
	movzx ecx,word ptr[esi+2]
	movzx ebx,word ptr[esi+4] ; ebx=R ecx=G edx=B
	mov eax,dword ptr[edi+4*ebx]
	add eax,dword ptr[edi+4*ecx+262144]
	add eax,dword ptr[edi+4*edx+524288]
	pinsrd xmm0,eax,0
	movzx edx,word ptr[esi+8]
	movzx ecx,word ptr[esi+10]
	movzx ebx,word ptr[esi+12] ; ebx=R ecx=G edx=B
	mov eax,dword ptr[edi+4*ebx]
	add eax,dword ptr[edi+4*ecx+262144]
	add eax,dword ptr[edi+4*edx+524288]
	mov edi,dst
	pinsrd xmm0,eax,1
	
	psrad xmm0,8
	packusdw xmm0,xmm1
	punpcklwd xmm0,xmm1
	
	movq qword ptr[edi],xmm0
	
	add dst,8
	add esi,16
	
	mov edi,lookup
	
Convert_16_RGB64toPlaneY32_SSE41_4:
	test w,1
	jz short Convert_16_RGB64toPlaneY32_SSE41_5

	movzx edx,word ptr[esi]
	movzx ecx,word ptr[esi+2]
	movzx ebx,word ptr[esi+4] ; ebx=R ecx=G edx=B
	mov eax,dword ptr[edi+4*ebx]
	add eax,dword ptr[edi+4*ecx+262144]
	add eax,dword ptr[edi+4*edx+524288]
	mov edi,dst
	pinsrd xmm0,eax,0
	
	psrad xmm0,8
	packusdw xmm0,xmm1
	punpcklwd xmm0,xmm1
	
	movd dword ptr[edi],xmm0
	
	add dst,4
	add esi,8
	
Convert_16_RGB64toPlaneY32_SSE41_5:
	mov edi,dst
	add esi,src_modulo
	add edi,dst_modulo
	mov dst,edi
	dec h
	jnz Convert_16_RGB64toPlaneY32_SSE41_1

	pop ebx
	pop edi
	pop esi

	ret

JPSDR_HDRTools_Convert_16_RGB64toPlaneY32_SSE41 endp


JPSDR_HDRTools_Convert_16_RGB64toPlaneY32_AVX proc src:dword,dst:dword,w:dword,h:dword,
	lookup:dword,src_modulo:dword,dst_modulo:dword

	public JPSDR_HDRTools_Convert_16_RGB64toPlaneY32_AVX

	local i,w0:dword

	push esi
	push edi
	push ebx

	vpxor xmm1,xmm1,xmm1
	vpxor xmm0,xmm0,xmm0

	mov eax,w
	shr eax,2
	mov w0,eax
	
	mov esi,src

Convert_16_RGB64toPlaneY32_AVX_1:
	mov edi,lookup
	
	mov eax,w0
	or eax,eax
	jz Convert_16_RGB64toPlaneY32_AVX_3
	
	mov i,eax
Convert_16_RGB64toPlaneY32_AVX_2:
	movzx edx,word ptr[esi]
	movzx ecx,word ptr[esi+2]
	movzx ebx,word ptr[esi+4] ; ebx=R ecx=G edx=B
	mov eax,dword ptr[edi+4*ebx]
	add eax,dword ptr[edi+4*ecx+262144]
	add eax,dword ptr[edi+4*edx+524288]
	vpinsrd xmm0,xmm0,eax,0
	movzx edx,word ptr[esi+8]
	movzx ecx,word ptr[esi+10]
	movzx ebx,word ptr[esi+12] ; ebx=R ecx=G edx=B
	mov eax,dword ptr[edi+4*ebx]
	add eax,dword ptr[edi+4*ecx+262144]
	add eax,dword ptr[edi+4*edx+524288]
	vpinsrd xmm0,xmm0,eax,1
	movzx edx,word ptr[esi+16]
	movzx ecx,word ptr[esi+18]
	movzx ebx,word ptr[esi+20] ; ebx=R ecx=G edx=B
	mov eax,dword ptr[edi+4*ebx]
	add eax,dword ptr[edi+4*ecx+262144]
	add eax,dword ptr[edi+4*edx+524288]
	vpinsrd xmm0,xmm0,eax,2
	movzx edx,word ptr[esi+24]
	movzx ecx,word ptr[esi+26]
	movzx ebx,word ptr[esi+28] ; ebx=R ecx=G edx=B
	mov eax,dword ptr[edi+4*ebx]
	add eax,dword ptr[edi+4*ecx+262144]
	add eax,dword ptr[edi+4*edx+524288]
	mov edi,dst
	vpinsrd xmm0,xmm0,eax,3
	
	vpsrad xmm0,xmm0,8
	vpackusdw xmm0,xmm0,xmm1
	vpunpcklwd xmm0,xmm0,xmm1
	
	vmovdqa XMMWORD ptr[edi],xmm0
	
	add dst,16
	add esi,32
	
	mov edi,lookup
	
	dec i
	jnz Convert_16_RGB64toPlaneY32_AVX_2
	
Convert_16_RGB64toPlaneY32_AVX_3:	
	test w,2
	jz Convert_16_RGB64toPlaneY32_AVX_4
	
	movzx edx,word ptr[esi]
	movzx ecx,word ptr[esi+2]
	movzx ebx,word ptr[esi+4] ; ebx=R ecx=G edx=B
	mov eax,dword ptr[edi+4*ebx]
	add eax,dword ptr[edi+4*ecx+262144]
	add eax,dword ptr[edi+4*edx+524288]
	vpinsrd xmm0,xmm0,eax,0
	movzx edx,word ptr[esi+8]
	movzx ecx,word ptr[esi+10]
	movzx ebx,word ptr[esi+12] ; ebx=R ecx=G edx=B
	mov eax,dword ptr[edi+4*ebx]
	add eax,dword ptr[edi+4*ecx+262144]
	add eax,dword ptr[edi+4*edx+524288]
	mov edi,dst
	vpinsrd xmm0,xmm0,eax,1
	
	vpsrad xmm0,xmm0,8
	vpackusdw xmm0,xmm0,xmm1
	vpunpcklwd xmm0,xmm0,xmm1
	
	vmovq qword ptr[edi],xmm0
	
	add dst,8
	add esi,16
	
	mov edi,lookup
	
Convert_16_RGB64toPlaneY32_AVX_4:
	test w,1
	jz short Convert_16_RGB64toPlaneY32_AVX_5

	movzx edx,word ptr[esi]
	movzx ecx,word ptr[esi+2]
	movzx ebx,word ptr[esi+4] ; ebx=R ecx=G edx=B
	mov eax,dword ptr[edi+4*ebx]
	add eax,dword ptr[edi+4*ecx+262144]
	add eax,dword ptr[edi+4*edx+524288]
	mov edi,dst
	vpinsrd xmm0,xmm0,eax,0
	
	vpsrad xmm0,xmm0,8
	vpackusdw xmm0,xmm0,xmm1
	vpunpcklwd xmm0,xmm0,xmm1
	
	vmovd dword ptr[edi],xmm0
	
	add dst,4
	add esi,8
	
Convert_16_RGB64toPlaneY32_AVX_5:
	mov edi,dst
	add esi,src_modulo
	add edi,dst_modulo
	mov dst,edi
	dec h
	jnz Convert_16_RGB64toPlaneY32_AVX_1

	pop ebx
	pop edi
	pop esi

	ret

JPSDR_HDRTools_Convert_16_RGB64toPlaneY32_AVX endp


JPSDR_HDRTools_Convert_RGB64_16toRGB64_8_SSE2 proc src:dword,dst:dword,w:dword,h:dword,
	src_pitch:dword,dst_pitch:dword

	public JPSDR_HDRTools_Convert_RGB64_16toRGB64_8_SSE2

	push esi
	push edi
	push ebx

	movdqa xmm1,XMMWORD ptr data_w_128

	mov esi,src
	mov edi,dst
	mov ebx,w
	shr ebx,1
	mov edx,16

Convert_RGB64_16toRGB64_8_SSE2_1:
	mov ecx,ebx
	xor eax,eax
	or ecx,ecx
	jz short Convert_RGB64_16toRGB64_8_SSE2_3
	
Convert_RGB64_16toRGB64_8_SSE2_2:
	movdqa xmm0,XMMWORD ptr[esi+eax]
	paddusw xmm0,xmm1
	psrlw xmm0,8
	movdqa XMMWORD ptr[edi+eax],xmm0
	add eax,edx
	loop Convert_RGB64_16toRGB64_8_SSE2_2
	
	test w,1
	jz short Convert_RGB64_16toRGB64_8_SSE2_4
	
Convert_RGB64_16toRGB64_8_SSE2_3:
	movq xmm0,qword ptr[esi+eax]
	paddusw xmm0,xmm1
	psrlw xmm0,8
	movq qword ptr[edi+eax],xmm0
	
Convert_RGB64_16toRGB64_8_SSE2_4:
	add esi,src_pitch
	add edi,dst_pitch
	dec h
	jnz short Convert_RGB64_16toRGB64_8_SSE2_1
	
	pop ebx
	pop edi
	pop esi

	ret

JPSDR_HDRTools_Convert_RGB64_16toRGB64_8_SSE2 endp


JPSDR_HDRTools_Convert_RGB64_16toRGB64_8_AVX proc src:dword,dst:dword,w:dword,h:dword,
	src_pitch:dword,dst_pitch:dword

	public JPSDR_HDRTools_Convert_RGB64_16toRGB64_8_AVX

	push esi
	push edi
	push ebx

	vmovdqa xmm1,XMMWORD ptr data_w_128

	mov esi,src
	mov edi,dst
	mov ebx,w
	shr ebx,1
	mov edx,16

Convert_RGB64_16toRGB64_8_AVX_1:
	mov ecx,ebx
	xor eax,eax
	or ecx,ecx
	jz short Convert_RGB64_16toRGB64_8_AVX_3
	
Convert_RGB64_16toRGB64_8_AVX_2:
	vmovdqa xmm0,XMMWORD ptr[esi+eax]
	vpaddusw xmm0,xmm0,xmm1
	vpsrlw xmm0,xmm0,8
	vmovdqa XMMWORD ptr[edi+eax],xmm0
	add eax,edx
	loop Convert_RGB64_16toRGB64_8_AVX_2

Convert_RGB64_16toRGB64_8_AVX_3:
	test w,1
	jz short Convert_RGB64_16toRGB64_8_AVX_4
	
	vmovq xmm0,qword ptr[esi+eax]
	vpaddusw xmm0,xmm0,xmm1
	vpsrlw xmm0,xmm0,8
	vmovq qword ptr[edi+eax],xmm0
	
Convert_RGB64_16toRGB64_8_AVX_4:
	add esi,src_pitch
	add edi,dst_pitch
	dec h
	jnz short Convert_RGB64_16toRGB64_8_AVX_1
	
	pop ebx
	pop edi
	pop esi

	ret

JPSDR_HDRTools_Convert_RGB64_16toRGB64_8_AVX endp	


JPSDR_HDRTools_Convert_RGB64_16toRGB64_10_SSE2 proc src:dword,dst:dword,w:dword,h:dword,
	src_pitch:dword,dst_pitch:dword

	public JPSDR_HDRTools_Convert_RGB64_16toRGB64_10_SSE2

	push esi
	push edi
	push ebx

	movdqa xmm1,XMMWORD ptr data_w_32

	mov esi,src
	mov edi,dst
	mov ebx,w
	shr ebx,1
	mov edx,16

Convert_RGB64_16toRGB64_10_SSE2_1:
	mov ecx,ebx
	xor eax,eax
	or ecx,ecx
	jz short Convert_RGB64_16toRGB64_10_SSE2_3
	
Convert_RGB64_16toRGB64_10_SSE2_2:
	movdqa xmm0,XMMWORD ptr[esi+eax]
	paddusw xmm0,xmm1
	psrlw xmm0,6
	movdqa XMMWORD ptr[edi+eax],xmm0
	add eax,edx
	loop Convert_RGB64_16toRGB64_10_SSE2_2
	
	test w,1
	jz short Convert_RGB64_16toRGB64_10_SSE2_4
	
Convert_RGB64_16toRGB64_10_SSE2_3:
	movq xmm0,qword ptr[esi+eax]
	paddusw xmm0,xmm1
	psrlw xmm0,6
	movq qword ptr[edi+eax],xmm0
	
Convert_RGB64_16toRGB64_10_SSE2_4:
	add esi,src_pitch
	add edi,dst_pitch
	dec h
	jnz short Convert_RGB64_16toRGB64_10_SSE2_1
	
	pop ebx
	pop edi
	pop esi

	ret

JPSDR_HDRTools_Convert_RGB64_16toRGB64_10_SSE2 endp
	
	
JPSDR_HDRTools_Convert_RGB64_16toRGB64_10_AVX proc src:dword,dst:dword,w:dword,h:dword,
	src_pitch:dword,dst_pitch:dword

	public JPSDR_HDRTools_Convert_RGB64_16toRGB64_10_AVX

	push esi
	push edi
	push ebx

	vmovdqa xmm1,XMMWORD ptr data_w_32

	mov esi,src
	mov edi,dst
	mov ebx,w
	shr ebx,1
	mov edx,16

Convert_RGB64_16toRGB64_10_AVX_1:
	mov ecx,ebx
	xor eax,eax
	or ecx,ecx
	jz short Convert_RGB64_16toRGB64_10_AVX_3
	
Convert_RGB64_16toRGB64_10_AVX_2:
	vmovdqa xmm0,XMMWORD ptr[esi+eax]
	vpaddusw xmm0,xmm0,xmm1
	vpsrlw xmm0,xmm0,6
	vmovdqa XMMWORD ptr[edi+eax],xmm0
	add eax,edx
	loop Convert_RGB64_16toRGB64_10_AVX_2

Convert_RGB64_16toRGB64_10_AVX_3:
	test w,1
	jz short Convert_RGB64_16toRGB64_10_AVX_4
	
	vmovq xmm0,qword ptr[esi+eax]
	vpaddusw xmm0,xmm0,xmm1
	vpsrlw xmm0,xmm0,6
	vmovq qword ptr[edi+eax],xmm0
	
Convert_RGB64_16toRGB64_10_AVX_4:
	add esi,src_pitch
	add edi,dst_pitch
	dec h
	jnz short Convert_RGB64_16toRGB64_10_AVX_1
	
	pop ebx
	pop edi
	pop esi

	ret

JPSDR_HDRTools_Convert_RGB64_16toRGB64_10_AVX endp	


JPSDR_HDRTools_Convert_RGB64_16toRGB64_12_SSE2 proc src:dword,dst:dword,w:dword,h:dword,
	src_pitch:dword,dst_pitch:dword

	public JPSDR_HDRTools_Convert_RGB64_16toRGB64_12_SSE2

	push esi
	push edi
	push ebx

	movdqa xmm1,XMMWORD ptr data_w_8

	mov esi,src
	mov edi,dst
	mov ebx,w
	shr ebx,1
	mov edx,16

Convert_RGB64_16toRGB64_12_SSE2_1:
	mov ecx,ebx
	xor eax,eax
	or ecx,ecx
	jz short Convert_RGB64_16toRGB64_12_SSE2_3
	
Convert_RGB64_16toRGB64_12_SSE2_2:
	movdqa xmm0,XMMWORD ptr[esi+eax]
	paddusw xmm0,xmm1
	psrlw xmm0,4
	movdqa XMMWORD ptr[edi+eax],xmm0
	add eax,edx
	loop Convert_RGB64_16toRGB64_12_SSE2_2
	
	test w,1
	jz short Convert_RGB64_16toRGB64_12_SSE2_4
	
Convert_RGB64_16toRGB64_12_SSE2_3:
	movq xmm0,qword ptr[esi+eax]
	paddusw xmm0,xmm1
	psrlw xmm0,4
	movq qword ptr[edi+eax],xmm0
	
Convert_RGB64_16toRGB64_12_SSE2_4:
	add esi,src_pitch
	add edi,dst_pitch
	dec h
	jnz short Convert_RGB64_16toRGB64_12_SSE2_1
	
	pop ebx
	pop edi
	pop esi

	ret

JPSDR_HDRTools_Convert_RGB64_16toRGB64_12_SSE2 endp
	
	
JPSDR_HDRTools_Convert_RGB64_16toRGB64_12_AVX proc src:dword,dst:dword,w:dword,h:dword,
	src_pitch:dword,dst_pitch:dword

	public JPSDR_HDRTools_Convert_RGB64_16toRGB64_12_AVX

	push esi
	push edi
	push ebx

	vmovdqa xmm1,XMMWORD ptr data_w_8

	mov esi,src
	mov edi,dst
	mov ebx,w
	shr ebx,1
	mov edx,16

Convert_RGB64_16toRGB64_12_AVX_1:
	mov ecx,ebx
	xor eax,eax
	or ecx,ecx
	jz short Convert_RGB64_16toRGB64_12_AVX_3
	
Convert_RGB64_16toRGB64_12_AVX_2:
	vmovdqa xmm0,XMMWORD ptr[esi+eax]
	vpaddusw xmm0,xmm0,xmm1
	vpsrlw xmm0,xmm0,4
	vmovdqa XMMWORD ptr[edi+eax],xmm0
	add eax,edx
	loop Convert_RGB64_16toRGB64_12_AVX_2

Convert_RGB64_16toRGB64_12_AVX_3:
	test w,1
	jz short Convert_RGB64_16toRGB64_12_AVX_4
	
	vmovq xmm0,qword ptr[esi+eax]
	vpaddusw xmm0,xmm0,xmm1
	vpsrlw xmm0,xmm0,4
	vmovq qword ptr[edi+eax],xmm0
	
Convert_RGB64_16toRGB64_12_AVX_4:
	add esi,src_pitch
	add edi,dst_pitch
	dec h
	jnz short Convert_RGB64_16toRGB64_12_AVX_1
	
	pop ebx
	pop edi
	pop esi

	ret

JPSDR_HDRTools_Convert_RGB64_16toRGB64_12_AVX endp	


JPSDR_HDRTools_Scale_HLG_SSE2 proc src:dword,dst:dword,w4:dword,h:dword,src_pitch:dword,dst_pitch:dword,
	Coeff:dword

	public JPSDR_HDRTools_Scale_HLG_SSE2

	push esi
	push edi
	push ebx
	
	mov esi,Coeff
	movss xmm1,dword ptr[esi]
	shufps xmm1,xmm1,0
	movaps xmm2,XMMWORD ptr data_f_1
	
	mov esi,src
	mov edi,dst
	mov ebx,w4
	mov edx,16
	
Scale_HLG_SSE2_1:
	mov ecx,ebx
	xor eax,eax
Scale_HLG_SSE2_2:	
	movaps xmm0,XMMWORD ptr [esi+eax]
	mulps xmm0,xmm1
	minps xmm0,xmm2
	movdqa XMMWORD ptr [edi+eax],xmm0
	
	add eax,edx
	loop Scale_HLG_SSE2_2
	
	add esi,src_pitch
	add edi,dst_pitch
	dec h
	jnz short Scale_HLG_SSE2_1
	
	pop ebx
	pop edi
	pop esi

	ret

JPSDR_HDRTools_Scale_HLG_SSE2 endp
	

JPSDR_HDRTools_Scale_HLG_AVX proc src:dword,dst:dword,w8:dword,h:dword,src_pitch:dword,dst_pitch:dword,
	Coeff:dword

	public JPSDR_HDRTools_Scale_HLG_AVX

	push esi
	push edi
	push ebx
	
	mov esi,Coeff
	vmovss xmm1,dword ptr[esi]
	vshufps xmm1,xmm1,xmm1,0
	vinsertf128 ymm1,ymm1,xmm1,1
	vmovaps ymm2,YMMWORD ptr data_f_1
	
	mov esi,src
	mov edi,dst
	mov ebx,w8
	mov edx,32
	
Scale_HLG_AVX_1:
	mov ecx,ebx
	xor eax,eax
Scale_HLG_AVX_2:	
	vmovaps ymm0,YMMWORD ptr [esi+eax]
	vmulps ymm0,ymm0,ymm1
	vminps ymm0,ymm0,ymm2
	vmovdqa YMMWORD ptr [edi+eax],ymm0
	
	add eax,edx
	loop Scale_HLG_AVX_2
	
	add esi,src_pitch
	add edi,dst_pitch
	dec h
	jnz short Scale_HLG_AVX_1
	
	vzeroupper
	
	pop ebx
	pop edi
	pop esi

	ret

JPSDR_HDRTools_Scale_HLG_AVX endp

	
JPSDR_HDRTools_Scale_20_float_SSE2 proc src:dword,dst:dword,w4:dword,h:dword,src_pitch:dword,dst_pitch:dword

	public JPSDR_HDRTools_Scale_20_float_SSE2

	push esi
	push edi
	push ebx
	
	movaps xmm1,XMMWORD ptr data_f_1048575
	
	mov esi,src
	mov edi,dst
	mov ebx,w4
	mov edx,16
	
Scale_20_float_SSE2_1:
	mov ecx,ebx
	xor eax,eax
Scale_20_float_SSE2_2:	
	movaps xmm0,XMMWORD ptr [esi+eax]
	mulps xmm0,xmm1
;	minps xmm0,xmm1
	cvtps2dq xmm0,xmm0
	movdqa XMMWORD ptr [edi+eax],xmm0
	
	add eax,edx
	loop Scale_20_float_SSE2_2
	
	add esi,src_pitch
	add edi,dst_pitch
	dec h
	jnz short Scale_20_float_SSE2_1
	
	pop ebx
	pop edi
	pop esi

	ret

JPSDR_HDRTools_Scale_20_float_SSE2 endp
	

JPSDR_HDRTools_Scale_20_float_AVX proc src:dword,dst:dword,w8:dword,h:dword,src_pitch:dword,dst_pitch:dword

	public JPSDR_HDRTools_Scale_20_float_AVX

	push esi
	push edi
	push ebx
	
	vmovaps ymm1,YMMWORD ptr data_f_1048575
	
	mov esi,src
	mov edi,dst
	mov ebx,w8
	mov edx,32
	
Scale_20_float_AVX_1:
	mov ecx,ebx
	xor eax,eax
Scale_20_float_AVX_2:	
	vmovaps ymm0,YMMWORD ptr [esi+eax]
	vmulps ymm0,ymm0,ymm1
;	vminps ymm0,ymm0,ymm1
	vcvtps2dq ymm0,ymm0
	vmovdqa YMMWORD ptr [edi+eax],ymm0
	
	add eax,edx
	loop Scale_20_float_AVX_2
	
	add esi,src_pitch
	add edi,dst_pitch
	dec h
	jnz short Scale_20_float_AVX_1
	
	vzeroupper
	
	pop ebx
	pop edi
	pop esi

	ret

JPSDR_HDRTools_Scale_20_float_AVX endp


JPSDR_HDRTools_Convert_RGBPStoPlaneY32F_SSE2 proc srcR:dword,srcG:dword,srcB:dword,dst:dword,w4:dword,h:dword,
	src_pitchR:dword,src_pitchG:dword,src_pitchB:dword,dst_pitch:dword,Coeff_R:dword,Coeff_G:dword,Coeff_B:dword
	
	public JPSDR_HDRTools_Convert_RGBPStoPlaneY32F_SSE2

	push esi
	push edi
	push ebx
	
	mov esi,Coeff_R
	movss xmm3,dword ptr[esi]
	shufps xmm3,xmm3,0
	mov esi,Coeff_G
	movss xmm4,dword ptr[esi]
	shufps xmm4,xmm4,0
	mov esi,Coeff_B
	movss xmm5,dword ptr[esi]
	shufps xmm5,xmm5,0
	
	mov edi,dst
	mov ebx,w4
	mov edx,16
	
Convert_RGBPStoPlaneY32F_SSE2_1:
	mov esi,srcR
	mov ecx,ebx
	xor eax,eax
Convert_RGBPStoPlaneY32F_SSE2_2:	
	movaps xmm0,XMMWORD ptr [esi+eax]
	mov esi,srcG
	movaps xmm1,XMMWORD ptr [esi+eax]
	mov esi,srcB
	movaps xmm2,XMMWORD ptr [esi+eax]
	mulps xmm0,xmm3
	mulps xmm1,xmm4
	mulps xmm2,xmm5
	addps xmm0,xmm1
	mov esi,srcR
	addps xmm0,xmm2
	movdqa XMMWORD ptr [edi+eax],xmm0
	
	add eax,edx
	loop Convert_RGBPStoPlaneY32F_SSE2_2
	
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
	jnz short Convert_RGBPStoPlaneY32F_SSE2_1
	
	pop ebx
	pop edi
	pop esi

	ret

JPSDR_HDRTools_Convert_RGBPStoPlaneY32F_SSE2 endp	
	

JPSDR_HDRTools_Convert_RGBPStoPlaneY32D_SSE2 proc srcR:dword,srcG:dword,srcB:dword,dst:dword,w4:dword,h:dword,
	src_pitchR:dword,src_pitchG:dword,src_pitchB:dword,dst_pitch:dword,Coeff_R:dword,Coeff_G:dword,Coeff_B:dword
	
	public JPSDR_HDRTools_Convert_RGBPStoPlaneY32D_SSE2

	push esi
	push edi
	push ebx
	
	mov esi,Coeff_R
	movss xmm3,dword ptr[esi]
	shufps xmm3,xmm3,0
	mov esi,Coeff_G
	movss xmm4,dword ptr[esi]
	shufps xmm4,xmm4,0
	mov esi,Coeff_B
	movss xmm5,dword ptr[esi]
	shufps xmm5,xmm5,0
	movaps xmm6,XMMWORD ptr data_f_1048575
	
	mov edi,dst
	mov ebx,w4
	mov edx,16
	
Convert_RGBPStoPlaneY32D_SSE2_1:
	mov esi,srcR
	mov ecx,ebx
	xor eax,eax
Convert_RGBPStoPlaneY32D_SSE2_2:	
	movaps xmm0,XMMWORD ptr [esi+eax]
	mov esi,srcG
	movaps xmm1,XMMWORD ptr [esi+eax]
	mov esi,srcB
	movaps xmm2,XMMWORD ptr [esi+eax]
	mulps xmm0,xmm3
	mulps xmm1,xmm4
	mulps xmm2,xmm5
	addps xmm0,xmm1
	mov esi,srcR
	addps xmm0,xmm2
	mulps xmm0,xmm6
	cvtps2dq xmm0,xmm0
	movdqa XMMWORD ptr [edi+eax],xmm0
	
	add eax,edx
	loop Convert_RGBPStoPlaneY32D_SSE2_2
	
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
	jnz short Convert_RGBPStoPlaneY32D_SSE2_1
	
	pop ebx
	pop edi
	pop esi

	ret

JPSDR_HDRTools_Convert_RGBPStoPlaneY32D_SSE2 endp


JPSDR_HDRTools_Convert_RGBPStoPlaneY32F_AVX proc srcR:dword,srcG:dword,srcB:dword,dst:dword,w8:dword,h:dword,
	src_pitchR:dword,src_pitchG:dword,src_pitchB:dword,dst_pitch:dword,Coeff_R:dword,Coeff_G:dword,Coeff_B:dword
	
	public JPSDR_HDRTools_Convert_RGBPStoPlaneY32F_AVX

	push esi
	push edi
	push ebx
	
	mov esi,Coeff_R
	vmovss xmm3,dword ptr[esi]
	vshufps xmm3,xmm3,xmm3,0
	vinsertf128 ymm3,ymm3,xmm3,1
	mov esi,Coeff_G
	vmovss xmm4,dword ptr[esi]
	vshufps xmm4,xmm4,xmm4,0
	vinsertf128 ymm4,ymm4,xmm4,1
	mov esi,Coeff_B
	vmovss xmm5,dword ptr[esi]
	vshufps xmm5,xmm5,xmm5,0
	vinsertf128 ymm5,ymm5,xmm5,1
	
	mov edi,dst
	mov ebx,w8
	mov edx,32
	
Convert_RGBPStoPlaneY32F_AVX_1:
	mov esi,srcR
	mov ecx,ebx
	xor eax,eax
Convert_RGBPStoPlaneY32F_AVX_2:	
	vmulps ymm0,ymm3,YMMWORD ptr [esi+eax]
	mov esi,srcG
	vmulps ymm1,ymm4,YMMWORD ptr [esi+eax]
	mov esi,srcB
	vmulps ymm2,ymm5,YMMWORD ptr [esi+eax]
	vaddps ymm0,ymm0,ymm1
	mov esi,srcR
	vaddps ymm0,ymm0,ymm2
	vmovdqa YMMWORD ptr [edi+eax],ymm0
	
	add eax,edx
	loop Convert_RGBPStoPlaneY32F_AVX_2
	
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
	jnz short Convert_RGBPStoPlaneY32F_AVX_1
	
	vzeroupper
	
	pop ebx
	pop edi
	pop esi

	ret

JPSDR_HDRTools_Convert_RGBPStoPlaneY32F_AVX endp	


JPSDR_HDRTools_Convert_RGBPStoPlaneY32D_AVX proc srcR:dword,srcG:dword,srcB:dword,dst:dword,w8:dword,h:dword,
	src_pitchR:dword,src_pitchG:dword,src_pitchB:dword,dst_pitch:dword,Coeff_R:dword,Coeff_G:dword,Coeff_B:dword
	
	public JPSDR_HDRTools_Convert_RGBPStoPlaneY32D_AVX

	push esi
	push edi
	push ebx
	
	mov esi,Coeff_R
	vmovss xmm3,dword ptr[esi]
	vshufps xmm3,xmm3,xmm3,0
	vinsertf128 ymm3,ymm3,xmm3,1
	mov esi,Coeff_G
	vmovss xmm4,dword ptr[esi]
	vshufps xmm4,xmm4,xmm4,0
	vinsertf128 ymm4,ymm4,xmm4,1
	mov esi,Coeff_B
	vmovss xmm5,dword ptr[esi]
	vshufps xmm5,xmm5,xmm5,0
	vinsertf128 ymm5,ymm5,xmm5,1
	vmovaps ymm6,YMMWORD ptr data_f_1048575
	
	mov edi,dst
	mov ebx,w8
	mov edx,32
	
Convert_RGBPStoPlaneY32D_AVX_1:
	mov esi,srcR
	mov ecx,ebx
	xor eax,eax
Convert_RGBPStoPlaneY32D_AVX_2:	
	vmulps ymm0,ymm3,YMMWORD ptr [esi+eax]
	mov esi,srcG
	vmulps ymm1,ymm4,YMMWORD ptr [esi+eax]
	mov esi,srcB
	vmulps ymm2,ymm5,YMMWORD ptr [esi+eax]
	vaddps ymm0,ymm0,ymm1
	mov esi,srcR
	vaddps ymm0,ymm0,ymm2
	vmulps ymm0,ymm0,ymm6
	vcvtps2dq ymm0,ymm0
	vmovdqa YMMWORD ptr [edi+eax],ymm0
	
	add eax,edx
	loop Convert_RGBPStoPlaneY32D_AVX_2
	
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
	jnz short Convert_RGBPStoPlaneY32D_AVX_1
	
	vzeroupper
	
	pop ebx
	pop edi
	pop esi

	ret

JPSDR_HDRTools_Convert_RGBPStoPlaneY32D_AVX endp


JPSDR_HDRTools_Convert_16_RGB64_HLG_OOTF_SSE41 proc dst:dword,srcY:dword,w:dword,h:dword,dst_pitch:dword,src_pitchY:dword

	public JPSDR_HDRTools_Convert_16_RGB64_HLG_OOTF_SSE41

	push esi
	push edi
	push ebx
	
	mov ebx,w
	shr ebx,1
	mov esi,srcY
	mov edi,dst
	mov edx,8
	pxor xmm4,xmm4
	
Convert_16_RGB64_HLG_OOTF_SSE41_1:
	mov ecx,ebx
	or ecx,ecx
	jz short Convert_16_RGB64_HLG_OOTF_SSE41_3
	
	xor eax,eax
Convert_16_RGB64_HLG_OOTF_SSE41_2:
	movss xmm0,dword ptr[esi+eax]
	movss xmm1,dword ptr[esi+eax+4]
	shufps xmm0,xmm0,0
	shufps xmm1,xmm1,0	
	movdqa xmm2,XMMWORD ptr[edi+2*eax]
	movdqa xmm3,xmm2
	punpcklwd xmm2,xmm4
	punpckhwd xmm3,xmm4
	cvtdq2ps xmm2,xmm2
	cvtdq2ps xmm3,xmm3
	mulps xmm2,xmm0
	mulps xmm3,xmm1
	cvtps2dq xmm2,xmm2
	cvtps2dq xmm3,xmm3
	packusdw xmm2,xmm3
	movdqa XMMWORD ptr[edi+2*eax],xmm2
	
	add eax,edx
	loop Convert_16_RGB64_HLG_OOTF_SSE41_2
	
Convert_16_RGB64_HLG_OOTF_SSE41_3:
	test w,1
	jz short Convert_16_RGB64_HLG_OOTF_SSE41_4
	
	movss xmm0,dword ptr[esi+eax]
	shufps xmm0,xmm0,0
	movq xmm2,qword ptr[edi+2*eax]
	punpcklwd xmm2,xmm4
	cvtdq2ps xmm2,xmm2
	mulps xmm2,xmm0
	cvtps2dq xmm2,xmm2
	packusdw xmm2,xmm2
	movq qword ptr[edi+2*eax],xmm2
	
Convert_16_RGB64_HLG_OOTF_SSE41_4:
	add edi,dst_pitch
	add esi,src_pitchY
	dec h
	jnz Convert_16_RGB64_HLG_OOTF_SSE41_1
	
	pop ebx
	pop edi
	pop esi

	ret

JPSDR_HDRTools_Convert_16_RGB64_HLG_OOTF_SSE41 endp


JPSDR_HDRTools_Convert_16_RGB64_HLG_OOTF_AVX proc dst:dword,srcY:dword,w:dword,h:dword,dst_pitch:dword,src_pitchY:dword

	public JPSDR_HDRTools_Convert_16_RGB64_HLG_OOTF_AVX

	push esi
	push edi
	push ebx
	
	mov ebx,w
	shr ebx,1
	mov esi,srcY
	mov edi,dst
	mov edx,8
	pxor xmm4,xmm4
	
Convert_16_RGB64_HLG_OOTF_AVX_1:
	mov ecx,ebx
	or ecx,ecx
	jz short Convert_16_RGB64_HLG_OOTF_AVX_3
	
	xor eax,eax
Convert_16_RGB64_HLG_OOTF_AVX_2:
	vmovss xmm0,dword ptr[esi+eax]
	vmovss xmm1,dword ptr[esi+eax+4]
	vshufps xmm0,xmm0,xmm0,0
	vshufps xmm1,xmm1,xmm1,0
	vmovdqa xmm2,XMMWORD ptr[edi+2*eax]
	vinsertf128 ymm0,ymm0,xmm1,1
	vpunpckhwd xmm3,xmm2,xmm4
	vpunpcklwd xmm2,xmm2,xmm4
	vinsertf128 ymm2,ymm2,xmm3,1
	vcvtdq2ps ymm2,ymm2
	vmulps ymm2,ymm2,ymm0
	vcvtps2dq ymm2,ymm2
	vextractf128 xmm3,ymm2,1
	vpackusdw xmm2,xmm2,xmm3
	vmovdqa XMMWORD ptr[edi+2*eax],xmm2
	
	add eax,edx
	loop Convert_16_RGB64_HLG_OOTF_AVX_2
	
Convert_16_RGB64_HLG_OOTF_AVX_3:
	test w,1
	jz short Convert_16_RGB64_HLG_OOTF_AVX_4
	
	vmovss xmm0,dword ptr[esi+eax]
	vshufps xmm0,xmm0,xmm0,0
	vmovq xmm2,qword ptr[edi+2*eax]
	vpunpcklwd xmm2,xmm2,xmm4
	vcvtdq2ps xmm2,xmm2
	vmulps xmm2,xmm2,xmm0
	vcvtps2dq xmm2,xmm2
	vpackusdw xmm2,xmm2,xmm2
	vmovq qword ptr[edi+2*eax],xmm2
	
Convert_16_RGB64_HLG_OOTF_AVX_4:
	add edi,dst_pitch
	add esi,src_pitchY
	dec h
	jnz Convert_16_RGB64_HLG_OOTF_AVX_1
	
	vzeroupper
	
	pop ebx
	pop edi
	pop esi

	ret

JPSDR_HDRTools_Convert_16_RGB64_HLG_OOTF_AVX endp


JPSDR_HDRTools_Convert_RGBPS_HLG_OOTF_SSE2 proc dstR:dword,dstG:dword,dstB:dword,srcY:dword,w4:dword,h:dword,
	dst_pitchR:dword,dst_pitchG:dword,dst_pitchB:dword,src_pitchY:dword

	public JPSDR_HDRTools_Convert_RGBPS_HLG_OOTF_SSE2

	push esi
	push edi
	push ebx
	
	mov edi,srcY
	mov ebx,w4
	mov edx,16
	
Convert_RGBPS_HLG_OOTF_SSE2_1:
	mov ecx,ebx
	xor eax,eax
Convert_RGBPS_HLG_OOTF_SSE2_2:
	mov esi,dstR
	movaps xmm0,XMMWORD ptr[edi+eax]
	
	movaps xmm1,XMMWORD ptr[esi+eax]
	mulps xmm1,xmm0
	movaps XMMWORD ptr[esi+eax],xmm1
	mov esi,dstG
	movaps xmm1,XMMWORD ptr[esi+eax]
	mulps xmm1,xmm0
	movaps XMMWORD ptr[esi+eax],xmm1
	mov esi,dstB
	movaps xmm1,XMMWORD ptr[esi+eax]
	mulps xmm1,xmm0
	movaps XMMWORD ptr[esi+eax],xmm1
	
	add eax,edx
	loop Convert_RGBPS_HLG_OOTF_SSE2_2
	
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
	
	jnz short Convert_RGBPS_HLG_OOTF_SSE2_1
	
	pop ebx
	pop edi
	pop esi

	ret

JPSDR_HDRTools_Convert_RGBPS_HLG_OOTF_SSE2 endp
	

JPSDR_HDRTools_Convert_RGBPS_HLG_OOTF_AVX proc dstR:dword,dstG:dword,dstB:dword,srcY:dword,w8:dword,h:dword,
	dst_pitchR:dword,dst_pitchG:dword,dst_pitchB:dword,src_pitchY:dword

	public JPSDR_HDRTools_Convert_RGBPS_HLG_OOTF_AVX

	push esi
	push edi
	push ebx
	
	mov edi,srcY
	mov ebx,w8
	mov edx,32
	
Convert_RGBPS_HLG_OOTF_AVX_1:
	mov ecx,ebx
	xor eax,eax
Convert_RGBPS_HLG_OOTF_AVX_2:
	mov esi,dstR
	vmovaps ymm0,YMMWORD ptr[edi+eax]
	
	vmulps ymm1,ymm0,YMMWORD ptr[esi+eax]
	vmovaps YMMWORD ptr[esi+eax],ymm1
	mov esi,dstG
	vmulps ymm1,ymm0,YMMWORD ptr[esi+eax]
	vmovaps YMMWORD ptr[esi+eax],ymm1
	mov esi,dstB
	vmulps ymm1,ymm0,YMMWORD ptr[esi+eax]
	vmovaps YMMWORD ptr[esi+eax],ymm1
	
	add eax,edx
	loop Convert_RGBPS_HLG_OOTF_AVX_2
	
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
	
	jnz short Convert_RGBPS_HLG_OOTF_AVX_1
	
	vzeroupper
	
	pop ebx
	pop edi
	pop esi

	ret

JPSDR_HDRTools_Convert_RGBPS_HLG_OOTF_AVX endp


JPSDR_HDRTools_Convert_RGBPS_HLG_OOTF_Scale_SSE2 proc dstR:dword,dstG:dword,dstB:dword,srcY:dword,w4:dword,h:dword,
	dst_pitchR:dword,dst_pitchG:dword,dst_pitchB:dword,src_pitchY:dword

	public JPSDR_HDRTools_Convert_RGBPS_HLG_OOTF_Scale_SSE2

	push esi
	push edi
	push ebx
	
	movaps xmm2,XMMWORD ptr data_f_1
	
	mov edi,srcY
	mov ebx,w4
	mov edx,16
	
Convert_RGBPS_HLG_OOTF_Scale_SSE2_1:
	mov ecx,ebx
	xor eax,eax
Convert_RGBPS_HLG_OOTF_Scale_SSE2_2:
	mov esi,dstR
	movaps xmm0,XMMWORD ptr[edi+eax]
	
	movaps xmm1,XMMWORD ptr[esi+eax]
	mulps xmm1,xmm0
	minps xmm1,xmm2
	movaps XMMWORD ptr[esi+eax],xmm1
	mov esi,dstG
	movaps xmm1,XMMWORD ptr[esi+eax]
	mulps xmm1,xmm0
	minps xmm1,xmm2
	movaps XMMWORD ptr[esi+eax],xmm1
	mov esi,dstB
	movaps xmm1,XMMWORD ptr[esi+eax]
	mulps xmm1,xmm0
	minps xmm1,xmm2
	movaps XMMWORD ptr[esi+eax],xmm1
	
	add eax,edx
	loop Convert_RGBPS_HLG_OOTF_Scale_SSE2_2
	
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
	
	jnz short Convert_RGBPS_HLG_OOTF_Scale_SSE2_1
	
	pop ebx
	pop edi
	pop esi

	ret

JPSDR_HDRTools_Convert_RGBPS_HLG_OOTF_Scale_SSE2 endp

	
JPSDR_HDRTools_Convert_RGBPS_HLG_OOTF_Scale_AVX proc dstR:dword,dstG:dword,dstB:dword,srcY:dword,w8:dword,h:dword,
	dst_pitchR:dword,dst_pitchG:dword,dst_pitchB:dword,src_pitchY:dword

	public JPSDR_HDRTools_Convert_RGBPS_HLG_OOTF_Scale_AVX

	push esi
	push edi
	push ebx
	
	vmovaps ymm2,YMMWORD ptr data_f_1
	
	mov edi,srcY
	mov ebx,w8
	mov edx,32
	
Convert_RGBPS_HLG_OOTF_Scale_AVX_1:
	mov ecx,ebx
	xor eax,eax
Convert_RGBPS_HLG_OOTF_Scale_AVX_2:
	mov esi,dstR
	vmovaps ymm0,YMMWORD ptr[edi+eax]
	
	vmulps ymm1,ymm0,YMMWORD ptr[esi+eax]
	vminps ymm1,ymm1,ymm2
	vmovaps YMMWORD ptr[esi+eax],ymm1
	mov esi,dstG
	vmulps ymm1,ymm0,YMMWORD ptr[esi+eax]
	vminps ymm1,ymm1,ymm2
	vmovaps YMMWORD ptr[esi+eax],ymm1
	mov esi,dstB
	vmulps ymm1,ymm0,YMMWORD ptr[esi+eax]
	vminps ymm1,ymm1,ymm2
	vmovaps YMMWORD ptr[esi+eax],ymm1
	
	add eax,edx
	loop Convert_RGBPS_HLG_OOTF_Scale_AVX_2
	
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
	
	jnz short Convert_RGBPS_HLG_OOTF_Scale_AVX_1
	
	vzeroupper
	
	pop ebx
	pop edi
	pop esi

	ret

JPSDR_HDRTools_Convert_RGBPS_HLG_OOTF_Scale_AVX endp
	
	
;***************************************************
;**           XYZ/HDR/SDR functions               **
;***************************************************


JPSDR_HDRTools_Scale_20_XYZ_SSE2 proc src:dword,dst:dword,w4:dword,h:dword,src_pitch:dword,dst_pitch:dword,
	ValMin:dword,Coeff:dword

	public JPSDR_HDRTools_Scale_20_XYZ_SSE2

	push esi
	push edi
	push ebx
	
	mov esi,ValMin
	movss xmm1,dword ptr[esi]
	shufps xmm1,xmm1,0
	mov esi,Coeff
	movss xmm2,dword ptr[esi]
	shufps xmm2,xmm2,0
	
	movaps xmm3,XMMWORD ptr data_f_1048575
	movaps xmm4,XMMWORD ptr data_f_0
	mulps xmm2,xmm3
	
	mov esi,src
	mov edi,dst
	mov ebx,w4
	mov edx,16
	
Scale_20_XYZ_SSE2_1:
	mov ecx,ebx
	xor eax,eax
Scale_20_XYZ_SSE2_2:	
	movaps xmm0,XMMWORD ptr[esi+eax]
	addps xmm0,xmm1
	mulps xmm0,xmm2
	minps xmm0,xmm3
	maxps xmm0,xmm4
	cvtps2dq xmm0,xmm0
	movdqa XMMWORD ptr[edi+eax],xmm0
	
	add eax,edx
	loop Scale_20_XYZ_SSE2_2
	
	add esi,src_pitch
	add edi,dst_pitch
	dec h
	jnz short Scale_20_XYZ_SSE2_1
	
	pop ebx
	pop edi
	pop esi

	ret

JPSDR_HDRTools_Scale_20_XYZ_SSE2 endp
	

JPSDR_HDRTools_Scale_20_XYZ_SSE41 proc src:dword,dst:dword,w4:dword,h:dword,src_pitch:dword,dst_pitch:dword,
	ValMin:dword,Coeff:dword

	public JPSDR_HDRTools_Scale_20_XYZ_SSE41

	push esi
	push edi
	push ebx
	
	mov esi,ValMin
	movss xmm1,dword ptr[esi]
	shufps xmm1,xmm1,0
	mov esi,Coeff
	movss xmm2,dword ptr[esi]
	shufps xmm2,xmm2,0
	
	movdqa xmm3,XMMWORD ptr data_dw_1048575
	movdqa xmm4,XMMWORD ptr data_dw_0
	mulps xmm2,XMMWORD ptr data_f_1048575
	
	mov esi,src
	mov edi,dst
	mov ebx,w4
	mov edx,16
	
Scale_20_XYZ_SSE41_1:
	mov ecx,ebx
	xor eax,eax
Scale_20_XYZ_SSE41_2:	
	movaps xmm0,XMMWORD ptr[esi+eax]
	addps xmm0,xmm1
	mulps xmm0,xmm2
	cvtps2dq xmm0,xmm0
	pminsd xmm0,xmm3
	pmaxsd xmm0,xmm4
	movdqa XMMWORD ptr[edi+eax],xmm0
	
	add eax,edx
	loop Scale_20_XYZ_SSE41_2
	
	add esi,src_pitch
	add edi,dst_pitch
	dec h
	jnz short Scale_20_XYZ_SSE41_1
	
	pop ebx
	pop edi
	pop esi

	ret

JPSDR_HDRTools_Scale_20_XYZ_SSE41 endp


JPSDR_HDRTools_Scale_20_XYZ_AVX proc src:dword,dst:dword,w8:dword,h:dword,src_pitch:dword,dst_pitch:dword,
	ValMin:dword,Coeff:dword

	public JPSDR_HDRTools_Scale_20_XYZ_AVX

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
	
	vmovaps ymm3,YMMWORD ptr data_f_1048575
	vmovaps ymm4,YMMWORD ptr data_f_0
	vmulps ymm2,ymm2,ymm3
	
	mov esi,src
	mov edi,dst
	mov ebx,w8
	mov edx,32
	
Scale_20_XYZ_AVX_1:
	mov ecx,ebx
	xor eax,eax
Scale_20_XYZ_AVX_2:	
	vaddps ymm0,ymm1,YMMWORD ptr[esi+eax]
	vmulps ymm0,ymm0,ymm2
	vminps ymm0,ymm0,ymm3
	vmaxps ymm0,ymm0,ymm4
	vcvtps2dq ymm0,ymm0
	vmovdqa YMMWORD ptr[edi+eax],ymm0
	
	add eax,edx
	loop Scale_20_XYZ_AVX_2
	
	add esi,src_pitch
	add edi,dst_pitch
	dec h
	jnz short Scale_20_XYZ_AVX_1
	
	vzeroupper
	
	pop ebx
	pop edi
	pop esi

	ret

JPSDR_HDRTools_Scale_20_XYZ_AVX endp


JPSDR_HDRTools_Scale_20_RGB_SSE2 proc src:dword,dst:dword,w4:dword,h:dword,src_pitch:dword,dst_pitch:dword

	public JPSDR_HDRTools_Scale_20_RGB_SSE2

	push esi
	push edi
	push ebx
	
	movaps xmm1,XMMWORD ptr data_f_1048575
	movaps xmm2,XMMWORD ptr data_f_0
	
	mov esi,src
	mov edi,dst
	mov ebx,w4
	mov edx,16
	
Scale_20_RGB_SSE2_1:
	mov ecx,ebx
	xor eax,eax
Scale_20_RGB_SSE2_2:	
	movaps xmm0,XMMWORD ptr[esi+eax]
	mulps xmm0,xmm1
	minps xmm0,xmm1
	maxps xmm0,xmm2
	cvtps2dq xmm0,xmm0
	movdqa XMMWORD ptr[edi+eax],xmm0
	
	add eax,edx
	loop Scale_20_RGB_SSE2_2
	
	add esi,src_pitch
	add edi,dst_pitch
	dec h
	jnz short Scale_20_RGB_SSE2_1
	
	pop ebx
	pop edi
	pop esi

	ret

JPSDR_HDRTools_Scale_20_RGB_SSE2 endp


JPSDR_HDRTools_Scale_20_RGB_SSE41 proc src:dword,dst:dword,w4:dword,h:dword,src_pitch:dword,dst_pitch:dword

	public JPSDR_HDRTools_Scale_20_RGB_SSE41

	push esi
	push edi
	push ebx
	
	movaps xmm1,XMMWORD ptr data_f_1048575
	movdqa xmm2,XMMWORD ptr data_dw_1048575
	movdqa xmm3,XMMWORD ptr data_dw_0
	
	mov esi,src
	mov edi,dst
	mov ebx,w4
	mov edx,16
	
Scale_20_RGB_SSE41_1:
	mov ecx,ebx
	xor eax,eax
Scale_20_RGB_SSE41_2:	
	movaps xmm0,XMMWORD ptr[esi+eax]
	mulps xmm0,xmm1
	cvtps2dq xmm0,xmm0
	pminsd xmm0,xmm2
	pmaxsd xmm0,xmm3
	movdqa XMMWORD ptr[edi+eax],xmm0
	
	add eax,edx
	loop Scale_20_RGB_SSE41_2
	
	add esi,src_pitch
	add edi,dst_pitch
	dec h
	jnz short Scale_20_RGB_SSE41_1
	
	pop ebx
	pop edi
	pop esi

	ret

JPSDR_HDRTools_Scale_20_RGB_SSE41 endp


JPSDR_HDRTools_Scale_20_RGB_AVX proc src:dword,dst:dword,w8:dword,h:dword,src_pitch:dword,dst_pitch:dword

	public JPSDR_HDRTools_Scale_20_RGB_AVX

	push esi
	push edi
	push ebx
	
	vmovaps ymm1,YMMWORD ptr data_f_1048575
	vmovaps ymm2,YMMWORD ptr data_f_0
	
	mov esi,src
	mov edi,dst
	mov ebx,w8
	mov edx,32
	
Scale_20_RGB_AVX_1:
	mov ecx,ebx
	xor eax,eax
Scale_20_RGB_AVX_2:	
	vmulps ymm0,ymm1,YMMWORD ptr[esi+eax]
	vminps ymm0,ymm0,ymm1
	vmaxps ymm0,ymm0,ymm2
	vcvtps2dq ymm0,ymm0
	vmovdqa YMMWORD ptr[edi+eax],ymm0
	
	add eax,edx
	loop Scale_20_RGB_AVX_2
	
	add esi,src_pitch
	add edi,dst_pitch
	dec h
	jnz short Scale_20_RGB_AVX_1
	
	vzeroupper
	
	pop ebx
	pop edi
	pop esi

	ret

JPSDR_HDRTools_Scale_20_RGB_AVX endp

	
JPSDR_HDRTools_Convert_XYZ_HDRtoSDR_32_SSE2 proc src:dword,dst:dword,w4:dword,h:dword,src_pitch:dword,dst_pitch:dword,
	Coeff:dword

	public JPSDR_HDRTools_Convert_XYZ_HDRtoSDR_32_SSE2

	push esi
	push edi
	push ebx
	
	mov esi,Coeff
	movss xmm1,dword ptr[esi]
	shufps xmm1,xmm1,0
	
	mov esi,src
	mov edi,dst
	mov ebx,w4
	mov edx,16
	
Convert_XYZ_HDRtoSDR_32_SSE2_1:
	mov ecx,ebx
	xor eax,eax
Convert_XYZ_HDRtoSDR_32_SSE2_2:	
	movaps xmm0,XMMWORD ptr[esi+eax]
	mulps xmm0,xmm1
	movaps XMMWORD ptr[edi+eax],xmm0
	
	add eax,edx
	loop Convert_XYZ_HDRtoSDR_32_SSE2_2
	
	add esi,src_pitch
	add edi,dst_pitch
	dec h
	jnz short Convert_XYZ_HDRtoSDR_32_SSE2_1
	
	pop ebx
	pop edi
	pop esi

	ret

JPSDR_HDRTools_Convert_XYZ_HDRtoSDR_32_SSE2 endp
	

JPSDR_HDRTools_Convert_XYZ_HDRtoSDR_32_AVX proc src:dword,dst:dword,w8:dword,h:dword,src_pitch:dword,dst_pitch:dword,
	Coeff:dword

	public JPSDR_HDRTools_Convert_XYZ_HDRtoSDR_32_AVX

	push esi
	push edi
	push ebx
	
	mov esi,Coeff
	vmovss xmm1,dword ptr[esi]
	vshufps xmm1,xmm1,xmm1,0
	vinsertf128 ymm1,ymm1,xmm1,1
	
	mov esi,src
	mov edi,dst
	mov ebx,w8
	mov edx,32
	
Convert_XYZ_HDRtoSDR_32_AVX_1:
	mov ecx,ebx
	xor eax,eax
Convert_XYZ_HDRtoSDR_32_AVX_2:	
	vmulps ymm0,ymm1,YMMWORD ptr[esi+eax]
	vmovaps YMMWORD ptr[edi+eax],ymm0
	
	add eax,edx
	loop Convert_XYZ_HDRtoSDR_32_AVX_2
	
	add esi,src_pitch
	add edi,dst_pitch
	dec h
	jnz short Convert_XYZ_HDRtoSDR_32_AVX_1
	
	vzeroupper
	
	pop ebx
	pop edi
	pop esi

	ret

JPSDR_HDRTools_Convert_XYZ_HDRtoSDR_32_AVX endp	


JPSDR_HDRTools_Convert_XYZ_SDRtoHDR_32_SSE2 proc src:dword,dst:dword,w4:dword,h:dword,src_pitch:dword,dst_pitch:dword,
	Coeff:dword

	public JPSDR_HDRTools_Convert_XYZ_SDRtoHDR_32_SSE2

	push esi
	push edi
	push ebx
	
	mov esi,Coeff
	movss xmm1,dword ptr[esi]
	shufps xmm1,xmm1,0
	
	mov esi,src
	mov edi,dst
	mov ebx,w4
	mov edx,16
	
Convert_XYZ_SDRtoHDR_32_SSE2_1:
	mov ecx,ebx
	xor eax,eax
Convert_XYZ_SDRtoHDR_32_SSE2_2:	
	movaps xmm0,XMMWORD ptr[esi+eax]
	mulps xmm0,xmm1
	movaps XMMWORD ptr[edi+eax],xmm0
	
	add eax,edx
	loop Convert_XYZ_SDRtoHDR_32_SSE2_2
	
	add esi,src_pitch
	add edi,dst_pitch
	dec h
	jnz short Convert_XYZ_SDRtoHDR_32_SSE2_1
	
	pop ebx
	pop edi
	pop esi

	ret

JPSDR_HDRTools_Convert_XYZ_SDRtoHDR_32_SSE2 endp


JPSDR_HDRTools_Convert_XYZ_SDRtoHDR_32_AVX proc src:dword,dst:dword,w8:dword,h:dword,src_pitch:dword,dst_pitch:dword,
	Coeff:dword

	public JPSDR_HDRTools_Convert_XYZ_SDRtoHDR_32_AVX

	push esi
	push edi
	push ebx
	
	mov esi,Coeff
	vmovss xmm1,dword ptr[esi]
	vshufps xmm1,xmm1,xmm1,0
	vinsertf128 ymm1,ymm1,xmm1,1
	
	mov esi,src
	mov edi,dst
	mov ebx,w8
	mov edx,32
	
Convert_XYZ_SDRtoHDR_32_AVX_1:
	mov ecx,ebx
	xor eax,eax
Convert_XYZ_SDRtoHDR_32_AVX_2:	
	vmulps ymm0,ymm1,YMMWORD ptr[esi+eax]
	vmovaps YMMWORD ptr[edi+eax],ymm0
	
	add eax,edx
	loop Convert_XYZ_SDRtoHDR_32_AVX_2
	
	add esi,src_pitch
	add edi,dst_pitch
	dec h
	jnz short Convert_XYZ_SDRtoHDR_32_AVX_1
	
	vzeroupper
	
	pop ebx
	pop edi
	pop esi

	ret

JPSDR_HDRTools_Convert_XYZ_SDRtoHDR_32_AVX endp


JPSDR_HDRTools_Convert_XYZ_Hable_HDRtoSDR_SSE2 proc src:dword,dst:dword,w4:dword,h:dword,src_pitch:dword,dst_pitch:dword,
	Coeff1:dword,Coeff2:dword,Coeff3:dword,Coeff4:dword,Coeff5:dword,Coeff6:dword

	public JPSDR_HDRTools_Convert_XYZ_Hable_HDRtoSDR_SSE2

	push esi
	push edi
	push ebx
	
	mov esi,Coeff1
	movss xmm2,dword ptr[esi]
	shufps xmm2,xmm2,0
	mov esi,Coeff2
	movss xmm3,dword ptr[esi]
	shufps xmm3,xmm3,0
	mov esi,Coeff3
	movss xmm4,dword ptr[esi]
	shufps xmm4,xmm4,0
	mov esi,Coeff4
	movss xmm5,dword ptr[esi]
	shufps xmm5,xmm5,0
	mov esi,Coeff5
	movss xmm6,dword ptr[esi]
	shufps xmm6,xmm6,0
	mov esi,Coeff6
	movss xmm7,dword ptr[esi]
	shufps xmm7,xmm7,0
	
	mov esi,src
	mov edi,dst
	mov ebx,w4
	mov edx,16
	
Convert_XYZ_Hable_HDRtoSDR_SSE2_1:
	mov ecx,ebx
	xor eax,eax
Convert_XYZ_Hable_HDRtoSDR_SSE2_2:	
	movaps xmm0,XMMWORD ptr[esi+eax]
	
	movaps xmm1,xmm0
	mulps xmm1,xmm2
	addps xmm1,xmm5
	mulps xmm1,xmm0
	addps xmm1,xmm6
	
	mulps xmm0,xmm2
	addps xmm0,xmm3
	mulps xmm0,XMMWORD ptr[esi+eax]
	addps xmm0,xmm4
	divps xmm0,xmm1
	subps xmm0,xmm7
	
	movaps XMMWORD ptr[edi+eax],xmm0
	
	add eax,edx
	loop Convert_XYZ_Hable_HDRtoSDR_SSE2_2
	
	add esi,src_pitch
	add edi,dst_pitch
	dec h
	jnz short Convert_XYZ_Hable_HDRtoSDR_SSE2_1
	
	pop ebx
	pop edi
	pop esi

	ret

JPSDR_HDRTools_Convert_XYZ_Hable_HDRtoSDR_SSE2 endp


JPSDR_HDRTools_Convert_XYZ_Hable_HDRtoSDR_AVX proc src:dword,dst:dword,w8:dword,h:dword,src_pitch:dword,dst_pitch:dword,
	Coeff1:dword,Coeff2:dword,Coeff3:dword,Coeff4:dword,Coeff5:dword,Coeff6:dword

	public JPSDR_HDRTools_Convert_XYZ_Hable_HDRtoSDR_AVX

	push esi
	push edi
	push ebx
	
	mov esi,Coeff1
	vmovss xmm2,dword ptr[esi]
	vshufps xmm2,xmm2,xmm2,0
	vinsertf128 ymm2,ymm2,xmm2,1
	mov esi,Coeff2
	vmovss xmm3,dword ptr[esi]
	vshufps xmm3,xmm3,xmm3,0
	vinsertf128 ymm3,ymm3,xmm3,1
	mov esi,Coeff3
	vmovss xmm4,dword ptr[esi]
	vshufps xmm4,xmm4,xmm4,0
	vinsertf128 ymm4,ymm4,xmm4,1
	mov esi,Coeff4
	vmovss xmm5,dword ptr[esi]
	vshufps xmm5,xmm5,xmm5,0
	vinsertf128 ymm5,ymm5,xmm5,1
	mov esi,Coeff5
	vmovss xmm6,dword ptr[esi]
	vshufps xmm6,xmm6,xmm6,0
	vinsertf128 ymm6,ymm6,xmm6,1
	mov esi,Coeff6
	vmovss xmm7,dword ptr[esi]
	vshufps xmm7,xmm7,xmm7,0
	vinsertf128 ymm7,ymm7,xmm7,1
	
	mov esi,src
	mov edi,dst
	mov ebx,w8
	mov edx,32
	
Convert_XYZ_Hable_HDRtoSDR_AVX_1:
	mov ecx,ebx
	xor eax,eax
Convert_XYZ_Hable_HDRtoSDR_AVX_2:
	vmovaps ymm0,YMMWORD ptr[esi+eax]
	
	vmulps ymm1,ymm0,ymm2
	vaddps ymm1,ymm1,ymm5
	vmulps ymm1,ymm1,ymm0
	vaddps ymm1,ymm1,ymm6
	
	vmulps ymm0,ymm0,ymm2
	vaddps ymm0,ymm0,ymm3
	vmulps ymm0,ymm0,YMMWORD ptr[esi+eax]
	vaddps ymm0,ymm0,ymm4
	vdivps ymm0,ymm0,ymm1
	vsubps ymm0,ymm0,ymm7
	
	vmovaps YMMWORD ptr[edi+eax],ymm0
	
	add eax,edx
	loop Convert_XYZ_Hable_HDRtoSDR_AVX_2
	
	add esi,src_pitch
	add edi,dst_pitch
	dec h
	jnz short Convert_XYZ_Hable_HDRtoSDR_AVX_1
	
	vzeroupper
	
	pop ebx
	pop edi
	pop esi

	ret

JPSDR_HDRTools_Convert_XYZ_Hable_HDRtoSDR_AVX endp


JPSDR_HDRTools_Convert_XYZ_Mobius_HDRtoSDR_SSE2 proc src:dword,dst:dword,w4:dword,h:dword,src_pitch:dword,dst_pitch:dword,
	Coeff1:dword,Coeff2:dword,Coeff3:dword,Coeff4:dword

	public JPSDR_HDRTools_Convert_XYZ_Mobius_HDRtoSDR_SSE2

	push esi
	push edi
	push ebx
	
	mov esi,Coeff1
	movss xmm4,dword ptr[esi]
	shufps xmm4,xmm4,0
	mov esi,Coeff2
	movss xmm5,dword ptr[esi]
	shufps xmm5,xmm5,0
	mov esi,Coeff3
	movss xmm6,dword ptr[esi]
	shufps xmm6,xmm6,0
	mov esi,Coeff4
	movss xmm7,dword ptr[esi]
	shufps xmm7,xmm7,0
	
	mov esi,src
	mov edi,dst
	mov ebx,w4
	mov edx,16
	
Convert_XYZ_Mobius_HDRtoSDR_SSE2_1:
	mov ecx,ebx
	xor eax,eax
Convert_XYZ_Mobius_HDRtoSDR_SSE2_2:	
	movaps xmm0,XMMWORD ptr[esi+eax]
	
	movaps xmm3,xmm0
	movaps xmm2,xmm0
	movaps xmm1,xmm0
	cmpleps xmm2,xmm4
	addps xmm1,xmm7
	addps xmm0,xmm6
	divps xmm0,xmm1
	andps xmm3,xmm2
	xorps xmm2,XMMWORD ptr data_all_1
	andps xmm0,xmm2
	orps xmm0,xmm3
	
	movaps XMMWORD ptr [edi+eax],xmm0
	
	add eax,edx
	loop Convert_XYZ_Mobius_HDRtoSDR_SSE2_2
	
	add esi,src_pitch
	add edi,dst_pitch
	dec h
	jnz short Convert_XYZ_Mobius_HDRtoSDR_SSE2_1
	
	pop ebx
	pop edi
	pop esi

	ret

JPSDR_HDRTools_Convert_XYZ_Mobius_HDRtoSDR_SSE2 endp


JPSDR_HDRTools_Convert_XYZ_Mobius_HDRtoSDR_AVX proc src:dword,dst:dword,w8:dword,h:dword,src_pitch:dword,dst_pitch:dword,
	Coeff1:dword,Coeff2:dword,Coeff3:dword,Coeff4:dword

	public JPSDR_HDRTools_Convert_XYZ_Mobius_HDRtoSDR_AVX

	push esi
	push edi
	push ebx
	
	mov esi,Coeff1
	vmovss xmm4,dword ptr[esi]
	vshufps xmm4,xmm4,xmm4,0
	vinsertf128 ymm4,ymm4,xmm4,1
	mov esi,Coeff2
	vmovss xmm5,dword ptr[esi]
	vshufps xmm5,xmm5,xmm5,0
	vinsertf128 ymm5,ymm5,xmm5,1
	mov esi,Coeff3
	vmovss xmm6,dword ptr[esi]
	vshufps xmm6,xmm6,xmm6,0
	vinsertf128 ymm6,ymm6,xmm6,1
	mov esi,Coeff4
	vmovss xmm7,dword ptr[esi]
	vshufps xmm7,xmm7,xmm7,0
	vinsertf128 ymm7,ymm7,xmm7,1
	
	mov esi,src
	mov edi,dst
	mov ebx,w8
	mov edx,32
	
Convert_XYZ_Mobius_HDRtoSDR_AVX_1:
	mov ecx,ebx
	xor eax,eax
Convert_XYZ_Mobius_HDRtoSDR_AVX_2:
	vmovaps ymm0,YMMWORD ptr[esi+eax]
	
	vcmpleps ymm2,ymm0,ymm4
	vaddps ymm1,ymm0,ymm7
	vaddps ymm3,ymm0,ymm6
	vdivps ymm3,ymm3,ymm1
	vandps ymm0,ymm0,ymm2
	vxorps ymm2,ymm2,YMMWORD ptr data_all_1
	vandps ymm3,ymm3,ymm2
	vorps ymm0,ymm0,ymm3
	
	vmovaps YMMWORD ptr [edi+eax],ymm0
	
	add eax,edx
	loop Convert_XYZ_Mobius_HDRtoSDR_AVX_2
	
	add esi,src_pitch
	add edi,dst_pitch
	dec h
	jnz short Convert_XYZ_Mobius_HDRtoSDR_AVX_1
	
	vzeroupper
	
	pop ebx
	pop edi
	pop esi

	ret

JPSDR_HDRTools_Convert_XYZ_Mobius_HDRtoSDR_AVX endp


JPSDR_HDRTools_Convert_XYZ_Reinhard_HDRtoSDR_SSE2 proc src:dword,dst:dword,w4:dword,h:dword,src_pitch:dword,dst_pitch:dword,
	Coeff1:dword,Coeff2:dword

	public JPSDR_HDRTools_Convert_XYZ_Reinhard_HDRtoSDR_SSE2

	push esi
	push edi
	push ebx
	
	mov esi,Coeff1
	movss xmm2,dword ptr[esi]
	shufps xmm2,xmm2,0
	mov esi,Coeff2
	movss xmm3,dword ptr[esi]
	shufps xmm3,xmm3,0
	
	mov esi,src
	mov edi,dst
	mov ebx,w4
	mov edx,16
	
Convert_XYZ_Reinhard_HDRtoSDR_SSE2_1:
	mov ecx,ebx
	xor eax,eax
Convert_XYZ_Reinhard_HDRtoSDR_SSE2_2:	
	movaps xmm0,XMMWORD ptr[esi+eax]
	
	movaps xmm1,xmm0
	addps xmm0,xmm3
	divps xmm1,xmm0
	mulps xmm1,xmm2
	
	movaps XMMWORD ptr [edi+eax],xmm1
	
	add eax,edx
	loop Convert_XYZ_Reinhard_HDRtoSDR_SSE2_2
	
	add esi,src_pitch
	add edi,dst_pitch
	dec h
	jnz short Convert_XYZ_Reinhard_HDRtoSDR_SSE2_1
	
	pop ebx
	pop edi
	pop esi

	ret

JPSDR_HDRTools_Convert_XYZ_Reinhard_HDRtoSDR_SSE2 endp


JPSDR_HDRTools_Convert_XYZ_Reinhard_HDRtoSDR_AVX proc src:dword,dst:dword,w8:dword,h:dword,src_pitch:dword,dst_pitch:dword,
	Coeff1:dword,Coeff2:dword

	public JPSDR_HDRTools_Convert_XYZ_Reinhard_HDRtoSDR_AVX

	push esi
	push edi
	push ebx
	
	mov esi,Coeff1
	vmovss xmm2,dword ptr[esi]
	vshufps xmm2,xmm2,xmm2,0
	vinsertf128 ymm2,ymm2,xmm2,1
	mov esi,Coeff2
	vmovss xmm3,dword ptr[esi]
	vshufps xmm3,xmm3,xmm3,0
	vinsertf128 ymm3,ymm3,xmm3,1
	
	mov esi,src
	mov edi,dst
	mov ebx,w8
	mov edx,32
	
Convert_XYZ_Reinhard_HDRtoSDR_AVX_1:
	mov ecx,ebx
	xor eax,eax
Convert_XYZ_Reinhard_HDRtoSDR_AVX_2:
	vmovaps ymm0,YMMWORD ptr[esi+eax]
	
	vaddps ymm1,ymm0,ymm3
	vdivps ymm0,ymm0,ymm1
	vmulps ymm0,ymm0,ymm2
	
	vmovaps YMMWORD ptr [edi+eax],ymm0
	
	add eax,edx
	loop Convert_XYZ_Reinhard_HDRtoSDR_AVX_2
	
	add esi,src_pitch
	add edi,dst_pitch
	dec h
	jnz short Convert_XYZ_Reinhard_HDRtoSDR_AVX_1
	
	vzeroupper
	
	pop ebx
	pop edi
	pop esi

	ret

JPSDR_HDRTools_Convert_XYZ_Reinhard_HDRtoSDR_AVX endp


end





