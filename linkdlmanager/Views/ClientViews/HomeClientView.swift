//
//  HomeClientView.swift
//  linkdlmanager
//  This view is the main "home" view showing all the different clients in a Navigation view that can be entered.
//  It will get the clients saved via CoreData
//  Created by Agron Gemajli on 4/9/23.
//

import SwiftUI

struct HomeClientView: View {
    //This below context would be used if we wanted to save or load new.
    @EnvironmentObject private var mainvm: SettingsViewModel
    
    
    var body: some View {
        NavigationView {
            if !mainvm.savedClients.isEmpty{
            VStack {
                List(mainvm.savedClients) { client in
                    Text(client.clientNickname ?? "Unknown Nickname")
                }
            }
            .navigationTitle("Clients")
        } else {
            Text("No Clients Added. Go to Settings to add one.")
                .navigationTitle("Clients")
        }
        }
    }
}

struct HomeClientView_Previews: PreviewProvider {
    static var previews: some View {
        HomeClientView()
    }
}
