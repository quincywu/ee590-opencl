/*****************************************************************************
 * Copyright (c) 2013-2014 Intel Corporation
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
 __kernel void whoami(__global int* pA, __global int* pB, __global int* pC)
{ 
	const int gx     = get_global_id(0);
    const int gy     = get_global_id(1);
    const int gwidthx = get_global_size(0);
    const int gwidthy = get_global_size(1);
    const int lszx = get_local_size(0);
    const int lszy = get_local_size(1);

	const int lx     = get_local_id(0);
    const int ly     = get_local_id(1);
	const int grpx     = get_group_id(0);
    const int grpy     = get_group_id(1);

	printf("work-item: global_id(0)=%u, global_id(1)=%u, global_size(0)=%u, global_size(1)=%u, local_size(0)=%u, local_size(1)=%u, local_id(0)=%u, local_id(1)=%u, group_id(0)=%u, group_id(1)=%u\n", gx,gy,gwidthx,gwidthy,lszx,lszy,lx,ly,grpx,grpy);
}

 // Arithmetic Intensity <= 1/4
 __kernel void Add(__global int* pA, __global int* pB, __global int* pC)
{
    const int x     = get_global_id(0);
    const int y     = get_global_id(1);
    const int width = get_global_size(0);

    const int id = y * width + x;

    pC[id] = pA[id] + pB[id];
}

// C = A*B : matrix multiplication, assume A, B, C all NxN
// Arithmetic Intensity <= N/6
__kernel void MMULT(__global int* pA, __global int* pB, __global int* pC)
{
    const int x     = get_global_id(0);
    const int y     = get_global_id(1);
    const int width = get_global_size(0);

    const int id = y * width + x;

//	__local int tempArow[1024] = 
//	__local int tempBcol[1024]

	//int itemp = 0;		// use private memory (EU thread register)
	// __global int itemp[1];  // use global memory
	__local int itemp;	// use local memory (SLM)
	itemp = 0;
	for(int k = 0; k<width; k++)
	{ 
		itemp += pA[y*width+k]*pB[k*width+x];
	}
    pC[id] = itemp;
}