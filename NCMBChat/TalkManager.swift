//
//  TalkManager.swift
//  NCMBChat
//
//  Created by 井上 龍一 on 2016/03/15.
//  Copyright © 2016年 Ryuichi Inoue. All rights reserved.
//

import UIKit
import NCMB
import JSQMessagesViewController

protocol TalkManagerDelegate: class {
    func didFetchMessages(error: NSError!, results: [AnyObject]!)
}

class TalkManager: NSObject {
    var messages = [JSQMessage]()
    weak var delegate: TalkManagerDelegate?
    var senderID = ""
    var senderDisplayName = ""
    var receiverID = ""
    var receiverDisplayName = ""
    
    var timer:NSTimer!
    
    var isFetchAutomatically = false {
        didSet {
            if isFetchAutomatically {
                timer?.fire()
            } else {
                timer?.invalidate()
            }
        }
    }
    
    override init() {
        super.init()
        timer = NSTimer.scheduledTimerWithTimeInterval(3.0, target: self, selector: "fetchMessages", userInfo: nil, repeats: true)
    }
    
    func fetchMessages() {
        let query1 = NCMBQuery(className: "Message")
        query1.whereKey("senderID", equalTo: senderID)
        query1.whereKey("receiverID", equalTo: receiverID)

        let query2 = NCMBQuery(className: "Message")
        query2.whereKey("senderID", equalTo: receiverID)
        query2.whereKey("receiverID", equalTo: senderID)
        
        let query = NCMBQuery.orQueryWithSubqueries([query1,query2])

        if messages.count >= 1 {
            query.whereKey("createDate", greaterThan: messages.last!.date)
        }
        
        query.orderByAscending("createDate")
        query.findObjectsInBackgroundWithBlock { (results, error) -> Void in
            guard error == nil else {
                return
            }
            
            guard let messages = results as? [NCMBObject] else {
                return
            }
            
            let localeIdentifier = NSBundle.mainBundle().preferredLocalizations.first!
            let locale = NSLocale(localeIdentifier: localeIdentifier)
            
            let formatter = NSDateFormatter()
            formatter.locale = locale
            formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
            
            for item in messages {
                let messageDateString = item.objectForKey("createDate") as! String
                let messageDate = formatter.dateFromString(messageDateString)
                
                let message = JSQMessage(senderId: item.objectForKey("senderID") as! String,
                    senderDisplayName: item.objectForKey("senderDisplayName") as! String,
                    date: messageDate,
                    text: item.objectForKey("body") as! String)
                
                self.messages.append(message)
            }
            
            self.delegate?.didFetchMessages(error, results: results)
        }
    }
    
    func sendMessage(text: String, errorBlock: ((NSError!) -> Void)! ) {        
        let message = NCMBObject(className: "Message")
        message.setObject(text, forKey: "body")
        
        message.setObject(senderID, forKey: "senderID")
        message.setObject(senderDisplayName, forKey: "senderDisplayName")
        
        message.setObject(receiverID, forKey: "receiverID")
        message.setObject(receiverDisplayName, forKey: "receiverDisplayName")
        
        message.saveInBackgroundWithBlock { (error) -> Void in
            guard error == nil else {
                self.messages.removeLast()
                errorBlock?(error)
                return
            }
        }
    }
    
}
