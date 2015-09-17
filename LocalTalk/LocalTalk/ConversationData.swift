//
//  ConversationData.swift
//  LocalTalk
//
//  Created by Brian Douglas on 9/11/15.
//  Copyright (c) 2015 MutualFun. All rights reserved.
//

import UIKit


class ConversationData: NSObject, UICollectionViewDataSource {
//    var conversations: Array<NSObject>
//    
//    init(conversations: Array<NSObject>) {
//        self.conversations = conversations
//    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("cell", forIndexPath: indexPath) as! UICollectionViewCell
        return cell    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
//    func addRandomData(amount: NSInteger) -> ConversationData {
        // hopefully add conversation without mpcManager
//        return randomConversationData
//    }
    
}
