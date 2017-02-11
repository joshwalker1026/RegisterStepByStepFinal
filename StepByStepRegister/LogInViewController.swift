//
//  LogInViewController.swift
//  StepByStepRegister
//
//  Created by Mac on 2017/2/3.
//  Copyright © 2017年 Mac. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class LogInViewController: UIViewController {
    
    @IBOutlet weak var Email: UITextField!
    @IBOutlet weak var Password: UITextField!
    
    var uid = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func SignUp_Button_Tapped(_ sender: Any) {
        if self.Email.text != "" || self.Password.text != ""{
            FIRAuth.auth()?.createUser(withEmail: self.Email.text!, password: self.Password.text!, completion: { (user, error) in
                
                if error == nil{
                    if let user = FIRAuth.auth()?.currentUser{
                        self.uid = user.uid
                    }
                }
                
                FIRDatabase.database().reference(withPath: "ID/\(self.uid)/Profile/Safety-Check").setValue("ON")
                
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let nextVC =  storyboard.instantiateViewController(withIdentifier: "SignUpViewControllerID") as! SignUpViewController
                self.present(nextVC, animated: true, completion: nil)
                
            })
        }
    }
    
    @IBAction func LogIn_Button_Tapped(_ sender: Any) {
        if self.Email.text != "" || self.Password.text != ""{
            FIRAuth.auth()?.signIn(withEmail: self.Email.text!, password: self.Password.text!, completion: { (user, error) in
                
                if error == nil {
                    if let user = FIRAuth.auth()?.currentUser{
                        self.uid = user.uid
                        
                        FIRDatabase.database().reference(withPath: "Online-Status/\(self.uid)").setValue("ON")
                    }
                    
                    FIRDatabase.database().reference(withPath: "ID/\(self.uid)/Profile/Safety-Check").setValue("ON")
                    
                    //跳到確認頁
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let nextVC = storyboard.instantiateViewController(withIdentifier: "ConfirmViewControllerID")as! ConfirmViewController
                    self.present(nextVC,animated:true,completion:nil)
                }
                
            })
        }

    }

        
    
    
    
    
    
}
