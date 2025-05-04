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
            for item in stateManager.items {
                // I wonder if we can store the entities directly
                // in stateManager and update the positions there
                if let entity = content.entities.first(where: { $0.name == item.id}) as? ModelEntity {
                    entity.position = item.position
                }
            }
        }
        .gesture(
            DragGesture()
                .onChanged { value in
                    stateManager.updateDragOffset(Float(value.translation.width))
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

    let itemSpacing: Float = 0.8
    let dragNormalizer: Float = 0.003

    init() {
        setupInitialItems(count: 5)
    }

    private func setupInitialItems(count: Int) {
        items = (0..<count).map { index in
            let targetX:Float = Float(index) * itemSpacing
            return CarouselItemModel(
                id: "item_\(index)",
                position: [targetX, 0, 0]
            )
        }
    }

    func updateDragOffset(_ offset: Float) {
        let dragOffset = offset * dragNormalizer
        let centerX: Float = 0

        for i in 0..<items.count {
            let indexOffset = Float(i - currentIndex) + dragOffset / itemSpacing
            let targetX = centerX + indexOffset * itemSpacing

            items[i].position.x = targetX
        }
    }
}
