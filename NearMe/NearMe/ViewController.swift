//
//  ViewController.swift
//  NearMe
//
//  Created by Ankit Rouniyar on 13/01/24.
//

import UIKit
import MapKit

class ViewController: UIViewController{

    var locationManager: CLLocationManager?
    private var places: [PlaceAnnotation] = []
    
    lazy var mapView: MKMapView = {
       let map = MKMapView()
        map.showsUserLocation = true
        map.delegate = self
        map.translatesAutoresizingMaskIntoConstraints = false
        return map
    }()
    
    lazy var searchtextField: UITextField = {
        
        let textField = UITextField()
        textField.layer.cornerRadius  = 10
        textField.placeholder = "Search"
        textField.backgroundColor = .white
        textField.delegate = self
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: 0))
        textField.leftViewMode = .always
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLocationManager()
        setupUI()
    }

    private func setupLocationManager() {
        //initialise location manager
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationManager?.requestWhenInUseAuthorization()
        locationManager?.requestLocation()
    }
    
    private func setupUI() {
        view.addSubview(searchtextField)
        view.addSubview(mapView)
        
        view.bringSubviewToFront(searchtextField)
      
        //search text fields constraints
        searchtextField.heightAnchor.constraint(equalToConstant: 45).isActive = true
        searchtextField.widthAnchor.constraint(equalToConstant: view.bounds.width * 0.90).isActive = true
        searchtextField.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        searchtextField.topAnchor.constraint(equalTo: view.topAnchor, constant: 60).isActive = true
        searchtextField.returnKeyType = .go
        
        //map views constraints
        mapView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        mapView.heightAnchor.constraint(equalTo: view.heightAnchor).isActive = true
        mapView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        mapView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
    }
    
    private func showAlert() {
        
        let alertController = UIAlertController(title: "We could not find you",
                                                message: "Please enable location services for this app in Settings.",
                                                preferredStyle: .alert)
        
        let settingAction = UIAlertAction(title: "Settings", style: .default) { action in
            
            if let settingsUrl = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(settingsUrl)
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        alertController.addAction(settingAction)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true)
        
    }
    
    private func checkLocationAuthorization() {
        guard let locationManager,
              let location = locationManager.location else { return }
        
        switch locationManager.authorizationStatus {
        case .authorizedAlways, .authorizedWhenInUse:
            let region = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: 500, longitudinalMeters: 500)
            mapView.setRegion(region, animated: true)
        case .denied:
//            print("")
            showAlert()
        case .notDetermined, .restricted:
            print("")
        default:
            print("")
        }
    }
    
    private func findNearByPlaces(by query: String) {
        
        //remove all annotations
        mapView.removeAnnotations(mapView.annotations)
        
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = query
        request.region = mapView.region
        
        let search = MKLocalSearch(request: request)
        search.start { [weak self] response, error in
            
            guard let response, error == nil else { return }
            print(response)
            self?.places = response.mapItems.map(PlaceAnnotation.init)
            self?.places.forEach { place in
                self?.mapView.addAnnotation(place)
            }
            
            if let places = self?.places {
                self?.presentPlacesList(places: places)
            }

        }
    }
    
    private func presentPlacesList(places: [PlaceAnnotation] ) {
        guard let locationManager,
              let location = locationManager.location else { return }
        
        let placesTableViewController = PlacesTableViewController(userLocation: location,
                                                                  places: places)
        placesTableViewController.modalPresentationStyle = .pageSheet
        
        if let sheet = placesTableViewController.sheetPresentationController {
            sheet.prefersGrabberVisible = true
            sheet.detents = [.medium(), .large()]
            present(placesTableViewController, animated: true)
        }
    }
}

extension ViewController: MKMapViewDelegate {
    
    private func clearAllSelections() {
        self.places = self.places.map({ place in
            place.isSelected = false
            return place
        })
    }
    
    func mapView(_ mapView: MKMapView, didSelect annotation: MKAnnotation) {
        
        //clear all selections
        clearAllSelections()
        guard let selectedAnnotation = annotation as? PlaceAnnotation else { return }
        
        let placeAnnotaiton = self.places.first(where: {$0.id == selectedAnnotation.id })
        
        placeAnnotaiton?.isSelected = true
        presentPlacesList(places: self.places)
    }
    
}

extension ViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        let text = textField.text ?? String()
        if !text.isEmpty {
            textField.resignFirstResponder()
            findNearByPlaces(by: text)
        }
        return true
    }
}

extension ViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        checkLocationAuthorization()
    }
}

