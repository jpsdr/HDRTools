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

#define HDRTOOLS_VERSION "HDRTools 0.4.1 JPSDR"


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
	int16_t *lookupRGB_8;
	int32_t *lookupRGB_16,*lookupHLG_RGB_16;
	uint8_t *lookupL_8;
	uint16_t *lookupL_16;
	float *lookupL_32;
	void *lookupHLG_OOTF,*lookupHLG_inv_OOTF;
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
	bool sleep,HLG_Mode;
	double HLG_Lb,HLG_Lw;
	uint16_t *lookup_Upscale8;
	uint32_t *lookup_Upscale16,*lookup_8to16;
	int16_t *lookupRGB_8,*lookupXYZ_8;
	int32_t *lookupRGB_16,*lookupXYZ_16,*lookupHLG_RGB_16;
	uint8_t *lookupL_8;
	uint16_t *lookupL_16;
	float *lookupL_32;
	void *lookupHLG_OOTF,*lookupHLG_inv_OOTF;
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
	bool sleep,HLG_Mode;
	double HLG_Lb,HLG_Lw;
	int16_t *lookupXYZ_8;
	int32_t *lookupXYZ_16,*lookupHLG_RGB_16;
	uint8_t *lookupL_8;
	uint16_t *lookupL_16,*lookupL_8to16;
	float *lookupL_32,*lookupL_8to32,*lookupL_20;
	float Coeff_XYZ[9],*Coeff_XYZ_asm;
	void *lookupHLG_OOTF,*lookupHLG_inv_OOTF;
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
	bool sleep,HLG_Mode;
	double HLG_Lb,HLG_Lw;
	int16_t *lookupRGB_8;
	int32_t *lookupRGB_16,*lookupHLG_RGB_16;
	uint8_t *lookupL_8;
	uint16_t *lookupL_16,*lookupL_20;
	void *lookupHLG_OOTF,*lookupHLG_inv_OOTF;
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
	bool sleep,HLG_Mode;
	double HLG_Lb,HLG_Lw;
	int16_t *lookupRGB_8,*lookupXYZ_8;
	int32_t *lookupRGB_16,*lookupXYZ_16,*lookupHLG_RGB_16;
	uint8_t *lookupL_8;
	uint16_t *lookupL_16,*lookupL_20;
	float Coeff_XYZ[9],*Coeff_XYZ_asm;
	void *lookupHLG_OOTF,*lookupHLG_inv_OOTF;
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
	bool sleep,HLG_Mode;
	double HLG_Lb,HLG_Lw;
	int16_t *lookupXYZ_8;
	int32_t *lookupXYZ_16,*lookupHLG_RGB_16;
	uint8_t *lookupL_8;
	uint16_t *lookupL_16,*lookupL_20;
	float Coeff_XYZ[9],*Coeff_XYZ_asm,*lookupL_32;
	void *lookupHLG_OOTF,*lookupHLG_inv_OOTF;
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


class ConvertXYZ_Scale_HDRtoSDR : public GenericVideoFilter
{
public:
	ConvertXYZ_Scale_HDRtoSDR(PClip _child,float _Coeff_X,float _Coeff_Y,float _Coeff_Z,uint8_t _threads,
		bool _sleep,IScriptEnvironment* env);
	virtual ~ConvertXYZ_Scale_HDRtoSDR();
    PVideoFrame __stdcall GetFrame(int n, IScriptEnvironment* env);

	int __stdcall SetCacheHints(int cachehints, int frame_range);

private:
	bool sleep;
	float Coeff_X,Coeff_Y,Coeff_Z;
	uint16_t *lookupX_16,*lookupY_16,*lookupZ_16;
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


class ConvertXYZ_Scale_SDRtoHDR : public GenericVideoFilter
{
public:
	ConvertXYZ_Scale_SDRtoHDR(PClip _child,float _Coeff_X,float _Coeff_Y,float _Coeff_Z,
		uint8_t _threads, bool _sleep,IScriptEnvironment* env);
	virtual ~ConvertXYZ_Scale_SDRtoHDR();
    PVideoFrame __stdcall GetFrame(int n, IScriptEnvironment* env);

