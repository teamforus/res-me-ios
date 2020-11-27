//
//  CommonService.swift
//  Me-iOS
//
//  Created by Tcacenco Daniel on 5/6/19.
//  Copyright © 2019 Tcacenco Daniel. All rights reserved.
//

import Foundation

protocol CommonServiceProtocol {
    func get<T: Decodable>(request:String ,complete: @escaping (_ response: T,_ statusCode: Int)->(), failure: @escaping(_ error: Error)->() )
    
    
    
    func getWithoutToken<T: Decodable>(request:String ,complete: @escaping (_ response: T,_ statusCode: Int)->(), failure: @escaping(_ error: Error)->() )
    
    func getById<T: Decodable>(request:String, id: String ,complete: @escaping (_ response: T,_ statusCode: Int)->(), failure: @escaping(_ error: Error)->()  )
    
    func createById<T: Decodable, E: Encodable>(request:String, id: String, data: E ,complete: @escaping (_ response: T,_ statusCode: Int)->() )
    
    func patch<T: Decodable, E: Encodable>(request:String, data: E ,complete: @escaping (_ response: T,_ statusCode: Int)->() )
    
    func patchWithoutParam(request:String, complete: @escaping (_ statusCode: Int)->() )
    
    func create<T: Decodable, E: Encodable>(request:String, data: E,complete: @escaping (_ response: T,_ statusCode: Int)->() )
    
    func post<T: Decodable>(request:String, complete: @escaping (_ response: T,_ statusCode: Int)->() )
    
    func postWithoutToken<T: Decodable, E: Encodable>(request:String, e: E , complete: @escaping (_ response: T,_ statusCode: Int)->(), failure: @escaping(_ error: Error)->())
    
    func getByType<E: RawRepresentable, T: Decodable>(request:String ,e: E ,complete: @escaping (_ response: T, _ statusCode: Int)->() ) where E.RawValue == String
    
    func postWithParameters<T: Decodable>(request: String, parameters: [String : Any], complete: @escaping (_ response: T, _ statusCode: Int)->(), failure: @escaping(_ error: Error)->())
    
    func postWithoutParamtersAndResponse(request: String, complete: @escaping ( _ statusCode: Int)->(), failure: @escaping(_ error: Error)->())
    
    func postWithoutResponse<E: Encodable>(request: String, body: E,  complete: @escaping ( _ statusCode: Int)->(), failure: @escaping(_ error: Error)->())
    
    func deleteWithoutResponse<E: Encodable>(request: String, body: E,  complete: @escaping ( _ statusCode: Int)->(), failure: @escaping(_ error: Error)->())
    
    func postWithParametersWithoutToken<T: Decodable>(request: String, parameters: [String : Any], complete: @escaping (_ response: T, _ statusCode: Int)->(), failure: @escaping(_ error: Error)->())
    
    func deleteById(request: String, id: String, complete: @escaping ( _ statusCode: Int)->(), failure: @escaping(_ error: Error)->())
}

class CommonService: CommonServiceProtocol {
    
    func deleteWithoutResponse<E>(request: String, body: E, complete: @escaping (Int) -> (), failure: @escaping (Error) -> ()) where E : Encodable {
        
        let url = URL(string: BaseURL.baseURL(url: request))!
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.addValue("me_app-ios", forHTTPHeaderField: "Client-Type")
        request.addValue("Bearer " + CurrentSession.shared.token, forHTTPHeaderField: "Authorization")
        
        do {
            let encodePost = ApiService.getPostString(params: ["id" : (body as! BodyId).id!]).data(using: .utf8)
            request.httpBody = encodePost
        }
        
        let session = URLSession.shared
        
        let task = session.dataTask(with: request) { (data, response, error) in
            guard data != nil else { return }
            _ = JSONDecoder()
            
            let httpResponse = response as? HTTPURLResponse
            
            complete( httpResponse!.statusCode)
            
        }
        
        task.resume()
    }
    
    
    func postWithoutResponse<E>(request: String, body: E, complete: @escaping (Int) -> (), failure: @escaping (Error) -> ()) where E : Encodable {
        
        let url = URL(string: BaseURL.baseURL(url: request))!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("me_app-ios", forHTTPHeaderField: "Client-Type")
        request.addValue("Bearer " + CurrentSession.shared.token, forHTTPHeaderField: "Authorization")
        
        do {
            let encodePost = ApiService.getPostString(params: ["id" : (body as! BodyId).id!]).data(using: .utf8)
            request.httpBody = encodePost
        }
        
        let session = URLSession.shared
        
        let task = session.dataTask(with: request) { (data, response, error) in
            guard data != nil else { return }
            let _ = JSONDecoder()
            
            let httpResponse = response as? HTTPURLResponse
            
            complete( httpResponse!.statusCode)
            
        }
        
        task.resume()
    }
    
    
    func postWithoutParamtersAndResponse(request: String, complete: @escaping (Int) -> (), failure: @escaping (Error) -> ()) {
        
        let url = URL(string: BaseURL.baseURL(url: request))!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("me_app-ios", forHTTPHeaderField: "Client-Type")
        request.addValue("Bearer " + CurrentSession.shared.token, forHTTPHeaderField: "Authorization")
        
        
        
        let session = URLSession.shared
        
        let task = session.dataTask(with: request) { (data, response, error) in
            guard data != nil else { return }
            _ = JSONDecoder()
            let httpResponse = response as? HTTPURLResponse
            
            complete( httpResponse!.statusCode)
            
        }
        
        task.resume()
        
    }
    
    
    
