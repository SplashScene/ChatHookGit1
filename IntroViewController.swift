//
//  ViewController.swift
//  ChatHook
//
//  Created by Kevin Farm on 5/10/16.
//  Copyright © 2016 splashscene. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation
import FBSDKLoginKit
import Firebase
import FirebaseStorage


class IntroViewController: UIViewController {
    @IBOutlet weak var videoView: UIView!
    var textFieldMultiplier: CGFloat = 1/3
    var userNameTextFieldMultiplier:CGFloat = 1/3
    var loginContainerViewHeightAnchor: NSLayoutConstraint?
    var loginContainerViewCenterAnchor: NSLayoutConstraint?
    var inputsContainerViewHeightAnchor: NSLayoutConstraint?
    var emailTextFieldViewHeightAnchor: NSLayoutConstraint?
    var userNameTextFieldViewHeightAnchor: NSLayoutConstraint?
    var passwordSeparatorViewHeightAnchor: NSLayoutConstraint?
    var passwordTextFieldViewHeightAnchor: NSLayoutConstraint?
    var chatHookLogoViewBottomAnchor: NSLayoutConstraint?
    var userEmail: String?
    var userProvider: String?
    var profileImageChanged: Bool = false
    var alreadyRegistered: Bool = false
    var viewsArray:[UIView]? = []
    var timer: Timer?
    
    let chatHookLogo: UILabel = {
        let logoLabel = UILabel()
            logoLabel.translatesAutoresizingMaskIntoConstraints = false
            logoLabel.alpha = 0.0
            logoLabel.text = "ChatHook"
            logoLabel.font = UIFont(name: FONT_AVENIR_MEDIUM, size:  60.0)
            logoLabel.backgroundColor = UIColor.clear
            logoLabel.textColor = UIColor.white
            logoLabel.sizeToFit()
            logoLabel.layer.shadowOffset = CGSize(width: 3, height: 3)
            logoLabel.layer.shadowOpacity = 0.7
            logoLabel.layer.shadowRadius = 2
            logoLabel.textAlignment = NSTextAlignment.center
        return logoLabel
    }()
    
