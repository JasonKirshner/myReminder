//
//  RemindersTableVC.swift
//  MyReminder
//
//  Created by Jason Kirshner on 12/14/17.
//  Copyright © 2017 Jason Kirshner. All rights reserved.
//

import UIKit

class RemindersTableVC: UITableViewController {
    var taskItems = [[String]]()
    var taskName: [String] = []
    var taskDate: [String] = []
    var taskTime: [String] = []
    var cells: [UITableViewCell] = []
    var longGesture = UILongPressGestureRecognizer()
    var flag = false
    var reminders: UserDefaults?

    @IBOutlet weak var cancel: UIBarButtonItem!

    @IBAction func cancel(_ sender: Any) {
        flag = false
        cancel.isEnabled = false
        delete.isEnabled = false
        for c in cells {
            if c.accessoryType == UITableViewCellAccessoryType.checkmark {
                c.accessoryType = UITableViewCellAccessoryType.none
            }
        }
    }
    
    @IBAction func deleteReminders(_ sender: Any) {
        for (i, c) in cells.enumerated().reversed() {
            if c.accessoryType == UITableViewCellAccessoryType.checkmark {
                print(i)
                print(cells.count)
                cells.remove(at: i)
                taskName.remove(at: i)
                taskDate.remove(at: i)
                taskTime.remove(at: i)
                taskItems.remove(at: i)
                c.removeFromSuperview()
            }
        }
        flag = false
        cancel.isEnabled = false
        delete.isEnabled = false
        tableView.reloadData()
    }
    
    @IBOutlet weak var delete: UIBarButtonItem!
    @IBOutlet var remindersTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        longGesture = UILongPressGestureRecognizer(target: self, action: #selector(longPress))
        longGesture.minimumPressDuration = 1
        remindersTableView.addGestureRecognizer(longGesture)
        reminders = UserDefaults.init(suiteName: "reminders")!
//        if !(reminders?.array(forKey: "taskNames")?.isEmpty)! {
//            taskItems = reminders?.array(forKey: "taskItems") as! [[String]]
//            taskName = reminders?.array(forKey: "taskNames") as! [String]
//            taskTime = reminders?.array(forKey: "taskTimes") as! [String]
//            taskDate = reminders?.array(forKey: "taskDates") as! [String]
//        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        tableView.reloadData()
        reminders?.set(taskItems, forKey: "taskItems")
        reminders?.set(taskName, forKey: "taskNames")
        reminders?.set(taskDate, forKey: "taskDates")
        reminders?.set(taskItems, forKey: "taskItems")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return taskName.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reminderCell", for: indexPath)
        cell.textLabel?.text = taskName[indexPath.row]
        cell.detailTextLabel?.text = taskDate[indexPath.row] + " " + taskTime[indexPath.row]
        cell.accessoryType = .disclosureIndicator
        if !cells.contains(cell) {
            cells.append(cell)
        }
        print("here\(cells.count)")
        return cell
    }
    
    @objc func longPress(sender: UILongPressGestureRecognizer) {
        cancel.isEnabled = true
        delete.isEnabled = true
        flag = true
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if flag == false {
            performSegue(withIdentifier: "reminderTasksSegue", sender: self)
        } else {
            if tableView.cellForRow(at: indexPath)?.accessoryType == UITableViewCellAccessoryType.checkmark {
                tableView.cellForRow(at: indexPath)?.accessoryType = UITableViewCellAccessoryType.none
            } else {
                tableView.cellForRow(at: indexPath)?.accessoryType = UITableViewCellAccessoryType.checkmark
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "reminderTasksSegue", let destination = segue.destination as? ReminderTasksTableVC, let index = tableView.indexPathForSelectedRow?.row {
            destination.taskName = taskName[index]
            destination.taskItems = taskItems[index]
        }
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
