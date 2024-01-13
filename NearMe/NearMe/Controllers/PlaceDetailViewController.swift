//
//  PlaceDetailViewController.swift
//  NearMe
//
//  Created by Ankit Rouniyar on 13/01/24.
//

import Foundation
import UIKit

final class PlaceDetailViewController: UIViewController {
    
    let place: PlaceAnnotation
    
    lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.font = .preferredFont(forTextStyle: .title1)
        return label
    }()
    
    lazy var addressLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.font = .preferredFont(forTextStyle: .body)
        label.alpha = 0.5
        return label
    }()
    
    lazy var directionButton: UIButton = {
        
        let button = UIButton(configuration: UIButton.Configuration.bordered())
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(didTapDirectionButton), for: .touchUpInside)
        button.setTitle("Directions", for: .normal)
        return button
    }()
    
    lazy var callButton: UIButton = {
        
        let button = UIButton(configuration: UIButton.Configuration.bordered())
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(didTapCallButton), for: .touchUpInside)
        button.setTitle("Call", for: .normal)
        return button
    }()
    
    init(place: PlaceAnnotation) {
        self.place = place
        super.init(nibName: nil, bundle: nil)
        setupUI()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        
        let stackView = UIStackView()
        stackView.alignment = .leading
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.spacing = 8
        stackView.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 20, leading: 20, bottom: 20, trailing: 20)
        
        nameLabel.text = place.name
        addressLabel.text = place.address
        nameLabel.widthAnchor.constraint(equalToConstant: view.bounds.width - 20).isActive = true
        
        let directionAndCallButtonStack = UIStackView()
        directionAndCallButtonStack.axis = .horizontal
        directionAndCallButtonStack.isLayoutMarginsRelativeArrangement = true
        directionAndCallButtonStack.translatesAutoresizingMaskIntoConstraints = false
        directionAndCallButtonStack.spacing = 20
        directionAndCallButtonStack.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 20, leading: 20, bottom: 20, trailing: 20)
        directionAndCallButtonStack.addArrangedSubview(directionButton)
        directionAndCallButtonStack.addArrangedSubview(callButton)
        
        
        stackView.addArrangedSubview(nameLabel)
        stackView.addArrangedSubview(addressLabel)
        stackView.addArrangedSubview(directionAndCallButtonStack)
        
       
        view.addSubview(stackView)
        
    }
    
    @objc private func didTapCallButton(_ sender: UIButton) {
     
        let phone = place.phone.formatForPhoneCall
        guard let url = URL(string: "tel://\(phone)") else { return }
        UIApplication.shared.open(url)
    }
    
    @objc private func didTapDirectionButton(_ sender: UIButton) {
        let cordinate = place.location.coordinate
        guard let url = URL(string: "http://maps.apple.com/?daddr=\(cordinate.latitude),\(cordinate.longitude)") else { return }
        
        UIApplication.shared.open(url)
    }
    
    
}
