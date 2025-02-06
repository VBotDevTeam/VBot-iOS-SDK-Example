import UIKit

@MainActor
protocol SelectMemberVCDelegate: AnyObject {
    func didSelectMember(_ member: SDKMember, toCall: Bool)
}

class SelectMemberViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    private let collectionView: UICollectionView
    private weak var delegate: SelectMemberVCDelegate?
    private let toCall: Bool
    private let dataTable: [SDKMember]
    
    init(delegate: SelectMemberVCDelegate?, toCall: Bool = false) {
        self.delegate = delegate
        self.toCall = toCall
        
        let connectedName = getSDKMember()?.callName ?? ""
        if toCall {
            self.dataTable = TestAccount.filter { $0.callName != connectedName }
        } else {
            self.dataTable = TestAccount.filter { $0.type == "ios" && $0.typeTest == "xanhsm" && $0.callName != connectedName }
        }
        
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 10
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        
        self.collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupCollectionView()
    }
    
    private func setupView() {
        view.backgroundColor = .white
        title = toCall ? "Chọn để gọi" : "Chọn để kết nối"
    }
    
    private func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .white
        collectionView.register(MemberCollectionViewCell.self, forCellWithReuseIdentifier: "MemberCell")
        
        view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataTable.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MemberCell", for: indexPath) as! MemberCollectionViewCell
        cell.configure(with: dataTable[indexPath.item])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let delegate = delegate {
            delegate.didSelectMember(dataTable[indexPath.item], toCall: toCall)
        }
        dismiss(animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let spacing: CGFloat = 30
        let availableWidth = collectionView.bounds.width - spacing
        let cellWidth = availableWidth / 2
        return CGSize(width: cellWidth, height: 60)
    }
}

class MemberCollectionViewCell: UICollectionViewCell {
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCell()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupCell() {
        contentView.backgroundColor = .white
        contentView.layer.cornerRadius = 4.0
        
        contentView.addSubview(nameLabel)
        nameLabel.textColor = .white
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            nameLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
        ])
    }
    
    func configure(with item: SDKMember) {
        nameLabel.text = item.callName
        
        if item.typeTest == "xanhsm" {
            if #available(iOS 15.0, *) {
                contentView.backgroundColor = UIColor.systemTeal
            } else {
                contentView.backgroundColor = UIColor.yellow
            }
            
        } else {
            contentView.backgroundColor = UIColor.systemGreen
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        nameLabel.text = nil
    }
}
