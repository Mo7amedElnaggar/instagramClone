//
//  SecondViewController.swift
//  FireBase instagram Clone
//
//  Created by Mohamed El Naggar on 4/24/17.
//  Copyright © 2017 Mohamed El Naggar. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage
import PermissionScope

class uploadVC: UIViewController , UIImagePickerControllerDelegate , UINavigationControllerDelegate {

    @IBOutlet weak var postImage: UIImageView!
    @IBOutlet weak var postText: UITextView!
    @IBOutlet weak var chooseLabel: UILabel!
    
    // Photo Libary PErmission
    let photoLibary = PermissionScope()
    
    var uuid = NSUUID().uuidString // create unique id every Time to photo name
    
    override func viewDidLoad() {
        super.viewDidLoad()
        /* Adding Permission scopre FrameWork */
        photoLibary.addPermission(PhotosPermission(), message: "Access to Select Photo")
        
        // Do any additional setup after loading the view, typically from a nib.
        
        makeImageViewLikeCircle()
        
        postImage.isUserInteractionEnabled = true
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(uploadVC.showPermission))
        
        postImage.addGestureRecognizer(gestureRecognizer)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func uploadClicked(_ sender: UIButton) {
        let mediaFolder = FIRStorage.storage().reference().child("media")
        if postImage.image != nil {
            if let data = UIImageJPEGRepresentation(postImage.image! , 0.5) {
                mediaFolder.child("\(uuid).jpeg").put(data, metadata: nil , completion: {
                    (metadata , error) in
                    if error != nil {
                        self.alertME("Error" , (error?.localizedDescription)!)
                    } else {
                        
                        let imageURL = metadata?.downloadURL()?.absoluteString
                        
                        let post: [String : Any] = ["image" : imageURL! , "postedby": (FIRAuth.auth()!.currentUser!.email!) , "uuid": self.uuid , "posttext": self.postText.text]
                        
                        FIRDatabase.database().reference().child("users").child((FIRAuth.auth()?.currentUser?.uid)!).child("posts").childByAutoId().setValue(post)
                        
                        self.alertME("DONE" , "Your Post successfully done")
                        self.postImage.image = nil
                        self.postText.text = ""
                        self.chooseLabel.text = "Tap me and Choose a Photo"
                    }
                })
            }
        } else {
            alertME("Error", "Choose your image first :(")
        }
    }
    
    private func makeImageViewLikeCircle() {
        postImage.layer.borderWidth = 2.0
        postImage.layer.masksToBounds = false
        postImage.layer.borderColor = UIColor.purple.cgColor
        postImage.layer.cornerRadius = postImage.frame.size.height/2
        postImage.clipsToBounds = true
        
        
        postText.layer.cornerRadius = 5.0
        postText.layer.borderColor = UIColor.blue.cgColor
        postText.layer.borderWidth = 2.0
        postText.layer.shadowColor = UIColor.black.cgColor
        postText.layer.shadowOffset = CGSize(width: 5.0, height: 5.0)
        postText.layer.shadowOpacity = 5.0
        postText.layer.shadowRadius = 5.0
        
    }
    func showPermission() {
        
        photoLibary.show({ (finished, results) in
            self.selectImage()
        }) { (results) in
            
        }
    }
    
    func selectImage() {
 
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        picker.allowsEditing = true
        
        self.present(picker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        postImage.image = info[UIImagePickerControllerEditedImage] as? UIImage
        chooseLabel.isHidden = true
        self.dismiss(animated: true, completion: nil)
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    
    private func alertME(_ title: String , _ message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alert.addAction(cancel)
        
        self.present(alert, animated: true, completion: nil)
    }
    

}

