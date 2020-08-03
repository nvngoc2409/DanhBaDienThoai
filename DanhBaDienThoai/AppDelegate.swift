//
//  AppDelegate.swift
//  DanhBaDienThoai
//
//  Created by Phạm Khánh Hưng on 30/7/20.
//  Copyright © 2020 Phạm Khánh Hưng. All rights reserved.
//

import UIKit
import Foundation
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

     var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
//        let arrr =  PhoneContacts.getContacts()
//        let database:DBContact = DBContact.init()
//        database.deleteContact()
//        var arrContact:[Contact] = database.read()
//        if arrContact.count == 0 {
//            for i in arrr {
//                let cont:Contact = Contact.init(contact: i)
//                database.insert(contactIns: cont)
//            }
//            arrContact = database.read()
//        }
//        var testUpd = arrContact.first
//        testUpd?.firstName = "Pham Khanh Hung"
//        database.update(contact: testUpd!)
//        arrContact = database.read()
        let vc = HomeVC(nibName: "HomeVC", bundle: nil)
        
        let nv = UINavigationController(rootViewController: vc)
        window?.rootViewController = nv
        window?.makeKeyAndVisible()
        
        return true
    }

   

    


}

