//  EmployeeVC.swift
//  CoreDataEmployee
//  Created by vaayoousa on 15/06/18.
//  Copyright © 2018 vaayoousa. All rights reserved.

import UIKit
import CoreData


  class  EmployeeVC : UIViewController , UITableViewDelegate , UITableViewDataSource, AddEmployeeDelegate  {
    

    var empList: [NSManagedObject] = []
    
    //Adding Dictionary to  Array
     var employeeList = Array<Dictionary<String,String>>()//initialized array
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        tableView.delegate = self
        tableView.dataSource = self
        self.tableView.addSubview(self.refresherControl) //concept regarding pull to refresh
       super.viewDidLoad()
        
        empList = CoreDataHandler.fetchObject()!
        
        print("count \(String(describing: empList))")
        
    }
    //UITableViewDataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    //UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return empList.count
    }
    //UITableViewDataSource
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 160
    }
    //UITableViewDataSource
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "employeeCell") as! EmployeeCell
        
        let emp = empList[indexPath.row]
         let fileURL = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        let dirPath = "\(fileURL)/Images/\(emp.value(forKeyPath: "image") ?? "")"
        //cell.editt.button = UIButton
        cell.imgeView.image = UIImage.init(contentsOfFile: dirPath)
        cell.lblID.text = emp.value(forKeyPath: "id") as? String
        cell.employeee.text = emp.value(forKeyPath: "fname") as? String//dict["FName"]
        cell.dateField.text = emp.value(forKeyPath: "dob") as? String//dict["DOB"]
        cell.numericSalary.text = emp.value(forKeyPath: "salary") as? String //dict["Salary"]
        //Below two lines is there to make  round or circular image
        cell.imgeView.layer.cornerRadius = cell.imgeView.frame.size.height / 2
        cell.imgeView.layer.masksToBounds = true
        
        cell.btnEdit.tag = indexPath.row
        cell.btnEdit.addTarget(self, action: #selector(btnEditPressed(sender:)), for: .touchUpInside)
        
        return cell
    }
    //UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let AdDeMployee = self.storyboard?.instantiateViewController(withIdentifier: "addemployee") as? AddEmployee
          self.present(AdDeMployee!, animated: true, completion: nil)
    }
    
   
    //perform (+)
    @IBAction func performAddition(_ sender: Any) {
        let AdDeMployee = self.storyboard?.instantiateViewController(withIdentifier: "addemployee") as? AddEmployee
        AdDeMployee?.delegate = self
        self.present(AdDeMployee!, animated: true, completion: nil)
    }
   
    func launchEmployeeVC()
    {
        let story = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "") as! AddEmployee
        story.delegate = self
        self.navigationController?.pushViewController(story, animated: true)
    }

    func fetchEmployeeData() {
        
        empList = CoreDataHandler.fetchObject()!
        tableView.reloadData()
        
    }
    
   //Swipe to Delete
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
     
        let deleteAction = UIContextualAction(style: .normal, title: "") { (action, view, completion) in
            // Perform your action here
         // remove the item from the data model
     
            let emp = self.empList[indexPath.row]
            let id = emp.value(forKeyPath: "id")
            
            if CoreDataHandler.deleteRecord(id: id! as! Int) {
            
                self.empList.remove(at: indexPath.row)
                DispatchQueue.main.async {
                    
                    tableView.deleteRows(at: [indexPath], with: .fade)
                    tableView.reloadData()
                    
                }
                
            
            }

        }
        deleteAction.image = #imageLiteral(resourceName: "Delete")
        deleteAction.backgroundColor = UIColor.red
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.delete) {
            // handle delete (by removing the data from your array and updating the tableview)
        }
    }
    //Perform Edit
    
    @objc public func btnEditPressed(sender: UIButton) {
        
        let AdDeMployee = self.storyboard?.instantiateViewController(withIdentifier: "addemployee") as? AddEmployee
        AdDeMployee?.delegate = self
        let indexPath = NSIndexPath(item: sender.tag, section: 0)
        let cell = tableView.cellForRow(at: indexPath as IndexPath) as! EmployeeCell
        
        
        AdDeMployee?.isEdit = true
        
        AdDeMployee?.emp = empList[sender.tag]
        
        print("Data to Pass:\(String(describing: AdDeMployee?.emp)), name \(String(describing: cell.employeee.text))")
        self.present(AdDeMployee!, animated: true, completion: nil)
        
    }
    
    
    // pull to refresh
    lazy  var refresherControl:UIRefreshControl = {
        let refrsControl = UIRefreshControl()
        refrsControl.addTarget(self , action: #selector(EmployeeVC.pullToRefresh(_:)) , for: .valueChanged)
        refrsControl.tintColor = UIColor.blue
        return refrsControl
    }()
    @objc func pullToRefresh(_ refrsControl: UIRefreshControl){
        let deadline = DispatchTime.now() + .milliseconds(20)//increase or decrease refreshing time from here
        DispatchQueue.main.asyncAfter(deadline: deadline){
        self.tableView.reloadData()
        refrsControl.endRefreshing()
        }
    }
    func displayMyAlertMessage(employeeMessage:String){
        let myAlert = UIAlertController(title: "Alert", message: employeeMessage, preferredStyle: UIAlertControllerStyle.alert)
        let okAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: {(action:UIAlertAction!) in
            let AdDeMployee = self.storyboard?.instantiateViewController(withIdentifier: "addemployee") as? AddEmployee
            self.present(AdDeMployee!, animated: true, completion: nil)
        })
        myAlert.addAction(okAction)
        self.present(myAlert,animated: true,completion: nil)
    }
   }
