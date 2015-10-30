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
	var activePeers: [Contact] = []
	var previewConversations: [Message] = []
	var conversationMessages: [Message] = []
    var conversationsRef: Firebase!

	class var sharedInstance :DataSource {
		struct Static {
			static var onceToken: dispatch_once_t = 0
			static var instance: DataSource? = nil
		}
		dispatch_once(&Static.onceToken) {
			Static.instance = DataSource()
			Static.instance?.setupFirebase()
		}
		return Static.instance!
	}

	init(activePeers: Array<Contact> = []) {
		self.activePeers = activePeers
		super.init()
	}

	func setupFirebase() {
		let url =  "https://resplendent-torch-6823.firebaseio.com/conversations"
		let ref = Firebase(url: url)

		setupContacts()
		setupConversations(ref)
	}
	
	func createNotification(name: String) {
        NSNotificationCenter.defaultCenter().postNotification(NSNotification(name: name, object: nil));
    }
	
	func setupContacts() {
		let url =  "https://resplendent-torch-6823.firebaseio.com/contacts"
		let ref = Firebase(url: url)
		
		ref.queryLimitedToLast(20).observeEventType(FEventType.ChildAdded, withBlock: { (snapshot) in
			let senderId = snapshot.value["senderId"] as! String
			let senderName = snapshot.value["senderDisplayName"] as! String
			let senderImagePath = snapshot.value["senderImagePath"] as! String
			
			let contact = Contact(id: senderId, name: senderName, image: senderImagePath) as Contact
			
			self.activePeers.append(contact)
			print("contacts pulled: \(self.activePeers.count)")
		})
	}
	
	func setupConversations(ref: Firebase) {
		ref.queryOrderedByValue().observeEventType(FEventType.ChildAdded, withBlock: { (convoId) in
			let conversationKey = convoId.key
		
			ref.childByAppendingPath(conversationKey).childByAppendingPath("messages").queryLimitedToFirst(1).observeEventType(FEventType.ChildAdded, withBlock: { (snapshot) in
				let message = self.createMessageFromSnapshot(snapshot)
				self.previewConversations.append(message)
				self.createNotification("conversationsUpdated")
			})
			
			ref.childByAppendingPath(conversationKey).childByAppendingPath("messages").queryLimitedToLast(25).observeEventType(FEventType.ChildAdded, withBlock: { (snapshot) in
				let message = self.createMessageFromSnapshot(snapshot)
				self.conversationMessages.append(message)
				self.createNotification("conversationsUpdated")
			})
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