	int __stdcall SetCacheHints(int cachehints, int frame_range);

private:
	float MinMastering,MaxMastering;
	bool sleep;
	float Coeff_X,Coeff_Y,Coeff_Z;
	uint16_t *lookupX_16,*lookupY_16,*lookupZ_16;
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


class ConvertXYZ_Hable_HDRtoSDR : public GenericVideoFilter
{
public:
	ConvertXYZ_Hable_HDRtoSDR(PClip _child,double _exp_X,double _w_X,double _a_X,double _b_X,double _c_X,
		double _d_X,double _e_X,double _f_X,double _exp_Y,double _w_Y,double _a_Y,double _b_Y,double _c_Y,
		double _d_Y,double _e_Y,double _f_Y,double _exp_Z,double _w_Z,double _a_Z,double _b_Z,double _c_Z,
		double _d_Z,double _e_Z,double _f_Z,
		float _pRx,float _pRy,float _pGx,float _pGy,float _pBx,float _pBy,float _pWx,float _pWy,
		bool _fastmode, uint8_t _threads,bool _sleep,IScriptEnvironment* env);
	virtual ~ConvertXYZ_Hable_HDRtoSDR();
    PVideoFrame __stdcall GetFrame(int n, IScriptEnvironment* env);

	int __stdcall SetCacheHints(int cachehints, int frame_range);

private:
	bool sleep,fastmode;
	double exp_X,w_X,a_X,b_X,c_X,d_X,e_X,f_X;
	double exp_Y,w_Y,a_Y,b_Y,c_Y,d_Y,e_Y,f_Y;
	double exp_Z,w_Z,a_Z,b_Z,c_Z,d_Z,e_Z,f_Z;
	float pRx,pRy,pGx,pGy,pBx,pBy,pWx,pWy;
	uint16_t *lookupX_16,*lookupY_16,*lookupZ_16;
	float *lookupX_32,*lookupY_32,*lookupZ_32;
	bool SSE2_Enable,SSE41_Enable,AVX_Enable,AVX2_Enable;

	double Xmin,Ymin,Zmin,CoeffX,CoeffY,CoeffZ;

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


class ConvertRGB_Hable_HDRtoSDR : public GenericVideoFilter
{
public:
	ConvertRGB_Hable_HDRtoSDR(PClip _child,double _exp_R,double _w_R,double _a_R,double _b_R,double _c_R,
		double _d_R,double _e_R,double _f_R,double _exp_G,double _w_G,double _a_G,double _b_G,double _c_G,
		double _d_G,double _e_G,double _f_G,double _exp_B,double _w_B,double _a_B,double _b_B,double _c_B,
		double _d_B,double _e_B,double _f_B,
		bool _fastmode, uint8_t _threads,bool _sleep,IScriptEnvironment* env);
	virtual ~ConvertRGB_Hable_HDRtoSDR();
    PVideoFrame __stdcall GetFrame(int n, IScriptEnvironment* env);

	int __stdcall SetCacheHints(int cachehints, int frame_range);

private:
	bool sleep,fastmode;
	double exp_R,w_R,a_R,b_R,c_R,d_R,e_R,f_R;
	double exp_G,w_G,a_G,b_G,c_G,d_G,e_G,f_G;
	double exp_B,w_B,a_B,b_B,c_B,d_B,e_B,f_B;
	uint16_t *lookupR_16,*lookupG_16,*lookupB_16;
	float *lookupR_32,*lookupG_32,*lookupB_32;
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


class ConvertXYZ_Mobius_HDRtoSDR : public GenericVideoFilter
{
public:
	ConvertXYZ_Mobius_HDRtoSDR(PClip _child,double _exp_X,double _trans_X,double _peak_X,
		double _exp_Y,double _trans_Y,double _peak_Y,double _exp_Z,double _trans_Z,double _peak_Z,
		float _pRx,float _pRy,float _pGx,float _pGy,float _pBx,float _pBy,float _pWx,float _pWy,
		bool _fastmode, uint8_t _threads,bool _sleep,IScriptEnvironment* env);
	virtual ~ConvertXYZ_Mobius_HDRtoSDR();
    PVideoFrame __stdcall GetFrame(int n, IScriptEnvironment* env);

