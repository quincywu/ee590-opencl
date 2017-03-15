
// TODO: Add OpenCL kernel code here.
// __attribute__ ((packed))
typedef struct __attribute__ ((packed)) s1 {
	uint2 ui2;
	float4 fl4;
	char8 ch8;
} struct_my;

__kernel void mykernel(float4 fl4, __global struct_my* p_str1)
{
	int x = get_global_id(0);
	int y = get_global_id(1);

	// Print device structure size & alignment info to console
	printf("Hello OpenCL from work-item x=%d y=%d\n",x,y);
	printf("sizeof(struct_my) = %d\n", sizeof(struct_my));
	printf("base address of p_str1 = %d\n", p_str1);
	printf("base address of &p_str1->ui2 = %d\n", &p_str1->ui2);
	printf("base address of &p_str1->fl4 = %d\n", &p_str1->fl4);
	printf("base address of &p_str1->ch8 = %d\n", &p_str1->ch8);

	printf("fl4 = %2.2v4hlf\n",fl4);
	printf("fl4.wzyx = %2.2v4hlf\n",fl4.wzyx);
	printf("p_str1.ch8 elements = %v8hhc\n",p_str1->ch8);
}