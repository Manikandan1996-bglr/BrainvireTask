//
//  ViewEmployeeDetails.swift
//  BrainvireTask
//
//  Created by Velozion Mac on 03/July/2019A.
//

import UIKit
import CoreData
class ViewEmployeeDetails: UIViewController {

    var index = 0
    var employeeInfoArray :[Any] = []
    var dict = NSMutableDictionary()
    let appdelegate = UIApplication.shared.delegate as! AppDelegate
    @IBOutlet weak var empNameLbl: UILabel!
    @IBOutlet weak var desLbl: UILabel!
    @IBOutlet weak var mobileLbl: UILabel!
    @IBOutlet weak var mailLbl: UILabel!
    @IBOutlet weak var stateLbl: UILabel!
    @IBOutlet weak var genderLbl: UILabel!
    @IBOutlet weak var degreeLbl: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let context = appdelegate.persistentContainer.viewContext
        var details = [EmployeeInfo]()
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "EmployeeInfo")
        fetchRequest.returnsObjectsAsFaults = false
        details = try! context.fetch(fetchRequest) as! [EmployeeInfo]
        for detail in details {
            employeeInfoArray.append(detail)
        }
        fillDetails()
        // Do any additional setup after loading the view.
    }
    
    func fillDetails() {
        let dic = employeeInfoArray[index] as! NSManagedObject
        empNameLbl.text = dic.value(forKey: "empName") as? String
        desLbl.text = dic.value(forKey: "empDes") as? String
        mobileLbl.text = dic.value(forKey: "empPhone") as? String
        mailLbl.text = dic.value(forKey: "empMail") as? String
    }
}
