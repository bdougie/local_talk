//
//  MessagesCollectionViewController.swift
//  LocalTalk
//
//  Created by Brian Douglas on 9/30/15.
//  Copyright © 2015 MutualFun. All rights reserved.
//

import UIKit
import Firebase
import JSQMessagesViewController

private let reuseIdentifier = "Cell"

class MessagesCollectionViewController: JSQMessagesViewController {

    var user: FAuthData?
    
    var messages = [Message]()
    var avatars = Dictionary<String, UIImage>()
    var outgoingBubbleImage = JSQMessagesBubbleImageFactory().outgoingMessagesBubbleImageWithColor(UIColor.jsq_messageBubbleLightGrayColor())
    var incomingBubbleImage = JSQMessagesBubbleImageFactory().incomingMessagesBubbleImageWithColor(UIColor.jsq_messageBubbleGreenColor())
    var senderImagePath: String!
    var batchMessages = true
    var ref: Firebase!
    
    // *** STEP 1: STORE FIREBASE REFERENCES
    var messagesRef: Firebase!
    
    func setupFirebase() {
        // *** STEP 2: SETUP FIREBASE
        messagesRef = Firebase(url: "https://resplendent-torch-6823.firebaseio.com/messages")
        
        // *** STEP 4: RECEIVE MESSAGES FROM FIREBASE (limited to latest 25 messages)
        messagesRef.queryLimitedToFirst(25).observeEventType(FEventType.ChildAdded, withBlock: { (snapshot) in
            let text = snapshot.value["text"] as? String
            let senderDetails = snapshot.value["sender"] as AnyObject!
            let imagePath = snapshot.value["imagePath"] as? String
            let isMediaMessage = snapshot.value["isMediaMessage"] as? Bool
            let messageHash = snapshot.value["messageHash"] as? UInt
            
            let senderId = senderDetails!["senderId"] as! NSNumber
            let senderIdString = senderId.stringValue
            let senderName = senderDetails!["senderDisplayName"] as! String
            let senderImagePath = senderDetails!["senderImagePath"] as! String
            
            let sender = Contact(id: senderIdString, name: senderName, image: senderImagePath) as Contact
            
            let message = Message(sender: sender, isMediaMessage: isMediaMessage!, messageHash: messageHash!, text: text!, imagePath: imagePath)
            if senderName == self.senderDisplayName {
                self.messages.append(message)
            }
            self.finishReceivingMessage()
        })
    }
    
    func sendMessage(text: String!, sender: String!) {
        // *** STEP 3: ADD A MESSAGE TO FIREBASE
        messagesRef.childByAutoId().setValue([
            "text":text,
            "sender":sender,
            "imagePath":senderImagePath
            ])
    }
    
    func tempSendMessage(text: String!, sender: Contact) {
        let message = Message(sender: sender, isMediaMessage: true, messageHash: 1, text: text, imagePath: senderImagePath)
        messages.append(message)
    }
    
    func setupAvatarImage(name: String, imagePath: String?, incoming: Bool) {
//        if let stringUrl = imagePath {
//            if let url = NSURL(string: stringUrl) {
//                if let data = NSData(contentsOfURL: url) {
//                    let image = UIImage(data: data)
//                    let diameter = incoming ? UInt(collectionView!.collectionViewLayout.incomingAvatarViewSize.width) : UInt(collectionView!.collectionViewLayout.outgoingAvatarViewSize.width)
//                    let avatarImage = JSQMessagesAvatarImageFactory.avatarImageWithImage(image, diameter: diameter)
//                    avatars[name] = avatarImage.avatarImage
//                    return
//                }
//            }
//        }
        
        // At some point, we failed at getting the image (probably broken URL), so default to avatarColor
        setupAvatarColor(name, incoming: incoming)
    }
    
    func setupAvatarColor(name: String, incoming: Bool) {
        let diameter = incoming ? UInt(collectionView!.collectionViewLayout.incomingAvatarViewSize.width) : UInt(collectionView!.collectionViewLayout.outgoingAvatarViewSize.width)
        
        let rgbValue = name.hash
        let r = CGFloat(Float((rgbValue & 0xFF0000) >> 16)/255.0)
        let g = CGFloat(Float((rgbValue & 0xFF00) >> 8)/255.0)
        let b = CGFloat(Float(rgbValue & 0xFF)/255.0)
        let color = UIColor(red: r, green: g, blue: b, alpha: 0.5)
        
        let separatedName = name.componentsSeparatedByString(" ")
        let one = separatedName[0].characters.first
        var initials : String? = "\(one)"
        if separatedName.count > 1 {
            let two = separatedName[1].characters.first
            initials = "\(initials)\(two)"
        }
        
        let userImage = JSQMessagesAvatarImageFactory.avatarImageWithUserInitials(initials, backgroundColor: color, textColor: UIColor.blackColor(), font: UIFont.systemFontOfSize(CGFloat(13)), diameter: diameter)
        
        avatars[name] = userImage.avatarImage
    }
    
    // INIT
    
    override func viewDidLoad() {
        super.viewDidLoad()
        inputToolbar!.contentView!.leftBarButtonItem = nil
        automaticallyScrollsToMostRecentMessage = true
        navigationController?.navigationBar.topItem?.title = "Back To Conversations"
        
        senderDisplayName = (senderDisplayName != nil) ? senderDisplayName : "Anonymous"
//        let profileImageUrl = user?.providerData["cachedUserProfile"]?["profile_image_url_https"] as? NSString
//        if let urlString = profileImageUrl {
//            setupAvatarImage(senderDisplayName, imagePath: urlString as String, incoming: false)
//            senderImagePath = urlString as String
//        } else {
//            setupAvatarColor(senderDisplayName, incoming: false)
//            senderImagePath = ""
//        }
        setupAvatarColor(senderDisplayName, incoming: false)
        setupFirebase()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        collectionView!.collectionViewLayout.springinessEnabled = true
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        if ref != nil {
            ref.unauth()
        }
    }
    
