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
    
    private let errorAlert = ErrorAlert()
    private var realmRepo = RealmRepository()
    private var annotations = [MKAnnotation]()
    private var estateCoordinate = CLLocationCoordinate2D()
    private var projectAdress: MapAdress?
    private var latitudeInit: Double = 46.227638
    private var longitudeInit: Double = 2.213749
    private var userPosition: CLLocation?
    private let geoCoder = CLGeocoder()
    private let locationManager = CLLocationManager()
    private var coordinateInit: CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: latitudeInit, longitude: longitudeInit)}
    var selectedProject: Project?
    
    
    //MARK: - Outlets
    
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var adressTitleLabel: UILabel!
    @IBOutlet weak var adressButton: UIButton!
    @IBOutlet weak var noDataLabel: UILabel!
    @IBOutlet weak var mapTypeSegment: UISegmentedControl!
    @IBOutlet weak var myPositionButton: UIButton!
    @IBOutlet weak var estatePositionButton: UIButton!
    
    
    //MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        if let projectName = selectedProject?.name {
            projectAdress = realmRepo.getMapAdressWithProjectName(name: projectName)
        }
        mapView.delegate = self
        getAuthorizationAndDisplayUserLocation()
        configureMapViewAnnotations()
        configurePage()
        setupMap(coordinate: estateCoordinate, spanLatitude: 0.1, spanLongitude: 0.1)
    }
    
    //MARK: - Actions
    
    @IBAction func didTapOnMyPositionButton(_ sender: Any) {
        getPosition()
    }
    @IBAction func didTapOnEstatePositionButton(_ sender: Any) {
        setupMap(coordinate: estateCoordinate, spanLatitude: 0.1, spanLongitude: 0.1)
    }
    
    @IBAction func didChangeMapType(_ sender: UISegmentedControl) {
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
    
    @IBAction func didTapOnAdressButton(_ sender: Any) {
        guard let adress = projectAdress?.adress else {return}
        guard let position = locationManager.location?.coordinate else {return}
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Waze", style: .default, handler: { (alert:UIAlertAction!) -> Void in
            self.openWaze(latitude: self.estateCoordinate.latitude, longitude: self.estateCoordinate.longitude)
        }))
        alert.addAction(UIAlertAction(title: "Plan", style: .default, handler: { (alert:UIAlertAction!) -> Void in
            self.openMaps(coordinate: position, adress: adress)
        }))
        alert.addAction(UIAlertAction(title: "Annuler", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    //MARK: - Methods
    
    private func openMaps(coordinate: CLLocationCoordinate2D, adress: String) {
        let source = MKMapItem(coordinate: coordinate, name: "Ma Position")
        let destination = MKMapItem(coordinate: estateCoordinate, name: adress)
        MKMapItem.openMaps(with: [source, destination], launchOptions: [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving])
    }
    
    private func openWaze(latitude: Double, longitude: Double) {
        if UIApplication.shared.canOpenURL(URL(string: "waze://")!) {
            
            // Waze is installed. Launch Waze and start navigation
            let urlStr = String(format: "waze://?ll=%f,%f&navigate=yes", latitude, longitude)
            UIApplication.shared.open(URL(string: urlStr)!)
        } else {
            
            // Waze is not installed. Launch AppStore to install Waze app
            UIApplication.shared.open(URL(string: "http://itunes.apple.com/us/app/id323229106")!)
        }
    }
    
    private func displayEstateAdress() {
        guard let projectAdress = projectAdress else {return}
        if let adress = projectAdress.adress {
            adressButton.setTitle(adress, for: .normal)
            adressButton.titleLabel?.lineBreakMode = .byWordWrapping
            adressButton.titleLabel?.numberOfLines = 2
        }
        
    }
    
    private func configurePage() {
        if projectAdress == nil {
            hideMap()
            adressTitleLabel.isHidden = true
            adressButton.isHidden = true
            noDataLabel.isHidden = false
        } else {
            showMap()
            displayEstateAdress()
            adressTitleLabel.isHidden = false
            adressButton.isHidden = false
            noDataLabel.isHidden = true
        }
    }
    
    private func hideMap() {
        mapView.isHidden = true
        mapTypeSegment.isHidden = true
        myPositionButton.isHidden = true
        estatePositionButton.isHidden = true
    }
    
    private func showMap() {
        mapView.isHidden = false
        mapTypeSegment.isHidden = false
        myPositionButton.isHidden = false
        estatePositionButton.isHidden = false
    }
    
    @objc private func configureMapViewAnnotations() {
        mapView.removeAnnotations(annotations)
        addAnnotation()
    }
    
    private func addAnnotation() {
        guard let projectAdress = projectAdress else {return}
        guard let name = projectAdress.name,
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
             let alert = errorAlert.alert(message: "Invest'Immo ne pourra pas mettre à jour votre position sur la carte sans avoir accès à votre localisation.")
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
        let identifier = "pma"
        var  annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
        if annotationView == nil {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: identifier)
        }
        let adress = UILabel()
        adress.text = annotation.info
        adress.numberOfLines = 0
        adress.font = UIFont(name: "Poetsen One", size: 13)
        annotationView?.annotation = annotation
        annotationView?.image = #imageLiteral(resourceName: "bigRedHouse")
        annotationView?.detailCalloutAccessoryView = adress
        annotationView?.canShowCallout = true
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        
        
    }
    
}
