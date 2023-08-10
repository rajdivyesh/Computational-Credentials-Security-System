//
//  SignInViewController.swift
//  PrjPasswordManager
//
//  Created by Karansinh Parmar on 2023-04-15.
//

import UIKit
import CoreData

class SignInViewController: UIViewController,UITextFieldDelegate,  NSFetchedResultsControllerDelegate {
    
    var mailArray = [String]()
    var passwordArray = [String]()
    var remember = true
    //var registerFetchedResultsController: NSFetchedResultsController<RegistrationInfo>?
    //var registrationArr = NSMutableArray()
    
    @IBOutlet weak var mailText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    @IBOutlet weak var btnShowPassword: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.isNavigationBarHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.isNavigationBarHidden = false
    }
    @IBAction func btnLoginTouchUpInside(_ sender: Any) {
        let appdelegate = UIApplication.shared.delegate as! AppDelegate
                let context = appdelegate.persistentContainer.viewContext
                let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "UserInfo")
                fetchRequest.returnsObjectsAsFaults = false
                
                do{
                    let results = try context.fetch(fetchRequest)
                    
                    for result in results as! [NSManagedObject]{
                        if let mail = result.value(forKey: "mail") as? String{
                            self.mailArray.append(mail)
                        }
                        if let password = result.value(forKey: "password") as? String{
                            self.passwordArray.append(password)
                        }
                        
                    }
                }
                catch{
                    print("error")
                }
                
                if (mailArray.contains(mailText.text!)){
                    let mailIndex = mailArray.firstIndex(where: {$0 == mailText.text})
                    
                    if passwordArray[mailIndex!] == passwordText.text{
                        UserDefaults.standard.set(self.mailText.text!, forKey: "emailID")
                        if remember == true{
                            UserDefaults.standard.set(true, forKey: "ISRegistr")
                        }
                        let storyboard = UIStoryboard(name: "Main", bundle: nil)
                        let MainViewController = storyboard.instantiateViewController(withIdentifier: "MainViewController")
                        let nav = UINavigationController(rootViewController: MainViewController)
                        if let window = UIApplication.shared.keyWindow {
                            window.rootViewController = nav
                            window.makeKeyAndVisible()
                        }
                    }else{
                        let alert = UIAlertController(title: "Error!", message: "Password Not Found", preferredStyle: .alert)
                        // add an action (button)
                        //alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                        let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) {
                            UIAlertAction in
                        }
                        alert.addAction(okAction)
                        // show the alert
                        self.present(alert, animated: true, completion: nil)
                    }
                }
                else{
                    // create the alert
                    let alert = UIAlertController(title: "Not Found", message: "No account found for this e-mail address", preferredStyle: .alert)
                    // add an action (button)
                    //alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                    let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) {
                            UIAlertAction in
                        }
                    alert.addAction(okAction)
                    // show the alert
                    self.present(alert, animated: true, completion: nil)
                }
    }
    
    @IBAction func btnPasswordVisibilityTouchUpInside(_ sender: Any) {
        if passwordText.isSecureTextEntry {
            btnShowPassword.setImage(UIImage(systemName: "eye.slash"), for: .normal)
        } else {
            btnShowPassword.setImage(UIImage(systemName: "eye"), for: .normal)
        }
        passwordText.isSecureTextEntry.toggle()
    }
    
    @IBAction func rememberingMeAction(_ sender: UISwitch) {
        remember = sender.isOn
    }
    
    func signUpViewController(newUserSignedUp name: String, login: String, password: String) {
        mailText.text = login
        passwordText.text = password
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
