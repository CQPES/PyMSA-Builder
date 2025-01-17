#include <stdio.h>
#include <stdlib.h>
#include <math.h>

#include "basis.h"

int main(int argc, const char *argv[]) {
    int num_atoms = 5;
    
    double xyz[][3] = {
        { 0.00000000, -0.00000000,  1.07000000},  // H
        {-0.00000000, -1.00880567, -0.35666667},  // H
        {-0.87365134,  0.50440284, -0.35666667},  // H
        { 0.87365134,  0.50440284, -0.35666667},  // H
        {-0.00000000, -0.00000000, -0.00000000},  // C
    };

    #ifdef DEBUG

    for (int i = 0; i < num_atoms; i++) {
        printf("atom %d %10.5f %10.5f %10.5f\n", i, xyz[i][0], xyz[i][1], xyz[i][2]);
    }

    printf("\n");

    #endif

    int len_r = num_atoms * (num_atoms - 1) / 2;

    // distance vector
    double *r = (double *)malloc((size_t)len_r * sizeof(double));
    // morse-like
    double *x = (double *)malloc((size_t)len_r * sizeof(double));

    int k = 0;
    for (int i = 0; i < (num_atoms - 1); i++) {
        for (int j = i + 1; j < num_atoms; j++) {
            double dx = xyz[i][0] - xyz[j][0];
            double dy = xyz[i][1] - xyz[j][1];
            double dz = xyz[i][2] - xyz[j][2];
            r[k] = sqrt(dx * dx + dy * dy + dz * dz);
            x[k] = exp(-1.0 * r[k] / 1.0);
            k++;
        }
    }

    #ifdef DEBUG

    for (int i = 0; i < len_r; i++) {
        printf("r[%d] = %e\n", i, r[i]);
    }

    printf("\n");

    for (int i = 0; i < len_r; i++) {
        printf("x[%d] = %e\n", i, x[i]);
    }

    printf("\n");

    #endif

    // calculate pip
    double *p = (double *)malloc((size_t)(NP + 1) * sizeof(double));

    bemsav(x, p);

    #ifdef DEBUG

    for (int i = 0; i < (NP + 1); i++) {
        printf("p[%d] = %e\n", i, p[i]);
    }

    printf("\n");

    #endif

    // free
    free(r);
    free(x);
    free(p);

    return 0;
}
