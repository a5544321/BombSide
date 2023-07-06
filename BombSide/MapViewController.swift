//
//  ViewController.swift
//  BombSide
//
//  Created by Andy on 2017/4/13.
//  Copyright © 2017年 com.andy. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

let APIKEY = "AIzaSyBzO7VXg-6h-x_fTSkCCTkvyZW5GRSjFbg"
let cellID = "cellID"



class MapViewController: UIViewController , MKMapViewDelegate, CLLocationManagerDelegate, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var labelAddress: UILabel!
    @IBOutlet weak var mMapView: MKMapView!
    
    let locationManager = CLLocationManager();
    let ceo = CLGeocoder();
    var mTableView: UITableView? = nil
    
    var placeResults = [Place?]()
    
    
    
    @IBOutlet weak var buttonGotoLocation: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Disable swipe back
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        
        self.title = "地 點"
        
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white,
                                                                   NSAttributedString.Key.font: UIFont(name: "HanziPenTC-W5", size: 20)!]
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 126/255.0, green: 74/255.0, blue: 22/255.0, alpha: 1)
        self.navigationController?.navigationBar.tintColor = UIColor.white
        
        locationManager.delegate = self;
        locationManager.distanceFilter = kCLLocationAccuracyNearestTenMeters;
        locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        
        mMapView.delegate = self
        mMapView.showsUserLocation = true
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(MapViewController.showTableView))
        labelAddress.addGestureRecognizer(tap)
        
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // 1. 還沒有詢問過用戶以獲得權限
        if CLLocationManager.authorizationStatus() == .notDetermined {
            locationManager.requestWhenInUseAuthorization()
        }
            // 2. 用戶不同意
        else if CLLocationManager.authorizationStatus() == .denied {
            print("Location services were previously denied. Please enable location services for this app in Settings.")
        }
            // 3. 用戶已經同意
        else if CLLocationManager.authorizationStatus() == .authorizedAlways || CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            locationManager.startUpdatingLocation()
        }
        buttonGotoLocation.sendActions(for: .touchUpInside)
        
    }
    
    //--------------------------------------------------------------------------------
    // MARK: - Map Delegate
    //--------------------------------------------------------------------------------
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("location update \(String(describing: locations.last?.coordinate))" );
        mMapView.setCenter((locations.first?.coordinate)!, animated: true)
    }
    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        print("region change")
        let location = CLLocation(latitude: mapView.centerCoordinate.latitude, longitude: mapView.centerCoordinate.longitude)
        ceo.reverseGeocodeLocation(location)
        { (placemarks, error) in
            if (placemarks != nil)
            {
                if let stringPlace = (placemarks?.first?.addressDictionary?["FormattedAddressLines"] as? NSArray)?.firstObject as? String{
                    print(stringPlace)
                    self.labelAddress.text = stringPlace
                    self.labelAddress.sizeToFit()
                }else{
                    self.labelAddress.text = "Unkown"
                }
                
            }
        }
        
    }
    
    
    func mapView(_ mapView: MKMapView, regionWillChangeAnimated animated: Bool) {
        labelAddress.text = "處理中..."
        hideTableView()
    }
    
//    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
//        
//    }
    
    //MARK: - TableView delegate
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if placeResults.count <= 0 {
            let label = UILabel(frame: tableView.frame)
            label.textAlignment = .center
            label.textColor = UIColor.gray
            label.text = "無結果"
            tableView.backgroundView = label
        }
        else{
            tableView.backgroundView = nil
        }
        return placeResults.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "附近地點"
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print("sention \(indexPath.section)  row \(indexPath.row)")
        var cell: UITableViewCell? = tableView.dequeueReusableCell(withIdentifier: cellID)
        if cell == nil {
            cell = UITableViewCell(style: .subtitle, reuseIdentifier: cellID)
        }
        cell?.textLabel?.text = placeResults[indexPath.row]?.name
        cell?.detailTextLabel?.text = placeResults[indexPath.row]?.address
//        cell?.detailTextLabel?.text = "654654"
        return cell!
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detail: AddDetailConditionViewController = self.storyboard?.instantiateViewController(withIdentifier: "detail") as! AddDetailConditionViewController
        detail.strAddress = labelAddress.text!
        detail.strLocation = (placeResults[indexPath.row]?.name!)!
        detail.place = placeResults[indexPath.row]
        
        self.show(detail, sender: nil)
    }
    
    //-----------------
    // MARK: - Self Method
    //-----------------
    
    @objc func showTableView() {
        if mTableView == nil{
            mTableView = UITableView(frame: CGRect(x: 0, y: ScreenSize.height * 0.5, width: ScreenSize.width, height: ScreenSize.height * 0.5))
            mTableView?.delegate = self as UITableViewDelegate
            mTableView?.dataSource = self
//            mTableView?.register(UITableViewCell.self, forCellReuseIdentifier: cellID)
            mTableView?.translatesAutoresizingMaskIntoConstraints = false
            self.mTableView?.tableFooterView = UIView(frame: CGRect.zero)
            self.view.addSubview(mTableView!)
        }
        
        print("screen \(ScreenSize.height)  view \(self.view.frame.maxY)")
        
        UIView.animate(withDuration: 0.8) {
            self.mTableView?.frame.origin.y = self.view.frame.height - ScreenSize.height * 0.5
        }
        googlePlaceRequest()
        
    }
    
    func hideTableView() {
        if let tbView = mTableView{
            UIView.animate(withDuration: 0.4, animations: {
                tbView.frame.origin.y = ScreenSize.height
            })
        }
    }
    
    func googlePlaceRequest() {
        let url = URL(string: "https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=\(mMapView.centerCoordinate.latitude),\(mMapView.centerCoordinate.longitude)&radius=200&types=address&key=\(APIKEY)")
        
        NetworkAction.searchPlace(url: url!) { (jsonDict, error) in
            guard error == nil else{
                showAlert(vc: self, title: "Error", message: "error occured")
                return
            }
            
            if jsonDict!["status"] as! String != "OK"
            {
                showAlert(vc: self, title: "Fail", message: jsonDict!["status"] as! String)
                return
            }
            if let results = jsonDict?["results"] as? [[String:Any]]
            {
                DispatchQueue.main.async
                {
                    self.placeResults.removeAll()
                    for dic: Dictionary in results {
                        if let place = Place.init(json: dic){
                            self.placeResults.append(place)
                        }
                    }
                    self.mTableView?.reloadData()
                }
            }
        }
        
    }
    
    func gotoDetailVC() {
        
        
    }
    
    
    //-----------------
    // MARK: - Button click
    //-----------------

    @IBAction func currentBtnPress(_ sender: UIButton) {
        
        guard let location = locationManager.location else {
            return
        }
        
        let span :MKCoordinateSpan = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        let region = MKCoordinateRegion(center: (location.coordinate), span: span)
        
        mMapView.setRegion(region, animated: true)
        
    }
    
    
    
    

}

func showAlert(vc: UIViewController, title: String, message: String) {
    let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
    let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
    alert.addAction(okAction)
    vc.present(alert, animated: true, completion: nil)
}
