//
//  ViewController.swift
//  LocalTalk
//
//  Created by Brian Douglas on 9/9/15.
//  Copyright (c) 2015 MutualFun. All rights reserved.
//

import UIKit
import MultipeerConnectivity

class ViewController: UIViewController {
    @IBOutlet weak var Conversations : ConversationData?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func addSession(sender: UIBarButtonItem) {
        let sessionViewController = self.storyboard!.instantiateViewControllerWithIdentifier("SessionViewController") as! SessionViewController
        
        self.navigationController!.pushViewController(sessionViewController, animated: true)
    }


}

