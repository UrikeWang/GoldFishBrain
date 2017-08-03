//
//  CreateDoViewController.swift
//  GoldfishBrain
//
//  Created by yuling on 2017/8/3.
//  Copyright © 2017年 yuling. All rights reserved.
//

import UIKit

class CreateDoViewController: UIViewController, UIPopoverPresentationControllerDelegate {

    @IBAction func dateText(_ sender: Any) {

    }

    @IBAction func destinationText(_ sender: Any) {

        //       self.view.addSubview(darkView)

//        darkView.isHidden = false

        //swiftlint:disable force_cast
        let popVC = storyboard?.instantiateViewController(withIdentifier: "popVC") as! AddDoPopViewController
        //swiftlint:enable force_cast

        popVC.modalPresentationStyle = .popover

        var popOverVC = popVC.popoverPresentationController

        if let popOverVC = popVC.popoverPresentationController {

            //swiftlint:disable force_cast
            let viewForSource = sender as! UITextField
            //swiftlint:enable force_cast

            popOverVC.sourceView = viewForSource

            popOverVC.permittedArrowDirections = UIPopoverArrowDirection(rawValue: 0)

            popVC.preferredContentSize = CGSize(width: UIScreen.main.bounds.width, height: 600)

            popOverVC.delegate = self

            /*//把原本按鈕隱藏
            viewForSource.alpha = 0.0
            viewForSource.layer.cornerRadius = 5
            viewForSource.layer.borderWidth = 2
            */
        }

        self.present(popVC, animated: true, completion: nil)

    }

    func adaptivePresentationStyle(for controller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle {

        return .none

    }

    @IBAction func toWhoText(_ sender: Any) {
    }

    @IBAction func createDoButton(_ sender: Any) {
    }

    @IBAction func cancelDoButton(_ sender: Any) {
    }

    override func viewDidLoad() {
        super.viewDidLoad()

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
