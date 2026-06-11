import Metal
import QuartzCore

// Mode constants — must match Shaders.metal
private let kModeFullField:  UInt32 = 0
private let kModeSplitQuad:  UInt32 = 1
private let kModeStripeH:    UInt32 = 2
private let kModeStripeV:    UInt32 = 3
private let kModeGrayWedge:  UInt32 = 4
private let kModePatches:    UInt32 = 5

// Memory layout must match `struct RenderParams` in Shaders.metal (80 bytes).
struct RenderParams {
    var color0: (Float, Float, Float, Float)
    var color1: (Float, Float, Float, Float)
    var color2: (Float, Float, Float, Float)
    var color3: (Float, Float, Float, Float)
    var mode:        UInt32
    var stripeCount: UInt32
    var wedgeSteps:  UInt32
    var pad:         UInt32 = 0
}

final class MetalRenderer {
    private let device:        MTLDevice
    private let commandQueue:  MTLCommandQueue
    private let pipelineState: MTLRenderPipelineState

    init?() {
        guard
            let dev   = MTLCreateSystemDefaultDevice(),
            let queue = dev.makeCommandQueue(),
            let lib   = try? dev.makeDefaultLibrary(),
            let vert  = lib.makeFunction(name: "vertexMain"),
            let frag  = lib.makeFunction(name: "fragmentMain")
        else { return nil }

        let pd = MTLRenderPipelineDescriptor()
        pd.vertexFunction   = vert
        pd.fragmentFunction = frag
        pd.colorAttachments[0].pixelFormat = .bgra8Unorm

        guard let ps = try? dev.makeRenderPipelineState(descriptor: pd) else { return nil }

        self.device        = dev
        self.commandQueue  = queue
        self.pipelineState = ps
    }

    func configure(layer: CAMetalLayer, colorSpace: RenderColorSpace) {
        layer.device         = device
        layer.pixelFormat    = .bgra8Unorm
        layer.framebufferOnly = true
        layer.colorspace     = colorSpace.cgColorSpace
    }

    func render(test: TestDefinition, onto layer: CAMetalLayer) {
        guard
            layer.drawableSize.width  > 0,
            layer.drawableSize.height > 0,
            let drawable = layer.nextDrawable()
        else { return }

        var params = makeParams(for: test)

        let rpd = MTLRenderPassDescriptor()
        rpd.colorAttachments[0].texture     = drawable.texture
        rpd.colorAttachments[0].loadAction  = .clear
        rpd.colorAttachments[0].clearColor  = MTLClearColor(red: 0, green: 0, blue: 0, alpha: 1)
        rpd.colorAttachments[0].storeAction = .store

        guard
            let buf     = commandQueue.makeCommandBuffer(),
            let encoder = buf.makeRenderCommandEncoder(descriptor: rpd)
        else { return }

        encoder.setRenderPipelineState(pipelineState)
        encoder.setFragmentBytes(&params,
                                 length: MemoryLayout<RenderParams>.stride,
                                 index: 0)
        encoder.drawPrimitives(type: .triangle, vertexStart: 0, vertexCount: 6)
        encoder.endEncoding()
        buf.present(drawable)
        buf.commit()
    }

    // MARK: - Param building

    private func makeParams(for test: TestDefinition) -> RenderParams {
        let p = test.params
        return RenderParams(
            color0: simd(p.color),
            color1: simd(p.color2),
            color2: simd(p.color3),
            color3: simd(p.color4),
            mode:        modeValue(for: test.renderer, orientation: p.orientation),
            stripeCount: UInt32(p.stripeCount ?? 8),
            wedgeSteps:  UInt32(p.wedgeSteps  ?? 10)
        )
    }

    private func simd(_ v: [Double]?) -> (Float, Float, Float, Float) {
        guard let v, v.count >= 4 else { return (0, 0, 0, 1) }
        return (Float(v[0]), Float(v[1]), Float(v[2]), Float(v[3]))
    }

    private func modeValue(for type: RendererType, orientation: String?) -> UInt32 {
        switch type {
        case .fullField:      return kModeFullField
        case .splitQuadrants: return kModeSplitQuad
        case .splitStripes:   return (orientation == "vertical") ? kModeStripeV : kModeStripeH
        case .grayWedge:      return kModeGrayWedge
        case .colorPatches:   return kModePatches
        case .marker:         return kModeFullField  // black bg; text overlay via SwiftUI
        }
    }
}
