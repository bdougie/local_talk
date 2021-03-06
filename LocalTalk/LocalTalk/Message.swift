//
//  Message.swift
//  LocalTalk
//
//  Created by Brian Douglas on 9/17/15.
//  Copyright (c) 2015 MutualFun. All rights reserved.
//

import UIKit
import JSQMessagesViewController

class Message: NSObject, JSQMessageData {
    var text_: String
    var senderId_: String
    var senderDisplayName_: String
    var senderDeviceName_: String
    var isMediaMessage_: Bool
    var messageHash_: UInt
    var date_: NSDate
    var imagePath_: String
    var conversationId_: String
    var timeSent_: String

    init(sender: Contact, isMediaMessage: Bool, messageHash: UInt, text: String, imagePath: String?, conversationId: String, timeSent: String) {
        self.text_ = text
        self.senderId_ = sender.id
        self.senderDisplayName_ = sender.name
        self.senderDeviceName_ = sender.deviceName
        self.date_ = NSDate()
        self.isMediaMessage_ = isMediaMessage
        self.messageHash_ = messageHash
        self.imagePath_ = imagePath!
        self.conversationId_ = conversationId
        self.timeSent_ = timeSent
    }
    
    func text() -> String! {
        return text_;
    }
    
    func senderId() -> String! {
        return senderId_;
    }
    
    func conversationId() -> String! {
        return conversationId_;
    }
    
    func senderDisplayName() -> String! {
        return senderDisplayName_;
    }
    
    func senderDeviceName() -> String! {
        return senderDeviceName_;
    }
    
    func isMediaMessage() -> Bool {
        return isMediaMessage_;
    }
    
    func messageHash() -> UInt {
        return UInt(messageHash_);
    }
    
    func date() -> NSDate! {
        return date_;
    }
    
    func imagePath() -> String? {
        return imagePath_;
    }
    
    func timeSent() -> String? {
        return timeSent_;
    }
}

