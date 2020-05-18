//
//  MapViewController.swift
//  InvestImmo
//
//  Created by Nicolas Lion on 23/04/2020.
//  Copyright © 2020 Nicolas Lion. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController {
    
    //MARK: - Properties
    private let errorAlert = ErrorAlert()
    private let searchAdressPopUp = MapSearchAdressPopUp()
    private let projectRepository = ProjectRepository()
    private let mapRepository = MapRepository()
    private let mapExistantProject = MapExistantProjectPopUp()
    private let mapNewProject = MapNewProjectPopUp()
    private var annotations = [MKAnnotation]()
    private var searchedAdress = String()
    private var searchResultLatitude = String()
    private var searchResultLongitude = String()
    private var latitudeInit: Double = 46.227638
    private var longitudeInit: Double = 2.213749
    private let geoCoder = CLGeocoder()
    private let locationManager = CLLocationManager()
    private var coordinateInit: CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: latitudeInit, longitude: longitudeInit)}
    
    //MARK: - Outlets
    @IBOutlet weak private var mapView: MKMapView!
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        mapView.showsUserLocation = true
        getAuthorizationAndDisplayUserLocation()
        setupMap(coordinate: coordinateInit, spanLatitude: 10, spanLongitude: 10)
        configureMapViewAnnotations()
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
    
    @IBAction private func didTapOnMyPositionButton(_ sender: Any) {
        getPosition()
    }

    @IBAction private func didTapOnSearchAdressButton(_ sender: Any) {
        let popUp = searchAdressPopUp.alert(delegate: self)
        present(popUp, animated: true)
    }
    
    @IBAction private func didTapOnAddAdressButton(_ sender: Any) {
        NotificationCenter.default.addObserver(self, selector: #selector(self.configureMapViewAnnotations), name: NSNotification.Name(rawValue: mapNotificationName), object: nil)
        if searchedAdress == "" {
            let alert = errorAlert.alert(message: MapAlert.adressMissing.message)
            present(alert, animated: true)
        } else {
            if projectRepository.myProjects.count == 0 {
               
                let popUp = mapNewProject.alert(adress: searchedAdress, latitude: searchResultLatitude, longitude: searchResultLongitude)
                present(popUp, animated: true)
            } else {
                let popUp = mapExistantProject.alert(adress: searchedAdress, latitude: searchResultLatitude, longitude: searchResultLongitude)
                present(popUp, animated: true)
            }
        }
    }
    
    //MARK: - Methods
    
    @objc private func configureMapViewAnnotations() {
        mapView.removeAnnotations(annotations)
        addSomeAnnotations()
    }
    
    private func addSomeAnnotations() {
        for mapAdress in mapRepository.myAdresses {
            guard let name = mapAdress.name,
                let adress = mapAdress.adress,
                let latitude = mapAdress.latitude?.transformInDouble,
                let longitude = mapAdress.longitude?.transformInDouble else {return}
            let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
            let annotation = ProjectMapAnnotation(title: name, coordinate: coordinate, info: adress)
            annotations.append(annotation)
        }
        
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
extension MapViewController: MKMapViewDelegate, CLLocationManagerDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard let annotation = annotation as? ProjectMapAnnotation else {return nil}
        let identifier = projectMapAnnotationIdentifier
        var  annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
        if annotationView == nil {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: identifier)
        }
        let adress = UILabel()
        adress.text = annotation.info
        adress.font = UIFont(name: poetsenOneFont, size: adressFontSize)
        adress.numberOfLines = 0
        annotationView?.annotation = annotation
        annotationView?.image = #imageLiteral(resourceName: "bigRedHouse")
        annotationView?.detailCalloutAccessoryView = adress
        annotationView?.canShowCallout = true
        return annotationView
    }
    
}

extension MapViewController: SearchAdressPopUpVCDelegate {
    
    func searchAdressPopUpVC(_ searchAdressPopUpVC: SearchAdressPopUpVC, adress: String) {
        geoCoder.geocodeAddressString(adress) { (placemarks, error) in
            guard let placemark = placemarks?.first else {return}
            if error != nil {
                let alert = self.errorAlert.alert(message: MapAlert.incorrectAdress.message)
                self.present(alert, animated: true)
            } else {
                if let coordinate = placemark.location?.coordinate {
                    self.searchedAdress = adress
                    self.searchResultLatitude = String(coordinate.latitude)
                    self.searchResultLongitude = String(coordinate.longitude)
                    self.setupMap(coordinate: coordinate, spanLatitude: 0.001, spanLongitude: 0.001)
                }
            }
        }
    }
    
    
}
