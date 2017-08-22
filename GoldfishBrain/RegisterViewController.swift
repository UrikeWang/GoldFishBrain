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
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var appTitle: UILabel!
    @IBOutlet weak var appLogo: UIImageView!

//    var gradientLayer: CAGradientLayer()

    @IBAction func registerButton(_ sender: Any) {

        guard let email = emailText.text, let password = passwordText.text, let firstName = firstNameText.text, let lastName = lastNameText.text else {

            print("Register failed!")

            return
        }

        //當新的註冊者使用重複的email，會被firebase阻止登入
        Auth.auth().createUser(withEmail: email, password: password, completion: {(user: User?, error) in

            if error != nil {
                print("錯誤訊息:", error as Any)
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

        dismiss(animated: true, completion: nil)
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

//        appLogo.tintColor = UIColor.black
        appLogo.layer.shadowOffset = CGSize(width: 0, height: 3)
        appLogo.layer.shadowOpacity = 0.4
        appLogo.layer.shadowRadius = 4
        appLogo.layer.shadowColor = UIColor.black.cgColor

        appTitle.text = "GOLDFISH\nBRAIN"
        appTitle.font = UIFont(name: "Comix Loud", size: 20.0)

        let attrString = NSMutableAttributedString(string: appTitle.text!)
        var style = NSMutableParagraphStyle()
        style.lineSpacing = 24 // change line spacing between paragraph like 36 or 48
        style.minimumLineHeight = 20 // change line spacing between each line like 30 or 40
        attrString.addAttribute(NSParagraphStyleAttributeName, value: style, range: NSRange(location: 0, length: (appTitle.text?.characters.count)!))
        appTitle.attributedText = attrString
        appTitle.textAlignment = .center
        appTitle.textColor = UIColor.white

        firstNameText.placeholder = "First Name"
        firstNameText.backgroundColor = UIColor.textBackground
        firstNameText.layer.cornerRadius = 15
        firstNameText.textAlignment = .center
        firstNameText.textColor = UIColor.white
        firstNameText.returnKeyType = .done
//        firstNameText.font = UIFont(descriptor: ".Myriad Pro Semibold", size: 16)

        lastNameText.placeholder = "Last Name"
        lastNameText.backgroundColor = UIColor.textBackground
        lastNameText.layer.cornerRadius = 15
        lastNameText.textAlignment = .center
        lastNameText.textColor = UIColor.white
        lastNameText.returnKeyType = .done

        emailText.placeholder = "Email"
        emailText.backgroundColor = UIColor.textBackground
        emailText.layer.cornerRadius = 15
        emailText.textAlignment = .center
        emailText.textColor = UIColor.white
        emailText.returnKeyType = .done

        passwordText.placeholder = "Password"
        passwordText.backgroundColor = UIColor.textBackground
        passwordText.layer.cornerRadius = 15
        passwordText.textAlignment = .center
        passwordText.textColor = UIColor.white
        passwordText.returnKeyType = .done

        registerButton.layer.cornerRadius = 15
        registerButton.backgroundColor = UIColor.buttonBackground
        registerButton.contentHorizontalAlignment = .center
        registerButton.setTitleColor(UIColor.buttonTitleBackground, for: .normal)
        registerButton.setTitle("Register", for: .normal)

        loginButton.layer.cornerRadius = 15
        loginButton.backgroundColor = UIColor.buttonBackground
        loginButton.contentHorizontalAlignment = .center
        loginButton.setTitleColor(UIColor.buttonTitleBackground, for: .normal)
        loginButton.setTitle("Login", for: .normal)

    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
