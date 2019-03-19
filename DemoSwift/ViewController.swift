//
//  ViewController.swift
//  DemoSwift
//
//  Created by Joel Oliveira on 18/03/2019.
//  Copyright © 2019 Joel Oliveira. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    let appDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
    @IBOutlet weak var tableView: UITableView!
    var inboxItems: NSMutableArray = []

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "INBOX"
        
        NotificationCenter.default.addObserver(self, selector: #selector(onDidLoadInbox(_:)), name: NSNotification.Name(rawValue: "didLoadInbox"), object:nil)
        
    }

    @objc func onDidLoadInbox(_ notification: Notification) {
        self.inboxItems.removeAllObjects()
        NotificarePushLib.shared().inboxManager.fetchInbox({(_ response: Any?, _ error: Error?) -> Void in
            if error == nil {
                self.inboxItems.addObjects(from: response as! [Any])
                self.tableView.reloadData()
            }
        })
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return inboxItems.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "InboxItemCell")!
        
        let inboxItem: NotificareDeviceInbox = inboxItems[indexPath.row] as! NotificareDeviceInbox
        
        cell.textLabel?.text = inboxItem.message
        
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let inboxItem: NotificareDeviceInbox = inboxItems[indexPath.row] as! NotificareDeviceInbox
        NotificarePushLib.shared().inboxManager.openInboxItem(inboxItem, completionHandler: {(_ response: Any?, _ error: Error?) -> Void in
            if error == nil {
                NotificarePushLib.shared().presentInboxItem(inboxItem, in: self.navigationController!, withController: response as Any)
            }
        })
    }
    
}

