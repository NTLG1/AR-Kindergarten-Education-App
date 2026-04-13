//
//  LoginViewController.swift
//  UIforUnity2
//
//  Created by NTLG1 on 7/6/24.
//

import Combine
import UIKit

class LoginViewController: UIViewController {

    var viewModel: SignInViewModel!
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - UI Components
       private let headerView = AuthHeaderView(title: "Sign In", subTitle: "Sign in to your account")
       
       private let emailField = CustomTextField(fieldType: .email)
       private let passwordField = CustomTextField(fieldType: .password)
       
       private let signInButton = CustomButton(title: "Sign In", hasBackground: true, fontSize: .big)
       private let newUserButton = CustomButton(title: "New User? Create Account.", fontSize: .med)
       private let forgotPasswordButton = CustomButton(title: "Forgot Password?", fontSize: .small)
    
//        private let skipLogin = UIButton(type: .system)
       
       // MARK: - LifeCycle
       override func viewDidLoad() {
           super.viewDidLoad()
           self.setupUI()
           
           self.signInButton.addTarget(self, action: #selector(didTapSignIn), for: .touchUpInside)
           self.newUserButton.addTarget(self, action: #selector(didTapNewUser), for: .touchUpInside)
           self.forgotPasswordButton.addTarget(self, action: #selector(didTapForgotPassword), for: .touchUpInside)
           
//           self.skipLogin.setTitle("Use the app without login", for: .normal)
//           self.skipLogin.addTarget(self, action: #selector(loginTapped), for: .touchUpInside)
       }
       
       override func viewWillAppear(_ animated: Bool) {
           super.viewWillAppear(animated)
           self.navigationController?.navigationBar.isHidden = true
       }
       
       // MARK: - UI Setup
       private func setupUI() {
           self.view.backgroundColor = .systemBackground
           
           self.view.addSubview(headerView)
           self.view.addSubview(emailField)
           self.view.addSubview(passwordField)
           self.view.addSubview(signInButton)
           self.view.addSubview(newUserButton)
           self.view.addSubview(forgotPasswordButton)
//           self.view.addSubview(skipLogin)
           
           headerView.translatesAutoresizingMaskIntoConstraints = false
           emailField.translatesAutoresizingMaskIntoConstraints = false
           passwordField.translatesAutoresizingMaskIntoConstraints = false
           signInButton.translatesAutoresizingMaskIntoConstraints = false
           newUserButton.translatesAutoresizingMaskIntoConstraints = false
           forgotPasswordButton.translatesAutoresizingMaskIntoConstraints = false
//           skipLogin.translatesAutoresizingMaskIntoConstraints = false

           NSLayoutConstraint.activate([
               self.headerView.topAnchor.constraint(equalTo: self.view.layoutMarginsGuide.topAnchor),
               self.headerView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
               self.headerView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
               self.headerView.heightAnchor.constraint(equalToConstant: 222),
               
               self.emailField.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 12),
               self.emailField.centerXAnchor.constraint(equalTo: headerView.centerXAnchor),
               self.emailField.heightAnchor.constraint(equalToConstant: 55),
               self.emailField.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.85),
               
               self.passwordField.topAnchor.constraint(equalTo: emailField.bottomAnchor, constant: 22),
               self.passwordField.centerXAnchor.constraint(equalTo: headerView.centerXAnchor),
               self.passwordField.heightAnchor.constraint(equalToConstant: 55),
               self.passwordField.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.85),
               
               self.signInButton.topAnchor.constraint(equalTo: passwordField.bottomAnchor, constant: 22),
               self.signInButton.centerXAnchor.constraint(equalTo: headerView.centerXAnchor),
               self.signInButton.heightAnchor.constraint(equalToConstant: 55),
               self.signInButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.85),
               
               self.newUserButton.topAnchor.constraint(equalTo: signInButton.bottomAnchor, constant: 11),
               self.newUserButton.centerXAnchor.constraint(equalTo: headerView.centerXAnchor),
               self.newUserButton.heightAnchor.constraint(equalToConstant: 44),
               self.newUserButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.85),
               
               self.forgotPasswordButton.topAnchor.constraint(equalTo: newUserButton.bottomAnchor, constant: 6),
               self.forgotPasswordButton.centerXAnchor.constraint(equalTo: headerView.centerXAnchor),
               self.forgotPasswordButton.heightAnchor.constraint(equalToConstant: 44),
               self.forgotPasswordButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.85),
               
//               self.skipLogin.centerXAnchor.constraint(equalTo: view.centerXAnchor),
//               self.skipLogin.topAnchor.constraint(equalTo: forgotPasswordButton.bottomAnchor, constant: 12)
           ])

       }
       
