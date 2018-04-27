.586
.xmm
.model flat,c

.code


JPSDR_HDRTools_Convert420_to_Planar422_8_AVX2 proc src1:dword,src2:dword,dst:dword,w:dword

	public JPSDR_HDRTools_Convert420_to_Planar422_8_AVX2
	
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
	
Convert420_to_Planar422_8_AVX2_1:
	vmovdqa ymm0,YMMWORD ptr[esi+eax]
	vmovdqa ymm1,YMMWORD ptr[edx+eax]
	vpxor ymm2,ymm0,ymm3
	vpxor ymm1,ymm1,ymm3
	vpavgb ymm2,ymm2,ymm1
	vpxor ymm2,ymm2,ymm3
	vpavgb ymm2,ymm2,ymm0
	
	vmovdqa YMMWORD ptr[edi+eax],ymm2
	add eax,ebx
	loop Convert420_to_Planar422_8_AVX2_1
	
	vzeroupper
	
	pop ebx
	pop edi
	pop esi

	ret

JPSDR_HDRTools_Convert420_to_Planar422_8_AVX2 endp


JPSDR_HDRTools_Convert420_to_Planar422_16_AVX2 proc src1:dword,src2:dword,dst:dword,w:dword

	public JPSDR_HDRTools_Convert420_to_Planar422_16_AVX2
	
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
	
Convert420_to_Planar422_16_AVX2_1:
	vmovdqa ymm0,YMMWORD ptr[esi+eax]
	vmovdqa ymm1,YMMWORD ptr[edx+eax]
	vpxor ymm2,ymm0,ymm3
	vpxor ymm1,ymm1,ymm3
	vpavgw ymm2,ymm2,ymm1
	vpxor ymm2,ymm2,ymm3
	vpavgw ymm2,ymm2,ymm0
	
	vmovdqa YMMWORD ptr[edi+eax],ymm2
	add eax,ebx
	loop Convert420_to_Planar422_16_AVX2_1
	
	vzeroupper
	
	pop ebx
	pop edi
	pop esi

	ret

JPSDR_HDRTools_Convert420_to_Planar422_16_AVX2 endp


end





