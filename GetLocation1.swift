//
//  CurrentLocationViewcontrollerViewController.swift
//  ChatHook
//
//  Created by Kevin Farm on 6/10/16.
//  Copyright © 2016 splashscene. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import Firebase


class GetLocation1: UIViewController {
    
    var locationManager:CLLocationManager? = nil
    let regionRadius:CLLocationDistance = 5000
    var userLocation: CLLocation?
    var otherUsersLocations: [UserLocation] = []
    var locationArray1: [UserLocation] = []
    var locationArray2: [UserLocation] = []
    var locationArray3: [UserLocation] = []
    
    var zoneDistanceCheck: [[UserLocation]] = []
    var userOnline: Bool = false
    
    var userLatInt: Int!
    var userLngInt: Int!
    
    //let currentUserRef = DataService.ds.REF_USER_CURRENT
    var blockedUsers: [String] = []
    var locationArray:[CLLocation] = []
    var timer: Timer!
    var locationTimer: Timer!
    var arrayCounter: Int = 0
    var overlayAlpha: CGFloat?
    var overlayColor: UIColor?
    
    
    //MARK: - Objects

    let mapView: MKMapView = {
        let map = MKMapView()
            map.translatesAutoresizingMaskIntoConstraints = false
        return map
    }()
    
    let topView: UIView = {
        let view = UIView()
            view.translatesAutoresizingMaskIntoConstraints = false
            view.backgroundColor = UIColor.red
        return view
    }()
    
    lazy var logoutButton: UIButton = {
        let logButton = UIButton()
            logButton.translatesAutoresizingMaskIntoConstraints = false
            logButton.setTitle("Logout", for: .normal)
            logButton.titleLabel?.textColor = UIColor.white
            logButton.titleLabel?.font = UIFont(name: FONT_AVENIR_MEDIUM, size: 14.0)
            logButton.addTarget(self, action: #selector(handleLogout), for: .touchUpInside)
            logButton.isHidden = true
        return logButton
    }()
    
    let onlineLabel: UILabel = {
        let msgLabel = UILabel()
            msgLabel.translatesAutoresizingMaskIntoConstraints = false
            msgLabel.font = UIFont(name: FONT_AVENIR_MEDIUM, size:  18.0)
            msgLabel.backgroundColor = UIColor.clear
            msgLabel.textColor = UIColor.white
            msgLabel.text = "Getting Location..."
            msgLabel.sizeToFit()
        return msgLabel
    }()
 
    //MARK: - View Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(topView)
        view.addSubview(mapView)
        
        locationManager = CLLocationManager()
        locationManager?.allowsBackgroundLocationUpdates = true
        self.mapView.delegate = self
        self.locationManager?.delegate = self
        self.locationManager?.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        checkAuthorizationStatus()
        //zoneDistanceCheck = [locationArray1,locationArray2,locationArray3]
    
        setupUI()
        handleLocationTimer()
        print("The CURRENT USER IS: \(DataService.ds.REF_USER_CURRENT)")
        
        
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
    }
    
    //MARK: - Setup Methods
    func checkAuthorizationStatus(){
        let authStatus = CLLocationManager.authorizationStatus()
            switch(authStatus){
                case .notDetermined: locationManager?.requestWhenInUseAuthorization(); print("In Auth switch statement1");return
                case .denied: showLocationServicesDeniedAlert(); print("In Auth switch statement2");return
                case .restricted: showLocationServicesDeniedAlert(); print("In Auth switch statement3"); return
                default:
                    if authStatus != .authorizedWhenInUse{
                        locationManager?.requestWhenInUseAuthorization()
                    }else{
                        locationManager?.requestLocation()
                    }
            }//end switch
    }//end checkAuthorizationStatus
    
