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

#define HDRTOOLS_VERSION "HDRTools 0.3.0 JPSDR"


typedef struct _dataLookUp
{
	uint16_t Min_Y,Max_Y,Min_U,Max_U,Min_V,Max_V;
	int32_t Offset_Y,Offset_U,Offset_V,Offset_R,Offset_G,Offset_B;
	double Coeff_Y,Coeff_U,Coeff_V;
} dataLookUp;

typedef struct _MT_Data_Info_HDRTools
{
	void *src1,*src2,*src3,*src4;
	void *dst1,*dst2,*dst3,*dst4;
	ptrdiff_t src_pitch1,src_pitch2,src_pitch3,src_pitch4;
	ptrdiff_t dst_pitch1,dst_pitch2,dst_pitch3,dst_pitch4;
	ptrdiff_t src_modulo1,src_modulo2,src_modulo3,src_modulo4;
	ptrdiff_t dst_modulo1,dst_modulo2,dst_modulo3,dst_modulo4;
	int32_t src_Y_h_min,src_Y_h_max,src_Y_w;
	int32_t src_UV_h_min,src_UV_h_max,src_UV_w;
	int32_t dst_Y_h_min,dst_Y_h_max,dst_Y_w;
	int32_t dst_UV_h_min,dst_UV_h_max,dst_UV_w;
	bool top,bottom;
	bool moveY8to16;
} MT_Data_Info_HDRTools;


class ConvertYUVtoLinearRGB : public GenericVideoFilter
{
public:
	ConvertYUVtoLinearRGB(PClip _child,uint8_t _Color,uint8_t _OutputMode,uint8_t _HDRMode,double _HLG_Lb,double _HLG_Lw,
		uint8_t _HLGColor,bool _OOTF,bool _EOTF,bool _fullrange,bool _mpeg2c,uint8_t _threads, bool _sleep, IScriptEnvironment* env);
	virtual ~ConvertYUVtoLinearRGB();
    PVideoFrame __stdcall GetFrame(int n, IScriptEnvironment* env);

	int __stdcall SetCacheHints(int cachehints, int frame_range);

private:
	uint8_t Color,OutputMode,HDRMode,HLGColor;
	bool OOTF,mpeg2c,fullrange,EOTF;
	bool sleep,HLG_Mode;
	double HLG_Lb,HLG_Lw;
	uint16_t *lookup_Upscale8;
	uint32_t *lookup_Upscale16,*lookup_8to16;
	int16_t *lookupRGB_8,*lookupHLG_RGB_8;
	int32_t *lookupRGB_16,*lookupHLG_RGB_16;
	uint8_t *lookupL_8;
	uint16_t *lookupL_16;
	float *lookupL_32,*lookupHLG_Y;
	void *lookupHLG_OOTF;
	bool SSE2_Enable,SSE41_Enable,AVX_Enable,AVX2_Enable;



	bool grey,avsp,isRGBPfamily,isAlphaChannel;
	uint8_t pixelsize; // AVS16
	uint8_t bits_per_pixel;

	VideoInfo *vi_original,*vi_422,*vi_444,*vi_RGB64,*vi_PlaneY_HLG;

	dataLookUp dl;

	Public_MT_Data_Thread MT_Thread[MAX_MT_THREADS];
	MT_Data_Info_HDRTools MT_Data[3][MAX_MT_THREADS];
	uint8_t threads,threads_number[3],max_threads;
	uint16_t UserId;
	
	ThreadPoolFunction StaticThreadpoolF;

	static void StaticThreadpool(void *ptr);

	void FreeData(void);
};


class ConvertYUVtoXYZ : public GenericVideoFilter
{
public:
	ConvertYUVtoXYZ(PClip _child,uint8_t _Color,uint8_t _OutputMode,uint8_t _HDRMode,double _HLG_Lb,double _HLG_Lw,
		uint8_t _HLGColor,bool _OOTF,bool _EOTF,bool _fullrange,bool _mpeg2c,float _Rx,float _Ry,float _Gx,float _Gy,
		float _Bx,float _By,float _Wx,float _Wy,uint8_t _threads, bool _sleep, IScriptEnvironment* env);
	virtual ~ConvertYUVtoXYZ();
    PVideoFrame __stdcall GetFrame(int n, IScriptEnvironment* env);

