//  CoreDataHandler.swift
//  CoreDataEmployee
//  Created by vaayoousa on 13/06/18.
//  Copyright © 2018 vaayoousa. All rights reserved.

import UIKit
import CoreData
class CoreDataHandler: NSObject {
    private class func getContext() -> NSManagedObjectContext{
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }
    class func saveObject(id: Int, fname:String,lname:String,emailID:String,gender:String,dob:String, salary:String, image:String) -> Bool{
        let context = getContext()
        let entity = NSEntityDescription.entity(forEntityName: "Employee", in: context)
        let manageObject = NSManagedObject(entity: entity!, insertInto: context)
        manageObject.setValue(id, forKey: "id")
        manageObject.setValue(fname, forKey: "fname")
        manageObject.setValue(lname, forKey: "lname")
        manageObject.setValue(emailID, forKey: "emailID")
        manageObject.setValue(gender, forKey: "gender")
        manageObject.setValue(dob, forKey: "dob")
        manageObject.setValue(salary, forKey:"salary")
        manageObject.setValue(image, forKey: "image")
        do {
            try context.save()
            return true
        }catch{
            return false
        }
    }
    class func fetchObject() -> [Employee]?{
        let context =  getContext()
        var employee:[Employee]? = nil
        do{
            employee = try context.fetch(Employee.fetchRequest())
            return employee
        }catch{
            return employee
        }
    }
    
    class func getCount()-> Int {
        var count = 0
        let context = getContext()//(UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Employee")
        do {
            
            count = try context.count(for: fetchRequest)
        
        } catch _ {}
        //context.countForFetchRequest(fetchRequest, error: nil)
        
        return count
    }
    
    class func deleteRecord(id: Int) -> Bool {
        let context = CoreDataHandler.getContext()
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Employee")
       // let predicate = NSPredicate(format: "id ='\(id)'")
        fetchRequest.predicate = NSPredicate(format: "id ='\(id)'")
        let objects = try! context.fetch(fetchRequest)
        for obj in objects {
            context.delete(obj as! NSManagedObject)
        }
        
        do {
            try context.save() // <- remember to put this :)
            return true
        } catch {
            
            return false
            // Do something... fatalerror
        }

    }
    class func updateRecord(id: Int, fname:String,lname:String,emailID:String,gender:String,dob:String, salary:String, image:String) -> Bool  {
        
        var isSuccess:Bool = false
        
        //guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
         //   return
       // }
        let managedContext = CoreDataHandler.getContext()//appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Employee")
       // let predicate1 = NSPredicate(format: "id = ", <#T##args: CVarArg...##CVarArg#>)
        let predicate = NSPredicate(format: "id ='\(id)'")
            fetchRequest.predicate = predicate
            do{
            let test = try managedContext.fetch(fetchRequest)
            if test.count == 1
            {
            let objectUpdate = test[0] as! NSManagedObject
                
                objectUpdate.setValue(id, forKeyPath: "id")
            objectUpdate.setValue(fname, forKey: "fname")
                objectUpdate.setValue(lname, forKey: "lname")
                objectUpdate.setValue(emailID, forKey: "emailID")
                objectUpdate.setValue(dob, forKey: "dob")
                objectUpdate.setValue(salary, forKey: "salary")
                objectUpdate.setValue(gender, forKey: "gender")
                objectUpdate.setValue(image, forKey: "image")
            //objectUpdate.setValue(UIImageJPEGRepresentation(imgUserImg.image!, 1), forKey: “image”)
            do {
            try managedContext.save()
                
                isSuccess = true
           // showAlert(withTitleMessageAndAction: “Sucess!!”, message: “Your record has been updated sucessfully!!”, action: true)
            } catch let error as NSError {
                
                print("Could not save. \(error), \(error.userInfo)")
                isSuccess = false
               // return false
            //
            }
            }
            }
            catch{
            print(error)
                
                isSuccess = false
        }
        
        return isSuccess
    }
}
