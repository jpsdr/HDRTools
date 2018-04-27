.data

.code

;JPSDR_HDRTools_Move8to16 proc dst:dword,src:dword,w:dword
; dst = rcx
; src = rdx
; w = r8d

JPSDR_HDRTools_Move8to16 proc public frame

	push rsi
	.pushreg rsi
	push rdi
	.pushreg rdi
	.endprolog
	
	mov rdi,rcx
	xor rax,rax	
	xor rcx,rcx
	mov rsi,rdx
	mov ecx,r8d
	
	stosb
	dec rcx
	jz short Move8to16_2
	
Move8to16_1:
	lodsb
	stosw
	loop Move8to16_1
	
Move8to16_2:
	
	movsb
	
	pop rdi
	pop rsi

	ret
	
JPSDR_HDRTools_Move8to16 endp	


;JPSDR_HDRTools_Move8to16_SSE2 proc dst:dword,src:dword,w:dword
; dst = rcx
; src = rdx
; w = r8d
JPSDR_HDRTools_Move8to16_SSE2 proc public frame

	.endprolog
	
	mov r9,rcx
	mov r10,16
	xor rcx,rcx
	xor rax,rax
	mov ecx,r8d
	pxor xmm0,xmm0
		
Move8to16_SSE2_1:
	movdqa xmm1,XMMWORD ptr [rdx+rax]
	movdqa xmm2,xmm0
	movdqa xmm3,xmm0
	punpcklbw xmm2,xmm1
	punpckhbw xmm3,xmm1
	movdqa XMMWORD ptr [r9+2*rax],xmm2
	movdqa XMMWORD ptr [r9+2*rax+16],xmm3
	add rax,r10
	loop Move8to16_SSE2_1
	
	ret
	
JPSDR_HDRTools_Move8to16_SSE2 endp	


;JPSDR_HDRTools_Move8to16_AVX proc dst:dword,src:dword,w:dword
; dst = rcx
; src = rdx
; w = r8d
JPSDR_HDRTools_Move8to16_AVX proc public frame

	.endprolog
	
	mov r9,rcx
	mov r10,16
	xor rcx,rcx
	xor rax,rax
	mov ecx,r8d
	vpxor xmm0,xmm0,xmm0
		
Move8to16_AVX_1:
	vpunpcklbw xmm2,xmm0,XMMWORD ptr [rdx+rax]
	vpunpckhbw xmm3,xmm0,XMMWORD ptr [rdx+rax]
	vmovdqa XMMWORD ptr [r9+2*rax],xmm2
	vmovdqa XMMWORD ptr [r9+2*rax+16],xmm3
	add rax,r10
	loop Move8to16_AVX_1
	
	ret
	
JPSDR_HDRTools_Move8to16_AVX endp	


;JPSDR_HDRTools_Convert420_to_Planar422_8_SSE2 proc src1:dword,src2:dword,dst:dword,w:dword
; src1 = rcx
; src2 = rdx
; dst = r8
; w = r9d

JPSDR_HDRTools_Convert420_to_Planar422_8_SSE2 proc public frame

	.endprolog
		
	pcmpeqb xmm3,xmm3
	
	mov r10,rcx				; r10=src1
	xor rcx,rcx
	xor rax,rax	
	mov ecx,r9d	
	mov r11,16
	
Convert420_to_Planar422_8_SSE2_1:
	movdqa xmm0,XMMWORD ptr[r10+rax]
	movdqa xmm1,XMMWORD ptr[rdx+rax]
	movdqa xmm2,xmm0
	pxor xmm0,xmm3
	pxor xmm1,xmm3
	pavgb xmm0,xmm1
	pxor xmm0,xmm3
	pavgb xmm0,xmm2
	
	movdqa XMMWORD ptr[r8+rax],xmm0
	add rax,r11
	loop Convert420_to_Planar422_8_SSE2_1
	
	ret

JPSDR_HDRTools_Convert420_to_Planar422_8_SSE2 endp


;JPSDR_HDRTools_Convert420_to_Planar422_8to16_SSE2 proc src1:dword,src2:dword,dst:dword,w:dword
; src1 = rcx
; src2 = rdx
; dst = r8
; w = r9d

JPSDR_HDRTools_Convert420_to_Planar422_8to16_SSE2 proc public frame

	.endprolog
		
	pcmpeqb xmm3,xmm3
	
	mov r10,rcx				; r10=src1
	xor rcx,rcx
	xor rax,rax	
	mov ecx,r9d	
	mov r11,8
	
