//
//  MainTabBar.swift
//  ChatHook
//
//  Created by Kevin Farm on 8/22/16.
//  Copyright © 2016 splashscene. All rights reserved.
//

import UIKit

class MainTabBar: UITabBarController {
    
    
    var introViewController = IntroViewController()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let mapViewController = GetLocation1()
        let messagesViewController = MessagesController()
        let postsViewController = RoomsViewController()
        let profileViewController = ProfileViewController()
        let peopleViewController = NewMessagesController()
        let chatNavController = UINavigationController(rootViewController: messagesViewController)
        let peepsNavController = UINavigationController(rootViewController: peopleViewController)
        let postsNavController = UINavigationController(rootViewController: postsViewController)
        let profileNavController = UINavigationController(rootViewController: profileViewController)
        
        mapViewController.title = "Home"
        mapViewController.tabBarItem.image = UIImage(named: "GlobeIcon25")
        mapViewController.tabBarItem.isEnabled = true
        
        messagesViewController.title = "Chat"
        messagesViewController.tabBarItem.image = UIImage(named: "ChatIcon25")
        messagesViewController.tabBarItem.isEnabled = false
        
        peepsNavController.title = "People"
        peepsNavController.tabBarItem.image = UIImage(named: "peeps")
        peepsNavController.tabBarItem.isEnabled = false
        
        postsViewController.title = "Rooms"
        postsViewController.tabBarItem.image = UIImage(named: "language_icon")
        postsViewController.tabBarItem.isEnabled = false
        
        profileViewController.title = "Profile"
        profileViewController.tabBarItem.image = UIImage(named: "ProfileIcon25")
        profileViewController.tabBarItem.isEnabled = false
        
        viewControllers = [mapViewController, peepsNavController, chatNavController, postsNavController, profileNavController]
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print("I am in main tab bar")
        super.viewWillAppear(animated)
        self.tabBar.barTintColor = UIColor.white
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
