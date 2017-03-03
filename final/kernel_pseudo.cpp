struct point {
	float x;
	float y;
	int category; // or class
};

struct ref_point{
	point p;
	float distance;
	int order;
};

__kernel void KNN(__global ref_point* ref_data,__global point* testing_data, __local point* aux, int k)
{
	foreach testing_data point as t_point{ // t_point (x, y, class)
		// calculate distance with all ref_data point
		int counter = 1;
		foreach ref_data point as a_ref_point{ // ref_point (x, y, class, distance, order)
			a_ref_point.distance = distance(a_ref_point.point, t_point);
			a_ref_point.order = counter++;
			barrier(); 
			ParallelbitonicSort();
			int[] category = 0;
			if(a_ref_point.order <= k){
				category[a_ref_point.point.category]++;
			}
			t_point.category = 0;
			for(int i = 0; i < category.length(); ++i)
				if(category[i] > t_point.category)
					t_point.category = category[i];
		}
		
		// possibily add more weight to closer ref_point
		barrier();
	}
}

float distance(const float2 a, const float2 b) {
	return (float)sqrt( (pointA.x - pointB.x) * (pointA.x - pointB.x) + ((pointA.y - pointB.y) * (pointA.y - pointB.y)) );
}
__kernel void ParallelBitonic_C4(__global data_t * data,int inc0,int dir,__local data_t * aux)
{
  int t = get_global_id(0); // thread index
  int wgBits = 4*get_local_size(0) - 1; // bit mask to get index in local memory AUX (size is 4*WG)
  int inc,low,i;
  bool reverse;
  data_t x[4];

  // First iteration, global input, local output
  inc = inc0>>1;
  low = t & (inc - 1); // low order bits (below INC)
  i = ((t - low) << 2) + low; // insert 00 at position INC
  reverse = ((dir & i) == 0); // asc/desc order
  for (int k=0;k<4;k++) x[k] = data[i+k*inc];
  B4V(x,0);
  for (int k=0;k<4;k++) aux[(i+k*inc) & wgBits] = x[k];
  barrier(CLK_LOCAL_MEM_FENCE);

  // Internal iterations, local input and output
  for ( ;inc>1;inc>>=2)
  {
    low = t & (inc - 1); // low order bits (below INC)
    i = ((t - low) << 2) + low; // insert 00 at position INC
    reverse = ((dir & i) == 0); // asc/desc order
    for (int k=0;k<4;k++) x[k] = aux[(i+k*inc) & wgBits];
    B4V(x,0);
    barrier(CLK_LOCAL_MEM_FENCE);
    for (int k=0;k<4;k++) aux[(i+k*inc) & wgBits] = x[k];
    barrier(CLK_LOCAL_MEM_FENCE);
  }

  // Final iteration, local input, global output, INC=1
  i = t << 2;
  reverse = ((dir & i) == 0); // asc/desc order
  for (int k=0;k<4;k++) x[k] = aux[(i+k) & wgBits];
  B4V(x,0);
  for (int k=0;k<4;k++) data[i+k] = x[k];
}

							 