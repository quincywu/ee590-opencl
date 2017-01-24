__kernel void elementwiseMatrixPower (__global float* inputA, int Kpower, __global float* outputB)
{
	const int x = get_global_id(0);
	const int y = get_global_id(1);
	const int width = get_global_size(0);
	const int height = get_global_size(1);

	// B(i,j) = A(i,j)^K
	const int id = y * width + x;

	float tmp = inputA[id];
	for(unsigned i = 1; i < Kpower; ++i){
		 tmp *= inputA[id];
	}
	outputB[id] = tmp;

}

__kernel void progressiveArraySum (__global float* inputA, __global float* outputB)
{
	const int x = get_global_id(0);

	// B(i)=sum(j=1 to i) A(j) for i = 1 ... N
	const int id = x;

	float tmp = 0.0f;
	for(unsigned int i = 0; i < id; ++i){ 
		tmp += inputA[i];
	}
	
	outputB[id] = tmp + inputA[id];
	
}