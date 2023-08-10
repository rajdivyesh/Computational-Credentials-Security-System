//
//  AddPasswordViewController.swift
//  PrjPasswordManager
//
//  Created by Karansinh Parmar on 2023-04-16.
//

import UIKit
import CoreData

class AddPasswordViewController: UIViewController {

    @IBOutlet weak var pickerView: UIPickerView!
    
    @IBOutlet weak var usernameTxt: UITextField!
    @IBOutlet weak var websiteUrlTxt: UITextField!
    @IBOutlet weak var passwordLbl: UILabel!
    var selectedObj : NSManagedObject?

    var generatedPwd = ""
    var websiteURL = ["https://accounts.google.com/","https://appleid.apple.com/","https://www.facebook.com/login/","https://www.instagram.com/accounts/login/","https://www.linkedin.com/"]
    
    var websiteName = ["Google","Apple ID","Facebook","Instagram","Linkedln"]

    override func viewDidLoad() {
        super.viewDidLoad()
        self.websiteUrlTxt.text = "https://accounts.google.com/"

        if let selObj = selectedObj as? PasswordInfo{
            usernameTxt.text = selObj.username
            websiteUrlTxt.text = selObj.url
            passwordLbl.text = selObj.password
            
            //Adding option to delete in navbar if user has an object selected
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Delete", style: .done, target: self, action:  #selector(deleteAction))
        }
        
        pickerView.backgroundColor = .clear
        pickerView.dataSource = self
        pickerView.delegate = self
        
        
        print("Adding pickerView as subview...")
        view.addSubview(pickerView)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if appdelegate.generatedpassword.count>0{
            generatedPwd = appdelegate.generatedpassword
            passwordLbl.text = generatedPwd
            appdelegate.generatedpassword = ""
        }
    }

    @objc func deleteAction(){
        let product = selectedObj
        appdelegate.persistentContainer.viewContext.delete(product!)
        do {
            try appdelegate.persistentContainer.viewContext.save()
        } catch let error as NSError {
            // Handle the error here
            print("Error saving context: \(error.localizedDescription)")
        }
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func saveBtnAction(_ sender: Any) {
        let context = appdelegate.persistentContainer.viewContext
        if let selObj = selectedObj as? PasswordInfo{
            let addPassword = selObj
            addPassword.password = passwordLbl.text
            addPassword.url = websiteUrlTxt.text
            addPassword.username = usernameTxt.text
            if let mail = UserDefaults.standard.string(forKey: "emailID"){
                addPassword.mail = mail
            }

            do {
                try context.save()
                print("Successfully saved new PasswordInfo object")
            } catch {
                print("Failed to save new PasswordInfo object: \(error)")
            }
        }else{
            guard let addPassword = NSEntityDescription.insertNewObject(forEntityName: "PasswordInfo", into: context) as? PasswordInfo else {
                print("Failed to create new PasswordInfo object")
                return
            }
            addPassword.password = passwordLbl.text
            addPassword.url = websiteUrlTxt.text
            addPassword.username = usernameTxt.text
            if let mail = UserDefaults.standard.string(forKey: "emailID"){
                addPassword.mail = mail
            }
            do {
                try context.save()
                print("Successfully saved new PasswordInfo object")
            } catch {
                print("Failed to save new PasswordInfo object: \(error)")
            }
        }
        self.navigationController?.popViewController(animated: true)
    }
    
}

extension AddPasswordViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return websiteName.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return websiteName[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        websiteUrlTxt.text = websiteURL[row]
    }
}





