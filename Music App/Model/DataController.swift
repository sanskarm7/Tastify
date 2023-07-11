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
        container.loadPersistentStores(completionHandler: {description, error in
            if let error = error {
                print("Core Data failed to load: \(error.localizedDescription)")
            }
        })
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
    
    func addData(context: NSManagedObjectContext){
        let user = AppUser(context: context)
        
        user.id = UUID()
        user.isAuthorized = false
        print("Data has been ADDED to coredata")
        save(context: context)
    }
    
    func status(user: AppUser, context: NSManagedObjectContext) -> Bool{

        if(user.isAuthorized == false){
            print("isAuthorized is false")
            return false
        }
        print("isAuthorized is true")
        return true
    }
    

    
    func modifyIsAuthorize(user: AppUser, context: NSManagedObjectContext){
//        let user = AppUser(context: context)
        
        user.isAuthorized = true
        print("authorized to Core Data")
        //set to authorized
        save(context: context)
        
    }
}
