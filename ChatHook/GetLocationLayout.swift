//
//  GetLocationLayout.swift
//  ChatHook
//
//  Created by Kevin Farm on 11/11/16.
//  Copyright © 2016 splashscene. All rights reserved.
//

import UIKit

extension GetLocation1{
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
}
