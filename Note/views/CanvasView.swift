import PencilKit
import SwiftUI
import UIKit

struct CanvasView: View {

  @ObservedObject var data: AppData

  static var canvasView: PKCanvasView = PKCanvasView()
    
    

  init(_ viewData: AppData) {
    data = viewData
  }

  var body: some View {

      ZStack {
        VStack(alignment: .center, spacing: 0) {
            Image(uiImage: #imageLiteral(resourceName: GetBGTop()))
            .resizable()
            .scaledToFill()
            
            Image(
              uiImage: #imageLiteral(
                resourceName: data.GetBG(isDarkMode: GetDarkMode()))
            )
            .resizable(resizingMode: .tile)
            .scaledToFill()
        }
        MyCanvas(view: CanvasView.canvasView, tag: data.showsTags, picker: picker)
      }
    .onAppear(perform: data.LoadDisplay)
    .onAppear(perform: logPageID)
    .onReceive(NotificationCenter.default.publisher(for: UIApplication.didBecomeActiveNotification), perform: { _ in
        print ("checking for dark mode")
          //  data.objectWillChange.send()
           // data.ForceUpdate()
    
    })
    .onReceive(
      NotificationCenter.default.publisher(for: UIApplication.didEnterBackgroundNotification),
      perform: { output in
        print("saving on background")
        data.SaveDisplay()
      }
    )
    .onReceive(
      NotificationCenter.default.publisher(for: UIApplication.willTerminateNotification),
      perform: { output in
        print("saving on quit")
        data.SaveDisplay()
      })
  }
    
    

  func logPageID() {
    print("page title is: " + data.currentPageData.title)
  }

  public func GetBGTop() -> String {

    let bgName = "bg-top"

    var resourceName = bgName + "-light.jpg"
    if GetDarkMode() {
      resourceName = bgName + "-dark.jpg"
    }

    return resourceName
  }
}

struct MyView_Previews: PreviewProvider {
  static var previews: some View {
    CanvasView(AppData())
  }
}