    func setupUI(){
        topView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        topView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        topView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        topView.heightAnchor.constraint(equalToConstant: 70).isActive = true
        
        topView.addSubview(onlineLabel)
        topView.addSubview(logoutButton)
        
        onlineLabel.rightAnchor.constraint(equalTo: topView.rightAnchor, constant: -8).isActive = true
        onlineLabel.centerYAnchor.constraint(equalTo: topView.centerYAnchor).isActive = true
        
        logoutButton.leftAnchor.constraint(equalTo: topView.leftAnchor, constant: 8).isActive = true
        logoutButton.centerYAnchor.constraint(equalTo: topView.centerYAnchor).isActive = true
        logoutButton.widthAnchor.constraint(equalToConstant: 60).isActive = true
        logoutButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        mapView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        mapView.topAnchor.constraint(equalTo: topView.bottomAnchor).isActive = true
        mapView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        mapView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
    
    func userIsOnline(){
        userOnline = true
        logoutButton.isHidden = false
        onlineLabel.text = "Online"
        topView.backgroundColor = UIColor(r: 80, g: 101, b: 161)
        
        if let currentUserLocation = CurrentUser._location{
             userLatInt = Int(currentUserLocation.coordinate.latitude)
             userLngInt = Int(currentUserLocation.coordinate.longitude)
            
            let usersOnlineRef = DataService.ds.REF_BASE.child("users_online").child("\(userLatInt!)").child("\(userLngInt!)").child(CurrentUser._postKey)
            let userLocal = ["userLatitude":currentUserLocation.coordinate.latitude, "userLongitude": currentUserLocation.coordinate.longitude]
            usersOnlineRef.setValue(userLocal)
            observeOtherUsersLocations()
        }
        
        centerMapOnLocation(location: CurrentUser._location!)
        self.mapView.showsUserLocation = true
    }
    
    func handleLocationTimer(){
        if locationTimer != nil{
            locationTimer.invalidate()
        }
        self.locationTimer = Timer.scheduledTimer(timeInterval: 180.0, target: self, selector: #selector(self.handleCheckLocation), userInfo: nil, repeats: true)

    }

    //MARK: - Observe Methods
    func fetchCurrentUser(userLocation: CLLocation){
        print("In fetchCurrentUser")
        print("My Latitude is: \(userLocation.coordinate.latitude) and my Latitude is: \(userLocation.coordinate.longitude)")
        let uid = UserDefaults.standard.value(forKey: KEY_UID) as! String
        let currUser = URL_BASE.child("users").child(uid)
        
        currUser.observeSingleEvent(of: .value, with: { (snapshot) in
            print("The current user ref is: \(currUser)")
            if let dictionary = snapshot.value as? [String: AnyObject]{
                CurrentUser._blockedUsersArray = []
                CurrentUser._postKey = snapshot.key
                CurrentUser._userName = dictionary["UserName"] as! String
                CurrentUser._location = userLocation
                CurrentUser._profileImageUrl = dictionary["ProfileImage"] as? String
                
                let blockedUsersRef = currUser.child("blocked_users")
                    blockedUsersRef.observe(.value, with: { (snapshot) in
                        if let snapshots = snapshot.children.allObjects as? [FIRDataSnapshot]{
                            for snap in snapshots{
                                let blockedUserID = snap.key
                                CurrentUser._blockedUsersArray?.append(blockedUserID)
                            }
                        }
                    },
                    withCancel: nil)
                
                self.userIsOnline()
            }else{
                print("I aint got no dictionary dickhead")
            }
        }, withCancel: nil)
    }
    
    
    //MARK: - Handlers
    
    func handleCheckLocation(){
        print("Checking Location")
        locationManager?.requestLocation()
    }
    
    func attemptHandleOverlays(){
        self.timer?.invalidate()
        self.timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.handleOverlays), userInfo: nil, repeats: false)
    }
    
    func handleOverlays(){
        print("Inside Handle Overlays")
            handleAnnotations()
            let overlays = self.mapView.overlays
            self.mapView.removeOverlays(overlays)
            for i in 0..<self.zoneDistanceCheck.count{
                if self.zoneDistanceCheck[i].count > 1 && self.zoneDistanceCheck[i].count <= 3{
                    let midPoint:Int = self.zoneDistanceCheck[i].count / 2
                    let centerLocation = self.zoneDistanceCheck[i][midPoint]
                    overlayColor = UIColor(r: 255, g: 255, b: 0)
                    overlayAlpha = 0.15
                    self.addRadiusCircle(location: centerLocation.location)
                }
                if self.zoneDistanceCheck.count == 4 || zoneDistanceCheck.count == 5{
                    let midPoint:Int = self.zoneDistanceCheck[i].count / 2
                    let centerLocation = self.zoneDistanceCheck[i][midPoint]
                    overlayColor = UIColor(r: 255, g: 165, b: 0)
                    overlayAlpha = 0.15
                    self.addRadiusCircle(location: centerLocation.location)
                }
                if self.zoneDistanceCheck[i].count > 5{
                    let midPoint:Int = self.zoneDistanceCheck[i].count / 2
                    let centerLocation = self.zoneDistanceCheck[i][midPoint]
                    overlayColor = UIColor(r: 255, g: 0, b: 0)
                    overlayAlpha = 0.15
                    self.addRadiusCircle(location: centerLocation.location)
                }
            }
    }
    
