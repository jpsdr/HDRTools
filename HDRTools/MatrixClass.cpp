/*
 *  MatrixClass
 *
 *  Matrix and vector class allowing several operations.
 *  Copyright (C) 2017 JPSDR
 *	
 *  MatrixClass is free software; you can redistribute it and/or modify
 *  it under the terms of the GNU General Public License as published by
 *  the Free Software Foundation; either version 2, or (at your option)
 *  any later version.
 *   
 *  MatrixClass is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
 *  GNU General Public License for more details.
 *   
 *  You should have received a copy of the GNU General Public License
 *  along with GNU Make; see the file COPYING.  If not, write to
 *  the Free Software Foundation, 675 Mass Ave, Cambridge, MA 02139, USA. 
 *
 */

#include "MatrixClass.h"

#include <memory.h>
#include <algorithm>

// VS 2015
#if _MSC_VER >= 1900
#define AVX2_BUILD_POSSIBLE
#endif

// VS 2019 v16.3
#if _MSC_VER >= 1923
#define AVX512_BUILD_POSSIBLE
#endif

extern "C" void CoeffProductF_SSE2(const float *coeff_a,const float *coeff_b,float *coeff_c,uint16_t lght);
extern "C" void CoeffProductD_SSE2(const double *coeff_a,const double *coeff_b,double *coeff_c,uint16_t lght);
extern "C" void CoeffProduct2F_SSE2(const float *coeff_a,float *coeff_b,uint16_t lght);
extern "C" void CoeffProduct2D_SSE2(const double *coeff_a,double *coeff_b,uint16_t lght);
extern "C" void CoeffAddProductF_SSE2(const float *coeff_a,const float *coeff_b,float *coeff_c,uint16_t lght);
extern "C" void CoeffAddProductD_SSE2(const double *coeff_a,const double *coeff_b,double *coeff_c,uint16_t lght);
extern "C" void CoeffAddF_SSE2(const float *coeff_a,const float *coeff_b,float *coeff_c,uint16_t lght);
extern "C" void CoeffAddD_SSE2(const double *coeff_a,const double *coeff_b,double *coeff_c,uint16_t lght);
extern "C" void CoeffAdd2F_SSE2(const float *coeff_a,float *coeff_b,uint16_t lght);
extern "C" void CoeffAdd2D_SSE2(const double *coeff_a,double *coeff_b,uint16_t lght);
extern "C" void CoeffSubF_SSE2(const float *coeff_a,const float *coeff_b,float *coeff_c,uint16_t lght);
extern "C" void CoeffSubD_SSE2(const double *coeff_a,const double *coeff_b,double *coeff_c,uint16_t lght);
extern "C" void CoeffSub2F_SSE2(const float *coeff_a,float *coeff_b,uint16_t lght);
extern "C" void CoeffSub2D_SSE2(const double *coeff_a,double *coeff_b,uint16_t lght);
extern "C" void VectorNorme2F_SSE2(const float *coeff_x,float *result,uint16_t lght);
extern "C" void VectorNorme2D_SSE2(const double *coeff_x,double *result,uint16_t lght);
extern "C" void VectorNorme1F_SSE2(const float *coeff_x,float *result,uint16_t lght);
extern "C" void VectorNorme1D_SSE2(const double *coeff_x,double *result,uint16_t lght);
extern "C" void VectorNormeF_SSE2(const float *coeff_x,float *result,uint16_t lght);
extern "C" void VectorNormeD_SSE2(const double *coeff_x,double *result,uint16_t lght);
extern "C" void VectorDist2F_SSE2(const float *coeff_x,const float *coeff_y,float *result,uint16_t lght);
extern "C" void VectorDist2D_SSE2(const double *coeff_x,const double *coeff_y,double *result,uint16_t lght);
extern "C" void VectorDist1F_SSE2(const float *coeff_x,const float *coeff_y,float *result,uint16_t lght);
extern "C" void VectorDist1D_SSE2(const double *coeff_x,const double *coeff_y,double *result,uint16_t lght);
extern "C" void VectorDistF_SSE2(const float *coeff_x,const float *coeff_y,float *result,uint16_t lght);
extern "C" void VectorDistD_SSE2(const double *coeff_x,const double *coeff_y,double *result,uint16_t lght);
extern "C" void VectorProductF_SSE2(const float *coeff_a,const float *coeff_x,float *result,uint16_t lght);
extern "C" void VectorProductD_SSE2(const double *coeff_a,const double *coeff_x,double *result,uint16_t lght);
extern "C" void VectorAddF_SSE2(const float *coeff_a,const float *coeff_b,float *coeff_c,uint16_t lght);
extern "C" void VectorAddD_SSE2(const double *coeff_a,const double *coeff_b,double *coeff_c,uint16_t lght);
extern "C" void VectorAdd2F_SSE2(float *coeff_a,const float *coeff_b,uint16_t lght);
extern "C" void VectorAdd2D_SSE2(double *coeff_a,const double *coeff_b,uint16_t lght);
extern "C" void VectorSubF_SSE2(const float *coeff_a,const float *coeff_b,float *coeff_c,uint16_t lght);
extern "C" void VectorSubD_SSE2(const double *coeff_a,const double *coeff_b,double *coeff_c,uint16_t lght);
extern "C" void VectorSub2F_SSE2(float *coeff_a,const float *coeff_b,uint16_t lght);
extern "C" void VectorSub2D_SSE2(double *coeff_a,const double *coeff_b,uint16_t lght);
extern "C" void VectorInvSubF_SSE2(float *coeff_a,const float *coeff_b,uint16_t lght);
extern "C" void VectorInvSubD_SSE2(double *coeff_a,const double *coeff_b,uint16_t lght);
extern "C" void VectorProdF_SSE2(const float *coeff_a,const float *coeff_b,float *coeff_c,uint16_t lght);
extern "C" void VectorProdD_SSE2(const double *coeff_a,const double *coeff_b,double *coeff_c,uint16_t lght);
extern "C" void VectorProd2F_SSE2(float *coeff_a,const float *coeff_b,uint16_t lght);
extern "C" void VectorProd2D_SSE2(double *coeff_a,const double *coeff_b,uint16_t lght);

extern "C" void CoeffProductF_AVX(const float *coeff_a,const float *coeff_b,float *coeff_c,uint16_t lght);
extern "C" void CoeffProductD_AVX(const double *coeff_a,const double *coeff_b,double *coeff_c,uint16_t lght);
extern "C" void CoeffProduct2F_AVX(const float *coeff_a,float *coeff_b,uint16_t lght);
extern "C" void CoeffProduct2D_AVX(const double *coeff_a,double *coeff_b,uint16_t lght);
extern "C" void CoeffAddProductF_AVX(const float *coeff_a,const float *coeff_b,float *coeff_c,uint16_t lght);
extern "C" void CoeffAddProductD_AVX(const double *coeff_a,const double *coeff_b,double *coeff_c,uint16_t lght);
extern "C" void CoeffAddF_AVX(const float *coeff_a,const float *coeff_b,float *coeff_c,uint16_t lght);
extern "C" void CoeffAddD_AVX(const double *coeff_a,const double *coeff_b,double *coeff_c,uint16_t lght);
extern "C" void CoeffAdd2F_AVX(const float *coeff_a,float *coeff_b,uint16_t lght);
extern "C" void CoeffAdd2D_AVX(const double *coeff_a,double *coeff_b,uint16_t lght);
extern "C" void CoeffSubF_AVX(const float *coeff_a,const float *coeff_b,float *coeff_c,uint16_t lght);
extern "C" void CoeffSubD_AVX(const double *coeff_a,const double *coeff_b,double *coeff_c,uint16_t lght);
extern "C" void CoeffSub2F_AVX(const float *coeff_a,float *coeff_b,uint16_t lght);
extern "C" void CoeffSub2D_AVX(const double *coeff_a,double *coeff_b,uint16_t lght);
extern "C" void VectorNorme2F_AVX(const float *coeff_x,float *result,uint16_t lght);
extern "C" void VectorNorme2D_AVX(const double *coeff_x,double *result,uint16_t lght);
extern "C" void VectorNorme1F_AVX(const float *coeff_x,float *result,uint16_t lght);
extern "C" void VectorNorme1D_AVX(const double *coeff_x,double *result,uint16_t lght);
extern "C" void VectorNormeF_AVX(const float *coeff_x,float *result,uint16_t lght);
extern "C" void VectorNormeD_AVX(const double *coeff_x,double *result,uint16_t lght);
extern "C" void VectorDist2F_AVX(const float *coeff_x,const float *coeff_y,float *result,uint16_t lght);
extern "C" void VectorDist2D_AVX(const double *coeff_x,const double *coeff_y,double *result,uint16_t lght);
extern "C" void VectorDist1F_AVX(const float *coeff_x,const float *coeff_y,float *result,uint16_t lght);
extern "C" void VectorDist1D_AVX(const double *coeff_x,const double *coeff_y,double *result,uint16_t lght);
extern "C" void VectorDistF_AVX(const float *coeff_x,const float *coeff_y,float *result,uint16_t lght);
extern "C" void VectorDistD_AVX(const double *coeff_x,const double *coeff_y,double *result,uint16_t lght);
extern "C" void VectorProductF_AVX(const float *coeff_a,const float *coeff_x,float *result,uint16_t lght);
extern "C" void VectorProductD_AVX(const double *coeff_a,const double *coeff_x,double *result,uint16_t lght);
extern "C" void VectorAddF_AVX(const float *coeff_a,const float *coeff_b,float *coeff_c,uint16_t lght);
extern "C" void VectorAddD_AVX(const double *coeff_a,const double *coeff_b,double *coeff_c,uint16_t lght);
extern "C" void VectorAdd2F_AVX(float *coeff_a,const float *coeff_b,uint16_t lght);
extern "C" void VectorAdd2D_AVX(double *coeff_a,const double *coeff_b,uint16_t lght);
extern "C" void VectorSubF_AVX(const float *coeff_a,const float *coeff_b,float *coeff_c,uint16_t lght);
extern "C" void VectorSubD_AVX(const double *coeff_a,const double *coeff_b,double *coeff_c,uint16_t lght);
extern "C" void VectorSub2F_AVX(float *coeff_a,const float *coeff_b,uint16_t lght);
extern "C" void VectorSub2D_AVX(double *coeff_a,const double *coeff_b,uint16_t lght);
extern "C" void VectorInvSubF_AVX(float *coeff_a,const float *coeff_b,uint16_t lght);
extern "C" void VectorInvSubD_AVX(double *coeff_a,const double *coeff_b,uint16_t lght);
extern "C" void VectorProdF_AVX(const float *coeff_a,const float *coeff_b,float *coeff_c,uint16_t lght);
extern "C" void VectorProdD_AVX(const double *coeff_a,const double *coeff_b,double *coeff_c,uint16_t lght);
extern "C" void VectorProd2F_AVX(float *coeff_a,const float *coeff_b,uint16_t lght);
extern "C" void VectorProd2D_AVX(double *coeff_a,const double *coeff_b,uint16_t lght);

#ifdef AVX512_BUILD_POSSIBLE
extern "C" void CoeffProductF_AVX512(const float *coeff_a,const float *coeff_b,float *coeff_c,uint16_t lght);
extern "C" void CoeffProductD_AVX512(const double *coeff_a,const double *coeff_b,double *coeff_c,uint16_t lght);
extern "C" void CoeffProduct2F_AVX512(const float *coeff_a,float *coeff_b,uint16_t lght);
extern "C" void CoeffProduct2D_AVX512(const double *coeff_a,double *coeff_b,uint16_t lght);
extern "C" void CoeffAddProductF_AVX512(const float *coeff_a,const float *coeff_b,float *coeff_c,uint16_t lght);
extern "C" void CoeffAddProductD_AVX512(const double *coeff_a,const double *coeff_b,double *coeff_c,uint16_t lght);
extern "C" void CoeffAddF_AVX512(const float *coeff_a,const float *coeff_b,float *coeff_c,uint16_t lght);
extern "C" void CoeffAddD_AVX512(const double *coeff_a,const double *coeff_b,double *coeff_c,uint16_t lght);
extern "C" void CoeffAdd2F_AVX512(const float *coeff_a,float *coeff_b,uint16_t lght);
extern "C" void CoeffAdd2D_AVX512(const double *coeff_a,double *coeff_b,uint16_t lght);
extern "C" void CoeffSubF_AVX512(const float *coeff_a,const float *coeff_b,float *coeff_c,uint16_t lght);
extern "C" void CoeffSubD_AVX512(const double *coeff_a,const double *coeff_b,double *coeff_c,uint16_t lght);
extern "C" void CoeffSub2F_AVX512(const float *coeff_a,float *coeff_b,uint16_t lght);
extern "C" void CoeffSub2D_AVX512(const double *coeff_a,double *coeff_b,uint16_t lght);
extern "C" void VectorNorme2F_AVX512(const float *coeff_x,float *result,uint16_t lght);
extern "C" void VectorNorme2D_AVX512(const double *coeff_x,double *result,uint16_t lght);
extern "C" void VectorNorme1F_AVX512(const float *coeff_x,float *result,uint16_t lght);
extern "C" void VectorNorme1D_AVX512(const double *coeff_x,double *result,uint16_t lght);
extern "C" void VectorNormeF_AVX512(const float *coeff_x,float *result,uint16_t lght);
extern "C" void VectorNormeD_AVX512(const double *coeff_x,double *result,uint16_t lght);
extern "C" void VectorDist2F_AVX512(const float *coeff_x,const float *coeff_y,float *result,uint16_t lght);
extern "C" void VectorDist2D_AVX512(const double *coeff_x,const double *coeff_y,double *result,uint16_t lght);
extern "C" void VectorDist1F_AVX512(const float *coeff_x,const float *coeff_y,float *result,uint16_t lght);
extern "C" void VectorDist1D_AVX512(const double *coeff_x,const double *coeff_y,double *result,uint16_t lght);
extern "C" void VectorDistF_AVX512(const float *coeff_x,const float *coeff_y,float *result,uint16_t lght);
extern "C" void VectorDistD_AVX512(const double *coeff_x,const double *coeff_y,double *result,uint16_t lght);
extern "C" void VectorProductF_AVX512(const float *coeff_a,const float *coeff_x,float *result,uint16_t lght);
extern "C" void VectorProductD_AVX512(const double *coeff_a,const double *coeff_x,double *result,uint16_t lght);
extern "C" void VectorAddF_AVX512(const float *coeff_a,const float *coeff_b,float *coeff_c,uint16_t lght);
extern "C" void VectorAddD_AVX512(const double *coeff_a,const double *coeff_b,double *coeff_c,uint16_t lght);
extern "C" void VectorAdd2F_AVX512(float *coeff_a,const float *coeff_b,uint16_t lght);
extern "C" void VectorAdd2D_AVX512(double *coeff_a,const double *coeff_b,uint16_t lght);
extern "C" void VectorSubF_AVX512(const float *coeff_a,const float *coeff_b,float *coeff_c,uint16_t lght);
extern "C" void VectorSubD_AVX512(const double *coeff_a,const double *coeff_b,double *coeff_c,uint16_t lght);
extern "C" void VectorSub2F_AVX512(float *coeff_a,const float *coeff_b,uint16_t lght);
extern "C" void VectorSub2D_AVX512(double *coeff_a,const double *coeff_b,uint16_t lght);
extern "C" void VectorInvSubF_AVX512(float *coeff_a,const float *coeff_b,uint16_t lght);
extern "C" void VectorInvSubD_AVX512(double *coeff_a,const double *coeff_b,uint16_t lght);
extern "C" void VectorProdF_AVX512(const float *coeff_a,const float *coeff_b,float *coeff_c,uint16_t lght);
extern "C" void VectorProdD_AVX512(const double *coeff_a,const double *coeff_b,double *coeff_c,uint16_t lght);
extern "C" void VectorProd2F_AVX512(float *coeff_a,const float *coeff_b,uint16_t lght);
extern "C" void VectorProd2D_AVX512(double *coeff_a,const double *coeff_b,uint16_t lght);
#endif

#define MATRIX_ALIGN_SIZE 64
#define MATRIX_ALIGN_SHIFT 6

static bool g_EnableSSE2=false,g_EnableAVX=false,g_EnableAVX2=false,g_EnableAVX512=false;

void SetCPUMatrixClass(const bool SSE2,const bool AVX,const bool AVX2,const bool AVX512)
{
	g_EnableSSE2=SSE2;
	g_EnableAVX=AVX;
	g_EnableAVX2=AVX2;
	g_EnableAVX512=AVX512;
}

Vector::Vector(void)
{
	Coeff=nullptr;
	length=0;
	size=0;
	data_type=DATA_NONE;
}


Vector::Vector(const uint16_t l,const COEFF_DATA_TYPE data)
{
	Coeff=nullptr;
	length=0;
	size=0;
	data_type=DATA_NONE;

	if (l==0) return;

	size_t coeff_size;

	switch(data)
	{
		case DATA_FLOAT : coeff_size=sizeof(float); break;
		case DATA_DOUBLE : coeff_size=sizeof(double); break;
		case DATA_UINT64 : coeff_size=sizeof(uint64_t); break;
		case DATA_INT64 : coeff_size=sizeof(int64_t); break;
		case DATA_UINT32 : coeff_size=sizeof(uint32_t); break;
		case DATA_INT32 : coeff_size=sizeof(int32_t); break;
		case DATA_UINT16 : coeff_size=sizeof(uint16_t); break;
		case DATA_INT16 : coeff_size=sizeof(int16_t); break;
		case DATA_UINT8 : coeff_size=sizeof(uint8_t); break;
		case DATA_INT8 : coeff_size=sizeof(int8_t); break;
		default : coeff_size=0; break;
	}
	if (coeff_size==0) return;

	const size_t p0=((((size_t)l*coeff_size)+MATRIX_ALIGN_SIZE-1) >> MATRIX_ALIGN_SHIFT) << MATRIX_ALIGN_SHIFT;

	Coeff=(void *)_aligned_malloc(p0,MATRIX_ALIGN_SIZE);
	if (Coeff==nullptr) return;

	size=p0;
	length=l;
	data_type=data;

	const size_t n0=(size_t)l*coeff_size,n=p0-n0;

	if (n>0)
	{
		switch(data_type)
		{
			case DATA_FLOAT : std::fill_n((float *)(((uint8_t *)Coeff)+n0),n>>2,0.0f); break;
			case DATA_DOUBLE : std::fill_n((double *)(((uint8_t *)Coeff)+n0),n>>3,0.0); break;
			default : memset(((uint8_t *)Coeff)+n0,0,n); break;
		}
	}
}


Vector::Vector(const Vector &x)
{
	Coeff=nullptr;
	length=0;
	size=0;
	data_type=DATA_NONE;

	const uint16_t l=x.length;

	if ((x.Coeff==nullptr) || (l==0)) return;

	size_t coeff_size;

	switch(x.data_type)
	{
		case DATA_FLOAT : coeff_size=sizeof(float); break;
		case DATA_DOUBLE : coeff_size=sizeof(double); break;
		case DATA_UINT64 : coeff_size=sizeof(uint64_t); break;
		case DATA_INT64 : coeff_size=sizeof(int64_t); break;
		case DATA_UINT32 : coeff_size=sizeof(uint32_t); break;
		case DATA_INT32 : coeff_size=sizeof(int32_t); break;
		case DATA_UINT16 : coeff_size=sizeof(uint16_t); break;
		case DATA_INT16 : coeff_size=sizeof(int16_t); break;
		case DATA_UINT8 : coeff_size=sizeof(uint8_t); break;
		case DATA_INT8 : coeff_size=sizeof(int8_t); break;
		default : coeff_size=0; break;
	}
	if (coeff_size==0) return;

	const size_t p0=((((size_t)l*coeff_size)+MATRIX_ALIGN_SIZE-1) >> MATRIX_ALIGN_SHIFT) << MATRIX_ALIGN_SHIFT;

	Coeff=(void *)_aligned_malloc(p0,MATRIX_ALIGN_SIZE);
	if (Coeff==nullptr) return;

	size=p0;
	length=l;
	data_type=x.data_type;

	const size_t n0=(size_t)l*coeff_size,n=p0-n0;

	if (n>0)
	{
		switch(data_type)
		{
			case DATA_FLOAT : std::fill_n((float *)(((uint8_t *)Coeff)+n0),n>>2,0.0f); break;
			case DATA_DOUBLE : std::fill_n((double *)(((uint8_t *)Coeff)+n0),n>>3,0.0); break;
			default : memset(((uint8_t *)Coeff)+n0,0,n); break;
		}
	}

	CopyStrict(x);
}


Vector::~Vector(void)
{
	Destroy();
}


bool Vector::Create(void)
{
	if ((Coeff!=nullptr) || (length==0)) return(false);

	size_t coeff_size;

	switch(data_type)
	{
		case DATA_FLOAT : coeff_size=sizeof(float); break;
		case DATA_DOUBLE : coeff_size=sizeof(double); break;
		case DATA_UINT64 : coeff_size=sizeof(uint64_t); break;
		case DATA_INT64 : coeff_size=sizeof(int64_t); break;
		case DATA_UINT32 : coeff_size=sizeof(uint32_t); break;
		case DATA_INT32 : coeff_size=sizeof(int32_t); break;
		case DATA_UINT16 : coeff_size=sizeof(uint16_t); break;
		case DATA_INT16 : coeff_size=sizeof(int16_t); break;
		case DATA_UINT8 : coeff_size=sizeof(uint8_t); break;
		case DATA_INT8 : coeff_size=sizeof(int8_t); break;
		default : coeff_size=0; break;
	}
	if (coeff_size==0) return(false);

	const size_t p0=((((size_t)length*coeff_size)+MATRIX_ALIGN_SIZE-1) >> MATRIX_ALIGN_SHIFT) << MATRIX_ALIGN_SHIFT;

	Coeff=(void *)_aligned_malloc(p0,MATRIX_ALIGN_SIZE);
	if (Coeff==nullptr) return(false);

	size=p0;

	const size_t n0=(size_t)length*coeff_size,n=p0-n0;

	if (n>0)
	{
		switch(data_type)
		{
			case DATA_FLOAT : std::fill_n((float *)(((uint8_t *)Coeff)+n0),n>>2,0.0f); break;
			case DATA_DOUBLE : std::fill_n((double *)(((uint8_t *)Coeff)+n0),n>>3,0.0); break;
			default : memset(((uint8_t *)Coeff)+n0,0,n); break;
		}
	}

	return(true);
}


bool Vector::Create(const uint16_t l,const COEFF_DATA_TYPE data)
{
	if ((Coeff!=nullptr) || (l==0)) return(false);

	size_t coeff_size;

	switch(data)
	{
		case DATA_FLOAT : coeff_size=sizeof(float); break;
		case DATA_DOUBLE : coeff_size=sizeof(double); break;
		case DATA_UINT64 : coeff_size=sizeof(uint64_t); break;
		case DATA_INT64 : coeff_size=sizeof(int64_t); break;
		case DATA_UINT32 : coeff_size=sizeof(uint32_t); break;
		case DATA_INT32 : coeff_size=sizeof(int32_t); break;
		case DATA_UINT16 : coeff_size=sizeof(uint16_t); break;
		case DATA_INT16 : coeff_size=sizeof(int16_t); break;
		case DATA_UINT8 : coeff_size=sizeof(uint8_t); break;
		case DATA_INT8 : coeff_size=sizeof(int8_t); break;
		default : coeff_size=0; break;
	}
	if (coeff_size==0) return(false);

	const size_t p0=((((size_t)l*coeff_size)+MATRIX_ALIGN_SIZE-1) >> MATRIX_ALIGN_SHIFT) << MATRIX_ALIGN_SHIFT;

	Coeff=(void *)_aligned_malloc(p0,MATRIX_ALIGN_SIZE);
	if (Coeff==nullptr) return(false);

	size=p0;
	length=l;
	data_type=data;

	const size_t n0=(size_t)l*coeff_size,n=p0-n0;

	if (n>0)
	{
		switch(data_type)
		{
			case DATA_FLOAT : std::fill_n((float *)(((uint8_t *)Coeff)+n0),n>>2,0.0f); break;
			case DATA_DOUBLE : std::fill_n((double *)(((uint8_t *)Coeff)+n0),n>>3,0.0); break;
			default : memset(((uint8_t *)Coeff)+n0,0,n); break;
		}
	}

	return(true);
}


bool Vector::Create(const Vector &x)
{
	if (Coeff!=nullptr) return(false);

	const uint16_t l=x.length;

	if ((x.Coeff==nullptr) || (l==0)) return(false);

	size_t coeff_size;

	switch(x.data_type)
	{
		case DATA_FLOAT : coeff_size=sizeof(float); break;
		case DATA_DOUBLE : coeff_size=sizeof(double); break;
		case DATA_UINT64 : coeff_size=sizeof(uint64_t); break;
		case DATA_INT64 : coeff_size=sizeof(int64_t); break;
		case DATA_UINT32 : coeff_size=sizeof(uint32_t); break;
		case DATA_INT32 : coeff_size=sizeof(int32_t); break;
		case DATA_UINT16 : coeff_size=sizeof(uint16_t); break;
		case DATA_INT16 : coeff_size=sizeof(int16_t); break;
		case DATA_UINT8 : coeff_size=sizeof(uint8_t); break;
		case DATA_INT8 : coeff_size=sizeof(int8_t); break;
		default : coeff_size=0; break;
	}
	if (coeff_size==0) return(false);

	const size_t p0=((((size_t)l*coeff_size)+MATRIX_ALIGN_SIZE-1) >> MATRIX_ALIGN_SHIFT) << MATRIX_ALIGN_SHIFT;

	Coeff=(void *)_aligned_malloc(p0,MATRIX_ALIGN_SIZE);
	if (Coeff==nullptr) return(false);

	size=p0;
	length=l;
	data_type=x.data_type;

	const size_t n0=(size_t)l*coeff_size,n=p0-n0;

	if (n>0)
	{
		switch(data_type)
		{
			case DATA_FLOAT : std::fill_n((float *)(((uint8_t *)Coeff)+n0),n>>2,0.0f); break;
			case DATA_DOUBLE : std::fill_n((double *)(((uint8_t *)Coeff)+n0),n>>3,0.0); break;
			default : memset(((uint8_t *)Coeff)+n0,0,n); break;
		}
	}

	CopyStrict(x);

	return(true);
}


void Vector::Destroy(void)
{
	if (Coeff!=nullptr)
	{
		_aligned_free(Coeff);
		Coeff=nullptr;
	}
	length=0;
	size=0;
	data_type=DATA_NONE;
}


bool Vector::CopyStrict(const Vector &x)
{
	if ((Coeff==nullptr) || (length==0)) return(false);

	const uint16_t l=x.length;

	if ((x.Coeff==nullptr) || (l==0) || (l!=length) || (x.data_type!=data_type)) return(false);

	size_t coeff_size;

	switch(data_type)
	{
		case DATA_FLOAT : coeff_size=sizeof(float); break;
		case DATA_DOUBLE : coeff_size=sizeof(double); break;
		case DATA_UINT64 : coeff_size=sizeof(uint64_t); break;
		case DATA_INT64 : coeff_size=sizeof(int64_t); break;
		case DATA_UINT32 : coeff_size=sizeof(uint32_t); break;
		case DATA_INT32 : coeff_size=sizeof(int32_t); break;
		case DATA_UINT16 : coeff_size=sizeof(uint16_t); break;
		case DATA_INT16 : coeff_size=sizeof(int16_t); break;
		case DATA_UINT8 : coeff_size=sizeof(uint8_t); break;
		case DATA_INT8 : coeff_size=sizeof(int8_t); break;
		default : coeff_size=0; break;
	}
	if (coeff_size==0) return(false);

	const size_t size_line=(size_t)l*coeff_size;

	memcpy(Coeff,x.GetPtrVector(),size_line);

	return(true);
}


bool Vector::CopyRaw(const void *ptr)
{
	if ((Coeff==nullptr) || (ptr==nullptr) || (length==0)) return(false);

	size_t coeff_size;

	switch(data_type)
	{
		case DATA_FLOAT : coeff_size=sizeof(float); break;
		case DATA_DOUBLE : coeff_size=sizeof(double); break;
		case DATA_UINT64 : coeff_size=sizeof(uint64_t); break;
		case DATA_INT64 : coeff_size=sizeof(int64_t); break;
		case DATA_UINT32 : coeff_size=sizeof(uint32_t); break;
		case DATA_INT32 : coeff_size=sizeof(int32_t); break;
		case DATA_UINT16 : coeff_size=sizeof(uint16_t); break;
		case DATA_INT16 : coeff_size=sizeof(int16_t); break;
		case DATA_UINT8 : coeff_size=sizeof(uint8_t); break;
		case DATA_INT8 : coeff_size=sizeof(int8_t); break;
		default : coeff_size=0; break;
	}
	if (coeff_size==0) return(false);

	const size_t size_line=(size_t)length*coeff_size;

	memcpy(Coeff,ptr,size_line);

	return(true);
}


