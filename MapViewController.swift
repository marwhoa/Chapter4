//
//  MapViewController.swift
//  WorldTrotter
//
//  Created by James Marlowe on 2/5/17.
//  Last modified on 2/12/17
//  Copyright © 2017 High Point University. All rights reserved.
//
//  This project uses the MapKit feature of IOS to display a map in the device.
//  Features: 
//                -Pushing the Pin button for the first 3 times sets a pinned location of that map where it is currently
//                  centered
//                -After 3 pins have been set, you can toggle between the pin location by pressed that button again
//                -By pushing the locate me button initially, the map will zoom in on the current device location
//                -By pushing it again, you can zoom out do lat,lon location (0,0) as a predefined default

import UIKit
import MapKit


class MapViewController: UIViewController, MKMapViewDelegate {
    
    //Globals
    var mapView: MKMapView!
    var Delegate: MKMapViewDelegate!
    let locationManager = CLLocationManager()
    var updatingLocation : Bool = false
    
    var latitude : CLLocationDegrees!
    var longitude : CLLocationDegrees!
    
    let centerCoord = CLLocationCoordinate2DMake(0, 0)
    
    var Pins : [CLLocationCoordinate2D] = []
    var pinSize : Int = -1
    var pinPointer : Int = -1
    
    
    //provide definition for delegate function
    //Gets called whenever mapView's location gets updated via code
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
    
