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
    var isMediaMessage_: Bool
    var messageHash_: UInt
    var date_: NSDate
    var imagePath_: String

    init(sender: Contact, isMediaMessage: Bool, messageHash: UInt, text: String, imagePath: String?) {
        self.text_ = text
        self.senderId_ = sender.id
        self.senderDisplayName_ = sender.name
        self.date_ = NSDate()
        self.isMediaMessage_ = isMediaMessage
        self.messageHash_ = messageHash
        self.imagePath_ = imagePath!
    }
    
    func text() -> String! {
        return text_;
    }
    
    func senderId() -> String! {
        return senderId_;
    }
    
    func senderDisplayName() -> String! {
        return senderDisplayName_;
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
}

