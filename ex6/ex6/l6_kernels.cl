__kernel void conv1D(__global float* y, __global float* data, int dataLen, __global float* h_filt, int filtLen) 
{
	int i = get_global_id(0); 
	for(int j = 0; j<filtLen; ++j) {
		(0 > (i-j)) ? (y[i]+=0) : (y[i] += data[i-j]*h_filt[j]); 
	}
}

__kernel void convolve_v1(__read_only image2d_t inImg, __write_only image2d_t outImg, int rows, int cols, __constant float* filter, int filterWidth, sampler_t sampler)
{ 
	int column = get_global_id(0);
	int row = get_global_id(1);

	int halfWidth = (int)(filterWidth/2);

	float4 sum = {0.0f, 0.0f, 0.0f, 0.0f};
	int filterIdx = 0;
	int2 coords;

	for(int i = -halfWidth; i<= halfWidth; i++) /* iterate thru filter rows */
	{ 
		coords.y = row + i;
		for(int j = -halfWidth; j<= halfWidth; j++) /* iterate thru filter cols */
		{ 
			coords.x = column+j;
			float4 pixel;
			pixel = read_imagef(inImg, sampler, coords);
			sum.x += pixel.x * filter[filterIdx]; /* filter indexed in row-major progression */
			sum.y += pixel.y * filter[filterIdx]; /* filter indexed in row-major progression */
			sum.z += pixel.z * filter[filterIdx++]; /* filter indexed in row-major progression */
		} 
	}

	/* copy data to output img */
	coords.x = column;
	coords.y = row;
	write_imagef(outImg, coords, sum);
}

__constant sampler_t sampler2 = CLK_NORMALIZED_COORDS_FALSE | CLK_FILTER_NEAREST | CLK_ADDRESS_CLAMP_TO_EDGE;

__kernel void sobel_edgedet_v1(__read_only image2d_t inImg, __write_only image2d_t outImg, int rows, int cols)
{ 
	int column = get_global_id(0);
	int row = get_global_id(1);

	int filterWidth = 3;
	//int sobelx[] = {-1,0,1,-2,0,2,-1,0,1};
	int sobelx[] = { 0,1,0,1,-2,1,0,1,0};
	int sobely[] = { 0,1,0,1,-2,1,0,1,0};
	//int sobely[] = {1,2,1,0,0,0,-1,-2,-1};

	int halfWidth = (int)(filterWidth/2);

	float4 sumx = {0.0f, 0.0f, 0.0f, 0.0f};
	float4 sumy = {0.0f, 0.0f, 0.0f, 0.0f};
	float4 px_grad = {0.0f, 0.0f, 0.0f, 0.0f};
	int filterIdx = 0;
	int2 coords;

	for(int i = -halfWidth; i<= halfWidth; i++) /* iterate thru filter rows */
	{ 
		coords.y = row + i;
		for(int j = -halfWidth; j<= halfWidth; j++) /* iterate thru filter cols */
		{ 
			coords.x = column+j;
			float4 pixel;
			pixel = read_imagef(inImg, sampler2, coords);
			sumx.x += pixel.x * sobelx[filterIdx]; /* filter indexed in row-major progression */
			sumy.x += pixel.x * sobely[filterIdx++]; /* filter indexed in row-major progression */
		} 
	}

	px_grad.x = sqrt(sumx.x * sumx.x + sumy.x * sumy.x );

	/* copy data to output img */
	coords.x = column;
	coords.y = row;
	write_imagef(outImg, coords, px_grad);
}