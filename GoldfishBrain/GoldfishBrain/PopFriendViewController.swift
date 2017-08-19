//
//  popFriendViewController.swift
//  GoldfishBrain
//
//  Created by yuling on 2017/8/7.
//  Copyright © 2017年 yuling. All rights reserved.
//

import UIKit
import Kingfisher

protocol managerFriendDelegate: class {

    func manager(_ manager: PopFriendViewController, name: String, id: String)
}

class PopFriendViewController: UIViewController, chatRoomManagerDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var friendCollectionView: UICollectionView!

    @IBOutlet weak var cancelSelectFriendButton: UIButton!

    let chatRoomManager = ChatRoomManager()

    var people = [Person]()

    weak var delegate: managerFriendDelegate?

    let sectionInsets = UIEdgeInsets(top: 30.0, left: 20.0, bottom: 30.0, right: 20.0)

    @IBAction func cancelSelectFriendButton(_ sender: Any) {

        dismiss(animated: true, completion: nil)
    }

    func chatRoomManager(_ manager: ChatRoomManager, didGetPeople people: [Person]) {

        self.people = people

        DispatchQueue.main.async {

            self.friendCollectionView.reloadData()
        }

    }

    func chatRoomManager(_ manager: ChatRoomManager, didGetFriend friend: Person) {

    }

    func chatRoomManager(_ manager: ChatRoomManager, didFailWith error: Error) {

    }

    override func viewDidLoad() {
        super.viewDidLoad()

        chatRoomManager.delegate = self

        chatRoomManager.fetchFriendIDs()

        cancelSelectFriendButton.setTitle("Cancel", for: .normal)
        cancelSelectFriendButton.setTitleColor(UIColor.white, for: .normal)
        cancelSelectFriendButton.layer.borderWidth = 2
        cancelSelectFriendButton.backgroundColor = UIColor.goldfishRed
        cancelSelectFriendButton.layer.borderColor = UIColor.goldfishRed.cgColor
        cancelSelectFriendButton.layer.cornerRadius = 20
        cancelSelectFriendButton.dropShadow()

    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

        return people.count
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {

        return sectionInsets

    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        let paddingSpace = sectionInsets.left * 3
        let availableWidth = UIScreen.main.bounds.width - paddingSpace
        let widthPerItem = availableWidth / 3

        return CGSize(width: widthPerItem, height: widthPerItem + 50)
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        //swiftlint:disable force_cast
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PopFriendCell", for: indexPath) as! PopFriendCollectionViewCell
        //swiftlint:enable force_cast

        cell.friendNameLabel.text = people[indexPath.row].firstName

        let url = URL(string: "\(people[indexPath.row].imageUrl)")

//        cell.friendPhoto.kf.setImage(with: url)

        cell.friendPhoto.sd_setImage(with: url, placeholderImage: UIImage(named: "icon-placeholder"))

        cell.friendPhoto.contentMode = .scaleAspectFill

        cell.friendPhoto.tag = indexPath.row

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        self.delegate?.manager(self, name: people[indexPath.row].firstName, id: people[indexPath.row].id)

        dismiss(animated: true, completion: nil)

    }

//    func collectionView(_ collectionView: UICollectionView, didSelectRowAtIndexPath indexPath: IndexPath) {
//        if indexPath.item == 0 {
//            let alertController = UIAlertController(title: "Share", message: "No Bookmarks to Share", preferredStyle: .alert)
//            let cancelAction = UIAlertAction(title: "Dismiss", style: .cancel) { (_) in }
//            alertController.addAction(cancelAction)
//            self.present(alertController, animated: true) {}
//            
//            self.dismiss(animated: true, completion: nil)
//        }
//    }

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
