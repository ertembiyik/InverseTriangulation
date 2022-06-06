//
//  Renderer.swift
//  InverseTriangulation
//
//  Created by Ertem Biyik on 04.06.2022.
//

import MetalKit

class Renderer: NSObject {
    
    static var device: MTLDevice!
    static var commandQueue: MTLCommandQueue!
    static var library: MTLLibrary!
    var vertexBuffer: MTLBuffer!
    var pipelineState: MTLRenderPipelineState!
    var timer: Float = 0
    var uniforms = Uniforms()
    
    lazy var cube: Cube = {
        Cube(device: Renderer.device)
    }()
    
    init(metalView: MTKView) {
        
        guard let device = MTLCreateSystemDefaultDevice(), let commandQueue = device.makeCommandQueue() else {
            fatalError("GPU not available")
        }
        
        Renderer.device = device
        Renderer.commandQueue = commandQueue
        metalView.device = device
        
        let library = device.makeDefaultLibrary()
        Self.library = library
        let vertexFunction = library?.makeFunction(name: "vertex_main")
        let fragmentFunction =
        library?.makeFunction(name: "fragment_main")
        
        // create the pipeline state object
        let pipelineDescriptor = MTLRenderPipelineDescriptor()
        pipelineDescriptor.vertexFunction = vertexFunction
        pipelineDescriptor.fragmentFunction = fragmentFunction
        pipelineDescriptor.colorAttachments[0].pixelFormat =
        metalView.colorPixelFormat
        pipelineDescriptor.vertexDescriptor =
        MTLVertexDescriptor.defaultLayout
        
        do {
            pipelineState =
            try device.makeRenderPipelineState(
                descriptor: pipelineDescriptor)
        } catch let error {
            fatalError(error.localizedDescription)
        }
        
        super.init()
        
        // background color
        metalView.clearColor = MTLClearColor(
            red: 1.0,
            green: 1.0,
            blue: 0.8,
            alpha: 1.0)
        
        metalView.delegate = self
        
        uniforms.viewMatrix = float4x4(translation: [0.8, 0, 0]).inverse
        
        mtkView(metalView, drawableSizeWillChange: metalView.bounds.size)
    }
}

extension Renderer: MTKViewDelegate {
    
    func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {
        let aspect =
        Float(view.bounds.width) / Float(view.bounds.height)
        let projectionMatrix =
        float4x4(
            projectionFov: Float(150).degreesToRadians,
            near: 0.1,
            far: 100,
            aspect: aspect)
        uniforms.projectionMatrix = projectionMatrix
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
        uniforms.viewMatrix = float4x4(translation: [0,0,-3]).inverse
        cube.position.y = -0.6
        cube.rotation.y = tan(timer)
        uniforms.modelMatrix = cube.transform.modelMatrix
        
        renderEncoder.setVertexBytes(
            &uniforms,
            length: MemoryLayout<Uniforms>.stride,
            index: 11)
        
        renderEncoder.setRenderPipelineState(pipelineState)
        
        cube.render(encoder: renderEncoder)
        
        renderEncoder.endEncoding()
        guard let drawable = view.currentDrawable else {
            return
        }
        commandBuffer.present(drawable)
        commandBuffer.commit()
        
    }
    
}
