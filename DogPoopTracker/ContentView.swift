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

    var body: some View {
        RealityView { content in
            let mesh = MeshResource.generateBox(size: 0.7)
            let material = SimpleMaterial(color: .brown, roughness: 0.7, isMetallic: false)
            let poopEntity = ModelEntity(mesh: mesh, materials: [material])
            poopEntity.components.set(InputTargetComponent())
            poopEntity.generateCollisionShapes(recursive: false)

            let anchorEntity = AnchorEntity()
            anchorEntity.position = SIMD3<Float>(0, 0, -0.5)
            anchorEntity.addChild(poopEntity)

            let pitchTranslate = Transform(rotation: simd_quatf(angle: .pi/8, axis: SIMD3<Float>(1.0, 0.0, 0.0)))
            poopEntity.move(to: pitchTranslate, relativeTo: nil)

            eternalRotation(model: poopEntity)

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

#Preview {
    ContentView()
}