bool Vector::CopyRaw(const void *ptr,const uint16_t lgth)
{
	if ((Coeff==nullptr) || (ptr==nullptr) || (length==0) || (lgth>length)) return(false);

	size_t coeff_size;

	switch(data_type)
	{
		case DATA_FLOAT : coeff_size=sizeof(float); break;
		case DATA_DOUBLE : coeff_size=sizeof(double); break;
		case DATA_UINT64 : coeff_size=sizeof(uint64_t); break;
		case DATA_INT64 : coeff_size=sizeof(int64_t); break;
		case DATA_UINT32 : coeff_size=sizeof(uint32_t); break;
		case DATA_INT32 : coeff_size=sizeof(int32_t); break;
		case DATA_UINT16 : coeff_size=sizeof(uint16_t); break;
		case DATA_INT16 : coeff_size=sizeof(int16_t); break;
		case DATA_UINT8 : coeff_size=sizeof(uint8_t); break;
		case DATA_INT8 : coeff_size=sizeof(int8_t); break;
		default : coeff_size=0; break;
	}
	if (coeff_size==0) return(false);

	const size_t size_line=(size_t)lgth*coeff_size;

	memcpy(Coeff,ptr,size_line);

	return(true);
}


bool Vector::ExportRaw(void *ptr)
{
	if ((Coeff==nullptr) || (ptr==nullptr) || (length==0)) return(false);

	size_t coeff_size;

	switch(data_type)
	{
		case DATA_FLOAT : coeff_size=sizeof(float); break;
		case DATA_DOUBLE : coeff_size=sizeof(double); break;
		case DATA_UINT64 : coeff_size=sizeof(uint64_t); break;
		case DATA_INT64 : coeff_size=sizeof(int64_t); break;
		case DATA_UINT32 : coeff_size=sizeof(uint32_t); break;
		case DATA_INT32 : coeff_size=sizeof(int32_t); break;
		case DATA_UINT16 : coeff_size=sizeof(uint16_t); break;
		case DATA_INT16 : coeff_size=sizeof(int16_t); break;
		case DATA_UINT8 : coeff_size=sizeof(uint8_t); break;
		case DATA_INT8 : coeff_size=sizeof(int8_t); break;
		default : coeff_size=0; break;
	}
	if (coeff_size==0) return(false);

	const size_t size_line=(size_t)length*coeff_size;

	memcpy(ptr,Coeff,size_line);

	return(true);
}


bool Vector::ExportRaw(void *ptr,const uint16_t lgth)
{
	if ((Coeff==nullptr) || (ptr==nullptr) || (length==0) || (lgth>length)) return(false);

	size_t coeff_size;

	switch(data_type)
	{
		case DATA_FLOAT : coeff_size=sizeof(float); break;
		case DATA_DOUBLE : coeff_size=sizeof(double); break;
		case DATA_UINT64 : coeff_size=sizeof(uint64_t); break;
		case DATA_INT64 : coeff_size=sizeof(int64_t); break;
		case DATA_UINT32 : coeff_size=sizeof(uint32_t); break;
		case DATA_INT32 : coeff_size=sizeof(int32_t); break;
		case DATA_UINT16 : coeff_size=sizeof(uint16_t); break;
		case DATA_INT16 : coeff_size=sizeof(int16_t); break;
		case DATA_UINT8 : coeff_size=sizeof(uint8_t); break;
		case DATA_INT8 : coeff_size=sizeof(int8_t); break;
		default : coeff_size=0; break;
	}
	if (coeff_size==0) return(false);

	const size_t size_line=(size_t)lgth*coeff_size;

	memcpy(ptr,Coeff,size_line);

	return(true);
}


bool Vector::FillD(const double data)
{
	if ((Coeff==nullptr) || (length==0) || (data_type!=DATA_DOUBLE)) return(false);

	std::fill_n((double *)Coeff,length,data);

	return(true);
}


bool Vector::FillF(const float data)
{
	if ((Coeff==nullptr) || (length==0) || (data_type!=DATA_FLOAT)) return(false);

	std::fill_n((float *)Coeff,length,data);

	return(true);
}


bool Vector::FillZero(void)
{
	if ((Coeff==nullptr) || (length==0)) return(false);

	switch(data_type)
	{
		case DATA_FLOAT : std::fill_n((float *)Coeff,length,0.0f); break;
		case DATA_DOUBLE : std::fill_n((double *)Coeff,length,0.0); break;
		default : memset(Coeff,0,size); break;
	}

	return(true);
}


bool Vector::SetInfo(const uint16_t l,const COEFF_DATA_TYPE data)
{
	if ((Coeff!=nullptr) || (length!=0) || (l==0) || (data_type==DATA_NONE)) return(false);

	length=l; data_type=data;

	return(true);
}


void Vector::GetInfo(uint16_t &l,COEFF_DATA_TYPE &data) const
{
	l=length; data=data_type;
}


bool Vector::GetSafeD(const uint16_t i,double &d) const
{
	if ((Coeff==nullptr) || (length==0) || (i>=length) || (data_type!=DATA_DOUBLE)) return(false);

	d=((double *)Coeff)[i];

	return(true);
}


bool Vector::SetSafeD(const uint16_t i,const double d)
{
	if ((Coeff==nullptr) || (length==0) || (i>=length) || (data_type!=DATA_DOUBLE)) return(false);

	((double *)Coeff)[i]=d;

	return(true);
}


bool Vector::GetSafeF(const uint16_t i,float &d) const
{
	if ((Coeff==nullptr) || (length==0) || (i>=length) || (data_type!=DATA_FLOAT)) return(false);

	d=((float *)Coeff)[i];

	return(true);
}


bool Vector::SetSafeF(const uint16_t i,const float d)
{
	if ((Coeff==nullptr) || (length==0) || (i>=length) || (data_type!=DATA_FLOAT)) return(false);

	((float *)Coeff)[i]=d;

	return(true);
}


// +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

Vector_Compute::Vector_Compute(void)
{
	SSE2_Enable=g_EnableSSE2;
	AVX_Enable=g_EnableAVX;
	AVX2_Enable=g_EnableAVX2;
	AVX512_Enable=g_EnableAVX512;
}


Vector_Compute::~Vector_Compute(void)
{
}


Vector_Compute::Vector_Compute(const uint16_t l,const COEFF_DATA_TYPE data):Vector(l,data)
{
	SSE2_Enable=g_EnableSSE2;
	AVX_Enable=g_EnableAVX;
	AVX2_Enable=g_EnableAVX2;
	AVX512_Enable=g_EnableAVX512;
}


Vector_Compute::Vector_Compute(const Vector_Compute &x):Vector(x)
{
	SSE2_Enable=x.SSE2_Enable;
	AVX_Enable=x.AVX_Enable;
	AVX2_Enable=x.AVX2_Enable;
	AVX512_Enable=x.AVX512_Enable;
}


bool Vector_Compute::Product_AX(const Matrix &ma, const Vector &x)
{
	if ((Coeff==nullptr) || (length==0)) return(false);
	if (!ma.AllocCheck() || !x.AllocCheck()) return(false);

	if ((ma.GetColumns()!=x.GetLength()) || (length!=ma.GetLines()) || (ma.GetDataType()!=x.GetDataType())
		|| (x.GetDataType()!=data_type)) return(false);

	switch(data_type)
	{
		case DATA_FLOAT : ProductF_AX(ma,x); break;
		case DATA_DOUBLE : ProductD_AX(ma,x); break;
		default : return(false);
	}

	return(true);
}


bool Vector_Compute::Product_AX(const Matrix &ma)
{
	if ((Coeff==nullptr) || (length==0)) return(false);
	if (!ma.AllocCheck()) return(false);

	if ((ma.GetColumns()!=ma.GetLines()) || (length!=ma.GetLines()) || (ma.GetDataType()!=data_type)) return(false);

	Vector b(*this);

	if (!b.AllocCheck()) return(false);

	switch(data_type)
	{
		case DATA_FLOAT : ProductF_AX(ma,b); break;
		case DATA_DOUBLE : ProductD_AX(ma,b); break;
		default : return(false);
	}

	return(true);
}


void Vector_Compute::ProductF_AX(const Matrix &ma, const Vector &x)
{
	const uint16_t l=length,lb=x.GetLength();
	const uint8_t *a0=(uint8_t *)ma.GetPtrMatrix();
	const float *x1=(const float *)x.GetPtrVector();
	float *c1=(float *)Coeff;
	const ptrdiff_t pa=ma.GetPitch();

#ifdef AVX512_BUILD_POSSIBLE
	if (AVX512_Enable)
	{
		const uint16_t n=(lb+15)>>4;

		for (int32_t i=0; i<l; i++)
		{
			VectorProductF_AVX512((const float *)a0,x1,c1++,n);
			a0+=pa;
		}
	}
	else
#endif
	{
		if (AVX_Enable)
		{
			const uint16_t n=(lb+7)>>3;

			for (int32_t i=0; i<l; i++)
			{
				VectorProductF_AVX((const float *)a0,x1,c1++,n);
				a0+=pa;
			}
		}
		else
		{
			if (SSE2_Enable)
			{
				const uint16_t n=(lb+3)>>2;

				for (int32_t i=0; i<l; i++)
				{
					VectorProductF_SSE2((const float *)a0,x1,c1++,n);
					a0+=pa;
				}
			}
			else
			{
				for (uint16_t i=0; i<l; i++)
				{
					const float *a1=(const float *)a0;
					float s=0.0f;

					for (uint16_t k=0; k<lb; k++)
						s+=a1[k]*x1[k];
					*c1++=s;
					a0+=pa;
				}
			}
		}
	}
}


void Vector_Compute::ProductD_AX(const Matrix &ma, const Vector &x)
{
	const uint16_t l=length,lb=x.GetLength();
	const uint8_t *a0=(uint8_t *)ma.GetPtrMatrix();
	const double *x1=(const double *)x.GetPtrVector();
	double *c1=(double *)Coeff;
	const ptrdiff_t pa=ma.GetPitch();

#ifdef AVX512_BUILD_POSSIBLE
	if (AVX512_Enable)
	{
		const uint16_t n=(lb+7)>>3;

		for (int32_t i=0; i<l; i++)
		{
			VectorProductD_AVX512((const double *)a0,x1,c1++,n);
			a0+=pa;
		}
	}
	else
#endif
	{
		if (AVX_Enable)
		{
			const uint16_t n=(lb+3)>>2;

			for (int32_t i=0; i<l; i++)
			{
				VectorProductD_AVX((const double *)a0,x1,c1++,n);
				a0+=pa;
			}
		}
		else
		{
			if (SSE2_Enable)
			{
				const uint16_t n=(lb+1)>>1;

				for (int32_t i=0; i<l; i++)
				{
					VectorProductD_SSE2((const double *)a0,x1,c1++,n);
					a0+=pa;
				}
			}
			else
			{
				for (uint16_t i=0; i<l; i++)
				{
					const double *a1=(const double *)a0;
					double s=0.0;

					for (uint16_t k=0; k<lb; k++)
						s+=a1[k]*x1[k];
					*c1++=s;
					a0+=pa;
				}
			}
		}
	}
}


bool Vector_Compute::Product_tAX(const Matrix &ma, const Vector &x)
{
	if ((Coeff==nullptr) || (length==0)) return(false);
	if (!ma.AllocCheck() || !x.AllocCheck()) return(false);

	if ((ma.GetLines()!=x.GetLength()) || (length!=ma.GetColumns()) || (ma.GetDataType()!=x.GetDataType())
		|| (x.GetDataType()!=data_type)) return(false);

	switch(data_type)
	{
		case DATA_FLOAT : ProductF_tAX(ma,x); break;
		case DATA_DOUBLE : ProductD_tAX(ma,x); break;
		default : return(false);
	}

	return(true);
}


bool Vector_Compute::Product_tAX(const Matrix &ma)
{
	if ((Coeff==nullptr) || (length==0)) return(false);
	if (!ma.AllocCheck()) return(false);

	if ((ma.GetColumns()!=ma.GetLines()) || (length!=ma.GetLines()) || (ma.GetDataType()!=data_type)) return(false);

	Vector b(*this);

	if (!b.AllocCheck()) return(false);

	switch(data_type)
	{
		case DATA_FLOAT : ProductF_tAX(ma,b); break;
		case DATA_DOUBLE : ProductD_tAX(ma,b); break;
		default : return(false);
	}

	return(true);
}


void Vector_Compute::ProductF_tAX(const Matrix &ma, const Vector &x)
{
	const uint16_t l=length,lb=x.GetLength();
	const float *x1=(const float *)x.GetPtrVector();
	float *c1=(float *)Coeff;

#ifdef AVX512_BUILD_POSSIBLE
	if (AVX512_Enable)
	{
		Matrix_Compute mb;

		mb.CreateTranspose(ma);

		const uint8_t *b0=(uint8_t *)mb.GetPtrMatrix();
		const ptrdiff_t pb=mb.GetPitch();

		uint16_t n=(lb+15) >> 4;

		for (uint16_t i=0; i<l; i++)
		{
			VectorProductF_AVX512((const float *)b0,x1,c1++,n);
			b0+=pb;
		}
	}
	else
#endif
	{
		if (AVX_Enable)
		{
			Matrix_Compute mb;

			mb.CreateTranspose(ma);

			const uint8_t *b0=(uint8_t *)mb.GetPtrMatrix();
			const ptrdiff_t pb=mb.GetPitch();

			uint16_t n=(lb+7) >> 3;

			for (uint16_t i=0; i<l; i++)
			{
				VectorProductF_AVX((const float *)b0,x1,c1++,n);
				b0+=pb;
			}
		}
		else
		{
			if (SSE2_Enable)
			{
				Matrix_Compute mb;

				mb.CreateTranspose(ma);

				const uint8_t *b0=(uint8_t *)mb.GetPtrMatrix();
				const ptrdiff_t pb=mb.GetPitch();

				uint16_t n=(lb+3) >> 2;

				for (uint16_t i=0; i<l; i++)
				{
					VectorProductF_SSE2((const float *)b0,x1,c1++,n);
					b0+=pb;
				}
			}
			else
			{
				const uint8_t *a0=(uint8_t *)ma.GetPtrMatrix();
				const ptrdiff_t pa=ma.GetPitch();

				for (uint16_t i=0; i<l; i++)
				{
					const uint8_t *a1=a0;
					float s=0.0;

					for (uint16_t k=0; k<lb; k++)
					{
						s+=*((float *)a1)*x1[k];
						a1+=pa;
					}
					*c1++=s;

					a0+=sizeof(float);
				}
			}
		}
	}
}


void Vector_Compute::ProductD_tAX(const Matrix &ma, const Vector &x)
{
	const uint16_t l=length,lb=x.GetLength();
	const double *x1=(const double *)x.GetPtrVector();
	double *c1=(double *)Coeff;

#ifdef AVX512_BUILD_POSSIBLE
	if (AVX512_Enable)
	{
		Matrix_Compute mb;

		mb.CreateTranspose(ma);

		const uint8_t *b0=(uint8_t *)mb.GetPtrMatrix();
		const ptrdiff_t pb=mb.GetPitch();

		uint16_t n=(lb+7) >> 3;

		for (uint16_t i=0; i<l; i++)
		{
			VectorProductD_AVX512((const double *)b0,x1,c1++,n);
			b0+=pb;
		}
	}
	else
#endif
	{
		if (AVX_Enable)
		{
			Matrix_Compute mb;

			mb.CreateTranspose(ma);

			const uint8_t *b0=(uint8_t *)mb.GetPtrMatrix();
			const ptrdiff_t pb=mb.GetPitch();

			uint16_t n=(lb+3) >> 2;

			for (uint16_t i=0; i<l; i++)
			{
				VectorProductD_AVX((const double *)b0,x1,c1++,n);
				b0+=pb;
			}
		}
		else
		{
			if (SSE2_Enable)
			{
				Matrix_Compute mb;

				mb.CreateTranspose(ma);

				const uint8_t *b0=(uint8_t *)mb.GetPtrMatrix();
				const ptrdiff_t pb=mb.GetPitch();

				uint16_t n=(lb+1) >> 1;

				for (uint16_t i=0; i<l; i++)
				{
					VectorProductD_SSE2((const double *)b0,x1,c1++,n);
					b0+=pb;
				}
			}
			else
			{
				const uint8_t *a0=(uint8_t *)ma.GetPtrMatrix();
				const ptrdiff_t pa=ma.GetPitch();

				for (uint16_t i=0; i<l; i++)
				{
					const uint8_t *a1=a0;
					double s=0.0;

					for (uint16_t k=0; k<lb; k++)
					{
						s+=*((double *)a1)*x1[k];
						a1+=pa;
					}
					*c1++=s;

					a0+=sizeof(double);
				}
			}
		}
	}
}


bool Vector_Compute::Mult(const double coef,const Vector &x)
{
	if ((Coeff==nullptr) || (length==0)) return(false);
	if (!x.AllocCheck()) return(false);

	if ((length!=x.GetLength()) || (x.GetDataType()!=data_type)) return(false);

	if (coef==0.0)
	{
		FillZero();
		return(true);
	}
	if (coef==1.0)
	{
		CopyStrict(x);
		return(true);
	}

	switch(data_type)
	{
		case DATA_FLOAT : MultF(coef,x); break;
		case DATA_DOUBLE : MultD(coef,x); break;
		default : return(false);
	}

	return(true);
}


bool Vector_Compute::Mult(const double coef)
{
	if ((Coeff==nullptr) || (length==0)) return(false);


	if (coef==0.0)
	{
		FillZero();
		return(true);
	}
	if (coef==1.0) return(true);

	switch(data_type)
	{
		case DATA_FLOAT : MultF(coef); break;
		case DATA_DOUBLE : MultD(coef); break;
		default : return(false);
	}

	return(true);
}


void Vector_Compute::MultF(const double coef, const Vector &x)
{
	const uint16_t l=length;
	const float *x1=(const float *)x.GetPtrVector();
	float *c1=(float *)Coeff;
	float b=(float)coef;

#ifdef AVX512_BUILD_POSSIBLE
	if (AVX512_Enable)
	{
		const uint16_t n=(l+15)>>4;

		CoeffProductF_AVX512(&b,x1,c1,n);
	}
	else
#endif
	{
		if (AVX_Enable)
		{
			const uint16_t n=(l+7)>>3;

			CoeffProductF_AVX(&b,x1,c1,n);
		}
		else
		{
			if (SSE2_Enable)
			{
				const uint16_t n=(l+3)>>2;

				CoeffProductF_SSE2(&b,x1,c1,n);
			}
			else
			{
				for (uint16_t i=0; i<l; i++)
					c1[i]=b*x1[i];
			}
		}
	}
}


void Vector_Compute::MultF(const double coef)
{
	const uint16_t l=length;
	float *c1=(float *)Coeff;
	float b=(float)coef;

#ifdef AVX512_BUILD_POSSIBLE
	if (AVX512_Enable)
	{
		const uint16_t n=(l+15)>>4;

		CoeffProduct2F_AVX512(&b,c1,n);
	}
	else
#endif
	{
		if (AVX_Enable)
		{
			const uint16_t n=(l+7)>>3;

			CoeffProduct2F_AVX(&b,c1,n);
		}
		else
		{
			if (SSE2_Enable)
			{
				const uint16_t n=(l+3)>>2;

				CoeffProduct2F_SSE2(&b,c1,n);
			}
			else
			{
				for (uint16_t i=0; i<l; i++)
					c1[i]*=b;
			}
		}
	}
}


void Vector_Compute::MultD(const double coef, const Vector &x)
{
	const uint16_t l=length;
	const double *x1=(const double *)x.GetPtrVector();
	double *c1=(double *)Coeff;

#ifdef AVX512_BUILD_POSSIBLE
	if (AVX512_Enable)
	{
		const uint16_t n=(l+7)>>3;

		CoeffProductD_AVX512(&coef,x1,c1,n);
	}
	else
#endif
	{
		if (AVX_Enable)
		{
			const uint16_t n=(l+3)>>2;

			CoeffProductD_AVX(&coef,x1,c1,n);
		}
		else
		{
			if (SSE2_Enable)
			{
				const uint16_t n=(l+1)>>1;

				CoeffProductD_SSE2(&coef,x1,c1,n);
			}
			else
			{
				for (uint16_t i=0; i<l; i++)
					c1[i]=coef*x1[i];
			}
		}
	}
}


void Vector_Compute::MultD(const double coef)
{
	const uint16_t l=length;
	double *c1=(double *)Coeff;

#ifdef AVX512_BUILD_POSSIBLE
	if (AVX512_Enable)
	{
		const uint16_t n=(l+7)>>3;

		CoeffProduct2D_AVX512(&coef,c1,n);
	}
	else
#endif
	{
		if (AVX_Enable)
		{
			const uint16_t n=(l+3)>>2;

			CoeffProduct2D_AVX(&coef,c1,n);
		}
		else
		{
			if (SSE2_Enable)
			{
				const uint16_t n=(l+1)>>1;

				CoeffProduct2D_SSE2(&coef,c1,n);
			}
			else
			{
				for (uint16_t i=0; i<l; i++)
					c1[i]*=coef;
			}
		}
	}
}


bool Vector_Compute::Add(const double coef,const Vector &x)
{
	if ((Coeff==nullptr) || (length==0)) return(false);
	if (!x.AllocCheck()) return(false);

	if ((length!=x.GetLength()) || (x.GetDataType()!=data_type)) return(false);

	if (coef==0.0)
	{
		CopyStrict(x);
		return(true);
	}

	switch(data_type)
	{
		case DATA_FLOAT : AddF(coef,x); break;
		case DATA_DOUBLE : AddD(coef,x); break;
		default : return(false);
	}

	return(true);
}


bool Vector_Compute::Add(const double coef)
{
	if ((Coeff==nullptr) || (length==0)) return(false);

	if (coef==0.0) return(true);

	switch(data_type)
	{
		case DATA_FLOAT : AddF(coef); break;
		case DATA_DOUBLE : AddD(coef); break;
		default : return(false);
	}

	return(true);
}


void Vector_Compute::AddF(const double coef, const Vector &x)
{
	const uint16_t l=length;
	const float *x1=(const float *)x.GetPtrVector();
	float *c1=(float *)Coeff;
	float b=(float)coef;

#ifdef AVX512_BUILD_POSSIBLE
	if (AVX512_Enable)
	{
		const uint16_t n0=l>>4,n1=n0<<4;

		if (n0>0) CoeffAddF_AVX512(&b,x1,c1,n0);
		for (uint16_t i=n1; i<l; i++)
			c1[i]=b+x1[i];
	}
	else
#endif
	{
		if (AVX_Enable)
		{
			const uint16_t n0=l>>3,n1=n0<<3;

			if (n0>0) CoeffAddF_AVX(&b,x1,c1,n0);
			for (uint16_t i=n1; i<l; i++)
				c1[i]=b+x1[i];
		}
		else
		{
			if (SSE2_Enable)
			{
				const uint16_t n0=l>>2,n1=n0<<2;

				if (n0>0) CoeffAddF_SSE2(&b,x1,c1,n0);
				for (uint16_t i=n1; i<l; i++)
					c1[i]=b+x1[i];
			}
			else
			{
				for (uint16_t i=0; i<l; i++)
					c1[i]=b+x1[i];
			}
		}
	}
}


void Vector_Compute::AddF(const double coef)
{
	const uint16_t l=length;
	float *c1=(float *)Coeff;
	float b=(float)coef;

#ifdef AVX512_BUILD_POSSIBLE
	if (AVX512_Enable)
	{
		const uint16_t n0=l>>4,n1=n0<<4;

		if (n0>0) CoeffAdd2F_AVX512(&b,c1,n0);
		for (uint16_t i=n1; i<l; i++)
			c1[i]+=b;
	}
	else
#endif
	{
		if (AVX_Enable)
		{
			const uint16_t n0=l>>3,n1=n0<<3;

			if (n0>0) CoeffAdd2F_AVX(&b,c1,n0);
			for (uint16_t i=n1; i<l; i++)
				c1[i]+=b;
		}
		else
		{
			if (SSE2_Enable)
			{
				const uint16_t n0=l>>2,n1=n0<<2;

				if (n0>0) CoeffAdd2F_SSE2(&b,c1,n0);
				for (uint16_t i=n1; i<l; i++)
					c1[i]+=b;
			}
			else
			{
				for (uint16_t i=0; i<l; i++)
					c1[i]+=b;
			}
		}
	}
}


void Vector_Compute::AddD(const double coef, const Vector &x)
{
	const uint16_t l=length;
	const double *x1=(const double *)x.GetPtrVector();
	double *c1=(double *)Coeff;

#ifdef AVX512_BUILD_POSSIBLE
	if (AVX512_Enable)
	{
		const uint16_t n0=l>>3,n1=n0<<3;

		if (n0>0) CoeffAddD_AVX512(&coef,x1,c1,n0);
		for (uint16_t i=n1; i<l; i++)
			c1[i]=coef+x1[i];
	}
	else
#endif
	{
		if (AVX_Enable)
		{
			const uint16_t n0=l>>2,n1=n0<<2;

			if (n0>0) CoeffAddD_AVX(&coef,x1,c1,n0);
			for (uint16_t i=n1; i<l; i++)
				c1[i]=coef+x1[i];
		}
		else
		{
			if (SSE2_Enable)
			{
				const uint16_t n0=l>>1,n1=n0<<1;

				if (n0>0) CoeffAddD_SSE2(&coef,x1,c1,n0);
				for (uint16_t i=n1; i<l; i++)
					c1[i]=coef+x1[i];
			}
			else
			{
				for (uint16_t i=0; i<l; i++)
					c1[i]=coef+x1[i];
			}
		}
	}
}


void Vector_Compute::AddD(const double coef)
{
	const uint16_t l=length;
	double *c1=(double *)Coeff;

#ifdef AVX512_BUILD_POSSIBLE
	if (AVX512_Enable)
	{
		const uint16_t n0=l>>3,n1=n0<<3;

		if (n0>0) CoeffAdd2D_AVX512(&coef,c1,n0);
		for (uint16_t i=n1; i<l; i++)
			c1[i]+=coef;
	}
	else
#endif
	{
		if (AVX_Enable)
		{
			const uint16_t n0=l>>2,n1=n0<<2;

			if (n0>0) CoeffAdd2D_AVX(&coef,c1,n0);
			for (uint16_t i=n1; i<l; i++)
				c1[i]+=coef;
		}
		else
		{
			if (SSE2_Enable)
			{
				const uint16_t n0=l>>1,n1=n0<<1;

				if (n0>0) CoeffAdd2D_SSE2(&coef,c1,n0);
				for (uint16_t i=n1; i<l; i++)
					c1[i]+=coef;
			}
			else
			{
				for (uint16_t i=0; i<l; i++)
					c1[i]+=coef;
			}
		}
	}
}


bool Vector_Compute::Sub(const double coef,const Vector &x)
{
	if ((Coeff==nullptr) || (length==0)) return(false);
	if (!x.AllocCheck()) return(false);

	if ((length!=x.GetLength()) || (x.GetDataType()!=data_type)) return(false);

	if (coef==0.0)
	{
		CopyStrict(x);
		return(true);
	}

	switch(data_type)
	{
		case DATA_FLOAT : SubF(coef,x); break;
		case DATA_DOUBLE : SubD(coef,x); break;
		default : return(false);
	}

	return(true);
}


bool Vector_Compute::Sub(const double coef)
{
	if ((Coeff==nullptr) || (length==0)) return(false);

	if (coef==0.0) return(true);

	switch(data_type)
	{
		case DATA_FLOAT : SubF(coef); break;
		case DATA_DOUBLE : SubD(coef); break;
		default : return(false);
	}

	return(true);
}


