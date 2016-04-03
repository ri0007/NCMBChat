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
        Login.loginWithBlock(nameField.text!, password: passField.text!, block: { (error, user) in
            guard error == nil else {
                print("Login not Succeed")
                
                Login.signInWithBlock(self.nameField.text!, password: self.passField.text!, block: { (error) in
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
}

