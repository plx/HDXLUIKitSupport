//
//  UIViewController+ConfigurationTargetingSupport.swift
//

import Foundation
#if os(iOS) || os(tvOS)
import UIKit

public extension UIViewController {
  
  @objc(hdxl_primaryConfigurationTargetViewController)
  var effectivePrimaryConfigurationTargetViewController: UIViewController {
    get {
      // note we *must* check this first to correctly deal with custom subclasses
      // of `UINavigationController`:
      if let configurationTargetingVC = self as? ConfigurationTargetingViewControllerProtocol {
        return configurationTargetingVC.primaryConfigurationTargetViewController
      } else if let navVC = self as? UINavigationController {
        return navVC.viewControllers.first ?? self
      } else {
        return self
      }
    }
  }
  
}

#endif