void Vector_Compute::SubF(const double coef, const Vector &x)
{
	const uint16_t l=length;
	const float *x1=(const float *)x.GetPtrVector();
	float *c1=(float *)Coeff;
	float b=(float)coef;

#ifdef AVX512_BUILD_POSSIBLE
	if (AVX512_Enable)
	{
		const uint16_t n0=l>>4,n1=n0<<4;

		if (n0>0) CoeffSubF_AVX512(&b,x1,c1,n0);
		for (uint16_t i=n1; i<l; i++)
			c1[i]=b-x1[i];
	}
	else
#endif
	{
		if (AVX_Enable)
		{
			const uint16_t n0=l>>3,n1=n0<<3;

			if (n0>0) CoeffSubF_AVX(&b,x1,c1,n0);
			for (uint16_t i=n1; i<l; i++)
				c1[i]=b-x1[i];
		}
		else
		{
			if (SSE2_Enable)
			{
				const uint16_t n0=l>>2,n1=n0<<2;

				if (n0>0) CoeffSubF_SSE2(&b,x1,c1,n0);
				for (uint16_t i=n1; i<l; i++)
					c1[i]=b-x1[i];
			}
			else
			{
				for (uint16_t i=0; i<l; i++)
					c1[i]=b-x1[i];
			}
		}
	}
}


void Vector_Compute::SubF(const double coef)
{
	const uint16_t l=length;
	float *c1=(float *)Coeff;
	float b=(float)coef;

#ifdef AVX512_BUILD_POSSIBLE
	if (AVX512_Enable)
	{
		const uint16_t n0=l>>4,n1=n0<<4;

		if (n0>0) CoeffSub2F_AVX512(&b,c1,n0);
		for (uint16_t i=n1; i<l; i++)
			c1[i]=b-c1[i];
	}
	else
#endif
	{
		if (AVX_Enable)
		{
			const uint16_t n0=l>>3,n1=n0<<3;

			if (n0>0) CoeffSub2F_AVX(&b,c1,n0);
			for (uint16_t i=n1; i<l; i++)
				c1[i]=b-c1[i];
		}
		else
		{
			if (SSE2_Enable)
			{
				const uint16_t n0=l>>2,n1=n0<<2;

				if (n0>0) CoeffSub2F_SSE2(&b,c1,n0);
				for (uint16_t i=n1; i<l; i++)
					c1[i]=b-c1[i];
			}
			else
			{
				for (uint16_t i=0; i<l; i++)
					c1[i]=b-c1[i];
			}
		}
	}
}


void Vector_Compute::SubD(const double coef, const Vector &x)
{
	const uint16_t l=length;
	const double *x1=(const double *)x.GetPtrVector();
	double *c1=(double *)Coeff;

#ifdef AVX512_BUILD_POSSIBLE
	if (AVX512_Enable)
	{
		const uint16_t n0=l>>3,n1=n0<<3;

		if (n0>0) CoeffSubD_AVX512(&coef,x1,c1,n0);
		for (uint16_t i=n1; i<l; i++)
			c1[i]=coef-x1[i];
	}
	else
#endif
	{
		if (AVX_Enable)
		{
			const uint16_t n0=l>>2,n1=n0<<2;

			if (n0>0) CoeffSubD_AVX(&coef,x1,c1,n0);
			for (uint16_t i=n1; i<l; i++)
				c1[i]=coef-x1[i];
		}
		else
		{
			if (SSE2_Enable)
			{
				const uint16_t n0=l>>1,n1=n0<<1;

				if (n0>0) CoeffSubD_SSE2(&coef,x1,c1,n0);
				for (uint16_t i=n1; i<l; i++)
					c1[i]=coef-x1[i];
			}
			else
			{
				for (uint16_t i=0; i<l; i++)
					c1[i]=coef-x1[i];
			}
		}
	}
}


void Vector_Compute::SubD(const double coef)
{
	const uint16_t l=length;
	double *c1=(double *)Coeff;

#ifdef AVX512_BUILD_POSSIBLE
	if (AVX512_Enable)
	{
		const uint16_t n0=l>>3,n1=n0<<3;

		if (n0>0) CoeffSub2D_AVX512(&coef,c1,n0);
		for (uint16_t i=n1; i<l; i++)
			c1[i]=coef-c1[i];
	}
	else
#endif
	{
		if (AVX_Enable)
		{
			const uint16_t n0=l>>2,n1=n0<<2;

			if (n0>0) CoeffSub2D_AVX(&coef,c1,n0);
			for (uint16_t i=n1; i<l; i++)
				c1[i]=coef-c1[i];
		}
		else
		{
			if (SSE2_Enable)
			{
				const uint16_t n0=l>>1,n1=n0<<1;

				if (n0>0) CoeffSub2D_SSE2(&coef,c1,n0);
				for (uint16_t i=n1; i<l; i++)
					c1[i]=coef-c1[i];
			}
			else
			{
				for (uint16_t i=0; i<l; i++)
					c1[i]=coef-c1[i];
			}
		}
	}
}


bool Vector_Compute::Add_X(const Vector &x,const Vector &y)
{
	if ((Coeff==nullptr) || (length==0)) return(false);
	if (!x.AllocCheck() || !y.AllocCheck()) return(false);

	if ((x.GetLength()!=y.GetLength()) || (length!=x.GetLength()) || (x.GetDataType()!=y.GetDataType())
		|| (x.GetDataType()!=data_type)) return(false);

	switch(data_type)
	{
		case DATA_FLOAT : AddF_X(x,y); break;
		case DATA_DOUBLE : AddD_X(x,y); break;
		default : return(false);
	}

	return(true);
}


bool Vector_Compute::Add_X(const Vector &x)
{
	if ((Coeff==nullptr) || (length==0)) return(false);
	if (!x.AllocCheck()) return(false);

	if ((length!=x.GetLength()) || (x.GetDataType()!=data_type)) return(false);

	switch(data_type)
	{
		case DATA_FLOAT : AddF_X(x); break;
		case DATA_DOUBLE : AddD_X(x); break;
		default : return(false);
	}

	return(true);
}


void Vector_Compute::AddF_X(const Vector &x,const Vector &y)
{
	const uint16_t l=length;
	const float *x1=(const float *)x.GetPtrVector();
	const float *y1=(const float *)y.GetPtrVector();
	float *c1=(float *)Coeff;

#ifdef AVX512_BUILD_POSSIBLE
	if (AVX512_Enable)
	{
		const uint16_t n=(l+15)>>4;

		VectorAddF_AVX512(x1,y1,c1,n);
	}
	else
#endif
	{
		if (AVX_Enable)
		{
			const uint16_t n=(l+7)>>3;

			VectorAddF_AVX(x1,y1,c1,n);
		}
		else
		{
			if (SSE2_Enable)
			{
				const uint16_t n=(l+3)>>2;

				VectorAddF_SSE2(x1,y1,c1,n);
			}
			else
			{
				for (uint16_t i=0; i<l; i++)
					c1[i]=x1[i]+y1[i];
			}
		}
	}
}


void Vector_Compute::AddF_X(const Vector &x)
{
	const uint16_t l=length;
	const float *x1=(const float *)x.GetPtrVector();
	float *c1=(float *)Coeff;

#ifdef AVX512_BUILD_POSSIBLE
	if (AVX512_Enable)
	{
		const uint16_t n=(l+15)>>4;

		VectorAdd2F_AVX512(c1,x1,n);
	}
	else
#endif
	{
		if (AVX_Enable)
		{
			const uint16_t n=(l+7)>>3;

			VectorAdd2F_AVX(c1,x1,n);
		}
		else
		{
			if (SSE2_Enable)
			{
				const uint16_t n=(l+3)>>2;

				VectorAdd2F_SSE2(c1,x1,n);
			}
			else
			{
				for (uint16_t i=0; i<l; i++)
					c1[i]+=x1[i];
			}
		}
	}
}


void Vector_Compute::AddD_X(const Vector &x,const Vector &y)
{
	const uint16_t l=length;
	const double *x1=(const double *)x.GetPtrVector();
	const double *y1=(const double *)y.GetPtrVector();
	double *c1=(double *)Coeff;

#ifdef AVX512_BUILD_POSSIBLE
	if (AVX512_Enable)
	{
		const uint16_t n=(l+7)>>3;

		VectorAddD_AVX512(x1,y1,c1,n);
	}
	else
#endif
	{
		if (AVX_Enable)
		{
			const uint16_t n=(l+3)>>2;

			VectorAddD_AVX(x1,y1,c1,n);
		}
		else
		{
			if (SSE2_Enable)
			{
				const uint16_t n=(l+1)>>1;

				VectorAddD_SSE2(x1,y1,c1,n);
			}
			else
			{
				for (uint16_t i=0; i<l; i++)
					c1[i]=x1[i]+y1[i];
			}
		}
	}
}


void Vector_Compute::AddD_X(const Vector &x)
{
	const uint16_t l=length;
	const double *x1=(const double *)x.GetPtrVector();
	double *c1=(double *)Coeff;

#ifdef AVX512_BUILD_POSSIBLE
	if (AVX512_Enable)
	{
		const uint16_t n=(l+7)>>3;

		VectorAdd2D_AVX512(c1,x1,n);
	}
	else
#endif
	{
		if (AVX_Enable)
		{
			const uint16_t n=(l+3)>>2;

			VectorAdd2D_AVX(c1,x1,n);
		}
		else
		{
			if (SSE2_Enable)
			{
				const uint16_t n=(l+1)>>1;

				VectorAdd2D_SSE2(c1,x1,n);
			}
			else
			{
				for (uint16_t i=0; i<l; i++)
					c1[i]+=x1[i];
			}
		}
	}
}


bool Vector_Compute::Sub_X(const Vector &x,const Vector &y)
{
	if ((Coeff==nullptr) || (length==0)) return(false);
	if (!x.AllocCheck() || !y.AllocCheck()) return(false);

	if ((x.GetLength()!=y.GetLength()) || (length!=x.GetLength()) || (x.GetDataType()!=y.GetDataType())
		|| (x.GetDataType()!=data_type)) return(false);

	switch(data_type)
	{
		case DATA_FLOAT : SubF_X(x,y); break;
		case DATA_DOUBLE : SubD_X(x,y); break;
		default : return(false);
	}

	return(true);
}


bool Vector_Compute::Sub_X(const Vector &x)
{
	if ((Coeff==nullptr) || (length==0)) return(false);
	if (!x.AllocCheck()) return(false);

	if ((length!=x.GetLength()) || (x.GetDataType()!=data_type)) return(false);

	switch(data_type)
	{
		case DATA_FLOAT : SubF_X(x); break;
		case DATA_DOUBLE : SubD_X(x); break;
		default : return(false);
	}

	return(true);
}


bool Vector_Compute::InvSub_X(const Vector &x)
{
	if ((Coeff==nullptr) || (length==0)) return(false);
	if (!x.AllocCheck()) return(false);

	if ((length!=x.GetLength()) || (x.GetDataType()!=data_type)) return(false);

	switch(data_type)
	{
		case DATA_FLOAT : InvSubF_X(x); break;
		case DATA_DOUBLE : InvSubD_X(x); break;
		default : return(false);
	}

	return(true);
}


void Vector_Compute::SubF_X(const Vector &x,const Vector &y)
{
	const uint16_t l=length;
	const float *x1=(const float *)x.GetPtrVector();
	const float *y1=(const float *)y.GetPtrVector();
	float *c1=(float *)Coeff;

#ifdef AVX512_BUILD_POSSIBLE
	if (AVX512_Enable)
	{
		const uint16_t n=(l+15)>>4;

		VectorSubF_AVX512(x1,y1,c1,n);
	}
	else
#endif
	{
		if (AVX_Enable)
		{
			const uint16_t n=(l+7)>>3;

			VectorSubF_AVX(x1,y1,c1,n);
		}
		else
		{
			if (SSE2_Enable)
			{
				const uint16_t n=(l+3)>>2;

				VectorSubF_SSE2(x1,y1,c1,n);
			}
			else
			{
				for (uint16_t i=0; i<l; i++)
					c1[i]=x1[i]-y1[i];
			}
		}
	}
}


void Vector_Compute::SubF_X(const Vector &x)
{
	const uint16_t l=length;
	const float *x1=(const float *)x.GetPtrVector();
	float *c1=(float *)Coeff;

#ifdef AVX512_BUILD_POSSIBLE
	if (AVX512_Enable)
	{
		const uint16_t n=(l+15)>>4;

		VectorSub2F_AVX512(c1,x1,n);
	}
	else
#endif
	{
		if (AVX_Enable)
		{
			const uint16_t n=(l+7)>>3;

			VectorSub2F_AVX(c1,x1,n);
		}
		else
		{
			if (SSE2_Enable)
			{
				const uint16_t n=(l+3)>>2;

				VectorSub2F_SSE2(c1,x1,n);
			}
			else
			{
				for (uint16_t i=0; i<l; i++)
					c1[i]-=x1[i];
			}
		}
	}
}


void Vector_Compute::InvSubF_X(const Vector &x)
{
	const uint16_t l=length;
	const float *x1=(const float *)x.GetPtrVector();
	float *c1=(float *)Coeff;

#ifdef AVX512_BUILD_POSSIBLE
	if (AVX512_Enable)
	{
		const uint16_t n=(l+15)>>4;

		VectorInvSubF_AVX512(c1,x1,n);
	}
	else
#endif
	{
		if (AVX_Enable)
		{
			const uint16_t n=(l+7)>>3;

			VectorInvSubF_AVX(c1,x1,n);
		}
		else
		{
			if (SSE2_Enable)
			{
				const uint16_t n=(l+3)>>2;

				VectorInvSubF_SSE2(c1,x1,n);
			}
			else
			{
				for (uint16_t i=0; i<l; i++)
					c1[i]=x1[i]-c1[i];
			}
		}
	}
}


void Vector_Compute::SubD_X(const Vector &x,const Vector &y)
{
	const uint16_t l=length;
	const double *x1=(const double *)x.GetPtrVector();
	const double *y1=(const double *)y.GetPtrVector();
	double *c1=(double *)Coeff;

#ifdef AVX512_BUILD_POSSIBLE
	if (AVX512_Enable)
	{
		const uint16_t n=(l+7)>>3;

		VectorSubD_AVX512(x1,y1,c1,n);
	}
	else
#endif
	{
		if (AVX_Enable)
		{
			const uint16_t n=(l+3)>>2;

			VectorSubD_AVX(x1,y1,c1,n);
		}
		else
		{
			if (SSE2_Enable)
			{
				const uint16_t n=(l+1)>>1;

				VectorSubD_SSE2(x1,y1,c1,n);
			}
			else
			{
				for (uint16_t i=0; i<l; i++)
					c1[i]=x1[i]-y1[i];
			}
		}
	}
}


void Vector_Compute::SubD_X(const Vector &x)
{
	const uint16_t l=length;
	const double *x1=(const double *)x.GetPtrVector();
	double *c1=(double *)Coeff;

#ifdef AVX512_BUILD_POSSIBLE
	if (AVX512_Enable)
	{
		const uint16_t n=(l+7)>>3;

		VectorSub2D_AVX512(c1,x1,n);
	}
	else
#endif
	{
		if (AVX_Enable)
		{
			const uint16_t n=(l+3)>>2;

			VectorSub2D_AVX(c1,x1,n);
		}
		else
		{
			if (SSE2_Enable)
			{
				const uint16_t n=(l+1)>>1;

				VectorSub2D_SSE2(c1,x1,n);
			}
			else
			{
				for (uint16_t i=0; i<l; i++)
					c1[i]-=x1[i];
			}
		}
	}
}


void Vector_Compute::InvSubD_X(const Vector &x)
{
	const uint16_t l=length;
	const double *x1=(const double *)x.GetPtrVector();
	double *c1=(double *)Coeff;

#ifdef AVX512_BUILD_POSSIBLE
	if (AVX512_Enable)
	{
		const uint16_t n=(l+7)>>3;

		VectorInvSubD_AVX512(c1,x1,n);
	}
	else
#endif
	{
		if (AVX_Enable)
		{
			const uint16_t n=(l+3)>>2;

			VectorInvSubD_AVX(c1,x1,n);
		}
		else
		{
			if (SSE2_Enable)
			{
				const uint16_t n=(l+1)>>1;

				VectorInvSubD_SSE2(c1,x1,n);
			}
			else
			{
				for (uint16_t i=0; i<l; i++)
					c1[i]=x1[i]-c1[i];
			}
		}
	}
}


bool Vector_Compute::Mult_X(const Vector &x,const Vector &y)
{
	if ((Coeff==nullptr) || (length==0)) return(false);
	if (!x.AllocCheck() || !y.AllocCheck()) return(false);

	if ((x.GetLength()!=y.GetLength()) || (length!=x.GetLength()) || (x.GetDataType()!=y.GetDataType())
		|| (x.GetDataType()!=data_type)) return(false);

	switch(data_type)
	{
		case DATA_FLOAT : MultF_X(x,y); break;
		case DATA_DOUBLE : MultD_X(x,y); break;
		default : return(false);
	}

	return(true);
}


bool Vector_Compute::Mult_X(const Vector &x)
{
	if ((Coeff==nullptr) || (length==0)) return(false);
	if (!x.AllocCheck()) return(false);

	if ((length!=x.GetLength()) || (x.GetDataType()!=data_type)) return(false);

	switch(data_type)
	{
		case DATA_FLOAT : MultF_X(x); break;
		case DATA_DOUBLE : MultD_X(x); break;
		default : return(false);
	}

	return(true);
}


void Vector_Compute::MultF_X(const Vector &x,const Vector &y)
{
	const uint16_t l=length;
	const float *x1=(const float *)x.GetPtrVector();
	const float *y1=(const float *)y.GetPtrVector();
	float *c1=(float *)Coeff;

#ifdef AVX512_BUILD_POSSIBLE
	if (AVX512_Enable)
	{
		const uint16_t n=(l+15)>>4;

		VectorProdF_AVX512(x1,y1,c1,n);
	}
	else
#endif
	{
		if (AVX_Enable)
		{
			const uint16_t n=(l+7)>>3;

			VectorProdF_AVX(x1,y1,c1,n);
		}
		else
		{
			if (SSE2_Enable)
			{
				const uint16_t n=(l+3)>>2;

				VectorProdF_SSE2(x1,y1,c1,n);
			}
			else
			{
				for (uint16_t i=0; i<l; i++)
					c1[i]=x1[i]*y1[i];
			}
		}
	}
}


void Vector_Compute::MultF_X(const Vector &x)
{
	const uint16_t l=length;
	const float *x1=(const float *)x.GetPtrVector();
	float *c1=(float *)Coeff;

#ifdef AVX512_BUILD_POSSIBLE
	if (AVX512_Enable)
	{
		const uint16_t n=(l+15)>>4;

		VectorProd2F_AVX512(c1,x1,n);
	}
	else
#endif
	{
		if (AVX_Enable)
		{
			const uint16_t n=(l+7)>>3;

			VectorProd2F_AVX(c1,x1,n);
		}
		else
		{
			if (SSE2_Enable)
			{
				const uint16_t n=(l+3)>>2;

				VectorProd2F_SSE2(c1,x1,n);
			}
			else
			{
				for (uint16_t i=0; i<l; i++)
					c1[i]*=x1[i];
			}
		}
	}
}


void Vector_Compute::MultD_X(const Vector &x,const Vector &y)
{
	const uint16_t l=length;
	const double *x1=(const double *)x.GetPtrVector();
	const double *y1=(const double *)y.GetPtrVector();
	double *c1=(double *)Coeff;

#ifdef AVX512_BUILD_POSSIBLE
	if (AVX512_Enable)
	{
		const uint16_t n=(l+7)>>3;

		VectorProdD_AVX512(x1,y1,c1,n);
	}
	else
#endif
	{
		if (AVX_Enable)
		{
			const uint16_t n=(l+3)>>2;

			VectorProdD_AVX(x1,y1,c1,n);
		}
		else
		{
			if (SSE2_Enable)
			{
				const uint16_t n=(l+1)>>1;

				VectorProdD_SSE2(x1,y1,c1,n);
			}
			else
			{
				for (uint16_t i=0; i<l; i++)
					c1[i]=x1[i]*y1[i];
			}
		}
	}
}


void Vector_Compute::MultD_X(const Vector &x)
{
	const uint16_t l=length;
	const double *x1=(const double *)x.GetPtrVector();
	double *c1=(double *)Coeff;

#ifdef AVX512_BUILD_POSSIBLE
	if (AVX512_Enable)
	{
		const uint16_t n=(l+7)>>3;

		VectorProd2D_AVX512(c1,x1,n);
	}
	else
#endif
	{
		if (AVX_Enable)
		{
			const uint16_t n=(l+3)>>2;

			VectorProd2D_AVX(c1,x1,n);
		}
		else
		{
			if (SSE2_Enable)
			{
				const uint16_t n=(l+1)>>1;

				VectorProd2D_SSE2(c1,x1,n);
			}
			else
			{
				for (uint16_t i=0; i<l; i++)
					c1[i]*=x1[i];
			}
		}
	}
}


bool Vector_Compute::Distance2(const Vector &x,double &result)
{
	if ((Coeff==nullptr) || (length==0)) return(false);
	if (!x.AllocCheck()) return(false);

	if ((length!=x.GetLength()) || (x.GetDataType()!=data_type)) return(false);

	switch(data_type)
	{
		case DATA_FLOAT : result=Distance2F(x); break;
		case DATA_DOUBLE : result=Distance2D(x); break;
		default : return(false);
	}

	return(true);
}


double Vector_Compute::Distance2F(const Vector &x)
{
	const uint16_t l=length;
	const float *x1=(const float *)x.GetPtrVector();
	const float *c1=(const float *)Coeff;

#ifdef AVX512_BUILD_POSSIBLE
	if (AVX512_Enable)
	{
		float r;
		const uint16_t n=(l+15)>>4;

		VectorDist2F_AVX512(x1,c1,&r,n);

		return((double)r);
	}
	else
#endif
	{
		if (AVX_Enable)
		{
			float r;
			const uint16_t n=(l+7)>>3;

			VectorDist2F_AVX(x1,c1,&r,n);

			return((double)r);
		}
		else
		{
			if (SSE2_Enable)
			{
				float r;
				const uint16_t n=(l+3)>>2;

				VectorDist2F_SSE2(x1,c1,&r,n);

				return((double)r);
			}
			else
			{
				double r=0.0;

				for (uint16_t i=0; i<l; i++)
				{
					double d=(double)(c1[i]-x1[i]);

					r+=d*d;
				}
				r=sqrt(r);
				return(r);
			}
		}
	}
}


double Vector_Compute::Distance2D(const Vector &x)
{
	const uint16_t l=length;
	const double *x1=(const double *)x.GetPtrVector();
	const double *c1=(const double *)Coeff;
	double r;

#ifdef AVX512_BUILD_POSSIBLE
	if (AVX512_Enable)
	{
		const uint16_t n=(l+7)>>3;

		VectorDist2D_AVX512(x1,c1,&r,n);
	}
	else
#endif
	{
		if (AVX_Enable)
		{
			const uint16_t n=(l+3)>>2;

			VectorDist2D_AVX(x1,c1,&r,n);
		}
		else
		{
			if (SSE2_Enable)
			{
				const uint16_t n=(l+1)>>1;

				VectorDist2D_SSE2(x1,c1,&r,n);
			}
			else
			{
				r=0.0;
				for (uint16_t i=0; i<l; i++)
				{
					double d=c1[i]-x1[i];

					r+=d*d;
				}
				r=sqrt(r);
			}
		}
	}
	return(r);
}


bool Vector_Compute::Distance1(const Vector &x,double &result)
{
	if ((Coeff==nullptr) || (length==0)) return(false);
	if (!x.AllocCheck()) return(false);

	if ((length!=x.GetLength()) || (x.GetDataType()!=data_type)) return(false);

	switch(data_type)
	{
		case DATA_FLOAT : result=Distance1F(x); break;
		case DATA_DOUBLE : result=Distance1D(x); break;
		default : return(false);
	}

	return(true);
}


double Vector_Compute::Distance1F(const Vector &x)
{
	const uint16_t l=length;
	const float *x1=(const float *)x.GetPtrVector();
	const float *c1=(const float *)Coeff;

#ifdef AVX512_BUILD_POSSIBLE
	if (AVX512_Enable)
	{
		float r;
		const uint16_t n=(l+15)>>4;

		VectorDist1F_AVX512(x1,c1,&r,n);

		return((double)r);
	}
	else
#endif
	{
		if (AVX_Enable)
		{
			float r;
			const uint16_t n=(l+7)>>3;

			VectorDist1F_AVX(x1,c1,&r,n);

			return((double)r);
		}
		else
		{
			if (SSE2_Enable)
			{
				float r;
				const uint16_t n=(l+3)>>2;

				VectorDist1F_SSE2(x1,c1,&r,n);

				return((double)r);
			}
			else
			{
				double r=0.0;

				for (uint16_t i=0; i<l; i++)
					r+=fabs(c1[i]-x1[i]);
				return(r);
			}
		}
	}
}


double Vector_Compute::Distance1D(const Vector &x)
{
	const uint16_t l=length;
	const double *x1=(const double *)x.GetPtrVector();
	const double *c1=(const double *)Coeff;
	double r;

#ifdef AVX512_BUILD_POSSIBLE
	if (AVX512_Enable)
	{
		const uint16_t n=(l+7)>>3;

		VectorDist1D_AVX512(x1,c1,&r,n);
	}
	else
#endif
	{
		if (AVX_Enable)
		{
			const uint16_t n=(l+3)>>2;

			VectorDist1D_AVX(x1,c1,&r,n);
		}
		else
		{
			if (SSE2_Enable)
			{
				const uint16_t n=(l+1)>>1;

				VectorDist1D_SSE2(x1,c1,&r,n);
			}
			else
			{
				r=0.0;
				for (uint16_t i=0; i<l; i++)
					r+=fabs(c1[i]-x1[i]);
			}
		}
	}
	return(r);
}


bool Vector_Compute::Norme2(double &result)
{
	if ((Coeff==nullptr) || (length==0)) return(false);

	switch(data_type)
	{
		case DATA_FLOAT : result=Norme2F(); break;
		case DATA_DOUBLE : result=Norme2D(); break;
		default : return(false);
	}

	return(true);
}


double Vector_Compute::Norme2F(void)
{
	const uint16_t l=length;
	float *c1=(float *)Coeff;

#ifdef AVX512_BUILD_POSSIBLE
	if (AVX512_Enable)
	{
		float r;
		const uint16_t n=(l+15)>>4;

		VectorNorme2F_AVX512(c1,&r,n);

		return((double)r);
	}
	else
#endif
	{
		if (AVX_Enable)
		{
			float r;
			const uint16_t n=(l+7)>>3;

			VectorNorme2F_AVX(c1,&r,n);

			return((double)r);
		}
		else
		{
			if (SSE2_Enable)
			{
				float r;
				const uint16_t n=(l+3)>>2;

				VectorNorme2F_SSE2(c1,&r,n);

				return((double)r);
			}
			else
			{
				double r=0.0;

				for (uint16_t i=0; i<l; i++)
				{
					const double d=c1[i];
					r+=d*d;
				}
				r=sqrt(r);
				return(r);
			}
		}
	}
}


double Vector_Compute::Norme2D(void)
{
	const uint16_t l=length;
	double *c1=(double *)Coeff;
	double r;

#ifdef AVX512_BUILD_POSSIBLE
	if (AVX512_Enable)
	{
		const uint16_t n=(l+7)>>3;

		VectorNorme2D_AVX512(c1,&r,n);
	}
	else
#endif
	{
		if (AVX_Enable)
		{
			const uint16_t n=(l+3)>>2;

			VectorNorme2D_AVX(c1,&r,n);
		}
		else
		{
			if (SSE2_Enable)
			{
				const uint16_t n=(l+1)>>1;

				VectorNorme2D_SSE2(c1,&r,n);
			}
			else
			{
				r=0.0;
				for (uint16_t i=0; i<l; i++)
				{
					const double d=c1[i];
					r+=d*d;
				}
				r=sqrt(r);
			}
		}
	}
	return(r);
}


bool Vector_Compute::Norme1(double &result)
{
	if ((Coeff==nullptr) || (length==0)) return(false);

	switch(data_type)
	{
		case DATA_FLOAT : result=Norme1F(); break;
		case DATA_DOUBLE : result=Norme1D(); break;
		default : return(false);
	}

	return(true);
}


double Vector_Compute::Norme1F(void)
{
	const uint16_t l=length;
	float *c1=(float *)Coeff;

#ifdef AVX512_BUILD_POSSIBLE
	if (AVX512_Enable)
	{
		float r;
		const uint16_t n=(l+15)>>4;

		VectorNorme1F_AVX512(c1,&r,n);

		return((double)r);
	}
	else
#endif
	{
		if (AVX_Enable)
		{
			float r;
			const uint16_t n=(l+7)>>3;

			VectorNorme1F_AVX(c1,&r,n);

			return((double)r);
		}
		else
		{
			if (SSE2_Enable)
			{
				float r;
				const uint16_t n=(l+3)>>2;

				VectorNorme1F_SSE2(c1,&r,n);

				return((double)r);
			}
			else
			{
				double r=0.0;

				for (uint16_t i=0; i<l; i++)
					r+=fabs(c1[i]);
				return(r);
			}
		}
	}
}


