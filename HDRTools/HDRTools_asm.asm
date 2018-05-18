.586
.xmm
.model flat,c

.data

data segment align(32)

data_f_65535 real4 8 dup(65535.0)

.code


JPSDR_HDRTools_Move8to16 proc dst:dword,src:dword,w:dword

	public JPSDR_HDRTools_Move8to16
	
	push esi
	push edi
	
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

	
JPSDR_HDRTools_Convert420_to_Planar422_8_SSE2 proc src1:dword,src2:dword,dst:dword,w:dword

	public JPSDR_HDRTools_Convert420_to_Planar422_8_SSE2
	
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
	
Convert420_to_Planar422_8_SSE2_1:
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
	loop Convert420_to_Planar422_8_SSE2_1
	

	pop ebx
	pop edi
	pop esi

	ret

JPSDR_HDRTools_Convert420_to_Planar422_8_SSE2 endp


JPSDR_HDRTools_Convert420_to_Planar422_8to16_SSE2 proc src1:dword,src2:dword,dst:dword,w:dword

	public JPSDR_HDRTools_Convert420_to_Planar422_8to16_SSE2
	
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
	
Convert420_to_Planar422_8to16_SSE2_1:
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
	loop Convert420_to_Planar422_8to16_SSE2_1
	

	pop ebx
	pop edi
	pop esi

	ret

JPSDR_HDRTools_Convert420_to_Planar422_8to16_SSE2 endp


JPSDR_HDRTools_Convert420_to_Planar422_8_AVX proc src1:dword,src2:dword,dst:dword,w:dword

	public JPSDR_HDRTools_Convert420_to_Planar422_8_AVX
	
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
	
Convert420_to_Planar422_8_AVX_1:
	vmovdqa xmm0,XMMWORD ptr[esi+eax]
	vmovdqa xmm1,XMMWORD ptr[edx+eax]
	vpxor xmm2,xmm0,xmm3
	vpxor xmm1,xmm1,xmm3
	vpavgb xmm2,xmm2,xmm1
	vpxor xmm2,xmm2,xmm3
	vpavgb xmm2,xmm2,xmm0
	
	vmovdqa XMMWORD ptr[edi+eax],xmm2
	add eax,ebx
	loop Convert420_to_Planar422_8_AVX_1
	
	pop ebx
	pop edi
	pop esi

	ret

JPSDR_HDRTools_Convert420_to_Planar422_8_AVX endp


JPSDR_HDRTools_Convert420_to_Planar422_8to16_AVX proc src1:dword,src2:dword,dst:dword,w:dword

	public JPSDR_HDRTools_Convert420_to_Planar422_8to16_AVX
	
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
	
Convert420_to_Planar422_8to16_AVX_1:
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
	loop Convert420_to_Planar422_8to16_AVX_1
	
	pop ebx
	pop edi
	pop esi

	ret

JPSDR_HDRTools_Convert420_to_Planar422_8to16_AVX endp


JPSDR_HDRTools_Convert420_to_Planar422_16_SSE2 proc src1:dword,src2:dword,dst:dword,w:dword

	public JPSDR_HDRTools_Convert420_to_Planar422_16_SSE2
	
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
	
Convert420_to_Planar422_16_SSE2_1:
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
	loop Convert420_to_Planar422_16_SSE2_1
	

	pop ebx
	pop edi
	pop esi

	ret

JPSDR_HDRTools_Convert420_to_Planar422_16_SSE2 endp


JPSDR_HDRTools_Convert420_to_Planar422_16_AVX proc src1:dword,src2:dword,dst:dword,w:dword

	public JPSDR_HDRTools_Convert420_to_Planar422_16_AVX
	
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
	
Convert420_to_Planar422_16_AVX_1:
	vmovdqa xmm0,XMMWORD ptr[esi+eax]
	vmovdqa xmm1,XMMWORD ptr[edx+eax]
	vpxor xmm2,xmm0,xmm3
	vpxor xmm1,xmm1,xmm3
	vpavgw xmm2,xmm2,xmm1
	vpxor xmm2,xmm2,xmm3
	vpavgw xmm2,xmm2,xmm0
	
	vmovdqa XMMWORD ptr[edi+eax],xmm2
	add eax,ebx
	loop Convert420_to_Planar422_16_AVX_1
	
	pop ebx
	pop edi
	pop esi

	ret

JPSDR_HDRTools_Convert420_to_Planar422_16_AVX endp


JPSDR_HDRTools_Convert422_to_Planar444_8_SSE2 proc src:dword,dst:dword,w:dword

	public JPSDR_HDRTools_Convert422_to_Planar444_8_SSE2
	
	push edi
	push ebx
	
	mov edx,src
	mov edi,dst
	xor eax,eax	
	mov ecx,w	
	mov ebx,16
	
Convert422_to_Planar444_8_SSE2_1:
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
	loop Convert422_to_Planar444_8_SSE2_1
	
	pop ebx
	pop edi

	ret

JPSDR_HDRTools_Convert422_to_Planar444_8_SSE2 endp


JPSDR_HDRTools_Convert422_to_Planar444_8_AVX proc src:dword,dst:dword,w:dword

	public JPSDR_HDRTools_Convert422_to_Planar444_8_AVX
	
	push edi
	push ebx
	
	mov edx,src
	mov edi,dst
	xor eax,eax	
	mov ecx,w	
	mov ebx,16
	
Convert422_to_Planar444_8_AVX_1:
	vmovdqa xmm0,XMMWORD ptr[edx+eax]
	vmovdqu xmm1,XMMWORD ptr[edx+eax+1]
	vpavgb xmm1,xmm1,xmm0
	vpunpcklbw xmm2,xmm0,xmm1
	vpunpckhbw xmm3,xmm0,xmm1
	
	vmovdqa XMMWORD ptr[edi+2*eax],xmm2
	vmovdqa XMMWORD ptr[edi+2*eax+16],xmm3
	add eax,ebx
	loop Convert422_to_Planar444_8_AVX_1
	
	pop ebx
	pop edi

	ret

