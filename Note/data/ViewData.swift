import PencilKit
import SwiftUI
import UIKit

public struct ViewData : Identifiable, Hashable {
    public var id = UUID()
    var title: String!
    var currentBackground = 0
    var imageCount = 0 
    var images = [ImageData]()
    var data = Data()
    
    init(heading: String) {
        title = heading
    }
}

public class ImageData : ObservableObject, Hashable {
    
    public static func == (lhs: ImageData, rhs: ImageData) -> Bool {
        lhs === rhs
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(ObjectIdentifier(self))
    }
    
    var offset = CGSize()
    var zoom = 1.0
    var rotationAngle: Angle = .degrees(0)
    var uiImage: UIImage!
}
