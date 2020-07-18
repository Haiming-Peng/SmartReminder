//
//  LifeViewController.swift
//  ReminderApp
//
//  Created by 彭海明 on 2020/7/17.
//  Copyright © 2020 Jacky Peng. All rights reserved.
//

import Foundation
import UIKit
import RealmSwift

extension LifeViewController: ReminderCellDelegate {
      func delete(cell: ReminderCell) {
          if let indexPath = lifeCollectionView.indexPath(for: cell) {
              do {
                  try realm.write {
                      realm.delete(reminders[indexPath.item])
                  }
              }catch {
                  print("Error while deleting cells")
              }
              
              lifeCollectionView.deleteItems(at: [indexPath])
          }
         }
}


class LifeViewController: UIViewController {
    
    let realm = try! Realm()
    
    var reminders : Results<Memorandum>!

    @IBOutlet weak var lifeCollectionView: UICollectionView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var editStatus = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
     
        
        self.fetchData()
        
        DataManager.shared.life = self
        
        lifeCollectionView.delegate = self
        
        lifeCollectionView.dataSource = self
        
        searchBar.delegate = self
       
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
//        self.fetchData()
    }

   
    
    @IBAction func trashButtonTapped(_ sender: Any) {
        editStatus = !editStatus
        lifeCollectionView.reloadData()
    }
    
    
    func fetchData() {
        
        self.reminders = realm.objects(Memorandum.self).filter("category CONTAINS 'Life'").sorted(byKeyPath: "dateReminder", ascending: true)

        self.lifeCollectionView.reloadData()
        
        
    }
    
   
    
}



//MARK: - CollectionView


extension LifeViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate {
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
         return CGSize(width: lifeCollectionView.frame.width/2.1, height: lifeCollectionView.frame.width/2.1)
     }
     

     
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
         return reminders.count
        
     }
     
     func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
         
         let reminder = reminders[indexPath.item]
         
         let lifeCell = lifeCollectionView.dequeueReusableCell(withReuseIdentifier: "lifeCell", for: indexPath) as! ReminderCell
         
         lifeCell.configureCell(date: reminder.dateReminder, importance: UIColor(hex: reminder.color)!, name: reminder.title, depict: reminder.depiction)
             
        lifeCell.isEditing = editStatus
        lifeCell.delegate = self
         lifeCell.layer.cornerRadius = 12
         
         return lifeCell
         
     }
    
     func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
           performSegue(withIdentifier: "lifeInfo", sender: self)
                print("happy")
    }
       
       override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
              let destinationVC = segue.destination as! InfoController
              
              if let indexPath = lifeCollectionView.indexPathsForSelectedItems?[0]{
                  destinationVC.selectedReminder = reminders[indexPath.item]
              }
          }
    
}


//MARK: - searchBar Method

extension LifeViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        
        self.reminders = reminders.filter("title CONTAINS[cd] %@ AND category == 'Life'", self.searchBar.text!).sorted(byKeyPath: "dateReminder", ascending: true)
        
        self.lifeCollectionView.reloadData()
        DispatchQueue.main.async{
            self.searchBar.resignFirstResponder()
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if self.searchBar.text?.count == 0 {
            fetchData()
            DispatchQueue.main.async{
                self.searchBar.resignFirstResponder()
            }
        } else {
            
            self.reminders = realm.objects(Memorandum.self).filter("title CONTAINS[cd] %@ AND category == 'Life'", searchText).sorted(byKeyPath: "dateReminder", ascending: true)
                self.lifeCollectionView.reloadData()
            
        }
        
    }
}
