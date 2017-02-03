#define SECTION_SIZE  8
__kernel void reduce_v1(__global float* g_indata, __global float* g_outdata) {
__local float sdata[SECTION_SIZE];
int gid = get_global_id(0);
int lid = get_local_id(0);
// each thread loads one element from global to local mem
sdata[lid] = g_indata[gid];
work_group_barrier(CLK_LOCAL_MEM_FENCE);

//reduce in shared local mem
for(uint s=1; s< SECTION_SIZE; s*=2) { 
    if(lid % (2*s) == 0) {
        sdata[lid] += sdata[lid+s];
    }
	work_group_barrier(CLK_LOCAL_MEM_FENCE);

}

//write result for section to global mem
if(lid ==0)
g_outdata[get_group_id(0)]= sdata[0]; 

}

#define SECTION_SIZE  8
__kernel void reduce_v2(__global float* g_indata, __global float* g_outdata) {
__local float sdata[SECTION_SIZE];
int gid = get_global_id(0);
int lid = get_local_id(0);
// each thread loads one element from global to local mem
sdata[lid] = g_indata[gid];
work_group_barrier(CLK_LOCAL_MEM_FENCE);

//reduce in shared local mem
for(uint s=1; s< SECTION_SIZE/2 - 1; s*=2) {
   int index = 2*s*lid;
      if(index < SECTION_SIZE) {
         sdata[index] += sdata[index+s];
      }
   work_group_barrier(CLK_LOCAL_MEM_FENCE);
}


//write result for section to global mem
if(lid ==0)
g_outdata[get_group_id(0)]= sdata[0]; 

}

#define SECTION_SIZE  8
__kernel void reduce_v3(__global float* g_indata, __global float* g_outdata) {
__local float sdata[SECTION_SIZE];
int gid = get_global_id(0);
int lid = get_local_id(0);
// each thread loads one element from global to local mem
sdata[lid] = g_indata[gid];
work_group_barrier(CLK_LOCAL_MEM_FENCE);

//reduce in shared local mem
for(uint s = get_local_size(0); s>=1; s/=2) { 
    if(lid <s) {
        sdata[lid] += sdata[lid+s];
    }
}



//write result for section to global mem
if(lid ==0)
g_outdata[get_group_id(0)]= sdata[0]; 

}

__kernel void inclusive_scan_v1(__global float* X, __global float* Y, int InputSize)
{ 
__local float XY[SECTION_SIZE];
int gid = get_global_id(0);
int lid = get_local_id(0);
if(gid < InputSize)
{ 
    XY[lid] = X[gid];
}
for(uint stride=1; stride <= lid; stride *=2)
{ 
    work_group_barrier(CLK_LOCAL_MEM_FENCE);
    XY[lid] += XY[lid - stride];
}
Y[gid] = XY[lid];
}

