.data

data segment align(32)

data_f_65535 real4 8 dup(65535.0)


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


;JPSDR_HDRTools_Convert_YV24toRGB32_SSE2 proc src_y:dword,src_u:dword,src_v:dword,dst:dword,w:dword,h:dword,offset_R:word,
; offset_G:word,offset_B:word,lookup:dword,src_modulo_y:dword,src_modulo_u:dword,src_modulo_v:dword,dst_modulo:dword
; src_y = rcx
; src_u = rdx
; src_v = r8
; dst = r9

JPSDR_HDRTools_Convert_YV24toRGB32_SSE2 proc public frame

w equ dword ptr[rbp+48]
h equ dword ptr[rbp+56]
offset_R equ word ptr[rbp+64]
offset_G equ word ptr[rbp+72]
offset_B equ word ptr[rbp+80]
lookup equ qword ptr[rbp+88]
src_modulo_y equ qword ptr[rbp+96]
src_modulo_u equ qword ptr[rbp+104]
src_modulo_v equ qword ptr[rbp+112]
dst_modulo equ qword ptr[rbp+120]

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

	xor rax,rax
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
	mov rsi,rcx					;rsi=src_y
	mov r11,rdx					;r11=src_u
	mov r12,r8					;r12=src_v
	mov rdi,r9
	mov r9d,w
	mov r10,lookup
	mov r13,2
	mov r14,8
	
	mov r8d,r9d
	shr r8d,1					;r8d=w0
	
	xor rcx,rcx
	xor rdx,rdx
	xor rbx,rbx
	xor r15,r15

Convert_YV24toRGB32_SSE2_1:
	or r8d,r8d
	jz Convert_YV24toRGB32_SSE2_3
	mov ecx,r8d
Convert_YV24toRGB32_SSE2_2:
	movzx ebx,byte ptr[rsi]
	movzx r15d,byte ptr[r11]
	movzx edx,byte ptr[r12] ; rbx=Y r15=U rdx=V
	movzx eax,word ptr[r10+2*rbx]
	add ax,word ptr[r10+2*rdx+512]
	pinsrw xmm0,eax,2
	movzx eax,word ptr[r10+2*rbx]
	add ax,word ptr[r10+2*r15+1024]
	add ax,word ptr[r10+2*rdx+1536]
	pinsrw xmm0,eax,1
	movzx eax,word ptr[r10+2*rbx]
	add ax,word ptr[r10+2*r15+2048]
	pinsrw xmm0,eax,0
	movzx ebx,byte ptr[rsi+1]
	movzx r15d,byte ptr[r11+1]
	movzx edx,byte ptr[r12+1] ; rbx=Y r15=U rdx=V
	movzx eax,word ptr[r10+2*rbx]
	add ax,word ptr[r10+2*rdx+512]
	add rsi,r13
	pinsrw xmm0,eax,6
	movzx eax,word ptr[r10+2*rbx]
	add ax,word ptr[r10+2*r15+1024]
	add ax,word ptr[r10+2*rdx+1536]
	add r11,r13
	pinsrw xmm0,eax,5
	movzx eax,word ptr[r10+2*rbx]
	add ax,word ptr[r10+2*r15+2048]
	add r12,r13
	pinsrw xmm0,eax,4
	
	paddsw xmm0,xmm1
	psraw xmm0,5
	packuswb xmm0,xmm2
	
	movq qword ptr[rdi],xmm0
	
	add rdi,r14
	
	dec ecx
	jnz Convert_YV24toRGB32_SSE2_2
	
Convert_YV24toRGB32_SSE2_3:	
	mov eax,r9d
	and eax,1
	jz Convert_YV24toRGB32_SSE2_4
	
	movzx ebx,byte ptr[rsi]
	movzx r15d,byte ptr[r11]
	movzx edx,byte ptr[r12] ; rbx=Y r15=U rdx=V
	movzx eax,word ptr[r10+2*rbx]
	add ax,word ptr[r10+2*rdx+512]
	inc rsi
	pinsrw xmm0,eax,2
	movzx eax,word ptr[r10+2*rbx]
	add ax,word ptr[r10+2*r15+1024]
	add ax,word ptr[r10+2*rdx+1536]
	inc r11
	pinsrw xmm0,eax,1
	movzx eax,word ptr[r10+2*rbx]
	add ax,word ptr[r10+2*r15+2048]
	inc r12
	pinsrw xmm0,eax,0
	
	paddsw xmm0,xmm1
	psraw xmm0,5
	packuswb xmm0,xmm2
	
	movd dword ptr[rdi],xmm0
	
	add rdi,4
	
Convert_YV24toRGB32_SSE2_4:	
	add rsi,src_modulo_y
	add r11,src_modulo_u
	add r12,src_modulo_v
	add rdi,dst_modulo
	dec h
	jnz Convert_YV24toRGB32_SSE2_1

	pop r15
	pop r14
	pop r13
	pop r12
	pop rbx
	pop rsi
	pop rdi
	pop rbp
	
	ret

JPSDR_HDRTools_Convert_YV24toRGB32_SSE2 endp


;JPSDR_HDRTools_Convert_YV24toRGB32_AVX proc src_y:dword,src_u:dword,src_v:dword,dst:dword,w:dword,h:dword,offset_R:word,
; offset_G:word,offset_B:word,lookup:dword,src_modulo_y:dword,src_modulo_u:dword,src_modulo_v:dword,dst_modulo:dword
; src_y = rcx
; src_u = rdx
; src_v = r8
; dst = r9

JPSDR_HDRTools_Convert_YV24toRGB32_AVX proc public frame

w equ dword ptr[rbp+48]
h equ dword ptr[rbp+56]
offset_R equ word ptr[rbp+64]
offset_G equ word ptr[rbp+72]
offset_B equ word ptr[rbp+80]
lookup equ qword ptr[rbp+88]
src_modulo_y equ qword ptr[rbp+96]
src_modulo_u equ qword ptr[rbp+104]
src_modulo_v equ qword ptr[rbp+112]
dst_modulo equ qword ptr[rbp+120]

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

	xor rax,rax
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
	mov rsi,rcx					;rsi=src_y
	mov r11,rdx					;r11=src_u
	mov r12,r8					;r12=src_v
	mov rdi,r9
	mov r9d,w
	mov r10,lookup
	mov r13,2
	mov r14,8
	
	mov r8d,r9d
	shr r8d,1					;r8d=w0
	
	xor rcx,rcx
	xor rdx,rdx
	xor rbx,rbx
	xor r15,r15

Convert_YV24toRGB32_AVX_1:
	or r8d,r8d
	jz Convert_YV24toRGB32_AVX_3
	
	mov ecx,r8d
Convert_YV24toRGB32_AVX_2:
	movzx ebx,byte ptr[rsi]
	movzx r15d,byte ptr[r11]
	movzx edx,byte ptr[r12] ; rbx=Y r15=U rdx=V
	movzx eax,word ptr[r10+2*rbx]
	add ax,word ptr[r10+2*rdx+512]
	vpinsrw xmm0,xmm0,eax,2
	movzx eax,word ptr[r10+2*rbx]
	add ax,word ptr[r10+2*r15+1024]
	add ax,word ptr[r10+2*rdx+1536]
	vpinsrw xmm0,xmm0,eax,1
	movzx eax,word ptr[r10+2*rbx]
	add ax,word ptr[r10+2*r15+2048]
	vpinsrw xmm0,xmm0,eax,0
	movzx ebx,byte ptr[rsi+1]
	movzx r15d,byte ptr[r11+1]
	movzx edx,byte ptr[r12+1] ; rbx=Y r15=U rdx=V
	movzx eax,word ptr[r10+2*rbx]
	add ax,word ptr[r10+2*rdx+512]
	add rsi,r13
	vpinsrw xmm0,xmm0,eax,6
	movzx eax,word ptr[r10+2*rbx]
	add ax,word ptr[r10+2*r15+1024]
	add ax,word ptr[r10+2*rdx+1536]
	add r11,r13
	vpinsrw xmm0,xmm0,eax,5
	movzx eax,word ptr[r10+2*rbx]
	add ax,word ptr[r10+2*r15+2048]
	add r12,r13
	vpinsrw xmm0,xmm0,eax,4
	
	vpaddsw xmm0,xmm0,xmm1
	vpsraw xmm0,xmm0,5
	vpackuswb xmm0,xmm0,xmm2
	
	vmovq qword ptr[rdi],xmm0
	
	add rdi,r14
	
	dec ecx
	jnz Convert_YV24toRGB32_AVX_2
	
Convert_YV24toRGB32_AVX_3:	
	mov eax,r9d
	and eax,1
	jz Convert_YV24toRGB32_AVX_4
	
	movzx ebx,byte ptr[rsi]
	movzx r15d,byte ptr[r11]
	movzx edx,byte ptr[r12] ; rbx=Y r15=U rdx=V
	movzx eax,word ptr[r10+2*rbx]
	add ax,word ptr[r10+2*rdx+512]
	inc rsi
	vpinsrw xmm0,xmm0,eax,2
	movzx eax,word ptr[r10+2*rbx]
	add ax,word ptr[r10+2*r15+1024]
	add ax,word ptr[r10+2*rdx+1536]
	inc r11
	vpinsrw xmm0,xmm0,eax,1
	movzx eax,word ptr[r10+2*rbx]
	add ax,word ptr[r10+2*r15+2048]
	inc r12
	vpinsrw xmm0,xmm0,eax,0
	
	vpaddsw xmm0,xmm0,xmm1
	vpsraw xmm0,xmm0,5
	vpackuswb xmm0,xmm0,xmm2
	
	vmovd dword ptr[rdi],xmm0
	
	add rdi,4
	
