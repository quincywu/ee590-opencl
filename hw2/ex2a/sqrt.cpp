// This code was generated with Kernel Builder Program Generator
//Session Name: modulate1
//Kernel Name: Modulate_v1_uchar
//Configuration Name: config_0

#include <stdio.h> 
#include <stdlib.h> 
#include <string.h> 
#include <string> 
#include <fstream> 

#include "ocl_utils.h"

#include <malloc.h> 

#define CL_USE_DEPRECATED_OPENCL_1_2_APIS 
#include <CL/cl.h> 

#define SEPARATOR       ("----------------------------------------------------------------------\n") 
#define INTEL_PLATFORM  "Intel(R) OpenCL" 
#define BUF_SIZE 1048576

using namespace std;

// get platform id of Intel OpenCL platform 
cl_platform_id get_intel_platform();

// read the kernel source code from a given file name 
char* read_source(const char *file_name);

// print the build log in case of failure 
void build_fail_log(cl_program, cl_device_id);

// read binary content 
int ReadBinaryFile(const std::string filename, char** data, bool isSVM = false);

/*
* Generate random value for input buffers
*/
void generateInput4(cl_float4* inputArray, cl_uint arrayWidth, cl_uint arrayHeight)
{
	srand(12345);

	// random initialization of input
	cl_uint array_size = arrayWidth * arrayHeight;
	for (cl_uint i = 0; i < array_size; ++i)
	{
		inputArray[i] = { (cl_float)(rand() % 1000), (cl_float)(rand() % 1000), (cl_float)(rand() % 1000), (cl_float)(rand() % 1000) };
	}
}

