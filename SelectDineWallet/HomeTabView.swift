//
//  HomeTabView.swift
//  SelectDineWallet
//
//  Created by Pavan Powani on 31/03/17.
//  Copyright © 2017 Pavan Powani. All rights reserved.
//

import UIKit

class HomeTabView: UIViewController,UIScrollViewDelegate {

    @IBOutlet var coverView: UIScrollView!
    let feature1 = ["image":"Background-Cover"]
    let feature2 = ["image":"Background-Cover"]
    @IBOutlet var featurePageControl: UIPageControl!
    let feature3 = ["image":"Background-Cover"]
    let feature4 = ["image":"Background-Cover"]
    
    var featureArray = [Dictionary<String,String>]()
    
    let prefs = UserDefaults.standard
    let baseUrl = "http://35.154.46.78:1337"
    
    override func viewDidLoad() {
        featureArray = [feature1,feature2,feature3,feature4]
        
        coverView.isPagingEnabled = true
        coverView.contentSize = CGSize(width: self.view.bounds.width * CGFloat(featureArray.count), height: 196)
        coverView.showsHorizontalScrollIndicator = false
        coverView.delegate = self
        loadFeatures()
    }
    
    func loadFeatures(){
        for(index,feature) in featureArray.enumerated(){
            if let featureView = Bundle.main.loadNibNamed("HomeScroller", owner: self, options: nil)?.first as? HomeScrollView {
                featureView.coverImage.image = UIImage(named:feature["image"]!)
                coverView.addSubview(featureView)
                featureView.frame.size.width = self.view.bounds.size.width
                featureView.frame.origin.x = CGFloat(index) * self.view.bounds.size.width
                
            }
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let page = scrollView.contentOffset.x / scrollView.frame.size.width
        featurePageControl.currentPage = Int(page)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "HomeBank" {
            let destinationVC = segue.destination as! PayViewController
            if let phoneNumber = prefs.value(forKey: "phone"){
            destinationVC.defaultNumber = phoneNumber as! Int
                destinationVC.phoneFlag = 1
            }else{
                print("update phone number before transaction")
            }
            
        }else if segue.identifier == "HomeCredits"{
            let destinationVC = segue.destination as! PayViewController
            if let phoneNumber = prefs.value(forKey: "phone"){
            destinationVC.defaultNumber = phoneNumber as! Int
            destinationVC.phoneFlag = 2
            }else{
                print("update phone number before transaction")
            }
        }
    }
}
