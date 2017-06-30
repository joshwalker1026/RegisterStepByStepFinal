//
//  LogInViewController.swift
//  StepByStepRegister
//
//  Created by Mac on 2017/2/3.
//  Copyright © 2017年 Mac. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth// 這邊的Auth，是指Authentication，「新增使用者UID」或是「從Auth獲取使用者UID」需要用到這個部分
import FirebaseDatabase // 需要用到Database


class LogInViewController: UIViewController {
    
    @IBOutlet weak var Email: UITextField!
    @IBOutlet weak var Password: UITextField!
    
    // uid 是「使用者的獨特編碼」，在這邊儲存成一個 "" ，沒有任何值的 String，這樣聽起來有點饒舌
    // 比如說：某使用者UID是 "Avdfu12ejsiod9"<隨便亂取>，在 SignUp_Button_Tapped 或 LogIn_Button_Tapped
    // 有一串程式碼是 「self.uid = user.uid」
    // 前者 uid 即是指 「var uid = ""」的 uid，而後者的 uid 是指 「Firebase - Auth 的 使用者UID」
    // 意思就是「將Firebase使用者uid儲存愛變數uid中」，因為 var 代表「變數」，最終就變成 var uid = "Avdfu12ejsiod9"
    // 這樣，在我們需要使用者UID的時候（不論「從Firebase拿取資料」或是「從手機將資料放置到Firebase」皆需要用到）就可以輕易使用了！
    var uid = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // 這是前往SignUpViewController的按鈕，但在到下一個ViewController之前，先「新增了一個使用者」
    @IBAction func SignUp_Button_Tapped(_ sender: Any) {
        
        // 第一個要確保 Email & Password 這兩個 Text Field 不能什麼字都沒打，不然這樣就不合理啦！
        // 當然還能用別的假設，如：Email一定要加上"@"等等，這是最簡單，卻也不是很謹慎的方式
        // 俗話說：「一個成功的App要假設使用者的所有可能」，也就是說絕對不能讓使用者產生Bug的機會啊
        // 所以還是可以好好想想要用什麼樣的假設，但基本邏輯上這樣沒問題！
        if self.Email.text != "" || self.Password.text != ""{
            
            // 接下來，FIRAuth.auth().createUser，這邊就是「新增使用者」，
            // 部落格中在步驟三的前半段，有先啟用電子郵件/密碼，所以這邊會有 withEmail, password
            // 另外提醒，順著打程式碼會出現
            // FIRAuth.auth()?.createUser(withEmail: String, password: String, completion: FIRAuthResultCallback?)，
            // 那怎麼變成 completion: { (user, error) in 這樣的呢？
            // 其實很簡單，只要在藍藍的 FIRAuthResultCallback? 按個 enter(return) 鍵，就會變成這樣囉
            FIRAuth.auth()?.createUser(withEmail: self.Email.text!, password: self.Password.text!, completion: { (user, error) in
                
                if error == nil{
                    if let user = FIRAuth.auth()?.currentUser{
                        
                        //這裏即是「var uid」那邊所說明的，將Firebase使用者uid儲存愛變數uid裡面，便可隨意使用，不用重複打這幾行程式碼
                        self.uid = user.uid
                    }
                }
                
                // 到了另一個重點啦！這是指在 database 中以 "ID/\(self.uid)/Profile/Safety-Check" 為路徑，設一個值: "ON"
                // 要在 Database 中建立資訊，一定要 setvalue 才會成功喔！
                FIRDatabase.database().reference(withPath: "ID/\(self.uid)/Profile/Safety-Check").setValue("ON")
                
                
                //「新增使用者」、「在Database中新增一個Safety-Check:"ON"」，接著就跳到註冊頁
                // 另外提醒，這邊要在 Main.storyboard，Show Utilities，Identity inspector(左邊數來第三個)
                // storyboardID 要記得改名字，像是這裡的SignUpViewController，要在storyboardID改成SignUpViewControllerID
                FIRDatabase.database().reference(withPath: "ID/\(self.uid)/Profile/Safety-Check").setValue("ON")
                
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let nextVC =  storyboard.instantiateViewController(withIdentifier: "SignUpViewControllerID") as! SignUpViewController
                self.present(nextVC, animated: true, completion: nil)
                
            })
        }
    }
    
    // 這是前往ConfirmViewController的按鈕，但在到下一個ViewController之前，先「在Firebase做登入的動作」
    @IBAction func LogIn_Button_Tapped(_ sender: Any) {
        
        // 一樣要先假設 Email & Password 要輸入某些字喔！
        if self.Email.text != "" || self.Password.text != ""{
            
            // 這裡跟SignUp_Button_Tapped不一樣的地方就是，從createUser改成SignIn，其餘都一樣，就不再贅述了
            FIRAuth.auth()?.signIn(withEmail: self.Email.text!, password: self.Password.text!, completion: { (user, error) in
                
                if error == nil {
                    if let user = FIRAuth.auth()?.currentUser{
                        self.uid = user.uid
                        
                    }
                    
                    // Online-Status 是線上狀態，在點選「登入」按鈕後，將Online-Status設定為On
                    FIRDatabase.database().reference(withPath: "Online-Status/\(self.uid)").setValue("ON")
                    
                    //跳到確認頁
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let nextVC = storyboard.instantiateViewController(withIdentifier: "ConfirmViewControllerID")as! ConfirmViewController
                    self.present(nextVC,animated:true,completion:nil)
                }
                
            })
        }

    }

        
    
    
    
    
    
}
