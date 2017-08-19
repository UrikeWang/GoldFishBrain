//
//  CoreDataManager.swift
//  GoldfishBrain
//
//  Created by yuling on 2017/8/11.
//  Copyright © 2017年 yuling. All rights reserved.
//

import Foundation
import CoreData
import UIKit

// swiftlint:disable force_cast
let appDelegate = UIApplication.shared.delegate as! AppDelegate
// swiftlint:enable force_cast

class CoreDataManager {

    let context = appDelegate.persistentContainer.viewContext

    func fetchData() -> [TravelDataMO] {

        var travelDatas = [TravelDataMO]()

        do {

            travelDatas = try context.fetch(TravelDataMO.fetchRequest())

        } catch (let error) {

            print(error)
        }

        return travelDatas

    }

    func addDo(time: String, destination: String, distance: String, duration: String, friend: String) {

        let newTravelData = TravelDataMO(context: context)

        newTravelData.time = time

        newTravelData.destination = destination

        newTravelData.distance = distance

        newTravelData.duration = duration

        newTravelData.friend = friend

        newTravelData.finished = false

        newTravelData.notify = false

        appDelegate.saveContext()

    }

    //將do從coredata中刪除
    func deleteDo(indexPath: Int) {

        let travelDatas = fetchData()

        context.delete(travelDatas[indexPath])

        appDelegate.saveContext()

    }

}