double Vector_Compute::Norme1D(void)
{
	const uint16_t l=length;
	double *c1=(double *)Coeff;
	double r;

#ifdef AVX512_BUILD_POSSIBLE
	if (AVX512_Enable)
	{
		const uint16_t n=(l+7)>>3;

		VectorNorme1D_AVX512(c1,&r,n);
	}
	else
#endif
	{
		if (AVX_Enable)
		{
			const uint16_t n=(l+3)>>2;

			VectorNorme1D_AVX(c1,&r,n);
		}
		else
		{
			if (SSE2_Enable)
			{
				const uint16_t n=(l+1)>>1;

				VectorNorme1D_SSE2(c1,&r,n);
			}
			else
			{
				r=0.0;
				for (uint16_t i=0; i<l; i++)
					r+=fabs(c1[i]);
			}
		}
	}
	return(r);
}


// +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
// +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

Matrix::Matrix(void)
{
	Coeff=nullptr;
	columns=0; lines=0;
	size=0;
	pitch=0;
	data_type=DATA_NONE;
}


Matrix::Matrix(const uint16_t l,const uint16_t c,const COEFF_DATA_TYPE data)
{
	Coeff=nullptr;
	columns=0; lines=0;
	size=0;
	pitch=0;
	data_type=DATA_NONE;

	if ((c==0) || (l==0)) return;

	size_t coeff_size;

	switch(data)
	{
		case DATA_FLOAT : coeff_size=sizeof(float); break;
		case DATA_DOUBLE : coeff_size=sizeof(double); break;
		case DATA_UINT64 : coeff_size=sizeof(uint64_t); break;
		case DATA_INT64 : coeff_size=sizeof(int64_t); break;
		case DATA_UINT32 : coeff_size=sizeof(uint32_t); break;
		case DATA_INT32 : coeff_size=sizeof(int32_t); break;
		case DATA_UINT16 : coeff_size=sizeof(uint16_t); break;
		case DATA_INT16 : coeff_size=sizeof(int16_t); break;
		case DATA_UINT8 : coeff_size=sizeof(uint8_t); break;
		case DATA_INT8 : coeff_size=sizeof(int8_t); break;
		default : coeff_size=0; break;
	}
	if (coeff_size==0) return;

	const ptrdiff_t p0=((((ptrdiff_t)c*coeff_size)+MATRIX_ALIGN_SIZE-1) >> MATRIX_ALIGN_SHIFT) << MATRIX_ALIGN_SHIFT;

	Coeff=(void *)_aligned_malloc((size_t)p0*(size_t)l,MATRIX_ALIGN_SIZE);
	if (Coeff==nullptr) return;

	size=(size_t)p0*(size_t)l;
	pitch=p0;
	columns=c; lines=l;
	data_type=data;

	const size_t n0=(size_t)c*coeff_size,n=(size_t)p0-n0;

	if (n>0) 
	{
		uint8_t *a=(uint8_t *)Coeff;

		switch(data_type)
		{
			case DATA_FLOAT :
				for(uint16_t i=0; i<l; i++)
				{
					std::fill_n((float *)(a+n0),n>>2,0.0f);
					a+=p0;
				}
				break;
			case DATA_DOUBLE :
				for(uint16_t i=0; i<l; i++)
				{
					std::fill_n((double *)(a+n0),n>>3,0.0);
					a+=p0;
				}
				break;
			default :
				for(uint16_t i=0; i<l; i++)
				{
					memset(a+n0,0,n);
					a+=p0;
				}
				break;
		}
	}
}


Matrix::Matrix(const Matrix &m)
{
	Coeff=nullptr;
	columns=0; lines=0;
	size=0;
	pitch=0;
	data_type=DATA_NONE;

	const uint16_t c=m.columns,l=m.lines;

	if ((m.Coeff==nullptr) || (c==0) || (l==0)) return;

	size_t coeff_size;

	switch(m.data_type)
	{
		case DATA_FLOAT : coeff_size=sizeof(float); break;
		case DATA_DOUBLE : coeff_size=sizeof(double); break;
		case DATA_UINT64 : coeff_size=sizeof(uint64_t); break;
		case DATA_INT64 : coeff_size=sizeof(int64_t); break;
		case DATA_UINT32 : coeff_size=sizeof(uint32_t); break;
		case DATA_INT32 : coeff_size=sizeof(int32_t); break;
		case DATA_UINT16 : coeff_size=sizeof(uint16_t); break;
		case DATA_INT16 : coeff_size=sizeof(int16_t); break;
		case DATA_UINT8 : coeff_size=sizeof(uint8_t); break;
		case DATA_INT8 : coeff_size=sizeof(int8_t); break;
		default : coeff_size=0; break;
	}
	if (coeff_size==0) return;

	const ptrdiff_t p0=((((ptrdiff_t)c*coeff_size)+MATRIX_ALIGN_SIZE-1) >> MATRIX_ALIGN_SHIFT) << MATRIX_ALIGN_SHIFT;

	Coeff=(void *)_aligned_malloc((size_t)p0*(size_t)l,MATRIX_ALIGN_SIZE);
	if (Coeff==nullptr) return;

	size=(size_t)p0*(size_t)l;
	pitch=p0;
	columns=c; lines=l;
	data_type=m.data_type;

	const size_t n0=(size_t)c*coeff_size,n=(size_t)p0-n0;

	if (n>0) 
	{
		uint8_t *a=(uint8_t *)Coeff;

		switch(data_type)
		{
			case DATA_FLOAT :
				for(uint16_t i=0; i<l; i++)
				{
					std::fill_n((float *)(a+n0),n>>2,0.0f);
					a+=p0;
				}
				break;
			case DATA_DOUBLE :
				for(uint16_t i=0; i<l; i++)
				{
					std::fill_n((double *)(a+n0),n>>3,0.0);
					a+=p0;
				}
				break;
			default :
				for(uint16_t i=0; i<l; i++)
				{
					memset(a+n0,0,n);
					a+=p0;
				}
				break;
		}
	}

	CopyStrict(m);
}


Matrix::~Matrix(void)
{
	Destroy();
}


bool Matrix::Create(void)
{
	if ((Coeff!=nullptr) || (columns==0) || (lines==0)) return(false);

	size_t coeff_size;

	switch(data_type)
	{
		case DATA_FLOAT : coeff_size=sizeof(float); break;
		case DATA_DOUBLE : coeff_size=sizeof(double); break;
		case DATA_UINT64 : coeff_size=sizeof(uint64_t); break;
		case DATA_INT64 : coeff_size=sizeof(int64_t); break;
		case DATA_UINT32 : coeff_size=sizeof(uint32_t); break;
		case DATA_INT32 : coeff_size=sizeof(int32_t); break;
		case DATA_UINT16 : coeff_size=sizeof(uint16_t); break;
		case DATA_INT16 : coeff_size=sizeof(int16_t); break;
		case DATA_UINT8 : coeff_size=sizeof(uint8_t); break;
		case DATA_INT8 : coeff_size=sizeof(int8_t); break;
		default : coeff_size=0; break;
	}
	if (coeff_size==0) return(false);

	const ptrdiff_t p0=((((ptrdiff_t)columns*coeff_size)+MATRIX_ALIGN_SIZE-1) >> MATRIX_ALIGN_SHIFT) << MATRIX_ALIGN_SHIFT;

	Coeff=(void *)_aligned_malloc((size_t)p0*(size_t)lines,MATRIX_ALIGN_SIZE);
	if (Coeff==nullptr) return(false);

	size=(size_t)p0*(size_t)lines;
	pitch=p0;

	const size_t n0=(size_t)columns*coeff_size,n=(size_t)p0-n0;

	if (n>0) 
	{
		uint8_t *a=(uint8_t *)Coeff;

		switch(data_type)
		{
			case DATA_FLOAT :
				for(uint16_t i=0; i<lines; i++)
				{
					std::fill_n((float *)(a+n0),n>>2,0.0f);
					a+=p0;
				}
				break;
			case DATA_DOUBLE :
				for(uint16_t i=0; i<lines; i++)
				{
					std::fill_n((double *)(a+n0),n>>3,0.0);
					a+=p0;
				}
				break;
			default :
				for(uint16_t i=0; i<lines; i++)
				{
					memset(a+n0,0,n);
					a+=p0;
				}
				break;
		}
	}

	return(true);
}


bool Matrix::Create(const Matrix &m)
{
	if (Coeff!=nullptr) return(false);

	const uint16_t c=m.columns,l=m.lines;

	if ((m.Coeff==nullptr) || (c==0) || (l==0)) return(false);

	size_t coeff_size;

	switch(m.data_type)
	{
		case DATA_FLOAT : coeff_size=sizeof(float); break;
		case DATA_DOUBLE : coeff_size=sizeof(double); break;
		case DATA_UINT64 : coeff_size=sizeof(uint64_t); break;
		case DATA_INT64 : coeff_size=sizeof(int64_t); break;
		case DATA_UINT32 : coeff_size=sizeof(uint32_t); break;
		case DATA_INT32 : coeff_size=sizeof(int32_t); break;
		case DATA_UINT16 : coeff_size=sizeof(uint16_t); break;
		case DATA_INT16 : coeff_size=sizeof(int16_t); break;
		case DATA_UINT8 : coeff_size=sizeof(uint8_t); break;
		case DATA_INT8 : coeff_size=sizeof(int8_t); break;
		default : coeff_size=0; break;
	}
	if (coeff_size==0) return(false);

	const ptrdiff_t p0=((((ptrdiff_t)c*coeff_size)+MATRIX_ALIGN_SIZE-1) >> MATRIX_ALIGN_SHIFT) << MATRIX_ALIGN_SHIFT;

	Coeff=(void *)_aligned_malloc((size_t)p0*(size_t)l,MATRIX_ALIGN_SIZE);
	if (Coeff==nullptr) return(false);

	size=(size_t)p0*(size_t)l;
	pitch=p0;
	columns=c; lines=l;
	data_type=m.data_type;

	const size_t n0=(size_t)c*coeff_size,n=(size_t)p0-n0;

	if (n>0) 
	{
		uint8_t *a=(uint8_t *)Coeff;

		switch(data_type)
		{
			case DATA_FLOAT :
				for(uint16_t i=0; i<l; i++)
				{
					std::fill_n((float *)(a+n0),n>>2,0.0f);
					a+=p0;
				}
				break;
			case DATA_DOUBLE :
				for(uint16_t i=0; i<l; i++)
				{
					std::fill_n((double *)(a+n0),n>>3,0.0);
					a+=p0;
				}
				break;
			default :
				for(uint16_t i=0; i<l; i++)
				{
					memset(a+n0,0,n);
					a+=p0;
				}
				break;
		}
	}

	return(CopyStrict(m));
}


bool Matrix::Create(const uint16_t l,const uint16_t c,const COEFF_DATA_TYPE data)
{
	if ((Coeff!=nullptr) || (c==0) || (l==0)) return(false);

	size_t coeff_size;

	switch(data)
	{
		case DATA_FLOAT : coeff_size=sizeof(float); break;
		case DATA_DOUBLE : coeff_size=sizeof(double); break;
		case DATA_UINT64 : coeff_size=sizeof(uint64_t); break;
		case DATA_INT64 : coeff_size=sizeof(int64_t); break;
		case DATA_UINT32 : coeff_size=sizeof(uint32_t); break;
		case DATA_INT32 : coeff_size=sizeof(int32_t); break;
		case DATA_UINT16 : coeff_size=sizeof(uint16_t); break;
		case DATA_INT16 : coeff_size=sizeof(int16_t); break;
		case DATA_UINT8 : coeff_size=sizeof(uint8_t); break;
		case DATA_INT8 : coeff_size=sizeof(int8_t); break;
		default : coeff_size=0; break;
	}
	if (coeff_size==0) return(false);

	const ptrdiff_t p0=((((ptrdiff_t)c*coeff_size)+MATRIX_ALIGN_SIZE-1) >> MATRIX_ALIGN_SHIFT) << MATRIX_ALIGN_SHIFT;

	Coeff=(void *)_aligned_malloc((size_t)p0*(size_t)l,MATRIX_ALIGN_SIZE);
	if (Coeff==nullptr) return(false);

	size=(size_t)p0*(size_t)l;
	pitch=p0;
	columns=c; lines=l;

	const size_t n0=(size_t)c*coeff_size,n=(size_t)p0-n0;

	if (n>0) 
	{
		uint8_t *a=(uint8_t *)Coeff;

		switch(data_type)
		{
			case DATA_FLOAT :
				for(uint16_t i=0; i<l; i++)
				{
					std::fill_n((float *)(a+n0),n>>2,0.0f);
					a+=p0;
				}
				break;
			case DATA_DOUBLE :
				for(uint16_t i=0; i<l; i++)
				{
					std::fill_n((double *)(a+n0),n>>3,0.0);
					a+=p0;
				}
				break;
			default :
				for(uint16_t i=0; i<l; i++)
				{
					memset(a+n0,0,n);
					a+=p0;
				}
				break;
		}
	}

	return(true);
}


void Matrix::Destroy(void)
{
	if (Coeff!=nullptr)
	{
		_aligned_free(Coeff);
		Coeff=nullptr;
	}
	columns=0; lines=0;
	size=0;
	pitch=0;
	data_type=DATA_NONE;
}


bool Matrix::FillD(const double data)
{
	const uint16_t l=lines,c=columns;

	if ((Coeff==nullptr) || (c==0) || (l==0) || (data_type!=DATA_DOUBLE)) return(false);

	uint8_t *a=(uint8_t *)Coeff;

	for (uint16_t i=0; i<l; i++)
	{
		std::fill_n((double *)a,c,data);
		a+=pitch;
	}

	return(true);
}


bool Matrix::FillF(const float data)
{
	const uint16_t l=lines,c=columns;

	if ((Coeff==nullptr) || (c==0) || (l==0) || (data_type!=DATA_FLOAT)) return(false);

	uint8_t *a=(uint8_t *)Coeff;

	for (uint16_t i=0; i<l; i++)
	{
		std::fill_n((float *)a,c,data);
		a+=pitch;
	}

	return(true);
}


bool Matrix::FillZero(void)
{
	if ((Coeff==nullptr) || (columns==0) || (lines==0)) return(false);

	uint8_t *a=(uint8_t *)Coeff;

	switch(data_type)
	{
		case DATA_FLOAT :
			for(uint16_t i=0; i<lines; i++)
			{
				std::fill_n((float *)a,columns,0.0f);
				a+=pitch;
			}
			break;
		case DATA_DOUBLE :
			for(uint16_t i=0; i<lines; i++)
			{
				std::fill_n((double *)a,columns,0.0);
				a+=pitch;
			}
			break;
		default : memset(Coeff,0,size); break;
	}

	return(true);
}


bool Matrix::SetInfo(const uint16_t l,const uint16_t c,const COEFF_DATA_TYPE data)
{
	if ((Coeff!=nullptr) || (columns!=0) || (lines!=0) || (c==0) || (l==0) || (data_type==DATA_NONE)) return(false);

	columns=c; lines=l; data_type=data;

	return(true);
}


void Matrix::GetInfo(uint16_t &l,uint16_t &c,COEFF_DATA_TYPE &data) const
{
	c=columns; l=lines; data=data_type;
}


bool Matrix::GetSafeD(const uint16_t i,const uint16_t j,double &d) const
{
	if ((Coeff==nullptr) || (columns==0) || (lines==0) || (i>=lines) || (j>=columns) || (data_type!=DATA_DOUBLE)) return(false);

	d=((double *)((uint8_t *)Coeff+(ptrdiff_t)i*pitch))[j];

	return(true);
}


bool Matrix::SetSafeD(const uint16_t i,const uint16_t j,const double d)
{
	if ((Coeff==nullptr) || (columns==0) || (lines==0) || (i>=lines) || (j>=columns) || (data_type!=DATA_DOUBLE)) return(false);

	((double *)((uint8_t *)Coeff+(ptrdiff_t)i*pitch))[j]=d;

	return(true);
}


bool Matrix::GetSafeF(const uint16_t i,const uint16_t j,float &d) const
{
	if ((Coeff==nullptr) || (columns==0) || (lines==0) || (i>=lines) || (j>=columns) || (data_type!=DATA_FLOAT)) return(false);

	d=((float *)((uint8_t *)Coeff+(ptrdiff_t)i*pitch))[j];

	return(true);
}


bool Matrix::SetSafeF(const uint16_t i,const uint16_t j,const float d)
{
	if ((Coeff==nullptr) || (columns==0) || (lines==0) || (i>=lines) || (j>=columns) || (data_type!=DATA_FLOAT)) return(false);

	((float *)((uint8_t *)Coeff+(ptrdiff_t)i*pitch))[j]=d;

	return(true);
}


bool Matrix::CopyStrict(const Matrix &m)
{
	if ((Coeff==nullptr) || (columns==0) || (lines==0)) return(false);

	const uint16_t c=m.columns,l=m.lines;

	if ((m.Coeff==nullptr) || (c==0) || (l==0) || (c!=columns) || (l!=lines) || (m.data_type!=data_type)) return(false);

	size_t coeff_size;

	switch(data_type)
	{
		case DATA_FLOAT : coeff_size=sizeof(float); break;
		case DATA_DOUBLE : coeff_size=sizeof(double); break;
		case DATA_UINT64 : coeff_size=sizeof(uint64_t); break;
		case DATA_INT64 : coeff_size=sizeof(int64_t); break;
		case DATA_UINT32 : coeff_size=sizeof(uint32_t); break;
		case DATA_INT32 : coeff_size=sizeof(int32_t); break;
		case DATA_UINT16 : coeff_size=sizeof(uint16_t); break;
		case DATA_INT16 : coeff_size=sizeof(int16_t); break;
		case DATA_UINT8 : coeff_size=sizeof(uint8_t); break;
		case DATA_INT8 : coeff_size=sizeof(int8_t); break;
		default : coeff_size=0; break;
	}
	if (coeff_size==0) return(false);

	const ptrdiff_t pa=m.pitch,p=pitch;
	const uint8_t *a=(const uint8_t *)m.Coeff;
	uint8_t *b=(uint8_t *)Coeff;
	const size_t size_line=(size_t)c*coeff_size;

	for (uint16_t i=0; i<l; i++)
	{
		memcpy(b,a,size_line);
		a+=pa;
		b+=p;
	}

	return(true);
}


bool Matrix::CopyRaw(const void *ptr)
{
	if ((Coeff==nullptr) || (ptr==nullptr) || (columns==0) || (lines==0)) return(false);

	size_t coeff_size;

	switch(data_type)
	{
		case DATA_FLOAT : coeff_size=sizeof(float); break;
		case DATA_DOUBLE : coeff_size=sizeof(double); break;
		case DATA_UINT64 : coeff_size=sizeof(uint64_t); break;
		case DATA_INT64 : coeff_size=sizeof(int64_t); break;
		case DATA_UINT32 : coeff_size=sizeof(uint32_t); break;
		case DATA_INT32 : coeff_size=sizeof(int32_t); break;
		case DATA_UINT16 : coeff_size=sizeof(uint16_t); break;
		case DATA_INT16 : coeff_size=sizeof(int16_t); break;
		case DATA_UINT8 : coeff_size=sizeof(uint8_t); break;
		case DATA_INT8 : coeff_size=sizeof(int8_t); break;
		default : coeff_size=0; break;
	}
	if (coeff_size==0) return(false);

	const uint8_t *a=(const uint8_t *)ptr;
	uint8_t *b=(uint8_t *)Coeff;
	const size_t size_line=(size_t)columns*coeff_size;

	for (uint16_t i=0; i<lines; i++)
	{
		memcpy(b,a,size_line);
		a+=size_line;
		b+=pitch;
	}

	return(true);
}


bool Matrix::CopyRaw(const void *ptr,const ptrdiff_t ptr_pitch)
{
	if ((Coeff==nullptr) || (ptr==nullptr) || (columns==0) || (lines==0)) return(false);

	size_t coeff_size;

	switch(data_type)
	{
		case DATA_FLOAT : coeff_size=sizeof(float); break;
		case DATA_DOUBLE : coeff_size=sizeof(double); break;
		case DATA_UINT64 : coeff_size=sizeof(uint64_t); break;
		case DATA_INT64 : coeff_size=sizeof(int64_t); break;
		case DATA_UINT32 : coeff_size=sizeof(uint32_t); break;
		case DATA_INT32 : coeff_size=sizeof(int32_t); break;
		case DATA_UINT16 : coeff_size=sizeof(uint16_t); break;
		case DATA_INT16 : coeff_size=sizeof(int16_t); break;
		case DATA_UINT8 : coeff_size=sizeof(uint8_t); break;
		case DATA_INT8 : coeff_size=sizeof(int8_t); break;
		default : coeff_size=0; break;
	}
	if (coeff_size==0) return(false);

	const uint8_t *a=(const uint8_t *)ptr;
	uint8_t *b=(uint8_t *)Coeff;
	const size_t size_line=(size_t)columns*coeff_size;

	for (uint16_t i=0; i<lines; i++)
	{
		memcpy(b,a,size_line);
		a+=ptr_pitch;
		b+=pitch;
	}

	return(true);
}


bool Matrix::CopyRaw(const void *ptr,const ptrdiff_t ptr_pitch,const uint16_t ln,const uint16_t co)
{
	if ((Coeff==nullptr) || (ptr==nullptr) || (columns==0) || (lines==0) || (ln>lines) || (co>columns)) return(false);

	size_t coeff_size;

	switch(data_type)
	{
		case DATA_FLOAT : coeff_size=sizeof(float); break;
		case DATA_DOUBLE : coeff_size=sizeof(double); break;
		case DATA_UINT64 : coeff_size=sizeof(uint64_t); break;
		case DATA_INT64 : coeff_size=sizeof(int64_t); break;
		case DATA_UINT32 : coeff_size=sizeof(uint32_t); break;
		case DATA_INT32 : coeff_size=sizeof(int32_t); break;
		case DATA_UINT16 : coeff_size=sizeof(uint16_t); break;
		case DATA_INT16 : coeff_size=sizeof(int16_t); break;
		case DATA_UINT8 : coeff_size=sizeof(uint8_t); break;
		case DATA_INT8 : coeff_size=sizeof(int8_t); break;
		default : coeff_size=0; break;
	}
	if (coeff_size==0) return(false);

	const uint8_t *a=(const uint8_t *)ptr;
	uint8_t *b=(uint8_t *)Coeff;
	const size_t size_line=(size_t)co*coeff_size;

	for (uint16_t i=0; i<ln; i++)
	{
		memcpy(b,a,size_line);
		a+=ptr_pitch;
		b+=pitch;
	}

	return(true);
}


bool Matrix::ExportRaw(void *ptr)
{
	if ((Coeff==nullptr) || (ptr==nullptr) || (columns==0) || (lines==0)) return(false);

	size_t coeff_size;

	switch(data_type)
	{
		case DATA_FLOAT : coeff_size=sizeof(float); break;
		case DATA_DOUBLE : coeff_size=sizeof(double); break;
		case DATA_UINT64 : coeff_size=sizeof(uint64_t); break;
		case DATA_INT64 : coeff_size=sizeof(int64_t); break;
		case DATA_UINT32 : coeff_size=sizeof(uint32_t); break;
		case DATA_INT32 : coeff_size=sizeof(int32_t); break;
		case DATA_UINT16 : coeff_size=sizeof(uint16_t); break;
		case DATA_INT16 : coeff_size=sizeof(int16_t); break;
		case DATA_UINT8 : coeff_size=sizeof(uint8_t); break;
		case DATA_INT8 : coeff_size=sizeof(int8_t); break;
		default : coeff_size=0; break;
	}
	if (coeff_size==0) return(false);

	uint8_t *a=(uint8_t *)ptr;
	uint8_t *b=(uint8_t *)Coeff;
	const size_t size_line=(size_t)columns*coeff_size;

	for (uint16_t i=0; i<lines; i++)
	{
		memcpy(a,b,size_line);
		a+=size_line;
		b+=pitch;
	}

	return(true);
}


bool Matrix::ExportRaw(void *ptr,const ptrdiff_t ptr_pitch)
{
	if ((Coeff==nullptr) || (ptr==nullptr) || (columns==0) || (lines==0)) return(false);

	size_t coeff_size;

	switch(data_type)
	{
		case DATA_FLOAT : coeff_size=sizeof(float); break;
		case DATA_DOUBLE : coeff_size=sizeof(double); break;
		case DATA_UINT64 : coeff_size=sizeof(uint64_t); break;
		case DATA_INT64 : coeff_size=sizeof(int64_t); break;
		case DATA_UINT32 : coeff_size=sizeof(uint32_t); break;
		case DATA_INT32 : coeff_size=sizeof(int32_t); break;
		case DATA_UINT16 : coeff_size=sizeof(uint16_t); break;
		case DATA_INT16 : coeff_size=sizeof(int16_t); break;
		case DATA_UINT8 : coeff_size=sizeof(uint8_t); break;
		case DATA_INT8 : coeff_size=sizeof(int8_t); break;
		default : coeff_size=0; break;
	}
	if (coeff_size==0) return(false);

	uint8_t *a=(uint8_t *)ptr;
	uint8_t *b=(uint8_t *)Coeff;
	const size_t size_line=(size_t)columns*coeff_size;

	for (uint16_t i=0; i<lines; i++)
	{
		memcpy(a,b,size_line);
		a+=ptr_pitch;
		b+=pitch;
	}

	return(true);
}


bool Matrix::ExportRaw(void *ptr,const ptrdiff_t ptr_pitch,const uint16_t ln,const uint16_t co)
{
	if ((Coeff==nullptr) || (ptr==nullptr) || (columns==0) || (lines==0) || (ln>lines) || (co>columns)) return(false);

	size_t coeff_size;

	switch(data_type)
	{
		case DATA_FLOAT : coeff_size=sizeof(float); break;
		case DATA_DOUBLE : coeff_size=sizeof(double); break;
		case DATA_UINT64 : coeff_size=sizeof(uint64_t); break;
		case DATA_INT64 : coeff_size=sizeof(int64_t); break;
		case DATA_UINT32 : coeff_size=sizeof(uint32_t); break;
		case DATA_INT32 : coeff_size=sizeof(int32_t); break;
		case DATA_UINT16 : coeff_size=sizeof(uint16_t); break;
		case DATA_INT16 : coeff_size=sizeof(int16_t); break;
		case DATA_UINT8 : coeff_size=sizeof(uint8_t); break;
		case DATA_INT8 : coeff_size=sizeof(int8_t); break;
		default : coeff_size=0; break;
	}
	if (coeff_size==0) return(false);

	uint8_t *a=(uint8_t *)ptr;
	uint8_t *b=(uint8_t *)Coeff;
	const size_t size_line=(size_t)co*coeff_size;

	for (uint16_t i=0; i<ln; i++)
	{
		memcpy(a,b,size_line);
		a+=ptr_pitch;
		b+=pitch;
	}

	return(true);
}

// +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

Matrix_Compute::Matrix_Compute(void)
{
	zero_value=0.0;
	SSE2_Enable=g_EnableSSE2;
	AVX_Enable=g_EnableAVX;
	AVX2_Enable=g_EnableAVX2;
	AVX512_Enable=g_EnableAVX512;
}


Matrix_Compute::~Matrix_Compute(void)
{
}


Matrix_Compute::Matrix_Compute(const uint16_t l,const uint16_t c,const COEFF_DATA_TYPE data):Matrix(l,c,data)
{
	zero_value=0.0;
	SSE2_Enable=g_EnableSSE2;
	AVX_Enable=g_EnableAVX;
	AVX2_Enable=g_EnableAVX2;
	AVX512_Enable=g_EnableAVX512;
}


Matrix_Compute::Matrix_Compute(const Matrix_Compute &m):Matrix(m)
{
	zero_value=m.zero_value;
	SSE2_Enable=m.SSE2_Enable;
	AVX_Enable=m.AVX_Enable;
	AVX2_Enable=m.AVX2_Enable;
	AVX512_Enable=m.AVX512_Enable;
}


bool Matrix_Compute::CopyStrict(const Matrix_Compute &m)
{
	if (!Matrix::CopyStrict(m)) return(false);

	zero_value=m.zero_value;

	return(true);
}