Convert_YV24toRGB32_AVX_4:	
	add rsi,src_modulo_y
	add r11,src_modulo_u
	add r12,src_modulo_v
	add rdi,dst_modulo
	dec h
	jnz Convert_YV24toRGB32_AVX_1

	pop r15
	pop r14
	pop r13
	pop r12
	pop rbx
	pop rsi
	pop rdi
	pop rbp
	
	ret

JPSDR_HDRTools_Convert_YV24toRGB32_AVX endp


;JPSDR_HDRTools_Convert_8_YV24toRGB64_SSE41 proc src_y:dword,src_u:dword,src_v:dword,dst:dword,w:dword,h:dword,offset_R:dword,
; offset_G:dword,offset_B:dword,lookup:dword,src_modulo_y:dword,src_modulo_u:dword,src_modulo_v:dword,dst_modulo:dword
; src_y = rcx
; src_u = rdx
; src_v = r8
; dst = r9

JPSDR_HDRTools_Convert_8_YV24toRGB64_SSE41 proc public frame

w equ dword ptr[rbp+48]
h equ dword ptr[rbp+56]
offset_R equ dword ptr[rbp+64]
offset_G equ dword ptr[rbp+72]
offset_B equ dword ptr[rbp+80]
lookup equ qword ptr[rbp+88]
src_modulo_y equ qword ptr[rbp+96]
src_modulo_u equ qword ptr[rbp+104]
src_modulo_v equ qword ptr[rbp+112]
dst_modulo equ qword ptr[rbp+120]

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

	xor rax,rax
	pxor xmm2,xmm2
	pxor xmm1,xmm1
	pxor xmm0,xmm0
	mov eax,offset_B
	pinsrd xmm1,eax,0
	mov eax,offset_G
	pinsrd xmm1,eax,1
	mov eax,offset_R
	pinsrd xmm1,eax,2
	mov rsi,rcx					;rsi=src_y
	mov r11,rdx					;r11=src_u
	mov r12,r8					;r12=src_v
	mov rdi,r9
	mov r9d,w
	mov r10,lookup
	mov r13,2
	mov r14,8
	
	mov r8d,r9d					;r8d=w0
	
	xor rcx,rcx
	xor rdx,rdx
	xor rbx,rbx
	xor r15,r15

Convert_8_YV24toRGB64_SSE41_1:
	mov ecx,r8d
Convert_8_YV24toRGB64_SSE41_2:
	movzx ebx,byte ptr[rsi]
	movzx r15d,byte ptr[r11]
	movzx edx,byte ptr[r12] ; rbx=Y r15=U rdx=V
	mov eax,dword ptr[r10+4*rbx]
	add eax,dword ptr[r10+4*rdx+1024]
	pinsrd xmm0,eax,2
	inc rsi
	mov eax,dword ptr[r10+4*rbx]
	add eax,dword ptr[r10+4*r15+2048]
	add eax,dword ptr[r10+4*rdx+3072]
	pinsrd xmm0,eax,1
	inc r11
	mov eax,dword ptr[r10+4*rbx]
	add eax,dword ptr[r10+4*r15+4096]
	pinsrd xmm0,eax,0
	inc r12
	
	paddd xmm0,xmm1
	psrad xmm0,8
	packusdw xmm0,xmm2
	
	movq qword ptr[rdi],xmm0
	
	add rdi,r14
	
	dec ecx
	jnz short Convert_8_YV24toRGB64_SSE41_2
	
	add rsi,src_modulo_y
	add r11,src_modulo_u
	add r12,src_modulo_v
	add rdi,dst_modulo
	dec h
	jnz Convert_8_YV24toRGB64_SSE41_1

	pop r15
	pop r14
	pop r13
	pop r12
	pop rbx
	pop rsi
	pop rdi
	pop rbp
	
	ret

JPSDR_HDRTools_Convert_8_YV24toRGB64_SSE41 endp


;JPSDR_HDRTools_Convert_10_YV24toRGB64_SSE41 proc src_y:dword,src_u:dword,src_v:dword,dst:dword,w:dword,h:dword,offset_R:dword,
; offset_G:dword,offset_B:dword,lookup:dword,src_modulo_y:dword,src_modulo_u:dword,src_modulo_v:dword,dst_modulo:dword
; src_y = rcx
; src_u = rdx
; src_v = r8
; dst = r9

JPSDR_HDRTools_Convert_10_YV24toRGB64_SSE41 proc public frame

w equ dword ptr[rbp+48]
h equ dword ptr[rbp+56]
offset_R equ dword ptr[rbp+64]
offset_G equ dword ptr[rbp+72]
offset_B equ dword ptr[rbp+80]
lookup equ qword ptr[rbp+88]
src_modulo_y equ qword ptr[rbp+96]
src_modulo_u equ qword ptr[rbp+104]
src_modulo_v equ qword ptr[rbp+112]
dst_modulo equ qword ptr[rbp+120]

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

	xor rax,rax
	pxor xmm2,xmm2
	pxor xmm1,xmm1
	pxor xmm0,xmm0
	mov eax,offset_B
	pinsrd xmm1,eax,0
	mov eax,offset_G
	pinsrd xmm1,eax,1
	mov eax,offset_R
	pinsrd xmm1,eax,2
	mov rsi,rcx					;rsi=src_y
	mov r11,rdx					;r11=src_u
	mov r12,r8					;r12=src_v
	mov rdi,r9
	mov r9d,w
	mov r10,lookup
	mov r13,2
	mov r14,8
	
	mov r8d,r9d					;r8d=w0
	
	xor rcx,rcx
	xor rdx,rdx
	xor rbx,rbx
	xor r15,r15

Convert_10_YV24toRGB64_SSE41_1:
	mov ecx,r8d
Convert_10_YV24toRGB64_SSE41_2:
	movzx ebx,word ptr[rsi]
	movzx r15d,word ptr[r11]
	movzx edx,word ptr[r12] ; rbx=Y r15=U rdx=V
	mov eax,dword ptr[r10+4*rbx]
	add eax,dword ptr[r10+4*rdx+4096]
	pinsrd xmm0,eax,2
	add rsi,r13
	mov eax,dword ptr[r10+4*rbx]
	add eax,dword ptr[r10+4*r15+8192]
	add eax,dword ptr[r10+4*rdx+12288]
	pinsrd xmm0,eax,1
	add r11,r13
	mov eax,dword ptr[r10+4*rbx]
	add eax,dword ptr[r10+4*r15+16384]
	pinsrd xmm0,eax,0
	add r12,r13
	
	paddd xmm0,xmm1
	psrad xmm0,8
	packusdw xmm0,xmm2
	
	movq qword ptr[rdi],xmm0
	
	add rdi,r14
	
	dec ecx
	jnz short Convert_10_YV24toRGB64_SSE41_2
	
	add rsi,src_modulo_y
	add r11,src_modulo_u
	add r12,src_modulo_v
	add rdi,dst_modulo
	dec h
	jnz Convert_10_YV24toRGB64_SSE41_1

	pop r15
	pop r14
	pop r13
	pop r12
	pop rbx
	pop rsi
	pop rdi
	pop rbp
	
	ret

JPSDR_HDRTools_Convert_10_YV24toRGB64_SSE41 endp


;JPSDR_HDRTools_Convert_12_YV24toRGB64_SSE41 proc src_y:dword,src_u:dword,src_v:dword,dst:dword,w:dword,h:dword,offset_R:dword,
; offset_G:dword,offset_B:dword,lookup:dword,src_modulo_y:dword,src_modulo_u:dword,src_modulo_v:dword,dst_modulo:dword
; src_y = rcx
; src_u = rdx
; src_v = r8
; dst = r9

JPSDR_HDRTools_Convert_12_YV24toRGB64_SSE41 proc public frame

w equ dword ptr[rbp+48]
h equ dword ptr[rbp+56]
offset_R equ dword ptr[rbp+64]
offset_G equ dword ptr[rbp+72]
offset_B equ dword ptr[rbp+80]
lookup equ qword ptr[rbp+88]
src_modulo_y equ qword ptr[rbp+96]
src_modulo_u equ qword ptr[rbp+104]
src_modulo_v equ qword ptr[rbp+112]
dst_modulo equ qword ptr[rbp+120]

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

	xor rax,rax
	pxor xmm2,xmm2
	pxor xmm1,xmm1
	pxor xmm0,xmm0
	mov eax,offset_B
	pinsrd xmm1,eax,0
	mov eax,offset_G
	pinsrd xmm1,eax,1
	mov eax,offset_R
	pinsrd xmm1,eax,2
	mov rsi,rcx					;rsi=src_y
	mov r11,rdx					;r11=src_u
	mov r12,r8					;r12=src_v
	mov rdi,r9
	mov r9d,w
	mov r10,lookup
	mov r13,2
	mov r14,8
	
	mov r8d,r9d					;r8d=w0
	
	xor rcx,rcx
	xor rdx,rdx
	xor rbx,rbx
	xor r15,r15

