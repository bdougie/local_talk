//
//  ConversationViewController.swift
//  LocalTalk
//
//  Created by Brian Douglas on 9/9/15.
//  Copyright (c) 2015 MutualFun. All rights reserved.
//

import UIKit
import MultipeerConnectivity
// http://radar.oreilly.com/2014/09/multipeer-connectivity-on-ios-8-with-swift.html
// https://www.hackingwithswift.com/read/25/4/invitation-only-mcpeerid

class ConversationViewController: UIViewController, MCBrowserViewControllerDelegate, MCSessionDelegate {
    let serviceType = "LCOC-Chat"
    
    var browser : MCBrowserViewController!
    var assistant : MCAdvertiserAssistant!
    var session : MCSession!
    var peerID: MCPeerID!
    
    @IBOutlet weak var Conversations : ConversationData?
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.peerID = MCPeerID(displayName: UIDevice.currentDevice().name)
        self.session = MCSession(peer: peerID)
        self.session.delegate = self
        
        self.browser = MCBrowserViewController(serviceType:serviceType,
            session:self.session)
        
        self.browser.delegate = self;
        startHosting(nil);
    }

    @IBAction func addConversation(sender: UIBarButtonItem) {
        print("button pressed ")
        self.presentViewController(self.browser, animated: true, completion: nil)
    }
    
     // MARK: MCBrowserViewControllerDelegate method implementation
    
    func browserViewControllerDidFinish(
        browserViewController: MCBrowserViewController)  {
            // Called when the browser view controller is dismissed (ie the Done
            // button was tapped)
            
            self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func browserViewControllerWasCancelled(
        browserViewController: MCBrowserViewController)  {
            // Called when the browser view controller is cancelled
            
            self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    // MARK: MCBrowserSessionDelegate method implementation
    
    func session(session: MCSession, didReceiveData data: NSData,
        fromPeer peerID: MCPeerID)  {
            // BoilerPlate: Called when a peer sends an NSData to us
            
            // This needs to run on the main queue
//            dispatch_async(dispatch_get_main_queue()) {
//                
//                var msg = NSString(data: data, encoding: NSUTF8StringEncoding)
//                
//                self.updateChat(msg, fromPeer: peerID)
//            }
    }
    
    // The following methods do nothing, but the MCSessionDelegate protocol
    // requires that we implement them.
    func session(session: MCSession,
        didStartReceivingResourceWithName resourceName: String,
        fromPeer peerID: MCPeerID, withProgress progress: NSProgress)  {
            
            // Called when a peer starts sending a file to us
    }
    
    func session(session: MCSession,
        didFinishReceivingResourceWithName resourceName: String,
        fromPeer peerID: MCPeerID,
        atURL localURL: NSURL, withError error: NSError?)  {
            // Called when a file has finished transferring from another peer
    }
    
    func session(session: MCSession, didReceiveStream stream: NSInputStream,
        withName streamName: String, fromPeer peerID: MCPeerID)  {
            // Called when a peer establishes a stream with us
    }
    
    func session(session: MCSession, peer peerID: MCPeerID,
        didChangeState state: MCSessionState)  {
            // Called when a connected peer changes state (for example, goes offline)
            
    }
    
     // MARK: MCAdvertiserAssistant method implementation
    
    func startHosting(action: UIAlertAction!) {
        assistant = MCAdvertiserAssistant(serviceType: serviceType, discoveryInfo: nil, session: session)
        assistant.start()
    }
    
    func joinSession(action: UIAlertAction!) {
        let mcBrowser = MCBrowserViewController(serviceType: serviceType, session: session)
        mcBrowser.delegate = self
        presentViewController(mcBrowser, animated: true, completion: nil)
    }


}

