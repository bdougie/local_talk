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
        
        var contact = DataSource.sharedInstance.activePeers[indexPath.row]
        
        // Cant use  "var imageName = contact.image" -- not sure why?
//        var imageName = contact.image
//        println("SAMAMA \(toString(contact.description.dynamicType))")
        var imageName = "3.jpg"
        var image = UIImage(named: imageName)
        var imageView = UIImageView(image: image!)
        imageView.frame = CGRect(x: 15, y: 0, width: 60, height: 60)
        
        var label = UILabel(frame: CGRectMake(0, 0, 200, 210))
        label.center = CGPointMake(160, 284)
        label.textAlignment = NSTextAlignment.Center
        label.text = "I'am a test message"
        
        cell.cellImageView = imageView
        cell.cellMessagePreview = label
        cell.addSubview(imageView)
        cell.addSubview(label)
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        println("Got \(DataSource.sharedInstance.activePeers.count) items");
        return DataSource.sharedInstance.activePeers.count
    }
    
}
