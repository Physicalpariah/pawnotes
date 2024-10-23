import SwiftUI

struct TopButtonView: View {
    var text: String
    var clicked: (() -> Void)
    var viewData: AppData!
    
    var body: some View {
        Button {
            withAnimation {
                clicked()
            }
        } label: {
            Image(uiImage: #imageLiteral(resourceName: GetIcon(title: text)))
                .resizable()
                .opacity(viewData.buttonOpacity)
                .animation(/*@START_MENU_TOKEN@*/.easeIn/*@END_MENU_TOKEN@*/, value: 1)
                .disabled(viewData.buttonDisabled)
                .modifier(TopImageModifier())
        }
        .modifier(TopButtonModifier())
    }
}

struct ZenButtonView: View {
    var text: String
    var clicked: (() -> Void)
    var viewData: AppData!
    
    var body: some View {
        Button {
            clicked()
        } label: {
            Image(uiImage: #imageLiteral(resourceName: GetIcon(title: text)))
                .resizable()
                .modifier(TopImageModifier())
        }
        .modifier(TopButtonModifier())
        
    }
}
