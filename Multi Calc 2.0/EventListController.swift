//
//  EventListController.swift
//  Multi Calc 2.0
//
//  Created by Jerrod on 3/21/18.
//  Copyright © 2018 Jerrod Sunderland. All rights reserved.
//

import UIKit

class EventListController: UITableViewController {
    let athleteEvents = GlobalVariable.athletesArray[GlobalVariable.athletesIndex]
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
        // set title
        self.title = "\(athleteEvents.fName)'s Events"
        tableView.backgroundColor = GlobalVariable.backgroundColor
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // set table view and title
        tableView.delegate = self
        tableView.dataSource = self
    }
    // swipe guestures for table view
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let edit = editAction(at: indexPath)
        let delete = deleteAction(at: indexPath)
        return UISwipeActionsConfiguration(actions: [delete, edit])
    }
    // edit selection
    func editAction(at indexPath: IndexPath) -> UIContextualAction {
        let action = UIContextualAction(style: .destructive, title: "Edit") { (action, view, completion) in
            GlobalVariable.eventsIndex = indexPath.row
            self.performSegue(withIdentifier: "editEvent", sender: self)
        }
        action.backgroundColor = UIColor.darkGray
        
        return action
    }
    // delete section
    func deleteAction(at indexPath: IndexPath) -> UIContextualAction {
        let action = UIContextualAction(style: .destructive, title: "Delete") { (action, view, completion) in
            // Declare Alert
            let dialogMessage = UIAlertController(title: "Reset", message: "Are you sure you want to reset the settings?", preferredStyle: .alert)
            
            // Create OK button with action handler
            let ok = UIAlertAction(title: "Yes", style: .default, handler: { (action) -> Void in
                for i in 0...GlobalVariable.athletesArray.count - 1 {
                    GlobalVariable.athletesArray[i].deleteAthlete(id: i)
                }
                // remove from table and array
                GlobalVariable.athletesArray[GlobalVariable.athletesIndex].events.remove(at: indexPath.row)
                self.tableView.deleteRows(at: [indexPath], with: .automatic)
                // save athletes and tot number of athletes
                UserDefaults.standard.set(GlobalVariable.athletesArray.count - 1, forKey: "totAthletes")
                for i in 0...GlobalVariable.athletesArray.count - 1 {
                    GlobalVariable.athletesArray[i].saveAthlete(id: i)
                }
                completion(true)
            })
            
            // Create Cancel button with action handlder
            let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (action) -> Void in
                // event if canceled
            }
            
            //Add OK and Cancel button to dialog message
            dialogMessage.addAction(ok)
            dialogMessage.addAction(cancel)
            
            // Present dialog message to user
            self.present(dialogMessage, animated: true, completion: nil)
        }
        action.backgroundColor = UIColor.red
        
        return action
    }
    // set table length
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return athleteEvents.events.count
    }
    // set table rows
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "eventListCell") as? CustomEventCell
        cell?.backgroundColor = GlobalVariable.backgroundColor
        cell?.title.textColor = GlobalVariable.textColor
        // put in name and array
        cell?.title.text = athleteEvents.events[indexPath.row].name
        cell?.subtitle.text = athleteEvents.events[indexPath.row].eventType
        cell?.arrowImage.image = #imageLiteral(resourceName: "blackArrow")
        if GlobalVariable.theme == "dark" {
            cell?.arrowImage.image = #imageLiteral(resourceName: "whiteArrow")
        }
        
        return cell!
    }
    // preform segue to next controller if clicked
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        GlobalVariable.eventsIndex = indexPath.row
        performSegue(withIdentifier: "showDetails", sender: self)
    }
}
