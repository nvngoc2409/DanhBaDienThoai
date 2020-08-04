//
//  HomeVC.swift
//  DanhBaDienThoai
//
//  Created by Phạm Khánh Hưng on 30/7/20.
//  Copyright © 2020 Phạm Khánh Hưng. All rights reserved.
//

import UIKit
import Foundation
class HomeVC: UIViewController {
    
    let arrr =  PhoneContacts.getContacts()
    let database:DBContact = DBContact.init()
    var arrContact:[Contact] = []
    
    @IBOutlet weak var TvMain: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Home"
        print("home page")
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNav()
        initData()
        initUI()
        
    }
    func setupNav() {
        let right = UIBarButtonItem(image: #imageLiteral(resourceName: "home_plus").withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(self.showBranch))
        self.navigationItem.rightBarButtonItem = right
    }
    
    @objc func showBranch() {
        let vc = AddContactVC(nibName: "AddContactVC", bundle: nil)
        let nav = UINavigationController(rootViewController: vc)
        nav.modalPresentationStyle = .fullScreen
        self.present(nav, animated: true, completion: nil)
    }
    
    
    
    
}
extension HomeVC {
    func initUI() {
        TvMain.dataSource = self
        TvMain.delegate = self
        TvMain.register(UINib.init(nibName: "HomeCell", bundle: nil), forCellReuseIdentifier: "HomeCell")
        
    }
    func initData() {
        
        
        arrContact = database.read()
        if arrContact.count == 0 {
//        for k in 1...3{
            for i in arrr {
                let cont:Contact = Contact.init(contact: i)
                database.insert(contactIns: cont)
            }
            arrContact = database.read()
        }
        TvMain.reloadData()
    }
}
extension HomeVC:UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrContact.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let tbCell = tableView.dequeueReusableCell(withIdentifier: "HomeCell", for: indexPath as IndexPath) as! HomeCell
        
        tbCell.lbName.text = arrContact[indexPath.row].lastName + " " + arrContact[indexPath.row].firstName
        tbCell.lbPhoneNumber.text = arrContact[indexPath.row].phoneNumber
        return tbCell
    }
}
extension HomeVC:UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = ContatDetailVC(nibName: "ContatDetailVC", bundle: nil)
        vc.contactDel = arrContact[indexPath.row]
        let nav = UINavigationController(rootViewController: vc)
        nav.modalPresentationStyle = .fullScreen
        self.present(nav, animated: true, completion: nil)
    }
}
