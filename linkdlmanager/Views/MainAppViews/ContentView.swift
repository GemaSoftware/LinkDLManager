//
//  ContentView.swift
//  linkdlmanager
//
//  Created by Agron Gemajli on 4/8/23.
//

import SwiftUI

struct ContentView: View {
    
    
    
    var body: some View {
        TabView {
            HomeClientView()
                .tabItem{
                    Image(systemName: "house")
                    Text("Home")
                }
            SendLinkView()
                .tabItem{
                    Image(systemName: "square.and.arrow.down.on.square")
                    Text("Send Link")
                }
            Settings()
                .tabItem {
                    Image(systemName: "gear")
                    Text("Settings")
                }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    
    static var previews: some View {
        ContentView()
    }
}
