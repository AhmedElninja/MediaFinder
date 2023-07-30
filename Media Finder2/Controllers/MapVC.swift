//
//  MapVC.swift
//  Media Finder2
//
//  Created by Ahmed Alaa on 08/05/2023.
//

import MapKit

protocol addressDelegation: class {
    func sendAddress(address: String)
}

class MapVC: UIViewController {
    
    // MARK: - Outlets.
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    
    
    // MARK: - Proprepties
    private var locationManger = CLLocationManager()
    weak var delegate: addressDelegation?

    
    // MARK: - LifeCycle Methods.
    override func viewDidLoad() {
        super.viewDidLoad()
        checkLocationServices()
        mapView.delegate = self
    }
//    override func viewWillAppear(_ animated: Bool) {
//        self.navigationController?.navigationBar.isHidden = true
//    }
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false
    }
    // MARK: - Actions.
    @IBAction func sumbintBtnTapped(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
        delegate?.sendAddress(address: addressLabel.text ?? "")
    }
}

// MARK: - MKMapViewDelegate.
extension MapVC: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        let lat = mapView.centerCoordinate.latitude
        let long = mapView.centerCoordinate.longitude
        let location: CLLocation = CLLocation(latitude: lat, longitude: long)
        getAddressName(location: location)
    }
}

// MARK: - Private Methods.
extension MapVC {
    private func getAddressName(location: CLLocation) {
        let gepCoder: CLGeocoder = CLGeocoder()
        gepCoder.reverseGeocodeLocation(location) { placeMarks, error in
            if let error = error {
                print(error.localizedDescription)
            } else if let firstPlaceMark = placeMarks?.first  {
                self.addressLabel.text = firstPlaceMark.compactAddress ?? "N/A"
            }
        }
    }
    private func checkLocationServices() {
        if CLLocationManager.locationServicesEnabled() {
            checkLocationAuthorisation()
        } else {
             print("Please, Open Locatoion Services (GPS)")
        }
    }
    private func getLocation() {
        let location = CLLocation(latitude: 30.096655, longitude: 31.662533)
        let region = MKCoordinateRegion(center: location.coordinate ,
                                        latitudinalMeters: 10000,
                                        longitudinalMeters: 10000)
        mapView.setRegion(region, animated: true)
        getAddressName(location: location)
    }
    private func getCurrentLoction(){
        if let location = locationManger.location?.coordinate {
            let region = MKCoordinateRegion(center: location,
                                            latitudinalMeters: 10000,
                                            longitudinalMeters: 10000)
            mapView.setRegion(region, animated: true)
            getAddressName(location: locationManger.location!)
        }
    }
    private func checkLocationAuthorisation() {
        switch CLLocationManager.authorizationStatus() {
        case .authorizedAlways, .authorizedWhenInUse:
            getLocation()
        case .restricted, .denied:
            print("Can Not Get Your Location!")
         case .notDetermined:
            locationManger.requestWhenInUseAuthorization()
        default:
            print("Can Not Get Your Location!")
        }
    }
}

