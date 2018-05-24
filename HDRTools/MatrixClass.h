#ifndef _MATRIX_CLASS_H
#define _MATRIX_CLASS_H

#include <stdlib.h>
#include <stdint.h>
#include <math.h>

typedef enum COEFF_DATA_TYPE_ {DATA_NONE,DATA_DOUBLE,DATA_FLOAT,DATA_UINT64,DATA_INT64,
	DATA_UINT32,DATA_INT32,DATA_UINT16,DATA_INT16,DATA_UINT8,DATA_INT8} COEFF_DATA_TYPE;


void SetCPUMatrixClass(bool SSE2,bool AVX,bool AVX2);


class Vector
{
public :
	Vector(void);
	Vector(const uint16_t l,const COEFF_DATA_TYPE data);
	Vector(const Vector &x);
	virtual ~Vector(void);

	bool AllocCheck(void) const {return(Coeff!=NULL);}
	bool Create(void);
	bool Create(const uint16_t l,const COEFF_DATA_TYPE data);
	bool Create(const Vector &x);
	bool CopyStrict(const Vector &x);
	bool CopyRaw(const void *ptr);
	bool CopyRaw(const void *ptr,uint16_t lgth);
	bool ExportRaw(void *ptr);
	bool ExportRaw(void *ptr,uint16_t lgth);
	void Destroy(void);
	bool FillD(const double data);
	bool FillF(const float data);
	bool FillZero(void);
	COEFF_DATA_TYPE GetDataType(void) const {return(data_type);}
	bool SetInfo(const uint16_t l,const COEFF_DATA_TYPE data);
	void GetInfo(uint16_t &l,COEFF_DATA_TYPE &data) const;
	uint16_t GetLength(void) const {return(length);}
	void* GetPtrVector(void) const {return(Coeff);}
	size_t GetDataSize(void) const {return(size);}
	double GetD(const uint16_t i) const {return(((double *)Coeff)[i]);}
	float GetF(const uint16_t i) const {return(((float *)Coeff)[i]);}
	void SetD(const uint16_t i,const double d) {((double *)Coeff)[i]=d;}
	void SetF(const uint16_t i,const float d) {((float *)Coeff)[i]=d;}
	bool GetSafeD(const uint16_t i,double &d) const ;
	bool SetSafeD(const uint16_t i,const double d);
	bool GetSafeF(const uint16_t i,float &d) const ;
	bool SetSafeF(const uint16_t i,const float d);

protected :
	void *Coeff;
	uint16_t length;
	size_t size;
	COEFF_DATA_TYPE data_type;

private :
	Vector& operator = (const Vector &other);
	bool operator == (const Vector &other) const;
	bool operator != (const Vector &other) const;
};

class Matrix;

class Vector_Compute : public Vector
{
protected :
	bool SSE2_Enable,AVX_Enable,AVX2_Enable;

public :
	Vector_Compute(void);
	Vector_Compute(const uint16_t l,const COEFF_DATA_TYPE data);
	Vector_Compute(const Vector_Compute &x);
	virtual ~Vector_Compute(void);

	void SetSSE2(bool val) {SSE2_Enable=val;}
	void SetAVX(bool val) {AVX_Enable=val;}
	void SetAVX2(bool val) {AVX2_Enable=val;}

	bool Mult(const double coef,const Vector &x);
	bool Mult(const double coef);
	bool Add(const double coef,const Vector &x);
	bool Add(const double coef);
	bool Sub(const double coef,const Vector &x);
	bool Sub(const double coef);
	bool Add_X(const Vector &x,const Vector &y);
	bool Add_X(const Vector &x);
	bool Sub_X(const Vector &x,const Vector &y);
	bool Sub_X(const Vector &x);
	bool InvSub_X(const Vector &x);
	bool Mult_X(const Vector &x,const Vector &y);
	bool Mult_X(const Vector &x);

	bool Product_AX(const Matrix &ma,const Vector &x);
	bool Product_AX(const Matrix &ma);
	bool Product_tAX(const Matrix &ma,const Vector &x);
	bool Product_tAX(const Matrix &ma);

	bool Norme2(double &result);
	bool Distance2(const Vector &x,double &result);
	bool Norme1(double &result);
	bool Distance1(const Vector &x,double &result);

protected :
	// Float
	void MultF(const double coef,const Vector &x);
	void MultF(const double coef);
	void AddF(const double coef,const Vector &x);
	void AddF(const double coef);
	void SubF(const double coef,const Vector &x);
	void SubF(const double coef);
	void AddF_X(const Vector &x,const Vector &y);
	void AddF_X(const Vector &x);
	void SubF_X(const Vector &x,const Vector &y);
	void SubF_X(const Vector &x);
	void InvSubF_X(const Vector &x);
	void MultF_X(const Vector &x,const Vector &y);
	void MultF_X(const Vector &x);