JPSDR_HDRTools_Convert422_to_Planar444_8_AVX endp


JPSDR_HDRTools_Convert422_to_Planar444_8to16_SSE2 proc src:dword,dst:dword,w:dword

	public JPSDR_HDRTools_Convert422_to_Planar444_8to16_SSE2
	
	push esi
	push edi
	push ebx
	
	mov esi,src
	mov edi,dst
	xor eax,eax
	xor edx,edx
	mov ecx,w	
	mov ebx,32
	
Convert422_to_Planar444_8to16_SSE2_1:
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
	loop Convert422_to_Planar444_8to16_SSE2_1
	
	pop ebx
	pop edi
	pop esi

	ret

JPSDR_HDRTools_Convert422_to_Planar444_8to16_SSE2 endp


JPSDR_HDRTools_Convert422_to_Planar444_8to16_AVX proc src:dword,dst:dword,w:dword

	public JPSDR_HDRTools_Convert422_to_Planar444_8to16_AVX
	
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
	
Convert422_to_Planar444_8to16_AVX_1:
	vmovq xmm0,qword ptr[esi+8*eax]
	vmovq xmm1,qword ptr[esi+8*eax+1]
	vpunpcklbw xmm0,xmm4,xmm0
	vpunpcklbw xmm1,xmm4,xmm1
	
	vpavgw xmm1,xmm1,xmm0
	vpunpcklwd xmm2,xmm0,xmm1
	vpunpckhwd xmm3,xmm0,xmm1
	
	vmovdqa XMMWORD ptr[edi+edx],xmm2
	vmovdqa XMMWORD ptr[edi+edx+16],xmm0
	inc eax
	add edx,ebx
	loop Convert422_to_Planar444_8to16_AVX_1
	
	pop ebx
	pop edi
	pop esi

	ret

JPSDR_HDRTools_Convert422_to_Planar444_8to16_AVX endp


JPSDR_HDRTools_Convert422_to_Planar444_16_SSE2 proc src:dword,dst:dword,w:dword

	public JPSDR_HDRTools_Convert422_to_Planar444_16_SSE2
	
	push edi
	push ebx
	
	mov edx,src
	mov edi,dst
	xor eax,eax	
	mov ecx,w	
	mov ebx,16
	
Convert422_to_Planar444_16_SSE2_1:
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
	loop Convert422_to_Planar444_16_SSE2_1
	
	pop ebx
	pop edi

	ret

JPSDR_HDRTools_Convert422_to_Planar444_16_SSE2 endp


JPSDR_HDRTools_Convert422_to_Planar444_16_AVX proc src:dword,dst:dword,w:dword

	public JPSDR_HDRTools_Convert422_to_Planar444_16_AVX
	
	push edi
	push ebx
	
	mov edx,src
	mov edi,dst
	xor eax,eax	
	mov ecx,w	
	mov ebx,16
	
Convert422_to_Planar444_16_AVX_1:
	vmovdqa xmm0,XMMWORD ptr[edx+eax]
	vmovdqu xmm1,XMMWORD ptr[edx+eax+2]
	vpavgw xmm1,xmm1,xmm0
	vpunpcklwd xmm2,xmm0,xmm1
	vpunpckhwd xmm3,xmm0,xmm1
	
	vmovdqa XMMWORD ptr[edi+2*eax],xmm2
	vmovdqa XMMWORD ptr[edi+2*eax+16],xmm3
	add eax,ebx
	loop Convert422_to_Planar444_16_AVX_1
	
	pop ebx
	pop edi

	ret

JPSDR_HDRTools_Convert422_to_Planar444_16_AVX endp


JPSDR_HDRTools_Convert_YV24toRGB32_SSE2 proc src_y:dword,src_u:dword,src_v:dword,dst:dword,w:dword,h:dword,offset_R:word,
	offset_G:word,offset_B:word,lookup:dword,src_modulo_y:dword,src_modulo_u:dword,src_modulo_v:dword,dst_modulo:dword

	public JPSDR_HDRTools_Convert_YV24toRGB32_SSE2

	local i,w0:dword

	push esi
	push edi
	push ebx

	pxor xmm2,xmm2
	pxor xmm1,xmm1
	pxor xmm0,xmm0
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
	shr eax,1
	mov w0,eax
	
	mov edi,dst
	
Convert_YV24toRGB32_SSE2_1:
	mov eax,w0
	or eax,eax
	jz Convert_YV24toRGB32_SSE2_3
	mov i,eax
Convert_YV24toRGB32_SSE2_2:
	mov esi,src_y
	movzx ebx,byte ptr[esi]
	mov esi,src_u
	movzx ecx,byte ptr[esi]
	mov esi,src_v
	movzx edx,byte ptr[esi] ; ebx=Y ecx=U edx=V
	mov esi,lookup
	movzx eax,word ptr[esi+2*ebx]
	add ax,word ptr[esi+2*edx+512]
	pinsrw xmm0,eax,2
	movzx eax,word ptr[esi+2*ebx]
	add ax,word ptr[esi+2*ecx+1024]
	add ax,word ptr[esi+2*edx+1536]
	pinsrw xmm0,eax,1
	movzx eax,word ptr[esi+2*ebx]
	add ax,word ptr[esi+2*ecx+2048]
	mov esi,src_y
	pinsrw xmm0,eax,0
	
	movzx ebx,byte ptr[esi+1]
	mov esi,src_u
	movzx ecx,byte ptr[esi+1]
	mov esi,src_v
	movzx edx,byte ptr[esi+1] ; ebx=Y ecx=U edx=V
	mov esi,lookup
	movzx eax,word ptr[esi+2*ebx]
	add ax,word ptr[esi+2*edx+512]
	add src_y,2
	pinsrw xmm0,eax,6
	movzx eax,word ptr[esi+2*ebx]
	add ax,word ptr[esi+2*ecx+1024]
	add ax,word ptr[esi+2*edx+1536]
	add src_u,2
	pinsrw xmm0,eax,5
	movzx eax,word ptr[esi+2*ebx]
	add ax,word ptr[esi+2*ecx+2048]
	add src_v,2
	pinsrw xmm0,eax,4
	
	paddsw xmm0,xmm1
	psraw xmm0,5
	packuswb xmm0,xmm2
	
	movq qword ptr[edi],xmm0
	
	add edi,8
	
	dec i
	jnz Convert_YV24toRGB32_SSE2_2
	
