//
//  ConversationData.swift
//  LocalTalk
//
//  Created by Brian Douglas on 9/11/15.
//  Copyright (c) 2015 MutualFun. All rights reserved.
//

import UIKit

class ConversationData: NSObject, UICollectionViewDataSource {
    @IBOutlet var collectionview: UICollectionView!
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("cell", forIndexPath: indexPath) as! ConversationCollectionViewCell
        
        let contact : Contact = Message.sharedInstance.activePeers[indexPath.row] as! Contact
        let message = Message.sharedInstance.randomMessages[indexPath.row]
        
        let imageName = contact.image
        let contactName = contact.name
        let image = UIImage(named: imageName!)
        
        cell.cellImageView.image = image
        cell.cellContactName!.text = contactName
        cell.cellMessagePreview!.text = message 
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("Got \(Message.sharedInstance.activePeers.count) items");
        return Message.sharedInstance.activePeers.count
    }
    
}
