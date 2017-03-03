#include<stdio.h>    
#include<string.h>   
#include<math.h>   
#include<ctype.h>   
#include<stdbool.h> 

float distance (float2 const& pointA, float2 const& pointB) { 
	// for 2D space (also has a built in function distance)
	return (float2)((float)sqrt((pointA.x - pointB.x) * (pointA.x - pointB.x)), (float)sqrt((pointA.y - pointB.y) * (pointA.y - pointB.y)) );
}

 

void swap(float& a, float&b) { //by ref
	float temp = a;
	a = b;
	b = temp;
}

void printArray(float a[], int count) {
	int i; 
	for (i = 0; i < count; ++i) {
		printf("%d ", a[i]);
	}
	printf('\n');
}

// iterative odd-even sort
void oddeven_sort(float a[], int size) {
	bool sorted = false; 
	while(!sorted) {
		sorted = true;
		int i;
		for(i = 1; i < size - 1; i+=2) {
			if (a[i] > a[i+1]) {
				swap(a[i], a[i+1]);
				sorted = false;
			}
		}
		
		for (i = 0; i < size - 1; i+=2) {
			if (a[i] > a[i+1]) {
				swap(a[i], a[i+1]);
				sorted = false;
			}
		}
	}
}

// iterative bitonic sort (batcher odd-even mergesort (OpencL Parallel Programming Development Cookbook by Raymond Tay)
void merge_iterative (int a[], int l, int r){
	int i, j, k, p, N = r -l+1;
	for(p = 1; p < N; p += p)
		for(k = p; k > 0; k /=2)
			for(j = k%p; j +k < N; j += (k+k))
				for(i = 0; i < k; i++)
					if(j+i+k < N)
						if((j+i)/(p+p) == (j+i+k)/(p+p))
							if(a[l+j+i] > a[l+j+i+k]) //compareXchange
								swap(a[l+j+i], a[l+j+i+k]);
}

// recurssive odd-even merge sort
void oddEvenMergeSort (int lo, int n) {
	if (n > 1) {
		int m = n/2;
		oddEvenMergeSort (lo, m);
		oddEvenMergeSort (lo+m, m);
		oddEvenMerge (lo, n, 1);
	}
}

/*
*  lo is starting pos
*  n is length of piece to merge
*  r is distance of elements to compare
*/
void oddEvenMerge (int lo, int n, int r) {
	int m = r * 2;
	if (m < n) {
		oddEvenMerge(lo, n, m); //even
		oddEvenMerge(lo + r, n, m); //odd
		for (int i = lo + r; i + r < lo + n; i+=m) {
			if (a[i] > a[i+r]) {
				swap(a[i], a[i+r]);
			}
		}
	} else {
		if (a[lo] > a[lo+r]) {
			swap(a[lo], a[lo+r]);
		}
	}
}

// 