    func postWithoutToken<T, E>(request: String, e: E, complete: @escaping (T, Int) -> (), failure: @escaping (Error) -> ()) where T : Decodable, E : Encodable {
        
        
        let url = URL(string: BaseURL.baseURL(url: request))!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("me_app-ios", forHTTPHeaderField: "Client-Type")
        
        do {
            let encodePost = try JSONEncoder().encode(e)
            request.httpBody = encodePost
        } catch{}
        
        let session = URLSession.shared
        
        let task = session.dataTask(with: request) { (data, response, error) in
            guard let data = data else { return }
            let decoder = JSONDecoder()
            do {
                
                let responseData = try decoder.decode(T.self, from: data)
                let httpResponse = response as? HTTPURLResponse
                
                complete(responseData, httpResponse!.statusCode)
            } catch let error {
                
                failure(error)
                
            }
        }
        
        task.resume()
        
    }
    
    
    
    func deleteById(request: String, id: String, complete: @escaping (Int) -> (), failure: @escaping (Error) -> ()) {
        
        let url = URL(string: BaseURL.baseURL(url: request + id))!
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("me_app-ios", forHTTPHeaderField: "Client-Type")
        request.addValue("Bearer " + CurrentSession.shared.token, forHTTPHeaderField: "Authorization")
        
        let session = URLSession.shared
        
        let task = session.dataTask(with: request) { (data, response, error) in
            guard data != nil else { return }
                
                let httpResponse = response as? HTTPURLResponse
                
                complete(httpResponse!.statusCode)
        }
        
        task.resume()
    }
    
    
    func postWithParameters<T>(request: String, parameters: [String : Any], complete: @escaping (T, Int) -> (), failure: @escaping (Error) -> ()) where T : Decodable {
        
        let url = URL(string: BaseURL.baseURL(url: request))!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("me_app-ios", forHTTPHeaderField: "Client-Type")
        request.addValue("Bearer " + CurrentSession.shared.token, forHTTPHeaderField: "Authorization")
        
        request.httpBody = ApiService.getPostString(params: parameters).data(using: .utf8)
        
        let session = URLSession.shared
        
        let task = session.dataTask(with: request) { (data, response, error) in
            guard let data = data else { return }
            let decoder = JSONDecoder()
            do {
                
                let responseData = try decoder.decode(T.self, from: data)
                let httpResponse = response as? HTTPURLResponse
                
                complete(responseData, httpResponse!.statusCode)
            } catch let error {
                
                failure(error)
                
            }
        }
        
        task.resume()
    }
    
    func postWithParametersWithoutToken<T>(request: String, parameters: [String : Any], complete: @escaping (T, Int) -> (), failure: @escaping (Error) -> ()) where T : Decodable {
        
        let url = URL(string: BaseURL.baseURL(url: request))!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("me_app-ios", forHTTPHeaderField: "Client-Type")
        request.addValue("general", forHTTPHeaderField: "Client-key")
        
        request.httpBody = ApiService.getPostString(params: parameters).data(using: .utf8)
        
        let session = URLSession.shared
        
        let task = session.dataTask(with: request) { (data, response, error) in
            guard let data = data else { return }
            let decoder = JSONDecoder()
            do {
                
                let responseData = try decoder.decode(T.self, from: data)
                let httpResponse = response as? HTTPURLResponse
                
                complete(responseData, httpResponse!.statusCode)
            } catch let error {
                
                failure(error)
                
            }
        }
        
        task.resume()
    }
    
    
    
