//
//  ContentView.swift
//  DogPoopTracker
//
//  Created by Ragnar on 20/04/2025.
//

import SwiftUI
import RealityKit

struct ContentView: View {
    var body: some View {
        VStack {
            Text("Poop Shape Selector")
                .font(.title)
                .padding()
            PoopView()
                .frame(height: 300)
                .background(.orange)

            Spacer()
        }
    }
}

struct PoopView: View {
    @State private var dragOffset: CGFloat = 0
    @State private var scale: Float = 0.7
    @State private var currentIndex: Int = 0

    private let shapes: [PoopShape] = [
        PoopShape(type: .sphere, name: "Round"),
        PoopShape(type: .box, name: "Square"),
        PoopShape(type: .cylinder, name: "Cylindrical"),
    ]

    var body: some View {
        RealityView { content in
            let spacing: Float = 1.8
            for (index, shape) in shapes.enumerated() {
                let entity = shape.createEntity()
                entity.name = shape.name
                entity.position = SIMD3<Float>(Float(index) * spacing - Float(shapes.count - 1) * spacing / 2, 0, 0)
                entity.components.set(InputTargetComponent())
                entity.generateCollisionShapes(recursive: false)

                content.add(entity)
            }
        } update: { content in
            for (index, child) in content.entities.enumerated() {
                if let entity = child as? ModelEntity {
                    let targetScale: Float = index == currentIndex ? 1.5 : 1
                    entity.scale = [targetScale, targetScale, targetScale]
                }
            }

        }.gesture(swipeGesture)
    }

    private var swipeGesture: some Gesture {
        DragGesture()
            .onChanged { gesture in
                dragOffset = gesture.translation.width
            }
            .onEnded { value in
                let threshold: CGFloat = 50

                if value.translation.width < -threshold {
                    currentIndex = (currentIndex + 1 + shapes.count) % shapes.count
                } else if value.translation.width > threshold {
                    currentIndex = (currentIndex - 1 + shapes.count) % shapes.count
                }
                dragOffset = 0
            }
    }
}

enum PoopTypes {
    case sphere
    case box
    case cylinder
}

struct PoopShape {
    let type: PoopTypes
    let name: String

    func createEntity() -> ModelEntity {
        let mesh: MeshResource
        let material: SimpleMaterial
        switch self.type {
        case .sphere:
            mesh = MeshResource.generateBox(width: 0.3, height: 0.7, depth: 0.5)
            material = SimpleMaterial(color: .red, roughness: 0.7, isMetallic: false)
        case .box:
            mesh = MeshResource.generateBox(size: 0.7)
            material = SimpleMaterial(color: .green, roughness: 0.7, isMetallic: false)
        case .cylinder:
            mesh = MeshResource.generateBox(size: 1.3, cornerRadius: 0.2)
            material = SimpleMaterial(color: .blue, roughness: 0.7, isMetallic: false)
        }

        let entity = ModelEntity(mesh: mesh, materials: [material])

        return entity
    }
}

#Preview {
    ContentView()
}
