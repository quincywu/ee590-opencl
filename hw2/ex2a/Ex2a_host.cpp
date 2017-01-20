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

// TODO: define host-side struct
struct s1 {
	cl_int2 ui2;
	cl_float4 fl4;
	cl_char8 ch8;
};

// TODO: declare pointer instance of struct
struct s1* p_str1;

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
void generateInput(cl_float4* inputArray, cl_uint arrayWidth, cl_uint arrayHeight)
{
	srand(12345);

	// random initialization of input
	cl_uint array_size = arrayWidth * arrayHeight;
	for (cl_uint i = 0; i < array_size; ++i)
	{
		inputArray[i] = { (cl_float)(rand() % 1000), (cl_float)(rand() % 1000), (cl_float)(rand() % 1000), (cl_float)(rand() % 1000) };
	}
}

int main_1(int argc, char** argv)
{
	cl_int err;                             // error code returned from api calls 
	cl_platform_id   platform = NULL;   // platform id 
	cl_device_id     device_id = NULL;   // compute device id  
	cl_context       context = NULL;   // compute context 
	cl_command_queue commands = NULL;   // compute device's queue 
	cl_program       program = NULL;   // compute program 
	cl_kernel        kernel = NULL;   // compute kernel 

	//hw2
	cl_kernel        kernel1_1 = NULL;   // compute kernel 
	cl_kernel        kernel1_2 = NULL;   // compute kernel 
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

	// TODO: allocate aligned memory for struct pointer
#define NUM_STRUCTS 1
	p_str1 = (struct s1*)_aligned_malloc(sizeof(struct s1), 4096);

	// TODO: initialize struct members
	p_str1->ch8 = { 'a', 'b','c','d','e','f','g','h' };
	p_str1->fl4 = { 1.0f, 2.0f, 3.0f, 4.0f };
	p_str1->ui2 = { 11, 22 };

	//hw2
	cl_float4* inputA = (cl_float4*)_aligned_malloc(sizeof(cl_float4) * vector_size, 4096);
	cl_float4* inputB = (cl_float4*)_aligned_malloc(sizeof(cl_float4) * vector_size, 4096);
	cl_float* outputC = (cl_float*)_aligned_malloc(sizeof(cl_float) * vector_size, 4096);
	if (NULL == inputA || NULL == inputB || NULL == outputC)
	{
		LogError("Error: _aligned_malloc failed to allocate buffers.\n");
		return -1;
	}

	generateInput(inputA, vector_size, 1);
	generateInput(inputB, vector_size, 1);

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
	kernel1_1 = clCreateKernel(program, "hw2_1_1kernel", &err);
	//kernel1_2 = clCreateKernel(program, "hw2_1_2kernel", &err);

	if (CL_SUCCESS != err || NULL == kernel1_1)
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

	// TODO: define and create buffer memory object for host-side struct memory
	cl_mem buffer_structbuf = clCreateBuffer(context, CL_MEM_USE_HOST_PTR, sizeof(struct s1), &p_str1, &err);

	if ((CL_SUCCESS != err))
	{
		LogError("BAD");
		return err;
	}

	//hw2
	cl_mem buffer_inputA = clCreateBuffer(context, CL_MEM_READ_ONLY | CL_MEM_USE_HOST_PTR, sizeof(cl_float4) * vector_size, inputA, &err);
	cl_mem buffer_inputB = clCreateBuffer(context, CL_MEM_READ_ONLY | CL_MEM_USE_HOST_PTR, sizeof(cl_float4) * vector_size, inputB, &err);

	//output buffer
	cl_mem buffer_outputC = clCreateBuffer(context, CL_MEM_WRITE_ONLY | CL_MEM_USE_HOST_PTR, sizeof(cl_float) * vector_size, outputC, &err);


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
	cl_float4 cl_fl4b = { 5.0f, 6.0f, 7.0f, 8.0f };


	if (kernel1_1) {
		err = clSetKernelArg(kernel1_1, 0, sizeof(cl_mem), (void *)&buffer_inputA);

		if ((CL_SUCCESS != err))
		{
			LogError("Error: Failed to set kernel1_1 arg0 '%s'.\n", TranslateOpenCLError(err));
			return err;
		}

		err = clSetKernelArg(kernel1_1, 1, sizeof(cl_mem), (void *)&buffer_inputB);

		if ((CL_SUCCESS != err))
		{
			LogError("Error: Failed to set kernel1_1 arg1 '%s'.\n", TranslateOpenCLError(err));
			return err;
		}

		err = clSetKernelArg(kernel1_1, 2, sizeof(cl_mem), (void *)&buffer_outputC);

		if ((CL_SUCCESS != err))
		{
			LogError("Error: Failed to set kernel1_1 arg2 '%s'.\n", TranslateOpenCLError(err));
			return err;
		}
	}
	if (kernel1_2) {
		err = clSetKernelArg(kernel1_2, 0, sizeof(cl_mem), (void *)&buffer_inputA);

		if ((CL_SUCCESS != err))
		{
			LogError("Error: Failed to set kernel1_2 arg0 '%s'.\n", TranslateOpenCLError(err));
			return err;
		}

		err = clSetKernelArg(kernel1_2, 1, sizeof(cl_mem), (void *)&buffer_inputB);

		if ((CL_SUCCESS != err))
		{
			LogError("Error: Failed to set kernel1_2 arg1 '%s'.\n", TranslateOpenCLError(err));
			return err;
		}

		err = clSetKernelArg(kernel1_2, 2, sizeof(cl_mem), (void *)&buffer_outputC);

		if ((CL_SUCCESS != err))
		{
			LogError("Error: Failed to set kernel1_2 arg2 '%s'.\n", TranslateOpenCLError(err));
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

	//choosing best local size
	bool findingBestLocalSize = true;
	bool first_itr = true;
	cl_float best_time = 0.0f, current_time;
	unsigned int counter = 0;
	int ideal_local_size = 1;

	//opencl profiling timing
	bool openclqueueProfilingEnable = true;
	cl_ulong start_time, end_time;
	size_t return_bytes;

	unsigned int iterations = 1;
	float runSum = 0;
	float runNum = 0;

	if (openclqueueProfilingEnable)
		iterations = 50;

	if (!findingBestLocalSize) // so the loop only excecute once
		counter = vector_size - 2;

	//CL_DEVICE_MAX_WORK_GROUP_SIZE
	for (; counter < 512 - 1; ++counter) { // then local[0] would be less than global size
		local[0] = (size_t)(counter + 1);
		LogInfo("%d %d %d\n", local[0], local[1], local[2]);
		if (global[0] % local[0] == 0) {
			for (unsigned int i = 0; i < iterations; ++i) {
				//err = clEnqueueNDRangeKernel(commands, kernel, dim, NULL, global, local, 0, NULL, &prof_event);
				if (kernel1_1) err = clEnqueueNDRangeKernel(commands, kernel1_1, dim, NULL, global, local, 0, NULL, &prof_event);
				if (kernel1_2) err = clEnqueueNDRangeKernel(commands, kernel1_2, dim, NULL, global, local, 0, NULL, &prof_event);
				if (CL_SUCCESS != err)
				{
					printf("Error: Failed to execute kernel!\n");
					//clReleaseKernel(kernel);
					if (kernel1_1) clReleaseKernel(kernel1_1);
					if (kernel1_2) clReleaseKernel(kernel1_2);
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
			current_time = runSum / runNum;
			runSum = 0;
			runNum = 0;
		}
		if (current_time < best_time || first_itr) { //current time is faster therefore better local size
			best_time = current_time;
			ideal_local_size = local[0];
			first_itr = false;
		}
		LogInfo("Best local size is %d, best time is %f, current_time is %f.\n", ideal_local_size, best_time, current_time);
	}


	//opencl profiling timing 
	if (openclqueueProfilingEnable)
		LogInfo("After %d iterations, average running time for kernel is %f ms.\n", iterations, best_time);

	printf("\n");
	printf("\n***** NDRange is finished ***** \n");
	printf(SEPARATOR);

	printf("\nRead output memory \n");
	printf(SEPARATOR);

	//hw2
	bool result = true;
	
	cl_float *resultPtr = (cl_float *)clEnqueueMapBuffer(commands, buffer_outputC, true, CL_MAP_READ, 0, sizeof(cl_float) * vector_size, 0, NULL, NULL, &err);
	
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
			if (resultPtr[i] != inputA[i].x * inputB[i].x + inputA[i].y * inputB[i].y + inputA[i].z * inputB[i].z + inputA[i].w * inputB[i].w) {

				LogError("Verification failed at %d, resultPtr=%f, inputA[i]=%.2v4hlf, inputB=%.2v4hlf\n", i, resultPtr[i], inputA[i], inputB[i]);
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
			LogInfo("Verification passed");
	}

	if (windowqueueProfilingEnable)
		LogInfo("After %d iterations, average running time for sequential is %f ms.\n", iterations, runSum / runNum);


	// Unmapped the output buffer before releasing it
	err = clEnqueueUnmapMemObject(commands, buffer_outputC, resultPtr, 0, NULL, NULL);
	if (CL_SUCCESS != err)
	{
		LogError("Error: clEnqueueUnmapMemObject returned %s\n", TranslateOpenCLError(err));
	}
	

	// TODO: release memory object and host memory
	err = clReleaseMemObject(buffer_inputA);
	err = clReleaseMemObject(buffer_inputB);
	err = clReleaseMemObject(buffer_outputC);
	err = clReleaseMemObject(buffer_structbuf);


	_aligned_free(inputA);
	_aligned_free(inputB);
	_aligned_free(outputC);

	//clReleaseKernel(kernel);
	//clReleaseKernel(kernel1_1);
	clReleaseKernel(kernel1_2);
	clReleaseProgram(program);
	clReleaseCommandQueue(commands);
	clReleaseContext(context);

	return 0;
}


cl_platform_id get_intel_platform()
{
	// Trying to get a handle to Intel's OpenCL platform using function 
	// 
	// cl_int clGetPlatformIDs (cl_uint num_entries, cl_platform_id *platforms, cl_uint *num_platforms) 
	// 
	// num_entries is the number of cl_platform_id entries that can be added to platforms. If platforms 
	// is not NULL, the num_entries must be greater than zero. 
	// platforms returns a list of OpenCL platforms found. The cl_platform_id values returned in platforms 
	// can be used to identify a specific OpenCL platform. If platforms argument is NULL, this argument is ignored. 
	// The number of OpenCL platforms returned is the minimum of the value specified by num_entries or the number of 
	// OpenCL platforms available. 
	// num_platforms returns the number of OpenCL platforms available. If num_platforms is NULL, this argument is ignored. 
	// 
	// Trying to identify one platform: 

	cl_platform_id platforms[10] = { NULL };
	cl_uint num_platforms = 0;

	cl_int err = clGetPlatformIDs(10, platforms, &num_platforms);

	if (err != CL_SUCCESS) {
		printf("Error: Failed to get a platform id!\n");
		return NULL;
	}

	size_t returned_size = 0;
	cl_char platform_name[1024] = { 0 }, platform_prof[1024] = { 0 }, platform_vers[1024] = { 0 }, platform_exts[1024] = { 0 };

	for (unsigned int ui = 0; ui < num_platforms; ++ui)
	{
		// Found one platform. Query specific information about the found platform using the function  
		// 
		// cl_int clGetPlatformInfo (cl_platform_id platform, cl_platform_info param_name, 
		//                           size_t param_value_size, void *param_value,  
		//                           size_t *param_value_size_ret) 
		// 
		// platform refers to the platform ID returned by clGetPlatformIDs or can be NULL. 
		// If platform is NULL, the behavior is implementation-defined. 
		// 
		// param_name is an enumeration constant that identifies the platform information being queried. 
		// We'll query the following information (for complete documentation, see Specification, page 30): 
		// 
		// CL_PLATFORM_NAME       -platform name string 
		// CL_PLATFORM_VERSION    -OpenCL version supported by the implementation 
		// CL_PLATFORM_PROFILE    -FULL_PROFILE if the implementation supports the OpenCL specification 
		//                        -EMBEDDED_PROFILE - if the implementation supports the OpenCL embedded profile (subset). 
		// CL_PLATFORM_EXTENSIONS -extension names supported by the platform 
		// 
		// param_value is a pointer to memory location where appropriate values for a given param_name will be returned. 
		// If param_value is NULL, it is ignored. 
		// 
		// param_value_size specifies the size in bytes of memory pointed to by param_value. 
		// param_value_size_ret returns the actual size in bytes of data being queried by param_value. 
		// 
		// Trying to query platform specific information... 

		err = clGetPlatformInfo(platforms[ui], CL_PLATFORM_NAME, sizeof(platform_name), platform_name, &returned_size);
		err |= clGetPlatformInfo(platforms[ui], CL_PLATFORM_VERSION, sizeof(platform_vers), platform_vers, &returned_size);
		err |= clGetPlatformInfo(platforms[ui], CL_PLATFORM_PROFILE, sizeof(platform_prof), platform_prof, &returned_size);
		err |= clGetPlatformInfo(platforms[ui], CL_PLATFORM_EXTENSIONS, sizeof(platform_exts), platform_exts, &returned_size);

		if (err != CL_SUCCESS) {
			printf("Error: Failed to get platform info!\n");
			return NULL;
		}

		// check for Intel platform 
		if (!strcmp((char*)platform_name, INTEL_PLATFORM)) {
			printf("\nPlatform information: %d\n", ui);
			printf(SEPARATOR);
			printf("Platform name:       %s\n", (char *)platform_name);
			printf("Platform version:    %s\n", (char *)platform_vers);
			printf("Platform profile:    %s\n", (char *)platform_prof);
			printf("Platform extensions: %s\n", ((char)platform_exts[0] != '\0') ? (char *)platform_exts : "NONE");
			return platforms[ui];
		}
	}

	return NULL;
}

char* read_source(const char *file_name)
{
	FILE *file;
	file = fopen(file_name, "rb");
	if (!file) {
		printf("Error: Failed to open file '%s'\n", file_name);
		return NULL;
	}

	if (fseek(file, 0, SEEK_END))
	{
		printf("Error: Failed to seek file '%s'\n", file_name);
		fclose(file);
		return NULL;
	}
	long size = ftell(file);
	if (size == 0)
	{
		printf("Error: Failed to check position on file '%s'\n", file_name);
		fclose(file);
		return NULL;
	}

	rewind(file);

	char *src = (char *)malloc(sizeof(char) * size + 1);
	if (!src)
	{
		printf("Error: Failed to allocate memory for file '%s'\n", file_name);
		fclose(file);
		return NULL;
	}
	printf("Reading file '%s' (size %ld bytes)\n", file_name, size);

	size_t res = fread(src, 1, sizeof(char) * size, file);
	if (res != sizeof(char) * size)
	{
		printf("Error: Failed to read file '%s'\n", file_name);
		fclose(file);
		free(src);
		return NULL;
	}

	src[size] = '\0'; // NULL terminated  
	fclose(file);

	return src;
};

void build_fail_log(cl_program program, cl_device_id device_id)
{
	cl_int err = CL_SUCCESS;
	size_t log_size = 0;

	err = clGetProgramBuildInfo(program, device_id, CL_PROGRAM_BUILD_LOG, 0, NULL, &log_size);
	if (CL_SUCCESS != err)
	{
		printf("Error: Failed to read build log length...\n");
		return;
	}

	char* build_log = (char*)malloc(sizeof(char) * log_size + 1);
	if (NULL != build_log)
	{
		err = clGetProgramBuildInfo(program, device_id, CL_PROGRAM_BUILD_LOG, log_size, build_log, &log_size);
		if (CL_SUCCESS != err)
		{
			printf("Error: Failed to read build log...\n");
			free(build_log);
			return;
		}

		build_log[log_size] = '\0';    // mark end of message string 

		printf("Build Log:\n");
		puts(build_log);
		fflush(stdout);

		free(build_log);
	}
}

int ReadBinaryFile(const std::string filename, char** data, bool isSVM)
{
	ifstream::pos_type file_size;
	int num_of_elements;
	// Openning bin file with pointer pointing to eof, in order to get file size 
	ifstream file(filename.c_str(), ios::in | ios::binary | ios::ate);
	if (!file.is_open())
	{
		throw string("Could not open file " + filename);
	}

	file_size = file.tellg();
	int mTotalSize = file_size;
	int buffer_size = mTotalSize;

	// Calculating total number of elements to be read 
	num_of_elements = mTotalSize;
	if (!isSVM)
	{
		*data = new char[num_of_elements];
	}
	// Moving file pointer to beginning, and reading file contents 
	file.seekg(0, ios::beg);
	file.read(*data, mTotalSize);
	file.close();
	return num_of_elements;
}