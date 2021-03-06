__kernel //__attribute__ ((dsdfsdfsad(16,1,1)))
void mmult_v1 (int N, __global float* A, __global float* B, __global float* C) { 
	int i, j, k;
    i = get_global_id(0);
    j = get_global_id(1);
    // C(i, j) = sum(over k) A(i,k) * B(k,j)
	float tem = 0.0f;
    for (k = 0; k < N; k++) { 
      tem += A[i*N+k] * B[k*N+j];
    }
	C[i*N+j] = tem;
}