Convert_YV24toRGB32_SSE2_3:
	mov eax,w
	and eax,1
	jz Convert_YV24toRGB32_SSE2_4
	
	mov esi,src_y
	movzx ebx,byte ptr[esi]
	mov esi,src_u
	movzx ecx,byte ptr[esi]
	mov esi,src_v
	movzx edx,byte ptr[esi] ; ebx=Y ecx=U edx=V
	mov esi,lookup
	movzx eax,word ptr[esi+2*ebx]
	add ax,word ptr[esi+2*edx+512]
	inc src_y
	pinsrw xmm0,eax,2
	movzx eax,word ptr[esi+2*ebx]
	add ax,word ptr[esi+2*ecx+1024]
	add ax,word ptr[esi+2*edx+1536]
	inc src_u
	pinsrw xmm0,eax,1
	movzx eax,word ptr[esi+2*ebx]
	add ax,word ptr[esi+2*ecx+2048]
	inc src_v
	pinsrw xmm0,eax,0
	
	paddsw xmm0,xmm1
	psraw xmm0,5
	packuswb xmm0,xmm2
	
	movd dword ptr[edi],xmm0
	
	add edi,4
	
Convert_YV24toRGB32_SSE2_4:	
	add edi,dst_modulo
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
	shr eax,1
	mov w0,eax
	
	mov edi,dst
	
Convert_YV24toRGB32_AVX_1:
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
	mov esi,lookup
	movzx eax,word ptr[esi+2*ebx]
	add ax,word ptr[esi+2*edx+512]
	vpinsrw xmm0,xmm0,eax,2
	movzx eax,word ptr[esi+2*ebx]
	add ax,word ptr[esi+2*ecx+1024]
	add ax,word ptr[esi+2*edx+1536]
	vpinsrw xmm0,xmm0,eax,1
	movzx eax,word ptr[esi+2*ebx]
	add ax,word ptr[esi+2*ecx+2048]
	mov esi,src_y
	vpinsrw xmm0,xmm0,eax,0
	
	movzx ebx,byte ptr[esi+1]
	mov esi,src_u
	movzx ecx,byte ptr[esi+1]
	mov esi,src_v
	movzx edx,byte ptr[esi+1] ; ebx=Y ecx=U edx=V
	mov esi,lookup
	movzx eax,word ptr[esi+2*ebx]
	add ax,word ptr[esi+2*edx+512]
	add src_y,2
	vpinsrw xmm0,xmm0,eax,6
	movzx eax,word ptr[esi+2*ebx]
	add ax,word ptr[esi+2*ecx+1024]
	add ax,word ptr[esi+2*edx+1536]
	add src_u,2
	vpinsrw xmm0,xmm0,eax,5
	movzx eax,word ptr[esi+2*ebx]
	add ax,word ptr[esi+2*ecx+2048]
	add src_v,2
	vpinsrw xmm0,xmm0,eax,4
	
	vpaddsw xmm0,xmm0,xmm1
	vpsraw xmm0,xmm0,5
	vpackuswb xmm0,xmm0,xmm2
	
	vmovq qword ptr[edi],xmm0
	
	add edi,8
	
	dec i
	jnz Convert_YV24toRGB32_AVX_2
	
Convert_YV24toRGB32_AVX_3:
	mov eax,w
	and eax,1
	jz Convert_YV24toRGB32_AVX_4
	
	mov esi,src_y
	movzx ebx,byte ptr[esi]
	mov esi,src_u
	movzx ecx,byte ptr[esi]
	mov esi,src_v
	movzx edx,byte ptr[esi] ; ebx=Y ecx=U edx=V
	mov esi,lookup
	movzx eax,word ptr[esi+2*ebx]
	add ax,word ptr[esi+2*edx+512]
	inc src_y
	vpinsrw xmm0,xmm0,eax,2
	movzx eax,word ptr[esi+2*ebx]
	add ax,word ptr[esi+2*ecx+1024]
	add ax,word ptr[esi+2*edx+1536]
	inc src_u
	vpinsrw xmm0,xmm0,eax,1
	movzx eax,word ptr[esi+2*ebx]
	add ax,word ptr[esi+2*ecx+2048]
	inc src_v
	vpinsrw xmm0,xmm0,eax,0
	
	vpaddsw xmm0,xmm0,xmm1
	vpsraw xmm0,xmm0,5
	vpackuswb xmm0,xmm0,xmm2
	
	vmovd dword ptr[edi],xmm0
	
	add edi,4
	
Convert_YV24toRGB32_AVX_4:	
	add edi,dst_modulo
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

	pxor xmm2,xmm2
	pxor xmm1,xmm1
	pxor xmm0,xmm0
	mov eax,offset_B
	pinsrd xmm1,eax,0
	mov eax,offset_G
	pinsrd xmm1,eax,1
	mov eax,offset_R
	pinsrd xmm1,eax,2
	
	mov eax,w
	mov w0,eax
	
	mov edi,dst
	
Convert_8_YV24toRGB64_SSE41_1:
	mov eax,w0
	mov i,eax
