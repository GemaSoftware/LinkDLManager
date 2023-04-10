//
//  SettingsViewModel.swift
//  linkdlmanager
//
//  Created by Agron Gemajli on 4/9/23.
//

import Foundation
import CoreData

class SettingsViewModel: ObservableObject {
    //This view model is essentially going to be leveraging CoreData so that we can access / insert / delete items as needed for this View. Most likely just to insert.
    
    //Core Data Items
    let container: NSPersistentContainer
    let moc: NSManagedObjectContext
    
    //View Model Items
    @Published var savedClients: [ClientE] = []
    
    
    //init the core data
    init(){
        container = ClientDataController().container
        moc = container.viewContext
        self.fetchClients()
    }
    
    //Functions
    
    /*
     This function will fetch all clients in the CoreData
     Also can be used to update any UI that relies on this data
     as the @Published var savedClients is affected by this.
     */
    func fetchClients(){
        //Create Fetch Request for all clients
        let clients = NSFetchRequest<ClientE>(entityName: "ClientE")
        //fetch the clients and store in the published var.
        do{
            try savedClients = moc.fetch(clients)
            print(savedClients)
        } catch let error {
            print("Error fetching clients: \(error)")
        }
    }
    
    struct MyError: Error {
        let errorMessage: String
    }
    
    /*
     This function will run when we want to add a new Client to CoreData for use in the app.
     */
    func addClientIfNotExist(clientNickname: String, clientConnectionURL: String, clientUsername: String?, clientPassword: String?, completion: @escaping (Bool) -> Void) {
        var success: Bool = false
        
        do {
            //first we want to check if there exists a client with that Nickname already
            let clients = NSFetchRequest<ClientE>(entityName: "ClientE")
            let isExist = try container.viewContext.fetch(clients).contains(where: { client in
                client.clientNickname == clientNickname
            })
            if isExist {
                throw MyError(errorMessage: "Client Nickname already exists")
            } else {
                //begin building the client to save.
                let newClient = ClientE(context: container.viewContext)
                newClient.id = UUID()
                newClient.clientNickname = clientNickname
                newClient.clientConnectionURL = clientConnectionURL
                newClient.clientType = "Qbittorrent"
                
                //set up authentication
                newClient.clientAuth = ClientAuthentication(context: container.viewContext)
                newClient.clientAuth?.cauthID = UUID()
                newClient.clientAuth?.userName = clientUsername
                newClient.clientAuth?.userPassword = clientPassword
                
                //Attempt to save
                try moc.save()
                
                //if no errors, make success = true
                print("Successfully Saved new Client")
                success = true
                self.fetchClients()
            }
            
        } catch let error {
            print("Adding Client Failed: \(error.localizedDescription)")
            success = false
        }
        completion(success)
        
    }
    
    /*
     This function will run when the onDelete is called in the List View
     It will take all indicies of items to delete, and deletes them from CoreData
     Then calls fetchClients to update view.
     */
    func deleteClients(clientsToDelete: IndexSet) {
        for index in clientsToDelete {
            let client = savedClients[index]
            container.viewContext.delete(client)
            do {
                try moc.save()
                self.fetchClients() //this will update any UI
            } catch let error {
                print("Error Deleting Client: \(error.localizedDescription)")
            }
        }
    }
    
    
    
}
