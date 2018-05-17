#include <math.h>

double fact(double x)
{
	unsigned short a=(unsigned short)x;
	
	if ((a==0) || (a==1)) return(1.0);

	double b=1.0;

	for(unsigned short i=1; i<=a; i++)
		b*=i;

	return(b);
}


double ar(double n,double p)
{
	double a=ceil(n),b=ceil(p);

	if (p==0) return(1.0);
	if (p==n) return(fact(p));

	double i=a-b,s=1.0;

	while (a>i)
	{
		s*=a;
		a-=1.0;
	}
	return(ceil(a+0.5));
}


double cm(double n,double p)
{
	double a=ceil(n),b=ceil(p);

	if ((p==0) || (p==1) || (p==n)) return(1.0);

	double i=a-b,s;

	if (b>i) s=ar(a,i)/fact(i);
	else s=ar(a,b)/fact(b);

	return(ceil(s+0.5));
}

