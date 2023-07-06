//
//  SqlManager.swift
//  SqliteTest
//
//  Created by Andy on 2017/4/18.
//  Copyright © 2017年 com.andy. All rights reserved.
//

import Foundation
import UIKit

class SqlManager {
    private static let mInstance = SqlManager()
    var db :OpaquePointer? = nil
    
    static func shareInstance() -> SqlManager{
        
        return mInstance
    }
    
    init() {
        self.db = openDB()
        
        createPlaceTable()
        createRecordTable()
        
    }
    
    
    
    
    func openDB() -> OpaquePointer? {
        var connectdb: OpaquePointer? = nil
        let url = try!FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
        let sqlitePath = url.absoluteString + "record.db"
        
        if sqlite3_open(sqlitePath, &connectdb) == SQLITE_OK {
            print("Successfully opened database \(sqlitePath)")
            return connectdb!
        } else {
            print("Unable to open database.")
            return nil
        }
    }
    
    
    
    //------------------------------------
    // MARK: - 建立資料表 create table
    //------------------------------------
    
    func createTable(tableName :String, columnsInfo :[String]) -> Bool {
        let sql = "CREATE table if not exists \(tableName) "
            + "(\(columnsInfo.joined(separator: ",")))" as NSString
        
//        print("sql commect is  \(sql)")
        
        var errorMsg:UnsafeMutablePointer<CChar>?
        
        if sqlite3_exec(
            self.db, sql.utf8String, nil, nil, &errorMsg) == SQLITE_OK{
            return true
        }else{
            print("cannot create table \(tableName)  error : \(String(utf8String: errorMsg!))")
        }
        
        return false
    }
    // Create Place table
    func createPlaceTable() -> Bool {
        return createTable(tableName: "place", columnsInfo: ["id INTEGER PRIMARY KEY AUTOINCREMENT",
                                                             "address TEXT",
                                                             "name TEXT",
                                                             "lati REAL",
                                                             "long REAL",
                                                             "clean INTEGER",
                                                             "smell INTEGER",
                                                             "comfortable INTEGER",
                                                             "count INTEGER"])
    }
    //Create Record table
    func createRecordTable() -> Bool {
        return createTable(tableName: "record", columnsInfo: ["id INTEGER PRIMARY KEY AUTOINCREMENT",
                                                              "place_id INTEGER",
                                                              "time REAL",
                                                              "water INTEGER",
                                                              "smell INTEGER",
                                                              "amount INTEGER",
                                                              "red INTEGER",
                                                              "green INTEGER",
                                                              "blue INTEGER",
                                                              "FOREIGN KEY(place_id) REFERENCES PLACE(id)"])
    }
    
    
    //------------------------------------
    // MARK: - INSERT
    //------------------------------------
    
    func insert(sql:NSString) -> Int {
        var statement :OpaquePointer? = nil
        if sqlite3_prepare_v2(db, sql.utf8String, -1, &statement, nil) == SQLITE_OK{
            if sqlite3_step(statement) == SQLITE_DONE {
                print("新增資料成功")
                let id = sqlite3_last_insert_rowid(self.db)
                return Int(id)
            }
            sqlite3_finalize(statement)
        }else{
            
            print( String(format: "insert fail error: %s", (sqlite3_errmsg(db))) )
        }
        return -1
    }
    
    func insertPlace(place: Place) -> Int {
        
        let sql = "INSERT into place "
            + "(name, address, lati, long, clean, smell, comfortable) "
            + "values ('\(place.name!)', '\(place.address!)', \(place.lati!), \(place.long!), \(place.clean!), \(place.smell!), \(place.comfortable!))"
    
        return insert(sql: sql as NSString)
    }
    
    func insertRecord(placeId: Int, time: TimeInterval, water: Int, smell: Int, amount: Int, red: Int, green: Int, blue: Int, completeBlock: ((Bool) -> Void) ) -> Void {
        if placeId < 0 {
            print("Insert record fail")
            return
        }
        let sql  = "INSERT into record "
             + "(place_id, time, water, smell, amount, red, green, blue) "
             + "values (\(placeId), \(time), \(water), \(smell), \(amount), \(red), \(green), \(blue))"
        
        let success = insert(sql: sql as NSString) > 0 ? true : false
        
        completeBlock(success)
        
    }
    
