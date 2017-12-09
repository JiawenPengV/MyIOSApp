//
//  ReviewViewController.swift
//  InstagramClone
//
//  Created by Jiawen Peng on 8/19/17.
//  Copyright © 2017 Jiawen Peng. All rights reserved.
//

import UIKit
import CoreData


class ReviewViewController: UIViewController,UINavigationControllerDelegate,UIImagePickerControllerDelegate,UITextFieldDelegate {

    var currentUser = ""
    
    @IBOutlet weak var submitoutlet: UIButton!
    @IBOutlet weak var message: UITextField!
    @IBOutlet weak var imageView: UIImageView!
    
    @IBAction func submitAction(_ sender: Any) {
        
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        let context = appDelegate.persistentContainer.viewContext
        
        let newPost = NSEntityDescription.insertNewObject(forEntityName:"Posts", into: context)
        
        newPost.setValue(currentUser, forKey: "username")
        newPost.setValue(message.text, forKey:"message")
        
        let imageData = UIImagePNGRepresentation(imageView.image!)
        
        newPost.setValue(imageData, forKey: "image")
        
        do {
            try context.save()
            self.imageView.image = UIImage(named : "14_meitu_1.jpg")
            
            self.message.text = ""
            
            
            self.createAlert(title: "Uploaded", message: "Your review has been uploaded")
            
        } catch {
           self.createAlert(title: "Uploaded failed", message: "Your review fail to be uploaded")
        }
        
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        self.view.endEditing(true)
        
        
        
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        
        return true
        
    }
    
   
    func createAlert(title:String, message: String){
        
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        
        let cancelAction = UIAlertAction(title: "Comfirm", style: UIAlertActionStyle.cancel) {
            (cancel) in
            alert.dismiss(animated: true, completion: nil)
        }
        
        
        alert.addAction(cancelAction)
        
        self.present(alert, animated: true, completion:  nil)
    }
    
    
    @IBAction func choose(_ sender: Any) {
        
        let imagePicker = UIImagePickerController()
        
        imagePicker.delegate = self
        
        imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
        imagePicker.allowsEditing = false
        
        self.present(imagePicker,animated: true,completion: nil)
        
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            
            imageView.image = image
            
        }
        
        self.dismiss(animated: true, completion: nil)
        
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        submitoutlet.layer.cornerRadius = 50 / 2
        submitoutlet.clipsToBounds = true
        
        self.title = "\(currentUser) ' s review"
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