bool Matrix_Compute::CreateTranspose(const Matrix &m)
{
	if (Coeff!=nullptr) return(false);

	if ((m.GetPtrMatrix()==nullptr) || (m.GetLines()==0) || (m.GetColumns()==0)) return(false);

	size_t coeff_size;

	switch(m.GetDataType())
	{
		case DATA_FLOAT : coeff_size=sizeof(float); break;
		case DATA_DOUBLE : coeff_size=sizeof(double); break;
		case DATA_UINT64 : coeff_size=sizeof(uint64_t); break;
		case DATA_INT64 : coeff_size=sizeof(int64_t); break;
		case DATA_UINT32 : coeff_size=sizeof(uint32_t); break;
		case DATA_INT32 : coeff_size=sizeof(int32_t); break;
		case DATA_UINT16 : coeff_size=sizeof(uint16_t); break;
		case DATA_INT16 : coeff_size=sizeof(int16_t); break;
		case DATA_UINT8 : coeff_size=sizeof(uint8_t); break;
		case DATA_INT8 : coeff_size=sizeof(int8_t); break;
		default : coeff_size=0; break;
	}
	if (coeff_size==0) return(false);

	const ptrdiff_t p0=((((ptrdiff_t)m.GetLines()*coeff_size)+MATRIX_ALIGN_SIZE-1) >> MATRIX_ALIGN_SHIFT) << MATRIX_ALIGN_SHIFT;

	Coeff=(void *)_aligned_malloc((size_t)p0*(size_t)m.GetColumns(),MATRIX_ALIGN_SIZE);
	if (Coeff==nullptr) return(false);

	size=(size_t)p0*(size_t)m.GetColumns();
	pitch=p0;
	columns=m.GetLines(); lines=m.GetColumns();
	data_type=m.GetDataType();

	const size_t n0=(size_t)columns*coeff_size,n=(size_t)p0-n0;

	if (n>0) 
	{
		uint8_t *a=(uint8_t *)Coeff;

		switch(data_type)
		{
			case DATA_FLOAT :
				for(uint16_t i=0; i<lines; i++)
				{
					std::fill_n((float *)(a+n0),n>>2,0.0f);
					a+=p0;
				}
				break;
			case DATA_DOUBLE :
				for(uint16_t i=0; i<lines; i++)
				{
					std::fill_n((double *)(a+n0),n>>3,0.0);
					a+=p0;
				}
				break;
			default :
				for(uint16_t i=0; i<lines; i++)
				{
					memset(a+n0,0,n);
					a+=p0;
				}
				break;
		}
	}

	switch(data_type)
	{
		case DATA_FLOAT : TransposeF(m); break;
		case DATA_DOUBLE : TransposeD(m); break;
		case DATA_UINT64 : TransposeU64(m); break;
		case DATA_INT64 : TransposeI64(m); break;
		case DATA_UINT32 : TransposeU32(m); break;
		case DATA_INT32 : TransposeI32(m); break;
		case DATA_UINT16 : TransposeU16(m); break;
		case DATA_INT16 : TransposeI16(m); break;
		case DATA_UINT8 : TransposeU8(m); break;
		case DATA_INT8 : TransposeI8(m); break;
		default : return(false);
	}

	return(true);
}


bool Matrix_Compute::Mult(const double coef,const Matrix &ma)
{
	if ((Coeff==nullptr) || (lines==0) || (columns==0)) return(false);
	if (!ma.AllocCheck()) return(false);

	if ((columns!=ma.GetColumns()) || (lines!=ma.GetLines()) || (ma.GetDataType()!=data_type)) return(false);

	if (coef==0.0)
	{
		FillZero();
		return(true);
	}
	if (coef==1.0)
	{
		Matrix::CopyStrict(ma);
		return(true);
	}

	switch(data_type)
	{
		case DATA_FLOAT : MultF(coef,ma); break;
		case DATA_DOUBLE : MultD(coef,ma); break;
		default : return(false);
	}

	return(true);
}


bool Matrix_Compute::Mult(const double coef)
{
	if ((Coeff==nullptr) || (lines==0) || (columns==0)) return(false);

	if (coef==0.0)
	{
		FillZero();
		return(true);
	}
	if (coef==1.0) return(true);

	switch(data_type)
	{
		case DATA_FLOAT : MultF(coef); break;
		case DATA_DOUBLE : MultD(coef); break;
		default : return(false);
	}

	return(true);
}


void Matrix_Compute::MultF(const double coef,const Matrix &ma)
{
	const uint16_t li=lines,co=columns;
	const uint8_t *a=(const uint8_t *)ma.GetPtrMatrix();
	uint8_t *c=(uint8_t *)Coeff;
	const ptrdiff_t pa=ma.GetPitch(),pc=pitch;
	const float b=(float)coef;

#ifdef AVX512_BUILD_POSSIBLE
	if (AVX512_Enable)
	{
		const uint16_t n=(co+15)>>4;

		for (uint16_t i=0; i<li; i++)
		{
			CoeffProductF_AVX512(&b,(const float *)a,(float *)c,n);

			a+=pa;
			c+=pc;
		}
	}
	else
#endif
	{
		if (AVX_Enable)
		{
			const uint16_t n=(co+7)>>3;

			for (uint16_t i=0; i<li; i++)
			{
				CoeffProductF_AVX(&b,(const float *)a,(float *)c,n);

				a+=pa;
				c+=pc;
			}
		}
		else
		{
			if (SSE2_Enable)
			{
				const uint16_t n=(co+3)>>2;

				for (uint16_t i=0; i<li; i++)
				{
					CoeffProductF_SSE2(&b,(const float *)a,(float *)c,n);

					a+=pa;
					c+=pc;
				}
			}
			else
			{
				for (uint16_t i=0; i<li; i++)
				{
					const float *a1=(const float *)a;
					float *c1=(float *)c;

					for (uint16_t j=0; j<co; j++)
						c1[j]=b*a1[j];

					a+=pa;
					c+=pc;
				}
			}
		}
	}
}


void Matrix_Compute::MultD(const double coef,const Matrix &ma)
{
	const uint16_t li=lines,co=columns;
	const uint8_t *a=(const uint8_t *)ma.GetPtrMatrix();
	uint8_t *c=(uint8_t *)Coeff;
	const ptrdiff_t pa=ma.GetPitch(),pc=pitch;

#ifdef AVX512_BUILD_POSSIBLE
	if (AVX512_Enable)
	{
		const uint16_t n=(co+7)>>3;

		for (uint16_t i=0; i<li; i++)
		{
			CoeffProductD_AVX512(&coef,(const double *)a,(double *)c,n);

			a+=pa;
			c+=pc;
		}
	}
	else
#endif
	{
		if (AVX_Enable)
		{
			const uint16_t n=(co+3)>>2;

			for (uint16_t i=0; i<li; i++)
			{
				CoeffProductD_AVX(&coef,(const double *)a,(double *)c,n);

				a+=pa;
				c+=pc;
			}
		}
		else
		{
			if (SSE2_Enable)
			{
				const uint16_t n=(co+1)>>1;

				for (uint16_t i=0; i<li; i++)
				{
					CoeffProductD_SSE2(&coef,(const double *)a,(double *)c,n);

					a+=pa;
					c+=pc;
				}
			}
			else
			{
				for (uint16_t i=0; i<li; i++)
				{
					const double *a1=(const double *)a;
					double *c1=(double *)c;

					for (uint16_t j=0; j<co; j++)
						c1[j]=coef*a1[j];

					a+=pa;
					c+=pc;
				}
			}
		}
	}
}


void Matrix_Compute::MultF(const double coef)
{
	const uint16_t li=lines,co=columns;
	uint8_t *c=(uint8_t *)Coeff;
	const ptrdiff_t pc=pitch;
	const float b=(float)coef;

#ifdef AVX512_BUILD_POSSIBLE
	if (AVX512_Enable)
	{
		const uint16_t n=(co+15)>>4;

		for (uint16_t i=0; i<li; i++)
		{
			CoeffProduct2F_AVX512(&b,(float *)c,n);

			c+=pc;
		}
	}
	else
#endif
	{
		if (AVX_Enable)
		{
			const uint16_t n=(co+7)>>3;

			for (uint16_t i=0; i<li; i++)
			{
				CoeffProduct2F_AVX(&b,(float *)c,n);

				c+=pc;
			}
		}
		else
		{
			if (SSE2_Enable)
			{
				const uint16_t n=(co+3)>>2;

				for (uint16_t i=0; i<li; i++)
				{
					CoeffProduct2F_SSE2(&b,(float *)c,n);

					c+=pc;
				}
			}
			else
			{
				for (uint16_t i=0; i<li; i++)
				{
					float *c1=(float *)c;

					for (uint16_t j=0; j<co; j++)
						c1[j]*=b;

					c+=pc;
				}
			}
		}
	}
}


void Matrix_Compute::MultD(const double coef)
{
	const uint16_t li=lines,co=columns;
	uint8_t *c=(uint8_t *)Coeff;
	const ptrdiff_t pc=pitch;

#ifdef AVX512_BUILD_POSSIBLE
	if (AVX512_Enable)
	{
		const uint16_t n=(co+7)>>3;

		for (uint16_t i=0; i<li; i++)
		{
			CoeffProduct2D_AVX512(&coef,(double *)c,n);

			c+=pc;
		}
	}
	else
#endif
	{
		if (AVX_Enable)
		{
			const uint16_t n=(co+3)>>2;

			for (uint16_t i=0; i<li; i++)
			{
				CoeffProduct2D_AVX(&coef,(double *)c,n);

				c+=pc;
			}
		}
		else
		{
			if (SSE2_Enable)
			{
				const uint16_t n=(co+1)>>1;

				for (uint16_t i=0; i<li; i++)
				{
					CoeffProduct2D_SSE2(&coef,(double *)c,n);

					c+=pc;
				}
			}
			else
			{
				for (uint16_t i=0; i<li; i++)
				{
					double *c1=(double *)c;

					for (uint16_t j=0; j<co; j++)
						c1[j]*=coef;

					c+=pc;
				}
			}
		}
	}
}


bool Matrix_Compute::Add(const double coef,const Matrix &ma)
{
	if ((Coeff==nullptr) || (lines==0) || (columns==0)) return(false);
	if (!ma.AllocCheck()) return(false);

	if ((columns!=ma.GetColumns()) || (lines!=ma.GetLines()) || (ma.GetDataType()!=data_type)) return(false);

	if (coef==0.0)
	{
		Matrix::CopyStrict(ma);
		return(true);
	}

	switch(data_type)
	{
		case DATA_FLOAT : AddF(coef,ma); break;
		case DATA_DOUBLE : AddD(coef,ma); break;
		default : return(false);
	}

	return(true);
}


bool Matrix_Compute::Add(const double coef)
{
	if ((Coeff==nullptr) || (lines==0) || (columns==0)) return(false);

	if (coef==0.0) return(true);

	switch(data_type)
	{
		case DATA_FLOAT : AddF(coef); break;
		case DATA_DOUBLE : AddD(coef); break;
		default : return(false);
	}

	return(true);
}


void Matrix_Compute::AddF(const double coef,const Matrix &ma)
{
	const uint16_t li=lines,co=columns;
	const uint8_t *a=(const uint8_t *)ma.GetPtrMatrix();
	uint8_t *c=(uint8_t *)Coeff;
	const ptrdiff_t pa=ma.GetPitch(),pc=pitch;
	const float b=(float)coef;

#ifdef AVX512_BUILD_POSSIBLE
	if (AVX512_Enable)
	{
		const uint16_t n0=co>>4,n1=n0<<4;

		for (uint16_t i=0; i<li; i++)
		{
			const float *a1=(const float *)a;
			float *c1=(float *)c;

			if (n0>0) CoeffAddF_AVX512(&b,(const float *)a,(float *)c,n0);
			for (uint16_t j=n1; j<co; j++)
				c1[j]=b+a1[j];

			a+=pa;
			c+=pc;
		}
	}
	else
#endif
	{
		if (AVX_Enable)
		{
			const uint16_t n0=co>>3,n1=n0<<3;

			for (uint16_t i=0; i<li; i++)
			{
				const float *a1=(const float *)a;
				float *c1=(float *)c;

				if (n0>0) CoeffAddF_AVX(&b,(const float *)a,(float *)c,n0);
				for (uint16_t j=n1; j<co; j++)
					c1[j]=b+a1[j];

				a+=pa;
				c+=pc;
			}
		}
		else
		{
			if (SSE2_Enable)
			{
				const uint16_t n0=co>>2,n1=n0<<2;

				for (uint16_t i=0; i<li; i++)
				{
					const float *a1=(const float *)a;
					float *c1=(float *)c;

					if (n0>0) CoeffAddF_SSE2(&b,(const float *)a,(float *)c,n0);
					for (uint16_t j=n1; j<co; j++)
						c1[j]=b+a1[j];

					a+=pa;
					c+=pc;
				}
			}
			else
			{
				for (uint16_t i=0; i<li; i++)
				{
					const float *a1=(const float *)a;
					float *c1=(float *)c;

					for (uint16_t j=0; j<co; j++)
						c1[j]=b+a1[j];

					a+=pa;
					c+=pc;
				}
			}
		}
	}
}


void Matrix_Compute::AddD(const double coef,const Matrix &ma)
{
	const uint16_t li=lines,co=columns;
	const uint8_t *a=(const uint8_t *)ma.GetPtrMatrix();
	uint8_t *c=(uint8_t *)Coeff;
	const ptrdiff_t pa=ma.GetPitch(),pc=pitch;

#ifdef AVX512_BUILD_POSSIBLE
	if (AVX512_Enable)
	{
		const uint16_t n0=co>>3,n1=n0<<3;

		for (uint16_t i=0; i<li; i++)
		{
			const double *a1=(const double *)a;
			double *c1=(double *)c;

			if (n0>0) CoeffAddD_AVX512(&coef,(const double *)a,(double *)c,n0);
			for (uint16_t j=n1; j<co; j++)
				c1[j]=coef+a1[j];

			a+=pa;
			c+=pc;
		}
	}
	else
#endif
	{
		if (AVX_Enable)
		{
			const uint16_t n0=co>>2,n1=n0<<2;

			for (uint16_t i=0; i<li; i++)
			{
				const double *a1=(const double *)a;
				double *c1=(double *)c;

				if (n0>0) CoeffAddD_AVX(&coef,(const double *)a,(double *)c,n0);
				for (uint16_t j=n1; j<co; j++)
					c1[j]=coef+a1[j];

				a+=pa;
				c+=pc;
			}
		}
		else
		{
			if (SSE2_Enable)
			{
				const uint16_t n0=co>>1,n1=n0<<1;

				for (uint16_t i=0; i<li; i++)
				{
					const double *a1=(const double *)a;
					double *c1=(double *)c;

					if (n0>0) CoeffAddD_SSE2(&coef,(const double *)a,(double *)c,n0);
					for (uint16_t j=n1; j<co; j++)
						c1[j]=coef+a1[j];

					a+=pa;
					c+=pc;
				}
			}
			else
			{
				for (uint16_t i=0; i<li; i++)
				{
					const double *a1=(const double *)a;
					double *c1=(double *)c;

					for (uint16_t j=0; j<co; j++)
						c1[j]=coef+a1[j];

					a+=pa;
					c+=pc;
				}
			}
		}
	}
}


void Matrix_Compute::AddF(const double coef)
{
	const uint16_t li=lines,co=columns;
	uint8_t *c=(uint8_t *)Coeff;
	const ptrdiff_t pc=pitch;
	const float b=(float)coef;

#ifdef AVX512_BUILD_POSSIBLE
	if (AVX512_Enable)
	{
		const uint16_t n0=co>>4,n1=n0<<4;

		for (uint16_t i=0; i<li; i++)
		{
			float *c1=(float *)c;

			if (n0>0) CoeffAdd2F_AVX512(&b,(float *)c,n0);
			for (uint16_t j=n1; j<co; j++)
				c1[j]+=b;

			c+=pc;
		}
	}
	else
#endif
	{
		if (AVX_Enable)
		{
			const uint16_t n0=co>>3,n1=n0<<3;

			for (uint16_t i=0; i<li; i++)
			{
				float *c1=(float *)c;

				if (n0>0) CoeffAdd2F_AVX(&b,(float *)c,n0);
				for (uint16_t j=n1; j<co; j++)
					c1[j]+=b;

				c+=pc;
			}
		}
		else
		{
			if (SSE2_Enable)
			{
				const uint16_t n0=co>>2,n1=n0<<2;

				for (uint16_t i=0; i<li; i++)
				{
					float *c1=(float *)c;

					if (n0>0) CoeffAdd2F_SSE2(&b,(float *)c,n0);
					for (uint16_t j=n1; j<co; j++)
						c1[j]+=b;

					c+=pc;
				}
			}
			else
			{
				for (uint16_t i=0; i<li; i++)
				{
					float *c1=(float *)c;

					for (uint16_t j=0; j<co; j++)
						c1[j]+=b;

					c+=pc;
				}
			}
		}
	}
}


void Matrix_Compute::AddD(const double coef)
{
	const uint16_t li=lines,co=columns;
	uint8_t *c=(uint8_t *)Coeff;
	const ptrdiff_t pc=pitch;

#ifdef AVX512_BUILD_POSSIBLE
	if (AVX512_Enable)
	{
		const uint16_t n0=co>>3,n1=n0<<3;

		for (uint16_t i=0; i<li; i++)
		{
			double *c1=(double *)c;

			if (n0>0) CoeffAdd2D_AVX512(&coef,(double *)c,n0);
			for (uint16_t j=n1; j<co; j++)
				c1[j]+=coef;

			c+=pc;
		}
	}
	else
#endif
	{
		if (AVX_Enable)
		{
			const uint16_t n0=co>>2,n1=n0<<2;

			for (uint16_t i=0; i<li; i++)
			{
				double *c1=(double *)c;

				if (n0>0) CoeffAdd2D_AVX(&coef,(double *)c,n0);
				for (uint16_t j=n1; j<co; j++)
					c1[j]+=coef;

				c+=pc;
			}
		}
		else
		{
			if (SSE2_Enable)
			{
				const uint16_t n0=co>>1,n1=n0<<1;

				for (uint16_t i=0; i<li; i++)
				{
					double *c1=(double *)c;

					if (n0>0) CoeffAdd2D_SSE2(&coef,(double *)c,n0);
					for (uint16_t j=n1; j<co; j++)
						c1[j]+=coef;

					c+=pc;
				}
			}
			else
			{
				for (uint16_t i=0; i<li; i++)
				{
					double *c1=(double *)c;

					for (uint16_t j=0; j<co; j++)
						c1[j]+=coef;

					c+=pc;
				}
			}
		}
	}
}


bool Matrix_Compute::Sub(const double coef,const Matrix &ma)
{
	if ((Coeff==nullptr) || (lines==0) || (columns==0)) return(false);
	if (!ma.AllocCheck()) return(false);

	if ((columns!=ma.GetColumns()) || (lines!=ma.GetLines()) || (ma.GetDataType()!=data_type)) return(false);

	if (coef==0.0)
	{
		Matrix::CopyStrict(ma);
		return(true);
	}

	switch(data_type)
	{
		case DATA_FLOAT : SubF(coef,ma); break;
		case DATA_DOUBLE : SubD(coef,ma); break;
		default : return(false);
	}

	return(true);
}


bool Matrix_Compute::Sub(const double coef)
{
	if ((Coeff==nullptr) || (lines==0) || (columns==0)) return(false);

	if (coef==0.0) return(true);

	switch(data_type)
	{
		case DATA_FLOAT : SubF(coef); break;
		case DATA_DOUBLE : SubD(coef); break;
		default : return(false);
	}

	return(true);
}


void Matrix_Compute::SubF(const double coef,const Matrix &ma)
{
	const uint16_t li=lines,co=columns;
	const uint8_t *a=(const uint8_t *)ma.GetPtrMatrix();
	uint8_t *c=(uint8_t *)Coeff;
	const ptrdiff_t pa=ma.GetPitch(),pc=pitch;
	const float b=(float)coef;

#ifdef AVX512_BUILD_POSSIBLE
	if (AVX512_Enable)
	{
		const uint16_t n0=co>>4,n1=n0<<4;

		for (uint16_t i=0; i<li; i++)
		{
			const float *a1=(const float *)a;
			float *c1=(float *)c;

			if (n0>0) CoeffSubF_AVX512(&b,(const float *)a,(float *)c,n0);
			for (uint16_t j=n1; j<co; j++)
				c1[j]=b-a1[j];

			a+=pa;
			c+=pc;
		}
	}
	else
#endif
	{
		if (AVX_Enable)
		{
			const uint16_t n0=co>>3,n1=n0<<3;

			for (uint16_t i=0; i<li; i++)
			{
				const float *a1=(const float *)a;
				float *c1=(float *)c;

				if (n0>0) CoeffSubF_AVX(&b,(const float *)a,(float *)c,n0);
				for (uint16_t j=n1; j<co; j++)
					c1[j]=b-a1[j];

				a+=pa;
				c+=pc;
			}
		}
		else
		{
			if (SSE2_Enable)
			{
				const uint16_t n0=co>>2,n1=n0<<2;

				for (uint16_t i=0; i<li; i++)
				{
					const float *a1=(const float *)a;
					float *c1=(float *)c;

					if (n0>0) CoeffSubF_SSE2(&b,(const float *)a,(float *)c,n0);
					for (uint16_t j=n1; j<co; j++)
						c1[j]=b-a1[j];

					a+=pa;
					c+=pc;
				}
			}
			else
			{
				for (uint16_t i=0; i<li; i++)
				{
					const float *a1=(const float *)a;
					float *c1=(float *)c;

					for (uint16_t j=0; j<co; j++)
						c1[j]=b-a1[j];

					a+=pa;
					c+=pc;
				}
			}
		}
	}
}


void Matrix_Compute::SubD(const double coef,const Matrix &ma)
{
	const uint16_t li=lines,co=columns;
	const uint8_t *a=(const uint8_t *)ma.GetPtrMatrix();
	uint8_t *c=(uint8_t *)Coeff;
	const ptrdiff_t pa=ma.GetPitch(),pc=pitch;

#ifdef AVX512_BUILD_POSSIBLE
	if (AVX512_Enable)
	{
		const uint16_t n0=co>>3,n1=n0<<3;

		for (uint16_t i=0; i<li; i++)
		{
			const double *a1=(const double *)a;
			double *c1=(double *)c;

			if (n0>0) CoeffSubD_AVX512(&coef,(const double *)a,(double *)c,n0);
			for (uint16_t j=n1; j<co; j++)
				c1[j]=coef-a1[j];

			a+=pa;
			c+=pc;
		}
	}
	else
#endif
	{
		if (AVX_Enable)
		{
			const uint16_t n0=co>>2,n1=n0<<2;

			for (uint16_t i=0; i<li; i++)
			{
				const double *a1=(const double *)a;
				double *c1=(double *)c;

				if (n0>0) CoeffSubD_AVX(&coef,(const double *)a,(double *)c,n0);
				for (uint16_t j=n1; j<co; j++)
					c1[j]=coef-a1[j];

				a+=pa;
				c+=pc;
			}
		}
		else
		{
			if (SSE2_Enable)
			{
				const uint16_t n0=co>>1,n1=n0<<1;

				for (uint16_t i=0; i<li; i++)
				{
					const double *a1=(const double *)a;
					double *c1=(double *)c;

					if (n0>0) CoeffSubD_SSE2(&coef,(const double *)a,(double *)c,n0);
					for (uint16_t j=n1; j<co; j++)
						c1[j]=coef-a1[j];

					a+=pa;
					c+=pc;
				}
			}
			else
			{
				for (uint16_t i=0; i<li; i++)
				{
					const double *a1=(const double *)a;
					double *c1=(double *)c;

					for (uint16_t j=0; j<co; j++)
						c1[j]=coef-a1[j];

					a+=pa;
					c+=pc;
				}
			}
		}
	}
}


void Matrix_Compute::SubF(const double coef)
{
	const uint16_t li=lines,co=columns;
	uint8_t *c=(uint8_t *)Coeff;
	const ptrdiff_t pc=pitch;
	const float b=(float)coef;

#ifdef AVX512_BUILD_POSSIBLE
	if (AVX512_Enable)
	{
		const uint16_t n0=co>>4,n1=n0<<4;

		for (uint16_t i=0; i<li; i++)
		{
			float *c1=(float *)c;

			if (n0>0) CoeffSub2F_AVX512(&b,(float *)c,n0);
			for (uint16_t j=n1; j<co; j++)
				c1[j]=b-c1[j];

			c+=pc;
		}
	}
	else
#endif
	{
		if (AVX_Enable)
		{
			const uint16_t n0=co>>3,n1=n0<<3;

			for (uint16_t i=0; i<li; i++)
			{
				float *c1=(float *)c;

				if (n0>0) CoeffSub2F_AVX(&b,(float *)c,n0);
				for (uint16_t j=n1; j<co; j++)
					c1[j]=b-c1[j];

				c+=pc;
			}
		}
		else
		{
			if (SSE2_Enable)
			{
				const uint16_t n0=co>>2,n1=n0<<2;

				for (uint16_t i=0; i<li; i++)
				{
					float *c1=(float *)c;

					if (n0>0) CoeffSub2F_SSE2(&b,(float *)c,n0);
					for (uint16_t j=n1; j<co; j++)
						c1[j]=b-c1[j];

					c+=pc;
				}
			}
			else
			{
				for (uint16_t i=0; i<li; i++)
				{
					float *c1=(float *)c;

					for (uint16_t j=0; j<co; j++)
						c1[j]=b-c1[j];

					c+=pc;
				}
			}
		}
	}
}


void Matrix_Compute::SubD(const double coef)
{
	const uint16_t li=lines,co=columns;
	uint8_t *c=(uint8_t *)Coeff;
	const ptrdiff_t pc=pitch;

#ifdef AVX512_BUILD_POSSIBLE
	if (AVX512_Enable)
	{
		const uint16_t n0=co>>3,n1=n0<<3;

		for (uint16_t i=0; i<li; i++)
		{
			double *c1=(double *)c;

			if (n0>0) CoeffSub2D_AVX512(&coef,(double *)c,n0);
			for (uint16_t j=n1; j<co; j++)
				c1[j]=coef-c1[j];

			c+=pc;
		}
	}
	else
#endif
	{
		if (AVX_Enable)
		{
			const uint16_t n0=co>>2,n1=n0<<2;

			for (uint16_t i=0; i<li; i++)
			{
				double *c1=(double *)c;

				if (n0>0) CoeffSub2D_AVX(&coef,(double *)c,n0);
				for (uint16_t j=n1; j<co; j++)
					c1[j]=coef-c1[j];

				c+=pc;
			}
		}
		else
		{
			if (SSE2_Enable)
			{
				const uint16_t n0=co>>1,n1=n0<<1;

				for (uint16_t i=0; i<li; i++)
				{
					double *c1=(double *)c;

					if (n0>0) CoeffSub2D_SSE2(&coef,(double *)c,n0);
					for (uint16_t j=n1; j<co; j++)
						c1[j]=coef-c1[j];

					c+=pc;
				}
			}
			else
			{
				for (uint16_t i=0; i<li; i++)
				{
					double *c1=(double *)c;

					for (uint16_t j=0; j<co; j++)
						c1[j]=coef-c1[j];

					c+=pc;
				}
			}
		}
	}
}


bool Matrix_Compute::Add_A(const Matrix &ma, const Matrix &mb)
{
	if ((Coeff==nullptr) || (lines==0) || (columns==0)) return(false);
	if (!ma.AllocCheck() || !mb.AllocCheck()) return(false);

	if ((ma.GetColumns()!=mb.GetColumns()) || (ma.GetLines()!=mb.GetLines()) || (columns!=ma.GetColumns())
		|| (lines!=ma.GetLines()) || (ma.GetDataType()!=mb.GetDataType()) || (ma.GetDataType()!=data_type)) return(false);

	switch(data_type)
	{
		case DATA_FLOAT : AddF_A(ma,mb); break;
		case DATA_DOUBLE : AddD_A(ma,mb); break;
		default : return(false);
	}

	return(true);
}


bool Matrix_Compute::Add_A(const Matrix &ma)
{
	if ((Coeff==nullptr) || (lines==0) || (columns==0)) return(false);
	if (!ma.AllocCheck()) return(false);

	if ((columns!=ma.GetColumns()) || (lines!=ma.GetLines()) || (ma.GetDataType()!=data_type)) return(false);

	switch(data_type)
	{
		case DATA_FLOAT : AddF_A(ma); break;
		case DATA_DOUBLE : AddD_A(ma); break;
		default : return(false);
	}

	return(true);
}


