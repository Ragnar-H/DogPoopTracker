//
//  ContentView.swift
//  DogPoopTracker
//
//  Created by Ragnar on 20/04/2025.
//

import SwiftUI
import RealityKit

struct ContentView: View {
    @State private var rotation: Float = 0

    var body: some View {
        RealityView { content in
            let box = ModelEntity(mesh: .generateBox(size: 0.4),
                                  materials: [SimpleMaterial(color: .red, isMetallic: false)])

            box.position = [0, 0, -1]
            content.add(box)

            let light = DirectionalLight()
            light.light.intensity = 1000
            light.orientation = simd_quatf(angle: -.pi/4, axis: [1,0,0])
            content.add(light)
        } update: { content in
            content.entities.forEach { entity in
                if let model = entity as? ModelEntity {
                    model.move(
                        to: Transform(rotation:simd_quatf(angle: rotation, axis: [0, 1, 0])),
                        relativeTo: model.parent,
                        duration: 0.2, timingFunction: .easeInOut
                    )
                }
            }
        }
        .gesture(
            DragGesture()
                .onChanged { value in
                    rotation = Float(value.translation.width) * 0.01
                }
        )
    }
}

#Preview {
    ContentView()
}
