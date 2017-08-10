//
//  ViewController.swift
//  GoldfishBrain
//
//  Created by yuling on 2017/7/25.
//  Copyright © 2017年 yuling. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class LoginViewController: UIViewController {

    @IBOutlet weak var emailText: UITextField!
    @IBOutlet weak var passwordText: UITextField!

    @IBAction func loginButton(_ sender: Any) {

        guard let email = emailText.text, let password = passwordText.text else {

            print("Login failed!")

            return
        }

        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in

            if error != nil {

                print("email or password is false")

                return
            }

            guard let userUid = user?.uid else {

                print("userUid is nil")

                return
            }

            UserDefaults.standard.set(userUid, forKey: "uid")

            UserDefaults.standard.synchronize()

            //因為Firebase會延遲，按下確認鍵，將註冊的個人資料丟到Firebase上，這是需要幾秒鐘的時間，倘若直接Segue，資料還來不及送達Firebase，就已經到達下一個頁面，這就非常有可能造成Error
            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle:nil)

            let tabBarVC = storyBoard.instantiateViewController(withIdentifier: "TabBarVC")

            self.present(tabBarVC, animated: true, completion: nil)
        }

    }

    @IBAction func forgetPasswordButton(_ sender: Any) {

        if emailText.text == "" {

            print("You have to keyin your email")

        } else {

            Auth.auth().sendPasswordReset(withEmail: emailText.text!, completion: { (error) in

                if error != nil {

                    print("error occured", error)

                } else {

                    print("Sent password reset mail successfully!")

                }

            })

        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        passwordText.isSecureTextEntry = true

        let gradientLayer = CAGradientLayer()

        gradientLayer.frame = self.view.bounds

        gradientLayer.colors = [ UIColor(red: 229.0 / 255.0, green: 255.0 / 255.0, blue: 255.0 / 255.0, alpha: 1.0).cgColor,
                                 UIColor(red: 241.0 / 255.0, green: 171.0 / 255.0, blue: 64.0 / 255.0, alpha: 1.0).cgColor,
                                 UIColor(red: 218.0 / 255.0, green: 52.0 / 255.0, blue: 51.0 / 255.0, alpha: 1.0).cgColor,
                                 UIColor.white.cgColor ]

        gradientLayer.startPoint = CGPoint(x: 0.0, y: 1.0)

        gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.0)

        self.view.layer.insertSublayer(gradientLayer, at: 0)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
