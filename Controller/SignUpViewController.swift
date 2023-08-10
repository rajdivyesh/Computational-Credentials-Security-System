//
//  SignUpViewController.swift
//  PrjPasswordManager
//
//  Created by Karansinh Parmar on 2023-04-15.
//

import UIKit
import CoreData

class SignUpViewController: UIViewController {
    
    var mailArray = [String]()
    

    @IBOutlet weak var mailtext: UITextField!
    @IBOutlet weak var passwordtext: UITextField!
    @IBOutlet weak var verifyPasswordtext: UITextField!
    @IBOutlet weak var btnSignUp: UIButton!
    @IBOutlet weak var btnShowPassword: UIButton!
    @IBOutlet weak var btnShowMainPassword: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func btnSignUpTouchUpInside(_ sender: Any) {
        
        let passwordRegPattern = "^(?=.*[A-Za-z])(?=.*\\d)(?=.*[$@$!%*#?&])[A-Za-z\\d$@$!%*#?&]{8,}$"
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let appdelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appdelegate.persistentContainer.viewContext
        
        // Fetch user information from CoreData
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "UserInfo")
        fetchRequest.predicate = NSPredicate(format: "mail = %@", mailtext.text!)
        fetchRequest.fetchLimit = 1
        
        do{
            let results = try context.fetch(fetchRequest)
            if results.count>0{
                let alert = UIAlertController(title: "Error!", message: "User Already Exist.", preferredStyle: .alert)
                
                let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) {
                    UIAlertAction in
                }
                alert.addAction(okAction)
                self.present(alert, animated: true, completion: nil)
                return
            }
            
            let password = NSEntityDescription.insertNewObject(forEntityName: "UserInfo", into: context)
            let mail = NSEntityDescription.insertNewObject(forEntityName: "UserInfo", into: context)
            
            if ((passwordtext.text?.range(of: passwordRegPattern, options: .regularExpression) != nil)&&(mailtext.text?.range(of: emailRegEx, options: .regularExpression) != nil)){
                
                if (passwordtext.text == verifyPasswordtext.text){
                    
                    // Save user information in CoreData
                    password.setValue(passwordtext.text, forKey: "password")
                    mail.setValue(mailtext.text, forKey: "mail")
                    try context.save()
                    
                    // create the alert
                    let alert = UIAlertController(title: "Success", message: "SignUp successful", preferredStyle: .alert)
                    
                    let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) {
                        UIAlertAction in
                        UserDefaults.standard.set(self.mailtext.text!, forKey: "emailID")
                        UserDefaults.standard.set(true, forKey: "ISRegistr")
                        let storyboard = UIStoryboard(name: "Main", bundle: nil)
                        let MainViewController = storyboard.instantiateViewController(withIdentifier: "MainViewController")
                        let nav = UINavigationController(rootViewController: MainViewController)
                        if let window = UIApplication.shared.keyWindow {
                            window.rootViewController = nav
                            window.makeKeyAndVisible()
                        }
                    }
                    alert.addAction(okAction)
                    // show the alert
                    self.present(alert, animated: true, completion: nil)
                } else {
                    // create the alert
                    let alert = UIAlertController(title: "Password Error", message: "Passwords do not match", preferredStyle: .alert)
                    
                    let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) {
                        UIAlertAction in
                    }
                    alert.addAction(okAction)
                    // show the alert
                    self.present(alert, animated: true, completion: nil)
                }
            } else {
                // create the alert
                let alert = UIAlertController(title: "Invalid Information", message: "Check E-Mail and Password again", preferredStyle: .alert)
                
                let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) {
                    UIAlertAction in
                }
                alert.addAction(okAction)
                // show the alert
                self.present(alert, animated: true, completion: nil)
            }
        }catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
    @IBAction func btnPasswordVisibilityTouchUpInside(_ sender: Any) {
        if verifyPasswordtext.isSecureTextEntry {
            btnShowPassword.setImage(UIImage(systemName: "eye.slash"), for: .normal)
        } else {
            btnShowPassword.setImage(UIImage(systemName: "eye"), for: .normal)
        }
        verifyPasswordtext.isSecureTextEntry.toggle()
    }
    
    @IBAction func btnMainPasswordVisibilityTouchUpInside(_ sender: Any) {
        if passwordtext.isSecureTextEntry {
            btnShowMainPassword.setImage(UIImage(systemName: "eye.slash"), for: .normal)
        } else {
            btnShowMainPassword.setImage(UIImage(systemName: "eye"), for: .normal)
        }
        passwordtext.isSecureTextEntry.toggle()
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
