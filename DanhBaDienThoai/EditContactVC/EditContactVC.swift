//
//  EditContactVC.swift
//  DanhBaDienThoai
//
//  Created by Phạm Khánh Hưng on 5/8/20.
//  Copyright © 2020 Phạm Khánh Hưng. All rights reserved.
//

import UIKit

class EditContactVC: UIViewController {

    var contactEdit:Contact?
    
    @IBOutlet weak var tfEmail: UITextField!
    @IBOutlet weak var tfPhoneNumber: UITextField!
    @IBOutlet weak var tfLastName: UITextField!
    @IBOutlet weak var tfFirstName: UITextField!
    @IBOutlet weak var imgAvata: UIImageView!
    let picker = UIImagePickerController()

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNv()
        initUI()
    }

    
    @IBAction func hendleDelete(_ sender: Any) {
        print("delete")
        let data:DBContact = DBContact.init()
        data.deleteByID(id: contactEdit?.id ?? "" )
        self.view.window?.rootViewController?.dismiss(animated: true, completion: nil)
    }
   
    @IBAction func hebdleReset(_ sender: Any) {
        print("reset")
        initUI()
    }
    
    @IBAction func handleAddAvata(_ sender: Any) {
        chooseAvata()
    }
    @IBAction func handleAvata(_ sender: Any) {
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

            // Add the actions
            
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
    //            let alert = UIAlertView()
    //            alert.title = "Warning"
    //            alert.message = "You don't have camera"
    //            alert.addButtonWithTitle("OK")
    //            alert.show()
            }
        }
        func openGallary(){
            picker.sourceType = UIImagePickerController.SourceType.photoLibrary
            self.present(picker, animated: true, completion: nil)
        }

}
extension EditContactVC {
    func initUI()  {
        tfFirstName.text = contactEdit?.firstName ?? ""
        tfLastName.text = contactEdit?.lastName ?? ""
        tfPhoneNumber.text = contactEdit?.phoneNumber ?? ""
        tfEmail.text = contactEdit?.email ?? ""
        if contactEdit?.avatarData != nil {
            imgAvata.image = UIImage(data: (contactEdit?.avatarData)!)
            self.imgAvata.layer.cornerRadius = self.imgAvata.frame.width / 2
            self.imgAvata.contentMode = UIView.ContentMode.scaleAspectFill

        }else{
            imgAvata.image = #imageLiteral(resourceName: "Bitmap")
            self.imgAvata.layer.cornerRadius = self.imgAvata.frame.width / 2
            self.imgAvata.contentMode = UIView.ContentMode.scaleAspectFill

        }
        
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
            contactEdit?.firstName = tfFirstName.text ?? ""
            contactEdit?.lastName = tfLastName.text ?? ""
            contactEdit?.phoneNumber = tfPhoneNumber.text ?? ""
            contactEdit?.email = tfEmail.text ?? ""
            
            let img:UIImage = #imageLiteral(resourceName: "Bitmap")
            if self.imgAvata.image != img {
                contactEdit?.avatarData = self.imgAvata.image?.jpegData(compressionQuality: 0.1)
            }
            database.update(contact: contactEdit!)
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
extension EditContactVC: UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    //MARK:UIImagePickerControllerDelegate
    
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
