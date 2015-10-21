//
//  Map_MapController.swift
//  KampusSGGW_ios
//
//  Created by Pawel Sygnowski on 21/10/15.
//  Copyright © 2015 QexT. All rights reserved.
//

import UIKit
import MapKit

//Base

extension MapController{
    @IBAction func showMyLocation(sender: AnyObject) {
        let userLocation = mapView.userLocation
        
        if let location = userLocation.location{
            let region = MKCoordinateRegionMakeWithDistance(location.coordinate, 700, 700)
            
            mapView.setRegion(region, animated: true)
        }
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
    
    func checkLocationAuthorizationStatus(){
        if CLLocationManager.authorizationStatus() == .AuthorizedWhenInUse{
            mapView.showsUserLocation = true
        }
        else{
            locationManager.requestWhenInUseAuthorization()
        }
    }
}

//MKMapViewDelegate

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
