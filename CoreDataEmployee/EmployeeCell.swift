//  EmployeeCell.swift
//  CoreDataEmployee
//  Created by vaayoousa on 16/06/18.
//  Copyright © 2018 vaayoousa. All rights reserved.

import UIKit
class EmployeeCell: UITableViewCell {
   
    @IBOutlet weak var imgeView: UIImageView!
    @IBOutlet weak var dateField: UILabel!
    @IBOutlet weak var employeee: UILabel!
    @IBOutlet weak var numericSalary: UILabel!
    
    @IBOutlet weak var btnEdit: UIButton!
    
    @IBOutlet weak var lblID: UILabel!
    @IBAction func editt(_ sender: Any) {
        
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
           }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
