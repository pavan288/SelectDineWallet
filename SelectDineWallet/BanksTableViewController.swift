//
//  BanksTableViewController.swift
//  SelectDineWallet
//
//  Created by Pavan Powani on 11/04/17.
//  Copyright © 2017 Pavan Powani. All rights reserved.
//
import Foundation
import UIKit
import SwiftyJSON

class BanksTableViewController: UITableViewController {
    
    let searchController = UISearchController(searchResultsController: nil)
    var filteredBanks = [bankModel]()
    var tempBanks = [bankModel]()
    var banks = [String]()
    var test:String!
    var NumberOfRows = 0
    @IBOutlet var bankTableView: UITableView!
    let baseUrl = "http://35.154.46.78:1337"

    override func viewDidLoad() {
        super.viewDidLoad()
       
        
      /*  searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        bankTableView.tableHeaderView = searchController.searchBar
        searchController.hidesNavigationBarDuringPresentation = false*/
        
        parseJSON()

    }
    
    func parseJSON(){
        let urlpath = "\(baseUrl)/banks/getAllBanksByName".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        let url = URL(string: urlpath!)
        if let jsonData = try? Data(contentsOf: url! as URL, options: []) {
            let readableJSON = JSON(data: jsonData as Data, options: JSONSerialization.ReadingOptions.mutableContainers, error: nil)
            let status = readableJSON["status"].int! as Int
            
            let items = readableJSON["banks"].array!
                for i in 0..<items.count{
                    banks.append(items[i].string!)
                }
            
            NumberOfRows = readableJSON["banks"].count as Int
    }
    }
    
  /*  func searchDisplayController(controller: UISearchController!, shouldReloadTableForSearchString searchString: String!) -> Bool {
        self.filterContentForSearchText(searchText: searchString)
        return true
    }
    
    func filterContentForSearchText(searchText: String, scope: String = "All") {
        filteredBanks = banks.filter({ bank in
            return bank.lowercased().contains(searchText.lowercased())
        })
        
        bankTableView.reloadData()
    }*/

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchController.isActive && searchController.searchBar.text != "" {
            return filteredBanks.count
        }
        return NumberOfRows
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "bankNameCell", for: indexPath) as! BankTableViewCell

        // Configure the cell...
        
        cell.bankName.text = banks[indexPath.row]

        return cell
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
/*extension BanksTableViewController: UISearchResultsUpdating {
    @available(iOS 8.0, *)
    public func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchText: searchController.searchBar.text!)
        bankTableView.reloadData()
    }

}*/