	int __stdcall SetCacheHints(int cachehints, int frame_range);

private:
	bool sleep,fastmode;
	double exp_X,trans_X,peak_X;
	double exp_Y,trans_Y,peak_Y;
	double exp_Z,trans_Z,peak_Z;
	float pRx,pRy,pGx,pGy,pBx,pBy,pWx,pWy;
	uint16_t *lookupX_16,*lookupY_16,*lookupZ_16;
	float *lookupX_32,*lookupY_32,*lookupZ_32;
	bool SSE2_Enable,SSE41_Enable,AVX_Enable,AVX2_Enable;

	double Xmin,Ymin,Zmin,CoeffX,CoeffY,CoeffZ;

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


class ConvertRGB_Mobius_HDRtoSDR : public GenericVideoFilter
{
public:
	ConvertRGB_Mobius_HDRtoSDR(PClip _child,double _exp_R,double _trans_R,double _peak_R,
		double _exp_G,double _trans_G,double _peak_G,double _exp_B,double _trans_B,double _peak_B,
		bool _fastmode, uint8_t _threads,bool _sleep,IScriptEnvironment* env);
	virtual ~ConvertRGB_Mobius_HDRtoSDR();
    PVideoFrame __stdcall GetFrame(int n, IScriptEnvironment* env);

	int __stdcall SetCacheHints(int cachehints, int frame_range);

private:
	bool sleep,fastmode;
	double exp_R,trans_R,peak_R;
	double exp_G,trans_G,peak_G;
	double exp_B,trans_B,peak_B;
	uint16_t *lookupR_16,*lookupG_16,*lookupB_16;
	float *lookupR_32,*lookupG_32,*lookupB_32;
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


class ConvertXYZ_Reinhard_HDRtoSDR : public GenericVideoFilter
{
public:
	ConvertXYZ_Reinhard_HDRtoSDR(PClip _child,double _exp_X,double _contr_X,double _peak_X,
		double _exp_Y,double _contr_Y,double _peak_Y,double _exp_Z,double _contr_Z,double _peak_Z,
		float _pRx,float _pRy,float _pGx,float _pGy,float _pBx,float _pBy,float _pWx,float _pWy,
		bool _fastmode, uint8_t _threads,bool _sleep,IScriptEnvironment* env);
	virtual ~ConvertXYZ_Reinhard_HDRtoSDR();
    PVideoFrame __stdcall GetFrame(int n, IScriptEnvironment* env);

	int __stdcall SetCacheHints(int cachehints, int frame_range);

private:
	bool sleep,fastmode;
	double exp_X,contr_X,peak_X;
	double exp_Y,contr_Y,peak_Y;
	double exp_Z,contr_Z,peak_Z;
	float pRx,pRy,pGx,pGy,pBx,pBy,pWx,pWy;
	uint16_t *lookupX_16,*lookupY_16,*lookupZ_16;
	float *lookupX_32,*lookupY_32,*lookupZ_32;
	bool SSE2_Enable,SSE41_Enable,AVX_Enable,AVX2_Enable;

	double Xmin,Ymin,Zmin,CoeffX,CoeffY,CoeffZ;

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


class ConvertRGB_Reinhard_HDRtoSDR : public GenericVideoFilter
{
public:
	ConvertRGB_Reinhard_HDRtoSDR(PClip _child,double _exp_R,double _contr_R,double _peak_R,
		double _exp_G,double _contr_G,double _peak_G,double _exp_B,double _contr_B,double _peak_B,
		bool _fastmode, uint8_t _threads,bool _sleep,IScriptEnvironment* env);
	virtual ~ConvertRGB_Reinhard_HDRtoSDR();
    PVideoFrame __stdcall GetFrame(int n, IScriptEnvironment* env);

	int __stdcall SetCacheHints(int cachehints, int frame_range);

private:
	bool sleep,fastmode;
	double exp_R,contr_R,peak_R;
	double exp_G,contr_G,peak_G;
	double exp_B,contr_B,peak_B;
	uint16_t *lookupR_16,*lookupG_16,*lookupB_16;
	float *lookupR_32,*lookupG_32,*lookupB_32;
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
