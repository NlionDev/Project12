//
//  MapViewController.swift
//  InvestImmo
//
//  Created by Nicolas Lion on 20/04/2020.
//  Copyright © 2020 Nicolas Lion. All rights reserved.
//

import UIKit
import MapKit

/// Class for ProjectMapViewController
class ProjectMapViewController: UIViewController {
    
    //MARK: - Properties
    
    /// Property for store 'My position' title
    private let myPositionTitle = "Ma Position"
    
    /// Instance of ErrorAlert for present alert
    private let errorAlert = ErrorAlert()
    
    /// Instance of MapRepository
    private let mapRepository = MapRepository()
    
    /// Array for store saved map Annotations
    private var annotations = [MKAnnotation]()
    
    /// Property for store coordinate of saved estate
    private var estateCoordinate = CLLocationCoordinate2D()
    
    /// Property for store saved adress of specific project
    private var projectAdress: MapAdress?
    
    /// Property for store latitude of France for init Map
    private var latitudeInit: Double = 46.227638
    
    /// Property for store longitude of France for init Map
    private var longitudeInit: Double = 2.213749
    
    /// Instance of CLGeocoder
    private let geoCoder = CLGeocoder()
    
    /// Instance of CLLocationManager
    private let locationManager = CLLocationManager()
    
    /// Property for store coordinate of France for init Map
    private var coordinateInit: CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: latitudeInit, longitude: longitudeInit)}
    
    /// Property to store a selected Project past from SavedProjectsViewController
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
    
    /// Action activated when tap on myPosition Button for get and show user position
    @IBAction private func didTapOnMyPositionButton(_ sender: Any) {
        getPosition()
    }
    
    /// Action activated when tap on estatePosition button for get and show estate position
    @IBAction private func didTapOnEstatePositionButton(_ sender: Any) {
        setupMap(coordinate: estateCoordinate, spanLatitude: 0.1, spanLongitude: 0.1)
    }
    
    /// Action activated when change segmentMapType value and change Map looks
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
    
    /// Action activated when tap on GPS button for launch GPS ( Map or Waze )
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
    
    /// Method for open GPS on Maps with user location in source and estate position in destination
    private func openMaps(coordinate: CLLocationCoordinate2D, adress: String) {
        let source = MKMapItem(coordinate: coordinate, name: myPositionTitle)
        let destination = MKMapItem(coordinate: estateCoordinate, name: adress)
        MKMapItem.openMaps(with: [source, destination], launchOptions: [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving])
    }
    
    /// Method for open GPS on Waze with user location in source and estate position in destination
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

    /// Method for configure page and show or hide maps and label
    private func configurePage() {
        if projectAdress?.name == nil {
            hideMap()
            noDataLabel.isHidden = false
        } else {
            showMap()
            noDataLabel.isHidden = true
        }
    }
    
    /// Method for hide Map and map buttons
    private func hideMap() {
        mapView.isHidden = true
        mapTypeSegment.isHidden = true
        buttonStackView.isHidden = true
    }
    
    /// Method for show Map and map buttons
    private func showMap() {
        mapView.isHidden = false
        mapTypeSegment.isHidden = false
        buttonStackView.isHidden = false
    }
    
    /// Method for configure annotations on map
    @objc private func configureMapViewAnnotations() {
        mapView.removeAnnotations(annotations)
        addAnnotation()
    }
    
    /// Method for add annotions from retrieved project adress
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
    
    /// Method for check if the app is allow to access to user location
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
    
    /// Method for configure map view
    private func setupMap(coordinate: CLLocationCoordinate2D, spanLatitude: Double, spanLongitude: Double) {
         mapView.setCenter(coordinate, animated: true)
         let span = MKCoordinateSpan(latitudeDelta: spanLatitude, longitudeDelta: spanLongitude)
         let region = MKCoordinateRegion(center: coordinate, span: span)
         mapView.setRegion(region, animated: true)
     }
     
    /// Method for get user location and show his position
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

/// Extension of ProjectMapViewController for map and location manager delegate methods
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
