//
//  CoreDataManager.swift
//  ShopifyApp
//
//  Created by Samuel Adel on 11/06/2024.
//

import Foundation
import CoreData
import UIKit

enum CoreDataError: Error {
    case dataNotFound
    case errorHappenedSaving
}

class CoreDataManager {
    var appDelegate: AppDelegate!
    var managedContext: NSManagedObjectContext!
    static let shared = CoreDataManager()
    
    private init(){
        appDelegate = UIApplication.shared.delegate as? AppDelegate
        managedContext = appDelegate.persistentContainer.viewContext
    }
    
    func getCustomerData() throws -> CustomerCoreDataModel {
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "CustomerCoreData")
        do {
            let customerCoreData = try managedContext.fetch(fetchRequest)
            if  customerCoreData.count <= 0 {
                throw CoreDataError.dataNotFound
            }
            guard let id = customerCoreData[0].value(forKey: "id") as? Int,
                      let email = customerCoreData[0].value(forKey: "email") as? String
                       else {
                throw CoreDataError.dataNotFound
                }
            return  CustomerCoreDataModel(email: email, id: id)
            
        } catch {
            print(error.localizedDescription)
            throw CoreDataError.dataNotFound
        }
         
    }
  
    func saveCustomerData(customer: CustomerData)throws{
        let entity = NSEntityDescription.entity(forEntityName: "CustomerCoreData", in: managedContext)
        let customerManagedObject = NSManagedObject(entity: entity!, insertInto: managedContext)
        customerManagedObject.setValue(customer.id, forKey: "id")
        customerManagedObject.setValue(customer.email, forKey: "email")
        do {
            try managedContext.save()
            print("saved")
        } catch {
            print(error.localizedDescription)
            throw CoreDataError.errorHappenedSaving
        }
    }
  
}
