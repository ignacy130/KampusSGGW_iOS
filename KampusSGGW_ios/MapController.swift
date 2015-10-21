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
    var selectedBuilding: Building?
    let cellIdentifier = "buildingCell"
    var locationManager = CLLocationManager()
    var selectedAnnotation:MKAnnotation?
    
    @IBAction func showAboutInfo(sender: AnyObject) {
    }
    
    @IBAction func showMyLocation(sender: AnyObject) {
        let userLocation = mapView.userLocation
        
        if let location = userLocation.location{
            let region = MKCoordinateRegionMakeWithDistance(location.coordinate, 700, 700)
            
            mapView.setRegion(region, animated: true)
        }
        
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.mapView.delegate = self
        self.buildings = Buildings.getAll()
        
        setNavigationBarColors()
        initializeSearch()
        centerMapOnCamp()
        displayAnnotations()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        checkLocationAuthorizationStatus()
    }
    
    func checkLocationAuthorizationStatus(){
        if CLLocationManager.authorizationStatus() == .AuthorizedWhenInUse{
            mapView.showsUserLocation = true
        }
        else{
            locationManager.requestWhenInUseAuthorization()
        }
    }
    
    func setNavigationBarColors(){
        self.navigationController?.navigationBar.barTintColor = Colors.background
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: Colors.text]
        self.navigationController?.toolbar.barTintColor = Colors.background
        self.navigationController?.toolbar.tintColor = Colors.background
        self.navigationController?.navigationBar.tintColor = Colors.text
    }
    
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

extension MapController: UISearchBarDelegate{
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        searchBar.text = ""
    }
}

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
                let button = UIButton(type: .InfoDark)
                view = MKAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                view.canShowCallout = true
                view.rightCalloutAccessoryView = button
                view.image = building.pin
            }
            return view
        }
        return nil
    }
    
    func mapView(mapView: MKMapView, didSelectAnnotationView view: MKAnnotationView) {
        selectedAnnotation = view.annotation
    }
    
    func mapView(mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        let building = view.annotation as? Building
        if building != nil{
            selectedBuilding = building
            performSegueWithIdentifier("buildingDetails", sender: self)
        }
        else{
            selectedBuilding = nil
        }
    }
    
    func hideCallout(){
        mapView.deselectAnnotation(selectedAnnotation, animated: true)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let buildingController = segue.destinationViewController as? BuildingController{
            buildingController.building = selectedBuilding
            
            hideCallout()
        }
    }
}
