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

#ifdef AVX2_BUILD_POSSIBLE
extern "C" void JPSDR_HDRTools_Convert420_to_Planar422_8_AVX2(const void *scr_1,const void *src_2,void *dst,int32_t w);
extern "C" void JPSDR_HDRTools_Convert420_to_Planar422_16_AVX2(const void *scr_1,const void *src_2,void *dst,int32_t w);
#endif

int __stdcall ConvertYUVtoRGBP::SetCacheHints(int cachehints,int frame_range)
{
  switch (cachehints)
  {
  case CACHE_GET_MTMODE :
    return MT_MULTI_INSTANCE;
  default :
    return 0;
  }
}


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
		int src_pitch,int dst_pitch)
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


static inline void Move_Full_8to16(const void *src_, void *dst_, const int32_t w,const int32_t h, int src_pitch,int dst_pitch)
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


static inline void Move_Full_8to16_SSE2(const void *src_, void *dst_, const int32_t w,const int32_t h, int src_pitch,int dst_pitch)
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


static inline void Move_Full_8to16_AVX(const void *src_, void *dst_, const int32_t w,const int32_t h, int src_pitch,int dst_pitch)
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
	const int src_pitch_Y=mt_data_inf.src_pitch1;
	const int src_pitch_U=mt_data_inf.src_pitch2;
	const int src_pitch_V=mt_data_inf.src_pitch3;
	const int dst_pitch_Y=mt_data_inf.dst_pitch1;
	const int dst_pitch_U=mt_data_inf.dst_pitch2;
	const int dst_pitch_V=mt_data_inf.dst_pitch3;

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
	const int src_pitch_Y=mt_data_inf.src_pitch1;
	const int src_pitch_U=mt_data_inf.src_pitch2;
	const int src_pitch_V=mt_data_inf.src_pitch3;
	const int dst_pitch_Y=mt_data_inf.dst_pitch1;
	const int dst_pitch_U=mt_data_inf.dst_pitch2;
	const int dst_pitch_V=mt_data_inf.dst_pitch3;

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
	const int src_pitch_Y=mt_data_inf.src_pitch1;
	const int src_pitch_U=mt_data_inf.src_pitch2;
	const int src_pitch_V=mt_data_inf.src_pitch3;
	const int dst_pitch_Y=mt_data_inf.dst_pitch1;
	const int dst_pitch_U=mt_data_inf.dst_pitch2;
	const int dst_pitch_V=mt_data_inf.dst_pitch3;

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
	const int src_pitch_Y=mt_data_inf.src_pitch1;
	const int src_pitch_U=mt_data_inf.src_pitch2;
	const int src_pitch_V=mt_data_inf.src_pitch3;
	const int dst_pitch_Y=mt_data_inf.dst_pitch1;
	const int dst_pitch_U=mt_data_inf.dst_pitch2;
	const int dst_pitch_V=mt_data_inf.dst_pitch3;

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
	const int src_pitch_Y=mt_data_inf.src_pitch1;
	const int src_pitch_U=mt_data_inf.src_pitch2;
	const int src_pitch_V=mt_data_inf.src_pitch3;
	const int dst_pitch_Y=mt_data_inf.dst_pitch1;
	const int dst_pitch_U=mt_data_inf.dst_pitch2;
	const int dst_pitch_V=mt_data_inf.dst_pitch3;

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
	const int src_pitch_Y=mt_data_inf.src_pitch1;
	const int src_pitch_U=mt_data_inf.src_pitch2;
	const int src_pitch_V=mt_data_inf.src_pitch3;
	const int dst_pitch_Y=mt_data_inf.dst_pitch1;
	const int dst_pitch_U=mt_data_inf.dst_pitch2;
	const int dst_pitch_V=mt_data_inf.dst_pitch3;

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
	const int src_pitch_Y=mt_data_inf.src_pitch1;
	const int src_pitch_U=mt_data_inf.src_pitch2;
	const int src_pitch_V=mt_data_inf.src_pitch3;
	const int dst_pitch_Y=mt_data_inf.dst_pitch1;
	const int dst_pitch_U=mt_data_inf.dst_pitch2;
	const int dst_pitch_V=mt_data_inf.dst_pitch3;

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
	const int src_pitch_Y=mt_data_inf.src_pitch1;
	const int src_pitch_U=mt_data_inf.src_pitch2;
	const int src_pitch_V=mt_data_inf.src_pitch3;
	const int dst_pitch_Y=mt_data_inf.dst_pitch1;
	const int dst_pitch_U=mt_data_inf.dst_pitch2;
	const int dst_pitch_V=mt_data_inf.dst_pitch3;

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
	const int src_pitch_Y=mt_data_inf.src_pitch1;
	const int src_pitch_U=mt_data_inf.src_pitch2;
	const int src_pitch_V=mt_data_inf.src_pitch3;
	const int dst_pitch_Y=mt_data_inf.dst_pitch1;
	const int dst_pitch_U=mt_data_inf.dst_pitch2;
	const int dst_pitch_V=mt_data_inf.dst_pitch3;

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
	const int src_pitch_Y=mt_data_inf.src_pitch1;
	const int src_pitch_U=mt_data_inf.src_pitch2;
	const int src_pitch_V=mt_data_inf.src_pitch3;
	const int dst_pitch_Y=mt_data_inf.dst_pitch1;
	const int dst_pitch_U=mt_data_inf.dst_pitch2;
	const int dst_pitch_V=mt_data_inf.dst_pitch3;

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
	const int src_pitch_Y=mt_data_inf.src_pitch1;
	const int src_pitch_U=mt_data_inf.src_pitch2;
	const int src_pitch_V=mt_data_inf.src_pitch3;
	const int dst_pitch_Y=mt_data_inf.dst_pitch1;
	const int dst_pitch_U=mt_data_inf.dst_pitch2;
	const int dst_pitch_V=mt_data_inf.dst_pitch3;

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
	const int src_pitch_Y=mt_data_inf.src_pitch1;
	const int src_pitch_U=mt_data_inf.src_pitch2;
	const int src_pitch_V=mt_data_inf.src_pitch3;
	const int dst_pitch_Y=mt_data_inf.dst_pitch1;
	const int dst_pitch_U=mt_data_inf.dst_pitch2;
	const int dst_pitch_V=mt_data_inf.dst_pitch3;

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
	const int src_pitch_Y=mt_data_inf.src_pitch1;
	const int src_pitch_U=mt_data_inf.src_pitch2;
	const int src_pitch_V=mt_data_inf.src_pitch3;
	const int dst_pitch_Y=mt_data_inf.dst_pitch1;
	const int dst_pitch_U=mt_data_inf.dst_pitch2;
	const int dst_pitch_V=mt_data_inf.dst_pitch3;

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
	const int src_pitch_Y=mt_data_inf.src_pitch1;
	const int src_pitch_U=mt_data_inf.src_pitch2;
	const int src_pitch_V=mt_data_inf.src_pitch3;
	const int dst_pitch_Y=mt_data_inf.dst_pitch1;
	const int dst_pitch_U=mt_data_inf.dst_pitch2;
	const int dst_pitch_V=mt_data_inf.dst_pitch3;

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
	const int src_pitch_Y=mt_data_inf.src_pitch1;
	const int src_pitch_U=mt_data_inf.src_pitch2;
	const int src_pitch_V=mt_data_inf.src_pitch3;
	const int dst_pitch_Y=mt_data_inf.dst_pitch1;
	const int dst_pitch_U=mt_data_inf.dst_pitch2;
	const int dst_pitch_V=mt_data_inf.dst_pitch3;

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
	const int src_pitch_Y=mt_data_inf.src_pitch1;
	const int src_pitch_U=mt_data_inf.src_pitch2;
	const int src_pitch_V=mt_data_inf.src_pitch3;
	const int dst_pitch_Y=mt_data_inf.dst_pitch1;
	const int dst_pitch_U=mt_data_inf.dst_pitch2;
	const int dst_pitch_V=mt_data_inf.dst_pitch3;

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
	const int src_pitch_Y=mt_data_inf.src_pitch1;
	const int src_pitch_U=mt_data_inf.src_pitch2;
	const int src_pitch_V=mt_data_inf.src_pitch3;
	const int dst_pitch_Y=mt_data_inf.dst_pitch1;
	const int dst_pitch_U=mt_data_inf.dst_pitch2;
	const int dst_pitch_V=mt_data_inf.dst_pitch3;

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
	const int src_pitch_Y=mt_data_inf.src_pitch1;
	const int src_pitch_U=mt_data_inf.src_pitch2;
	const int src_pitch_V=mt_data_inf.src_pitch3;
	const int dst_pitch_Y=mt_data_inf.dst_pitch1;
	const int dst_pitch_U=mt_data_inf.dst_pitch2;
	const int dst_pitch_V=mt_data_inf.dst_pitch3;

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
	const int src_pitch_Y=mt_data_inf.src_pitch1;
	const int src_pitch_U=mt_data_inf.src_pitch2;
	const int src_pitch_V=mt_data_inf.src_pitch3;
	const int dst_pitch_Y=mt_data_inf.dst_pitch1;
	const int dst_pitch_U=mt_data_inf.dst_pitch2;
	const int dst_pitch_V=mt_data_inf.dst_pitch3;

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
	const int src_pitch_Y=mt_data_inf.src_pitch1;
	const int src_pitch_U=mt_data_inf.src_pitch2;
	const int src_pitch_V=mt_data_inf.src_pitch3;
	const int dst_pitch_Y=mt_data_inf.dst_pitch1;
	const int dst_pitch_U=mt_data_inf.dst_pitch2;
	const int dst_pitch_V=mt_data_inf.dst_pitch3;

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


