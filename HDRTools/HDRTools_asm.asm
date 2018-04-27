.586
.xmm
.model flat,c

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


end





