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
        
        if (NotificarePushLib.shared().locationServicesEnabled()) {
            self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Stop Location", style: .plain, target: self, action: #selector(self.stopLocationUpdates))
        } else {
            self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Start Location", style: .plain, target: self, action: #selector(self.startLocationUpdates))
        }
        
        if ((NotificarePushLib.shared().myDevice().userID) != nil) {
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(self.logout))
        } else {
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Login", style: .plain, target: self, action: #selector(self.login))
        }
        
    }

    @objc func onDidLoadInbox(_ notification: Notification) {
        self.inboxItems.removeAllObjects()
        NotificarePushLib.shared().inboxManager.fetchInbox({(_ response: Any?, _ error: Error?) -> Void in
            if error == nil {
                
                for item in (response as! [NotificareDeviceInbox]) {
                    print("\(item.message)")
                }
                
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
        
        NotificarePushLib.shared().inboxManager.markAll(asRead: {(_ response: Any?, _ error: Error?) -> Void in
            
        })
    }
    
    @objc func login() {
        NotificarePushLib.shared().registerDevice("1234567890", withUsername: "Joel", completionHandler: {(_ response: Any?, _ error: Error?) -> Void in
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(self.logout))
        });
    }
    
    @objc func logout() {
        NotificarePushLib.shared().registerDevice(nil, withUsername: nil, completionHandler: {(_ response: Any?, _ error: Error?) -> Void in
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Login", style: .plain, target: self, action: #selector(self.login))
        });
    }
    
    @objc func startLocationUpdates(){
        let alert = UIAlertController(title: "Notificare", message: "Do you want to start location updates and receive alerts when you near by?", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { action in
            NotificarePushLib.shared().startLocationUpdates()
            self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Stop Location", style: .plain, target: self, action: #selector(self.stopLocationUpdates))
        }))
        alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
        
        self.navigationController?.present(alert, animated: true)
    }
    
    @objc func stopLocationUpdates(){
        let alert = UIAlertController(title: "Notificare", message: "Do you want to stop location updates?", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { action in
            NotificarePushLib.shared().stopLocationUpdates()
            self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Start Location", style: .plain, target: self, action: #selector(self.startLocationUpdates))
        }))
        alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
        
        self.navigationController?.present(alert, animated: true)
    }

    
}

