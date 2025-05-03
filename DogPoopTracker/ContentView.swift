//
//  ContentView.swift
//  DogPoopTracker
//
//  Created by Ragnar on 20/04/2025.
//

import SwiftUI
import RealityKit

struct ContentView: View {
    @State private var selectedEntity: Entity?
    @State private var dragOffset: CGSize = .zero
    @State private var scale: CGFloat = 1.0
    @State private var rotation: Angle = .zero

    var body: some View {
        RealityView { content in
            for i in 0..<5 {
                let box = ModelEntity(mesh: .generateBox(size: 0.2),
                                      materials: [SimpleMaterial(color: .blue, isMetallic: true)]
                )

                box.position = [Float(i) * 0.3 - 0.6, 0, -1]
                box.components.set(InputTargetComponent())
                box.generateCollisionShapes(recursive: false)
                box.name = "Box\(i)"
                content.add(box)
            }

            let light = DirectionalLight()
            light.light.intensity = 1000
            light.orientation = simd_quatf(angle: -.pi/4, axis: [-1,-1,-1])
            content.add(light)
        } update: { content in
            if let selected = selectedEntity as? ModelEntity {
                selected.scale = SIMD3<Float>(repeating: Float(scale))
                selected.orientation *= simd_quatf(angle: Float(rotation.radians), axis: [0, 1, 0])
                selected.position.x += Float(dragOffset.width) * 0.001
                selected.position.y -= Float(dragOffset.height) * 0.001
            }
        }
        .gesture(
            SpatialTapGesture()
                .targetedToAnyEntity()
                .onEnded { value in
                    selectedEntity = value.entity

                    if let model = value.entity as? ModelEntity {
                        model.model?.materials = [SimpleMaterial(color: .yellow, isMetallic: true)]
                    }
                }
        )
        .gesture(
            DragGesture()
                .targetedToAnyEntity()
                .onChanged { value in
                    dragOffset = value.translation
                }
                .onEnded { _ in
                    dragOffset = .zero
                }
        )
    }
}

#Preview {
    ContentView()
}
