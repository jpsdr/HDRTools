.586
.xmm
.model flat,c

.data

align 16

data segment align(32)

data_f_1048575 real4 8 dup(1048575.0)
data_dw_1048575 dword 8 dup(1048575)
data_dw_0 dword 8 dup(0)

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


JPSDR_HDRTools_Scale_20_XYZ_AVX2 proc src:dword,dst:dword,w8:dword,h:dword,src_pitch:dword,dst_pitch:dword,
	ValMin:dword,Coeff:dword

	public JPSDR_HDRTools_Scale_20_XYZ_AVX2

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
	vmovdqa ymm3,YMMWORD ptr data_dw_1048575
	vmovdqa ymm4,YMMWORD ptr data_dw_0
	vmulps ymm2,ymm2,YMMWORD ptr data_f_1048575
	
	mov esi,src
	mov edi,dst
	mov ebx,w8
	mov edx,32
	
Scale_20_XYZ_AVX2_1:
	mov ecx,ebx
	xor eax,eax
Scale_20_XYZ_AVX2_2:	
	vaddps ymm0,ymm1,YMMWORD ptr [esi+eax]
	vmulps ymm0,ymm0,ymm2
	vcvtps2dq ymm0,ymm0
	vpminsd ymm0,ymm0,ymm3
	vpmaxsd ymm0,ymm0,ymm4
	vmovdqa YMMWORD ptr [edi+eax],ymm0
	
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
	mov ecx,ebx
	xor eax,eax
Scale_20_RGB_AVX2_2:	
	vmulps ymm0,ymm1,YMMWORD ptr [esi+eax]
	vcvtps2dq ymm0,ymm0
	vpminsd ymm0,ymm0,ymm2
	vpmaxsd ymm0,ymm0,ymm3
	vmovdqa YMMWORD ptr [edi+eax],ymm0
	
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


end