    func observeOtherUsersLocations(){
        print("The count of ZoneDistanceArray is: \(zoneDistanceCheck.count)")
        otherUsersLocations = []
        zoneDistanceCheck = []
        print("In observeOtherUsersLocations")
        print("The count of zone distance check is: \(zoneDistanceCheck.count)")
        let otherUsersLocationsRef = DataService.ds.REF_USERSONLINE.child("\(userLatInt!)").child("\(userLngInt!)")
        otherUsersLocationsRef.observe(.childAdded, with: { (snapshot) in
            if let dictionary = snapshot.value as? [String: AnyObject]{
                let otherUserId = snapshot.key
                let otherUserLat = dictionary["userLatitude"] as! Double
                let otherUserLong = dictionary["userLongitude"] as! Double
                
                let otherUsersRef = DataService.ds.REF_USERS.child(otherUserId)
                    otherUsersRef.observeSingleEvent(of: .value, with: { (snapshot) in
                        if let userDict = snapshot.value as? [String: AnyObject]{
                            let otherUserName = userDict["UserName"] as! String
                            let otherUserImageUrl = userDict["ProfileImage"] as! String
                            
                            
                            let otherUserLocation = UserLocation(latitude: otherUserLat, longitude: otherUserLong, name: otherUserName, imageName: otherUserImageUrl)
                            
                            self.otherUsersLocations.append(otherUserLocation)
                            self.timer?.invalidate()
                            self.timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.groupOtherUsers), userInfo: nil, repeats: false)

                            
                            print("The COUNT of otherUserLocations array is: \(self.otherUsersLocations.count)")
                        }
                    }, withCancel: nil)
            }
            
            //self.groupOtherUsers()
            //self.handleOtherUsers(snapshot: snapshot)
            
        }, withCancel: nil)
        
        otherUsersLocationsRef.observe(.childRemoved, with: { (snapshot) in
            print("Inside child REMOVED")
            self.groupOtherUsers()
            //self.handleOtherUsers(snapshot: snapshot)
            self.mapView.setCenter(CurrentUser._location.coordinate, animated: true)
        }, withCancel: nil)
        
    }

    func groupOtherUsers(){
        print("The count of otherUserLocations is: \(otherUsersLocations.count)")
        print("Inside groupOtherUsers")
        zoneDistanceCheck = []
        var firstsArray: [UserLocation] = []
        
        
        for i in 0..<otherUsersLocations.count{
            var matched: Bool = false
            if i == 0{
                firstsArray.append(otherUsersLocations[i])
                print("I put \(otherUsersLocations[i].name) in the first array")
                continue
            }
            
            for t in 0..<firstsArray.count{
                let calcDistance = calculateDistance(zoneLocation: firstsArray[t], otherLocation: otherUsersLocations[i])
                if calcDistance <= 0.5{
                    matched = true
                    break
                }
            }
            
            if matched == true{
                continue
            }else{
                firstsArray.append(otherUsersLocations[i])
            }
        }
        
        for first in firstsArray{
            let newArray = [first]
            zoneDistanceCheck.append(newArray)
        }
        
        for i in 0..<otherUsersLocations.count{
            for t in 0..<firstsArray.count{
                if otherUsersLocations[i].name == firstsArray[t].name{ break }
                
                let calcDistance = calculateDistance(zoneLocation: firstsArray[t], otherLocation: otherUsersLocations[i])
                if calcDistance <= 0.5 {
                    zoneDistanceCheck[t].append(otherUsersLocations[i])
                    break
                }
            }
        }
        for array in zoneDistanceCheck{
            print("The count of the internal array is: \(array.count)")
        }
        
        attemptHandleOverlays()
    }
    
    func handleAnnotations(){
        self.mapView.addAnnotations(self.otherUsersLocations)
    }
    
    func handleLoadingBlockedUsers(){
        CurrentUser._blockedUsersArray = blockedUsers
        print("Current User blocked array count is: \(CurrentUser._blockedUsersArray?.count)")
    }
    
    func handleLogout(){
        do{
            let usersOnlineRef = DataService.ds.REF_BASE.child("users_online").child("\(userLatInt)").child("\(userLngInt)").child(CurrentUser._postKey)
            usersOnlineRef.removeValue()
            UserDefaults.standard.removeObject(forKey: KEY_UID)
            
            try FIRAuth.auth()?.signOut()
        }catch let logoutError{
            print(logoutError)
        }
        dismiss(animated: true, completion: nil)
    }
    
    func calculateDistance(zoneLocation: UserLocation, otherLocation: UserLocation) -> Double {
        
        let arrayLocation = zoneLocation.location
        let distanceInMeters = arrayLocation.distance(from: otherLocation.location)
        let distanceInMiles = (distanceInMeters / 1000) * 0.62137
        
        return distanceInMiles
    }
    
    func checkDistanceForMe(storedLocation: CLLocation, currentLocation: CLLocation) -> Bool{
        let distanceInMeters = storedLocation.distance(from: currentLocation)
        let distanceInMiles = (distanceInMeters / 1000) * 0.62137
        return distanceInMiles >= 0.10 ? true : false
    }
}//end class


