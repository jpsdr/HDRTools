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

#include "avisynth.h"
#include "ThreadPoolInterface.h"

#define HDRTOOLS_VERSION "HDRTools 0.1.0 JPSDR"
// Inspired from Neuron2 filter

#define Interlaced_Tab_Size 3

#define myfree(ptr) if (ptr!=NULL) { free(ptr); ptr=NULL;}
#define mydelete(ptr) if (ptr!=NULL) { delete ptr; ptr=NULL;}

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


typedef struct _MT_Data_Info_HDRTools
{
	void *src1,*src2,*src3;
	void *dst1,*dst2,*dst3;
	int src_pitch1,src_pitch2,src_pitch3;
	int dst_pitch1,dst_pitch2,dst_pitch3;
	int32_t src_Y_h_min,src_Y_h_max,src_Y_w;
	int32_t src_UV_h_min,src_UV_h_max,src_UV_w;
	int32_t dst_Y_h_min,dst_Y_h_max,dst_Y_w;
	int32_t dst_UV_h_min,dst_UV_h_max,dst_UV_w;
	bool top,bottom;
} MT_Data_Info_HDRTools;


class ConvertYUVtoRGBP : public GenericVideoFilter
{
public:
	ConvertYUVtoRGBP(PClip _child,int _Color,bool _Output16,bool _HLGMode,bool _mpeg2c,
		uint8_t _threads, bool _sleep, IScriptEnvironment* env);
	virtual ~ConvertYUVtoRGBP();
    PVideoFrame __stdcall GetFrame(int n, IScriptEnvironment* env);

	int __stdcall SetCacheHints(int cachehints, int frame_range);

private:
	int Color;
	bool Output16,HLGMode,mpeg2c,fullrange;
	bool sleep;
	uint16_t *lookup_Upscale8;
	uint32_t *lookup_Upscale16,*lookup_8to16;
	bool SSE2_Enable,AVX_Enable,AVX2_Enable;

	bool grey,avsp,isRGBPfamily,isAlphaChannel;
	uint8_t pixelsize; // AVS16
	uint8_t bits_per_pixel;

	VideoInfo *vi_422,*vi_444,*vi_original;

	Public_MT_Data_Thread MT_Thread[MAX_MT_THREADS];
	MT_Data_Info_HDRTools MT_Data[3][MAX_MT_THREADS];
	uint8_t threads,threads_number[3],max_threads;
	uint16_t UserId;
	
	ThreadPoolFunction StaticThreadpoolF;

	static void StaticThreadpool(void *ptr);

	void FreeData(void);
};


