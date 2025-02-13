//
//  Helpers.swift
//  VBotPhoneSDK_Example
//
//  Created by DAT NGUYEN QUOC on 02/02/2025.
//

import Foundation
import UIKit

extension UIColor {
    static var systemMintCompat: UIColor {
        if #available(iOS 15.0, *) {
            return .systemMint
        } else {
            return .systemYellow
        }
    }
    
    static var systemTealCompat: UIColor {
        if #available(iOS 15.0, *) {
            return .systemTeal
        } else {
            return .green
        }
    }
}


extension UIViewController {
    @objc open func wrapToNavigationController() -> SPNavigationController {
        let navigationController = SPNavigationController(rootViewController: self)
        #if os(iOS)
        navigationController.navigationBar.prefersLargeTitles = false
        #endif
        return navigationController
    }


}

struct Res: Codable {
    let status: Int
    let error: String
    let message: String
}

open class SPNavigationController: UINavigationController {
    // MARK: - Init
    
    override public init(rootViewController: UIViewController) {
        super.init(rootViewController: rootViewController)
        commonInit()
    }
    
    override public init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        commonInit()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override public init(navigationBarClass: AnyClass?, toolbarClass: AnyClass?) {
        super.init(navigationBarClass: navigationBarClass, toolbarClass: toolbarClass)
    }
    
    /**
     SparrowKit: Wrapper of init.
     Called in each init and using for configuration.
     
     No need ovveride init. Using one function for configurate view.
     */
    open func commonInit() {}
    
    // MARK: - Layout
    
    /**
     SparrowKit: If set to `true`, navigation bar apply horizontal margins from view of navigation controller.
     Default is `false`.
     */
    open var inheritLayoutMarginsForNavigationBar: Bool = false
    
    /**
     SparrowKit: If set to `true`, child controllers apply horizontal margins from view of navigation controller.
     Default is `false`.
     */
    open var inheritLayoutMarginsForСhilds: Bool = false
    
    override open func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        // Inhert of Navigation Bar
        
        if inheritLayoutMarginsForNavigationBar {
            let leftMargin = view.layoutMargins.left
            let rightMargin = view.layoutMargins.left
            
            if navigationBar.layoutMargins.left != leftMargin {
                navigationBar.layoutMargins.left = leftMargin
            }
            if navigationBar.layoutMargins.right != rightMargin {
                navigationBar.layoutMargins.right = rightMargin
            }
        }
        
        // Inhert childs controllers
        
        if inheritLayoutMarginsForСhilds {
            let leftMargin = view.layoutMargins.left
            let rightMargin = view.layoutMargins.left
            
            for childController in viewControllers {
                if childController.view.layoutMargins.left != leftMargin {
                    childController.view.layoutMargins.left = leftMargin
                }
                if childController.view.layoutMargins.right != rightMargin {
                    childController.view.layoutMargins.right = rightMargin
                }
            }
        }
    }
}


class LoadingView: UIView {
    private let activityIndicator = UIActivityIndicatorView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }

    private func setupView() {
        self.backgroundColor = .clear
        self.layer.cornerRadius = 10

        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        addSubview(activityIndicator)
        activityIndicator.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        activityIndicator.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true

        activityIndicator.startAnimating()
    }
}

extension UIViewController {
    func showProgress() {
           DispatchQueue.main.async {
               if let _ = self.view.viewWithTag(999) {
                   return
               }

               let loadingView = LoadingView(frame: self.view.bounds)
               loadingView.tag = 999
               self.view.addSubview(loadingView)
           }
       }

       func hideProgress() {
           DispatchQueue.main.async {
               if let loadingView = self.view.viewWithTag(999) {
                   loadingView.removeFromSuperview()
               }
           }
       }
}
