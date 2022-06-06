//
//  Cube.swift
//  InverseTriangulation
//
//  Created by Ertem Biyik on 05.06.2022.
//

import MetalKit

struct Cube: Transformable {
    
    var vertices: [Float] = [
         -1,  1,  1,
         -1, -1,  1,
          1, -1,  1,
          1,  1,  1,
         
         -1,  1, -1,
         -1, -1, -1,
          1, -1, -1,
          1,  1, -1
    ]
    
    var indices: [UInt16] = [
        0,1,2,  0,2,3, // Front
        4,5,7,  4,6,7, // Back
        4,1,0,  4,1,5, // Left
        7,2,3,  7,2,6, // Right
        4,0,3,  4,3,7, // Top
        2,5,1,  2,5,6  // Bottom
    ]
    
    var colors: [simd_float3] = [
        [1, 0, 0], // red
        [0, 1, 0], // green
        [0, 0, 1], // blue
        [1, 1, 0]  // yellow
    ]
    
    let indexBuffer: MTLBuffer
    
    let vertexBuffer: MTLBuffer
    
    let colorBuffer: MTLBuffer
    
    var transform = Transform()
    
    init(device: MTLDevice) {
        
        guard let vertexBuffer = device.makeBuffer(
            bytes: &vertices,
            length: MemoryLayout<Float>.stride * vertices.count,
            options: []) else {
            fatalError("Unable to create cube vertex buffer")
        }
        
        self.vertexBuffer = vertexBuffer
        
        guard let indexBuffer = device.makeBuffer(
            bytes: &indices,
            length: MemoryLayout<UInt16>.stride * indices.count,
            options: []) else {
            fatalError("Unable to create cube index buffer")
        }
        
        self.indexBuffer = indexBuffer
        
        guard let colorBuffer = device.makeBuffer(
            bytes: &colors,
            length: MemoryLayout<simd_float3>.stride * indices.count,
            options: []) else {
            fatalError("Unable to create cube color buffer")
        }
        
        self.colorBuffer = colorBuffer
    }
}

extension Cube {
    func render(encoder: MTLRenderCommandEncoder) {
        
        // vertex buffer
        encoder.setVertexBuffer(
            vertexBuffer,
            offset: 0,
            index: 0)
        
        // color buffer
        encoder.setVertexBuffer(
            colorBuffer,
            offset: 0,
            index: 1)
        
        encoder.drawIndexedPrimitives(
            type: .triangle,
            indexCount: indices.count,
            indexType: .uint16,
            indexBuffer: indexBuffer,
            indexBufferOffset: 0)
    }
}
