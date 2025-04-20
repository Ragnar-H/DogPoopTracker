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
            ConeView()
                .frame(height: 300)
                .background(.orange)

            Spacer()
        }
    }
}

struct ConeView: View {
    var body: some View {
        RealityView { content in
            let mesh = MeshResource.generateCone(height: 1, radius: 0.1)
            let material = SimpleMaterial(color: .brown, roughness: 0.7, isMetallic: false)
            let poopEntity = ModelEntity(mesh: mesh, materials: [material])

            let anchorEntity = AnchorEntity()
            anchorEntity.position = SIMD3<Float>(0, 0, -0.5)
            anchorEntity.addChild(poopEntity)

            poopEntity.move(to: Transform(), relativeTo: anchorEntity)

            content.add(anchorEntity)
        }
    }
}

#Preview {
    ContentView()
}
