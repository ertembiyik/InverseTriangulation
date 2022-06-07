//
//  Shaders.metal
//  InverseTriangulation
//
//  Created by Ertem Biyik on 05.06.2022.
//

#include <metal_stdlib>
#import "Common.h"
#import "ShaderDefs.h"
using namespace metal;

struct VertexIn {
    float4 position [[attribute(0)]];
    float3 normal [[attribute(1)]];
//    float4 color [[attribute(1)]];
};

//struct VertexOut {
//    float4 position [[position]];
//    float4 color;
//    float3 normal;
//    float pointSize [[point_size]];
//};

vertex VertexOut vertex_main(VertexIn in [[stage_in]], constant Uniforms &uniforms [[buffer(11)]]) {
    
    float4 position =
    uniforms.projectionMatrix * uniforms.viewMatrix
    * uniforms.modelMatrix * in.position;
    
    VertexOut out {
        .position = position,
//        .color = in.color
        .normal = in.normal
    };
    
    return out;
}

fragment float4 fragment_main(constant Params &params [[buffer(12)]], VertexOut in [[stage_in]]) {
    // MARK: Make it colored by the colors from buffer
    // return in.color;

    // MARK: Color half of the screen
//    float color = step(params.width * 0.5, in.position.x);
//
//    return float4(color, color, color, 1);
    
    // MARK: Make a chess-like color
//    uint checks = 8;
//    // 1
//    float2 uv = in.position.xy / params.width;
//    // 2
//    uv = fract(uv * checks * 0.5) - 0.5;
//    // 3
//    float3 color = step(uv.x * uv.y, 0.0);
//    return float4(color, 1.0);
    
    // MARK: smooth gradient
//    float color = smoothstep(0, params.width, in.position.x);
//    return float4(color, color, color, 1);
    
    // MARK: mixing colors
//    float3 red = float3(1, 0, 0);
//    float3 blue = float3(0, 0, 1);
//    float3 color = mix(red, blue, 0.3);
//    return float4(color, 1);
    
//    float3 color = normalize(in.position.xyz);
//    return float4(color, 1);
    
//    return float4(in.normal, 1);
    
    float4 sky = float4(0.34, 0.9, 1.0, 1.0);
    float4 earth = float4(0.29, 0.58, 0.2, 1.0);
    float intensity = in.normal.y * 0.5 + 0.5;
    return mix(earth, sky, intensity);
}
