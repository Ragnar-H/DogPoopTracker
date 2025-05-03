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

    var body: some View {
        RealityView { content in
            for i in 0..<5 {
                let entity = ModelEntity(mesh: .generateBox(size: [0.4, 0.4, 0.1]), materials: [SimpleMaterial(color: .red, isMetallic: false)])

                let targetX = Float(i) * itemSpacing
                entity.position = [targetX, 0, 0]
                entity.name = "box-\(i)"

                content.add(entity)
            }
        } update: { content in
            let normalizedDragOffset = Float(dragOffset) * 0.003
            for i in 0..<5 {
                if let itemEntity = content.entities.first(where: { $0.name == "box-\(i)"}) as? ModelEntity {
                    let indexOffset = Float(i - 3) + normalizedDragOffset
                    let targetX = indexOffset * itemSpacing
                    // Feels kind of fiddly to calculate position in the render(update) call
                    // would it be better to calculate and update positions in
                    // ObservableObject state vars. Then use the render (update)
                    // call to have smooth animations
                    itemEntity.position = [targetX, 0, 0]
                }

            }


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
