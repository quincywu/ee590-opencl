
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