Convert_8_YV24toRGB64_SSE41_2:
	mov esi,src_y
	movzx ebx,byte ptr[esi]
	mov esi,src_u
	movzx ecx,byte ptr[esi]
	mov esi,src_v
	movzx edx,byte ptr[esi] ; ebx=Y ecx=U edx=V
	mov esi,lookup
	mov eax,dword ptr[esi+4*ebx]
	add eax,dword ptr[esi+4*edx+1024]
	pinsrd xmm0,eax,2
	inc src_y
	mov eax,dword ptr[esi+4*ebx]
	add eax,dword ptr[esi+4*ecx+2048]
	add eax,dword ptr[esi+4*edx+3072]
	pinsrd xmm0,eax,1
	inc src_u
	mov eax,dword ptr[esi+4*ebx]
	add eax,dword ptr[esi+4*ecx+4096]
	mov esi,src_y
	pinsrd xmm0,eax,0
	inc src_v
	
	paddd xmm0,xmm1
	psrad xmm0,8
	packusdw xmm0,xmm2
	
	movq qword ptr[edi],xmm0
	
	add edi,8
	
	dec i
	jnz short Convert_8_YV24toRGB64_SSE41_2
	
	add edi,dst_modulo
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

	pxor xmm2,xmm2
	pxor xmm1,xmm1
	pxor xmm0,xmm0
	mov eax,offset_B
	pinsrd xmm1,eax,0
	mov eax,offset_G
	pinsrd xmm1,eax,1
	mov eax,offset_R
	pinsrd xmm1,eax,2
	
	mov eax,w
	mov w0,eax
	
	mov edi,dst
	
Convert_10_YV24toRGB64_SSE41_1:
	mov eax,w0
	mov i,eax
Convert_10_YV24toRGB64_SSE41_2:
	mov esi,src_y
	movzx ebx,word ptr[esi]
	mov esi,src_u
	movzx ecx,word ptr[esi]
	mov esi,src_v
	movzx edx,word ptr[esi] ; ebx=Y ecx=U edx=V
	mov esi,lookup
	mov eax,dword ptr[esi+4*ebx]
	add eax,dword ptr[esi+4*edx+4096]
	pinsrd xmm0,eax,2
	add src_y,2
	mov eax,dword ptr[esi+4*ebx]
	add eax,dword ptr[esi+4*ecx+8192]
	add eax,dword ptr[esi+4*edx+12288]
	pinsrd xmm0,eax,1
	add src_u,2
	mov eax,dword ptr[esi+4*ebx]
	add eax,dword ptr[esi+4*ecx+16384]
	mov esi,src_y
	pinsrd xmm0,eax,0
	add src_v,2
	
	paddd xmm0,xmm1
	psrad xmm0,8
	packusdw xmm0,xmm2
	
	movq qword ptr[edi],xmm0
	
	add edi,8
	
	dec i
	jnz short Convert_10_YV24toRGB64_SSE41_2
	
	add edi,dst_modulo
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

	pxor xmm2,xmm2
	pxor xmm1,xmm1
	pxor xmm0,xmm0
	mov eax,offset_B
	pinsrd xmm1,eax,0
	mov eax,offset_G
	pinsrd xmm1,eax,1
	mov eax,offset_R
	pinsrd xmm1,eax,2
	
	mov eax,w
	mov w0,eax
	
	mov edi,dst
	
Convert_12_YV24toRGB64_SSE41_1:
	mov eax,w0
	mov i,eax
Convert_12_YV24toRGB64_SSE41_2:
	mov esi,src_y
	movzx ebx,word ptr[esi]
	mov esi,src_u
	movzx ecx,word ptr[esi]
	mov esi,src_v
	movzx edx,word ptr[esi] ; ebx=Y ecx=U edx=V
	mov esi,lookup
	mov eax,dword ptr[esi+4*ebx]
	add eax,dword ptr[esi+4*edx+16384]
	pinsrd xmm0,eax,2
	add src_y,2
	mov eax,dword ptr[esi+4*ebx]
	add eax,dword ptr[esi+4*ecx+32768]
	add eax,dword ptr[esi+4*edx+49152]
	pinsrd xmm0,eax,1
	add src_u,2
	mov eax,dword ptr[esi+4*ebx]
	add eax,dword ptr[esi+4*ecx+65536]
	mov esi,src_y
	pinsrd xmm0,eax,0
	add src_v,2
	
	paddd xmm0,xmm1
	psrad xmm0,8
	packusdw xmm0,xmm2
	
	movq qword ptr[edi],xmm0
	
	add edi,8
	
	dec i
	jnz short Convert_12_YV24toRGB64_SSE41_2
	
	add edi,dst_modulo
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

	pxor xmm2,xmm2
	pxor xmm1,xmm1
	pxor xmm0,xmm0
	mov eax,offset_B
	pinsrd xmm1,eax,0
	mov eax,offset_G
	pinsrd xmm1,eax,1
	mov eax,offset_R
	pinsrd xmm1,eax,2
	
	mov eax,w
	mov w0,eax
	
	mov edi,dst
	
Convert_14_YV24toRGB64_SSE41_1:
	mov eax,w0
	mov i,eax
Convert_14_YV24toRGB64_SSE41_2:
	mov esi,src_y
	movzx ebx,word ptr[esi]
	mov esi,src_u
	movzx ecx,word ptr[esi]
	mov esi,src_v
	movzx edx,word ptr[esi] ; ebx=Y ecx=U edx=V
	mov esi,lookup
	mov eax,dword ptr[esi+4*ebx]
	add eax,dword ptr[esi+4*edx+65536]
	pinsrd xmm0,eax,2
	add src_y,2
	mov eax,dword ptr[esi+4*ebx]
	add eax,dword ptr[esi+4*ecx+131072]
	add eax,dword ptr[esi+4*edx+196608]
	pinsrd xmm0,eax,1
	add src_u,2
	mov eax,dword ptr[esi+4*ebx]
	add eax,dword ptr[esi+4*ecx+262144]
	mov esi,src_y
	pinsrd xmm0,eax,0
	add src_v,2
	
	paddd xmm0,xmm1
	psrad xmm0,8
	packusdw xmm0,xmm2
	
	movq qword ptr[edi],xmm0
	
	add edi,8
	
	dec i
	jnz short Convert_14_YV24toRGB64_SSE41_2
	
	add edi,dst_modulo
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

	pxor xmm2,xmm2
	pxor xmm1,xmm1
	pxor xmm0,xmm0
	mov eax,offset_B
	pinsrd xmm1,eax,0
	mov eax,offset_G
	pinsrd xmm1,eax,1
	mov eax,offset_R
	pinsrd xmm1,eax,2
	
	mov eax,w
	mov w0,eax
	
	mov edi,dst
	
