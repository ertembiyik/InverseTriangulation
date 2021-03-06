//
//  VertexDescriptor.swift
//  InverseTriangulation
//
//  Created by Ertem Biyik on 05.06.2022.
//

import MetalKit

extension MTLVertexDescriptor {
    static var defaultLayout: MTLVertexDescriptor {
        let vertexDescriptor = MTLVertexDescriptor()
        vertexDescriptor.attributes[0].format = .float3
        vertexDescriptor.attributes[0].offset = 0
        vertexDescriptor.attributes[0].bufferIndex = 0
        
        var stride = MemoryLayout<Float>.stride * 3
        vertexDescriptor.layouts[0].stride = stride
        
//        vertexDescriptor.attributes[1].format = .float3
//        vertexDescriptor.attributes[1].offset = 0
//        vertexDescriptor.attributes[1].bufferIndex = 1
//        vertexDescriptor.layouts[1].stride =
//          MemoryLayout<simd_float3>.stride
        
        vertexDescriptor.attributes[1].format = .float3
        vertexDescriptor.attributes[1].offset = 0
        vertexDescriptor.attributes[1].bufferIndex = 1
        
        stride = MemoryLayout<float3>.stride
        vertexDescriptor.layouts[1].stride = stride

        return vertexDescriptor
    }
}

