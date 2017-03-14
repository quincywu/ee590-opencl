
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
	//int order;
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
/*
float my_dist(const float2 pointA, const float2 pointB) {
	return (float)(sqrt((pointA.x - pointB.x) * (pointA.x - pointB.x) + (pointA.y - pointB.y) * (pointA.y - pointB.y)));
}

void calc_distance(struct ref_point refpoints, const struct point pointB) {
	
	//for (int i = 0; i < ref_size; ++i) {
	refpoints.dist = my_dist(refpoints.p.location, pointB.location);
	printf("This is dist=%f, a=%f, b=%f\n", refpoints.dist, refpoints.p.location, pointB.location);
	//}
	
	return;
}*/

__kernel void knn_kernel (__global struct ref_point* ref_data,__global struct point* test_point_data, const uint k)
{ 
	const int id = get_global_id(0);

	printf("id=%d\n", id);
	/*calc_dist, parallel
	calc_distance(ref_data[ref_id], test_point_data[test_id]);*/
	printf("print sizeof = %f\n", (float)sizeof(test_point_data));
	printf("print sizeof2 = %f\n", (float)sizeof(struct point*));
	printf("test_point_data_location = %2v2hlf\n", test_point_data[0].location);
	//ref_data[ref_id].dist = (float)sqrt((ref_data[ref_id].p.location.x - test_point_data[test_id].location.x) * (ref_data[ref_id].p.location.x - test_point_data[test_id].location.x) + (ref_data[ref_id].p.location.y - test_point_data[test_id].location.y) * (ref_data[ref_id].p.location.y - test_point_data[test_id].location.y) );
	//printf("This is dist=%f, a=%f, b=%f\n", ref_data[ref_id].dist, ref_data[ref_id].p.location.x, test_point_data[test_id].location.x);
	//printf("no_idea_at_all\n");
	// CLK_GLOBAL_MEM_FENCE   CLK_LOCAL_MEM_FENCE
	barrier(CLK_LOCAL_MEM_FENCE); // came from barrier() got renamed work_group_barrier

	//sort, parallel

	//work_group_barrier(CLK_LOCAL_MEM_FENCE);

	//find majority
}

__kernel void knn_kernel_1 (__global struct ref_point* ref_data,__global struct point* testing_data, __local struct point* aux, const uint k)
{ 
	
}