	void ProductF_AX(const Matrix &ma,const Vector &x);
	void ProductF_tAX(const Matrix &ma,const Vector &x);

	double Norme2F(void);
	double Distance2F(const Vector &x);
	double Norme1F(void);
	double Distance1F(const Vector &x);

	// Double
	void MultD(const double coef,const Vector &x);
	void MultD(const double coef);
	void AddD(const double coef,const Vector &x);
	void AddD(const double coef);
	void SubD(const double coef,const Vector &x);
	void SubD(const double coef);
	void AddD_X(const Vector &x,const Vector &y);
	void AddD_X(const Vector &x);
	void SubD_X(const Vector &x,const Vector &y);
	void SubD_X(const Vector &x);
	void InvSubD_X(const Vector &x);
	void MultD_X(const Vector &x,const Vector &y);
	void MultD_X(const Vector &x);

	void ProductD_AX(const Matrix &ma,const Vector &x);
	void ProductD_tAX(const Matrix &ma,const Vector &x);

	double Norme2D(void);
	double Distance2D(const Vector &x);
	double Norme1D(void);
	double Distance1D(const Vector &x);

private :
	Vector_Compute& operator = (const Vector_Compute &other);
	bool operator == (const Vector_Compute &other) const;
	bool operator != (const Vector_Compute &other) const;
};


class Matrix
{
public :
	Matrix(void);
	Matrix(const uint16_t l,const uint16_t c,const COEFF_DATA_TYPE data);
	Matrix(const Matrix &m);
	virtual ~Matrix(void);

	bool AllocCheck(void) const {return(Coeff!=NULL);}
	bool Create(void);
	bool Create(const uint16_t l,const uint16_t c,const COEFF_DATA_TYPE data);
	bool Create(const Matrix &m);
	virtual bool CopyStrict(const Matrix &m);
	bool CopyRaw(const void *ptr);
	bool CopyRaw(const void *ptr,ptrdiff_t ptr_pitch);
	bool CopyRaw(const void *ptr,ptrdiff_t ptr_pitch,uint16_t ln,uint16_t co);
	bool ExportRaw(void *ptr);
	bool ExportRaw(void *ptr,ptrdiff_t ptr_pitch);
	bool ExportRaw(void *ptr,ptrdiff_t ptr_pitch,uint16_t ln,uint16_t co);
	void Destroy(void);
	bool FillD(const double data);
	bool FillF(const float data);
	bool FillZero(void);
	COEFF_DATA_TYPE GetDataType(void) const {return(data_type);}
	bool SetInfo(const uint16_t l,const uint16_t c,const COEFF_DATA_TYPE data);
	void GetInfo(uint16_t &l,uint16_t &c,COEFF_DATA_TYPE &data) const;
	uint16_t GetLines(void) const {return(lines);}
	uint16_t GetColumns(void) const {return(columns);}
	void* GetPtrMatrix(void) const {return(Coeff);}
	void* GetPtrMatrixLine(const uint16_t i) const {return((void *)((uint8_t *)Coeff+i*pitch));}
	ptrdiff_t GetPitch(void) const {return(pitch);}
	size_t GetDataSize(void) const {return(size);}
	double GetD(const uint16_t i,const uint16_t j) const {return(((double *)((uint8_t *)Coeff+(ptrdiff_t)i*pitch))[j]);}
	float GetF(const uint16_t i,const uint16_t j) const {return(((float *)((uint8_t *)Coeff+(ptrdiff_t)i*pitch))[j]);}
	void SetD(const uint16_t i,const uint16_t j,const double d) {((double *)((uint8_t *)Coeff+(ptrdiff_t)i*pitch))[j]=d;}
	void SetF(const uint16_t i,const uint16_t j,const float d) {((float *)((uint8_t *)Coeff+(ptrdiff_t)i*pitch))[j]=d;}
	bool GetSafeD(const uint16_t i,const uint16_t j,double &d) const ;
	bool SetSafeD(const uint16_t i,const uint16_t j,const double d);
	bool GetSafeF(const uint16_t i,const uint16_t j,float &d) const ;
	bool SetSafeF(const uint16_t i,const uint16_t j,const float d);

protected :
	void *Coeff;
	uint16_t columns,lines;
	size_t size;
	ptrdiff_t pitch;
	COEFF_DATA_TYPE data_type;

	Matrix& operator=(const Matrix&){return(*this);}

private :
	bool operator == (const Matrix &other) const;
	bool operator != (const Matrix &other) const;
};


class Matrix_Compute : public Matrix
{
protected :
	double zero_value;
	bool SSE2_Enable,AVX_Enable,AVX2_Enable;

public :
	Matrix_Compute(void);
	Matrix_Compute(const uint16_t l,const uint16_t c,const COEFF_DATA_TYPE data);
	Matrix_Compute(const Matrix_Compute &m);
	virtual ~Matrix_Compute(void);

