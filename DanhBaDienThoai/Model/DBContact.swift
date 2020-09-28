//
//  DBContact.swift
//  DanhBaDienThoai
//
//  Created by Phạm Khánh Hưng on 30/7/20.
//  Copyright © 2020 Phạm Khánh Hưng. All rights reserved.
//

import Foundation
import SQLite3
class DBContact {
    let dbPath: String = "myDb.sqlite"
    var db:OpaquePointer?
    
    init() {
        db = openDatabase()
        createTable()
    }
    
    func openDatabase() -> OpaquePointer?{
        let fileURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            .appendingPathComponent(dbPath)
        var db: OpaquePointer? = nil
        if sqlite3_open(fileURL.path, &db) != SQLITE_OK
        {
            print("error opening database")
            return nil
        }
        else
        {
            print("Successfully opened connection to database at \(dbPath)")
            return db
        }
    }
    
    func createTable() {
        let createTableString = "CREATE TABLE IF NOT EXISTS contact(id TEXT PRIMARY KEY,firstName TEXT,lastName TEXT,avatarData BLOB,phoneNumber TEXT,email TEXT);"
        var createTableStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, createTableString, -1, &createTableStatement, nil) == SQLITE_OK
        {
            if sqlite3_step(createTableStatement) == SQLITE_DONE
            {
                print("Contact table created.")
            } else {
                print("Contact table could not be created.")
            }
        } else {
            print("CREATE TABLE statement could not be prepared.")
        }
        sqlite3_finalize(createTableStatement)
    }
    
    func insert(contactIns:Contact)
    {
        let insertStatementString = "INSERT INTO contact (id, firstName,lastName, avatarData,phoneNumber,email) VALUES (?, ?, ?, ?, ?, ?);"
        var insertStatement: OpaquePointer? = nil
        //        let SQLITE_STATIC = unsafeBitCast(0, to: sqlite3_destructor_type.self)
        let SQLITE_TRANSIENT = unsafeBitCast(-1, to: sqlite3_destructor_type.self)
        if sqlite3_prepare_v2(db, insertStatementString, -1, &insertStatement, nil) == SQLITE_OK {
            sqlite3_bind_text(insertStatement, 1, NSString(string: contactIns.id).utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 2, NSString(string: contactIns.firstName).utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 3, NSString(string: contactIns.lastName).utf8String, -1, nil)
            if let data = contactIns.avatarData {
                let dataSave = NSData(data: data)
                sqlite3_bind_blob(insertStatement, 4, dataSave.bytes, Int32(dataSave.length), SQLITE_TRANSIENT);
            }
            sqlite3_bind_text(insertStatement, 5, NSString(string: contactIns.phoneNumber).utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 6, NSString(string: contactIns.email).utf8String, -1, nil)
            if sqlite3_step(insertStatement) == SQLITE_DONE {
                print("Successfully inserted row.")
            } else {
                print("Could not insert row.")
            }
        } else {
            print("INSERT statement could not be prepared.")
        }
        sqlite3_finalize(insertStatement)
    }
    
    func insertArrContact(contactIns:[Contact])
    {
        let insertStatementString = "INSERT INTO contact (id, firstName,lastName, avatarData,phoneNumber,email) VALUES (?, ?, ?, ?, ?, ?);"
        var insertStatement: OpaquePointer? = nil
        let SQLITE_TRANSIENT = unsafeBitCast(-1, to: sqlite3_destructor_type.self)
        for item in contactIns {
            if sqlite3_prepare_v2(db, insertStatementString, -1, &insertStatement, nil) == SQLITE_OK {
                sqlite3_bind_text(insertStatement, 1, NSString(string: item.id).utf8String, -1, nil)
                sqlite3_bind_text(insertStatement, 2, NSString(string: item.firstName).utf8String, -1, nil)
                sqlite3_bind_text(insertStatement, 3, NSString(string: item.lastName).utf8String, -1, nil)
                if let data = item.avatarData {
                    let dataSave = NSData(data: data)
                    sqlite3_bind_blob(insertStatement, 4, dataSave.bytes, Int32(dataSave.length), SQLITE_TRANSIENT);
                }
                sqlite3_bind_text(insertStatement, 5, NSString(string: item.phoneNumber).utf8String, -1, nil)
                sqlite3_bind_text(insertStatement, 6, NSString(string: item.email).utf8String, -1, nil)
                if sqlite3_step(insertStatement) == SQLITE_DONE {
                    print("Successfully inserted row.")
                } else {
                    print("Could not insert row.")
                }
            } else {
                print("INSERT statement could not be prepared.")
            }
            sqlite3_finalize(insertStatement)
        }
    }
    
    func read() -> [Contact] {
        let queryStatementString = "SELECT * FROM contact;"
        var queryStatement: OpaquePointer? = nil
        var contactns : [Contact] = []
        if sqlite3_prepare_v2(db, queryStatementString, -1, &queryStatement, nil) == SQLITE_OK {
            while sqlite3_step(queryStatement) == SQLITE_ROW {
                let id = String(describing: String(cString: sqlite3_column_text(queryStatement, 0)))
                let firstName = String(describing: String(cString: sqlite3_column_text(queryStatement, 1)))
                let lastName = String(describing: String(cString: sqlite3_column_text(queryStatement, 2)))
                var avatarData:Data?
                if let dataBlob = sqlite3_column_blob(queryStatement, 3){
                    let dataBlobLength = sqlite3_column_bytes(queryStatement, 3)
                    avatarData = Data(bytes: dataBlob, count: Int(dataBlobLength))
                }
                let phoneNumber = String(describing: String(cString: sqlite3_column_text(queryStatement, 4)))
                let email = String(describing: String(cString: sqlite3_column_text(queryStatement, 5)))
                contactns.append(Contact(id: id, firstName: firstName, lastName: lastName, avatarData: avatarData, phoneNumber: phoneNumber, email: email))
                print("Query Result:")
                print("\(id) | \(firstName) | \(lastName)| | \(phoneNumber)| \(email)")
            }
        } else {
            print("SELECT statement could not be prepared")
        }
        sqlite3_finalize(queryStatement)
        return contactns
    }
    
    func deleteByID(id:String) {
        let deleteStatementStirng = "DELETE FROM contact WHERE id = ?;"
        var deleteStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, deleteStatementStirng, -1, &deleteStatement, nil) == SQLITE_OK {
            sqlite3_bind_text(deleteStatement, 1, NSString(string: id).utf8String, -1, nil)
            if sqlite3_step(deleteStatement) == SQLITE_DONE {
                print("Successfully deleted row.")
            } else {
                print("Could not delete row.")
            }
        } else {
            print("DELETE statement could not be prepared")
        }
        sqlite3_finalize(deleteStatement)
    }
    
    func deleteContact()  {
        let deleteStatementStirng = "DELETE FROM contact;"
        var deleteStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, deleteStatementStirng, -1, &deleteStatement, nil) == SQLITE_OK {
            if sqlite3_step(deleteStatement) == SQLITE_DONE {
                print("Successfully deleted all row.")
            } else {
                print("Could not delete all row.")
            }
        } else {
            print("DELETE statement could not be prepared")
        }
        sqlite3_finalize(deleteStatement)
    }
    
    func update(contact:Contact)  {
        let SQLITE_TRANSIENT = unsafeBitCast(-1, to: sqlite3_destructor_type.self)
        let updateStatementString = "UPDATE contact SET firstName = '\(contact.firstName)',lastName = '\(contact.lastName)',avatarData = ?,phoneNumber = '\(contact.phoneNumber)',email = '\(contact.email)' WHERE id = '\(contact.id)';"
        var updateStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, updateStatementString, -1, &updateStatement, nil) == SQLITE_OK {
            if let data = contact.avatarData {
                let dataSave = NSData(data: data)
                sqlite3_bind_blob(updateStatement, 1, dataSave.bytes, Int32(dataSave.length), SQLITE_TRANSIENT);
            }
            if sqlite3_step(updateStatement) == SQLITE_DONE {
                print("Successfully updated row.")
            } else {
                print("Could not update row.")
            }
        } else {
            print("UPDATE statement could not be prepared")
        }
        sqlite3_finalize(updateStatement)
    }
    
    func getContact(id:String) -> [Contact] {
        let queryStatementString = "SELECT * FROM contact WHERE id = '\(id)';"
        var queryStatement: OpaquePointer? = nil
        var contactns : [Contact] = []
        if sqlite3_prepare_v2(db, queryStatementString, -1, &queryStatement, nil) == SQLITE_OK {
            while sqlite3_step(queryStatement) == SQLITE_ROW {
                let id = String(describing: String(cString: sqlite3_column_text(queryStatement, 0)))
                let firstName = String(describing: String(cString: sqlite3_column_text(queryStatement, 1)))
                let lastName = String(describing: String(cString: sqlite3_column_text(queryStatement, 2)))
                var avatarData:Data?
                if let dataBlob = sqlite3_column_blob(queryStatement, 3){
                    let dataBlobLength = sqlite3_column_bytes(queryStatement, 3)
                    avatarData = Data(bytes: dataBlob, count: Int(dataBlobLength))
                }
                let phoneNumber = String(describing: String(cString: sqlite3_column_text(queryStatement, 4)))
                let email = String(describing: String(cString: sqlite3_column_text(queryStatement, 5)))
                contactns.append(Contact(id: id, firstName: firstName, lastName: lastName, avatarData: avatarData, phoneNumber: phoneNumber, email: email))
                print("Query Result:")
                print("\(id) | \(firstName) | \(lastName)| | \(phoneNumber)| \(email)")
            }
        } else {
            print("SELECT statement could not be prepared")
        }
        sqlite3_finalize(queryStatement)
        return contactns
    }
}
