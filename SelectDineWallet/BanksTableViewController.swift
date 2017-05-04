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

protocol BankEnteredDelegate: class {
    func userDidEnterBank(info: String)
}

class BanksTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchDisplayDelegate, UISearchBarDelegate {
    
    let searchController = UISearchController(searchResultsController: nil)
    var filteredBanks = [String]()
    var banks = [String]()
    var test:String!
    var NumberOfRows = 0
    @IBOutlet var bankTableView: UITableView!
    let baseUrl = "http://35.154.46.78:1337"
    var searchActive : Bool = false
   weak var delegate: BankEnteredDelegate? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        
        bankTableView.delegate = self
        bankTableView.dataSource = self
      //  searchController.delegate = self
       
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        bankTableView.tableHeaderView = searchController.searchBar
        searchController.hidesNavigationBarDuringPresentation = false
        
        parseJSON()
        
        self.hideKeyboard()

    }
    
    func parseJSON(){
        let urlpath = "\(baseUrl)/banks/getAllBanksByName&accessToken=accessToken".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        let url = URL(string: urlpath!)
        if let jsonData = try? Data(contentsOf: url! as URL, options: []) {
            let readableJSON = JSON(data: jsonData as Data, options: JSONSerialization.ReadingOptions.mutableContainers, error: nil)
            let status = readableJSON["status"].int! as Int
            
            let items = readableJSON["banks"].array!
                for i in 0..<items.count{
                    banks.append(items[i].string!)
                }
            
            NumberOfRows = readableJSON["banks"].count as Int
        }else{
            let alert = UIAlertController(title: "Error!", message: "Could not retrieve banks", preferredStyle: .actionSheet)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action) in
                
            }))
            self.present(alert, animated: true)
        }
        filteredBanks = banks
    }
    
    func filterContentForSearchText(searchText: String, scope: String = "All") {
        filteredBanks = banks.filter { bank in
            return bank.lowercased().contains(searchText.lowercased())
            
        }
        bankTableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source


     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchController.isActive && searchController.searchBar.text != "" {
            return filteredBanks.count
        }
        return banks.count
    }


     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "bankNameCell", for: indexPath) as! BankTableViewCell
        
        if searchController.isActive && searchController.searchBar.text != "" {
          cell.bankName.text = filteredBanks[indexPath.row]
        }else{
       cell.bankName.text = banks[indexPath.row]
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let currentCell = tableView.cellForRow(at: indexPath)! as! BankTableViewCell
        print(currentCell.bankName!.text!)
      delegate?.userDidEnterBank(info: currentCell.bankName!.text!)
        dismiss(animated: true, completion: nil)

    }


    @IBAction func dismissVC(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}
extension BanksTableViewController: UISearchResultsUpdating {
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

    

