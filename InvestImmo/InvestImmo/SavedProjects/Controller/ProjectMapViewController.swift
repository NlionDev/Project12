//
//  MapViewController.swift
//  InvestImmo
//
//  Created by Nicolas Lion on 20/04/2020.
//  Copyright © 2020 Nicolas Lion. All rights reserved.
//

import UIKit
import MapKit

class ProjectMapViewController: UIViewController {
    
    //MARK: - Properties
    private let myPositionTitle = "Ma Position"
    private let errorAlert = ErrorAlert()
    private let mapRepository = MapRepository()
    private var annotations = [MKAnnotation]()
    private var estateCoordinate = CLLocationCoordinate2D()
    private var projectAdress: MapAdress?
    private var latitudeInit: Double = 46.227638
    private var longitudeInit: Double = 2.213749
    private let geoCoder = CLGeocoder()
    private let locationManager = CLLocationManager()
    private var coordinateInit: CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: latitudeInit, longitude: longitudeInit)}
    var selectedProject: Project?
    
    
    //MARK: - Outlets
    @IBOutlet weak private var mapView: MKMapView!
    @IBOutlet weak private var noDataLabel: UILabel!
    @IBOutlet weak private var mapTypeSegment: UISegmentedControl!
    @IBOutlet weak private var buttonStackView: UIStackView!
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        if let projectName = selectedProject?.name {
            projectAdress = mapRepository.getMapAdressWithProjectName(name: projectName)
        }
        mapView.delegate = self
        mapView.showsUserLocation = true
        getAuthorizationAndDisplayUserLocation()
        configureMapViewAnnotations()
        configurePage()
        setupMap(coordinate: estateCoordinate, spanLatitude: 0.1, spanLongitude: 0.1)
    }
    
    //MARK: - Actions
    
    @IBAction private func didTapOnMyPositionButton(_ sender: Any) {
        getPosition()
    }
    @IBAction private func didTapOnEstatePositionButton(_ sender: Any) {
        setupMap(coordinate: estateCoordinate, spanLatitude: 0.1, spanLongitude: 0.1)
    }
    
    @IBAction private func didChangeMapType(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            mapView.mapType = .standard
        case 1:
            mapView.mapType = .satellite
        case 2:
            mapView.mapType = .hybrid
        default:
            break
        }
    }
    
    @IBAction private func didTapOnGpsButton(_ sender: Any) {
        guard let adress = projectAdress?.adress,
            let position = locationManager.location?.coordinate else {return}
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: MapAlert.waze.message, style: .default, handler: { (alert:UIAlertAction!) -> Void in
            self.openWaze(latitude: self.estateCoordinate.latitude, longitude: self.estateCoordinate.longitude)
        }))
        alert.addAction(UIAlertAction(title: MapAlert.plan.message, style: .default, handler: { (alert:UIAlertAction!) -> Void in
            self.openMaps(coordinate: position, adress: adress)
        }))
        alert.addAction(UIAlertAction(title: MapAlert.cancel.message, style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    //MARK: - Methods
    private func openMaps(coordinate: CLLocationCoordinate2D, adress: String) {
        let source = MKMapItem(coordinate: coordinate, name: myPositionTitle)
        let destination = MKMapItem(coordinate: estateCoordinate, name: adress)
        MKMapItem.openMaps(with: [source, destination], launchOptions: [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving])
    }
    
    private func openWaze(latitude: Double, longitude: Double) {
        if UIApplication.shared.canOpenURL(URL(string: wazeBeginUrl)!) {
            // Waze is installed. Launch Waze and start navigation
            let urlStr = String(format: wazeAppUrl, latitude, longitude)
            UIApplication.shared.open(URL(string: urlStr)!)
        } else {
            // Waze is not installed. Launch AppStore to install Waze app
            UIApplication.shared.open(URL(string: wazeItunesUrl)!)
        }
    }

    private func configurePage() {
        if projectAdress?.name == nil {
            hideMap()
            noDataLabel.isHidden = false
        } else {
            showMap()
            noDataLabel.isHidden = true
        }
    }
    
    private func hideMap() {
        mapView.isHidden = true
        mapTypeSegment.isHidden = true
        buttonStackView.isHidden = true
    }
    
    private func showMap() {
        mapView.isHidden = false
        mapTypeSegment.isHidden = false
        buttonStackView.isHidden = false
    }
    
    @objc private func configureMapViewAnnotations() {
        mapView.removeAnnotations(annotations)
        addAnnotation()
    }
    
    private func addAnnotation() {
        guard let projectAdress = projectAdress,
            let name = projectAdress.name,
            let adress = projectAdress.adress,
            let latitude = projectAdress.latitude?.transformInDouble,
            let longitude = projectAdress.longitude?.transformInDouble else {return}
        let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        estateCoordinate = coordinate
        let annotation = ProjectMapAnnotation(title: name, coordinate: coordinate, info: adress)
        annotations.append(annotation)
        mapView.addAnnotations(annotations)
    }
    
    private func getAuthorizationAndDisplayUserLocation() {
         switch CLLocationManager.authorizationStatus() {
         case .denied, .restricted:
            let alert = errorAlert.alert(message: MapAlert.Unauthorize.message)
             present(alert, animated: true)
         case .notDetermined:
             locationManager.requestWhenInUseAuthorization()
             locationManager.desiredAccuracy = kCLLocationAccuracyBest
             locationManager.delegate = self
             locationManager.startUpdatingLocation()
         default:
             locationManager.desiredAccuracy = kCLLocationAccuracyBest
             locationManager.delegate = self
             locationManager.startUpdatingLocation()
         }
     }
    
    private func setupMap(coordinate: CLLocationCoordinate2D, spanLatitude: Double, spanLongitude: Double) {
         mapView.setCenter(coordinate, animated: true)
         let span = MKCoordinateSpan(latitudeDelta: spanLatitude, longitudeDelta: spanLongitude)
         let region = MKCoordinateRegion(center: coordinate, span: span)
         mapView.setRegion(region, animated: true)
     }
     
     private func getPosition() {
         guard let position = locationManager.location?.coordinate else {return}
         if locationManager.location != nil {
             setupMap(coordinate: position, spanLatitude: 0.1, spanLongitude: 0.1)
         } else {
             setupMap(coordinate: coordinateInit, spanLatitude: 3.0, spanLongitude: 3.0)
         }
     }
}

//MARK: - Extension
extension ProjectMapViewController: MKMapViewDelegate, CLLocationManagerDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard let annotation = annotation as? ProjectMapAnnotation else {return nil}
        let identifier = projectMapAnnotationIdentifier
        var  annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
        if annotationView == nil {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: identifier)
        }
        let adress = UILabel()
        adress.text = annotation.info
        adress.numberOfLines = 0
        adress.font = UIFont(name: poetsenOneFont, size: adressFontSize)
        annotationView?.annotation = annotation
        annotationView?.image = #imageLiteral(resourceName: "bigRedHouse")
        annotationView?.detailCalloutAccessoryView = adress
        annotationView?.canShowCallout = true
        return annotationView
    }
}