Convert_16_YV24toRGB64_SSE41_1:
	mov eax,w0
	mov i,eax
Convert_16_YV24toRGB64_SSE41_2:
	mov esi,src_y
	movzx ebx,word ptr[esi]
	mov esi,src_u
	movzx ecx,word ptr[esi]
	mov esi,src_v
	movzx edx,word ptr[esi] ; ebx=Y ecx=U edx=V
	mov esi,lookup
	mov eax,dword ptr[esi+4*ebx]
	add eax,dword ptr[esi+4*edx+262144]
	pinsrd xmm0,eax,2
	add src_y,2
	mov eax,dword ptr[esi+4*ebx]
	add eax,dword ptr[esi+4*ecx+524288]
	add eax,dword ptr[esi+4*edx+786432]
	pinsrd xmm0,eax,1
	add src_u,2
	mov eax,dword ptr[esi+4*ebx]
	add eax,dword ptr[esi+4*ecx+1048576]
	mov esi,src_y
	pinsrd xmm0,eax,0
	add src_v,2
	
	paddd xmm0,xmm1
	psrad xmm0,8
	packusdw xmm0,xmm2
	
	movq qword ptr[edi],xmm0
	
	add edi,8
	
	dec i
	jnz short Convert_16_YV24toRGB64_SSE41_2
	
	add edi,dst_modulo
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
	mov w0,eax
	
	mov edi,dst
	
Convert_8_YV24toRGB64_AVX_1:
	mov eax,w0
	mov i,eax
Convert_8_YV24toRGB64_AVX_2:
	mov esi,src_y
	movzx ebx,byte ptr[esi]
	mov esi,src_u
	movzx ecx,byte ptr[esi]
	mov esi,src_v
	movzx edx,byte ptr[esi] ; ebx=Y ecx=U edx=V
	mov esi,lookup
	mov eax,dword ptr[esi+4*ebx]
	add eax,dword ptr[esi+4*edx+1024]
	vpinsrd xmm0,xmm0,eax,2
	inc src_y
	mov eax,dword ptr[esi+4*ebx]
	add eax,dword ptr[esi+4*ecx+2048]
	add eax,dword ptr[esi+4*edx+3072]
	vpinsrd xmm0,xmm0,eax,1
	inc src_u
	mov eax,dword ptr[esi+4*ebx]
	add eax,dword ptr[esi+4*ecx+4096]
	mov esi,src_y
	vpinsrd xmm0,xmm0,eax,0
	inc src_v
	
	vpaddd xmm0,xmm0,xmm1
	vpsrad xmm0,xmm0,8
	vpackusdw xmm0,xmm0,xmm2
	
	vmovq qword ptr[edi],xmm0
	
	add edi,8
	
	dec i
	jnz short Convert_8_YV24toRGB64_AVX_2
	
	add edi,dst_modulo
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
	mov w0,eax
	
	mov edi,dst
	
Convert_10_YV24toRGB64_AVX_1:
	mov eax,w0
	mov i,eax
Convert_10_YV24toRGB64_AVX_2:
	mov esi,src_y
	movzx ebx,word ptr[esi]
	mov esi,src_u
	movzx ecx,word ptr[esi]
	mov esi,src_v
	movzx edx,word ptr[esi] ; ebx=Y ecx=U edx=V
	mov esi,lookup
	mov eax,dword ptr[esi+4*ebx]
	add eax,dword ptr[esi+4*edx+4096]
	vpinsrd xmm0,xmm0,eax,2
	add src_y,2
	mov eax,dword ptr[esi+4*ebx]
	add eax,dword ptr[esi+4*ecx+8192]
	add eax,dword ptr[esi+4*edx+12288]
	vpinsrd xmm0,xmm0,eax,1
	add src_u,2
	mov eax,dword ptr[esi+4*ebx]
	add eax,dword ptr[esi+4*ecx+16384]
	mov esi,src_y
	vpinsrd xmm0,xmm0,eax,0
	add src_v,2
	
	vpaddd xmm0,xmm0,xmm1
	vpsrad xmm0,xmm0,8
	vpackusdw xmm0,xmm0,xmm2
	
	vmovq qword ptr[edi],xmm0
	
	add edi,8
	
	dec i
	jnz short Convert_10_YV24toRGB64_AVX_2
	
	add edi,dst_modulo
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
	mov w0,eax
	
	mov edi,dst
	
Convert_12_YV24toRGB64_AVX_1:
	mov eax,w0
	mov i,eax
Convert_12_YV24toRGB64_AVX_2:
	mov esi,src_y
	movzx ebx,word ptr[esi]
	mov esi,src_u
	movzx ecx,word ptr[esi]
	mov esi,src_v
	movzx edx,word ptr[esi] ; ebx=Y ecx=U edx=V
	mov esi,lookup
	mov eax,dword ptr[esi+4*ebx]
	add eax,dword ptr[esi+4*edx+16384]
	vpinsrd xmm0,xmm0,eax,2
	add src_y,2
	mov eax,dword ptr[esi+4*ebx]
	add eax,dword ptr[esi+4*ecx+32768]
	add eax,dword ptr[esi+4*edx+49152]
	vpinsrd xmm0,xmm0,eax,1
	add src_u,2
	mov eax,dword ptr[esi+4*ebx]
	add eax,dword ptr[esi+4*ecx+65536]
	mov esi,src_y
	vpinsrd xmm0,xmm0,eax,0
	add src_v,2
	
	vpaddd xmm0,xmm0,xmm1
	vpsrad xmm0,xmm0,8
	vpackusdw xmm0,xmm0,xmm2
	
	vmovq qword ptr[edi],xmm0
	
	add edi,8
	
	dec i
	jnz short Convert_12_YV24toRGB64_AVX_2
	
	add edi,dst_modulo
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
	mov w0,eax
	
	mov edi,dst
	
Convert_14_YV24toRGB64_AVX_1:
	mov eax,w0
	mov i,eax
