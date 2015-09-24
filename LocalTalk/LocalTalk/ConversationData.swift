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
        var cell = collectionView.dequeueReusableCellWithReuseIdentifier("cell", forIndexPath: indexPath) as! ConversationCollectionViewCell
        
        var contact : Contact = DataSource.sharedInstance.activePeers[indexPath.row] as! Contact
        
        var imageName = contact.image
        var contactName = contact.name
        var image = UIImage(named: imageName!)
        
        cell.cellImageView.image = image
        cell.cellContactName!.text = contactName
        cell.cellMessagePreview!.text = "I refuse to accept other people's ideas of happiness for me. As if there's a 'one size fits all' standard for happiness."
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        println("Got \(DataSource.sharedInstance.activePeers.count) items");
        return DataSource.sharedInstance.activePeers.count
    }
    
}
