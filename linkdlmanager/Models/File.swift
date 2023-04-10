//
//  File.swift
//  linkdlmanager
//
//  Created by Agron Gemajli on 4/8/23.
//

import Foundation

struct File: Hashable, Codable, Identifiable {
    var id: String //Will be the 'hash'
    var fileName: String // The files name
}
