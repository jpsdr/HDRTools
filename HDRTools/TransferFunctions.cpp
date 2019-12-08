/*
 *  TransferFunctions
 *
 *  OOTF,EOTF,OETF, etc... HDR and SDR core functions.
 *  Copyright (C) 2019 JPSDR
 *	
 *  HDRTools is free software; you can redistribute it and/or modify
 *  it under the terms of the GNU General Public License as published by
 *  the Free Software Foundation; either version 2, or (at your option)
 *  any later version.
 *   
 *  HDRTools is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
 *  GNU General Public License for more details.
 *   
 *  You should have received a copy of the GNU General Public License
 *  along with GNU Make; see the file COPYING.  If not, write to
 *  the Free Software Foundation, 675 Mass Ave, Cambridge, MA 02139, USA. 
 *
 */

#include <math.h>

static const double m1=0.1593017578125,im1=1.0/m1;
static const double m2=78.84375,im2=1.0/m2;
static const double c1=0.8359375;
static const double c2=18.8515625;
static const double c3=18.6875;

static const double alpha=1.09929682680944,alpham1=alpha-1.0,ialpha=1.0/alpha;
static const double beta=0.018053968510807;
static const double alpha2=267.84,beta2=0.0003024,ialpha2=1.0/alpha2;
static const double coeff_i12=1.0/12.0,coeff_i3=1.0/3.0,coeff_i45=1.0/0.45;
static const double coeff_i24=1.0/2.404,coeff_i59=1.0/59.5208;
static const double a=0.17883277;
static const double b=1.0-4.0*a,c=0.5-a*log(4.0*a),ia=1.0/a;
static double lm1=1.2-1.0,ilm1=(1.0/1.2)-1.0;

void Set_l_HLG(double Lw)
{
	lm1=(1.2+0.42*log10(Lw*0.001))-1.0;
	ilm1=(1.0/(1.2+0.42*log10(Lw*0.001)))-1.0;
}

double HLG_OETF(double x)
{
	if (x<=coeff_i12) return(sqrt(3.0*x));
	else return(a*log(12.0*x-b)+c);
}

double HLG_inv_OETF(double x)
{
	if (x<=0.5) return(x*x*coeff_i3);
	else return((exp((x-c)*ia)+b)*coeff_i12);
}

double HLG_OOTF(double x)
{
	return(x*pow(x,lm1));
}

double HLG_inv_OOTF(double x)
{
	return(x*pow(x,ilm1));
}

double inv_OETF(double x)
{
	if (x<(beta*4.5)) return(x*coeff_i45);
	else return(pow(((x+alpham1))*ialpha,coeff_i45));
}

double OETF(double x)
{
	if (x<beta) return(x*4.5);
	else return(alpha*pow(x,0.45)-alpham1);
}

double EOTF(double x)
{
	return(pow(x,2.404));
}

double PQ_OOTF(double x)
{
	if (x<=beta2) x*=alpha2;
	else x=pow(59.5208*x,0.45)*alpha-alpham1;
	return(pow(x,2.404)*0.01);
}

double PQ_OOTF_Inv(double x)
{
	x=pow(100.0*x,coeff_i24);
	if (x<=alpha2*beta2) return(x*ialpha2);
	else return(pow(((x+alpham1))*ialpha,coeff_i45)*coeff_i59);
}

double PQ_EOTF(double x)
{
	double x0;

	x0=pow(x,im2);
	if (x0<=c1) return(0.0);
	else return(pow((x0-c1)/(c2-c3*x0),im1));
}

double PQ_inv_EOTF(double x)
{
	return(pow((c1+c2*pow(x,m1))/(1+c3*pow(x,m1)),m2));
}
