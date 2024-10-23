import PencilKit
import SwiftUI
import UIKit

//------------------------------------------------------------------------------------------
// UI
//------------------------------------------------------------------------------------------

public func GetDarkMode() -> Bool {
    let currentSystemScheme = UITraitCollection.current.userInterfaceStyle
    if currentSystemScheme == .light {
        return false
    } else {
        return true
    }
}

struct TopImageModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .scaledToFill()
            .frame(width: 30, height: 30.0)
    }
}

struct TopButtonModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding()
            .frame(width: 30.0, height: 30.0)
    }
}

public func GetIcon(title: String) -> String {
    let bg = "icon-"
    var resourceName = bg + title + "-light.png"
    if GetDarkMode() {
        resourceName = bg + title + "-dark.png"
    }
    return resourceName
}

//------------------------------------------------------------------------------------------
// Extensions
//------------------------------------------------------------------------------------------

extension Array: RawRepresentable where Element: Codable {
    public init?(rawValue: String) {
        guard let data = rawValue.data(using: .utf8),
              let result = try? JSONDecoder().decode(
                [Element].self,
                from: data
              )
        else {
            return nil
        }
        self = result
    }
    
    public var rawValue: String {
        guard let data = try? JSONEncoder().encode(self),
              let result = String(data: data, encoding: .utf8)
        else {
            return "[]"
        }
        return result
    }
}

extension UIImage {
    public func mergeWith(topImage: UIImage) -> UIImage {
        let bottomImage = self
        
        UIGraphicsBeginImageContext(size)
        
        let areaSize = CGRect(
            x: 0,
            y: 0,
            width: bottomImage.size.width,
            height: bottomImage.size.height
        )
        bottomImage.draw(in: areaSize)
        
        topImage.draw(in: areaSize, blendMode: .normal, alpha: 1.0)
        
        let mergedImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return mergedImage
    }
}


extension View {
    func snapshot() -> UIImage {
        let controller = UIHostingController(rootView: self)
        let view = controller.view
        
        let targetSize = controller.view.intrinsicContentSize
        view?.bounds = CGRect(origin: .zero, size: targetSize)
        view?.backgroundColor = .clear
        
        let renderer = UIGraphicsImageRenderer(size: targetSize)
        
        return renderer.image { _ in
            view?.drawHierarchy(in: controller.view.bounds, afterScreenUpdates: true)
        }
    }
}
