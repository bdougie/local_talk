//
//  DataSource.swift
//  LocalTalk
//
//  Created by Brian Douglas on 9/30/15.
//  Copyright © 2015 MutualFun. All rights reserved.
//

import UIKit

class DataSource: NSObject {
        var activePeers: Array<NSObject> = []
        var randomConversations: [Message] = []
    
        class var sharedInstance :DataSource {
            struct Singleton {
                static let instance = DataSource()
            }
    
            return Singleton.instance
        }
    
        init(activePeers: Array<NSObject> = []) {
            self.activePeers = activePeers
            super.init()
            self.addRandomData()
        }
    
        func addRandomData() {
            let contact1 = Contact(id: "1", name: "Louis Picasso", image: "1.jpg")
            let contact2 = Contact(id: "2", name: "Sir Mercy Lago", image: "2.jpg")
            let contact3 = Contact(id: "3", name: "Amadeus Da Vinci", image: "3.jpg")
            let contact4 = Contact(id: "4", name: "Jean Paul Hampton", image: "4.jpg")
    
            self.activePeers = NSArray(objects: contact1, contact2, contact3, contact4) as! Array<NSObject>
    
            let text1 = "When you’re the absolute best, you get hated on the most."
            let text2 = "My goal, if I was going to do art, fine art, would have been to become Picasso or greater… That always sounds so funny to people, comparing yourself to someone who has done so much, and that’s a mentality that suppresses humanity…"
            let text3 = "One of my biggest achilles heels has been my ego. And if I, Kanye West, can remove my ego, I think there’s hope for everyone."
            let text4 = "I refuse to accept other people's ideas of happiness for me. As if there's a 'one size fits all' standard for happiness."
            
            let message1 = Message(sender: contact1, isMediaMessage: false, messageHash: 1, text: text1, imagePath: contact1.image)
            let message2 = Message(sender: contact2, isMediaMessage: false, messageHash: 2, text: text2, imagePath: contact2.image)
            let message3 = Message(sender: contact3, isMediaMessage: false, messageHash: 3, text: text3, imagePath: contact3.image)
            let message4 = Message(sender: contact4, isMediaMessage: false, messageHash: 4, text: text4, imagePath: contact4.image)
    
            self.randomConversations = NSArray(objects: message1, message2, message3, message4) as! [Message]
    }

}
