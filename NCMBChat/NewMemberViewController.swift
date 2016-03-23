//
//  NewMemberViewController.swift
//  NCMBChat
//
//  Created by 井上 龍一 on 2016/03/15.
//  Copyright © 2016年 Ryuichi Inoue. All rights reserved.
//

//MARK: 新規ユーザー検索画面

import UIKit
import NCMB

class NewMemberViewController: UIViewController, UISearchBarDelegate {

    @IBOutlet weak var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        searchBar.placeholder = "Search by Username"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func findUser(result:AnyObject) {
        guard let user = result as? NCMBUser else {
            return
        }
        
        let VCs = navigationController!.viewControllers
        
        guard let talkListVC = VCs.first as? TalkListTableViewController else {
            return
        }
        
        talkListVC.newMember = user
        navigationController?.popViewControllerAnimated(true)
    }
    
    // MARK: - UISearchBarDelegate
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        searchBar.text = ""
        searchBar.resignFirstResponder()
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        guard searchBar.text != nil else {
            return
        }
        
        let query = NCMBUser.query()
        query.whereKey("userName", equalTo: searchBar.text!)
        query.findObjectsInBackgroundWithBlock { (results, error) -> Void in
            guard error == nil else {
                print(error)
                return
            }
            
            guard let result = results.first else {
                return
            }
            
            self.findUser(result)
        }
    }
}