void Matrix_Compute::AddF_A(const Matrix &ma, const Matrix &mb)
{
	const uint16_t li=lines,co=columns;
	const uint8_t *a=(const uint8_t *)ma.GetPtrMatrix();
	const uint8_t *b=(const uint8_t *)mb.GetPtrMatrix();
	uint8_t *c=(uint8_t *)Coeff;
	const ptrdiff_t pa=ma.GetPitch(),pb=mb.GetPitch(),pc=pitch;

#ifdef AVX512_BUILD_POSSIBLE
	if (AVX512_Enable)
	{
		const uint16_t n=(co+15)>>4;

		for (uint16_t i=0; i<li; i++)
		{
			VectorAddF_AVX512((const float *)a,(const float *)b,(float *)c,n);

			a+=pa;
			b+=pb;
			c+=pc;
		}
	}
	else
#endif
	{
		if (AVX_Enable)
		{
			const uint16_t n=(co+7)>>3;

			for (uint16_t i=0; i<li; i++)
			{
				VectorAddF_AVX((const float *)a,(const float *)b,(float *)c,n);

				a+=pa;
				b+=pb;
				c+=pc;
			}
		}
		else
		{
			if (SSE2_Enable)
			{
				const uint16_t n=(co+3)>>2;

				for (uint16_t i=0; i<li; i++)
				{
					VectorAddF_SSE2((const float *)a,(const float *)b,(float *)c,n);

					a+=pa;
					b+=pb;
					c+=pc;
				}
			}
			else
			{
				for (uint16_t i=0; i<li; i++)
				{
					const float *a1=(const float *)a;
					const float *b1=(const float *)b;
					float *c1=(float *)c;

					for (uint16_t j=0; j<co; j++)
						c1[j]=a1[j]+b1[j];

					a+=pa;
					b+=pb;
					c+=pc;
				}
			}
		}
	}
}


void Matrix_Compute::AddD_A(const Matrix &ma, const Matrix &mb)
{
	const uint16_t li=lines,co=columns;
	const uint8_t *a=(const uint8_t *)ma.GetPtrMatrix();
	const uint8_t *b=(const uint8_t *)mb.GetPtrMatrix();
	uint8_t *c=(uint8_t *)Coeff;
	const ptrdiff_t pa=ma.GetPitch(),pb=mb.GetPitch(),pc=pitch;

#ifdef AVX512_BUILD_POSSIBLE
	if (AVX512_Enable)
	{
		const uint16_t n=(co+7)>>3;

		for (uint16_t i=0; i<li; i++)
		{
			VectorAddD_AVX512((const double *)a,(const double *)b,(double *)c,n);

			a+=pa;
			b+=pb;
			c+=pc;
		}
	}
	else
#endif
	{
		if (AVX_Enable)
		{
			const uint16_t n=(co+3)>>2;

			for (uint16_t i=0; i<li; i++)
			{
				VectorAddD_AVX((const double *)a,(const double *)b,(double *)c,n);

				a+=pa;
				b+=pb;
				c+=pc;
			}
		}
		else
		{
			if (SSE2_Enable)
			{
				const uint16_t n=(co+1)>>1;

				for (uint16_t i=0; i<li; i++)
				{
					VectorAddD_SSE2((const double *)a,(const double *)b,(double *)c,n);

					a+=pa;
					b+=pb;
					c+=pc;
				}
			}
			else
			{
				for (uint16_t i=0; i<li; i++)
				{
					const double *a1=(const double *)a;
					const double *b1=(const double *)b;
					double *c1=(double *)c;

					for (uint16_t j=0; j<co; j++)
						c1[j]=a1[j]+b1[j];

					a+=pa;
					b+=pb;
					c+=pc;
				}
			}
		}
	}
}


void Matrix_Compute::AddF_A(const Matrix &ma)
{
	const uint16_t li=lines,co=columns;
	const uint8_t *a=(const uint8_t *)ma.GetPtrMatrix();
	uint8_t *c=(uint8_t *)Coeff;
	const ptrdiff_t pa=ma.GetPitch(),pc=pitch;

#ifdef AVX512_BUILD_POSSIBLE
	if (AVX512_Enable)
	{
		const uint16_t n=(co+15)>>4;

		for (uint16_t i=0; i<li; i++)
		{
			VectorAdd2F_AVX512((float *)c,(const float *)a,n);

			a+=pa;
			c+=pc;
		}
	}
	else
#endif
	{
		if (AVX_Enable)
		{
			const uint16_t n=(co+7)>>3;

			for (uint16_t i=0; i<li; i++)
			{
				VectorAdd2F_AVX((float *)c,(const float *)a,n);

				a+=pa;
				c+=pc;
			}
		}
		else
		{
			if (SSE2_Enable)
			{
				const uint16_t n=(co+3)>>2;

				for (uint16_t i=0; i<li; i++)
				{
					VectorAdd2F_SSE2((float *)c,(const float *)a,n);

					a+=pa;
					c+=pc;
				}
			}
			else
			{
				for (uint16_t i=0; i<li; i++)
				{
					const float *a1=(const float *)a;
					float *c1=(float *)c;

					for (uint16_t j=0; j<co; j++)
						c1[j]+=a1[j];

					a+=pa;
					c+=pc;
				}
			}
		}
	}
}


void Matrix_Compute::AddD_A(const Matrix &ma)
{
	const uint16_t li=lines,co=columns;
	const uint8_t *a=(const uint8_t *)ma.GetPtrMatrix();
	uint8_t *c=(uint8_t *)Coeff;
	const ptrdiff_t pa=ma.GetPitch(),pc=pitch;

#ifdef AVX512_BUILD_POSSIBLE
	if (AVX512_Enable)
	{
		const uint16_t n=(co+7)>>3;

		for (uint16_t i=0; i<li; i++)
		{
			VectorAdd2D_AVX512((double *)c,(const double *)a,n);

			a+=pa;
			c+=pc;
		}
	}
	else
#endif
	{
		if (AVX_Enable)
		{
			const uint16_t n=(co+3)>>2;

			for (uint16_t i=0; i<li; i++)
			{
				VectorAdd2D_AVX((double *)c,(const double *)a,n);

				a+=pa;
				c+=pc;
			}
		}
		else
		{
			if (SSE2_Enable)
			{
				const uint16_t n=(co+1)>>1;

				for (uint16_t i=0; i<li; i++)
				{
					VectorAdd2D_SSE2((double *)c,(const double *)a,n);

					a+=pa;
					c+=pc;
				}
			}
			else
			{
				for (uint16_t i=0; i<li; i++)
				{
					const double *a1=(const double *)a;
					double *c1=(double *)c;

					for (uint16_t j=0; j<co; j++)
						c1[j]+=a1[j];

					a+=pa;
					c+=pc;
				}
			}
		}
	}
}


bool Matrix_Compute::Mult_A(const Matrix &ma, const Matrix &mb)
{
	if ((Coeff==nullptr) || (lines==0) || (columns==0)) return(false);
	if (!ma.AllocCheck() || !mb.AllocCheck()) return(false);

	if ((ma.GetColumns()!=mb.GetColumns()) || (ma.GetLines()!=mb.GetLines()) || (columns!=ma.GetColumns())
		|| (lines!=ma.GetLines()) || (ma.GetDataType()!=mb.GetDataType()) || (ma.GetDataType()!=data_type)) return(false);

	switch(data_type)
	{
		case DATA_FLOAT : MultF_A(ma,mb); break;
		case DATA_DOUBLE : MultD_A(ma,mb); break;
		default : return(false);
	}

	return(true);
}


bool Matrix_Compute::Mult_A(const Matrix &ma)
{
	if ((Coeff==nullptr) || (lines==0) || (columns==0)) return(false);
	if (!ma.AllocCheck()) return(false);

	if ((columns!=ma.GetColumns()) || (lines!=ma.GetLines()) || (ma.GetDataType()!=data_type)) return(false);

	switch(data_type)
	{
		case DATA_FLOAT : MultF_A(ma); break;
		case DATA_DOUBLE : MultD_A(ma); break;
		default : return(false);
	}

	return(true);
}


void Matrix_Compute::MultF_A(const Matrix &ma, const Matrix &mb)
{
	const uint16_t li=lines,co=columns;
	const uint8_t *a=(const uint8_t *)ma.GetPtrMatrix();
	const uint8_t *b=(const uint8_t *)mb.GetPtrMatrix();
	uint8_t *c=(uint8_t *)Coeff;
	const ptrdiff_t pa=ma.GetPitch(),pb=mb.GetPitch(),pc=pitch;

#ifdef AVX512_BUILD_POSSIBLE
	if (AVX512_Enable)
	{
		const uint16_t n=(co+15)>>4;

		for (uint16_t i=0; i<li; i++)
		{
			VectorProdF_AVX512((const float *)a,(const float *)b,(float *)c,n);

			a+=pa;
			b+=pb;
			c+=pc;
		}
	}
	else
#endif
	{
		if (AVX_Enable)
		{
			const uint16_t n=(co+7)>>3;

			for (uint16_t i=0; i<li; i++)
			{
				VectorProdF_AVX((const float *)a,(const float *)b,(float *)c,n);

				a+=pa;
				b+=pb;
				c+=pc;
			}
		}
		else
		{
			if (SSE2_Enable)
			{
				const uint16_t n=(co+3)>>2;

				for (uint16_t i=0; i<li; i++)
				{
					VectorProdF_SSE2((const float *)a,(const float *)b,(float *)c,n);

					a+=pa;
					b+=pb;
					c+=pc;
				}
			}
			else
			{
				for (uint16_t i=0; i<li; i++)
				{
					const float *a1=(const float *)a;
					const float *b1=(const float *)b;
					float *c1=(float *)c;

					for (uint16_t j=0; j<co; j++)
						c1[j]=a1[j]*b1[j];

					a+=pa;
					b+=pb;
					c+=pc;
				}
			}
		}
	}
}


void Matrix_Compute::MultD_A(const Matrix &ma, const Matrix &mb)
{
	const uint16_t li=lines,co=columns;
	const uint8_t *a=(const uint8_t *)ma.GetPtrMatrix();
	const uint8_t *b=(const uint8_t *)mb.GetPtrMatrix();
	uint8_t *c=(uint8_t *)Coeff;
	const ptrdiff_t pa=ma.GetPitch(),pb=mb.GetPitch(),pc=pitch;

#ifdef AVX512_BUILD_POSSIBLE
	if (AVX512_Enable)
	{
		const uint16_t n=(co+7)>>3;

		for (uint16_t i=0; i<li; i++)
		{
			VectorProdD_AVX512((const double *)a,(const double *)b,(double *)c,n);

			a+=pa;
			b+=pb;
			c+=pc;
		}
	}
	else
#endif
	{
		if (AVX_Enable)
		{
			const uint16_t n=(co+3)>>2;

			for (uint16_t i=0; i<li; i++)
			{
				VectorProdD_AVX((const double *)a,(const double *)b,(double *)c,n);

				a+=pa;
				b+=pb;
				c+=pc;
			}
		}
		else
		{
			if (SSE2_Enable)
			{
				const uint16_t n=(co+1)>>1;

				for (uint16_t i=0; i<li; i++)
				{
					VectorProdD_SSE2((const double *)a,(const double *)b,(double *)c,n);

					a+=pa;
					b+=pb;
					c+=pc;
				}
			}
			else
			{
				for (uint16_t i=0; i<li; i++)
				{
					const double *a1=(const double *)a;
					const double *b1=(const double *)b;
					double *c1=(double *)c;

					for (uint16_t j=0; j<co; j++)
						c1[j]=a1[j]*b1[j];

					a+=pa;
					b+=pb;
					c+=pc;
				}
			}
		}
	}
}


void Matrix_Compute::MultF_A(const Matrix &ma)
{
	const uint16_t li=lines,co=columns;
	const uint8_t *a=(const uint8_t *)ma.GetPtrMatrix();
	uint8_t *c=(uint8_t *)Coeff;
	const ptrdiff_t pa=ma.GetPitch(),pc=pitch;

#ifdef AVX512_BUILD_POSSIBLE
	if (AVX512_Enable)
	{
		const uint16_t n=(co+15)>>4;

		for (uint16_t i=0; i<li; i++)
		{
			VectorProd2F_AVX512((float *)c,(const float *)a,n);

			a+=pa;
			c+=pc;
		}
	}
	else
#endif
	{
		if (AVX_Enable)
		{
			const uint16_t n=(co+7)>>3;

			for (uint16_t i=0; i<li; i++)
			{
				VectorProd2F_AVX((float *)c,(const float *)a,n);

				a+=pa;
				c+=pc;
			}
		}
		else
		{
			if (SSE2_Enable)
			{
				const uint16_t n=(co+3)>>2;

				for (uint16_t i=0; i<li; i++)
				{
					VectorProd2F_SSE2((float *)c,(const float *)a,n);

					a+=pa;
					c+=pc;
				}
			}
			else
			{
				for (uint16_t i=0; i<li; i++)
				{
					const float *a1=(const float *)a;
					float *c1=(float *)c;

					for (uint16_t j=0; j<co; j++)
						c1[j]*=a1[j];

					a+=pa;
					c+=pc;
				}
			}
		}
	}
}


void Matrix_Compute::MultD_A(const Matrix &ma)
{
	const uint16_t li=lines,co=columns;
	const uint8_t *a=(const uint8_t *)ma.GetPtrMatrix();
	uint8_t *c=(uint8_t *)Coeff;
	const ptrdiff_t pa=ma.GetPitch(),pc=pitch;

#ifdef AVX512_BUILD_POSSIBLE
	if (AVX512_Enable)
	{
		const uint16_t n=(co+7)>>3;

		for (uint16_t i=0; i<li; i++)
		{
			VectorProd2D_AVX512((double *)c,(const double *)a,n);

			a+=pa;
			c+=pc;
		}
	}
	else
#endif
	{
		if (AVX_Enable)
		{
			const uint16_t n=(co+3)>>2;

			for (uint16_t i=0; i<li; i++)
			{
				VectorProd2D_AVX((double *)c,(const double *)a,n);

				a+=pa;
				c+=pc;
			}
		}
		else
		{
			if (SSE2_Enable)
			{
				const uint16_t n=(co+1)>>1;

				for (uint16_t i=0; i<li; i++)
				{
					VectorProd2D_SSE2((double *)c,(const double *)a,n);

					a+=pa;
					c+=pc;
				}
			}
			else
			{
				for (uint16_t i=0; i<li; i++)
				{
					const double *a1=(const double *)a;
					double *c1=(double *)c;

					for (uint16_t j=0; j<co; j++)
						c1[j]*=a1[j];

					a+=pa;
					c+=pc;
				}
			}
		}
	}
}


bool Matrix_Compute::Sub_A(const Matrix &ma, const Matrix &mb)
{
	if ((Coeff==nullptr) || (lines==0) || (columns==0)) return(false);
	if (!ma.AllocCheck() || !mb.AllocCheck()) return(false);

	if ((ma.GetColumns()!=mb.GetColumns()) || (ma.GetLines()!=mb.GetLines()) || (columns!=ma.GetColumns())
		|| (lines!=ma.GetLines()) || (ma.GetDataType()!=mb.GetDataType()) || (ma.GetDataType()!=data_type)) return(false);

	switch(data_type)
	{
		case DATA_FLOAT : Sub_A(ma,mb); break;
		case DATA_DOUBLE : Sub_A(ma,mb); break;
		default : return(false);
	}

	return(true);
}


bool Matrix_Compute::Sub_A(const Matrix &ma)
{
	if ((Coeff==nullptr) || (lines==0) || (columns==0)) return(false);
	if (!ma.AllocCheck()) return(false);

	if ((columns!=ma.GetColumns()) || (lines!=ma.GetLines()) || (ma.GetDataType()!=data_type)) return(false);

	switch(data_type)
	{
		case DATA_FLOAT : Sub_A(ma); break;
		case DATA_DOUBLE : Sub_A(ma); break;
		default : return(false);
	}

	return(true);
}


bool Matrix_Compute::InvSub_A(const Matrix &ma)
{
	if ((Coeff==nullptr) || (lines==0) || (columns==0)) return(false);
	if (!ma.AllocCheck()) return(false);

	if ((columns!=ma.GetColumns()) || (lines!=ma.GetLines()) || (ma.GetDataType()!=data_type)) return(false);

	switch(data_type)
	{
		case DATA_FLOAT : InvSub_A(ma); break;
		case DATA_DOUBLE : InvSub_A(ma); break;
		default : return(false);
	}

	return(true);
}


void Matrix_Compute::SubF_A(const Matrix &ma, const Matrix &mb)
{
	const uint16_t li=lines,co=columns;
	const uint8_t *a=(const uint8_t *)ma.GetPtrMatrix();
	const uint8_t *b=(const uint8_t *)mb.GetPtrMatrix();
	uint8_t *c=(uint8_t *)Coeff;
	const ptrdiff_t pa=ma.GetPitch(),pb=mb.GetPitch(),pc=pitch;

#ifdef AVX512_BUILD_POSSIBLE
	if (AVX512_Enable)
	{
		const uint16_t n=(co+15)>>4;

		for (uint16_t i=0; i<li; i++)
		{
			VectorSubF_AVX512((const float *)a,(const float *)b,(float *)c,n);

			a+=pa;
			b+=pb;
			c+=pc;
		}
	}
	else
#endif
	{
		if (AVX_Enable)
		{
			const uint16_t n=(co+7)>>3;

			for (uint16_t i=0; i<li; i++)
			{
				VectorSubF_AVX((const float *)a,(const float *)b,(float *)c,n);

				a+=pa;
				b+=pb;
				c+=pc;
			}
		}
		else
		{
			if (SSE2_Enable)
			{
				const uint16_t n=(co+3)>>2;

				for (uint16_t i=0; i<li; i++)
				{
					VectorSubF_SSE2((const float *)a,(const float *)b,(float *)c,n);

					a+=pa;
					b+=pb;
					c+=pc;
				}
			}
			else
			{
				for (uint16_t i=0; i<li; i++)
				{
					const float *a1=(const float *)a;
					const float *b1=(const float *)b;
					float *c1=(float *)c;

					for (uint16_t j=0; j<co; j++)
						c1[j]=a1[j]-b1[j];

					a+=pa;
					b+=pb;
					c+=pc;
				}
			}
		}
	}
}


void Matrix_Compute::SubD_A(const Matrix &ma, const Matrix &mb)
{
	const uint16_t li=lines,co=columns;
	const uint8_t *a=(const uint8_t *)ma.GetPtrMatrix();
	const uint8_t *b=(const uint8_t *)mb.GetPtrMatrix();
	uint8_t *c=(uint8_t *)Coeff;
	const ptrdiff_t pa=ma.GetPitch(),pb=mb.GetPitch(),pc=pitch;

#ifdef AVX512_BUILD_POSSIBLE
	if (AVX512_Enable)
	{
		const uint16_t n=(co+7)>>3;

		for (uint16_t i=0; i<li; i++)
		{
			VectorSubD_AVX512((const double *)a,(const double *)b,(double *)c,n);

			a+=pa;
			b+=pb;
			c+=pc;
		}
	}
	else
#endif
	{
		if (AVX_Enable)
		{
			const uint16_t n=(co+3)>>2;

			for (uint16_t i=0; i<li; i++)
			{
				VectorSubD_AVX((const double *)a,(const double *)b,(double *)c,n);

				a+=pa;
				b+=pb;
				c+=pc;
			}
		}
		else
		{
			if (SSE2_Enable)
			{
				const uint16_t n=(co+1)>>1;

				for (uint16_t i=0; i<li; i++)
				{
					VectorSubD_SSE2((const double *)a,(const double *)b,(double *)c,n);

					a+=pa;
					b+=pb;
					c+=pc;
				}
			}
			else
			{
				for (uint16_t i=0; i<li; i++)
				{
					const double *a1=(const double *)a;
					const double *b1=(const double *)b;
					double *c1=(double *)c;

					for (uint16_t j=0; j<co; j++)
						c1[j]=a1[j]-b1[j];

					a+=pa;
					b+=pb;
					c+=pc;
				}
			}
		}
	}
}


void Matrix_Compute::SubF_A(const Matrix &ma)
{
	const uint16_t li=lines,co=columns;
	const uint8_t *a=(const uint8_t *)ma.GetPtrMatrix();
	uint8_t *c=(uint8_t *)Coeff;
	const ptrdiff_t pa=ma.GetPitch(),pc=pitch;

#ifdef AVX512_BUILD_POSSIBLE
	if (AVX512_Enable)
	{
		const uint16_t n=(co+15)>>4;

		for (uint16_t i=0; i<li; i++)
		{
			VectorSub2F_AVX512((float *)c,(const float *)a,n);

			a+=pa;
			c+=pc;
		}
	}
	else
#endif
	{
		if (AVX_Enable)
		{
			const uint16_t n=(co+7)>>3;

			for (uint16_t i=0; i<li; i++)
			{
				VectorSub2F_AVX((float *)c,(const float *)a,n);

				a+=pa;
				c+=pc;
			}
		}
		else
		{
			if (SSE2_Enable)
			{
				const uint16_t n=(co+3)>>2;

				for (uint16_t i=0; i<li; i++)
				{
					VectorSub2F_SSE2((float *)c,(const float *)a,n);

					a+=pa;
					c+=pc;
				}
			}
			else
			{
				for (uint16_t i=0; i<li; i++)
				{
					const float *a1=(const float *)a;
					float *c1=(float *)c;

					for (uint16_t j=0; j<co; j++)
						c1[j]-=a1[j];

					a+=pa;
					c+=pc;
				}
			}
		}
	}
}


void Matrix_Compute::InvSubF_A(const Matrix &ma)
{
	const uint16_t li=lines,co=columns;
	const uint8_t *a=(const uint8_t *)ma.GetPtrMatrix();
	uint8_t *c=(uint8_t *)Coeff;
	const ptrdiff_t pa=ma.GetPitch(),pc=pitch;

#ifdef AVX512_BUILD_POSSIBLE
	if (AVX512_Enable)
	{
		const uint16_t n=(co+15)>>4;

		for (uint16_t i=0; i<li; i++)
		{
			VectorInvSubF_AVX512((float *)c,(const float *)a,n);

			a+=pa;
			c+=pc;
		}
	}
	else
#endif
	{
		if (AVX_Enable)
		{
			const uint16_t n=(co+7)>>3;

			for (uint16_t i=0; i<li; i++)
			{
				VectorInvSubF_AVX((float *)c,(const float *)a,n);

				a+=pa;
				c+=pc;
			}
		}
		else
		{
			if (SSE2_Enable)
			{
				const uint16_t n=(co+3)>>2;

				for (uint16_t i=0; i<li; i++)
				{
					VectorInvSubF_SSE2((float *)c,(const float *)a,n);

					a+=pa;
					c+=pc;
				}
			}
			else
			{
				for (uint16_t i=0; i<li; i++)
				{
					const float *a1=(const float *)a;
					float *c1=(float *)c;

					for (uint16_t j=0; j<co; j++)
						c1[j]=a1[j]-c1[j];

					a+=pa;
					c+=pc;
				}
			}
		}
	}
}


void Matrix_Compute::SubD_A(const Matrix &ma)
{
	const uint16_t li=lines,co=columns;
	const uint8_t *a=(const uint8_t *)ma.GetPtrMatrix();
	uint8_t *c=(uint8_t *)Coeff;
	const ptrdiff_t pa=ma.GetPitch(),pc=pitch;

#ifdef AVX512_BUILD_POSSIBLE
	if (AVX512_Enable)
	{
		const uint16_t n=(co+7)>>3;

		for (uint16_t i=0; i<li; i++)
		{
			VectorSub2D_AVX512((double *)c,(const double *)a,n);

			a+=pa;
			c+=pc;
		}
	}
	else
#endif
	{
		if (AVX_Enable)
		{
			const uint16_t n=(co+3)>>2;

			for (uint16_t i=0; i<li; i++)
			{
				VectorSub2D_AVX((double *)c,(const double *)a,n);

				a+=pa;
				c+=pc;
			}
		}
		else
		{
			if (SSE2_Enable)
			{
				const uint16_t n=(co+1)>>1;

				for (uint16_t i=0; i<li; i++)
				{
					VectorSub2D_SSE2((double *)c,(const double *)a,n);

					a+=pa;
					c+=pc;
				}
			}
			else
			{
				for (uint16_t i=0; i<li; i++)
				{
					const double *a1=(const double *)a;
					double *c1=(double *)c;

					for (uint16_t j=0; j<co; j++)
						c1[j]-=a1[j];

					a+=pa;
					c+=pc;
				}
			}
		}
	}
}


void Matrix_Compute::InvSubD_A(const Matrix &ma)
{
	const uint16_t li=lines,co=columns;
	const uint8_t *a=(const uint8_t *)ma.GetPtrMatrix();
	uint8_t *c=(uint8_t *)Coeff;
	const ptrdiff_t pa=ma.GetPitch(),pc=pitch;

#ifdef AVX512_BUILD_POSSIBLE
	if (AVX512_Enable)
	{
		const uint16_t n=(co+7)>>3;

		for (uint16_t i=0; i<li; i++)
		{
			VectorInvSubD_AVX512((double *)c,(const double *)a,n);

			a+=pa;
			c+=pc;
		}
	}
	else
#endif
	{
		if (AVX_Enable)
		{
			const uint16_t n=(co+3)>>2;

			for (uint16_t i=0; i<li; i++)
			{
				VectorInvSubD_AVX((double *)c,(const double *)a,n);

				a+=pa;
				c+=pc;
			}
		}
		else
		{
			if (SSE2_Enable)
			{
				const uint16_t n=(co+1)>>1;

				for (uint16_t i=0; i<li; i++)
				{
					VectorInvSubD_SSE2((double *)c,(const double *)a,n);

					a+=pa;
					c+=pc;
				}
			}
			else
			{
				for (uint16_t i=0; i<li; i++)
				{
					const double *a1=(const double *)a;
					double *c1=(double *)c;

					for (uint16_t j=0; j<co; j++)
						c1[j]=a1[j]-c1[j];

					a+=pa;
					c+=pc;
				}
			}
		}
	}
}


bool Matrix_Compute::Product_AB(const Matrix &ma, const Matrix &mb)
{
	if ((Coeff==nullptr) || (lines==0) || (columns==0)) return(false);
	if (!ma.AllocCheck() || !mb.AllocCheck()) return(false);

	if ((ma.GetColumns()!=mb.GetLines()) || (columns!=mb.GetColumns()) || (lines!=ma.GetLines())
		|| (ma.GetDataType()!=mb.GetDataType()) || (ma.GetDataType()!=data_type)) return(false);

	switch(data_type)
	{
		case DATA_FLOAT : ProductF_AB(ma,mb); break;
		case DATA_DOUBLE : ProductD_AB(ma,mb); break;
		default : return(false);
	}

	return(true);
}