	void SetSSE2(bool val) {SSE2_Enable=val;}
	void SetAVX(bool val) {AVX_Enable=val;}
	void SetAVX2(bool val) {AVX2_Enable=val;}

	bool CreateTranspose(const Matrix &m);
	virtual bool CopyStrict(const Matrix_Compute &m);
	void SetZeroValue(const double z) {zero_value=fabs(z);}
	double GetZeroValue(void) const {return(zero_value);}

	bool Transpose(void);
	bool Transpose(const Matrix &ma);

	bool Mult(const double coef,const Matrix &ma);
	bool Mult(const double coef);
	bool Add(const double coef,const Matrix &ma);
	bool Add(const double coef);
	bool Sub(const double coef,const Matrix &ma);
	bool Sub(const double coef);
	bool Add_A(const Matrix &ma,const Matrix &mb);
	bool Add_A(const Matrix &ma);
	bool Sub_A(const Matrix &ma,const Matrix &mb);
	bool Sub_A(const Matrix &ma);
	bool InvSub_A(const Matrix &ma);
	bool Mult_A(const Matrix &ma,const Matrix &mb);
	bool Mult_A(const Matrix &ma);

	bool Product_AB(const Matrix &ma,const Matrix &mb);
	bool Product_AtB(const Matrix &ma,const Matrix &mb);
	bool Product_tAA(const Matrix &ma);
	bool Product_tAA(void);

	bool Inverse(const Matrix &ma);
	bool Inverse(void);
	int8_t InverseSafe(const Matrix_Compute &ma);
	int8_t InverseSafe(void);

	bool Norme2(double &result);
	bool Distance2(const Matrix &ma,double &result);
	bool Norme1(double &result);
	bool Distance1(const Matrix &ma,double &result);

protected :
	// Float
	void TransposeF(const Matrix &ma);

	void MultF(const double coef,const Matrix &ma);
	void MultF(const double coef);
	void AddF(const double coef,const Matrix &ma);
	void AddF(const double coef);
	void SubF(const double coef,const Matrix &ma);
	void SubF(const double coef);
	void AddF_A(const Matrix &ma,const Matrix &mb);
	void AddF_A(const Matrix &ma);
	void SubF_A(const Matrix &ma,const Matrix &mb);
	void SubF_A(const Matrix &ma);
	void InvSubF_A(const Matrix &ma);
	void MultF_A(const Matrix &ma,const Matrix &mb);
	void MultF_A(const Matrix &ma);

	void ProductF_AB(const Matrix &ma,const Matrix &mb);
	void ProductF_AtB(const Matrix &ma,const Matrix &mb);

	bool InverseF(const Matrix &ma);
	int8_t InverseSafeF(const Matrix_Compute &ma);

	double Norme2F(void);
	double Distance2F(const Matrix &ma);
	double Norme1F(void);
	double Distance1F(const Matrix &ma);

	// Double
	void MultD(const double coef,const Matrix &ma);
	void MultD(const double coef);
	void AddD(const double coef,const Matrix &ma);
	void AddD(const double coef);
	void SubD(const double coef,const Matrix &ma);
	void SubD(const double coef);
	void AddD_A(const Matrix &ma,const Matrix &mb);
	void AddD_A(const Matrix &ma);
	void SubD_A(const Matrix &ma,const Matrix &mb);
	void SubD_A(const Matrix &ma);
	void InvSubD_A(const Matrix &ma);
	void MultD_A(const Matrix &ma,const Matrix &mb);
	void MultD_A(const Matrix &ma);

	void TransposeD(const Matrix &ma);

	void ProductD_AB(const Matrix &ma,const Matrix &mb);
	void ProductD_AtB(const Matrix &ma,const Matrix &mb);

	bool InverseD(const Matrix &ma);
	int8_t InverseSafeD(const Matrix_Compute &ma);

	double Norme2D(void);
	double Distance2D(const Matrix &ma);
	double Norme1D(void);
	double Distance1D(const Matrix &ma);

	// U64
	void TransposeU64(const Matrix &ma);

	// I64
	void TransposeI64(const Matrix &ma);

	// U32
	void TransposeU32(const Matrix &ma);

	// I32
	void TransposeI32(const Matrix &ma);

	// U16
	void TransposeU16(const Matrix &ma);

	// I16
	void TransposeI16(const Matrix &ma);

	// U8
	void TransposeU8(const Matrix &ma);

	// I8
	void TransposeI8(const Matrix &ma);

	Matrix_Compute& operator=(const Matrix_Compute&){return(*this);}

private :
	bool operator == (const Matrix_Compute &other) const;
	bool operator != (const Matrix_Compute &other) const;
};

#endif