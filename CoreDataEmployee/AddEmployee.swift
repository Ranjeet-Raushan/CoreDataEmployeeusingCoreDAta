//  AddEmployee.swift
//  CoreDataEmployee
//  Created by vaayoousa on 16/06/18.
//  Copyright © 2018 vaayoousa. All rights reserved.

import UIKit
import CoreData
protocol AddEmployeeDelegate {
    //func addEmployeeData(dictionary: Dictionary<String, String>)
    func fetchEmployeeData()
    
}
class AddEmployee: UIViewController ,UIPickerViewDataSource , UIPickerViewDelegate ,UITextFieldDelegate , UINavigationControllerDelegate , UIImagePickerControllerDelegate{
    var isEdit:Bool = false
    var emp:NSManagedObject? = nil
   // let emp
   // For Image Library
    @IBOutlet weak var lblTitle: UINavigationItem!
    @IBOutlet weak var myImage: UIImageView!
    var imageName = ""
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
    if let image = info[UIImagePickerControllerOriginalImage] as? UIImage
      {
        myImage.image = image
        let imageFolder = getImagesFolder()
        let uniqueFileName = getUniqueFileName()
        let finalPath = URL.init(fileURLWithPath: "\(String(describing: imageFolder))/\(String(describing: uniqueFileName))")
        
        let data = UIImagePNGRepresentation(image)
  imageName = uniqueFileName
        do
        {
            try data?.write(to: finalPath)
        }
        catch {
            let err = error as Error
            print(err)
        }
      }
        else
        {
          //Error message
        }
        self.dismiss(animated: true, completion: nil)
    }
    var employee:[Employee]? = nil
   var text = "Main"
    let gender = ["Male","Female","Others"]
    var delegate: AddEmployeeDelegate?
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
 }
func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return gender.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        genderField.text = gender[row]
        return gender[row]
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        genderField.text = gender[row]
    }
