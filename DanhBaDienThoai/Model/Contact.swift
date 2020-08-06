//
//  PhoneContact.swift
//  DanhBaDienThoai
//
//  Created by Phạm Khánh Hưng on 30/7/20.
//  Copyright © 2020 Phạm Khánh Hưng. All rights reserved.
//

import Foundation
import ContactsUI
import SQLite3

class Contact: NSObject {
    var id:String = ""
    
    var firstName: String = ""
    var lastName: String = ""
    var avatarData: Data?
    var phoneNumber: String = ""
    var email: String = ""

    init(contact: CNContact) {
        id = UUID.init().uuidString
        firstName = contact.givenName
        lastName = contact.familyName
        avatarData  = contact.thumbnailImageData
        phoneNumber = contact.phoneNumbers.first?.value.stringValue ?? ""
        email  = (contact.emailAddresses.first?.value ?? "") as String
        
    }
    init(id:String,firstName:String, lastName:String,avatarData:Data? ,phoneNumber:String,email:String) {
        self.id = id
        self.firstName = firstName
        self.lastName = lastName
        self.avatarData = avatarData
        self.phoneNumber = phoneNumber
        self.email = email
    }
    init(contact:Contact) {
        self.id = contact.id
        self.firstName = contact.firstName
        self.lastName = contact.lastName
        self.avatarData = contact.avatarData
        self.phoneNumber = contact.phoneNumber
        self.email = contact.email
    }
    override init() {
        super.init()
    }
}
