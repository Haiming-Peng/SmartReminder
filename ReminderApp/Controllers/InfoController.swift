//
//  InfoController.swift
//  ReminderApp
//
//  Created by 彭海明 on 2020/7/18.
//  Copyright © 2020 Jacky Peng. All rights reserved.
//

import UIKit
import RealmSwift

class InfoController: UIViewController {
    
    
    
    let realm = try! Realm()
    
    @IBOutlet weak var importanceColor: UIImageView!
    
    @IBOutlet weak var date: UILabel!
    
    @IBOutlet weak var titleInfo: UILabel!
    
    @IBOutlet weak var descriptionInfo: UITextView!
    
    @IBOutlet weak var navigationBar: UINavigationItem!
    
    var selectedReminder : Memorandum?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        presentInfo()
        navigationBar.title = selectedReminder?.category
    }
    

    
    func presentInfo() {
        
        if let safeReminder = selectedReminder {
            importanceColor.layer.cornerRadius = importanceColor.bounds.height/2
            importanceColor.backgroundColor = UIColor(hex: safeReminder.color)
            
            let df = DateFormatter()
            df.dateStyle = .medium
            df.timeStyle = .short
            date.text = df.string(from: safeReminder.dateReminder)
            titleInfo.text = safeReminder.title
            if safeReminder.depiction == "" {
                descriptionInfo.text = "No Description"
            } else {
                descriptionInfo.text = safeReminder.depiction
            }
            
        } else {
            print("found nil when unwrap info")
        }
         
        
    
        
    }
    
    @IBAction func backToReminder(_ sender: Any) {
        do {
            try realm.write{
                selectedReminder?.depiction = descriptionInfo.text
            }
        } catch {
            print("error while saving.")
        }
        
        DataManager.shared.life.lifeCollectionView.reloadData()
           DataManager.shared.work.workCollectionView.reloadData()
        self.resignFirstResponder()
        self.dismiss(animated: true, completion: nil)
    }
    
    
    

}

extension InfoController: UITextViewDelegate {
    
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
