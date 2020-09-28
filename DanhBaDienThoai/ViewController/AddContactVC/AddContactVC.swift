//
//  AddContactVC.swift
//  DanhBaDienThoai
//
//  Created by Phạm Khánh Hưng on 4/8/20.
//  Copyright © 2020 Phạm Khánh Hưng. All rights reserved.
//

import UIKit
import Foundation
class AddContactVC: UIViewController {
    
    @IBOutlet weak var tfEmail: UITextField!
    @IBOutlet weak var tfPhoneNumber: UITextField!
    @IBOutlet weak var tfLastName: UITextField!
    @IBOutlet weak var tfFirstName: UITextField!
    @IBOutlet weak var btnAddPhoto: UIButton!
    @IBOutlet weak var imgAvata: UIImageView!
    
    let picker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "New Contact"
        initUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    @IBAction func handleAddPhoto(_ sender: Any) {
        chooseAvata()
    }
    
    @IBAction func handleAddPhoto_img(_ sender: Any) {
        chooseAvata()
    }
    
    func chooseAvata()  {
        let alert:UIAlertController=UIAlertController(title: "Choose Image", message: nil, preferredStyle: UIAlertController.Style.actionSheet)
        let cameraAction = UIAlertAction(title: "Camera", style: UIAlertAction.Style.default)
        {
            UIAlertAction in
            self.openCamera()
        }
        let gallaryAction = UIAlertAction(title: "Gallary", style: UIAlertAction.Style.default)
        {
            UIAlertAction in
            self.openGallary()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel)
        {
            UIAlertAction in
        }
        picker.delegate = self
        alert.addAction(cameraAction)
        alert.addAction(gallaryAction)
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    func openCamera(){
        if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerController.SourceType.camera)){
            picker.sourceType = UIImagePickerController.SourceType.camera
            self.present(picker, animated: true, completion: nil)
        }else{
            print("FALSE")
        }
    }
    
    func openGallary(){
        picker.sourceType = UIImagePickerController.SourceType.photoLibrary
        self.present(picker, animated: true, completion: nil)
    }
}

extension AddContactVC {
    func initUI()  {
        self.imgAvata.layer.cornerRadius = 50
        self.imgAvata.image = #imageLiteral(resourceName: "Bitmap")
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
            let img:UIImage = #imageLiteral(resourceName: "Bitmap")
            var contact:Contact = Contact.init()
            if self.imgAvata.image == img {
                contact = Contact.init(id: UUID.init().uuidString, firstName: tfFirstName.text ?? "", lastName: tfLastName.text ?? "", avatarData: nil, phoneNumber: tfPhoneNumber.text ?? "", email: tfEmail.text ?? "")
            }else{
                contact = Contact.init(id: UUID.init().uuidString, firstName: tfFirstName.text ?? "", lastName: tfLastName.text ?? "", avatarData: self.imgAvata.image?.jpegData(compressionQuality: 0.1), phoneNumber: tfPhoneNumber.text ?? "", email: tfEmail.text ?? "")
            }
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
}

extension AddContactVC: UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[.originalImage] as! UIImage
        self.imgAvata.image = image
        self.imgAvata.contentMode = UIView.ContentMode.scaleAspectFill
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}
