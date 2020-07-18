//
//  TapBarController.swift
//  ReminderApp
//
//  Created by 彭海明 on 2020/7/17.
//  Copyright © 2020 Jacky Peng. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController, UITabBarControllerDelegate {
    
    
    var collectionView : UICollectionView!
   
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
        setupMiddleButton()
        
    }
    
    func configureCollectionView() {
        print("configure collecitonview")
    }

    func setupMiddleButton() {
        
        let tabBarHeight = tabBar.frame.size.height
        
       
        let menuButton = UIButton(frame: CGRect(x: 0, y: 0, width: tabBarHeight*1.5, height: tabBarHeight*1.5))
        var menuButtonFrame = menuButton.frame
        
        menuButtonFrame.origin.y = view.bounds.height - menuButtonFrame.height/2 - tabBarHeight - 8

        menuButtonFrame.origin.x = view.bounds.width/2 - menuButtonFrame.size.width/2
        menuButton.frame = menuButtonFrame
        
        menuButton.backgroundColor = UIColor.red
        menuButton.layer.cornerRadius = menuButtonFrame.height/2
        view.addSubview(menuButton)
        
        let largeConfiguration = UIImage.SymbolConfiguration(scale: .large)
        let addIcon = UIImage(systemName: "plus", withConfiguration: largeConfiguration)
        menuButton.setImage((addIcon), for: .normal)
        
        menuButton.addTarget(self, action: #selector(menuButtonAction(sender:)), for: .touchUpInside)
        
        view.layoutIfNeeded()
    }
    
    @objc private func menuButtonAction(sender: UIButton) {
          
//        let life = LifeViewController()
//        let work = WorkViewController()
//
        
        
//        let destinationVC = UINavigationController(rootViewController: addVC)
        
//            addVC.onViewWillDisappear = {
//            let lifeView = LifeViewController()
//               let workView = WorkViewController()
        //               lifeView.reloadCollection()
        //               workView.reloadCollection()
        performSegue(withIdentifier: "addEventSegue", sender: self)
       
    }
    
}
//
//extension TabBarController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
//
//
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return 3
//    }
//
//
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! ReminderCell
//
//        return cell
//    }
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        return CGSize(width: collectionView.frame.width/2.1, height: collectionView.frame.width/2.1)
//    }
//
//}
//
  
extension UIImage {
    
    func imageResize (sizeChange:CGSize)-> UIImage{

        let hasAlpha = true
        let scale: CGFloat = 0.0 // Use scale factor of main screen

        UIGraphicsBeginImageContextWithOptions(sizeChange, !hasAlpha, scale)
        self.draw(in: CGRect(origin: CGPoint.zero, size: sizeChange))

        let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
        return scaledImage!
    }
}


   

