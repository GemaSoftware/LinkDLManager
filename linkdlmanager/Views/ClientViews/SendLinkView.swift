//
//  SendLinkView.swift
//  linkdlmanager
//
//  Created by Agron Gemajli on 4/8/23.
//

import SwiftUI

struct SendLinkView: View {
    @EnvironmentObject private var clientVM: ClientViewModel
    @State private var magnetLink: String = ""
    
    var body: some View {
        VStack{
            TextField("Magnet Link", text: $magnetLink)
            Button("Send Download", action: {
                clientVM.sendDownload(magnetLink: magnetLink)
            })
            .foregroundColor(.white)
            .padding()
            .background(Color.blue)
            .cornerRadius(8)
            
        }.padding()
    }
}

struct SendLinkView_Previews: PreviewProvider {
    static var previews: some View {
        SendLinkView().environmentObject(ClientViewModel(client: Client(id: 1, status: true, clientNickname: "Test", clientName: "QBittorrent", clientConnectionURL: "http://192.168.1.105:8080")))
    }
}
