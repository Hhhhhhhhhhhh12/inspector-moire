import SwiftUI
import UIKit
import QuartzCore

// UIView subclass that exposes CAMetalLayer as its backing layer.
final class MetalUIView: UIView {
    override class var layerClass: AnyClass { CAMetalLayer.self }
    var metalLayer: CAMetalLayer { layer as! CAMetalLayer }

    var renderer:    MetalRenderer?
    var currentTest: TestDefinition?
    var colorSpace:  RenderColorSpace = .rec709Legal

    override func layoutSubviews() {
        super.layoutSubviews()
        metalLayer.drawableSize = CGSize(
            width:  bounds.width  * contentScaleFactor,
            height: bounds.height * contentScaleFactor
        )
        renderIfReady()
    }

    func renderIfReady() {
        guard let test = currentTest else { return }
        renderer?.render(test: test, onto: metalLayer)
    }
}

// UIViewRepresentable bridge. Coordinator owns the MetalRenderer (created once).
struct MetalView: UIViewRepresentable {
    let test:       TestDefinition
    let colorSpace: RenderColorSpace

    func makeCoordinator() -> MetalRenderer? { MetalRenderer() }

    func makeUIView(context: Context) -> MetalUIView {
        let view        = MetalUIView()
        view.renderer   = context.coordinator
        view.colorSpace = colorSpace
        view.currentTest = test
        if let r = context.coordinator {
            r.configure(layer: view.metalLayer, colorSpace: colorSpace)
        }
        return view
    }

    func updateUIView(_ uiView: MetalUIView, context: Context) {
        uiView.currentTest = test
        if uiView.colorSpace != colorSpace, let r = context.coordinator {
            uiView.colorSpace = colorSpace
            r.configure(layer: uiView.metalLayer, colorSpace: colorSpace)
        }
        uiView.renderIfReady()
    }
}
