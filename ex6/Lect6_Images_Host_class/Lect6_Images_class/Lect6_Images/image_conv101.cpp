// This code was generated with Kernel Builder Program Generator
//Session Name: images101
//Kernel Name: convolve_v1
//Configuration Name: config_0

#include <stdio.h> 
#include <stdlib.h> 
#include <string.h> 
#include <string> 
#include <fstream> 

#include <malloc.h> 

//#define CL_USE_DEPRECATED_OPENCL_1_2_APIS 
#include <CL/cl.h> 

#define SEPARATOR       ("----------------------------------------------------------------------\n") 
#define INTEL_PLATFORM  "Intel(R) OpenCL" 

using namespace std; 

// get platform id of Intel OpenCL platform 
cl_platform_id get_intel_platform(); 

// read the kernel source code from a given file name 
char* read_source(const char *file_name); 

// print the build log in case of failure 
void build_fail_log(cl_program, cl_device_id); 

// read binary content 
int ReadBinaryFile(const std::string filename, char** data, bool isSVM = false); 
// verfiy output variables 
bool verifyOutput(const std::string& file1Path, const std::string& file2Path); 

int main(int argc, char** argv) 
{ 
    cl_int err;                             // error code returned from api calls 
    cl_platform_id   platform     = NULL;   // platform id 
    cl_device_id     device_id    = NULL;   // compute device id  
    cl_context       context      = NULL;   // compute context 
    cl_command_queue commands     = NULL;   // compute device's queue 
    cl_program       program      = NULL;   // compute program 
    cl_kernel        kernel       = NULL;   // compute kernel 

    // get Intel OpenCL platform 
    platform = get_intel_platform(); 

    if (NULL == platform) 
    { 
        printf("Error: failed to found Intel platform...\n"); 
        return EXIT_FAILURE; 
    } 

    // Getting the compute device for the processor graphic (GPU) on our platform by function 
     printf("Selected device: GPU\n");
    err = clGetDeviceIDs(platform, CL_DEVICE_TYPE_GPU, 1, &device_id, NULL);

    char *deviceName = new char [1024];
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

    cl_context_properties properties[3] = {CL_CONTEXT_PLATFORM, (cl_context_properties)platform, '\0'}; 
    context = clCreateContext(NULL, 1, &device_id, NULL, NULL, &err); 
    if (CL_SUCCESS != err || NULL == context) 
    { 
        printf("Error: Failed to create a compute context!\n"); 
        return EXIT_FAILURE; 
    } 

    printf("\n"); 
    printf(SEPARATOR); 
    printf("\nCreating a command queue\n"); 

    commands = clCreateCommandQueue(context, device_id, 0, &err); 
    if (CL_SUCCESS != err || NULL == commands)  
    { 
        printf("Error: Failed to create a command queue!\n"); 
        clReleaseContext(context); 
        return EXIT_FAILURE; 
    } 

    // Create the compute program object for our context and load the source code from the source buffer 
    printf("\n"); 
    printf(SEPARATOR); 
    printf("\nCreating the compute program from source\n"); 


    string newCLFileName = "image_conv101.cl";
    char * kernel_source = read_source(newCLFileName.c_str()); 
    if (NULL == kernel_source) 
    { 
      printf("Error: Failed to read kernel source code from file name: %s!\n", newCLFileName.c_str()); 
      clReleaseCommandQueue(commands); 
      clReleaseContext(context); 
      return EXIT_FAILURE;    
    } 
    printf("%s\n", kernel_source); 

    program = clCreateProgramWithSource(context, 1, (const char **) &kernel_source, NULL, &err); 

    free (kernel_source); 
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

    // Create the compute kernel object in the program we wish to run 
    printf("\n"); 
    printf(SEPARATOR); 
    printf("\nCreating the compute kernel from program executable\n"); 
    printf(SEPARATOR); 

    kernel = clCreateKernel(program, "convolve_v1", &err);
    if (CL_SUCCESS != err || NULL == kernel) 
    { 
        printf("Error: Failed to create compute kernel!\n"); 
        clReleaseProgram(program); 
        clReleaseCommandQueue(commands); 
        clReleaseContext(context); 
        return EXIT_FAILURE; 
    } 

    //Variables: 
    printf("Creating image image_IN...\n");

     //Creating image variable: image_IN
	// create imageFormat
    cl_image_format imageFormat_image_IN;
    imageFormat_image_IN.image_channel_data_type = CL_FLOAT;
    imageFormat_image_IN.image_channel_order = CL_R;
	//Creating imageDescriptior:
	cl_image_desc imageDescriptor_image_IN;
    imageDescriptor_image_IN.image_type = CL_MEM_OBJECT_IMAGE2D;
    imageDescriptor_image_IN.image_width = 512;
    imageDescriptor_image_IN.image_height = 512;
    imageDescriptor_image_IN.image_depth = 1;
    imageDescriptor_image_IN.image_array_size = 1;
    imageDescriptor_image_IN.image_row_pitch = 0;
    imageDescriptor_image_IN.image_slice_pitch = 0;
    imageDescriptor_image_IN.num_mip_levels = 0;
    imageDescriptor_image_IN.num_samples = 0;
    imageDescriptor_image_IN.mem_object = NULL;
    
	size_t imageSize_image_IN;
    char * bufferData_0;
    imageSize_image_IN = ReadBinaryFile("Flowergirl_512x512.bin", &bufferData_0);
    cl_mem image_image_IN;
    const size_t imageOriginimage_IN[3] = {0, 0, 0};
    const size_t imageRegionimage_IN[3] = {imageDescriptor_image_IN.image_width, imageDescriptor_image_IN.image_height, imageDescriptor_image_IN.image_depth};
     image_image_IN = clCreateImage(context, CL_MEM_USE_HOST_PTR, &imageFormat_image_IN, &imageDescriptor_image_IN, bufferData_0, &err);
    if (err != CL_SUCCESS)
    {
        printf("Error: Failed to creaimageimage_image_IN\n");
        return EXIT_FAILURE;
    }

    printf("Creating image image_OUT...\n");

     //Creating image variable: image_OUT
    cl_image_format imageFormat_image_OUT;
    imageFormat_image_OUT.image_channel_data_type = CL_FLOAT;
    imageFormat_image_OUT.image_channel_order = CL_R;
    cl_image_desc imageDescriptor_image_OUT;
    imageDescriptor_image_OUT.image_type = CL_MEM_OBJECT_IMAGE2D;
    imageDescriptor_image_OUT.image_width = 512;
    imageDescriptor_image_OUT.image_height = 512;
    imageDescriptor_image_OUT.image_depth = 1;
    imageDescriptor_image_OUT.image_array_size = 1;
    imageDescriptor_image_OUT.image_row_pitch = 0;
    imageDescriptor_image_OUT.image_slice_pitch = 0;
    imageDescriptor_image_OUT.num_mip_levels = 0;
    imageDescriptor_image_OUT.num_samples = 0;
    imageDescriptor_image_OUT.mem_object = NULL;
    size_t imageSize_image_OUT;
    imageSize_image_OUT = 1048576;
    cl_mem image_image_OUT;
    const size_t imageOriginimage_OUT[3] = {0, 0, 0};
    const size_t imageRegionimage_OUT[3] = {imageDescriptor_image_OUT.image_width, imageDescriptor_image_OUT.image_height, imageDescriptor_image_OUT.image_depth};
    char * bufferData_1 = (char*)_aligned_malloc(imageSize_image_OUT, 4096);
     image_image_OUT = clCreateImage(context, CL_MEM_USE_HOST_PTR, &imageFormat_image_OUT, &imageDescriptor_image_OUT, bufferData_1, &err);
    if (err != CL_SUCCESS)
    {
        printf("Error: Failed to creaimageimage_image_OUT\n");
        return EXIT_FAILURE;
    }

     //Creating uniform variable: rows
    cl_int uniformrows = {512};

     //Creating uniform variable: cols
    cl_int uniformcols = {512};

	// Create buffer objects for the input and input/output arrays in device memory for our calculation 
    printf("Creating buffer buffer_FILT...\n");

    //Creating buffer: buffer_FILT
    size_t bufferSize_buffer_FILT = 81 * sizeof(cl_float);
    char * bufferData_4;
    bufferSize_buffer_FILT = ReadBinaryFile("bin_buffer_GAUSSFILT.bin", &bufferData_4);
    cl_mem buffer_buffer_FILT;
     buffer_buffer_FILT = clCreateBuffer(context, CL_MEM_USE_HOST_PTR, bufferSize_buffer_FILT, bufferData_4, &err); 
    if (err != CL_SUCCESS)
    {
        printf("Error: Failed to create buffer buffer_buffer_FILT\n");
        return EXIT_FAILURE;
    }

     //Creating uniform variable: filterWidth
    cl_int uniformfilterWidth = {9};

	// Creates a sampler object. 
    //  
    // cl_sampler clCreateSampler (cl_context context, cl_bool normalized_coords, cl_addressing_mode addressing_mode, cl_filter_mode filter_mode, cl_int *errcode_ret) 
    //  
    // context must be a valid OpenCL context. 
    //  
    // normalized_coords determines if the image coordinates specified are normalized(if normalized_coords is CL_TRUE) or not (if normalized_coords is CL_FALSE). 
    //  
    // addressing_mode specifies how out-of- range image coordinates are handled when reading from an image.This can be set to CL_ADDRESS_MIRRORED_REPEAT, CL_ADDRESS_REPEAT, 
    // CL_ADDRESS_CLAMP_TO_EDGE, CL_ADDRESS_CLAMP and CL_ADDRESS_NONE. 
    //  
    // filter_mode specifies the type of filter that must be applied when reading an image.This can be CL_FILTER_NEAREST, or CL_FILTER_LINEAR. 
    //  
    // errcode_ret will return an appropriate error code.If errcode_ret is NULL, no error code is returned. 

    printf("Creating sampler sampler_0...\n");
    //Creating sampler: sampler_0
    cl_sampler image_sampler_0 = clCreateSampler(context, false, CL_ADDRESS_CLAMP_TO_EDGE, CL_FILTER_LINEAR, &err);
    if (err != CL_SUCCESS)
    {
        printf("Error: Failed to create samplerimage_sampler_0\n");
        return EXIT_FAILURE;
    }

    // Setting the arguments to our compute kernel in order to execute it. 
    // 
    printf("\n"); 
    printf(SEPARATOR); 
    printf("\nSetting the kernel arguments\n"); 

    err  = clSetKernelArg(kernel, 0, sizeof(cl_mem), &image_image_IN);
    printf("Setting argument number 0\n");
    if (CL_SUCCESS != err) 
    { 
        printf("Error: Failed to set argument!\n"); 
        return EXIT_FAILURE; 
    } 
    err  = clSetKernelArg(kernel, 1, sizeof(cl_mem), &image_image_OUT);
    printf("Setting argument number 1\n");
    if (CL_SUCCESS != err) 
    { 
        printf("Error: Failed to set argument!\n"); 
        return EXIT_FAILURE; 
    } 
	err  = clSetKernelArg(kernel, 2, sizeof(cl_int), &uniformrows);
    printf("Setting argument number 2\n");
    if (CL_SUCCESS != err) 
    { 
        printf("Error: Failed to set argument!\n"); 
        return EXIT_FAILURE; 
    } 
	err  = clSetKernelArg(kernel, 3, sizeof(cl_int), &uniformcols);
    printf("Setting argument number 3\n");
    if (CL_SUCCESS != err) 
    { 
        printf("Error: Failed to set argument!\n"); 
        return EXIT_FAILURE; 
    } 
    err  = clSetKernelArg(kernel, 4, sizeof(cl_mem), &buffer_buffer_FILT);
    printf("Setting argument number 4\n");
    if (CL_SUCCESS != err) 
    { 
        printf("Error: Failed to set argument!\n"); 
        return EXIT_FAILURE; 
    } 
    err  = clSetKernelArg(kernel, 5, sizeof(cl_int), &uniformfilterWidth);
    printf("Setting argument number 5\n");
    if (CL_SUCCESS != err) 
    { 
        printf("Error: Failed to set argument!\n"); 
        return EXIT_FAILURE; 
    } 
    err  = clSetKernelArg(kernel, 6, sizeof(cl_sampler), &image_sampler_0);
    printf("Setting argument number 6\n");
    if (CL_SUCCESS != err) 
    { 
        printf("Error: Failed to set argument!\n"); 
        return EXIT_FAILURE; 
    } 

    // Execute the kernel over the entire range of our logically 1d configuration 
    // using the maximum kernel work group size 
    printf("\n"); 
    printf(SEPARATOR); 
    printf("Executing NDRange \n"); 

    int dim = 2;
    size_t global[] = {512, 512, 0}; 
    size_t local[] = {8, 8, 0}; 
    err = clEnqueueNDRangeKernel(commands, kernel, dim, NULL, global, local, 0, NULL, NULL);
    if (CL_SUCCESS != err)  
    { 
        printf("Error: Failed to execute kernel!\n"); 
        clReleaseKernel(kernel); 
        clReleaseProgram(program); 
        clReleaseCommandQueue(commands); 
        clReleaseContext(context); 
        return EXIT_FAILURE; 
    } 

    err = clFinish(commands);
    if (err != CL_SUCCESS)
    {
        printf("Error: Failed to finish\n");
        return EXIT_FAILURE;
    }

    printf("\n"); 
    printf("\n***** NDRange is finished ***** \n");
    printf(SEPARATOR); 
    printf("\nRead output memory \n");
    printf(SEPARATOR); 

    // Enqueues a command to map a region of the buffer object given by buffer into the host address space and returns a pointer to this mapped region. 
    printf("Read(Map/Unmap) buffer buffer_buffer_FILT\n");
    cl_map_flags MapFlags(CL_MAP_READ);
    void *buffer_buffer_FILT_out = clEnqueueMapBuffer(commands, buffer_buffer_FILT, true, MapFlags, 0, bufferSize_buffer_FILT, 0, NULL, NULL, &err);
    if (err != CL_SUCCESS)
    {
        printf("Error: Failed to map buffer buffer_buffer_FILT\n");
        return EXIT_FAILURE;
    }

    std::ofstream outFilebuffer_buffer_FILT_out("buffer_buffer_FILT_out.bin", std::ios::out | std::ios::binary);
    if (!outFilebuffer_buffer_FILT_out.is_open())
    {
        printf("Could not open output file for write");
    }
    else
    {
        outFilebuffer_buffer_FILT_out.write((char*) buffer_buffer_FILT_out, bufferSize_buffer_FILT);
        outFilebuffer_buffer_FILT_out.close();
    }
    printf("buffer_buffer_FILT buffer was dumped to buffer_buffer_FILT_out.bin\n");
    // Enqueues a command to unmap a previously mapped region of a memory object.Reads or writes from the host using the pointer returned by clEnqueueMapBuffer or clEnqueueMapImage are considered to be complete. 
    err = clEnqueueUnmapMemObject(commands, buffer_buffer_FILT, buffer_buffer_FILT_out, 0, NULL, NULL);

    if (err != CL_SUCCESS)
    {
        printf("Error: Failed to unmap buffer buffer_buffer_FILT\n");
        return EXIT_FAILURE;
    }

    clReleaseMemObject(buffer_buffer_FILT);

    // Enqueues a command to map a region in the image object given by image into the host address space and returns a pointer to this mapped region. 
    printf("Read imageimage_image_IN\n");
    void *image_image_IN_out = clEnqueueMapImage(commands, image_image_IN, true, MapFlags, imageOriginimage_IN, imageRegionimage_IN, &imageDescriptor_image_IN.image_row_pitch, &imageDescriptor_image_IN.image_slice_pitch, 0, NULL, NULL, &err);
    if (err != CL_SUCCESS)
    {
        printf("Error: Failed to map imageimage_image_IN\n");
        return EXIT_FAILURE;
    }

    std::ofstream outFileimage_image_IN_out("image_image_IN_out.bin", std::ios::out | std::ios::binary);
    if (!outFileimage_image_IN_out.is_open())
    {
        printf("Could not open output file for write");
    }
    else
    {
        outFileimage_image_IN_out.write((char*) image_image_IN_out, 1048576);
        outFileimage_image_IN_out.close();
    }
    printf("image_image_IN image was dumped to image_image_IN_out.bin\n");

    err = clEnqueueUnmapMemObject(commands, image_image_IN, image_image_IN_out, 0, NULL, NULL);

    if (err != CL_SUCCESS)
    {
        printf("Error: Failed to unmap imageimage_image_IN\n");
        return EXIT_FAILURE;
    }

    clReleaseMemObject(image_image_IN);

    printf("Read imageimage_image_OUT\n");
    void *image_image_OUT_out = clEnqueueMapImage(commands, image_image_OUT, true, MapFlags, imageOriginimage_OUT, imageRegionimage_OUT, &imageDescriptor_image_OUT.image_row_pitch, &imageDescriptor_image_OUT.image_slice_pitch, 0, NULL, NULL, &err);
    if (err != CL_SUCCESS)
    {
        printf("Error: Failed to map imageimage_image_OUT\n");
        return EXIT_FAILURE;
    }

    std::ofstream outFileimage_image_OUT_out("image_image_OUT_out.bin", std::ios::out | std::ios::binary);
    if (!outFileimage_image_OUT_out.is_open())
    {
        printf("Could not open output file for write");
    }
    else
    {
        outFileimage_image_OUT_out.write((char*) image_image_OUT_out, 1048576);
        outFileimage_image_OUT_out.close();
    }
    printf("image_image_OUT image was dumped to image_image_OUT_out.bin\n");

    err = clEnqueueUnmapMemObject(commands, image_image_OUT, image_image_OUT_out, 0, NULL, NULL);

    if (err != CL_SUCCESS)
    {
        printf("Error: Failed to unmap imageimage_image_OUT\n");
        return EXIT_FAILURE;
    }

    clReleaseMemObject(image_image_OUT);
    clReleaseKernel(kernel); 
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

   cl_platform_id platforms[10]  = { NULL }; 
   cl_uint num_platforms = 0; 

   cl_int err = clGetPlatformIDs(10, platforms, &num_platforms); 

   if (err != CL_SUCCESS) { 
      printf("Error: Failed to get a platform id!\n"); 
       return NULL; 
   } 

   size_t returned_size = 0; 
   cl_char platform_name[1024] = {0}, platform_prof[1024] = {0}, platform_vers[1024] = {0}, platform_exts[1024] = {0}; 

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

       err  = clGetPlatformInfo(platforms[ui], CL_PLATFORM_NAME,       sizeof(platform_name), platform_name, &returned_size); 
       err |= clGetPlatformInfo(platforms[ui], CL_PLATFORM_VERSION,    sizeof(platform_vers), platform_vers, &returned_size); 
       err |= clGetPlatformInfo(platforms[ui], CL_PLATFORM_PROFILE,    sizeof(platform_prof), platform_prof, &returned_size); 
       err |= clGetPlatformInfo(platforms[ui], CL_PLATFORM_EXTENSIONS, sizeof(platform_exts), platform_exts, &returned_size); 

       if (err != CL_SUCCESS) { 
           printf("Error: Failed to get platform info!\n"); 
           return NULL; 
       } 

       // check for Intel platform 
       if (!strcmp((char*)platform_name, INTEL_PLATFORM)) { 
           printf("\nPlatform information\n", ui); 
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

void build_fail_log( cl_program program, cl_device_id device_id )  
{ 
    cl_int err = CL_SUCCESS; 
    size_t log_size = 0; 

    err = clGetProgramBuildInfo(program, device_id, CL_PROGRAM_BUILD_LOG, 0, NULL, &log_size); 
    if (CL_SUCCESS != err)  
    { 
        printf("Error: Failed to read build log length...\n"); 
        return; 
    } 

    char* build_log = (char*) malloc(sizeof(char) * log_size + 1); 
    if(NULL != build_log)  
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
    ifstream file(filename.c_str(), ios::in|ios::binary|ios::ate); 
    if (!file.is_open())  
    { 
        throw string("Could not open file " + filename); 
    } 

    file_size = file.tellg(); 
    int mTotalSize = file_size; 
    int buffer_size = mTotalSize; 

    // Calculating total number of elements to be read 
    num_of_elements = mTotalSize; 
    if(!isSVM) 
    {
        *data = new char[num_of_elements]; 
    }
    // Moving file pointer to beginning, and reading file contents 
    file.seekg(0, ios::beg); 
    file.read(*data, mTotalSize); 
    file.close(); 
    return num_of_elements; 
} 
bool verifyOutput(const std::string& file1Path, const std::string& file2Path){ 
    bool equals = true; 
    unsigned int N = 65536; 
    char* b1 = (char*)calloc(1, N + 1); 
    char* b2 = (char*)calloc(1, N + 1); 
 
    ifstream stream1(file1Path.c_str(), std::ios::binary); 
    if (!stream1) 
    { 
        return false; 
    } 
 
    ifstream stream2(file2Path.c_str(), std::ios::binary); 
    if (!stream2) 
    { 
        return false; 
    } 
 
    stream1.seekg(0, stream1.end); 
    stream2.seekg(0, stream2.end); 
    unsigned int length1 = stream1.tellg(); 
    unsigned int length2 = stream2.tellg(); 
    if (length1 != length2) 
    { 
        stream1.close(); 
        stream2.close(); 
        return false; 
    } 
 
    stream1.seekg(0, stream1.beg); 
    stream2.seekg(0, stream2.beg); 
 
    while (true) { 
        unsigned int pos = stream1.tellg(); 
        if (length1 - pos < N) 
        { 
            N = length1 - pos; 
        } 
 
        if (N <= 0) 
        { 
            break; 
        } 
 
        stream1.read(b1, N); 
        stream2.read(b2, N); 
 
        if (memcmp(b1, b2, N)) 
        { 
            equals = false; 
            break; 
        } 
    } 
    stream1.close(); 
    stream2.close(); 
 
    return equals; 
} 

