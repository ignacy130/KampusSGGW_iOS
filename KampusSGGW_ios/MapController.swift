//
//  ViewController.swift
//  KampusSGGW_ios
//
//  Created by Pawel Sygnowski on 29/09/15.
//  Copyright © 2015 QexT. All rights reserved.
//

import UIKit
import MapKit

class MapController: UIViewController {
    @IBOutlet weak var mapView: MKMapView!
    var searchController:UISearchController!
    var searchResultsController:UITableViewController!
    var buildings = [Building]()
    var filteredBuildings = [Building]()
    let cellIdentifier = "buildingCell"

    override func viewDidLoad() {
        super.viewDidLoad()
        self.mapView.delegate = self
        self.buildings = Buildings.getAll()
        
        setNavigationBarColors()
        initializeSearch()
        centerMapOnCamp()
        displayAnnotations()
    }
    
    func setNavigationBarColors(){
        self.navigationController?.navigationBar.barTintColor = Colors.background
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: Colors.text]
    }
    
    func initializeSearch(){
        self.searchResultsController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("SearchResultsTableViewController") as? UITableViewController
        self.searchResultsController.tableView.backgroundColor = Colors.background
        self.searchController = UISearchController(searchResultsController: self.searchResultsController)
        self.searchController.hidesNavigationBarDuringPresentation = false
        self.searchController.searchResultsUpdater = self
        self.searchResultsController.tableView.dataSource = self
        self.searchResultsController.tableView.delegate = self
    }
    
    func displayAnnotations(){
        mapView.addAnnotations(self.buildings)
    }
    
    func centerMapOnCamp(){
        let initialLocation = CLLocation(latitude: 52.161501, longitude: 21.045504)
        centerMapOnLocation(initialLocation, distance: 500);
    }
    
    func centerMapOnActiveLocation(location: CLLocation){
        centerMapOnLocation(location, distance: 300);
    }
    
    func centerMapOnLocation(location: CLLocation, distance: CLLocationDistance){
        let regionRadius: CLLocationDistance = distance
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, regionRadius * 2.0, regionRadius * 2.0)
        
        mapView.setRegion(coordinateRegion, animated: false)
    }
    
    @IBAction func showSearchBar(sender: AnyObject) {
        self.filteredBuildings = self.buildings
        presentViewController(searchController, animated: true, completion: nil)
    }
}

extension MapController: UITableViewDelegate, UITableViewDataSource{
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as? BuildingTableViewCell
        
        if cell == nil{
            tableView.registerClass(BuildingTableViewCell.classForCoder(), forCellReuseIdentifier: cellIdentifier)
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
        if filteredBuildings.count == 0{
            let emptyLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.view.bounds.size.width, height: self.view.bounds.size.height))
            emptyLabel.text = "Brak wyników spełniających podane kryteria."
            emptyLabel.textColor = Colors.text
            emptyLabel.numberOfLines = 0
            emptyLabel.textAlignment = .Center
            emptyLabel.sizeToFit()
            
            self.searchResultsController.tableView.backgroundView = emptyLabel
            self.searchResultsController.tableView?.backgroundView?.hidden = false
        }
        else{
            self.searchResultsController.tableView?.backgroundView?.hidden = true
        }
        return filteredBuildings.count
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.searchController.active = false
        let selection = filteredBuildings[indexPath.row]
        for annotation in self.buildings{
            mapView.viewForAnnotation(annotation)?.image = annotation.pin
        }
        mapView.viewForAnnotation(selection)?.image = selection.activePin
        centerMapOnActiveLocation(selection.location)
    }
}

extension MapController: UISearchResultsUpdating{
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        self.searchResultsController.view.hidden = false
        if let input = searchController.searchBar.text{
            filterBuildings(input.lowercaseString)
        }
    }
    
    func filterBuildings(input: String){
        self.filteredBuildings = self.buildings.filter({ $0.searchText.rangeOfString(input) != nil || input.characters.count == 0 })
        self.searchResultsController?.tableView.reloadData()
    }
}

extension MapController : MKMapViewDelegate{
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        if let building = annotation as? Building{
            let identifier = "pin"
            var view: MKAnnotationView
            if let dequeuedView = mapView.dequeueReusableAnnotationViewWithIdentifier(identifier){
                dequeuedView.annotation = building
                view = dequeuedView
            }
            else{
                view = MKAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                view.canShowCallout = true
                view.image = building.pin
            }
            return view
        }
        return nil
    }
}