void Matrix_Compute::ProductF_AB(const Matrix &ma, const Matrix &mb)
{
	const uint16_t li=lines,co=columns;
	const uint16_t ca=ma.GetColumns();
	const uint8_t *a=(const uint8_t *)ma.GetPtrMatrix();
	const uint8_t *b=(const uint8_t *)mb.GetPtrMatrix();
	uint8_t *c=(uint8_t *)Coeff;
	const ptrdiff_t pa=ma.GetPitch(),pb=mb.GetPitch(),pc=pitch;

	const uint8_t *a0=a;
	uint8_t *c0=c;

#ifdef AVX512_BUILD_POSSIBLE
	if (AVX512_Enable)
	{
		const uint16_t n=(co+15)>>4;

		for (uint16_t i=0; i<li; i++)
		{
			const float a1=*(const float *)a0;

			if (a1!=0.0f) CoeffProductF_AVX512(&a1,(const float *)b,(float *)c0,n);
			else std::fill_n((float *)c0,co,0.0f);

			a0+=pa;
			c0+=pc;
		}
		b+=pb;

		for(uint16_t i=1; i<ca; i++)
		{
			const float *b1=(const float *)b;

			a0=a;c0=c;
			for (uint16_t j=0; j<li; j++)
			{
				const float a1=((float *)a0)[i];

				if (a1!=0.0f) CoeffAddProductF_AVX512(&a1,b1,(float *)c0,n);
				a0+=pa;
				c0+=pc;
			}
			b+=pb;
		}
	}
	else
#endif
	{
		if (AVX_Enable)
		{
			const uint16_t n=(co+7)>>3;

			for (uint16_t i=0; i<li; i++)
			{
				const float a1=*(const float *)a0;

				if (a1!=0.0f) CoeffProductF_AVX(&a1,(const float *)b,(float *)c0,n);
				else std::fill_n((float *)c0,co,0.0f);

				a0+=pa;
				c0+=pc;
			}
			b+=pb;

			for(uint16_t i=1; i<ca; i++)
			{
				const float *b1=(const float *)b;

				a0=a;c0=c;
				for (uint16_t j=0; j<li; j++)
				{
					const float a1=((float *)a0)[i];

					if (a1!=0.0f) CoeffAddProductF_AVX(&a1,b1,(float *)c0,n);
					a0+=pa;
					c0+=pc;
				}
				b+=pb;
			}
		}
		else
		{
			if (SSE2_Enable)
			{
				const uint16_t n=(co+3)>>2;

				for (uint16_t i=0; i<li; i++)
				{
					const float a1=*(const float *)a0;

					if (a1!=0.0f) CoeffProductF_SSE2(&a1,(const float *)b,(float *)c0,n);
					else std::fill_n((float *)c0,co,0.0f);

					a0+=pa;
					c0+=pc;
				}
				b+=pb;

				for(uint16_t i=1; i<ca; i++)
				{
					const float *b1=(const float *)b;

					a0=a;c0=c;
					for (uint16_t j=0; j<li; j++)
					{
						const float a1=((float *)a0)[i];

						if (a1!=0.0f) CoeffAddProductF_SSE2(&a1,b1,(float *)c0,n);
						a0+=pa;
						c0+=pc;
					}
					b+=pb;
				}
			}
			else
			{
				for (uint16_t i=0; i<li; i++)
				{
					const float *b1=(const float *)b;
					const float a1=*(const float *)a0;
					float *c1=(float *)c0;

					if (a1!=0.0f)
					{
						for (uint16_t j=0; j<co; j++)
							c1[j]=a1*b1[j];
					}
					else std::fill_n((float *)c0,co,0.0f);

					a0+=pa;
					c0+=pc;
				}
				b+=pb;

				for(uint16_t i=1; i<ca; i++)
				{
					const float *b1=(const float *)b;

					a0=a;c0=c;
					for (uint16_t j=0; j<li; j++)
					{
						float *c1=(float *)c0;
						const float a1=((float *)a0)[i];

						if (a1!=0.0f)
						{
							for(uint16_t k=0; k<co; k++)
								c1[k]+=a1*b1[k];
						}
						a0+=pa;
						c0+=pc;
					}
					b+=pb;
				}
			}
		}
	}
}


void Matrix_Compute::ProductD_AB(const Matrix &ma, const Matrix &mb)
{
	const uint16_t li=lines,co=columns;
	const uint16_t ca=ma.GetColumns();
	const uint8_t *a=(const uint8_t *)ma.GetPtrMatrix();
	const uint8_t *b=(const uint8_t *)mb.GetPtrMatrix();
	uint8_t *c=(uint8_t *)Coeff;
	const ptrdiff_t pa=ma.GetPitch(),pb=mb.GetPitch(),pc=pitch;

	const uint8_t *a0=a;
	uint8_t *c0=c;

#ifdef AVX512_BUILD_POSSIBLE
	if (AVX512_Enable)
	{
		const uint16_t n=(co+7)>>3;

		for (uint16_t i=0; i<li; i++)
		{
			const double a1=*(double *)a0;

			if (a1!=0.0) CoeffProductD_AVX512(&a1,(const double *)b,(double *)c0,n);
			else std::fill_n((double *)c0,co,0.0);

			a0+=pa;
			c0+=pc;
		}
		b+=pb;

		for(uint16_t i=1; i<ca; i++)
		{
			const double *b1=(const double *)b;

			a0=a;c0=c;
			for (uint16_t j=0; j<li; j++)
			{
				const double a1=((double *)a0)[i];

				if (a1!=0.0) CoeffAddProductD_AVX512(&a1,b1,(double *)c0,n);
				a0+=pa;
				c0+=pc;
			}
			b+=pb;
		}
	}
	else
#endif
	{
		if (AVX_Enable)
		{
			const uint16_t n=(co+3)>>2;

			for (uint16_t i=0; i<li; i++)
			{
				const double a1=*(double *)a0;

				if (a1!=0.0) CoeffProductD_AVX(&a1,(const double *)b,(double *)c0,n);
				else std::fill_n((double *)c0,co,0.0);

				a0+=pa;
				c0+=pc;
			}
			b+=pb;

			for(uint16_t i=1; i<ca; i++)
			{
				const double *b1=(const double *)b;

				a0=a;c0=c;
				for (uint16_t j=0; j<li; j++)
				{
					const double a1=((double *)a0)[i];

					if (a1!=0.0) CoeffAddProductD_AVX(&a1,b1,(double *)c0,n);
					a0+=pa;
					c0+=pc;
				}
				b+=pb;
			}
		}
		else
		{
			if (SSE2_Enable)
			{
				const uint16_t n=(co+1)>>1;

				for (uint16_t i=0; i<li; i++)
				{
					const double a1=*(double *)a0;

					if (a1!=0.0) CoeffProductD_SSE2(&a1,(const double *)b,(double *)c0,n);
					else std::fill_n((double *)c0,co,0.0);

					a0+=pa;
					c0+=pc;
				}
				b+=pb;

				for(uint16_t i=1; i<ca; i++)
				{
					const double *b1=(const double *)b;

					a0=a;c0=c;
					for (uint16_t j=0; j<li; j++)
					{
						const double a1=((double *)a0)[i];

						if (a1!=0.0) CoeffAddProductD_SSE2(&a1,b1,(double *)c0,n);
						a0+=pa;
						c0+=pc;
					}
					b+=pb;
				}
			}
			else
			{
				for (uint16_t i=0; i<li; i++)
				{
					const double *b1=(const double *)b;
					const double a1=*(double *)a0;
					double *c1=(double *)c0;

					if (a1!=0.0)
					{
						for (uint16_t j=0; j<co; j++)
							c1[j]=a1*b1[j];
					}
					else std::fill_n((double *)c0,co,0.0);

					a0+=pa;
					c0+=pc;
				}
				b+=pb;

				for(uint16_t i=1; i<ca; i++)
				{
					const double *b1=(const double *)b;

					a0=a;c0=c;
					for (uint16_t j=0; j<li; j++)
					{
						double *c1=(double *)c0;
						const double a1=((double *)a0)[i];

						if (a1!=0.0)
						{
							for(uint16_t k=0; k<co; k++)
								c1[k]+=a1*b1[k];
						}
						a0+=pa;
						c0+=pc;
					}
					b+=pb;
				}
			}
		}
	}
}


bool Matrix_Compute::Product_AtB(const Matrix &ma,const Matrix &mb)
{
	if ((Coeff==nullptr) || (lines==0) || (columns==0)) return(false);
	if (!ma.AllocCheck() || !mb.AllocCheck()) return(false);

	if ((ma.GetColumns()!=mb.GetColumns()) || (columns!=mb.GetLines()) || (lines!=ma.GetLines())
		|| (ma.GetDataType()!=mb.GetDataType()) || (ma.GetDataType()!=data_type)) return(false);

	switch(data_type)
	{
		case DATA_FLOAT : ProductF_AtB(ma,mb); break;
		case DATA_DOUBLE : ProductD_AtB(ma,mb); break;
		default : return(false);
	}

	return(true);
}


void Matrix_Compute::ProductF_AtB(const Matrix &ma,const Matrix &mb)
{
	const uint16_t l=lines,co=columns;
	const uint16_t ca=ma.GetColumns();
	const uint8_t *a=(const uint8_t *)ma.GetPtrMatrix();
	const uint8_t *b=(const uint8_t *)mb.GetPtrMatrix();
	uint8_t *c=(uint8_t *)Coeff;
	const ptrdiff_t pa=ma.GetPitch(),pb=mb.GetPitch(),pc=pitch;

#ifdef AVX512_BUILD_POSSIBLE
	if (AVX512_Enable)
	{
		const uint16_t n=(ca+15)>>4;

		for (uint16_t i=0; i<l; i++)
		{
			const uint8_t *b0=b;
			float *c1=(float *)c;

			for (uint16_t j=0; j<co; j++)
			{
				VectorProductF_AVX512((const float *)a,(const float *)b0,c1++,n);
				b0+=pb;
			}
			a+=pa;
			c+=pc;
		}
	}
	else
#endif
	{
		if (AVX_Enable)
		{
			const uint16_t n=(ca+7)>>3;

			for (uint16_t i=0; i<l; i++)
			{
				const uint8_t *b0=b;
				float *c1=(float *)c;

				for (uint16_t j=0; j<co; j++)
				{
					VectorProductF_AVX((const float *)a,(const float *)b0,c1++,n);
					b0+=pb;
				}
				a+=pa;
				c+=pc;
			}
		}
		else
		{
			if (SSE2_Enable)
			{
				const uint16_t n=(ca+3)>>2;

				for (uint16_t i=0; i<l; i++)
				{
					const uint8_t *b0=b;
					float *c1=(float *)c;

					for (uint16_t j=0; j<co; j++)
					{
						VectorProductF_SSE2((const float *)a,(const float *)b0,c1++,n);
						b0+=pb;
					}
					a+=pa;
					c+=pc;
				}
			}
			else
			{
				for (uint16_t i=0; i<l; i++)
				{
					const float *a1=(const float *)a;
					const uint8_t *b0=b;
					float *c1=(float *)c;

					for (uint16_t j=0; j<co; j++)
					{
						float s=0.0f;
						const float *b1=(const float *)b0;

						for (uint16_t k=0; k<ca; k++)
							s+=a1[k]*b1[k];
						*c1++=s;
						b0+=pb;
					}
					a+=pa;
					c+=pc;
				}
			}
		}
	}
}


void Matrix_Compute::ProductD_AtB(const Matrix &ma,const Matrix &mb)
{
	const uint16_t l=lines,co=columns;
	const uint16_t ca=ma.GetColumns();
	const uint8_t *a=(const uint8_t *)ma.GetPtrMatrix();
	const uint8_t *b=(const uint8_t *)mb.GetPtrMatrix();
	uint8_t *c=(uint8_t *)Coeff;
	const ptrdiff_t pa=ma.GetPitch(),pb=mb.GetPitch(),pc=pitch;

#ifdef AVX512_BUILD_POSSIBLE
	if (AVX512_Enable)
	{
		const uint16_t n=(ca+7)>>3;

		for (uint16_t i=0; i<l; i++)
		{
			const uint8_t *b0=b;
			double *c1=(double *)c;

			for (uint16_t j=0; j<co; j++)
			{
				VectorProductD_AVX512((const double *)a,(const double *)b0,c1++,n);
				b0+=pb;
			}
			a+=pa;
			c+=pc;
		}
	}
	else
#endif
	{
		if (AVX_Enable)
		{
			const uint16_t n=(ca+3)>>2;

			for (uint16_t i=0; i<l; i++)
			{
				const uint8_t *b0=b;
				double *c1=(double *)c;

				for (uint16_t j=0; j<co; j++)
				{
					VectorProductD_AVX((const double *)a,(const double *)b0,c1++,n);
					b0+=pb;
				}
				a+=pa;
				c+=pc;
			}
		}
		else
		{
			if (SSE2_Enable)
			{
				const uint16_t n=(ca+1)>>1;

				for (uint16_t i=0; i<l; i++)
				{
					const uint8_t *b0=b;
					double *c1=(double *)c;

					for (uint16_t j=0; j<co; j++)
					{
						VectorProductD_SSE2((const double *)a,(const double *)b0,c1++,n);
						b0+=pb;
					}
					a+=pa;
					c+=pc;
				}
			}
			else
			{
				for (uint16_t i=0; i<l; i++)
				{
					const double *a1=(const double *)a;
					const uint8_t *b0=b;
					double *c1=(double *)c;

					for (uint16_t j=0; j<co; j++)
					{
						double s=0.0;
						const double *b1=(const double *)b0;

						for (uint16_t k=0; k<ca; k++)
							s+=a1[k]*b1[k];
						*c1++=s;
						b0+=pb;
					}
					a+=pa;
					c+=pc;
				}
			}
		}
	}
}


bool Matrix_Compute::Product_tAA(const Matrix &ma)
{
	if ((Coeff==nullptr) || (lines==0) || (columns==0) || (lines!=columns)) return(false);
	if (!ma.AllocCheck()) return(false);

	if ((lines!=ma.GetColumns()) || (ma.GetDataType()!=data_type)) return(false);

	Matrix_Compute b;

	b.CreateTranspose(ma);

	if (!b.AllocCheck()) return(false);

	switch(data_type)
	{
		case DATA_FLOAT : ProductF_AB(b,ma); break;
		case DATA_DOUBLE : ProductD_AB(b,ma); break;
		default : return(false);
	}

	return(true);
}


bool Matrix_Compute::Product_tAA(void)
{
	if ((Coeff==nullptr) || (lines==0) || (columns==0) || (lines!=columns)) return(false);

	Matrix_Compute a(*this),b;

	if (!a.AllocCheck()) return(false);

	b.CreateTranspose(*this);

	if (!b.AllocCheck()) return(false);

	switch(data_type)
	{
		case DATA_FLOAT : ProductF_AB(b,a); break;
		case DATA_DOUBLE : ProductF_AB(b,a); break;
		default : return(false);
	}

	return(true);
}


bool Matrix_Compute::Inverse(const Matrix &ma)
{
	const uint16_t l=lines,c=columns;

	if ((Coeff==nullptr) || (lines==0) || (columns==0) || (columns!=lines)) return(false);
	if (!ma.AllocCheck()) return(false);

	if ((ma.GetColumns()!=ma.GetLines()) || (lines!=ma.GetLines()) || (ma.GetDataType()!=data_type)) return(false);

	switch(data_type)
	{
		case DATA_FLOAT : return(InverseF(ma)); break;
		case DATA_DOUBLE : return(InverseD(ma)); break;
		default : return(false);
	}

	return(false);
}


bool Matrix_Compute::Inverse(void)
{
	if ((Coeff==nullptr) || (lines==0) || (columns==0) || (columns!=lines)) return(false);

	switch(data_type)
	{
		case DATA_FLOAT : return(InverseF(*this)); break;
		case DATA_DOUBLE : return(InverseD(*this)); break;
		default : return(false);
	}

	return(false);
}


bool Matrix_Compute::InverseF(const Matrix &ma)
{
	const uint16_t l=lines,c=columns;
	const uint16_t c2=c<<1;

	Matrix b(l,c2,data_type);

	if (!b.AllocCheck()) return(false);

	b.FillZero();

	const uint8_t *a0=(const uint8_t *)ma.GetPtrMatrix();
	uint8_t *b_=(uint8_t *)b.GetPtrMatrix();
	const size_t size_line=(size_t)c*sizeof(float);
	const ptrdiff_t pa=ma.GetPitch(),pb=b.GetPitch(),pc=pitch;
	uint8_t *b0=b_;

	for (uint16_t i=0; i<l; i++)
	{
		memcpy(b0,a0,size_line);
		b0+=pb;
		a0+=pa;
		b.SetF(i,i+c,1.0f);
	}

	b0=b_;

#ifdef AVX512_BUILD_POSSIBLE
	if (AVX512_Enable)
	{
		const uint16_t n=(c2+15)>>4;

		for (uint16_t i=0; i<l; i++)
		{
			float *b2=(float *)b0;
			uint8_t *b1=b_;

			for (uint16_t j=0; j<c; j++)
			{
				float *b3=(float *)b1;

				if (i!=j)
				{
					const float ratio=-b3[i]/b2[i];

					if (ratio!=0.0f) CoeffAddProductF_AVX512(&ratio,b2,b3,n);
				}
				b1+=pb;
			}
			b0+=pb;
		}

		b0=b_;
		for (uint16_t i=0; i<l; i++)
		{
			float *b2=(float *)b0;
			const float a=1.0f/b2[i];

			CoeffProductF_AVX512(&a,b2,b2,n);

			b0+=pb;
		}
	}
	else
#endif
	{
		if (AVX_Enable)
		{
			const uint16_t n=(c2+7)>>3;

			for (uint16_t i=0; i<l; i++)
			{
				float *b2=(float *)b0;
				uint8_t *b1=b_;

				for (uint16_t j=0; j<c; j++)
				{
					float *b3=(float *)b1;

					if (i!=j)
					{
						const float ratio=-b3[i]/b2[i];

						if (ratio!=0.0f) CoeffAddProductF_AVX(&ratio,b2,b3,n);
					}
					b1+=pb;
				}
				b0+=pb;
			}

			b0=b_;
			for (uint16_t i=0; i<l; i++)
			{
				float *b2=(float *)b0;
				const float a=1.0f/b2[i];

				CoeffProductF_AVX(&a,b2,b2,n);

				b0+=pb;
			}
		}
		else
		{
			if (SSE2_Enable)
			{
				const uint16_t n=(c2+3)>>2;

				for (uint16_t i=0; i<l; i++)
				{
					float *b2=(float *)b0;
					uint8_t *b1=b_;

					for (uint16_t j=0; j<c; j++)
					{
						float *b3=(float *)b1;

						if (i!=j)
						{
							const float ratio=-b3[i]/b2[i];

							if (ratio!=0.0f) CoeffAddProductF_SSE2(&ratio,b2,b3,n);
						}
						b1+=pb;
					}
					b0+=pb;
				}

				b0=b_;
				for (uint16_t i=0; i<l; i++)
				{
					float *b2=(float *)b0;
					const float a=1.0f/b2[i];

					CoeffProductF_SSE2(&a,b2,b2,n);

					b0+=pb;
				}
			}
			else
			{
				for (uint16_t i=0; i<l; i++)
				{
					float *b2=(float *)b0;
					uint8_t *b1=b_;

					for (uint16_t j=0; j<c; j++)
					{
						float *b3=(float *)b1;

						if (i!=j)
						{
							const float ratio=-b3[i]/b2[i];

							if (ratio!=0.0f)
							{
								for (uint16_t k=0; k<c2; k++)
									b3[k]+=ratio*b2[k];
							}
						}
						b1+=pb;
					}
					b0+=pb;
				}

				b0=b_;
				for (uint16_t i=0; i<l; i++)
				{
					float *b2=(float *)b0;
					const float a=1.0f/b2[i];

					for (uint16_t j=0; j<c2; j++)
						b2[j]*=a;
					b0+=pb;
				}
			}
		}
	}

	b0=b_;
	b0+=(ptrdiff_t)c*sizeof(float);
	uint8_t *c0=(uint8_t *)Coeff;
	for (uint16_t i=0; i<l; i++)
	{
		memcpy(c0,b0,size_line);
		b0+=pb;
		c0+=pc;
	}

	return(true);
}


bool Matrix_Compute::InverseD(const Matrix &ma)
{
	const uint16_t l=lines,c=columns;
	const uint16_t c2=c<<1;

	Matrix b(l,c2,data_type);

	if (!b.AllocCheck()) return(false);

	b.FillZero();

	const uint8_t *a0=(const uint8_t *)ma.GetPtrMatrix();
	uint8_t *b_=(uint8_t *)b.GetPtrMatrix();
	const size_t size_line=(size_t)c*sizeof(double);
	const ptrdiff_t pa=ma.GetPitch(),pb=b.GetPitch(),pc=pitch;
	uint8_t *b0=b_;
	
	for (uint16_t i=0; i<l; i++)
	{
		memcpy(b0,a0,size_line);
		b0+=pb;
		a0+=pa;
		b.SetD(i,i+c,1.0);
	}

	b0=b_;

#ifdef AVX512_BUILD_POSSIBLE
	if (AVX512_Enable)
	{
		const uint16_t n=(c2+7)>>3;

		for (uint16_t i=0; i<l; i++)
		{
			double *b2=(double *)b0;
			uint8_t *b1=b_;

			for (uint16_t j=0; j<c; j++)
			{
				double *b3=(double *)b1;

				if (i!=j)
				{
					const double ratio=-b3[i]/b2[i];

					if (ratio!=0.0) CoeffAddProductD_AVX512(&ratio,b2,b3,n);
				}
				b1+=pb;
			}
			b0+=pb;
		}

		b0=b_;
		for (uint16_t i=0; i<l; i++)
		{
			double *b2=(double *)b0;
			const double a=1.0/b2[i];

			CoeffProductD_AVX512(&a,b2,b2,n);

			b0+=pb;
		}
	}
	else
#endif
	{
		if (AVX_Enable)
		{
			const uint16_t n=(c2+3)>>2;

			for (uint16_t i=0; i<l; i++)
			{
				double *b2=(double *)b0;
				uint8_t *b1=b_;

				for (uint16_t j=0; j<c; j++)
				{
					double *b3=(double *)b1;

					if (i!=j)
					{
						const double ratio=-b3[i]/b2[i];

						if (ratio!=0.0) CoeffAddProductD_AVX(&ratio,b2,b3,n);
					}
					b1+=pb;
				}
				b0+=pb;
			}

			b0=b_;
			for (uint16_t i=0; i<l; i++)
			{
				double *b2=(double *)b0;
				const double a=1.0/b2[i];

				CoeffProductD_AVX(&a,b2,b2,n);

				b0+=pb;
			}
		}
		else
		{
			if (SSE2_Enable)
			{
				const uint16_t n=(c2+1)>>1;

				for (uint16_t i=0; i<l; i++)
				{
					double *b2=(double *)b0;
					uint8_t *b1=b_;

					for (uint16_t j=0; j<c; j++)
					{
						double *b3=(double *)b1;

						if (i!=j)
						{
							const double ratio=-b3[i]/b2[i];

							if (ratio!=0.0) CoeffAddProductD_SSE2(&ratio,b2,b3,n);
						}
						b1+=pb;
					}
					b0+=pb;
				}

				b0=b_;
				for (uint16_t i=0; i<l; i++)
				{
					double *b2=(double *)b0;
					const double a=1.0/b2[i];

					CoeffProductD_SSE2(&a,b2,b2,n);

					b0+=pb;
				}
			}
			else
			{
				for (uint16_t i=0; i<l; i++)
				{
					double *b2=(double *)b0;
					uint8_t *b1=b_;

					for (uint16_t j=0; j<c; j++)
					{
						double *b3=(double *)b1;

						if (i!=j)
						{
							const double ratio=-b3[i]/b2[i];

							if (ratio!=0.0)
							{
								for (uint16_t k=0; k<c2; k++)
									b3[k]+=ratio*b2[k];
							}
						}
						b1+=pb;
					}
					b0+=pb;
				}

				b0=b_;
				for (uint16_t i=0; i<l; i++)
				{
					double *b2=(double *)b0;
					const double a=1.0/b2[i];

					for (uint16_t j=0; j<c2; j++)
						b2[j]*=a;
					b0+=pb;
				}
			}
		}
	}

	b0=b_;
	b0+=(ptrdiff_t)c*sizeof(double);
	uint8_t *c0=(uint8_t *)Coeff;
	for (uint16_t i=0; i<l; i++)
	{
		memcpy(c0,b0,size_line);
		b0+=pb;
		c0+=pc;
	}

	return(true);
}


/*
Return :
 0 : Matrix is reversed.
 -1 : Allocation/Matrix configuration error.
 -2 : Matrix can't be reversed.
*/
int8_t Matrix_Compute::InverseSafe(const Matrix_Compute &ma)
{
	if ((Coeff==nullptr) || (lines==0) || (columns==0) || (columns!=lines)) return(-1);
	if (!ma.AllocCheck()) return(-1);

	if ((ma.GetColumns()!=ma.GetLines()) || (lines!=ma.GetLines()) || (ma.GetDataType()!=data_type)) return(-1);

	switch(data_type)
	{
		case DATA_FLOAT : return(InverseSafeF(ma)); break;
		case DATA_DOUBLE : return(InverseSafeD(ma)); break;
		default : return(-1);
	}

	return(-1);
}


int8_t Matrix_Compute::InverseSafe(void)
{
	if ((Coeff==nullptr) || (lines==0) || (columns==0) || (columns!=lines)) return(-1);

	switch(data_type)
	{
		case DATA_FLOAT : return(InverseSafeF(*this)); break;
		case DATA_DOUBLE : return(InverseSafeD(*this)); break;
		default : return(-1);
	}

	return(-1);
}


/*	
Return :
 0 : Matrix is reversed.
 -1 : Allocation/Matrix configuration error.
 -2 : Matrix can't be reversed.
*/
int8_t Matrix_Compute::InverseSafeF(const Matrix_Compute &ma)
{
	const uint16_t l=lines,c=columns;
	const uint16_t c2=c<<1;

	Matrix b(l,c2,data_type);

	if (!b.AllocCheck()) return(-1);

	b.FillZero();

	const uint8_t *a0=(const uint8_t *)ma.GetPtrMatrix();
	uint8_t *b_=(uint8_t *)b.GetPtrMatrix();
	const size_t size_line=(size_t)c*sizeof(float);
	const ptrdiff_t pa=ma.GetPitch(),pb=b.GetPitch(),pc=pitch;
	const float _zero=(const float)ma.zero_value;
	uint8_t *b0=b_;
	
	for (uint16_t i=0; i<l; i++)
	{
		memcpy(b0,a0,size_line);
		b0+=pb;
		a0+=pa;
		b.SetF(i,i+l,1.0f);
	}

	b0=b_;

#ifdef AVX512_BUILD_POSSIBLE
	if (AVX512_Enable)
	{
		const uint16_t n=(c2+15)>>4;

		for (uint16_t i=0; i<l; i++)
		{
			float *b2=(float *)b0;
			uint8_t *b1=b_;

			for (uint16_t j=0; j<c; j++)
			{
				float *b3=(float *)b1;

				if (i!=j)
				{
					if (fabs(b2[i])<=_zero) return(-2);

					const float ratio=-b3[i]/b2[i];

					if (ratio!=0.0f) CoeffAddProductF_AVX512(&ratio,b2,b3,n);
				}
				b1+=pb;
			}
			b0+=pb;
		}

		b0=b_;
		for (uint16_t i=0; i<l; i++)
		{
			float *b2=(float *)b0;

			if (fabs(b2[i])<=_zero) return(-2);

			const float a=1.0f/b2[i];

			CoeffProductF_AVX512(&a,b2,b2,n);

			b0+=pb;
		}
	}
	else
#endif
	{
		if (AVX_Enable)
		{
			const uint16_t n=(c2+7)>>3;

			for (uint16_t i=0; i<l; i++)
			{
				float *b2=(float *)b0;
				uint8_t *b1=b_;

				for (uint16_t j=0; j<c; j++)
				{
					float *b3=(float *)b1;

					if (i!=j)
					{
						if (fabs(b2[i])<=_zero) return(-2);

						const float ratio=-b3[i]/b2[i];

						if (ratio!=0.0f) CoeffAddProductF_AVX(&ratio,b2,b3,n);
					}
					b1+=pb;
				}
				b0+=pb;
			}

			b0=b_;
			for (uint16_t i=0; i<l; i++)
			{
				float *b2=(float *)b0;

				if (fabs(b2[i])<=_zero) return(-2);

				const float a=1.0f/b2[i];

				CoeffProductF_AVX(&a,b2,b2,n);

				b0+=pb;
			}
		}
		else
		{
			if (SSE2_Enable)
			{
				const uint16_t n=(c2+3)>>2;

				for (uint16_t i=0; i<l; i++)
				{
					float *b2=(float *)b0;
					uint8_t *b1=b_;

					for (uint16_t j=0; j<c; j++)
					{
						float *b3=(float *)b1;

						if (i!=j)
						{
							if (fabs(b2[i])<=_zero) return(-2);

							const float ratio=-b3[i]/b2[i];

							if (ratio!=0.0f) CoeffAddProductF_SSE2(&ratio,b2,b3,n);
						}
						b1+=pb;
					}
					b0+=pb;
				}

				b0=b_;
				for (uint16_t i=0; i<l; i++)
				{
					float *b2=(float *)b0;

					if (fabs(b2[i])<=_zero) return(-2);

					const float a=1.0f/b2[i];

					CoeffProductF_SSE2(&a,b2,b2,n);

					b0+=pb;
				}
			}
			else
			{
				for (uint16_t i=0; i<l; i++)
				{
					float *b2=(float *)b0;
					uint8_t *b1=b_;

					for (uint16_t j=0; j<c; j++)
					{
						float *b3=(float *)b1;

						if (i!=j)
						{
							if (fabs(b2[i])<=_zero) return(-2);

							const float ratio=-b3[i]/b2[i];

							if (ratio!=0.0f)
							{
								for (uint16_t k=0; k<c2; k++)
									b3[k]+=ratio*b2[k];
							}
						}
						b1+=pb;
					}
					b0+=pb;
				}

				b0=b_;
				for (uint16_t i=0; i<l; i++)
				{
					float *b2=(float *)b0;

					if (fabs(b2[i])<=_zero) return(-2);

					const float a=1.0f/b2[i];

					for (uint16_t j=0; j<c2; j++)
						b2[j]*=a;
					b0+=pb;
				}
			}
		}
	}

	b0=b_;
	b0+=(ptrdiff_t)c*sizeof(float);
	uint8_t *c0=(uint8_t *)Coeff;
	for (uint16_t i=0; i<l; i++)
	{
		memcpy(c0,b0,size_line);
		b0+=pb;
		c0+=pc;
	}

	return(0);
}


