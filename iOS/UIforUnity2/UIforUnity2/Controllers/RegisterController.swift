//
//  RegisterController.swift
//  UIforUnity2
//
//  Created by NTLG1 on 8/6/24.
//

import UIKit
import Combine

class RegisterController: UIViewController {
    
    var viewModel: SignUpViewModel!
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - UI Components
    private let headerView = AuthHeaderView(title: "Sign Up", subTitle: "Create your account")
    
    private let usernameField = CustomTextField(fieldType: .username)
    private let emailField = CustomTextField(fieldType: .email)
    private let passwordField = CustomTextField(fieldType: .password)
    
    private let signUpButton = CustomButton(title: "Sign Up", hasBackground: true, fontSize: .big)
    private let signInButton = CustomButton(title: "Already have an account? Sign In.", fontSize: .med)
    
//    private let termsTextView: UITextView = {
//        let tv = UITextView()
//        tv.text = "By creating an account, you agree to our Terms & Conditions and you acknowledge that you have read our Privacy Policy."
//        tv.backgroundColor = .clear
//        tv.textColor = .label
//        tv.isSelectable = true
//        tv.isEditable = false
//        tv.isScrollEnabled = false
//        return tv
//    }()
    
    private let termsTextView: UITextView = {
        let attributedString = NSMutableAttributedString(string: "By creating an account, you agree to our Terms & Conditions and you acknowledge that you have read our Privacy Policy.")
        
        attributedString.addAttribute(.link, value: "terms://termsAndConditions", range: (attributedString.string as NSString).range(of: "Terms & Conditions"))
        
        attributedString.addAttribute(.link, value: "privacy://privacyPolicy", range: (attributedString.string as NSString).range(of: "Privacy Policy"))
        
        let tv = UITextView()
        attributedString.addAttribute(.font, value: UIFont.systemFont(ofSize: 17), range: (attributedString.string as NSString).range(of: "By creating an account, you agree to our Terms & Conditions and you acknowledge that you have read our Privacy Policy."))
        tv.linkTextAttributes = [.foregroundColor: UIColor.systemBlue]
        tv.backgroundColor = .clear
        tv.attributedText = attributedString
        tv.textColor = .label
        tv.isSelectable = true
        tv.isEditable = false
        tv.delaysContentTouches = false
        tv.isScrollEnabled = false
        return tv
    }()
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
        
        self.termsTextView.delegate = self

        self.signUpButton.addTarget(self, action: #selector(didTapSignUp), for: .touchUpInside)
        self.signInButton.addTarget(self, action: #selector(didTapSignIn), for: .touchUpInside)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        self.view.backgroundColor = .systemBackground
        
        self.view.addSubview(headerView)
        self.view.addSubview(usernameField)
        self.view.addSubview(emailField)
        self.view.addSubview(passwordField)
        self.view.addSubview(signUpButton)
        self.view.addSubview(termsTextView)
        self.view.addSubview(signInButton)
        
        self.headerView.translatesAutoresizingMaskIntoConstraints = false
        self.usernameField.translatesAutoresizingMaskIntoConstraints = false
        self.emailField.translatesAutoresizingMaskIntoConstraints = false
        self.passwordField.translatesAutoresizingMaskIntoConstraints = false
        self.signUpButton.translatesAutoresizingMaskIntoConstraints = false
        self.termsTextView.translatesAutoresizingMaskIntoConstraints = false
        self.signInButton.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            self.headerView.topAnchor.constraint(equalTo: self.view.layoutMarginsGuide.topAnchor),
            self.headerView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.headerView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            self.headerView.heightAnchor.constraint(equalToConstant: 222),
            
            self.usernameField.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 12),
            self.usernameField.centerXAnchor.constraint(equalTo: headerView.centerXAnchor),
            self.usernameField.heightAnchor.constraint(equalToConstant: 55),
            self.usernameField.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.85),
            