Convert_12_YV24toRGB64_SSE41_1:
	mov ecx,r8d
Convert_12_YV24toRGB64_SSE41_2:
	movzx ebx,word ptr[rsi]
	movzx r15d,word ptr[r11]
	movzx edx,word ptr[r12] ; rbx=Y r15=U rdx=V
	mov eax,dword ptr[r10+4*rbx]
	add eax,dword ptr[r10+4*rdx+16384]
	pinsrd xmm0,eax,2
	add rsi,r13
	mov eax,dword ptr[r10+4*rbx]
	add eax,dword ptr[r10+4*r15+32768]
	add eax,dword ptr[r10+4*rdx+49152]
	pinsrd xmm0,eax,1
	add r11,r13
	mov eax,dword ptr[r10+4*rbx]
	add eax,dword ptr[r10+4*r15+65536]
	pinsrd xmm0,eax,0
	add r12,r13
	
	paddd xmm0,xmm1
	psrad xmm0,8
	packusdw xmm0,xmm2
	
	movq qword ptr[rdi],xmm0
	
	add rdi,r14
	
	dec ecx
	jnz short Convert_12_YV24toRGB64_SSE41_2
	
	add rsi,src_modulo_y
	add r11,src_modulo_u
	add r12,src_modulo_v
	add rdi,dst_modulo
	dec h
	jnz Convert_12_YV24toRGB64_SSE41_1

	pop r15
	pop r14
	pop r13
	pop r12
	pop rbx
	pop rsi
	pop rdi
	pop rbp
	
	ret

JPSDR_HDRTools_Convert_12_YV24toRGB64_SSE41 endp


;JPSDR_HDRTools_Convert_14_YV24toRGB64_SSE41 proc src_y:dword,src_u:dword,src_v:dword,dst:dword,w:dword,h:dword,offset_R:dword,
; offset_G:dword,offset_B:dword,lookup:dword,src_modulo_y:dword,src_modulo_u:dword,src_modulo_v:dword,dst_modulo:dword
; src_y = rcx
; src_u = rdx
; src_v = r8
; dst = r9

JPSDR_HDRTools_Convert_14_YV24toRGB64_SSE41 proc public frame

w equ dword ptr[rbp+48]
h equ dword ptr[rbp+56]
offset_R equ dword ptr[rbp+64]
offset_G equ dword ptr[rbp+72]
offset_B equ dword ptr[rbp+80]
lookup equ qword ptr[rbp+88]
src_modulo_y equ qword ptr[rbp+96]
src_modulo_u equ qword ptr[rbp+104]
src_modulo_v equ qword ptr[rbp+112]
dst_modulo equ qword ptr[rbp+120]

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

	xor rax,rax
	pxor xmm2,xmm2
	pxor xmm1,xmm1
	pxor xmm0,xmm0
	mov eax,offset_B
	pinsrd xmm1,eax,0
	mov eax,offset_G
	pinsrd xmm1,eax,1
	mov eax,offset_R
	pinsrd xmm1,eax,2
	mov rsi,rcx					;rsi=src_y
	mov r11,rdx					;r11=src_u
	mov r12,r8					;r12=src_v
	mov rdi,r9
	mov r9d,w
	mov r10,lookup
	mov r13,2
	mov r14,8
	
	mov r8d,r9d					;r8d=w0
	
	xor rcx,rcx
	xor rdx,rdx
	xor rbx,rbx
	xor r15,r15

Convert_14_YV24toRGB64_SSE41_1:
	mov ecx,r8d
Convert_14_YV24toRGB64_SSE41_2:
	movzx ebx,word ptr[rsi]
	movzx r15d,word ptr[r11]
	movzx edx,word ptr[r12] ; rbx=Y r15=U rdx=V
	mov eax,dword ptr[r10+4*rbx]
	add eax,dword ptr[r10+4*rdx+65536]
	pinsrd xmm0,eax,2
	add rsi,r13
	mov eax,dword ptr[r10+4*rbx]
	add eax,dword ptr[r10+4*r15+131072]
	add eax,dword ptr[r10+4*rdx+196608]
	pinsrd xmm0,eax,1
	add r11,r13
	mov eax,dword ptr[r10+4*rbx]
	add eax,dword ptr[r10+4*r15+262144]
	pinsrd xmm0,eax,0
	add r12,r13
	
	paddd xmm0,xmm1
	psrad xmm0,8
	packusdw xmm0,xmm2
	
	movq qword ptr[rdi],xmm0
	
	add rdi,r14
	
	dec ecx
	jnz short Convert_14_YV24toRGB64_SSE41_2
	
	add rsi,src_modulo_y
	add r11,src_modulo_u
	add r12,src_modulo_v
	add rdi,dst_modulo
	dec h
	jnz Convert_14_YV24toRGB64_SSE41_1

	pop r15
	pop r14
	pop r13
	pop r12
	pop rbx
	pop rsi
	pop rdi
	pop rbp
	
	ret

JPSDR_HDRTools_Convert_14_YV24toRGB64_SSE41 endp


;JPSDR_HDRTools_Convert_16_YV24toRGB64_SSE41 proc src_y:dword,src_u:dword,src_v:dword,dst:dword,w:dword,h:dword,offset_R:dword,
; offset_G:dword,offset_B:dword,lookup:dword,src_modulo_y:dword,src_modulo_u:dword,src_modulo_v:dword,dst_modulo:dword
; src_y = rcx
; src_u = rdx
; src_v = r8
; dst = r9

JPSDR_HDRTools_Convert_16_YV24toRGB64_SSE41 proc public frame

w equ dword ptr[rbp+48]
h equ dword ptr[rbp+56]
offset_R equ dword ptr[rbp+64]
offset_G equ dword ptr[rbp+72]
offset_B equ dword ptr[rbp+80]
lookup equ qword ptr[rbp+88]
src_modulo_y equ qword ptr[rbp+96]
src_modulo_u equ qword ptr[rbp+104]
src_modulo_v equ qword ptr[rbp+112]
dst_modulo equ qword ptr[rbp+120]

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

	xor rax,rax
	pxor xmm2,xmm2
	pxor xmm1,xmm1
	pxor xmm0,xmm0
	mov eax,offset_B
	pinsrd xmm1,eax,0
	mov eax,offset_G
	pinsrd xmm1,eax,1
	mov eax,offset_R
	pinsrd xmm1,eax,2
	mov rsi,rcx					;rsi=src_y
	mov r11,rdx					;r11=src_u
	mov r12,r8					;r12=src_v
	mov rdi,r9
	mov r9d,w
	mov r10,lookup
	mov r13,2
	mov r14,8
	
	mov r8d,r9d					;r8d=w0
	
	xor rcx,rcx
	xor rdx,rdx
	xor rbx,rbx
	xor r15,r15

Convert_16_YV24toRGB64_SSE41_1:
	mov ecx,r8d
Convert_16_YV24toRGB64_SSE41_2:
	movzx ebx,word ptr[rsi]
	movzx r15d,word ptr[r11]
	movzx edx,word ptr[r12] ; rbx=Y r15=U rdx=V
	mov eax,dword ptr[r10+4*rbx]
	add eax,dword ptr[r10+4*rdx+262144]
	pinsrd xmm0,eax,2
	add rsi,r13
	mov eax,dword ptr[r10+4*rbx]
	add eax,dword ptr[r10+4*r15+524288]
	add eax,dword ptr[r10+4*rdx+786432]
	pinsrd xmm0,eax,1
	add r11,r13
	mov eax,dword ptr[r10+4*rbx]
	add eax,dword ptr[r10+4*r15+1048576]
	pinsrd xmm0,eax,0
	add r12,r13
	
	paddd xmm0,xmm1
	psrad xmm0,8
	packusdw xmm0,xmm2
	
	movq qword ptr[rdi],xmm0
	
	add rdi,r14
	
	dec ecx
	jnz short Convert_16_YV24toRGB64_SSE41_2
	
	add rsi,src_modulo_y
	add r11,src_modulo_u
	add r12,src_modulo_v
	add rdi,dst_modulo
	dec h
	jnz Convert_16_YV24toRGB64_SSE41_1

	pop r15
	pop r14
	pop r13
	pop r12
	pop rbx
	pop rsi
	pop rdi
	pop rbp
	
	ret

JPSDR_HDRTools_Convert_16_YV24toRGB64_SSE41 endp


;JPSDR_HDRTools_Convert_8_YV24toRGB64_AVX proc src_y:dword,src_u:dword,src_v:dword,dst:dword,w:dword,h:dword,offset_R:dword,
; offset_G:dword,offset_B:dword,lookup:dword,src_modulo_y:dword,src_modulo_u:dword,src_modulo_v:dword,dst_modulo:dword
; src_y = rcx
; src_u = rdx
; src_v = r8
; dst = r9

JPSDR_HDRTools_Convert_8_YV24toRGB64_AVX proc public frame

