//
//  Login.swift
//  NCMBChat
//
//  Created by 井上 龍一 on 2016/04/03.
//  Copyright © 2016年 Ryuichi Inoue. All rights reserved.
//

import UIKit
import NCMB

class Login: NSObject {
    
    class func signInWithBlock(userName: String, password: String, block:((NSError!)->Void)!) {
        let user = NCMBUser()
        user.userName = userName
        user.password = password
        
        user.signUpInBackgroundWithBlock { (error) -> Void in
            guard error == nil else {
                print(error)
                block?(error)
                return
            }
            
            block?(nil)
        }
    }
    
    class func loginWithBlock(userName: String, password: String, block:((NSError!, NCMBUser!)->Void)!) {
        NCMBUser.logInWithUsernameInBackground(userName, password: password, block: { (user, error) in
            guard error == nil else {
                print(error)
                block?(error, nil)
                return
            }
            
            block?(nil, user)
        })
    }
}
