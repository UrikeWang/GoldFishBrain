//
//  ChatLogViewController.swift
//  GoldfishBrain
//
//  Created by yuling on 2017/7/27.
//  Copyright © 2017年 yuling. All rights reserved.
//

import UIKit

class ChatLogViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBAction func lastPageButton(_ sender: Any) {

        dismiss(animated: true)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
