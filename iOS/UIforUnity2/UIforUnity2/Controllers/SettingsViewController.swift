//
//  SettingsViewController.swift
//  UIforUnity2
//
//  Created by NTLG1 on 1/6/24.
//

import UIKit

class SettingsViewController: UITableViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {

    var username = "User"
    var soundEnabled = true
    var volume: Float = 50
    var fontSize = 2
    var notificationsEnabled = true
    var profileImage = UIImage(systemName: "person.circle.fill")

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Settings"
        view.backgroundColor = .systemBackground
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 5
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0: return 1
        case 1: return 2
        case 2: return 2
        case 3: return 1
        case 4: return 2
        default: return 0
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)

        switch indexPath.section {
        case 0:
            // Account and Profile
            cell.textLabel?.text = "Username: \(username)"
            cell.accessoryType = .disclosureIndicator
            cell.imageView?.image = profileImage
        case 1:
            // Sound Settings
            if indexPath.row == 0 {
                let toggle = UISwitch()
                toggle.isOn = soundEnabled
                toggle.addTarget(self, action: #selector(toggleSound(_:)), for: .valueChanged)
                cell.textLabel?.text = "Enable Sound Effects"
                cell.accessoryView = toggle
            } else if indexPath.row == 1 {
                let slider = UISlider()
                slider.value = volume
                slider.addTarget(self, action: #selector(sliderValueChanged(_:)), for: .valueChanged)
                cell.textLabel?.text = "Volume: \(Int(volume))"
                cell.accessoryView = slider
            }
        case 2:
            // Display Settings
            if indexPath.row == 0 {
                cell.textLabel?.text = "Font Size"
                let segmentedControl = UISegmentedControl(items: ["Very Small", "Small", "Medium", "Big"])
                segmentedControl.selectedSegmentIndex = fontSize - 1
                segmentedControl.addTarget(self, action: #selector(fontSizeChanged(_:)), for: .valueChanged)
                cell.accessoryView = segmentedControl
            }
        case 3:
            // Notifications Settings
            let toggle = UISwitch()
            toggle.isOn = notificationsEnabled
            toggle.addTarget(self, action: #selector(toggleNotifications(_:)), for: .valueChanged)
            cell.textLabel?.text = "Enable Notifications"
            cell.accessoryView = toggle
        case 4:
            // General Settings
            if indexPath.row == 0 {
                cell.textLabel?.text = "About the App"
                cell.accessoryType = .disclosureIndicator
            } else if indexPath.row == 1 {
                cell.textLabel?.text = "Reset to Default Settings"
                cell.textLabel?.textColor = .red
            }
        default:
            break
        }

        return cell
    }

    @objc func toggleSound(_ sender: UISwitch) {
        soundEnabled = sender.isOn
    }

    @objc func sliderValueChanged(_ sender: UISlider) {
        volume = sender.value
        if let cell = sender.superview as? UITableViewCell {
            cell.textLabel?.text = "Volume: \(Int(volume))"
        }
    }

    @objc func fontSizeChanged(_ sender: UISegmentedControl) {
        fontSize = sender.selectedSegmentIndex + 1
    }

    @objc func toggleNotifications(_ sender: UISwitch) {
        notificationsEnabled = sender.isOn
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        if indexPath.section == 0 {
            // Handle profile image tap
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            present(imagePicker, animated: true, completion: nil)
        } else if indexPath.section == 4 && indexPath.row == 0 {
            // Handle About the App navigation
            let aboutVC = UIViewController()
            aboutVC.view.backgroundColor = .white
            aboutVC.title = "About the App"
            navigationController?.pushViewController(aboutVC, animated: true)
        } else if indexPath.section == 4 && indexPath.row == 1 {
            // Handle reset to default settings
            resetToDefaultSettings()
        }
    }

    func resetToDefaultSettings() {
        username = "User"
        soundEnabled = true
        volume = 50
        fontSize = 2
        notificationsEnabled = true
        profileImage = UIImage(systemName: "person.circle.fill")
        tableView.reloadData()
    }

    // MARK: - UIImagePickerControllerDelegate
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let selectedImage = info[.originalImage] as? UIImage {
            profileImage = selectedImage
        }
        dismiss(animated: true) {
            self.tableView.reloadData()
        }
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}