ConvertYUVtoRGBP::ConvertYUVtoRGBP(PClip _child,int _Color,bool _Output16,bool _HLGMode,bool _mpeg2c,
	uint8_t _threads,bool _sleep,IScriptEnvironment* env) :
	GenericVideoFilter(_child),Color(_Color),Output16(_Output16),HLGMode(_HLGMode),mpeg2c(_mpeg2c),
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

	vi_original=NULL; vi_422=NULL; vi_444=NULL;

	lookup_Upscale8=(uint16_t *)malloc(256*sizeof(uint16_t));
	lookup_8to16=(uint32_t *)malloc(256*sizeof(uint32_t));
	lookup_Upscale16=(uint32_t *)malloc(vmax*sizeof(uint32_t));

	if ((lookup_Upscale8==NULL) || (lookup_8to16==NULL) || (lookup_Upscale16==NULL))
	{
		FreeData();
		env->ThrowError("ConvertYUVtoRGBP: Error while allocating the lookup tables!");
	}

	vi_original = new VideoInfo(vi);
	vi_422 = new VideoInfo(vi);
	vi_444 = new VideoInfo(vi);

	if ((vi_original==NULL) || (vi_422==NULL) || (vi_444==NULL))
	{
		FreeData();
		env->ThrowError("ConvertYUVtoRGBP: Error while creating VideoInfo!");
	}

	if (pixelsize==1)
	{
		if (Output16)
		{
			vi_422->pixel_type=VideoInfo::CS_YUV422P16;
			vi_444->pixel_type=VideoInfo::CS_YUV444P16;
			vi.pixel_type=VideoInfo::CS_BGR64;
		}
		else
		{
			vi_422->pixel_type=VideoInfo::CS_YV16;
			vi_444->pixel_type=VideoInfo::CS_YV24;
			vi.pixel_type=VideoInfo::CS_BGR32;
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
		vi.pixel_type=VideoInfo::CS_BGR64;
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

	for (uint16_t i=0; i<256; i++)
	{
		lookup_Upscale8[i]=3*i+2;
		lookup_8to16[i]=((uint32_t)i) << 8;
	}

	if ((pixelsize==1) && Output16)
	{
		for (uint32_t i=0; i<256; i++)
			lookup_Upscale16[i]=3*(i << 8)+2;
	}
	else
	{
		for (uint32_t i=0; i<vmax; i++)
			lookup_Upscale16[i]=3*i+2;
	}

/*	SSE2_Enable=((env->GetCPUFlags()&CPUF_SSE2)!=0);
	AVX_Enable=((env->GetCPUFlags()&CPUF_AVX)!=0);
	AVX2_Enable=((env->GetCPUFlags()&CPUF_AVX2)!=0);*/
	SSE2_Enable=false;
	AVX_Enable=false;
	AVX2_Enable=false;

	if (max_threads>1)
	{
		if (!poolInterface->GetUserId(UserId))
		{
			poolInterface->DeAllocateAllThreads(true);
			FreeData();
			env->ThrowError("ConvertYUVtoRGBP: Error with the TheadPool while getting UserId!");
		}
	}
	vi.pixel_type=vi_444->pixel_type;
}


void ConvertYUVtoRGBP::FreeData(void) 
{
	mydelete(vi_444);
	mydelete(vi_422);
	mydelete(vi_original);
	myfree(lookup_Upscale16);
	myfree(lookup_8to16);
	myfree(lookup_Upscale8);
}


ConvertYUVtoRGBP::~ConvertYUVtoRGBP() 
{
	if (max_threads>1) poolInterface->RemoveUserId(UserId);
	if (threads>1) poolInterface->DeAllocateAllThreads(true);
	FreeData();
}


void ConvertYUVtoRGBP::StaticThreadpool(void *ptr)
{
	const Public_MT_Data_Thread *data=(const Public_MT_Data_Thread *)ptr;
	ConvertYUVtoRGBP *ptrClass=(ConvertYUVtoRGBP *)data->pClass;
	
	switch(data->f_process)
	{
		case 1 : Convert_Progressive_8_YV12toYV16(ptrClass->MT_Data[0][data->thread_Id],ptrClass->lookup_Upscale8);
			break;
		case 2 : Convert_Progressive_8_YV12toYV16_SSE2(ptrClass->MT_Data[0][data->thread_Id]);
			break;
		case 3 : Convert_Progressive_8_YV12toYV16_AVX(ptrClass->MT_Data[0][data->thread_Id]);
			break;
		case 5 : Convert_Progressive_8to16_YV12toYV16(ptrClass->MT_Data[0][data->thread_Id],ptrClass->lookup_Upscale16,
					 ptrClass->lookup_8to16);
			break;
		case 6 : Convert_Progressive_8to16_YV12toYV16_SSE2(ptrClass->MT_Data[0][data->thread_Id],ptrClass->lookup_Upscale16,
					 ptrClass->lookup_8to16);
			break;
		case 7 : Convert_Progressive_8to16_YV12toYV16_AVX(ptrClass->MT_Data[0][data->thread_Id],ptrClass->lookup_Upscale16,
					 ptrClass->lookup_8to16);
			break;
		case 8 : Convert_Progressive_16_YV12toYV16(ptrClass->MT_Data[0][data->thread_Id],ptrClass->lookup_Upscale16);
			break;
		case 9 : Convert_Progressive_16_YV12toYV16_SSE2(ptrClass->MT_Data[0][data->thread_Id]);
			break;
		case 10 : Convert_Progressive_16_YV12toYV16_AVX(ptrClass->MT_Data[0][data->thread_Id]);
			break;
		case 12 : Convert_8_YV16toYV24(ptrClass->MT_Data[1][data->thread_Id]);
			break;
		case 13 : Convert_8_YV16toYV24_SSE2(ptrClass->MT_Data[1][data->thread_Id]);
			break;
		case 14 : Convert_8_YV16toYV24_AVX(ptrClass->MT_Data[1][data->thread_Id]);
			break;
		case 15 : Convert_8to16_YV16toYV24(ptrClass->MT_Data[1][data->thread_Id],ptrClass->lookup_8to16);
			break;
		case 16 : Convert_8to16_YV16toYV24_SSE2(ptrClass->MT_Data[1][data->thread_Id],ptrClass->lookup_8to16);
			break;
		case 17 : Convert_8to16_YV16toYV24_AVX(ptrClass->MT_Data[1][data->thread_Id],ptrClass->lookup_8to16);
			break;
		case 18 : Convert_16_YV16toYV24(ptrClass->MT_Data[1][data->thread_Id]);
			break;
		case 19 : Convert_16_YV16toYV24_SSE2(ptrClass->MT_Data[1][data->thread_Id]);
			break;
		case 20 : Convert_16_YV16toYV24_AVX(ptrClass->MT_Data[1][data->thread_Id]);
			break;
#ifdef AVX2_BUILD_POSSIBLE
		case 4 : Convert_Progressive_8_YV12toYV16_AVX2(ptrClass->MT_Data[0][data->thread_Id]);
			break;
		case 11 : Convert_Progressive_16_YV12toYV16_AVX2(ptrClass->MT_Data[0][data->thread_Id]);
			break;
#endif
		default : ;
	}
}


PVideoFrame __stdcall ConvertYUVtoRGBP::GetFrame(int n, IScriptEnvironment* env) 
{
	PVideoFrame src = child->GetFrame(n,env);
	PVideoFrame tmp1 = env->NewVideoFrame(*vi_422,64);
	//PVideoFrame tmp2 = env->NewVideoFrame(*vi_444,64);
	PVideoFrame tmp2 = env->NewVideoFrame(vi,64);
	PVideoFrame dst = env->NewVideoFrame(vi,64);

	const uint8_t *srcY = src->GetReadPtr(PLANAR_Y);
	const uint8_t *srcU = src->GetReadPtr(PLANAR_U);
	const uint8_t *srcV = src->GetReadPtr(PLANAR_V);
/*	const int src_h = src->GetHeight(PLANAR_Y);
	const int src_w = (pixelsize==1) ? src->GetRowSize(PLANAR_Y):src->GetRowSize(PLANAR_Y) >> 1;*/
	const int src_pitch_Y = src->GetPitch(PLANAR_Y);
	const int src_pitch_U = src->GetPitch(PLANAR_U);
	const int src_pitch_V = src->GetPitch(PLANAR_V);

	const uint8_t *tmp1Yr = tmp1->GetReadPtr(PLANAR_Y);
	const uint8_t *tmp1Ur = tmp1->GetReadPtr(PLANAR_U);
	const uint8_t *tmp1Vr = tmp1->GetReadPtr(PLANAR_V);
	uint8_t *tmp1Yw = tmp1->GetWritePtr(PLANAR_Y);
	uint8_t *tmp1Uw = tmp1->GetWritePtr(PLANAR_U);
	uint8_t *tmp1Vw = tmp1->GetWritePtr(PLANAR_V);
	const int tmp1_pitch_Y = tmp1->GetPitch(PLANAR_Y);
	const int tmp1_pitch_U = tmp1->GetPitch(PLANAR_U);
	const int tmp1_pitch_V = tmp1->GetPitch(PLANAR_V);

	const uint8_t *tmp2Yr = tmp2->GetReadPtr(PLANAR_Y);
	const uint8_t *tmp2Ur = tmp2->GetReadPtr(PLANAR_U);
	const uint8_t *tmp2Vr = tmp2->GetReadPtr(PLANAR_V);
	uint8_t *tmp2Yw = tmp2->GetWritePtr(PLANAR_Y);
	uint8_t *tmp2Uw = tmp2->GetWritePtr(PLANAR_U);
	uint8_t *tmp2Vw = tmp2->GetWritePtr(PLANAR_V);
	const int tmp2_pitch_Y = tmp2->GetPitch(PLANAR_Y);
	const int tmp2_pitch_U = tmp2->GetPitch(PLANAR_U);
	const int tmp2_pitch_V = tmp2->GetPitch(PLANAR_V);

	const uint8_t *dstYr = dst->GetReadPtr(PLANAR_Y);
	const uint8_t *dstUr = dst->GetReadPtr(PLANAR_U);
	const uint8_t *dstVr = dst->GetReadPtr(PLANAR_V);
	uint8_t *dstYw = dst->GetWritePtr(PLANAR_Y);
	uint8_t *dstUw = dst->GetWritePtr(PLANAR_U);
	uint8_t *dstVw = dst->GetWritePtr(PLANAR_V);
	const int dst_pitch_Y = dst->GetPitch(PLANAR_Y);
	const int dst_pitch_U = dst->GetPitch(PLANAR_U);
	const int dst_pitch_V = dst->GetPitch(PLANAR_V);

	uint8_t f_proc;
		
	if (max_threads>1)
	{
		if (!poolInterface->RequestThreadPool(UserId,max_threads,MT_Thread,-1,false))
			env->ThrowError("AutoYUY2: Error with the TheadPool while requesting threadpool !");
	}

	/*
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

	const bool dst_Y_al32=((((size_t)dstYw) & 0x1F)==0) && ((((size_t)dstYr) & 0x1F)==0)
		&& ((abs(dst_pitch_Y) & 0x1F)==0);
	const bool dst_Y_al16=((((size_t)dstYw) & 0x0F)==0) && ((((size_t)dstYr) & 0x0F)==0)
		&& ((abs(dst_pitch_Y) & 0x0F)==0);
	const bool dst_UV_al32=((((size_t)dstUw) & 0x1F)==0) && ((((size_t)dstVw) & 0x1F)==0)
		&& ((((size_t)dstUr) & 0x1F)==0) && ((((size_t)dstVr) & 0x1F)==0)
		&& ((abs(dst_pitch_U) & 0x1F)==0) && ((abs(dst_pitch_V) & 0x1F)==0);
	const bool dst_UV_al16=((((size_t)dstUw) & 0x0F)==0) && ((((size_t)dstVw) & 0x0F)==0)
		&& ((((size_t)dstUr) & 0x0F)==0) && ((((size_t)dstVr) & 0x0F)==0)
		&& ((abs(dst_pitch_U) & 0x0F)==0) && ((abs(dst_pitch_V) & 0x0F)==0);*/

	const bool src_Y_al32=true;
	const bool src_Y_al16=true;
	const bool src_UV_al32=true;
	const bool src_UV_al16=true;

	const bool tmp1_Y_al32=true;
	const bool tmp1_Y_al16=true;
	const bool tmp1_UV_al32=true;
	const bool tmp1_UV_al16=true;

	const bool tmp2_Y_al32=true;
	const bool tmp2_Y_al16=true;
	const bool tmp2_UV_al32=true;
	const bool tmp2_UV_al16=true;

	const bool dst_Y_al32=true;
	const bool dst_Y_al16=true;
	const bool dst_UV_al32=true;
	const bool dst_UV_al16=true;

/*
	for(uint8_t j=0; j<3; j++)
	{
		for(uint8_t i=0; i<threads_number[j]; i++)
		{
			MT_Data[j][i].src1=(void *)(srcY+(MT_Data[j][i].src_Y_h_min*src_pitch_Y));
			MT_Data[j][i].src2=(void *)(srcU+(MT_Data[j][i].src_UV_h_min*src_pitch_U));
			MT_Data[j][i].src3=(void *)(srcV+(MT_Data[j][i].src_UV_h_min*src_pitch_V));
			MT_Data[j][i].src_pitch1=src_pitch_Y;
			MT_Data[j][i].src_pitch2=src_pitch_U;
			MT_Data[j][i].src_pitch3=src_pitch_V;
			MT_Data[j][i].dst1=(void *)(dst_Y+(MT_Data[j][i].dst_Y_h_min*dst_pitch_Y));
			MT_Data[j][i].dst2=(void *)(dst_U+(MT_Data[j][i].dst_UV_h_min*dst_pitch_U));
			MT_Data[j][i].dst3=(void *)(dst_V+(MT_Data[j][i].dst_UV_h_min*dst_pitch_V));
			MT_Data[j][i].dst_pitch1=dst_pitch_Y;
			MT_Data[j][i].dst_pitch2=dst_pitch_U;
			MT_Data[j][i].dst_pitch3=dst_pitch_V;
		}
	}*/

	// Process 420 to 422 upscale
	if (vi_original->Is420())
	{
		for(uint8_t i=0; i<threads_number[0]; i++)
		{
			MT_Data[0][i].src1=(void *)(srcY+(MT_Data[0][i].src_Y_h_min*src_pitch_Y));
			MT_Data[0][i].src2=(void *)(srcU+(MT_Data[0][i].src_UV_h_min*src_pitch_U));
			MT_Data[0][i].src3=(void *)(srcV+(MT_Data[0][i].src_UV_h_min*src_pitch_V));
			MT_Data[0][i].src_pitch1=src_pitch_Y;
			MT_Data[0][i].src_pitch2=src_pitch_U;
			MT_Data[0][i].src_pitch3=src_pitch_V;
			MT_Data[0][i].dst1=(void *)(tmp1Yw+(MT_Data[0][i].dst_Y_h_min*tmp1_pitch_Y));
			MT_Data[0][i].dst2=(void *)(tmp1Uw+(MT_Data[0][i].dst_UV_h_min*tmp1_pitch_U));
			MT_Data[0][i].dst3=(void *)(tmp1Vw+(MT_Data[0][i].dst_UV_h_min*tmp1_pitch_V));
			MT_Data[0][i].dst_pitch1=tmp1_pitch_Y;
			MT_Data[0][i].dst_pitch2=tmp1_pitch_U;
			MT_Data[0][i].dst_pitch3=tmp1_pitch_V;
		}

		if (pixelsize==1)
		{
			if (Output16)
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
				MT_Thread[i].f_process=f_proc;
			if (poolInterface->StartThreads(UserId)) poolInterface->WaitThreadsEnd(UserId);

			for(uint8_t i=0; i<threads_number[0]; i++)
				MT_Thread[i].f_process=0;
		}
		else
		{
			switch(f_proc)
			{
				case 1 : Convert_Progressive_8_YV12toYV16(MT_Data[0][0],lookup_Upscale8); break;
				case 2 : Convert_Progressive_8_YV12toYV16_SSE2(MT_Data[0][0]); break;
				case 3 : Convert_Progressive_8_YV12toYV16_AVX(MT_Data[0][0]); break;
				case 5 : Convert_Progressive_8to16_YV12toYV16(MT_Data[0][0],lookup_Upscale16,lookup_8to16); break;
				case 6 : Convert_Progressive_8to16_YV12toYV16_SSE2(MT_Data[0][0],lookup_Upscale16,lookup_8to16); break;
				case 7 : Convert_Progressive_8to16_YV12toYV16_AVX(MT_Data[0][0],lookup_Upscale16,lookup_8to16); break;
				case 8 : Convert_Progressive_16_YV12toYV16(MT_Data[0][0],lookup_Upscale16); break;
				case 9 : Convert_Progressive_16_YV12toYV16_SSE2(MT_Data[0][0]); break;
				case 10 : Convert_Progressive_16_YV12toYV16_AVX(MT_Data[0][0]); break;
#ifdef AVX2_BUILD_POSSIBLE
				case 4 : Convert_Progressive_8_YV12toYV16_AVX2(MT_Data[0][0]); break;
				case 11 : Convert_Progressive_16_YV12toYV16_AVX2(MT_Data[0][0]); break;
#endif
				default : break;
			}
		}
	}

	// Process 422 to 444 upscale
	if (vi_original->Is422())
	{
		for(uint8_t i=0; i<threads_number[1]; i++)
		{
			MT_Data[1][i].src1=(void *)(srcY+(MT_Data[1][i].src_Y_h_min*src_pitch_Y));
			MT_Data[1][i].src2=(void *)(srcU+(MT_Data[1][i].src_UV_h_min*src_pitch_U));
			MT_Data[1][i].src3=(void *)(srcV+(MT_Data[1][i].src_UV_h_min*src_pitch_V));
			MT_Data[1][i].src_pitch1=src_pitch_Y;
			MT_Data[1][i].src_pitch2=src_pitch_U;
			MT_Data[1][i].src_pitch3=src_pitch_V;
			MT_Data[1][i].dst1=(void *)(tmp2Yw+(MT_Data[1][i].dst_Y_h_min*tmp2_pitch_Y));
			MT_Data[1][i].dst2=(void *)(tmp2Uw+(MT_Data[1][i].dst_UV_h_min*tmp2_pitch_U));
			MT_Data[1][i].dst3=(void *)(tmp2Vw+(MT_Data[1][i].dst_UV_h_min*tmp2_pitch_V));
			MT_Data[1][i].dst_pitch1=tmp2_pitch_Y;
			MT_Data[1][i].dst_pitch2=tmp2_pitch_U;
			MT_Data[1][i].dst_pitch3=tmp2_pitch_V;
		}

		if (pixelsize==1)
		{
			if (Output16)
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
			MT_Data[1][i].src1=(void *)(tmp1Yr+(MT_Data[1][i].src_Y_h_min*tmp1_pitch_Y));
			MT_Data[1][i].src2=(void *)(tmp1Ur+(MT_Data[1][i].src_UV_h_min*tmp1_pitch_U));
			MT_Data[1][i].src3=(void *)(tmp1Vr+(MT_Data[1][i].src_UV_h_min*tmp1_pitch_V));
			MT_Data[1][i].src_pitch1=tmp1_pitch_Y;
			MT_Data[1][i].src_pitch2=tmp1_pitch_U;
			MT_Data[1][i].src_pitch3=tmp1_pitch_V;
			MT_Data[1][i].dst1=(void *)(tmp2Yw+(MT_Data[1][i].dst_Y_h_min*tmp2_pitch_Y));
			MT_Data[1][i].dst2=(void *)(tmp2Uw+(MT_Data[1][i].dst_UV_h_min*tmp2_pitch_U));
			MT_Data[1][i].dst3=(void *)(tmp2Vw+(MT_Data[1][i].dst_UV_h_min*tmp2_pitch_V));
			MT_Data[1][i].dst_pitch1=tmp2_pitch_Y;
			MT_Data[1][i].dst_pitch2=tmp2_pitch_U;
			MT_Data[1][i].dst_pitch3=tmp2_pitch_V;
		}

		if (pixelsize==1)
		{
			if (Output16)
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
				MT_Thread[i].f_process=f_proc;
			if (poolInterface->StartThreads(UserId)) poolInterface->WaitThreadsEnd(UserId);

			for(uint8_t i=0; i<threads_number[1]; i++)
				MT_Thread[i].f_process=0;
		}
		else
		{
			switch(f_proc)
			{
				case 12 : Convert_8_YV16toYV24(MT_Data[1][0]); break;
				case 13 : Convert_8_YV16toYV24_SSE2(MT_Data[1][0]); break;
				case 14 : Convert_8_YV16toYV24_AVX(MT_Data[1][0]); break;
				case 15 : Convert_8to16_YV16toYV24(MT_Data[1][0],lookup_8to16); break;
				case 16 : Convert_8to16_YV16toYV24_SSE2(MT_Data[1][0],lookup_8to16); break;
				case 17 : Convert_8to16_YV16toYV24_AVX(MT_Data[1][0],lookup_8to16); break;
				case 18 : Convert_16_YV16toYV24(MT_Data[1][0]); break;
				case 19 : Convert_16_YV16toYV24_SSE2(MT_Data[1][0]); break;
				case 20 : Convert_16_YV16toYV24_AVX(MT_Data[1][0]); break;
				default : break;
			}
		}
	}

	if (max_threads>1) poolInterface->ReleaseThreadPool(UserId,sleep);

	//return dst;
	return tmp2;
}


const AVS_Linkage *AVS_linkage = nullptr;


/*
  Chroma : int, default value : 0
     0 : BT2100
	 1 : BT2020
	 2 : BT709
	 3 : BT601
  Output16 : bool, default false.
  HLGMode : bool, default false.
*/
AVSValue __cdecl Create_ConvertYUVtoRGBP(AVSValue args, void* user_data, IScriptEnvironment* env)
{
	if (!args[0].IsClip()) env->ThrowError("ConvertYUVtoRGBP: arg 0 must be a clip !");

	VideoInfo vi = args[0].AsClip()->GetVideoInfo();

	if (!vi.IsPlanar() || !vi.IsYUV())
		env->ThrowError("ConvertYUVtoRGBP: Input format must be planar YUV");

	const int Color=args[1].AsInt(0);
	bool Output16=args[2].AsBool(false);
	const bool HLGMode=args[3].AsBool(false);
	const bool fullrange=args[4].AsBool(true);
	const bool mpeg2c=args[5].AsBool(true);
	const int threads=args[6].AsInt(0);
	const bool LogicalCores=args[7].AsBool(true);
	const bool MaxPhysCores=args[8].AsBool(true);
	const bool SetAffinity=args[9].AsBool(false);
	const bool sleep = args[10].AsBool(false);
	int prefetch=args[11].AsInt(0);

	const bool avsp=env->FunctionExists("ConvertBits");

	if (!avsp) Output16=false;

	if ((Color<0) || (Color>3))
		env->ThrowError("ConvertYUVtoRGBP: [Color] must be 0 (BT2100), 1 (BT2020), 2 (BT709), 3 (BT601)");
	if ((threads<0) || (threads>MAX_MT_THREADS))
		env->ThrowError("ConvertYUVtoRGBP: [threads] must be between 0 and %ld.",MAX_MT_THREADS);

	if (prefetch==0) prefetch=1;
	if ((prefetch<0) || (prefetch>MAX_THREAD_POOL))
		env->ThrowError("ConvertYUVtoRGBP: [prefetch] must be between 0 and %d.",MAX_THREAD_POOL);

	uint8_t threads_number=1;

	if (threads!=1)
	{
		if (!poolInterface->CreatePool(prefetch)) env->ThrowError("ConvertYUVtoRGBP: Unable to create ThreadPool!");

		threads_number=poolInterface->GetThreadNumber(threads,LogicalCores);

		if (threads_number==0) env->ThrowError("ConvertYUVtoRGBP: Error with the TheadPool while getting CPU info!");

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
							env->ThrowError("ConvertYUVtoRGBP: Error with the TheadPool while allocating threadpool!");
						}
						Offset+=delta;
					}
				}
				else
				{
					if (!poolInterface->AllocateThreads(threads_number,0,0,MaxPhysCores,false,true,-1))
					{
						poolInterface->DeAllocateAllThreads(true);
						env->ThrowError("ConvertYUVtoRGBP: Error with the TheadPool while allocating threadpool!");
					}
				}
			}
			else
			{
				if (!poolInterface->AllocateThreads(threads_number,0,0,MaxPhysCores,SetAffinity,true,-1))
				{
					poolInterface->DeAllocateAllThreads(true);
					env->ThrowError("ConvertYUVtoRGBP: Error with the TheadPool while allocating threadpool!");
				}
			}
		}
	}

	return new ConvertYUVtoRGBP(args[0].AsClip(),Color,Output16,HLGMode,mpeg2c,threads_number,sleep,env);
}

extern "C" __declspec(dllexport) const char* __stdcall AvisynthPluginInit3(IScriptEnvironment* env, const AVS_Linkage* const vectors)
{
	AVS_linkage = vectors;

	poolInterface=ThreadPoolInterface::Init(0);

	if (!poolInterface->GetThreadPoolInterfaceStatus()) env->ThrowError("AutoYUY2: Error with the TheadPool status!");

    env->AddFunction("ConvertYUVtoRGBP",
		"c[Color]i[Output16]b[HLGMode]b[fullrange]b[mpeg2c]b[threads]i[logicalCores]b[MaxPhysCore]b[SetAffinity]b[sleep]b[prefetch]i",
		Create_ConvertYUVtoRGBP, 0);

    return HDRTOOLS_VERSION;
}
