//
//  CoreDataManager.swift
//  dealdash-ios
//
//  Created by Gevindu Piyumal on 2025-04-26.
//

import CoreData
import Foundation

class CoreDataManager {
    static let shared = CoreDataManager()
    
    private init() {}
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "DealDash")
        container.loadPersistentStores { _, error in
            if let error = error as NSError? {
                fatalError("Failed to load Core Data stack: \(error), \(error.userInfo)")
            }
        }
        return container
    }()
    
    var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    func saveContext() {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let error = error as NSError
                print("Error saving context: \(error), \(error.userInfo)")
            }
        }
    }
    
    // Save a deal to Core Data
    func saveDeal(_ deal: Deal) {
        // Check if deal already exists
        if isDealSaved(id: deal.id) {
            print("Deal already saved")
            return
        }
        
        let savedDeal = NSEntityDescription.insertNewObject(forEntityName: "SavedDeal", into: context) as! NSManagedObject
        
        savedDeal.setValue(deal.id, forKey: "id")
        savedDeal.setValue(deal.title, forKey: "title")
        savedDeal.setValue(deal.description, forKey: "sddescription")
        savedDeal.setValue(deal.banner.absoluteString, forKey: "banner")
        savedDeal.setValue(deal.category.name, forKey: "categoryName")
        savedDeal.setValue(deal.startDate, forKey: "startDate")
        savedDeal.setValue(deal.expireDate, forKey: "expireDate")
        savedDeal.setValue(deal.isActive, forKey: "isActive")
        savedDeal.setValue(deal.isFeatured, forKey: "isFeatured")
        savedDeal.setValue(deal.vendor.id, forKey: "vendorId")
        savedDeal.setValue(deal.vendor.name, forKey: "vendorName")
        savedDeal.setValue(deal.createdAt, forKey: "createdAt")
        savedDeal.setValue(Date(), forKey: "savedAt")
        
        saveContext()
    }
    
    // Delete a saved deal
    func deleteSavedDeal(id: String) {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "SavedDeal")
        fetchRequest.predicate = NSPredicate(format: "id == %@", id)
        
        do {
            let results = try context.fetch(fetchRequest)
            if let dealToDelete = results.first as? NSManagedObject {
                context.delete(dealToDelete)
                saveContext()
            }
        } catch {
            print("Error deleting saved deal: \(error)")
        }
    }
    
    // Check if a deal is already saved
    func isDealSaved(id: String) -> Bool {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "SavedDeal")
        fetchRequest.predicate = NSPredicate(format: "id == %@", id)
        
        do {
            let count = try context.count(for: fetchRequest)
            return count > 0
        } catch {
            print("Error checking if deal is saved: \(error)")
            return false
        }
    }
    
    // Fetch all saved deals
    func fetchSavedDeals() -> [Deal] {
        let fetchRequest: NSFetchRequest<NSManagedObject> = NSFetchRequest(entityName: "SavedDeal")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "savedAt", ascending: false)]
        
        do {
            let savedDealsObjects = try context.fetch(fetchRequest)
            return savedDealsObjects.compactMap { object -> Deal? in
                guard
                    let id = object.value(forKey: "id") as? String,
                    let title = object.value(forKey: "title") as? String,
                    let sddescription = object.value(forKey: "sddescription") as? String,
                    let bannerURLString = object.value(forKey: "banner") as? String,
                    let bannerURL = URL(string: bannerURLString),
                    let categoryName = object.value(forKey: "categoryName") as? String,
                    let startDate = object.value(forKey: "startDate") as? Date,
                    let expireDate = object.value(forKey: "expireDate") as? Date,
                    let isActive = object.value(forKey: "isActive") as? Bool,
                    let isFeatured = object.value(forKey: "isFeatured") as? Bool,
                    let vendorId = object.value(forKey: "vendorId") as? String,
                    let vendorName = object.value(forKey: "vendorName") as? String,
                    let createdAt = object.value(forKey: "createdAt") as? Date
                else {
                    return nil
                }
                
                // Reconstruct Deal object from Core Data
                let category = Category(id: "", name: categoryName, icon: URL(string: "https://placeholder.com/icon.png") ?? URL(fileURLWithPath: ""))
                let vendor = Vendor(
                    id: vendorId,
                    name: vendorName,
                    logo: URL(string: "https://placeholder.com/logo.png")!, 
                    address: "",
                    openingHours: nil,
                    contactNumber: nil,
                    email: nil,
                    website: nil,
                    socialMedia: nil,
                    location: nil
                )
                
                return Deal(
                    id: id,
                    title: title,
                    description: sddescription,
                    banner: bannerURL,
                    category: category,
                    startDate: startDate,
                    expireDate: expireDate,
                    isActive: isActive,
                    isFeatured: isFeatured,
                    vendor: vendor,
                    createdAt: createdAt
                )
            }
        } catch {
            print("Error fetching saved deals: \(error)")
            return []
        }
    }
}
