//
//  CBDBOperation.swift
//  TestingAPIAlamofire
//
//  Created by khinhninmyintzu on 5/20/19.
//  Copyright © 2019 khinhninmyintzu. All rights reserved.
//

import Foundation
import SQLite3

class CBDBOperation  {
    
    private let CB_TABLE = "CentralBankCurrency"
    private let CB_ID = "cbidx"
    private let INFO = "info"
    private let DESCRIPTION = "description"
    private let TIMESTAMP = "timestamp"
    private var db : OpaquePointer?
    
    let cblist : [CentralBankClass] = []
    
    init(){
        let fileUrl = try! FileManager.default.url(for: .documentDirectory,in: .userDomainMask, appropriateFor: nil,create: false).appendingPathComponent("CentralBankDatabase.sqlite")
        print("db file url: ", fileUrl)
        if sqlite3_open(fileUrl.path, &db) != SQLITE_OK{
            print("Error opening database")
        }
        // "CREATE TABLE IF NOT EXISTS CONTACTS (ID INTEGER PRIMARY KEY AUTOINCREMENT, NAME TEXT, ADDRESS TEXT, PHONE TEXT)"
        
        var stmt : OpaquePointer?
        let createTableQuery = "CREATE TABLE IF NOT EXISTS \(CB_TABLE)" +
            " (\(CB_ID) INTEGER PRIMARY KEY AUTOINCREMENT," +
            " \(INFO) TEXT," +
            " \(DESCRIPTION) TEXT," + "\(TIMESTAMP) INTEGER)"
        
        //creating table
        if sqlite3_prepare_v2(db, createTableQuery, -1, &stmt, nil) == SQLITE_OK {
            if sqlite3_step(stmt) == SQLITE_DONE {
                print("Table created.")
            } else {
                print("Table could not be created.")
            }
        } else {
            print("CREATE TABLE statement could not be prepared.")
        }
        sqlite3_finalize(stmt)
    }
    
    func insertCentralBankInfo(_ centralbank : CentralBankClass){
        var stmt : OpaquePointer?
        
        let insertQuery = "INSERT INTO CentralBankCurrency (info, description , timestamp) VALUES (?,?,?);"
        
        if sqlite3_prepare(db, insertQuery, -1,
                           &stmt, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            sqlite3_finalize(stmt)
            return
        }else{
            
            let infocolumn = centralbank.info! as NSString
            let descriptioncolumn = centralbank.description! as NSString
            let timestampcolumn = Int32(centralbank.timestamp!)
            print("Everything is fine")
            
            //binding the params
            
            if sqlite3_bind_text(stmt, 1, infocolumn.utf8String, -1, nil) != SQLITE_OK{
                let errmsg = String(cString: sqlite3_errmsg(db)!)
                print("Binding data 1 \(errmsg)")
                sqlite3_finalize(stmt)
                return
            }
            
            if sqlite3_bind_text(stmt, 2, descriptioncolumn.utf8String, -1, nil) != SQLITE_OK{
                let errmsg = String(cString: sqlite3_errmsg(db)!)
                print("Binding data 1 \(errmsg)")
                sqlite3_finalize(stmt)
                return
            }
            
            if sqlite3_bind_int(stmt, 3, timestampcolumn) != SQLITE_OK{
                let errmsg = String(cString: sqlite3_errmsg(db)!)
                print("Binding data 2 \(errmsg)")
                sqlite3_finalize(stmt)
                return
            }
            
            if sqlite3_step(stmt) == SQLITE_DONE {
                print(stmt)
                print("Successful inserted")
            }else{
                let errmsg = String(cString: sqlite3_errmsg(db)!)
                print("Binding data is successful \(errmsg)")
            }
        }
        sqlite3_finalize(stmt)
    }
    
//    func getAllInfo() -> CentralBankInfoList{
//
//        let infolist = CentralBankInfoList()
//        var cbclass = [CentralBankClass]()
//
//        let selectqueryString = "SELECT * FROM \(self.CB_TABLE)"
//
//        var stmt:OpaquePointer?
//
//        //preparing the query
//        if sqlite3_prepare(db, selectqueryString, -1, &stmt, nil) != SQLITE_OK{
//            let errmsg = String(cString: sqlite3_errmsg(db)!)
//            print("error preparing insert:v\(errmsg)")
//        }
//        //traversing through all the records
//        while (sqlite3_step(stmt) == SQLITE_ROW) {
//
//            let id = sqlite3_column_int(stmt, 0)
//
//            let namePointer = sqlite3_column_text(stmt, 1)
//            let getinfo =  String(cString: namePointer!)
//
//            let descriptionPointer = sqlite3_column_text(stmt, 2)
//            let getdescription = String(cString: descriptionPointer!)
//
//            let gettimestamp = sqlite3_column_int(stmt, 3)
//
//            let cbObj = CentralBankClass.init(id: Int(id), info: getinfo, description: getdescription, timestamp: Int(gettimestamp))
//            cbclass.append(cbObj)
//        }
//        infolist?.cblist = cbclass
//        sqlite3_finalize(stmt)
//        return infolist!
//    }
//
    func getAllInfo() -> CentralBankClass{
        
       // let infolist = CentralBankInfoList()
        var cb = CentralBankClass()
        var cbclass = [CentralBankClass]()
        
        let selectqueryString = "SELECT * FROM \(self.CB_TABLE)"
        
        var stmt:OpaquePointer?
        
        //preparing the query
        if sqlite3_prepare(db, selectqueryString, -1, &stmt, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error preparing insert:v\(errmsg)")
        }
        //traversing through all the records
        while (sqlite3_step(stmt) == SQLITE_ROW) {
            
            let id = sqlite3_column_int(stmt, 0)
            
            let namePointer = sqlite3_column_text(stmt, 1)
            let getinfo =  String(cString: namePointer!)
            
            let descriptionPointer = sqlite3_column_text(stmt, 2)
            let getdescription = String(cString: descriptionPointer!)
            
            let gettimestamp = sqlite3_column_int(stmt, 3)
            
            let cbObj = CentralBankClass.init(id: Int(id), info: getinfo, description: getdescription, timestamp: Int(gettimestamp))
            cbclass.append(cbObj)
            cb = cbObj
        }
       // infolist?.cblist = cbclass
        sqlite3_finalize(stmt)
        return cb!
    }
    
}
