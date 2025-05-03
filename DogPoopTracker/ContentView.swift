//
//  ContentView.swift
//  DogPoopTracker
//
//  Created by Ragnar on 20/04/2025.
//

import SwiftUI
import RealityKit

struct ContentView: View {
    let itemSpacing:Float = 0.6

    var body: some View {
        RealityView { content in
            for i in 0..<5 {
                let entity = ModelEntity(mesh: .generateBox(size: [0.4, 0.4, 0.1]), materials: [SimpleMaterial(color: .red, isMetallic: false)])

                let targetX = Float(i) * itemSpacing
                entity.position = [targetX, 0, 0]
                entity.name = "box-\(i)"

                content.add(entity)
            }
        }
    }
}

#Preview {
    ContentView()
}
