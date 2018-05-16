/*
 *  AutoYUY2()
 *
 *  Adaptive YV12 upsampling. Progressive picture areas are upsampled
 *  progressively and interlaced areas are upsampled interlaced.
 *  Copyright (C) 2005 Donald A. Graft
 *	
 *  AutoYUY2 is free software; you can redistribute it and/or modify
 *  it under the terms of the GNU General Public License as published by
 *  the Free Software Foundation; either version 2, or (at your option)
 *  any later version.
 *   
 *  AutoYUY2 is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
 *  GNU General Public License for more details.
 *   
 *  You should have received a copy of the GNU General Public License
 *  along with GNU Make; see the file COPYING.  If not, write to
 *  the Free Software Foundation, 675 Mass Ave, Cambridge, MA 02139, USA. 
 *
 */

#include <windows.h>
#include <math.h>
#include "HDRTools.h"

#if _MSC_VER >= 1900
#define AVX2_BUILD_POSSIBLE
#endif

static ThreadPoolInterface *poolInterface;

extern "C" void JPSDR_HDRTools_Move8to16(void *dst,const void *src,int32_t w);
extern "C" void JPSDR_HDRTools_Move8to16_SSE2(void *dst,const void *src,int32_t w);
extern "C" void JPSDR_HDRTools_Move8to16_AVX(void *dst,const void *src,int32_t w);

extern "C" void JPSDR_HDRTools_Convert420_to_Planar422_8_SSE2(const void *scr_1,const void *src_2,void *dst,int32_t w);
extern "C" void JPSDR_HDRTools_Convert420_to_Planar422_8to16_SSE2(const void *scr_1,const void *src_2,void *dst,int32_t w);
extern "C" void JPSDR_HDRTools_Convert420_to_Planar422_16_SSE2(const void *scr_1,const void *src_2,void *dst,int32_t w);

extern "C" void JPSDR_HDRTools_Convert420_to_Planar422_8_AVX(const void *scr_1,const void *src_2,void *dst,int32_t w);
extern "C" void JPSDR_HDRTools_Convert420_to_Planar422_8to16_AVX(const void *scr_1,const void *src_2,void *dst,int32_t w);
extern "C" void JPSDR_HDRTools_Convert420_to_Planar422_16_AVX(const void *scr_1,const void *src_2,void *dst,int32_t w);

extern "C" void JPSDR_HDRTools_Convert422_to_Planar444_8_SSE2(const void *scr,void *dst,int32_t w);
extern "C" void JPSDR_HDRTools_Convert422_to_Planar444_8to16_SSE2(const void *scr,void *dst,int32_t w);
extern "C" void JPSDR_HDRTools_Convert422_to_Planar444_16_SSE2(const void *scr,void *dst,int32_t w);

extern "C" void JPSDR_HDRTools_Convert422_to_Planar444_8_AVX(const void *scr,void *dst,int32_t w);
extern "C" void JPSDR_HDRTools_Convert422_to_Planar444_8to16_AVX(const void *scr,void *dst,int32_t w);
extern "C" void JPSDR_HDRTools_Convert422_to_Planar444_16_AVX(const void *scr,void *dst,int32_t w);

extern "C" void JPSDR_HDRTools_Convert_YV24toRGB32_SSE2(const void *src_y,const void *src_u,const void *src_v,void *dst,int32_t w,
	int32_t h,int16_t offset_R,int16_t offset_G,int16_t offset_B,const int16_t *lookup,
	ptrdiff_t src_modulo_Y,ptrdiff_t src_modulo_U,ptrdiff_t src_modulo_V,ptrdiff_t dst_modulo);
extern "C" void JPSDR_HDRTools_Convert_YV24toRGB32_AVX(const void *src_y,const void *src_u,const void *src_v,void *dst,int32_t w,
	int32_t h,int16_t offset_R,int16_t offset_G,int16_t offset_B,const int16_t *lookup,
	ptrdiff_t src_modulo_Y,ptrdiff_t src_modulo_U,ptrdiff_t src_modulo_V,ptrdiff_t dst_modulo);

extern "C" void JPSDR_HDRTools_Convert_8_YV24toRGB64_SSE41(const void *src_y,const void *src_u,const void *src_v,void *dst,int32_t w,
	int32_t h,int32_t offset_R,int32_t offset_G,int32_t offset_B,const int32_t *lookup,
	ptrdiff_t src_modulo_Y,ptrdiff_t src_modulo_U,ptrdiff_t src_modulo_V,ptrdiff_t dst_modulo);
extern "C" void JPSDR_HDRTools_Convert_10_YV24toRGB64_SSE41(const void *src_y,const void *src_u,const void *src_v,void *dst,int32_t w,
	int32_t h,int32_t offset_R,int32_t offset_G,int32_t offset_B,const int32_t *lookup,
	ptrdiff_t src_modulo_Y,ptrdiff_t src_modulo_U,ptrdiff_t src_modulo_V,ptrdiff_t dst_modulo);
extern "C" void JPSDR_HDRTools_Convert_12_YV24toRGB64_SSE41(const void *src_y,const void *src_u,const void *src_v,void *dst,int32_t w,
	int32_t h,int32_t offset_R,int32_t offset_G,int32_t offset_B,const int32_t *lookup,
	ptrdiff_t src_modulo_Y,ptrdiff_t src_modulo_U,ptrdiff_t src_modulo_V,ptrdiff_t dst_modulo);
extern "C" void JPSDR_HDRTools_Convert_14_YV24toRGB64_SSE41(const void *src_y,const void *src_u,const void *src_v,void *dst,int32_t w,
	int32_t h,int32_t offset_R,int32_t offset_G,int32_t offset_B,const int32_t *lookup,
	ptrdiff_t src_modulo_Y,ptrdiff_t src_modulo_U,ptrdiff_t src_modulo_V,ptrdiff_t dst_modulo);
extern "C" void JPSDR_HDRTools_Convert_16_YV24toRGB64_SSE41(const void *src_y,const void *src_u,const void *src_v,void *dst,int32_t w,
	int32_t h,int32_t offset_R,int32_t offset_G,int32_t offset_B,const int32_t *lookup,
	ptrdiff_t src_modulo_Y,ptrdiff_t src_modulo_U,ptrdiff_t src_modulo_V,ptrdiff_t dst_modulo);

extern "C" void JPSDR_HDRTools_Convert_8_YV24toRGB64_AVX(const void *src_y,const void *src_u,const void *src_v,void *dst,int32_t w,
	int32_t h,int32_t offset_R,int32_t offset_G,int32_t offset_B,const int32_t *lookup,
	ptrdiff_t src_modulo_Y,ptrdiff_t src_modulo_U,ptrdiff_t src_modulo_V,ptrdiff_t dst_modulo);
extern "C" void JPSDR_HDRTools_Convert_10_YV24toRGB64_AVX(const void *src_y,const void *src_u,const void *src_v,void *dst,int32_t w,
	int32_t h,int32_t offset_R,int32_t offset_G,int32_t offset_B,const int32_t *lookup,
	ptrdiff_t src_modulo_Y,ptrdiff_t src_modulo_U,ptrdiff_t src_modulo_V,ptrdiff_t dst_modulo);
extern "C" void JPSDR_HDRTools_Convert_12_YV24toRGB64_AVX(const void *src_y,const void *src_u,const void *src_v,void *dst,int32_t w,
	int32_t h,int32_t offset_R,int32_t offset_G,int32_t offset_B,const int32_t *lookup,
	ptrdiff_t src_modulo_Y,ptrdiff_t src_modulo_U,ptrdiff_t src_modulo_V,ptrdiff_t dst_modulo);
extern "C" void JPSDR_HDRTools_Convert_14_YV24toRGB64_AVX(const void *src_y,const void *src_u,const void *src_v,void *dst,int32_t w,
	int32_t h,int32_t offset_R,int32_t offset_G,int32_t offset_B,const int32_t *lookup,
	ptrdiff_t src_modulo_Y,ptrdiff_t src_modulo_U,ptrdiff_t src_modulo_V,ptrdiff_t dst_modulo);
extern "C" void JPSDR_HDRTools_Convert_16_YV24toRGB64_AVX(const void *src_y,const void *src_u,const void *src_v,void *dst,int32_t w,
	int32_t h,int32_t offset_R,int32_t offset_G,int32_t offset_B,const int32_t *lookup,
	ptrdiff_t src_modulo_Y,ptrdiff_t src_modulo_U,ptrdiff_t src_modulo_V,ptrdiff_t dst_modulo);

extern "C" void JPSDR_HDRTools_Convert_RGBPStoRGB64_SSE41(const void *srcR,const void *srcG,const void *srcB,void *dst,
	int32_t w,int32_t h,ptrdiff_t src_modulo_R,ptrdiff_t src_modulo_G,ptrdiff_t src_modulo_B,ptrdiff_t dst_modulo);
extern "C" void JPSDR_HDRTools_Convert_RGBPStoRGB64_AVX(const void *srcR,const void *srcG,const void *srcB,void *dst,
	int32_t w,int32_t h,ptrdiff_t src_modulo_R,ptrdiff_t src_modulo_G,ptrdiff_t src_modulo_B,ptrdiff_t dst_modulo);

extern "C" void JPSDR_HDRTools_Convert_RGB32toYV24_SSE2(const void *src,void *dst_y,void *dst_u,void *dst_v,int32_t w,int32_t h,
	int16_t offset_Y,int16_t offset_U,int16_t offset_V,const int16_t *lookup, ptrdiff_t src_modulo,
	ptrdiff_t dst_modulo_Y,ptrdiff_t dst_modulo_U,ptrdiff_t dst_modulo_V,int16_t Min_Y,int16_t Max_Y,
	int16_t Min_U,int16_t Max_U,int16_t Min_V,int16_t Max_V);
extern "C" void JPSDR_HDRTools_Convert_RGB32toYV24_AVX(const void *src,void *dst_y,void *dst_u,void *dst_v,int32_t w,int32_t h,
	int16_t offset_Y,int16_t offset_U,int16_t offset_V,const int16_t *lookup, ptrdiff_t src_modulo,
	ptrdiff_t dst_modulo_Y,ptrdiff_t dst_modulo_U,ptrdiff_t dst_modulo_V,int16_t Min_Y,int16_t Max_Y,
	int16_t Min_U,int16_t Max_U,int16_t Min_V,int16_t Max_V);


#ifdef AVX2_BUILD_POSSIBLE
extern "C" void JPSDR_HDRTools_Convert420_to_Planar422_8_AVX2(const void *scr_1,const void *src_2,void *dst,int32_t w);
extern "C" void JPSDR_HDRTools_Convert420_to_Planar422_16_AVX2(const void *scr_1,const void *src_2,void *dst,int32_t w);
#endif


#define myfree(ptr) if (ptr!=NULL) { free(ptr); ptr=NULL;}
#define myalignedfree(ptr) if (ptr!=NULL) { _aligned_free(ptr); ptr=NULL;}
#define mydelete(ptr) if (ptr!=NULL) { delete ptr; ptr=NULL;}

#define trunc(x) (signed long) floor(x)
#define round(x) (signed long) floor(x+0.5)

typedef struct _RGB32BMP
{
	uint8_t b;
	uint8_t g;
	uint8_t r;
	uint8_t alpha;
} RGB32BMP;

typedef union _URGB32BMP
{
	RGB32BMP rgb32bmp;
	uint32_t data32;
} URGB32BMP;


typedef struct _RGB64BMP
{
	uint16_t b;
	uint16_t g;
	uint16_t r;
	uint16_t alpha;
} RGB64BMP;

typedef union _URGB64BMP
{
	RGB64BMP rgb64bmp;
	uint64_t data64;
} URGB64BMP;


uint8_t CreateMTData(MT_Data_Info_HDRTools MT_Data[],uint8_t max_threads,uint8_t threads_number,int32_t size_x,int32_t size_y,
	bool div_src_w_UV,bool div_src_h_UV,bool div_dst_w_UV,bool div_dst_h_UV)
{
	if ((max_threads<=1) || (max_threads>threads_number))
	{
		MT_Data[0].top=true;
		MT_Data[0].bottom=true;
		MT_Data[0].src_Y_h_min=0;
		MT_Data[0].dst_Y_h_min=0;
		MT_Data[0].src_Y_h_max=size_y;
		MT_Data[0].dst_Y_h_max=size_y;
		MT_Data[0].src_UV_h_min=0;
		MT_Data[0].dst_UV_h_min=0;
		MT_Data[0].src_UV_h_max=div_src_h_UV ? size_y >> 1:size_y;
		MT_Data[0].dst_UV_h_max=div_dst_h_UV ? size_y >> 1:size_y;
		MT_Data[0].src_Y_w=size_x;
		MT_Data[0].dst_Y_w=size_x;
		MT_Data[0].src_UV_w=div_src_w_UV ? size_x >> 1:size_x;
		MT_Data[0].dst_UV_w=div_dst_w_UV ? size_x >> 1:size_x;
		return(1);
	}

	int32_t dh_Y,src_dh_UV,dst_dh_UV,h_y;
	uint8_t i,max=0;

	dh_Y=(size_y+(int32_t)max_threads-1)/(int32_t)max_threads;
	if (dh_Y<16) dh_Y=16;
	if ((dh_Y & 3)!=0) dh_Y=((dh_Y+3) >> 2) << 2;

	h_y=0;
	while (h_y<(size_y-16))
	{
		max++;
		h_y+=dh_Y;
	}

	if (max==1)
	{
		MT_Data[0].top=true;
		MT_Data[0].bottom=true;
		MT_Data[0].src_Y_h_min=0;
		MT_Data[0].dst_Y_h_min=0;
		MT_Data[0].src_Y_h_max=size_y;
		MT_Data[0].dst_Y_h_max=size_y;
		MT_Data[0].src_UV_h_min=0;
		MT_Data[0].dst_UV_h_min=0;
		MT_Data[0].src_UV_h_max=div_src_h_UV ? size_y >> 1:size_y;
		MT_Data[0].dst_UV_h_max=div_dst_h_UV ? size_y >> 1:size_y;
		MT_Data[0].src_Y_w=size_x;
		MT_Data[0].dst_Y_w=size_x;
		MT_Data[0].src_UV_w=div_src_w_UV ? size_x >> 1:size_x;
		MT_Data[0].dst_UV_w=div_dst_w_UV ? size_x >> 1:size_x;
		return(1);
	}

	src_dh_UV=div_src_h_UV ? dh_Y>>1:dh_Y;
	dst_dh_UV=div_dst_h_UV ? dh_Y>>1:dh_Y;

	MT_Data[0].top=true;
	MT_Data[0].bottom=false;
	MT_Data[0].src_Y_h_min=0;
	MT_Data[0].src_Y_h_max=dh_Y;
	MT_Data[0].dst_Y_h_min=0;
	MT_Data[0].dst_Y_h_max=dh_Y;
	MT_Data[0].src_UV_h_min=0;
	MT_Data[0].src_UV_h_max=src_dh_UV;
	MT_Data[0].dst_UV_h_min=0;
	MT_Data[0].dst_UV_h_max=dst_dh_UV;

	i=1;
	while (i<max)
	{
		MT_Data[i].top=false;
		MT_Data[i].bottom=false;
		MT_Data[i].src_Y_h_min=MT_Data[i-1].src_Y_h_max;
		MT_Data[i].src_Y_h_max=MT_Data[i].src_Y_h_min+dh_Y;
		MT_Data[i].dst_Y_h_min=MT_Data[i-1].dst_Y_h_max;
		MT_Data[i].dst_Y_h_max=MT_Data[i].dst_Y_h_min+dh_Y;
		MT_Data[i].src_UV_h_min=MT_Data[i-1].src_UV_h_max;
		MT_Data[i].src_UV_h_max=MT_Data[i].src_UV_h_min+src_dh_UV;
		MT_Data[i].dst_UV_h_min=MT_Data[i-1].dst_UV_h_max;
		MT_Data[i].dst_UV_h_max=MT_Data[i].dst_UV_h_min+dst_dh_UV;
		i++;
	}
	MT_Data[max-1].bottom=true;
	MT_Data[max-1].src_Y_h_max=size_y;
	MT_Data[max-1].dst_Y_h_max=size_y;
	MT_Data[max-1].src_UV_h_max=div_src_h_UV ? size_y >> 1:size_y;
	MT_Data[max-1].dst_UV_h_max=div_dst_h_UV ? size_y >> 1:size_y;
	for (i=0; i<max; i++)
	{
		MT_Data[i].src_Y_w=size_x;
		MT_Data[i].dst_Y_w=size_x;
		MT_Data[i].src_UV_w=div_src_w_UV ? size_x >> 1:size_x;
		MT_Data[i].dst_UV_w=div_dst_w_UV ? size_x >> 1:size_x;
	}
	return(max);
}


static inline void Move_Full(const void *src_, void *dst_, const int32_t w,const int32_t h,
		ptrdiff_t src_pitch,ptrdiff_t dst_pitch)
{
	const uint8_t *src=(uint8_t *)src_;
	uint8_t *dst=(uint8_t *)dst_;

	if ((src_pitch==dst_pitch) && (abs(src_pitch)==w))
	{
		if (src_pitch<0)
		{
			src+=(h-1)*src_pitch;
			dst+=(h-1)*dst_pitch;
		}
		memcpy(dst,src,(size_t)h*(size_t)w);
	}
	else
	{
		for(int i=0; i<h; i++)
		{
			memcpy(dst,src,w);
			src+=src_pitch;
			dst+=dst_pitch;
		}
	}
}


static inline void Move_Full_8to16(const void *src_, void *dst_, const int32_t w,const int32_t h,ptrdiff_t src_pitch,ptrdiff_t dst_pitch)
{
	const uint8_t *src=(uint8_t *)src_;
	uint8_t *dst=(uint8_t *)dst_;

	for(int i=0; i<h; i++)
	{
		JPSDR_HDRTools_Move8to16(dst,src,w);
		src+=src_pitch;
		dst+=dst_pitch;
	}
}


static inline void Move_Full_8to16_SSE2(const void *src_, void *dst_, const int32_t w,const int32_t h,
	ptrdiff_t src_pitch,ptrdiff_t dst_pitch)
{
	const uint8_t *src=(uint8_t *)src_;
	uint8_t *dst=(uint8_t *)dst_;
	const uint32_t w16=((w+15)>>4)-1,w0=w-(w16 << 4);
	const uint32_t offset8=w16 << 4,offset16=offset8 << 1;

	for(int i=0; i<h; i++)
	{
		JPSDR_HDRTools_Move8to16_SSE2(dst,src,w16);
		JPSDR_HDRTools_Move8to16(dst+offset16,src+offset8,w0);
		src+=src_pitch;
		dst+=dst_pitch;
	}
}


static inline void Move_Full_8to16_AVX(const void *src_, void *dst_, const int32_t w,const int32_t h,
	ptrdiff_t src_pitch,ptrdiff_t dst_pitch)
{
	const uint8_t *src=(uint8_t *)src_;
	uint8_t *dst=(uint8_t *)dst_;
	const uint32_t w16=((w+15)>>4)-1,w0=w-(w16 << 4);
	const uint32_t offset8=w16 << 4,offset16=offset8 << 1;

	for(int i=0; i<h; i++)
	{
		JPSDR_HDRTools_Move8to16_AVX(dst,src,w16);
		JPSDR_HDRTools_Move8to16(dst+offset16,src+offset8,w0);
		src+=src_pitch;
		dst+=dst_pitch;
	}
}


static void Convert_Progressive_8_YV12toYV16_SSE2(const MT_Data_Info_HDRTools &mt_data_inf)
{
	const uint8_t *srcYp=(const uint8_t *)mt_data_inf.src1;
	const uint8_t *srcU_=(const uint8_t *)mt_data_inf.src2;
	const uint8_t *srcV_=(const uint8_t *)mt_data_inf.src3;
	uint8_t *dstYp=(uint8_t *)mt_data_inf.dst1;
	uint8_t *dstUp=(uint8_t *)mt_data_inf.dst2;
	uint8_t *dstVp=(uint8_t *)mt_data_inf.dst3;
	const int32_t dst_w=mt_data_inf.dst_Y_w;
	const int32_t h_Y_min=mt_data_inf.src_Y_h_min;
	const int32_t h_Y_max=mt_data_inf.src_Y_h_max;
	const ptrdiff_t src_pitch_Y=mt_data_inf.src_pitch1;
	const ptrdiff_t src_pitch_U=mt_data_inf.src_pitch2;
	const ptrdiff_t src_pitch_V=mt_data_inf.src_pitch3;
	const ptrdiff_t dst_pitch_Y=mt_data_inf.dst_pitch1;
	const ptrdiff_t dst_pitch_U=mt_data_inf.dst_pitch2;
	const ptrdiff_t dst_pitch_V=mt_data_inf.dst_pitch3;

	const uint8_t *src_U,*src_Up,*src_Un;
	const uint8_t *src_V,*src_Vp,*src_Vn;
	const int32_t w_U=dst_w>>1,w_V=dst_w>>1;
	const int32_t w_U16=(w_U+15)>>4,w_V16=(w_V+15)>>4;
	const int32_t h_2 = mt_data_inf.bottom ? h_Y_max-2:h_Y_max;
	const int32_t h_0 = mt_data_inf.top ? 2:h_Y_min;

	src_U=srcU_;
	src_V=srcV_;
	src_Up=src_U-src_pitch_U;
	src_Un=src_U+src_pitch_U;
	src_Vp=src_V-src_pitch_V;
	src_Vn=src_V+src_pitch_V;

	Move_Full(srcYp,dstYp,dst_w,h_Y_max-h_Y_min,src_pitch_Y,dst_pitch_Y);

// Planar U
	if (mt_data_inf.top)
	{
		for(int32_t i=0; i<2; i+=2)
		{
			memcpy(dstUp,src_U,w_U);
			dstUp+=dst_pitch_U;

			JPSDR_HDRTools_Convert420_to_Planar422_8_SSE2(src_U,src_Un,dstUp,w_U16);
			dstUp+=dst_pitch_U;

			src_U+=src_pitch_U;
			src_Up+=src_pitch_U;
			src_Un+=src_pitch_U;
		}
	}

	for(int32_t i=h_0; i<h_2; i+=2)
	{
		JPSDR_HDRTools_Convert420_to_Planar422_8_SSE2(src_U,src_Up,dstUp,w_U16);
		dstUp+=dst_pitch_U;
		JPSDR_HDRTools_Convert420_to_Planar422_8_SSE2(src_U,src_Un,dstUp,w_U16);
		dstUp+=dst_pitch_U;

		src_U+=src_pitch_U;
		src_Up+=src_pitch_U;
		src_Un+=src_pitch_U;
	}

	if (mt_data_inf.bottom)
	{
		for(int32_t i=h_2; i<h_Y_max; i+=2)
		{
			JPSDR_HDRTools_Convert420_to_Planar422_8_SSE2(src_U,src_Up,dstUp,w_U16);
			dstUp+=dst_pitch_U;

			memcpy(dstUp,src_U,w_U);
			dstUp+=dst_pitch_U;

			src_U+=src_pitch_U;
			src_Up+=src_pitch_U;
			src_Un+=src_pitch_U;
		}
	}


// Planar V
	if (mt_data_inf.top)
	{
		for(int32_t i=0; i<2; i+=2)
		{
			memcpy(dstVp,src_V,w_V);
			dstVp+=dst_pitch_V;

			JPSDR_HDRTools_Convert420_to_Planar422_8_SSE2(src_V,src_Vn,dstVp,w_V16);
			dstVp+=dst_pitch_V;

			src_V+=src_pitch_V;
			src_Vp+=src_pitch_V;
			src_Vn+=src_pitch_V;
		}
	}

	for(int32_t i=h_0; i<h_2; i+=2)
	{
		JPSDR_HDRTools_Convert420_to_Planar422_8_SSE2(src_V,src_Vp,dstVp,w_V16);
		dstVp+=dst_pitch_V;
		JPSDR_HDRTools_Convert420_to_Planar422_8_SSE2(src_V,src_Vn,dstVp,w_V16);
		dstVp+=dst_pitch_V;

		src_V+=src_pitch_V;
		src_Vp+=src_pitch_V;
		src_Vn+=src_pitch_V;
	}

	if (mt_data_inf.bottom)
	{
		for(int32_t i=h_2; i<h_Y_max; i+=2)
		{
			JPSDR_HDRTools_Convert420_to_Planar422_8_SSE2(src_V,src_Vp,dstVp,w_V16);
			dstVp+=dst_pitch_V;

			memcpy(dstVp,src_V,w_V);
			dstVp+=dst_pitch_V;

			src_V+=src_pitch_V;
			src_Vp+=src_pitch_V;
			src_Vn+=src_pitch_V;
		}
	}
}


static void Convert_Progressive_8to16_YV12toYV16_SSE2(const MT_Data_Info_HDRTools &mt_data_inf,uint32_t *lookup1,uint32_t *lookup2)
{
	const uint8_t *srcYp=(const uint8_t *)mt_data_inf.src1;
	const uint8_t *srcU_=(const uint8_t *)mt_data_inf.src2;
	const uint8_t *srcV_=(const uint8_t *)mt_data_inf.src3;
	uint8_t *dstYp=(uint8_t *)mt_data_inf.dst1;
	uint8_t *dstUp=(uint8_t *)mt_data_inf.dst2;
	uint8_t *dstVp=(uint8_t *)mt_data_inf.dst3;
	const int32_t dst_w=mt_data_inf.dst_Y_w;
	const int32_t h_Y_min=mt_data_inf.src_Y_h_min;
	const int32_t h_Y_max=mt_data_inf.src_Y_h_max;
	const ptrdiff_t src_pitch_Y=mt_data_inf.src_pitch1;
	const ptrdiff_t src_pitch_U=mt_data_inf.src_pitch2;
	const ptrdiff_t src_pitch_V=mt_data_inf.src_pitch3;
	const ptrdiff_t dst_pitch_Y=mt_data_inf.dst_pitch1;
	const ptrdiff_t dst_pitch_U=mt_data_inf.dst_pitch2;
	const ptrdiff_t dst_pitch_V=mt_data_inf.dst_pitch3;

	const uint8_t *src_U,*src_Up,*src_Un;
	const uint8_t *src_V,*src_Vp,*src_Vn;
	const int32_t w_U=dst_w >> 1,w_V=dst_w >> 1;
	const int32_t w_U8=((w_U+7) >> 3)-1,w_V8=((w_V+7) >> 3)-1;
	const int32_t wU0=w_U-(w_U8 << 3),wV0=w_V-(w_V8 << 3);
	const uint32_t offsetU8=w_U8 << 3,offsetU16=offsetU8 << 1;
	const uint32_t offsetV8=w_V8 << 3,offsetV16=offsetV8 << 1;
	const int32_t h_2 = mt_data_inf.bottom ? h_Y_max-2:h_Y_max;
	const int32_t h_0 = mt_data_inf.top ? 2:h_Y_min;

	src_U=srcU_;
	src_V=srcV_;
	src_Up=src_U-src_pitch_U;
	src_Un=src_U+src_pitch_U;
	src_Vp=src_V-src_pitch_V;
	src_Vn=src_V+src_pitch_V;

	Move_Full_8to16_SSE2(srcYp,dstYp,dst_w,h_Y_max-h_Y_min,src_pitch_Y,dst_pitch_Y);

// Planar U
	if (mt_data_inf.top)
	{
		for(int32_t i=0; i<2; i+=2)
		{
			JPSDR_HDRTools_Move8to16_SSE2(dstUp,src_U,w_U8);
			JPSDR_HDRTools_Move8to16(dstUp+offsetU16,src_U+offsetU8,wU0);
			dstUp+=dst_pitch_U;

			JPSDR_HDRTools_Convert420_to_Planar422_8to16_SSE2(src_U,src_Un,dstUp,w_U8);

			const uint8_t *srcU=src_U+offsetU8,*srcUn=src_Un+offsetU8;
			uint16_t *dstU=(uint16_t *)(dstUp+offsetU16);

			for(int32_t j=0; j<wU0; j++)
				dstU[j]=(uint16_t)((lookup1[srcU[j]]+lookup2[srcUn[j]])>>2);

			dstUp+=dst_pitch_U;

			src_U+=src_pitch_U;
			src_Up+=src_pitch_U;
			src_Un+=src_pitch_U;
		}
	}

	for(int32_t i=h_0; i<h_2; i+=2)
	{
		JPSDR_HDRTools_Convert420_to_Planar422_8to16_SSE2(src_U,src_Up,dstUp,w_U8);

		const uint8_t *srcU=src_U+offsetU8,*srcUp=src_Up+offsetU8;
		uint16_t *dstU=(uint16_t *)(dstUp+offsetU16);

		for(int32_t j=0; j<wU0; j++)
			dstU[j]=(uint16_t)((lookup1[srcU[j]]+lookup2[srcUp[j]])>>2);

		dstUp+=dst_pitch_U;

		JPSDR_HDRTools_Convert420_to_Planar422_8to16_SSE2(src_U,src_Un,dstUp,w_U8);

		const uint8_t *srcUn=src_Un+offsetU8;
		dstU=(uint16_t *)(dstUp+offsetU16);

		for(int32_t j=0; j<wU0; j++)
			dstU[j]=(uint16_t)((lookup1[srcU[j]]+lookup2[srcUn[j]])>>2);
		dstUp+=dst_pitch_U;

		src_U+=src_pitch_U;
		src_Up+=src_pitch_U;
		src_Un+=src_pitch_U;
	}

	if (mt_data_inf.bottom)
	{
		for(int32_t i=h_2; i<h_Y_max; i+=2)
		{
			JPSDR_HDRTools_Convert420_to_Planar422_8to16_SSE2(src_U,src_Up,dstUp,w_U8);

			const uint8_t *srcU=src_U+offsetU8,*srcUp=src_Up+offsetU8;
			uint16_t *dstU=(uint16_t *)(dstUp+offsetU16);

			for(int32_t j=0; j<wU0; j++)
				dstU[j]=(uint16_t)((lookup1[srcU[j]]+lookup2[srcUp[j]])>>2);

			dstUp+=dst_pitch_U;

			JPSDR_HDRTools_Move8to16_SSE2(dstUp,src_U,w_U8);
			JPSDR_HDRTools_Move8to16(dstUp+offsetU16,src_U+offsetU8,wU0);
			dstUp+=dst_pitch_U;

			src_U+=src_pitch_U;
			src_Up+=src_pitch_U;
			src_Un+=src_pitch_U;
		}
	}


// Planar V
	if (mt_data_inf.top)
	{
		for(int32_t i=0; i<2; i+=2)
		{
			JPSDR_HDRTools_Move8to16_SSE2(dstVp,src_V,w_V8);
			JPSDR_HDRTools_Move8to16(dstVp+offsetV16,src_V+offsetV8,wV0);
			dstVp+=dst_pitch_V;

			JPSDR_HDRTools_Convert420_to_Planar422_8to16_SSE2(src_V,src_Vn,dstVp,w_V8);

			const uint8_t *srcV=src_V+offsetV8,*srcVn=src_Vn+offsetV8;
			uint16_t *dstV=(uint16_t *)(dstVp+offsetV16);

			for(int32_t j=0; j<wV0; j++)
				dstV[j]=(uint16_t)((lookup1[srcV[j]]+lookup2[srcVn[j]])>>2);

			dstVp+=dst_pitch_V;

			src_V+=src_pitch_V;
			src_Vp+=src_pitch_V;
			src_Vn+=src_pitch_V;
		}
	}

	for(int32_t i=h_0; i<h_2; i+=2)
	{
		JPSDR_HDRTools_Convert420_to_Planar422_8to16_SSE2(src_V,src_Vp,dstVp,w_V8);

		const uint8_t *srcV=src_V+offsetV8,*srcVp=src_Vp+offsetV8;
		uint16_t *dstV=(uint16_t *)(dstVp+offsetV16);

		for(int32_t j=0; j<wV0; j++)
			dstV[j]=(uint16_t)((lookup1[srcV[j]]+lookup2[srcVp[j]])>>2);

		dstVp+=dst_pitch_V;

		JPSDR_HDRTools_Convert420_to_Planar422_8to16_SSE2(src_V,src_Vn,dstVp,w_V8);

		const uint8_t *srcVn=src_Vn+offsetV8;
		dstV=(uint16_t *)(dstVp+offsetV16);

		for(int32_t j=0; j<wV0; j++)
			dstV[j]=(uint16_t)((lookup1[srcV[j]]+lookup2[srcVn[j]])>>2);
		dstVp+=dst_pitch_V;

		src_V+=src_pitch_V;
		src_Vp+=src_pitch_V;
		src_Vn+=src_pitch_V;
	}

	if (mt_data_inf.bottom)
	{
		for(int32_t i=h_2; i<h_Y_max; i+=2)
		{
			JPSDR_HDRTools_Convert420_to_Planar422_8to16_SSE2(src_V,src_Vp,dstVp,w_V8);

			const uint8_t *srcV=src_V+offsetV8,*srcVp=src_Vp+offsetV8;
			uint16_t *dstV=(uint16_t *)(dstVp+offsetV16);

			for(int32_t j=0; j<wV0; j++)
				dstV[j]=(uint16_t)((lookup1[srcV[j]]+lookup2[srcVp[j]])>>2);

			dstVp+=dst_pitch_V;

			JPSDR_HDRTools_Move8to16_SSE2(dstVp,src_V,w_V8);
			JPSDR_HDRTools_Move8to16(dstVp+offsetV16,src_V+offsetV8,wV0);
			dstVp+=dst_pitch_V;

			src_V+=src_pitch_V;
			src_Vp+=src_pitch_V;
			src_Vn+=src_pitch_V;
		}
	}
}


