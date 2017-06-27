//
//  user.swift
//  HeartGuard
//
//  Created by JasonZ on 2017-6-23.
//  Copyright © 2017 saneryee. All rights reserved.
//

import UIKit

class HGUser: NSObject{
    
    // MARK: Shared Instance
    
    static let sharedInstance : HGUser = {
        let instance = HGUser(email: "")
        return instance
    }()
    
    var email:String?
    var userUID:String? // Firebase UserUID
    
    init(email: String){
        
        self.email = email

        super.init()
    }
}
