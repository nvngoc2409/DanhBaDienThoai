//
//  ContatDetailVC.swift
//  DanhBaDienThoai
//
//  Created by Phạm Khánh Hưng on 4/8/20.
//  Copyright © 2020 Phạm Khánh Hưng. All rights reserved.
//

import UIKit

class ContatDetailVC: UIViewController {
    var contactDel:Contact?
    override func viewDidLoad() {
        super.viewDidLoad()
        
       print("ContactDetailVC")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNv()
        
        print(contactDel)
    }
    func setupNv() {
        let left = UIBarButtonItem(title: "Contacts", style: .plain, target: self, action: #selector(self.backHome))
        let right = UIBarButtonItem(title: "Edit", style: .plain, target: self, action: #selector(self.Done))
        self.navigationItem.rightBarButtonItem = right
        self.navigationItem.leftBarButtonItem = left
    }
    @objc func backHome() {
        
        self.dismiss(animated: true, completion: nil)
    }
    @objc func Done() {
        let vc = AddContactVC(nibName: "AddContactVC", bundle: nil)
        let nav = UINavigationController(rootViewController: vc)
        nav.modalPresentationStyle = .fullScreen
        self.present(nav, animated: true, completion: nil)
    }

   

}
