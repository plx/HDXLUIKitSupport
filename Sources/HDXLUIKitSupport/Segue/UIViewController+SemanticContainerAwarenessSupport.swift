//
//  UIViewController+SemanticContainerAwarenessSupport.swift
//

import Foundation
#if os(iOS) || os(tvOS)
import UIKit

public extension UIViewController {
  
  @objc(hdxl_primarySemanticContainerViewController)
  var effectivePrimarySemanticContainerViewController: UIViewController {
    get {
      if let semanticContainerAwareVC = self as? SemanticContainerAwareViewControllerProtocol {
        return semanticContainerAwareVC.primarySemanticContainerViewController
      } else {
        return self
      }
    }
  }
  
}

#endif
