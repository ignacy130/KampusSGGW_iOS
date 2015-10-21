//
//  Search_MapController.swift
//  KampusSGGW_ios
//
//  Created by Pawel Sygnowski on 21/10/15.
//  Copyright © 2015 QexT. All rights reserved.
//

import UIKit

//Base

extension MapController {
    func initializeSearch(){
        self.searchResultsController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("SearchResultsTableViewController") as? UITableViewController
        self.searchResultsController.tableView.backgroundColor = UIColor.clearColor()
        self.searchController = UISearchController(searchResultsController: self.searchResultsController)
        self.searchController.hidesNavigationBarDuringPresentation = false
        self.searchController.searchResultsUpdater = self
        self.searchController.searchBar.delegate = self
        self.searchResultsController.tableView.dataSource = self
        self.searchResultsController.tableView.delegate = self
    }
    
    @IBAction func showSearchBar(sender: AnyObject) {
        self.filteredBuildings = self.buildings
        presentViewController(searchController, animated: true, completion: nil)
    }
}

//UISearchBarDelegate

extension MapController: UISearchBarDelegate{
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        searchBar.text = ""
    }
}

//UISearchResultsUpdating

extension MapController: UISearchResultsUpdating{
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        if let input = searchController.searchBar.text{
            filterBuildings(input.lowercaseString)
        }
    }
    
    func filterBuildings(input: String){
        self.filteredBuildings = self.buildings.filter({ $0.searchText.rangeOfString(input) != nil || input.characters.count == 0 })
        self.searchResultsController?.tableView.reloadData()
    }
}

//UITableViewDelegate, UITableViewDataSource

extension MapController: UITableViewDelegate, UITableViewDataSource{
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as? BuildingTableViewCell
        
        if cell == nil{
            cell = BuildingTableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: cellIdentifier)
        }
        
        let building = self.filteredBuildings[indexPath.row]
        cell?.assignValuesFromBuilding(building)
        cell?.backgroundColor = Colors.background
        
        return cell!
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredBuildings.count
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let selection = filteredBuildings[indexPath.row]
        for annotation in self.buildings{
            mapView.viewForAnnotation(annotation)?.image = annotation.pin
        }
        mapView.viewForAnnotation(selection)?.image = selection.activePin
        centerMapOnActiveLocation(selection.location)
        searchController.searchBar.text = ""
        self.searchController.active = false
    }
}