    //--------------------------------------------------------------------------------
    // MARK: - UPDATE
    //--------------------------------------------------------------------------------
    func update(sql: NSString) -> Void {
        var statement :OpaquePointer? = nil
        if sqlite3_prepare_v2(db, sql.utf8String, -1, &statement, nil) == SQLITE_OK{
            if sqlite3_step(statement) == SQLITE_DONE {
                print("Update OK")
            }
            sqlite3_finalize(statement)
        }
    }
    
    func updatePlaceScore(pId: Int, clean: Int, smell: Int, comfort: Int) -> Void {
        let sql = "UPDATE place set clean = \(clean), smell = \(smell), comfortable = \(comfort), count = count + 1 WHERE id = \(pId)"
        update(sql: sql as NSString)
    }
    
    
    //------------------------------------
    // MARK: - SELECT
    //------------------------------------
    
    
    func getPlaceIdbyName(name: String) -> Int? {
        var statement :OpaquePointer? = nil
        let sql = "SELECT id FROM place WHERE name = \(name)"
        
        if sqlite3_prepare_v2(db, (sql as NSString).utf8String, -1, &statement, nil) == SQLITE_OK{
            while sqlite3_step(statement) == SQLITE_ROW{
                let id =  sqlite3_column_int(statement, 0)
                return Int(id)
            }
            return nil
        }
        return nil
    }
    
    
    func getRecords(placeId :Int?) -> [Record] {
        var statement :OpaquePointer? = nil
        var sql = "SELECT record.id, place_id, time, water, record.smell, amount, red, green, blue," +
        "name, address, lati, long, clean, place.smell, comfortable" +
        " from record inner join PLACE  on record.place_id = PLACE.id"
        
        if placeId != nil {
            sql += " WHERE place_id = \(placeId!)"
        }
        
        print("SELECT sql \(sql)")
        
        var results: [Record] = []
        
        
        if sqlite3_prepare_v2(db, (sql as NSString).utf8String, -1, &statement, nil) == SQLITE_OK
        {
//            print("\(sqlite3_step(statement))")
            
            while sqlite3_step(statement) == SQLITE_ROW
            {
                let id     = sqlite3_column_int(statement, 0)
                let pid    = sqlite3_column_int(statement, 1)
                let time   = sqlite3_column_double(statement, 2)
                let water  = sqlite3_column_int(statement, 3)
                let rSmell = sqlite3_column_int(statement, 4)
                let amount = sqlite3_column_int(statement, 5)
                let red    = sqlite3_column_int(statement, 6)
                let green  = sqlite3_column_int(statement, 7)
                let blue   = sqlite3_column_int(statement, 8)
                
                let name    = String(cString:(sqlite3_column_text(statement, 9)))
                let add     = String(cString:(sqlite3_column_text(statement, 10)))
                let lati    = sqlite3_column_double(statement, 11)
                let long    = sqlite3_column_double(statement, 12)
                let clean   = sqlite3_column_int(statement, 13)
                let pSmell  = sqlite3_column_int(statement, 14)
                let comfort = sqlite3_column_int(statement, 15)
                
                print("\(id). place id: \(pid) address: \(add) time： \(time)")
                let place = Place(id: Int(pid), name: name, address: add, lati: lati, long: long, clean: Int(clean), smell: Int(pSmell), comfortable: Int(comfort))
                let pColor = UIColor(red: CGFloat(red) / 255.0, green: CGFloat(green)/255.0, blue: CGFloat(blue)/255.0, alpha: 1)
                var record = Record(id: Int(id), placeID: Int(pid), time: time, date: Date(), water: Int(water), smell: Int(rSmell), amount: Int(amount), color: pColor, place: place)
                
                record.time = time
                
                results.append(record)
            }
            
        }
        
        sqlite3_finalize(statement)
        return results
    }
    
    
    
    
    
    
    
    
    
    
}
