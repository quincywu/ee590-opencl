__kernel void elementwiseMatrixPower (__global float* inputA, int Kpower, __global float* outputB)
{
	const int x = get_global_id(0);
	const int y = get_global_id(1);
	const int width = get_global_size(0);
	const int height = get_global_size(1);

	// B(i,j) = A(i,j)^K
	const int id = y * width + x;

	
	outputB[id] = pow(inputA[id], Kpower);

}

__kernel void progressiveArraySum (__global float* inputA, __global float* outputB)
{
	const int x = get_global_id(0);
	const int y = get_global_id(1);
	const int width = get_global_size(0);
	const int height = get_global_size(1);

	// B(i)=sum(j=1 to i) A(j) for i = 1 ... N
	const int id = y * width + x;

	float tmp = inputA[id];
	for(unsigned int i = id - 1; i > 0; --i){ 
		tmp += inputA[i];
	}
	outputB[id] = tmp;

	/*if(id == 0)
		outputB[id] = inputA[id];
	else 

		outputB[id] = outputB[id - 1] + inputA[id];
		*/
}