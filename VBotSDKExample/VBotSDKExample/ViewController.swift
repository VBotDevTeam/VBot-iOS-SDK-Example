//
//  ViewController.swift
//  VBotPhoneSDK
//
//  Created by 37604706 on 01/04/2024.
//  Copyright (c) 2024 37604706. All rights reserved.
//

import MBProgressHUD
import UIKit
import VBotPhoneSDK

// Constants
enum Constants {
    static let logoutText = "Logout"
    static let noHotlinesText = "No hotlines"
    static let errorTitle = "Error"
    static let closeTitle = "Close"
    static let deleteTitle = "Delete client"
    static let userConnectedText = "User connected"
    static let disconnectedText = "Disconnected"
    static let loginText = "Login"
}

enum TestPhoneNumber: String {
    case caNgu = "112"
    case caVoi = "113"
    case caChuoi = "114"
    case caChim = "115"
    
    var name: String {
        switch self {
        case .caNgu:
            return "Cá ngừ"
        case .caVoi:
            return "Cá Voi"
        case .caChuoi:
            return "Cá Chuối"
        case .caChim:
            return "Cá Chim"
        }
    }
    
    var code: String {
        switch self {
        case .caNgu:
            return "ios01"
        case .caVoi:
            return "ios02"
        case .caChuoi:
            return "android01"
        case .caChim:
            return "android02"
        }
    }
}

class ViewController: UIViewController {
    @IBOutlet var tokenTextField: UITextField!
    @IBOutlet var loginButton: UIButton!
    @IBOutlet var accountLabel: UILabel!
    @IBOutlet var callButton: UIButton!
    @IBOutlet var hotlineTextfield: UITextField!
    @IBOutlet var phoneTextField: UITextField!
    @IBOutlet var selectHotlineButton: UIButton!
    
    var selectedHotline: VBotHotline?
    
    let client = VBotPhone.sharedInstance
   
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
        setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        UIDevice.current.isProximityMonitoringEnabled = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func setupView() {
        phoneTextField.keyboardType = .numberPad
        if client.isUserConnected() {
            setupViewForLoggedInUser()
        } else {
            setupViewForLoggedOutUser()
        }
    }
    
    func setupViewForLoggedInUser() {
        loginButton.setTitle(Constants.logoutText, for: .normal)
        accountLabel.isHidden = false
        accountLabel.text = "\(Constants.userConnectedText) \(VBotPhone.sharedInstance.userDisplayName() ?? "")"
        tokenTextField.text = VBotPhone.sharedInstance.userToken() ?? ""
        accountLabel.textColor = .green
        getHotlines()
    }
        
    func setupViewForLoggedOutUser() {
        tokenTextField.text = client.userToken()
        accountLabel.text = Constants.disconnectedText
        accountLabel.textColor = .red
        selectHotlineButton.setTitle(Constants.noHotlinesText, for: .normal)
        selectHotlineButton.isEnabled = false
    }
    
    func getHotlines() {
        client.getHotlines { [weak self] hotlines, error in
            guard let self = self else { return }
            if error != nil {
                self.showError(code: (error! as NSError).code, message: (error! as NSError).localizedDescription)
                return
            } else {
                self.setupHotline(hotlines)
            }
        }
    }
    