	int __stdcall SetCacheHints(int cachehints, int frame_range);

private:
	uint8_t Color,OutputMode,HDRMode,HLGColor;
	bool OOTF,mpeg2c,fullrange,EOTF;
	float Rx,Ry,Gx,Gy,Bx,By,Wx,Wy;
	bool sleep;
	double HLG_Lb,HLG_Lw;
	uint16_t *lookup_Upscale8;
	uint32_t *lookup_Upscale16,*lookup_8to16;
	int16_t *lookupRGB_8,*lookupXYZ_8;
	int32_t *lookupRGB_16,*lookupXYZ_16;
	uint8_t *lookupL_8;
	uint16_t *lookupL_16;
	float *lookupL_32;
	float Coeff_XYZ[9],*Coeff_XYZ_asm;
	bool SSE2_Enable,SSE41_Enable,AVX_Enable,AVX2_Enable;

	bool grey,avsp,isRGBPfamily,isAlphaChannel;
	uint8_t pixelsize; // AVS16
	uint8_t bits_per_pixel;

	VideoInfo *vi_original,*vi_422,*vi_444,*vi_RGB64,*vi_PlaneY_HLG;

	dataLookUp dl;

	Public_MT_Data_Thread MT_Thread[MAX_MT_THREADS];
	MT_Data_Info_HDRTools MT_Data[3][MAX_MT_THREADS];
	uint8_t threads,threads_number[3],max_threads;
	uint16_t UserId;
	
	ThreadPoolFunction StaticThreadpoolF;

	static void StaticThreadpool(void *ptr);

	void FreeData(void);
};


class ConvertRGBtoXYZ : public GenericVideoFilter
{
public:
	ConvertRGBtoXYZ(PClip _child,uint8_t _Color,uint8_t _OutputMode,uint8_t _HDRMode,double _HLG_Lb,double _HLG_Lw,
		uint8_t _HLGColor,bool _OOTF,bool _EOTF,bool _fastmode,float _Rx,float _Ry,float _Gx,float _Gy,float _Bx,float _By,
		float _Wx,float _Wy,uint8_t _threads, bool _sleep, IScriptEnvironment* env);
	virtual ~ConvertRGBtoXYZ();
    PVideoFrame __stdcall GetFrame(int n, IScriptEnvironment* env);

	int __stdcall SetCacheHints(int cachehints, int frame_range);

private:
	uint8_t Color,OutputMode,HDRMode,HLGColor;
	bool OOTF,EOTF,fastmode;
	float Rx,Ry,Gx,Gy,Bx,By,Wx,Wy;
	bool sleep;
	double HLG_Lb,HLG_Lw;
	int16_t *lookupXYZ_8;
	int32_t *lookupXYZ_16;
	uint8_t *lookupL_8;
	uint16_t *lookupL_16,*lookupL_8to16;
	float *lookupL_32,*lookupL_8to32,*lookupL_20;
	float Coeff_XYZ[9],*Coeff_XYZ_asm;
	bool SSE2_Enable,SSE41_Enable,AVX_Enable,AVX2_Enable;

	VideoInfo *vi_PlaneY_HLG;

	bool grey,avsp,isRGBPfamily,isAlphaChannel;
	uint8_t pixelsize; // AVS16
	uint8_t bits_per_pixel;

	Public_MT_Data_Thread MT_Thread[MAX_MT_THREADS];
	MT_Data_Info_HDRTools MT_Data[MAX_MT_THREADS];
	uint8_t threads,threads_number;
	uint16_t UserId;
	
	ThreadPoolFunction StaticThreadpoolF;

	static void StaticThreadpool(void *ptr);

	void FreeData(void);
};


class ConvertLinearRGBtoYUV : public GenericVideoFilter
{
public:
	ConvertLinearRGBtoYUV(PClip _child,uint8_t _Color,uint8_t _OutputMode,uint8_t _HDRMode,double _HLG_Lb,double _HLG_Lw,
		uint8_t _HLGColor,bool _OOTF,bool _EOTF,bool _fullrange,bool _mpeg2c,bool _fastmode,uint8_t _threads, bool _sleep,
		IScriptEnvironment* env);
	virtual ~ConvertLinearRGBtoYUV();
    PVideoFrame __stdcall GetFrame(int n, IScriptEnvironment* env);

