# cuda-vec-add

A simple CUDA application which loads two arrays from memory on the host machine into an NVIDIA graphics card. Performs element-wise addition and writes the result back to host memory. The number of blocks distributed across the device scales with the size of the arrays.

## Compilation
1. Install NVIDIA tool-kit and appropriate drivers for your device.
2. Compile with ```./build.sh```, might need to ```chmod +x build.sh```.
3. Run: ```./out/main```.