static void Convert_Progressive_8_YV12toYV16_AVX(const MT_Data_Info_HDRTools &mt_data_inf)
{
	const uint8_t *srcYp=(const uint8_t *)mt_data_inf.src1;
	const uint8_t *srcU_=(const uint8_t *)mt_data_inf.src2;
	const uint8_t *srcV_=(const uint8_t *)mt_data_inf.src3;
	uint8_t *dstYp=(uint8_t *)mt_data_inf.dst1;
	uint8_t *dstUp=(uint8_t *)mt_data_inf.dst2;
	uint8_t *dstVp=(uint8_t *)mt_data_inf.dst3;
	const int32_t dst_w=mt_data_inf.dst_Y_w;
	const int32_t h_Y_min=mt_data_inf.src_Y_h_min;
	const int32_t h_Y_max=mt_data_inf.src_Y_h_max;
	const ptrdiff_t src_pitch_Y=mt_data_inf.src_pitch1;
	const ptrdiff_t src_pitch_U=mt_data_inf.src_pitch2;
	const ptrdiff_t src_pitch_V=mt_data_inf.src_pitch3;
	const ptrdiff_t dst_pitch_Y=mt_data_inf.dst_pitch1;
	const ptrdiff_t dst_pitch_U=mt_data_inf.dst_pitch2;
	const ptrdiff_t dst_pitch_V=mt_data_inf.dst_pitch3;

	const uint8_t *src_U,*src_Up,*src_Un;
	const uint8_t *src_V,*src_Vp,*src_Vn;
	const int32_t w_U=dst_w>>1,w_V=dst_w>>1;
	const int32_t w_U16=(w_U+15)>>4,w_V16=(w_V+15)>>4;
	const int32_t h_2 = mt_data_inf.bottom ? h_Y_max-2:h_Y_max;
	const int32_t h_0 = mt_data_inf.top ? 2:h_Y_min;

	src_U=srcU_;
	src_V=srcV_;
	src_Up=src_U-src_pitch_U;
	src_Un=src_U+src_pitch_U;
	src_Vp=src_V-src_pitch_V;
	src_Vn=src_V+src_pitch_V;

	Move_Full(srcYp,dstYp,dst_w,h_Y_max-h_Y_min,src_pitch_Y,dst_pitch_Y);

// Planar U
	if (mt_data_inf.top)
	{
		for(int32_t i=0; i<2; i+=2)
		{
			memcpy(dstUp,src_U,w_U);
			dstUp+=dst_pitch_U;

			JPSDR_HDRTools_Convert420_to_Planar422_8_AVX(src_U,src_Un,dstUp,w_U16);
			dstUp+=dst_pitch_U;

			src_U+=src_pitch_U;
			src_Up+=src_pitch_U;
			src_Un+=src_pitch_U;
		}
	}

	for(int32_t i=h_0; i<h_2; i+=2)
	{
		JPSDR_HDRTools_Convert420_to_Planar422_8_AVX(src_U,src_Up,dstUp,w_U16);
		dstUp+=dst_pitch_U;
		JPSDR_HDRTools_Convert420_to_Planar422_8_AVX(src_U,src_Un,dstUp,w_U16);
		dstUp+=dst_pitch_U;

		src_U+=src_pitch_U;
		src_Up+=src_pitch_U;
		src_Un+=src_pitch_U;
	}

	if (mt_data_inf.bottom)
	{
		for(int32_t i=h_2; i<h_Y_max; i+=2)
		{
			JPSDR_HDRTools_Convert420_to_Planar422_8_AVX(src_U,src_Up,dstUp,w_U16);
			dstUp+=dst_pitch_U;

			memcpy(dstUp,src_U,w_U);
			dstUp+=dst_pitch_U;

			src_U+=src_pitch_U;
			src_Up+=src_pitch_U;
			src_Un+=src_pitch_U;
		}
	}

// Planar V
	if (mt_data_inf.top)
	{
		for(int32_t i=0; i<2; i+=2)
		{
			memcpy(dstVp,src_V,w_V);
			dstVp+=dst_pitch_V;

			JPSDR_HDRTools_Convert420_to_Planar422_8_AVX(src_V,src_Vn,dstVp,w_V16);
			dstVp+=dst_pitch_V;

			src_V+=src_pitch_V;
			src_Vp+=src_pitch_V;
			src_Vn+=src_pitch_V;
		}
	}

	for(int32_t i=h_0; i<h_2; i+=2)
	{
		JPSDR_HDRTools_Convert420_to_Planar422_8_AVX(src_V,src_Vp,dstVp,w_V16);
		dstVp+=dst_pitch_V;
		JPSDR_HDRTools_Convert420_to_Planar422_8_AVX(src_V,src_Vn,dstVp,w_V16);
		dstVp+=dst_pitch_V;

		src_V+=src_pitch_V;
		src_Vp+=src_pitch_V;
		src_Vn+=src_pitch_V;
	}

	if (mt_data_inf.bottom)
	{
		for(int32_t i=h_2; i<h_Y_max; i+=2)
		{
			JPSDR_HDRTools_Convert420_to_Planar422_8_AVX(src_V,src_Vp,dstVp,w_V16);
			dstVp+=dst_pitch_V;

			memcpy(dstVp,src_V,w_V);
			dstVp+=dst_pitch_V;

			src_V+=src_pitch_V;
			src_Vp+=src_pitch_V;
			src_Vn+=src_pitch_V;
		}
	}
}


static void Convert_Progressive_8to16_YV12toYV16_AVX(const MT_Data_Info_HDRTools &mt_data_inf,uint32_t *lookup1,uint32_t *lookup2)
{
	const uint8_t *srcYp=(const uint8_t *)mt_data_inf.src1;
	const uint8_t *srcU_=(const uint8_t *)mt_data_inf.src2;
	const uint8_t *srcV_=(const uint8_t *)mt_data_inf.src3;
	uint8_t *dstYp=(uint8_t *)mt_data_inf.dst1;
	uint8_t *dstUp=(uint8_t *)mt_data_inf.dst2;
	uint8_t *dstVp=(uint8_t *)mt_data_inf.dst3;
	const int32_t dst_w=mt_data_inf.dst_Y_w;
	const int32_t h_Y_min=mt_data_inf.src_Y_h_min;
	const int32_t h_Y_max=mt_data_inf.src_Y_h_max;
	const ptrdiff_t src_pitch_Y=mt_data_inf.src_pitch1;
	const ptrdiff_t src_pitch_U=mt_data_inf.src_pitch2;
	const ptrdiff_t src_pitch_V=mt_data_inf.src_pitch3;
	const ptrdiff_t dst_pitch_Y=mt_data_inf.dst_pitch1;
	const ptrdiff_t dst_pitch_U=mt_data_inf.dst_pitch2;
	const ptrdiff_t dst_pitch_V=mt_data_inf.dst_pitch3;

	const uint8_t *src_U,*src_Up,*src_Un;
	const uint8_t *src_V,*src_Vp,*src_Vn;
	const int32_t w_U=dst_w >> 1,w_V=dst_w >> 1;
	const int32_t w_U8=((w_U+7) >> 3)-1,w_V8=((w_V+7) >> 3)-1;
	const int32_t wU0=w_U-(w_U8 << 3),wV0=w_V-(w_V8 << 3);
	const uint32_t offsetU8=w_U8 << 3,offsetU16=offsetU8 << 1;
	const uint32_t offsetV8=w_V8 << 3,offsetV16=offsetV8 << 1;
	const int32_t h_2 = mt_data_inf.bottom ? h_Y_max-2:h_Y_max;
	const int32_t h_0 = mt_data_inf.top ? 2:h_Y_min;

	src_U=srcU_;
	src_V=srcV_;
	src_Up=src_U-src_pitch_U;
	src_Un=src_U+src_pitch_U;
	src_Vp=src_V-src_pitch_V;
	src_Vn=src_V+src_pitch_V;

	Move_Full_8to16_AVX(srcYp,dstYp,dst_w,h_Y_max-h_Y_min,src_pitch_Y,dst_pitch_Y);

// Planar U
	if (mt_data_inf.top)
	{
		for(int32_t i=0; i<2; i+=2)
		{
			JPSDR_HDRTools_Move8to16_AVX(dstUp,src_U,w_U8);
			JPSDR_HDRTools_Move8to16(dstUp+offsetU16,src_U+offsetU8,wU0);
			dstUp+=dst_pitch_U;

			JPSDR_HDRTools_Convert420_to_Planar422_8to16_AVX(src_U,src_Un,dstUp,w_U8);

			const uint8_t *srcU=src_U+offsetU8,*srcUn=src_Un+offsetU8;
			uint16_t *dstU=(uint16_t *)(dstUp+offsetU16);

			for(int32_t j=0; j<wU0; j++)
				dstU[j]=(uint16_t)((lookup1[srcU[j]]+lookup2[srcUn[j]])>>2);

			dstUp+=dst_pitch_U;

			src_U+=src_pitch_U;
			src_Up+=src_pitch_U;
			src_Un+=src_pitch_U;
		}
	}

	for(int32_t i=h_0; i<h_2; i+=2)
	{
		JPSDR_HDRTools_Convert420_to_Planar422_8to16_AVX(src_U,src_Up,dstUp,w_U8);

		const uint8_t *srcU=src_U+offsetU8,*srcUp=src_Up+offsetU8;
		uint16_t *dstU=(uint16_t *)(dstUp+offsetU16);

		for(int32_t j=0; j<wU0; j++)
			dstU[j]=(uint16_t)((lookup1[srcU[j]]+lookup2[srcUp[j]])>>2);

		dstUp+=dst_pitch_U;

		JPSDR_HDRTools_Convert420_to_Planar422_8to16_AVX(src_U,src_Un,dstUp,w_U8);

		const uint8_t *srcUn=src_Un+offsetU8;
		dstU=(uint16_t *)(dstUp+offsetU16);

		for(int32_t j=0; j<wU0; j++)
			dstU[j]=(uint16_t)((lookup1[srcU[j]]+lookup2[srcUn[j]])>>2);
		dstUp+=dst_pitch_U;

		src_U+=src_pitch_U;
		src_Up+=src_pitch_U;
		src_Un+=src_pitch_U;
	}

	if (mt_data_inf.bottom)
	{
		for(int32_t i=h_2; i<h_Y_max; i+=2)
		{
			JPSDR_HDRTools_Convert420_to_Planar422_8to16_AVX(src_U,src_Up,dstUp,w_U8);

			const uint8_t *srcU=src_U+offsetU8,*srcUp=src_Up+offsetU8;
			uint16_t *dstU=(uint16_t *)(dstUp+offsetU16);

			for(int32_t j=0; j<wU0; j++)
				dstU[j]=(uint16_t)((lookup1[srcU[j]]+lookup2[srcUp[j]])>>2);

			dstUp+=dst_pitch_U;

			JPSDR_HDRTools_Move8to16_AVX(dstUp,src_U,w_U8);
			JPSDR_HDRTools_Move8to16(dstUp+offsetU16,src_U+offsetU8,wU0);
			dstUp+=dst_pitch_U;

			src_U+=src_pitch_U;
			src_Up+=src_pitch_U;
			src_Un+=src_pitch_U;
		}
	}

// Planar V
	if (mt_data_inf.top)
	{
		for(int32_t i=0; i<2; i+=2)
		{
			JPSDR_HDRTools_Move8to16_AVX(dstVp,src_V,w_V8);
			JPSDR_HDRTools_Move8to16(dstVp+offsetV16,src_V+offsetV8,wV0);
			dstVp+=dst_pitch_V;

			JPSDR_HDRTools_Convert420_to_Planar422_8to16_AVX(src_V,src_Vn,dstVp,w_V8);

			const uint8_t *srcV=src_V+offsetV8,*srcVn=src_Vn+offsetV8;
			uint16_t *dstV=(uint16_t *)(dstVp+offsetV16);

			for(int32_t j=0; j<wV0; j++)
				dstV[j]=(uint16_t)((lookup1[srcV[j]]+lookup2[srcVn[j]])>>2);

			dstVp+=dst_pitch_V;

			src_V+=src_pitch_V;
			src_Vp+=src_pitch_V;
			src_Vn+=src_pitch_V;
		}
	}

	for(int32_t i=h_0; i<h_2; i+=2)
	{
		JPSDR_HDRTools_Convert420_to_Planar422_8to16_AVX(src_V,src_Vp,dstVp,w_V8);

		const uint8_t *srcV=src_V+offsetV8,*srcVp=src_Vp+offsetV8;
		uint16_t *dstV=(uint16_t *)(dstVp+offsetV16);

		for(int32_t j=0; j<wV0; j++)
			dstV[j]=(uint16_t)((lookup1[srcV[j]]+lookup2[srcVp[j]])>>2);

		dstVp+=dst_pitch_V;

		JPSDR_HDRTools_Convert420_to_Planar422_8to16_AVX(src_V,src_Vn,dstVp,w_V8);

		const uint8_t *srcVn=src_Vn+offsetV8;
		dstV=(uint16_t *)(dstVp+offsetV16);

		for(int32_t j=0; j<wV0; j++)
			dstV[j]=(uint16_t)((lookup1[srcV[j]]+lookup2[srcVn[j]])>>2);
		dstVp+=dst_pitch_V;

		src_V+=src_pitch_V;
		src_Vp+=src_pitch_V;
		src_Vn+=src_pitch_V;
	}

	if (mt_data_inf.bottom)
	{
		for(int32_t i=h_2; i<h_Y_max; i+=2)
		{
			JPSDR_HDRTools_Convert420_to_Planar422_8to16_AVX(src_V,src_Vp,dstVp,w_V8);

			const uint8_t *srcV=src_V+offsetV8,*srcVp=src_Vp+offsetV8;
			uint16_t *dstV=(uint16_t *)(dstVp+offsetV16);

			for(int32_t j=0; j<wV0; j++)
				dstV[j]=(uint16_t)((lookup1[srcV[j]]+lookup2[srcVp[j]])>>2);

			dstVp+=dst_pitch_V;

			JPSDR_HDRTools_Move8to16_AVX(dstVp,src_V,w_V8);
			JPSDR_HDRTools_Move8to16(dstVp+offsetV16,src_V+offsetV8,wV0);
			dstVp+=dst_pitch_V;

			src_V+=src_pitch_V;
			src_Vp+=src_pitch_V;
			src_Vn+=src_pitch_V;
		}
	}
}


static void Convert_Progressive_16_YV12toYV16_SSE2(const MT_Data_Info_HDRTools &mt_data_inf)
{
	const uint8_t *srcYp=(const uint8_t *)mt_data_inf.src1;
	const uint8_t *srcU_=(const uint8_t *)mt_data_inf.src2;
	const uint8_t *srcV_=(const uint8_t *)mt_data_inf.src3;
	uint8_t *dstYp=(uint8_t *)mt_data_inf.dst1;
	uint8_t *dstUp=(uint8_t *)mt_data_inf.dst2;
	uint8_t *dstVp=(uint8_t *)mt_data_inf.dst3;
	const int32_t dst_w=mt_data_inf.dst_Y_w;
	const int32_t h_Y_min=mt_data_inf.src_Y_h_min;
	const int32_t h_Y_max=mt_data_inf.src_Y_h_max;
	const ptrdiff_t src_pitch_Y=mt_data_inf.src_pitch1;
	const ptrdiff_t src_pitch_U=mt_data_inf.src_pitch2;
	const ptrdiff_t src_pitch_V=mt_data_inf.src_pitch3;
	const ptrdiff_t dst_pitch_Y=mt_data_inf.dst_pitch1;
	const ptrdiff_t dst_pitch_U=mt_data_inf.dst_pitch2;
	const ptrdiff_t dst_pitch_V=mt_data_inf.dst_pitch3;

	const uint8_t *src_U,*src_Up,*src_Un;
	const uint8_t *src_V,*src_Vp,*src_Vn;
	const int32_t w_U=dst_w>>1,w_V=dst_w>>1;
	const int32_t w_U2=w_U << 1,w_V2=w_V << 1;
	const int32_t w_U8=(w_U+7)>>3,w_V8=(w_V+7)>>3;
	const int32_t h_2 = mt_data_inf.bottom ? h_Y_max-2:h_Y_max;
	const int32_t h_0 = mt_data_inf.top ? 2:h_Y_min;

	src_U=srcU_;
	src_V=srcV_;
	src_Up=src_U-src_pitch_U;
	src_Un=src_U+src_pitch_U;
	src_Vp=src_V-src_pitch_V;
	src_Vn=src_V+src_pitch_V;


	Move_Full(srcYp,dstYp,dst_w << 1,h_Y_max-h_Y_min,src_pitch_Y,dst_pitch_Y);

// Planar U
	if (mt_data_inf.top)
	{
		for(int32_t i=0; i<2; i+=2)
		{
			memcpy(dstUp,src_U,w_U2);
			dstUp+=dst_pitch_U;

			JPSDR_HDRTools_Convert420_to_Planar422_16_SSE2(src_U,src_Un,dstUp,w_U8);
			dstUp+=dst_pitch_U;

			src_U+=src_pitch_U;
			src_Up+=src_pitch_U;
			src_Un+=src_pitch_U;
		}
	}

	for(int32_t i=h_0; i<h_2; i+=2)
	{
		JPSDR_HDRTools_Convert420_to_Planar422_16_SSE2(src_U,src_Up,dstUp,w_U8);
		dstUp+=dst_pitch_U;
		JPSDR_HDRTools_Convert420_to_Planar422_16_SSE2(src_U,src_Un,dstUp,w_U8);
		dstUp+=dst_pitch_U;

		src_U+=src_pitch_U;
		src_Up+=src_pitch_U;
		src_Un+=src_pitch_U;
	}

	if (mt_data_inf.bottom)
	{
		for(int32_t i=h_2; i<h_Y_max; i+=2)
		{
			JPSDR_HDRTools_Convert420_to_Planar422_16_SSE2(src_U,src_Up,dstUp,w_U8);
			dstUp+=dst_pitch_U;

			memcpy(dstUp,src_U,w_U2);
			dstUp+=dst_pitch_U;

			src_U+=src_pitch_U;
			src_Up+=src_pitch_U;
			src_Un+=src_pitch_U;
		}
	}

// Planar V
	if (mt_data_inf.top)
	{
		for(int32_t i=0; i<2; i+=2)
		{
			memcpy(dstVp,src_V,w_V2);
			dstVp+=dst_pitch_V;

			JPSDR_HDRTools_Convert420_to_Planar422_16_SSE2(src_V,src_Vn,dstVp,w_V8);
			dstVp+=dst_pitch_V;

			src_V+=src_pitch_V;
			src_Vp+=src_pitch_V;
			src_Vn+=src_pitch_V;
		}
	}

	for(int32_t i=h_0; i<h_2; i+=2)
	{
		JPSDR_HDRTools_Convert420_to_Planar422_16_SSE2(src_V,src_Vp,dstVp,w_V8);
		dstVp+=dst_pitch_V;
		JPSDR_HDRTools_Convert420_to_Planar422_16_SSE2(src_V,src_Vn,dstVp,w_V8);
		dstVp+=dst_pitch_V;

		src_V+=src_pitch_V;
		src_Vp+=src_pitch_V;
		src_Vn+=src_pitch_V;
	}

	if (mt_data_inf.bottom)
	{
		for(int32_t i=h_2; i<h_Y_max; i+=2)
		{
			JPSDR_HDRTools_Convert420_to_Planar422_16_SSE2(src_V,src_Vp,dstVp,w_V8);
			dstVp+=dst_pitch_V;

			memcpy(dstVp,src_V,w_V2);
			dstVp+=dst_pitch_V;

			src_V+=src_pitch_V;
			src_Vp+=src_pitch_V;
			src_Vn+=src_pitch_V;
		}
	}
}


static void Convert_Progressive_16_YV12toYV16_AVX(const MT_Data_Info_HDRTools &mt_data_inf)
{
	const uint8_t *srcYp=(const uint8_t *)mt_data_inf.src1;
	const uint8_t *srcU_=(const uint8_t *)mt_data_inf.src2;
	const uint8_t *srcV_=(const uint8_t *)mt_data_inf.src3;
	uint8_t *dstYp=(uint8_t *)mt_data_inf.dst1;
	uint8_t *dstUp=(uint8_t *)mt_data_inf.dst2;
	uint8_t *dstVp=(uint8_t *)mt_data_inf.dst3;
	const int32_t dst_w=mt_data_inf.dst_Y_w;
	const int32_t h_Y_min=mt_data_inf.src_Y_h_min;
	const int32_t h_Y_max=mt_data_inf.src_Y_h_max;
	const ptrdiff_t src_pitch_Y=mt_data_inf.src_pitch1;
	const ptrdiff_t src_pitch_U=mt_data_inf.src_pitch2;
	const ptrdiff_t src_pitch_V=mt_data_inf.src_pitch3;
	const ptrdiff_t dst_pitch_Y=mt_data_inf.dst_pitch1;
	const ptrdiff_t dst_pitch_U=mt_data_inf.dst_pitch2;
	const ptrdiff_t dst_pitch_V=mt_data_inf.dst_pitch3;

	const uint8_t *src_U,*src_Up,*src_Un;
	const uint8_t *src_V,*src_Vp,*src_Vn;
	const int32_t w_U=dst_w>>1,w_V=dst_w>>1;
	const int32_t w_U2=w_U << 1,w_V2=w_V << 1;
	const int32_t w_U8=(w_U+7)>>3,w_V8=(w_V+7)>>3;
	const int32_t h_2 = mt_data_inf.bottom ? h_Y_max-2:h_Y_max;
	const int32_t h_0 = mt_data_inf.top ? 2:h_Y_min;

	src_U=srcU_;
	src_V=srcV_;
	src_Up=src_U-src_pitch_U;
	src_Un=src_U+src_pitch_U;
	src_Vp=src_V-src_pitch_V;
	src_Vn=src_V+src_pitch_V;

	Move_Full(srcYp,dstYp,dst_w << 1,h_Y_max-h_Y_min,src_pitch_Y,dst_pitch_Y);

// Planar U
	if (mt_data_inf.top)
	{
		for(int32_t i=0; i<2; i+=2)
		{
			memcpy(dstUp,src_U,w_U2);
			dstUp+=dst_pitch_U;

			JPSDR_HDRTools_Convert420_to_Planar422_16_AVX(src_U,src_Un,dstUp,w_U8);
			dstUp+=dst_pitch_U;

			src_U+=src_pitch_U;
			src_Up+=src_pitch_U;
			src_Un+=src_pitch_U;
		}
	}

	for(int32_t i=h_0; i<h_2; i+=2)
	{
		JPSDR_HDRTools_Convert420_to_Planar422_16_AVX(src_U,src_Up,dstUp,w_U8);
		dstUp+=dst_pitch_U;
		JPSDR_HDRTools_Convert420_to_Planar422_16_AVX(src_U,src_Un,dstUp,w_U8);
		dstUp+=dst_pitch_U;

		src_U+=src_pitch_U;
		src_Up+=src_pitch_U;
		src_Un+=src_pitch_U;
	}

	if (mt_data_inf.bottom)
	{
		for(int32_t i=h_2; i<h_Y_max; i+=2)
		{
			JPSDR_HDRTools_Convert420_to_Planar422_16_AVX(src_U,src_Up,dstUp,w_U8);
			dstUp+=dst_pitch_U;

			memcpy(dstUp,src_U,w_U2);
			dstUp+=dst_pitch_U;

			src_U+=src_pitch_U;
			src_Up+=src_pitch_U;
			src_Un+=src_pitch_U;
		}
	}

// Planar V
	if (mt_data_inf.top)
	{
		for(int32_t i=0; i<2; i+=2)
		{
			memcpy(dstVp,src_V,w_V2);
			dstVp+=dst_pitch_V;

			JPSDR_HDRTools_Convert420_to_Planar422_16_AVX(src_V,src_Vn,dstVp,w_V8);
			dstVp+=dst_pitch_V;

			src_V+=src_pitch_V;
			src_Vp+=src_pitch_V;
			src_Vn+=src_pitch_V;
		}
	}

	for(int32_t i=h_0; i<h_2; i+=2)
	{
		JPSDR_HDRTools_Convert420_to_Planar422_16_AVX(src_V,src_Vp,dstVp,w_V8);
		dstVp+=dst_pitch_V;
		JPSDR_HDRTools_Convert420_to_Planar422_16_AVX(src_V,src_Vn,dstVp,w_V8);
		dstVp+=dst_pitch_V;

		src_V+=src_pitch_V;
		src_Vp+=src_pitch_V;
		src_Vn+=src_pitch_V;
	}

	if (mt_data_inf.bottom)
	{
		for(int32_t i=h_2; i<h_Y_max; i+=2)
		{
			JPSDR_HDRTools_Convert420_to_Planar422_16_AVX(src_V,src_Vp,dstVp,w_V8);
			dstVp+=dst_pitch_V;

			memcpy(dstVp,src_V,w_V2);
			dstVp+=dst_pitch_V;

			src_V+=src_pitch_V;
			src_Vp+=src_pitch_V;
			src_Vn+=src_pitch_V;
		}
	}
}


#ifdef AVX2_BUILD_POSSIBLE
static void Convert_Progressive_8_YV12toYV16_AVX2(const MT_Data_Info_HDRTools &mt_data_inf)
{
	const uint8_t *srcYp=(const uint8_t *)mt_data_inf.src1;
	const uint8_t *srcU_=(const uint8_t *)mt_data_inf.src2;
	const uint8_t *srcV_=(const uint8_t *)mt_data_inf.src3;
	uint8_t *dstYp=(uint8_t *)mt_data_inf.dst1;
	uint8_t *dstUp=(uint8_t *)mt_data_inf.dst2;
	uint8_t *dstVp=(uint8_t *)mt_data_inf.dst3;
	const int32_t dst_w=mt_data_inf.dst_Y_w;
	const int32_t h_Y_min=mt_data_inf.src_Y_h_min;
	const int32_t h_Y_max=mt_data_inf.src_Y_h_max;
	const ptrdiff_t src_pitch_Y=mt_data_inf.src_pitch1;
	const ptrdiff_t src_pitch_U=mt_data_inf.src_pitch2;
	const ptrdiff_t src_pitch_V=mt_data_inf.src_pitch3;
	const ptrdiff_t dst_pitch_Y=mt_data_inf.dst_pitch1;
	const ptrdiff_t dst_pitch_U=mt_data_inf.dst_pitch2;
	const ptrdiff_t dst_pitch_V=mt_data_inf.dst_pitch3;

	const uint8_t *src_U,*src_Up,*src_Un;
	const uint8_t *src_V,*src_Vp,*src_Vn;
	const int32_t w_U=dst_w>>1,w_V=dst_w>>1;
	const int32_t w_U32=(w_U+31)>>5,w_V32=(w_V+31)>>5;
	const int32_t h_2 = mt_data_inf.bottom ? h_Y_max-2:h_Y_max;
	const int32_t h_0 = mt_data_inf.top ? 2:h_Y_min;

	src_U=srcU_;
	src_V=srcV_;
	src_Up=src_U-src_pitch_U;
	src_Un=src_U+src_pitch_U;
	src_Vp=src_V-src_pitch_V;
	src_Vn=src_V+src_pitch_V;

	Move_Full(srcYp,dstYp,dst_w,h_Y_max-h_Y_min,src_pitch_Y,dst_pitch_Y);

// Planar U
	if (mt_data_inf.top)
	{
		for(int32_t i=0; i<2; i+=2)
		{
			memcpy(dstUp,src_U,w_U);
			dstUp+=dst_pitch_U;

			JPSDR_HDRTools_Convert420_to_Planar422_8_AVX2(src_U,src_Un,dstUp,w_U32);
			dstUp+=dst_pitch_U;

			src_U+=src_pitch_U;
			src_Up+=src_pitch_U;
			src_Un+=src_pitch_U;
		}
	}

	for(int32_t i=h_0; i<h_2; i+=2)
	{
		JPSDR_HDRTools_Convert420_to_Planar422_8_AVX2(src_U,src_Up,dstUp,w_U32);
		dstUp+=dst_pitch_U;
		JPSDR_HDRTools_Convert420_to_Planar422_8_AVX2(src_U,src_Un,dstUp,w_U32);
		dstUp+=dst_pitch_U;

		src_U+=src_pitch_U;
		src_Up+=src_pitch_U;
		src_Un+=src_pitch_U;
	}

	if (mt_data_inf.bottom)
	{
		for(int32_t i=h_2; i<h_Y_max; i+=2)
		{
			JPSDR_HDRTools_Convert420_to_Planar422_8_AVX2(src_U,src_Up,dstUp,w_U32);
			dstUp+=dst_pitch_U;

			memcpy(dstUp,src_U,w_U);
			dstUp+=dst_pitch_U;

			src_U+=src_pitch_U;
			src_Up+=src_pitch_U;
			src_Un+=src_pitch_U;
		}
	}

// Planar V
	if (mt_data_inf.top)
	{
		for(int32_t i=0; i<2; i+=2)
		{
			memcpy(dstVp,src_V,w_V);
			dstVp+=dst_pitch_V;

			JPSDR_HDRTools_Convert420_to_Planar422_8_AVX2(src_V,src_Vn,dstVp,w_V32);
			dstVp+=dst_pitch_V;

			src_V+=src_pitch_V;
			src_Vp+=src_pitch_V;
			src_Vn+=src_pitch_V;
		}
	}

	for(int32_t i=h_0; i<h_2; i+=2)
	{
		JPSDR_HDRTools_Convert420_to_Planar422_8_AVX2(src_V,src_Vp,dstVp,w_V32);
		dstVp+=dst_pitch_V;
		JPSDR_HDRTools_Convert420_to_Planar422_8_AVX2(src_V,src_Vn,dstVp,w_V32);
		dstVp+=dst_pitch_V;

		src_V+=src_pitch_V;
		src_Vp+=src_pitch_V;
		src_Vn+=src_pitch_V;
	}

	if (mt_data_inf.bottom)
	{
		for(int32_t i=h_2; i<h_Y_max; i+=2)
		{
			JPSDR_HDRTools_Convert420_to_Planar422_8_AVX2(src_V,src_Vp,dstVp,w_V32);
			dstVp+=dst_pitch_V;

			memcpy(dstVp,src_V,w_V);
			dstVp+=dst_pitch_V;

			src_V+=src_pitch_V;
			src_Vp+=src_pitch_V;
			src_Vn+=src_pitch_V;
		}
	}
}


