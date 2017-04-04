#pragma once

//////////////////////////////////////////////////////
float sumBase(__global float *input, uint count)
{
  float ret = 0.0f;
  for (uint i = 0; i < count; ++i) {
    ret += input[i];
  }
  return ret;
}

__kernel void sum(                                                    
   __global float* input, 
   __global float* output,
   const uint count)
{
  float ret = sumBase(input, count);
  (*output) = ret;
}                                      

__kernel void sum_size_t(                                                    
   __global uint* input, 
   __global uint* output,
   const uint count)
{
  uint ret = 0;
  for (uint i = 0; i < count; ++i) {
    ret += input[i];
  }
  (*output) = ret;
}                                      

//////////////////////////////////////////////////////

__kernel void gCopyRows(
	__global float* out, 
	__global const float* in, 
	const uint cols,
  __global const uint* targetRowIdx,
  const uint numPairs) 
{
  for (uint j = 0; j < numPairs; ++j) {
    uint srcId = targetRowIdx[j];    
    __global float *rowOut = out + j * cols;

    uint inOffset =  srcId * cols;
    __global const float *rowIn = in + inOffset;
    
  	for (uint i = 0; i < cols; ++i) {
       //rowOut[i] = srcId;  	
       float f = rowIn[i];
       rowOut[i] = f;
  	}

    //const float f = cols;
    //rowOut[0] = f;
    
  }
  
}
  
//////////////////////////////////////////////////////
  
__kernel void transpose(
  __global float* out, 
  __global const float* in, 
  const uint rows,
  const uint cols)
{
  uint i = 0;
  for (uint row = 0; row < rows; ++row) {
    for (uint col = 0; col < cols; ++col) {
      float v = in[i];
      
      //uint outInd = row * cols + col;
      uint outInd = col * rows + row;
      out[outInd] = v;
      
      ++i;
    }
  }
}

//////////////////////////////////////////////////////

__kernel void prod(
  __global float* C, 
  __global const float* A, 
  __global const float* B, 
  const uint rowsA,
  const uint colsA,
  const uint rowsB,
  const uint colsB)
{
  for (uint rowA = 0; rowA < rowsA; ++rowA) {
    for (uint colB = 0; colB < colsB; ++colB) {
      float sum = 0;
      
      for (uint colA = 0; colA < colsA; ++colA) {
        float valA = A[rowA * colsA + colA];
        float valB = B[colA * colsB + colB];
        sum += valA * valB;
      }
      
      C[rowA * colsB + colB] = sum; 
    }
  }
  
}

//////////////////////////////////////////////////////

__kernel void gElementwiseOps(__global float* out,
                                __global const float* state,
                                __global const float* ruh,
                                __global const float* t,
                                __global const float* b,
                                __global const float* bx1,
                                __global const float* bx2,
                                uint rows, uint cols) 
{

}

//////////////////////////////////////////////////////

__kernel void gBroadcastVecAdd(__global float* out, 
                              __global const float* in, 
                              uint rows, uint cols) 
{
  for (uint noColumn = 0; noColumn < cols; ++noColumn) {
    float vecValue = in[noColumn];
  
    uint index = noColumn;
    for (uint noRow = 0; noRow < rows; ++noRow) {
        out[index] += vecValue;
        index += cols;
    }
  
  }

}

__kernel void gLogit(__global float* out, 
                     __global const float* in, 
                     uint rows, uint cols) 
{
  uint i = 0;
  
  for (uint noColumn = 0; noColumn < cols; ++noColumn) {
    for (uint noRow = 0; noRow < rows; ++noRow) {
      float p = out[i] + in[i];
      out[i] = 1.0f / (1.0f + exp(-p));
      ++i;
    }
  }
  
  //out[i-1] = i - 1; // - log(1/p - 1);
}                                