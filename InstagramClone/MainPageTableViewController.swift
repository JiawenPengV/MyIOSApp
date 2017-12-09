//
//  MainPageTableViewController.swift
//  InstagramClone
//
//  Created by Jiawen Peng on 8/19/17.
//  Copyright © 2017 Jiawen Peng. All rights reserved.
//

import UIKit
import CoreData

class MainPageTableViewController: UITableViewController {

    
    
     var currentuser = ""
    
    var followeringUsers = [String]()
    
    var usernames = [String]()
    
    var messages = [String]()
    
    var imageFiles = [NSData]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let followerrequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Followers")
        
        followerrequest.predicate = NSPredicate(format : "follower = %@",currentuser)
        
        followerrequest.returnsObjectsAsFaults = false
        
        do {
            
            let results  = try context.fetch(followerrequest)
            
            if results.count > 0 {
                for result in results as! [NSManagedObject] {
                    let followeringUser = result.value(forKey: "following") as! String
                    followeringUsers.append(followeringUser)
                }
            }
            
        } catch {
            print("cann ot fetch data")
            
        }
        
        
        followeringUsers.append(currentuser)
        
        for user in followeringUsers {
            
            let postrequest = NSFetchRequest<NSFetchRequestResult>(entityName :"Posts")
            
            postrequest.predicate = NSPredicate(format: "username = %@", user)
            
            postrequest.returnsObjectsAsFaults = false
            
            do {
                
                let results = try context.fetch(postrequest)
                
                if results.count > 0 {
                    
                    for result in results as! [NSManagedObject] {
                        
                        let usern = result.value(forKey: "username") as! String
                        
                        let message = result.value(forKey: "message") as! String
                        
                        let img = result.value(forKey: "image") as! NSData
                        
                        self.usernames.append(usern)
                        self.messages.append(message)
                        self.imageFiles.append(img)
                        
                    }
                    
                }
                
            } catch {
                print("can not find")
            }
            
            
            
        }
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
        return messages.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! FeedTableViewCell


        cell.usernamelalbel.text = usernames[indexPath.row]
        
        cell.messagelabel.text = messages[indexPath.row]

        cell.postedimage.image = UIImage(data: imageFiles[indexPath.row]as! Data)
        
        return cell
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