static void Convert_Progressive_16_YV12toYV16_AVX2(const MT_Data_Info_HDRTools &mt_data_inf)
{
	const uint8_t *srcYp=(const uint8_t *)mt_data_inf.src1;
	const uint8_t *srcU_=(const uint8_t *)mt_data_inf.src2;
	const uint8_t *srcV_=(const uint8_t *)mt_data_inf.src3;
	uint8_t *dstYp=(uint8_t *)mt_data_inf.dst1;
	uint8_t *dstUp=(uint8_t *)mt_data_inf.dst2;
	uint8_t *dstVp=(uint8_t *)mt_data_inf.dst3;
	const int32_t dst_w=mt_data_inf.dst_Y_w;
	const int32_t h_Y_min=mt_data_inf.src_Y_h_min;
	const int32_t h_Y_max=mt_data_inf.src_Y_h_max;
	const ptrdiff_t src_pitch_Y=mt_data_inf.src_pitch1;
	const ptrdiff_t src_pitch_U=mt_data_inf.src_pitch2;
	const ptrdiff_t src_pitch_V=mt_data_inf.src_pitch3;
	const ptrdiff_t dst_pitch_Y=mt_data_inf.dst_pitch1;
	const ptrdiff_t dst_pitch_U=mt_data_inf.dst_pitch2;
	const ptrdiff_t dst_pitch_V=mt_data_inf.dst_pitch3;

	const uint8_t *src_U,*src_Up,*src_Un;
	const uint8_t *src_V,*src_Vp,*src_Vn;
	const int32_t w_U=dst_w>>1,w_V=dst_w>>1;
	const int32_t w_U2=w_U << 1,w_V2=w_V << 1;
	const int32_t w_U16=(w_U+15)>>4,w_V16=(w_V+15)>>4;
	const int32_t h_2 = mt_data_inf.bottom ? h_Y_max-2:h_Y_max;
	const int32_t h_0 = mt_data_inf.top ? 2:h_Y_min;

	src_U=srcU_;
	src_V=srcV_;
	src_Up=src_U-src_pitch_U;
	src_Un=src_U+src_pitch_U;
	src_Vp=src_V-src_pitch_V;
	src_Vn=src_V+src_pitch_V;

	Move_Full(srcYp,dstYp,dst_w << 1,h_Y_max-h_Y_min,src_pitch_Y,dst_pitch_Y);

// Planar U
	if (mt_data_inf.top)
	{
		for(int32_t i=0; i<2; i+=2)
		{
			memcpy(dstUp,src_U,w_U2);
			dstUp+=dst_pitch_U;

			JPSDR_HDRTools_Convert420_to_Planar422_16_AVX2(src_U,src_Un,dstUp,w_U16);
			dstUp+=dst_pitch_U;

			src_U+=src_pitch_U;
			src_Up+=src_pitch_U;
			src_Un+=src_pitch_U;
		}
	}

	for(int32_t i=h_0; i<h_2; i+=2)
	{
		JPSDR_HDRTools_Convert420_to_Planar422_16_AVX2(src_U,src_Up,dstUp,w_U16);
		dstUp+=dst_pitch_U;
		JPSDR_HDRTools_Convert420_to_Planar422_16_AVX2(src_U,src_Un,dstUp,w_U16);
		dstUp+=dst_pitch_U;

		src_U+=src_pitch_U;
		src_Up+=src_pitch_U;
		src_Un+=src_pitch_U;
	}

	if (mt_data_inf.bottom)
	{
		for(int32_t i=h_2; i<h_Y_max; i+=2)
		{
			JPSDR_HDRTools_Convert420_to_Planar422_16_AVX2(src_U,src_Up,dstUp,w_U16);
			dstUp+=dst_pitch_U;

			memcpy(dstUp,src_U,w_U2);
			dstUp+=dst_pitch_U;

			src_U+=src_pitch_U;
			src_Up+=src_pitch_U;
			src_Un+=src_pitch_U;
		}
	}

// Planar V
	if (mt_data_inf.top)
	{
		for(int32_t i=0; i<2; i+=2)
		{
			memcpy(dstVp,src_V,w_V2);
			dstVp+=dst_pitch_V;

			JPSDR_HDRTools_Convert420_to_Planar422_16_AVX2(src_V,src_Vn,dstVp,w_V16);
			dstVp+=dst_pitch_V;

			src_V+=src_pitch_V;
			src_Vp+=src_pitch_V;
			src_Vn+=src_pitch_V;
		}
	}

	for(int32_t i=h_0; i<h_2; i+=2)
	{
		JPSDR_HDRTools_Convert420_to_Planar422_16_AVX2(src_V,src_Vp,dstVp,w_V16);
		dstVp+=dst_pitch_V;
		JPSDR_HDRTools_Convert420_to_Planar422_16_AVX2(src_V,src_Vn,dstVp,w_V16);
		dstVp+=dst_pitch_V;

		src_V+=src_pitch_V;
		src_Vp+=src_pitch_V;
		src_Vn+=src_pitch_V;
	}

	if (mt_data_inf.bottom)
	{
		for(int32_t i=h_2; i<h_Y_max; i+=2)
		{
			JPSDR_HDRTools_Convert420_to_Planar422_16_AVX2(src_V,src_Vp,dstVp,w_V16);
			dstVp+=dst_pitch_V;

			memcpy(dstVp,src_V,w_V2);
			dstVp+=dst_pitch_V;

			src_V+=src_pitch_V;
			src_Vp+=src_pitch_V;
			src_Vn+=src_pitch_V;
		}
	}
}
#endif


static void Convert_Progressive_8_YV12toYV16(const MT_Data_Info_HDRTools &mt_data_inf,const uint16_t *lookup)
{
	const uint8_t *srcY=(const uint8_t *)mt_data_inf.src1;
	const uint8_t *srcU_=(const uint8_t *)mt_data_inf.src2;
	const uint8_t *srcV_=(const uint8_t *)mt_data_inf.src3;
	uint8_t *dstY=(uint8_t *)mt_data_inf.dst1;
	uint8_t *dstU_=(uint8_t *)mt_data_inf.dst2;
	uint8_t *dstV_=(uint8_t *)mt_data_inf.dst3;
	const int32_t dst_w=mt_data_inf.dst_Y_w;
	const int32_t h_Y_min=mt_data_inf.src_Y_h_min;
	const int32_t h_Y_max=mt_data_inf.src_Y_h_max;
	const ptrdiff_t src_pitch_Y=mt_data_inf.src_pitch1;
	const ptrdiff_t src_pitch_U=mt_data_inf.src_pitch2;
	const ptrdiff_t src_pitch_V=mt_data_inf.src_pitch3;
	const ptrdiff_t dst_pitch_Y=mt_data_inf.dst_pitch1;
	const ptrdiff_t dst_pitch_U=mt_data_inf.dst_pitch2;
	const ptrdiff_t dst_pitch_V=mt_data_inf.dst_pitch3;

	const uint8_t *src_U,*src_Up,*src_Un;
	const uint8_t *src_V,*src_Vp,*src_Vn;
	uint8_t *dst_U,*dst_V;
	const int32_t w_U=dst_w>>1,w_V=dst_w>>1;
	const int32_t h_2 = mt_data_inf.bottom ? h_Y_max-2:h_Y_max;
	const int32_t h_0 = mt_data_inf.top ? 2:h_Y_min;

	src_U=srcU_;
	src_V=srcV_;
	src_Up=src_U-src_pitch_U;
	src_Un=src_U+src_pitch_U;
	src_Vp=src_V-src_pitch_V;
	src_Vn=src_V+src_pitch_V;
	dst_U=dstU_;
	dst_V=dstV_;

	Move_Full(srcY,dstY,dst_w,h_Y_max-h_Y_min,src_pitch_Y,dst_pitch_Y);

// Planar U
	if (mt_data_inf.top)
	{
		for(int32_t i=0; i<2; i+=2)
		{
			memcpy(dst_U,src_U,w_U);
			dst_U+=dst_pitch_U;

			for(int32_t j=0; j<w_U; j++)
				dst_U[j]=(uint8_t)((lookup[src_U[j]]+(uint16_t)src_Un[j])>>2);
			dst_U+=dst_pitch_U;

			src_U+=src_pitch_U;
			src_Up+=src_pitch_U;
			src_Un+=src_pitch_U;
		}
	}

	for(int32_t i=h_0; i<h_2; i+=2)
	{
		for(int32_t j=0; j<w_U; j++)
			dst_U[j]=(uint8_t)((lookup[src_U[j]]+(uint16_t)src_Up[j])>>2);
		dst_U+=dst_pitch_U;

		for(int32_t j=0; j<w_U; j++)
			dst_U[j]=(uint8_t)((lookup[src_U[j]]+(uint16_t)src_Un[j])>>2);
		dst_U+=dst_pitch_U;

		src_U+=src_pitch_U;
		src_Up+=src_pitch_U;
		src_Un+=src_pitch_U;
	}

	if (mt_data_inf.bottom)
	{
		for(int32_t i=h_2; i<h_Y_max; i+=2)
		{
			for(int32_t j=0; j<w_U; j++)
				dst_U[j]=(uint8_t)((lookup[src_U[j]]+(uint16_t)src_Up[j])>>2);
			dst_U+=dst_pitch_U;

			memcpy(dst_U,src_U,w_U);
			dst_U+=dst_pitch_U;

			src_U+=src_pitch_U;
			src_Up+=src_pitch_U;
			src_Un+=src_pitch_U;
		}
	}

// Planar V
	if (mt_data_inf.top)
	{
		for(int32_t i=0; i<2; i+=2)
		{
			memcpy(dst_V,src_V,w_V);
			dst_V+=dst_pitch_V;

			for(int32_t j=0; j<w_V; j++)
				dst_V[j]=(uint8_t)((lookup[src_V[j]]+(uint16_t)src_Vn[j])>>2);
			dst_V+=dst_pitch_V;

			src_V+=src_pitch_V;
			src_Vp+=src_pitch_V;
			src_Vn+=src_pitch_V;
		}
	}

	for(int32_t i=h_0; i<h_2; i+=2)
	{
		for(int32_t j=0; j<w_V; j++)
			dst_V[j]=(uint8_t)((lookup[src_V[j]]+(uint16_t)src_Vp[j])>>2);
		dst_V+=dst_pitch_V;

		for(int32_t j=0; j<w_V; j++)
			dst_V[j]=(uint8_t)((lookup[src_V[j]]+(uint16_t)src_Vn[j])>>2);
		dst_V+=dst_pitch_V;

		src_V+=src_pitch_V;
		src_Vp+=src_pitch_V;
		src_Vn+=src_pitch_V;
	}

	if (mt_data_inf.bottom)
	{
		for(int32_t i=h_2; i<h_Y_max; i+=2)
		{
			for(int32_t j=0; j<w_V; j++)
				dst_V[j]=(uint8_t)((lookup[src_V[j]]+(uint16_t)src_Vp[j])>>2);
			dst_V+=dst_pitch_V;

			memcpy(dst_V,src_V,w_V);
			dst_V+=dst_pitch_V;

			src_V+=src_pitch_V;
			src_Vp+=src_pitch_V;
			src_Vn+=src_pitch_V;
		}
	}
}


static void Convert_Progressive_16_YV12toYV16(const MT_Data_Info_HDRTools &mt_data_inf,const uint32_t *lookup)
{
	const uint8_t *srcY=(const uint8_t *)mt_data_inf.src1;
	const uint8_t *srcU_=(const uint8_t *)mt_data_inf.src2;
	const uint8_t *srcV_=(const uint8_t *)mt_data_inf.src3;
	uint8_t *dstY=(uint8_t *)mt_data_inf.dst1;
	uint8_t *dstU_=(uint8_t *)mt_data_inf.dst2;
	uint8_t *dstV_=(uint8_t *)mt_data_inf.dst3;
	const int32_t dst_w=mt_data_inf.dst_Y_w;
	const int32_t h_Y_min=mt_data_inf.src_Y_h_min;
	const int32_t h_Y_max=mt_data_inf.src_Y_h_max;
	const ptrdiff_t src_pitch_Y=mt_data_inf.src_pitch1;
	const ptrdiff_t src_pitch_U=mt_data_inf.src_pitch2;
	const ptrdiff_t src_pitch_V=mt_data_inf.src_pitch3;
	const ptrdiff_t dst_pitch_Y=mt_data_inf.dst_pitch1;
	const ptrdiff_t dst_pitch_U=mt_data_inf.dst_pitch2;
	const ptrdiff_t dst_pitch_V=mt_data_inf.dst_pitch3;

	const uint8_t *src_U,*src_Up,*src_Un;
	const uint8_t *src_V,*src_Vp,*src_Vn;
	uint8_t *dst_U,*dst_V;
	const int32_t w_U=dst_w>>1,w_V=dst_w>>1;
	const int32_t w_U2=w_U << 1,w_V2=w_V << 1;
	const int32_t h_2 = mt_data_inf.bottom ? h_Y_max-2:h_Y_max;
	const int32_t h_0 = mt_data_inf.top ? 2:h_Y_min;

	src_U=srcU_;
	src_V=srcV_;
	src_Up=src_U-src_pitch_U;
	src_Un=src_U+src_pitch_U;
	src_Vp=src_V-src_pitch_V;
	src_Vn=src_V+src_pitch_V;
	dst_U=dstU_;
	dst_V=dstV_;

	Move_Full(srcY,dstY,dst_w << 1,h_Y_max-h_Y_min,src_pitch_Y,dst_pitch_Y);

// Planar U
	if (mt_data_inf.top)
	{
		for(int32_t i=0; i<2; i+=2)
		{
			memcpy(dst_U,src_U,w_U2);
			dst_U+=dst_pitch_U;

			const uint16_t *srcU=(const uint16_t *)src_U,*srcUn=(const uint16_t *)src_Un;
			uint16_t *dstU=(uint16_t *)dst_U;

			for(int32_t j=0; j<w_U; j++)
				dstU[j]=(uint16_t)((lookup[srcU[j]]+(uint32_t)srcUn[j])>>2);
			dst_U+=dst_pitch_U;

			src_U+=src_pitch_U;
			src_Up+=src_pitch_U;
			src_Un+=src_pitch_U;
		}
	}

	for(int32_t i=h_0; i<h_2; i+=2)
	{
		const uint16_t *srcU=(const uint16_t *)src_U,*srcUp=(const uint16_t *)src_Up;
		uint16_t *dstU=(uint16_t *)dst_U;

		for(int32_t j=0; j<w_U; j++)
			dstU[j]=(uint16_t)((lookup[srcU[j]]+(uint32_t)srcUp[j])>>2);
		dst_U+=dst_pitch_U;

		const uint16_t *srcUn=(const uint16_t *)src_Un;
		dstU=(uint16_t *)dst_U;

		for(int32_t j=0; j<w_U; j++)
			dstU[j]=(uint16_t)((lookup[srcU[j]]+(uint32_t)srcUn[j])>>2);
		dst_U+=dst_pitch_U;

		src_U+=src_pitch_U;
		src_Up+=src_pitch_U;
		src_Un+=src_pitch_U;
	}

	if (mt_data_inf.bottom)
	{
		for(int32_t i=h_2; i<h_Y_max; i+=2)
		{
			const uint16_t *srcU=(const uint16_t *)src_U,*srcUp=(const uint16_t *)src_Up;
			uint16_t *dstU=(uint16_t *)dst_U;

			for(int32_t j=0; j<w_U; j++)
				dstU[j]=(uint16_t)((lookup[srcU[j]]+(uint32_t)srcUp[j])>>2);
			dst_U+=dst_pitch_U;

			memcpy(dst_U,src_U,w_U2);
			dst_U+=dst_pitch_U;

			src_U+=src_pitch_U;
			src_Up+=src_pitch_U;
			src_Un+=src_pitch_U;
		}
	}

// Planar V
	if (mt_data_inf.top)
	{
		for(int32_t i=0; i<2; i+=2)
		{
			memcpy(dst_V,src_V,w_V2);
			dst_V+=dst_pitch_V;

			const uint16_t *srcV=(const uint16_t *)src_V,*srcVn=(const uint16_t *)src_Vn;
			uint16_t *dstV=(uint16_t *)dst_V;

			for(int32_t j=0; j<w_V; j++)
				dstV[j]=(uint16_t)((lookup[srcV[j]]+(uint32_t)srcVn[j])>>2);
			dst_V+=dst_pitch_V;

			src_V+=src_pitch_V;
			src_Vp+=src_pitch_V;
			src_Vn+=src_pitch_V;
		}
	}

	for(int32_t i=h_0; i<h_2; i+=2)
	{
		const uint16_t *srcV=(const uint16_t *)src_V,*srcVp=(const uint16_t *)src_Vp;
		uint16_t *dstV=(uint16_t *)dst_V;

		for(int32_t j=0; j<w_V; j++)
			dstV[j]=(uint16_t)((lookup[srcV[j]]+(uint32_t)srcVp[j])>>2);
		dst_V+=dst_pitch_V;

		const uint16_t *srcVn=(const uint16_t *)src_Vn;
		dstV=(uint16_t *)dst_V;

		for(int32_t j=0; j<w_V; j++)
			dstV[j]=(uint16_t)((lookup[srcV[j]]+(uint32_t)srcVn[j])>>2);
		dst_V+=dst_pitch_V;

		src_V+=src_pitch_V;
		src_Vp+=src_pitch_V;
		src_Vn+=src_pitch_V;
	}

	if (mt_data_inf.bottom)
	{
		for(int32_t i=h_2; i<h_Y_max; i+=2)
		{
			const uint16_t *srcV=(const uint16_t *)src_V,*srcVp=(const uint16_t *)src_Vp;
			uint16_t *dstV=(uint16_t *)dst_V;

			for(int32_t j=0; j<w_V; j++)
				dstV[j]=(uint16_t)((lookup[srcV[j]]+(uint32_t)srcVp[j])>>2);
			dst_V+=dst_pitch_V;

			memcpy(dst_V,src_V,w_V2);
			dst_V+=dst_pitch_V;

			src_V+=src_pitch_V;
			src_Vp+=src_pitch_V;
			src_Vn+=src_pitch_V;
		}
	}
}


static void Convert_Progressive_8to16_YV12toYV16(const MT_Data_Info_HDRTools &mt_data_inf,const uint32_t *lookup1,const uint32_t *lookup2)
{
	const uint8_t *srcY=(const uint8_t *)mt_data_inf.src1;
	const uint8_t *srcU_=(const uint8_t *)mt_data_inf.src2;
	const uint8_t *srcV_=(const uint8_t *)mt_data_inf.src3;
	uint8_t *dstY=(uint8_t *)mt_data_inf.dst1;
	uint8_t *dstU_=(uint8_t *)mt_data_inf.dst2;
	uint8_t *dstV_=(uint8_t *)mt_data_inf.dst3;
	const int32_t dst_w=mt_data_inf.dst_Y_w;
	const int32_t h_Y_min=mt_data_inf.src_Y_h_min;
	const int32_t h_Y_max=mt_data_inf.src_Y_h_max;
	const ptrdiff_t src_pitch_Y=mt_data_inf.src_pitch1;
	const ptrdiff_t src_pitch_U=mt_data_inf.src_pitch2;
	const ptrdiff_t src_pitch_V=mt_data_inf.src_pitch3;
	const ptrdiff_t dst_pitch_Y=mt_data_inf.dst_pitch1;
	const ptrdiff_t dst_pitch_U=mt_data_inf.dst_pitch2;
	const ptrdiff_t dst_pitch_V=mt_data_inf.dst_pitch3;

	const uint8_t *src_U,*src_Up,*src_Un;
	const uint8_t *src_V,*src_Vp,*src_Vn;
	uint8_t *dst_U,*dst_V;
	const int32_t w_U=dst_w>>1,w_V=dst_w>>1;
	const int32_t h_2 = mt_data_inf.bottom ? h_Y_max-2:h_Y_max;
	const int32_t h_0 = mt_data_inf.top ? 2:h_Y_min;

	src_U=srcU_;
	src_V=srcV_;
	src_Up=src_U-src_pitch_U;
	src_Un=src_U+src_pitch_U;
	src_Vp=src_V-src_pitch_V;
	src_Vn=src_V+src_pitch_V;
	dst_U=dstU_;
	dst_V=dstV_;

	Move_Full_8to16(srcY,dstY,dst_w,h_Y_max-h_Y_min,src_pitch_Y,dst_pitch_Y);

// Planar U
	if (mt_data_inf.top)
	{
		for(int32_t i=0; i<2; i+=2)
		{
			JPSDR_HDRTools_Move8to16(dst_U,src_U,w_U);
			dst_U+=dst_pitch_U;

			uint16_t *dstU=(uint16_t *)dst_U;

			for(int32_t j=0; j<w_U; j++)
				dstU[j]=(uint16_t)((lookup1[src_U[j]]+lookup2[src_Un[j]])>>2);
			dst_U+=dst_pitch_U;

			src_U+=src_pitch_U;
			src_Up+=src_pitch_U;
			src_Un+=src_pitch_U;
		}
	}

	for(int32_t i=h_0; i<h_2; i+=2)
	{
		uint16_t *dstU=(uint16_t *)dst_U;

		for(int32_t j=0; j<w_U; j++)
			dstU[j]=(uint16_t)((lookup1[src_U[j]]+lookup2[src_Up[j]])>>2);
		dst_U+=dst_pitch_U;

		dstU=(uint16_t *)dst_U;

		for(int32_t j=0; j<w_U; j++)
			dstU[j]=(uint16_t)((lookup1[src_U[j]]+lookup2[src_Un[j]])>>2);
		dst_U+=dst_pitch_U;

		src_U+=src_pitch_U;
		src_Up+=src_pitch_U;
		src_Un+=src_pitch_U;
	}

	if (mt_data_inf.bottom)
	{
		for(int32_t i=h_2; i<h_Y_max; i+=2)
		{
			uint16_t *dstU=(uint16_t *)dst_U;

			for(int32_t j=0; j<w_U; j++)
				dstU[j]=(uint16_t)((lookup1[src_U[j]]+lookup2[src_Up[j]])>>2);
			dst_U+=dst_pitch_U;

			JPSDR_HDRTools_Move8to16(dst_U,src_U,w_U);
			dst_U+=dst_pitch_U;

			src_U+=src_pitch_U;
			src_Up+=src_pitch_U;
			src_Un+=src_pitch_U;
		}
	}

// Planar V
	if (mt_data_inf.top)
	{
		for(int32_t i=0; i<2; i+=2)
		{
			JPSDR_HDRTools_Move8to16(dst_V,src_V,w_V);
			dst_V+=dst_pitch_V;

			uint16_t *dstV=(uint16_t *)dst_V;

			for(int32_t j=0; j<w_V; j++)
				dstV[j]=(uint16_t)((lookup1[src_V[j]]+lookup2[src_Vn[j]])>>2);
			dst_V+=dst_pitch_V;

			src_V+=src_pitch_V;
			src_Vp+=src_pitch_V;
			src_Vn+=src_pitch_V;
		}
	}

	for(int32_t i=h_0; i<h_2; i+=2)
	{
		uint16_t *dstV=(uint16_t *)dst_V;

		for(int32_t j=0; j<w_V; j++)
			dstV[j]=(uint16_t)((lookup1[src_V[j]]+lookup2[src_Vp[j]])>>2);
		dst_V+=dst_pitch_V;

		dstV=(uint16_t *)dst_V;

		for(int32_t j=0; j<w_V; j++)
			dstV[j]=(uint16_t)((lookup1[src_V[j]]+lookup2[src_Vn[j]])>>2);
		dst_V+=dst_pitch_V;

		src_V+=src_pitch_V;
		src_Vp+=src_pitch_V;
		src_Vn+=src_pitch_V;
	}

	if (mt_data_inf.bottom)
	{
		for(int32_t i=h_2; i<h_Y_max; i+=2)
		{
			uint16_t *dstV=(uint16_t *)dst_V;

			for(int32_t j=0; j<w_V; j++)
				dstV[j]=(uint16_t)((lookup1[src_V[j]]+lookup2[src_Vp[j]])>>2);
			dst_V+=dst_pitch_V;

			JPSDR_HDRTools_Move8to16(dst_V,src_V,w_V);
			dst_V+=dst_pitch_V;

			src_V+=src_pitch_V;
			src_Vp+=src_pitch_V;
			src_Vn+=src_pitch_V;
		}
	}
}


static void Convert_8_YV16toYV24(const MT_Data_Info_HDRTools &mt_data_inf)
{
	const uint8_t *srcY=(const uint8_t *)mt_data_inf.src1;
	const uint8_t *srcU=(const uint8_t *)mt_data_inf.src2;
	const uint8_t *srcV=(const uint8_t *)mt_data_inf.src3;
	uint8_t *dstY=(uint8_t *)mt_data_inf.dst1;
	uint8_t *dstU=(uint8_t *)mt_data_inf.dst2;
	uint8_t *dstV=(uint8_t *)mt_data_inf.dst3;
	const int32_t dst_w=mt_data_inf.dst_Y_w;
	const int32_t h_Y_min=mt_data_inf.src_Y_h_min;
	const int32_t h_Y_max=mt_data_inf.src_Y_h_max;
	const ptrdiff_t src_pitch_Y=mt_data_inf.src_pitch1;
	const ptrdiff_t src_pitch_U=mt_data_inf.src_pitch2;
	const ptrdiff_t src_pitch_V=mt_data_inf.src_pitch3;
	const ptrdiff_t dst_pitch_Y=mt_data_inf.dst_pitch1;
	const ptrdiff_t dst_pitch_U=mt_data_inf.dst_pitch2;
	const ptrdiff_t dst_pitch_V=mt_data_inf.dst_pitch3;

	const int32_t w_U=(dst_w>>1)-1,w_V=(dst_w>>1)-1;

	Move_Full(srcY,dstY,dst_w,h_Y_max-h_Y_min,src_pitch_Y,dst_pitch_Y);

// Planar U
	for(int32_t i=h_Y_min; i<h_Y_max; i++)
	{
		int32_t j2=0;

		for(int32_t j=0; j<w_U; j++)
		{
			dstU[j2++]=srcU[j];
			dstU[j2++]=(uint8_t)(((uint16_t)srcU[j]+(uint16_t)srcU[j+1])>>1);
		}
		dstU[j2++]=srcU[w_U];
		dstU[j2]=srcU[w_U];

		srcU+=src_pitch_U;
		dstU+=dst_pitch_U;
	}

// Planar V
	for(int32_t i=h_Y_min; i<h_Y_max; i++)
	{
		int32_t j2=0;

		for(int32_t j=0; j<w_V; j++)
		{
			dstV[j2++]=srcV[j];
			dstV[j2++]=(uint8_t)(((uint16_t)srcV[j]+(uint16_t)srcV[j+1])>>1);
		}
		dstV[j2++]=srcV[w_V];
		dstV[j2]=srcV[w_V];

		srcV+=src_pitch_V;
		dstV+=dst_pitch_V;
	}
}


static void Convert_8_YV16toYV24_SSE2(const MT_Data_Info_HDRTools &mt_data_inf)
{
	const uint8_t *srcY=(const uint8_t *)mt_data_inf.src1;
	const uint8_t *srcU=(const uint8_t *)mt_data_inf.src2;
	const uint8_t *srcV=(const uint8_t *)mt_data_inf.src3;
	uint8_t *dstY=(uint8_t *)mt_data_inf.dst1;
	uint8_t *dstU=(uint8_t *)mt_data_inf.dst2;
	uint8_t *dstV=(uint8_t *)mt_data_inf.dst3;
	const int32_t dst_w=mt_data_inf.dst_Y_w;
	const int32_t h_Y_min=mt_data_inf.src_Y_h_min;
	const int32_t h_Y_max=mt_data_inf.src_Y_h_max;
	const ptrdiff_t src_pitch_Y=mt_data_inf.src_pitch1;
	const ptrdiff_t src_pitch_U=mt_data_inf.src_pitch2;
	const ptrdiff_t src_pitch_V=mt_data_inf.src_pitch3;
	const ptrdiff_t dst_pitch_Y=mt_data_inf.dst_pitch1;
	const ptrdiff_t dst_pitch_U=mt_data_inf.dst_pitch2;
	const ptrdiff_t dst_pitch_V=mt_data_inf.dst_pitch3;

	const int32_t w_U=dst_w>>1,w_V=dst_w>>1;
	const int32_t w_U16=((w_U+15) >> 4)-1,w_V16=((w_V+15) >> 4)-1;
	const int32_t w_U0=(w_U-(w_U16 << 4))-1,w_V0=(w_V-(w_V16 << 4))-1;
	const uint32_t offsetU8=w_U16 << 4,offsetU16=offsetU8 << 1;
	const uint32_t offsetV8=w_V16 << 4,offsetV16=offsetV8 << 1;

	Move_Full(srcY,dstY,dst_w,h_Y_max-h_Y_min,src_pitch_Y,dst_pitch_Y);

// Planar U
	for(int32_t i=h_Y_min; i<h_Y_max; i++)
	{
		JPSDR_HDRTools_Convert422_to_Planar444_8_SSE2(srcU,dstU,w_U16);

		const uint8_t *src=srcU+offsetU8;
		uint8_t *dst=dstU+offsetU16;
		int32_t j2=0;

		for(int32_t j=0; j<w_U0; j++)
		{
			dst[j2++]=src[j];
			dst[j2++]=(uint8_t)(((uint16_t)src[j]+(uint16_t)src[j+1])>>1);
		}
		dst[j2++]=src[w_U0];
		dst[j2]=src[w_U0];

		srcU+=src_pitch_U;
		dstU+=dst_pitch_U;
	}

// Planar V
	for(int32_t i=h_Y_min; i<h_Y_max; i++)
	{
		JPSDR_HDRTools_Convert422_to_Planar444_8_SSE2(srcV,dstV,w_V16);

		const uint8_t *src=srcV+offsetV8;
		uint8_t *dst=dstV+offsetV16;
		int32_t j2=0;

		for(int32_t j=0; j<w_V0; j++)
		{
			dst[j2++]=src[j];
			dst[j2++]=(uint8_t)(((uint16_t)src[j]+(uint16_t)src[j+1])>>1);
		}
		dst[j2++]=src[w_V0];
		dst[j2]=src[w_V0];

		srcV+=src_pitch_V;
		dstV+=dst_pitch_V;
	}
}


static void Convert_8_YV16toYV24_AVX(const MT_Data_Info_HDRTools &mt_data_inf)
{
	const uint8_t *srcY=(const uint8_t *)mt_data_inf.src1;
	const uint8_t *srcU=(const uint8_t *)mt_data_inf.src2;
	const uint8_t *srcV=(const uint8_t *)mt_data_inf.src3;
	uint8_t *dstY=(uint8_t *)mt_data_inf.dst1;
	uint8_t *dstU=(uint8_t *)mt_data_inf.dst2;
	uint8_t *dstV=(uint8_t *)mt_data_inf.dst3;
	const int32_t dst_w=mt_data_inf.dst_Y_w;
	const int32_t h_Y_min=mt_data_inf.src_Y_h_min;
	const int32_t h_Y_max=mt_data_inf.src_Y_h_max;
	const ptrdiff_t src_pitch_Y=mt_data_inf.src_pitch1;
	const ptrdiff_t src_pitch_U=mt_data_inf.src_pitch2;
	const ptrdiff_t src_pitch_V=mt_data_inf.src_pitch3;
	const ptrdiff_t dst_pitch_Y=mt_data_inf.dst_pitch1;
	const ptrdiff_t dst_pitch_U=mt_data_inf.dst_pitch2;
	const ptrdiff_t dst_pitch_V=mt_data_inf.dst_pitch3;

	const int32_t w_U=dst_w>>1,w_V=dst_w>>1;
	const int32_t w_U16=((w_U+15) >> 4)-1,w_V16=((w_V+15) >> 4)-1;
	const int32_t w_U0=(w_U-(w_U16 << 4))-1,w_V0=(w_V-(w_V16 << 4))-1;
	const uint32_t offsetU8=w_U16 << 4,offsetU16=offsetU8 << 1;
	const uint32_t offsetV8=w_V16 << 4,offsetV16=offsetV8 << 1;

	Move_Full(srcY,dstY,dst_w,h_Y_max-h_Y_min,src_pitch_Y,dst_pitch_Y);

// Planar U
	for(int32_t i=h_Y_min; i<h_Y_max; i++)
	{
		JPSDR_HDRTools_Convert422_to_Planar444_8_AVX(srcU,dstU,w_U16);

		const uint8_t *src=srcU+offsetU8;
		uint8_t *dst=dstU+offsetU16;
		int32_t j2=0;

		for(int32_t j=0; j<w_U0; j++)
		{
			dst[j2++]=src[j];
			dst[j2++]=(uint8_t)(((uint16_t)src[j]+(uint16_t)src[j+1])>>1);
		}
		dst[j2++]=src[w_U0];
		dst[j2]=src[w_U0];

		srcU+=src_pitch_U;
		dstU+=dst_pitch_U;
	}

// Planar V
	for(int32_t i=h_Y_min; i<h_Y_max; i++)
	{
		JPSDR_HDRTools_Convert422_to_Planar444_8_AVX(srcV,dstV,w_V16);

		const uint8_t *src=srcV+offsetV8;
		uint8_t *dst=dstV+offsetV16;
		int32_t j2=0;

		for(int32_t j=0; j<w_V0; j++)
		{
			dst[j2++]=src[j];
			dst[j2++]=(uint8_t)(((uint16_t)src[j]+(uint16_t)src[j+1])>>1);
		}
		dst[j2++]=src[w_V0];
		dst[j2]=src[w_V0];

		srcV+=src_pitch_V;
		dstV+=dst_pitch_V;
	}
}


