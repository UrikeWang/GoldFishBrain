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
import NVActivityIndicatorView

class LoginViewController: UIViewController {

    @IBOutlet weak var emailText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var appTitle: UILabel!
    @IBOutlet weak var appLogo: UIImageView!
    @IBOutlet weak var forgotPasswordButton: UIButton!

    @IBAction func loginButton(_ sender: Any) {

        guard let email = emailText.text, let password = passwordText.text else {

            print("Login failed!")

            return
        }

        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in

            if error != nil {

                let alertController = UIAlertController(
                    title: "溫馨小提醒",
                    message: "\((error?.localizedDescription)!)",
                    preferredStyle: .alert)

                let check = UIAlertAction(title: "OK", style: .default, handler: { (_ : UIAlertAction) in
                    alertController.dismiss(animated: true, completion: nil)
                })

                alertController.addAction(check)

                self.present(alertController, animated: true, completion: nil)

                return
            }

            guard let userUid = user?.uid else {

                print("userUid is nil")

//                self.alertLabel.isHidden = false
//
//                self.alertLabel.text = "You have not registered yet."

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

//            print("You have to keyin your email")
//
//            self.alertLabel.isHidden = false

//            self.alertLabel.text = "Please enter your email."

            let alertController = UIAlertController(
                title: "溫馨小提醒",
                message: "請輸入email，這樣才能寄通知信到您原本註冊的信箱喔！",
                preferredStyle: .alert)

            let check = UIAlertAction(title: "OK", style: .default, handler: { (_ : UIAlertAction) in
                alertController.dismiss(animated: true, completion: nil)
            })

            alertController.addAction(check)

            self.present(alertController, animated: true, completion: nil)

        } else {

            Auth.auth().sendPasswordReset(withEmail: emailText.text!, completion: { (error) in

                if error != nil {

                    let alertController = UIAlertController(
                        title: "溫馨小提醒",
                        message: "\((error?.localizedDescription)!)",
                        preferredStyle: .alert)

                    let check = UIAlertAction(title: "OK", style: .default, handler: { (_ : UIAlertAction) in
                        alertController.dismiss(animated: true, completion: nil)
                    })

                    alertController.addAction(check)

                    self.present(alertController, animated: true, completion: nil)

                    return

                } else {

//                    print("Sent password reset mail successfully!")

//                    self.alertLabel.isHidden = false
//
//                    self.alertLabel.text = "Login..."

                    let activityData = ActivityData()

                    NVActivityIndicatorPresenter.sharedInstance.startAnimating(activityData)

                }

            })

        }
    }

    @IBAction func registerButton(_ sender: Any) {

        if emailText.text! != "" || passwordText.text! != "" {

            let alertController = UIAlertController(
                title: "溫馨小提醒",
                message: "真的要離開登入頁面嗎？",
                preferredStyle: .alert)

            let ok = UIAlertAction(title: "OK", style: .default, handler: { (_ : UIAlertAction) in

                let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)

                let registerVC = storyBoard.instantiateViewController(withIdentifier: "RegisterVC")

                self.present(registerVC, animated: true, completion: nil)

            })

            let cancel = UIAlertAction(title: "Cancel", style: .default) { (_ : UIAlertAction) in

                alertController.dismiss(animated: true, completion: nil)
            }

            alertController.addAction(ok)

            alertController.addAction(cancel)

            self.present(alertController, animated: true, completion: nil)

        } else {

            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)

            let registerVC = storyBoard.instantiateViewController(withIdentifier: "RegisterVC")

            self.present(registerVC, animated: true, completion: nil)

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

//        appLogo.tintColor = UIColor.black
        appLogo.layer.shadowOffset = CGSize(width: 0, height: 3)
        appLogo.layer.shadowOpacity = 0.4
        appLogo.layer.shadowRadius = 4
        appLogo.layer.shadowColor = UIColor.black.cgColor

        appTitle.text = "GOLDFISH\nBRAIN"
        appTitle.font = UIFont(name: "Comix Loud", size: 20.0)

        let attrString = NSMutableAttributedString(string: appTitle.text!)
        let style = NSMutableParagraphStyle()
        style.lineSpacing = 24 // change line spacing between paragraph like 36 or 48
        style.minimumLineHeight = 20 // change line spacing between each line like 30 or 40
        attrString.addAttribute(NSParagraphStyleAttributeName, value: style, range: NSRange(location: 0, length: (appTitle.text?.characters.count)!))
        appTitle.attributedText = attrString
        appTitle.textAlignment = .center
        appTitle.textColor = UIColor.white

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

        forgotPasswordButton.backgroundColor = UIColor.clear
        forgotPasswordButton.setTitleColor(UIColor.white, for: .normal)
        forgotPasswordButton.setTitle("Forgot your password?", for: .normal)
        forgotPasswordButton.contentHorizontalAlignment = .center

//        NVActivityIndicatorView(frame: CGRect(x: view.frame.width/2, y: view.frame.height/2, width: 100, height: 100), type: .pacman, color: UIColor.white, padding: 10)

//        alertLabel.isHidden = true
//        alertLabel.backgroundColor = UIColor.clear
//        alertLabel.textAlignment = .center

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
