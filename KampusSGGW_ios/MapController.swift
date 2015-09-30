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

    override func viewDidLoad() {
        super.viewDidLoad()
        self.mapView.delegate = self
        
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
        self.searchResultsController = UITableViewController()
        self.searchController = UISearchController(searchResultsController: self.searchResultsController)
        self.searchController.hidesNavigationBarDuringPresentation = false
        self.searchController.searchResultsUpdater = self
        self.searchResultsController.tableView.dataSource = self
        self.searchResultsController.tableView.delegate = self
    }
    
    func displayAnnotations(){
        self.buildings = Buildings.getAll()
        
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
        presentViewController(searchController, animated: true, completion: nil)
    }
}

extension MapController: UITableViewDelegate, UITableViewDataSource{
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel!.text = buildings[indexPath.row].name
        return cell
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return buildings.count
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let selection = buildings[indexPath.row]
        for annotation in self.buildings{
            mapView.viewForAnnotation(annotation)?.image = annotation.pin
        }
        mapView.viewForAnnotation(selection)?.image = selection.activePin
        self.searchController.active = false
        centerMapOnActiveLocation(selection.location)
    }
}

extension MapController: UISearchResultsUpdating{
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        self.searchResultsController.view.hidden = false
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