static void Convert_8to16_YV16toYV24(const MT_Data_Info_HDRTools &mt_data_inf,uint32_t *lookup)
{
	const uint8_t *srcY=(const uint8_t *)mt_data_inf.src1;
	const uint8_t *srcU=(const uint8_t *)mt_data_inf.src2;
	const uint8_t *srcV=(const uint8_t *)mt_data_inf.src3;
	uint8_t *dstY=(uint8_t *)mt_data_inf.dst1;
	uint8_t *dstU=(uint8_t *)mt_data_inf.dst2;
	uint8_t *dstV=(uint8_t *)mt_data_inf.dst3;
	const int32_t dst_w=mt_data_inf.dst_Y_w;
	const int32_t h_Y_min=mt_data_inf.src_Y_h_min;
	const int32_t h_Y_max=mt_data_inf.src_Y_h_max;
	const ptrdiff_t src_pitch_Y=mt_data_inf.src_pitch1;
	const ptrdiff_t src_pitch_U=mt_data_inf.src_pitch2;
	const ptrdiff_t src_pitch_V=mt_data_inf.src_pitch3;
	const ptrdiff_t dst_pitch_Y=mt_data_inf.dst_pitch1;
	const ptrdiff_t dst_pitch_U=mt_data_inf.dst_pitch2;
	const ptrdiff_t dst_pitch_V=mt_data_inf.dst_pitch3;

	const int32_t w_U=(dst_w>>1)-1,w_V=(dst_w>>1)-1;

	Move_Full_8to16(srcY,dstY,dst_w,h_Y_max-h_Y_min,src_pitch_Y,dst_pitch_Y);

// Planar U
	for(int32_t i=h_Y_min; i<h_Y_max; i++)
	{
		uint16_t *dst=(uint16_t *)dstU;
		int32_t j2=0;

		for(int32_t j=0; j<w_U; j++)
		{
			dst[j2++]=(uint16_t)lookup[srcU[j]];
			dst[j2++]=(uint16_t)((lookup[srcU[j]]+lookup[srcU[j+1]])>>1);
		}
		dst[j2]=(uint16_t)lookup[srcU[w_U]];
		dst[j2+1]=dst[j2];

		srcU+=src_pitch_U;
		dstU+=dst_pitch_U;
	}

// Planar V
	for(int32_t i=h_Y_min; i<h_Y_max; i++)
	{
		uint16_t *dst=(uint16_t *)dstV;
		int32_t j2=0;

		for(int32_t j=0; j<w_V; j++)
		{
			dst[j2++]=(uint16_t)lookup[srcV[j]];
			dst[j2++]=(uint16_t)((lookup[srcV[j]]+lookup[srcV[j+1]])>>1);
		}
		dst[j2]=(uint16_t)lookup[srcV[w_V]];
		dst[j2+1]=dst[j2];

		srcV+=src_pitch_V;
		dstV+=dst_pitch_V;
	}
}


static void Convert_8to16_YV16toYV24_SSE2(const MT_Data_Info_HDRTools &mt_data_inf,uint32_t *lookup)
{
	const uint8_t *srcY=(const uint8_t *)mt_data_inf.src1;
	const uint8_t *srcU=(const uint8_t *)mt_data_inf.src2;
	const uint8_t *srcV=(const uint8_t *)mt_data_inf.src3;
	uint8_t *dstY=(uint8_t *)mt_data_inf.dst1;
	uint8_t *dstU=(uint8_t *)mt_data_inf.dst2;
	uint8_t *dstV=(uint8_t *)mt_data_inf.dst3;
	const int32_t dst_w=mt_data_inf.dst_Y_w;
	const int32_t h_Y_min=mt_data_inf.src_Y_h_min;
	const int32_t h_Y_max=mt_data_inf.src_Y_h_max;
	const ptrdiff_t src_pitch_Y=mt_data_inf.src_pitch1;
	const ptrdiff_t src_pitch_U=mt_data_inf.src_pitch2;
	const ptrdiff_t src_pitch_V=mt_data_inf.src_pitch3;
	const ptrdiff_t dst_pitch_Y=mt_data_inf.dst_pitch1;
	const ptrdiff_t dst_pitch_U=mt_data_inf.dst_pitch2;
	const ptrdiff_t dst_pitch_V=mt_data_inf.dst_pitch3;

	const int32_t w_U=dst_w>>1,w_V=dst_w>>1;
	const int32_t w_U8=((w_U+7) >> 3)-1,w_V8=((w_V+7) >> 3)-1;
	const int32_t w_U0=(w_U-(w_U8 << 3))-1,w_V0=(w_V-(w_V8 << 3))-1;
	const uint32_t offsetU8=w_U8 << 3,offsetU16=offsetU8 << 2;
	const uint32_t offsetV8=w_V8 << 3,offsetV16=offsetV8 << 2;

	Move_Full_8to16_SSE2(srcY,dstY,dst_w,h_Y_max-h_Y_min,src_pitch_Y,dst_pitch_Y);

// Planar U
	for(int32_t i=h_Y_min; i<h_Y_max; i++)
	{
		JPSDR_HDRTools_Convert422_to_Planar444_8to16_SSE2(srcU,dstU,w_U8);

		const uint8_t *src=srcU+offsetU8;
		uint16_t *dst=(uint16_t *)(dstU+offsetU16);
		int32_t j2=0;

		for(int32_t j=0; j<w_U0; j++)
		{
			dst[j2++]=(uint16_t)lookup[src[j]];
			dst[j2++]=(uint16_t)((lookup[src[j]]+lookup[src[j+1]])>>1);
		}
		dst[j2]=(uint16_t)lookup[src[w_U0]];
		dst[j2+1]=dst[j2];

		srcU+=src_pitch_U;
		dstU+=dst_pitch_U;
	}

// Planar V
	for(int32_t i=h_Y_min; i<h_Y_max; i++)
	{
		JPSDR_HDRTools_Convert422_to_Planar444_8to16_SSE2(srcV,dstV,w_V8);

		const uint8_t *src=srcV+offsetV8;
		uint16_t *dst=(uint16_t *)(dstV+offsetV16);
		int32_t j2=0;

		for(int32_t j=0; j<w_V0; j++)
		{
			dst[j2++]=(uint16_t)lookup[src[j]];
			dst[j2++]=(uint16_t)((lookup[src[j]]+lookup[src[j+1]])>>1);
		}
		dst[j2]=(uint16_t)lookup[src[w_V0]];
		dst[j2+1]=dst[j2];

		srcV+=src_pitch_V;
		dstV+=dst_pitch_V;
	}
}


static void Convert_8to16_YV16toYV24_AVX(const MT_Data_Info_HDRTools &mt_data_inf,uint32_t *lookup)
{
	const uint8_t *srcY=(const uint8_t *)mt_data_inf.src1;
	const uint8_t *srcU=(const uint8_t *)mt_data_inf.src2;
	const uint8_t *srcV=(const uint8_t *)mt_data_inf.src3;
	uint8_t *dstY=(uint8_t *)mt_data_inf.dst1;
	uint8_t *dstU=(uint8_t *)mt_data_inf.dst2;
	uint8_t *dstV=(uint8_t *)mt_data_inf.dst3;
	const int32_t dst_w=mt_data_inf.dst_Y_w;
	const int32_t h_Y_min=mt_data_inf.src_Y_h_min;
	const int32_t h_Y_max=mt_data_inf.src_Y_h_max;
	const ptrdiff_t src_pitch_Y=mt_data_inf.src_pitch1;
	const ptrdiff_t src_pitch_U=mt_data_inf.src_pitch2;
	const ptrdiff_t src_pitch_V=mt_data_inf.src_pitch3;
	const ptrdiff_t dst_pitch_Y=mt_data_inf.dst_pitch1;
	const ptrdiff_t dst_pitch_U=mt_data_inf.dst_pitch2;
	const ptrdiff_t dst_pitch_V=mt_data_inf.dst_pitch3;

	const int32_t w_U=dst_w>>1,w_V=dst_w>>1;
	const int32_t w_U8=((w_U+7) >> 3)-1,w_V8=((w_V+7) >> 3)-1;
	const int32_t w_U0=(w_U-(w_U8 << 3))-1,w_V0=(w_V-(w_V8 << 3))-1;
	const uint32_t offsetU8=w_U8 << 3,offsetU16=offsetU8 << 2;
	const uint32_t offsetV8=w_V8 << 3,offsetV16=offsetV8 << 2;

	Move_Full_8to16_AVX(srcY,dstY,dst_w,h_Y_max-h_Y_min,src_pitch_Y,dst_pitch_Y);

// Planar U
	for(int32_t i=h_Y_min; i<h_Y_max; i++)
	{
		JPSDR_HDRTools_Convert422_to_Planar444_8to16_AVX(srcU,dstU,w_U8);

		const uint8_t *src=srcU+offsetU8;
		uint16_t *dst=(uint16_t *)(dstU+offsetU16);
		int32_t j2=0;

		for(int32_t j=0; j<w_U0; j++)
		{
			dst[j2++]=(uint16_t)lookup[src[j]];
			dst[j2++]=(uint16_t)((lookup[src[j]]+lookup[src[j+1]])>>1);
		}
		dst[j2]=(uint16_t)lookup[src[w_U0]];
		dst[j2+1]=dst[j2];

		srcU+=src_pitch_U;
		dstU+=dst_pitch_U;
	}

// Planar V
	for(int32_t i=h_Y_min; i<h_Y_max; i++)
	{
		JPSDR_HDRTools_Convert422_to_Planar444_8to16_AVX(srcV,dstV,w_V8);

		const uint8_t *src=srcV+offsetV8;
		uint16_t *dst=(uint16_t *)(dstV+offsetV16);
		int32_t j2=0;

		for(int32_t j=0; j<w_V0; j++)
		{
			dst[j2++]=(uint16_t)lookup[src[j]];
			dst[j2++]=(uint16_t)((lookup[src[j]]+lookup[src[j+1]])>>1);
		}
		dst[j2]=(uint16_t)lookup[src[w_V0]];
		dst[j2+1]=dst[j2];

		srcV+=src_pitch_V;
		dstV+=dst_pitch_V;
	}
}


static void Convert_16_YV16toYV24(const MT_Data_Info_HDRTools &mt_data_inf)
{
	const uint8_t *srcY=(const uint8_t *)mt_data_inf.src1;
	const uint8_t *srcU=(const uint8_t *)mt_data_inf.src2;
	const uint8_t *srcV=(const uint8_t *)mt_data_inf.src3;
	uint8_t *dstY=(uint8_t *)mt_data_inf.dst1;
	uint8_t *dstU=(uint8_t *)mt_data_inf.dst2;
	uint8_t *dstV=(uint8_t *)mt_data_inf.dst3;
	const int32_t dst_w=mt_data_inf.dst_Y_w;
	const int32_t h_Y_min=mt_data_inf.src_Y_h_min;
	const int32_t h_Y_max=mt_data_inf.src_Y_h_max;
	const ptrdiff_t src_pitch_Y=mt_data_inf.src_pitch1;
	const ptrdiff_t src_pitch_U=mt_data_inf.src_pitch2;
	const ptrdiff_t src_pitch_V=mt_data_inf.src_pitch3;
	const ptrdiff_t dst_pitch_Y=mt_data_inf.dst_pitch1;
	const ptrdiff_t dst_pitch_U=mt_data_inf.dst_pitch2;
	const ptrdiff_t dst_pitch_V=mt_data_inf.dst_pitch3;

	const int32_t w_U=(dst_w>>1)-1,w_V=(dst_w>>1)-1;

	Move_Full(srcY,dstY,dst_w << 1,h_Y_max-h_Y_min,src_pitch_Y,dst_pitch_Y);

// Planar U
	for(int32_t i=h_Y_min; i<h_Y_max; i++)
	{
		const uint16_t *src=(uint16_t *)srcU;
		uint16_t *dst=(uint16_t *)dstU;
		int32_t j2=0;

		for(int32_t j=0; j<w_U; j++)
		{
			dst[j2++]=src[j];
			dst[j2++]=(uint16_t)(((uint32_t)src[j]+(uint32_t)src[j+1])>>1);
		}
		dst[j2++]=src[w_U];
		dst[j2]=src[w_U];

		srcU+=src_pitch_U;
		dstU+=dst_pitch_U;
	}

// Planar V
	for(int32_t i=h_Y_min; i<h_Y_max; i++)
	{
		const uint16_t *src=(uint16_t *)srcV;
		uint16_t *dst=(uint16_t *)dstV;
		int32_t j2=0;

		for(int32_t j=0; j<w_V; j++)
		{
			dst[j2++]=src[j];
			dst[j2++]=(uint16_t)(((uint32_t)src[j]+(uint32_t)src[j+1])>>1);
		}
		dst[j2++]=src[w_V];
		dst[j2]=src[w_V];

		srcV+=src_pitch_V;
		dstV+=dst_pitch_V;
	}
}


static void Convert_16_YV16toYV24_SSE2(const MT_Data_Info_HDRTools &mt_data_inf)
{
	const uint8_t *srcY=(const uint8_t *)mt_data_inf.src1;
	const uint8_t *srcU=(const uint8_t *)mt_data_inf.src2;
	const uint8_t *srcV=(const uint8_t *)mt_data_inf.src3;
	uint8_t *dstY=(uint8_t *)mt_data_inf.dst1;
	uint8_t *dstU=(uint8_t *)mt_data_inf.dst2;
	uint8_t *dstV=(uint8_t *)mt_data_inf.dst3;
	const int32_t dst_w=mt_data_inf.dst_Y_w;
	const int32_t h_Y_min=mt_data_inf.src_Y_h_min;
	const int32_t h_Y_max=mt_data_inf.src_Y_h_max;
	const ptrdiff_t src_pitch_Y=mt_data_inf.src_pitch1;
	const ptrdiff_t src_pitch_U=mt_data_inf.src_pitch2;
	const ptrdiff_t src_pitch_V=mt_data_inf.src_pitch3;
	const ptrdiff_t dst_pitch_Y=mt_data_inf.dst_pitch1;
	const ptrdiff_t dst_pitch_U=mt_data_inf.dst_pitch2;
	const ptrdiff_t dst_pitch_V=mt_data_inf.dst_pitch3;

	const int32_t w_U=dst_w>>1,w_V=dst_w>>1;
	const int32_t w_U8=((w_U+7) >> 3)-1,w_V8=((w_V+7) >> 3)-1;
	const int32_t w_U0=(w_U-(w_U8 << 3))-1,w_V0=(w_V-(w_V8 << 3))-1;
	const uint32_t offsetU8=w_U8 << 4,offsetU16=offsetU8 << 1;
	const uint32_t offsetV8=w_V8 << 4,offsetV16=offsetV8 << 1;

	Move_Full(srcY,dstY,dst_w << 1,h_Y_max-h_Y_min,src_pitch_Y,dst_pitch_Y);

// Planar U
	for(int32_t i=h_Y_min; i<h_Y_max; i++)
	{
		JPSDR_HDRTools_Convert422_to_Planar444_16_SSE2(srcU,dstU,w_U8);

		const uint16_t *src=(uint16_t *)(srcU+offsetU8);
		uint16_t *dst=(uint16_t *)(dstU+offsetU16);
		int32_t j2=0;

		for(int32_t j=0; j<w_U0; j++)
		{
			dst[j2++]=src[j];
			dst[j2++]=(uint16_t)(((uint32_t)src[j]+(uint32_t)src[j+1])>>1);
		}
		dst[j2++]=src[w_U0];
		dst[j2]=src[w_U0];

		srcU+=src_pitch_U;
		dstU+=dst_pitch_U;
	}

// Planar V
	for(int32_t i=h_Y_min; i<h_Y_max; i++)
	{
		JPSDR_HDRTools_Convert422_to_Planar444_16_SSE2(srcV,dstV,w_V8);

		const uint16_t *src=(uint16_t *)(srcV+offsetV8);
		uint16_t *dst=(uint16_t *)(dstV+offsetV16);
		int32_t j2=0;

		for(int32_t j=0; j<w_V0; j++)
		{
			dst[j2++]=src[j];
			dst[j2++]=(uint16_t)(((uint32_t)src[j]+(uint32_t)src[j+1])>>1);
		}
		dst[j2++]=src[w_V0];
		dst[j2]=src[w_V0];

		srcV+=src_pitch_V;
		dstV+=dst_pitch_V;
	}
}


static void Convert_16_YV16toYV24_AVX(const MT_Data_Info_HDRTools &mt_data_inf)
{
	const uint8_t *srcY=(const uint8_t *)mt_data_inf.src1;
	const uint8_t *srcU=(const uint8_t *)mt_data_inf.src2;
	const uint8_t *srcV=(const uint8_t *)mt_data_inf.src3;
	uint8_t *dstY=(uint8_t *)mt_data_inf.dst1;
	uint8_t *dstU=(uint8_t *)mt_data_inf.dst2;
	uint8_t *dstV=(uint8_t *)mt_data_inf.dst3;
	const int32_t dst_w=mt_data_inf.dst_Y_w;
	const int32_t h_Y_min=mt_data_inf.src_Y_h_min;
	const int32_t h_Y_max=mt_data_inf.src_Y_h_max;
	const ptrdiff_t src_pitch_Y=mt_data_inf.src_pitch1;
	const ptrdiff_t src_pitch_U=mt_data_inf.src_pitch2;
	const ptrdiff_t src_pitch_V=mt_data_inf.src_pitch3;
	const ptrdiff_t dst_pitch_Y=mt_data_inf.dst_pitch1;
	const ptrdiff_t dst_pitch_U=mt_data_inf.dst_pitch2;
	const ptrdiff_t dst_pitch_V=mt_data_inf.dst_pitch3;

	const int32_t w_U=dst_w>>1,w_V=dst_w>>1;
	const int32_t w_U8=((w_U+7) >> 3)-1,w_V8=((w_V+7) >> 3)-1;
	const int32_t w_U0=(w_U-(w_U8 << 3))-1,w_V0=(w_V-(w_V8 << 3))-1;
	const uint32_t offsetU8=w_U8 << 4,offsetU16=offsetU8 << 1;
	const uint32_t offsetV8=w_V8 << 4,offsetV16=offsetV8 << 1;

	Move_Full(srcY,dstY,dst_w << 1,h_Y_max-h_Y_min,src_pitch_Y,dst_pitch_Y);

// Planar U
	for(int32_t i=h_Y_min; i<h_Y_max; i++)
	{
		JPSDR_HDRTools_Convert422_to_Planar444_16_AVX(srcU,dstU,w_U8);

		const uint16_t *src=(uint16_t *)(srcU+offsetU8);
		uint16_t *dst=(uint16_t *)(dstU+offsetU16);
		int32_t j2=0;

		for(int32_t j=0; j<w_U0; j++)
		{
			dst[j2++]=src[j];
			dst[j2++]=(uint16_t)(((uint32_t)src[j]+(uint32_t)src[j+1])>>1);
		}
		dst[j2++]=src[w_U0];
		dst[j2]=src[w_U0];

		srcU+=src_pitch_U;
		dstU+=dst_pitch_U;
	}

// Planar V
	for(int32_t i=h_Y_min; i<h_Y_max; i++)
	{
		JPSDR_HDRTools_Convert422_to_Planar444_16_AVX(srcV,dstV,w_V8);

		const uint16_t *src=(uint16_t *)(srcV+offsetV8);
		uint16_t *dst=(uint16_t *)(dstV+offsetV16);
		int32_t j2=0;

		for(int32_t j=0; j<w_V0; j++)
		{
			dst[j2++]=src[j];
			dst[j2++]=(uint16_t)(((uint32_t)src[j]+(uint32_t)src[j+1])>>1);
		}
		dst[j2++]=src[w_V0];
		dst[j2]=src[w_V0];

		srcV+=src_pitch_V;
		dstV+=dst_pitch_V;
	}
}


static void Convert_YV24toRGB32(const MT_Data_Info_HDRTools &mt_data_inf,const dataLookUp &dl,const int16_t *lookup)
{
	const uint8_t *src_y=(uint8_t *)mt_data_inf.src1;
	const uint8_t *src_u=(uint8_t *)mt_data_inf.src2;
	const uint8_t *src_v=(uint8_t *)mt_data_inf.src3;
	RGB32BMP *dst=(RGB32BMP *)mt_data_inf.dst1;
	const int32_t w=mt_data_inf.dst_Y_w;
	const int32_t h_Y_min=mt_data_inf.src_Y_h_min;
	const int32_t h_Y_max=mt_data_inf.src_Y_h_max;
	const ptrdiff_t src_pitch_y=mt_data_inf.src_pitch1;
	const ptrdiff_t src_pitch_u=mt_data_inf.src_pitch2;
	const ptrdiff_t src_pitch_v=mt_data_inf.src_pitch3;
	const ptrdiff_t dst_pitch=mt_data_inf.dst_pitch1;

	for (int32_t i=h_Y_min; i<h_Y_max; i++)
	{
		for (int32_t j=0; j<w; j++)
		{
			int16_t r,g,b;
			const uint16_t y=src_y[j],u=src_u[j],v=src_v[j];

			r=(lookup[y]+lookup[v+256]+(int16_t)dl.Offset_R) >> 5;
			g=(lookup[y]+lookup[u+512]+lookup[v+768]+(int16_t)dl.Offset_G) >> 5;
			b=(lookup[y]+lookup[u+1024]+(int16_t)dl.Offset_B) >> 5;

			if (b<0) dst[j].b=0;
			else
			{
				if (b>255) dst[j].b=255;
				else dst[j].b=(uint8_t)b;
			}
			if (g<0) dst[j].g=0;
			else
			{
				if (g>255) dst[j].g=255;
				else dst[j].g=(uint8_t)g;
			}
			if (r<0) dst[j].r=0;
			else
			{
				if (r>255) dst[j].r=255;
				else dst[j].r=(uint8_t)r;
			}
			dst[j].alpha=255;
		}
		dst=(RGB32BMP *)((uint8_t *)dst+dst_pitch);
		src_y+=src_pitch_y;
		src_u+=src_pitch_u;
		src_v+=src_pitch_v;
	}
}


static void Convert_YV24toRGB32_SSE2(const MT_Data_Info_HDRTools &mt_data_inf,const dataLookUp &dl,const int16_t *lookup)
{
	const int32_t w=mt_data_inf.dst_Y_w;
	const int32_t h_Y_min=mt_data_inf.src_Y_h_min;
	const int32_t h_Y_max=mt_data_inf.src_Y_h_max;

	JPSDR_HDRTools_Convert_YV24toRGB32_SSE2(mt_data_inf.src1,mt_data_inf.src2,mt_data_inf.src3,mt_data_inf.dst1,
		w,h_Y_max-h_Y_min,(int16_t)dl.Offset_R,(int16_t)dl.Offset_G,(int16_t)dl.Offset_B,lookup,mt_data_inf.src_modulo1,
		mt_data_inf.src_modulo2,mt_data_inf.src_modulo3,mt_data_inf.dst_modulo1);
}


static void Convert_YV24toRGB32_AVX(const MT_Data_Info_HDRTools &mt_data_inf,const dataLookUp &dl,const int16_t *lookup)
{
	const int32_t w=mt_data_inf.dst_Y_w;
	const int32_t h_Y_min=mt_data_inf.src_Y_h_min;
	const int32_t h_Y_max=mt_data_inf.src_Y_h_max;

	JPSDR_HDRTools_Convert_YV24toRGB32_AVX(mt_data_inf.src1,mt_data_inf.src2,mt_data_inf.src3,mt_data_inf.dst1,
		w,h_Y_max-h_Y_min,(int16_t)dl.Offset_R,(int16_t)dl.Offset_G,(int16_t)dl.Offset_B,lookup,mt_data_inf.src_modulo1,
		mt_data_inf.src_modulo2,mt_data_inf.src_modulo3,mt_data_inf.dst_modulo1);
}


static void Convert_8_YV24toRGB64(const MT_Data_Info_HDRTools &mt_data_inf,const dataLookUp &dl,const int32_t *lookup)
{
	const uint8_t *src_y=(uint8_t *)mt_data_inf.src1;
	const uint8_t *src_u=(uint8_t *)mt_data_inf.src2;
	const uint8_t *src_v=(uint8_t *)mt_data_inf.src3;
	RGB64BMP *dst=(RGB64BMP *)mt_data_inf.dst1;
	const int32_t w=mt_data_inf.dst_Y_w;
	const int32_t h_Y_min=mt_data_inf.src_Y_h_min;
	const int32_t h_Y_max=mt_data_inf.src_Y_h_max;
	const ptrdiff_t src_pitch_y=mt_data_inf.src_pitch1;
	const ptrdiff_t src_pitch_u=mt_data_inf.src_pitch2;
	const ptrdiff_t src_pitch_v=mt_data_inf.src_pitch3;
	const ptrdiff_t dst_pitch=mt_data_inf.dst_pitch1;

	for (int32_t i=h_Y_min; i<h_Y_max; i++)
	{
		for (int32_t j=0; j<w; j++)
		{
			int32_t r,g,b;
			const uint32_t y=src_y[j],u=src_u[j],v=src_v[j];

			r=(lookup[y]+lookup[v+256]+dl.Offset_R) >> 8;
			g=(lookup[y]+lookup[u+512]+lookup[v+768]+dl.Offset_G) >> 8;
			b=(lookup[y]+lookup[u+1024]+dl.Offset_B) >> 8;

			if (b<0) dst[j].b=0;
			else
			{
				if (b>65535) dst[j].b=65535;
				else dst[j].b=(uint16_t)b;
			}
			if (g<0) dst[j].g=0;
			else
			{
				if (g>65535) dst[j].g=65535;
				else dst[j].g=(uint16_t)g;
			}
			if (r<0) dst[j].r=0;
			else
			{
				if (r>65535) dst[j].r=65535;
				else dst[j].r=(uint16_t)r;
			}
			dst[j].alpha=65535;
		}
		dst=(RGB64BMP *)((uint8_t *)dst+dst_pitch);
		src_y+=src_pitch_y;
		src_u+=src_pitch_u;
		src_v+=src_pitch_v;
	}
}


static void Convert_YV24toRGB64_SSE41(const MT_Data_Info_HDRTools &mt_data_inf,const dataLookUp &dl,const int32_t *lookup,
	const uint8_t bits_per_pixel)
{
	const int32_t w=mt_data_inf.dst_Y_w;
	const int32_t h_Y_min=mt_data_inf.src_Y_h_min;
	const int32_t h_Y_max=mt_data_inf.src_Y_h_max;

	switch(bits_per_pixel)
	{
		case 8 :
			JPSDR_HDRTools_Convert_8_YV24toRGB64_SSE41(mt_data_inf.src1,mt_data_inf.src2,mt_data_inf.src3,mt_data_inf.dst1,
				w,h_Y_max-h_Y_min,dl.Offset_R,dl.Offset_G,dl.Offset_B,lookup,mt_data_inf.src_modulo1,
				mt_data_inf.src_modulo2,mt_data_inf.src_modulo3,mt_data_inf.dst_modulo1);
			break;
		case 10 :
			JPSDR_HDRTools_Convert_10_YV24toRGB64_SSE41(mt_data_inf.src1,mt_data_inf.src2,mt_data_inf.src3,mt_data_inf.dst1,
				w,h_Y_max-h_Y_min,dl.Offset_R,dl.Offset_G,dl.Offset_B,lookup,mt_data_inf.src_modulo1,
				mt_data_inf.src_modulo2,mt_data_inf.src_modulo3,mt_data_inf.dst_modulo1);
			break;
		case 12 :
			JPSDR_HDRTools_Convert_12_YV24toRGB64_SSE41(mt_data_inf.src1,mt_data_inf.src2,mt_data_inf.src3,mt_data_inf.dst1,
				w,h_Y_max-h_Y_min,dl.Offset_R,dl.Offset_G,dl.Offset_B,lookup,mt_data_inf.src_modulo1,
				mt_data_inf.src_modulo2,mt_data_inf.src_modulo3,mt_data_inf.dst_modulo1);
			break;
		case 14 :
			JPSDR_HDRTools_Convert_14_YV24toRGB64_SSE41(mt_data_inf.src1,mt_data_inf.src2,mt_data_inf.src3,mt_data_inf.dst1,
				w,h_Y_max-h_Y_min,dl.Offset_R,dl.Offset_G,dl.Offset_B,lookup,mt_data_inf.src_modulo1,
				mt_data_inf.src_modulo2,mt_data_inf.src_modulo3,mt_data_inf.dst_modulo1);
			break;
		case 16 :
			JPSDR_HDRTools_Convert_16_YV24toRGB64_SSE41(mt_data_inf.src1,mt_data_inf.src2,mt_data_inf.src3,mt_data_inf.dst1,
				w,h_Y_max-h_Y_min,dl.Offset_R,dl.Offset_G,dl.Offset_B,lookup,mt_data_inf.src_modulo1,
				mt_data_inf.src_modulo2,mt_data_inf.src_modulo3,mt_data_inf.dst_modulo1);
			break;
		default : break;
	}
}


static void Convert_YV24toRGB64_AVX(const MT_Data_Info_HDRTools &mt_data_inf,const dataLookUp &dl,const int32_t *lookup,
	const uint8_t bits_per_pixel)
{
	const int32_t w=mt_data_inf.dst_Y_w;
	const int32_t h_Y_min=mt_data_inf.src_Y_h_min;
	const int32_t h_Y_max=mt_data_inf.src_Y_h_max;

	switch(bits_per_pixel)
	{
		case 8 :
			JPSDR_HDRTools_Convert_8_YV24toRGB64_AVX(mt_data_inf.src1,mt_data_inf.src2,mt_data_inf.src3,mt_data_inf.dst1,
				w,h_Y_max-h_Y_min,dl.Offset_R,dl.Offset_G,dl.Offset_B,lookup,mt_data_inf.src_modulo1,
				mt_data_inf.src_modulo2,mt_data_inf.src_modulo3,mt_data_inf.dst_modulo1);
			break;
		case 10 :
			JPSDR_HDRTools_Convert_10_YV24toRGB64_AVX(mt_data_inf.src1,mt_data_inf.src2,mt_data_inf.src3,mt_data_inf.dst1,
				w,h_Y_max-h_Y_min,dl.Offset_R,dl.Offset_G,dl.Offset_B,lookup,mt_data_inf.src_modulo1,
				mt_data_inf.src_modulo2,mt_data_inf.src_modulo3,mt_data_inf.dst_modulo1);
			break;
		case 12 :
			JPSDR_HDRTools_Convert_12_YV24toRGB64_AVX(mt_data_inf.src1,mt_data_inf.src2,mt_data_inf.src3,mt_data_inf.dst1,
				w,h_Y_max-h_Y_min,dl.Offset_R,dl.Offset_G,dl.Offset_B,lookup,mt_data_inf.src_modulo1,
				mt_data_inf.src_modulo2,mt_data_inf.src_modulo3,mt_data_inf.dst_modulo1);
			break;
		case 14 :
			JPSDR_HDRTools_Convert_14_YV24toRGB64_AVX(mt_data_inf.src1,mt_data_inf.src2,mt_data_inf.src3,mt_data_inf.dst1,
				w,h_Y_max-h_Y_min,dl.Offset_R,dl.Offset_G,dl.Offset_B,lookup,mt_data_inf.src_modulo1,
				mt_data_inf.src_modulo2,mt_data_inf.src_modulo3,mt_data_inf.dst_modulo1);
			break;
		case 16 :
			JPSDR_HDRTools_Convert_16_YV24toRGB64_AVX(mt_data_inf.src1,mt_data_inf.src2,mt_data_inf.src3,mt_data_inf.dst1,
				w,h_Y_max-h_Y_min,dl.Offset_R,dl.Offset_G,dl.Offset_B,lookup,mt_data_inf.src_modulo1,
				mt_data_inf.src_modulo2,mt_data_inf.src_modulo3,mt_data_inf.dst_modulo1);
			break;
		default : break;
	}
}


