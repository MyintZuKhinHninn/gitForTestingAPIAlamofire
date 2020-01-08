//
//  DBOperation.swift
//  TestingAPIAlamofire
//
//  Created by khinhninmyintzu on 5/17/19.
//  Copyright © 2019 khinhninmyintzu. All rights reserved.
//
import UIKit
import SQLite3

class RateDBOperation  {
    
    private let RATE_TABLE = "Rate"
    private let RATE_ID = "currencyidx"
    private let CURRENCY = "currency"
    private let RATE = "rate"
    private let CBID = "cbidx"
    private var db : OpaquePointer?
    
    let ratelist : [RateClass] = []
    let cblist : [CentralBankClass] = []
    
    init(){
        let fileUrl = try! FileManager.default.url(for: .documentDirectory,in: .userDomainMask, appropriateFor: nil,create: false).appendingPathComponent("RateDatabase.sqlite")
        print("db file url: ", fileUrl)
        if sqlite3_open(fileUrl.path, &db) != SQLITE_OK{
            print("Error opening database")
        }
        // "CREATE TABLE IF NOT EXISTS CONTACTS (ID INTEGER PRIMARY KEY AUTOINCREMENT, NAME TEXT, ADDRESS TEXT, PHONE TEXT)"
        
        var stmt : OpaquePointer?
        let createTableQuery = "CREATE TABLE IF NOT EXISTS \(RATE_TABLE)" +
            " (\(RATE_ID) INTEGER PRIMARY KEY AUTOINCREMENT," +
            " \(CURRENCY) TEXT," +
        " \(RATE) DOUBLE," + "\(CBID) INTEGER)"
        
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
    
    func insertRate(_ rate : RateClass){
        var stmt : OpaquePointer?
        
        let insertQuery = "INSERT INTO Rate (currency, rate , cbidx) VALUES (?,?,?);"
        
        if sqlite3_prepare(db, insertQuery, -1,
                           &stmt, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            sqlite3_finalize(stmt)
            return
        }else{
            
            let currencycolumn = rate.currency! as NSString
            let rateformat = rate.rate! as! String
            let ratecolumn = Double(rateformat) ?? 10.00
            let cbid = rate.cbid
            print("Everything is fine")
            
            //binding the params
            
            if sqlite3_bind_text(stmt, 1, currencycolumn.utf8String, -1, nil) != SQLITE_OK{
                let errmsg = String(cString: sqlite3_errmsg(db)!)
                print("Binding data 1 \(errmsg)")
                sqlite3_finalize(stmt)
                return
            }
            if sqlite3_bind_double(stmt, 2, ratecolumn) != SQLITE_OK{
                let errmsg = String(cString: sqlite3_errmsg(db)!)
                print("Binding data 2 \(errmsg)")
                sqlite3_finalize(stmt)
                return
            }
            if sqlite3_bind_int(stmt, 3, Int32(cbid as! Int)) != SQLITE_OK{
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
    
//    func getAllCurrency() -> CurrencyList{
//
//        let ratelist = CurrencyList()
//        var currencyclass = [CurrencyClass]()
//
//        let selectqueryString = "SELECT * FROM \(self.CURRENCY_TABLE)"
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
//            let getcurrency =  String(cString: namePointer!)
//
//            let getrate = sqlite3_column_int(stmt, 2)
//
//            let currencyObj = CurrencyClass.init(currency: getcurrency, currencyvalue: getrate as AnyObject)
//            currencyclass.append(currencyObj)
//        }
//        ratelist?.currencylist? = currencyclass
//        sqlite3_finalize(stmt)
//
//        return ratelist!
//    }
    
    func deleteRate(_ id : Int,_ rate : RateClass)
    {
        let queryString = "DELETE FROM \(self.RATE_TABLE) WHERE \(self.RATE_ID) = \(id);"
        var stmt:OpaquePointer?
        
        if sqlite3_prepare_v2(db, queryString, -1, &stmt, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print(" Error preparing to delete: \(errmsg)")
        }
        
        if sqlite3_step(stmt) == SQLITE_DONE {
            print(" Successfully deleted row.")
        } else {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print(" Could not delete row: \(errmsg)")
        }
        sqlite3_finalize(stmt)
    }
}
