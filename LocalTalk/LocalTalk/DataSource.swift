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
	var allConversations: [Message] = []
	var conversationMessages: [Message] = []
	
	class var sharedInstance :DataSource {
		struct Singleton {
			static let instance = DataSource()
		}

		return Singleton.instance
	}

	init(activePeers: Array<Contact> = []) {
		self.activePeers = activePeers
		super.init()
		setupFirebase()
	}

	var conversationsRef: Firebase!

	func setupFirebase() {
		let url =  "https://resplendent-torch-6823.firebaseio.com/conversations"
		let ref = Firebase(url: url)

		setupContacts()
		print("Got \(DataSource.sharedInstance.activePeers.count) items");
		setupConversations(ref)
//		createNotification()
		NSNotificationCenter.defaultCenter().postNotification(NSNotification(name: "firebaseSetup", object: nil));
	}
	
//	func createNotification() {
//		let title = "firebase setup"
//		let message = "just saying"
//		
//		NSNotificationCenter.defaultCenter().postNotification(NSNotification(name: "firebaseSetup", object: nil));
//		
//		let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
//		alert.addAction(UIAlertAction(title: "ok", style: UIAlertActionStyle.Default, handler: nil))
//		ConversationViewController.presentViewController(alert);
//	}
	
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
			print("Got \(DataSource.sharedInstance.activePeers.count) items");

		})
	}
	
	func setupConversations(ref: Firebase) {
		ref.queryOrderedByValue().observeEventType(FEventType.ChildAdded, withBlock: { (convoId) in
			let conversationKey = convoId.key
		
			ref.childByAppendingPath(conversationKey).childByAppendingPath("messages").queryLimitedToLast(1).observeEventType(FEventType.ChildAdded, withBlock: { (snapshot) in
				let message = self.createMessageFromSnapshot(snapshot)
				print("create messages was called")
				self.allConversations.append(message)
				print("conversation count: \(self.allConversations.count)")
			})
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
	
//	func saveToDisk() {
//		if self.activePeers.count > 0 {
//			dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
//				var numberOfItemsToSave: UInt = MIN(self.activePeers.count, 50)
//				var mediaItemsToSave: [AnyObject] = self.activePeers.subarrayWithRange(NSMakeRange(0, numberOfItemsToSave))
//				var fullPath: String = self.pathForFilename(NSStringFromSelector("mediaItems"))
//				var mediaItemData: NSData = NSKeyedArchiver.archivedDataWithRootObject(mediaItemsToSave)
//				var dataError: NSErrorPointer
//				var wroteSuccessfully: Bool = mediaItemData.writeToFile(fullPath, options: NSDataWritingAtomic | NSDataWritingFileProtectionCompleteUnlessOpen, error: &dataError)
//				if !wroteSuccessfully {
//					NSLog("Couldn't write file: %@", dataError)
//				}
//				
//			})
//		}
//	}
//	
//	func pathForFilename(filename: String) -> String {
//		var paths: [AnyObject] = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, true)
//		var documentsDirectory: String = paths.firstObject()
//		var dataPath: String = documentsDirectory.stringByAppendingPathComponent(filename)
//		return dataPath
//	}
}