//MARK: - CLLocationManagerDelegate
extension GetLocation1: CLLocationManagerDelegate{
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Location did fail with error")
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("In location didUpdateLocations")
                if userLocation == nil{
                    userLocation = locations.first
                    //userLocation = CLLocation(latitude: 41.92413, longitude: -88.161242)
                    if CurrentUser._location == nil {
                        print("I don't even have a user")
                    }
                    if userLocation != nil{
                        fetchCurrentUser(userLocation: userLocation!)
                        if let items = self.tabBarController!.tabBar.items as [UITabBarItem]!{
                            for barTabItem in items{
                                barTabItem.isEnabled = true
                            }
                        }
                    }else{
                        print("I got NO location")
                    }
                   centerMapOnLocation(location: userLocation!)
                }else{
                    print("In didUpdateLocation but user has location")
                    if let newLocation = locations.first,
                        let storedLocation = CurrentUser._location{
                        print("Inside new location if let")
                        let haveIMoved = checkDistanceForMe(storedLocation: storedLocation, currentLocation: newLocation)
                        if haveIMoved == true{
                            CurrentUser._location = newLocation
                            let newLocationLatInt = Int(newLocation.coordinate.latitude)
                            let newLocationLngInt = Int(newLocation.coordinate.longitude)
                            let usersOnlineRef = DataService.ds.REF_BASE.child("users_online").child("\(newLocationLatInt)").child("\(newLocationLngInt)").child(CurrentUser._postKey)
                            
                            usersOnlineRef.observe(.value, with: { (snapshot) in
                                if let _ = snapshot.value as? NSNull{
                                    let userLocal = ["userLatitude":newLocation.coordinate.latitude, "userLongitude": newLocation.coordinate.longitude]
                                    usersOnlineRef.setValue(userLocal)
                                }else{
                                    usersOnlineRef.child("userLatitude").setValue(newLocation.coordinate.latitude)
                                    usersOnlineRef.child("userLongitude").setValue(newLocation.coordinate.longitude)
                                }
                            }, withCancel: nil)
                            
                        }else{
                            print("I haven't moved a muscle")
                        }
                        
                    }
                    
                }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        print("In locationDidChangeAuthorizationStatus")
        if status == .authorizedAlways || status == .authorizedWhenInUse{
            locationManager?.requestLocation()
        }
    }
   
    func showLocationServicesDeniedAlert(){
        print("In showLocationServicesDeniedAlert")
        let alert = UIAlertController(title: "Location Services Disabled", message: "Please enable location services for this app in Settings", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
}//end extension

//MARK: - Map View Delegate Functions

extension GetLocation1: MKMapViewDelegate{
    func centerMapOnLocation(location:CLLocation){
        let radiusFactor = userOnline ? 2 : 8
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, regionRadius * Double(radiusFactor), regionRadius * Double(radiusFactor))
        mapView.setRegion(coordinateRegion, animated: true)
    }
   
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
            if (annotation is MKUserLocation){ return nil }
        
            var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "otherLocation") as? MKPinAnnotationView
            if annotationView == nil{
                annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "otherLocation")
            }else{
                annotationView?.annotation = annotation
            }
        
        //if let user = annotation as? User, let image = user.profile
        
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        if let loc = userLocation.location{
            print("MAP VIEW LOCATION is: \(userLocation.coordinate.latitude) and \(userLocation.coordinate.longitude)")
            centerMapOnLocation(location: loc)
            //addRadiusCircle(loc)
        }
    }
    
    
    //MARK: - Overlay Functions
    func addRadiusCircle(location: CLLocation){
        print("Inside Radius Circle")
            let circle = MKCircle(center: location.coordinate, radius: 750 as CLLocationDistance)
            self.mapView.add(circle)
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        print("Inside mapView overlay")
        let circle = MKCircleRenderer(overlay: overlay)
            circle.strokeColor = UIColor.red
        
        if let circleColor = overlayColor,
            let circleAlpha = overlayAlpha{
                circle.alpha = circleAlpha
                circle.fillColor = circleColor
        }
            circle.lineWidth = 1.0
        return circle
    }
    
    
    
}//end extension
