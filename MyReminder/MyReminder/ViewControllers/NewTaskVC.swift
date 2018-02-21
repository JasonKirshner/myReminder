//
//  NewTaskVC.swift
//  MyReminder
//
//  Created by Jason Kirshner on 12/14/17.
//  Copyright © 2017 Jason Kirshner. All rights reserved.
//

import UIKit
import UserNotifications

class NewTaskVC: UIViewController, UITextFieldDelegate {
    var itemCount: Int? = 0
    var textfields:[UITextField] = []
    var textFieldStrings: [String] = []
    var button: UIButton?
    
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var taskName: UITextField!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var height: NSLayoutConstraint!
    @IBOutlet weak var containerHeight: NSLayoutConstraint!
    @IBOutlet weak var itemCountTF: UITextField!
    @IBAction func createItems(_ sender: Any) {
        if itemCountTF.text != "" {
            self.generateTask()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if textfields.count > 0 {
            for t in textfields {
                t.removeFromSuperview()
            }
            button?.removeFromSuperview()
            if taskName.text != "" {
                taskName.text = ""
            }
            itemCountTF.text = ""
            height.constant = 231
        }
        //containerView.alignmentRect(forFrame: CGRect(x: 0, y: 0, width: containerView.bounds.width, height: containerView.bounds.height))
        //containerView.layoutIfNeeded()
        //scrollView.layoutIfNeeded()
    }
    
    @objc func registerLocal() {
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .badge, .sound]) { (granted, error) in
            if granted {
                self.scheduleLocal()
            }
        }
    }
    
    @objc func createTask(sender: UIButton) {
        for t in textfields {
            textFieldStrings.append(t.text!)
        }
        let navVC = tabBarController?.viewControllers![0] as! UINavigationController
        let remindersTable = navVC.viewControllers[0] as! RemindersTableVC
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = DateFormatter.Style.short
        remindersTable.taskDate.append(dateFormatter.string(from: datePicker.date))
        let timeFormatter = DateFormatter()
        timeFormatter.timeStyle = DateFormatter.Style.short
        remindersTable.taskTime.append(timeFormatter.string(from: datePicker.date))
        remindersTable.taskItems.append(self.textFieldStrings)
        remindersTable.taskName.append(self.taskName.text!)
        self.registerLocal()
        for t in textfields {
            t.removeFromSuperview()
        }
        textfields.removeAll()
        textFieldStrings.removeAll()
        button?.removeFromSuperview()
        taskName.text = ""
        itemCountTF.text = ""
        height.constant = 231
        self.tabBarController?.selectedIndex = 0
    }
    
    @objc func scheduleLocal() {
        DispatchQueue.main.async {
            let content = UNMutableNotificationContent()
            content.title = NSString.localizedUserNotificationString(forKey:
                self.taskName.text!, arguments: nil)
            content.body = NSString.localizedUserNotificationString(forKey:
                "You have a task!", arguments: nil)
            
            // Deliver the notification in five seconds.
            content.sound = UNNotificationSound.default()
            var dateComponents = DateComponents()
            //self.datePicker.datePickerMode = .time
            let components = Calendar.current.dateComponents([.hour, .minute], from: self.datePicker.date)
            let hour = components.hour!
            let minute = components.minute!
            dateComponents.hour = hour
            dateComponents.minute = minute
            let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
            
            // Schedule the notification.
            let request = UNNotificationRequest(identifier: "FiveSecond", content: content, trigger: trigger)
            let center = UNUserNotificationCenter.current()
            center.add(request, withCompletionHandler: nil)
        }
    }
    
    func generateTask() {
        itemCountTF.resignFirstResponder()
        var y: Int = 400
        itemCount = Int(itemCountTF.text!)
        if itemCount! <= 10 {
            height.constant += CGFloat(itemCount! * 45)
            self.scrollView.layoutIfNeeded()
            for _ in 1...itemCount! {
                let textField = UITextField(frame: CGRect(x: 20, y: y, width: 300, height: 50))
                textField.placeholder = "Enter Task Item Here"
                textField.font = UIFont.systemFont(ofSize: 15)
                textField.borderStyle = UITextBorderStyle.roundedRect
                textField.autocorrectionType = UITextAutocorrectionType.no
                textField.keyboardType = UIKeyboardType.default
                textField.returnKeyType = UIReturnKeyType.done
                textField.clearButtonMode = UITextFieldViewMode.whileEditing;
                textField.contentVerticalAlignment = UIControlContentVerticalAlignment.center
                textField.delegate = self
                self.textfields.append(textField)
                self.scrollView.addSubview(textField)
                y = y + 55
            }
            button = UIButton(type: .system)
            let x: CGFloat = UIScreen.main.bounds.midX
            button?.frame = CGRect(x: 150, y: y+40, width: 100, height: 100)
            button?.center = CGPoint(x: x, y: CGFloat(y+55))
            button?.setTitle("Create Task", for: .normal)
            button?.addTarget(self, action: #selector(createTask), for: .touchUpInside)
            self.scrollView.addSubview(button!)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.taskName.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.containerView.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        taskName.resignFirstResponder()
        for t in textfields {
            t.resignFirstResponder()
        }
        return true
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