static void Convert_16_YV24toRGB64(const MT_Data_Info_HDRTools &mt_data_inf,const dataLookUp &dl,const int32_t *lookup,
	const uint8_t bits_per_pixel)
{
	const uint16_t *src_y=(uint16_t *)mt_data_inf.src1;
	const uint16_t *src_u=(uint16_t *)mt_data_inf.src2;
	const uint16_t *src_v=(uint16_t *)mt_data_inf.src3;
	RGB64BMP *dst=(RGB64BMP *)mt_data_inf.dst1;
	const int32_t w=mt_data_inf.dst_Y_w;
	const int32_t h_Y_min=mt_data_inf.src_Y_h_min;
	const int32_t h_Y_max=mt_data_inf.src_Y_h_max;
	const ptrdiff_t src_pitch_y=mt_data_inf.src_pitch1;
	const ptrdiff_t src_pitch_u=mt_data_inf.src_pitch2;
	const ptrdiff_t src_pitch_v=mt_data_inf.src_pitch3;
	const ptrdiff_t dst_pitch=mt_data_inf.dst_pitch1;
	const uint32_t vmax=(uint32_t)1 << bits_per_pixel;
	const uint32_t vmax2=vmax*2,vmax3=vmax*3,vmax4=vmax*4;

	for (int32_t i=h_Y_min; i<h_Y_max; i++)
	{
		for (int32_t j=0; j<w; j++)
		{
			int32_t r,g,b;
			const uint32_t y=src_y[j],u=src_u[j],v=src_v[j];

			r=(lookup[y]+lookup[v+vmax]+dl.Offset_R) >> 8;
			g=(lookup[y]+lookup[u+vmax2]+lookup[v+vmax3]+dl.Offset_G) >> 8;
			b=(lookup[y]+lookup[u+vmax4]+dl.Offset_B) >> 8;

			if (b<0) dst[j].b=0;
			else
			{
				if (b>65535) dst[j].b=65535;
				else dst[j].b=(uint16_t)b;
			}
			if (g<0) dst[j].g=0;
			else
			{
				if (g>65535) dst[j].g=65535;
				else dst[j].g=(uint16_t)g;
			}
			if (r<0) dst[j].r=0;
			else
			{
				if (r>65535) dst[j].r=65535;
				else dst[j].r=(uint16_t)r;
			}
			dst[j].alpha=65535;
		}
		dst=(RGB64BMP *)((uint8_t *)dst+dst_pitch);
		src_y=(uint16_t *)((uint8_t *)src_y+src_pitch_y);
		src_u=(uint16_t *)((uint8_t *)src_u+src_pitch_u);
		src_v=(uint16_t *)((uint8_t *)src_v+src_pitch_v);
	}
}


static void Convert_RGB32toLinearRGB32(const MT_Data_Info_HDRTools &mt_data_inf,const uint8_t *lookup)
{
	const uint8_t *src=(uint8_t *)mt_data_inf.src1;
	uint8_t *dst=(uint8_t *)mt_data_inf.dst1;
	const int32_t w=mt_data_inf.dst_Y_w;
	const int32_t h_Y_min=mt_data_inf.src_Y_h_min;
	const int32_t h_Y_max=mt_data_inf.src_Y_h_max;
	const ptrdiff_t src_pitch=mt_data_inf.src_pitch1;
	const ptrdiff_t dst_pitch=mt_data_inf.dst_pitch1;

	for (int32_t i=h_Y_min; i<h_Y_max; i++)
	{
		uint32_t x=0;

		for (int32_t j=0; j<w; j++)
		{
			dst[x++]=lookup[src[x]];
			dst[x++]=lookup[src[x]];
			dst[x++]=lookup[src[x]];
			dst[x++]=255;
		}
		src+=src_pitch;
		dst+=dst_pitch;
	}
}


static void Convert_RGB64toLinearRGB64(const MT_Data_Info_HDRTools &mt_data_inf,const uint16_t *lookup)
{
	const uint8_t *src_=(uint8_t *)mt_data_inf.src1;
	uint8_t *dst_=(uint8_t *)mt_data_inf.dst1;
	const int32_t w=mt_data_inf.dst_Y_w;
	const int32_t h_Y_min=mt_data_inf.src_Y_h_min;
	const int32_t h_Y_max=mt_data_inf.src_Y_h_max;
	const ptrdiff_t src_pitch=mt_data_inf.src_pitch1;
	const ptrdiff_t dst_pitch=mt_data_inf.dst_pitch1;

	for (int32_t i=h_Y_min; i<h_Y_max; i++)
	{
		const uint16_t *src=(uint16_t *)src_;
		uint16_t *dst=(uint16_t *)dst_;
		uint32_t x=0;

		for (int32_t j=0; j<w; j++)
		{
			dst[x++]=lookup[src[x]];
			dst[x++]=lookup[src[x]];
			dst[x++]=lookup[src[x]];
			dst[x++]=65535;
		}
		src_+=src_pitch;
		dst_+=dst_pitch;
	}
}


static void Convert_RGB64toLinearRGBPS(const MT_Data_Info_HDRTools &mt_data_inf,const float *lookup)
{
	const uint8_t *src_=(uint8_t *)mt_data_inf.src1;
	uint8_t *dstR_=(uint8_t *)mt_data_inf.dst1;
	uint8_t *dstG_=(uint8_t *)mt_data_inf.dst2;
	uint8_t *dstB_=(uint8_t *)mt_data_inf.dst3;
	const int32_t w=mt_data_inf.dst_Y_w;
	const int32_t h_Y_min=mt_data_inf.src_Y_h_min;
	const int32_t h_Y_max=mt_data_inf.src_Y_h_max;
	const ptrdiff_t src_pitch=mt_data_inf.src_pitch1;
	const ptrdiff_t dst_pitch_R=mt_data_inf.dst_pitch1;
	const ptrdiff_t dst_pitch_G=mt_data_inf.dst_pitch2;
	const ptrdiff_t dst_pitch_B=mt_data_inf.dst_pitch3;

	for (int32_t i=h_Y_min; i<h_Y_max; i++)
	{
		const uint16_t *src=(uint16_t *)src_;
		float *dstR=(float *)dstR_,*dstG=(float *)dstG_,*dstB=(float *)dstB_;
		uint32_t x=0;

		for (int32_t j=0; j<w; j++)
		{
			dstR[j]=lookup[src[x++]];
			dstG[j]=lookup[src[x++]];
			dstB[j]=lookup[src[x++]];
			x++;
		}
		src_+=src_pitch;
		dstR_+=dst_pitch_R;
		dstG_+=dst_pitch_G;
		dstB_+=dst_pitch_B;
	}
}


static void Convert_RGB32toYV24(const MT_Data_Info_HDRTools &mt_data_inf,const dataLookUp &dl,const int16_t *lookup)
{
	const RGB32BMP *src=(RGB32BMP *)mt_data_inf.src1;
	uint8_t *dst_y=(uint8_t *)mt_data_inf.dst1;
	uint8_t *dst_u=(uint8_t *)mt_data_inf.dst2;
	uint8_t *dst_v=(uint8_t *)mt_data_inf.dst3;
	const int32_t w=mt_data_inf.dst_Y_w;
	const int32_t h_Y_min=mt_data_inf.src_Y_h_min;
	const int32_t h_Y_max=mt_data_inf.src_Y_h_max;
	const ptrdiff_t src_pitch=mt_data_inf.src_pitch1;
	const ptrdiff_t dst_pitch_y=mt_data_inf.dst_pitch1;
	const ptrdiff_t dst_pitch_u=mt_data_inf.dst_pitch2;
	const ptrdiff_t dst_pitch_v=mt_data_inf.dst_pitch3;

	for (int32_t i=h_Y_min; i<h_Y_max; i++)
	{
		for (int32_t j=0; j<w; j++)
		{
			int16_t y,u,v;
			const uint16_t b=src[j].b,g=src[j].g,r=src[j].r;

			y=((int16_t)dl.Offset_Y+lookup[r]+lookup[g+256]+lookup[b+512]) >> 6;
			u=((int16_t)dl.Offset_U+lookup[r+768]+lookup[g+1024]+lookup[b+1280]) >> 6;
			v=((int16_t)dl.Offset_V+lookup[r+1536]+lookup[g+1792]+lookup[b+2048]) >> 6;

			if (y<(int16_t)dl.Min_Y) dst_y[j]=(uint8_t)dl.Min_Y;
			else
			{
				if (y>(int16_t)dl.Max_Y) dst_y[j]=(uint8_t)dl.Max_Y;
				else dst_y[j]=(uint8_t)y;
			}
			if (u<(int16_t)dl.Min_U) dst_u[j]=(uint8_t)dl.Min_U;
			else
			{
				if (u>(int16_t)dl.Max_U) dst_u[j]=(uint8_t)dl.Max_U;
				else dst_u[j]=(uint8_t)u;
			}
			if (v<(int16_t)dl.Min_V) dst_v[j]=(uint8_t)dl.Min_V;
			else
			{
				if (v>(int16_t)dl.Max_V) dst_v[j]=(uint8_t)dl.Max_V;
				else dst_v[j]=(uint8_t)v;
			}
		}
		src=(RGB32BMP *)((uint8_t *)src+src_pitch);
		dst_y+=dst_pitch_y;
		dst_u+=dst_pitch_u;
		dst_v+=dst_pitch_v;
	}
}


static void Convert_RGB32toYV24_SSE2(const MT_Data_Info_HDRTools &mt_data_inf,const dataLookUp &dl,const int16_t *lookup)
{
	const int32_t w=mt_data_inf.dst_Y_w;
	const int32_t h_Y_min=mt_data_inf.src_Y_h_min;
	const int32_t h_Y_max=mt_data_inf.src_Y_h_max;

	JPSDR_HDRTools_Convert_RGB32toYV24_SSE2(mt_data_inf.src1,mt_data_inf.dst1,mt_data_inf.dst2,mt_data_inf.dst3,
		w,h_Y_max-h_Y_min,(int16_t)dl.Offset_Y,(int16_t)dl.Offset_U,(int16_t)dl.Offset_V,lookup,mt_data_inf.src_modulo1,
		mt_data_inf.dst_modulo1,mt_data_inf.dst_modulo2,mt_data_inf.dst_modulo3,
		(int16_t)dl.Min_Y,(int16_t)dl.Max_Y,(int16_t)dl.Min_U,(int16_t)dl.Max_U,(int16_t)dl.Min_V,(int16_t)dl.Max_V);
}


static void Convert_RGB32toYV24_AVX(const MT_Data_Info_HDRTools &mt_data_inf,const dataLookUp &dl,const int16_t *lookup)
{
	const int32_t w=mt_data_inf.dst_Y_w;
	const int32_t h_Y_min=mt_data_inf.src_Y_h_min;
	const int32_t h_Y_max=mt_data_inf.src_Y_h_max;

	JPSDR_HDRTools_Convert_RGB32toYV24_AVX(mt_data_inf.src1,mt_data_inf.dst1,mt_data_inf.dst2,mt_data_inf.dst3,
		w,h_Y_max-h_Y_min,(int16_t)dl.Offset_Y,(int16_t)dl.Offset_U,(int16_t)dl.Offset_V,lookup,
		mt_data_inf.src_modulo1,mt_data_inf.dst_modulo1,mt_data_inf.dst_modulo2,mt_data_inf.dst_modulo3,
		(int16_t)dl.Min_Y,(int16_t)dl.Max_Y,(int16_t)dl.Min_U,(int16_t)dl.Max_U,(int16_t)dl.Min_V,(int16_t)dl.Max_V);
}


static void Compute_Lookup_RGB_8(uint8_t color_mode,bool full_range,bool YUVtoRGB,int16_t *lookup,dataLookUp &data)
{
	double kr,kg,kb;
	double Rv,Gu,Gv,Bu;
	double Ur,Ug,Ub,Vr,Vg,Vb;
	int16_t Off_Y,Off_U,Off_V;

	if (full_range)
	{
		data.Min_Y=0;
		data.Max_Y=255;
		data.Min_U=0;
		data.Max_U=255;
		data.Min_V=0;
		data.Max_V=255;
		data.Coeff_Y=1.0;
		data.Coeff_U=1.0;
		data.Coeff_V=1.0;
	}
	else
	{
		data.Min_Y=16;
		data.Max_Y=235;
		data.Min_U=16;
		data.Max_U=240;
		data.Min_V=16;
		data.Max_V=240;
		data.Coeff_Y=219.0/255.0;
		data.Coeff_U=224.0/255.0;
		data.Coeff_V=224.0/225.0;
	}	
	switch (color_mode)
	{
		case 0 :								// BT-2100
		case 1 : kr=0.2627; kb=0.0593; break;	// BT-2020
		case 2 : kr=0.2126; kb=0.0722; break;	// BT-709
		case 3 :								// BT-601_525
		case 4 : kr=0.299; kb=0.114; break;		// BT-601_625
	}
	kg=1.0-kr-kb;

	Rv=2.0*(1.0-kr);
	Gu=-2.0*kb*(1.0-kb)/kg;
	Gv=-2.0*kr*(1.0-kr)/kg;
	Bu=2.0*(1.0-kb);

	Ur=-0.5*kr/(1.0-kb);
	Ug=-0.5*kg/(1.0-kb);
	Ub=0.5;
	Vr=0.5;
	Vg=-0.5*kg/(1.0-kr);
	Vb=-0.5*kb/(1.0-kr);

	/*
	R',G',B' : RGB value normalised between (0.0,0.0,0.0)[Black] to (1.0,1.0,1.0)[White]
	Y' between (0.0 / +1.0) and Pb/Pr between (-0.5 / +0.5)

	Y'=Kr*R'+Kg*G'+Kb*B'
	Pb=0.5*(B'-Y')/(1-Kb)=-0.5*Kr/(1-Kb))*R'-0.5*Kg/(1-Kb)*G'+0.5*B'
	Pr=0.5*(R'-Y')/(1-Kr)=0.5*R'-0.5*Kg/(1-Kr)*G'-0.5*Kb/(1-Kr)*B'

	R'=Y'+2*(1-Kr)*Pr
	G'=Y'-(2*Kb*(1-Kb)/Kg)*Pb-(2*Kr*(1-Kr)/Kg)*Pr
	B'=Y'+2*(1-Kb)*Pb

	Status with actual values here.
	(Y) Y'=Kr*R'+Kg*G'+Kb*B'
	(U) Pb=(u1*R'+u2*G'+B')*0.5
	(V) Pr=(R'+v1*G'+v2*B')*0.5

	(R) R'=Y'+r1*Pb
	(G) G'=Y'+g1*Pb+g2*Pr
	(B) B'=Y'+b1*Pb

	For 8 bits data limited range :
	(Y',Cb,Cr) = (16,128,128) + (219*Y',224*Pb,224*Pr)

	Y = Off_Y + (Kr*R+Kg*G+Kb*B)*Coeff_Y
	(Cb) U = Off_U + (Ur*R+Ug*G+Ub*B)*Coeff_U
	(Cr) V = Off_V + (Vr*R+Vg*G+Vb*B)*Coeff_V

	R = Y/Coeff_Y + Rv*V/Coeff_V + Off_R [ Off_R = -(Off_Y/Coeff_Y+Rv*Off_V/Coeff_V) ]
	G = Y/Coeff_Y + Gu*U/Coeff_U + Gv*V/Coeff_V + Off_G [ Off_G = -(Off_Y/Coeff_Y+Gu*Off_U/Coeff_U+Gv*Off_V/Coeff_V) ]
	B = Y/Coeff_Y + Bu*U/Coeff_U + Off_B [ Off_B = -(Off_Y/Coeff_Y+Bu*Off_U/Coeff_U) ]
	*/

	Off_Y=data.Min_Y;
	Off_U=128;
	Off_V=128;

	data.Offset_Y=(Off_Y << 6)+32;
	data.Offset_U=(Off_U << 6)+32;
	data.Offset_V=(Off_V << 6)+32;

	data.Offset_R=(int32_t)-round(16.0+32.0*(Off_Y/data.Coeff_Y+Rv*Off_V/data.Coeff_V));
	data.Offset_G=(int32_t)-round(16.0+32.0*(Off_Y/data.Coeff_Y+Gu*Off_U/data.Coeff_U+Gv*Off_V/data.Coeff_V));
	data.Offset_B=(int32_t)-round(16.0+32.0*(Off_Y/data.Coeff_Y+Bu*Off_U/data.Coeff_U));

	if (YUVtoRGB)
	{
		for (int16_t i=0; i<=255; i++)
		{
			lookup[i]=(int16_t)round(i*32.0/data.Coeff_Y);
			lookup[i+256]=(int16_t)round(i*Rv*32.0/data.Coeff_V);
			lookup[i+512]=(int16_t)round(i*Gu*32.0/data.Coeff_U);
			lookup[i+768]=(int16_t)round(i*Gv*32.0/data.Coeff_V);
			lookup[i+1024]=(int16_t)round(i*Bu*32.0/data.Coeff_U);
		}
	}
	else
	{
		for (int16_t i=0; i<=255; i++)
		{
			lookup[i]=(int16_t)round(i*kr*data.Coeff_Y*64.0);
			lookup[i+256]=(int16_t)round(i*kg*data.Coeff_Y*64.0);
			lookup[i+512]=(int16_t)round(i*kb*data.Coeff_Y*64.0);
			lookup[i+768]=(int16_t)round(i*Ur*data.Coeff_U*64.0);
			lookup[i+1024]=(int16_t)round(i*Ug*data.Coeff_U*64.0);
			lookup[i+1280]=(int16_t)round(i*Ub*data.Coeff_U*64.0);
			lookup[i+1536]=(int16_t)round(i*Vr*data.Coeff_V*64.0);
			lookup[i+1792]=(int16_t)round(i*Vg*data.Coeff_V*64.0);
			lookup[i+2048]=(int16_t)round(i*Vb*data.Coeff_V*64.0);
		}
	}
}


static void Compute_Lookup_RGB_16(uint8_t color_mode,bool full_range,bool YUVtoRGB,uint8_t bits_per_pixel,int32_t *lookup,dataLookUp &data)
{
	double kr,kg,kb;
	double Rv,Gu,Gv,Bu;
	double Ur,Ug,Ub,Vr,Vg,Vb;
	int32_t Off_Y,Off_U,Off_V;
	const uint8_t pshift1=bits_per_pixel-8,pshift2=24-bits_per_pixel;
	const int32_t vmax=1 << bits_per_pixel;
	const double coeff_div=((double)vmax)/65536.0,coeff_mul=(double)((int32_t)1 << pshift2);

	if (full_range)
	{
		data.Min_Y=0;
		data.Max_Y=255 << pshift1;
		data.Min_U=0;
		data.Max_U=255 << pshift1;
		data.Min_V=0;
		data.Max_V=255 << pshift1;
		data.Coeff_Y=1.0;
		data.Coeff_U=1.0;
		data.Coeff_V=1.0;
	}
	else
	{
		data.Min_Y=16 << pshift1;
		data.Max_Y=235 << pshift1;
		data.Min_U=16 << pshift1;
		data.Max_U=240 << pshift1;
		data.Min_V=16 << pshift1;
		data.Max_V=240 << pshift1;
		data.Coeff_Y=219.0/255.0;
		data.Coeff_U=224.0/255.0;
		data.Coeff_V=224.0/225.0;
	}	
	switch (color_mode)
	{
		case 0 :								// BT-2100
		case 1 : kr=0.2627; kb=0.0593; break;	// BT-2020
		case 2 : kr=0.2126; kb=0.0722; break;	// BT-709
		case 3 :								// BT-601_525
		case 4 : kr=0.299; kb=0.114; break;		// BT-601_625
	}
	kg=1.0-kr-kb;

	Rv=2.0*(1.0-kr);
	Gu=-2.0*kb*(1.0-kb)/kg;
	Gv=-2.0*kr*(1.0-kr)/kg;
	Bu=2.0*(1.0-kb);

	Ur=-0.5*kr/(1.0-kb);
	Ug=-0.5*kg/(1.0-kb);
	Ub=0.5;
	Vr=0.5;
	Vg=-0.5*kg/(1.0-kr);
	Vb=-0.5*kb/(1.0-kr);

	/*
	R',G',B' : RGB value normalised between (0.0,0.0,0.0)[Black] to (1.0,1.0,1.0)[White]
	Y' between (0.0 / +1.0) and Pb/Pr between (-0.5 / +0.5)

	Y'=Kr*R'+Kg*G'+Kb*B'
	Pb=0.5*(B'-Y')/(1-Kb)=-0.5*Kr/(1-Kb))*R'-0.5*Kg/(1-Kb)*G'+0.5*B'
	Pr=0.5*(R'-Y')/(1-Kr)=0.5*R'-0.5*Kg/(1-Kr)*G'-0.5*Kb/(1-Kr)*B'

	R'=Y'+2*(1-Kr)*Pr
	G'=Y'-(2*Kb*(1-Kb)/Kg)*Pb-(2*Kr*(1-Kr)/Kg)*Pr
	B'=Y'+2*(1-Kb)*Pb

	Status with actual values here.
	(Y) Y'=Kr*R'+Kg*G'+Kb*B'
	(U) Pb=(u1*R'+u2*G'+B')*0.5
	(V) Pr=(R'+v1*G'+v2*B')*0.5

	(R) R'=Y'+r1*Pb
	(G) G'=Y'+g1*Pb+g2*Pr
	(B) B'=Y'+b1*Pb

	For 8 bits data limited range :
	(Y',Cb,Cr) = (16,128,128) + (219*Y',224*Pb,224*Pr)

	Y = Off_Y + (Kr*R+Kg*G+Kb*B)*Coeff_Y
	(Cb) U = Off_U + (Ur*R+Ug*G+Ub*B)*Coeff_U
	(Cr) V = Off_V + (Vr*R+Vg*G+Vb*B)*Coeff_V

	R = Y/Coeff_Y + Rv*V/Coeff_V + Off_R [ Off_R = -(Off_Y/Coeff_Y+Rv*Off_V/Coeff_V) ]
	G = Y/Coeff_Y + Gu*U/Coeff_U + Gv*V/Coeff_V + Off_G [ Off_G = -(Off_Y/Coeff_Y+Gu*Off_U/Coeff_U+Gv*Off_V/Coeff_V) ]
	B = Y/Coeff_Y + Bu*U/Coeff_U + Off_B [ Off_B = -(Off_Y/Coeff_Y+Bu*Off_U/Coeff_U) ]
	*/
	
	Off_Y=data.Min_Y;
	Off_U=128 << pshift1;
	Off_V=128 << pshift1;

	data.Offset_Y=(Off_Y << 8)+128;
	data.Offset_U=(Off_U << 8)+128;
	data.Offset_V=(Off_V << 8)+128;

	data.Offset_R=(int32_t)-round(coeff_mul*(0.5+Off_Y/data.Coeff_Y+Rv*Off_V/data.Coeff_V));
	data.Offset_G=(int32_t)-round(coeff_mul*(0.5+Off_Y/data.Coeff_Y+Gu*Off_U/data.Coeff_U+Gv*Off_V/data.Coeff_V));
	data.Offset_B=(int32_t)-round(coeff_mul*(0.5+Off_Y/data.Coeff_Y+Bu*Off_U/data.Coeff_U));

	if (YUVtoRGB)
	{
		for (int32_t i=0; i<vmax; i++)
		{
			lookup[i]=(int32_t)round(i*coeff_mul/data.Coeff_Y);
			lookup[i+vmax]=(int32_t)round(i*coeff_mul*Rv/data.Coeff_V);
			lookup[i+2*vmax]=(int32_t)round(i*coeff_mul*Gu/data.Coeff_U);
			lookup[i+3*vmax]=(int32_t)round(i*coeff_mul*Gv/data.Coeff_V);
			lookup[i+4*vmax]=(int32_t)round(i*coeff_mul*Bu/data.Coeff_U);
		}
	}
	else
	{
		for (int32_t i=0; i<65536; i++)
		{
			lookup[i]=(int32_t)round(i*coeff_div*kr*data.Coeff_Y*256.0);
			lookup[i+65536]=(int32_t)round(i*coeff_div*kg*data.Coeff_Y*256.0);
			lookup[i+2*65536]=(int32_t)round(i*coeff_div*kb*data.Coeff_Y*256.0);
			lookup[i+3*65536]=(int32_t)round(i*coeff_div*Ur*data.Coeff_U*256.0);
			lookup[i+4*65536]=(int32_t)round(i*coeff_div*Ug*data.Coeff_U*256.0);
			lookup[i+5*65536]=(int32_t)round(i*coeff_div*Ub*data.Coeff_U*256.0);
			lookup[i+6*65536]=(int32_t)round(i*coeff_div*Vr*data.Coeff_V*256.0);
			lookup[i+7*65536]=(int32_t)round(i*coeff_div*Vg*data.Coeff_V*256.0);
			lookup[i+8*65536]=(int32_t)round(i*coeff_div*Vb*data.Coeff_V*256.0);
		}
	}
}


/*
********************************************************************************************
**                               ConvertYUVtoLinearRGB                                    **
********************************************************************************************
*/

ConvertYUVtoLinearRGB::ConvertYUVtoLinearRGB(PClip _child,int _Color,int _OutputMode,bool _HLGMode,bool _fullrange,bool _mpeg2c,
	uint8_t _threads,bool _sleep,IScriptEnvironment* env) :
	GenericVideoFilter(_child),Color(_Color),OutputMode(_OutputMode),HLGMode(_HLGMode),fullrange(_fullrange),mpeg2c(_mpeg2c),
		threads(_threads),sleep(_sleep)
{
	UserId=0;

	StaticThreadpoolF=StaticThreadpool;

	for (int16_t i=0; i<MAX_MT_THREADS; i++)
	{
		MT_Thread[i].pClass=this;
		MT_Thread[i].f_process=0;
		MT_Thread[i].thread_Id=(uint8_t)i;
		MT_Thread[i].pFunc=StaticThreadpoolF;
	}

	grey = vi.IsY();
	isRGBPfamily = vi.IsPlanarRGB() || vi.IsPlanarRGBA();
	isAlphaChannel = vi.IsYUVA() || vi.IsPlanarRGBA();
	pixelsize = (uint8_t)vi.ComponentSize(); // AVS16
	bits_per_pixel = (uint8_t)vi.BitsPerComponent();
	const uint32_t vmax=1 << bits_per_pixel;

	vi_original=NULL; vi_422=NULL; vi_444=NULL; vi_RGB64=NULL;

	lookup_Upscale8=(uint16_t *)malloc(256*sizeof(uint16_t));
	lookup_8to16=(uint32_t *)malloc(256*sizeof(uint32_t));
	lookup_Upscale16=(uint32_t *)malloc(vmax*sizeof(uint32_t));
	lookupRGB_8=(int16_t *)malloc(5*256*sizeof(int16_t));
	if ((OutputMode!=0) && (pixelsize==1) && (vi.pixel_type!=VideoInfo::CS_YV24))
		lookupRGB_16=(int32_t *)malloc(5*65536*sizeof(int32_t));
	else lookupRGB_16=(int32_t *)malloc(5*vmax*sizeof(int32_t));
	lookupL_8=(uint8_t *)malloc(256*sizeof(uint8_t));
	lookupL_16=(uint16_t *)malloc(65536*sizeof(uint16_t));
	lookupL_32=(float *)malloc(65536*sizeof(float));

	if ((lookup_Upscale8==NULL) || (lookup_8to16==NULL) || (lookup_Upscale16==NULL)
		|| (lookupRGB_8==NULL) || (lookupRGB_16==NULL) || (lookupL_8==NULL)
		|| (lookupL_16==NULL) || (lookupL_32==NULL))
	{
		FreeData();
		env->ThrowError("ConvertYUVtoLinearRGB: Error while allocating the lookup tables!");
	}

	vi_original = new VideoInfo(vi);
	vi_422 = new VideoInfo(vi);
	vi_444 = new VideoInfo(vi);
	vi_RGB64 = new VideoInfo(vi);

	if ((vi_original==NULL) || (vi_422==NULL) || (vi_444==NULL) || (vi_RGB64==NULL))
	{
		FreeData();
		env->ThrowError("ConvertYUVtoLinearRGB: Error while creating VideoInfo!");
	}

	vi_RGB64->pixel_type=VideoInfo::CS_BGR64;

	if (pixelsize==1)
	{
		switch(OutputMode)
		{
			case 0 :
				vi_422->pixel_type=VideoInfo::CS_YV16;
				vi_444->pixel_type=VideoInfo::CS_YV24;
				vi.pixel_type=VideoInfo::CS_BGR32;
				break;
			case 1 :
				vi_422->pixel_type=VideoInfo::CS_YUV422P16;
				vi_444->pixel_type=VideoInfo::CS_YUV444P16;
				vi.pixel_type=VideoInfo::CS_BGR64;
				break;
			case 2 :
				vi_422->pixel_type=VideoInfo::CS_YUV422P16;
				vi_444->pixel_type=VideoInfo::CS_YUV444P16;
				vi.pixel_type=VideoInfo::CS_RGBPS;
				break;
			default :
				vi_422->pixel_type=VideoInfo::CS_YV16;
				vi_444->pixel_type=VideoInfo::CS_YV24;
				vi.pixel_type=VideoInfo::CS_BGR32;
				break;
		}
	}
	else
	{
		switch(bits_per_pixel)
		{
			case 10 :
				vi_422->pixel_type=VideoInfo::CS_YUV422P10;
				vi_444->pixel_type=VideoInfo::CS_YUV444P10;
				break;
			case 12 :
				vi_422->pixel_type=VideoInfo::CS_YUV422P12;
				vi_444->pixel_type=VideoInfo::CS_YUV444P12;
				break;
			case 14 :
				vi_422->pixel_type=VideoInfo::CS_YUV422P14;
				vi_444->pixel_type=VideoInfo::CS_YUV444P14;
				break;
			default :
				vi_422->pixel_type=VideoInfo::CS_YUV422P16;
				vi_444->pixel_type=VideoInfo::CS_YUV444P16;
				break;
		}
		if (OutputMode==2) vi.pixel_type=VideoInfo::CS_RGBPS;
		else vi.pixel_type=VideoInfo::CS_BGR64;
	}

	if (vi.height<32)
	{
		for(uint8_t i=0; i<3; i++)
			threads_number[i]=1;
	}
	else
	{
		for(uint8_t i=0; i<3; i++)
			threads_number[i]=threads;
	}
	threads_number[0]=CreateMTData(MT_Data[0],threads_number[0],threads_number[0],vi.width,vi.height,true,true,true,false);
	threads_number[1]=CreateMTData(MT_Data[1],threads_number[1],threads_number[1],vi.width,vi.height,true,false,false,false);
	threads_number[2]=CreateMTData(MT_Data[2],threads_number[2],threads_number[2],vi.width,vi.height,false,false,false,false);

	max_threads=threads_number[0];
	for(uint8_t i=1; i<3; i++)
		if (max_threads<threads_number[i]) max_threads=threads_number[i];

	const double alpha=1.09929682680944,beta=0.018053968510807;
	const double alpha2=267.84,beta2=0.0003024;

	const double m1=0.1593017578125;
	const double m2=78.84375;
	const double c1=0.8359375;
	const double c2=18.8515625;
	const double c3=18.6875;
	
	for (uint16_t i=0; i<256; i++)
	{
		double x=((double)i)/255.0;

		if (Color==0)
		{
			if (!HLGMode)
			{
				// PQ EOTF
				const double x0=pow(x,1.0/m2);

				if (x0<=c1) x=0.0;
				else x=pow((x0-c1)/(c2-c3*x0),1.0/m1);
			
				// Reverse PQ OOTF
				if (x>0.0)
				{
					x=pow(100.0*x,1.0/2.4);
					if (x<=alpha2*beta2) x/=alpha2;
					else x=pow(((x+(alpha-1.0)))/alpha,1.0/0.45)/59.5208;
				}
			}
			else
			{
			}
		}
		else
		{
			if (x<(beta*4.5)) x/=4.5;
			else x=pow(((x+(alpha-1.0)))/alpha,1.0/0.45);
		}
		if (x>1.0) x=1.0;

		lookupL_8[i]=(uint8_t)round(i*x);
		lookup_Upscale8[i]=3*i+2;
		lookup_8to16[i]=((uint32_t)i) << 8;
	}

	for (uint32_t i=0; i<65536; i++)
	{
		double x=((double)i)/65535.0;

		if (Color==0)
		{
			if (!HLGMode)
			{
				// PQ EOTF
				double x0=pow(x,1.0/m2);

				if (x0<=c1) x=0.0;
				else x=pow((x0-c1)/(c2-c3*x0),1.0/m1);
			
				// Reverse PQ OOTF
				if (x>0.0)
				{
					x=pow(100.0*x,1.0/2.4);
					if (x<=alpha2*beta2) x/=alpha2;
					else x=pow(((x+(alpha-1.0)))/alpha,1.0/0.45)/59.5208;
				}
			}
			else
			{
			}
		}
		else
		{
			if (x<(beta*4.5)) x/=4.5;
			else x=pow(((x+(alpha-1.0)))/alpha,1.0/0.45);
		}
		if (x>1.0) x=1.0;
		lookupL_16[i]=(uint16_t)round(i*x);
		lookupL_32[i]=(float)x;
	}

	if ((pixelsize==1) && (OutputMode!=0))
	{
		for (uint32_t i=0; i<256; i++)
			lookup_Upscale16[i]=3*(i << 8)+2;
	}
	else
	{
		for (uint32_t i=0; i<vmax; i++)
			lookup_Upscale16[i]=3*i+2;
	}

	if (vi.pixel_type==VideoInfo::CS_BGR32) Compute_Lookup_RGB_8(Color,fullrange,true,lookupRGB_8,dl);
	else
	{
		if ((OutputMode!=0) && (pixelsize==1) && (vi_original->pixel_type!=VideoInfo::CS_YV24))
			Compute_Lookup_RGB_16(Color,fullrange,true,16,lookupRGB_16,dl);
		else Compute_Lookup_RGB_16(Color,fullrange,true,bits_per_pixel,lookupRGB_16,dl);
	}

	SSE2_Enable=((env->GetCPUFlags()&CPUF_SSE2)!=0);
	AVX_Enable=((env->GetCPUFlags()&CPUF_AVX)!=0);
	SSE41_Enable=((env->GetCPUFlags()&CPUF_SSE4_1)!=0);
	AVX2_Enable=((env->GetCPUFlags()&CPUF_AVX2)!=0);

	if (max_threads>1)
	{
		if (!poolInterface->GetUserId(UserId))
		{
			poolInterface->DeAllocateAllThreads(true);
			FreeData();
			env->ThrowError("ConvertYUVtoLinearRGB: Error with the TheadPool while getting UserId!");
		}
	}
}


