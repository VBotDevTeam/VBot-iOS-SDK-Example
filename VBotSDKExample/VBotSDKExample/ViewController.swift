import MBProgressHUD
import UIKit
import VBotPhoneSDK

final class ViewController: UIViewController {
    // MARK: - Types
    
    private enum Constants {
        static let buttonHeight: CGFloat = 44
        static let stackViewSpacing: CGFloat = 16
        static let horizontalPadding: CGFloat = 20
        static let cornerRadius: CGFloat = 4
        static let fontSize: CGFloat = 16
    }
    
    // MARK: - UI Components
    
    private lazy var containerStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = Constants.stackViewSpacing
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    private lazy var selectMemberButton = makeButton(
        title: "Chọn thành viên kết nối",
        backgroundColor: .systemMintCompat,
        action: #selector(selectMemberTapped)
    )
    
    private lazy var loginButton = makeButton(
        title: "Kết nối",
        backgroundColor: .systemBlue,
        action: #selector(loginTapped)
    )
    
    private lazy var accountLabel: UILabel = {
        let label = makeLabel(text: "Đã ngắt kết nối", textColor: .red)
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var selectMemberToCallButton = makeButton(
        title: "Chọn thành viên để gọi",
        backgroundColor: .systemGreen,
        action: #selector(selectMemberToCallTapped)
    )
    
    private lazy var callButton = makeButton(
        title: "Gọi",
        backgroundColor: .systemMintCompat,
        action: #selector(callTapped)
    )
    
    // MARK: - Properties
    
    private let client: VBotPhone = .sharedInstance
    private var selectedMember: SDKMember?
    private var memberToCall: SDKMember?
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupConstraints()
        hideKeyboardWhenTappedAround()
        updateViewState()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIDevice.current.isProximityMonitoringEnabled = false
    }
    
    // MARK: - Setup
    
    private func setupView() {
        view.backgroundColor = .white
        view.addSubview(containerStackView)
        
        [accountLabel, selectMemberButton, loginButton,
         makeSpacerView(), selectMemberToCallButton, callButton].forEach {
            containerStackView.addArrangedSubview($0)
        }
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            containerStackView.bottomAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.bottomAnchor,
                constant: -Constants.horizontalPadding
            ),
            containerStackView.leadingAnchor.constraint(
                equalTo: view.leadingAnchor,
                constant: Constants.horizontalPadding
            ),
            containerStackView.trailingAnchor.constraint(
                equalTo: view.trailingAnchor,
                constant: -Constants.horizontalPadding
            ),
            
