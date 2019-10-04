//
//  OpeningPageViewController.swift
//  NotificationApp
//
//  Created by Deniz MacBook Air on 30.09.2019.
//  Copyright © 2019 MacBook Air. All rights reserved.
//

import UIKit
import SwiftSoup

var text:String = ""

class OpeningPageViewController: UIViewController {

    @IBOutlet weak var lblData: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getData()
        sendNotification()
    }
    
    func getData(){
        
        do {
            let url = NSURL(string: "url")
            print(url!)
            let html = try NSString(contentsOf: url! as URL, encoding: String.Encoding.utf8.rawValue)
            let document: Document = try SwiftSoup.parse(html as String)
            if let data: Element = try document.select("div.entry-details h5.entry-title").first() {
                let description = try data.text()
                lblData.text = description
                print(description)
                text = description
            }
        } catch {
            
        }
    }
    
    func sendNotification(){
        // Step 1: Ask for permission
        let center = UNUserNotificationCenter.current()
        
        center.requestAuthorization(options: [.alert, .sound]) { (granted, error) in
        }
        
        // Step 2: Create the notification content
        let content = UNMutableNotificationContent()
        content.title = "Yeni bir duyuru var ! "
        content.body = text
        
        // Step 3: Create the notification trigger
        let date = Date().addingTimeInterval(10)
        
        let dateComponents = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date)
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
        
        // Step 4: Create the request
        
        let uuidString = UUID().uuidString
        
        let request = UNNotificationRequest(identifier: uuidString, content: content, trigger: trigger)
        
        // Step 5: Register the request
        center.add(request) { (error) in
            
        }
    }


}

