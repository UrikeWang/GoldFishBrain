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

        //當新的註冊者使用重複的email，會被firebase阻止登入
        Auth.auth().createUser(withEmail: email, password: password, completion: {(user: User?, error) in

            if error != nil {
                print("錯誤訊息:", error)
                return
            }

            guard let uid = user?.uid else {

                return

            }

            let ref = Database.database().reference(fromURL: "https://goldfishbrain-e2684.firebaseio.com/")

            //建立firebase的巢狀結構
            let userReference = ref.child("users").child(uid)

            let values = ["firstName": firstName, "lastName": lastName, "email": email, "profileImageURL": "https://firebasestorage.googleapis.com/v0/b/goldfishbrain-e2684.appspot.com/o/05c1348a7d53f02a1cc861f01d21878e-600x400.jpg?alt=media&token=0375102f-9417-466c-b957-74ac60dd91dc"] as [String : Any]

            userReference.updateChildValues(values, withCompletionBlock: {(err, _) in

                if err != nil {

                    print("錯誤訊息", err)
                    return
                }

                print("saved user successfully into firebase")

                guard let userUid = user?.uid else {

                    print("userUid is nil")

                    return
                }
                
                //存在userdefaults中為optional型態
                UserDefaults.standard.set(userUid, forKey: "uid")

                UserDefaults.standard.synchronize()

                let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle:nil)

                let tabBarVC = storyBoard.instantiateViewController(withIdentifier: "TabBarVC")

                self.present(tabBarVC, animated: true, completion: nil)

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
