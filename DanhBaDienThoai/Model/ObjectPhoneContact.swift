//
//  ObjectPhoneContact.swift
//  DanhBaDienThoai
//
//  Created by Phạm Khánh Hưng on 30/7/20.
//  Copyright © 2020 Phạm Khánh Hưng. All rights reserved.
//

import Foundation
import ContactsUI
import SQLite3
class PhoneContact: NSObject {
    var name: String?
    var avatarData: Data?
    var phoneNumber: [String] = [String]()
    var email: [String] = [String]()
    var isSelected: Bool = false
    var isInvited = false

    init(contact: CNContact) {
        name        = contact.givenName + " " + contact.familyName
        avatarData  = contact.thumbnailImageData
        for phone in contact.phoneNumbers {
            phoneNumber.append(phone.value.stringValue)
        }
        for mail in contact.emailAddresses {
            email.append(mail.value as String)
        }
    }

    override init() {
        super.init()
    }
}
