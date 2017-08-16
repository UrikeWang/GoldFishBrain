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

    //將doingDo搬到do coredata中
    func deleteDoingDo(indexPath: Int) {

        let doingTravelDatas = fetchDoingData()

        let coreDataManager = CoreDataManager()

        let data = TravelDataMO(context: context)

        data.destination = doingTravelDatas[indexPath].destination

        data.distance = doingTravelDatas[indexPath].distance

        data.duration = doingTravelDatas[indexPath].duration

        data.finished = false

        data.friend = doingTravelDatas[indexPath].friend

        data.notify = false

        data.time = doingTravelDatas[indexPath].time

        context.delete(doingTravelDatas[indexPath])

        appDelegate.saveContext()

    }

    func updateDoingDo() {

        let doingTravelDatas = fetchDoingData()

        let doingCounts = doingTravelDatas.count

        doingTravelDatas[doingCounts - 1].finished = true

        doingTravelDatas[doingCounts - 1].notify = true

        appDelegate.saveContext()

    }

}
