//
//  ViewEmployeeVC.swift
//  BrainvireTask
//
//  Created by Velozion Mac on 03/July/2019A.
//

import UIKit
import CoreData

class ViewEmployeeVC: UIViewController {

    @IBOutlet weak var EmployeeDetailsTV: UITableView!
    
    var window: UIWindow?
    var employeeInfoArray :[Any] = []
    var dict = NSMutableDictionary()
    let appdelegate = UIApplication.shared.delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        EmployeeDetailsTV.register(UINib(nibName: "EmployeeDetailsCell", bundle: nil), forCellReuseIdentifier: "EmployeeDetailsCell")
        EmployeeDetailsTV.estimatedRowHeight = UITableView.automaticDimension
    }
    
    override func viewWillAppear(_ animated: Bool) {
        DispatchQueue.main.async {
            self.employeeInfoArray.removeAll()
            let context = self.appdelegate.persistentContainer.viewContext
            var details = [EmployeeInfo]()
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "EmployeeInfo")
            fetchRequest.returnsObjectsAsFaults = false
            details = try! context.fetch(fetchRequest) as! [EmployeeInfo]
            for detail in details {
                self.employeeInfoArray.append(detail)
            }
            self.EmployeeDetailsTV.reloadData()
        }
    }
}

extension ViewEmployeeVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return employeeInfoArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EmployeeDetailsCell") as! EmployeeDetailsCell
        cell.selectionStyle = .none
        let dic = employeeInfoArray[indexPath.row] as! NSManagedObject
        cell.nameLbl.text = dic.value(forKey: "empName") as? String
        cell.desLbl.text = dic.value(forKey: "empDes") as? String
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = storyboard?.instantiateViewController(identifier: "ViewEmployeeDetails") as! ViewEmployeeDetails
        vc.index = indexPath.row
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") {  (contextualAction, view, boolValue) in
            let temp = self.employeeInfoArray[indexPath.row] as! NSManagedObject
            let userNAME = temp.value(forKey: "empName")
            let context = self.appdelegate.persistentContainer.viewContext
            let entitydec = NSEntityDescription.entity(forEntityName: "EmployeeInfo", in:  context)
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: "EmployeeInfo")
            request.entity = entitydec
            let pred = NSPredicate(format: "empName = %@", userNAME as! CVarArg)
            request.predicate = pred
            
            do {
                let result = try context.fetch(request)
                if result.count > 0 {
                    let manage = result[0] as! NSManagedObject
                    context.delete(manage)
                    try
                        context.save()
                    print("Record Deleted")
                } else {
                    print("Record Not Found")
                }
                
            } catch {}
            DispatchQueue.main.async {
                let alert: UIAlertController = UIAlertController(title: "Confirm Delete", message: "Are u sure!! Do u want delete this record?", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action) in
                    self.employeeInfoArray.remove(at: indexPath.row)
                    self.EmployeeDetailsTV.deleteRows(at: [indexPath], with: .middle)
                    self.EmployeeDetailsTV.reloadData()
                }))
                alert.addAction(UIAlertAction(title: "No", style: .default, handler: nil))
                self.present(alert, animated: true)
            }
        }
        
        let swipeActions = UISwipeActionsConfiguration(actions: [deleteAction])
        
        return swipeActions
    }
}
