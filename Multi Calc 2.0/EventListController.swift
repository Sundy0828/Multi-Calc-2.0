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
        if let tabController = self.parent as? UITabBarController {
            tabController.navigationItem.title = "Events"
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        if let tabController = self.parent as? UITabBarController {
            tabController.navigationItem.title = "Events"
        }
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let edit = editAction(at: indexPath)
        let delete = deleteAction(at: indexPath)
        return UISwipeActionsConfiguration(actions: [delete, edit])
    }
    func editAction(at indexPath: IndexPath) -> UIContextualAction {
        let action = UIContextualAction(style: .destructive, title: "Edit") { (action, view, completion) in
            
        }
        action.backgroundColor = UIColor.darkGray
        
        return action
    }
    func deleteAction(at indexPath: IndexPath) -> UIContextualAction {
        let action = UIContextualAction(style: .destructive, title: "Delete") { (action, view, completion) in
            GlobalVariable.athletesArray[GlobalVariable.athletesIndex].events.remove(at: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
            completion(true)
        }
        action.backgroundColor = UIColor.red
        
        return action
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return athleteEvents.events.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "eventListCell") as? CustomEventCell
        
        cell?.title.text = athleteEvents.events[indexPath.row].name
        cell?.subtitle.text = athleteEvents.events[indexPath.row].eventType
        cell?.arrowImage.image = #imageLiteral(resourceName: "blackArrow")
        
        return cell!
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "showDetails", sender: self)
    }
}
