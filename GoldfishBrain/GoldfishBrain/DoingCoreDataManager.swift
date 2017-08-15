//
//  DoingCoreDataManager.swift
//  GoldfishBrain
//
//  Created by yuling on 2017/8/15.
//  Copyright © 2017年 yuling. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class DoingCoreDataManager {

    let context = appDelegate.persistentContainer.viewContext

    func fetchDoingData() -> [DoingTravelDataMO] {

        var doingTravelDatas = [DoingTravelDataMO]()

        do {

            doingTravelDatas = try context.fetch(DoingTravelDataMO.fetchRequest())

        } catch (let error) {

            print(error)
        }

        return doingTravelDatas

    }

    func addDoingDo(time: String, destination: String, distance: String, duration: String, friend: String) {

        let newTravelData = DoingTravelDataMO(context: context)

        newTravelData.time = time

        newTravelData.destination = destination

        newTravelData.distance = distance

        newTravelData.duration = duration

        newTravelData.friend = friend

        newTravelData.finished = false

        newTravelData.notify = false

        appDelegate.saveContext()

    }

    func deleteDoingDo(indexPath: Int) {

        let doingTravelDatas = fetchDoingData()

        context.delete(doingTravelDatas[indexPath])

        appDelegate.saveContext()

    }

}
