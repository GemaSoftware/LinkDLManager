//
//  Client.swift
//  linkdlmanager
//
//  Created by Agron Gemajli on 4/8/23.
//

import Foundation
import SwiftUI

struct Client: Hashable, Identifiable, Codable {
    var id: Int
    var status: Bool // This will tell us if client connection is successful.
    var clientNickname: String? // Nickname of client for user to modify.
    var clientName: String // Name of client - set in stone.
    var clientConnectionURL: String // Connection URL of the client to connect to.
    var clientCookie: String // Cookie once user is authenticated.
    var files: Array<File>
    
    init(id: Int, status: Bool, clientNickname: String, clientName: String, clientConnectionURL: String) {
        self.id = id
        self.status = status
        self.clientNickname = clientNickname
        self.clientName = clientName
        self.clientConnectionURL = clientConnectionURL
        self.clientCookie = ""
        self.files = Array()
    }
    
    init(clientName: String, clientConnectionURL: String) {
        self.id = 0
        self.clientName = clientName
        self.clientConnectionURL = clientConnectionURL
        self.status = false
        self.clientNickname = nil
        self.clientCookie = ""
        self.files = Array()
    }

}
