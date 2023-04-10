//
//  Settings.swift
//  linkdlmanager
//
//  Created by Agron Gemajli on 4/9/23.
//

import SwiftUI
import LazyViewSwiftUI

struct Settings: View {
    @EnvironmentObject private var settingsVM: SettingsViewModel
    
    
    var body: some View {
        NavigationStack() {
            List {
                Section(header: Text("Clients")){
                    ForEach(settingsVM.savedClients){ client in
                        NavigationLink(destination: EditClientView(client: client)) {
                            Text(client.clientNickname!)
                        }
                    }.onDelete(perform: settingsVM.deleteClients)
                    NavigationLink(destination: LazyView(CreateClientView().environmentObject(settingsVM))) {
                        Text("Add New Client")
                    }
                }
                Section(header: Text("About Me")){
                    VStack (alignment: .leading) {
                        Text("Creator: Agron Gemajli")
                        Text("Just a normal cyber student")
                    }
                    Text("Follow me on LinkedIn!")
                    Text("Follow me on Twitter!")
                }
                
                Section(header: Text("App Details")){
                    Text("Version: ALPHA v1.0")
                }
            }
            .navigationTitle("Settings")
        }
    }
    
}


struct Settings_Previews: PreviewProvider {
    static var previews: some View {
        Settings()
    }
}


