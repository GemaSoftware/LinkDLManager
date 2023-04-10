//
//  ClientViewModel.swift
//  linkdlmanager
//
//  Created by Agron Gemajli on 4/8/23.
//

import Foundation

class ClientViewModel: ObservableObject {
    @Published var client: Client
    
    init(client: Client){
        self.client = client
    }
    
    
    //Functions
    
    func buildWebRequest(endpoint: String, method: String, postData: String = "", completion: @escaping (Result<Data, Error>) -> Void) {
        guard let url = URL(string: client.clientConnectionURL + endpoint) else {
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method
        
        if(method == "POST" && !postData.isEmpty){
            //pass in post data
            request.httpBody = postData.data(using: .utf8)
        }
        
        
        //TODO: need to make make error handling here. Temporary for now
        if self.client.clientCookie.isEmpty{
            authenticate()
        }
        
        //Set Up Cookie for Use in request.
        let sid = self.client.clientCookie
        let CookieProprties = HTTPCookie(properties: [
            .domain: client.clientConnectionURL,
            .path: "/",
            .name: "SID",
            .value: sid
        ])
        if let cookie = CookieProprties {
            request.addValue("Cookie", forHTTPHeaderField: cookie.value)
        }
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
            } else if let data = data {
                completion(.success(data))
            }
        }.resume()
        
    }
    
    func getFiles(){
        var successData: Data?
        var failureError: Error?
        buildWebRequest(endpoint: "/api/v2/torrents/info", method: "GET") { result in
            //This is where we can work with the data task details once it completes.
            switch result{
            case .failure(let error):
                failureError = error
            case .success(let data):
                successData = data
            }
            //if there was an error
            if failureError != nil {
                print("err0r: \(failureError?.localizedDescription ?? "Something went wrong")")
                return
            }
            
            //otherwise, here is where we work for the "get files: function
            if successData != nil {
                do{
                    let jsonOut = try JSONSerialization.jsonObject(with: successData!, options: []) //already checked for nil. Can force unwrap here.
                    if let jsonArray = jsonOut as? [[String: Any]] {
                        for object in jsonArray{
                            if let fileHash = (object["hash"] ?? "") as? String {
                                if let fileName = (object["name"] ?? "No Name Provided") as? String {
                                    let fileToAdd = File(id: fileHash, fileName: fileName)
                                    //if file not in the files array already, add it now.
                                    if !self.client.files.contains(fileToAdd){
                                        DispatchQueue.main.async {
                                            self.client.files.append(fileToAdd)
                                            print("Added \(fileToAdd.fileName) to list")
                                        }
                                    } else {
                                        //check for file name changes
                                        //TODO: this will get reworked and changed.
                                        if self.client.files.first(where: {$0.hashValue == fileToAdd.hashValue})?.fileName != fileToAdd.fileName {
                                            var loc = self.client.files.firstIndex(of: self.client.files.first(where: {$0.hashValue == fileToAdd.hashValue})!)
                                            DispatchQueue.main.async {
                                                self.client.files[loc!] = fileToAdd
                                            }
                                        }
                                    }
                                }
                            }
                        }
                        //this will ensure that we remove files as they complete also.
                        DispatchQueue.main.async {
                            self.client.files = self.client.files.filter{ file in
                                return jsonArray.contains { item in
                                    return item["hash"] as? String == file.id
                                }
                            }
                        }
                    }
                } catch {
                    print("Erorr parsing JSON \(error.localizedDescription)")
                }
            }
            
        }
    }
    
    func sendDownload(magnetLink: String) {
        var successData: Data?
        var failError: Error?
        //if not authenticated, sign in and get cookie.
        if self.client.clientCookie.isEmpty {
                authenticate()
        } else {
            let urlToAdd: String = "urls=\(magnetLink)"
            buildWebRequest(endpoint: "/api/v2/torrents/add", method: "POST", postData: urlToAdd) { res in
                switch res{
                case .success(let data):
                    successData = data
                case .failure(let fail):
                    failError = fail
                }
                
                if failError != nil {
                    print("err0r: \(failError?.localizedDescription ?? "Something went wrong")")
                    return
                }
                
                if successData != nil {
                    print("For now,looks like URL went to client. Check homepage")
                }
                
            }
        }
    }
    
    //This function authenticates the user with qBitt and stores the session cookie to the viewmodel.
    func authenticate() {
        //set up URL from the client variables.
        guard let url = URL(string: client.clientConnectionURL + "/api/v2/auth/login") else {
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        //TODO: removed the below Body line to authenticate. This function will need rework after we reesigned the ViewModels and Views
        request.httpBody = "".data(using: .utf8) // We will need to find a credentials manager in swift to pass in the authentication fields securely. For now, removing from text and leaving blank.
        
        // Performing the request
        URLSession.shared.dataTask(with: request) {data, response, error in
            //handle errors first
            guard let data = data, error == nil else {
                DispatchQueue.main.async {
                    //if error, set status to false.
                    self.client.status = false
                }
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse {
                        if httpResponse.statusCode == 200 {
                            // Authentication successful
                            // Capture the "Set-Cookie" value from the response headers
                            if let setCookie = httpResponse.allHeaderFields["Set-Cookie"] as? String {
                                // Update the client's cookie property
                                DispatchQueue.main.async {
                                    self.client.clientCookie = (setCookie.components(separatedBy: ";").first?.components(separatedBy: "=").last)!
                                }
                            }
                            
                            // Update the status property
                            DispatchQueue.main.async {
                                self.client.status = true
                                
                            }
                        } else {
                            // Authentication failed
                            // Update the status property accordingly
                            DispatchQueue.main.async {
                                self.client.status = false
                            }
                        }
                    }
            
            if let data = String(data: data, encoding: .utf8){
                DispatchQueue.main.async {
                    print("RESPONSE FROM SERVER AUTH: \(data)")
                }
            }
        }.resume()
    }
}
