//
//  ProfileTableViewController+extension.swift
//  GoldfishBrain
//
//  Created by yuling on 2017/7/27.
//  Copyright © 2017年 yuling. All rights reserved.
//

import UIKit
import FirebaseStorage
import FirebaseAuth
import FirebaseDatabase

extension ProfileTableViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    func handleSelectionProfileImage() {

        let picker = UIImagePickerController()

        picker.delegate = self

        picker.sourceType = UIImagePickerControllerSourceType.photoLibrary

        picker.allowsEditing = true

        present(picker, animated: true, completion: nil)

    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {

        picker.dismiss(animated: true, completion: nil)

        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {

            let imageZip = UIImageJPEGRepresentation(image, 0.5)

            profileImage.image = image

            // 可以自動產生一組獨一無二的 ID 號碼，方便等一下上傳圖片的命名
            let uniqueString = NSUUID().uuidString

            saveProfileImage(image: imageZip, imageID: uniqueString)

        } else {

            print("Something went wrong")
        }
    }

//    func resizeImage(image: UIImage, newWidth: CGFloat) -> UIImage {
//
//        let scale = newWidth / image.size.width
//
//        let newHeight = image.size.height * scale
//
//        UIGraphicsBeginImageContext(CGSize(width: newWidth, height: newHeight))
//
//        image.draw(in: CGRect(x: 0, y: 0, width: newWidth, height: newHeight ))
//
//        let newImage = UIGraphicsGetImageFromCurrentImageContext()
//
//        UIGraphicsEndImageContext()
//
//        return newImage!
//    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {

        picker.dismiss(animated: true, completion: nil)

    }

    func saveProfileImage(image: Data?, imageID: String) {

        if let uid = UserDefaults.standard.value(forKey: "uid") {

            let storageRef = Storage.storage().reference().child("\(uid)").child("profileImageURL")

//            if let uploadData = UIImagePNGRepresentation(image) {

            if let uploadData = image {

                storageRef.putData(uploadData, metadata: nil, completion: { (data, error) in

                    if error != nil {

                        print("Something wrong with saving photo", error as Any)

                        return
                    }

                    if let uploadImageURL = data?.downloadURL()?.absoluteString {

                        let databaseRef = Database.database().reference().child("users").child("\(uid)")

                        databaseRef.updateChildValues(["profileImageURL": uploadImageURL])

                    }
                })

            }
        }

    }

}
