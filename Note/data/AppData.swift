import PencilKit
import SwiftUI
import UIKit

public class AppData: ObservableObject {

  let pageCount = "pageCount"
  let bgName = "background"
  let sessionName = "prevSession"

  @AppStorage("isDarkMode") var isDarkMode: Bool = true
  @AppStorage("currentPage") var currentPage = 1
  @AppStorage("count") var count = 0

  public var version = 0.01

  @Published var currentPageData = ViewData(heading: "1")
  @Published var pages = [ViewData]()

  @Published var showsTags = false
  @Published var buttonOpacity = 1.0
  @Published var buttonDisabled = false
  @Published private var hideStatusBar = false
  @Published var copyNotifShown = false

  @Published var currentPageTitle = "1 | 1"
  @Published var topPadding = 35.0

  @Published var pageScaleValueAnim = 1.0
  @Published var pagePositionValueAnim = 0.0
  @Published var pageAnimTimeValue = 0.2

  init() {
  }

  func Initialise() {
//    Reset()
    print(currentPage)
    print(count)

    if count > 0 {
      for number in 1...count {
        let page = ViewData(heading: String(number))
        pages.append(page)
      }
    }

    if currentPage == 0 {
      currentPage = 1
    }

    if count == 0 {
      let page = ViewData(heading: String(currentPage))
      pages.append(page)
    } else {
      currentPageData = pages[currentPage - 1]
    }

    LoadDisplay()
  }

  func NextPage() {
    if CanvasView.canvasView.drawing.dataRepresentation().count <= 64 {
      print("nah page is empty")
      pagePositionValueAnim = 0
      pageAnimTimeValue = 0.4
      return
    } else {
      print("page is not empty, making a new one")
      pageAnimTimeValue = 0.2
      currentPage += 1
      SetPage()

      // whoa there
    }
  }

  func PrevPage() {
    currentPage -= 1
    if currentPage <= 1 {
      currentPage = 1
      pagePositionValueAnim = 0
    }
    SetPage()
  }

  func SetPage() {
    SaveDisplay()
    ClearPage()
    if pages.count < currentPage {
      let page = ViewData(heading: String(currentPage))
      pages.append(page)
    }
    currentPageData = pages[currentPage - 1]
    if currentPage > count {
      count = currentPage
    }
    print("current page is:", currentPage)
    print("count is:", count)
    LoadDisplay()

    //      currentPageTitle = currentPageData.title + " | " +
  }

  public func ToggleZenMode() {
    print("toggling zen mode")

    buttonDisabled = !buttonDisabled

    if !buttonDisabled {
      SetNormalMode()
    } else {
      SetZenMode()
    }

    print(buttonDisabled)
    print(buttonOpacity)
  }

  public func SetZenMode() {
    print("Setting Zen Mode")
    buttonOpacity = 0
    topPadding = 35.0
  }

  public func SetNormalMode() {
    print("Disabling Zen Mode")
    buttonOpacity = 1
    topPadding = 35
  }

  public func ClearPage() {
    picker.removeObserver(CanvasView.canvasView)
    CanvasView.canvasView.drawing = PKDrawing()
    picker.addObserver(CanvasView.canvasView)
  }

  public func LoadDisplay() {
    print("Attempting to load drawing")

    let d: PKDrawing
    do {
      try d = PKDrawing.init(data: Load())
      CanvasView.canvasView.drawing = d
      print("Loaded background is: ")
      print(currentPageData.currentBackground)
      print("Drawing successfully loaded")
      print("data count is:" + String(d.dataRepresentation().count))
    } catch {
      print("Error loading drawing object")
    }
  }

  public func SaveDisplay() {
    print("Attempting to save drawing")
    currentPageData.data = CanvasView.canvasView.drawing.dataRepresentation()
    Save()
  }

  func dataKey() -> String {
    return sessionName + currentPageData.title
  }

  func bgKey() -> String {
    return currentPageData.title + bgName
  }

  func imgKey() -> String {
      return currentPageData.title + "image"
  }

  func pageCountKey() -> String {
    return currentPageData.title + pageCount
  }

  public func Save() {
    let defaults = UserDefaults.standard
    defaults.set(currentPageData.data, forKey: dataKey())
    defaults.set(currentPageData.currentBackground, forKey: bgKey())

    // TODO: Change this to save to sandbox instead of defaults.
    //  https://cocoacasts.com/ud-9-how-to-save-an-image-in-user-defaults-in-swift#:~:text=It%20is%2C%20but%20it%20isn,in%20the%20user's%20defaults%20database.
    if currentPageData.images.uiImage != nil {
        if let data = currentPageData.images.uiImage.pngData() {
            defaults.set(data, forKey: imgKey())
        }
    }
  }

  public func Load() -> Data {
    let defaults = UserDefaults.standard
    currentPageData.currentBackground = defaults.integer(forKey: bgKey())
      
      let imgData = defaults.object(forKey: imgKey())
      if (imgData != nil)
      {
      let pngImage = UIImage(data: imgData as! Data)
          currentPageData.images.uiImage = pngImage ?? UIImage()
      }
    
    return defaults.object(forKey: dataKey()) as? Data ?? Data()
  }

  public func Reset() {

    print("resetting....")

    let defaults = UserDefaults.standard
    defaults.set(nil, forKey: dataKey())
    defaults.set(0, forKey: bgKey())
    defaults.set([], forKey: pageCountKey())
    let domain = Bundle.main.bundleIdentifier!
    UserDefaults.standard.removePersistentDomain(forName: domain)
    UserDefaults.standard.synchronize()
    currentPage = 0
    count = 0
    currentPageData.currentBackground = 0
  }

  public func ChangeBG() {
    currentPageData.currentBackground += 1

    if currentPageData.currentBackground >= 3 {
      currentPageData.currentBackground = 0
    }
    print("Changing bg")
  }

  public func GetBG(isDarkMode: Bool) -> String {

    var bgName = "bg-"

    switch currentPageData.currentBackground
    {
    case (0):
      do {
        bgName += "ruled"
      }
    case (1):
      do {
        bgName += "dots"
      }
    case (2):
      do {
        bgName += "none"
      }
    default:
      bgName += "ruled"
    }

    var resourceName = bgName + "-light.jpg"
    if isDarkMode {
      resourceName = bgName + "-dark.jpg"
    }

    return resourceName
  }

  public func GetModeToggleButton(isDarkMode: Bool) -> String {
    var resourceName = "icon-lightMode.png"
    if isDarkMode {
      resourceName = "icon-darkMode.png"
    }

    return resourceName
  }

  public func ClearAndReset() {
    print("clearing canvas")
    picker.removeObserver(CanvasView.canvasView)
    CanvasView.canvasView.drawing = PKDrawing()

    picker.addObserver(CanvasView.canvasView)
    Reset()
  }

  public func GetDarkMode() -> Bool {
    let currentSystemScheme = UITraitCollection.current.userInterfaceStyle
    if currentSystemScheme == .light {
      return false
    } else {
      return true
    }
  }

  public func ForceUpdate() {
    self.objectWillChange.send()
  }

  public func SendToClipboard() {
    let img = CanvasView.canvasView.drawing.image(from: CanvasView.canvasView.frame, scale: 1.0)
    UIPasteboard.general.image = img
  }

}