void ConvertYUVtoLinearRGB::FreeData(void) 
{
	mydelete(vi_RGB64);
	mydelete(vi_444);
	mydelete(vi_422);
	mydelete(vi_original);
	myfree(lookupL_32);
	myfree(lookupL_16);
	myfree(lookupL_8);
	myfree(lookupRGB_16);
	myfree(lookupRGB_8);
	myfree(lookup_Upscale16);
	myfree(lookup_8to16);
	myfree(lookup_Upscale8);
}


ConvertYUVtoLinearRGB::~ConvertYUVtoLinearRGB() 
{
	if (max_threads>1) poolInterface->RemoveUserId(UserId);
	if (threads>1) poolInterface->DeAllocateAllThreads(true);
	FreeData();
}


int __stdcall ConvertYUVtoLinearRGB::SetCacheHints(int cachehints,int frame_range)
{
  switch (cachehints)
  {
	case CACHE_GET_MTMODE :
		return MT_NICE_FILTER;
	default :
		return 0;
  }
}


void ConvertYUVtoLinearRGB::StaticThreadpool(void *ptr)
{
	const Public_MT_Data_Thread *data=(const Public_MT_Data_Thread *)ptr;
	ConvertYUVtoLinearRGB *ptrClass=(ConvertYUVtoLinearRGB *)data->pClass;

	MT_Data_Info_HDRTools *mt_data_inf=((MT_Data_Info_HDRTools *)data->pData)+data->thread_Id;
	
	switch(data->f_process)
	{
		case 1 : Convert_Progressive_8_YV12toYV16(*mt_data_inf,ptrClass->lookup_Upscale8);
			break;
		case 2 : Convert_Progressive_8_YV12toYV16_SSE2(*mt_data_inf);
			break;
		case 3 : Convert_Progressive_8_YV12toYV16_AVX(*mt_data_inf);
			break;
		case 5 : Convert_Progressive_8to16_YV12toYV16(*mt_data_inf,ptrClass->lookup_Upscale16,ptrClass->lookup_8to16);
			break;
		case 6 : Convert_Progressive_8to16_YV12toYV16_SSE2(*mt_data_inf,ptrClass->lookup_Upscale16,ptrClass->lookup_8to16);
			break;
		case 7 : Convert_Progressive_8to16_YV12toYV16_AVX(*mt_data_inf,ptrClass->lookup_Upscale16,ptrClass->lookup_8to16);
			break;
		case 8 : Convert_Progressive_16_YV12toYV16(*mt_data_inf,ptrClass->lookup_Upscale16);
			break;
		case 9 : Convert_Progressive_16_YV12toYV16_SSE2(*mt_data_inf);
			break;
		case 10 : Convert_Progressive_16_YV12toYV16_AVX(*mt_data_inf);
			break;
		case 12 : Convert_8_YV16toYV24(*mt_data_inf);
			break;
		case 13 : Convert_8_YV16toYV24_SSE2(*mt_data_inf);
			break;
		case 14 : Convert_8_YV16toYV24_AVX(*mt_data_inf);
			break;
		case 15 : Convert_8to16_YV16toYV24(*mt_data_inf,ptrClass->lookup_8to16);
			break;
		case 16 : Convert_8to16_YV16toYV24_SSE2(*mt_data_inf,ptrClass->lookup_8to16);
			break;
		case 17 : Convert_8to16_YV16toYV24_AVX(*mt_data_inf,ptrClass->lookup_8to16);
			break;
		case 18 : Convert_16_YV16toYV24(*mt_data_inf);
			break;
		case 19 : Convert_16_YV16toYV24_SSE2(*mt_data_inf);
			break;
		case 20 : Convert_16_YV16toYV24_AVX(*mt_data_inf);
			break;
		case 21 : Convert_YV24toRGB32(*mt_data_inf,ptrClass->dl,ptrClass->lookupRGB_8);
			break;
		case 22 : Convert_YV24toRGB32_SSE2(*mt_data_inf,ptrClass->dl,ptrClass->lookupRGB_8);
			break;
		case 23 : Convert_YV24toRGB32_AVX(*mt_data_inf,ptrClass->dl,ptrClass->lookupRGB_8);
			break;
		case 24 : Convert_8_YV24toRGB64(*mt_data_inf,ptrClass->dl,ptrClass->lookupRGB_16);
			break;
		case 25 : Convert_16_YV24toRGB64(*mt_data_inf,ptrClass->dl,ptrClass->lookupRGB_16,ptrClass->bits_per_pixel);
			break;
		case 26 : Convert_YV24toRGB64_SSE41(*mt_data_inf,ptrClass->dl,ptrClass->lookupRGB_16,ptrClass->bits_per_pixel);
			break;
		case 27 : Convert_YV24toRGB64_AVX(*mt_data_inf,ptrClass->dl,ptrClass->lookupRGB_16,ptrClass->bits_per_pixel);
			break;
		case 28 : Convert_16_YV24toRGB64(*mt_data_inf,ptrClass->dl,ptrClass->lookupRGB_16,16);
			break;
		case 29 : Convert_YV24toRGB64_SSE41(*mt_data_inf,ptrClass->dl,ptrClass->lookupRGB_16,16);
			break;
		case 30 : Convert_YV24toRGB64_AVX(*mt_data_inf,ptrClass->dl,ptrClass->lookupRGB_16,16);
			break;
		case 31 : Convert_RGB32toLinearRGB32(*mt_data_inf,ptrClass->lookupL_8);
			break;
		case 32 : Convert_RGB64toLinearRGB64(*mt_data_inf,ptrClass->lookupL_16);
			break;
		case 33 : Convert_RGB64toLinearRGBPS(*mt_data_inf,ptrClass->lookupL_32);
			break;
#ifdef AVX2_BUILD_POSSIBLE
		case 4 : Convert_Progressive_8_YV12toYV16_AVX2(*mt_data_inf);
			break;
		case 11 : Convert_Progressive_16_YV12toYV16_AVX2(*mt_data_inf);
			break;
#endif
		default : ;
	}
}


PVideoFrame __stdcall ConvertYUVtoLinearRGB::GetFrame(int n, IScriptEnvironment* env) 
{
	PVideoFrame src = child->GetFrame(n,env);
	PVideoFrame tmp1 = env->NewVideoFrame(*vi_422,64);
	PVideoFrame tmp2 = env->NewVideoFrame(*vi_444,64);
	PVideoFrame tmp3 = env->NewVideoFrame(*vi_RGB64,64);
	PVideoFrame dst = env->NewVideoFrame(vi,64);

	const uint8_t *srcY = src->GetReadPtr(PLANAR_Y);
	const uint8_t *srcU = src->GetReadPtr(PLANAR_U);
	const uint8_t *srcV = src->GetReadPtr(PLANAR_V);
/*	const int src_h = src->GetHeight(PLANAR_Y);
	const int src_w = (pixelsize==1) ? src->GetRowSize(PLANAR_Y):src->GetRowSize(PLANAR_Y) >> 1;*/
	const ptrdiff_t src_pitch_Y = src->GetPitch(PLANAR_Y);
	const ptrdiff_t src_pitch_U = src->GetPitch(PLANAR_U);
	const ptrdiff_t src_pitch_V = src->GetPitch(PLANAR_V);
	const ptrdiff_t src_modulo_Y = src_pitch_Y - src->GetRowSize(PLANAR_Y);
	const ptrdiff_t src_modulo_U = src_pitch_U - src->GetRowSize(PLANAR_U);
	const ptrdiff_t src_modulo_V = src_pitch_V - src->GetRowSize(PLANAR_V);

	const uint8_t *tmp1Yr = tmp1->GetReadPtr(PLANAR_Y);
	const uint8_t *tmp1Ur = tmp1->GetReadPtr(PLANAR_U);
	const uint8_t *tmp1Vr = tmp1->GetReadPtr(PLANAR_V);
	uint8_t *tmp1Yw = tmp1->GetWritePtr(PLANAR_Y);
	uint8_t *tmp1Uw = tmp1->GetWritePtr(PLANAR_U);
	uint8_t *tmp1Vw = tmp1->GetWritePtr(PLANAR_V);
	const ptrdiff_t tmp1_pitch_Y = tmp1->GetPitch(PLANAR_Y);
	const ptrdiff_t tmp1_pitch_U = tmp1->GetPitch(PLANAR_U);
	const ptrdiff_t tmp1_pitch_V = tmp1->GetPitch(PLANAR_V);

	const uint8_t *tmp2Yr = tmp2->GetReadPtr(PLANAR_Y);
	const uint8_t *tmp2Ur = tmp2->GetReadPtr(PLANAR_U);
	const uint8_t *tmp2Vr = tmp2->GetReadPtr(PLANAR_V);
	uint8_t *tmp2Yw = tmp2->GetWritePtr(PLANAR_Y);
	uint8_t *tmp2Uw = tmp2->GetWritePtr(PLANAR_U);
	uint8_t *tmp2Vw = tmp2->GetWritePtr(PLANAR_V);
	const ptrdiff_t tmp2_pitch_Y = tmp2->GetPitch(PLANAR_Y);
	const ptrdiff_t tmp2_pitch_U = tmp2->GetPitch(PLANAR_U);
	const ptrdiff_t tmp2_pitch_V = tmp2->GetPitch(PLANAR_V);
	const ptrdiff_t tmp2_modulo_Y = tmp2_pitch_Y - tmp2->GetRowSize(PLANAR_Y);
	const ptrdiff_t tmp2_modulo_U = tmp2_pitch_U - tmp2->GetRowSize(PLANAR_U);
	const ptrdiff_t tmp2_modulo_V = tmp2_pitch_V - tmp2->GetRowSize(PLANAR_V);

	const uint8_t *tmp3r = tmp3->GetReadPtr();
	uint8_t *tmp3w = tmp3->GetWritePtr();
	const int32_t tmp3_h = tmp3->GetHeight();
	const ptrdiff_t tmp3_pitch = tmp3->GetPitch();

	const uint8_t *tmp3r0=tmp3r+(tmp3_h-1)*tmp3_pitch;
	uint8_t *tmp3w0=tmp3w+(tmp3_h-1)*tmp3_pitch;
	const ptrdiff_t tmp3_pitch0 = -tmp3_pitch;
	const ptrdiff_t tmp3_modulo0 = tmp3_pitch0 - tmp3->GetRowSize();

	const uint8_t *dstr = dst->GetReadPtr();
	uint8_t *dstw = dst->GetWritePtr();
	const int32_t dst_h = dst->GetHeight();
	const ptrdiff_t dst_pitch = dst->GetPitch();

	uint8_t *dstw0=dstw+(dst_h-1)*dst_pitch;
	const ptrdiff_t dst_pitch0 = -dst_pitch;
	const ptrdiff_t dst_modulo0 = dst_pitch0 - dst->GetRowSize();

	const uint8_t *dstRr,*dstGr,*dstBr;
	uint8_t *dstRw,*dstGw,*dstBw;
	ptrdiff_t dst_pitch_R,dst_pitch_G,dst_pitch_B;

	if (vi.pixel_type==VideoInfo::CS_RGBPS)
	{
		dstRr = dst->GetReadPtr(PLANAR_R);
		dstGr = dst->GetReadPtr(PLANAR_G);
		dstBr = dst->GetReadPtr(PLANAR_B);
		dstRw = dst->GetWritePtr(PLANAR_R);
		dstGw = dst->GetWritePtr(PLANAR_G);
		dstBw = dst->GetWritePtr(PLANAR_B);
		dst_pitch_R = dst->GetPitch(PLANAR_R);
		dst_pitch_G = dst->GetPitch(PLANAR_G);
		dst_pitch_B = dst->GetPitch(PLANAR_B);
	}

	Public_MT_Data_Thread MT_ThreadGF[MAX_MT_THREADS];
	MT_Data_Info_HDRTools MT_DataGF[MAX_MT_THREADS];
	int8_t nPool=-1;

	memcpy(MT_ThreadGF,MT_Thread,sizeof(MT_ThreadGF));

	for(uint8_t i=0; i<max_threads; i++)
		MT_ThreadGF[i].pData=(void *)MT_DataGF;

	if (max_threads>1)
	{
		if ((!poolInterface->RequestThreadPool(UserId,max_threads,MT_ThreadGF,nPool,false,true)) || (nPool==-1))
			env->ThrowError("ConvertYUVtoLinearRGB: Error with the TheadPool while requesting threadpool !");
	}

	const bool src_Y_al32=((((size_t)srcY) & 0x1F)==0) && ((abs(src_pitch_Y) & 0x1F)==0);
	const bool src_Y_al16=((((size_t)srcY) & 0x0F)==0) && ((abs(src_pitch_Y) & 0x0F)==0);
	const bool src_UV_al32=((((size_t)srcU) & 0x1F)==0) && ((((size_t)srcV) & 0x1F)==0)
		&& ((abs(src_pitch_U) & 0x1F)==0) && ((abs(src_pitch_V) & 0x1F)==0);
	const bool src_UV_al16=((((size_t)srcU) & 0x0F)==0) && ((((size_t)srcV) & 0x0F)==0)
		&& ((abs(src_pitch_U) & 0x0F)==0) && ((abs(src_pitch_V) & 0x0F)==0);

	const bool tmp1_Y_al32=((((size_t)tmp1Yw) & 0x1F)==0) && ((((size_t)tmp1Yr) & 0x1F)==0)
		&& ((abs(tmp1_pitch_Y) & 0x1F)==0);
	const bool tmp1_Y_al16=((((size_t)tmp1Yw) & 0x0F)==0) && ((((size_t)tmp1Yr) & 0x0F)==0)
		&& ((abs(tmp1_pitch_Y) & 0x0F)==0);
	const bool tmp1_UV_al32=((((size_t)tmp1Uw) & 0x1F)==0) && ((((size_t)tmp1Vw) & 0x1F)==0)
		&& ((((size_t)tmp1Ur) & 0x1F)==0) && ((((size_t)tmp1Vr) & 0x1F)==0)
		&& ((abs(tmp1_pitch_U) & 0x1F)==0) && ((abs(tmp1_pitch_V) & 0x1F)==0);
	const bool tmp1_UV_al16=((((size_t)tmp1Uw) & 0x0F)==0) && ((((size_t)tmp1Vw) & 0x0F)==0)
		&& ((((size_t)tmp1Ur) & 0x0F)==0) && ((((size_t)tmp1Vr) & 0x0F)==0)
		&& ((abs(tmp1_pitch_U) & 0x0F)==0) && ((abs(tmp1_pitch_V) & 0x0F)==0);

	const bool tmp2_Y_al32=((((size_t)tmp2Yw) & 0x1F)==0) && ((((size_t)tmp2Yr) & 0x1F)==0)
		&& ((abs(tmp2_pitch_Y) & 0x1F)==0);
	const bool tmp2_Y_al16=((((size_t)tmp2Yw) & 0x0F)==0) && ((((size_t)tmp2Yr) & 0x0F)==0)
		&& ((abs(tmp2_pitch_Y) & 0x0F)==0);
	const bool tmp2_UV_al32=((((size_t)tmp2Uw) & 0x1F)==0) && ((((size_t)tmp2Vw) & 0x1F)==0)
		&& ((((size_t)tmp2Ur) & 0x1F)==0) && ((((size_t)tmp2Vr) & 0x1F)==0)
		&& ((abs(tmp2_pitch_U) & 0x1F)==0) && ((abs(tmp2_pitch_V) & 0x1F)==0);
	const bool tmp2_UV_al16=((((size_t)tmp2Uw) & 0x0F)==0) && ((((size_t)tmp2Vw) & 0x0F)==0)
		&& ((((size_t)tmp2Ur) & 0x0F)==0) && ((((size_t)tmp2Vr) & 0x0F)==0)
		&& ((abs(tmp2_pitch_U) & 0x0F)==0) && ((abs(tmp2_pitch_V) & 0x0F)==0);

	const bool tmp3_al32=((((size_t)tmp3w) & 0x1F)==0) && ((((size_t)tmp3r) & 0x1F)==0)
		&& ((abs(tmp3_pitch) & 0x1F)==0);
	const bool tmp3_al16=((((size_t)tmp3w) & 0x0F)==0) && ((((size_t)tmp3r) & 0x0F)==0)
		&& ((abs(tmp3_pitch) & 0x0F)==0);

	const bool dst_al32=((((size_t)dstw) & 0x1F)==0) && ((((size_t)dstr) & 0x1F)==0)
		&& ((abs(dst_pitch) & 0x1F)==0);
	const bool dst_al16=((((size_t)dstw) & 0x0F)==0) && ((((size_t)dstr) & 0x0F)==0)
		&& ((abs(dst_pitch) & 0x0F)==0);
	
	const bool dst_RGBP_al32=((((size_t)dstRw) & 0x1F)==0) && ((((size_t)dstRr) & 0x1F)==0)
		&& ((((size_t)dstGw) & 0x1F)==0) && ((((size_t)dstGr) & 0x1F)==0)
		&& ((((size_t)dstBw) & 0x1F)==0) && ((((size_t)dstBr) & 0x1F)==0)
		&& ((abs(dst_pitch_R) & 0x1F)==0) && ((abs(dst_pitch_G) & 0x1F)==0)
		&& ((abs(dst_pitch_B) & 0x1F)==0);
	const bool dst_RGBP_al16=((((size_t)dstRw) & 0x0F)==0) && ((((size_t)dstRr) & 0x0F)==0)
		&& ((((size_t)dstGw) & 0x0F)==0) && ((((size_t)dstGr) & 0x0F)==0)
		&& ((((size_t)dstBw) & 0x0F)==0) && ((((size_t)dstBr) & 0x0F)==0)
		&& ((abs(dst_pitch_R) & 0x0F)==0) && ((abs(dst_pitch_G) & 0x0F)==0)
		&& ((abs(dst_pitch_B) & 0x0F)==0);

	uint8_t f_proc=0;

	// Process YUV420 to YUV422 upscale
	memcpy(MT_DataGF,MT_Data[0],sizeof(MT_DataGF));

	if (vi_original->Is420())
	{
		for(uint8_t i=0; i<threads_number[0]; i++)
		{
			MT_DataGF[i].src1=(void *)(srcY+(MT_DataGF[i].src_Y_h_min*src_pitch_Y));
			MT_DataGF[i].src2=(void *)(srcU+(MT_DataGF[i].src_UV_h_min*src_pitch_U));
			MT_DataGF[i].src3=(void *)(srcV+(MT_DataGF[i].src_UV_h_min*src_pitch_V));
			MT_DataGF[i].src_pitch1=src_pitch_Y;
			MT_DataGF[i].src_pitch2=src_pitch_U;
			MT_DataGF[i].src_pitch3=src_pitch_V;
			MT_DataGF[i].dst1=(void *)(tmp1Yw+(MT_DataGF[i].dst_Y_h_min*tmp1_pitch_Y));
			MT_DataGF[i].dst2=(void *)(tmp1Uw+(MT_DataGF[i].dst_UV_h_min*tmp1_pitch_U));
			MT_DataGF[i].dst3=(void *)(tmp1Vw+(MT_DataGF[i].dst_UV_h_min*tmp1_pitch_V));
			MT_DataGF[i].dst_pitch1=tmp1_pitch_Y;
			MT_DataGF[i].dst_pitch2=tmp1_pitch_U;
			MT_DataGF[i].dst_pitch3=tmp1_pitch_V;
		}

		if (pixelsize==1)
		{
			if (OutputMode!=0)
			{
				if (AVX_Enable && src_Y_al16 && tmp1_Y_al16 && src_UV_al16 && tmp1_UV_al16) f_proc=7;
				else
				{
					if (SSE2_Enable && src_Y_al16 && tmp1_Y_al16 && src_UV_al16 && tmp1_UV_al16) f_proc=6;
					else f_proc=5;
				}
			}
			else
			{
				if (AVX2_Enable && src_UV_al32 && tmp1_UV_al32) f_proc=4;
				else
				{
					if (AVX_Enable && src_UV_al16 && tmp1_UV_al16) f_proc=3;
					else
					{
						if (SSE2_Enable && src_UV_al16 && tmp1_UV_al16) f_proc=2;
						else f_proc=1;
					}
				}
			}
		}
		else
		{
			if (AVX2_Enable && src_UV_al32 && tmp1_UV_al32) f_proc=11;
			else
			{
				if (AVX_Enable && src_UV_al16 && tmp1_UV_al16) f_proc=10;
				else
				{
					if (SSE2_Enable && src_UV_al16 && tmp1_UV_al16) f_proc=9;
					else f_proc=8;
				}
			}
		}
	}
	else f_proc=0;
	
	if (f_proc!=0)
	{
		if (threads_number[0]>1)
		{
			for(uint8_t i=0; i<threads_number[0]; i++)
				MT_ThreadGF[i].f_process=f_proc;
			if (poolInterface->StartThreads(UserId,nPool)) poolInterface->WaitThreadsEnd(UserId,nPool);

			for(uint8_t i=0; i<threads_number[0]; i++)
				MT_ThreadGF[i].f_process=0;
		}
		else
		{
			switch(f_proc)
			{
				case 1 : Convert_Progressive_8_YV12toYV16(MT_DataGF[0],lookup_Upscale8); break;
				case 2 : Convert_Progressive_8_YV12toYV16_SSE2(MT_DataGF[0]); break;
				case 3 : Convert_Progressive_8_YV12toYV16_AVX(MT_DataGF[0]); break;
				case 5 : Convert_Progressive_8to16_YV12toYV16(MT_DataGF[0],lookup_Upscale16,lookup_8to16); break;
				case 6 : Convert_Progressive_8to16_YV12toYV16_SSE2(MT_DataGF[0],lookup_Upscale16,lookup_8to16); break;
				case 7 : Convert_Progressive_8to16_YV12toYV16_AVX(MT_DataGF[0],lookup_Upscale16,lookup_8to16); break;
				case 8 : Convert_Progressive_16_YV12toYV16(MT_DataGF[0],lookup_Upscale16); break;
				case 9 : Convert_Progressive_16_YV12toYV16_SSE2(MT_DataGF[0]); break;
				case 10 : Convert_Progressive_16_YV12toYV16_AVX(MT_DataGF[0]); break;
#ifdef AVX2_BUILD_POSSIBLE
				case 4 : Convert_Progressive_8_YV12toYV16_AVX2(MT_DataGF[0]); break;
				case 11 : Convert_Progressive_16_YV12toYV16_AVX2(MT_DataGF[0]); break;
#endif
				default : break;
			}
		}
	}

	// Process YUV422 to YUV444 upscale
	memcpy(MT_DataGF,MT_Data[1],sizeof(MT_DataGF));

	if (vi_original->Is422())
	{
		for(uint8_t i=0; i<threads_number[1]; i++)
		{
			MT_DataGF[i].src1=(void *)(srcY+(MT_DataGF[i].src_Y_h_min*src_pitch_Y));
			MT_DataGF[i].src2=(void *)(srcU+(MT_DataGF[i].src_UV_h_min*src_pitch_U));
			MT_DataGF[i].src3=(void *)(srcV+(MT_DataGF[i].src_UV_h_min*src_pitch_V));
			MT_DataGF[i].src_pitch1=src_pitch_Y;
			MT_DataGF[i].src_pitch2=src_pitch_U;
			MT_DataGF[i].src_pitch3=src_pitch_V;
			MT_DataGF[i].dst1=(void *)(tmp2Yw+(MT_DataGF[i].dst_Y_h_min*tmp2_pitch_Y));
			MT_DataGF[i].dst2=(void *)(tmp2Uw+(MT_DataGF[i].dst_UV_h_min*tmp2_pitch_U));
			MT_DataGF[i].dst3=(void *)(tmp2Vw+(MT_DataGF[i].dst_UV_h_min*tmp2_pitch_V));
			MT_DataGF[i].dst_pitch1=tmp2_pitch_Y;
			MT_DataGF[i].dst_pitch2=tmp2_pitch_U;
			MT_DataGF[i].dst_pitch3=tmp2_pitch_V;
		}

		if (pixelsize==1)
		{
			if (OutputMode!=0)
			{
				if (AVX_Enable && src_Y_al16 && tmp2_Y_al16 && src_UV_al16 && tmp2_UV_al16) f_proc=17;
				else
				{
					if (SSE2_Enable && src_Y_al16 && tmp2_Y_al16 && src_UV_al16 && tmp2_UV_al16) f_proc=16;
					else f_proc=15;
				}
			}
			else
			{
				if (AVX_Enable && src_UV_al16 && tmp2_UV_al16) f_proc=14;
				else
				{
					if (SSE2_Enable && src_UV_al16 && tmp2_UV_al16) f_proc=13;
					else f_proc=12;
				}
			}
		}
		else
		{
			if (AVX_Enable && src_UV_al16 && tmp2_UV_al16) f_proc=20;
			else
			{
				if (SSE2_Enable && src_UV_al16 && tmp2_UV_al16) f_proc=19;
				else f_proc=18;
			}
		}
	}
	else f_proc=0;

	if (vi_original->Is420())
	{
		for(uint8_t i=0; i<threads_number[1]; i++)
		{
			MT_DataGF[i].src1=(void *)(tmp1Yr+(MT_DataGF[i].src_Y_h_min*tmp1_pitch_Y));
			MT_DataGF[i].src2=(void *)(tmp1Ur+(MT_DataGF[i].src_UV_h_min*tmp1_pitch_U));
			MT_DataGF[i].src3=(void *)(tmp1Vr+(MT_DataGF[i].src_UV_h_min*tmp1_pitch_V));
			MT_DataGF[i].src_pitch1=tmp1_pitch_Y;
			MT_DataGF[i].src_pitch2=tmp1_pitch_U;
			MT_DataGF[i].src_pitch3=tmp1_pitch_V;
			MT_DataGF[i].dst1=(void *)(tmp2Yw+(MT_DataGF[i].dst_Y_h_min*tmp2_pitch_Y));
			MT_DataGF[i].dst2=(void *)(tmp2Uw+(MT_DataGF[i].dst_UV_h_min*tmp2_pitch_U));
			MT_DataGF[i].dst3=(void *)(tmp2Vw+(MT_DataGF[i].dst_UV_h_min*tmp2_pitch_V));
			MT_DataGF[i].dst_pitch1=tmp2_pitch_Y;
			MT_DataGF[i].dst_pitch2=tmp2_pitch_U;
			MT_DataGF[i].dst_pitch3=tmp2_pitch_V;
		}

		if (pixelsize==1)
		{
			if (OutputMode!=0)
			{
				if (AVX_Enable && tmp1_UV_al16 && tmp2_UV_al16) f_proc=20;
				else
				{
					if (SSE2_Enable && tmp1_UV_al16 && tmp2_UV_al16) f_proc=19;
					else f_proc=18;
				}
			}
			else
			{
				if (AVX_Enable && tmp1_UV_al16 && tmp2_UV_al16) f_proc=14;
				else
				{
					if (SSE2_Enable && tmp1_UV_al16 && tmp2_UV_al16) f_proc=13;
					else f_proc=12;
				}
			}
		}
		else
		{
			if (AVX_Enable && tmp1_UV_al16 && tmp2_UV_al16) f_proc=20;
			else
			{
				if (SSE2_Enable && tmp1_UV_al16 && tmp2_UV_al16) f_proc=19;
				else f_proc=18;
			}
		}
	}

	if (f_proc!=0)
	{
		if (threads_number[1]>1)
		{
			for(uint8_t i=0; i<threads_number[1]; i++)
				MT_ThreadGF[i].f_process=f_proc;
			if (poolInterface->StartThreads(UserId,nPool)) poolInterface->WaitThreadsEnd(UserId,nPool);

			for(uint8_t i=0; i<threads_number[1]; i++)
				MT_ThreadGF[i].f_process=0;
		}
		else
		{
			switch(f_proc)
			{
				case 12 : Convert_8_YV16toYV24(MT_DataGF[0]); break;
				case 13 : Convert_8_YV16toYV24_SSE2(MT_DataGF[0]); break;
				case 14 : Convert_8_YV16toYV24_AVX(MT_DataGF[0]); break;
				case 15 : Convert_8to16_YV16toYV24(MT_DataGF[0],lookup_8to16); break;
				case 16 : Convert_8to16_YV16toYV24_SSE2(MT_DataGF[0],lookup_8to16); break;
				case 17 : Convert_8to16_YV16toYV24_AVX(MT_DataGF[0],lookup_8to16); break;
				case 18 : Convert_16_YV16toYV24(MT_DataGF[0]); break;
				case 19 : Convert_16_YV16toYV24_SSE2(MT_DataGF[0]); break;
				case 20 : Convert_16_YV16toYV24_AVX(MT_DataGF[0]); break;
				default : break;
			}
		}
	}

	//Process YUV444 to RGB
	memcpy(MT_DataGF,MT_Data[2],sizeof(MT_DataGF));

	if (vi_original->Is444())
	{
		if (OutputMode!=2)
		{
			for(uint8_t i=0; i<threads_number[2]; i++)
			{
				MT_DataGF[i].src1=(void *)(srcY+(MT_DataGF[i].src_Y_h_min*src_pitch_Y));
				MT_DataGF[i].src2=(void *)(srcU+(MT_DataGF[i].src_UV_h_min*src_pitch_U));
				MT_DataGF[i].src3=(void *)(srcV+(MT_DataGF[i].src_UV_h_min*src_pitch_V));
				MT_DataGF[i].src_pitch1=src_pitch_Y;
				MT_DataGF[i].src_pitch2=src_pitch_U;
				MT_DataGF[i].src_pitch3=src_pitch_V;
				MT_DataGF[i].src_modulo1=src_modulo_Y;
				MT_DataGF[i].src_modulo2=src_modulo_U;
				MT_DataGF[i].src_modulo3=src_modulo_V;
				MT_DataGF[i].dst1=(void *)(dstw0+(MT_DataGF[i].dst_Y_h_min*dst_pitch0));
				MT_DataGF[i].dst_pitch1=dst_pitch0;
				MT_DataGF[i].dst_modulo1=dst_modulo0;
			}
		}
		else
		{
			for(uint8_t i=0; i<threads_number[2]; i++)
			{
				MT_DataGF[i].src1=(void *)(srcY+(MT_DataGF[i].src_Y_h_min*src_pitch_Y));
				MT_DataGF[i].src2=(void *)(srcU+(MT_DataGF[i].src_UV_h_min*src_pitch_U));
				MT_DataGF[i].src3=(void *)(srcV+(MT_DataGF[i].src_UV_h_min*src_pitch_V));
				MT_DataGF[i].src_pitch1=src_pitch_Y;
				MT_DataGF[i].src_pitch2=src_pitch_U;
				MT_DataGF[i].src_pitch3=src_pitch_V;
				MT_DataGF[i].src_modulo1=src_modulo_Y;
				MT_DataGF[i].src_modulo2=src_modulo_U;
				MT_DataGF[i].src_modulo3=src_modulo_V;
				MT_DataGF[i].dst1=(void *)(tmp3w0+(MT_DataGF[i].dst_Y_h_min*tmp3_pitch0));
				MT_DataGF[i].dst_pitch1=tmp3_pitch0;
				MT_DataGF[i].dst_modulo1=tmp3_modulo0;
			}
		}

		if (pixelsize==1)
		{
			if (OutputMode!=0)
			{
				if (AVX_Enable) f_proc=27;
				else
				{
					if (SSE41_Enable) f_proc=26;
					else f_proc=24;
				}
			}
			else
			{
				if (AVX_Enable) f_proc=23;
				else
				{
					if (SSE41_Enable) f_proc=22;
					else f_proc=21;
				}
			}
		}
		else
		{
			if (AVX_Enable) f_proc=27;
			else
			{
				if (SSE41_Enable) f_proc=26;
				else f_proc=25;
			}
		}
	}
	else
	{
		if (OutputMode!=2)
		{
			for(uint8_t i=0; i<threads_number[2]; i++)
			{
				MT_DataGF[i].src1=(void *)(tmp2Yr+(MT_DataGF[i].src_Y_h_min*tmp2_pitch_Y));
				MT_DataGF[i].src2=(void *)(tmp2Ur+(MT_DataGF[i].src_UV_h_min*tmp2_pitch_U));
				MT_DataGF[i].src3=(void *)(tmp2Vr+(MT_DataGF[i].src_UV_h_min*tmp2_pitch_V));
				MT_DataGF[i].src_pitch1=tmp2_pitch_Y;
				MT_DataGF[i].src_pitch2=tmp2_pitch_U;
				MT_DataGF[i].src_pitch3=tmp2_pitch_V;
				MT_DataGF[i].src_modulo1=tmp2_modulo_Y;
				MT_DataGF[i].src_modulo2=tmp2_modulo_U;
				MT_DataGF[i].src_modulo3=tmp2_modulo_V;
				MT_DataGF[i].dst1=(void *)(dstw0+(MT_DataGF[i].dst_Y_h_min*dst_pitch0));
				MT_DataGF[i].dst_pitch1=dst_pitch0;
				MT_DataGF[i].dst_modulo1=dst_modulo0;
			}
		}
		else
		{
			for(uint8_t i=0; i<threads_number[2]; i++)
			{
				MT_DataGF[i].src1=(void *)(tmp2Yr+(MT_DataGF[i].src_Y_h_min*tmp2_pitch_Y));
				MT_DataGF[i].src2=(void *)(tmp2Ur+(MT_DataGF[i].src_UV_h_min*tmp2_pitch_U));
				MT_DataGF[i].src3=(void *)(tmp2Vr+(MT_DataGF[i].src_UV_h_min*tmp2_pitch_V));
				MT_DataGF[i].src_pitch1=tmp2_pitch_Y;
				MT_DataGF[i].src_pitch2=tmp2_pitch_U;
				MT_DataGF[i].src_pitch3=tmp2_pitch_V;
				MT_DataGF[i].src_modulo1=tmp2_modulo_Y;
				MT_DataGF[i].src_modulo2=tmp2_modulo_U;
				MT_DataGF[i].src_modulo3=tmp2_modulo_V;
				MT_DataGF[i].dst1=(void *)(tmp3w0+(MT_DataGF[i].dst_Y_h_min*tmp3_pitch0));
				MT_DataGF[i].dst_pitch1=tmp3_pitch0;
				MT_DataGF[i].dst_modulo1=tmp3_modulo0;
			}
		}

		if (pixelsize==1)
		{
			if (OutputMode!=0)
			{
				if (AVX_Enable) f_proc=30;
				else
				{
					if (SSE41_Enable) f_proc=29;
					else f_proc=28;
				}
			}
			else
			{
				if (AVX_Enable) f_proc=23;
				else
				{
					if (SSE41_Enable) f_proc=22;
					else f_proc=21;
				}
			}
		}
		else
		{
			if (AVX_Enable) f_proc=27;
			else
			{
				if (SSE41_Enable) f_proc=26;
				else f_proc=25;
			}
		}
	}

	if (threads_number[2]>1)
	{
		for(uint8_t i=0; i<threads_number[2]; i++)
			MT_ThreadGF[i].f_process=f_proc;
		if (poolInterface->StartThreads(UserId,nPool)) poolInterface->WaitThreadsEnd(UserId,nPool);

		for(uint8_t i=0; i<threads_number[2]; i++)
			MT_ThreadGF[i].f_process=0;
	}
	else
	{
		switch(f_proc)
		{
			case 21 : Convert_YV24toRGB32(MT_DataGF[0],dl,lookupRGB_8); break;
			case 22 : Convert_YV24toRGB32_SSE2(MT_DataGF[0],dl,lookupRGB_8); break;
			case 23 : Convert_YV24toRGB32_AVX(MT_DataGF[0],dl,lookupRGB_8); break;
			case 24 : Convert_8_YV24toRGB64(MT_DataGF[0],dl,lookupRGB_16); break;
			case 25 : Convert_16_YV24toRGB64(MT_DataGF[0],dl,lookupRGB_16,bits_per_pixel); break;
			case 26 : Convert_YV24toRGB64_SSE41(MT_DataGF[0],dl,lookupRGB_16,bits_per_pixel); break;
			case 27 : Convert_YV24toRGB64_AVX(MT_DataGF[0],dl,lookupRGB_16,bits_per_pixel); break;
			case 28 : Convert_16_YV24toRGB64(MT_DataGF[0],dl,lookupRGB_16,16); break;
			case 29 : Convert_YV24toRGB64_SSE41(MT_DataGF[0],dl,lookupRGB_16,16); break;
			case 30 : Convert_YV24toRGB64_AVX(MT_DataGF[0],dl,lookupRGB_16,16); break;
			default : break;
		}
	}

	//Process Non linear RGB to Linear RGB
	if (OutputMode!=2)
	{
		for(uint8_t i=0; i<threads_number[2]; i++)
		{
			MT_DataGF[i].src1=(void *)(dstr+(MT_DataGF[i].src_Y_h_min*dst_pitch));
			MT_DataGF[i].src_pitch1=dst_pitch;
			MT_DataGF[i].dst1=(void *)(dstw+(MT_DataGF[i].dst_Y_h_min*dst_pitch));
			MT_DataGF[i].dst_pitch1=dst_pitch;
		}
	}
	else
	{
		for(uint8_t i=0; i<threads_number[2]; i++)
		{
			MT_DataGF[i].src1=(void *)(tmp3r0+(MT_DataGF[i].src_Y_h_min*tmp3_pitch0));
			MT_DataGF[i].src_pitch1=tmp3_pitch0;
			MT_DataGF[i].src_modulo1=tmp3_modulo0;
			MT_DataGF[i].dst1=(void *)(dstRw+(MT_DataGF[i].dst_Y_h_min*dst_pitch_R));
			MT_DataGF[i].dst2=(void *)(dstGw+(MT_DataGF[i].dst_Y_h_min*dst_pitch_G));
			MT_DataGF[i].dst3=(void *)(dstBw+(MT_DataGF[i].dst_Y_h_min*dst_pitch_B));
			MT_DataGF[i].dst_pitch1=dst_pitch_R;
			MT_DataGF[i].dst_pitch2=dst_pitch_G;
			MT_DataGF[i].dst_pitch3=dst_pitch_B;
		}
	}

	if (OutputMode!=2)
	{
		if (vi.pixel_type==VideoInfo::CS_BGR32) f_proc=31;
		else f_proc=32;
	}
	else f_proc=33;

	if (threads_number[2]>1)
	{
		for(uint8_t i=0; i<threads_number[2]; i++)
			MT_ThreadGF[i].f_process=f_proc;
		if (poolInterface->StartThreads(UserId,nPool)) poolInterface->WaitThreadsEnd(UserId,nPool);

		for(uint8_t i=0; i<threads_number[2]; i++)
			MT_ThreadGF[i].f_process=0;
	}
	else
	{
		switch(f_proc)
		{
			case 31 : Convert_RGB32toLinearRGB32(MT_DataGF[0],lookupL_8); break;
			case 32 : Convert_RGB64toLinearRGB64(MT_DataGF[0],lookupL_16); break;
			case 33 : Convert_RGB64toLinearRGBPS(MT_DataGF[0],lookupL_32); break;
			default : break;
		}
	}

	if (max_threads>1) poolInterface->ReleaseThreadPool(UserId,sleep,nPool);

	return dst;
}


