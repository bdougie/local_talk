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
	var currentUser: Contact!
	var newConversationId: String!

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
	
	func removeObjectFromPreviewConversationsAtIndex(index: Int) {
		let convo = self.previewConversations[index]
		self.previewConversations.removeAtIndex(index)
		self.archiveMessage(convo.conversationId())
	}
	
	func archiveMessage(conversationId: String) {
 archiveConversationRef(conversationId).childByAppendingPath("hidden").setValue("true")
	}
	
	func unarchiveMessage(conversationId: String) {
		archiveConversationRef(conversationId).childByAppendingPath("hidden").setValue("false")
	}
	
	func archiveConversationRef(conversationId: String) -> Firebase {
		return  Firebase(url: "https://resplendent-torch-6823.firebaseio.com/conversations/\(conversationId)/archive")
	}

	func setupFirebase() {
		let ref = Firebase(url: "https://resplendent-torch-6823.firebaseio.com/conversations")

		setupContacts()
		setupConversations(ref)
	}
	
	func createNotification(name: String) {
        NSNotificationCenter.defaultCenter().postNotification(NSNotification(name: name, object: nil));
    }
	
	func setupContacts() {
		let ref = Firebase(url: "https://resplendent-torch-6823.firebaseio.com/contacts")
		
		ref.queryLimitedToLast(20).observeEventType(FEventType.ChildAdded, withBlock: { (snapshot) in
			let senderId = snapshot.value["senderId"] as! String
			let senderName = snapshot.value["senderDisplayName"] as! String
			let senderImagePath = snapshot.value["senderImagePath"] as! String
			let senderDeviceName = snapshot.value["senderDeviceName"] as! String
			
			let contact = Contact(id: senderId, name: senderName, deviceName: senderDeviceName, image: senderImagePath) as Contact
			
			if (contact.deviceName == UIDevice.currentDevice().name) {
				self.currentUser = contact
			}
			
			self.activePeers.append(contact)
			self.createNotification("conversationsUpdated")
		})
	}
	
	func setupConversations(ref: Firebase) {
		ref.queryOrderedByValue().observeEventType(FEventType.ChildAdded, withBlock: { (convoId) in
			let conversationKey = convoId.key
			ref.childByAppendingPath(conversationKey).childByAppendingPath("archive").queryLimitedToFirst(1).observeEventType(FEventType.ChildAdded, withBlock: { (archiveCheck) in
				
				let hidden = archiveCheck.value as! NSString
			ref.childByAppendingPath(conversationKey).childByAppendingPath("messages").queryLimitedToLast(1).observeEventType(FEventType.ChildAdded, withBlock: { (snapshot) in
					let message = self.createMessageFromSnapshot(snapshot)
					if ((hidden == "false")) {
						self.previewConversations.append(message)
						self.createNotification("conversationsUpdated")
					}
				})
				
			})
			ref.childByAppendingPath(conversationKey).childByAppendingPath("messages").queryLimitedToLast(25).observeEventType(FEventType.ChildAdded, withBlock: { (snapshot) in
				let message = self.createMessageFromSnapshot(snapshot)
				self.conversationMessages.append(message)
				self.createNotification("conversationsUpdated")
			})
		})
	}
	
	func createNewConversation() {
		let ref = Firebase(url: "https://resplendent-torch-6823.firebaseio.com/conversations")
		let time = generateDateString()
		
		ref.childByAutoId().setValue(time)

		ref.queryLimitedToFirst(1).observeEventType(FEventType.ChildAdded, withBlock: { (snapshot) in
			self.newConversationId = snapshot.key as String!
		})		
	}
	
	func createMessageFromSnapshot(snapshot: FDataSnapshot) -> Message {
		let text = snapshot.value["text"] as? String
		let senderDetails = snapshot.value["sender"] as AnyObject!
		let imagePath = snapshot.value["imagePath"] as? String
		let isMediaMessage = snapshot.value["isMediaMessage"] as? Bool
		let messageHash = snapshot.value["messageHash"] as? UInt
		let conversationId = snapshot.value["conversationId"] as! String
		let timeSent = snapshot.value["time"] as! String
		
		let senderId = senderDetails!["senderId"] as? String
		let senderName = senderDetails!["senderDisplayName"] as! String
		let senderImagePath = senderDetails!["senderImagePath"] as! String
		let senderDeviceName = senderDetails!["senderDeviceName"] as! String
		
		let sender = Contact(id: senderId!, name: senderName, deviceName: senderDeviceName, image: senderImagePath) as Contact
		
		return Message(sender: sender, isMediaMessage: isMediaMessage!, messageHash: messageHash!, text: text!, imagePath: imagePath, conversationId: conversationId, timeSent: timeSent)
	}
	
	func generateDateString() -> String {
		let date = NSDate()
		return date.description
	}
}
