//
//  ViewController.swift
//  GoldfishBrain
//
//  Created by yuling on 2017/7/25.
//  Copyright © 2017年 yuling. All rights reserved.
//

import UIKit
import FirebaseAuth

class LoginViewController: UIViewController {

    @IBOutlet weak var emailText: UITextField!

    @IBOutlet weak var passwordText: UITextField!

    @IBAction func loginButton(_ sender: Any) {

        guard let email = emailText.text, let password = passwordText.text else {

            print("Login failed!")
            return
        }

        Auth.auth().signIn(withEmail: email, password: password) { (_, error) in

            if error != nil {

                print("email or password is false")
                return
            }

            //因為Firebase會延遲，按下確認鍵，將註冊的個人資料丟到Firebase上，這是需要幾秒鐘的時間，倘若直接Segue，資料還來不及送達Firebase，就已經到達下一個頁面，這就非常有可能造成Error
            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            let tabBarVC = storyBoard.instantiateViewController(withIdentifier: "TabBarVC")
            self.present(tabBarVC, animated: true, completion: nil)
        }

    }

    override func viewDidLoad() {
        super.viewDidLoad()

        passwordText.isSecureTextEntry = true

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