/*
********************************************************************************************
**                               ConvertLinearRGBtoYUV                                    **
********************************************************************************************
*/


ConvertLinearRGBtoYUV::ConvertLinearRGBtoYUV(PClip _child,int _Color,int _OutputMode,bool _HLGMode,bool _fullrange,bool _mpeg2c,
	uint8_t _threads,bool _sleep,IScriptEnvironment* env) :
	GenericVideoFilter(_child),Color(_Color),OutputMode(_OutputMode),HLGMode(_HLGMode),fullrange(_fullrange),mpeg2c(_mpeg2c),
		threads(_threads),sleep(_sleep)
{
	UserId=0;

	StaticThreadpoolF=StaticThreadpool;

	for (int16_t i=0; i<MAX_MT_THREADS; i++)
	{
		MT_Thread[i].pClass=this;
		MT_Thread[i].f_process=0;
		MT_Thread[i].thread_Id=(uint8_t)i;
		MT_Thread[i].pFunc=StaticThreadpoolF;
	}

	grey = vi.IsY();
	isRGBPfamily = vi.IsPlanarRGB() || vi.IsPlanarRGBA();
	isAlphaChannel = vi.IsYUVA() || vi.IsPlanarRGBA();
	pixelsize = (uint8_t)vi.ComponentSize(); // AVS16
	bits_per_pixel = (uint8_t)vi.BitsPerComponent();
	const uint32_t vmax=1 << bits_per_pixel;

	vi_original=NULL; vi_422=NULL; vi_444=NULL; vi_RGB64=NULL;

	lookup_Upscale8=(uint16_t *)malloc(256*sizeof(uint16_t));
	lookup_8to16=(uint32_t *)malloc(256*sizeof(uint32_t));
	lookup_Upscale16=(uint32_t *)malloc(vmax*sizeof(uint32_t));
	lookupRGB_8=(int16_t *)malloc(5*256*sizeof(int16_t));
	if ((OutputMode!=0) && (pixelsize==1) && (vi.pixel_type!=VideoInfo::CS_YV24))
		lookupRGB_16=(int32_t *)malloc(5*65536*sizeof(int32_t));
	else lookupRGB_16=(int32_t *)malloc(5*vmax*sizeof(int32_t));
	lookupL_8=(uint8_t *)malloc(256*sizeof(uint8_t));
	lookupL_16=(uint16_t *)malloc(65536*sizeof(uint16_t));

	if ((lookup_Upscale8==NULL) || (lookup_8to16==NULL) || (lookup_Upscale16==NULL)
		|| (lookupRGB_8==NULL) || (lookupRGB_16==NULL) || (lookupL_8==NULL)
		|| (lookupL_16==NULL))
	{
		FreeData();
		env->ThrowError("ConvertLinearRGBtoYUV: Error while allocating the lookup tables!");
	}

	vi_original = new VideoInfo(vi);
	vi_422 = new VideoInfo(vi);
	vi_444 = new VideoInfo(vi);
	vi_RGB64 = new VideoInfo(vi);

	if ((vi_original==NULL) || (vi_422==NULL) || (vi_444==NULL) || (vi_RGB64==NULL))
	{
		FreeData();
		env->ThrowError("ConvertLinearRGBtoYUV: Error while creating VideoInfo!");
	}

	vi_RGB64->pixel_type=VideoInfo::CS_BGR64;

	if (pixelsize==1)
	{
		switch(OutputMode)
		{
			case 0 :
				vi_422->pixel_type=VideoInfo::CS_YV16;
				vi_444->pixel_type=VideoInfo::CS_YV24;
				vi.pixel_type=VideoInfo::CS_BGR32;
				break;
			case 1 :
				vi_422->pixel_type=VideoInfo::CS_YUV422P16;
				vi_444->pixel_type=VideoInfo::CS_YUV444P16;
				vi.pixel_type=VideoInfo::CS_BGR64;
				break;
			case 2 :
				vi_422->pixel_type=VideoInfo::CS_YUV422P16;
				vi_444->pixel_type=VideoInfo::CS_YUV444P16;
				vi.pixel_type=VideoInfo::CS_RGBPS;
				break;
			default :
				vi_422->pixel_type=VideoInfo::CS_YV16;
				vi_444->pixel_type=VideoInfo::CS_YV24;
				vi.pixel_type=VideoInfo::CS_BGR32;
				break;
		}
	}
	else
	{
		switch(bits_per_pixel)
		{
			case 10 :
				vi_422->pixel_type=VideoInfo::CS_YUV422P10;
				vi_444->pixel_type=VideoInfo::CS_YUV444P10;
				break;
			case 12 :
				vi_422->pixel_type=VideoInfo::CS_YUV422P12;
				vi_444->pixel_type=VideoInfo::CS_YUV444P12;
				break;
			case 14 :
				vi_422->pixel_type=VideoInfo::CS_YUV422P14;
				vi_444->pixel_type=VideoInfo::CS_YUV444P14;
				break;
			default :
				vi_422->pixel_type=VideoInfo::CS_YUV422P16;
				vi_444->pixel_type=VideoInfo::CS_YUV444P16;
				break;
		}
		if (OutputMode==2) vi.pixel_type=VideoInfo::CS_RGBPS;
		else vi.pixel_type=VideoInfo::CS_BGR64;
	}

	if (vi.height<32)
	{
		for(uint8_t i=0; i<3; i++)
			threads_number[i]=1;
	}
	else
	{
		for(uint8_t i=0; i<3; i++)
			threads_number[i]=threads;
	}
	threads_number[0]=CreateMTData(MT_Data[0],threads_number[0],threads_number[0],vi.width,vi.height,true,true,true,false);
	threads_number[1]=CreateMTData(MT_Data[1],threads_number[1],threads_number[1],vi.width,vi.height,true,false,false,false);
	threads_number[2]=CreateMTData(MT_Data[2],threads_number[2],threads_number[2],vi.width,vi.height,false,false,false,false);

	max_threads=threads_number[0];
	for(uint8_t i=1; i<3; i++)
		if (max_threads<threads_number[i]) max_threads=threads_number[i];

	const double alpha=1.09929682680944,beta=0.018053968510807;
	const double alpha2=267.84,beta2=0.0003024;

	const double m1=0.1593017578125;
	const double m2=78.84375;
	const double c1=0.8359375;
	const double c2=18.8515625;
	const double c3=18.6875;
	
	for (uint16_t i=0; i<256; i++)
	{
		double x=((double)i)/255.0;

		if (Color==0)
		{
			if (!HLGMode)
			{
				// PQ EOTF
				const double x0=pow(x,1.0/m2);

				if (x0<=c1) x=0.0;
				else x=pow((x0-c1)/(c2-c3*x0),1.0/m1);
			
				// Reverse PQ OOTF
				if (x>0.0)
				{
					x=pow(100.0*x,1.0/2.4);
					if (x<=alpha2*beta2) x/=alpha2;
					else x=pow(((x+(alpha-1.0)))/alpha,1.0/0.45)/59.5208;
				}
			}
			else
			{
			}
		}
		else
		{
			if (x<(beta*4.5)) x/=4.5;
			else x=pow(((x+(alpha-1.0)))/alpha,1.0/0.45);
		}
		if (x>1.0) x=1.0;

		lookupL_8[i]=(uint8_t)round(i*x);
		lookup_Upscale8[i]=3*i+2;
		lookup_8to16[i]=((uint32_t)i) << 8;
	}

	for (uint32_t i=0; i<65536; i++)
	{
		double x=((double)i)/65535.0;

		if (Color==0)
		{
			if (!HLGMode)
			{
				// PQ EOTF
				double x0=pow(x,1.0/m2);

				if (x0<=c1) x=0.0;
				else x=pow((x0-c1)/(c2-c3*x0),1.0/m1);
			
				// Reverse PQ OOTF
				if (x>0.0)
				{
					x=pow(100.0*x,1.0/2.4);
					if (x<=alpha2*beta2) x/=alpha2;
					else x=pow(((x+(alpha-1.0)))/alpha,1.0/0.45)/59.5208;
				}
			}
			else
			{
			}
		}
		else
		{
			if (x<(beta*4.5)) x/=4.5;
			else x=pow(((x+(alpha-1.0)))/alpha,1.0/0.45);
		}
		if (x>1.0) x=1.0;
		lookupL_16[i]=(uint16_t)round(i*x);
	}

	if ((pixelsize==1) && (OutputMode!=0))
	{
		for (uint32_t i=0; i<256; i++)
			lookup_Upscale16[i]=3*(i << 8)+2;
	}
	else
	{
		for (uint32_t i=0; i<vmax; i++)
			lookup_Upscale16[i]=3*i+2;
	}

	if (vi.pixel_type==VideoInfo::CS_BGR32) Compute_Lookup_RGB_8(Color,fullrange,true,lookupRGB_8,dl);
	else
	{
		if ((OutputMode!=0) && (pixelsize==1) && (vi_original->pixel_type!=VideoInfo::CS_YV24))
			Compute_Lookup_RGB_16(Color,fullrange,true,16,lookupRGB_16,dl);
		else Compute_Lookup_RGB_16(Color,fullrange,true,bits_per_pixel,lookupRGB_16,dl);
	}

	SSE2_Enable=((env->GetCPUFlags()&CPUF_SSE2)!=0);
	AVX_Enable=((env->GetCPUFlags()&CPUF_AVX)!=0);
	SSE41_Enable=((env->GetCPUFlags()&CPUF_SSE4_1)!=0);
	AVX2_Enable=((env->GetCPUFlags()&CPUF_AVX2)!=0);

	if (max_threads>1)
	{
		if (!poolInterface->GetUserId(UserId))
		{
			poolInterface->DeAllocateAllThreads(true);
			FreeData();
			env->ThrowError("ConvertLinearRGBtoYUV: Error with the TheadPool while getting UserId!");
		}
	}
}


void ConvertLinearRGBtoYUV::FreeData(void) 
{
	mydelete(vi_RGB64);
	mydelete(vi_444);
	mydelete(vi_422);
	mydelete(vi_original);
	myfree(lookupL_16);
	myfree(lookupL_8);
	myfree(lookupRGB_16);
	myfree(lookupRGB_8);
	myfree(lookup_Upscale16);
	myfree(lookup_8to16);
	myfree(lookup_Upscale8);
}


ConvertLinearRGBtoYUV::~ConvertLinearRGBtoYUV() 
{
	if (max_threads>1) poolInterface->RemoveUserId(UserId);
	if (threads>1) poolInterface->DeAllocateAllThreads(true);
	FreeData();
}


int __stdcall ConvertLinearRGBtoYUV::SetCacheHints(int cachehints,int frame_range)
{
  switch (cachehints)
  {
	case CACHE_GET_MTMODE :
		return MT_NICE_FILTER;
	default :
		return 0;
  }
}


void ConvertLinearRGBtoYUV::StaticThreadpool(void *ptr)
{
	const Public_MT_Data_Thread *data=(const Public_MT_Data_Thread *)ptr;
	ConvertLinearRGBtoYUV *ptrClass=(ConvertLinearRGBtoYUV *)data->pClass;

	MT_Data_Info_HDRTools *mt_data_inf=((MT_Data_Info_HDRTools *)data->pData)+data->thread_Id;
	
	switch(data->f_process)
	{
		case 1 : Convert_Progressive_8_YV12toYV16(*mt_data_inf,ptrClass->lookup_Upscale8);
			break;
		case 2 : Convert_Progressive_8_YV12toYV16_SSE2(*mt_data_inf);
			break;
		case 3 : Convert_Progressive_8_YV12toYV16_AVX(*mt_data_inf);
			break;
		case 5 : Convert_Progressive_8to16_YV12toYV16(*mt_data_inf,ptrClass->lookup_Upscale16,ptrClass->lookup_8to16);
			break;
		case 6 : Convert_Progressive_8to16_YV12toYV16_SSE2(*mt_data_inf,ptrClass->lookup_Upscale16,ptrClass->lookup_8to16);
			break;
		case 7 : Convert_Progressive_8to16_YV12toYV16_AVX(*mt_data_inf,ptrClass->lookup_Upscale16,ptrClass->lookup_8to16);
			break;
		case 8 : Convert_Progressive_16_YV12toYV16(*mt_data_inf,ptrClass->lookup_Upscale16);
			break;
		case 9 : Convert_Progressive_16_YV12toYV16_SSE2(*mt_data_inf);
			break;
		case 10 : Convert_Progressive_16_YV12toYV16_AVX(*mt_data_inf);
			break;
		case 12 : Convert_8_YV16toYV24(*mt_data_inf);
			break;
		case 13 : Convert_8_YV16toYV24_SSE2(*mt_data_inf);
			break;
		case 14 : Convert_8_YV16toYV24_AVX(*mt_data_inf);
			break;
		case 15 : Convert_8to16_YV16toYV24(*mt_data_inf,ptrClass->lookup_8to16);
			break;
		case 16 : Convert_8to16_YV16toYV24_SSE2(*mt_data_inf,ptrClass->lookup_8to16);
			break;
		case 17 : Convert_8to16_YV16toYV24_AVX(*mt_data_inf,ptrClass->lookup_8to16);
			break;
		case 18 : Convert_16_YV16toYV24(*mt_data_inf);
			break;
		case 19 : Convert_16_YV16toYV24_SSE2(*mt_data_inf);
			break;
		case 20 : Convert_16_YV16toYV24_AVX(*mt_data_inf);
			break;
		case 21 : Convert_YV24toRGB32(*mt_data_inf,ptrClass->dl,ptrClass->lookupRGB_8);
			break;
		case 22 : Convert_YV24toRGB32_SSE2(*mt_data_inf,ptrClass->dl,ptrClass->lookupRGB_8);
			break;
		case 23 : Convert_YV24toRGB32_AVX(*mt_data_inf,ptrClass->dl,ptrClass->lookupRGB_8);
			break;
		case 24 : Convert_8_YV24toRGB64(*mt_data_inf,ptrClass->dl,ptrClass->lookupRGB_16);
			break;
		case 25 : Convert_16_YV24toRGB64(*mt_data_inf,ptrClass->dl,ptrClass->lookupRGB_16,ptrClass->bits_per_pixel);
			break;
		case 26 : Convert_YV24toRGB64_SSE41(*mt_data_inf,ptrClass->dl,ptrClass->lookupRGB_16,ptrClass->bits_per_pixel);
			break;
		case 27 : Convert_YV24toRGB64_AVX(*mt_data_inf,ptrClass->dl,ptrClass->lookupRGB_16,ptrClass->bits_per_pixel);
			break;
		case 28 : Convert_16_YV24toRGB64(*mt_data_inf,ptrClass->dl,ptrClass->lookupRGB_16,16);
			break;
		case 29 : Convert_YV24toRGB64_SSE41(*mt_data_inf,ptrClass->dl,ptrClass->lookupRGB_16,16);
			break;
		case 30 : Convert_YV24toRGB64_AVX(*mt_data_inf,ptrClass->dl,ptrClass->lookupRGB_16,16);
			break;
		case 31 : Convert_RGB32toLinearRGB32(*mt_data_inf,ptrClass->lookupL_8);
			break;
		case 32 : Convert_RGB64toLinearRGB64(*mt_data_inf,ptrClass->lookupL_16);
			break;
#ifdef AVX2_BUILD_POSSIBLE
		case 4 : Convert_Progressive_8_YV12toYV16_AVX2(*mt_data_inf);
			break;
		case 11 : Convert_Progressive_16_YV12toYV16_AVX2(*mt_data_inf);
			break;
#endif
		default : ;
	}
}


