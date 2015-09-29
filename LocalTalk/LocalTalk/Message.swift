//
//  Message.swift
//  LocalTalk
//
//  Created by Brian Douglas on 9/17/15.
//  Copyright (c) 2015 MutualFun. All rights reserved.
//

import UIKit

class Message: NSObject, JSQMessageData {
    
    var activePeers: Array<NSObject> = []
    var randomMessages: [String] = []
    
    class var sharedInstance :Message {
        struct Singleton {
            static let instance = Message()
        }
        
        return Singleton.instance
    }
    
    init(activePeers: Array<NSObject> = []) {
        self.activePeers = activePeers
        super.init()
        self.addRandomData()
    }
    
    func addRandomData() {
        let contact1 = Contact(name: "Louis Picasso", image: "1.jpg")
        let contact2 = Contact(name: "Sir Mercy Lago", image: "2.jpg")
        let contact3 = Contact(name: "Amadeus Da Vinci", image: "3.jpg")
        let contact4 = Contact(name: "Jean Paul Hampton", image: "4.jpg")
        
        self.activePeers = NSArray(objects: contact1, contact2, contact3, contact4) as! Array<NSObject>
        
        let message1 = "When you’re the absolute best, you get hated on the most."
        let message2 = "My goal, if I was going to do art, fine art, would have been to become Picasso or greater… That always sounds so funny to people, comparing yourself to someone who has done so much, and that’s a mentality that suppresses humanity…"
        let message3 = "One of my biggest achilles heels has been my ego. And if I, Kanye West, can remove my ego, I think there’s hope for everyone."
        let message4 = "I refuse to accept other people's ideas of happiness for me. As if there's a 'one size fits all' standard for happiness."
        
        self.randomMessages = NSArray(objects: message1, message2, message3, message4) as! [String]
    }
}

