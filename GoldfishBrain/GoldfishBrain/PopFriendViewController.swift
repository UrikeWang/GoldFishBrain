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

    @IBOutlet weak var noFriendImageView: UIImageView!

    let chatRoomManager = ChatRoomManager()

    var people = [Person]()

    weak var delegate: managerFriendDelegate?

    let sectionInsets = UIEdgeInsets(top: 30.0, left: 20.0, bottom: 30.0, right: 20.0)

    @IBAction func cancelSelectFriendButton(_ sender: Any) {

        dismiss(animated: true, completion: nil)
    }

    func chatRoomManager(_ manager: ChatRoomManager, didGetPeople people: [Person]) {

        self.people = people

        if self.people.count == 0 {

            noFriendImageView.isHidden = false
        }

        DispatchQueue.main.async {

            self.friendCollectionView.reloadData()
        }

    }

    func chatRoomManager(_ manager: ChatRoomManager, didGetFriend friend: Person) {

    }

    func chatRoomManager(_ manager: ChatRoomManager, didFailWith error: String) {

       print("chatRome error occured : \(error)")

    }

    override func viewDidLoad() {
        super.viewDidLoad()

        chatRoomManager.delegate = self

        chatRoomManager.fetchFriendIDs()

        cancelSelectFriendButton.setTitle("取消", for: .normal)
        cancelSelectFriendButton.setTitleColor(UIColor.white, for: .normal)
        cancelSelectFriendButton.layer.borderWidth = 2
        cancelSelectFriendButton.backgroundColor = UIColor.goldfishRed
        cancelSelectFriendButton.layer.borderColor = UIColor.goldfishRed.cgColor
        cancelSelectFriendButton.layer.cornerRadius = cancelSelectFriendButton.frame.height/2
        cancelSelectFriendButton.dropShadow()

        noFriendImageView.isHidden = true

    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

        if people.count > 0 {

            noFriendImageView.isHidden = true

        }
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

        cell.friendPhoto.sd_setImage(with: url, placeholderImage: UIImage(named: "icon-placeholder"))

        cell.friendPhoto.contentMode = .scaleAspectFill

        cell.friendPhoto.tag = indexPath.row

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        self.delegate?.manager(self, name: people[indexPath.row].firstName, id: people[indexPath.row].id)

        dismiss(animated: true, completion: nil)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
