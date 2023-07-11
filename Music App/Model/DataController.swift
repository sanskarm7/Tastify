//
//  DataController.swift
//  Music App
//
//  Created by Sanskar Mishra on 7/10/23.
//

import Foundation
import CoreData


class DataController: ObservableObject {
    let container = NSPersistentContainer(name: "MusicApp")
    
    init(){
        
        container.loadPersistentStores { description, error in
            if let error = error{
                print("Core Data failed to load: \(error.localizedDescription)")
            }
        }
        
//        container.loadPersistentStores(completionHandler: {description, error in
//            if let error = error {
//                print("Core Data failed to load: \(error.localizedDescription)")
//            }
//        })
    }
    
    //save the data
    func save(context: NSManagedObjectContext) {
        do{
            try context.save()
            print("Data saved")
        } catch{
            print("We could not save the data...")
        }
    }
    
    func addUserData(context: NSManagedObjectContext){
        let user = MobileUser(context: context)
        
        user.id = UUID()
        user.isAuthorized = false
        user.date = Date()
        user.url = URL(string: "") //create an empty url hopefully?
        print("Data has been ADDED to coredata")
        print(user.id ?? 0)
        print("Above is the User's UUID")
        save(context: context)
    }
    
    func editUserData(user: MobileUser, context: NSManagedObjectContext, isAuthorized: Bool, date: Date, url: URL){
        
        
        user.isAuthorized = isAuthorized
        user.date = date
        user.url = url
        print("Data has been UPDATED to coredata")

        save(context: context)
    }
    
    func status(user: MobileUser, context: NSManagedObjectContext) -> Bool{

        if(user.isAuthorized == false){
            print("isAuthorized is false")
            return false
        }
        print("isAuthorized is true")
        return true
    }
    

    
    func modifyIsAuthorize(user: MobileUser, context: NSManagedObjectContext){
//        let user = MobileUser(context: context)
        
        user.isAuthorized = true
        print("authorized to Core Data")
        //set to authorized
        save(context: context)
        
    }
}
