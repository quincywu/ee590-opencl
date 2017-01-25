// This code was generated with Kernel Builder Program Generator
//Session Name: hw3_part1
//Kernel Name: progressiveArraySum
//Configuration Name: progressive

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
    // 
    // cl_int clGetDeviceIDs (cl_platform_id platform, cl_device_type device_type, 
    //                        cl_uint num_entries, cl_device_id *devices, cl_uint *num_devices) 
    // 
    // platform refers to the platform ID returned by clGetPlatformIDs 
    // 
    // device_type is a bitfield that identifies the type of OpenCL device. The device_type can 
    // be used to query specific OpenCL devices or all OpenCL devices available. The valid values are 
    // 
    // CL_DEVICE_TYPE_CPU          An OpenCL device that is the host processor. The host processor runs the OpenCL 
    //                             implementations and is a single or multi-core CPU. 
    // 
    // CL_DEVICE_TYPE_GPU          An OpenCL device that is a GPU. By this we mean that the device can also be used 
    //                             to accelerate a 3D API such as OpenGL or DirectX. 
    // 
    // CL_DEVICE_TYPE_ACCELERATOR  Dedicated OpenCL accelerators (for example the IBM CELL Blade). 
    //                             These devices communicate with the host processor using a peripheral interconnect such as PCIe. 
    // 
    // CL_DEVICE_TYPE_DEFAULT      The default OpenCL device in the system. 
    // 
    // CL_DEVICE_TYPE_ALL          All OpenCL devices available in the system. 
    // 
    // num_entries is the number of cl_device entries that can be added to devices. If devices is not 
    // NULL, the num_entries must be greater than zero. 
    // 
    // devices returns a list of OpenCL devices found. The cl_device_id values returned in devices can be used 
    // to identify a specific OpenCL device. If devices argument is NULL, this argument is ignored. The number of 
    // OpenCL devices returned is the mininum of the value specified by num_entries or the number of OpenCL devices 
    // whose type matches device_type. 
    // 
    // num_devices returns the number of OpenCL devices available that match device_type. If num_devices is NULL, 
    // this argument is ignored. 

    printf("Selected device: GPU\n");
    err = clGetDeviceIDs(platform, CL_DEVICE_TYPE_CPU, 1, &device_id, NULL);

    char *deviceName = new char [1024];
    err |= clGetDeviceInfo(device_id, CL_DEVICE_NAME, 1024, deviceName, NULL);
    printf("Device name: %s\n", deviceName);
    if (CL_SUCCESS != err || NULL == device_id) 
    { 
      printf("Error: Failed to get device on this platform!\n"); 
      return EXIT_FAILURE; 
    } 

    // We have a compute device of required type! Next, create a compute context on it. 
    // The function  
    //  
    // cl_context clCreateContext (const cl_context_properties *properties, cl_uint num_devices, 
    //                             const cl_device_id *devices, void (*pfn_notify)(const char *errinfo, 
    //                                                                             const void *private_info, size_t cb, 
    //                                                                             void *user_data), 
    //                             void *user_data, cl_int *errcode_ret) 
    // 
    // creates an OpenCL context. An OpenCL context is created with one or more devices. Contexts are used 
    // by the OpenCL runtime for managing objects such as command-queues, memory, program and kernel objects and for 
    // executing kernels on one or more devices specified in the context. 
    // 
    // properties specifies a list of context property names and their corresponding values. properties can be NULL in which 
    // case the platform that is selected is implementation-defined. 
    // Each property name is immediately followed by the corresponding desired value. The list is terminated with 0.  
    // The list of supported properties is described in the table below.  
    // cl_context_properties enum   |   Property value   |   Description 
    // =============================|====================|================================= 
    // CL_CONTEXT_PLATFORM          |   cl_platform_id   |   Specifies the platform to use.  
    // 
    // num_devices is the number of devices specified in the devices argument. 
    // 
    // devices is a pointer to a list of unique devices5 returned by clGetDeviceIDs for a platform. 
    //  
    // pfn_notify is a callback function that can be registered by the application. This callback function will be used 
    // by the OpenCL implementation to report information on errors that occur in this context. If pfn_notify is NULL, 
    // no callback function is registered. 
    // 
    // user_data will be passed as the user_data argument when pfn_notify is called. user_data can be NULL. 
    // 
    // errcode_ret will return an appropriate error code. If errcode_ret is NULL, no error code is returned. 
    // 
    // clCreateContext returns a valid non-zero context and errcode_ret is set to CL_SUCCESS if the context is created successfully. 
    // Otherwise, it returns a NULL value with an error valuee returned in errcode_ret. 

    printf("\n"); 
    printf(SEPARATOR); 
    printf("\nCreating a compute context for the required device\n"); 

    cl_context_properties properties[3] = {CL_CONTEXT_PLATFORM, (cl_context_properties)platform, NULL}; 

    context = clCreateContext(NULL, 1, &device_id, NULL, NULL, &err); 

    if (CL_SUCCESS != err || NULL == context) 
    { 
        printf("Error: Failed to create a compute context!\n"); 
        return EXIT_FAILURE; 
    } 

    // OpenCL objects such as memory, program and kernel objects are created using a context. Operations on these 
    // objects are performed using a command-queue. The command-queue can be used to queue a set of operations (referred 
    // to as commands) in order. Having multiple command-queues allows applications to queue multiple independent commands 
    // without requiring synchronization. Note that this should work as long as these objects are not being shared. 
    // Sharing of objects across multiple command-queues will require the application to perform appropriate synchronization. 
    //  
    // The function 
    // 
    // cl_command_queue clCreateCommandQueue (cl_context context, cl_device_id device, 
    //                                        cl_command_queue_properties properties, cl_int *errcode_ret) 
    // 
    // creates a command-queue on a specific device. context must be a valid OpenCL context. 
    // 
    // device must be a device associated with context. It can either be in the list of devices specified when context 
    // is created using clCreateContext or have the same device type as the device type specified when the context is 
    // created using clCreateContextFromType. 
    // 
    // properties is a bit-field which specifies a list of properties for the command-queue, we use the default one (0) 
    // 
    // errcode_ret will return an appropriate error code. If errcode_ret is NULL, no error code is returned. 

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
    // 
    // The function 
    // 
    // cl_program clCreateProgramWithSource (cl_context context, cl_uint count, 
    //                                       const char **strings, const size_t *lengths, cl_int *errcode_ret) 
    // 
    // creates a program object for a context, and loads the source code specified by the text strings in the 
    // strings array into the program object. The devices associated with the program object are the devices associated with context. 
    // 
    // context must be a valid OpenCL context. 
    // 
    // strings is an array of count pointers to optionally null-terminated character strings that make up 
    // the source code. 
    // 
    // The lengths argument is an array with the number of chars in each string (the string length). If an element 
    // in lengths is zero, its accompanying string is null-terminated. If lengths is NULL, all strings in the strings 
    // argument are considered null-terminated. Any length value passed in that is greater than zero excludes the 
    // null terminator in its count. 
    //  
    // errcode_ret will return an appropriate error code. If errcode_ret is NULL, no error code is returned. 

    printf("\n"); 
    printf(SEPARATOR); 
    printf("\nCreating the compute program from source\n"); 


    string newCLFileName = "C:\\Users\\quincywu\\Documents\\GitHub\\ee590-opencl\\hw3\\hw3\\progressiveArraySum\\program.cl";
    char * kernel_source = read_source(newCLFileName.c_str()); 

    if (NULL == kernel_source) 
    { 
      printf("Error: Failed to read kernel source code from file name: %s!\n", newCLFileName); 
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
    // 
    // The function 
    // 
    // cl_int clBuildProgram (cl_program program, cl_uint num_devices, 
    //                        const cl_device_id *device_list, const char *options, 
    //                        void (*pfn_notify)(cl_program, void *user_data), void *user_data) 
    // 
    // builds (compiles & links) a program executable from the program source or binary for all the devices or 
    // a specific device(s) in the OpenCL context associated with program. OpenCL allows program executables to be 
    // built using the source or the binary. clBuildProgram must be called for program created using either 
    // clCreateProgramWithSource or clCreateProgramWithBinary to build the program executable for one or more 
    // devices associated with program. 
    // 
    // program is the program object we just created. 
    // 
    // device_list is a pointer to a list of devices associated with program. If device_list is a NULL value, 
    // the program executable is built for all devices associated with program for which a source or binary has been loaded. 
    // If device_list is a non-NULL value, the program executable is built for devices specified in this list for which 
    // a source or binary has been loaded. 
    // 
    // num_devices is the number of devices listed in device_list. 
    //  
    // options is a pointer to a string that describes the build options to be used for building the program executable 
    // (see section 5.4.3) 
    // 
    // pfn_notify is a function pointer to a notification routine. The notification routine is a callback function that 
    // an application can register and which will be called when the program executable has been built (successfully or unsuccessfully). 
    // 
    // user_data will be passed as an argument when pfn_notify is called. user_data can be NULL. 

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
    // 
    // To create a kernel object, use the function 
    // 
    // cl_kernel clCreateKernel (cl_program program, const char *kernel_name, 
    //                           cl_int *errcode_ret) 
    // 
    // program is a program object with a successfully built executable. 
    // 
    // kernel_name is a function name in the program declared with the __kernel qualifier (here "saxpy"). 
    //  
    // errcode_ret will return an appropriate error code. If errcode_ret is NULL, no error code is returned. 
    // 
    // clCreateKernel returns a valid non-zero kernel object and errcode_ret is set to CL_SUCCESS if the 
    // kernel object is created successfully. 

    printf("\n"); 
    printf(SEPARATOR); 
    printf("\nCreating the compute kernel from program executable\n"); 
    printf(SEPARATOR); 

    kernel = clCreateKernel(program, "progressiveArraySum", &err);
    if (CL_SUCCESS != err || NULL == kernel) 
    { 
        printf("Error: Failed to create compute kernel!\n"); 
        clReleaseProgram(program); 
        clReleaseCommandQueue(commands); 
        clReleaseContext(context); 
        return EXIT_FAILURE; 
    } 

    //Variables: 

    // Create buffer objects for the input and input/output arrays in device memory for our calculation 
    // 
    // A buffer object is created using the following function 
    // 
    // cl_mem clCreateBuffer (cl_context context, cl_mem_flags flags, 
    //                        size_t size, void *host_ptr, cl_int *errcode_ret) 
    // 
    // context is a valid OpenCL context used to create the buffer object. 
    // 
    // flags is a bit-field that is used to specify allocation and usage information such as the memory 
    // arena that should be used to allocate the buffer object and how it will be used. 
    // 
    // Usually, these are used: 
    // 
    // CL_MEM_READ_WRITE   -This flag specifies that the memory object will be read and written by a kernel. This is the default. 
    // 
    // CL_MEM_WRITE_ONLY   -This flags specifies that the memory object will be written but not read by a kernel. 
    //                      Reading from a buffer or image object created with CL_MEM_WRITE_ONLY inside a kernel is undefined. 
    // 
    // CL_MEM_READ_ONLY    -This flag specifies that the memory object is a read-only memory object when used inside a kernel. 
    //                      Writing to a buffer or image object created with CL_MEM_READ_ONLY inside a kernel is undefined. 
    // 
    // CL_MEM_USE_HOST_PTR -This flag is valid only if host_ptr is not NULL. If specified, it indicates that the application 
    //                      wants the OpenCL implementation to use memory referenced by host_ptr as the storage bits for 
    //                      the memory object. 
    // 
    // size is the size in bytes of the buffer memory object to be allocated. 
    // 
    // host_ptr is a pointer to the buffer data that may already be allocated by the application. The size of the buffer 
    // that host_ptr points to must be >= size bytes. 
    // 
    // errcode_ret will return an appropriate error code. If errcode_ret is NULL, no error code is returned. 

    printf("Creating buffer inputA_progressive...\n");


     //Creating buffer: inputA_progressive

    size_t bufferSize_inputA_progressive = 4096 * sizeof(cl_float);
    char * bufferData_0;
    bufferSize_inputA_progressive = ReadBinaryFile("C:\\Users\\quincywu\\Documents\\GitHub\\ee590-opencl\\hw3\\hw3\\progressiveArraySum\\bin_inputA_progressive.bin", &bufferData_0);
    cl_mem buffer_inputA_progressive;
     buffer_inputA_progressive = clCreateBuffer(context, CL_MEM_USE_HOST_PTR, bufferSize_inputA_progressive, bufferData_0, &err); 
    if (err != CL_SUCCESS)
    {
        printf("Error: Failed to create buffer buffer_inputA_progressive\n");
        return EXIT_FAILURE;
    }

    printf("Creating buffer outputB_progressive...\n");


     //Creating buffer: outputB_progressive

    size_t bufferSize_outputB_progressive = 4096 * sizeof(cl_float);
    cl_mem buffer_outputB_progressive;
    char * bufferData_1 = (char*)_aligned_malloc(bufferSize_outputB_progressive, 4096);
     buffer_outputB_progressive = clCreateBuffer(context, CL_MEM_USE_HOST_PTR, bufferSize_outputB_progressive, bufferData_1, &err); 
    if (err != CL_SUCCESS)
    {
        printf("Error: Failed to create buffer buffer_outputB_progressive\n");
        return EXIT_FAILURE;
    }

    // Setting the arguments to our compute kernel in order to execute it. 
    // 
    // The function 
    // 
    // cl_int clSetKernelArg (cl_kernel kernel, cl_uint arg_index, 
    //                        size_t arg_size, const void *arg_value) 
    // 
    // is used to set the argument value for a specific argument of a kernel. 
    // 
    // kernel is a valid kernel object. 
    // 
    // arg_index is the argument index. Arguments to the kernel are referred by indices that go from 0 for the leftmost 
    // argument to n - 1, where n is the total number of arguments declared by a kernel. 
    //  
    // For example, our kernel has the arguments 
    // __kernel void search(                                                         
    // __global int* database,                                    
    // int what_to_find,                                          
    // __global int* index)                                       
    // { 
    //  ... 
    // } 
    // 
    // Argument index values for search will be 0 for database, 1 for what_to_find, and 2 for index. 
    // 
    // arg_value is a pointer to data that should be used as the argument value for argument specified by arg_index. 
    // The argument data pointed to by arg_value is copied and the arg_value pointer can therefore be reused by the 
    // application after clSetKernelArg returns. 
    // 
    // arg_size specifies the size of the argument value. Here it is sizeof(cl_mem) for memory buffer objects and 
    // sizeof(int) for what_to_find argument. 

    printf("\n"); 
    printf(SEPARATOR); 
    printf("\nSetting the kernel arguments\n"); 


    err  = clSetKernelArg(kernel, 0, sizeof(cl_mem), &buffer_inputA_progressive);
    printf("Setting argument number 0\n");
    if (CL_SUCCESS != err) 
    { 
        printf("Error: Failed to set argument!\n"); 
        return EXIT_FAILURE; 
    } 

    err  = clSetKernelArg(kernel, 1, sizeof(cl_mem), &buffer_outputB_progressive);
    printf("Setting argument number 1\n");
    if (CL_SUCCESS != err) 
    { 
        printf("Error: Failed to set argument!\n"); 
        return EXIT_FAILURE; 
    } 

    // Execute the kernel over the entire range of our logically 1d configuration 
    // using the maximum kernel work group size 
    // 
    // The function 
    // 
    // cl_int clEnqueueNDRangeKernel (cl_command_queue command_queue, cl_kernel kernel, cl_uint work_dim, 
    //                                const size_t *global_work_offset, const size_t *global_work_size, 
    //                                const size_t *local_work_size, cl_uint num_events_in_wait_list, 
    //                                const cl_event *event_wait_list, cl_event *event) 
    // 
    // enqueues a command to execute a kernel on a device. 
    // 
    // command_queue is a valid command-queue. The kernel will be queued for execution on the 
    // device associated with command_queue. 
    // 
    // kernel is a valid kernel object. The OpenCL context associated with kernel and command-queue 
    // must be the same. 
    // 
    // work_dim is the number of dimensions used to specify the global work-items and work-items in 
    // the work-group. work_dim must be greater than zero and less than or equal to three. 
    // 
    // global_work_offset must currently be a NULL value. 
    // 
    // global_work_size points to an array of work_dim unsigned values that describe the number of global work-items 
    // in work_dim dimensions that will execute the kernel function. The total number of global work-items is computed as 
    // global_work_size[0]*...*global_work_size[work_dim-1]. 
    // 
    // local_work_size points to an array of work_dim unsigned values that describe the number of work-items that make 
    // up a work-group (also referred to as the size of the work-group) that will execute the kernel specified by kernel. 
    // The total number of work-items in the work-group must be less than or equal to the CL_DEVICE_MAX_WORK_GROUP_SIZE 
    // 
    // event_wait_list and num_events_in_wait_list specify events that need to complete before this particular 
    // command can be executed. 
    // 
    // event returns an event object that identifies this particular kernel execution instance. 

    printf("\n"); 
    printf(SEPARATOR); 
    printf("Executing NDRange \n"); 


    int dim = 1;
    size_t global[] = {4096, 0, 0}; 
    size_t local[] = {1, 0, 0}; 
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
    //  
    // void * clEnqueueMapBuffer(cl_command_queue command_queue, cl_mem buffer, cl_bool blocking_map, cl_map_flags map_flags, 
    //     size_t offset, size_t size, cl_uint num_events_in_wait_list, const cl_event *event_wait_list, cl_event *event, cl_int *errcode_ret) 
    //  
    // command_queue must be a valid host command - queue. 
    //  
    // blocking_map indicates if the map operation is blocking or non - blocking. 
    //  
    // If blocking_map is CL_TRUE, clEnqueueMapBuffer does not return until the specified region in buffer is mapped into the host address space and the application can access the contents of the mapped region using the pointer returned by clEnqueueMapBuffer. 
    //  
    // If blocking_map is CL_FALSE i.e.map operation is non - blocking, the pointer to the mapped region returned by clEnqueueMapBuffer cannot be used until the map command has completed.The event argument returns an event object which can be used to query the execution status of the map command. 
    // Enqueues a command to map a region of the buffer object given by buffer into the host address space and returns a pointer to this mapped region. 
    // When the map command is completed, the application can access the contents of the mapped region using the pointer returned by clEnqueueMapBuffer. 
    //  
    // map_flags is a bit - field: CL_MAP_READ, CL_MAP_WRITE, CL_MAP_WRITE_INVALIDATE_REGION 
    //  
    // buffer is a valid buffer object.The OpenCL context associated with command_queue and buffer must be the same. 
    //  
    // offset and size are the offset in bytes and the size of the region in the buffer object that is being mapped. 
    //  
    //  
    // event_wait_list and num_events_in_wait_list specify events that need to complete before this particular command can be executed. 
    // 
    // If event_wait_list is NULL, then this particular command does not wait on any event to complete.If event_wait_list is NULL, num_events_in_wait_list must be 0. 
    // If event_wait_list is not NULL, the list of events pointed to by event_wait_list must be valid and num_events_in_wait_list must be greater than 0. 
    // The events specified in event_wait_list act as synchronization points.The context associated with events in event_wait_list and command_queue must be the same. 
    // The memory associated with event_wait_list can be reused or freed after the function returns. 
    //  
    // event returns an event object that identifies this particular write command and can be used to query or queue a wait for this particular command to complete. 
    // event can be NULL in which case it will not be possible for the application to query the status of this command or queue a wait for this command to complete. 
    // If the event_wait_list and the event arguments are not NULL, the event argument should not refer to an element of the event_wait_list array. 
    //  
    // errcode_ret will return an appropriate error code.If errcode_ret is NULL, no error code is returned. 

    printf("Read(Map/Unmap) buffer buffer_inputA_progressive\n");
    cl_map_flags MapFlags(CL_MAP_READ);
    void *buffer_inputA_progressive_out = clEnqueueMapBuffer(commands, buffer_inputA_progressive, true, MapFlags, 0, bufferSize_inputA_progressive, 0, NULL, NULL, &err);
    if (err != CL_SUCCESS)
    {
        printf("Error: Failed to map buffer buffer_inputA_progressive\n");
        return EXIT_FAILURE;
    }

    std::ofstream outFilebuffer_inputA_progressive_out("buffer_inputA_progressive_out.bin", std::ios::out | std::ios::binary);
    if (!outFilebuffer_inputA_progressive_out.is_open())
    {
        printf("Could not open output file for write");
    }
    else
    {
        outFilebuffer_inputA_progressive_out.write((char*) buffer_inputA_progressive_out, bufferSize_inputA_progressive);
        outFilebuffer_inputA_progressive_out.close();
    }
    printf("buffer_inputA_progressive buffer was dumped to buffer_inputA_progressive_out.bin\n");
    // Enqueues a command to unmap a previously mapped region of a memory object.Reads or writes from the host using the pointer returned by clEnqueueMapBuffer or clEnqueueMapImage are considered to be complete. 
    //  
    // cl_int clEnqueueUnmapMemObject(cl_command_queue command_queue, cl_mem memobj, void *mapped_ptr, cl_uint num_events_in_wait_list, 
    //     const cl_event *event_wait_list, cl_event *event) 
    //  
    // command_queue must be a valid host command - queue. 
    //  
    // memobj is a valid memory(buffer or image) object.The OpenCL context associated with command_queue and memobj must be the same. 
    //  
    // mapped_ptr is the host address returned by a previous call to clEnqueueMapBuffer, or clEnqueueMapImage for memobj. 
    //  
    // event_wait_list and num_events_in_wait_list specify events that need to complete before this particular command can be executed. 
    // 
    // If event_wait_list is NULL, then this particular command does not wait on any event to complete.If event_wait_list is NULL, num_events_in_wait_list must be 0. 
    // If event_wait_list is not NULL, the list of events pointed to by event_wait_list must be valid and num_events_in_wait_list must be greater than 0. 
    // The events specified in event_wait_list act as synchronization points.The context associated with events in event_wait_list and command_queue must be the same. 
    // The memory associated with event_wait_list can be reused or freed after the function returns. 
    //  
    // event returns an event object that identifies this particular write command and can be used to query or queue a wait for this particular command to complete. 
    // event can be NULL in which case it will not be possible for the application to query the status of this command or queue a wait for this command to complete. 
    // If the event_wait_list and the event arguments are not NULL, the event argument should not refer to an element of the event_wait_list array. 
    //  
    // errcode_ret will return an appropriate error code.If errcode_ret is NULL, no error code is returned. 

    err = clEnqueueUnmapMemObject(commands, buffer_inputA_progressive, buffer_inputA_progressive_out, 0, NULL, NULL);

    if (err != CL_SUCCESS)
    {
        printf("Error: Failed to unmap buffer buffer_inputA_progressive\n");
        return EXIT_FAILURE;
    }

    clReleaseMemObject(buffer_inputA_progressive);

    printf("Read(Map/Unmap) buffer buffer_outputB_progressive\n");
    void *buffer_outputB_progressive_out = clEnqueueMapBuffer(commands, buffer_outputB_progressive, true, MapFlags, 0, bufferSize_outputB_progressive, 0, NULL, NULL, &err);
    if (err != CL_SUCCESS)
    {
        printf("Error: Failed to map buffer buffer_outputB_progressive\n");
        return EXIT_FAILURE;
    }

    std::ofstream outFilebuffer_outputB_progressive_out("buffer_outputB_progressive_out.bin", std::ios::out | std::ios::binary);
    if (!outFilebuffer_outputB_progressive_out.is_open())
    {
        printf("Could not open output file for write");
    }
    else
    {
        outFilebuffer_outputB_progressive_out.write((char*) buffer_outputB_progressive_out, bufferSize_outputB_progressive);
        outFilebuffer_outputB_progressive_out.close();
    }
    printf("buffer_outputB_progressive buffer was dumped to buffer_outputB_progressive_out.bin\n");
    err = clEnqueueUnmapMemObject(commands, buffer_outputB_progressive, buffer_outputB_progressive_out, 0, NULL, NULL);

    if (err != CL_SUCCESS)
    {
        printf("Error: Failed to unmap buffer buffer_outputB_progressive\n");
        return EXIT_FAILURE;
    }

    clReleaseMemObject(buffer_outputB_progressive);

    printf("Output validation: ");
    if(verifyOutput("buffer_outputB_progressive_out.bin", "C:\\Users\\quincywu\\Documents\\GitHub\\ee590-opencl\\hw3\\hw3_part1\\bin_ref_outputB_progressive0.bin"))
    {
        printf("true\n");
    }
    else
    {
        printf("false\n");
    }

	//timing and verification
	LARGE_INTEGER perfFrequency;
	LARGE_INTEGER performanceCountNDRangeStart;
	LARGE_INTEGER performanceCountNDRangeStop;

	cl_float* inputA = (float*)bufferData_0;
	cl_float* result = (cl_float*)_aligned_malloc(4096 * sizeof(cl_float), 4096);
	float tmp = 0;

	QueryPerformanceCounter(&performanceCountNDRangeStart);
	for (unsigned int i = 0; i < 4096; ++i) //arraysize (4096,0,0)
	{
		tmp = 0;
		for (unsigned int j = 0; j < i; j++)
		{
			tmp += inputA[j];
		}
		result[i] = tmp + inputA[i];

	}

	QueryPerformanceCounter(&performanceCountNDRangeStop);
	QueryPerformanceFrequency(&perfFrequency);
	float outputtime = 1000.0f*(float)(performanceCountNDRangeStop.QuadPart - performanceCountNDRangeStart.QuadPart) / (float)perfFrequency.QuadPart;

	LogInfo("\n Running time for sequential is %f ms.\n", outputtime);

	tmp = 0;
	QueryPerformanceCounter(&performanceCountNDRangeStart);
	for (unsigned int i = 0; i < 4096; ++i) //arraysize (4096,0,0)
	{
		result[i] = tmp + inputA[i];
		tmp = result[i];
	}

	QueryPerformanceCounter(&performanceCountNDRangeStop);
	QueryPerformanceFrequency(&perfFrequency);
	outputtime = 1000.0f*(float)(performanceCountNDRangeStop.QuadPart - performanceCountNDRangeStart.QuadPart) / (float)perfFrequency.QuadPart;

	LogInfo("\n Running time for sequential is %f ms.\n", outputtime);

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
    errno_t err; 
    FILE *file; 
    err = fopen_s(&file, file_name, "rb");  
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

