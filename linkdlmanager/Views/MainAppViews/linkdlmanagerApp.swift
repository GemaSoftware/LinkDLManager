//
//  linkdlmanagerApp.swift
//  linkdlmanager
//
//  Created by Agron Gemajli on 4/8/23.
//

import SwiftUI

@main
struct linkdlmanagerApp: App {
    let mainvm = SettingsViewModel()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(mainvm)
        }
    }
}
