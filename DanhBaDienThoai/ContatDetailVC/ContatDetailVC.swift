//
//  ContatDetailVC.swift
//  DanhBaDienThoai
//
//  Created by Phạm Khánh Hưng on 4/8/20.
//  Copyright © 2020 Phạm Khánh Hưng. All rights reserved.
//
import MessageUI
import UIKit
import Foundation
class ContatDetailVC: UIViewController {
    
    @IBOutlet weak var btnMessage: UIButton!
    
    @IBOutlet weak var btnEmail: UIButton!
    @IBOutlet weak var btnVideo: UIButton!
    @IBOutlet weak var btnCall: UIButton!
    @IBOutlet weak var lbEmail: UILabel!
    
    @IBOutlet weak var lbPhoneNumber: UILabel!
    
    @IBOutlet weak var lbName: UILabel!
    @IBOutlet weak var imgAvata: UIImageView!
    var contactDel:Contact?
    var idcontact:String = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("ContactDetailVC")
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNv()
        initData()
    }
    
    func setupNv() {
        let left = UIBarButtonItem(title: "Contacts", style: .plain, target: self, action: #selector(self.backHome))
        let right = UIBarButtonItem(title: "Edit", style: .plain, target: self, action: #selector(self.editContact))
        self.navigationItem.rightBarButtonItem = right
        self.navigationItem.leftBarButtonItem = left
    }
    @objc func backHome() {
        
        self.dismiss(animated: true, completion: nil)
    }
    @objc func editContact() {
        let vc = EditContactVC(nibName: "EditContactVC", bundle: nil)
        vc.contactEdit = contactDel
        let nav = UINavigationController(rootViewController: vc)
        nav.modalPresentationStyle = .fullScreen
        self.present(nav, animated: true, completion: nil)
    }
    
    @IBAction func handleMessage(_ sender: Any) {
        if contactDel?.phoneNumber == "" {
            Helper.alert(msg: "Phone number is empty. Please try again later! ", target: self)
        }else{
            let phoneNumber:String =  checkPhoneNumber(number:contactDel?.phoneNumber ?? "123")
            guard MFMessageComposeViewController.canSendText() else {
                return
            }
            let messageVC = MFMessageComposeViewController()
            messageVC.body = "Enter a message";
            messageVC.recipients = [phoneNumber]
            messageVC.messageComposeDelegate = self;
            self.present(messageVC, animated: false, completion: nil)
        }
    }
    @IBAction func handleCall(_ sender: Any) {
        if contactDel?.phoneNumber.count == 0 {
            Helper.alert(msg: "Phone number is empty. Please try again later! ", target: self)
        }else{
            let phoneNumber:String =  checkPhoneNumber(number:contactDel?.phoneNumber ?? "123")
            let phone = "tel://\(phoneNumber)"
            let url = NSURL(string: phone)
            if let url1 = url {
                UIApplication.shared.open(url1 as URL, options: [:], completionHandler: nil)
            } else {
                print("There was an error")
            }
        }
        
    }
    @IBAction func handleVideo(_ sender: Any) {
        if contactDel?.phoneNumber == "" {
            Helper.alert(msg: "Phone number is empty. Please try again later! ", target: self)
        }else{
            let phoneNumber:String =  checkPhoneNumber(number:contactDel?.phoneNumber ?? "123")
            let phone = "facetime://\(phoneNumber)"
            let url = NSURL(string: phone)
            if let url1 = url {
                UIApplication.shared.open(url1 as URL, options: [:], completionHandler: nil)
            } else {
                print("There was an error")
            }
        }
    }
    @IBAction func handleMail(_ sender: Any) {
        sendEmail(email: contactDel?.email ?? "")
    }
    @IBAction func handleDeleteContact(_ sender: Any) {
        let data:DBContact = DBContact.init()
        data.deleteByID(id: contactDel?.id ?? "" )
        self.dismiss(animated: true, completion: nil)
        
    }
    
}
extension ContatDetailVC {
    func initUI()  {
        lbName.text = (contactDel?.firstName ?? "") + " " + (contactDel?.lastName ?? "")
        lbPhoneNumber.text = contactDel?.phoneNumber ?? ""
        lbEmail.text = contactDel?.email ?? ""
        if contactDel?.avatarData != nil {
            imgAvata.image = UIImage(data: (contactDel?.avatarData)!)
            self.imgAvata.layer.cornerRadius = 50
            self.imgAvata.contentMode = UIView.ContentMode.scaleAspectFill
            
        }else{
            imgAvata.image = #imageLiteral(resourceName: "Bitmap")
            self.imgAvata.layer.cornerRadius = 50
            self.imgAvata.contentMode = UIView.ContentMode.scaleAspectFill
            
        }
        btnEmail.layer.cornerRadius = 20
        btnCall.layer.cornerRadius = 20
        btnVideo.layer.cornerRadius = 20
        btnMessage.layer.cornerRadius = 20
        
    }
    func initData()  {
//        let db:DBContact = DBContact.init()
//        let dbContact:[Contact] = db.getContact(id: contactDel!.id)
//        contactDel = dbContact.first
        initUI()
    }
    func checkPhoneNumber(number:String) -> String {
        var pNEdit:String = ""
        let phoneNumberarr:[Character] = [Character].init(contactDel?.phoneNumber ?? " ")
        if phoneNumberarr.first == "+" {
            pNEdit = "+"
            
            for i in 1..<phoneNumberarr.count {
                switch (phoneNumberarr[i]){
                case "0","1","2","3","4","5","6","7","8","9" :
                    pNEdit = pNEdit + String(phoneNumberarr[i])
                case "-", " ":
                    continue
                default :
                    Helper.alert(msg: "Phone numbers formatted incorrectly. Please try again later!", target: self )
                    break
                    
                }
            }
            
        }else{
            pNEdit = ""
            
            for i in 0..<phoneNumberarr.count {
                switch (phoneNumberarr[i]){
                case "0","1","2","3","4","5","6","7","8","9" :
                    pNEdit = pNEdit + String(phoneNumberarr[i])
                case "-", " ",")","(":
                    continue
                default :
                    Helper.alert(msg: "Phone numbers formatted incorrectly. Please try again later!", target: self )
                    break
                    
                }
            }
        }
        return pNEdit
    }
    
    
    

    
}
extension ContatDetailVC:MFMessageComposeViewControllerDelegate{
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        switch (result.rawValue) {
            case MessageComposeResult.cancelled.rawValue:
            print("Message was cancelled")
            self.dismiss(animated: true, completion: nil)
        case MessageComposeResult.failed.rawValue:
            print("Message failed")
            self.dismiss(animated: true, completion: nil)
        case MessageComposeResult.sent.rawValue:
            print("Message was sent")
            self.dismiss(animated: true, completion: nil)
        default:
            break;
        }
    }
}

extension ContatDetailVC:MFMailComposeViewControllerDelegate{
    func sendEmail(email:String) {
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setToRecipients([email])
            mail.setSubject("Subject")

            mail.setMessageBody("<p>You're so awesome!</p>", isHTML: true)

            self.present(mail, animated: true)
        } else {
            // show failure alert
        }
    }

    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
    }
}

