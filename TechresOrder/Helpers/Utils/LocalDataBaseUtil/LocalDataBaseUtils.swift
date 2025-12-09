//
//  LocalDataBaseUtils.swift
//  TECHRES-ORDER
//
//  Created by Pham Khanh Huy on 28/06/2024.
//

import UIKit
import RealmSwift



class LocalDataBaseUtils: NSObject {
    
    static let shared: LocalDataBaseUtils = {
        let util = LocalDataBaseUtils()
        return util
    }()
    
    private override init() {}

    // MARK: - Shared Realm Configuration
    private let config: Realm.Configuration = {
       var config = Realm.Configuration(
           schemaVersion: 2,     // <--- Change this when adding new fields
           migrationBlock: { migration, oldSchemaVersion in
               if oldSchemaVersion < 2 {
                   // Handle changes here
                   // migration.renameProperty(...)
                   // migration.enumerateObjects(...)
               }
           }
       )
       return config
    }()

    // Always get Realm using this config
    func realmInstance() throws -> Realm {
       return try Realm(configuration: config)
    }
    
    

    func removeAllQueuedItem() {
        do {
            let realm = try realmInstance()
            
            try realm.write {
                // Delete all instances of Dog from the realm.
                let queuedItem = realm.objects(WIFIQueuedItemObject.self)
                realm.delete(queuedItem)
            }
        
        } catch let error {
            dLog(error.localizedDescription)
        }
        
        
        do {
            let realm = try realmInstance()
            
            try realm.write {
                // Delete all instances of Dog from the realm.
                let queuedItem = realm.objects(TSCQueuedItemObject.self)
                realm.delete(queuedItem)
            }
        
        } catch let error {
            dLog(error.localizedDescription)
        }
        
        
    }
    
    
    func CheckFinishedQueuedItem() {
        do {
            let realm = try realmInstance()

            let queue = realm.objects(WIFIQueuedItemObject.self)
            
            let finishedQueuedItem = queue.where {
                $0.isFinished == true
            }
            
            try realm.write {
                realm.delete(finishedQueuedItem)
            }
                
        } catch let error {
            dLog(error.localizedDescription)
        }
        
        
        
        do {
            let realm = try Realm()

            let queue = realm.objects(TSCQueuedItemObject.self)
            
            let finishedQueuedItem = queue.where {
                $0.isFinished == true
            }
            
            try realm.write {
                realm.delete(finishedQueuedItem)
            }
                
        } catch let error {
            dLog(error.localizedDescription)
        }
        
        
        
    }


}
