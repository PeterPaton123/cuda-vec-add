#include <iostream>
#include <cuda.h>
#include <stdlib.h>
#include <ctime>

__global__ void AddInts(int *a, int *b, int count) {
  // Get the thread id
  int id = blockIdx.x * blockDim.x + threadIdx.x;
  if (id < count) {
    a[id] += b[id];
  }
}

int main() {
  std::srand(time(NULL));
  int count = 1000;
  
  // Array a and b stored on host, hence h_a
  int *h_a = new int[count];
  int *h_b = new int[count];
  int *h_c = new int[count];

  for (int i = 0; i < count; i++) {
    h_a[i] = std::rand() % 1000;
    h_b[i] = std::rand() % 1000;
  }
  
  for(int i = 0; i < 5; i++) {
    std::cout << h_a[i] << " " << h_b[i] << std::endl;
  }

  // Array a and b stored on device, hence d_a
  int *d_a, *d_b;

  if (cudaMalloc(&d_a, sizeof(int) * count) != cudaSuccess) {
    std::cout << "CUDA Malloc failed" << std::endl;
    return -1;  
  }
  
  if (cudaMalloc(&d_b, sizeof(int) * count) != cudaSuccess) {
    cudaFree(d_a);    
    std::cout << "CUDA Malloc failed" << std::endl;
    return -1;  
  }

  if (cudaMemcpy(d_a, h_a, sizeof(int) * count, cudaMemcpyHostToDevice) != cudaSuccess or cudaMemcpy(d_b, h_b, sizeof(int) * count, cudaMemcpyHostToDevice) != cudaSuccess){
    std::cout << "Could not copy" << std::endl;
    cudaFree(d_a);
    cudaFree(d_b);
  }
  

  AddInts<<<count / 256 + 1, 256>>>(d_a, d_b, count);
  
  if (cudaMemcpy(h_c, d_a, sizeof(int) * count, cudaMemcpyDeviceToHost) != cudaSuccess) {
    std::cout << "Copy back to host from device failed!" << std::endl;
    delete []h_a;
    delete []h_b; 
    cudaFree(d_a);
    cudaFree(d_b);
  }
  
  for(int i = 0; i < 10; i++) {
    std::cout << h_a[i] << " + " << h_b[i] << " = " << h_c[i] << std::endl;
  }
 
  return 0;
}
