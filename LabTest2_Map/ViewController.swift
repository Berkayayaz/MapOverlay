//
//  ViewController.swift
//  LabTest2_Map
//
//  Created by Berkay AYAZ on 2016-08-02.
//  Copyright © 2016 Berkay AYAZ. All rights reserved.
//

import UIKit
import MapKit
extension CGRect {
    
    init(_ x:CGFloat, _ y:CGFloat, _ w:CGFloat, _ h:CGFloat) {
        
        self.init(x:x, y:y, width:w, height:h)
    }
}
class ViewController: UIViewController, UIGestureRecognizerDelegate,MKMapViewDelegate {
    
    
    var places = [MKAnnotation]()
    var oldAnn: MKAnnotation?
    var mkPoints:[CLLocationCoordinate2D]?
    var oldAnnTitle = String()
    var coordinates = [CLLocationCoordinate2D]()
    var distances = [Double]()
    var regionRadius: CLLocationDistance = 3000
    var initialLocation = CLLocation(latitude: 47.537372700198851, longitude: -79.361680041402053)


    @IBOutlet weak var mapView: MKMapView!
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.frame = CGRect(0 , 0, self.view.frame.width, self.view.frame.height)

        let lpgr = UILongPressGestureRecognizer(target: self, action: #selector(ViewController.handleLongPress(_:)))
        lpgr.minimumPressDuration = 1.0
        lpgr.delaysTouchesBegan = true
        lpgr.delegate = self
        mapView.delegate = self
        
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(initialLocation.coordinate,
                                                                  regionRadius * 2.0, regionRadius * 2.0)
        mapView.setRegion(coordinateRegion, animated: true)
       
       
        self.mapView.addGestureRecognizer(lpgr)
        // Do any additional setup after loading the view, typically from a nib.
    }
    @IBAction func CancelPressed(_ sender: UIBarButtonItem) {
        places.removeAll()
        clearAnnotations()
        mapView.removeOverlays(mapView.overlays)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func handleLongPress(_ gestureReconizer: UILongPressGestureRecognizer) {
        if gestureReconizer.state == UIGestureRecognizerState.began {
        let annCount = mapView.annotations.count
            let touchPoint = gestureReconizer.location(in: mapView)
            let newCoordinates = mapView.convert(touchPoint, toCoordinateFrom: mapView)
        print("ANNOTATION NUMBER")
        print(annCount)
            if(!checkDistance(newCoordinates)){
        if  annCount < 5 {
         
          
        
            var pointName = ""
            if annCount == 0 {
                pointName = "A" }
            else  if annCount == 1{ pointName = "B" } else if annCount == 2 { pointName = "C"} else if annCount == 3 { pointName = "D"} else { pointName = "E"}
         
        
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = newCoordinates
            annotation.title = pointName
            print(newCoordinates)
        mapView.addAnnotation(annotation)
        places.append(annotation)
            let annCount = mapView.annotations.count
            if  annCount >= 5 {
                createOverlay()
            }
    }
            }
            else {
                mapView.removeAnnotation(oldAnn!)
                mapView.removeOverlays(mapView.overlays)

               
        }
                
      
        }
    
    }
   
    
    func checkDistance(_ newPoint: CLLocationCoordinate2D) -> Bool{
        var check = false
        var i = 0
        for ann in places
        {
            
            
                let a = MKMapPointForCoordinate(ann.coordinate);
                let b = MKMapPointForCoordinate(newPoint);
                let distance = MKMetersBetweenMapPoints(a, b);
            
                if distance <= 900 {
                   
                    self.oldAnn = ann
                    places.remove(at: i)
                    check = true
                }
            i += 1
            }
            return check
        }
        
    
    
    func createOverlay(){
        let cor = places
         coordinates = [
            CLLocationCoordinate2D(latitude: cor[0].coordinate.latitude, longitude: cor[0].coordinate.longitude),
            CLLocationCoordinate2D(latitude: cor[1].coordinate.latitude, longitude: cor[1].coordinate.longitude),
            CLLocationCoordinate2D(latitude: cor[2].coordinate.latitude, longitude: cor[2].coordinate.longitude),
            CLLocationCoordinate2D(latitude: cor[3].coordinate.latitude, longitude: cor[3].coordinate.longitude),
            CLLocationCoordinate2D(latitude: cor[4].coordinate.latitude, longitude: cor[4].coordinate.longitude),
            CLLocationCoordinate2D(latitude: cor[0].coordinate.latitude, longitude: cor[0].coordinate.longitude)
        ]
        let center = CLLocationCoordinate2D(latitude: (cor[0].coordinate.latitude + cor[1].coordinate.latitude + cor[2].coordinate.latitude + cor[3].coordinate.latitude + cor[4].coordinate.latitude) / 5 , longitude:  (cor[0].coordinate.longitude+cor[1].coordinate.longitude+cor[2].coordinate.longitude+cor[3].coordinate.longitude+cor[4].coordinate.longitude) / 5 )
        let annotation = MKPointAnnotation()
        annotation.coordinate = center
        annotation.title = "Center"
        print(center)
        mapView.addAnnotation(annotation)
        places.append(annotation)
        initialLocation = CLLocation( latitude: center.latitude,longitude:center.longitude)
        regionRadius = 4000
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(initialLocation.coordinate,
                                                                  regionRadius * 2.0, regionRadius * 2.0)
        mapView.setRegion(coordinateRegion, animated: true)
        let tri = MKPolygon(coordinates : &coordinates, count: coordinates.count)
        self.mapView.add(tri)
        print("Overlay uploaded")
    }
    
    func mapView(_ mapView: MKMapView!, rendererFor overlay: MKOverlay!) -> MKOverlayRenderer! {
        if overlay is MKPolygon {
            let polygonView = MKPolygonRenderer(overlay: overlay)
            polygonView.strokeColor = UIColor.green
            polygonView.lineWidth = 3
            polygonView.fillColor = UIColor.red.withAlphaComponent(0.5)
            
            return polygonView
        }
        
        return nil
    }
    

    fileprivate func clearAnnotations() {
        for annotation in mapView.annotations {
            mapView.removeAnnotation(annotation)
            
        }
      
    }
    
    func distanceCal(_ coordinates:[CLLocationCoordinate2D]){
        var i = 1
        for coordinate in coordinates{
            if i == 6 {
                i = 0
            }
        let distance = MKMetersBetweenMapPoints(MKMapPointForCoordinate(coordinate), MKMapPointForCoordinate(coordinates[i]))
            distances.append(distance)
        }
    }

}

