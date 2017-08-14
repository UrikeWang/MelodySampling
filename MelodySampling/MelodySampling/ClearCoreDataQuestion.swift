//
//  ClearCoreDataQuestion.swift
//  MelodySampling
//
//  Created by moon on 2017/8/14.
//  Copyright © 2017年 Marvin Lin. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class CheckQuestionInCoreData: UIViewController, NSFetchedResultsControllerDelegate {

    var fetchResultController: NSFetchedResultsController<QuestionMO>!

    var questions: [QuestionMO] = []

    func clear() {

        let fetchRequest: NSFetchRequest<QuestionMO> = QuestionMO.fetchRequest()

        let sortDescriptor = NSSortDescriptor(key: "artistID", ascending: true)

        fetchRequest.sortDescriptors = [sortDescriptor]

        if let appDelegate = (UIApplication.shared.delegate as? AppDelegate) {

            let context = appDelegate.persistentContainer.viewContext

            fetchResultController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)

            fetchResultController.delegate = self

            do {

                try fetchResultController.performFetch()

                if let fetchedObjects = fetchResultController.fetchedObjects {

                    questions = fetchedObjects

                    if questions.count > 0 {

                        for question in questions {

                            context.delete(question)

                            appDelegate.saveContext()

                        }
                        print("Clean exist question in CoreData")
                    }

                }

            } catch {
                print(error)
            }
        }

    }

}
