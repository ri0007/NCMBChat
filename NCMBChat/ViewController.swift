//
//  ViewController.swift
//  NCMBChat
//
//  Created by 井上 龍一 on 2016/03/15.
//  Copyright © 2016年 Ryuichi Inoue. All rights reserved.
//

//MARK: ログインorサインイン画面

import UIKit
import NCMB

class ViewController: UIViewController {

    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var passField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @IBAction func clickedButton(sender: UIButton) {
        loginWithBlock(nameField.text!, password: passField.text!, block: { (error, user) in
            guard error == nil else {
                print("Login not Succeed")
                
                self.signInWithBlock(self.nameField.text!, password: self.passField.text!, block: { (error) in
                    guard error == nil else {
                        print("SignIn not Succeed")
                        return
                    }
                    
                    print("SignIn Succeed")
                    self.succeedLoginOrSignin()
                })
                
                return
            }
            
            print("Login Succeed")
            self.succeedLoginOrSignin()
        })
    }
    
    func succeedLoginOrSignin() {
        performSegueWithIdentifier("TalkSelect", sender: self)
    }

    func signInWithBlock(userName: String, password: String, block:((NSError!)->Void)!) {
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
    
    func loginWithBlock(userName: String, password: String, block:((NSError!, NCMBUser!)->Void)!) {
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

