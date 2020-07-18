//
//  WorkViewController.swift
//  ReminderApp
//
//  Created by 彭海明 on 2020/7/17.
//  Copyright © 2020 Jacky Peng. All rights reserved.
//


import Foundation
import UIKit
import RealmSwift


extension WorkViewController: ReminderCellDelegate {
    func delete(cell: ReminderCell) {
        if let indexPath = workCollectionView.indexPath(for: cell) {
            do {
                try realm.write {
                    realm.delete(reminders[indexPath.item])
                }
            }catch {
                print("Error while deleting cells")
            }
            
            workCollectionView.deleteItems(at: [indexPath])
        }
       }
}

class WorkViewController: UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UICollectionViewDelegate{
    
    let realm = try! Realm()
    
    var reminders : Results<Memorandum>!
    @IBOutlet weak var workCollectionView: UICollectionView!
    @IBOutlet weak var searchbar: UISearchBar!
    
    var editStatus = false
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.fetchData()
        
        DataManager.shared.work = self
        
        workCollectionView.delegate = self
        
        workCollectionView.dataSource = self
        
        searchbar.delegate = self 

        // Do any additional setup after loading the view.
    }
   
    
    @IBAction func trashButtonTapped(_ sender: Any) {
        editStatus = !editStatus
        workCollectionView.reloadData()
    }
    
    
  

    
    func fetchData() {
        
        let predicate = NSPredicate(format: "category == 'Work'")
        self.reminders = realm.objects(Memorandum.self).filter(predicate).sorted(byKeyPath: "dateReminder",ascending: true)
        
        self.workCollectionView.reloadData()
       
    }
    
}

//MARK: - CollectionVIew


extension WorkViewController  {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
              return reminders.count
          }
          
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

              
              let cell = workCollectionView.dequeueReusableCell(withReuseIdentifier: "workCell", for: indexPath) as! ReminderCell
              let reminder = reminders[indexPath.item]
              cell.configureCell(date:reminder.dateReminder , importance: UIColor(hex: reminder.color)!, name: reminder.title, depict: reminder.depiction)
              
              cell.layer.cornerRadius = 12
        cell.isEditing = editStatus
        cell.delegate = self

              return cell

              
          }
      //
          func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
              return CGSize(width: workCollectionView.frame.width / 2.1, height: workCollectionView.frame.width / 2.1 )
          }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
            performSegue(withIdentifier: "workInfo", sender: self)
             print("happy")
         }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "workInfo" {
            let destinationVC = segue.destination as! InfoController
            if let indexPath = workCollectionView.indexPathsForSelectedItems?[0]{
                destinationVC.selectedReminder = reminders[indexPath.item]
            }
        } else {
            print("nothing for segue")
        }
           
           
       }
         
     
}



//MARK: - searchBar methods



extension WorkViewController: UISearchBarDelegate {
    
      func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
         
         
        self.reminders = reminders.filter("title CONTAINS[cd] %@ AND category == 'Work'", self.searchbar.text!).sorted(byKeyPath: "dateReminder", ascending: true)
         
         self.workCollectionView.reloadData()
         DispatchQueue.main.async{
            self.searchbar.resignFirstResponder()
         }
     }
     
     func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
         
        if self.searchbar.text?.count == 0 {
             fetchData()
             DispatchQueue.main.async{
                self.searchbar.resignFirstResponder()
             }
         } else {
            self.reminders = realm.objects(Memorandum.self).filter("title CONTAINS[cd] %@ AND category == 'Work'", searchText).sorted(byKeyPath: "dateReminder", ascending: true)
            self.workCollectionView.reloadData()
        }
        
         
     }
}

