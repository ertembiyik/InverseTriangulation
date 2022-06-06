//
//  Shaders.metal
//  MetalGraphicEngine
//
//  Created by Ertem Biyik on 05.06.2022.
//

#include <metal_stdlib>
#import "Common.h"
using namespace metal;

struct VertexIn {
    float4 position [[attribute(0)]];
    float4 color [[attribute(1)]];
};

struct VertexOut {
    float4 position [[position]];
    float4 color;
    float pointSize [[point_size]];
};

#include <metal_stdlib>
using namespace metal;


vertex VertexOut vertex_main(
                             VertexIn in [[stage_in]],
                             constant Uniforms &uniforms [[buffer(11)]])
{
    float4 position =
    uniforms.projectionMatrix * uniforms.viewMatrix
    * uniforms.modelMatrix * in.position;
    
    VertexOut out {
        .position = position,
        .color = in.color
    };
    return out;
}

fragment float4 fragment_main(VertexOut in [[stage_in]]) {
  return in.color;
}
