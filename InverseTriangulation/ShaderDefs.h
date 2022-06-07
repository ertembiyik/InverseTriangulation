//
//  ShaderDefs.h
//  InverseTriangulation
//
//  Created by Ertem Biyik on 07.06.2022.
//

#ifndef ShaderDefs_h
#define ShaderDefs_h

#include <metal_stdlib>
using namespace metal;

struct VertexOut {
  float4 position [[position]];
  float3 normal;
};

#endif /* ShaderDefs_h */