Convert420_to_Planar422_8to16_SSE2_1:
	movq xmm0,qword ptr[r10+rax]
	movq xmm1,qword ptr[rdx+rax]
	
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
	
	movdqa XMMWORD ptr[r8+2*rax],xmm2
	add rax,r11
	loop Convert420_to_Planar422_8to16_SSE2_1
	
	ret

JPSDR_HDRTools_Convert420_to_Planar422_8to16_SSE2 endp


;JPSDR_HDRTools_Convert420_to_Planar422_8_AVX proc src1:dword,src2:dword,dst:dword,w:dword
; src1 = rcx
; src2 = rdx
; dst = r8
; w = r9d

JPSDR_HDRTools_Convert420_to_Planar422_8_AVX proc public frame

	.endprolog
		
	vpcmpeqb xmm3,xmm3,xmm3
	
	mov r10,rcx				; r10=src1
	xor rcx,rcx
	xor rax,rax	
	mov ecx,r9d	
	mov r11,16
	
Convert420_to_Planar422_8_AVX_1:
	vmovdqa xmm0,XMMWORD ptr[r10+rax]
	vmovdqa xmm1,XMMWORD ptr[rdx+rax]
	vpxor xmm2,xmm0,xmm3
	vpxor xmm1,xmm1,xmm3
	vpavgb xmm2,xmm2,xmm1
	vpxor xmm2,xmm2,xmm3
	vpavgb xmm2,xmm2,xmm0
	
	vmovdqa XMMWORD ptr[r8+rax],xmm2
	add rax,r11
	loop Convert420_to_Planar422_8_AVX_1
	
	ret

JPSDR_HDRTools_Convert420_to_Planar422_8_AVX endp


;JPSDR_HDRTools_Convert420_to_Planar422_8to16_AVX proc src1:dword,src2:dword,dst:dword,w:dword
; src1 = rcx
; src2 = rdx
; dst = r8
; w = r9d

JPSDR_HDRTools_Convert420_to_Planar422_8to16_AVX proc public frame

	.endprolog
		
	vpcmpeqb xmm3,xmm3,xmm3	
	vpxor xmm4,xmm4,xmm4
	
	mov r10,rcx				; r10=src1
	xor rcx,rcx
	xor rax,rax	
	mov ecx,r9d	
	mov r11,8
	
Convert420_to_Planar422_8to16_AVX_1:
	vmovq xmm0,qword ptr[r10+rax]
	vmovq xmm1,qword ptr[rdx+rax]
	vpunpcklbw xmm0,xmm4,xmm0
	vpunpcklbw xmm1,xmm4,xmm1
	
	vpxor xmm2,xmm0,xmm3
	vpxor xmm1,xmm1,xmm3
	vpavgw xmm2,xmm2,xmm1
	vpxor xmm2,xmm2,xmm3
	vpavgw xmm2,xmm2,xmm0

	vmovdqa XMMWORD ptr[r8+2*rax],xmm2
	add rax,r11
	loop Convert420_to_Planar422_8to16_AVX_1
	
	ret

JPSDR_HDRTools_Convert420_to_Planar422_8to16_AVX endp


;JPSDR_HDRTools_Convert420_to_Planar422_16_SSE2 proc src1:dword,src2:dword,dst:dword,w:dword
; src1 = rcx
; src2 = rdx
; dst = r8
; w = r9d

JPSDR_HDRTools_Convert420_to_Planar422_16_SSE2 proc public frame

	.endprolog
		
	pcmpeqb xmm3,xmm3
	
	mov r10,rcx				; r10=src1
	xor rcx,rcx
	xor rax,rax	
	mov ecx,r9d	
	mov r11,16
	
Convert420_to_Planar422_16_SSE2_1:
	movdqa xmm0,XMMWORD ptr[r10+rax]
	movdqa xmm1,XMMWORD ptr[rdx+rax]
	movdqa xmm2,xmm0
	pxor xmm0,xmm3
	pxor xmm1,xmm3
	pavgw xmm0,xmm1
	pxor xmm0,xmm3
	pavgw xmm0,xmm2
	
	movdqa XMMWORD ptr[r8+rax],xmm0
	add rax,r11
	loop Convert420_to_Planar422_16_SSE2_1
	
	ret