Convert_14_YV24toRGB64_AVX_2:
	mov esi,src_y
	movzx ebx,word ptr[esi]
	mov esi,src_u
	movzx ecx,word ptr[esi]
	mov esi,src_v
	movzx edx,word ptr[esi] ; ebx=Y ecx=U edx=V
	mov esi,lookup
	mov eax,dword ptr[esi+4*ebx]
	add eax,dword ptr[esi+4*edx+65536]
	vpinsrd xmm0,xmm0,eax,2
	add src_y,2
	mov eax,dword ptr[esi+4*ebx]
	add eax,dword ptr[esi+4*ecx+131072]
	add eax,dword ptr[esi+4*edx+196608]
	vpinsrd xmm0,xmm0,eax,1
	add src_u,2
	mov eax,dword ptr[esi+4*ebx]
	add eax,dword ptr[esi+4*ecx+262144]
	mov esi,src_y
	vpinsrd xmm0,xmm0,eax,0
	add src_v,2
	
	vpaddd xmm0,xmm0,xmm1
	vpsrad xmm0,xmm0,8
	vpackusdw xmm0,xmm0,xmm2
	
	vmovq qword ptr[edi],xmm0
	
	add edi,8
	
	dec i
	jnz short Convert_14_YV24toRGB64_AVX_2
	
	add edi,dst_modulo
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
	mov w0,eax
	
	mov edi,dst
	
Convert_16_YV24toRGB64_AVX_1:
	mov eax,w0
	mov i,eax
Convert_16_YV24toRGB64_AVX_2:
	mov esi,src_y
	movzx ebx,word ptr[esi]
	mov esi,src_u
	movzx ecx,word ptr[esi]
	mov esi,src_v
	movzx edx,word ptr[esi] ; ebx=Y ecx=U edx=V
	mov esi,lookup
	mov eax,dword ptr[esi+4*ebx]
	add eax,dword ptr[esi+4*edx+262144]
	vpinsrd xmm0,xmm0,eax,2
	add src_y,2
	mov eax,dword ptr[esi+4*ebx]
	add eax,dword ptr[esi+4*ecx+524288]
	add eax,dword ptr[esi+4*edx+786432]
	vpinsrd xmm0,xmm0,eax,1
	add src_u,2
	mov eax,dword ptr[esi+4*ebx]
	add eax,dword ptr[esi+4*ecx+1048576]
	mov esi,src_y
	vpinsrd xmm0,xmm0,eax,0
	add src_v,2
	
	vpaddd xmm0,xmm0,xmm1
	vpsrad xmm0,xmm0,8
	vpackusdw xmm0,xmm0,xmm2
	
	vmovq qword ptr[edi],xmm0
	
	add edi,8
	
	dec i
	jnz short Convert_16_YV24toRGB64_AVX_2
	
	add edi,dst_modulo
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


