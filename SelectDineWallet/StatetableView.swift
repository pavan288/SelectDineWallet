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

protocol StateEnteredDelegate: class {
    func userDidEnterState(info: String)
}

class StateTableView: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchDisplayDelegate, UISearchBarDelegate {
    
    let searchController = UISearchController(searchResultsController: nil)
    var filteredStates = [String]()
    var states = [String]()
    var NumberOfRows = 0
    let baseUrl = "http://35.154.46.78:1337"
    var searchActive : Bool = false
    @IBOutlet var statesTableView: UITableView!
    var test:String = "bank of baroda"
    weak var delegate: StateEnteredDelegate? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        statesTableView.delegate = self
        statesTableView.dataSource = self
        //  searchController.delegate = self
        
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        statesTableView.tableHeaderView = searchController.searchBar
        searchController.hidesNavigationBarDuringPresentation = false
        
        parseJSON()
        self.hideKeyboard()
        
    }
    
    func parseJSON(){
        let urlpath = "\(baseUrl)/banks/getAllStatesForABank?bankName=\(test)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        let url = URL(string: urlpath!)
        if let jsonData = try? Data(contentsOf: url! as URL, options: []) {
            let readableJSON = JSON(data: jsonData as Data, options: JSONSerialization.ReadingOptions.mutableContainers, error: nil)
            let status = readableJSON["status"].int! as Int
            
            let items = readableJSON["states"].array!
            for i in 0..<items.count{
                states.append(items[i].string!)
            }
            
            NumberOfRows = readableJSON["banks"].count as Int
        }
        filteredStates = states
    }
    
    func filterContentForSearchText(searchText: String, scope: String = "All") {
        filteredStates = states.filter { state in
            return state.lowercased().contains(searchText.lowercased())
            
        }
        statesTableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchController.isActive && searchController.searchBar.text != "" {
            return filteredStates.count
        }
        return states.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "bankNameCell", for: indexPath) as! BankTableViewCell
        
        if searchController.isActive && searchController.searchBar.text != "" {
            cell.stateName.text = filteredStates[indexPath.row]
        }else{
            cell.stateName.text = states[indexPath.row]
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let currentCell = tableView.cellForRow(at: indexPath)! as! BankTableViewCell
        print(currentCell.stateName!.text!)
       delegate?.userDidEnterState(info: currentCell.stateName!.text!)
        dismiss(animated: true, completion: nil)
        
    }
    
    @IBAction func dismiss(_ sender: Any) {
         dismiss(animated: true, completion: nil)
    }
    
    
}
extension StateTableView: UISearchResultsUpdating {
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



