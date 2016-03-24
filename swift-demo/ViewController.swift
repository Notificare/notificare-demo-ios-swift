//
//  ViewController.swift
//  swift-demo
//
//  Created by Joel Oliveira on 23/03/16.
//  Copyright © 2016 Joel Oliveira. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {

    // MARK: Properties
    var messagesArray : [NotificareDeviceInbox] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Inbox"
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ViewController.loadInbox), name:"updateInbox", object: nil)
        loadInbox()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    func loadInbox() {
        
        NotificarePushLib.shared().fetchInbox(nil, skip: nil, limit: nil, completionHandler: { (info) -> Void in
            if let arrayWithMessages = info["inbox"] as? [NotificareDeviceInbox] {
                self.messagesArray.removeAll()
                self.messagesArray.appendContentsOf(arrayWithMessages)
                //self.tableView!.reloadData()
                self.tableView?.reloadSections(NSIndexSet(index: 0), withRowAnimation: .Automatic)
            } 
            }, errorHandler:{ (error) -> Void in })
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messagesArray.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier( "InboxCell", forIndexPath: indexPath)
        
        let message = messagesArray[indexPath.row]
        // Configure the cell...
        cell.textLabel?.text = message.message
        cell.detailTextLabel?.text = message.time

        if(message.opened){
            cell.accessoryType = UITableViewCellAccessoryType.Checkmark
        } else {
            cell.accessoryType = UITableViewCellAccessoryType.None
        }
        
        return cell
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let message = messagesArray[indexPath.row]
        NotificarePushLib.shared().openInboxItem(message)
        /*NotificarePushLib.shared().markAsRead(message, completionHandler: { (NSDictionary) -> Void in
            
            }) { (NSError) -> Void in
                //
        }*/
    }
}

