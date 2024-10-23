import PencilKit
import SwiftUI
import UIKit

public struct ViewData : Identifiable, Hashable {
    public var id = UUID()
    var title: String!
    var currentBackground = 0
    var data = Data()
    
    init(heading: String) {
        title = heading
    }
}