JPSDR_HDRTools_Convert_LinearRGBPStoRGB64_SSE41 proc src_R:dword,src_G:dword,src_B:dword,dst:dword,w:dword,h:dword,lookup:dword,
	src_modulo_R:dword,src_modulo_G:dword,src_modulo_B:dword,dst_modulo:dword
	
	public JPSDR_HDRTools_Convert_LinearRGBPStoRGB64_SSE41
	
	push esi
	push edi
	push ebx
	
	movaps xmm3,XMMWORD ptr data_f_65535
	
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
	mulps xmm0,xmm3
	movaps xmm1,XMMWORD ptr[esi]
	mov esi,src_R
	mulps xmm1,xmm3
	movaps xmm2,XMMWORD ptr[esi]
	cvtps2dq xmm0,xmm0
	mulps xmm2,xmm3
	cvtps2dq xmm1,xmm1
	cvtps2dq xmm2,xmm2
	packusdw xmm0,xmm0
	packusdw xmm1,xmm1
	packusdw xmm2,xmm2
	
	pextrw eax,xmm0,0
	mov ax,word ptr[ebx+2*eax]
	stosw
	pextrw eax,xmm1,0
	mov ax,word ptr[ebx+2*eax]
	stosw
	pextrw eax,xmm2,0
	mov ax,word ptr[ebx+2*eax]
	stosw
	xor eax,eax
	stosw
	dec ecx
	jz short Convert_LinearRGBPStoRGB64_SSE41_3
	inc edx
	
	pextrw eax,xmm0,1
	mov ax,word ptr[ebx+2*eax]
	stosw
	pextrw eax,xmm1,1
	mov ax,word ptr[ebx+2*eax]
	stosw
	pextrw eax,xmm2,1
	mov ax,word ptr[ebx+2*eax]
	stosw
	xor eax,eax
	stosw
	dec ecx
	jz short Convert_LinearRGBPStoRGB64_SSE41_3
	inc edx

	pextrw eax,xmm0,2
	mov ax,word ptr[ebx+2*eax]
	stosw
	pextrw eax,xmm1,2
	mov ax,word ptr[ebx+2*eax]
	stosw
	pextrw eax,xmm2,2
	mov ax,word ptr[ebx+2*eax]
	stosw
	xor eax,eax
	stosw
	dec ecx
	jz short Convert_LinearRGBPStoRGB64_SSE41_3
	inc edx

	pextrw eax,xmm0,3
	mov ax,word ptr[ebx+2*eax]
	stosw
	pextrw eax,xmm1,3
	mov ax,word ptr[ebx+2*eax]
	stosw
	pextrw eax,xmm2,3
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
	
	vmovaps ymm3,YMMWORD ptr data_f_65535
	
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
	vmulps ymm0,ymm0,ymm3
	vmovaps ymm1,YMMWORD ptr[esi]
	mov esi,src_R
	vmulps ymm1,ymm1,ymm3
	vmovaps ymm2,YMMWORD ptr[esi]
	vcvtps2dq ymm0,ymm0
	vmulps ymm2,ymm2,ymm3
	vcvtps2dq ymm1,ymm1
	vcvtps2dq ymm2,ymm2
	
	vextractf128 xmm4,ymm0,1
	vextractf128 xmm5,ymm1,1
	vextractf128 xmm6,ymm2,1
	
	vpackusdw xmm0,xmm0,xmm4
	vpackusdw xmm1,xmm1,xmm5
	vpackusdw xmm2,xmm2,xmm6
	
	vpextrw eax,xmm0,0
	mov ax,word ptr[ebx+2*eax]
	stosw
	vpextrw eax,xmm1,0
	mov ax,word ptr[ebx+2*eax]
	stosw
	vpextrw eax,xmm2,0
	mov ax,word ptr[ebx+2*eax]
	stosw
	xor eax,eax
	stosw
	dec ecx
	jz Convert_LinearRGBPStoRGB64_AVX_3
	inc edx
	
	vpextrw eax,xmm0,1
	mov ax,word ptr[ebx+2*eax]
	stosw
	vpextrw eax,xmm1,1
	mov ax,word ptr[ebx+2*eax]
	stosw
	vpextrw eax,xmm2,1
	mov ax,word ptr[ebx+2*eax]
	stosw
	xor eax,eax
	stosw
	dec ecx
	jz Convert_LinearRGBPStoRGB64_AVX_3
	inc edx

	vpextrw eax,xmm0,2
	mov ax,word ptr[ebx+2*eax]
	stosw
	vpextrw eax,xmm1,2
	mov ax,word ptr[ebx+2*eax]
	stosw
	vpextrw eax,xmm2,2
	mov ax,word ptr[ebx+2*eax]
	stosw
	xor eax,eax
	stosw
	dec ecx
	jz Convert_LinearRGBPStoRGB64_AVX_3
	inc edx

	vpextrw eax,xmm0,3
	mov ax,word ptr[ebx+2*eax]
	stosw
	vpextrw eax,xmm1,3
	mov ax,word ptr[ebx+2*eax]
	stosw
	vpextrw eax,xmm2,3
	mov ax,word ptr[ebx+2*eax]
	stosw
	xor eax,eax
	stosw
	dec ecx
	jz Convert_LinearRGBPStoRGB64_AVX_3
	inc edx
	
	vpextrw eax,xmm0,4
	mov ax,word ptr[ebx+2*eax]
	stosw
	vpextrw eax,xmm1,4
	mov ax,word ptr[ebx+2*eax]
	stosw
	vpextrw eax,xmm2,4
	mov ax,word ptr[ebx+2*eax]
	stosw
	xor eax,eax
	stosw
	dec ecx
	jz short Convert_LinearRGBPStoRGB64_AVX_3
	inc edx
	
	vpextrw eax,xmm0,5
	mov ax,word ptr[ebx+2*eax]
	stosw
	vpextrw eax,xmm1,5
	mov ax,word ptr[ebx+2*eax]
	stosw
	vpextrw eax,xmm2,5
	mov ax,word ptr[ebx+2*eax]
	stosw
	xor eax,eax
	stosw
	dec ecx
	jz short Convert_LinearRGBPStoRGB64_AVX_3
	inc edx
	
	vpextrw eax,xmm0,6
	mov ax,word ptr[ebx+2*eax]
	stosw
	vpextrw eax,xmm1,6
	mov ax,word ptr[ebx+2*eax]
	stosw
	vpextrw eax,xmm2,6
	mov ax,word ptr[ebx+2*eax]
	stosw
	xor eax,eax
	stosw
	dec ecx
	jz short Convert_LinearRGBPStoRGB64_AVX_3
	inc edx
	
	vpextrw eax,xmm0,7
	mov ax,word ptr[ebx+2*eax]
	stosw
	vpextrw eax,xmm1,7
	mov ax,word ptr[ebx+2*eax]
	stosw
	vpextrw eax,xmm2,7
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
	mov eax,w0
	or eax,eax
	jz Convert_RGB32toYV24_SSE2_3
	mov i,eax
Convert_RGB32toYV24_SSE2_2:
	movzx edx,byte ptr[esi]
	movzx ecx,byte ptr[esi+1]
	movzx ebx,byte ptr[esi+2] ; ebx=R ecx=G edx=B
	mov esi,lookup
	movzx eax,word ptr[esi+2*ebx]
	add ax,word ptr[esi+2*ecx+512]
	add ax,word ptr[esi+2*edx+1024]
	pinsrw xmm0,eax,0
	movzx eax,word ptr[esi+2*ebx+1536]
	add ax,word ptr[esi+2*ecx+2048]
	add ax,word ptr[esi+2*edx+2560]
	pinsrw xmm0,eax,2
	movzx eax,word ptr[esi+2*ebx+3072]
	add ax,word ptr[esi+2*ecx+3584]
	add ax,word ptr[esi+2*edx+4096]
	mov esi,src
	pinsrw xmm0,eax,4
	movzx edx,byte ptr[esi+4]
	movzx ecx,byte ptr[esi+5]
	movzx ebx,byte ptr[esi+6] ; ebx=R ecx=G edx=B
	mov esi,lookup
	movzx eax,word ptr[esi+2*ebx]
	add ax,word ptr[esi+2*ecx+512]
	add ax,word ptr[esi+2*edx+1024]
	pinsrw xmm0,eax,1
	movzx eax,word ptr[esi+2*ebx+1536]
	add ax,word ptr[esi+2*ecx+2048]
	add ax,word ptr[esi+2*edx+2560]
	pinsrw xmm0,eax,3
	movzx eax,word ptr[esi+2*ebx+3072]
	add ax,word ptr[esi+2*ecx+3584]
	add ax,word ptr[esi+2*edx+4096]
	pinsrw xmm0,eax,5
	
	paddsw xmm0,xmm1
	psraw xmm0,6
	pmaxsw xmm0,xmm2
	pminsw xmm0,xmm3
	packuswb xmm0,xmm4
	
	mov edi,dst_y
	pextrw eax,xmm0,0
	add src,8
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
	
	mov esi,src
	
	dec i
	jnz Convert_RGB32toYV24_SSE2_2
	