int main(int argc, char** argv)
{
	cl_int err;                             // error code returned from api calls 
	cl_platform_id   platform = NULL;   // platform id 
	cl_device_id     device_id = NULL;   // compute device id  
	cl_context       context = NULL;   // compute context 
	cl_command_queue commands = NULL;   // compute device's queue 
	cl_program       program = NULL;   // compute program 
	cl_kernel        kernel = NULL;   // compute kernel 

									  //hw2
	cl_kernel        kernel4_1 = NULL;   // compute kernel 
	cl_kernel        kernel4_2 = NULL;   // compute kernel 
	cl_kernel        kernel4_3 = NULL;   // compute kernel 
	cl_event		 prof_event;


	int			 vector_size = 4096;

	// get Intel OpenCL platform 
	platform = get_intel_platform();
	if (NULL == platform)
	{
		printf("Error: failed to found Intel platform...\n");
		return EXIT_FAILURE;
	}

	// allocate working buffers. 
	// the buffer should be aligned with 4K page and size should fit 64-byte cached line
	///////////////////////////////cl_uint optimizedSize = ((sizeof(cl_float4) * vector_size - 1) / 64 + 1) * 64;
	
	//hw2
	cl_float4* inputA = (cl_float4*)_aligned_malloc(sizeof(cl_float4) * vector_size, 4096);
	cl_float* outputD = (cl_float*)_aligned_malloc(sizeof(cl_float) * vector_size, 4096);
	if (NULL == inputA || NULL == outputD)
	{
		LogError("Error: _aligned_malloc failed to allocate buffers.\n");
		return -1;
	}

	generateInput4(inputA, vector_size, 1);

	// Getting the compute device for the processor graphic (GPU) on our platform by function 
	printf("Selected device: GPU\n");
	err = clGetDeviceIDs(platform, CL_DEVICE_TYPE_GPU, 1, &device_id, NULL);

	char *deviceName = new char[1024];
	err |= clGetDeviceInfo(device_id, CL_DEVICE_NAME, 1024, deviceName, NULL);
	printf("Device name: %s\n", deviceName);
	if (CL_SUCCESS != err || NULL == device_id)
	{
		printf("Error: Failed to get device on this platform!\n");
		return EXIT_FAILURE;
	}

	// We have a compute device of required type! Next, create a compute context on it. 
	printf("\n");
	printf(SEPARATOR);
	printf("\nCreating a compute context for the required device\n");

	cl_context_properties properties[3] = { CL_CONTEXT_PLATFORM, (cl_context_properties)platform, '\0' };

	context = clCreateContext(NULL, 1, &device_id, NULL, NULL, &err);

	if (CL_SUCCESS != err || NULL == context)
	{
		printf("Error: Failed to create a compute context!\n");
		return EXIT_FAILURE;
	}

	// OpenCL objects such as memory, program and kernel objects are created using a context. 
	printf("\n");
	printf(SEPARATOR);
	printf("\nCreating a command queue\n");

	commands = clCreateCommandQueue(context, device_id, CL_QUEUE_PROFILING_ENABLE, &err);

	if (CL_SUCCESS != err || NULL == commands)
	{
		LogError("Error: Failed to create a command queue! Error %s\n", TranslateOpenCLError(err));
		clReleaseContext(context);
		return EXIT_FAILURE;
	}

	// Create the compute program object for our context and load the source code from the source buffer 
	printf("\n");
	printf(SEPARATOR);
	printf("\nCreating the compute program from source\n");

	// TODO: set correct path to kernel .cl source file
	string newCLFileName = "ex2akernel.cl";
	char * kernel_source = read_source(newCLFileName.c_str());

	if (NULL == kernel_source)
	{
		printf("Error: Failed to read kernel source code from file name: %s!\n", newCLFileName.c_str());
		clReleaseCommandQueue(commands);
		clReleaseContext(context);
		return EXIT_FAILURE;
	}
	printf("%s\n", kernel_source);

	program = clCreateProgramWithSource(context, 1, (const char **)&kernel_source, NULL, &err);

	free(kernel_source);

	if (CL_SUCCESS != err || NULL == program)
	{
		printf("Error: Failed to create compute program!\n");
		clReleaseCommandQueue(commands);
		clReleaseContext(context);
		return EXIT_FAILURE;
	}

	// Build the program executable 
	printf("\n");
	printf(SEPARATOR);
	printf("\nCompiling the program executable\n");

	err = clBuildProgram(program, 0, NULL, "", NULL, NULL);
	if (CL_SUCCESS != err)
	{
		printf("Error: Failed to build program executable!\n");
		build_fail_log(program, device_id);
		clReleaseProgram(program);
		clReleaseCommandQueue(commands);
		clReleaseContext(context);
		return EXIT_FAILURE;
	}

	// Create the compute kernel object from the program executable object 
	printf("\n");
	printf(SEPARATOR);
	printf("\nCreating the compute kernel from program executable\n");
	printf(SEPARATOR);

	// TODO: specify correct kernel function name
	//kernel = clCreateKernel(program, "myEx2akernel", &err);
	//kernel4_1 = clCreateKernel(program, "hw2_4_1kernel", &err);
	kernel4_2 = clCreateKernel(program, "hw2_4_2kernel", &err);
	//kernel4_3 = clCreateKernel(program, "hw2_4_3kernel", &err);

	if (CL_SUCCESS != err || NULL == kernel4_2)
	{
		printf("Error: Failed to create compute kernel!\n");
		clReleaseProgram(program);
		clReleaseCommandQueue(commands);
		clReleaseContext(context);
		return EXIT_FAILURE;
	}

	//Variables: 

	// Create buffer objects for the input and input/output arrays in device memory for our calculation 
	//Creating buffer: buffer_1

	if ((CL_SUCCESS != err))
	{
		LogError("BAD");
		return err;
	}

	//hw2
	cl_mem buffer_inputA = clCreateBuffer(context, CL_MEM_READ_ONLY | CL_MEM_USE_HOST_PTR, sizeof(cl_float4) * vector_size, inputA, &err);
	//output buffer
	cl_mem buffer_outputD = clCreateBuffer(context, CL_MEM_WRITE_ONLY | CL_MEM_USE_HOST_PTR, sizeof(cl_float) * vector_size, outputD, &err);


	// Setting the arguments to our compute kernel in order to execute it. 
	printf("\n");
	printf(SEPARATOR);
	printf("\nSetting the kernel arguments\n");

	// TODO: define and init vector variable type for kernel parameter
	cl_float4 cl_fl4 = { 1.0f, 2.0f, 3.0f, 4.0f };

	// TODO: set kernel arguments
	/*err = clSetKernelArg(kernel, 0, sizeof(cl_float4), &cl_fl4);

	if ((CL_SUCCESS != err))
	{
	LogError("Error: Failed to set kernel arg0 '%s'.\n", TranslateOpenCLError(err));
	return err;
	}

	err = clSetKernelArg(kernel, 1, sizeof(cl_mem), &buffer_structbuf);

	if ((CL_SUCCESS != err))
	{
	LogError("Error: Failed to set kernel arg1 '%s'.\n", TranslateOpenCLError(err));
	return err;
	}*/

	//hw2


	if (kernel4_1) {
		err = clSetKernelArg(kernel4_1, 0, sizeof(cl_mem), (void *)&buffer_inputA);

		if ((CL_SUCCESS != err))
		{
			LogError("Error: Failed to set kernel4_1 arg0 '%s'.\n", TranslateOpenCLError(err));
			return err;
		}

		err = clSetKernelArg(kernel4_1, 1, sizeof(cl_mem), (void *)&buffer_outputD);

		if ((CL_SUCCESS != err))
		{
			LogError("Error: Failed to set kernel4_1 arg1 '%s'.\n", TranslateOpenCLError(err));
			return err;
		}
	}

	if (kernel4_2) {
		err = clSetKernelArg(kernel4_2, 0, sizeof(cl_mem), (void *)&buffer_inputA);

		if ((CL_SUCCESS != err))
		{
			LogError("Error: Failed to set kernel4_2 arg0 '%s'.\n", TranslateOpenCLError(err));
			return err;
		}

		err = clSetKernelArg(kernel4_2, 1, sizeof(cl_mem), (void *)&buffer_outputD);

		if ((CL_SUCCESS != err))
		{
			LogError("Error: Failed to set kernel4_2 arg1 '%s'.\n", TranslateOpenCLError(err));
			return err;
		}
	}


	// Execute the kernel over the entire range of our logically 1d configuration 
	// using the maximum kernel work group size 
	printf("\n");
	printf(SEPARATOR);
	printf("Executing NDRange \n");

	// TODO: define NDRange
	//int dim = 2;
	//size_t global[] = { 8, 8, 0 };
	//size_t local[] = { 1, 1, 0 };

	//hw2
	int dim = 1;
	size_t global[] = { vector_size, 0, 0 };
	size_t local[] = { 1, 0, 0 };

	//opencl profiling timing
	bool openclqueueProfilingEnable = true;
	cl_ulong start_time, end_time;
	size_t return_bytes;

	unsigned int iterations = 1;
	float runSum = 0;
	float runNum = 0;

	if (openclqueueProfilingEnable)
		iterations = 25;

	for (unsigned int i = 0; i < iterations; ++i) {
		//err = clEnqueueNDRangeKernel(commands, kernel, dim, NULL, global, local, 0, NULL, &prof_event);
		//err = clEnqueueNDRangeKernel(commands, kernel4_1, dim, NULL, global, local, 0, NULL, &prof_event);
		err = clEnqueueNDRangeKernel(commands, kernel4_2, dim, NULL, global, local, 0, NULL, &prof_event);
		//err = clEnqueueNDRangeKernel(commands, kernel4_3, dim, NULL, global, local, 0, NULL, &prof_event);

		if (CL_SUCCESS != err)
		{
			printf("Error: Failed to execute kernel!\n");
			//clReleaseKernel(kernel);
			//clReleaseKernel(kernel4_1);
			clReleaseKernel(kernel4_2);
			//clReleaseKernel(kernel4_3);
			clReleaseProgram(program);
			clReleaseCommandQueue(commands);
			clReleaseContext(context);
			return EXIT_FAILURE;
		}

		err = clFinish(commands);
		err = clWaitForEvents(1, &prof_event);
		if (err != CL_SUCCESS)
		{
			printf("Error: clEnqueueNDRangeKernel failed to finish\n");
			return EXIT_FAILURE;
		}

		err = clGetEventProfilingInfo(prof_event, CL_PROFILING_COMMAND_QUEUED, sizeof(cl_ulong),
			&start_time, &return_bytes);
		err = clGetEventProfilingInfo(prof_event, CL_PROFILING_COMMAND_END, sizeof(cl_ulong),
			&end_time, &return_bytes);
		runSum += (double)(end_time - start_time) / 1000000; //nano
		runNum++;

	}
	//opencl profiling timing 
	if (openclqueueProfilingEnable)
		LogInfo("After %d iterations, average running time for kernel is %f ms.\n", iterations, runSum / runNum);

	printf("\n");
	printf("\n***** NDRange is finished ***** \n");
	printf(SEPARATOR);

	printf("\nRead output memory \n");
	printf(SEPARATOR);

	//hw2
	bool result = true;

	cl_float *resultPtr = (cl_float *)clEnqueueMapBuffer(commands, buffer_outputD, true, CL_MAP_READ, 0, sizeof(cl_float) * vector_size, 0, NULL, NULL, &err);

	if (CL_SUCCESS != err)
	{
		LogError("Error: clEnqueueMapBuffer returned %s\n", TranslateOpenCLError(err));
		return false;
	}

	// Call clFinish to guarantee that output region is updated
	err = clFinish(commands);
	if (CL_SUCCESS != err)
	{
		LogError("Error: clFinish returned %s\n", TranslateOpenCLError(err));
	}

	//timing and verification
	LARGE_INTEGER perfFrequency;
	LARGE_INTEGER performanceCountNDRangeStart;
	LARGE_INTEGER performanceCountNDRangeStop;

	iterations = iterations;
	bool windowqueueProfilingEnable = openclqueueProfilingEnable;
	runSum = 0;
	runNum = 0;

	for (unsigned int itr = 0; itr < iterations; ++itr) {
		if (windowqueueProfilingEnable)
			QueryPerformanceCounter(&performanceCountNDRangeStart);

		// sequential host ref. code
		for (unsigned int i = 0; i < vector_size; ++i) {
			if (resultPtr[i] != sqrt(inputA[i].x * inputA[i].x + inputA[i].y * inputA[i].y + inputA[i].z * inputA[i].z + inputA[i].w * inputA[i].w) ) {
				//LogError("this is float=%.10f\n", resultPtr[i] - sqrt(pow(inputA[i].x, 2) + pow(inputA[i].y, 2) + pow(inputA[i].z, 2) + pow(inputA[i].w, 2)));
				LogError("Verification failed at %d, resultPtr=%.2f, sqrt_result=%.2f, inputA[i]={%.2f,%.2f,%.2f,%.2f} \n\n", i, resultPtr[i], sqrt(pow(inputA[i].x, 2) + pow(inputA[i].y, 2) + pow(inputA[i].z, 2) + pow(inputA[i].w, 2)), inputA[i].x, inputA[i].y, inputA[i].z, inputA[i].w);
				result = false;
			}
		}

		if (windowqueueProfilingEnable)
			QueryPerformanceCounter(&performanceCountNDRangeStop);

		if (windowqueueProfilingEnable) {
			QueryPerformanceFrequency(&perfFrequency);
			runSum += 1000.0f*(float)(performanceCountNDRangeStop.QuadPart - performanceCountNDRangeStart.QuadPart) / (float)perfFrequency.QuadPart;
			runNum++;
		}

		if (result)
			LogInfo("Verification passed\n");
	}

	if (windowqueueProfilingEnable)
		LogInfo("\nAfter %d iterations, average running time for sequential is %f ms.\n", iterations, runSum / runNum);


	// Unmapped the output buffer before releasing it
	err = clEnqueueUnmapMemObject(commands, buffer_outputD, resultPtr, 0, NULL, NULL);
	if (CL_SUCCESS != err)
	{
		LogError("Error: clEnqueueUnmapMemObject returned %s\n", TranslateOpenCLError(err));
	}


	// TODO: release memory object and host memory
	err = clReleaseMemObject(buffer_inputA);
	
	err = clReleaseMemObject(buffer_outputD);


	_aligned_free(inputA);
	
	_aligned_free(outputD);

	//clReleaseKernel(kernel);
	//clReleaseKernel(kernel4_1);
	clReleaseKernel(kernel4_2);
	//clReleaseKernel(kernel4_2);
	clReleaseProgram(program);
	clReleaseCommandQueue(commands);
	clReleaseContext(context);

	return 0;
}

