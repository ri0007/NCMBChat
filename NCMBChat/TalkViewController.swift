//
//  TalkViewController.swift
//  NCMBChat
//
//  Created by 井上 龍一 on 2016/03/15.
//  Copyright © 2016年 Ryuichi Inoue. All rights reserved.
//

//MARK: チャット画面

import UIKit
import NCMB
import JSQMessagesViewController

class TalkViewController: JSQMessagesViewController, TalkManagerDelegate {
    
    var manager = TalkManager()
    
    var outgoingBubbleImageView: JSQMessagesBubbleImage!
    var incomingBubbleImageView: JSQMessagesBubbleImage!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        senderId = NCMBUser.currentUser().objectId ?? "0" //ref.authData.uid // 3
        senderDisplayName = NCMBUser.currentUser().userName ?? "Anonymous" // 4
                
        manager.senderID = senderId
        manager.senderDisplayName = senderDisplayName
        
        title = manager.receiverDisplayName
        
        manager.delegate = self
        manager.isFetchAutomatically = true
    
        setupBubbles()
        
        inputToolbar?.contentView?.leftBarButtonItemWidth = 0.0
        inputToolbar?.contentView?.leftBarButtonItem?.hidden = true
        
        collectionView!.collectionViewLayout.incomingAvatarViewSize = CGSizeZero
        collectionView!.collectionViewLayout.outgoingAvatarViewSize = CGSizeZero
    }
    
    private func setupBubbles() {
        let factory = JSQMessagesBubbleImageFactory()
        outgoingBubbleImageView = factory.outgoingMessagesBubbleImageWithColor(UIColor.jsq_messageBubbleBlueColor())
        incomingBubbleImageView = factory.incomingMessagesBubbleImageWithColor(UIColor.jsq_messageBubbleLightGrayColor())
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        manager.fetchMessages()
    }
    
    func didFetchMessages(error: NSError!, results: [AnyObject]!) {
        print("didFetchMessages is called")
        defer {
            self.finishReceivingMessageAnimated(true)
        }
        
        guard error == nil else {
            return
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func didPressSendButton(button: UIButton!, withMessageText text: String!, senderId: String!,
        senderDisplayName: String!, date: NSDate!) {
            defer {
                finishSendingMessageAnimated(true)
            }
            
            manager.sendMessage(text) { (error) -> Void in
                print(error)
                return
            }
            
            JSQSystemSoundPlayer.jsq_playMessageSentSound()
    }
    
    override func collectionView(collectionView: JSQMessagesCollectionView!,
        messageDataForItemAtIndexPath indexPath: NSIndexPath!) -> JSQMessageData! {
            return manager.messages[indexPath.item]
    }
    
    override func collectionView(collectionView: UICollectionView,
        numberOfItemsInSection section: Int) -> Int {
            return manager.messages.count ?? 0
    }
    
    override func collectionView(collectionView: JSQMessagesCollectionView!,
        messageBubbleImageDataForItemAtIndexPath indexPath: NSIndexPath!) -> JSQMessageBubbleImageDataSource! {
            let message = manager.messages[indexPath.item]
            if message.senderId == senderId {
                return outgoingBubbleImageView
            } else {
                return incomingBubbleImageView
            }
    }
    
    override func collectionView(collectionView: UICollectionView,
        cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
            let cell = super.collectionView(collectionView, cellForItemAtIndexPath: indexPath)
                as! JSQMessagesCollectionViewCell
            
            let message = manager.messages[indexPath.item]
            
            if message.senderId == senderId {
                cell.textView!.textColor = UIColor.whiteColor()
            } else {
                cell.textView!.textColor = UIColor.blackColor()
            }
            
            return cell
    }

    override func collectionView(collectionView: JSQMessagesCollectionView!,
        avatarImageDataForItemAtIndexPath indexPath: NSIndexPath!) -> JSQMessageAvatarImageDataSource! {
            return nil
    }
}