override func viewDidLoad() {
        super.viewDidLoad()
    //For Gender
    createGenderPicker()
    genderField.delegate = self
    genderField.inputView = picker
    picker.delegate = self
    picker.dataSource = self
    //For Date of Birth
    createDatePicker()
    myImage.isUserInteractionEnabled = true
    let TapGesture = UITapGestureRecognizer(target: self , action: #selector(AddEmployee.ImageTapped))
    self.myImage.addGestureRecognizer(TapGesture)
    if isEdit {
        let fileURL = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        let dirPath = "\(fileURL)/Images/\(emp?.value(forKeyPath: "image") ?? "")"
        //cell.editt.button = UIButton
        myImage.image = UIImage.init(contentsOfFile: dirPath)
        print("data : \(String(describing: emp))")
        //self.navigationItem.title = "Edit Employee"
        lblTitle.title = "Edit Employee"
        txtFName.text = emp?.value(forKeyPath: "fname") as? String//?["FName"] as? String
        txtLName.text = emp?.value(forKeyPath: "lname") as? String
        txtEmailID.text = emp?.value(forKeyPath: "emailID") as? String
        dateField.text = emp?.value(forKeyPath: "dob") as? String
        numericSalary.text = emp?.value(forKeyPath: "salary") as? String
        genderField.text = emp?.value(forKeyPath: "gender") as? String
        imageName = (emp?.value(forKeyPath: "image") as? String)!
    }
  }
    @objc func ImageTapped(){
        print("image Tapped")
        let image = UIImagePickerController()
        image.delegate = self
        image.sourceType = UIImagePickerControllerSourceType.photoLibrary
        image.allowsEditing = false
        self.present(image , animated: true)
        {
            //After it is complete
        }
    }
   //For Date of Birth
    let pickerDate = UIDatePicker()
    @IBOutlet weak var dateField: UITextField!
    func createDatePicker(){
        //toolbar
        let toolbarDOB = UIToolbar()
        toolbarDOB.sizeToFit()
        //done button for toolbar
        let doneDOB = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(doneDOBPressed))
        toolbarDOB.setItems([doneDOB],animated: false)
        dateField.inputAccessoryView = toolbarDOB
        dateField.inputView = pickerDate
      //format picker for date
        pickerDate.datePickerMode = .date
    }
    @objc func doneDOBPressed(){
        //  format date
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        let dateString = formatter.string(from: pickerDate.date)
        dateField.text = "\(dateString)"
        self.view.endEditing(true)
    }
 //For Gender
    let picker = UIPickerView()
    @IBOutlet weak var genderField: UITextField!
    func createGenderPicker(){
        //toolbar
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        //doneDOB button for toolbar
        let done = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(donePressed))
        toolbar.setItems([done],animated: false)
        genderField.inputAccessoryView = toolbar
    }
    @objc func donePressed(){
       // self.genderField.text =
        genderField.resignFirstResponder()
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
   }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        return true
    }
    @IBOutlet weak var txtFName: UITextField!
    @IBOutlet weak var txtLName: UITextField!
    @IBOutlet weak var txtEmailID: UITextField!
    @IBOutlet weak var numericSalary: UITextField!
    @IBAction func submitt(_ sender: Any) {
        
        
        if((txtFName.text! == "") || (txtLName.text! == "") || (txtEmailID.text! == "") || (numericSalary.text! == "")  || (dateField.text! == "")||(genderField.text! == ""))
        {
            //Display alert message
            displayMyAlertMessage(employeeMessage: "All fields are required", tag: 1)
            return
        }
        
        if isEdit {
            
            let success: Bool = CoreDataHandler.updateRecord(id: emp?.value(forKeyPath: "id") as! Int, fname: txtFName.text!, lname: txtLName.text!, emailID: txtEmailID.text!, gender: genderField.text!, dob: dateField.text! ,salary:numericSalary.text! , image: imageName)
            if success{
                
                if let del = self.delegate {
                    del.fetchEmployeeData()
                }
                // success message
                displayMyAlertMessage(employeeMessage:"submitted  successfully", tag: 0)
            }else{
                // error msg
                displayMyAlertMessage(employeeMessage:"submission failed", tag: 1)
            }
            
        } else {
            
            employee = CoreDataHandler.fetchObject()
            let count = CoreDataHandler.getCount()
            let success: Bool = CoreDataHandler.saveObject(id: count + 1, fname: txtFName.text!, lname: txtLName.text!, emailID: txtEmailID.text!, gender: genderField.text!, dob: dateField.text! ,salary:numericSalary.text! , image: imageName)
            if success{
                
                if let del = self.delegate {
                    del.fetchEmployeeData()
                }
                // success message
                displayMyAlertMessage(employeeMessage:"submitted  successfully", tag: 0)
            }else{
                // error msg
                displayMyAlertMessage(employeeMessage:"submission failed", tag: 1)
            }
        }
    //fething object
        
}
    func displayMyAlertMessage(employeeMessage:String, tag: Int){
        let myAlert = UIAlertController(title: "Alert", message: employeeMessage, preferredStyle: UIAlertControllerStyle.alert)
        
        if(tag == 0) {
            
            let okAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: {(action:UIAlertAction!) in
                self.dismiss(animated: true, completion: nil)
                })
            myAlert.addAction(okAction)
            } else {
            
                let okAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil)
            myAlert.addAction(okAction)
        }
        self.present(myAlert,animated: true,completion: nil)
    }
    func getImagesFolder() -> NSString
    {
        let documentFolderPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] //
        let imagesFolderPath = documentFolderPath + "/Images" //
        
        //Check if the images folder is already exist?  if not create it!
        var isDir: ObjCBool = true
        
        let isExist = FileManager.default.fileExists(atPath: imagesFolderPath, isDirectory:&isDir)
        if isExist == false
        {
            do
            {
                try FileManager.default.createDirectory(atPath: imagesFolderPath, withIntermediateDirectories: true, attributes: nil)
            }
            catch
            {
                let fetchError = error as NSError
                print(fetchError)
            }
        }
        return imagesFolderPath as NSString
    }
    func getUniqueFileName() -> String
    {
        let time = Foundation.Date()
        let df = DateFormatter()
        df.dateFormat = "MMddyyyyhhmmssSSS"
        let timeString = df.string(from: time)
        let fileName = "\(timeString).png"
        return fileName
    }
}
