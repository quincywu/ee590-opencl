
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
	//int order;
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

__kernel void hw2_4_3kernel(__global float4* fl4a, __global float4* pC)
{
	const int id = get_global_id(0);

	// sqrt
	pC[id] = sqrt(fl4a[id]);
	
	//printf("fl4a =%.2v4hlf, sqrt =%.2v4hlf\n", fl4a[id], pC[id]);

}

float my_dist(const float2 pointA, const float2 pointB) {
	return (float)(sqrt((pointA.x - pointB.x) * (pointA.x - pointB.x) + (pointA.y - pointB.y) * (pointA.y - pointB.y)));
}

float calc_distance(ref_point refpoints, const point pointB) {
	
	//for (int i = 0; i < ref_size; ++i) {
	return my_dist(refpoints.p.location, pointB.location);
	//printf("This is dist=%f, a=%.4v2hlf, b=%.4v2hlf\n", refpoints->dist, refpoints->p.location, pointB.location);
	//}
	
	//return;
}

void parallelBitonicSort_helper(__global ref_point* ref_data, const uint stage, const uint substage){ 
	const int threadId = get_global_id(0);
	uint sortIncreasing = 0; 
	
	uint distanceBetweenPairs = 1 << (stage - substage);
    uint blockWidth   = distanceBetweenPairs << 1;

	//left half
	uint leftId = (threadId % distanceBetweenPairs) + (threadId / distanceBetweenPairs) * blockWidth;

	//right half
    uint rightId = leftId + distanceBetweenPairs;

	//ref_point leftElement = ref_data[leftId];
    //ref_point rightElement = ref_data[rightId];

	uint sameDirectionBlockWidth = 1 << stage;

	if((threadId/sameDirectionBlockWidth) % 2 == 1)
        sortIncreasing = 1 - sortIncreasing;

    //uint greater;
    //uint lesser;

    if(ref_data[leftId].dist > ref_data[rightId].dist && sortIncreasing) {
        // greater = leftElement;
        // lesser  = rightElement;
		// swap
		ref_point temp = ref_data[leftId];
		ref_data[leftId] = ref_data[rightId];
		ref_data[rightId] = temp;
    } else if(ref_data[leftId].dist < ref_data[rightId].dist && !sortIncreasing) {
        // greater = rightElement;
        // lesser  = leftElement;
		ref_point temp = ref_data[leftId];
		ref_data[leftId] = ref_data[rightId];
		ref_data[rightId] = temp;
    }
    /*
    if(sortIncreasing) {
        data[leftId]  = lesser;
        data[rightId] = greater;
    } else {
        data[leftId]  = greater;
        data[rightId] = lesser;
    }*/

}

void parallelBitonicSort (__global ref_point* ref_data) {
	int ref_size = sizeof(ref_data);
	//printf("print ref size = %d\n", ref_size);
	uint stages = 0;
	for(unsigned int i = ref_size; i > 1; i >>= 1){
		// calculate how many helper function to call
		stages ++;
	}

	for(uint stage = 0; stage < stages; ++stage){ 
		
		for(uint substage = 0; substage < stage + 1; substage ++){
			parallelBitonicSort_helper(ref_data, stage, substage);
		}
	}

}

__kernel void knn_kernel (__global ref_point* ref_data,__global point* test_point_data, const uint k)
{ 
	const int ref_id = get_global_id(0);
	const int test_id = get_global_id(1);

	printf("ref_id=%d, test_id = %d\n", ref_id, test_id);
	printf("base address of test_point_data = %d\n", test_point_data);

	/*calc_dist, parallel*/
	ref_data[ref_id].dist = calc_distance(ref_data[ref_id], test_point_data[test_id]);	
	barrier(CLK_LOCAL_MEM_FENCE); // came from barrier() got renamed work_group_barrier // CLK_GLOBAL_MEM_FENCE   CLK_LOCAL_MEM_FENCE

	printf("this is i=%d, ref_data[i].dist=%f, ref_data[i].p.location=%.4v2hlf\n", ref_id, ref_data[ref_id].dist, ref_data[ref_id].p.location);
	barrier(CLK_LOCAL_MEM_FENCE);
	printf("finished\n");

	//sort, parallel
	parallelBitonicSort(ref_data);
	barrier(CLK_LOCAL_MEM_FENCE);

	int ref_size = sizeof(ref_data);
	//printf("print ref size here = %d\n", ref_size);
	//for(int i = 0; i < ref_size; ++i){ 
		printf("this is i=%d, ref_data[i].dist=%f, ref_data[i].p.location=%.4v2hlf\n", ref_id, ref_data[ref_id].dist, ref_data[ref_id].p.location);
	//}

	//find majority
}

__kernel void knn_kernel_1 (__global struct ref_point* ref_data,__global struct point* testing_data, __local struct point* aux, const uint k)
{ 
	
}