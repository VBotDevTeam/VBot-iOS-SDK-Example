//
//  ViewController.swift
//  VBotPhoneSDK
//
//  Created by 37604706 on 01/04/2024.
//  Copyright (c) 2024 37604706. All rights reserved.
//

import UIKit
import VBotPhoneSDK

class ViewController: UIViewController {
    private lazy var selectMemberButton = createButton(
        title: "Chọn tài khoản",
        backgroundColor: UIColor.systemMintCompat,
        action: #selector(go_selectMember)
    )
    
    private lazy var loginButton = createButton(
        title: "Lưu",
        backgroundColor: .systemBlue,
        action: #selector(loginButton_tapped)
    )
    
    private lazy var accountLabel = createLabel(
        text: "Chưa chọn tài khoản",
        textColor: .red
    )
    
    private lazy var selectMemberToCallButton = createButton(
        title: "Chọn tài khoản để gọi",
        backgroundColor: .systemGreen,
        action: #selector(go_selectMemberToCall)
    )
    
    private lazy var callButton = createButton(
        title: "Gọi",
        backgroundColor: UIColor.systemMintCompat,
        action: #selector(callButton_tapped)
    )
    
    private lazy var line = createLine()
    
    private lazy var containerStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    private let client = VBotPhone.sharedInstance
    private var selectedMember: SDKMember?
    private var memberToCall: SDKMember?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupUI()
        setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIDevice.current.isProximityMonitoringEnabled = false
    }
    
    private func setupUI() {
        view.addSubview(containerStackView)
        
        let items = [accountLabel, selectMemberButton, loginButton, line, selectMemberToCallButton, callButton]
        
        items.forEach { containerStackView.addArrangedSubview($0) }
        
        NSLayoutConstraint.activate([
            containerStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            containerStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            containerStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            loginButton.heightAnchor.constraint(equalToConstant: 44),
            accountLabel.heightAnchor.constraint(equalToConstant: 44),
            selectMemberToCallButton.heightAnchor.constraint(equalToConstant: 44),
            line.heightAnchor.constraint(equalToConstant: 44)
        ])
    }
    
    private func setupView() {
        if let loadedUser = getSDKMember() {
            setupViewForLoggedInUser(loadedUser)
        } else {
            setupViewForLoggedOutUser()
        }
    }
    
    private func setupViewForLoggedInUser(_ member: SDKMember) {
        selectedMember = member
        selectMemberToCallButton.isEnabled = true
        selectMemberButton.isEnabled = true
        loginButton.setTitle("Xóa", for: .normal)
        loginButton.backgroundColor = .systemRed
        accountLabel.isHidden = false
        
        let attributedText = NSMutableAttributedString(string: "Đã kết nối: ", attributes: [
            .font: UIFont.systemFont(ofSize: 16, weight: .regular),
            .foregroundColor: UIColor.black
        ])
        
        let userColor = UIColor.systemTealCompat
        let userAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 16, weight: .medium),
            .foregroundColor: userColor
        ]
        
        attributedText.append(NSAttributedString(string: member.callName, attributes: userAttributes))
        accountLabel.attributedText = attributedText
        
        if let member = findTestMember(byCallId: member.callId) {
            selectedMember = member
            selectMemberButton.setTitle("Đã chọn: \(member.callName)", for: .normal)
            selectMemberButton.isEnabled = false
        }
        
        if memberToCall != nil {
            callButton.isEnabled = true
        }
    }
    
    func addPushTokenInfo(_ member: SDKMember, completion: @escaping (Error?) -> Void) {
        let pushToken = getPushToken() ?? ""
        if pushToken != "" {
            let url = URL(string: "https://api-sandbox-h01.vbot.vn/example-sdk-xanhsm/sdk/push-token")!
            let isProduct = false
            let parameters = "{\n \"userId\": \"\(member.callId)\",\n \"isProduct\": \"\(isProduct)\",\n    \"deviceName\": \"\(member.callName)\",\n    \"deviceId\": \"\(member.code)\",\n    \"token\": \"\(pushToken)\"\n}"
            let postData = parameters.data(using: .utf8)
            VBotLogger.debug(filter: "🐳 Example", "parameters: \(parameters)")
    
            var request = URLRequest(url: url)
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpMethod = "POST"
            request.httpBody = postData
            URLSession.shared.dataTask(with: request) { data, _, error in
                guard let data = data else {
                    VBotLogger.debug(filter: "🐳 Example", "Kết nối máy chủ lỗi: \(String(describing: error))")
                    DispatchQueue.main.async {
                        completion(nil)
                    }
                    return
                }
    
                if let responseString = String(data: data, encoding: .utf8) {
                    VBotLogger.debug(filter: "🐳 Example", "Raw response: \(responseString)")
                }
    
                do {
                    if let jsonObject = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                        VBotLogger.debug(filter: "🐳 Example", "JSON Response: \(jsonObject)")
                    } else {
                        VBotLogger.debug(filter: "🐳 Example", "Không thể parse JSON từ dữ liệu trả về.")
                    }
                    DispatchQueue.main.async {
                        completion(nil)
                    }
                } catch {
                    VBotLogger.debug(filter: "🐳 Example", "Lỗi khi parse JSON: \(error) ")
                    DispatchQueue.main.async {
                        completion(nil)
                    }
                }
            }.resume()
        } else {
            let error = NSError(domain: "", code: 102, userInfo: [NSLocalizedDescriptionKey: "Không có push token"])
            DispatchQueue.main.async {
                completion(error)
            }
        }
    }
    
    func findTestMember(byCallId id: String) -> SDKMember? {
        return TestAccount.first { $0.callId == id }
    }
    
    private func setupViewForLoggedOutUser() {
        selectMemberButton.isEnabled = true
        selectMemberToCallButton.isEnabled = false
        callButton.isEnabled = false
        loginButton.setTitle("Lưu", for: .normal)
        loginButton.backgroundColor = .systemBlue
        accountLabel.text = "Chưa chọn tài khoản"
        accountLabel.textColor = .red
    }
    
    @objc private func go_selectMember() {
        presentSelectMemberViewController(toCall: false)
    }
    
    @objc private func go_selectMemberToCall() {
        presentSelectMemberViewController(toCall: true)
    }
    
    @objc private func loginButton_tapped() {
        if getSDKMember() == nil {
            saveMember()
        } else {
            deleteMember()
        }
    }
    
    @objc private func callButton_tapped() {
        if let member = memberToCall {
            makeCall(member)
        }
    }
    
    private func createButton(title: String, backgroundColor: UIColor, action: Selector) -> UIButton {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(title, for: .normal)
        button.addTarget(self, action: action, for: .touchUpInside)
        button.backgroundColor = backgroundColor
        button.layer.cornerRadius = 4
        button.tintColor = .white
        return button
    }
    
    private func createLabel(text: String, textColor: UIColor) -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.text = text
        label.textColor = textColor
        return label
    }
    
    private func createLine() -> UIView {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        return view
    }
    
    private func presentSelectMemberViewController(toCall: Bool) {
        let vc = SelectMemberViewController(delegate: self, toCall: toCall)
        present(vc.wrapToNavigationController(), animated: true)
    }
    
    private func saveMember() {
        showProgress()
        addPushTokenInfo(selectedMember!) { [weak self] error in
            guard let self = self else { return }
            if let error = error as NSError? {
                self.showError(code: error.code, message: error.localizedDescription)
                return
            }
            saveSDKMember(self.selectedMember!)
            self.hideProgress()
            self.setupViewForLoggedInUser(self.selectedMember!)
        }
    }
    
    private func deleteMember() {
        deleteSDKMember()
        setupViewForLoggedOutUser()
    }
    
    private func makeCall(_ member: SDKMember) {
        client.startOutgoingCall(callerId: selectedMember!.callId, callerName: selectedMember!.callName, calleeId: member.callId, calleeAvatar: "https://avatar.iran.liara.run/public", calleeName: member.callName, checkSum: generateChecksum(for: member)) { [weak self] error in
            guard let self = self else { return }
            if let error = error as NSError? {
                self.showError(code: error.code, message: error.localizedDescription)
            }
        }
    }
    
    private func generateChecksum(for testNumber: SDKMember) -> String {
        let uuidString = UUID().uuidString
        return testNumber.code + "-" + selectedMember!.code + "-" + uuidString
    }
    
    private func showError(code: Int, message: String) {
        let errorMessage = UIAlertController(title: "Lỗi", message: "Code: \(code)\nMessage: \(message)", preferredStyle: .alert)
        errorMessage.addAction(UIAlertAction(title: "Đóng", style: .default))
        
        present(errorMessage, animated: true)
    }
}

extension ViewController: SelectMemberVCDelegate {
     func didSelectMember(_ member: SDKMember, toCall: Bool) {
        if toCall {
            self.memberToCall = member
            self.callButton.isEnabled = true
            self.selectMemberToCallButton.setTitle("Gọi cho: \(member.callName)", for: .normal)
        } else {
            self.selectedMember = member
            self.selectMemberButton.setTitle("Đã chọn: \(member.callName)", for: .normal)
        }
    }
}