JPSDR_HDRTools_Convert420_to_Planar422_16_SSE2 endp


;JPSDR_HDRTools_Convert420_to_Planar422_16_AVX proc src1:dword,src2:dword,dst:dword,w:dword
; src1 = rcx
; src2 = rdx
; dst = r8
; w = r9d

JPSDR_HDRTools_Convert420_to_Planar422_16_AVX proc public frame

	.endprolog
		
	vpcmpeqb xmm3,xmm3,xmm3
	
	mov r10,rcx				; r10=src1
	xor rcx,rcx
	xor rax,rax	
	mov ecx,r9d	
	mov r11,16
	
Convert420_to_Planar422_16_AVX_1:
	vmovdqa xmm0,XMMWORD ptr[r10+rax]
	vmovdqa xmm1,XMMWORD ptr[rdx+rax]
	vpxor xmm2,xmm0,xmm3
	vpxor xmm1,xmm1,xmm3
	vpavgw xmm2,xmm2,xmm1
	vpxor xmm2,xmm2,xmm3
	vpavgw xmm2,xmm2,xmm0
	
	vmovdqa XMMWORD ptr[r8+rax],xmm2
	add rax,r11
	loop Convert420_to_Planar422_16_AVX_1
	
	ret

JPSDR_HDRTools_Convert420_to_Planar422_16_AVX endp


;JPSDR_HDRTools_Convert422_to_Planar444_8_SSE2 proc src:dword,dst:dword,w:dword
; src = rcx
; dst = rdx
; w = r8d

JPSDR_HDRTools_Convert422_to_Planar444_8_SSE2 proc public frame

	.endprolog
		
	mov r9,rcx				; r9=src
	xor rcx,rcx
	xor rax,rax	
	mov ecx,r8d	
	mov r10,16
	
Convert420_to_Planar422_8_SSE2_1:
	movdqa xmm0,XMMWORD ptr[r9+rax]
	movdqu xmm1,XMMWORD ptr[r9+rax+1]
	movdqa xmm2,xmm0
	pavgb xmm1,xmm0
	movdqa xmm3,xmm0
	punpcklbw xmm2,xmm1
	punpckhbw xmm3,xmm1	
	
	movdqa XMMWORD ptr[rdx+2*rax],xmm2
	movdqa XMMWORD ptr[rdx+2*rax+16],xmm3
	add rax,r10
	loop Convert420_to_Planar422_8_SSE2_1
	
	ret

JPSDR_HDRTools_Convert422_to_Planar444_8_SSE2 endp


;JPSDR_HDRTools_Convert422_to_Planar444_8_AVX proc src:dword,dst:dword,w:dword
; src = rcx
; dst = rdx
; w = r8d

JPSDR_HDRTools_Convert422_to_Planar444_8_AVX proc public frame

	.endprolog
		
	mov r9,rcx				; r9=src
	xor rcx,rcx
	xor rax,rax	
	mov ecx,r8d	
	mov r10,16
	
Convert420_to_Planar422_8_AVX_1:
	vmovdqa xmm0,XMMWORD ptr[r9+rax]
	vmovdqu xmm1,XMMWORD ptr[r9+rax+1]
	vpavgb xmm1,xmm1,xmm0
	vpunpcklbw xmm2,xmm0,xmm1
	vpunpckhbw xmm3,xmm0,xmm1
	
	vmovdqa XMMWORD ptr[rdx+2*rax],xmm2
	vmovdqa XMMWORD ptr[rdx+2*rax+16],xmm3
	add rax,r10
	loop Convert420_to_Planar422_8_AVX_1
	
	ret

JPSDR_HDRTools_Convert422_to_Planar444_8_AVX endp


;JPSDR_HDRTools_Convert422_to_Planar444_8to16_SSE2 proc src:dword,dst:dword,w:dword
; src = rcx
; dst = rdx
; w = r8d

JPSDR_HDRTools_Convert422_to_Planar444_8to16_SSE2 proc public frame

	.endprolog
		
	mov r9,rcx				; r9=src
	xor rcx,rcx
	xor rax,rax	
	mov ecx,r8d	
	mov r10,32
	xor r11,r11
	
