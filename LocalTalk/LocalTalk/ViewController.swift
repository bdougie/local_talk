//
//  ViewController.swift
//  LocalTalk
//
//  Created by Brian Douglas on 9/9/15.
//  Copyright (c) 2015 MutualFun. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var Conversations : ConversationData?
    @IBOutlet weak var addConversation: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}
