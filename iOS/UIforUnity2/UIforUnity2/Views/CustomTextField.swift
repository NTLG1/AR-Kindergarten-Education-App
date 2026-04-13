//
//  CustomTextField.swift
//  UIforUnity2
//
//  Created by NTLG1 on 7/6/24.
//

import UIKit

class CustomTextField: UITextField {
    
    enum CustomTextFieldType {
        case username
        case email
        case password
    }

    private let authFieldType: CustomTextFieldType
    private let clearButton = UIButton(type: .custom)
    private let passwordToggleButton = UIButton(type: .custom)
    
    init(fieldType: CustomTextFieldType) {
        self.authFieldType = fieldType
        super.init(frame: .zero)
        
        self.backgroundColor = .secondarySystemBackground
        self.layer.cornerRadius = 10
        self.returnKeyType = .done
        self.autocorrectionType = .no
        self.autocapitalizationType = .none
        
        self.leftViewMode = .always
        self.leftView = UIView(frame: CGRect(x: 0, y:0, width: 12, height: self.frame.size.height))
        
        switch fieldType {
        case .username, .email:
            setupClearButton()
        case .password:
            setupPasswordToggleButton()
        }

        setupFieldAttributes()
    }
    
    required init?(coder: NSCoder){
        fatalError("init(coder:) has not been implemented")
    }

    // Common setup for email and username (clear button)
    private func setupClearButton() {
        // Create a container view to add margin/padding
        let containerView = UIView(frame: CGRect(x: 0, y: 0, width: 35, height: 20)) // 15pt margin + 20pt icon width
        clearButton.setImage(UIImage(systemName: "xmark.circle.fill"), for: .normal)
        clearButton.tintColor = .gray
        clearButton.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
        clearButton.addTarget(self, action: #selector(clearText), for: .touchUpInside)
        
        containerView.addSubview(clearButton)
        clearButton.center = containerView.center // Center the button within the container

        self.rightViewMode = .whileEditing
        self.rightView = containerView // Set the container as the right view
    }

    // Setup for password field (toggle visibility button)
    private func setupPasswordToggleButton() {
        // Create a container view to add margin/padding
        let containerView = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: 20)) // 15pt margin + 20pt icon width
        passwordToggleButton.setImage(UIImage(systemName: "eye.fill"), for: .normal)
        passwordToggleButton.tintColor = .gray
        passwordToggleButton.frame = CGRect(x: 0, y: 0, width: 25, height: 20)
        passwordToggleButton.addTarget(self, action: #selector(togglePasswordVisibility), for: .touchUpInside)
        
        containerView.addSubview(passwordToggleButton)
        passwordToggleButton.center = containerView.center // Center the button within the container

        self.rightViewMode = .always
        self.rightView = containerView // Set the container as the right view
    }


    // Clear text action for clear button
    @objc private func clearText() {
        self.text = ""
    }

    // Toggle password visibility action for password field
    @objc private func togglePasswordVisibility() {
        self.isSecureTextEntry.toggle()
        let imageName = self.isSecureTextEntry ? "eye.fill" : "eye.slash.fill"
        passwordToggleButton.setImage(UIImage(systemName: imageName), for: .normal)
    }

    // Setup for field attributes like placeholder, keyboardType, etc.
    private func setupFieldAttributes() {
        switch authFieldType {
        case .username:
            self.placeholder = "Username"
        case .email:
            self.placeholder = "Email Address"
            self.keyboardType = .emailAddress
            self.textContentType = .emailAddress
        case .password:
            self.placeholder = "Password"
            self.textContentType = .oneTimeCode
            self.isSecureTextEntry = true
        }
    }
}