w equ dword ptr[rbp+48]
h equ dword ptr[rbp+56]
offset_R equ dword ptr[rbp+64]
offset_G equ dword ptr[rbp+72]
offset_B equ dword ptr[rbp+80]
lookup equ qword ptr[rbp+88]
src_modulo_y equ qword ptr[rbp+96]
src_modulo_u equ qword ptr[rbp+104]
src_modulo_v equ qword ptr[rbp+112]
dst_modulo equ qword ptr[rbp+120]

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

	xor rax,rax
	vpxor xmm2,xmm2,xmm2
	vpxor xmm1,xmm1,xmm1
	vpxor xmm0,xmm0,xmm0
	mov eax,offset_B
	vpinsrd xmm1,xmm1,eax,0
	mov eax,offset_G
	vpinsrd xmm1,xmm1,eax,1
	mov eax,offset_R
	vpinsrd xmm1,xmm1,eax,2
	mov rsi,rcx					;rsi=src_y
	mov r11,rdx					;r11=src_u
	mov r12,r8					;r12=src_v
	mov rdi,r9
	mov r9d,w
	mov r10,lookup
	mov r13,2
	mov r14,8
	
	mov r8d,r9d					;r8d=w0
	
	xor rcx,rcx
	xor rdx,rdx
	xor rbx,rbx
	xor r15,r15

Convert_8_YV24toRGB64_AVX_1:
	mov ecx,r8d
Convert_8_YV24toRGB64_AVX_2:
	movzx ebx,byte ptr[rsi]
	movzx r15d,byte ptr[r11]
	movzx edx,byte ptr[r12] ; rbx=Y r15=U rdx=V
	mov eax,dword ptr[r10+4*rbx]
	add eax,dword ptr[r10+4*rdx+1024]
	vpinsrd xmm0,xmm0,eax,2
	inc rsi
	mov eax,dword ptr[r10+4*rbx]
	add eax,dword ptr[r10+4*r15+2048]
	add eax,dword ptr[r10+4*rdx+3072]
	vpinsrd xmm0,xmm0,eax,1
	inc r11
	mov eax,dword ptr[r10+4*rbx]
	add eax,dword ptr[r10+4*r15+4096]
	vpinsrd xmm0,xmm0,eax,0
	inc r12
	
	vpaddd xmm0,xmm0,xmm1
	vpsrad xmm0,xmm0,8
	vpackusdw xmm0,xmm0,xmm2
	
	vmovq qword ptr[rdi],xmm0
	
	add rdi,r14
	
	dec ecx
	jnz short Convert_8_YV24toRGB64_AVX_2
	
	add rsi,src_modulo_y
	add r11,src_modulo_u
	add r12,src_modulo_v
	add rdi,dst_modulo
	dec h
	jnz Convert_8_YV24toRGB64_AVX_1

	pop r15
	pop r14
	pop r13
	pop r12
	pop rbx
	pop rsi
	pop rdi
	pop rbp
	
	ret

JPSDR_HDRTools_Convert_8_YV24toRGB64_AVX endp


;JPSDR_HDRTools_Convert_10_YV24toRGB64_AVX proc src_y:dword,src_u:dword,src_v:dword,dst:dword,w:dword,h:dword,offset_R:dword,
; offset_G:dword,offset_B:dword,lookup:dword,src_modulo_y:dword,src_modulo_u:dword,src_modulo_v:dword,dst_modulo:dword
; src_y = rcx
; src_u = rdx
; src_v = r8
; dst = r9

JPSDR_HDRTools_Convert_10_YV24toRGB64_AVX proc public frame

w equ dword ptr[rbp+48]
h equ dword ptr[rbp+56]
offset_R equ dword ptr[rbp+64]
offset_G equ dword ptr[rbp+72]
offset_B equ dword ptr[rbp+80]
lookup equ qword ptr[rbp+88]
src_modulo_y equ qword ptr[rbp+96]
src_modulo_u equ qword ptr[rbp+104]
src_modulo_v equ qword ptr[rbp+112]
dst_modulo equ qword ptr[rbp+120]

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

	xor rax,rax
	vpxor xmm2,xmm2,xmm2
	vpxor xmm1,xmm1,xmm1
	vpxor xmm0,xmm0,xmm0
	mov eax,offset_B
	vpinsrd xmm1,xmm1,eax,0
	mov eax,offset_G
	vpinsrd xmm1,xmm1,eax,1
	mov eax,offset_R
	vpinsrd xmm1,xmm1,eax,2
	mov rsi,rcx					;rsi=src_y
	mov r11,rdx					;r11=src_u
	mov r12,r8					;r12=src_v
	mov rdi,r9
	mov r9d,w
	mov r10,lookup
	mov r13,2
	mov r14,8
	
	mov r8d,r9d					;r8d=w0
	
	xor rcx,rcx
	xor rdx,rdx
	xor rbx,rbx
	xor r15,r15

Convert_10_YV24toRGB64_AVX_1:
	mov ecx,r8d
Convert_10_YV24toRGB64_AVX_2:
	movzx ebx,word ptr[rsi]
	movzx r15d,word ptr[r11]
	movzx edx,word ptr[r12] ; rbx=Y r15=U rdx=V
	mov eax,dword ptr[r10+4*rbx]
	add eax,dword ptr[r10+4*rdx+4096]
	vpinsrd xmm0,xmm0,eax,2
	add rsi,r13
	mov eax,dword ptr[r10+4*rbx]
	add eax,dword ptr[r10+4*r15+8192]
	add eax,dword ptr[r10+4*rdx+12288]
	vpinsrd xmm0,xmm0,eax,1
	add r11,r13
	mov eax,dword ptr[r10+4*rbx]
	add eax,dword ptr[r10+4*r15+16384]
	vpinsrd xmm0,xmm0,eax,0
	add r12,r13
	
	vpaddd xmm0,xmm0,xmm1
	vpsrad xmm0,xmm0,8
	vpackusdw xmm0,xmm0,xmm2
	
	vmovq qword ptr[rdi],xmm0
	
	add rdi,r14
	
	dec ecx
	jnz short Convert_10_YV24toRGB64_AVX_2
	
	add rsi,src_modulo_y
	add r11,src_modulo_u
	add r12,src_modulo_v
	add rdi,dst_modulo
	dec h
	jnz Convert_10_YV24toRGB64_AVX_1

	pop r15
	pop r14
	pop r13
	pop r12
	pop rbx
	pop rsi
	pop rdi
	pop rbp
	
	ret

JPSDR_HDRTools_Convert_10_YV24toRGB64_AVX endp


;JPSDR_HDRTools_Convert_12_YV24toRGB64_AVX proc src_y:dword,src_u:dword,src_v:dword,dst:dword,w:dword,h:dword,offset_R:dword,
; offset_G:dword,offset_B:dword,lookup:dword,src_modulo_y:dword,src_modulo_u:dword,src_modulo_v:dword,dst_modulo:dword
; src_y = rcx
; src_u = rdx
; src_v = r8
; dst = r9

JPSDR_HDRTools_Convert_12_YV24toRGB64_AVX proc public frame

w equ dword ptr[rbp+48]
h equ dword ptr[rbp+56]
offset_R equ dword ptr[rbp+64]
offset_G equ dword ptr[rbp+72]
offset_B equ dword ptr[rbp+80]
lookup equ qword ptr[rbp+88]
src_modulo_y equ qword ptr[rbp+96]
src_modulo_u equ qword ptr[rbp+104]
src_modulo_v equ qword ptr[rbp+112]
dst_modulo equ qword ptr[rbp+120]

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

	xor rax,rax
	vpxor xmm2,xmm2,xmm2
	vpxor xmm1,xmm1,xmm1
	vpxor xmm0,xmm0,xmm0
	mov eax,offset_B
	vpinsrd xmm1,xmm1,eax,0
	mov eax,offset_G
	vpinsrd xmm1,xmm1,eax,1
	mov eax,offset_R
	vpinsrd xmm1,xmm1,eax,2
	mov rsi,rcx					;rsi=src_y
	mov r11,rdx					;r11=src_u
	mov r12,r8					;r12=src_v
	mov rdi,r9
	mov r9d,w
	mov r10,lookup
	mov r13,2
	mov r14,8
	
	mov r8d,r9d					;r8d=w0
	
	xor rcx,rcx
	xor rdx,rdx
	xor rbx,rbx
	xor r15,r15

Convert_12_YV24toRGB64_AVX_1:
	mov ecx,r8d
Convert_12_YV24toRGB64_AVX_2:
	movzx ebx,word ptr[rsi]
	movzx r15d,word ptr[r11]
	movzx edx,word ptr[r12] ; rbx=Y r15=U rdx=V
	mov eax,dword ptr[r10+4*rbx]
	add eax,dword ptr[r10+4*rdx+16384]
	vpinsrd xmm0,xmm0,eax,2
	add rsi,r13
	mov eax,dword ptr[r10+4*rbx]
	add eax,dword ptr[r10+4*r15+32768]
	add eax,dword ptr[r10+4*rdx+49152]
	vpinsrd xmm0,xmm0,eax,1
	add r11,r13
	mov eax,dword ptr[r10+4*rbx]
	add eax,dword ptr[r10+4*r15+65536]
	vpinsrd xmm0,xmm0,eax,0
	add r12,r13
	
	vpaddd xmm0,xmm0,xmm1
	vpsrad xmm0,xmm0,8
	vpackusdw xmm0,xmm0,xmm2
	
	vmovq qword ptr[rdi],xmm0
	
	add rdi,r14
	
	dec ecx
	jnz short Convert_12_YV24toRGB64_AVX_2
	
	add rsi,src_modulo_y
	add r11,src_modulo_u
	add r12,src_modulo_v
	add rdi,dst_modulo
	dec h
	jnz Convert_12_YV24toRGB64_AVX_1

	pop r15
	pop r14
	pop r13
	pop r12
	pop rbx
	pop rsi
	pop rdi
	pop rbp
	
	ret

