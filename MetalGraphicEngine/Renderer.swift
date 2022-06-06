//
//  Renderer.swift
//  MetalGraphicEngine
//
//  Created by Ertem Biyik on 04.06.2022.
//

import MetalKit

class Renderer: NSObject {
    
    static var device: MTLDevice!
    static var commandQueue: MTLCommandQueue!
    static var library: MTLLibrary!
    var mesh: MTKMesh!
    var vertexBuffer: MTLBuffer!
    var pipelineState: MTLRenderPipelineState!
    var timer: Float = 0
    
    
    lazy var quad: Quad = {
      Quad(device: Renderer.device, scale: 0.8)
    }()
    
    init(metalView: MTKView) {
        guard let device = MTLCreateSystemDefaultDevice(), let commandQueue = device.makeCommandQueue() else {
            fatalError("GPU not available")
        }
        
        Renderer.device = device
        Renderer.commandQueue = commandQueue
        metalView.device = device
        
        let allocator = MTKMeshBufferAllocator(device: device)
        let size: Float = 0.8
        let mdlMesh = MDLMesh(
          boxWithExtent: [size, size, size],
          segments: [1, 1, 1],
          inwardNormals: false,
          geometryType: .triangles,
          allocator: allocator)
        
        do {
          mesh = try MTKMesh(mesh: mdlMesh, device: device)
        } catch {
          print(error.localizedDescription)
        }
        
        vertexBuffer = mesh.vertexBuffers[0].buffer
        
        let library = device.makeDefaultLibrary()
        Renderer.library = library
        let vertexFunction = library?.makeFunction(name: "vertex_main")
        let fragmentFunction =
          library?.makeFunction(name: "fragment_main")
        
        // create the pipeline state object
        let pipelineDescriptor = MTLRenderPipelineDescriptor()
        pipelineDescriptor.vertexFunction = vertexFunction
        pipelineDescriptor.fragmentFunction = fragmentFunction
        pipelineDescriptor.colorAttachments[0].pixelFormat =
          metalView.colorPixelFormat
        
        do {
          pipelineState =
            try device.makeRenderPipelineState(
              descriptor: pipelineDescriptor)
        } catch let error {
          fatalError(error.localizedDescription)
        }
        
        super.init()
        
        metalView.clearColor = MTLClearColor(
          red: 1.0,
          green: 1.0,
          blue: 0.8,
          alpha: 1.0)
        
        metalView.delegate = self
    }
    
    func createMesh(device: inout MTLDevice) {
        
    }
}

extension Renderer: MTKViewDelegate {
    
    func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {
        
    }
    
    func draw(in view: MTKView) {
        guard
          let commandBuffer = Renderer.commandQueue.makeCommandBuffer(),
          let descriptor = view.currentRenderPassDescriptor,
          let renderEncoder =
            commandBuffer.makeRenderCommandEncoder(
              descriptor: descriptor) else {
            return
        }
        
        timer += 0.005
        var currentTime = sin(timer)
        
        renderEncoder.setVertexBytes(
          &currentTime,
          length: MemoryLayout<Float>.stride,
          index: 11)
        
        var dots = 50
        
        renderEncoder.setVertexBytes(&dots,
                                     length: MemoryLayout<Int>.stride,
                                     index: 0)
        
        renderEncoder.setRenderPipelineState(pipelineState)
        
        renderEncoder.drawPrimitives(type: .point,
                                     vertexStart: 0,
                                     vertexCount: 50)

        renderEncoder.endEncoding()
        
        guard let drawable = view.currentDrawable else {
          return
        }
        
        commandBuffer.present(drawable)
        commandBuffer.commit()
        
    }
    
}