    func get<T>(request: String, complete: @escaping (T, Int) -> (), failure: @escaping (Error) -> ()) where T : Decodable {
        
        var request = URLRequest(url: URL(string: BaseURL.baseURL(url: request))!)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("me_app-ios", forHTTPHeaderField: "Client-Type")
        request.addValue(getLanguageISO(), forHTTPHeaderField: "Accept-Language")
        if let token = CurrentSession.shared.token {
        request.addValue("Bearer " + token , forHTTPHeaderField: "Authorization")
        }
        
        let session = URLSession.shared
        
        let task = session.dataTask(with: request) { (data, response, error) in
            guard let data = data else { return }
            let decoder = JSONDecoder()
            do {
                
                let responseData = try decoder.decode( T.self, from: data)
                let httpStatus = response as! HTTPURLResponse
                complete(responseData, httpStatus.statusCode)
                
            } catch let jsonError {
                failure(jsonError)
            }
        }
        
        task.resume()
    }
    
    func getWithoutToken<T>(request: String, complete: @escaping (T, Int) -> (), failure: @escaping (Error) -> ()) where T : Decodable {
        
        var request = URLRequest(url: URL(string: BaseURL.baseURL(url: request))!)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("me_app-ios", forHTTPHeaderField: "Client-Type")
        
        let session = URLSession.shared
        
        let task = session.dataTask(with: request) { (data, response, error) in
            guard let data = data else { return }
            let decoder = JSONDecoder()
            do {
                
                let responseData = try decoder.decode( T.self, from: data)
                let httpStatus = response as! HTTPURLResponse
                complete(responseData, httpStatus.statusCode)
                
            } catch let jsonError {
                failure(jsonError)
            }
        }
        
        task.resume()
    }
    
    
    
    func getById<T>(request: String, id: String, complete: @escaping (T, Int) -> (), failure: @escaping (Error) -> ()) where T : Decodable {
        
        var request = URLRequest(url: URL(string: BaseURL.baseURL(url: request + id))!)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("me_app-ios", forHTTPHeaderField: "Client-Type")
        request.addValue("Bearer " + CurrentSession.shared.token, forHTTPHeaderField: "Authorization")
        
        let session = URLSession.shared
        
        let task = session.dataTask(with: request) { (data, response, error) in
            guard let data = data else { return }
            let decoder = JSONDecoder()
            do {
                
                let responseData = try decoder.decode( T.self, from: data)
                let httpStatus = response as? HTTPURLResponse
                complete(responseData, httpStatus!.statusCode)
            } catch let error {
                failure(error)
                
            }
        }
        
        task.resume()
        
    }
    
    func createById<T, E>(request: String, id: String, data: E, complete: @escaping (T, Int) -> ()) where T : Decodable, E : Encodable {
        
        let url = URL(string: BaseURL.baseURL(url: request + id))!
        var request = URLRequest(url: url)
        request.httpMethod = "PATCH"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("me_app-ios", forHTTPHeaderField: "Client-Type")
        request.addValue("Bearer " + CurrentSession.shared.token, forHTTPHeaderField: "Authorization")
        
        do {
            let encodePost = try JSONEncoder().encode(data)
            request.httpBody = encodePost
        } catch{}
        
        let session = URLSession.shared
        
        let task = session.dataTask(with: request) { (data, response, error) in
            guard let data = data else { return }
            let decoder = JSONDecoder()
            do {
                
                let responseData = try decoder.decode(T.self, from: data)
                let httpResponse = response as? HTTPURLResponse
                
                complete(responseData, httpResponse!.statusCode)
            } catch {}
        }
        
        task.resume()
        
    }
    