JPSDR_HDRTools_Convert_12_YV24toRGB64_AVX endp


;JPSDR_HDRTools_Convert_14_YV24toRGB64_AVX proc src_y:dword,src_u:dword,src_v:dword,dst:dword,w:dword,h:dword,offset_R:dword,
; offset_G:dword,offset_B:dword,lookup:dword,src_modulo_y:dword,src_modulo_u:dword,src_modulo_v:dword,dst_modulo:dword
; src_y = rcx
; src_u = rdx
; src_v = r8
; dst = r9

JPSDR_HDRTools_Convert_14_YV24toRGB64_AVX proc public frame

w equ dword ptr[rbp+48]
h equ dword ptr[rbp+56]
offset_R equ dword ptr[rbp+64]
offset_G equ dword ptr[rbp+72]
offset_B equ dword ptr[rbp+80]
lookup equ qword ptr[rbp+88]
src_modulo_y equ qword ptr[rbp+96]
src_modulo_u equ qword ptr[rbp+104]
src_modulo_v equ qword ptr[rbp+112]
dst_modulo equ qword ptr[rbp+120]

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

	xor rax,rax
	vpxor xmm2,xmm2,xmm2
	vpxor xmm1,xmm1,xmm1
	vpxor xmm0,xmm0,xmm0
	mov eax,offset_B
	vpinsrd xmm1,xmm1,eax,0
	mov eax,offset_G
	vpinsrd xmm1,xmm1,eax,1
	mov eax,offset_R
	vpinsrd xmm1,xmm1,eax,2
	mov rsi,rcx					;rsi=src_y
	mov r11,rdx					;r11=src_u
	mov r12,r8					;r12=src_v
	mov rdi,r9
	mov r9d,w
	mov r10,lookup
	mov r13,2
	mov r14,8
	
	mov r8d,r9d					;r8d=w0
	
	xor rcx,rcx
	xor rdx,rdx
	xor rbx,rbx
	xor r15,r15

Convert_14_YV24toRGB64_AVX_1:
	mov ecx,r8d
Convert_14_YV24toRGB64_AVX_2:
	movzx ebx,word ptr[rsi]
	movzx r15d,word ptr[r11]
	movzx edx,word ptr[r12] ; rbx=Y r15=U rdx=V
	mov eax,dword ptr[r10+4*rbx]
	add eax,dword ptr[r10+4*rdx+65536]
	vpinsrd xmm0,xmm0,eax,2
	add rsi,r13
	mov eax,dword ptr[r10+4*rbx]
	add eax,dword ptr[r10+4*r15+131072]
	add eax,dword ptr[r10+4*rdx+196608]
	vpinsrd xmm0,xmm0,eax,1
	add r11,r13
	mov eax,dword ptr[r10+4*rbx]
	add eax,dword ptr[r10+4*r15+262144]
	vpinsrd xmm0,xmm0,eax,0
	add r12,r13
	
	vpaddd xmm0,xmm0,xmm1
	vpsrad xmm0,xmm0,8
	vpackusdw xmm0,xmm0,xmm2
	
	vmovq qword ptr[rdi],xmm0
	
	add rdi,r14
	
	dec ecx
	jnz short Convert_14_YV24toRGB64_AVX_2
	
	add rsi,src_modulo_y
	add r11,src_modulo_u
	add r12,src_modulo_v
	add rdi,dst_modulo
	dec h
	jnz Convert_14_YV24toRGB64_AVX_1

	pop r15
	pop r14
	pop r13
	pop r12
	pop rbx
	pop rsi
	pop rdi
	pop rbp
	
	ret

JPSDR_HDRTools_Convert_14_YV24toRGB64_AVX endp


;JPSDR_HDRTools_Convert_16_YV24toRGB64_AVX proc src_y:dword,src_u:dword,src_v:dword,dst:dword,w:dword,h:dword,offset_R:dword,
; offset_G:dword,offset_B:dword,lookup:dword,src_modulo_y:dword,src_modulo_u:dword,src_modulo_v:dword,dst_modulo:dword
; src_y = rcx
; src_u = rdx
; src_v = r8
; dst = r9

JPSDR_HDRTools_Convert_16_YV24toRGB64_AVX proc public frame

w equ dword ptr[rbp+48]
h equ dword ptr[rbp+56]
offset_R equ dword ptr[rbp+64]
offset_G equ dword ptr[rbp+72]
offset_B equ dword ptr[rbp+80]
lookup equ qword ptr[rbp+88]
src_modulo_y equ qword ptr[rbp+96]
src_modulo_u equ qword ptr[rbp+104]
src_modulo_v equ qword ptr[rbp+112]
dst_modulo equ qword ptr[rbp+120]

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

	xor rax,rax
	vpxor xmm2,xmm2,xmm2
	vpxor xmm1,xmm1,xmm1
	vpxor xmm0,xmm0,xmm0
	mov eax,offset_B
	vpinsrd xmm1,xmm1,eax,0
	mov eax,offset_G
	vpinsrd xmm1,xmm1,eax,1
	mov eax,offset_R
	vpinsrd xmm1,xmm1,eax,2
	mov rsi,rcx					;rsi=src_y
	mov r11,rdx					;r11=src_u
	mov r12,r8					;r12=src_v
	mov rdi,r9
	mov r9d,w
	mov r10,lookup
	mov r13,2
	mov r14,8
	
	mov r8d,r9d					;r8d=w0
	
	xor rcx,rcx
	xor rdx,rdx
	xor rbx,rbx
	xor r15,r15

Convert_16_YV24toRGB64_AVX_1:
	mov ecx,r8d
Convert_16_YV24toRGB64_AVX_2:
	movzx ebx,word ptr[rsi]
	movzx r15d,word ptr[r11]
	movzx edx,word ptr[r12] ; rbx=Y r15=U rdx=V
	mov eax,dword ptr[r10+4*rbx]
	add eax,dword ptr[r10+4*rdx+262144]
	vpinsrd xmm0,xmm0,eax,2
	add rsi,r13
	mov eax,dword ptr[r10+4*rbx]
	add eax,dword ptr[r10+4*r15+524288]
	add eax,dword ptr[r10+4*rdx+786432]
	vpinsrd xmm0,xmm0,eax,1
	add r11,r13
	mov eax,dword ptr[r10+4*rbx]
	add eax,dword ptr[r10+4*r15+1048576]
	vpinsrd xmm0,xmm0,eax,0
	add r12,r13
	
	vpaddd xmm0,xmm0,xmm1
	vpsrad xmm0,xmm0,8
	vpackusdw xmm0,xmm0,xmm2
	
	vmovq qword ptr[rdi],xmm0
	
	add rdi,r14
	
	dec ecx
	jnz short Convert_16_YV24toRGB64_AVX_2
	
	add rsi,src_modulo_y
	add r11,src_modulo_u
	add r12,src_modulo_v
	add rdi,dst_modulo
	dec h
	jnz Convert_16_YV24toRGB64_AVX_1

	pop r15
	pop r14
	pop r13
	pop r12
	pop rbx
	pop rsi
	pop rdi
	pop rbp
	
	ret

JPSDR_HDRTools_Convert_16_YV24toRGB64_AVX endp


;JPSDR_HDRTools_Convert_LinearRGBPStoRGB64_SSE41 proc src_R:dword,src_G:dword,src_B:dword,dst:dword,w:dword,h:dword,lookup:dword,
;	src_modulo_R:dword,src_modulo_G:dword,src_modulo_B:dword,dst_modulo:dword
; src_R = rcx
; src_G = rdx
; src_B = r8
; dst = r9

JPSDR_HDRTools_Convert_LinearRGBPStoRGB64_SSE41 proc public frame

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
	
	movaps xmm3,XMMWORD ptr data_f_65535
	
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
	xor rcx,rcx
	xor rax,rax
	
Convert_LinearRGBPStoRGB64_SSE41_1:
	mov ecx,r11d
