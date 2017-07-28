//
//  ChatLogViewController.swift
//  GoldfishBrain
//
//  Created by yuling on 2017/7/27.
//  Copyright © 2017年 yuling. All rights reserved.
//

import UIKit
import FirebaseDatabase

class ChatLogViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {

    var people = [Person]()

    var peopleFirstName = ""

    var peopleLastName = ""

//    var person: Person? {
//        
//        didSet {
//            
//            navigationItem.title = person?.firstName
//        
//        }
//    
//    }

    @IBOutlet weak var sendMessageView: UIView!

    @IBOutlet weak var messageText: UITextField!

    @IBOutlet weak var sendMessageButton: UIButton!

    @IBAction func lastPageButton(_ sender: Any) {

        dismiss(animated: true)

        peopleLastName = ""

        peopleFirstName = ""
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = peopleFirstName

//        sendMessageView.addTopBorder()

        sendMessageButton.setTitle("Send", for: .normal)

        sendMessageButton.addTarget(self, action: #selector(handleSendMessage), for: .touchUpInside)

        messageText.placeholder = "Enter message..."

        messageText.font = UIFont.asiTextStyle11Font()

        self.messageText.delegate = self

    }

    func handleSendMessage() {

        if let uid = UserDefaults.standard.value(forKey: "uid") {

            let ref = Database.database().reference(fromURL: "https://goldfishbrain-e2684.firebaseio.com/").child("messages")

            let childRef = ref.childByAutoId()

            let values = ["text": messageText.text, "name": uid]

            childRef.updateChildValues(values)
        }

    }

    //按完return鍵能自動送出message
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {

        textField.resignFirstResponder()

        handleSendMessage()

        return true
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 3
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        //swiftlint:disable force_cast
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChatLogCell", for: indexPath)
        //swiftlint:enable force_cast

        return cell
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
