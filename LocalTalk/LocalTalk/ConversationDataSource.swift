//
//  ConversationDataSource.swift
//  LocalTalk
//
//  Created by Brian Douglas on 9/11/15.
//  Copyright (c) 2015 MutualFun. All rights reserved.
//

import UIKit

class ConversationDataSource: NSObject, UICollectionViewDataSource {
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("cell", forIndexPath: indexPath) as! ConversationCollectionViewCell
        
        let _ : Contact = DataSource.sharedInstance.activePeers[indexPath.row] 
        let message = DataSource.sharedInstance.allConversations[indexPath.row]
        
        let imageName = message.imagePath()
        let contactName = message.senderDisplayName()
        let image = UIImage(named: imageName!)
        
        cell.cellImageView.image = image
        cell.cellContactName!.text = contactName
        cell.cellMessagePreview!.text = message.text()
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("Got \(DataSource.sharedInstance.activePeers.count) items");
        return DataSource.sharedInstance.activePeers.count
    }
    
}