        if self.updatingLocation == true { //if we want to zoom into the user's current location

            mapView.setCenter(userLocation.coordinate, animated: true)
            
            var letSpan : CLLocationDegrees
            var longSpan : CLLocationDegrees

            self.mapView.showsUserLocation = true
                
            latitude = mapView.userLocation.coordinate.latitude
            longitude = mapView.userLocation.coordinate.longitude
            
            letSpan = 0.02 //how much we zoom
            longSpan = 0.02
                
            let span = MKCoordinateSpanMake(letSpan, longSpan)
            let location = CLLocationCoordinate2DMake(latitude, longitude)
            let region = MKCoordinateRegionMake(location, span)
            
            self.mapView.setRegion(region, animated: true)
                
            print("Showing User Location")
        }

    }
    
    
    
    /*Function that gets activated when the user presses one of the buttons that changes the map type*/
    func mapTypeChanged(_ segControl: UISegmentedControl)
    {
        switch segControl.selectedSegmentIndex //switch based on which button was pressed
        {
            case 0:
               mapView.mapType = .standard
            case 1:
                mapView.mapType = .hybrid
            case 2:
                mapView.mapType = .satellite
            default:
                break
            
        }
    }
    
    
    //Function that is responsible for creating a new annotation to the map at the current center location
    //Adds that location to the global Pin array
    func createPin() {
        print("Creating new pin for map")
        let currentLocation = CLLocationCoordinate2DMake(mapView.centerCoordinate.latitude,                                               mapView.centerCoordinate.longitude)
        
        let localAnnotation = MKPointAnnotation()
        localAnnotation.coordinate = currentLocation
        localAnnotation.title = "Pin \(self.pinSize)"
        self.mapView.addAnnotation(localAnnotation)
        
        self.Pins.append(localAnnotation.coordinate) //add the pin coordinate to global array of pins
    }
    
    
    //Function to toggle the map's view based on what 3 items are in the global Pin array
    func togglePinLocation() {
        
        if self.pinPointer < 2 {
            self.pinPointer = self.pinPointer + 1 //advance to next pin
        }
        else {
            self.pinPointer = 0 //reset to first pin
        }
        
        //change the user's view
        mapView.setCenter(self.Pins[pinPointer], animated: true)
        
        latitude = self.Pins[pinPointer].latitude
        longitude = self.Pins[pinPointer].longitude
     
        let span = MKCoordinateSpanMake(0.05, 0.05)
        let location = CLLocationCoordinate2DMake(latitude, longitude)
        let region = MKCoordinateRegionMake(location, span)
        
        self.mapView.setRegion(region, animated: true)
        
        print("Zooming in on Pin \(self.pinPointer)")
        
    }
    
    
    //Function that gets called when the bottom UISegmentedControl is pushed
    func locationButtonPressed(_ segControl: UISegmentedControl)
    {
        switch segControl.selectedSegmentIndex
        {
            case 0: //pin button was pressed
                
                print("The pin button was pressed")
                
                if self.pinSize < 2 {
                    self.pinSize = self.pinSize + 1
                    createPin() //create a new pin annotation for the map
                    
                }
                else {
                    
                    togglePinLocation()
                    
                }
                
                segControl.selectedSegmentIndex = UISegmentedControlNoSegment
            
            case 1: //the show current location button was pressed
                
                print("Location me button was pressed")
                
                self.updatingLocation = !self.updatingLocation //reverse the values
                
                self.mapView.showsUserLocation = self.updatingLocation
                
                //deselect the segment, so that the user could press it again if desired
                segControl.selectedSegmentIndex = UISegmentedControlNoSegment
            
                if self.updatingLocation == false {
                    
                    //worldCenter is the default zoomed out location in the map
                    let worldCenter = MKCoordinateRegionMakeWithDistance(centerCoord, 10000000, 30000000)
                    self.mapView.setRegion(worldCenter, animated: true)
                    print("Panning out to Default View")
            }
            
        default:
                print("error in locationButtonPressed")
                break
        }
    }
    
    
    override func loadView() { //called when a view controller is asked for its view, and the view is nil
        
        //create a map view
        mapView = MKMapView()
        
        //set it as the view of this view controller
        self.view = mapView
        
        
        let pinButton = NSLocalizedString("Pin", comment: "Go to pinned location")
        let locateButton = NSLocalizedString("Locate Me", comment: "Zooms on current user Location")
        let standardString = NSLocalizedString("Standard", comment: "Standard map view")
        let satelliteString = NSLocalizedString("Satellite", comment: "Satellite Map view")
        let hybridString = NSLocalizedString("Hybrid", comment: "Hybrid Map View")
        
        let segmentedControl = UISegmentedControl(items: [standardString, satelliteString, hybridString])
        let locationControl = UISegmentedControl(items: [pinButton, locateButton])
        
    
        
        segmentedControl.backgroundColor = UIColor.white.withAlphaComponent(0.5)
        segmentedControl.selectedSegmentIndex = 0
        locationControl.backgroundColor = UIColor.white.withAlphaComponent(0.5)
        locationControl.selectedSegmentIndex = 0
        
        segmentedControl.addTarget(self, action: #selector(MapViewController.mapTypeChanged(_ :)), for: .valueChanged)
        locationControl.addTarget(self, action: #selector(MapViewController.locationButtonPressed(_ :)), for: .valueChanged)
        
        
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        locationControl.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(segmentedControl)
        view.addSubview(locationControl)
        
        
        //add contraints
        
        //Below was commented out so that the segmented controll isn't on top of the status line
        //let topConstraint = segmentedControl.topAnchor.constraint(equalTo: view.topAnchor)
        
        let topConstraint = segmentedControl.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor, constant: 8)
        
        //Below was commented out to use argins instead of constant constraints
        //let leadingConstraint = segmentedControl.leadingAnchor.constraint(equalTo: view.leadingAnchor)
        //let trailingConstraint = segmentedControl.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        
        let margins = view.layoutMarginsGuide
        let leadingConstraint = segmentedControl.leadingAnchor.constraint(equalTo: margins.leadingAnchor)
        let trailingConstraint = segmentedControl.trailingAnchor.constraint(equalTo: margins.trailingAnchor)
        
        topConstraint.isActive = true
        leadingConstraint.isActive = true
        trailingConstraint.isActive = true
        
        
        let bottomConstraint = locationControl.topAnchor.constraint(equalTo: bottomLayoutGuide.topAnchor, constant: -34.0)
        let LC = locationControl.leadingAnchor.constraint(equalTo: margins.leadingAnchor)
        let TC = locationControl.trailingAnchor.constraint(equalTo: margins.trailingAnchor)
        
        bottomConstraint.isActive = true
        LC.isActive = true
        TC.isActive = true
        
        locationControl.selectedSegmentIndex = UISegmentedControlNoSegment //start off with nothing selected
        
        
    }
    override func viewDidLoad() {
       
        super.viewDidLoad()
        //Let the delegate property of mapView know that this class also is receiving updates.
        self.mapView.delegate = self
    
        print("MapViewController loaded its view")
        
        self.locationManager.requestAlwaysAuthorization()
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.mapView.showsUserLocation = updatingLocation //intitially set to false
        
        
    }
}
