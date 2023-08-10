//
//  MainViewController.swift
//  PrjPasswordManager
//
//  Created by Karansinh Parmar on 2023-04-15.
//

import UIKit
import CoreData

let appdelegate = UIApplication.shared.delegate as! AppDelegate


class MainViewController: UIViewController, UITableViewDelegate,  UITableViewDataSource, NSFetchedResultsControllerDelegate {

    
    let cellIdentifier = "listWithItemAndNameCell"
    var listArr = NSMutableArray()
    
    var passwordFetchedResultsController: NSFetchedResultsController<PasswordInfo>?
    
    @IBOutlet weak var tableViewList: UITableView!
    @IBOutlet weak var ViewNoRecord: UIView!
    @IBOutlet weak var btnAdd: UIButton!
    @IBOutlet weak var lblNoRecord: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableViewList.delegate = self
        tableViewList.dataSource = self
        tableViewList.register(UINib(nibName: "ListWithItemAndNameCell", bundle: .main), forCellReuseIdentifier: cellIdentifier)

        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: .done, target: self, action:  #selector(logoutAction))

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.setFetchedResultsController()
        self.tableViewList.reloadData()
    }
    
    
    func setFetchedResultsController() {
        listArr.removeAllObjects()
            let fetch = NSFetchRequest<PasswordInfo>(entityName: "PasswordInfo")
            fetch.sortDescriptors = [NSSortDescriptor(key: "username", ascending: false)]
        if let mail = UserDefaults.standard.string(forKey: "emailID"){
            fetch.predicate = NSPredicate(format: "mail == %@",mail)
        }
        passwordFetchedResultsController = NSFetchedResultsController(fetchRequest: fetch, managedObjectContext: appdelegate.persistentContainer.viewContext, sectionNameKeyPath: nil, cacheName: nil)
            passwordFetchedResultsController?.delegate = self
            do {
                try passwordFetchedResultsController?.performFetch()
            } catch {
                print("Error fetching products")
            }
            listArr.addObjects(from: (passwordFetchedResultsController?.fetchedObjects)!)
        if listArr.count > 0{
            ViewNoRecord.isHidden = true
        }else{
            ViewNoRecord.isHidden = false
        }
        tableViewList.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return listArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as? ListWithItemAndNameCell
            
        if let passwordInfo = listArr[indexPath.row] as? PasswordInfo{
            cell?.nameLbl.text = passwordInfo.username
        }
        
//        let cellBGView = UIView()
//        cellBGView.backgroundColor = UIColor(named: "SelectedColor")
//        cell?.selectedBackgroundView = cellBGView
        
        if let aData = cell {
            return aData
        }
        
        return UITableViewCell()
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destVC = segue.destination as! AddPasswordViewController
        if let senderObj = sender as? NSManagedObject{
            destVC.selectedObj = senderObj
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedObj = listArr[indexPath.row]
        performSegue(withIdentifier: "AddPasswordViewController", sender: selectedObj)
    }

    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    @objc func logoutAction(){
        UserDefaults.standard.set("", forKey: "emailID")
        UserDefaults.standard.set(false, forKey: "ISRegistr")
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let registrationViewController = storyboard.instantiateViewController(withIdentifier: "SignInViewController")
        let nav = UINavigationController(rootViewController: registrationViewController)
        if let window = UIApplication.shared.keyWindow {
            window.rootViewController = nav
            window.makeKeyAndVisible()
        }
    }
    
}
