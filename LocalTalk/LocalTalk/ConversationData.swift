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
        
        let contact = DataSource.sharedInstance.activePeers[indexPath.row]
        
        // Cant use  "let imageName = contact.image" -- not sure why?
        let imageName = "1.jpg"
        let image = UIImage(named: imageName)
        let imageView = UIImageView(image: image!)
       
        let label = UILabel(frame: CGRectMake(0, 0, 200, 21))
        label.center = CGPointMake(160, 284)
        label.textAlignment = NSTextAlignment.Center
        label.text = "I'am a test label"
        
        cell.cellImageView = imageView
        cell.cellMessagePreview = label
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        println("Got \(DataSource.sharedInstance.activePeers.count) items");
        return DataSource.sharedInstance.activePeers.count
    }
    
}
