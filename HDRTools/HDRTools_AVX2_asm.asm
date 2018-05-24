.586
.xmm
.model flat,c

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


end





