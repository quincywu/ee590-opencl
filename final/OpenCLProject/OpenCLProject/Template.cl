
#define NUM_CATEGORY 2

struct s1 { 
	uint2 ui2;
	float4 fl4	;
	char8 ch8;
}; 

typedef struct  __attribute__ ((packed)) point_str { 
	float2 location;
	int category;
} point;

typedef struct  __attribute__ ((packed)) ref_point_str{
	point p;
	float dist;
} ref_point;

__kernel void myEx2akernel(float4 fl4, __global struct s1* p_str1) 
{
	int x = get_global_id(0);
	int y = get_global_id(1);


	printf("Hello OpenCL from work-item x=%d y=%d\n", x, y);
	printf("fl4 = %.2v4hlf\n", fl4);
	printf("fl4.wzyx = %.2v4hlf\n", fl4.wzyx);

	printf("p_str1.ch8 elements = %v8hhc\n", p_str1->ch8);

}

inline float my_dist(const float2 pointA, const float2 pointB) {
	return (float)(sqrt((pointA.x - pointB.x) * (pointA.x - pointB.x) + (pointA.y - pointB.y) * (pointA.y - pointB.y)));
}

float calc_distance(ref_point refpoints, const point pointB) {
	return my_dist(refpoints.p.location, pointB.location);
}

inline void swap(__global ref_point* a, __global ref_point* b) { 
	ref_point temp = *a;
	*a = *b;
	*b = temp;
}
/*inline void swap(__global ref_point* a, __global ref_point* b) { 
	float2 tempfl2;
	float tempfl;
	
	tempfl2 = (float2)a->p.location;
	tempfl = (float)a->dist;

	a->p.location = b->p.location;
	a->dist = b->dist;

	b-> p.location = tempfl2;
	b-> dist = tempfl;
}*/

void parallelBitonicSort_helper(__global ref_point* ref_data, const uint stage, const uint substage, const uint direction){ 
	const int threadId = get_global_id(0);
	uint sortIncreasing = direction; 
	
	uint distanceBetweenPairs = 1 << (stage - substage);
    uint blockWidth   = distanceBetweenPairs << 1;

	//left half
	uint leftId = (threadId % distanceBetweenPairs) + (threadId / distanceBetweenPairs) * blockWidth;

	//right half
    uint rightId = leftId + distanceBetweenPairs;


	uint sameDirectionBlockWidth = 1 << stage;

	if((threadId/sameDirectionBlockWidth) % 2 == 1)
        sortIncreasing = 1 - sortIncreasing;

	const int ref_id = get_global_id(0);
	
    if(ref_data[leftId].dist > ref_data[rightId].dist && sortIncreasing) {
		// swap
		swap(&ref_data[leftId], &ref_data[rightId]);
    } else if(ref_data[leftId].dist < ref_data[rightId].dist && !sortIncreasing) {
		swap(&ref_data[leftId], &ref_data[rightId]);
    }

}

void parallelBitonicSort (__global ref_point* ref_data) {
	//printf("2base address of ref_data1 = %d\n", ref_data);
	const int ref_id = get_global_id(0);
	int ref_size = sizeof(ref_data);
	uint stages = 0;// only need to calculate once
	for(unsigned int i = ref_size; i > 1; i >>= 1){
		// calculate how many helper function to call
		stages ++;
	}

	for(uint stage = 0; stage < stages; ++stage){ 
		for(uint substage = 0; substage < stage + 1; substage ++){
			//parallelBitonicSort_helper(ref_data, stage, substage);
		}
	}
	
}

uint majority(__global ref_point* ref_data, uint k, __local uint* count_array) {
	const int ref_id = get_global_id(0);
	
	if(ref_id < k)
		count_array[ ref_data[ref_id].p.category ] ++;

	int maj = 0;
	for (int i = 1; i < NUM_CATEGORY; ++i) {
		if (count_array[i] >= count_array[maj])
			maj = i;
	}

	return maj;
}

__kernel void knn_kernel (__global ref_point* ref_data,__global point* p_test_point_data, const uint k)
{ 
	const int ref_id = get_global_id(0);
	const int test_id = get_global_id(1);

	//printf("ref_id=%d, test_id = %d\n", ref_id, test_id);
	//printf("base address of p_test_point_data.location = %.4v2hlf\n", p_test_point_data->location);

	/*calc_dist, parallel*/
	ref_data[ref_id].dist = calc_distance(ref_data[ref_id], *p_test_point_data);	
	barrier(CLK_LOCAL_MEM_FENCE); // came from barrier() got renamed work_group_barrier // CLK_GLOBAL_MEM_FENCE   CLK_LOCAL_MEM_FENCE

	printf("this is i=%d, ref_data[i].dist=%f, ref_data[i].p.location=%.4v2hlf\n", ref_id, ref_data[ref_id].dist, ref_data[ref_id].p.location);
	barrier(CLK_GLOBAL_MEM_FENCE);
	printf("finished\n");
	
	//sort, parallel
	//printf("base address of ref_data1 = %d\n", ref_data);
	//printf("base address of ref_data2 = %d\n", ref_data[1]);
	parallelBitonicSort(ref_data);
	barrier(CLK_GLOBAL_MEM_FENCE);

	int ref_size = sizeof(ref_data);
	//printf("print ref size here = %d\n", ref_size);
	//for(int i = 0; i < ref_size; ++i){ 
		printf("this is i=%d, ref_data[i].dist=%f, category=%d, ref_data[i].p.location=%.4v2hlf\n", ref_id, ref_data[ref_id].dist, ref_data[ref_id].p.category, ref_data[ref_id].p.location);
	//}
	printf("k = %d\n", k);
	//find majority
	local int count_array[NUM_CATEGORY];
	count_array[ref_id] = 0;
	barrier(CLK_GLOBAL_MEM_FENCE);
	p_test_point_data->category = majority(ref_data, k, count_array);
	barrier(CLK_GLOBAL_MEM_FENCE);
	if(ref_id==7)
	printf("reached = %d\n", p_test_point_data->category);

}

__kernel void knn_dist(__global ref_point* ref_data,__global point* p_test_point_data){ 
	const int ref_id = get_global_id(0);
	const int test_id = get_global_id(1);

	/*calc_dist, parallel*/
	ref_data[ref_id].dist = calc_distance(ref_data[ref_id], *p_test_point_data);	

}

__kernel void knn_sort(__global ref_point* ref_data, const uint stage, const uint substage, const uint direction){ 
	const int ref_id = get_global_id(0);

	parallelBitonicSort_helper(ref_data, stage, substage, direction);
}

__kernel void knn_majority(__global ref_point* ref_data, const uint k, __global uint* aux){ 
	const int ref_id = get_global_id(0);

	if(ref_id < k){
		aux[ ref_data[ref_id].p.category ] ++;
	}

}

__kernel void knn_majority_helper(__global uint* aux, uint max_cat){ 
	const int id = get_global_id(0);

	if(aux[id] > aux[max_cat] ){ 
		max_cat = id;
	}

}

__kernel void knn_kernel_1 (__global struct ref_point* ref_data,__global struct point* testing_data, __local struct point* aux, const uint k)
{ 
	
}