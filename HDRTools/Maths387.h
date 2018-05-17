
#ifndef _MATH387_H
#define _MATH387_H

extern "C" void Init_Maths387(void);
extern "C" double sin(double x);
extern "C" double cos(double x);
extern "C" double tan(double x);
extern "C" double exp(double x);
extern "C" double arctan(double x);
extern "C" double arctan2(double x,double y);
extern "C" double cotan(double x);
extern "C" double sinh(double x);
extern "C" double th(double x);
extern "C" double coth(double x);
extern "C" double argsh(double x);
extern "C" double argch(double x);
extern "C" double argth(double x);
extern "C" double argcoth(double x);
extern "C" double log(double x);
//extern "C" double logb(double a,double x);
extern "C" double deg(double x);
extern "C" double rad(double x);
extern "C" signed short sgn(double x);
extern "C" double pow(double x,double y);
extern "C" double root(double x,double y);
extern "C" double arcsin(double x);
extern "C" double arccos(double x);
extern "C" double arccotan(double x);
extern "C" double sec(double x);
extern "C" double cosec(double x);
extern "C" double sinc(double x);
extern "C" double lnp1(double x);
extern "C" double expm(double x);
extern "C" double ln(double x);
extern "C" double pow2(double x);
extern "C" double ln2(double x);
extern "C" double angle(double x,double y);

double fact(double x);
double ar(double n,double p);
double cm(double n,double p);

//Neural network functions, sigmoïd tansig/logsid and derivated
extern "C" double tansig(double x);
extern "C" double d_tansig(double x);
extern "C" double logsig(double x);
extern "C" double d_logsig(double x);

#endif
