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
    var peerID : MCPeerID!
    var message : MessagesCollectionViewController!
    var tap : UITapGestureRecognizer!
    
    @IBOutlet weak var Conversations : ConversationData?
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.peerID = MCPeerID(displayName: UIDevice.currentDevice().name)
        self.session = MCSession(peer: peerID)
        self.session.delegate = self
        
        self.browser = MCBrowserViewController(serviceType:serviceType,
            session:self.session)
        
        // move to a seperate initWithStyleFunc
        // addToolbarToBroswer()
        
        self.browser.delegate = self;
        startHosting(nil);
    }
    
//    init(tap: UITapGestureRecognizer) {
//        self.tap = tap
//        super.init()
//    }
//
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//    
    self.tap = UITapGestureRecognizer(target: self, action: "tapFired:")
    
    func tapFired(sender: UITapGestureRecognizer) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    @IBAction func openConversation(tap: UITapGestureRecognizer) {
        print("button preseed")
        self.presentViewController(self.message, animated: true, completion: nil)
    }
    
    @IBAction func addConversation(sender: UIBarButtonItem) {
        print("button pressed")
        self.presentViewController(self.browser, animated: true, completion: nil)
    }
    
     // MARK: MCBrowserViewControllerDelegate method implementation
    
    func browserViewControllerDidFinish(
        browserViewController: MCBrowserViewController)  {
            // the Done button was tapped)
            
            self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func browserViewControllerWasCancelled(
        browserViewController: MCBrowserViewController)  {
            // Called when the browser view controller is cancelled
            self.dismissViewControllerAnimated(true, completion: nil)
    }
    
//    func addToolbarToBroswer() {
//        // attempt to add "Select Recipient to toolbar
//        browser.topView = UIToolbar.new()
//        browser.topView.barTintColor = whiteBG
//        browser.topView.text = "Select Recipient"
//        browser.topView.alpha = 0.5
//        browser.addSubview(self.topView)
//    }
    
    // MARK: MCBrowserSessionDelegate method implementation
    
    func session(session: MCSession, didReceiveData data: NSData,
        fromPeer peerID: MCPeerID)  {
            // BoilerPlate: Called when a peer sends an NSData
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
        alertNotification(state, peer: peerID)
    }
    
    func alertNotification(state: MCSessionState, peer: MCPeerID) {
        switch state {
        case MCSessionState.Connected:
            let title = "\(peer.displayName) is online"
            let message = "\(peer.displayName) is ready to chat"
            
            let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "ok", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: { () -> Void in});
        case MCSessionState.NotConnected:
            let title = "\(peer.displayName) went offline"
            let message = "\(peer.displayName) left the chat"
            
            let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "ok", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: { () -> Void in});
        default:
            print("No Peers Connected")
        }

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

