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
    @State private var dragOffset: Float = 0
    @State private var scale: Float = 0.7

    private let shapes: [PoopShape] = [
        PoopShape(type: .sphere, name: "Round"),
        PoopShape(type: .box, name: "Square"),
        PoopShape(type: .cylinder, name: "Cylindrical"),
    ]

    func eternalRotation(model: ModelEntity) {
        let spinAction = SpinAction(
            revolutions: 1,
            localAxis: [0, 1, 0],
            timingFunction: .linear,
            isAdditive: false
        )

        if let spinAnimation = try? AnimationResource.makeActionAnimation(
            for: spinAction,
            duration: 12.0,
            bindTarget: .transform,
            repeatMode: .cumulative

        ) {
            model.playAnimation(spinAnimation)
        }
    }

    func setupShapes(in anchorEntity: AnchorEntity) {
        let spacing: Float = 1.8

        for (index, shape) in shapes.enumerated() {
            let entity = shape.createEntity()
            entity.name = shape.name
            entity.position = SIMD3<Float>(Float(index) * spacing - Float(shapes.count - 1) * spacing / 2, 0, 0)
            entity.components.set(InputTargetComponent())
            entity.generateCollisionShapes(recursive: false)

            eternalRotation(model: entity)

            anchorEntity.addChild(entity)

        }
    }

    var body: some View {
        RealityView { content in
            let anchorEntity = AnchorEntity()
            anchorEntity.position = SIMD3<Float>(0, 0, -0.5)

            setupShapes(in: anchorEntity)
            let pitchTranslate = Transform(rotation: simd_quatf(angle: .pi/8, axis: SIMD3<Float>(1.0, 0.0, 0.0)))
//            poopEntity.move(to: pitchTranslate, relativeTo: nil)

            content.add(anchorEntity)
        } update: { content in
            if let entity = content.entities.first {
                var position = entity.position
                position.x = dragOffset
                entity.position = position
                entity.transform.scale = [scale, scale, scale]
            }
        }
        .gesture(
            DragGesture().targetedToAnyEntity()
                .onChanged({
                    gesture in
                    self.dragOffset = Float(gesture.translation.width) * 0.003
                })
        )
        .gesture(TapGesture().targetedToAnyEntity().onEnded({ _ in
            scale = self.scale == 1.0 ? 0.5 : 1.0
        }))
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
