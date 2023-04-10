//
//  EditClientView.swift
//  linkdlmanager
//
//  Created by Agron Gemajli on 4/9/23.
//

import SwiftUI

struct EditClientView: View {
    var client: ClientE
    
    var body: some View {
        Text("This is where the Edit View will go")
    }
}

struct EditClientView_Previews: PreviewProvider {
    
    static var previews: some View {
        EditClientView(client: ClientE())
    }
}
