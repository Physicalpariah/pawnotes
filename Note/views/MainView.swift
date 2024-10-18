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
let minTranslation = 25.0
let minMoveTranslation = 50.0
let maxTranslation = 150.0

let moveScaleDown = 0.95

struct MainView: View {

@ObservedObject var appData = AppData()
@State private var firstSelectedDataItem: ViewData?
@State private var number: Int = 0

    
  var body: some View {
      NavigationSplitView() {
              List(appData.pages, selection: $firstSelectedDataItem) { item in
                  Text(item.title).font(.system(size: 24))
                  Image(uiImage: appData.GetDisplayForPage(item: item, scale: 0.2)).onTapGesture {
                      appData.PickPage(item);
                  }.frame(height: 120)
                      .swipeActions(edge: .trailing) {
                          Button(role: .destructive) {
                              appData.pages.remove(object: item)
                              appData.Clear(viewData: item)
                              do {
                                  try appData.Save()
                              } catch {
                                  print(error.localizedDescription)
                              }
                          } label: {
                              Label("Delete", systemImage: "trash")
                          }
                      }
          }.navigationSplitViewColumnWidth(160)
       
      } detail: {
          ZStack(alignment: .top) {
            CanvasView(appData)
            MenuButtonsView(appData)
            VStack {
              Text(appData.currentPageData.title + " | " + String(appData.count))
                .font(.system(size: 18))
                .frame(maxWidth: .infinity, alignment: .center)
                .padding(.vertical, 40)
                .opacity(appData.buttonOpacity)
              Spacer()
            }
          }
          .frame(alignment: .leading)
          .gesture(
            DragGesture()
              .onChanged { gesture in

                let width = gesture.translation.width
                if width < maxTranslation || width > -maxTranslation {
                  appData.pagePositionValueAnim = width
                  print("moving!")
                }

                if width > maxTranslation && width > 0 {
                  appData.pageScaleValueAnim = moveScaleDown
                } else if width < -maxTranslation && width < 0 {
                  appData.pageScaleValueAnim = moveScaleDown
                } else {
                  appData.pageScaleValueAnim = 1
                }

                print(width)
              }
              .onEnded { value in
                print("value ", value.translation.width)
                let direction = self.detectDirection(value: value)
                if direction == .left {
                  // your code here
                  appData.PrevPage()
                } else if direction == .right {
                  // your code here
                  appData.NextPage()
                } else {
                  appData.pagePositionValueAnim = 0
                }
                appData.pageScaleValueAnim = 1

                print(direction)
              }
          )
      }
      .onAppear(perform: {
        appData.Initialise()
      })
  }

  func detectDirection(value: DragGesture.Value) -> SwipeHVDirection {
    if value.startLocation.x < value.location.x - maxTranslation {
      return .left
    }
    if value.startLocation.x > value.location.x + maxTranslation {
      return .right
    }
    if value.startLocation.y < value.location.y - maxTranslation {
      return .down
    }
    if value.startLocation.y > value.location.y + maxTranslation {
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

extension PKDrawing {
    mutating func scale(scaleFactor:CGFloat) {
    
        
//        if self.bounds.width != frame.width {
//            scaleFactor = frame.width / self.bounds.width
//        } else if self.bounds.height != frame.height {
//            scaleFactor = frame.height / self.bounds.height
//        }
        
        let trasform = CGAffineTransform(scaleX: scaleFactor, y: scaleFactor)
        
        self.transform(using: trasform)
    }
}

extension Array where Element: Equatable {
    
    // Remove first collection element that is equal to the given `object`:
    mutating func remove(object: Element) {
        guard let index = firstIndex(of: object) else {return}
        remove(at: index)
    }
}
