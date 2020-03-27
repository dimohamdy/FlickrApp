//
//  ViewRoutable.swift
//  EightyTech
//
//  Created by BinaryBoy on 8/24/20.
//  Copyright © 2019 EightyTech. All rights reserved.
//

import UIKit

public protocol ViewRoutable: class {
    func present(view: ViewRoutable, animated flag: Bool, completion: (() -> Void)?)
    func push(view: ViewRoutable, animated flag: Bool)
    func pushFromTabbar(view: ViewRoutable, animated flag: Bool)
    func dismiss(animated flag: Bool, completion: (() -> Void)?)
}

extension ViewRoutable {
    
    func present(view: ViewRoutable, animated flag: Bool, completion: (() -> Void)?) {
        
    }
    func push(view: ViewRoutable, animated flag: Bool) {
        
    }
    func pushFromTabbar(view: ViewRoutable, animated flag: Bool) {
        
    }
    func dismiss(animated flag: Bool, completion: (() -> Void)?) {
        
    }
}

extension ViewRoutable where Self: UIViewController {
    
    public func present(view: ViewRoutable, animated flag: Bool, completion: (() -> Void)?) {
        if  let view = view as? UIViewController {
            view.modalPresentationStyle = .fullScreen
            present(view, animated: flag, completion: completion)
        }
    }
    
    public func push(view: ViewRoutable, animated flag: Bool) {
        if  let view = view as? UIViewController {
            navigationController?.pushViewController(view, animated: true)
        }
    }
    
    public func pushFromTabbar(view: ViewRoutable, animated flag: Bool) {
        if  let view = view as? UIViewController {
            navigationController?.tabBarController?.present(view, animated: true, completion: nil)
        }
    }
}

extension UIViewController: ViewRoutable {
    
}