Convert_LinearRGBPStoRGB64_SSE41_2:
	xor rdx,rdx
	movaps xmm0,XMMWORD ptr[r8]
	movaps xmm1,XMMWORD ptr[r10]
	movaps xmm2,XMMWORD ptr[r9]
	mulps xmm0,xmm3
	mulps xmm1,xmm3
	mulps xmm2,xmm3
	cvtps2dq xmm0,xmm0
	cvtps2dq xmm1,xmm1
	cvtps2dq xmm2,xmm2
	packusdw xmm0,xmm0
	packusdw xmm1,xmm1
	packusdw xmm2,xmm2
	
	pextrw eax,xmm0,0
	mov ax,word ptr[rbx+2*rax]
	stosw
	pextrw eax,xmm1,0
	mov ax,word ptr[rbx+2*rax]
	stosw
	pextrw eax,xmm2,0
	mov ax,word ptr[rbx+2*rax]
	stosw
	xor eax,eax
	stosw
	dec ecx
	jz Convert_LinearRGBPStoRGB64_SSE41_3
	inc rdx
	
	pextrw eax,xmm0,1
	mov ax,word ptr[rbx+2*rax]
	stosw
	pextrw eax,xmm1,1
	mov ax,word ptr[rbx+2*rax]
	stosw
	pextrw eax,xmm2,1
	mov ax,word ptr[rbx+2*rax]
	stosw
	xor eax,eax
	stosw
	dec ecx
	jz short Convert_LinearRGBPStoRGB64_SSE41_3
	inc rdx

	pextrw eax,xmm0,2
	mov ax,word ptr[rbx+2*rax]
	stosw
	pextrw eax,xmm1,2
	mov ax,word ptr[rbx+2*rax]
	stosw
	pextrw eax,xmm2,2
	mov ax,word ptr[rbx+2*rax]
	stosw
	xor eax,eax
	stosw
	dec ecx
	jz short Convert_LinearRGBPStoRGB64_SSE41_3
	inc rdx

	pextrw eax,xmm0,3
	mov ax,word ptr[rbx+2*rax]
	stosw
	pextrw eax,xmm1,3
	mov ax,word ptr[rbx+2*rax]
	stosw
	pextrw eax,xmm2,3
	mov ax,word ptr[rbx+2*rax]
	stosw
	xor eax,eax
	stosw
	dec ecx
	
Convert_LinearRGBPStoRGB64_SSE41_3:
	inc rdx	
	shl rdx,2	
	add r8,rdx
	add r10,rdx
	add r9,rdx	
	or ecx,ecx
	jnz Convert_LinearRGBPStoRGB64_SSE41_2
	
	add rdi,r15
	add r8,r14
	add r10,r13
	add r9,r12
	dec h
	jnz Convert_LinearRGBPStoRGB64_SSE41_1
	
	pop r15
	pop r14
	pop r13
	pop r12
	pop rbx
	pop rsi
	pop rdi
	pop rbp

	ret

JPSDR_HDRTools_Convert_LinearRGBPStoRGB64_SSE41 endp


;JPSDR_HDRTools_Convert_LinearRGBPStoRGB64_AVX proc src_R:dword,src_G:dword,src_B:dword,dst:dword,w:dword,h:dword,lookup:dword,
;	src_modulo_R:dword,src_modulo_G:dword,src_modulo_B:dword,dst_modulo:dword
; src_R = rcx
; src_G = rdx
; src_B = r8
; dst = r9

JPSDR_HDRTools_Convert_LinearRGBPStoRGB64_AVX proc public frame

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
	
	sub rsp,16
	.allocstack 16
	vmovdqu XMMWORD ptr[rsp],xmm6
	.savexmm128 xmm6,0
	.endprolog	

	vmovaps ymm3,YMMWORD ptr data_f_65535
	
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
	xor rcx,rcx
	xor rax,rax
	
Convert_LinearRGBPStoRGB64_AVX_1:
	mov ecx,r11d
Convert_LinearRGBPStoRGB64_AVX_2:
	xor rdx,rdx
	vmovaps ymm0,YMMWORD ptr[r8]
	vmovaps ymm1,YMMWORD ptr[r10]
	vmovaps ymm2,YMMWORD ptr[r9]
	vmulps ymm0,ymm0,ymm3
	vmulps ymm1,ymm1,ymm3
	vmulps ymm2,ymm2,ymm3
	vcvtps2dq ymm0,ymm0
	vcvtps2dq ymm1,ymm1
	vcvtps2dq ymm2,ymm2
	
	vextractf128 xmm4,ymm0,1
	vextractf128 xmm5,ymm1,1
	vextractf128 xmm6,ymm2,1
	
	vpackusdw xmm0,xmm0,xmm4
	vpackusdw xmm1,xmm1,xmm5
	vpackusdw xmm2,xmm2,xmm6
	
	vpextrw eax,xmm0,0
	mov ax,word ptr[rbx+2*rax]
	stosw
	vpextrw eax,xmm1,0
	mov ax,word ptr[rbx+2*rax]
	stosw
	vpextrw eax,xmm2,0
	mov ax,word ptr[rbx+2*rax]
	stosw
	xor eax,eax
	stosw
	dec ecx
	jz Convert_LinearRGBPStoRGB64_AVX_3
	inc rdx
	
	vpextrw eax,xmm0,1
	mov ax,word ptr[rbx+2*rax]
	stosw
	vpextrw eax,xmm1,1
	mov ax,word ptr[rbx+2*rax]
	stosw
	vpextrw eax,xmm2,1
	mov ax,word ptr[rbx+2*rax]
	stosw
	xor eax,eax
	stosw
	dec ecx
	jz Convert_LinearRGBPStoRGB64_AVX_3
	inc rdx

	vpextrw eax,xmm0,2
	mov ax,word ptr[rbx+2*rax]
	stosw
	vpextrw eax,xmm1,2
	mov ax,word ptr[rbx+2*rax]
	stosw
	vpextrw eax,xmm2,2
	mov ax,word ptr[rbx+2*rax]
	stosw
	xor eax,eax
	stosw
	dec ecx
	jz Convert_LinearRGBPStoRGB64_AVX_3
	inc rdx

	vpextrw eax,xmm0,3
	mov ax,word ptr[rbx+2*rax]
	stosw
	vpextrw eax,xmm1,3
	mov ax,word ptr[rbx+2*rax]
	stosw
	vpextrw eax,xmm2,3
	mov ax,word ptr[rbx+2*rax]
	stosw
	xor eax,eax
	stosw
	dec ecx
	jz Convert_LinearRGBPStoRGB64_AVX_3
	inc rdx
	
	vpextrw eax,xmm0,4
	mov ax,word ptr[rbx+2*rax]
	stosw
	vpextrw eax,xmm1,4
	mov ax,word ptr[rbx+2*rax]
	stosw
	vpextrw eax,xmm2,4
	mov ax,word ptr[rbx+2*rax]
	stosw
	xor eax,eax
	stosw
	dec ecx
	jz Convert_LinearRGBPStoRGB64_AVX_3
	inc rdx	
	
	vpextrw eax,xmm0,5
	mov ax,word ptr[rbx+2*rax]
	stosw
	vpextrw eax,xmm1,5
	mov ax,word ptr[rbx+2*rax]
	stosw
	vpextrw eax,xmm2,5
	mov ax,word ptr[rbx+2*rax]
	stosw
	xor eax,eax
	stosw
	dec ecx
	jz short Convert_LinearRGBPStoRGB64_AVX_3
	inc rdx	

	vpextrw eax,xmm0,6
	mov ax,word ptr[rbx+2*rax]
	stosw
	vpextrw eax,xmm1,6
	mov ax,word ptr[rbx+2*rax]
	stosw
	vpextrw eax,xmm2,6
	mov ax,word ptr[rbx+2*rax]
	stosw
	xor eax,eax
	stosw
	dec ecx
	jz short Convert_LinearRGBPStoRGB64_AVX_3
	inc rdx		

	vpextrw eax,xmm0,7
	mov ax,word ptr[rbx+2*rax]
	stosw
	vpextrw eax,xmm1,7
	mov ax,word ptr[rbx+2*rax]
	stosw
	vpextrw eax,xmm2,7
	mov ax,word ptr[rbx+2*rax]
	stosw
	xor eax,eax
	stosw
	dec ecx
	
Convert_LinearRGBPStoRGB64_AVX_3:
	inc rdx	
	shl rdx,2	
	add r8,rdx
	add r10,rdx
	add r9,rdx	
	or ecx,ecx
	jnz Convert_LinearRGBPStoRGB64_AVX_2
	
	add rdi,r15
	add r8,r14
	add r10,r13
	add r9,r12
	dec h
	jnz Convert_LinearRGBPStoRGB64_AVX_1
	
	vzeroupper
	
	vmovdqu xmm6,XMMWORD ptr[rsp]
	add rsp,16
	
	pop r15
	pop r14
	pop r13
	pop r12
	pop rbx
	pop rsi
	pop rdi
	pop rbp

	ret

JPSDR_HDRTools_Convert_LinearRGBPStoRGB64_AVX endp


;JPSDR_HDRTools_Convert_RGBPStoRGB64_SSE41 proc src_R:dword,src_G:dword,src_B:dword,dst:dword,w:dword,h:dword,
;	src_pitch_R:dword,src_pitch_G:dword,src_pitch_B:dword,dst_pitch:dword
; src_R = rcx
; src_G = rdx
; src_B = r8
; dst = r9

JPSDR_HDRTools_Convert_RGBPStoRGB64_SSE41 proc public frame

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
	movdqa XMMWORD ptr[rsp],xmm6
	.savexmm128 xmm6,0
	movdqa XMMWORD ptr[rsp+16],xmm7
	.savexmm128 xmm7,16
	.endprolog	

	movaps xmm3,XMMWORD ptr data_f_65535
	pxor xmm4,xmm4
	
	mov rsi,rcx			; src_B=r8,src_G=rdx,src_R=rsi
	xor rcx,rcx
	
	mov r11d,w
	mov r12,src_pitch_R
	mov r13,src_pitch_G
	mov r14,src_pitch_B
	mov r15,dst_pitch
	mov rbx,4
	mov r10d,h
	
