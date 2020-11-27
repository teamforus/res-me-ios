//
//  LoginService.swift
//  Me-iOS
//
//  Created by Tcacenco Daniel on 5/6/19.
//  Copyright © 2019 Tcacenco Daniel. All rights reserved.
//

import Foundation


protocol LoginServiceProtocol {
    
    //    func login(complete: @escaping (_ loginUser: LoginUser)->() )
    
    func register(indentity: Identity, complete: @escaping(Register, Int)->(), failure: @escaping(Error)->())
    
}

class LoginService: LoginServiceProtocol{
    
    func register(indentity: Identity, complete: @escaping (Register, Int) -> (), failure: @escaping (Error) -> ()) {
        
        let url = URL(string: BaseURL.baseURL(url: "identity"))!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("me_app-ios", forHTTPHeaderField: "Client-Type")
        
        let parameters = ["email" : indentity.email ?? "", "source": "app-me_app"] as [String : Any]
        
        request.httpBody = ApiService.getPostString(params: parameters).data(using: .utf8)
        
        let session = URLSession.shared
        
        let task = session.dataTask(with: request) { (data, response, error) in
            guard let data = data else { return }
            let decoder = JSONDecoder()
            do {
                
                let responseData = try decoder.decode(Register.self, from: data)
                let httpResponse = response as? HTTPURLResponse
                
                complete(responseData, httpResponse!.statusCode)
            } catch let error {
                
                failure(error)
                
            }
        }
        
        task.resume()
    }
    
    
}
