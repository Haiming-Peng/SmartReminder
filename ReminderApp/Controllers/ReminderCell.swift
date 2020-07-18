//
//  ReminderCell.swift
//  ReminderApp
//
//  Created by 彭海明 on 2020/7/17.
//  Copyright © 2020 Jacky Peng. All rights reserved.
//

import Foundation
import UIKit


protocol ReminderCellDelegate: class {
    func delete(cell: ReminderCell)
}


class ReminderCell: UICollectionViewCell {
  
    @IBOutlet weak var dateReminder: UILabel!
    
    @IBOutlet weak var importanceLevel: UIImageView!
    
    @IBOutlet weak var title: UILabel!
    
    @IBOutlet weak var depiction: UILabel!
    

    @IBOutlet weak var deleteButtonBG: UIVisualEffectView!
    
    
    weak var delegate: ReminderCellDelegate?
    
    
    
    var isEditing: Bool = false {
        didSet{
            deleteButtonBG.isHidden = !isEditing
        }
    }
    

    
    func configureCell(date: Date, importance: UIColor, name: String, depict: String) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        
        dateReminder.text = timeReminder(recordDate: date)
        importanceLevel.backgroundColor = importance
        importanceLevel.layer.cornerRadius = importanceLevel.frame.height/2
        title.text = name
        depiction.text = depict
        configureDeleteButton()
        
    }
    
    func configureDeleteButton() {
        deleteButtonBG.layer.cornerRadius = deleteButtonBG.bounds.height/2
        deleteButtonBG.layer.masksToBounds = true
        deleteButtonBG.isHidden = !isEditing


    }

    

    @IBAction func deleteButtonTapped(_ sender: Any) {
//               DataManager.shared.delegate?.deleteCell(cell: self)
               print("tapped")
        delegate?.delete(cell: self)
    }
    
    
    
    
    func timeReminder(recordDate: Date) -> String {
        
              let min = 60
              let hr = 60 * min
              let day = 24 * hr
              let week = 7 * day
              let mon = 30*day
              let yr = 365 * day

        
        let interval = Int(recordDate.timeIntervalSinceNow)
        
        switch interval {
        case 0..<2*min :
            return "1 minute"
        case 2*min..<3*min :
            return "2 minute"
        case 3*min..<4*min :
            return "3 minute"
        case 4*min..<5*min :
            return "4 minute"
        case 5*min..<6*min :
            return "5 minute"
        case 6*min..<7*min :
            return "6 minute"
        case 7*min..<8*min :
            return "7 minute"
        case 8*min..<9*min :
            return "8 minute"
        case 9*min..<10*min :
            return "9 minute"
        case 10*min ..< 15*min :
            return "10 minute"
        case 15*min..<20*min :
            return "15 minute"
        case 20*min ..< 30*min :
            return "25 minute"
        case 30*min ..< 40*min :
            return "35 minute"
        case 40*min ..< 50*min :
            return "45 minute"
        case 50*min ..< 60*min :
            return "55 minute"
        case hr ..< 2*hr :
            return "1 hour"
        case 2*hr ..< 3*hr :
            return "2 hour"
        case 3*hr ..< 4*hr :
            return "3 hour"
        case 4*hr ..< 5*hr :
            return "4 hour"
        case 5*hr ..< 6*hr :
            return "5 hour"
        case 6*hr ..< 7*hr :
            return "6 hour"
        case 7*hr ..< 8*hr :
            return "7 hour"
        case 8*hr ..< 9*hr :
            return "8 hour"
        case 9*hr ..< 10*hr :
            return "9 hour"
        case 10*hr ..< 11*hr :
            return "10 hour"
        case 11*hr ..< 12*hr :
            return "11 hour"
        case 12*hr ..< day:
            return "half day"
        case day ..< 2*day :
            return "tomorrow"
        case 2*day ..< 3*day :
            return "2 day"
        case 3*day ..< 4*day :
            return "3 day"
        case 4*day ..< 5*day :
            return "4 day"
        case 5*day ..< 6*day :
            return "5 day "
        case 6*day ..< week :
            return "6 day "
        case week ..< 2*week :
            return "next week"
        case 2*week ..< 3*week :
            return "2 week"
        case 3*week ..< 4*week :
            return "3 week"
        case 4*week ..< 30*day :
            return "4 week"
        case mon ..< 2*mon:
            return "next month"
        case 2*mon ..< 3*mon:
            return "2 month"
        case 3*mon ..< 4*mon:
            return "3 month"
        case 4*mon ..< 5*mon:
            return "4 month"
        case 5*mon ..< 6*mon:
            return "5 month"
        case 6*mon ..< 7*mon:
            return "6 month"
        case 7*mon ..< 8*mon:
            return "7 month"
        case 8*mon ..< 9*mon:
            return "8 month"
        case 9*mon ..< 10*mon:
            return "9 month"
        case 10*mon ..< 11*mon:
            return "10 month"
        case 11*mon ..< yr:
            return "11 month"
        case 1*yr ..< 2*yr:
            return "1 year"
        case 2*yr ..< 3*yr:
            return "2 year"
        case 3*yr ..< 4*yr:
            return "3 year"
        case 4*yr ..< 5*yr:
            return "4 year"
        case 5*yr ..< 10*yr:
            return ">=5 year"
        default:
            return "already past"
        }
    }
    
}
