/*****************************************************************************
 * Copyright (c) 2013-2016 Intel Corporation
 * All rights reserved.
 *
 * WARRANTY DISCLAIMER
 *
 * THESE MATERIALS ARE PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
 * "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
 * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
 * A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL INTEL OR ITS
 * CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
 * EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
 * PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR
 * PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY
 * OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY OR TORT (INCLUDING
 * NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THESE
 * MATERIALS, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 *
 * Intel Corporation is the author of the Materials, and requests that all
 * problem reports or change requests be submitted to it directly
 *****************************************************************************/

// TODO: define host-side struct
struct s1 {
	cl_int2 ui2;
	cl_float4 fl4;
	cl_char8 ch8;
};

struct point {
	cl_float2 location; // X, Y
	cl_uint category;
};

struct ref_point {
	struct point p;
	cl_float dist;
	//cl_int order;
};

inline bool operator==(const point& p1, const point& p2) {
	return (p1.category == p2.category) && (p1.location.x == p2.location.x) && (p1.location.y == p2.location.y);
}

inline bool operator!=(const point& p1, const point& p2) {
	return !(p1 == p2);
}


// get platform id of Intel OpenCL platform 
cl_platform_id get_intel_platform();

// read the kernel source code from a given file name 
char* read_source(const char *file_name);

// print the build log in case of failure 
void build_fail_log(cl_program, cl_device_id);

// read binary content 
int ReadBinaryFile(const std::string filename, char** data, bool isSVM = false);

void generateInput(cl_float4* inputArray, cl_uint arrayWidth, cl_uint arrayHeight);

void generatetestPointsLocation(point* inputArray, cl_uint arrayWidth, cl_uint arrayHeight);

void generateRefPoints(ref_point* inputArray, cl_uint arrayWidth, cl_uint arrayHeight);

cl_float my_dist(const cl_float2& pointA, const cl_float2& pointB);

void calc_distance(ref_point* refpoints, point const& pointB, int ref_size);

void swap(ref_point& a, ref_point& b);

void printArray(ref_point* & a, int count);

void printArray(point* & a, int count);

void bitonicSort(ref_point* refpoints, int ref_size);

void oddeven_sort(ref_point* refpoints, int ref_size);

cl_uint majority(ref_point* ref_data);

bool seq_ref_code(point* resultPtr, ref_point* ref_point_data, point* test_point_data, const int ref_point_size, const int test_point_size);

