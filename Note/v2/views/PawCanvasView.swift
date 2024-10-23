//
//  PawCanvasView.swift
//  Note
//
//  Created by Matt on 23/10/2024.
//

import SwiftUI
import PencilKit

struct PawCanvasView: View {
    
    static var canvasView: PKCanvasView = PKCanvasView()
    
    var body: some View {
        ZStack {
            Image(
                    uiImage: #imageLiteral(
                        resourceName: GetBG(isDarkMode: GetDarkMode(), background: 0))
                )
            PawHandwritingCanvasView(view: CanvasView.canvasView, picker: picker)
        }
    }
}
