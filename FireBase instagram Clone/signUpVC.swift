//
//  signUpVC.swift
//  FireBase instagram Clone
//
//  Created by Mohamed El Naggar on 4/24/17.
//  Copyright © 2017 Mohamed El Naggar. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class signUpVC: UIViewController {
    
    @IBOutlet weak var userName: UITextField!
    @IBOutlet weak var passWord: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func signInClicked(_ sender: UIButton) {
        
        if userName.text != "" && passWord.text != "" {
            FIRAuth.auth()?.signIn(withEmail: userName.text! , password: passWord.text!, completion: { (user , error) in
                if error != nil {
                    self.alertME("Error" , (error?.localizedDescription)!)
                } else {
                    UserDefaults.standard.set(self.userName.text!, forKey: "userName")
                    UserDefaults.standard.synchronize()
                    
                    let appDelegate = UIApplication.shared.delegate as! AppDelegate
                    
                    appDelegate.rememberPassword()
                    
                }
            })
            
        } else {
            alertME("Error", "You left some 7agat ro7 d5lha")
        }
    }

    @IBAction func signUpClicked(_ sender: UIButton) {
        if userName.text != "" && passWord.text != "" {
            
            FIRAuth.auth()?.createUser(withEmail: userName.text! , password: passWord.text!, completion: { (user , error) in
                if error != nil {
                    self.alertME("Error", (error?.localizedDescription)!)
                } else {
                    
                    UserDefaults.standard.set(self.userName.text!, forKey: "userName")
                    UserDefaults.standard.synchronize()
                    
                    let appDelegate = UIApplication.shared.delegate as! AppDelegate
                    
                    appDelegate.rememberPassword()
                }
                
            })
        
        } else {
            alertME("Error" , "You left some 7agat ro7 d5lha")
        }
    }
    
    private func alertME(_ title: String , _ message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alert.addAction(cancel)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    // For Keyboard touchBegans in View
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
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
