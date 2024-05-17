import PencilKit
import SwiftUI
import UIKit

public struct ViewData {

    var title: String!
    var currentBackground = 0
    var images = ImageData()
    var data = Data()

  init(heading: String) {
    title = heading
  }
}

public class ImageData{
  var offset: CGSize!
  var uiImage: UIImage!
}
