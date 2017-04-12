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

class BranchTableView: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchDisplayDelegate, UISearchBarDelegate {
    
    
    let searchController = UISearchController(searchResultsController: nil)
    var filteredBranches = [String]()
    var branches = [String]()
    var NumberOfRows = 0
    let baseUrl = "http://35.154.46.78:1337"
    var searchActive : Bool = false
    @IBOutlet var branchesTableView: UITableView!
    
    var test:String = "Indian Bank"
    var test1:String = "Tamil Nadu"
    var test3:String = "vellore"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        branchesTableView.delegate = self
        branchesTableView.dataSource = self
        //  searchController.delegate = self
        
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        branchesTableView.tableHeaderView = searchController.searchBar
        searchController.hidesNavigationBarDuringPresentation = false
        
        parseJSON()
        
    }
    
    func parseJSON(){
        let urlpath = "\(baseUrl)/banks/getAllBranchesByNameAndState?bankName=\(test)&state=\(test1)&city=\(test3)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        let url = URL(string: urlpath!)
        if let jsonData = try? Data(contentsOf: url! as URL, options: []) {
            let readableJSON = JSON(data: jsonData as Data, options: JSONSerialization.ReadingOptions.mutableContainers, error: nil)
            let status = readableJSON["status"].int! as Int
            
            let items = readableJSON["branches"].array!
            for i in 0..<items.count{
                branches.append(items[i].string!)
            }
            
            NumberOfRows = readableJSON["banks"].count as Int
        }
        filteredBranches = branches
    }
    
    func filterContentForSearchText(searchText: String, scope: String = "All") {
        filteredBranches = branches.filter { state in
            return state.lowercased().contains(searchText.lowercased())
            
        }
        branchesTableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchController.isActive && searchController.searchBar.text != "" {
            return filteredBranches.count
        }
        return branches.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "bankNameCell", for: indexPath) as! BankTableViewCell
        
        if searchController.isActive && searchController.searchBar.text != "" {
            cell.branchName.text = filteredBranches[indexPath.row]
        }else{
            cell.branchName.text = branches[indexPath.row]
        }
        return cell
    }
    
    @IBAction func dismiss(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
}
extension BranchTableView: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchText: searchController.searchBar.text!)
    }
}



/*
 // MARK: - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
 // Get the new view controller using segue.destinationViewController.
 // Pass the selected object to the new view controller.
 }
 */



