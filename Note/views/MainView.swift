//
//  MainView.swift
//  Note
//
//  Created by Mathew Purchase on 8/11/21.
//

import PencilKit
import SwiftUI
import UIKit

struct MainView_Previews: PreviewProvider {
  static var previews: some View {
    MainView()
  }
}

enum SwipeHVDirection: String {
  case left, right, up, down, none
}

let picker = PKToolPicker.init()

struct MainView: View {

  @ObservedObject var appData = AppData()

  var body: some View {
    ZStack(alignment: .top) {
      CanvasView(appData)
      MenuButtonsView(appData)
      VStack {
        Spacer()
        Text("Page: " + appData.currentPageData.title + " | " + String(appData.count))
          .frame(maxWidth: .infinity, alignment: .trailing)
          .padding(.vertical, 10)
          .padding(.horizontal, 40)
          .opacity(appData.buttonOpacity)
      }
    }
    .frame(alignment: .leading)
    .onAppear(perform: {
      appData.Initialise()
    })
    .gesture(
      DragGesture()
        .onChanged { gesture in
          if gesture.translation.width < 100 || gesture.translation.width > -100 {
            appData.pagePositionValueAnim = gesture.translation.width
          }

        }
        .onEnded { value in
          print("value ", value.translation.width)
          let direction = self.detectDirection(value: value)
          if direction == .left {
            // your code here
            appData.PrevPage()
          }
          if direction == .right {
            // your code here
            appData.NextPage()
          }
            
            appData.pagePositionValueAnim = 0
          print(direction)
        }
    )
  }

  func detectDirection(value: DragGesture.Value) -> SwipeHVDirection {
    if value.startLocation.x < value.location.x - 24 {
      return .left
    }
    if value.startLocation.x > value.location.x + 24 {
      return .right
    }
    if value.startLocation.y < value.location.y - 24 {
      return .down
    }
    if value.startLocation.y > value.location.y + 24 {
      return .up
    }
    return .none
  }

}

//------------------------------------------------------------------------------------------
// Helpers
//------------------------------------------------------------------------------------------
struct MyCanvas: UIViewRepresentable {
  var canvasView: PKCanvasView
  var m_picker: PKToolPicker
  var tagOpen = false

  init(view: PKCanvasView, tag: Bool, picker: PKToolPicker) {
    canvasView = view
    tagOpen = tag
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
      if !tagOpen {
        uiView.becomeFirstResponder()
      }
    }
  }
}
