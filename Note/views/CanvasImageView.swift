import SwiftUI

struct CanvasImageView: View {

  @ObservedObject var data: ImageData
@State private var currentZoom = 0.0
  init(_ imgData: ImageData) {
    data = imgData
  }

  var body: some View {
    Image(
      uiImage: data.uiImage
    )
    .resizable()
    .scaledToFit()
    .frame(width: 300, height: 300)
    .offset(data.offset)
    .scaleEffect(currentZoom + data.zoom)
    .rotationEffect(data.rotationAngle)
    .gesture(
      MagnifyGesture()
        .onChanged { value in
          currentZoom = value.magnification - 1
          print("zoom is: " + String(currentZoom))
        }
        .onEnded { value in
          data.zoom += currentZoom
          print("zoom is: " + String(data.zoom))

          if data.zoom > 2 {
            data.zoom = 2
          } else if data.zoom < 0.75 {
            data.zoom = 0.75
          }
          currentZoom = 0
        }
        .simultaneously(
          with:
            RotationGesture()
            .onChanged { angle in
              data.rotationAngle = angle
            }
        )
        .simultaneously(
          with: DragGesture()
            .onChanged { gesture in
              data.offset = gesture.translation
            })
    )
  }

  func Nothing() {

  }

}

struct CanvasImageView_Previews: PreviewProvider {
  static var previews: some View {
      CanvasImageView(ImageData())
  }
}