//       // MARK: - Selectors
//        @objc private func didTapSignIn() {
//            let mainVC = HomeViewController(dataArray: <#DataArray#>)
//            let navigationController = UINavigationController(rootViewController: mainVC)
//
//            guard let window = UIApplication.shared.windows.first else { return }
//            window.rootViewController = navigationController
//            UIView.transition(with: window, duration: 0.5, options: .transitionCrossDissolve, animations: nil, completion: nil)
//        }
    
    // MARK: - Selectors
    @objc private func didTapSignIn() {
        let userRequest = SignInUserRequest(
            email: self.emailField.text ?? "",
            password: self.passwordField.text ?? ""
        )
        
        // Email check
        if !Validator.isValidEmail(for: userRequest.email) {
            AlertManager.showInvalidEmailAlert(on: self)
            return
        }
        
        // Password check
        if !Validator.isPasswordValid(for: userRequest.password) {
            AlertManager.showInvalidPasswordAlert(on: self)
            return
        }
        
        guard let request = Endpoint.signIn(userRequest: userRequest).request else { return }
        
        AuthService.fetch(request: request) { [weak self] result in
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                
                switch result {
                case .success(_):
                    if let sceneDelegate = self.view.window?.windowScene?.delegate as? SceneDelegate {
                        sceneDelegate.checkAuthentication()
                    }
                    
                case .failure(let error):
                    guard let error = error as? ServiceError else { return }
                    
                    switch error {
                    case .serverError(let string),
                            .unknown(let string),
                            .decodingError(let string):
                        AlertManager.showSignInErrorAlert(on: self, with: string)
                    }
                }
            }
        }
    }
   
    @objc private func didTapSignIn2() {
        let userRequest = SignInUserRequest(
            email: self.emailField.text ?? "",
            password: self.passwordField.text ?? ""
        )
        
        // Email check
        if !Validator.isValidEmail(for: userRequest.email) {
            AlertManager.showInvalidEmailAlert(on: self)
            return
        }
        
        // Password check
        if !Validator.isPasswordValid(for: userRequest.password) {
            AlertManager.showInvalidPasswordAlert(on: self)
            return
        }
        
        // Perform network call on background thread using Combine
        viewModel.signIn(userRequest: userRequest)
            .subscribe(on: DispatchQueue.global(qos: .background)) // Background thread for network call
            .receive(on: DispatchQueue.main) // Receive on main thread for UI updates
            .sink(receiveCompletion: { [weak self] completion in
                switch completion {
                case .failure(let error):
                    guard let error = error as? ServiceError else { return }
                    switch error {
                    case .serverError(let string),
                         .unknown(let string),
                         .decodingError(let string):
                        AlertManager.showSignInErrorAlert(on: self!, with: string)
                    }
                case .finished:
                    break
                }
            }, receiveValue: { [weak self] _ in
                guard let self = self else { return }
                if let sceneDelegate = self.view.window?.windowScene?.delegate as? SceneDelegate {
                    sceneDelegate.checkAuthentication()
                }
            })
            .store(in: &viewModel.cancellables)
    }

    @objc private func didTapNewUser() {
        let vc = RegisterController()
        let navigationController = UINavigationController(rootViewController: vc)

        guard let window = UIApplication.shared.windows.first else { return }
        window.rootViewController = navigationController
        UIView.transition(with: window, duration: 0.5, options: .transitionFlipFromLeft, animations: nil, completion: nil)
    }
  
    @objc private func didTapForgotPassword() {
        let vc = ForgotPasswordController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
//        @objc private func didTapForgotPassword() {
//            let vc = ForgotPasswordController()
//            let navigationController = UINavigationController(rootViewController: vc)
//
//            guard let window = UIApplication.shared.windows.first else { return }
//            window.rootViewController = navigationController
//            UIView.transition(with: window, duration: 0.5, options: .transitionFlipFromLeft, animations: nil, completion: nil)
//        }
    
//        @objc func loginTapped() {
//            // Simulate a successful login and transition to the main view controller
//            let mainVC = HomeViewController(dataArray: <#DataArray#>)
//            let navigationController = UINavigationController(rootViewController: mainVC)
//    //        navigationController.navigationBar.barTintColor = .blue
//            
//            // Use a cross-dissolve transition
//            guard let window = UIApplication.shared.windows.first else { return }
//            window.rootViewController = navigationController
//            UIView.transition(with: window, duration: 0.5, options: .transitionCrossDissolve, animations: nil, completion: nil)
//        }

