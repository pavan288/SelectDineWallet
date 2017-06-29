//
//  HomeViewController.swift
//  SelectDineWallet
//
//  Created by Pavan Powani on 29/03/17.
//  Copyright © 2017 Pavan Powani. All rights reserved.
//

import UIKit

class HomeViewController: UITabBarController {

    @IBOutlet var homeTab: UITabBar!
    override func viewDidLoad() {
        super.viewDidLoad()
       self.tabBarController?.selectedIndex=2
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
  /*  var freshLaunch = true
    override func viewWillAppear(_ animated: Bool) {
        if freshLaunch == true {
            freshLaunch = false
//            print(self.homeTab.selectedItem!)
            self.tabBarController?.selectedIndex = 2 // 5th tab
        }
    }*/
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
