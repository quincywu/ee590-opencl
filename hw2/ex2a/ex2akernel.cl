
// TODO: Add OpenCL kernel code here.
struct s1 { 
	uint2 ui2;
	float4 fl4	;
	char8 ch8;
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

__kernel void hw2_1_1kernel(__global float4* fl4a, __global float4* fl4b, __global float* pC)
{
	const int id = get_global_id(0);

	printf("id=%d\n", id);
	printf("id=%d\n", get_global_id(1));

	pC[id] = fl4a[id].x * fl4b[id].x; 
	pC[id] += fl4a[id].y * fl4b[id].y; 
	pC[id] += fl4a[id].z * fl4b[id].z; 
	pC[id] += fl4a[id].w * fl4b[id].w; 


	printf("fl4a =%.2v4hlf, fl4b=%.2v4hlf, fl4a+fl4b =%.2v4hlf\n", fl4a[id], fl4b[id], fl4a[id].x * fl4b[id].x + fl4a[id].y * fl4b[id].y + fl4a[id].z * fl4b[id].z + fl4a[id].w * fl4b[id].w);
}

__kernel void hw2_1_2kernel(float4 fl4a, float4 fl4b)
{
	printf("fl4a =%.2v4hlf, fl4b=%.2v4hlf, fl4a+fl4b =%.2v4hlf\n", fl4a, fl4b, dot(fl4a, fl4b));
}
