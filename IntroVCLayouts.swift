//
//  IntroVCLayouts.swift
//  ChatHook8
//
//  Created by Kevin Farm on 10/26/16.
//  Copyright © 2016 splashscene. All rights reserved.
//

import UIKit

extension IntroViewController{
    func setupChatHookLogoView(){
        //need x, y, width and height constraints
        chatHookLogo.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        chatHookLogoViewBottomAnchor = chatHookLogo.bottomAnchor.constraint(equalTo: facebookContainerView.topAnchor, constant: -16)
        chatHookLogoViewBottomAnchor?.isActive = true
        UIView.animate(withDuration: 0.5,
                       delay: 1.5,
                       options: [],
                       animations: { self.chatHookLogo.alpha = 1.0 },
                       completion: nil)
        UIView.animate(withDuration: 0.5,
                       delay: 1.5,
                       options: [],
                       animations: { self.facebookContainerView.alpha = 1.0;
                        self.eMailContainerView.alpha = 1.0},
                       completion: nil)
    }
    
    func setupFacebookContainerView(){
        //need x, y, width and height constraints
        facebookContainerView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        facebookContainerView.topAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        facebookContainerView.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -24).isActive = true
        facebookContainerView.heightAnchor.constraint(equalToConstant: 55).isActive = true
        
        facebookContainerView.addSubview(facebookLogoView)
        facebookContainerView.addSubview(facebookLabel)
        
        facebookLogoView.leftAnchor.constraint(equalTo: facebookContainerView.leftAnchor, constant: 8).isActive = true
        facebookLogoView.centerYAnchor.constraint(equalTo: facebookContainerView.centerYAnchor).isActive = true
        facebookLogoView.widthAnchor.constraint(equalToConstant: 45).isActive = true
        facebookLogoView.heightAnchor.constraint(equalToConstant: 45).isActive = true
        
        facebookLabel.centerXAnchor.constraint(equalTo: facebookContainerView.centerXAnchor).isActive = true
        facebookLabel.centerYAnchor.constraint(equalTo: facebookContainerView.centerYAnchor).isActive = true
        facebookLabel.widthAnchor.constraint(equalToConstant: 250).isActive = true
        facebookLabel.heightAnchor.constraint(equalTo: facebookContainerView.heightAnchor).isActive = true
    }
    
    func setupEmailContainerView(){
        //need x, y, width and height constraints
        eMailContainerView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        //eMailContainerView.topAnchor.constraint(equalTo: facebookLoginButton.bottomAnchor, constant: 8).isActive = true
        eMailContainerView.topAnchor.constraint(equalTo: facebookContainerView.bottomAnchor, constant: 8).isActive = true
        eMailContainerView.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -24).isActive = true
        eMailContainerView.heightAnchor.constraint(equalToConstant: 55).isActive = true
        
        eMailContainerView.addSubview(eMailLogoView)
        eMailContainerView.addSubview(eMailLabel)
        
        eMailLogoView.leftAnchor.constraint(equalTo: eMailContainerView.leftAnchor, constant: 8).isActive = true
        eMailLogoView.centerYAnchor.constraint(equalTo: eMailContainerView.centerYAnchor).isActive = true
        eMailLogoView.widthAnchor.constraint(equalToConstant: 45).isActive = true
        eMailLogoView.heightAnchor.constraint(equalToConstant: 45).isActive = true
        
        eMailLabel.centerXAnchor.constraint(equalTo: eMailContainerView.centerXAnchor).isActive = true
        eMailLabel.centerYAnchor.constraint(equalTo: eMailContainerView.centerYAnchor).isActive = true
        eMailLabel.widthAnchor.constraint(equalToConstant: 250).isActive = true
        eMailLabel.heightAnchor.constraint(equalTo: eMailContainerView.heightAnchor).isActive = true
    }
    
    func setupLoginContainerViewNewUser(){
        //need x, y, width and height constraints
        loginContainerView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        loginContainerViewCenterAnchor = loginContainerView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 0)
        loginContainerViewCenterAnchor?.isActive = true
        loginContainerView.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -24).isActive = true
        loginContainerViewHeightAnchor = loginContainerView.heightAnchor.constraint(equalToConstant: 174)
        loginContainerViewHeightAnchor?.isActive = true
        
        loginContainerView.addSubview(inputsContainerView)
        
        inputsContainerView.centerXAnchor.constraint(equalTo: loginContainerView.centerXAnchor).isActive = true
        inputsContainerView.centerYAnchor.constraint(equalTo: loginContainerView.centerYAnchor).isActive = true
        inputsContainerView.widthAnchor.constraint(equalTo: loginContainerView.widthAnchor, constant: -24).isActive = true
        inputsContainerViewHeightAnchor = inputsContainerView.heightAnchor.constraint(equalToConstant: 150)
        inputsContainerViewHeightAnchor?.isActive = true
        
        inputsContainerView.addSubview(emailTextField)
        inputsContainerView.addSubview(emailSeparatorView)
        inputsContainerView.addSubview(userNameTextField)
        inputsContainerView.addSubview(passwordSeparatorView)
        inputsContainerView.addSubview(passwordTextField)
        
        emailTextField.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor).isActive = true
        emailTextField.topAnchor.constraint(equalTo: inputsContainerView.topAnchor).isActive = true
        emailTextField.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        emailTextFieldViewHeightAnchor = emailTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: textFieldMultiplier)
        emailTextFieldViewHeightAnchor?.isActive = true
        
        emailSeparatorView.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor).isActive = true
        emailSeparatorView.topAnchor.constraint(equalTo: emailTextField.bottomAnchor).isActive = true
        emailSeparatorView.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        emailSeparatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        userNameTextField.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor).isActive = true
        userNameTextField.topAnchor.constraint(equalTo: emailSeparatorView.bottomAnchor).isActive = true
        userNameTextField.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        userNameTextFieldViewHeightAnchor = userNameTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: userNameTextFieldMultiplier)
        userNameTextFieldViewHeightAnchor?.isActive = true
        
        passwordSeparatorView.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor).isActive = true
        passwordSeparatorView.topAnchor.constraint(equalTo: userNameTextField.bottomAnchor).isActive = true
        passwordSeparatorView.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        passwordSeparatorViewHeightAnchor = passwordSeparatorView.heightAnchor.constraint(equalToConstant: 1)
        passwordSeparatorViewHeightAnchor?.isActive = true
        
        passwordTextField.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor).isActive = true
        passwordTextField.topAnchor.constraint(equalTo: passwordSeparatorView.bottomAnchor).isActive = true
        passwordTextField.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        passwordTextFieldViewHeightAnchor = passwordTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: textFieldMultiplier)
        passwordTextFieldViewHeightAnchor?.isActive = true
        
        setupRegisterButton()
    }
    
    func setupRegisterButton(){
        registerButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        registerButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -8).isActive = true
        registerButton.widthAnchor.constraint(equalToConstant: 200).isActive = true
        registerButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
    }
    
    func setupSeparatorView(){
        
    }
    
    func setupProfileImageView(){
        profileImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        profileImageView.bottomAnchor.constraint(equalTo: loginContainerView.topAnchor, constant: -8).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 125).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 125).isActive = true
    }
}
