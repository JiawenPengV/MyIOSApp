//
//  TableViewController.swift
//  InstagramClone
//
//  Created by Jiawen Peng on 8/18/17.
//  Copyright © 2017 Jiawen Peng. All rights reserved.
//

import UIKit
import CoreData

class TableViewController: UITableViewController {
    
    var isFollowing = ["": false]
    
    var currentuser = ""
    
    var usernames = [String]()
    
    var resfresher: UIRefreshControl?
    
    @IBAction func logout(_ sender: Any) {
        
         self.performSegue(withIdentifier: "logoutSegue", sender: self)
    }

    func refresh(){
        getAccount()
        resfresher?.endRefreshing()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        getAccount()
        
        resfresher = UIRefreshControl()
        resfresher?.attributedTitle = NSAttributedString(string :"Loding...")
        resfresher?.addTarget(self, action: #selector(TableViewController.refresh), for: UIControlEvents.valueChanged)
        
        tableView.addSubview(resfresher!)
       
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return usernames.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        

        let user = usernames[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        cell.textLabel?.text = user
        
        fetchFollowers(username : user)
        
        if isFollowing[user]! {
            
            cell.accessoryType = UITableViewCellAccessoryType.checkmark
            
        }
        return cell
    }


    func getAccount() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName : "Users")
        
        request.returnsObjectsAsFaults = false
        
        do{
            
            let results = try context.fetch(request)
            
            if results.count > 0 {
                
                for result in results as! [NSManagedObject] {
                    if let user = result.value(forKey: "username") as? String {
                        
                        if user != currentuser {
                            
                             usernames.append(user)
                            
                        }
                       
                    }
                }
                
            }
            
        } catch {
            
            print("can not find")
       
        }
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let cell = tableView.cellForRow(at: indexPath)
        
        let user  = usernames[indexPath.row]
        
        if isFollowing[user]! {
            
            isFollowing[user] = false
            cell?.accessoryType = UITableViewCellAccessoryType.none
            
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            
            let context = appDelegate.persistentContainer.viewContext
            
            let request = NSFetchRequest<NSFetchRequestResult>(entityName : "Followers")
            
            request.predicate = NSPredicate(format: "follower == %@ AND following = %@", self.currentuser,user)
            
            request.returnsObjectsAsFaults = false
            
            do {
                
                let results = try context.fetch(request)
                
                if results.count > 0 {
                    
                    for result in results as! [NSManagedObject] {
                        
                        context.delete(result)
                        
                        do {
                            try context.save()
                            
                        } catch {
                            
                            print("Deleted failed")
                            
                        }
                    }
                }
                
            }catch {
                
                print("cann ot fetch results")
                
            }
        } else {
            
            isFollowing[user] = true
            
            cell?.accessoryType = UITableViewCellAccessoryType.checkmark
            
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            
            let context = appDelegate.persistentContainer.viewContext
            
            let follower = NSEntityDescription.insertNewObject(forEntityName: "Followers", into : context)
            
           
            follower.setValue(currentuser, forKey: "follower")
           
            follower.setValue(usernames[indexPath.row],
                              forKey :"following")
            do {
               
                try context.save()
                
            } catch {
               
                print("can't save")
            }
        }
        
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showPosts" {
            
            let postViewController = segue.destination as!ReviewViewController
            
            postViewController.currentUser = currentuser
            
            
        }
        
        
        if segue.identifier == "showMainPage" {
            
            let newTableViewController = segue.destination as!MainPageTableViewController
            
            newTableViewController.currentuser = currentuser
            
            
        }
        
        
    }
    
    func fetchFollowers(username : String) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName : "Followers")
        //request.predicate = NSPredicate(format : "following = %@",username)
        request.predicate = NSPredicate(format: "follower = %@ AND following = %@",self.currentuser,username)
        request.returnsObjectsAsFaults = false
        
        do {
            let results = try context.fetch(request)
            
            if results.count > 0 {
                self.isFollowing[username] = true
            } else {
               self.isFollowing[username] = false
            }
        } catch {
            print("!!")
        }
        
    }
    
    
    
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
