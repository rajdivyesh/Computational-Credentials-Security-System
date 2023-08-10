//
//  PasswordGeneratorViewController.swift
//  PrjPasswordManager
//
//  Created by shanipatel on 17/04/23.
//

import UIKit

class PasswordGeneratorViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var sliderLbl: UILabel!
    @IBOutlet weak var PasswordLbl: UILabel!
    @IBOutlet weak var btnSave: UIButton!
    @IBOutlet weak var btnRefresh: UIButton!
    @IBOutlet weak var generatorTableView: UITableView!
    
    var uppercase = true
    var lowercase = true
    var digits = true
    var sliderValue = 16
    let lowercaseStr = "abcdefghijklmnopqrstuvwxyz"
    let uppercaseStr = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
    let digitsStr = "0123456789"
    
    var titleArr = ["Uppercase Letters","Lowercase Letters","Digits"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        generatorTableView.delegate = self
        generatorTableView.dataSource = self
        sliderLbl.text = "Password Lenght : 16"
        generateButtonPressed()
        self.generatorTableView.reloadData()

    }
    
    @IBAction func sliderValueChanged(_ sender: UISlider) {
        sliderValue = Int(sender.value)
        sliderLbl.text = "Password Lenght : \(Int(sender.value))"
        generateButtonPressed()
        self.generatorTableView.reloadData()
    }
    
    @IBAction func saveBtnAction(_ sender: UIButton) {
        appdelegate.generatedpassword = PasswordLbl.text ?? ""
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func refreshBtnAction(_ sender: Any) {
        generateButtonPressed()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "passwordGeneratorCell") as? GeneratorTableViewCell
        cell?.titleLbl.text = titleArr[indexPath.row]
        
        if indexPath.row == 0{
            let uppercaseSwitch = UISwitch()
            uppercaseSwitch.setOn(uppercase, animated: false)
            uppercaseSwitch.addTarget(self, action: #selector(uppercaseSwichValueChanged(_:)), for: .valueChanged)
            cell?.accessoryView = uppercaseSwitch
        }else if indexPath.row == 1{
            let lowercaseSwitch = UISwitch()
            lowercaseSwitch.setOn(lowercase, animated: false)
            lowercaseSwitch.addTarget(self, action: #selector(lowercaseSwichValueChanged(_:)), for: .valueChanged)
            cell?.accessoryView = lowercaseSwitch
        }else if indexPath.row == 2{
            let digitsSwitch = UISwitch()
            digitsSwitch.setOn(digits, animated: false)
            digitsSwitch.addTarget(self, action: #selector(digitSwichValueChanged(_:)), for: .valueChanged)
            cell?.accessoryView = digitsSwitch
        }
        
        if let aData = cell {
            return aData
        }
        return UITableViewCell()
    }
    
    @objc func uppercaseSwichValueChanged(_ sender: UISwitch) {
        uppercase = sender.isOn
        generateButtonPressed()
        generatorTableView.reloadData()
    }
    
    @objc func lowercaseSwichValueChanged(_ sender: UISwitch) {
        lowercase = sender.isOn
        generateButtonPressed()
        generatorTableView.reloadData()
    }
    
    @objc func digitSwichValueChanged(_ sender: UISwitch) {
        digits = sender.isOn
        generateButtonPressed()
        generatorTableView.reloadData()
    }
    
    func checkAllSwitchISOn(){
        if uppercase == false && lowercase == false && digits == false{
            btnSave.isHidden = true
            btnRefresh.isHidden = true
        }else{
            btnSave.isHidden = false
            btnRefresh.isHidden = false
        }
    }
    
    func generateButtonPressed() {
        checkAllSwitchISOn()
        var passwordCharSet = ""
        PasswordLbl.text = ""
        if uppercase == true{
            passwordCharSet += uppercaseStr
        }
        
        if lowercase == true{
            passwordCharSet += lowercaseStr
        }
        
        if digits == true{
            passwordCharSet += digitsStr
        }
        
        for _ in 0..<sliderValue{
            if passwordCharSet.count > 0{
                PasswordLbl.text! += String(passwordCharSet.randomElement()!)
            }
        }
    }
}
