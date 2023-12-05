//
//  Databasemanager.swift
//  DatabaseQuery
//
//  Created by Neosoft on 05/12/23.
//

import Foundation
import CoreData
import UIKit
class DataBaseManager{
    private var context : NSManagedObjectContext {
        return (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    }
    
    func saveData(user:userEvent , complition : @escaping (String)->Void){
        let userevent = UserEvent(context: context)
        userevent.title = user.title
        userevent.desc = user.desc
        userevent.date = user.date
        do{
            try context.save()
        }catch{
            print("some thing went wrong")
            complition("some thing went wrong")
        }
        complition("")
    }
    
    func fetchData(complition : @escaping (Bool,[UserEvent]?)->Void){
        var users : [UserEvent] = []
        do {
            users = try context.fetch(UserEvent.fetchRequest())
        }catch{
            print("Some thing wen wrong")
            complition(false,nil)
        }
        complition(true,users)
    }
    
    func sendQuery(queryDate: String, completion: @escaping (Bool, [UserEvent]?) -> Void) {
        let fetchRequest: NSFetchRequest<UserEvent> = UserEvent.fetchRequest()

        // Extract the month from the day_month_year string
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        if let date = dateFormatter.date(from: queryDate) {
            let calendar = Calendar.current
            let month = String(format: "%02d", calendar.component(.month, from: date))
            let year = String(calendar.component(.year, from: date))
            // Create a predicate to filter data based on the month
            let predicate = NSPredicate(format: "date LIKE[c] %@", "*-\(month)-\(year)")
            fetchRequest.predicate = predicate

            var filteredUsers: [UserEvent] = []

            do {
                filteredUsers = try context.fetch(fetchRequest)
                completion(true, filteredUsers)
            } catch {
                print("Error fetching data with query: \(error.localizedDescription)")
                completion(false, nil)
            }
        } else {
            print("Invalid date format")
            completion(false, nil)
        }
    }



    
}
