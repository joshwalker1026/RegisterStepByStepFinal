//
//  ChangeDataViewController.swift
//  StepByStepRegister
//
//  Created by Mac on 2017/2/3.
//  Copyright © 2017年 Mac. All rights reserved.


import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase

class ChangeDataViewController: UIViewController {
    
    
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var gender: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var phone: UITextField!
    
    var uid = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let user = FIRAuth.auth()?.currentUser {
            uid = user.uid
        }
    
        var ref: FIRDatabaseReference!
        
        ref = FIRDatabase.database().reference(withPath: "ID/\(self.uid)/Profile/Name")
        ref.observe(.value, with: { (snapshot) in
            let name = snapshot.value as! String
            self.name.text = name
        })
        
        ref = FIRDatabase.database().reference(withPath: "ID/\(self.uid)/Profile/Gender")
        ref.observe(.value, with: { (snapshot) in
            let gender = snapshot.value as! String
            self.gender.text = gender
        })
        
        ref = FIRDatabase.database().reference(withPath: "ID/\(self.uid)/Profile/Email")
        ref.observe(.value, with: { (snapshot) in
            let email = snapshot.value as! String
            self.email.text = email
        })
        
        ref = FIRDatabase.database().reference(withPath: "ID/\(self.uid)/Profile/Phone")
        ref.observe(.value, with: { (snapshot) in
            let phone = snapshot.value as! String
            self.phone.text = phone
        })
    
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func save(_ sender: Any) {
        
        
        if name.text != "" && gender.text != "" && email.text != "" && phone.text != "" {
            FIRDatabase.database().reference(withPath: "ID/\(self.uid)/Profile/Name").setValue(name.text)
            FIRDatabase.database().reference(withPath: "ID/\(self.uid)/Profile/Gender").setValue(gender.text)
            FIRDatabase.database().reference(withPath: "ID/\(self.uid)/Profile/Email").setValue(email.text)
            FIRDatabase.database().reference(withPath: "ID/\(self.uid)/Profile/Phone").setValue(phone.text)
            
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let nextVC = storyboard.instantiateViewController(withIdentifier: "ConfirmViewControllerID")as! ConfirmViewController
            self.present(nextVC,animated:true,completion:nil)
        }
        

    }
    
}