/*
Return :
 0 : Matrix is reversed.
 -1 : Allocation/Matrix configuration error.
 -2 : Matrix can't be reversed.
*/
int8_t Matrix_Compute::InverseSafeD(const Matrix_Compute &ma)
{
	const uint16_t l=lines,c=columns;
	const uint16_t c2=c<<1;

	Matrix b(l,c2,data_type);

	if (!b.AllocCheck()) return(-1);

	b.FillZero();

	const uint8_t *a0=(const uint8_t *)ma.GetPtrMatrix();
	uint8_t *b_=(uint8_t *)b.GetPtrMatrix();
	const size_t size_line=(size_t)c*sizeof(double);
	const ptrdiff_t pa=ma.GetPitch(),pb=b.GetPitch(),pc=pitch;
	const double _zero=ma.zero_value;
	uint8_t *b0=b_;
	
	for (uint16_t i=0; i<l; i++)
	{
		memcpy(b0,a0,size_line);
		b0+=pb;
		a0+=pa;
		b.SetD(i,i+l,1.0);
	}

	b0=b_;

#ifdef AVX512_BUILD_POSSIBLE
	if (AVX512_Enable)
	{
		const uint16_t n=(c2+7)>>3;

		for (uint16_t i=0; i<l; i++)
		{
			double *b2=(double *)b0;
			uint8_t *b1=b_;

			for (uint16_t j=0; j<c; j++)
			{
				double *b3=(double *)b1;

				if (i!=j)
				{
					if (fabs(b2[i])<=_zero) return(-2);

					const double ratio=-b3[i]/b2[i];

					if (ratio!=0.0) CoeffAddProductD_AVX512(&ratio,b2,b3,n);
				}
				b1+=pb;
			}
			b0+=pb;
		}

		b0=b_;
		for (uint16_t i=0; i<l; i++)
		{
			double *b2=(double *)b0;

			if (fabs(b2[i])<=_zero) return(-2);

			const double a=1.0/b2[i];

			CoeffProductD_AVX512(&a,b2,b2,n);

			b0+=pb;
		}
	}
	else
#endif
	{
		if (AVX_Enable)
		{
			const uint16_t n=(c2+3)>>2;

			for (uint16_t i=0; i<l; i++)
			{
				double *b2=(double *)b0;
				uint8_t *b1=b_;

				for (uint16_t j=0; j<c; j++)
				{
					double *b3=(double *)b1;

					if (i!=j)
					{
						if (fabs(b2[i])<=_zero) return(-2);

						const double ratio=-b3[i]/b2[i];

						if (ratio!=0.0) CoeffAddProductD_AVX(&ratio,b2,b3,n);
					}
					b1+=pb;
				}
				b0+=pb;
			}

			b0=b_;
			for (uint16_t i=0; i<l; i++)
			{
				double *b2=(double *)b0;

				if (fabs(b2[i])<=_zero) return(-2);

				const double a=1.0/b2[i];

				CoeffProductD_AVX(&a,b2,b2,n);

				b0+=pb;
			}
		}
		else
		{
			if (SSE2_Enable)
			{
				const uint16_t n=(c2+1)>>1;

				for (uint16_t i=0; i<l; i++)
				{
					double *b2=(double *)b0;
					uint8_t *b1=b_;

					for (uint16_t j=0; j<c; j++)
					{
						double *b3=(double *)b1;

						if (i!=j)
						{
							if (fabs(b2[i])<=_zero) return(-2);

							const double ratio=-b3[i]/b2[i];

							if (ratio!=0.0) CoeffAddProductD_SSE2(&ratio,b2,b3,n);
						}
						b1+=pb;
					}
					b0+=pb;
				}

				b0=b_;
				for (uint16_t i=0; i<l; i++)
				{
					double *b2=(double *)b0;

					if (fabs(b2[i])<=_zero) return(-2);

					const double a=1.0/b2[i];

					CoeffProductD_SSE2(&a,b2,b2,n);

					b0+=pb;
				}
			}
			else
			{
				for (uint16_t i=0; i<l; i++)
				{
					double *b2=(double *)b0;
					uint8_t *b1=b_;

					for (uint16_t j=0; j<c; j++)
					{
						double *b3=(double *)b1;

						if (i!=j)
						{
							if (fabs(b2[i])<=_zero) return(-2);

							const double ratio=-b3[i]/b2[i];

							if (ratio!=0.0)
							{
								for (uint16_t k=0; k<c2; k++)
									b3[k]+=ratio*b2[k];
							}
						}
						b1+=pb;
					}
					b0+=pb;
				}

				b0=b_;
				for (uint16_t i=0; i<l; i++)
				{
					double *b2=(double *)b0;

					if (fabs(b2[i])<=_zero) return(-2);

					const double a=1.0/b2[i];

					for (uint16_t j=0; j<c2; j++)
						b2[j]*=a;
					b0+=pb;
				}
			}
		}
	}

	b0=b_;
	b0+=(ptrdiff_t)c*sizeof(double);
	uint8_t *c0=(uint8_t *)Coeff;
	for (uint16_t i=0; i<l; i++)
	{
		memcpy(c0,b0,size_line);
		b0+=pb;
		c0+=pc;
	}

	return(0);
}


bool Matrix_Compute::Transpose(const Matrix &ma)
{
	if ((Coeff==nullptr) || (lines==0) || (columns==0)) return(false);
	if (!ma.AllocCheck()) return(false);

	if ((lines!=ma.GetColumns()) || (columns!=ma.GetLines()) || (ma.GetDataType()!=data_type)) return(false);

	switch(data_type)
	{
		case DATA_FLOAT : TransposeF(ma); break;
		case DATA_DOUBLE : TransposeD(ma); break;
		case DATA_UINT64 : TransposeU64(ma); break;
		case DATA_INT64 : TransposeI64(ma); break;
		case DATA_UINT32 : TransposeU32(ma); break;
		case DATA_INT32 : TransposeI32(ma); break;
		case DATA_UINT16 : TransposeU16(ma); break;
		case DATA_INT16 : TransposeI16(ma); break;
		case DATA_UINT8 : TransposeU8(ma); break;
		case DATA_INT8 : TransposeI8(ma); break;
		default : return(false);
	}

	return(true);
}

bool Matrix_Compute::Transpose(void)
{
	if ((Coeff==nullptr) || (lines==0) || (columns==0) || (lines!=columns)) return(false);

	Matrix b(*this);

	if (!b.AllocCheck()) return(false);

	switch(data_type)
	{
		case DATA_FLOAT : TransposeF(b); break;
		case DATA_DOUBLE : TransposeD(b); break;
		case DATA_UINT64 : TransposeU64(b); break;
		case DATA_INT64 : TransposeI64(b); break;
		case DATA_UINT32 : TransposeU32(b); break;
		case DATA_INT32 : TransposeI32(b); break;
		case DATA_UINT16 : TransposeU16(b); break;
		case DATA_INT16 : TransposeI16(b); break;
		case DATA_UINT8 : TransposeU8(b); break;
		case DATA_INT8 : TransposeI8(b); break;
		default : return(false);
	}

	return(true);
}


void Matrix_Compute::TransposeF(const Matrix &ma)
{
	const uint16_t l=lines,c=columns;
	uint8_t *a0=(uint8_t *)Coeff;
	const uint8_t *b0=(const uint8_t *)ma.GetPtrMatrix();
	const ptrdiff_t pb=ma.GetPitch(),p=pitch,db0=sizeof(float);

	for (uint16_t i=0; i<l; i++)
	{
		const uint8_t *b1=b0;
		float *a=(float *)a0;

		for (uint16_t j=0; j<c; j++)
		{
			*a++=*(float *)b1;
			b1+=pb;
		}
		a0+=p;
		b0+=db0;
	}
}


void Matrix_Compute::TransposeD(const Matrix &ma)
{
	const uint16_t l=lines,c=columns;
	uint8_t *a0=(uint8_t *)Coeff;
	const uint8_t *b0=(const uint8_t *)ma.GetPtrMatrix();
	const ptrdiff_t pb=ma.GetPitch(),p=pitch,db0=sizeof(double);

	for (uint16_t i=0; i<l; i++)
	{
		const uint8_t *b1=b0;
		double *a=(double *)a0;

		for (uint16_t j=0; j<c; j++)
		{
			*a++=*(double *)b1;
			b1+=pb;
		}
		a0+=p;
		b0+=db0;
	}
}


void Matrix_Compute::TransposeU64(const Matrix &ma)
{
	const uint16_t l=lines,c=columns;
	uint8_t *a0=(uint8_t *)Coeff;
	const uint8_t *b0=(const uint8_t *)ma.GetPtrMatrix();
	const ptrdiff_t pb=ma.GetPitch(),p=pitch,db0=sizeof(uint64_t);

	for (uint16_t i=0; i<l; i++)
	{
		const uint8_t *b1=b0;
		uint64_t *a=(uint64_t *)a0;

		for (uint16_t j=0; j<c; j++)
		{
			*a++=*(uint64_t *)b1;
			b1+=pb;
		}
		a0+=p;
		b0+=db0;
	}
}


void Matrix_Compute::TransposeI64(const Matrix &ma)
{
	const uint16_t l=lines,c=columns;
	uint8_t *a0=(uint8_t *)Coeff;
	const uint8_t *b0=(const uint8_t *)ma.GetPtrMatrix();
	const ptrdiff_t pb=ma.GetPitch(),p=pitch,db0=sizeof(int64_t);

	for (uint16_t i=0; i<l; i++)
	{
		const uint8_t *b1=b0;
		int64_t *a=(int64_t *)a0;

		for (uint16_t j=0; j<c; j++)
		{
			*a++=*(int64_t *)b1;
			b1+=pb;
		}
		a0+=p;
		b0+=db0;
	}
}


void Matrix_Compute::TransposeU32(const Matrix &ma)
{
	const uint16_t l=lines,c=columns;
	uint8_t *a0=(uint8_t *)Coeff;
	const uint8_t *b0=(const uint8_t *)ma.GetPtrMatrix();
	const ptrdiff_t pb=ma.GetPitch(),p=pitch,db0=sizeof(uint32_t);

	for (uint16_t i=0; i<l; i++)
	{
		const uint8_t *b1=b0;
		uint32_t *a=(uint32_t *)a0;

		for (uint16_t j=0; j<c; j++)
		{
			*a++=*(uint32_t *)b1;
			b1+=pb;
		}
		a0+=p;
		b0+=db0;
	}
}


void Matrix_Compute::TransposeI32(const Matrix &ma)
{
	const uint16_t l=lines,c=columns;
	uint8_t *a0=(uint8_t *)Coeff;
	const uint8_t *b0=(const uint8_t *)ma.GetPtrMatrix();
	const ptrdiff_t pb=ma.GetPitch(),p=pitch,db0=sizeof(int32_t);

	for (uint16_t i=0; i<l; i++)
	{
		const uint8_t *b1=b0;
		int32_t *a=(int32_t *)a0;

		for (uint16_t j=0; j<c; j++)
		{
			*a++=*(int32_t *)b1;
			b1+=pb;
		}
		a0+=p;
		b0+=db0;
	}
}


void Matrix_Compute::TransposeU16(const Matrix &ma)
{
	const uint16_t l=lines,c=columns;
	uint8_t *a0=(uint8_t *)Coeff;
	const uint8_t *b0=(const uint8_t *)ma.GetPtrMatrix();
	const ptrdiff_t pb=ma.GetPitch(),p=pitch,db0=sizeof(uint16_t);

	for (uint16_t i=0; i<l; i++)
	{
		const uint8_t *b1=b0;
		uint16_t *a=(uint16_t *)a0;

		for (uint16_t j=0; j<c; j++)
		{
			*a++=*(uint16_t *)b1;
			b1+=pb;
		}
		a0+=p;
		b0+=db0;
	}
}


void Matrix_Compute::TransposeI16(const Matrix &ma)
{
	const uint16_t l=lines,c=columns;
	uint8_t *a0=(uint8_t *)Coeff;
	const uint8_t *b0=(const uint8_t *)ma.GetPtrMatrix();
	const ptrdiff_t pb=ma.GetPitch(),p=pitch,db0=sizeof(int16_t);

	for (uint16_t i=0; i<l; i++)
	{
		const uint8_t *b1=b0;
		int16_t *a=(int16_t *)a0;

		for (uint16_t j=0; j<c; j++)
		{
			*a++=*(int16_t *)b1;
			b1+=pb;
		}
		a0+=p;
		b0+=db0;
	}
}


void Matrix_Compute::TransposeU8(const Matrix &ma)
{
	const uint16_t l=lines,c=columns;
	uint8_t *a0=(uint8_t *)Coeff;
	const uint8_t *b0=(const uint8_t *)ma.GetPtrMatrix();
	const ptrdiff_t pb=ma.GetPitch(),p=pitch,db0=sizeof(uint8_t);

	for (uint16_t i=0; i<l; i++)
	{
		const uint8_t *b1=b0;
		uint8_t *a=a0;

		for (uint16_t j=0; j<c; j++)
		{
			*a++=*b1;
			b1+=pb;
		}
		a0+=p;
		b0+=db0;
	}
}


void Matrix_Compute::TransposeI8(const Matrix &ma)
{
	const uint16_t l=lines,c=columns;
	int8_t *a0=(int8_t *)Coeff;
	const int8_t *b0=(const int8_t *)ma.GetPtrMatrix();
	const ptrdiff_t pb=ma.GetPitch(),p=pitch,db0=sizeof(int8_t);

	for (uint16_t i=0; i<l; i++)
	{
		const int8_t *b1=b0;
		int8_t *a=a0;

		for (uint16_t j=0; j<c; j++)
		{
			*a++=*b1;
			b1+=pb;
		}
		a0+=p;
		b0+=db0;
	}
}


bool Matrix_Compute::Norme2(double &result)
{
	if ((Coeff==nullptr) || (lines==0) || (columns==0)) return(false);

	switch(data_type)
	{
		case DATA_FLOAT : result=Norme2F(); break;
		case DATA_DOUBLE : result=Norme2D(); break;
		default : return(false);
	}

	return(true);
}


double Matrix_Compute::Norme2F(void)
{
	const uint16_t l=lines,c=columns;
	const uint8_t *c0=(uint8_t *)Coeff;
	const ptrdiff_t p=pitch;
	double s=0.0;

#ifdef AVX512_BUILD_POSSIBLE
	if (AVX512_Enable)
	{
		const uint16_t n=(c+15)>>4;
		float r;

		for (int32_t i=0; i<l; i++)
		{
			VectorNormeF_AVX512((const float *)c0,&r,n);
			c0+=p;
			s+=(double)r;
		}
	}
	else
#endif
	{
		if (AVX_Enable)
		{
			const uint16_t n=(c+7)>>3;
			float r;

			for (int32_t i=0; i<l; i++)
			{
				VectorNormeF_AVX((const float *)c0,&r,n);
				c0+=p;
				s+=(double)r;
			}
		}
		else
		{
			if (SSE2_Enable)
			{
				const uint16_t n=(c+3)>>2;
				float r;

				for (int32_t i=0; i<l; i++)
				{
					VectorNormeF_SSE2((const float *)c0,&r,n);
					c0+=p;
					s+=(double)r;
				}
			}
			else
			{
				for (uint16_t i=0; i<l; i++)
				{
					const float *c1=(const float *)c0;

					for (uint16_t j=0; j<c; j++)
					{
						double d=(double)c1[j];

						s+=d*d;
					}
					c0+=p;
				}
			}
		}
	}
	return(sqrt(s));
}


double Matrix_Compute::Norme2D(void)
{
	const uint16_t l=lines,c=columns;
	const uint8_t *c0=(uint8_t *)Coeff;
	const ptrdiff_t p=pitch;
	double s=0.0;

#ifdef AVX512_BUILD_POSSIBLE
	if (AVX512_Enable)
	{
		const uint16_t n=(c+7)>>3;
		double r;

		for (int32_t i=0; i<l; i++)
		{
			VectorNormeD_AVX512((const double *)c0,&r,n);
			c0+=p;
			s+=r;
		}
	}
	else
#endif
	{
		if (AVX_Enable)
		{
			const uint16_t n=(c+3)>>2;
			double r;

			for (int32_t i=0; i<l; i++)
			{
				VectorNormeD_AVX((const double *)c0,&r,n);
				c0+=p;
				s+=r;
			}
		}
		else
		{
			if (SSE2_Enable)
			{
				const uint16_t n=(c+1)>>1;
				double r;

				for (int32_t i=0; i<l; i++)
				{
					VectorNormeD_SSE2((const double *)c0,&r,n);
					c0+=p;
					s+=r;
				}
			}
			else
			{
				for (uint16_t i=0; i<l; i++)
				{
					const double *c1=(const double *)c0;

					for (uint16_t j=0; j<c; j++)
					{
						double d=c1[j];

						s+=d*d;
					}
					c0+=p;
				}
			}
		}
	}
	return(sqrt(s));
}


bool Matrix_Compute::Norme1(double &result)
{
	if ((Coeff==nullptr) || (lines==0) || (columns==0)) return(false);

	switch(data_type)
	{
		case DATA_FLOAT : result=Norme1F(); break;
		case DATA_DOUBLE : result=Norme1D(); break;
		default : return(false);
	}

	return(true);
}


double Matrix_Compute::Norme1F(void)
{
	const uint16_t l=lines,c=columns;
	const uint8_t *c0=(uint8_t *)Coeff;
	const ptrdiff_t p=pitch;
	double s=0.0;

#ifdef AVX512_BUILD_POSSIBLE
	if (AVX512_Enable)
	{
		const uint16_t n=(c+15)>>4;
		float r;

		for (int32_t i=0; i<l; i++)
		{
			VectorNorme1F_AVX512((const float *)c0,&r,n);
			c0+=p;
			s+=(double)r;
		}
	}
	else
#endif
	{
		if (AVX_Enable)
		{
			const uint16_t n=(c+7)>>3;
			float r;

			for (int32_t i=0; i<l; i++)
			{
				VectorNorme1F_AVX((const float *)c0,&r,n);
				c0+=p;
				s+=(double)r;
			}
		}
		else
		{
			if (SSE2_Enable)
			{
				const uint16_t n=(c+3)>>2;
				float r;

				for (int32_t i=0; i<l; i++)
				{
					VectorNorme1F_SSE2((const float *)c0,&r,n);
					c0+=p;
					s+=(double)r;
				}
			}
			else
			{
				for (uint16_t i=0; i<l; i++)
				{
					const float *c1=(const float *)c0;

					for (uint16_t j=0; j<c; j++)
						s+=fabs(c1[j]);
					c0+=p;
				}
			}
		}
	}
	return(s);
}


double Matrix_Compute::Norme1D(void)
{
	const uint16_t l=lines,c=columns;
	const uint8_t *c0=(uint8_t *)Coeff;
	const ptrdiff_t p=pitch;
	double s=0.0;

#ifdef AVX512_BUILD_POSSIBLE
	if (AVX512_Enable)
	{
		const uint16_t n=(c+7)>>3;
		double r;

		for (int32_t i=0; i<l; i++)
		{
			VectorNorme1D_AVX512((const double *)c0,&r,n);
			c0+=p;
			s+=r;
		}
	}
	else
#endif
	{
		if (AVX_Enable)
		{
			const uint16_t n=(c+3)>>2;
			double r;

			for (int32_t i=0; i<l; i++)
			{
				VectorNorme1D_AVX((const double *)c0,&r,n);
				c0+=p;
				s+=r;
			}
		}
		else
		{
			if (SSE2_Enable)
			{
				const uint16_t n=(c+1)>>1;
				double r;

				for (int32_t i=0; i<l; i++)
				{
					VectorNorme1D_SSE2((const double *)c0,&r,n);
					c0+=p;
					s+=r;
				}
			}
			else
			{
				for (uint16_t i=0; i<l; i++)
				{
					const double *c1=(const double *)c0;

					for (uint16_t j=0; j<c; j++)
						s+=fabs(c1[j]);
					c0+=p;
				}
			}
		}
	}
	return(s);
}


bool Matrix_Compute::Distance2(const Matrix &ma,double &result)
{
	if ((Coeff==nullptr) || (lines==0) || (columns==0)) return(false);
	if (!ma.AllocCheck()) return(false);

	if ((columns!=ma.GetColumns()) || (lines!=ma.GetLines()) || (ma.GetDataType()!=data_type)) return(false);

	switch(data_type)
	{
		case DATA_FLOAT : result=Distance2F(ma); break;
		case DATA_DOUBLE : result=Distance2D(ma); break;
		default : return(false);
	}

	return(true);
}


double Matrix_Compute::Distance2F(const Matrix &ma)
{
	const uint16_t l=lines,c=columns;
	const uint8_t *a0=(uint8_t *)ma.GetPtrMatrix();
	const uint8_t *c0=(uint8_t *)Coeff;
	const ptrdiff_t p=pitch,pa=ma.GetPitch();
	double s=0.0;

#ifdef AVX512_BUILD_POSSIBLE
	if (AVX512_Enable)
	{
		const uint16_t n=(c+15)>>4;
		float r;

		for (int32_t i=0; i<l; i++)
		{
			VectorDistF_AVX512((const float *)c0,(const float *)a0,&r,n);
			a0+=pa;
			c0+=p;
			s+=(double)r;
		}
	}
	else
#endif
	{
		if (AVX_Enable)
		{
			const uint16_t n=(c+7)>>3;
			float r;

			for (int32_t i=0; i<l; i++)
			{
				VectorDistF_AVX((const float *)c0,(const float *)a0,&r,n);
				a0+=pa;
				c0+=p;
				s+=(double)r;
			}
		}
		else
		{
			if (SSE2_Enable)
			{
				const uint16_t n=(c+3)>>2;
				float r;

				for (int32_t i=0; i<l; i++)
				{
					VectorDistF_SSE2((const float *)c0,(const float *)a0,&r,n);
					a0+=pa;
					c0+=p;
					s+=(double)r;
				}
			}
			else
			{
				for (uint16_t i=0; i<l; i++)
				{
					const float *c1=(const float *)c0;
					const float *a1=(const float *)a0;

					for (uint16_t j=0; j<c; j++)
					{
						const double d=(double)(c1[j]-a1[j]);

						s+=d*d;
					}
					a0+=pa;
					c0+=p;
				}
			}
		}
	}
	return(sqrt(s));
}


double Matrix_Compute::Distance2D(const Matrix &ma)
{
	const uint16_t l=lines,c=columns;
	const uint8_t *a0=(uint8_t *)ma.GetPtrMatrix();
	const uint8_t *c0=(uint8_t *)Coeff;
	const ptrdiff_t p=pitch,pa=ma.GetPitch();
	double s=0.0;

#ifdef AVX512_BUILD_POSSIBLE
	if (AVX512_Enable)
	{
		const uint16_t n=(c+7)>>3;
		double r;

		for (int32_t i=0; i<l; i++)
		{
			VectorDistD_AVX512((const double *)c0,(const double *)a0,&r,n);
			a0+=pa;
			c0+=p;
			s+=r;
		}
	}
	else
#endif
	{
		if (AVX_Enable)
		{
			const uint16_t n=(c+3)>>2;
			double r;

			for (int32_t i=0; i<l; i++)
			{
				VectorDistD_AVX((const double *)c0,(const double *)a0,&r,n);
				a0+=pa;
				c0+=p;
				s+=r;
			}
		}
		else
		{
			if (SSE2_Enable)
			{
				const uint16_t n=(c+1)>>1;
				double r;

				for (int32_t i=0; i<l; i++)
				{
					VectorDistD_SSE2((const double *)c0,(const double *)a0,&r,n);
					a0+=pa;
					c0+=p;
					s+=r;
				}
			}
			else
			{
				for (uint16_t i=0; i<l; i++)
				{
					const double *c1=(const double *)c0;
					const double *a1=(const double *)a0;

					for (uint16_t j=0; j<c; j++)
					{
						const double d=c1[j]-a1[j];

						s+=d*d;
					}
					a0+=pa;
					c0+=p;
				}
			}
		}
	}
	return(sqrt(s));
}


bool Matrix_Compute::Distance1(const Matrix &ma,double &result)
{
	if ((Coeff==nullptr) || (lines==0) || (columns==0)) return(false);
	if (!ma.AllocCheck()) return(false);

	if ((columns!=ma.GetColumns()) || (lines!=ma.GetLines()) || (ma.GetDataType()!=data_type)) return(false);

	switch(data_type)
	{
		case DATA_FLOAT : result=Distance1F(ma); break;
		case DATA_DOUBLE : result=Distance1D(ma); break;
		default : return(false);
	}

	return(true);
}


double Matrix_Compute::Distance1F(const Matrix &ma)
{
	const uint16_t l=lines,c=columns;
	const uint8_t *a0=(uint8_t *)ma.GetPtrMatrix();
	const uint8_t *c0=(uint8_t *)Coeff;
	const ptrdiff_t p=pitch,pa=ma.GetPitch();
	double s=0.0;

#ifdef AVX512_BUILD_POSSIBLE
	if (AVX512_Enable)
	{
		const uint16_t n=(c+15)>>4;
		float r;

		for (int32_t i=0; i<l; i++)
		{
			VectorDist1F_AVX512((const float *)c0,(const float *)a0,&r,n);
			a0+=pa;
			c0+=p;
			s+=(double)r;
		}
	}
	else
#endif
	{
		if (AVX_Enable)
		{
			const uint16_t n=(c+7)>>3;
			float r;

			for (int32_t i=0; i<l; i++)
			{
				VectorDist1F_AVX((const float *)c0,(const float *)a0,&r,n);
				a0+=pa;
				c0+=p;
				s+=(double)r;
			}
		}
		else
		{
			if (SSE2_Enable)
			{
				const uint16_t n=(c+3)>>2;
				float r;

				for (int32_t i=0; i<l; i++)
				{
					VectorDist1F_SSE2((const float *)c0,(const float *)a0,&r,n);
					a0+=pa;
					c0+=p;
					s+=(double)r;
				}
			}
			else
			{
				for (uint16_t i=0; i<l; i++)
				{
					const float *c1=(const float *)c0;
					const float *a1=(const float *)a0;

					for (uint16_t j=0; j<c; j++)
						s+=fabs(c1[j]-a1[j]);
					a0+=pa;
					c0+=p;
				}
			}
		}
	}
	return(s);
}


double Matrix_Compute::Distance1D(const Matrix &ma)
{
	const uint16_t l=lines,c=columns;
	const uint8_t *a0=(uint8_t *)ma.GetPtrMatrix();
	const uint8_t *c0=(uint8_t *)Coeff;
	const ptrdiff_t p=pitch,pa=ma.GetPitch();
	double s=0.0;

#ifdef AVX512_BUILD_POSSIBLE
	if (AVX512_Enable)
	{
		const uint16_t n=(c+7)>>3;
		double r;

		for (int32_t i=0; i<l; i++)
		{
			VectorDist1D_AVX512((const double *)c0,(const double *)a0,&r,n);
			a0+=pa;
			c0+=p;
			s+=r;
		}
	}
	else
#endif
	{
		if (AVX_Enable)
		{
			const uint16_t n=(c+3)>>2;
			double r;

			for (int32_t i=0; i<l; i++)
			{
				VectorDist1D_AVX((const double *)c0,(const double *)a0,&r,n);
				a0+=pa;
				c0+=p;
				s+=r;
			}
		}
		else
		{
			if (SSE2_Enable)
			{
				const uint16_t n=(c+1)>>1;
				double r;

				for (int32_t i=0; i<l; i++)
				{
					VectorDist1D_SSE2((const double *)c0,(const double *)a0,&r,n);
					a0+=pa;
					c0+=p;
					s+=r;
				}
			}
			else
			{
				for (uint16_t i=0; i<l; i++)
				{
					const double *c1=(const double *)c0;
					const double *a1=(const double *)a0;

					for (uint16_t j=0; j<c; j++)
						s+=fabs(c1[j]-a1[j]);
					a0+=pa;
					c0+=p;
				}
			}
		}
	}
	return(s);
}