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
    @State private var dragOffset:CGFloat = 0
    @StateObject private var stateManager = CarouselStateManager()

    var body: some View {
        RealityView { content in
            for item in stateManager.items {
                let material = SimpleMaterial(color: .red, isMetallic: false)

                let entity = ModelEntity(
                    mesh: .generateBox(size: 0.4),
                    materials: [material]
                )

                entity.position = item.position
                entity.name = item.id

                content.add(entity)
            }
        } update: { content in
            
        }
        .gesture(
            DragGesture()
                .onChanged { value in
                    dragOffset = value.translation.width
                }
        )
    }
}

#Preview {
    ContentView()
}

struct CarouselItemModel: Identifiable {
    let id: String
    var position: SIMD3<Float>
}

class CarouselStateManager: ObservableObject {
    @Published var currentIndex: Int = 0
    @Published var items: [CarouselItemModel] = []
    @Published var dragOffset: Float = 0

    let itemSpacing: Float = 0.8

    init() {
        setupInitialItems(count: 5)
    }

    private func setupInitialItems(count: Int) {
        items = (0..<count).map { index in
            let targetX:Float = Float(index) * itemSpacing - Float(count) * itemSpacing / 2
            return CarouselItemModel(
                id: "item_\(index)",
                position: [targetX, 0, 0]
            )
        }
    }
}
