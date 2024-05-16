import SwiftUI

struct MenuButtonsView: View {

  @ObservedObject var data: AppData

  init(_ viewData: AppData) {
    data = viewData
  }

  var body: some View {
    ZStack {
      ZenButtonView(text: "zen", clicked: data.ToggleZenMode, viewData: data)
    }
    .padding(.horizontal, 30)
    .padding(.top, data.topPadding)
    .animation(.none, value: 1)

    HStack {
      if !data.buttonDisabled {
        TopButtonView(text: "backgrounds", clicked: data.ChangeBG, viewData: data)
        Spacer()
      } else {
        Spacer()
        ZenButtonView(text: "zen", clicked: data.ToggleZenMode, viewData: data)
        Spacer()
      }
    }
    .padding(.horizontal, 30)
    .padding(.top, data.topPadding)
    .frame(maxWidth: .infinity, alignment: .leading)
    .statusBar(hidden: data.buttonDisabled)
  }

  func Nothing() {

  }

}

struct ButtonView_Previews: PreviewProvider {
  static var previews: some View {
    MenuButtonsView(AppData())
  }
}
