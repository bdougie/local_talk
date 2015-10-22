//
//  DataSource.swift
//  LocalTalk
//
//  Created by Brian Douglas on 9/30/15.
//  Copyright © 2015 MutualFun. All rights reserved.
//

import UIKit
import Firebase

class DataSource: NSObject {
	var activePeers: Array<NSObject> = []
	var allConversations = [Message]()
	var conversationMessages = [Message]()
	
	class var sharedInstance :DataSource {
		struct Singleton {
			static let instance = DataSource()
		}

		return Singleton.instance
	}

	init(activePeers: Array<NSObject> = []) {
		self.activePeers = activePeers
		super.init()
		self.setupFirebase()
	}

	var conversationsRef: Firebase!

	func setupFirebase() {
		let url =  "https://resplendent-torch-6823.firebaseio.com/conversations"
		let ref = Firebase(url: url)

		return setupConversations(ref)
	}
	
	func setupConversations(ref: Firebase) {
		ref.queryOrderedByChild("messages").queryLimitedToLast(1).observeEventType(FEventType.ChildAdded, withBlock: { (snapshot) in
			let message = self.createMessageFromSnapshot(snapshot)
			self.allConversations.append(message)
		})
	}
	
	func setupMessages(ref: Firebase) {
		ref.queryLimitedToFirst(25).observeEventType(FEventType.ChildAdded, withBlock: { (snapshot) in
			let message = self.createMessageFromSnapshot(snapshot)
			self.conversationMessages.append(message)
		})
	}
	
	func createMessageFromSnapshot(snapshot: FDataSnapshot) -> Message {
		let text = snapshot.value["text"] as? String
		let senderDetails = snapshot.value["sender"] as AnyObject!
		let imagePath = snapshot.value["imagePath"] as? String
		let isMediaMessage = snapshot.value["isMediaMessage"] as? Bool
		let messageHash = snapshot.value["messageHash"] as? UInt
		let conversationId = snapshot.value["conversationId"] as! String
		
		let senderId = senderDetails!["senderId"] as? String
		let senderName = senderDetails!["senderDisplayName"] as! String
		let senderImagePath = senderDetails!["senderImagePath"] as! String
		
		let sender = Contact(id: senderId!, name: senderName, image: senderImagePath) as Contact
		
		return Message(sender: sender, isMediaMessage: isMediaMessage!, messageHash: messageHash!, text: text!, imagePath: imagePath, conversationId: conversationId)
	}
}
