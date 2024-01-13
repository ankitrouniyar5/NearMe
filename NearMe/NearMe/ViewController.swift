//
//  ViewController.swift
//  NearMe
//
//  Created by Ankit Rouniyar on 13/01/24.
//

import UIKit
import MapKit

class ViewController: UIViewController {

    lazy var mapView: MKMapView = {
       let map = MKMapView()
        map.showsUserLocation = true
        map.translatesAutoresizingMaskIntoConstraints = false
        return map
    }()
    
    lazy var searchtextField: UITextField = {
        
        let textField = UITextField()
        textField.layer.cornerRadius  = 10
        textField.placeholder = "Search"
        textField.backgroundColor = .white
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
        textField.leftViewMode = .always
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .red
        setupUI()
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

}

