
typedef struct point_str { 
	float2 location;
	int category;
} point;

typedef struct ref_point_str{
	struct point p;
	float dist;
	//int order;
} ref_point;


float my_dist(const float2 pointA, const float2 pointB) {
	return (float)(sqrt((pointA.x - pointB.x) * (pointA.x - pointB.x) + (pointA.y - pointB.y) * (pointA.y - pointB.y)));
}

void calc_distance(struct ref_point refpoints, const struct point pointB) {
	
	//for (int i = 0; i < ref_size; ++i) {
	refpoints.dist = my_dist(refpoints.p.location, pointB.location);
	printf("This is dist=%f, a=%2v2hlf, b=%2v2hlf\n", refpoints.dist, refpoints.p.location, pointB.location);
	//}
	
	return;
}

__kernel void knn_kernel (__global struct ref_point* ref_data,__global struct point* test_point_data, const uint k)
{ 
	const int ref_id = get_global_id(0);
	const int test_id = get_global_id(1);

	/*calc_dist, parallel*/
	calc_distance(ref_data[ref_id], test_point_data[test_id]);

	printf("test_point_data_location = %2v2hlf\n", test_point_data[0].location);
	//ref_data[ref_id].dist = (float)sqrt((ref_data[ref_id].p.location.x - test_point_data[test_id].location.x) * (ref_data[ref_id].p.location.x - test_point_data[test_id].location.x) + (ref_data[ref_id].p.location.y - test_point_data[test_id].location.y) * (ref_data[ref_id].p.location.y - test_point_data[test_id].location.y) );
	//printf("This is dist=%f, a=%f, b=%f\n", ref_data[ref_id].dist, ref_data[ref_id].p.location.x, test_point_data[test_id].location.x);
	//printf("no_idea_at_all\n");
	// CLK_GLOBAL_MEM_FENCE   CLK_LOCAL_MEM_FENCE
	//barrier(CLK_LOCAL_MEM_FENCE); // came from barrier() got renamed work_group_barrier

	//sort, parallel

	//work_group_barrier(CLK_LOCAL_MEM_FENCE);

	//find majority
}