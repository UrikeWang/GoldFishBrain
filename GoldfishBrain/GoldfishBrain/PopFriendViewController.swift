//
//  popFriendViewController.swift
//  GoldfishBrain
//
//  Created by yuling on 2017/8/7.
//  Copyright © 2017年 yuling. All rights reserved.
//

import UIKit

class PopFriendViewController: UIViewController, chatRoomManagerDelegate, UICollectionViewDelegate, UICollectionViewDataSource {

    @IBOutlet weak var friendCollectionView: UICollectionView!

    let chatRoomManager = ChatRoomManager()

    var people = [Person]()

    let sectionInsets = UIEdgeInsets(top: 30.0, left: 20.0, bottom: 30.0, right: 20.0)

    func chatRoomManager(_ manager: ChatRoomManager, didGetPeople people: [Person]) {

        self.people = people

        DispatchQueue.main.async {

            self.friendCollectionView.reloadData()
        }

    }

    func chatRoomManager(_ manager: ChatRoomManager, didFailWith error: Error) {

    }

    override func viewDidLoad() {
        super.viewDidLoad()

        friendCollectionView.delegate = self

        // Do any additional setup after loading the view.
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return people.count

        return 6
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {

        return sectionInsets

    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        let paddingSpace = sectionInsets.left * 4
        let availableWidth = 300 - paddingSpace
        let widthPerItem = availableWidth / 3

        return CGSize(width: widthPerItem, height: widthPerItem)
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        //swiftlint:disable force_cast
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PopFriendCell", for: indexPath) as! PopFriendCollectionViewCell
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
