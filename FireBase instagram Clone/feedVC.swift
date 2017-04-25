//
//  FirstViewController.swift
//  FireBase instagram Clone
//
//  Created by Mohamed El Naggar on 4/24/17.
//  Copyright © 2017 Mohamed El Naggar. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseStorage
import FirebaseDatabase


class feedVC: UIViewController , UITableViewDelegate , UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    var allPosts = [(String , String , String)]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        getDataFromServer()
    }
    
    private func getDataFromServer() {
        FIRDatabase.database().reference().child("users").observe(.childAdded, with: { (snapshot) in
            let values = snapshot.value! as! NSDictionary
            let posts = values["posts"] as! NSDictionary
            
            let postIDs = posts.allKeys
            
            for id in postIDs {
                let singlePost = posts[id] as! NSDictionary
                
                let user = singlePost["postedby"] as! String
                let imgString = singlePost["image"] as! String
                let text = singlePost["posttext"] as! String
                
                self.allPosts.append((user , imgString , text))
                
            }
            self.tableView.reloadData()
            
            print(self.allPosts.count)

        })
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allPosts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "feedCell", for: indexPath) as! feedCell
        
        cell.setAttributes(post: allPosts[indexPath.row])
        
        return cell
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func logoutClicked(_ sender: UIBarButtonItem) {
        UserDefaults.standard.removeObject(forKey: "userName")
        UserDefaults.standard.synchronize()
        
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        let signUp = self.storyboard?.instantiateViewController(withIdentifier: "signUp")
        
        appDelegate.window?.rootViewController = signUp
        
        appDelegate.rememberPassword()
        
    }

}

