//
//  ClientDataController.swift
//  linkdlmanager
//
//  Created by Agron Gemajli on 4/9/23.
//

import CoreData
import Foundation

class ClientDataController: ObservableObject {
    let container = NSPersistentContainer(name: "ClientDM")
    
    init(){
        container.loadPersistentStores { description, err in
            if let err = err {
                print("Core Data failed to load: \(err.localizedDescription)")
            }
        }
    }
}