    // ACTIONS
    
    func receivedMessagePressed(sender: UIBarButtonItem) {
        // Simulate receiving message
        showTypingIndicator = !showTypingIndicator
        scrollToBottomAnimated(true)
    }
    
    func didPressSendButton(button: UIButton!, withMessageText text: String!, sender: String!, date: NSDate!) {
        JSQSystemSoundPlayer.jsq_playMessageSentSound()
        
        sendMessage(text, sender: sender)
        
        finishSendingMessage()
    }
    
    override func didPressAccessoryButton(sender: UIButton!) {
        print("Camera pressed!")
    }
    
    override func collectionView(collectionView: JSQMessagesCollectionView!, messageDataForItemAtIndexPath indexPath: NSIndexPath!) -> JSQMessageData! {
        return messages[indexPath.item]
    }
    
    func collectionView(collectionView: JSQMessagesCollectionView!, bubbleImageViewForItemAtIndexPath indexPath: NSIndexPath!) -> UIImageView! {
        let message = messages[indexPath.item]
        
        if message.senderDisplayName() == senderDisplayName {
            return UIImageView(image: outgoingBubbleImage.messageBubbleImage, highlightedImage: outgoingBubbleImage.messageBubbleHighlightedImage)
        }
        
        return UIImageView(image: incomingBubbleImage.messageBubbleImage, highlightedImage: incomingBubbleImage.messageBubbleHighlightedImage)
    }
    
    func collectionView(collectionView: JSQMessagesCollectionView!, avatarImageViewForItemAtIndexPath indexPath: NSIndexPath!) -> UIImageView! {
        let message = messages[indexPath.item]
        if let avatar = avatars[message.senderDisplayName()] {
            return UIImageView(image: avatar)
        } else {
            setupAvatarImage(message.senderDisplayName(), imagePath: message.imagePath(), incoming: true)
            return UIImageView(image:avatars[message.senderDisplayName()])
        }
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages.count
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = super.collectionView(collectionView, cellForItemAtIndexPath: indexPath) as! JSQMessagesCollectionViewCell
        
        let message = messages[indexPath.item]
        if message.senderDisplayName() == senderDisplayName {
            cell.textView!.textColor = UIColor.blackColor()
        } else {
            cell.textView!.textColor = UIColor.whiteColor()
        }
        
        //style for links.... not working look up in Swift
//        let attributes : [NSObject:AnyObject] = [NSForegroundColorAttributeName:cell.textView!.textColor, NSUnderlineStyleAttributeName: 1]
//        cell.textView!.linkTextAttributes = attributes
        
//                cell.textView.linkTextAttributes = [NSForegroundColorAttributeName: cell.textView.textColor,
//                    NSUnderlineStyleAttributeName: NSUnderlineStyle.StyleSingle]
        return cell
    }
    
    
    // View  usernames above bubbles
    override func collectionView(collectionView: JSQMessagesCollectionView!, attributedTextForMessageBubbleTopLabelAtIndexPath indexPath: NSIndexPath!) -> NSAttributedString! {
        let message = messages[indexPath.item];
        
        // Sent by me, skip
        if message.senderDisplayName() == senderDisplayName {
            return nil;
        }
        
        // Same as previous sender, skip
        if indexPath.item > 0 {
            let previousMessage = messages[indexPath.item - 1];
            if previousMessage.senderDisplayName() == message.senderDisplayName() {
                return nil;
            }
        }
        
        return NSAttributedString(string:message.senderDisplayName())
    }
    
    override func collectionView(collectionView: JSQMessagesCollectionView, messageBubbleImageDataForItemAtIndexPath indexPath: NSIndexPath) -> JSQMessageBubbleImageDataSource! {
        return JSQMessagesBubbleImageFactory().outgoingMessagesBubbleImageWithColor(UIColor.jsq_messageBubbleBlueColor())
    }
    
    override func collectionView(collectionView: JSQMessagesCollectionView, avatarImageDataForItemAtIndexPath indexPath: NSIndexPath) -> JSQMessageAvatarImageDataSource! {
         let diameter = UInt(collectionView.collectionViewLayout.outgoingAvatarViewSize.width)
        let image = UIImage(named: senderImagePath)
        
        return JSQMessagesAvatarImageFactory.avatarImageWithImage(image, diameter: diameter)
    }
    
    override func collectionView(collectionView: JSQMessagesCollectionView!, layout collectionViewLayout: JSQMessagesCollectionViewFlowLayout!, heightForMessageBubbleTopLabelAtIndexPath indexPath: NSIndexPath!) -> CGFloat {
        let message = messages[indexPath.item]
        
        // Sent by me, skip
        if message.senderDisplayName() == senderDisplayName {
            return CGFloat(0.0);
        }
        
        // Same as previous sender, skip
        if indexPath.item > 0 {
            let previousMessage = messages[indexPath.item - 1];
            if previousMessage.senderDisplayName() == message.senderDisplayName() {
                return CGFloat(0.0);
            }
        }
        
        return kJSQMessagesCollectionViewCellLabelHeightDefault
    }


}