Convert_RGBPStoRGB64_SSE41_1:
	mov ecx,r11d
	xor rax,rax
	shr ecx,2
	jz short Convert_RGBPStoRGB64_SSE41_3
Convert_RGBPStoRGB64_SSE41_2:
	movaps xmm0,XMMWORD ptr[r8+4*rax]
	movaps xmm1,XMMWORD ptr[rsi+4*rax]
	movaps xmm2,XMMWORD ptr[rdx+4*rax]
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
	movdqa XMMWORD ptr[r9+8*rax],xmm0
	movdqa XMMWORD ptr[r9+8*rax+16],xmm1
	add rax,rbx
loop Convert_RGBPStoRGB64_SSE41_2

Convert_RGBPStoRGB64_SSE41_3:
	mov ecx,r11d
	and ecx,3
	jz short Convert_RGBPStoRGB64_SSE41_5
	
	movaps xmm0,XMMWORD ptr[r8+4*rax]
	movaps xmm1,XMMWORD ptr[rsi+4*rax]
	movaps xmm2,XMMWORD ptr[rdx+4*rax]
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
	movq qword ptr[r9+8*rax],xmm0
	jmp short Convert_RGBPStoRGB64_SSE41_5
	
Convert_RGBPStoRGB64_SSE41_4:
	movdqa XMMWORD ptr[r9+8*rax],xmm0
	test ecx,1
	jz short Convert_RGBPStoRGB64_SSE41_5
	movq qword ptr[r9+8*rax+16],xmm1
	
Convert_RGBPStoRGB64_SSE41_5:
	add rsi,r12
	add rdx,r13
	add r8,r14
	add r9,r15
	dec r10d
	jnz Convert_RGBPStoRGB64_SSE41_1
	
	movdqa xmm7,XMMWORD ptr[rsp+16]
	movdqa xmm6,XMMWORD ptr[rsp]
	add rsp,32
	
	pop r15
	pop r14
	pop r13
	pop r12
	pop rbx
	pop rbp

	ret

JPSDR_HDRTools_Convert_RGBPStoRGB64_SSE41 endp


;JPSDR_HDRTools_Convert_RGBPStoRGB64_AVX proc src_R:dword,src_G:dword,src_B:dword,dst:dword,w:dword,h:dword,
;	src_pitch_R:dword,src_pitch_G:dword,src_pitch_B:dword,dst_pitch:dword
; src_R = rcx
; src_G = rdx
; src_B = r8
; dst = r9

JPSDR_HDRTools_Convert_RGBPStoRGB64_AVX proc public frame

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
	xor rcx,rcx
	
	mov r11d,w
	mov r12,src_pitch_R
	mov r13,src_pitch_G
	mov r14,src_pitch_B
	mov r15,dst_pitch
	mov rbx,8
	mov r10d,h
	
Convert_RGBPStoRGB64_AVX_1:
	mov ecx,r11d
	xor rax,rax
	shr ecx,3
	jz Convert_RGBPStoRGB64_AVX_3
Convert_RGBPStoRGB64_AVX_2:
	vmovaps ymm0,YMMWORD ptr[r8+4*rax]
	vmovaps ymm1,YMMWORD ptr[rsi+4*rax]
	vmovaps ymm2,YMMWORD ptr[rdx+4*rax]
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
		
	vmovdqa XMMWORD ptr[r9+8*rax],xmm0
	vmovdqa XMMWORD ptr[r9+8*rax+16],xmm1
	vmovdqa XMMWORD ptr[r9+8*rax+32],xmm5
	vmovdqa XMMWORD ptr[r9+8*rax+48],xmm6
	add rax,8
	dec ecx
	jnz Convert_RGBPStoRGB64_AVX_2

Convert_RGBPStoRGB64_AVX_3:
	mov ecx,r11d
	and ecx,7
	jz Convert_RGBPStoRGB64_AVX_5
	
	vmovaps ymm0,YMMWORD ptr[r8+4*rax]
	vmovaps ymm1,YMMWORD ptr[rsi+4*rax]
	vmovaps ymm2,YMMWORD ptr[rdx+4*rax]
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
	vmovq qword ptr[r9+8*rax],xmm0
	jmp short Convert_RGBPStoRGB64_AVX_7
	
Convert_RGBPStoRGB64_AVX_4:
	vmovdqa XMMWORD ptr[r9+8*rax],xmm0
	test ecx,1
	jz short Convert_RGBPStoRGB64_AVX_7
	vmovq qword ptr[r9+8*rax+16],xmm1
	jmp short Convert_RGBPStoRGB64_AVX_7
	
Convert_RGBPStoRGB64_AVX_5:
	vmovdqa XMMWORD ptr[r9+8*rax],xmm0
	vmovdqa XMMWORD ptr[r9+8*rax+16],xmm1
	test ecx,2
	jnz short Convert_RGBPStoRGB64_AVX_6
	test ecx,1
	jz short Convert_RGBPStoRGB64_AVX_7
	vmovq qword ptr[r9+8*rax+32],xmm5
	jmp short Convert_RGBPStoRGB64_AVX_7
	
Convert_RGBPStoRGB64_AVX_6:
	vmovdqa XMMWORD ptr[r9+8*rax+32],xmm5
	test ecx,1
	jz short Convert_RGBPStoRGB64_AVX_7
	vmovq qword ptr[r9+8*rax+48],xmm6
	
Convert_RGBPStoRGB64_AVX_7:
	add rsi,r12
	add rdx,r13
	add r8,r14
	add r9,r15
	dec r10d
	jnz Convert_RGBPStoRGB64_AVX_1
	
	movdqa xmm7,XMMWORD ptr[rsp+16]
	movdqa xmm6,XMMWORD ptr[rsp]
	add rsp,32
	
	vzeroupper
	
	pop r15
	pop r14
	pop r13
	pop r12
	pop rbx
	pop rbp

	ret

JPSDR_HDRTools_Convert_RGBPStoRGB64_AVX endp


;JPSDR_HDRTools_Convert_RGB32toYV24_SSE2 proc src:dword,dst_y:dword,dst_u:dword,dst_v:dword,w:dword,h:dword,offset_Y:word,
; offset_U:word,offset_V:word,lookup:dword,src_modulo:dword,dst_modulo_y:dword,dst_modulo_u:dword,dst_modulo_v:dword
;Min_Y:word,Max_Y:word,Min_U:word,Max_U:word,Min_V:word,Max_V:word
; src = rcx
; dst_y = rdx
; dst_u = r8
; dst_v = r9

JPSDR_HDRTools_Convert_RGB32toYV24_SSE2 proc public frame

w equ dword ptr[rbp+48]
h equ dword ptr[rbp+56]
offset_Y equ word ptr[rbp+64]
offset_U equ word ptr[rbp+72]
offset_V equ word ptr[rbp+80]
lookup equ qword ptr[rbp+88]
src_modulo equ qword ptr[rbp+96]
dst_modulo_y equ qword ptr[rbp+104]
dst_modulo_u equ qword ptr[rbp+112]
dst_modulo_v equ qword ptr[rbp+120]
Min_Y equ word ptr[rbp+128]
Max_Y equ word ptr[rbp+136]
Min_U equ word ptr[rbp+144]
Max_U equ word ptr[rbp+152]
Min_V equ word ptr[rbp+160]
Max_V equ word ptr[rbp+168]

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

	xor rax,rax
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

	mov rsi,rcx
	mov r10,lookup
	mov rdi,rdx				;rdi=dst_y
	mov r11,r8				;r11=dst_u
	mov r12,r9				;r12=dst_v
	mov r13,2
	mov r14,8
	mov r9d,w
	
	xor rcx,rcx
	xor rdx,rdx
	xor rbx,rbx
	xor r15,r15
	
	mov r8d,r9d
	shr r8d,1				;r8d=w0
	
Convert_RGB32toYV24_SSE2_1:
	or r8d,r8d
	jz Convert_RGB32toYV24_SSE2_3
	mov ecx,r8d
Convert_RGB32toYV24_SSE2_2:
	movzx edx,byte ptr[rsi]
	movzx r15d,byte ptr[rsi+1]
	movzx ebx,byte ptr[rsi+2] ; rbx=R r15=G rdx=B	
	movzx eax,word ptr[r10+2*rbx]
	add ax,word ptr[r10+2*r15+512]
	add ax,word ptr[r10+2*rdx+1024]
	pinsrw xmm0,eax,0
	movzx eax,word ptr[r10+2*rbx+1536]
	add ax,word ptr[r10+2*r15+2048]
	add ax,word ptr[r10+2*rdx+2560]
	pinsrw xmm0,eax,2
	movzx eax,word ptr[r10+2*rbx+3072]
	add ax,word ptr[r10+2*r15+3584]
	add ax,word ptr[r10+2*rdx+4096]
	pinsrw xmm0,eax,4
	movzx edx,byte ptr[rsi+4]
	movzx r15d,byte ptr[rsi+5]
	movzx ebx,byte ptr[rsi+6] ; rbx=R r15=G rdx=B
	movzx eax,word ptr[r10+2*rbx]
	add ax,word ptr[r10+2*r15+512]
	add ax,word ptr[r10+2*rdx+1024]
	pinsrw xmm0,eax,1
	movzx eax,word ptr[r10+2*rbx+1536]
	add ax,word ptr[r10+2*r15+2048]
	add ax,word ptr[r10+2*rdx+2560]
	pinsrw xmm0,eax,3
	movzx eax,word ptr[r10+2*rbx+3072]
	add ax,word ptr[r10+2*r15+3584]
	add ax,word ptr[r10+2*rdx+4096]
	pinsrw xmm0,eax,5

	paddsw xmm0,xmm1
	psraw xmm0,6
	pmaxsw xmm0,xmm2
	pminsw xmm0,xmm3
	packuswb xmm0,xmm4
	
	pextrw eax,xmm0,0
	add rsi,r14
	mov word ptr[rdi],ax
	pextrw eax,xmm0,1
	add rdi,r13
	mov word ptr[r11],ax
	pextrw eax,xmm0,2
	add r11,r13
	mov word ptr[r12],ax	
	add r12,r13
	
	dec ecx
	jnz Convert_RGB32toYV24_SSE2_2
	
