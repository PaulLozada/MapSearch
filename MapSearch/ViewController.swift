//
//  ViewController.swift
//  MapSearch
//
//  Created by Paul Lozada on 2016-02-16.
//  Copyright © 2016 Paul Lozada. All rights reserved.
//

import UIKit
import MapKit


class ViewController: UIViewController,UISearchBarDelegate,MKMapViewDelegate, UITextFieldDelegate {

    @IBOutlet weak var mainMapView: MKMapView!
    @IBOutlet weak var searchBarOutlet: UISearchBar!
    
    var mapItem = [MKMapItem]()
    
    let regionRadius: CLLocationDistance = 1000
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,
        regionRadius * 2.0, regionRadius * 2.0)
        self.mainMapView.setRegion(coordinateRegion, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        let annotationView = MKPinAnnotationView()
        annotationView.canShowCallout = true
        annotationView.animatesDrop = true
        annotationView.pinTintColor = UIColor(red:0.046, green:0.741, blue:1, alpha:1)
        annotationView.leftCalloutAccessoryView = UIButton(type: UIButtonType.InfoDark)
        annotationView.rightCalloutAccessoryView = UIButton(type: UIButtonType.InfoLight)
        return annotationView
    }
 
    func mapView(mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        
        switch control {
        case view.leftCalloutAccessoryView!:
            MKMapItem.openMapsWithItems(mapItem, launchOptions: [MKLaunchOptionsDirectionsModeKey:MKLaunchOptionsDirectionsModeDriving])
        default:
            print("right callout")
        }
        
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        
        let localSearchRequest = MKLocalSearchRequest()
        localSearchRequest.naturalLanguageQuery = searchBar.text
        let search = MKLocalSearch(request: localSearchRequest)
        search.startWithCompletionHandler { response, error in
            if response == nil {
                let alert = UIAlertController(title: "Search Failed", message: "No results found. Try another search.", preferredStyle: .Alert)
                let action = UIAlertAction(title: "Okay", style: .Default, handler: nil)
                alert.addAction(action)
                self.presentViewController(alert, animated: true, completion: nil)
            } else {
                let items = response!.mapItems
                for item in items {
                    let annotation = MapAnnotations(coordinate: item.placemark.coordinate, title:  item.placemark.name, subtitle: item.phoneNumber)
                    
                    let initialLocation = CLLocation(latitude: item.placemark.coordinate.latitude, longitude: item.placemark.coordinate.longitude)
                    
                    self.centerMapOnLocation(initialLocation)
                    self.mapItem.append(item)
                    self.mainMapView.addAnnotation(annotation)
                    self.mainMapView.selectAnnotation(annotation, animated: true)
                }
            }
        }
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText == "" {
            searchBarOutlet.showsCancelButton = false
        } else{
            searchBarOutlet.showsCancelButton = true
        }
    }
    
    func searchBarResultsListButtonClicked(searchBar: UISearchBar) {
        print(searchBar)
    }
    
    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
    }
    
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        self.view.endEditing(true)
        self.searchBarOutlet.text = ""
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

