//
//  ViewController.swift
//  UIforUnity2
//
//  Created by NTLG1 on 1/6/24.
//

import UIKit

class HomeViewController: UIViewController {
    
    let modes = ["Exploration Mode", "Learning Mode", "Book Mode", "Progress", "Logout"]
    let scrollView = UIScrollView()
    
    // MARK: - UI Components
    private let label: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 24, weight: .semibold)
        label.text = "Loading..."
        label.numberOfLines = 0
        return label
    }()
    
    // MARK: - LifeCycle
    init(dataArray: DataArray) {
        super.init(nibName: nil, bundle: nil)
        self.label.text = ""
        dataArray.data.forEach({ self.label.text?.append("\n\($0)") })
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set up the background image
        let backgroundImageView = UIImageView(image: UIImage(named: "background"))
        backgroundImageView.contentMode = .scaleAspectFill
        backgroundImageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(backgroundImageView)
        view.sendSubviewToBack(backgroundImageView)
        
        NSLayoutConstraint.activate([
            backgroundImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            backgroundImageView.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        // Set up the scroll view
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
        
        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        // Add the mode views to the scroll view
        addModeViews()
    }
    
    func addModeViews() {
        var previousView: UIView? = nil
        
        for (index, mode) in modes.enumerated() {
            let modeView = createModeView(for: mode, at: index)
            scrollView.addSubview(modeView)
            
            modeView.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                modeView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width / 2),
                modeView.heightAnchor.constraint(equalToConstant: 200),
                modeView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor)
            ])
            
            if let previousView = previousView {
                NSLayoutConstraint.activate([
                    modeView.topAnchor.constraint(equalTo: previousView.bottomAnchor, constant: 20)
                ])
            } else {
                NSLayoutConstraint.activate([
                    modeView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 0)
                ])
            }
            
            previousView = modeView
        }
        
        if let previousView = previousView {
            NSLayoutConstraint.activate([
                previousView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -20)
            ])
        }
    }
    
    func createModeView(for mode: String, at index: Int) -> UIView {
        let containerView = UIView()
        
        let rectangleView = UIView()
        let imageName: String
        
        switch mode {
        case "Exploration Mode":
            imageName = "explorationMode"
        case "Learning Mode":
            imageName = "learningMode"
        case "Book Mode":
            imageName = "bookMode"
        case "Progress":
            imageName = "progressMode"
        case "Logout":
            imageName = "logout"
        default:
            imageName = "defaultImage"
        }
        
        let imageView = UIImageView(image: UIImage(named: imageName))
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 15
        
        rectangleView.addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: rectangleView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: rectangleView.trailingAnchor),
            imageView.topAnchor.constraint(equalTo: rectangleView.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: rectangleView.bottomAnchor)
        ])
        
        rectangleView.layer.cornerRadius = 15
        rectangleView.layer.shadowRadius = 5
        rectangleView.layer.shadowOpacity = 0.5
        
        let label = UILabel()
        label.text = mode
        label.textColor = .black
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textAlignment = .center
        
        rectangleView.addSubview(label)
        containerView.addSubview(rectangleView)
        
        rectangleView.translatesAutoresizingMaskIntoConstraints = false
        label.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            rectangleView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            rectangleView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            rectangleView.topAnchor.constraint(equalTo: containerView.topAnchor),
            rectangleView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            
            label.centerXAnchor.constraint(equalTo: rectangleView.centerXAnchor),
            label.bottomAnchor.constraint(equalTo: rectangleView.bottomAnchor, constant: -10)
        ])
        
        if mode == "Logout" {
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapLogout))
            containerView.addGestureRecognizer(tapGesture)
        }
        
        return containerView
    }
    
    // MARK: - Selectors
    @objc private func didTapLogout() {
        AuthService.signOut()
        
        if let sceneDelegate = self.view.window?.windowScene?.delegate as? SceneDelegate {
            sceneDelegate.checkAuthentication()
        }
    }
    
//    @objc func openSettings() {
//        let settingsVC = SettingsViewController()
//        navigationController?.pushViewController(settingsVC, animated: true)
//    }
}