Convert_RGB32toYV24_SSE2_3:
	mov eax,r9d
	and eax,1
	jz Convert_RGB32toYV24_SSE2_4
	
	movzx edx,byte ptr[rsi]
	movzx r15d,byte ptr[rsi+1]
	movzx ebx,byte ptr[rsi+2] ; rbx=R r15=G rdx=B
	movzx eax,word ptr[r10+2*rbx]
	add ax,word ptr[r10+2*r15+512]
	add ax,word ptr[r10+2*rdx+1024]
	pinsrw xmm0,eax,0
	movzx eax,word ptr[r10+2*rbx+1536]
	add ax,word ptr[r10+2*r15+2048]
	add ax,word ptr[r10+2*rdx+2560]
	pinsrw xmm0,eax,2
	movzx eax,word ptr[r10+2*rbx+3072]
	add ax,word ptr[r10+2*r15+3584]
	add ax,word ptr[r10+2*rdx+4096]
	pinsrw xmm0,eax,4
	
	paddsw xmm0,xmm1
	psraw xmm0,6
	pmaxsw xmm0,xmm2
	pminsw xmm0,xmm3
	
	pextrw eax,xmm0,0
	add rsi,4
	mov byte ptr[rdi],al
	pextrw eax,xmm0,2
	inc rdi
	mov byte ptr[r11],al
	pextrw eax,xmm0,4
	inc r11
	mov byte ptr[r12],al
	inc r12
		
Convert_RGB32toYV24_SSE2_4:	
	add rsi,src_modulo
	add rdi,dst_modulo_y
	add r11,dst_modulo_u
	add r12,dst_modulo_v
	dec h
	jnz Convert_RGB32toYV24_SSE2_1

	pop r15
	pop r14
	pop r13
	pop r12
	pop rbx
	pop rsi
	pop rdi
	pop rbp

	ret

JPSDR_HDRTools_Convert_RGB32toYV24_SSE2 endp


;JPSDR_HDRTools_Convert_RGB32toYV24_AVX proc src:dword,dst_y:dword,dst_u:dword,dst_v:dword,w:dword,h:dword,offset_Y:word,
; offset_U:word,offset_V:word,lookup:dword,src_modulo:dword,dst_modulo_y:dword,dst_modulo_u:dword,dst_modulo_v:dword
;Min_Y:word,Max_Y:word,Min_U:word,Max_U:word,Min_V:word,Max_V:word
; src = rcx
; dst_y = rdx
; dst_u = r8
; dst_v = r9

JPSDR_HDRTools_Convert_RGB32toYV24_AVX proc public frame

w equ dword ptr[rbp+48]
h equ dword ptr[rbp+56]
offset_Y equ word ptr[rbp+64]
offset_U equ word ptr[rbp+72]
offset_V equ word ptr[rbp+80]
lookup equ qword ptr[rbp+88]
src_modulo equ qword ptr[rbp+96]
dst_modulo_y equ qword ptr[rbp+104]
dst_modulo_u equ qword ptr[rbp+112]
dst_modulo_v equ qword ptr[rbp+120]
Min_Y equ word ptr[rbp+128]
Max_Y equ word ptr[rbp+136]
Min_U equ word ptr[rbp+144]
Max_U equ word ptr[rbp+152]
Min_V equ word ptr[rbp+160]
Max_V equ word ptr[rbp+168]

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

	xor rax,rax
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

	mov rsi,rcx
	mov r10,lookup
	mov rdi,rdx				;rdi=dst_y
	mov r11,r8				;r11=dst_u
	mov r12,r9				;r12=dst_v
	mov r13,2
	mov r14,8
	mov r9d,w
	
	xor rcx,rcx
	xor rdx,rdx
	xor rbx,rbx
	xor r15,r15
	
	mov r8d,r9d
	shr r8d,1				;r8d=w0
	
Convert_RGB32toYV24_AVX_1:
	or r8d,r8d
	jz Convert_RGB32toYV24_AVX_3
	
	mov ecx,r8d
Convert_RGB32toYV24_AVX_2:
	movzx edx,byte ptr[rsi]
	movzx r15d,byte ptr[rsi+1]
	movzx ebx,byte ptr[rsi+2] ; rbx=R r15=G rdx=B	
	movzx eax,word ptr[r10+2*rbx]
	add ax,word ptr[r10+2*r15+512]
	add ax,word ptr[r10+2*rdx+1024]
	vpinsrw xmm0,xmm0,eax,0
	movzx eax,word ptr[r10+2*rbx+1536]
	add ax,word ptr[r10+2*r15+2048]
	add ax,word ptr[r10+2*rdx+2560]
	vpinsrw xmm0,xmm0,eax,2
	movzx eax,word ptr[r10+2*rbx+3072]
	add ax,word ptr[r10+2*r15+3584]
	add ax,word ptr[r10+2*rdx+4096]
	vpinsrw xmm0,xmm0,eax,4
	movzx edx,byte ptr[rsi+4]
	movzx r15d,byte ptr[rsi+5]
	movzx ebx,byte ptr[rsi+6] ; rbx=R r15=G rdx=B
	movzx eax,word ptr[r10+2*rbx]
	add ax,word ptr[r10+2*r15+512]
	add ax,word ptr[r10+2*rdx+1024]
	vpinsrw xmm0,xmm0,eax,1
	movzx eax,word ptr[r10+2*rbx+1536]
	add ax,word ptr[r10+2*r15+2048]
	add ax,word ptr[r10+2*rdx+2560]
	vpinsrw xmm0,xmm0,eax,3
	movzx eax,word ptr[r10+2*rbx+3072]
	add ax,word ptr[r10+2*r15+3584]
	add ax,word ptr[r10+2*rdx+4096]
	vpinsrw xmm0,xmm0,eax,5

	vpaddsw xmm0,xmm0,xmm1
	vpsraw xmm0,xmm0,6
	vpmaxsw xmm0,xmm0,xmm2
	vpminsw xmm0,xmm0,xmm3
	vpackuswb xmm0,xmm0,xmm4
	
	vpextrw eax,xmm0,0
	add rsi,r14
	mov word ptr[rdi],ax
	vpextrw eax,xmm0,1
	add rdi,r13
	mov word ptr[r11],ax
	vpextrw eax,xmm0,2
	add r11,r13
	mov word ptr[r12],ax	
	add r12,r13
	
	dec ecx
	jnz Convert_RGB32toYV24_AVX_2
	
Convert_RGB32toYV24_AVX_3:
	mov eax,r9d
	and eax,1
	jz Convert_RGB32toYV24_AVX_4
	
	movzx edx,byte ptr[rsi]
	movzx r15d,byte ptr[rsi+1]
	movzx ebx,byte ptr[rsi+2] ; rbx=R r15=G rdx=B
	movzx eax,word ptr[r10+2*rbx]
	add ax,word ptr[r10+2*r15+512]
	add ax,word ptr[r10+2*rdx+1024]
	vpinsrw xmm0,xmm0,eax,0
	movzx eax,word ptr[r10+2*rbx+1536]
	add ax,word ptr[r10+2*r15+2048]
	add ax,word ptr[r10+2*rdx+2560]
	vpinsrw xmm0,xmm0,eax,2
	movzx eax,word ptr[r10+2*rbx+3072]
	add ax,word ptr[r10+2*r15+3584]
	add ax,word ptr[r10+2*rdx+4096]
	vpinsrw xmm0,xmm0,eax,4
	
	vpaddsw xmm0,xmm0,xmm1
	vpsraw xmm0,xmm0,6
	vpmaxsw xmm0,xmm0,xmm2
	vpminsw xmm0,xmm0,xmm3
	
	vpextrw eax,xmm0,0
	add rsi,4
	mov byte ptr[rdi],al
	vpextrw eax,xmm0,2
	inc rdi
	mov byte ptr[r11],al
	vpextrw eax,xmm0,4
	inc r11
	mov byte ptr[r12],al
	inc r12
		
Convert_RGB32toYV24_AVX_4:	
	add rsi,src_modulo
	add rdi,dst_modulo_y
	add r11,dst_modulo_u
	add r12,dst_modulo_v
	dec h
	jnz Convert_RGB32toYV24_AVX_1

	pop r15
	pop r14
	pop r13
	pop r12
	pop rbx
	pop rsi
	pop rdi
	pop rbp

	ret

JPSDR_HDRTools_Convert_RGB32toYV24_AVX endp


end