Convert_RGB32toYV24_SSE2_3:	
	mov eax,w
	and eax,1
	jz Convert_RGB32toYV24_SSE2_4
	
	movzx edx,byte ptr[esi]
	movzx ecx,byte ptr[esi+1]
	movzx ebx,byte ptr[esi+2] ; ebx=R ecx=G edx=B
	mov esi,lookup
	movzx eax,word ptr[esi+2*ebx]
	add ax,word ptr[esi+2*ecx+512]
	add ax,word ptr[esi+2*edx+1024]
	pinsrw xmm0,eax,0
	movzx eax,word ptr[esi+2*ebx+1536]
	add ax,word ptr[esi+2*ecx+2048]
	add ax,word ptr[esi+2*edx+2560]
	pinsrw xmm0,eax,2
	movzx eax,word ptr[esi+2*ebx+3072]
	add ax,word ptr[esi+2*ecx+3584]
	add ax,word ptr[esi+2*edx+4096]
	pinsrw xmm0,eax,4
	
	paddsw xmm0,xmm1
	psraw xmm0,6
	pmaxsw xmm0,xmm2
	pminsw xmm0,xmm3
	
	mov edi,dst_y
	pextrw eax,xmm0,0
	add src,4
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
	
	mov esi,src	
	
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
	mov src,esi
	dec h
	jnz Convert_RGB32toYV24_SSE2_1

	pop ebx
	pop edi
	pop esi

	ret

JPSDR_HDRTools_Convert_RGB32toYV24_SSE2 endp


JPSDR_RGBConvert_Convert_RGB32toYV24_AVX proc src:dword,dst_y:dword,dst_u:dword,dst_v:dword,w:dword,h:dword,offset_Y:word,
	offset_U:word,offset_V:word,lookup:dword,src_modulo:dword,dst_modulo_y:dword,dst_modulo_u:dword,dst_modulo_v:dword,
	Min_Y:word,Max_Y:word,Min_U:word,Max_U:word,Min_V:word,Max_V:word

	public JPSDR_RGBConvert_Convert_RGB32toYV24_AVX

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
	mov eax,w0
	or eax,eax
	jz Convert_RGB32toYV24_AVX_3
	
	mov i,eax
Convert_RGB32toYV24_AVX_2:
	movzx edx,byte ptr[esi]
	movzx ecx,byte ptr[esi+1]
	movzx ebx,byte ptr[esi+2] ; ebx=R ecx=G edx=B
	mov esi,lookup
	movzx eax,word ptr[esi+2*ebx]
	add ax,word ptr[esi+2*ecx+512]
	add ax,word ptr[esi+2*edx+1024]
	vpinsrw xmm0,xmm0,eax,0
	movzx eax,word ptr[esi+2*ebx+1536]
	add ax,word ptr[esi+2*ecx+2048]
	add ax,word ptr[esi+2*edx+2560]
	vpinsrw xmm0,xmm0,eax,2
	movzx eax,word ptr[esi+2*ebx+3072]
	add ax,word ptr[esi+2*ecx+3584]
	add ax,word ptr[esi+2*edx+4096]
	mov esi,src
	vpinsrw xmm0,xmm0,eax,4
	movzx edx,byte ptr[esi+4]
	movzx ecx,byte ptr[esi+5]
	movzx ebx,byte ptr[esi+6] ; ebx=R ecx=G edx=B
	mov esi,lookup
	movzx eax,word ptr[esi+2*ebx]
	add ax,word ptr[esi+2*ecx+512]
	add ax,word ptr[esi+2*edx+1024]
	vpinsrw xmm0,xmm0,eax,1
	movzx eax,word ptr[esi+2*ebx+1536]
	add ax,word ptr[esi+2*ecx+2048]
	add ax,word ptr[esi+2*edx+2560]
	vpinsrw xmm0,xmm0,eax,3
	movzx eax,word ptr[esi+2*ebx+3072]
	add ax,word ptr[esi+2*ecx+3584]
	add ax,word ptr[esi+2*edx+4096]
	vpinsrw xmm0,xmm0,eax,5
	
	vpaddsw xmm0,xmm0,xmm1
	vpsraw xmm0,xmm0,6
	vpmaxsw xmm0,xmm0,xmm2
	vpminsw xmm0,xmm0,xmm3
	vpackuswb xmm0,xmm0,xmm4
	
	mov edi,dst_y
	vpextrw eax,xmm0,0
	add src,8
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
	
	mov esi,src
	
	dec i
	jnz Convert_RGB32toYV24_AVX_2
	
Convert_RGB32toYV24_AVX_3:	
	mov eax,w
	and eax,1
	jz Convert_RGB32toYV24_AVX_4
	
	movzx edx,byte ptr[esi]
	movzx ecx,byte ptr[esi+1]
	movzx ebx,byte ptr[esi+2] ; ebx=R ecx=G edx=B
	mov esi,lookup
	movzx eax,word ptr[esi+2*ebx]
	add ax,word ptr[esi+2*ecx+512]
	add ax,word ptr[esi+2*edx+1024]
	vpinsrw xmm0,xmm0,eax,0
	movzx eax,word ptr[esi+2*ebx+1536]
	add ax,word ptr[esi+2*ecx+2048]
	add ax,word ptr[esi+2*edx+2560]
	vpinsrw xmm0,xmm0,eax,2
	movzx eax,word ptr[esi+2*ebx+3072]
	add ax,word ptr[esi+2*ecx+3584]
	add ax,word ptr[esi+2*edx+4096]
	vpinsrw xmm0,xmm0,eax,4
	
	vpaddsw xmm0,xmm0,xmm1
	vpsraw xmm0,xmm0,6
	vpmaxsw xmm0,xmm0,xmm2
	vpminsw xmm0,xmm0,xmm3
	
	mov edi,dst_y
	vpextrw eax,xmm0,0
	add src,4
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
	
	mov esi,src	
	
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
	mov src,esi
	dec h
	jnz Convert_RGB32toYV24_AVX_1

	pop ebx
	pop edi
	pop esi

	ret

JPSDR_RGBConvert_Convert_RGB32toYV24_AVX endp


end





