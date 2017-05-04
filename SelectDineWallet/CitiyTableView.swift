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

protocol CityEnteredDelegate: class {
    func userDidEnterCity(info: String)
}

class CityTableView: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchDisplayDelegate, UISearchBarDelegate {
    
    let searchController = UISearchController(searchResultsController: nil)
    var filteredCities = [String]()
    var cities = [String]()
    var NumberOfRows = 0
    let baseUrl = "http://35.154.46.78:1337"
    var searchActive : Bool = false
    weak var delegate: CityEnteredDelegate? = nil
    var test:String = "Indian Bank"
    var test1:String = "Tamil Nadu"
    @IBOutlet var citiesTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        citiesTableView.delegate = self
        citiesTableView.dataSource = self
        //  searchController.delegate = self
        
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        citiesTableView.tableHeaderView = searchController.searchBar
        searchController.hidesNavigationBarDuringPresentation = false
        
        
        parseJSON()
        
    }
    
    func parseJSON(){
        let urlpath = "\(baseUrl)/banks/getAllCitiesWithABankInAState?state=\(test1)&bankName=\(test)&accessToken=accessToken".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        let url = URL(string: urlpath!)
        if let jsonData = try? Data(contentsOf: url! as URL, options: []) {
            let readableJSON = JSON(data: jsonData as Data, options: JSONSerialization.ReadingOptions.mutableContainers, error: nil)
            let status = readableJSON["status"].int! as Int
            
            let items = readableJSON["cities"].array!
            for i in 0..<items.count{
                cities.append(items[i].string!)
            }
            
            NumberOfRows = readableJSON["banks"].count as Int
        }else{
            let alert = UIAlertController(title: "Error!", message: "Could not retrieve cities", preferredStyle: .actionSheet)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action) in
                
            }))
            self.present(alert, animated: true)
        }
        filteredCities = cities
    }
    
    func filterContentForSearchText(searchText: String, scope: String = "All") {
        filteredCities = cities.filter { state in
            return state.lowercased().contains(searchText.lowercased())
            
        }
        citiesTableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchController.isActive && searchController.searchBar.text != "" {
            return filteredCities.count
        }
        return cities.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "bankNameCell", for: indexPath) as! BankTableViewCell
        
        if searchController.isActive && searchController.searchBar.text != "" {
            cell.cityName.text = filteredCities[indexPath.row]
        }else{
            cell.cityName.text = cities[indexPath.row]
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let currentCell = tableView.cellForRow(at: indexPath)! as! BankTableViewCell
        print(currentCell.cityName!.text!)
      delegate?.userDidEnterCity(info: currentCell.cityName!.text!)
        dismiss(animated: true, completion: nil)
        
    }
    
    @IBAction func dismiss(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
}
extension CityTableView: UISearchResultsUpdating {
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



