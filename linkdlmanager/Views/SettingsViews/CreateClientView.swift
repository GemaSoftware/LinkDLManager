//
//  CreateClient.swift
//  linkdlmanager
//
//  Created by Agron Gemajli on 4/9/23.
//

import SwiftUI
import AlertToast

struct CreateClientView: View {
    
    //we are passing in the viewmodel from Settings.
    @EnvironmentObject private var settingsVM: SettingsViewModel
    
    //Environment Variable of the current presentation to navigate back
    @Environment(\.presentationMode) private var presentationMode
    
    //Variables
    @State private var clientNickname = ""
    @State private var clientConnectionURL = ""
    @State private var clientType: ClientType = .qbittorrent
    @State private var clientUsername: String = ""
    @State private var clientPassword: String = ""
    @State private var showTestToast = false
    @State private var testSuccess = false
    
    //Enums
    enum ClientType: String, CaseIterable, Identifiable {
        case qbittorrent, vuze
        var id: Self { self }
    }
    
    //View
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Client Details")) {
                    TextField("Client Nickname", text: $clientNickname)
                    TextField("Client Connection URL", text: $clientConnectionURL)
                    Picker("Cient Type", selection: $clientType) {
                        Text("QBittorrent").tag(ClientType.qbittorrent)
                        Text("Vuze").tag(ClientType.vuze)
                    }
                }
                
                Section(header: Text("Client Authenticaion")) {
                    TextField("Username", text: $clientUsername)
                    TextField("Password", text: $clientPassword)
                }
                
                Section(header: Text("Test and Save")){
                    Button("Test Connection") {
                        //TODO: Add function
                        showTestToast.toggle()
                    }
                    Button("Save Client") {
                        //TODO: Add function
                        showTestToast.toggle()
                    }
                    Button("Add Test Client") {
                        //TODO: Add function
                        settingsVM.addClientIfNotExist(clientNickname: clientNickname, clientConnectionURL: clientConnectionURL, clientUsername: clientUsername, clientPassword: clientPassword) { success in
                            testSuccess = success
                            showTestToast.toggle()
                        }
                    }
                }
                
            }
            .navigationTitle("Add New Client")
            .toast(isPresenting: $showTestToast) {
                if testSuccess {
                    return AlertToast(displayMode: .alert, type: .complete(Color.green), title: "Client Added")
                } else {
                    return AlertToast(displayMode: .alert, type: .error(Color.red), title: "Failed Adding Client")
                }
            } completion: {
                if testSuccess {
                    presentationMode.wrappedValue.dismiss()
                } else {
                    print("There was an error.")
                }
                
            }

        }
        
    }
    
}

struct CreateClient_Previews: PreviewProvider {
    static var previews: some View {
        CreateClientView()
    }
}

