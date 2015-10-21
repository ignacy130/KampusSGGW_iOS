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
}

//Custom

extension MapController{
    func setNavigationBarColors(){
        self.navigationController?.navigationBar.barTintColor = Colors.background
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: Colors.text]
        self.navigationController?.toolbar.barTintColor = Colors.background
        self.navigationController?.toolbar.tintColor = Colors.background
        self.navigationController?.navigationBar.tintColor = Colors.text
    }
}