PVideoFrame __stdcall ConvertLinearRGBtoYUV::GetFrame(int n, IScriptEnvironment* env) 
{
	PVideoFrame src = child->GetFrame(n,env);
	PVideoFrame tmp1 = env->NewVideoFrame(*vi_422,64);
	PVideoFrame tmp2 = env->NewVideoFrame(*vi_444,64);
	PVideoFrame tmp3 = env->NewVideoFrame(*vi_RGB64,64);
	PVideoFrame dst = env->NewVideoFrame(vi,64);

	const uint8_t *srcY = src->GetReadPtr(PLANAR_Y);
	const uint8_t *srcU = src->GetReadPtr(PLANAR_U);
	const uint8_t *srcV = src->GetReadPtr(PLANAR_V);
	const ptrdiff_t src_pitch_Y = src->GetPitch(PLANAR_Y);
	const ptrdiff_t src_pitch_U = src->GetPitch(PLANAR_U);
	const ptrdiff_t src_pitch_V = src->GetPitch(PLANAR_V);
	const ptrdiff_t src_modulo_Y = src_pitch_Y - src->GetRowSize(PLANAR_Y);
	const ptrdiff_t src_modulo_U = src_pitch_U - src->GetRowSize(PLANAR_U);
	const ptrdiff_t src_modulo_V = src_pitch_V - src->GetRowSize(PLANAR_V);

	const uint8_t *tmp1Yr = tmp1->GetReadPtr(PLANAR_Y);
	const uint8_t *tmp1Ur = tmp1->GetReadPtr(PLANAR_U);
	const uint8_t *tmp1Vr = tmp1->GetReadPtr(PLANAR_V);
	uint8_t *tmp1Yw = tmp1->GetWritePtr(PLANAR_Y);
	uint8_t *tmp1Uw = tmp1->GetWritePtr(PLANAR_U);
	uint8_t *tmp1Vw = tmp1->GetWritePtr(PLANAR_V);
	const ptrdiff_t tmp1_pitch_Y = tmp1->GetPitch(PLANAR_Y);
	const ptrdiff_t tmp1_pitch_U = tmp1->GetPitch(PLANAR_U);
	const ptrdiff_t tmp1_pitch_V = tmp1->GetPitch(PLANAR_V);

	const uint8_t *tmp2Yr = tmp2->GetReadPtr(PLANAR_Y);
	const uint8_t *tmp2Ur = tmp2->GetReadPtr(PLANAR_U);
	const uint8_t *tmp2Vr = tmp2->GetReadPtr(PLANAR_V);
	uint8_t *tmp2Yw = tmp2->GetWritePtr(PLANAR_Y);
	uint8_t *tmp2Uw = tmp2->GetWritePtr(PLANAR_U);
	uint8_t *tmp2Vw = tmp2->GetWritePtr(PLANAR_V);
	const ptrdiff_t tmp2_pitch_Y = tmp2->GetPitch(PLANAR_Y);
	const ptrdiff_t tmp2_pitch_U = tmp2->GetPitch(PLANAR_U);
	const ptrdiff_t tmp2_pitch_V = tmp2->GetPitch(PLANAR_V);
	const ptrdiff_t tmp2_modulo_Y = tmp2_pitch_Y - tmp2->GetRowSize(PLANAR_Y);
	const ptrdiff_t tmp2_modulo_U = tmp2_pitch_U - tmp2->GetRowSize(PLANAR_U);
	const ptrdiff_t tmp2_modulo_V = tmp2_pitch_V - tmp2->GetRowSize(PLANAR_V);

	const uint8_t *tmp3r = tmp3->GetReadPtr();
	uint8_t *tmp3w = tmp3->GetWritePtr();
	const int32_t tmp3_h = tmp3->GetHeight();
	const ptrdiff_t tmp3_pitch = tmp3->GetPitch();

	const uint8_t *tmp3r0=tmp3r+(tmp3_h-1)*tmp3_pitch;
	uint8_t *tmp3w0=tmp3w+(tmp3_h-1)*tmp3_pitch;
	const ptrdiff_t tmp3_pitch0 = -tmp3_pitch;
	const ptrdiff_t tmp3_modulo0 = tmp3_pitch0 - tmp3->GetRowSize();

	const uint8_t *dstr = dst->GetReadPtr();
	uint8_t *dstw = dst->GetWritePtr();
	const int32_t dst_h = dst->GetHeight();
	const ptrdiff_t dst_pitch = dst->GetPitch();

	uint8_t *dstw0=dstw+(dst_h-1)*dst_pitch;
	const ptrdiff_t dst_pitch0 = -dst_pitch;
	const ptrdiff_t dst_modulo0 = dst_pitch0 - dst->GetRowSize();

	const uint8_t *dstRr,*dstGr,*dstBr;
	uint8_t *dstRw,*dstGw,*dstBw;
	ptrdiff_t dst_pitch_R,dst_pitch_G,dst_pitch_B;

	if (vi.pixel_type==VideoInfo::CS_RGBPS)
	{
		dstRr = dst->GetReadPtr(PLANAR_R);
		dstGr = dst->GetReadPtr(PLANAR_G);
		dstBr = dst->GetReadPtr(PLANAR_B);
		dstRw = dst->GetWritePtr(PLANAR_R);
		dstGw = dst->GetWritePtr(PLANAR_G);
		dstBw = dst->GetWritePtr(PLANAR_B);
		dst_pitch_R = dst->GetPitch(PLANAR_R);
		dst_pitch_G = dst->GetPitch(PLANAR_G);
		dst_pitch_B = dst->GetPitch(PLANAR_B);
	}

	Public_MT_Data_Thread MT_ThreadGF[MAX_MT_THREADS];
	MT_Data_Info_HDRTools MT_DataGF[MAX_MT_THREADS];
	int8_t nPool=-1;

	memcpy(MT_ThreadGF,MT_Thread,sizeof(MT_ThreadGF));

	for(uint8_t i=0; i<max_threads; i++)
		MT_ThreadGF[i].pData=(void *)MT_DataGF;

	if (max_threads>1)
	{
		if ((!poolInterface->RequestThreadPool(UserId,max_threads,MT_ThreadGF,nPool,false,true)) || (nPool==-1))
			env->ThrowError("ConvertYUVtoLinearRGB: Error with the TheadPool while requesting threadpool !");
	}

	const bool src_Y_al32=((((size_t)srcY) & 0x1F)==0) && ((abs(src_pitch_Y) & 0x1F)==0);
	const bool src_Y_al16=((((size_t)srcY) & 0x0F)==0) && ((abs(src_pitch_Y) & 0x0F)==0);
	const bool src_UV_al32=((((size_t)srcU) & 0x1F)==0) && ((((size_t)srcV) & 0x1F)==0)
		&& ((abs(src_pitch_U) & 0x1F)==0) && ((abs(src_pitch_V) & 0x1F)==0);
	const bool src_UV_al16=((((size_t)srcU) & 0x0F)==0) && ((((size_t)srcV) & 0x0F)==0)
		&& ((abs(src_pitch_U) & 0x0F)==0) && ((abs(src_pitch_V) & 0x0F)==0);

	const bool tmp1_Y_al32=((((size_t)tmp1Yw) & 0x1F)==0) && ((((size_t)tmp1Yr) & 0x1F)==0)
		&& ((abs(tmp1_pitch_Y) & 0x1F)==0);
	const bool tmp1_Y_al16=((((size_t)tmp1Yw) & 0x0F)==0) && ((((size_t)tmp1Yr) & 0x0F)==0)
		&& ((abs(tmp1_pitch_Y) & 0x0F)==0);
	const bool tmp1_UV_al32=((((size_t)tmp1Uw) & 0x1F)==0) && ((((size_t)tmp1Vw) & 0x1F)==0)
		&& ((((size_t)tmp1Ur) & 0x1F)==0) && ((((size_t)tmp1Vr) & 0x1F)==0)
		&& ((abs(tmp1_pitch_U) & 0x1F)==0) && ((abs(tmp1_pitch_V) & 0x1F)==0);
	const bool tmp1_UV_al16=((((size_t)tmp1Uw) & 0x0F)==0) && ((((size_t)tmp1Vw) & 0x0F)==0)
		&& ((((size_t)tmp1Ur) & 0x0F)==0) && ((((size_t)tmp1Vr) & 0x0F)==0)
		&& ((abs(tmp1_pitch_U) & 0x0F)==0) && ((abs(tmp1_pitch_V) & 0x0F)==0);

	const bool tmp2_Y_al32=((((size_t)tmp2Yw) & 0x1F)==0) && ((((size_t)tmp2Yr) & 0x1F)==0)
		&& ((abs(tmp2_pitch_Y) & 0x1F)==0);
	const bool tmp2_Y_al16=((((size_t)tmp2Yw) & 0x0F)==0) && ((((size_t)tmp2Yr) & 0x0F)==0)
		&& ((abs(tmp2_pitch_Y) & 0x0F)==0);
	const bool tmp2_UV_al32=((((size_t)tmp2Uw) & 0x1F)==0) && ((((size_t)tmp2Vw) & 0x1F)==0)
		&& ((((size_t)tmp2Ur) & 0x1F)==0) && ((((size_t)tmp2Vr) & 0x1F)==0)
		&& ((abs(tmp2_pitch_U) & 0x1F)==0) && ((abs(tmp2_pitch_V) & 0x1F)==0);
	const bool tmp2_UV_al16=((((size_t)tmp2Uw) & 0x0F)==0) && ((((size_t)tmp2Vw) & 0x0F)==0)
		&& ((((size_t)tmp2Ur) & 0x0F)==0) && ((((size_t)tmp2Vr) & 0x0F)==0)
		&& ((abs(tmp2_pitch_U) & 0x0F)==0) && ((abs(tmp2_pitch_V) & 0x0F)==0);

	const bool tmp3_al32=((((size_t)tmp3w) & 0x1F)==0) && ((((size_t)tmp3r) & 0x1F)==0)
		&& ((abs(tmp3_pitch) & 0x1F)==0);
	const bool tmp3_al16=((((size_t)tmp3w) & 0x0F)==0) && ((((size_t)tmp3r) & 0x0F)==0)
		&& ((abs(tmp3_pitch) & 0x0F)==0);

	const bool dst_al32=((((size_t)dstw) & 0x1F)==0) && ((((size_t)dstr) & 0x1F)==0)
		&& ((abs(dst_pitch) & 0x1F)==0);
	const bool dst_al16=((((size_t)dstw) & 0x0F)==0) && ((((size_t)dstr) & 0x0F)==0)
		&& ((abs(dst_pitch) & 0x0F)==0);
	
	const bool dst_RGBP_al32=((((size_t)dstRw) & 0x1F)==0) && ((((size_t)dstRr) & 0x1F)==0)
		&& ((((size_t)dstGw) & 0x1F)==0) && ((((size_t)dstGr) & 0x1F)==0)
		&& ((((size_t)dstBw) & 0x1F)==0) && ((((size_t)dstBr) & 0x1F)==0)
		&& ((abs(dst_pitch_R) & 0x1F)==0) && ((abs(dst_pitch_G) & 0x1F)==0)
		&& ((abs(dst_pitch_B) & 0x1F)==0);
	const bool dst_RGBP_al16=((((size_t)dstRw) & 0x0F)==0) && ((((size_t)dstRr) & 0x0F)==0)
		&& ((((size_t)dstGw) & 0x0F)==0) && ((((size_t)dstGr) & 0x0F)==0)
		&& ((((size_t)dstBw) & 0x0F)==0) && ((((size_t)dstBr) & 0x0F)==0)
		&& ((abs(dst_pitch_R) & 0x0F)==0) && ((abs(dst_pitch_G) & 0x0F)==0)
		&& ((abs(dst_pitch_B) & 0x0F)==0);

	uint8_t f_proc=0;

	// Process YUV420 to YUV422 upscale
	memcpy(MT_DataGF,MT_Data[0],sizeof(MT_DataGF));

	if (vi_original->Is420())
	{
		for(uint8_t i=0; i<threads_number[0]; i++)
		{
			MT_DataGF[i].src1=(void *)(srcY+(MT_DataGF[i].src_Y_h_min*src_pitch_Y));
			MT_DataGF[i].src2=(void *)(srcU+(MT_DataGF[i].src_UV_h_min*src_pitch_U));
			MT_DataGF[i].src3=(void *)(srcV+(MT_DataGF[i].src_UV_h_min*src_pitch_V));
			MT_DataGF[i].src_pitch1=src_pitch_Y;
			MT_DataGF[i].src_pitch2=src_pitch_U;
			MT_DataGF[i].src_pitch3=src_pitch_V;
			MT_DataGF[i].dst1=(void *)(tmp1Yw+(MT_DataGF[i].dst_Y_h_min*tmp1_pitch_Y));
			MT_DataGF[i].dst2=(void *)(tmp1Uw+(MT_DataGF[i].dst_UV_h_min*tmp1_pitch_U));
			MT_DataGF[i].dst3=(void *)(tmp1Vw+(MT_DataGF[i].dst_UV_h_min*tmp1_pitch_V));
			MT_DataGF[i].dst_pitch1=tmp1_pitch_Y;
			MT_DataGF[i].dst_pitch2=tmp1_pitch_U;
			MT_DataGF[i].dst_pitch3=tmp1_pitch_V;
		}

		if (pixelsize==1)
		{
			if (OutputMode!=0)
			{
				if (AVX_Enable && src_Y_al16 && tmp1_Y_al16 && src_UV_al16 && tmp1_UV_al16) f_proc=7;
				else
				{
					if (SSE2_Enable && src_Y_al16 && tmp1_Y_al16 && src_UV_al16 && tmp1_UV_al16) f_proc=6;
					else f_proc=5;
				}
			}
			else
			{
				if (AVX2_Enable && src_UV_al32 && tmp1_UV_al32) f_proc=4;
				else
				{
					if (AVX_Enable && src_UV_al16 && tmp1_UV_al16) f_proc=3;
					else
					{
						if (SSE2_Enable && src_UV_al16 && tmp1_UV_al16) f_proc=2;
						else f_proc=1;
					}
				}
			}
		}
		else
		{
			if (AVX2_Enable && src_UV_al32 && tmp1_UV_al32) f_proc=11;
			else
			{
				if (AVX_Enable && src_UV_al16 && tmp1_UV_al16) f_proc=10;
				else
				{
					if (SSE2_Enable && src_UV_al16 && tmp1_UV_al16) f_proc=9;
					else f_proc=8;
				}
			}
		}
	}
	else f_proc=0;
	
	if (f_proc!=0)
	{
		if (threads_number[0]>1)
		{
			for(uint8_t i=0; i<threads_number[0]; i++)
				MT_ThreadGF[i].f_process=f_proc;
			if (poolInterface->StartThreads(UserId,nPool)) poolInterface->WaitThreadsEnd(UserId,nPool);

			for(uint8_t i=0; i<threads_number[0]; i++)
				MT_ThreadGF[i].f_process=0;
		}
		else
		{
			switch(f_proc)
			{
				case 1 : Convert_Progressive_8_YV12toYV16(MT_DataGF[0],lookup_Upscale8); break;
				case 2 : Convert_Progressive_8_YV12toYV16_SSE2(MT_DataGF[0]); break;
				case 3 : Convert_Progressive_8_YV12toYV16_AVX(MT_DataGF[0]); break;
				case 5 : Convert_Progressive_8to16_YV12toYV16(MT_DataGF[0],lookup_Upscale16,lookup_8to16); break;
				case 6 : Convert_Progressive_8to16_YV12toYV16_SSE2(MT_DataGF[0],lookup_Upscale16,lookup_8to16); break;
				case 7 : Convert_Progressive_8to16_YV12toYV16_AVX(MT_DataGF[0],lookup_Upscale16,lookup_8to16); break;
				case 8 : Convert_Progressive_16_YV12toYV16(MT_DataGF[0],lookup_Upscale16); break;
				case 9 : Convert_Progressive_16_YV12toYV16_SSE2(MT_DataGF[0]); break;
				case 10 : Convert_Progressive_16_YV12toYV16_AVX(MT_DataGF[0]); break;
#ifdef AVX2_BUILD_POSSIBLE
				case 4 : Convert_Progressive_8_YV12toYV16_AVX2(MT_DataGF[0]); break;
				case 11 : Convert_Progressive_16_YV12toYV16_AVX2(MT_DataGF[0]); break;
#endif
				default : break;
			}
		}
	}

	// Process YUV422 to YUV444 upscale
	memcpy(MT_DataGF,MT_Data[1],sizeof(MT_DataGF));

	if (vi_original->Is422())
	{
		for(uint8_t i=0; i<threads_number[1]; i++)
		{
			MT_DataGF[i].src1=(void *)(srcY+(MT_DataGF[i].src_Y_h_min*src_pitch_Y));
			MT_DataGF[i].src2=(void *)(srcU+(MT_DataGF[i].src_UV_h_min*src_pitch_U));
			MT_DataGF[i].src3=(void *)(srcV+(MT_DataGF[i].src_UV_h_min*src_pitch_V));
			MT_DataGF[i].src_pitch1=src_pitch_Y;
			MT_DataGF[i].src_pitch2=src_pitch_U;
			MT_DataGF[i].src_pitch3=src_pitch_V;
			MT_DataGF[i].dst1=(void *)(tmp2Yw+(MT_DataGF[i].dst_Y_h_min*tmp2_pitch_Y));
			MT_DataGF[i].dst2=(void *)(tmp2Uw+(MT_DataGF[i].dst_UV_h_min*tmp2_pitch_U));
			MT_DataGF[i].dst3=(void *)(tmp2Vw+(MT_DataGF[i].dst_UV_h_min*tmp2_pitch_V));
			MT_DataGF[i].dst_pitch1=tmp2_pitch_Y;
			MT_DataGF[i].dst_pitch2=tmp2_pitch_U;
			MT_DataGF[i].dst_pitch3=tmp2_pitch_V;
		}

		if (pixelsize==1)
		{
			if (OutputMode!=0)
			{
				if (AVX_Enable && src_Y_al16 && tmp2_Y_al16 && src_UV_al16 && tmp2_UV_al16) f_proc=17;
				else
				{
					if (SSE2_Enable && src_Y_al16 && tmp2_Y_al16 && src_UV_al16 && tmp2_UV_al16) f_proc=16;
					else f_proc=15;
				}
			}
			else
			{
				if (AVX_Enable && src_UV_al16 && tmp2_UV_al16) f_proc=14;
				else
				{
					if (SSE2_Enable && src_UV_al16 && tmp2_UV_al16) f_proc=13;
					else f_proc=12;
				}
			}
		}
		else
		{
			if (AVX_Enable && src_UV_al16 && tmp2_UV_al16) f_proc=20;
			else
			{
				if (SSE2_Enable && src_UV_al16 && tmp2_UV_al16) f_proc=19;
				else f_proc=18;
			}
		}
	}
	else f_proc=0;

	if (vi_original->Is420())
	{
		for(uint8_t i=0; i<threads_number[1]; i++)
		{
			MT_DataGF[i].src1=(void *)(tmp1Yr+(MT_DataGF[i].src_Y_h_min*tmp1_pitch_Y));
			MT_DataGF[i].src2=(void *)(tmp1Ur+(MT_DataGF[i].src_UV_h_min*tmp1_pitch_U));
			MT_DataGF[i].src3=(void *)(tmp1Vr+(MT_DataGF[i].src_UV_h_min*tmp1_pitch_V));
			MT_DataGF[i].src_pitch1=tmp1_pitch_Y;
			MT_DataGF[i].src_pitch2=tmp1_pitch_U;
			MT_DataGF[i].src_pitch3=tmp1_pitch_V;
			MT_DataGF[i].dst1=(void *)(tmp2Yw+(MT_DataGF[i].dst_Y_h_min*tmp2_pitch_Y));
			MT_DataGF[i].dst2=(void *)(tmp2Uw+(MT_DataGF[i].dst_UV_h_min*tmp2_pitch_U));
			MT_DataGF[i].dst3=(void *)(tmp2Vw+(MT_DataGF[i].dst_UV_h_min*tmp2_pitch_V));
			MT_DataGF[i].dst_pitch1=tmp2_pitch_Y;
			MT_DataGF[i].dst_pitch2=tmp2_pitch_U;
			MT_DataGF[i].dst_pitch3=tmp2_pitch_V;
		}

		if (pixelsize==1)
		{
			if (OutputMode!=0)
			{
				if (AVX_Enable && tmp1_UV_al16 && tmp2_UV_al16) f_proc=20;
				else
				{
					if (SSE2_Enable && tmp1_UV_al16 && tmp2_UV_al16) f_proc=19;
					else f_proc=18;
				}
			}
			else
			{
				if (AVX_Enable && tmp1_UV_al16 && tmp2_UV_al16) f_proc=14;
				else
				{
					if (SSE2_Enable && tmp1_UV_al16 && tmp2_UV_al16) f_proc=13;
					else f_proc=12;
				}
			}
		}
		else
		{
			if (AVX_Enable && tmp1_UV_al16 && tmp2_UV_al16) f_proc=20;
			else
			{
				if (SSE2_Enable && tmp1_UV_al16 && tmp2_UV_al16) f_proc=19;
				else f_proc=18;
			}
		}
	}

	if (f_proc!=0)
	{
		if (threads_number[1]>1)
		{
			for(uint8_t i=0; i<threads_number[1]; i++)
				MT_ThreadGF[i].f_process=f_proc;
			if (poolInterface->StartThreads(UserId,nPool)) poolInterface->WaitThreadsEnd(UserId,nPool);

			for(uint8_t i=0; i<threads_number[1]; i++)
				MT_ThreadGF[i].f_process=0;
		}
		else
		{
			switch(f_proc)
			{
				case 12 : Convert_8_YV16toYV24(MT_DataGF[0]); break;
				case 13 : Convert_8_YV16toYV24_SSE2(MT_DataGF[0]); break;
				case 14 : Convert_8_YV16toYV24_AVX(MT_DataGF[0]); break;
				case 15 : Convert_8to16_YV16toYV24(MT_DataGF[0],lookup_8to16); break;
				case 16 : Convert_8to16_YV16toYV24_SSE2(MT_DataGF[0],lookup_8to16); break;
				case 17 : Convert_8to16_YV16toYV24_AVX(MT_DataGF[0],lookup_8to16); break;
				case 18 : Convert_16_YV16toYV24(MT_DataGF[0]); break;
				case 19 : Convert_16_YV16toYV24_SSE2(MT_DataGF[0]); break;
				case 20 : Convert_16_YV16toYV24_AVX(MT_DataGF[0]); break;
				default : break;
			}
		}
	}

	//Process YUV444 to RGB
	memcpy(MT_DataGF,MT_Data[2],sizeof(MT_DataGF));

	if (vi_original->Is444())
	{
		if (OutputMode!=2)
		{
			for(uint8_t i=0; i<threads_number[2]; i++)
			{
				MT_DataGF[i].src1=(void *)(srcY+(MT_DataGF[i].src_Y_h_min*src_pitch_Y));
				MT_DataGF[i].src2=(void *)(srcU+(MT_DataGF[i].src_UV_h_min*src_pitch_U));
				MT_DataGF[i].src3=(void *)(srcV+(MT_DataGF[i].src_UV_h_min*src_pitch_V));
				MT_DataGF[i].src_pitch1=src_pitch_Y;
				MT_DataGF[i].src_pitch2=src_pitch_U;
				MT_DataGF[i].src_pitch3=src_pitch_V;
				MT_DataGF[i].src_modulo1=src_modulo_Y;
				MT_DataGF[i].src_modulo2=src_modulo_U;
				MT_DataGF[i].src_modulo3=src_modulo_V;
				MT_DataGF[i].dst1=(void *)(dstw0+(MT_DataGF[i].dst_Y_h_min*dst_pitch0));
				MT_DataGF[i].dst_pitch1=dst_pitch0;
				MT_DataGF[i].dst_modulo1=dst_modulo0;
			}
		}
		else
		{
			for(uint8_t i=0; i<threads_number[2]; i++)
			{
				MT_DataGF[i].src1=(void *)(srcY+(MT_DataGF[i].src_Y_h_min*src_pitch_Y));
				MT_DataGF[i].src2=(void *)(srcU+(MT_DataGF[i].src_UV_h_min*src_pitch_U));
				MT_DataGF[i].src3=(void *)(srcV+(MT_DataGF[i].src_UV_h_min*src_pitch_V));
				MT_DataGF[i].src_pitch1=src_pitch_Y;
				MT_DataGF[i].src_pitch2=src_pitch_U;
				MT_DataGF[i].src_pitch3=src_pitch_V;
				MT_DataGF[i].src_modulo1=src_modulo_Y;
				MT_DataGF[i].src_modulo2=src_modulo_U;
				MT_DataGF[i].src_modulo3=src_modulo_V;
				MT_DataGF[i].dst1=(void *)(tmp3w0+(MT_DataGF[i].dst_Y_h_min*tmp3_pitch0));
				MT_DataGF[i].dst_pitch1=tmp3_pitch0;
				MT_DataGF[i].dst_modulo1=tmp3_modulo0;
			}
		}

		if (pixelsize==1)
		{
			if (OutputMode!=0)
			{
				if (AVX_Enable) f_proc=27;
				else
				{
					if (SSE41_Enable) f_proc=26;
					else f_proc=24;
				}
			}
			else
			{
				if (AVX_Enable) f_proc=23;
				else
				{
					if (SSE41_Enable) f_proc=22;
					else f_proc=21;
				}
			}
		}
		else
		{
			if (AVX_Enable) f_proc=27;
			else
			{
				if (SSE41_Enable) f_proc=26;
				else f_proc=25;
			}
		}
	}
	else
	{
		if (OutputMode!=2)
		{
			for(uint8_t i=0; i<threads_number[2]; i++)
			{
				MT_DataGF[i].src1=(void *)(tmp2Yr+(MT_DataGF[i].src_Y_h_min*tmp2_pitch_Y));
				MT_DataGF[i].src2=(void *)(tmp2Ur+(MT_DataGF[i].src_UV_h_min*tmp2_pitch_U));
				MT_DataGF[i].src3=(void *)(tmp2Vr+(MT_DataGF[i].src_UV_h_min*tmp2_pitch_V));
				MT_DataGF[i].src_pitch1=tmp2_pitch_Y;
				MT_DataGF[i].src_pitch2=tmp2_pitch_U;
				MT_DataGF[i].src_pitch3=tmp2_pitch_V;
				MT_DataGF[i].src_modulo1=tmp2_modulo_Y;
				MT_DataGF[i].src_modulo2=tmp2_modulo_U;
				MT_DataGF[i].src_modulo3=tmp2_modulo_V;
				MT_DataGF[i].dst1=(void *)(dstw0+(MT_DataGF[i].dst_Y_h_min*dst_pitch0));
				MT_DataGF[i].dst_pitch1=dst_pitch0;
				MT_DataGF[i].dst_modulo1=dst_modulo0;
			}
		}
		else
		{
			for(uint8_t i=0; i<threads_number[2]; i++)
			{
				MT_DataGF[i].src1=(void *)(tmp2Yr+(MT_DataGF[i].src_Y_h_min*tmp2_pitch_Y));
				MT_DataGF[i].src2=(void *)(tmp2Ur+(MT_DataGF[i].src_UV_h_min*tmp2_pitch_U));
				MT_DataGF[i].src3=(void *)(tmp2Vr+(MT_DataGF[i].src_UV_h_min*tmp2_pitch_V));
				MT_DataGF[i].src_pitch1=tmp2_pitch_Y;
				MT_DataGF[i].src_pitch2=tmp2_pitch_U;
				MT_DataGF[i].src_pitch3=tmp2_pitch_V;
				MT_DataGF[i].src_modulo1=tmp2_modulo_Y;
				MT_DataGF[i].src_modulo2=tmp2_modulo_U;
				MT_DataGF[i].src_modulo3=tmp2_modulo_V;
				MT_DataGF[i].dst1=(void *)(tmp3w0+(MT_DataGF[i].dst_Y_h_min*tmp3_pitch0));
				MT_DataGF[i].dst_pitch1=tmp3_pitch0;
				MT_DataGF[i].dst_modulo1=tmp3_modulo0;
			}
		}

		if (pixelsize==1)
		{
			if (OutputMode!=0)
			{
				if (AVX_Enable) f_proc=30;
				else
				{
					if (SSE41_Enable) f_proc=29;
					else f_proc=28;
				}
			}
			else
			{
				if (AVX_Enable) f_proc=23;
				else
				{
					if (SSE41_Enable) f_proc=22;
					else f_proc=21;
				}
			}
		}
		else
		{
			if (AVX_Enable) f_proc=27;
			else
			{
				if (SSE41_Enable) f_proc=26;
				else f_proc=25;
			}
		}
	}

	if (threads_number[2]>1)
	{
		for(uint8_t i=0; i<threads_number[2]; i++)
			MT_ThreadGF[i].f_process=f_proc;
		if (poolInterface->StartThreads(UserId,nPool)) poolInterface->WaitThreadsEnd(UserId,nPool);

		for(uint8_t i=0; i<threads_number[2]; i++)
			MT_ThreadGF[i].f_process=0;
	}
	else
	{
		switch(f_proc)
		{
			case 21 : Convert_YV24toRGB32(MT_DataGF[0],dl,lookupRGB_8); break;
			case 22 : Convert_YV24toRGB32_SSE2(MT_DataGF[0],dl,lookupRGB_8); break;
			case 23 : Convert_YV24toRGB32_AVX(MT_DataGF[0],dl,lookupRGB_8); break;
			case 24 : Convert_8_YV24toRGB64(MT_DataGF[0],dl,lookupRGB_16); break;
			case 25 : Convert_16_YV24toRGB64(MT_DataGF[0],dl,lookupRGB_16,bits_per_pixel); break;
			case 26 : Convert_YV24toRGB64_SSE41(MT_DataGF[0],dl,lookupRGB_16,bits_per_pixel); break;
			case 27 : Convert_YV24toRGB64_AVX(MT_DataGF[0],dl,lookupRGB_16,bits_per_pixel); break;
			case 28 : Convert_16_YV24toRGB64(MT_DataGF[0],dl,lookupRGB_16,16); break;
			case 29 : Convert_YV24toRGB64_SSE41(MT_DataGF[0],dl,lookupRGB_16,16); break;
			case 30 : Convert_YV24toRGB64_AVX(MT_DataGF[0],dl,lookupRGB_16,16); break;
			default : break;
		}
	}

	//Process Non linear RGB to Linear RGB
	if (OutputMode!=2)
	{
		for(uint8_t i=0; i<threads_number[2]; i++)
		{
			MT_DataGF[i].src1=(void *)(dstr+(MT_DataGF[i].src_Y_h_min*dst_pitch));
			MT_DataGF[i].src_pitch1=dst_pitch;
			MT_DataGF[i].dst1=(void *)(dstw+(MT_DataGF[i].dst_Y_h_min*dst_pitch));
			MT_DataGF[i].dst_pitch1=dst_pitch;
		}
	}
	else
	{
		for(uint8_t i=0; i<threads_number[2]; i++)
		{
			MT_DataGF[i].src1=(void *)(tmp3r0+(MT_DataGF[i].src_Y_h_min*tmp3_pitch0));
			MT_DataGF[i].src_pitch1=tmp3_pitch0;
			MT_DataGF[i].src_modulo1=tmp3_modulo0;
			MT_DataGF[i].dst1=(void *)(dstRw+(MT_DataGF[i].dst_Y_h_min*dst_pitch_R));
			MT_DataGF[i].dst2=(void *)(dstGw+(MT_DataGF[i].dst_Y_h_min*dst_pitch_G));
			MT_DataGF[i].dst3=(void *)(dstBw+(MT_DataGF[i].dst_Y_h_min*dst_pitch_B));
			MT_DataGF[i].dst_pitch1=dst_pitch_R;
			MT_DataGF[i].dst_pitch2=dst_pitch_G;
			MT_DataGF[i].dst_pitch3=dst_pitch_B;
		}
	}

	if (OutputMode!=2)
	{
		if (vi.pixel_type==VideoInfo::CS_BGR32) f_proc=31;
		else f_proc=32;
	}
	else f_proc=33;

	if (threads_number[2]>1)
	{
		for(uint8_t i=0; i<threads_number[2]; i++)
			MT_ThreadGF[i].f_process=f_proc;
		if (poolInterface->StartThreads(UserId,nPool)) poolInterface->WaitThreadsEnd(UserId,nPool);

		for(uint8_t i=0; i<threads_number[2]; i++)
			MT_ThreadGF[i].f_process=0;
	}
	else
	{
		switch(f_proc)
		{
			case 31 : Convert_RGB32toLinearRGB32(MT_DataGF[0],lookupL_8); break;
			case 32 : Convert_RGB64toLinearRGB64(MT_DataGF[0],lookupL_16); break;
			default : break;
		}
	}

	if (max_threads>1) poolInterface->ReleaseThreadPool(UserId,sleep,nPool);

	return dst;
}


/*
********************************************************************************************
**                               ConvertYUVtoLinearXYZ                                    **
********************************************************************************************
*/


const AVS_Linkage *AVS_linkage = nullptr;


/*
  Chroma : int, default value : 2
     0 : BT2100
	 1 : BT2020
	 2 : BT709
	 3 : BT601_525
	 4 : BT601_625
  OutputMode : int, default 0.
     0 : Input 8 Bits -> Output : RGB32, Input > 8 Bits -> Output : RGB64
	 1 : Output : RGB64
	 2 : Output : RGBPS (Planar RGB float)
  HLGMode : bool, default false.
  fullrange : bool, default false.
  mpeg2c : bool, default true.
*/
AVSValue __cdecl Create_ConvertYUVtoLinearRGB(AVSValue args, void* user_data, IScriptEnvironment* env)
{
	if (!args[0].IsClip()) env->ThrowError("ConvertYUVtoLinearRGB: arg 0 must be a clip !");

	VideoInfo vi = args[0].AsClip()->GetVideoInfo();

	if (!vi.IsPlanar() || !vi.IsYUV())
		env->ThrowError("ConvertYUVtoLinearRGB: Input format must be planar YUV");

	const int Color=args[1].AsInt(2);
	int OutputMode=args[2].AsInt(0);
	const bool HLGMode=args[3].AsBool(false);
	const bool fullrange=args[4].AsBool(false);
	const bool mpeg2c=args[5].AsBool(true);
	const int threads=args[6].AsInt(0);
	const bool LogicalCores=args[7].AsBool(true);
	const bool MaxPhysCores=args[8].AsBool(true);
	const bool SetAffinity=args[9].AsBool(false);
	const bool sleep = args[10].AsBool(false);
	int prefetch=args[11].AsInt(0);

	const bool avsp=env->FunctionExists("ConvertBits");

	if (!avsp) OutputMode=0;

	if ((Color<0) || (Color>4))
		env->ThrowError("ConvertYUVtoLinearRGB: [Color] must be 0 (BT2100), 1 (BT2020), 2 (BT709), 3 (BT601_525), 4 (BT601_625)");
	if ((OutputMode<0) || (OutputMode>2))
		env->ThrowError("ConvertYUVtoLinearRGB: [OutputMode] must be 0, 1 or 2");
	if ((threads<0) || (threads>MAX_MT_THREADS))
		env->ThrowError("ConvertYUVtoLinearRGB: [threads] must be between 0 and %ld.",MAX_MT_THREADS);

	if (prefetch==0) prefetch=1;
	if ((prefetch<0) || (prefetch>MAX_THREAD_POOL))
		env->ThrowError("ConvertYUVtoLinearRGB: [prefetch] must be between 0 and %d.",MAX_THREAD_POOL);

	uint8_t threads_number=1;

	if (threads!=1)
	{
		if (!poolInterface->CreatePool(prefetch)) env->ThrowError("ConvertYUVtoLinearRGB: Unable to create ThreadPool!");

		threads_number=poolInterface->GetThreadNumber(threads,LogicalCores);

		if (threads_number==0) env->ThrowError("ConvertYUVtoLinearRGB: Error with the TheadPool while getting CPU info!");

		if (threads_number>1)
		{
			if (prefetch>1)
			{
				if (SetAffinity && (prefetch<=poolInterface->GetPhysicalCoreNumber()))
				{
					float delta=(float)poolInterface->GetPhysicalCoreNumber()/(float)prefetch,Offset=0.0f;

					for(uint8_t i=0; i<prefetch; i++)
					{
						if (!poolInterface->AllocateThreads(threads_number,(uint8_t)ceil(Offset),0,MaxPhysCores,true,true,i))
						{
							poolInterface->DeAllocateAllThreads(true);
							env->ThrowError("ConvertYUVtoLinearRGB: Error with the TheadPool while allocating threadpool!");
						}
						Offset+=delta;
					}
				}
				else
				{
					if (!poolInterface->AllocateThreads(threads_number,0,0,MaxPhysCores,false,true,-1))
					{
						poolInterface->DeAllocateAllThreads(true);
						env->ThrowError("ConvertYUVtoLinearRGB: Error with the TheadPool while allocating threadpool!");
					}
				}
			}
			else
			{
				if (!poolInterface->AllocateThreads(threads_number,0,0,MaxPhysCores,SetAffinity,true,-1))
				{
					poolInterface->DeAllocateAllThreads(true);
					env->ThrowError("ConvertYUVtoLinearRGB: Error with the TheadPool while allocating threadpool!");
				}
			}
		}
	}

	return new ConvertYUVtoLinearRGB(args[0].AsClip(),Color,OutputMode,HLGMode,fullrange,mpeg2c,threads_number,sleep,env);
}


/*
  Chroma : int, default value : 2
     0 : BT2100
	 1 : BT2020
	 2 : BT709
	 3 : BT601_525
	 4 : BT601_625
  OutputMode : int, default 0.
     0 : YV24
	 1 : YV16
	 2 : YV12
  HLGMode : bool, default false.
  fullrange : bool, default false.
  mpeg2c : bool, default true.
*/
AVSValue __cdecl Create_ConvertLinearRGBtoYUV(AVSValue args, void* user_data, IScriptEnvironment* env)
{
	if (!args[0].IsClip()) env->ThrowError("ConvertLinearRGBtoYUV: arg 0 must be a clip !");

	VideoInfo vi = args[0].AsClip()->GetVideoInfo();

	if ((vi.pixel_type!=VideoInfo::CS_BGR32) && (vi.pixel_type!=VideoInfo::CS_BGR64)
		&& (vi.pixel_type!=VideoInfo::CS_RGBPS))
		env->ThrowError("ConvertLinearRGBtoYUV: Input format must be RGB32, RGB64 or RGBPS");

	const int Color=args[1].AsInt(2);
	int OutputMode=args[2].AsInt(0);
	const bool HLGMode=args[3].AsBool(false);
	const bool fullrange=args[4].AsBool(false);
	const bool mpeg2c=args[5].AsBool(true);
	const int threads=args[6].AsInt(0);
	const bool LogicalCores=args[7].AsBool(true);
	const bool MaxPhysCores=args[8].AsBool(true);
	const bool SetAffinity=args[9].AsBool(false);
	const bool sleep = args[10].AsBool(false);
	int prefetch=args[11].AsInt(0);

	const bool avsp=env->FunctionExists("ConvertBits");

	if (!avsp) OutputMode=0;

	if ((Color<0) || (Color>4))
		env->ThrowError("ConvertLinearRGBtoYUV: [Color] must be 0 (BT2100), 1 (BT2020), 2 (BT709), 3 (BT601_525), 4 (BT601_625)");
	if ((OutputMode<0) || (OutputMode>2))
		env->ThrowError("ConvertLinearRGBtoYUV: [OutputMode] must be 0, 1 or 2");
	if ((threads<0) || (threads>MAX_MT_THREADS))
		env->ThrowError("ConvertLinearRGBtoYUV: [threads] must be between 0 and %ld.",MAX_MT_THREADS);

	if (prefetch==0) prefetch=1;
	if ((prefetch<0) || (prefetch>MAX_THREAD_POOL))
		env->ThrowError("ConvertLinearRGBtoYUV: [prefetch] must be between 0 and %d.",MAX_THREAD_POOL);

	uint8_t threads_number=1;

	if (threads!=1)
	{
		if (!poolInterface->CreatePool(prefetch)) env->ThrowError("ConvertLinearRGBtoYUV: Unable to create ThreadPool!");

		threads_number=poolInterface->GetThreadNumber(threads,LogicalCores);

		if (threads_number==0) env->ThrowError("ConvertLinearRGBtoYUV: Error with the TheadPool while getting CPU info!");

		if (threads_number>1)
		{
			if (prefetch>1)
			{
				if (SetAffinity && (prefetch<=poolInterface->GetPhysicalCoreNumber()))
				{
					float delta=(float)poolInterface->GetPhysicalCoreNumber()/(float)prefetch,Offset=0.0f;

					for(uint8_t i=0; i<prefetch; i++)
					{
						if (!poolInterface->AllocateThreads(threads_number,(uint8_t)ceil(Offset),0,MaxPhysCores,true,true,i))
						{
							poolInterface->DeAllocateAllThreads(true);
							env->ThrowError("ConvertLinearRGBtoYUV: Error with the TheadPool while allocating threadpool!");
						}
						Offset+=delta;
					}
				}
				else
				{
					if (!poolInterface->AllocateThreads(threads_number,0,0,MaxPhysCores,false,true,-1))
					{
						poolInterface->DeAllocateAllThreads(true);
						env->ThrowError("ConvertLinearRGBtoYUV: Error with the TheadPool while allocating threadpool!");
					}
				}
			}
			else
			{
				if (!poolInterface->AllocateThreads(threads_number,0,0,MaxPhysCores,SetAffinity,true,-1))
				{
					poolInterface->DeAllocateAllThreads(true);
					env->ThrowError("ConvertLinearRGBtoYUV: Error with the TheadPool while allocating threadpool!");
				}
			}
		}
	}

	return new ConvertLinearRGBtoYUV(args[0].AsClip(),Color,OutputMode,HLGMode,fullrange,mpeg2c,threads_number,sleep,env);
}


extern "C" __declspec(dllexport) const char* __stdcall AvisynthPluginInit3(IScriptEnvironment* env, const AVS_Linkage* const vectors)
{
	AVS_linkage = vectors;

	poolInterface=ThreadPoolInterface::Init(0);

	if (!poolInterface->GetThreadPoolInterfaceStatus()) env->ThrowError("ConvertYUVtoLinearRGB: Error with the TheadPool status!");

    env->AddFunction("ConvertYUVtoLinearRGB",
		"c[Color]i[OutputMode]i[HLGMode]b[fullrange]b[mpeg2c]b[threads]i[logicalCores]b[MaxPhysCore]b[SetAffinity]b[sleep]b[prefetch]i",
		Create_ConvertYUVtoLinearRGB, 0);

    return HDRTOOLS_VERSION;
}
