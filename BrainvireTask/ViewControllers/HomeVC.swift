//
//  HomeVC.swift
//  BrainvireTask
//
//  Created by Velozion Mac on 03/July/2019A.
//

import UIKit
import CoreData
class HomeVC: UIViewController {

    @IBOutlet weak var empName: UITextField!
    @IBOutlet weak var empDes: UITextField!
    @IBOutlet weak var empMobileNum: UITextField!
    @IBOutlet weak var empEmail: UITextField!
    @IBOutlet weak var electCity: UITextField!
    
    let nscontext = ((UIApplication.shared.delegate) as!  AppDelegate).persistentContainer.viewContext
    override func viewDidLoad() {
        super.viewDidLoad()

        empName.delegate = self
        empDes.delegate = self
        empMobileNum.delegate = self
        empEmail.delegate = self
        // Do any additional setup after loading the view.
    }

    @IBAction func submitTapped(_ sender: Any) {
        if empName.text != "" && empDes.text != "" && empMobileNum.text != "" && empEmail.text != "" {
           
            empName.resignFirstResponder()
            empDes.resignFirstResponder()
            empMobileNum.resignFirstResponder()
            empEmail.resignFirstResponder()
            
            let entity = NSEntityDescription.insertNewObject(forEntityName: "EmployeeInfo",  into: nscontext)
            
            entity.setValue(empName.text, forKey:"empName")
            entity.setValue(empDes.text, forKey: "empDes")
            entity.setValue(empMobileNum.text, forKey: "empPhone")
            entity.setValue(empEmail.text, forKey: "empMail")
            
            do {
                try nscontext.save()
                empName.text = ""
                empDes.text = ""
                empMobileNum.text = ""
                empEmail.text = ""
            } catch {  }
            
            let alert: UIAlertController = UIAlertController(title: "Inserted successfully", message: "Employee details inserted successfully", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true)
        } else {
            let alert: UIAlertController = UIAlertController(title: "Fill all the details", message: "Fields should not be empty", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true)
        }
    }
}

extension HomeVC: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == empName || textField == empDes {
            let val = "[A-Za-z ]{3,30}"
            let test = NSPredicate(format: "Self Matches %@", val)
            if test.evaluate(with: textField.text) == false  {
                let alert: UIAlertController = UIAlertController(title: "Invalid Input", message: "Please Enter your Name only in alphabets with Minimum 3 letters", preferredStyle: .alert)
                let doneButton = UIAlertAction(title: "Ok", style: .default, handler: nil)
                alert.addAction(doneButton)
                self.present(alert,animated: true)
            }
        } else if textField == empMobileNum {
            let val = "[0-9]{10}"
            let test = NSPredicate(format: "Self Matches %@", val)
            if test.evaluate(with: empMobileNum.text) == false {
                let alert: UIAlertController = UIAlertController(title: "Invalid Input", message: "Please Enter your 10 digit 'Phone Number'", preferredStyle: .alert)
                let doneButton = UIAlertAction(title: "Ok", style: .default, handler: nil)
                alert.addAction(doneButton)
                self.present(alert,animated: true)
            }
        } else if textField == empEmail {
            let val = "[A-Z0-9a-z._%+-]+@[a-z.-]+\\.[a-z]{3,64}"
            let test = NSPredicate(format: "Self Matches %@", val)
            if test.evaluate(with: empEmail.text) == false {
                let alert: UIAlertController = UIAlertController(title: "Invalid Input", message: "Please Enter your Mail ID like 'sample@gmail.com'", preferredStyle: .alert)
                let doneButton = UIAlertAction(title: "Ok", style: .default, handler: nil)
                alert.addAction(doneButton)
                self.present(alert,animated: true)
            }
        }
    }
}
