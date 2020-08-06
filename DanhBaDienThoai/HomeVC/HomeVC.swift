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
    var searchData:[Contact] = []
    var convSearchData:[[Contact]] = []
    
    @IBOutlet weak var SearchBar: UISearchBar!
    @IBOutlet weak var TvMain: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Home"
        print("home page")
        TvMain.separatorStyle = .singleLine
        self.SearchBar.delegate = self
        self.TvMain.sectionHeaderHeight = 50
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNav()
        initData()
        initUI()
        self.SearchBar.endEditing(false)
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
//        for k in 1...7{
            for i in arrr {
                let cont:Contact = Contact.init(contact: i)
                database.insert(contactIns: cont)
            }
            arrContact = database.read()
        }
        searchData = arrContact.sorted(by: { (c1:Contact, c2:Contact) -> Bool in
            return c1.firstName.lowercased() < c2.firstName.lowercased()
        })
        convSearchData = converterArr(arr1d: searchData)
        TvMain.reloadData()
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
    
    func converterArr(arr1d:[Contact]) -> [[Contact]] {
        var charArr:[Character] = []
        var arrConv:[[Contact]] = []
        
        if arr1d.count != 0 {
            for i in arr1d {
                let k = checkChar(charArr: charArr, char: i.firstName.first ?? (i.lastName.first ?? " ") )
                if k == -1 {
                    charArr.append(i.firstName.first ?? (i.lastName.first ?? " "))
                    let c:[Contact] = [Contact.init(contact: i)]
                    
                    arrConv.append(c)
                    
                }else{
                    arrConv[k].append(i)
                }
            }
        }
        return arrConv
    }
    func checkChar(charArr:[Character],char:Character) -> Int {
        for (i,value) in charArr.enumerated() {
            
            if value.lowercased() == char.lowercased() {
                return i
            }
        }
        
        return -1
    }
    
}
extension HomeVC:UITableViewDataSource{
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView(frame: CGRect.zero)
        view.backgroundColor = #colorLiteral(red: 0.9254091382, green: 0.9255421162, blue: 0.9253800511, alpha: 1)
//        let view = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 18))
        let label = UILabel(frame: CGRect(x: 10, y: 0, width: 100, height: 30))
        label.text = convSearchData[section].first?.firstName.first?.uppercased()
        label.textColor = UIColor.black
        label.font = UIFont.boldSystemFont(ofSize: 20)
        view.addSubview(label)
        return view
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return convSearchData.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return convSearchData[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let tbCell = tableView.dequeueReusableCell(withIdentifier: "HomeCell", for: indexPath as IndexPath) as! HomeCell
        
        tbCell.lbName.text =  convSearchData[indexPath.section][indexPath.row].firstName + " " + convSearchData[indexPath.section][indexPath.row].lastName
        tbCell.lbPhoneNumber.text = convSearchData[indexPath.section][indexPath.row].phoneNumber
        return tbCell
    }
}
extension HomeVC:UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = ContatDetailVC(nibName: "ContatDetailVC", bundle: nil)
        vc.contactDel = Contact.init(contact: searchData[indexPath.row])
        let nav = UINavigationController(rootViewController: vc)
        nav.modalPresentationStyle = .fullScreen
        self.present(nav, animated: true, completion: nil)
    }
}
extension HomeVC: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchWith(string: "")
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchWith(string: searchText)
    }
    
    func searchWith(string: String) {
        self.searchData.removeAll()
        for item in arrContact {
            if item.firstName.lowercased().contains(string.lowercased()) ||
                item.lastName.lowercased().contains(string.lowercased()) ||
                string.count == 0 {
                self.searchData.append(item)
            }
        }
        searchData = searchData.sorted(by: { (c1:Contact, c2:Contact) -> Bool in
            return c1.firstName.lowercased() < c2.firstName.lowercased()
        })
        convSearchData = converterArr(arr1d: searchData)
        self.TvMain.reloadData()
    }
}

