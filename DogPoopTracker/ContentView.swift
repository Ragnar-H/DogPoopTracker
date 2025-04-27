import SwiftUI
import RealityKit

struct ModelItem: Identifiable {
    let id = UUID()
    let model: ModelEntity
}

struct CarouselRealityView: View {
    @State private var models: [ModelItem] = []
    @GestureState private var dragOffset: CGFloat = 0
    @State private var currentOffset: CGFloat = 0
    @State private var timer: Timer?

    var body: some View {
        ZStack {
            RealityView { content in
                // Create and add models
                models = createModels()
                for (index, item) in models.enumerated() {
                    let anchor = AnchorEntity(world: .zero)
                    item.model.position = SIMD3(Float(index) * 0.5, 0, 0)
                    anchor.addChild(item.model)
                    content.add(anchor)
                }

                startSpinning()
            } update: { content in
                for (index, item) in models.enumerated() {
                    let totalOffset = (CGFloat(index) * 150) + currentOffset + dragOffset
                    let distanceFromCenter = abs(totalOffset)

                    // Closer to center → bigger scale
                    let scale = max(0.8, 1.5 - Double(distanceFromCenter / 300))

                    item.model.transform.translation = SIMD3(Float(totalOffset / 300), 0, 0)
                    item.model.transform.scale = SIMD3(repeating: Float(scale))
                }
            }
            .gesture(
                DragGesture()
                    .updating($dragOffset) { value, state, _ in
                        state = value.translation.width
                    }
                    .onEnded { value in
                        currentOffset += value.translation.width
                        // Optional: Snap to nearest model
                        let snapped = (currentOffset / 150).rounded() * 150
                        withAnimation(.spring()) {
                            currentOffset = snapped
                        }
                    }
            )
        }
        .onDisappear {
            timer?.invalidate()
        }
    }

    func createModels() -> [ModelItem] {
        let box = ModelEntity(mesh: .generateBox(size: 0.2))
        box.model?.materials = [SimpleMaterial(color: .red, isMetallic: false)]

        let sphere = ModelEntity(mesh: .generateBox(size: 0.3))
        sphere.model?.materials = [SimpleMaterial(color: .green, isMetallic: false)]

        let cone = ModelEntity(mesh: .generateBox(size: 0.1))
        cone.model?.materials = [SimpleMaterial(color: .blue, isMetallic: false)]

        return [box, sphere, cone].map { ModelItem(model: $0) }
    }

    func startSpinning() {
        timer = Timer.scheduledTimer(withTimeInterval: 0.02, repeats: true) { _ in
            for item in models {
                item.model.transform.rotation *= simd_quatf(angle: 0.01, axis: SIMD3(0, 1, 0))
            }
        }
    }
}

struct CarouselRealityView_Previews: PreviewProvider {
    static var previews: some View {
        CarouselRealityView()
    }
}

