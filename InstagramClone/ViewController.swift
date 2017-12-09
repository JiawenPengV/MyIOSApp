//
//  ViewController.swift
//  InstagramClone
//
//  Created by Jiawen Peng on 8/17/17.
//  Copyright © 2017 Jiawen Peng. All rights reserved.
//

import UIKit
import CoreData
class ViewController: UIViewController {
    
    var loginUser = ""
    
    var message = ""
    
    let redColor = UIColor.init(red: 255/255, green: 50/255, blue: 75/255, alpha: 1)
    
    let greenColor = UIColor.init(red: 30/255, green: 244/255, blue: 120/255, alpha: 1)
    
    var isExisted:Bool?

    //-----------------------sign up----------------------------------
    @IBAction func signupaction(_ sender: Any) {
        
        createAlert()
        
    }
    @IBOutlet weak var loginoutlet: UIButton!
    
    //------------------------log in ---------------------------------
    @IBAction func loginAction(_ sender: Any) {
        
        if account.text == "" || password.text == "" {
            
             self.message = "please insert account and password"
            
            errorView(message: message,color : redColor)
        } else {
            
            isExisted = false
            fetchAccount(username: account.text!, completionHandler: {
                (isExisted, userDictionsry) in
                
                if isExisted {
                    
                    let passwordg = (userDictionsry[0] as! NSDictionary)["password"]
                    
                    
                    if self.password.text == passwordg as? String {
                        self.message = "login successfully"
                        
                        self.errorView(message: self.message,color : self.greenColor)
                        
                        self.performSegue(withIdentifier: "showUserTable", sender: self)

                        
                    } else {
                        self.message = "please insert account and password"
                        
                        self.errorView(message: self.message,color : self.redColor)

                    }
                } else {
                    self.message = "account not existed"
                    
                    self.errorView(message: self.message,color : self.redColor)

                }
                
            })
            
        }
    }
    
   //---------------------prepare--------------------------------------
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showUserTable" {
            
            //let userTable = segue.destination as! TableViewController
            
            let navigationController = segue.destination as! UINavigationController
            
            let userTable = navigationController.topViewController as! TableViewController
            

            
            userTable.currentuser = loginUser
            
            
            
        }
    }
    
    
    
    @IBOutlet weak var password: UITextField!
    
    
    @IBOutlet weak var account: UITextField!
    
    
//------------------view did load--------------------------------------
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loginoutlet.layer.cornerRadius = 50 / 2
        loginoutlet.clipsToBounds = true
        
        self.navigationController?.navigationBar.isHidden = true
    }
  //----------------create account-----------------------------------
    func createAlert() {
        
        let alert = UIAlertController(title: "New Account", message: "PLease iput your account and password", preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "Cancal", style: .cancel) {
            
            (cancel) in
            
            self.dismiss(animated: true, completion: nil)
        
    }
        
        let createAction = UIAlertAction(title: "creat", style: .default){(create) in
            
            if alert.textFields?[0].text == "" || alert.textFields?[1].text == "" {
                self.message = "please insert account and password"
                
                self.errorView(message: self.message,color : self.redColor)

            } else {
                let user = alert.textFields![0]
                let pass = alert.textFields![1]
                self.createuser(username: user.text!, password: pass.text!)
            }
            
        }
    
        alert.addTextField{(textField) in
            textField.placeholder = "Account"
            
        }
        
        alert.addTextField{(textField) in
            textField.placeholder = "Password"
            textField.isSecureTextEntry = true
            
  }
        
        alert.addAction(cancelAction)
        alert.addAction(createAction)
        
        self.present(alert, animated:  true, completion: nil)
    }
    
 //---------------------error view--------------------------------------
    func errorView(message : String, color: UIColor) {
        
        let errorViewHeight = view.frame.height / 14
        
        let errorViewY = 0 - errorViewHeight
        
        let errorView = UIView(frame: CGRect(x: 0, y: errorViewY, width: view.frame.width, height: errorViewHeight))
        
        errorView.backgroundColor = color
        
        view.addSubview(errorView)
        
        let errorLabel = UILabel()
        errorLabel.frame.size.width = errorView.frame.width
        errorLabel.frame.size.height = errorView.frame.height
        
        errorLabel.text = message
        errorLabel.textColor = UIColor.white
        errorLabel.textAlignment = NSTextAlignment.center
        errorLabel.font = UIFont(name: "HelveticaNeue", size: 14)
        
        errorView.addSubview(errorLabel)
        
        UIView.animate(withDuration: 1, animations:
            {
                errorView.frame.origin.y = 0
        }) {
            (finished) in
            if finished {
                UIView.animate(withDuration: 0.1, delay: 2, options: UIViewAnimationOptions.curveLinear, animations: {
                    errorView.frame.origin.y = errorViewY
                }, completion: { (finished) in
                    if finished {
                        errorView.removeFromSuperview()
                        errorLabel.removeFromSuperview()
                    }
                })
            }
        }
        
    }
    
    
    
    //--------------------------fetch account-----------------------------
    func fetchAccount  (username:String, completionHandler: @escaping (_ isExisted: Bool, _ userDictionary: NSArray) ->()) {
        
        var array = [NSDictionary]()
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName :"Users")
        
        request.returnsObjectsAsFaults = false
        request.predicate = NSPredicate(format: "username = %@", username)
        
        
        do {
            let results = try context.fetch(request)
            if results.count > 0 {
                for result in results as! [NSManagedObject] {
                    
                    if let user = result.value(forKey: "username") as? String{
                        
                        self.isExisted = true
                        
                        let psw = result.value(forKey: "password") as! String
                        
                        let userDict = ["username" : user, "password" : psw]
                        
                        array.append(userDict as NSDictionary)
                        
                        
                        loginUser = userDict["username"]!
                    }
                    
                    
                }
            }
        } catch {
            print()
        }
        
        completionHandler(self.isExisted!, array as NSArray)
        
        
    }
    
    
    //---------------------------create users------------------------
    func createuser(username :String, password:String){
        self.isExisted = false
        
        self.fetchAccount(username: username) {
            (isExisted, array) in
            
            if isExisted {
                
                self.message = "User existed"
                
                self.errorView(message: self.message,color : self.redColor)

            } else {
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                let context = appDelegate.persistentContainer.viewContext
                
                let newUser = NSEntityDescription.insertNewObject(forEntityName :"Users", into :context)
                
                newUser.setValue(username, forKey: "username")
                newUser.setValue(password, forKey: "password")
                
                
                do {
                    
                    try context.save()
                    
                } catch {
                    
                    print("Can not save items")
                    
                }
                
                
                self.loginUser = username
                
                self.performSegue(withIdentifier: "showUserTable", sender: self)
            
            }
        
        
        }
        
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

