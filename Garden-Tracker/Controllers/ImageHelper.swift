////
////  ImageHelper.swift
////  Garden-Tracker
////
////  Created by Hallie Johnson on 1/14/20.
////  Copyright © 2020 Hallie Johnson. All rights reserved.
////
//
//import UIKit
//import CoreData
//
//class ImageHelper {
//
//    static let shareInstance = SaveImageHelper()
//    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
//
//    func saveImage(data: Data) {
//        let imageInstance = Plant(context: context)
//    }
//
//
//    func fetchImage() -> [Plant] {
//        var fetchingImage = [Plant]()
//        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Plant")
//
//        do {
//            fetchingImage = try context.fetch(fetchRequest) as! [Image]
//        } catch {
//            print("Error while fetching the image")
//        }
//
//        return fetchingImage
//    }
//}
