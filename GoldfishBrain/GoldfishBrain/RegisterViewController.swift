//
//  RegisterViewController.swift
//  GoldfishBrain
//
//  Created by yuling on 2017/7/25.
//  Copyright © 2017年 yuling. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class RegisterViewController: UIViewController {

    @IBOutlet weak var emailText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    @IBOutlet weak var firstNameText: UITextField!
    @IBOutlet weak var lastNameText: UITextField!
    
    
    @IBAction func registerButton(_ sender: Any) {
        
        guard let email = emailText.text, let password = passwordText.text, let firstName = firstNameText.text, let lastName = lastNameText.text else {
            
            print("Register failed!")
            
            return
        }
        
        Auth.auth().createUser(withEmail: email, password: password, completion: {
            (user: User?, error) in
            
            if error != nil {
                print(error)
                return
            }
            
            guard let uid = user?.uid else {
                
                return
                
            }
            
            let ref = Database.database().reference(fromURL: "https://goldfishbrain-e2684.firebaseio.com/")
            
            //建立firebase的巢狀結構
            let userReference = ref.child("users").child(uid)
            let values = ["firstName": firstName, "lastName": lastName, "email": email, "password": password]
            userReference.updateChildValues(values, withCompletionBlock: {
                (err, ref) in
                
                if err != nil {
                    
                    print(err)
                    return
                }
                
                print("saved user successfully into firebase")
                
                
                let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle:nil)

                let tabBarVC = storyBoard.instantiateViewController(withIdentifier: "TabBarVC")
                self.present(tabBarVC, animated: true, completion: nil)
//                self.performSegue(withIdentifier: "loginToProfile", sender: sender)
                
            })
            
        })

    }

    @IBAction func loginButton(_ sender: Any) {
        
        self.performSegue(withIdentifier: "registerToLogin", sender: sender)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        passwordText.isSecureTextEntry = true

        // Do any additional setup after loading the view.
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
