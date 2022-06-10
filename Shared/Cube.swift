//
//  Cube.swift
//  InverseTriangulation
//
//  Created by Ertem Biyik on 05.06.2022.
//

import MetalKit

struct Cube: Transformable {
    
    //    var vertices: [Float] = [
    //
    //        0, 1, 1,  // 0
    //        0, 0, 1, // 1
    //        1, 0, 1, // 2
    //        1, 1, 1, // 3
    //
    //        0, 1, 0, // 4
    //        0, 0, 0, // 5
    //        1, 0, 0, // 6
    //        1, 1, 0  // 7
    //    ]
    //
    //    var indices: [UInt16] = [
    //        0,2,1,  0,2,3, // Front
    //        4,5,6,  4,6,7, // Back
    //
    //        4,1,0,  4,1,5, // Left
    //        7,2,3,  7,2,6, // Right
    //
    //        4,0,3,  4,3,7, // Top
    //        2,5,1,  2,5,6  // Bottom
    //    ]
    
    struct Vert {
        let x: Float
        let y: Float
        let z: Float
        
        var arr: [Float] {
            return [x, y, z]
        }
    }
    
    
    static var vertices: [Vert] = [
        .init(x: 0, y: 1, z: 1),
        .init(x: 0, y: 0, z: 1),
        .init(x: 1, y: 0, z: 1),
        .init(x: 1, y: 1, z: 1),
        
        .init(x: 0, y: 1, z: 0),
        .init(x: 0, y: 0, z: 0),
        .init(x: 1, y: 0, z: 0),
        .init(x: 1, y: 1, z: 0)
    ]
    
    
    var vertices2: [Float] = {
        var arr: [Float] = []
        
        arr.append(contentsOf:  pointBetweenTwoDots(firstDot: vertices[0].arr, secondDot: vertices[1].arr))
        arr.append(contentsOf:  pointBetweenTwoDots(firstDot: vertices[1].arr, secondDot: vertices[2].arr))
        arr.append(contentsOf:  pointBetweenTwoDots(firstDot: vertices[2].arr, secondDot: vertices[3].arr))
        arr.append(contentsOf:  pointBetweenTwoDots(firstDot: vertices[3].arr, secondDot: vertices[0].arr))
        
        arr.append(contentsOf:  pointBetweenTwoDots(firstDot: vertices[4].arr, secondDot: vertices[5].arr))
        arr.append(contentsOf:  pointBetweenTwoDots(firstDot: vertices[5].arr, secondDot: vertices[6].arr))
        arr.append(contentsOf:  pointBetweenTwoDots(firstDot: vertices[6].arr, secondDot: vertices[7].arr))
        arr.append(contentsOf:  pointBetweenTwoDots(firstDot: vertices[7].arr, secondDot: vertices[4].arr))
        
        arr.append(contentsOf:  pointBetweenTwoDots(firstDot: vertices[0].arr, secondDot: vertices[4].arr))
        arr.append(contentsOf:  pointBetweenTwoDots(firstDot: vertices[1].arr, secondDot: vertices[5].arr))
        arr.append(contentsOf:  pointBetweenTwoDots(firstDot: vertices[3].arr, secondDot: vertices[7].arr))
        arr.append(contentsOf:  pointBetweenTwoDots(firstDot: vertices[2].arr, secondDot: vertices[6].arr))
        
        //        [0.0, 0.5, 1.0, 0.5, 0.0, 1.0, 1.0, 0.5, 1.0, 0.5, 1.0, 1.0, 0.0, 0.5, 0.0, 0.5, 0.0, 0.0, 1.0, 0.5, 0.0, 0.5, 1.0, 0.0, 0.0, 1.0, 0.5, 0.0, 0.0, 0.5, 1.0, 1.0, 0.5, 1.0, 0.0, 0.5]
        
        print(arr)
        return arr
    }()
    
    var indices2: [UInt16] = [
        
        0, 1, 2,   2, 3, 0,
        4, 5, 6,   6, 7, 4,
        
        4, 9, 0,   0, 8, 4,
        2, 11, 6,  6, 10, 2,
        
        9, 5, 11,  11, 1, 9,
        8, 7, 10,  10, 3, 8,
        
        0, 1, 9,
        1, 2, 11,
        6, 11, 5,
        5, 4, 9,
        
        0, 8, 3,
        3, 10, 2,
        10, 6, 7,
        7, 4, 8
        
    ]
    
    // var indices: [UInt16] = [
    //        0,2,1,  0,2,3, // Front
    //        4,5,6,  4,6,7, // Back
    //
    //        4,1,0,  4,1,5, // Left
    //        7,2,3,  7,2,6, // Right
    //
    //        4,0,3,  4,3,7, // Top
    //        2,5,1,  2,5,6  // Bottom
    //    ]
    
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
            bytes: &vertices2,
            length: MemoryLayout<Float>.stride * vertices2.count,
            options: []) else {
            fatalError("Unable to create cube vertex buffer")
        }
        
        self.vertexBuffer = vertexBuffer
        
        guard let indexBuffer = device.makeBuffer(
            bytes: &indices2,
            length: MemoryLayout<UInt16>.stride * indices2.count,
            options: []) else {
            fatalError("Unable to create cube index buffer")
        }
        
        self.indexBuffer = indexBuffer
        
        guard let colorBuffer = device.makeBuffer(
            bytes: &colors,
            length: MemoryLayout<simd_float3>.stride * colors.count,
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
            indexCount: indices2.count,
            indexType: .uint16,
            indexBuffer: indexBuffer,
            indexBufferOffset: 0)
    }
}
