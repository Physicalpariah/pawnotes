import PencilKit
import SwiftUI
import UIKit


struct PawHandwritingCanvasView: UIViewRepresentable {
    var canvasView: PKCanvasView
    var m_picker: PKToolPicker
    
    init(view: PKCanvasView, picker: PKToolPicker) {
        canvasView = view
        m_picker = picker
    }
    
    func makeUIView(context: Context) -> PKCanvasView {
        self.canvasView.backgroundColor = .clear
        self.canvasView.isOpaque = false
        self.canvasView.becomeFirstResponder()
        return canvasView
    }
    
    func updateUIView(_ uiView: PKCanvasView, context: Context) {
        m_picker.addObserver(canvasView)
        m_picker.setVisible(true, forFirstResponder: uiView)
        DispatchQueue.main.async {
                uiView.becomeFirstResponder()
        }
    }
}