Convert420_to_Planar422_8to16_SSE2_1:
	movq xmm0,qword ptr[r9+8*rax]
	movq xmm1,qword ptr[r9+8*rax+1]
	pxor xmm2,xmm2
	pxor xmm3,xmm3
	punpcklbw xmm2,xmm0
	punpcklbw xmm3,xmm1
	
	pavgw xmm3,xmm2
	movdqa xmm0,xmm2	
	punpcklwd xmm2,xmm3
	punpckhwd xmm0,xmm3
	
	movdqa XMMWORD ptr[rdx+r11],xmm2
	movdqa XMMWORD ptr[rdx+r11+16],xmm0
	inc rax
	add r11,r10
	loop Convert420_to_Planar422_8to16_SSE2_1
	
	ret

JPSDR_HDRTools_Convert422_to_Planar444_8to16_SSE2 endp


;JPSDR_HDRTools_Convert422_to_Planar444_8to16_AVX proc src:dword,dst:dword,w:dword
; src = rcx
; dst = rdx
; w = r8d

JPSDR_HDRTools_Convert422_to_Planar444_8to16_AVX proc public frame

	.endprolog
		
	vpxor xmm4,xmm4,xmm4
	mov r9,rcx				; r9=src
	xor rcx,rcx
	xor rax,rax	
	mov ecx,r8d	
	mov r10,32
	xor r11,r11
	
Convert420_to_Planar422_8to16_AVX_1:
	vmovq xmm0,qword ptr[r9+8*rax]
	vmovq xmm1,qword ptr[r9+8*rax+1]	
	vpunpcklbw xmm0,xmm4,xmm0
	vpunpcklbw xmm1,xmm4,xmm1
	
	vpavgw xmm1,xmm1,xmm0
	vpunpcklwd xmm2,xmm0,xmm1
	vpunpckhwd xmm3,xmm0,xmm1
	
	vmovdqa XMMWORD ptr[rdx+r11],xmm2
	vmovdqa XMMWORD ptr[rdx+r11+16],xmm0
	inc rax
	add r11,r10
	loop Convert420_to_Planar422_8to16_AVX_1
	
	ret

JPSDR_HDRTools_Convert422_to_Planar444_8to16_AVX endp


;JPSDR_HDRTools_Convert422_to_Planar444_16_SSE2 proc src:dword,dst:dword,w:dword
; src = rcx
; dst = rdx
; w = r8d

JPSDR_HDRTools_Convert422_to_Planar444_16_SSE2 proc public frame

	.endprolog
		
	mov r9,rcx				; r9=src
	xor rcx,rcx
	xor rax,rax	
	mov ecx,r8d	
	mov r10,16
	
Convert420_to_Planar422_16_SSE2_1:
	movdqa xmm0,XMMWORD ptr[r9+rax]
	movdqu xmm1,XMMWORD ptr[r9+rax+2]
	movdqa xmm2,xmm0
	pavgw xmm1,xmm0
	movdqa xmm3,xmm0
	punpcklwd xmm2,xmm1
	punpckhwd xmm3,xmm1	
	
	movdqa XMMWORD ptr[rdx+2*rax],xmm2
	movdqa XMMWORD ptr[rdx+2*rax+16],xmm3
	add rax,r10
	loop Convert420_to_Planar422_16_SSE2_1
	
	ret

JPSDR_HDRTools_Convert422_to_Planar444_16_SSE2 endp


;JPSDR_HDRTools_Convert422_to_Planar444_16_AVX proc src:dword,dst:dword,w:dword
; src = rcx
; dst = rdx
; w = r8d

JPSDR_HDRTools_Convert422_to_Planar444_16_AVX proc public frame

	.endprolog
		
	mov r9,rcx				; r9=src
	xor rcx,rcx
	xor rax,rax	
	mov ecx,r8d	
	mov r10,16
	
Convert420_to_Planar422_16_AVX_1:
	vmovdqa xmm0,XMMWORD ptr[r9+rax]
	vmovdqu xmm1,XMMWORD ptr[r9+rax+2]
	vpavgw xmm1,xmm1,xmm0
	vpunpcklwd xmm2,xmm0,xmm1
	vpunpckhwd xmm3,xmm0,xmm1
	
	vmovdqa XMMWORD ptr[rdx+2*rax],xmm2
	vmovdqa XMMWORD ptr[rdx+2*rax+16],xmm3
	add rax,r10
	loop Convert420_to_Planar422_16_AVX_1
	
	ret

JPSDR_HDRTools_Convert422_to_Planar444_16_AVX endp


end
