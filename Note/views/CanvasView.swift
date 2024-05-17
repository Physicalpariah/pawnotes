import PencilKit
import SwiftUI
import UIKit

struct CanvasView: View {

  @ObservedObject var data: AppData

  static var canvasView: PKCanvasView = PKCanvasView()

  @State private var opacityValue = 1.0
  @State private var currentZoom = 0.0

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
      if data.currentPageData.images.uiImage != nil {
        Image(
          uiImage: data.currentPageData.images.uiImage
        )
        .resizable()
        .scaledToFit()
        .frame(width: 300, height: 300)
        .offset(data.currentPageData.images.offset)
        .scaleEffect(currentZoom + data.currentPageData.images.zoom)
        .rotationEffect(data.currentPageData.images.rotationAngle)
        .gesture(
          MagnifyGesture()
            .onChanged { value in
              currentZoom = value.magnification - 1
              print("zoom is: " + String(currentZoom))
            }
            .onEnded { value in
              data.currentPageData.images.zoom += currentZoom
              print("zoom is: " + String(data.currentPageData.images.zoom))

              if data.currentPageData.images.zoom > 2 {
                data.currentPageData.images.zoom = 2
              } else if data.currentPageData.images.zoom < 0.75 {
                data.currentPageData.images.zoom = 0.75
              }
              currentZoom = 0
            }
            .simultaneously(
              with:
                RotationGesture()
                .onChanged { angle in
                    data.currentPageData.images.rotationAngle = angle
                }
            )
            .simultaneously(
              with: DragGesture()
                .onChanged { gesture in
                  data.currentPageData.images.offset = gesture.translation
                })
        )

      }
    }
    .dropDestination(for: Data.self) { items, location in
      guard let item = items.first else { return false }
      guard let uiImage = UIImage(data: item) else { return false }
      data.currentPageData.images.uiImage = uiImage
      data.SaveDisplay()
      return true
    }
    .onChange(
      of: data.currentPage,
      { oldValue, newValue in
        animateImage(old: oldValue, new: newValue)
      }
    )
    .offset(x: data.pagePositionValueAnim, y: 0)
    .scaleEffect(x: data.pageScaleValueAnim, y: data.pageScaleValueAnim)
    .animation(.easeIn(duration: 0.05), value: data.pageScaleValueAnim)
    .opacity(opacityValue)
    //    .animation(.easeOut(duration: 0.05), value: opacityValue)
    .onAppear(perform: data.LoadDisplay)
    .onAppear(perform: logPageID)
    .onReceive(
      NotificationCenter.default.publisher(for: UIApplication.didBecomeActiveNotification),
      perform: { _ in
        print("checking for dark mode")
        //  data.objectWillChange.send()
        // data.ForceUpdate()

      }
    )
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

  func animateImage(old: Int, new: Int) {
    print("scale started")
    //    opacityValue = 0.9
    if old > new {
      data.pagePositionValueAnim = 100
    } else {
      data.pagePositionValueAnim = -100
    }

    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.2) {
      opacityValue = 1
      print("scale done")
      data.pagePositionValueAnim = 0
    }
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
