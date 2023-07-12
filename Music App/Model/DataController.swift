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
        user.url = URL(string: "musicapp://home")! //create an empty url hopefully?
        user.authState = ""
        print("Data has been ADDED to coredata")
        print(user.id ?? 0)
        print("Above is the User's UUID")
        save(context: context)
    }
    
    func editUserData(user: MobileUser, context: NSManagedObjectContext, isAuthorized: Bool, date: Date, url: URL, authState: String){
        
        
        user.isAuthorized = isAuthorized
        user.date = date
        user.url = url
        user.authState = authState
        print("Data has been UPDATED to coredata")

        save(context: context)
    }
    
    func status(user: MobileUser, context: NSManagedObjectContext) -> Bool{

        if(user.isAuthorized == false){
            
            return false
        }
        return true
    }
    
    func getURL(user: MobileUser, context: NSManagedObjectContext) -> URL{
//        guard let tempURL = user.url else{
//            return
//        }
//        return tempURL
        return user.url!
    }
    
    func getAuthState(user: MobileUser, context: NSManagedObjectContext) -> String{

        return user.authState!
    }
    

    
    func modifyIsAuthorize(user: MobileUser, context: NSManagedObjectContext){
//        let user = MobileUser(context: context)
        
        user.isAuthorized = true
        print("authorized to Core Data")
        //set to authorized
        save(context: context)
        
    }
}
