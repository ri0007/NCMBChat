//
//  TalkListTableViewController.swift
//  NCMBChat
//
//  Created by 井上 龍一 on 2016/03/15.
//  Copyright © 2016年 Ryuichi Inoue. All rights reserved.
//

//MARK: ユーザー一覧画面

import UIKit
import NCMB
class TalkListTableViewController: UITableViewController {

    var members = [NCMBUser]()
    var newMember: NCMBUser? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        if newMember != nil {
            members.append(newMember!)
            tableView.insertRowsAtIndexPaths([NSIndexPath(forRow: members.count - 1, inSection: 0)], withRowAnimation: .Automatic)
            newMember = nil
        }
    }
    
    @IBAction func clickAddButton(sender: UIBarButtonItem) {
        performSegueWithIdentifier("New", sender: self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        super.prepareForSegue(segue, sender: sender)
        
        if segue.identifier == "Talk" {
            guard let member = sender as? NCMBUser else {
                return
            }
            guard let talkVC = segue.destinationViewController as? TalkViewController else {
                return
            }
            
            talkVC.manager.receiverID = member.objectId
            talkVC.manager.receiverDisplayName = member.userName
        }
    }
    
    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return members.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)

        cell.textLabel?.text = members[indexPath.row].userName

        return cell
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {        
        let member = members[indexPath.row]
        performSegueWithIdentifier("Talk", sender: member)
    }
}