	int __stdcall SetCacheHints(int cachehints, int frame_range);

private:
	uint8_t Color,OutputMode,HDRMode,HLGColor;
	bool OOTF,mpeg2c,fullrange,fastmode,EOTF;
	bool sleep;
	double HLG_Lb,HLG_Lw;
	int16_t *lookupRGB_8;
	int32_t *lookupRGB_16;
	uint8_t *lookupL_8;
	uint16_t *lookupL_16,*lookupL_20;
	bool SSE2_Enable,SSE41_Enable,AVX_Enable,AVX2_Enable;

	bool grey,avsp,isRGBPfamily,isAlphaChannel;
	uint8_t pixelsize; // AVS16
	uint8_t bits_per_pixel;

	VideoInfo *vi_original,*vi_420,*vi_422,*vi_444,*vi_RGB32,*vi_RGB64,*vi_PlaneY_HLG;

	dataLookUp dl;

	Public_MT_Data_Thread MT_Thread[MAX_MT_THREADS];
	MT_Data_Info_HDRTools MT_Data[3][MAX_MT_THREADS];
	uint8_t threads,threads_number[3],max_threads;
	uint16_t UserId;
	
	ThreadPoolFunction StaticThreadpoolF;

	static void StaticThreadpool(void *ptr);

	void FreeData(void);
};


class ConvertXYZtoYUV : public GenericVideoFilter
{
public:
	ConvertXYZtoYUV(PClip _child,uint8_t _Color,uint8_t _OutputMode,uint8_t _HDRMode,double _HLG_Lb,double _HLG_Lw,
		uint8_t _HLGColor,bool _OOTF,bool _EOTF,bool _fullrange,bool _mpeg2c,bool _fastmode,float _Rx,float _Ry,
		float _Gx,float _Gy,float _Bx,float _By,float _Wx,float _Wy,float _pRx,float _pRy,float _pGx,float _pGy,
		float _pBx,float _pBy,float _pWx,float _pWy,uint8_t _threads, bool _sleep,IScriptEnvironment* env);
	virtual ~ConvertXYZtoYUV();
    PVideoFrame __stdcall GetFrame(int n, IScriptEnvironment* env);

	int __stdcall SetCacheHints(int cachehints, int frame_range);

private:
	uint8_t Color,OutputMode,HDRMode,HLGColor;
	bool OOTF,mpeg2c,fullrange,fastmode,EOTF;
	float Rx,Ry,Gx,Gy,Bx,By,Wx,Wy;
	float pRx,pRy,pGx,pGy,pBx,pBy,pWx,pWy;
	bool sleep;
	double HLG_Lb,HLG_Lw;
	int16_t *lookupRGB_8,*lookupXYZ_8;
	int32_t *lookupRGB_16,*lookupXYZ_16;
	uint8_t *lookupL_8;
	uint16_t *lookupL_16,*lookupL_20;
	float Coeff_XYZ[9],*Coeff_XYZ_asm;
	bool SSE2_Enable,SSE41_Enable,AVX_Enable,AVX2_Enable;

	bool grey,avsp,isRGBPfamily,isAlphaChannel;
	uint8_t pixelsize; // AVS16
	uint8_t bits_per_pixel;

	VideoInfo *vi_original,*vi_420,*vi_422,*vi_444,*vi_RGB32,*vi_RGB64,*vi_PlaneY_HLG;

	dataLookUp dl;

	Public_MT_Data_Thread MT_Thread[MAX_MT_THREADS];
	MT_Data_Info_HDRTools MT_Data[3][MAX_MT_THREADS];
	uint8_t threads,threads_number[3],max_threads;
	uint16_t UserId;
	
	ThreadPoolFunction StaticThreadpoolF;

	static void StaticThreadpool(void *ptr);

	void FreeData(void);
};


class ConvertXYZtoRGB : public GenericVideoFilter
{
public:
	ConvertXYZtoRGB(PClip _child,uint8_t _Color,uint8_t _OutputMode,uint8_t _HDRMode,double _HLG_Lb,double _HLG_Lw,
		uint8_t _HLGColor,bool _OOTF,bool _EOTF,bool _fastmode,float _Rx,float _Ry,float _Gx,float _Gy,
		float _Bx,float _By,float _Wx,float _Wy,float _pRx,float _pRy,float _pGx,float _pGy,
		float _pBx,float _pBy,float _pWx,float _pWy,uint8_t _threads, bool _sleep,IScriptEnvironment* env);
	virtual ~ConvertXYZtoRGB();
    PVideoFrame __stdcall GetFrame(int n, IScriptEnvironment* env);

