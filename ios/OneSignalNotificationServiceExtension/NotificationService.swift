import UserNotifications
import OneSignalExtension

class NotificationService: UNNotificationServiceExtension {
    
    var contentHandler: ((UNNotificationContent) -> Void)?
    var bestAttemptContent: UNMutableNotificationContent?

    override func didReceive(
        _ request: UNNotificationRequest,
        withContentHandler contentHandler: @escaping (UNNotificationContent) -> Void
    ) {
        self.contentHandler = contentHandler
        self.bestAttemptContent = request.content.mutableCopy() as? UNMutableNotificationContent

        if let bestAttemptContent = bestAttemptContent {
            OneSignalExtension.didReceiveNotificationExtensionRequest(
                request,
                with: bestAttemptContent,
                withContentHandler: contentHandler
            )
        }
    }

    override func serviceExtensionTimeWillExpire() {
        if let contentHandler = contentHandler,
           let bestAttemptContent = bestAttemptContent {
            contentHandler(bestAttemptContent)
        }
    }
}


// import UserNotifications
// import OneSignalFramework // 👈 Use 'Framework' for v5.0+, or 'Extension' for older

// class NotificationService: UNNotificationServiceExtension {
//     var contentHandler: ((UNNotificationContent) -> Void)?
//     var receivedRequest: UNNotificationRequest!
//     var bestAttemptContent: UNMutableNotificationContent?

//     override func didReceive(_ request: UNNotificationRequest, withContentHandler contentHandler: @escaping (UNNotificationContent) -> Void) {
//         self.receivedRequest = request
//         self.contentHandler = contentHandler
//         self.bestAttemptContent = (request.content.mutableCopy() as? UNMutableNotificationContent)

//         if let bestAttemptContent = bestAttemptContent {
//             // --- FLAVOR SUPPORT START ---
//             // We read the ID from Info.plist so it works for Dev, Staging, and Prod
//             let groupName = Bundle.main.object(forInfoDictionaryKey: "AppGroupName") as? String
//             OneSignal.setAppGroupId(groupName) 
//             // --- FLAVOR SUPPORT END ---

//             // Call OneSignal to process the notification
//             OneSignal.didReceiveNotificationExtensionRequest(self.receivedRequest, with: bestAttemptContent, withContentHandler: self.contentHandler)
//         }
//     }

//     override func serviceExtensionTimeWillExpire() {
//         if let contentHandler = contentHandler, let bestAttemptContent =  bestAttemptContent {
//             // OneSignal's helper for when the extension times out
//             OneSignal.serviceExtensionTimeWillExpire(bestAttemptContent, withContentHandler: contentHandler)
//         }
//     }
// }