    lazy var facebookContainerView: UIView = {
        let facebookView = UIView()
            facebookView.translatesAutoresizingMaskIntoConstraints = false
            facebookView.alpha = 0.0
            facebookView.backgroundColor = UIColor.white
            facebookView.layer.cornerRadius = 5.0
            facebookView.layer.shadowColor = UIColor(red: SHADOW_COLOR, green: SHADOW_COLOR, blue: SHADOW_COLOR, alpha: 0.5).cgColor
            facebookView.layer.shadowOpacity = 0.8
            facebookView.layer.shadowRadius = 5.0
            facebookView.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
            facebookView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(fbButtonPressed)))
        return facebookView
    }()
    
    let facebookLogoView: UIImageView = {
        let fbLogo  = UIImageView()
            fbLogo.translatesAutoresizingMaskIntoConstraints = false
            fbLogo.image = UIImage(named:"fb-icon")
        return fbLogo
    }()
    
    let facebookLabel: UILabel = {
        let fbLabel = UILabel()
            fbLabel.translatesAutoresizingMaskIntoConstraints = false
            fbLabel.text = "Login With Facebook"
            fbLabel.font = UIFont(name: FONT_AVENIR_MEDIUM, size:  24.0)
            fbLabel.backgroundColor = UIColor.clear
            fbLabel.textColor = UIColor.blue
            fbLabel.sizeToFit()
            fbLabel.textAlignment = NSTextAlignment.center
        return fbLabel
    }()
    
    lazy var eMailContainerView: UIView = {
        let eMailView = UIView()
            eMailView.translatesAutoresizingMaskIntoConstraints = false
            eMailView.alpha = 0.0
            eMailView.backgroundColor = UIColor.white
            eMailView.layer.cornerRadius = 5.0
            eMailView.layer.shadowColor = UIColor(red: SHADOW_COLOR, green: SHADOW_COLOR, blue: SHADOW_COLOR, alpha: 0.5).cgColor
            eMailView.layer.shadowOpacity = 0.8
            eMailView.layer.shadowRadius = 5.0
            eMailView.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
            eMailView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(eMailButtonPressed)))
        return eMailView
    }()
    
    let eMailLogoView: UIImageView = {
        let eMailLogo  = UIImageView()
            eMailLogo.translatesAutoresizingMaskIntoConstraints = false
            eMailLogo.image = UIImage(named:"letter")
            eMailLogo.contentMode = .scaleAspectFit
        return eMailLogo
    }()
    
    let eMailLabel: UILabel = {
        let emLabel = UILabel()
            emLabel.translatesAutoresizingMaskIntoConstraints = false
            emLabel.text = "Login With Email"
            emLabel.font = UIFont(name: FONT_AVENIR_MEDIUM, size:  24.0)
            emLabel.backgroundColor = UIColor.clear
            emLabel.textColor = UIColor.blue
            emLabel.sizeToFit()
            emLabel.textAlignment = NSTextAlignment.center
        return emLabel
    }()
    
    lazy var profileImageView: MaterialImageView = {
        let imageView = MaterialImageView(frame: CGRect(x: 0, y: 0, width: 125, height: 125))
            imageView.image = UIImage(named: "genericProfile")
            imageView.translatesAutoresizingMaskIntoConstraints = false
            imageView.alpha = 0.0
            imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(pickPhoto)))
            imageView.isUserInteractionEnabled = true
        return imageView
    }()

    let loginContainerView: UIView = {
        let loginView = UIView()
            loginView.translatesAutoresizingMaskIntoConstraints = false
            loginView.alpha = 0.0
            loginView.backgroundColor = UIColor.white
            loginView.layer.cornerRadius = 5.0
            loginView.layer.shadowColor = UIColor(red: SHADOW_COLOR, green: SHADOW_COLOR, blue: SHADOW_COLOR, alpha: 0.5).cgColor
            loginView.layer.shadowOpacity = 0.8
            loginView.layer.shadowRadius = 5.0
            loginView.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        return loginView
    }()
    
    let inputsContainerView: UIView = {
        let view = UIView()
            view.translatesAutoresizingMaskIntoConstraints = false
            view.layer.cornerRadius = 5
            view.layer.masksToBounds = true
        return view
    }()

    let emailTextField: MaterialTextField = {
        let etf = MaterialTextField()
            etf.placeholder = "Email"
            etf.translatesAutoresizingMaskIntoConstraints = false
            etf.autocapitalizationType = .none
        return etf
    }()
    
    let emailSeparatorView: UIView = {
        let view = UIView()
            view.backgroundColor = UIColor(r: 220, g: 220, b: 220)
            view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let passwordSeparatorView: UIView = {
        let view = UIView()
            view.backgroundColor = UIColor(r: 220, g: 220, b: 220)
            view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let passwordTextField: MaterialTextField = {
        let ptf = MaterialTextField()
            ptf.placeholder = "Password"
            ptf.isSecureTextEntry = true
            ptf.autocapitalizationType = .none
            ptf.translatesAutoresizingMaskIntoConstraints = false
        return ptf
    }()
    
    let userNameTextField: MaterialTextField = {
        let ntf = MaterialTextField()
            ntf.placeholder = "User Name"
            ntf.translatesAutoresizingMaskIntoConstraints = false
        return ntf
    }()
    
    lazy var registerButton: MaterialButton = {
        let button = MaterialButton(frame: CGRect(x: 0, y: 0, width: 200, height: 60))
            button.translatesAutoresizingMaskIntoConstraints = false
            button.setTitle("Sign In", for: .normal)
            button.isHidden = true
            button.addTarget(self, action: #selector(handleNewOrReturningUserForLogin), for: UIControlEvents.touchUpInside)
        return button
    }()

    //MARK: - View Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        print("INSIDE INTRO VIEW DID LOAD")
        emailTextField.delegate = self
        userNameTextField.delegate = self
        passwordTextField.delegate = self
        viewsArray = [chatHookLogo, facebookContainerView, eMailContainerView, loginContainerView, profileImageView, registerButton]
    }
    
    
    /*
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("Inside Intro View Will Appear - Outside if")
        if UserDefaults.standard.value(forKey: USER_EMAIL) != nil {
            print("INSIDE INTRO VIEW WILL APPEAR")
           
//            chatHookLogoViewBottomAnchor?.constant = -16
//            facebookContainerView.isHidden = true
//            eMailContainerView.isHidden = true
//            loginContainerView.isHidden = false
//            passwordTextField.text = ""
//            inputsContainerView.isHidden = false
//            registerButton.setTitle("Sign In", for: .normal)
 
        }else {
            self.setupView()
        }
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if UserDefaults.standard.value(forKey: KEY_UID) != nil{
            timer?.invalidate()
            self.timer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(handleReturningUser), userInfo: nil, repeats: false)
        }
    }
    */
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        checkIfAlreadySignedUp()
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)

        NotificationCenter.default.removeObserver(self)
    }

    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
    }
    
    //MARK: - Setup Methods

    
    func setupView(){
        print("INSIDE SETUP VIEW")
        let path = NSURL(fileURLWithPath: Bundle.main.path(forResource: "introVideo", ofType: "mov")!)
        let player = AVPlayer(url: path as URL)
        
        let newLayer = AVPlayerLayer(player: player)
            newLayer.videoGravity = AVLayerVideoGravityResizeAspectFill
            newLayer.masksToBounds = true
            newLayer.frame = view.bounds
        self.videoView.layer.addSublayer(newLayer)
        
        player.play()
        
        player.actionAtItemEnd = AVPlayerActionAtItemEnd.none
        
        NotificationCenter.default.addObserver(self, selector:#selector(IntroViewController.videoDidPlayToEnd), name: NSNotification.Name(rawValue: "AVPlayerItemDidPlayToEndTimeNotification"), object: player.currentItem)
        
        for view in viewsArray!{
            self.videoView.addSubview(view)
        }
        
        setupChatHookLogoView()
        setupFacebookContainerView()
        setupEmailContainerView()
        setupLoginContainerViewNewUser()
        setupProfileImageView()
    }//end func setupView
    
    func hideViews(){
        self.registerButton.isHidden = true
    }
    
    func checkIfAlreadySignedUp(){
        if UserDefaults.standard.value(forKey: USER_EMAIL) == nil && UserDefaults.standard.value(forKey: KEY_UID) == nil{
            print("Inside This is a brand new user")
            self.setupView()
        }else if UserDefaults.standard.value(forKey: USER_EMAIL) != nil && UserDefaults.standard.value(forKey: KEY_UID) == nil{
            print("Inside This user has already signed up but has logged out")
        }else{
            print("Inside This is a returning user")
            self.setupView()
            handleReturningUser()
        }
    }
    
    //MARK: - Login Methods
    func fbButtonPressed(){
        let facebookLogin = FBSDKLoginManager()
            facebookLogin.logIn(withReadPermissions: ["email", "public_profile"], from: nil) { (FBSDKLoginManagerLoginResult, facebookError) in
                if facebookError != nil {
                    print("Facebook login failed. Error: \(facebookError)")
                }else{
                    //let accessToken = FBSDKAccessToken.current().tokenString
                    FBSDKProfile.enableUpdates(onAccessTokenChange: true)
                    
                    let credential = FIRFacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
                        FIRAuth.auth()?.signIn(with: credential, completion: { (user, error) in
                            if error != nil {
                                print("Login Failed. \(error)")
                            }else{
                                let parameters = ["fields": "email, first_name, last_name, name, picture.type(large)"]
                                FBSDKGraphRequest(graphPath: "me", parameters: parameters).start(completionHandler: { (connection, result, error) in
                                    if error != nil{
                                        print(error as Any)
                                        return
                                    }
                                    let result1 = result as? NSDictionary
                                    if let picture = result1?["picture"] as? NSDictionary,
                                       let data = picture["data"] as? NSDictionary,
                                       let url = data["url"] as? String,
                                       let name = result1?["name"] as? String,
                                       let email = result1?["email"] as? String{
                                            
                                        let userData = ["provider": credential.provider,
                                                        "Email": email,
                                                        "UserName": name,
                                                        "ProfileImage": url]
                                        
                                        DataService.ds.createFirebaseUser(uid: user!.uid, user: userData as Dictionary<String, AnyObject> )
                                        
                                        UserDefaults.standard.setValue(user!.uid, forKey: KEY_UID)
                                        self.handleReturningUser()
                                    }
                                })
                            }//end else
                        })//end withCompletionBlock
                }//end else
        }//end facebook login handler
    }
    
    func handleNewOrReturningUserForLogin(){
        print("Inside Handle New or Returning")
        if UserDefaults.standard.value(forKey: USER_EMAIL) != nil{
            attemptLoginAlreadyUser()
        }else{
            attemptLoginNewUser()
        }
    }
    
    func attemptLoginNewUser(){
        print("Inside Login New User")
        if !profileImageChanged { showErrorAlert(title: "Profile Image Required", msg: "You must provide a profile picture.")
            return }
        
        guard let email = emailTextField.text,
              let password = passwordTextField.text,
              let userName = userNameTextField.text else
            
        { showErrorAlert(title: "Email and Password Required", msg: "You must enter an email and password to login")
            return
        }
        //let isNameAlreadyRegistered = checkAlreadyUserName(userName: userName)
        
        self.createAndSignInUser(email: email, password: password, username: userName)
        
        
    }//end method
    
    func checkAlreadyUserName(userName: String) -> Bool {
        var alreadyRegisteredUserName: Bool?
        let userLetterNameRef = DataService.ds.REF_USERS_NAMES.child(String(userName.uppercased()[userName.startIndex])).child(userName.lowercased())
            print("The user name ref is: \(userLetterNameRef)")
            userLetterNameRef.observe(.value, with: { (snapshot) in
                if let _ = snapshot.value as? NSNull{
                    alreadyRegisteredUserName = false
                }else{
                    alreadyRegisteredUserName = true
                }
                }, withCancel: nil)
            return alreadyRegisteredUserName!
    }

    func createAndSignInUser(email: String, password: String, username: String){
        print("Inside Create and Sign In User")
        registerButton.setTitle("Registering...", for: .normal)
        DataService.ds.authUserAndCreateUserEntry(email: email, password: password, username: username, profilePic: self.profileImageView.image!)
        
//        self.profileImageView.isHidden = true
//        self.loginContainerView.isHidden = true
//        self.facebookContainerView.isHidden = false
//        self.eMailContainerView.isHidden = false
//        
//        setupChatHookLogoView()
//        setupFacebookContainerView()
//        setupEmailContainerView()
        handleReturningUser()
    }
    
    func attemptLoginAlreadyUser(){
        print("Inside Already User")
        guard let email = emailTextField.text,
              let password = passwordTextField.text else {
                showErrorAlert(title: "Email and Password Required", msg: "You must enter an email and password to login")
                return
        }
        DataService.ds.authUserAndCreateUserEntry(email: email, password: password, username: nil, profilePic: nil)
    }//end method
    
    //MARK: - Handler Methods
    func handleReturningUser(){
        print("Inside handle returning USER")
        let tabController = MainTabBar()
            tabController.introViewController = self
        present(tabController, animated: true, completion: nil)
    }
    
    func eMailButtonPressed(){
        print("Email button pressed")
        chatHookLogoViewBottomAnchor?.constant = -200
        facebookContainerView.isHidden = true
        eMailContainerView.isHidden = true
            UIView.animate(withDuration: 0.5){
                self.view.layoutIfNeeded()
            }
        
            UIView.animate(withDuration: 0.5,
                           delay: 1.0,
                           options: [],
                           animations: { self.loginContainerView.alpha = 1.0;
                                         self.profileImageView.alpha = 1.0;
                                         self.registerButton.isHidden = false
                                       },
                           completion: nil)
    }
    
    //MARK: - Error Alert
    func showErrorAlert(title: String, msg: String){
        let alert = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }

    //MARK: - Video Played To End
    func videoDidPlayToEnd(notification: NSNotification){
        let player: AVPlayerItem = notification.object as! AVPlayerItem
            player.seek(to: kCMTimeZero)
    }//end func videoDidPlayToEnd
}//end class

extension IntroViewController: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}


