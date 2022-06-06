//
//  Common.h
//  MetalGraphicEngine
//
//  Created by Ertem Biyik on 06.06.2022.
//

#ifndef Common_h
#define Common_h
#import <simd/simd.h>

typedef struct {
    matrix_float4x4 modelMatrix;
    matrix_float4x4 viewMatrix;
    matrix_float4x4 projectionMatrix;
    
} Uniforms;


#endif /* Common_h */
