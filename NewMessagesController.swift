//
//  NewMessagesController.swift
//  ChatHook
//
//  Created by Kevin Farm on 8/22/16.
//  Copyright © 2016 splashscene. All rights reserved.
//

import UIKit
import Firebase
import CoreLocation

class NewMessagesController: UITableViewController {

    var messagesController: MessagesController?
    let cellID = "cellID"
    var groupedUsersArray = [GroupedUsers]()
    var blockedUsersArray = [String]()
    var usersArray1 = [User]()
    var usersArray2 = [User]()
    var usersArray3 = [User]()
    var userLat: Double?
    var userLong: Double?
    var timer: Timer?
    
    //MARK: - View Methods
    let noPeopleBackground: UIImageView = {
        var noPeopleBkgd = UIImageView()
        noPeopleBkgd.translatesAutoresizingMaskIntoConstraints = false
        noPeopleBkgd.image = UIImage(named: "NoPeopleBackground")
        noPeopleBkgd.contentMode = .scaleAspectFill
        noPeopleBkgd.clipsToBounds = true
        noPeopleBkgd.isUserInteractionEnabled = true
        
        return noPeopleBkgd
    }()
    
    func setupNoPeopleBackground(){
        noPeopleBackground.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        noPeopleBackground.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -16).isActive = true
        noPeopleBackground.widthAnchor.constraint(equalToConstant: view.frame.size.width).isActive = true
        noPeopleBackground.heightAnchor.constraint(equalToConstant: view.frame.size.height).isActive = true
    }
    override func viewDidLoad() {
        
        super.viewDidLoad()
        navigationItem.title = "People Near You"
        
        tableView.register(UserCell.self, forCellReuseIdentifier: "cellID")
        blockedUsersArray = []
        messagesController = MessagesController()
        noPeopleBackground.frame = view.bounds
        view.addSubview(noPeopleBackground)
        setupNoPeopleBackground()
        observeUsersOnline()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print("Inside View Will Appear")
        super.viewWillAppear(animated)
        handleReloadTable()
    }
    
    //MARK: - Observe Methods
    func observeUsersOnline(){
        
        groupedUsersArray = []
        blockedUsersArray = []
        usersArray1 = []
        usersArray2 = []
        usersArray3 = []

        let searchLatInteger = Int(CurrentUser._location.coordinate.latitude)
        let searchLongInteger = Int(CurrentUser._location.coordinate.longitude)

        let getMyLatitudeAndLongitudeRange = DataService.ds.REF_USERSONLINE.child("\(searchLatInteger)").child("\(searchLongInteger)")
        
        
        getMyLatitudeAndLongitudeRange.observe(.childAdded, with: { (snapshot) in
            let theirUserID = snapshot.key
            var theirUserLocation: CLLocation?
            
            let individualUserInMyLatitudeAndLongitudeRange = getMyLatitudeAndLongitudeRange.child(theirUserID)
            
            individualUserInMyLatitudeAndLongitudeRange.observeSingleEvent(of: .value, with: { (snapshot) in
                if let dictionary = snapshot.value as? [String: AnyObject]{
                    
                    theirUserLocation = CLLocation(latitude: dictionary["userLatitude"] as! Double,longitude: dictionary["userLongitude"] as! Double)
                    
                    let getIndividualUserInformation = DataService.ds.REF_USERS.child(theirUserID)
                    
                        getIndividualUserInformation.observeSingleEvent(of: .value, with: { (snapshot) in
                            if let dictionary = snapshot.value as? [String: AnyObject]{
                                let theirUniqueID = snapshot.key
                                let user = User(postKey: theirUniqueID, dictionary: dictionary)
                                    user.location = theirUserLocation
                                if let didIBlockThisUser = CurrentUser._blockedUsersArray?.contains(user.postKey){
                                    user.isBlocked = didIBlockThisUser
                                }
                            
                    let didTheyBlockMe = getIndividualUserInformation.child("blocked_users").child(CurrentUser._postKey)
                            
                        didTheyBlockMe.observe(.value, with: { (snapshot) in
                                if let _ = snapshot.value as? NSNull{ //They didn't block me so proceed
                                    if user.postKey != CurrentUser._postKey{
                                        let distanceFromMeDict = self.messagesController!.calculateDistance(otherLocation: user.location)
                                        let distance = distanceFromMeDict["DistanceDouble"] as! Double
                                        user.distance = distance
                                        
                                        self.loadDistanceArrays(distanceDouble: user.distance!, user: user)
                                        
                                        self.attemptLoadOfSections()
                                        print("Past attempt to load sections")
                                    }
                                    
                                }else{
                                    print("\(user.userName) cock blocked me")
                                }
                            }, withCancel: nil)
                    }
                }, withCancel: nil)
                }
                }, withCancel: nil)
            
            }, withCancel: nil)
    }
    
    //MARK: - Load Handlers
    func loadDistanceArrays(distanceDouble: Double, user: User){
        switch distanceDouble{
            case 0...0.999:
                self.usersArray1.append(user)
                print("Added to UsersArray1")
                self.usersArray1.sort(by: { (user1, user2) -> Bool in
                    return user1.distance! < user2.distance!
                })
                if self.usersArray1.count > 0 { self.noPeopleBackground.isHidden = true }
            case 1.0...5.0:
                self.usersArray2.append(user)
                self.usersArray2.sort(by: { (user1, user2) -> Bool in
                    return user1.distance! < user2.distance!
                })
                if self.usersArray2.count > 0 { self.noPeopleBackground.isHidden = true }
            default:
                self.usersArray3.append(user)
                self.usersArray3.sort(by: { (user1, user2) -> Bool in
                    return user1.distance! < user2.distance!
                })
                if self.usersArray3.count > 0 { self.noPeopleBackground.isHidden = true }
            }
    }
    
    func loadSections(){
        if usersArray1.count > 0 {
            self.groupedUsersArray.append(GroupedUsers(sectionName: "Within a mile", sectionUsers: self.usersArray1))
            print("Grouped Users Array Count is: \(groupedUsersArray.count)")
        }
        if usersArray2.count > 0 {
            self.groupedUsersArray.append(GroupedUsers(sectionName: "Within 5 miles", sectionUsers: self.usersArray2))
        }
        if usersArray3.count > 0 {
            self.groupedUsersArray.append(GroupedUsers(sectionName: "Over 5 miles", sectionUsers: self.usersArray3))
        }        
        handleReloadTable()
    }
    
    private func attemptLoadOfSections(){
        self.timer?.invalidate()
        self.timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.loadSections), userInfo: nil, repeats: false)
    }
    
    func handleReloadTable(){
        DispatchQueue.main.async{
            self.tableView.reloadData()
        }
    }
    
    func handleCancel(){
        dismiss(animated: true, completion: nil)
    }
    
    func showProfileControllerForUser(user: User){
        let profileController = ProfileViewController()
            profileController.selectedUser = user
        
        let navController = UINavigationController(rootViewController: profileController)
        present(navController, animated: true, completion: nil)
    }
    
    func showChatControllerForUser(user: User){
        let chatLogController = ChatViewController()
            chatLogController.senderId = CurrentUser._postKey
            chatLogController.senderDisplayName = CurrentUser._userName
            chatLogController.user = user
        
        var img: UIImage?
        if let url = user.profileImageUrl{
            img = imageCache.object(forKey: url as NSString) as UIImage?
        }
        
        chatLogController.messageImage = img
        
        let navController = UINavigationController(rootViewController: chatLogController)
        present(navController, animated: true, completion: nil)
        ///navigationController?.pushViewController(chatLogController, animated: true)
        
    }

    
    //MARK: - TableView Methods
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        print("The count of grouped users array is: \(groupedUsersArray.count)")
        return groupedUsersArray.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groupedUsersArray[section].sectionUsers.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath as IndexPath) as! UserCell
        
            let user = groupedUsersArray[indexPath.section].sectionUsers[indexPath.row]
            
            if let stringDistance = user.distance {
                let unwrappedString = String(format: "%.2f", (stringDistance))
                let distanceString = "\(unwrappedString) miles away"
                cell.detailTextLabel?.text = distanceString
            }
            
                if user.isBlocked == true{
                    cell.blockedUserContainerView.isHidden = false
                }else{
                    cell.blockedUserContainerView.isHidden = true
                }
            
            cell.textLabel?.text = user.userName
            cell.accessoryType = UITableViewCellAccessoryType.detailButton
            
            if let profileImageUrl = user.profileImageUrl{
                cell.profileImageView.loadImageUsingCacheWithUrlString(urlString: profileImageUrl)
            }
            return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            let user = self.groupedUsersArray[indexPath.section].sectionUsers[indexPath.row]
            print("The user for chat controller is: \(user.userName)")
            self.showChatControllerForUser(user: user)
    }

    override func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        print("Inside Accessory Button Tapped")
        let user = self.groupedUsersArray[indexPath.section].sectionUsers[indexPath.row]
        self.showProfileControllerForUser(user: user)
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        print("Inside Title For Header")
        return groupedUsersArray[section].sectionName
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        print("Inside Height For Row At IndexPath")
        return 72
    }
    
}