    func setupHotline(_ hotlines: [VBotHotline]?) {
        guard let hotlines = hotlines, !hotlines.isEmpty else {
            selectedHotline = nil
            selectHotlineButton.setTitle("No hotlines", for: .normal)
            selectHotlineButton.isEnabled = false
            return
        }
        
        selectedHotline = hotlines[0]
        var menuChildren: [UIMenuElement] = []
        
        for hotline in hotlines {
            let action = UIAction(title: hotline.name) { [weak self] _ in
                self?.selectedHotline = hotline
                self?.hotlineTextfield.text = hotline.name
                self?.selectHotlineButton.setTitle(hotline.name, for: .normal)
            }
            menuChildren.append(action)
        }
        
        if #available(iOS 14.0, *) {
            selectHotlineButton.menu = UIMenu(options: .displayInline, children: menuChildren)
            selectHotlineButton.showsMenuAsPrimaryAction = true
            if #available(iOS 15.0, *) {
                selectHotlineButton.changesSelectionAsPrimaryAction = true
            } else {
                // Fallback on earlier versions
            }
            selectHotlineButton.isEnabled = true
        } else {
            // Fallback on earlier versions
        }
    }
    
    func connectClient() {
        let token = tokenTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""

        client.connect(token: token) { [weak self] displayName, error in
            guard let self = self else { return }

            self.loginButton.isEnabled = true
            self.hideProgress()

            if let error = error as NSError? {
                self.showError(code: error.code, message: error.localizedDescription)
                return
            }

            if let displayName = displayName {
                self.updateUIAfterConnect(displayName: displayName)
            }
        }
    }

    func disconnectClient() {
        client.disconnect { [weak self] error in
            guard let self = self else { return }
            
            self.hideProgress()
            
            if let error = error as NSError? {
                self.showError(code: error.code, message: error.localizedDescription)
            } else {
                self.updateUIAfterDisconnect()
            }
        }
    }

    func updateUIAfterConnect(displayName: String) {
        getHotlines()
        accountLabel.isHidden = false
        accountLabel.text = "\(Constants.userConnectedText) \(displayName)"
        accountLabel.textColor = .green
        loginButton.setTitle(Constants.logoutText, for: .normal)
    }

    func updateUIAfterDisconnect() {
        loginButton.isEnabled = true
        accountLabel.isHidden = false
        accountLabel.text = Constants.disconnectedText
        accountLabel.textColor = .red
        loginButton.setTitle(Constants.loginText, for: .normal)
        setupHotline(nil)
    }
    
    func updateUIAfterDelete() {
        loginButton.isEnabled = true
        accountLabel.isHidden = false
        accountLabel.text = Constants.disconnectedText
        accountLabel.textColor = .red
        loginButton.setTitle(Constants.loginText, for: .normal)
        setupHotline(nil)
    }
    
    @IBAction func loginButton_tapped(_ sender: Any) {
        hideKeyboard()
        if tokenTextField.text == "" {
            return
        }
        showProgress()
        if !client.isUserConnected() {
            connectClient()
        } else {
            disconnectClient()
        }
    }
    
    @IBAction func callButtonTapped(_ sender: Any) {
        hideKeyboard()

        let phoneNumber = phoneTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        let hotline = hotlineTextfield.text?.isEmpty == false ? selectedHotline?.phoneNumber ?? "" : ""
        
        guard let number = TestPhoneNumber(rawValue: phoneNumber) else {
            return
        }
        
        // Start the call
        client.startCall(
            phoneNumber: number.rawValue,
            name: number.name,
            avatar: "https://avatar.iran.liara.run/public",
            checkSum: generateChecksum(for: number),
            hotline: hotline
        ) { [weak self] error in
            guard let self = self else { return }

            // Handle error
            if let error = error as NSError? {
                self.showError(code: error.code, message: error.localizedDescription)
            }
        }
    }

    func generateChecksum(for testNumber: TestPhoneNumber) -> String {
        let uuidString = UUID().uuidString
        return testNumber.code + uuidString
    }
    
    func showError(code: Int, message: String) {
        let errorMessage = UIAlertController(title: Constants.errorTitle, message: "Code: \(code)\nMessage: \(message)", preferredStyle: .alert)

        let close = UIAlertAction(title: Constants.closeTitle, style: .default)
        let delete = UIAlertAction(title: Constants.deleteTitle, style: .destructive) { _ in
            VBotPhone.sharedInstance.delete {
                self.updateUIAfterDelete()
            }
        }

        errorMessage.addAction(close)
        errorMessage.addAction(delete)
        present(errorMessage, animated: true, completion: nil)
    }
}

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tapGesture = UITapGestureRecognizer(target: self,
                                                action: #selector(hideKeyboard))
        view.addGestureRecognizer(tapGesture)
    }

    @objc func hideKeyboard() {
        view.endEditing(true)
    }
    
    func showProgress() {
        let hud = MBProgressHUD.showAdded(to: view, animated: true)
        hud.mode = .indeterminate
        
        hud.backgroundView.style = .solidColor
        hud.backgroundView.color = UIColor(white: 0.0, alpha: 0.1)
        hud.show(animated: true)
    }
    
    func hideProgress() {
        MBProgressHUD.hide(for: view, animated: true)
    }
}