	int __stdcall SetCacheHints(int cachehints, int frame_range);

private:
	uint8_t Color,OutputMode,HDRMode,HLGColor;
	bool OOTF,fastmode,EOTF;
	float Rx,Ry,Gx,Gy,Bx,By,Wx,Wy;
	float pRx,pRy,pGx,pGy,pBx,pBy,pWx,pWy;
	bool sleep;
	double HLG_Lb,HLG_Lw;
	int16_t *lookupXYZ_8;
	int32_t *lookupXYZ_16;
	uint8_t *lookupL_8;
	uint16_t *lookupL_16,*lookupL_20;
	float Coeff_XYZ[9],*Coeff_XYZ_asm,*lookupL_32;
	bool SSE2_Enable,SSE41_Enable,AVX_Enable,AVX2_Enable;

	VideoInfo *vi_PlaneY_HLG;

	bool grey,avsp,isRGBPfamily,isAlphaChannel;
	uint8_t pixelsize; // AVS16
	uint8_t bits_per_pixel;

	Public_MT_Data_Thread MT_Thread[MAX_MT_THREADS];
	MT_Data_Info_HDRTools MT_Data[MAX_MT_THREADS];
	uint8_t threads,threads_number;
	uint16_t UserId;
	
	ThreadPoolFunction StaticThreadpoolF;

	static void StaticThreadpool(void *ptr);

	void FreeData(void);
};


class ConvertXYZ_HDRtoSDR : public GenericVideoFilter
{
public:
	ConvertXYZ_HDRtoSDR(PClip _child,float _MinMastering,float _MaxMastering,float _Coeff_X,
		float _Coeff_Y,float _Coeff_Z,uint8_t _threads, bool _sleep,IScriptEnvironment* env);
	virtual ~ConvertXYZ_HDRtoSDR();
    PVideoFrame __stdcall GetFrame(int n, IScriptEnvironment* env);

	int __stdcall SetCacheHints(int cachehints, int frame_range);

private:
	float MinMastering,MaxMastering;
	bool sleep;
	uint16_t *lookupX_16,*lookupY_16,*lookupZ_16;
	float Coeff_X,Coeff_Y,Coeff_Z;
	bool SSE2_Enable,SSE41_Enable,AVX_Enable,AVX2_Enable;

	bool grey,avsp,isRGBPfamily,isAlphaChannel;
	uint8_t pixelsize; // AVS16
	uint8_t bits_per_pixel;

	Public_MT_Data_Thread MT_Thread[MAX_MT_THREADS];
	MT_Data_Info_HDRTools MT_Data[MAX_MT_THREADS];
	uint8_t threads,threads_number;
	uint16_t UserId;
	
	ThreadPoolFunction StaticThreadpoolF;

	static void StaticThreadpool(void *ptr);

	void FreeData(void);
};


class ConvertXYZ_SDRtoHDR : public GenericVideoFilter
{
public:
	ConvertXYZ_SDRtoHDR(PClip _child,float _Coeff_X,float _Coeff_Y,float _Coeff_Z,
		uint8_t _threads, bool _sleep,IScriptEnvironment* env);
	virtual ~ConvertXYZ_SDRtoHDR();
    PVideoFrame __stdcall GetFrame(int n, IScriptEnvironment* env);

	int __stdcall SetCacheHints(int cachehints, int frame_range);

private:
	float MinMastering,MaxMastering;
	bool sleep;
	uint16_t *lookupX_16,*lookupY_16,*lookupZ_16;
	float Coeff_X,Coeff_Y,Coeff_Z;
	bool SSE2_Enable,SSE41_Enable,AVX_Enable,AVX2_Enable;

	bool grey,avsp,isRGBPfamily,isAlphaChannel;
	uint8_t pixelsize; // AVS16
	uint8_t bits_per_pixel;

	Public_MT_Data_Thread MT_Thread[MAX_MT_THREADS];
	MT_Data_Info_HDRTools MT_Data[MAX_MT_THREADS];
	uint8_t threads,threads_number;
	uint16_t UserId;
	
	ThreadPoolFunction StaticThreadpoolF;

	static void StaticThreadpool(void *ptr);

	void FreeData(void);
};