            loginButton.heightAnchor.constraint(equalToConstant: Constants.buttonHeight),
            accountLabel.heightAnchor.constraint(equalToConstant: Constants.buttonHeight),
            selectMemberToCallButton.heightAnchor.constraint(equalToConstant: Constants.buttonHeight)
        ])
    }
    
    // MARK: - State Management
    
    private func updateViewState() {
        if client.isUserConnected() {
            configureConnectedState()
        } else {
            configureDisconnectedState()
        }
    }
    
    private func configureConnectedState() {
        selectMemberToCallButton.isEnabled = true
        selectMemberButton.isEnabled = true
        loginButton.setTitle("Ngắt kết nối", for: .normal)
        loginButton.backgroundColor = .systemRed
        accountLabel.isHidden = false
        
        updateAccountLabel()
        updateSelectedMember()
        callButton.isEnabled = memberToCall != nil
    }
    
    private func configureDisconnectedState() {
        selectMemberButton.isEnabled = true
        selectMemberToCallButton.isEnabled = false
        callButton.isEnabled = false
        loginButton.setTitle("Kết nối", for: .normal)
        loginButton.backgroundColor = .systemBlue
        accountLabel.text = "Đã ngắt kết nối"
        accountLabel.textColor = .red
    }
    
    private func updateAccountLabel() {
        let userName = client.userDisplayName() ?? ""
        let attributedText = NSMutableAttributedString(
            string: "Đã kết nối: ",
            attributes: [
                .font: UIFont.systemFont(ofSize: Constants.fontSize, weight: .regular),
                .foregroundColor: UIColor.black
            ]
        )
        
        attributedText.append(
            NSAttributedString(
                string: userName,
                attributes: [
                    .font: UIFont.systemFont(ofSize: Constants.fontSize, weight: .medium),
                    .foregroundColor: UIColor.systemTealCompat
                ]
            )
        )
        
        accountLabel.attributedText = attributedText
    }
    
    private func updateSelectedMember() {
        guard let userToken = client.userToken(),
              let member = findTestMember(byToken: userToken) else { return }
        
        selectedMember = member
        selectMemberButton.setTitle("Đã chọn: \(member.name)", for: .normal)
        selectMemberButton.isEnabled = false
    }
    
    // MARK: - Actions
    
    @objc private func selectMemberTapped() {
        presentMemberSelection(forCall: false)
    }
    
    @objc private func selectMemberToCallTapped() {
        presentMemberSelection(forCall: true)
    }
    
    @objc private func loginTapped() {
        hideKeyboard()
        
        if client.isUserConnected() {
            handleDisconnect()
        } else if let token = selectedMember?.token, !token.isEmpty {
            handleConnect(with: token)
        }
    }
    
    @objc private func callTapped() {
        guard let member = memberToCall else { return }
        initiateCall(to: member)
    }
    
    // MARK: - Networking
    
    private func handleConnect(with token: String) {
        showProgress()
        client.connect(token: token) { [weak self] _, error in
            guard let self = self else { return }
            self.loginButton.isEnabled = true
            self.hideProgress()
            
            if let error = error as NSError? {
                self.showError(code: error.code, message: error.localizedDescription)
                return
            }
            
            self.registerPushToken()
        }
    }
    
    private func handleDisconnect() {
        showProgress()
        client.disconnect { [weak self] error in
            guard let self = self else { return }
            self.hideProgress()
            
            if let error = error as NSError? {
                self.showError(code: error.code, message: error.localizedDescription)
                return
            }
            
            self.configureDisconnectedState()
        }
    }
    
    private func registerPushToken() {
        guard let member = selectedMember else { return }
        
        addPushTokenInfo(member) { [weak self] error in
            if let error = error as NSError? {
                self?.showError(code: error.code, message: error.localizedDescription)
                return
            }
            self?.configureConnectedState()
        }
    }
    
    private func initiateCall(to member: SDKMember) {
        guard let selectedMember = selectedMember else { return }
        
        let checksum = generateChecksum(caller: selectedMember, callee: member)
        client.startOutgoingCall(
            callerId: "",
            callerName: "",
            calleeId: member.ext,
            calleeAvatar: "https://avatar.iran.liara.run/public",
            calleeName: member.name,
            checkSum: checksum
        ) { [weak self] error in
            if let error = error as NSError? {
                self?.showError(code: error.code, message: error.localizedDescription)
            }
        }
    }
    
    // MARK: - Helper Methods
    
    private func makeButton(title: String, backgroundColor: UIColor, action: Selector) -> UIButton {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(title, for: .normal)
        button.addTarget(self, action: action, for: .touchUpInside)
        button.backgroundColor = backgroundColor
        button.layer.cornerRadius = Constants.cornerRadius
        button.tintColor = .white
        return button
    }
    
    private func makeLabel(text: String, textColor: UIColor) -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.text = text
        label.textColor = textColor
        return label
    }
    
    private func makeSpacerView() -> UIView {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        return view
    }
    
    private func presentMemberSelection(forCall: Bool) {
        let viewController = SelectMemberViewController(delegate: self, toCall: forCall)
        present(viewController.wrapToNavigationController(), animated: true)
    }
    
    private func generateChecksum(caller: SDKMember, callee: SDKMember) -> String {
        let uuid = UUID().uuidString
        return "\(callee.code)-\(caller.code)-\(uuid)"
    }
    
    private func showError(code: Int, message: String) {
        let alert = UIAlertController(
            title: "Lỗi",
            message: "Code: \(code)\nMessage: \(message)",
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "Đóng", style: .default))
        alert.addAction(
            UIAlertAction(title: "Xóa dữ liệu", style: .destructive) { [weak self] _ in
                VBotPhone.sharedInstance.delete {
                    self?.configureDisconnectedState()
                }
            }
        )
        
        present(alert, animated: true)
    }
    
    
    private func addPushTokenInfo(_ member: SDKMember, completion: @escaping (Error?) -> Void) {
        let pushToken = VBotPhone.sharedInstance.pushToken() ?? ""
        if  pushToken != ""  {
            let url = URL(string: "https://api-sandbox-h01.vbot.vn/example-sdk-xanhsm/sdk/push-token")!
            let isProduct = false
            let parameters = "{\n \"isProduct\": \"\(isProduct)\",\n    \"deviceName\": \"\(member.name)\",\n    \"deviceId\": \"\(member.code)\",\n    \"token\": \"\(pushToken)\"\n}"
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
                    //                    let error = NSError(domain: "", code: 500, userInfo: [NSLocalizedDescriptionKey: "Lỗi parse JSON: \(error.localizedDescription) \n \(parameters)"])
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
    
    private func findTestMember(byToken token: String) -> SDKMember? {
        return TestAccount.first { $0.token == token }
    }
}

// MARK: - SelectMemberVCDelegate

extension ViewController: SelectMemberVCDelegate {
    func didSelectMember(_ member: SDKMember, toCall: Bool) {
        if toCall {
            memberToCall = member
            callButton.isEnabled = true
            selectMemberToCallButton.setTitle("Gọi cho: \(member.name)", for: .normal)
        } else {
            selectedMember = member
            selectMemberButton.setTitle("Đã chọn: \(member.name)", for: .normal)
        }
    }
}
