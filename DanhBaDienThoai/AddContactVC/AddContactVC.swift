//
//  AddContactVC.swift
//  DanhBaDienThoai
//
//  Created by Phạm Khánh Hưng on 4/8/20.
//  Copyright © 2020 Phạm Khánh Hưng. All rights reserved.
//

import UIKit

class AddContactVC: UIViewController {

    @IBOutlet weak var tfEmail: UITextField!
    @IBOutlet weak var tfPhoneNumber: UITextField!
    @IBOutlet weak var tfLastName: UITextField!
    @IBOutlet weak var tfFirstName: UITextField!
    @IBOutlet weak var btnAddPhoto: UIButton!
    @IBOutlet weak var imgAvata: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "New Contact"
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.imgAvata.layer.cornerRadius = self.imgAvata.frame.width / 2
        setupNv()
    }
    func setupNv() {
        let left = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(self.backHome))
        let right = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(self.Done))
        self.navigationItem.rightBarButtonItem = right
        self.navigationItem.leftBarButtonItem = left
    }
    @objc func backHome() {
        
        self.dismiss(animated: true, completion: nil)
    }
    @objc func Done() {
        if checkTf() {
            let database:DBContact = DBContact.init()
            let contact:Contact = Contact.init(id: UUID.init().uuidString, firstName: tfFirstName.text ?? "", lastName: tfLastName.text ?? "", avatarData: nil, phoneNumber: tfPhoneNumber.text ?? "", email: tfEmail.text ?? "")
            database.insert(contactIns: contact)
            self.dismiss(animated: true, completion: nil)
        }
    }
    func checkTf() -> Bool {
        if tfLastName.text == "" && tfFirstName.text == "" {
            Helper.alert(msg: "First name and Last name  can't be simultaneous blank. Please try again later", target: self)
            return false
        }else{
            return true
        }
    }
    @IBAction func handleAddPhoto(_ sender: Any) {
    }
    @IBAction func handleAddPhoto_img(_ sender: Any) {
    }
    
    

}
