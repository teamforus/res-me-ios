//
//  RegisterViewModel.swift
//  Me-iOS
//
//  Created by Tcacenco Daniel on 5/8/19.
//  Copyright © 2019 Tcacenco Daniel. All rights reserved.
//

import Foundation


class RegisterViewModel{
    
    var registerService: LoginServiceProtocol!
    var complete: ((Register, Int)->())!
    
    init(registerService: LoginServiceProtocol = LoginService()) {
        self.registerService = registerService
    }
    
   func initRegister(identity: Identity){
        registerService.register(indentity: identity, complete: { (response, statusCode) in
        self.complete(response, statusCode)
        }) { (error) in
      }
    }
}
