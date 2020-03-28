//
//  BasePresenterIO.swift
//  EightyTech
//
//  Created by BinaryBoy on 8/24/20.
//  Copyright © 2019 EightyTech. All rights reserved.
//

import UIKit
import SwiftMessages

protocol BasePresenterInput: class {
    func viewDidLoad()
}
extension BasePresenterInput {
    func viewDidLoad() {}
}
protocol BaseDisplayLogic: class {
    func handle(error: FlickrAppError)
    func showError(error: Error)
    func showError(title: String, subtitle: String?)
    func showSuccess(title: String, subtitle: String?)
}

protocol Loading {

}

protocol BasePresenterOutput: BaseDisplayLogic {
    func showLoading()
    func hideLoading()
}

extension BaseDisplayLogic where Self: UIViewController {

    func showError(title: String, subtitle: String?) {

        let view = MessageView.viewFromNib(layout: .cardView)

        view.configureTheme(.warning)
        view.button?.isHidden = true
        view.semanticContentAttribute = .forceRightToLeft

        view.configureContent(title: title, body: subtitle ?? "", iconText: "")
        SwiftMessages.show(view: view)
    }

    func showSuccess(title: String, subtitle: String?) {

        let view = MessageView.viewFromNib(layout: .cardView)
        view.configureTheme(.success)
        view.button?.isHidden = true
        view.configureContent(title: title, body: subtitle ?? "")

        var successConfig = SwiftMessages.defaultConfig
        successConfig.presentationStyle = .center
        successConfig.preferredStatusBarStyle = .lightContent
        successConfig.presentationContext = .window(windowLevel: UIWindow.Level.normal)

        SwiftMessages.show(config: successConfig, view: view)
    }
}

extension UIViewController: BasePresenterOutput {
    func handle(error: FlickrAppError) {
        
    }
    
    func showLoading() {
        view.startActivityIndicator(tag: Tags.Loading.loadingIndicator)

    }

    func hideLoading() {
        view.stopActivityIndicator(tag: Tags.Loading.loadingIndicator)
    }
}
extension UIViewController {

    func showError(error: Error) {
        showError(title: "error", subtitle: error.localizedDescription)
    }
}

 extension UIView {
    
    func startActivityIndicator(style: UIActivityIndicatorView.Style = .white, location: CGPoint? = nil, tag: Tags.Loading) {
        
        let height: CGFloat = 65
        
        DispatchQueue.main.async(execute: {
            
            let loc = location ?? self.center
            
            // Create the activity indicator
            let loadingIndicatorView: UIActivityIndicatorView = {
                let style: UIActivityIndicatorView.Style = {
                    if #available(iOS 13, *) {
                        return .medium
                    }
                    
                    return .white
                }()
                
                let indicatorView = UIActivityIndicatorView(style: style)
                indicatorView.color = .white
                indicatorView.translatesAutoresizingMaskIntoConstraints = false
                return indicatorView
            }()
            
            // Add the tag so we can find the view in order to remove it later
            loadingIndicatorView.tag = tag.rawValue
            loadingIndicatorView.center = loc
            loadingIndicatorView.hidesWhenStopped = true
            
            loadingIndicatorView.startAnimating()
            self.addSubview(loadingIndicatorView)
            loadingIndicatorView.layer.zPosition = CGFloat(Float.greatestFiniteMagnitude)
            loadingIndicatorView.layer.cornerRadius = 5
            
            NSLayoutConstraint.activate([
                loadingIndicatorView.widthAnchor.constraint(equalToConstant: height),
                loadingIndicatorView.heightAnchor.constraint(equalTo: loadingIndicatorView.widthAnchor),
                loadingIndicatorView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
                loadingIndicatorView.centerYAnchor.constraint(equalTo: self.centerYAnchor)
            ])
            loadingIndicatorView.layoutIfNeeded()
            loadingIndicatorView.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)

        })
    }
    
    func stopActivityIndicator(tag: Tags.Loading) {
        
        DispatchQueue.main.async(execute: {
            
            if let loadingIndicatorView = self.subviews.filter({ $0.tag == tag.rawValue}).first as? UIActivityIndicatorView {
                loadingIndicatorView.stopAnimating()
                loadingIndicatorView.removeFromSuperview()
            }
        })
    }
}
