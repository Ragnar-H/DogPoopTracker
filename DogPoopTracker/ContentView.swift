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
        RealityView { content in
            let box = ModelEntity(mesh: .generateBox(size: 0.4),
                                  materials: [SimpleMaterial(color: .red, isMetallic: false)])

            box.position = [0, 0, -1]
            content.add(box)
        } update: { content in
        }
    }
}

#Preview {
    ContentView()
}
