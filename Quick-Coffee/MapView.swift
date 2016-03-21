//
//  MapView.swift
//  Quick-Coffee
//
//  Created by Irfan Lone on 3/21/16.
//  Copyright © 2016 Ilone Labs. All rights reserved.
//

import MapKit

extension DetailViewController : MKMapViewDelegate {

    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        
        let identifier = "pin"
        var view: MKPinAnnotationView
        if let dequeuedView = mapView.dequeueReusableAnnotationViewWithIdentifier(identifier)
            as? MKPinAnnotationView {
                dequeuedView.annotation = annotation
                view = dequeuedView
        } else {
            view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            view.canShowCallout = true
            view.rightCalloutAccessoryView = UIButton(type: .DetailDisclosure)
            
        }
        return view
    }
    
    func mapView(mapView: MKMapView, annotationView view: MKAnnotationView,
        calloutAccessoryControlTapped control: UIControl) {
            let launchOptions = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving]
            self.mapItem().openInMapsWithLaunchOptions(launchOptions)
    }
    
    func mapItem() -> MKMapItem {
        let addressDictionary = [String("Name"): venue.name]
        let coordinate = CLLocationCoordinate2DMake(venue.location.lattitue, venue.location.longitude)
        let placemark = MKPlacemark(coordinate: coordinate, addressDictionary: addressDictionary)
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = venue.location.address
        return mapItem
    }
    
}