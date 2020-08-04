//
//  Helper.swift
//  DanhBaDienThoai
//
//  Created by Phạm Khánh Hưng on 4/8/20.
//  Copyright © 2020 Phạm Khánh Hưng. All rights reserved.
//

import Foundation
import UIKit
class Helper: UIAlertController {
    class func alert(msg:String, target: UIViewController) {
        let alert:UIAlertController = UIAlertController(title: "Contact", message: msg, preferredStyle: UIAlertController.Style.alert)
        let btnOK:UIAlertAction = UIAlertAction(title: "OK", style: .destructive) { (btn) in
            
        }
        alert.addAction(btnOK)
        
        target.present(alert, animated: true, completion: nil)
    }
}
