//
//  NotificationService.swift
//  notification
//
//  Created by Joel Oliveira on 19/03/2019.
//  Copyright © 2019 Joel Oliveira. All rights reserved.
//

import UserNotifications

class NotificationService: UNNotificationServiceExtension {

    var contentHandler: ((UNNotificationContent) -> Void)?
    var bestAttemptContent: UNMutableNotificationContent?

    override func didReceive(_ request: UNNotificationRequest, withContentHandler contentHandler: @escaping (UNNotificationContent) -> Void) {
        self.contentHandler = contentHandler
        bestAttemptContent = (request.content.mutableCopy() as? UNMutableNotificationContent)
        
        NotificarePushLib.shared().handleNotificationRequest(request.content.userInfo, for: bestAttemptContent!, completionHandler: {(_ response: Any?, _ error: Error?) -> Void in
            if error == nil {
                contentHandler(response as! UNNotificationContent);
            } else {
                contentHandler(self.bestAttemptContent!);
            }
        })
    }
    
    override func serviceExtensionTimeWillExpire() {
        // Called just before the extension will be terminated by the system.
        // Use this as an opportunity to deliver your "best attempt" at modified content, otherwise the original push payload will be used.
        if let contentHandler = contentHandler, let bestAttemptContent =  bestAttemptContent {
            contentHandler(bestAttemptContent)
        }
    }

}