    func patch<T, E>(request: String, data: E, complete: @escaping (T, Int) -> ()) where T : Decodable, E : Encodable {
        
        let url = URL(string: BaseURL.baseURL(url: request))!
        var request = URLRequest(url: url)
        request.httpMethod = "PATCH"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("me_app-ios", forHTTPHeaderField: "Client-Type")
        request.addValue("Bearer " + CurrentSession.shared.token, forHTTPHeaderField: "Authorization")
        
        do {
            let encodePost = try JSONEncoder().encode(data)
            request.httpBody = encodePost
        } catch{}
        
        let session = URLSession.shared
        
        let task = session.dataTask(with: request) { (data, response, error) in
            guard let data = data else { return }
            let decoder = JSONDecoder()
            do {
                
                let responseData = try decoder.decode(T.self, from: data)
                let httpResponse = response as? HTTPURLResponse
                
                complete(responseData, httpResponse!.statusCode)
            } catch {}
        }
        
        task.resume()
        
    }
    
    func patchWithoutParam(request: String, complete: @escaping (Int) -> ()) {
        
        let url = URL(string: BaseURL.baseURL(url: request))!
        var request = URLRequest(url: url)
        request.httpMethod = "PATCH"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("me_app-ios", forHTTPHeaderField: "Client-Type")
        request.addValue("Bearer " + CurrentSession.shared.token, forHTTPHeaderField: "Authorization")
        
        let data = ["state" : "accepted"]
        
        do {
            let encodePost = try JSONEncoder().encode(data)
            request.httpBody = encodePost
        } catch{}
        
        
        let session = URLSession.shared
        
        let task = session.dataTask(with: request) { (data, response, error) in
                let httpResponse = response as? HTTPURLResponse
         
                complete(httpResponse!.statusCode)
        }
        
        task.resume()
    }
    
    func create<T, E>(request: String, data: E, complete: @escaping (T, Int) -> ()) where T : Decodable, E : Encodable {
        
        let url = URL(string: BaseURL.baseURL(url: request))!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("me_app-ios", forHTTPHeaderField: "Client-Type")
        request.addValue("Bearer " + CurrentSession.shared.token, forHTTPHeaderField: "Authorization")
        
        do {
            let encodePost = try JSONEncoder().encode(data)
            request.httpBody = encodePost
        } catch{}
        
        let session = URLSession.shared
        
        let task = session.dataTask(with: request) { (data, response, error) in
            guard let data = data else { return }
            let decoder = JSONDecoder()
            do {
                
                let responseData = try decoder.decode(T.self, from: data)
                let httpResponse = response as? HTTPURLResponse
                
                complete(responseData, httpResponse!.statusCode)
            } catch {}
        }
        
        task.resume()
        
    }
    
    func post<T>(request: String, complete: @escaping (T, Int) -> ()) where T : Decodable {
        
        let url = URL(string: BaseURL.baseURL(url: request))!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("me_app-ios", forHTTPHeaderField: "Client-Type")
        if CurrentSession.shared.token != nil {
        request.addValue("Bearer " + CurrentSession.shared.token , forHTTPHeaderField: "Authorization")
        }
        
        let session = URLSession.shared
        
        let task = session.dataTask(with: request) { (data, response, error) in
            guard let data = data else { return }
            let decoder = JSONDecoder()
            do {
                
                let responseData = try decoder.decode(T.self, from: data)
                let httpResponse = response as? HTTPURLResponse
                
                complete(responseData, httpResponse!.statusCode)
            } catch {
                
            }
        }
        
        task.resume()
    }
    
    func getByType<E, T>(request:String, e: E, complete: @escaping (T, Int) -> ()) where E : RawRepresentable, T : Decodable, E.RawValue == String {
        
        var componentsUrl = URLComponents(string: BaseURL.baseURL(url: request))!
        if e.rawValue != "" {
            componentsUrl.queryItems = [ URLQueryItem(name: "type", value: e.rawValue)]
        }
        
        var request = URLRequest(url: componentsUrl.url!)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("me_app-ios", forHTTPHeaderField: "Client-Type")
        request.addValue("Bearer " + CurrentSession.shared.token, forHTTPHeaderField: "Authorization")
        
        let session = URLSession.shared
        
        let task = session.dataTask(with: request) { (data, response, error) in
            guard let data = data else { return }
            let decoder = JSONDecoder()
            do {
                
                let responseData = try decoder.decode(T.self, from: data)
                let httpStatus = response as! HTTPURLResponse
                
                complete(responseData, httpStatus.statusCode)
            } catch {}
        }
        
        task.resume()
    }
    
}


extension CommonService {
    
    func getLanguageISO() -> String {
        return Locale.current.languageCode!
    }
    
}
