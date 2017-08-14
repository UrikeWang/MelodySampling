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

    var fetchQuestionResultController: NSFetchedResultsController<QuestionMO>!

    var fetchResultsResultController: NSFetchedResultsController<ResultMO>!

    var questions: [QuestionMO] = []

    var results: [ResultMO] = []

    func clearQuestionMO() {

        let fetchRequest: NSFetchRequest<QuestionMO> = QuestionMO.fetchRequest()

        let sortDescriptor = NSSortDescriptor(key: "artistID", ascending: true)

        fetchRequest.sortDescriptors = [sortDescriptor]

        if let appDelegate = (UIApplication.shared.delegate as? AppDelegate) {

            let context = appDelegate.persistentContainer.viewContext

            fetchQuestionResultController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)

            fetchQuestionResultController.delegate = self

            do {

                try fetchQuestionResultController.performFetch()

                if let fetchedObjects = fetchQuestionResultController.fetchedObjects {

                    questions = fetchedObjects

                    if questions.count > 0 {

                        for question in questions {

                            context.delete(question)

                            appDelegate.saveContext()

                        }
                        print("Clean exist questions in CoreData")
                    }

                }

            } catch {
                print(error)
            }
        }

    }

    func clearResultMO() {

        let fetchRequest: NSFetchRequest<ResultMO> = ResultMO.fetchRequest()

        let sortDescriptor = NSSortDescriptor(key: "index", ascending: true)

        fetchRequest.sortDescriptors = [sortDescriptor]

        if let appDelegate = (UIApplication.shared.delegate as? AppDelegate) {

            let context = appDelegate.persistentContainer.viewContext

            fetchResultsResultController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)

            fetchResultsResultController.delegate = self

            do {

                try fetchResultsResultController.performFetch()

                if let fetchedObjects = fetchResultsResultController.fetchedObjects {

                    results = fetchedObjects

                    if results.count > 0 {

                        for result in results {

                            context.delete(result)

                            appDelegate.saveContext()

                        }
                        print("Clean exist results in CoreData")
                    }

                }

            } catch {
                print(error)
            }
        }

    }

}
