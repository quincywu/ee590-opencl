
struct s1 { 
	uint2 ui2;
	float4 fl4	;
	char8 ch8;
}; 

struct point { 
	float2 location;
	int category;
};

struct ref_point{
	struct point p;
	float dist;
	int order;
};

__kernel void myEx2akernel(float4 fl4, __global struct s1* p_str1) 
{
	int x = get_global_id(0);
	int y = get_global_id(1);


	printf("Hello OpenCL from work-item x=%d y=%d\n", x, y);
	printf("fl4 = %.2v4hlf\n", fl4);
	printf("fl4.wzyx = %.2v4hlf\n", fl4.wzyx);

	printf("p_str1.ch8 elements = %v8hhc\n", p_str1->ch8);

}

__kernel void hw2_4_3kernel(__global float4* fl4a, __global float4* pC)
{
	const int id = get_global_id(0);

	// sqrt
	pC[id] = sqrt(fl4a[id]);
	
	//printf("fl4a =%.2v4hlf, sqrt =%.2v4hlf\n", fl4a[id], pC[id]);

}

__kernel void knn_kernel (__global struct ref_point* ref_data,__global struct point* testing_data, const uint k)
{ 
	
}

__kernel void knn_kernel_1 (__global struct ref_point* ref_data,__global struct point* testing_data, __local struct point* aux, const uint k)
{ 
	
}