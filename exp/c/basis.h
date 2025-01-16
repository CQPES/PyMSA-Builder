#ifndef BASIS_H_
#define BASIS_H_

#include <math.h>

#define NX 10
#define NM 261
#define NP 82

void evmono(double x[NX], double m[NM + 1]);
void evpoly(double m[NM + 1], double p[NP + 1]);
void bemsav(double x[NX], double p[NP + 1]); 

#endif /* BASIS_H_ */
