//
//  DataSource.swift
//  LocalTalk
//
//  Created by Brian Douglas on 9/17/15.
//  Copyright (c) 2015 MutualFun. All rights reserved.
//

import UIKit

class DataSource: NSObject {
    
    var activePeers: Array<NSObject> = []
    
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
        var contact1: Contact = Contact.new()
        contact1.name = "Louis Picasso"
        contact1.image = "1.jpg"
        
        var contact2: Contact = Contact.new()
        contact2.name = "Sir Mercy Lago"
        contact2.image = "2.jpg"
        
        var contact3: Contact = Contact.new()
        contact3.name = "Amadeus Da Vinci"
        contact3.image = "3.jpg"
        
        var contact4: Contact = Contact.new()
        contact4.name = "Jean Paul Hampton"
        contact4.image = "4.jpg"
        
        self.activePeers = NSArray(objects: contact1, contact2, contact3, contact4) as! Array<NSObject>
    }
}

