//
//  Contact.swift
//  LocalTalk
//
//  Created by Brian Douglas on 9/17/15.
//  Copyright (c) 2015 MutualFun. All rights reserved.
//

import UIKit

class Contact: NSObject {
    var id: String
    var name: String
    var image: String?
    
    init(id: String,name: String, image: String?) {
        self.id = id
        self.name = name
        self.image = image
        super.init()
    }
   
}
