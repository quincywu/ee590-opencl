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
			sum.x += pixel.x * filter[filterIdx++]; /* filter indexed in row-major progression */
		} 
	}

	/* copy data to output img */
	coords.x = column;
	coords.y = row;
	write_imagef(outImg, coords, sum);

}