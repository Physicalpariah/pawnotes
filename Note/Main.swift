//
//  NoteApp.swift
//  Note
//
//  Created by Mathew Purchase on 8/11/21.
//

import SwiftUI

//import Middleman

@main
struct NoteApp: SwiftUI.App {
    
    var body: some Scene {
        WindowGroup {
            MainView().ignoresSafeArea(edges: .all)
        }
    }
    
    func addpage() {}
}