            self.emailField.topAnchor.constraint(equalTo: usernameField.bottomAnchor, constant: 22),
            self.emailField.centerXAnchor.constraint(equalTo: headerView.centerXAnchor),
            self.emailField.heightAnchor.constraint(equalToConstant: 55),
            self.emailField.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.85),
            
            self.passwordField.topAnchor.constraint(equalTo: emailField.bottomAnchor, constant: 22),
            self.passwordField.centerXAnchor.constraint(equalTo: headerView.centerXAnchor),
            self.passwordField.heightAnchor.constraint(equalToConstant: 55),
            self.passwordField.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.85),
            
            self.signUpButton.topAnchor.constraint(equalTo: passwordField.bottomAnchor, constant: 22),
            self.signUpButton.centerXAnchor.constraint(equalTo: headerView.centerXAnchor),
            self.signUpButton.heightAnchor.constraint(equalToConstant: 55),
            self.signUpButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.85),
            
            self.termsTextView.topAnchor.constraint(equalTo: signUpButton.bottomAnchor, constant: 6),
            self.termsTextView.centerXAnchor.constraint(equalTo: headerView.centerXAnchor),
            self.termsTextView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.85),
            
            self.signInButton.topAnchor.constraint(equalTo: termsTextView.bottomAnchor, constant: 11),
            self.signInButton.centerXAnchor.constraint(equalTo: headerView.centerXAnchor),
            self.signInButton.heightAnchor.constraint(equalToConstant: 44),
            self.signInButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.85),
        ])
    }
    
    // MARK: - Selectors
//    @objc func didTapSignUp() {
//        print("DEBUG PRINT:", "didTapSignUp")
//        
//        let webViewer = WebViewerController(with: "https://www.memeatlas.com/images/pepes/pepe-fancy-smoking-cigar-served-by-seething-wojak.jpg")
//        
//        let nav = UINavigationController(rootViewController: webViewer)
//        self.present(nav, animated: true, completion: nil)
//    }
    
    @objc func didTapSignUp() {
            let userRequest = RegisterUserRequest(
                email: self.emailField.text ?? "",
                username: self.usernameField.text ?? "",
                password: self.passwordField.text ?? ""
            )
            
            // Username check
            if !Validator.isValidUsername(for: userRequest.username) {
                AlertManager.showInvalidUsernameAlert(on: self)
                return
            }
            
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
            
            guard let request = Endpoint.createAccount(userRequest: userRequest).request else { return }
            
            print(request)

            
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
                            AlertManager.showRegistrationErrorAlert(on: self, with: string)
                        }
                    }
                }
            }
        }
    @objc func didTapSignUp2() {
        let userRequest = RegisterUserRequest(
            email: self.emailField.text ?? "",
            username: self.usernameField.text ?? "",
            password: self.passwordField.text ?? ""
        )
        
        // Username check
        if !Validator.isValidUsername(for: userRequest.username) {
            AlertManager.showInvalidUsernameAlert(on: self)
            return
        }
        
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

        viewModel.signUp(userRequest: userRequest)
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
                        AlertManager.showRegistrationErrorAlert(on: self!, with: string)
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
    
    @objc private func didTapSignIn() {
        let vc = LoginViewController()
        let navigationController = UINavigationController(rootViewController: vc)

        guard let window = UIApplication.shared.windows.first else { return }
        window.rootViewController = navigationController
        UIView.transition(with: window, duration: 0.5, options: .transitionFlipFromRight, animations: nil, completion: nil)
    }
    
    
}

extension RegisterController: UITextViewDelegate {
    
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        
        if URL.scheme == "terms" {
            self.showWebViewerController(with: "https://policies.google.com/terms?hl=en")
        } else if URL.scheme == "privacy" {
            self.showWebViewerController(with: "https://policies.google.com/privacy?hl=en")
        }
        
        return true
    }
    
    private func showWebViewerController(with urlString: String) {
        let vc = WebViewerController(with: urlString)
        let nav = UINavigationController(rootViewController: vc)
        self.present(nav, animated: true, completion: nil)
    }
    
    //prevent text selectable
    func textViewDidChangeSelection(_ textView: UITextView) {
        textView.delegate = nil
        textView.selectedTextRange = nil
        textView.delegate = self
    }
}
