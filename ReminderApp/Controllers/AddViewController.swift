//
//  AddViewController.swift
//  ReminderApp
//
//  Created by 彭海明 on 2020/7/17.
//  Copyright © 2020 Jacky Peng. All rights reserved.
//

import UIKit
import RealmSwift



class DataManager {
        static let shared = DataManager()
        var work = WorkViewController()
        var life = LifeViewController()
}




class AddViewController: UIViewController, UITextFieldDelegate {
    
    let realm = try! Realm()
    var dateInfo : String?
    var timeInfo : String?
    
    var importance = UIColor(red: 124/255.0, green: 196/255.0, blue: 131/255.0, alpha: 1.0).toHex
    var categoryName = "Work"

    @IBOutlet weak var doneButton: UIBarButtonItem!
    
    @IBOutlet weak var dateField: UITextField!
    @IBOutlet weak var timeField: UITextField!

    let datePicker = UIDatePicker()
    let timePicker = UIDatePicker()
    @IBOutlet weak var titleField: UITextField!
       @IBOutlet weak var depictionTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        createDatePicker()
        createTimePicker()
        configureTextField()
        configureTapGesture()
        titleField.delegate = self
        doneButton.isEnabled = false
        checkFilled()
    }

  
    
    private func configureTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(AddViewController.handleTap))
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc func handleTap() {
        checkFilled()
        
        view.endEditing(true)
        
    }
    
    private func configureTextField() {
        depictionTextView.delegate = self
        depictionTextView.text = "Description Here"
        depictionTextView.textColor = UIColor.lightGray
    }
    
  
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        checkFilled()
    }
    
    
    
    func checkFilled() {
        if dateField.text != "" && timeField.text != "" && titleField.text?.isEmpty == false {
            
            doneButton.isEnabled = true
        }
    }
    
    
    //MARK: - Date and Time TextField

    
    func createDatePicker() {
        
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        let doneBtn = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(doneDatePressed))
        toolBar.setItems([doneBtn], animated: true)
        
//        date pickermode
        datePicker.datePickerMode = .date
//        assign picker to textfield
        dateField.inputView = datePicker
//        assign the toolBar to textfield
        dateField.inputAccessoryView = toolBar
        
    }
    
    func createTimePicker() {
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        let doneBtn = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(doneTimePressed))
        
        toolBar.setItems([doneBtn], animated: true)
        
        timeField.inputView = timePicker
        timeField.inputAccessoryView = toolBar
        timePicker.datePickerMode = .time
        
    }
    
    @objc func doneDatePressed() {
        
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
      
        
        dateField.text = formatter.string(from: datePicker.date)
        dateInfo = dateField.text
        checkFilled()
        self.view.endEditing(true)
    }
    
    
    @objc func doneTimePressed() {
        
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        
        timeField.text = formatter.string(from: timePicker.date)
        timeInfo = timeField.text
        checkFilled()
        self.view.endEditing(true)
        
    }
    
    func resetTime(forDate:NSDate,timedate:NSDate) ->Date {

         let df = DateFormatter()
         df.dateFormat = "dd MMM yyyy"
         var resultdate = Date()
         if let dateFromString = df.date(from: df.string(from: forDate as Date)) {
             
             let hour = NSCalendar.current.component(.hour, from: timedate as Date)
             let minutes = NSCalendar.current.component(.minute, from: timedate as Date)
             if let dateFromStringWithTime = NSCalendar.current.date(bySettingHour: hour, minute: minutes, second: 0, of: dateFromString) {
                 let df = DateFormatter()
                 df.dateFormat = "yyyy-MM-dd HH:mm:ss.SSS'Z"
                 let resultString = df.string(from: dateFromStringWithTime)
                 resultdate = df.date(from: resultString)!
             }
         }
         return resultdate
    }
    
    
    //MARK: - Done and Cancel button for the Page

    
    @IBAction func doneButtonPressed(_ sender: UIBarButtonItem) {
    
//        let belongCateogry = Category()
//        belongCateogry.name = categoryName
        
        
       
        let storeData = Memorandum()
//        let dateFormatter = DateFormatter()
//        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
//        dateFormatter.dateFormat = "MMMM dd, yyyy 'at' h:mm a"
//        if let date = dateInfo, let time = timeInfo {
//            let string = date + " at " + time
//            let finalDate = dateFormatter.date(from: string)
    
        let finalDate = resetTime(forDate: datePicker.date as NSDate, timedate: timePicker.date as NSDate)
            storeData.dateReminder = finalDate
          
//        }
        storeData.title = titleField.text ?? " "
        storeData.depiction = depictionTextView.text ?? " "
        storeData.color = importance ?? "000000"
        storeData.category = categoryName
//        belongCateogry.items.append(storeData)
       
        saveData(with: storeData)
       
        
        DataManager.shared.work.workCollectionView.reloadData()
        if let life = DataManager.shared.life.lifeCollectionView {
            life.reloadData()
        }
        
        self.resignFirstResponder()
        self.dismiss(animated: true, completion: nil)
        
        
        
    }
    
    
    
    @IBAction func cancelButtonPressed(_ sender: UIBarButtonItem) {
        
        self.dismiss(animated: true, completion: nil)
        
    }
    
    //MARK: - Segment Control

    
    @IBAction func importanceDidChange(_ sender: UISegmentedControl) {
        
        let greenColor = UIColor(red: 124/255.0, green: 196/255.0, blue: 131/255.0, alpha: 1.0)
        
        sender.subviews[0].tintColor = greenColor

        switch sender.selectedSegmentIndex {
            case 0:
                sender.selectedSegmentTintColor = greenColor
                importance = greenColor.toHex
                print("0")
            case 1:
                sender.selectedSegmentTintColor = .orange
                importance = UIColor.orange.toHex
                print("1")
            case 2:
                sender.selectedSegmentTintColor = .red
                importance = UIColor.red.toHex
                print("2")
            default:
                sender.selectedSegmentTintColor = greenColor
                importance = UIColor.green.toHex
        }
    }
    
    @IBAction func CategoryDidChange(_ sender: UISegmentedControl) {
        
        switch sender.selectedSegmentIndex{
        case 0 :
            categoryName = "Work"
            
        case 1:
            
            categoryName = "Life"
            
        default:
            categoryName = "Work"
            
        }
       
    }
    
    
    
    //MARK: - save and load Data
    
    func saveData(with data: Object) {
        do{
            try realm.write{
                realm.add(data)
            }
        } catch {
            print("Error while saving storeData")
        }
        
        
    }
    
    
  
    
}

extension AddViewController: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Description Here"
            textView.textColor = UIColor.lightGray
        }
    }
 
}

extension AddViewController {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        checkFilled()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        checkFilled()
        return true
    }
}
        
        


