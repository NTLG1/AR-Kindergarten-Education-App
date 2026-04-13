//
//  SwiftCodeKitViewController.swift
//  iOSFrameWork
//
//  Created by NTLG1 on 5/5/24.
//

import Foundation
import UIKit

final class SwiftCodeKitViewController: UIViewController {

    private lazy var button: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Press me", for: .normal)
        button.backgroundColor = .white
        button.layer.cornerRadius = 20
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(onTap), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .orange
        
        view.addSubview(button)
        
        NSLayoutConstraint.activate([
            button.widthAnchor.constraint(equalToConstant: 150),
            button.heightAnchor.constraint(equalToConstant: 50),
            button.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            button.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        
        // Adjust constraints to make the orange background cover the full screen
        view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            view.topAnchor.constraint(equalTo: view.superview!.topAnchor),
            view.leadingAnchor.constraint(equalTo: view.superview!.leadingAnchor),
            view.trailingAnchor.constraint(equalTo: view.superview!.trailingAnchor),
            view.bottomAnchor.constraint(equalTo: view.superview!.bottomAnchor)
        ])
    }
    
    @objc
    func onTap() {
        dismiss(animated: true)
    }
}
