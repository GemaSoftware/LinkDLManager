//
//  ClientStatusView.swift
//  linkdlmanager
//
//  Created by Agron Gemajli on 4/8/23.
//

import SwiftUI

struct ClientStatusView: View {
    @EnvironmentObject private var clientVM: ClientViewModel
    
    //decalre a timer on this view to update every so often.
    @State private var timer: Timer?

    
    var body: some View {
        VStack(alignment: .center){
            Text(clientVM.client.clientName).bold()
            Text(clientVM.client.clientConnectionURL)
            Text("Status: \(clientVM.client.status ? "Connected" : "Disconnected")").onAppear{
                clientVM.authenticate()
            }
            if !clientVM.client.clientCookie.isEmpty {
                Text(clientVM.client.clientCookie)
                Table(clientVM.client.files) {
                    TableColumn("File", value: \.fileName)
                }
                .onAppear{
                    clientVM.getFiles()
                    //run the update function every 10 seconds
                    self.timer = Timer.scheduledTimer(withTimeInterval: 10.0, repeats: true) { _ in
                        clientVM.getFiles()
                    }
                }
                .onDisappear{
                    // moving to another tab or closing app.
                    self.timer?.invalidate()
                    self.timer = nil
                }
            }

            
        }.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
    }
    
}

struct ClientStatusView_Previews: PreviewProvider {
    @EnvironmentObject private var clientVM: ClientViewModel
    static var previews: some View {
        ClientStatusView().environmentObject(ClientViewModel(client: Client(id: 1, status: true, clientNickname: "Test", clientName: "QBittorrent", clientConnectionURL: "http://192.168.1.105:8080")))
    }
}
