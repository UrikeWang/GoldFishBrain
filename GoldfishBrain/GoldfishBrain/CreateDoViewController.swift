//
//  CreateDoViewController.swift
//  GoldfishBrain
//
//  Created by yuling on 2017/8/3.
//  Copyright © 2017年 yuling. All rights reserved.
//

import UIKit

class CreateDoViewController: UIViewController, UIPopoverPresentationControllerDelegate, UITextFieldDelegate {

    @IBOutlet weak var dateText: UITextField!

    @IBOutlet weak var dateLabel: UILabel!

    @IBOutlet weak var destinationLabel: UILabel!

    @IBOutlet weak var toWhoLabel: UILabel!

    @IBOutlet var popMapView: UIView!

    @IBOutlet weak var createDoButton: UIButton!

    @IBOutlet weak var cancelDoButton: UIButton!

    var effect: UIVisualEffect!

    let dateTimeFormatter = DateFormatter()

    var datePicker = UIDatePicker()

    var travelDuration = ""

    var travelDistance = ""

    var travelDestination = ""

    var travelTime = ""

    @IBOutlet weak var travelDetails: UITextView!

    @IBAction func dateText(_ sender: UITextField) {

        let datePickerView: UIDatePicker = UIDatePicker()

        datePickerView.datePickerMode = UIDatePickerMode.date

        // 設置 UIDatePicker 格式
        datePickerView.datePickerMode = .dateAndTime

        // 選取時間時的分鐘間隔 這邊以 5 分鐘為一個間隔
        datePickerView.minuteInterval = 5

        datePickerView.date = Date()

        datePicker.locale = Locale(identifier: "zh_TW")

        // Creates the toolbar
        let toolBar = UIToolbar()
        toolBar.barStyle = .default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor(red: 92/255, green: 216/255, blue: 255/255, alpha: 1)
        toolBar.sizeToFit()

        // Adds the buttons
        let doneButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.done, target: self, action: #selector(CreateDoViewController.donePressed))

        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)

        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: "cancelClick")

        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)

        toolBar.isUserInteractionEnabled = true

        sender.inputView = datePickerView

        sender.inputAccessoryView = toolBar

        datePickerView.addTarget(self, action: #selector(CreateDoViewController.datePickerValueChanged), for: UIControlEvents.valueChanged)
    }

    @IBAction func destinationText(_ sender: Any) {

        //swiftlint:disable force_cast
        let popVC = storyboard?.instantiateViewController(withIdentifier: "popVC") as! AddDoPopViewController
        //swiftlint:enable force_cast

        popVC.modalPresentationStyle = .popover

        if let popOverVC = popVC.popoverPresentationController {

            //swiftlint:disable force_cast
            let viewForSource = sender as! UITextField
            //swiftlint:enable force_cast

            popOverVC.sourceView = viewForSource

            popOverVC.permittedArrowDirections = UIPopoverArrowDirection(rawValue: 0)

            popVC.preferredContentSize = CGSize(width: 350, height: 600)

            popOverVC.delegate = self

            /*//把原本按鈕隱藏
            viewForSource.alpha = 0.0
            viewForSource.layer.cornerRadius = 5
            viewForSource.layer.borderWidth = 2
            */
        }

        self.present(popVC, animated: true, completion: nil)

    }

    //Picker Date Done Button
    func donePressed(_ sender: UIBarButtonItem) {

        dateText.resignFirstResponder()

    }

    func datePickerValueChanged(_ sender: UIDatePicker) {

        let dateFormatter1 = DateFormatter()

        dateFormatter1.dateFormat = "yyyy-MM-dd HH:mm"

        dateText.text = dateFormatter1.string(from: sender.date)

        travelTime = dateText.text!

//        dateText.resignFirstResponder()

    }

    func cancelClick() {

        dateText.resignFirstResponder()
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

        dateText.placeholder = "add time.."

        //textFieldDidBeginEditing
        self.dateText.delegate = self

        dateLabel.text = "Select your start time"

        destinationLabel.text = "Select your desination"

        toWhoLabel.text = "Select your friend who you want to notify"

        createDoButton.setTitle("Create", for: .normal)

        cancelDoButton.setTitle("Cancel", for: .normal)

    }

    override func viewWillAppear(_ animated: Bool) {

        super.viewWillAppear(animated) // No need for semicolon

        dateText.text = travelTime

        print("33333333", travelTime)

        travelDetails.text = "目的地：\(travelDestination)\r\n起始時間：\(travelTime)\r\n總距離：\(travelDistance)\r\n預估時間：\(travelDuration)\r\n"

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
