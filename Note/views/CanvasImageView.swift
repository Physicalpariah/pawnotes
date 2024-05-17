import SwiftUI

struct CanvasImageView: View {

  @ObservedObject var data: ImageData

  init(_ imgData: ImageData) {
    data = imgData
  }

  var body: some View {
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

  func Nothing() {

  }

}

struct ButtonView_Previews: PreviewProvider {
  static var previews: some View {
    MenuButtonsView(AppData())
  }
}
