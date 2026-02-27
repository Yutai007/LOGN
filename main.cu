#include <stdio.h>
#include <cuda_runtime.h>

__global__
void sort(int* input, int* output, int n) {
    int i = blockIdx.x * blockDim.x + threadIdx.x;
    if (i >= n) return;
    int rank = 0;
    for (int j = 0; j < n; j++) {
        if (input[j] < input[i] ||
           (input[j] == input[i] && j < i)) {
            rank++;
        }
    }
    output[rank] = input[i];
}

int main() {
    const int n = 5;
    int h_input[n]  = {1, 5, 2, 1, 0};
    int h_output[n];
    int *d_input, *d_output;
    cudaMalloc(&d_input,  n * sizeof(int));
    cudaMalloc(&d_output, n * sizeof(int));
    cudaMemcpy(d_input, h_input, n * sizeof(int), cudaMemcpyHostToDevice);
    int threadsPerBlock = 64; // Can be scaled with n to keep span O(log n)
    int blocks = (n + threadsPerBlock - 1) / threadsPerBlock;
    sort<<<blocks, threadsPerBlock>>>(d_input, d_output, n);
    cudaMemcpy(h_output, d_output, n * sizeof(int), cudaMemcpyDeviceToHost);
    for (int i = 0; i < n; i++)
        printf("%d ", h_output[i]);
    printf("\n");
    cudaFree(d_input);
    cudaFree(d_output);
    return 0;
}