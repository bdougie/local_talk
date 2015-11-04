//
//  ConversationViewController.swift
//  LocalTalk
//
//  Created by Brian Douglas on 9/9/15.
//  Copyright (c) 2015 MutualFun. All rights reserved.
//

import UIKit
import MultipeerConnectivity

class ConversationViewController: UIViewController, MCBrowserViewControllerDelegate, MCSessionDelegate, UICollectionViewDelegate, UICollectionViewDataSource {
    let serviceType = "LCOC-Chat"
    
    var browser : MCBrowserViewController!
    var assistant : MCAdvertiserAssistant!
    var session : MCSession!
    var peerID : MCPeerID!
    var specificIndex: Int!
    
    @IBOutlet weak var collectionview: UICollectionView!
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "conversationsUpdated", name: "conversationsUpdated", object: nil)
        
        self.peerID = MCPeerID(displayName: UIDevice.currentDevice().name)
        self.session = MCSession(peer: peerID)
        self.session.delegate = self
        
        self.browser = MCBrowserViewController(serviceType:serviceType,
            session:self.session)
        
        self.browser.delegate = self;
        startHosting(nil);

        self.collectionview.delegate = self
        self.collectionview.dataSource = self
    }
    
    func conversationsUpdated(){
        print("reloaded preview data");
        self.collectionview.reloadData()
    }
    
    func tapFired(sender: UITapGestureRecognizer) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func addConversation(sender: UIBarButtonItem) {
        print("button pressed")
        self.presentViewController(self.browser, animated: true, completion: nil)
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let message = DataSource.sharedInstance.previewConversations[indexPath.row]

        let messagesCollectionViewController = self.storyboard!.instantiateViewControllerWithIdentifier("messages") as! MessagesCollectionViewController
        let conversationId = message.conversationId()
        
        messagesCollectionViewController.senderDisplayName = UIDevice.currentDevice().name
        messagesCollectionViewController.senderId = "6"
        messagesCollectionViewController.senderDeviceName = self.peerID.displayName
        messagesCollectionViewController.senderImagePath = message.imagePath()
        messagesCollectionViewController.conversationId = message.conversationId()
        messagesCollectionViewController.isMediaMessage = message.isMediaMessage()
        messagesCollectionViewController.messageHash = message.messageHash()
        messagesCollectionViewController.messagesRefUrl = "https://resplendent-torch-6823.firebaseio.com/conversations/\(conversationId)/messages"
        
        self.navigationController!.pushViewController(messagesCollectionViewController, animated: true)
    }
    
    // MARK: Swipe to delete
    func showCloseButton(sender: UISwipeGestureRecognizer) {
        let cell = sender.view as! ConversationCollectionViewCell
        cell.closeImageButton?.hidden = false
    }
    
    func hideCloseButton(sender: UISwipeGestureRecognizer) {
        let cell = sender.view as! ConversationCollectionViewCell
        cell.closeImageButton?.hidden = true
    }
   
    func archiveCell(sender: UIButton) {
        let i : Int = (sender.layer.valueForKey("index")) as! Int
        DataSource.sharedInstance.removeObjectFromPreviewConversationsAtIndex(i)
        
        self.collectionview.reloadData()
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return previewConversations().count
    }

    // MARK: UICollectionViewDataSource method implementation
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("cell", forIndexPath: indexPath) as! ConversationCollectionViewCell
        
        let message = previewConversations()[indexPath.row]
        
        let imageName = message.imagePath()
        let contactName = message.senderDisplayName()
        let image = UIImage(named: imageName!)
        
        cell.cellImageView.image = image
        cell.cellContactName!.text = contactName
        cell.cellMessagePreview!.text = message.text()
        
        // Swipe to archive
        let cSelector = Selector("showCloseButton:")
        let LeftSwipe = UISwipeGestureRecognizer(target: self, action: cSelector)
        LeftSwipe.direction = UISwipeGestureRecognizerDirection.Left
        cell.addGestureRecognizer(LeftSwipe)
        
        // Swipe to hide archive
        let hSelector = Selector("hideCloseButton:")
        let RightSwipe = UISwipeGestureRecognizer(target: self, action: hSelector)
        RightSwipe.direction = UISwipeGestureRecognizerDirection.Right
        cell.addGestureRecognizer(RightSwipe)
        
        // Close button
        cell.closeImageButton?.hidden = true
        cell.closeImageButton?.layer.setValue(indexPath.row, forKey: "index")
        cell.closeImageButton?.addTarget(self, action: "archiveCell:", forControlEvents: UIControlEvents.TouchUpInside)
        
        return cell
    }
    
    func previewConversations() -> [Message] {
        return DataSource.sharedInstance.previewConversations
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

