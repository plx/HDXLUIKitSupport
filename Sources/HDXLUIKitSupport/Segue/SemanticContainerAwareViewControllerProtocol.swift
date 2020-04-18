//
//  SemanticContainerAwareViewControllerProtocol.swift
//

import Foundation
#if os(iOS) || os(tvOS)
import UIKit

/// Something of a mirror-image to `ConfigurationTargetViewController`: this protocol
/// is for view controllers that (a) are typically embedded in some larger coordinating
/// container VC and (b) originate their own unwind segues. In other words, if you have
/// (a) a "control deck" VC that uses per-component embedded VCs and also (b) those
/// embedded component VCs trigger their own unwind segues (directly), then you *may*
/// want those embedded VCs to implement this protocol (to return the "control deck" VC).
///
/// I increasingly think that's a suboptimal pattern--it's *better* to have the
/// child VCs tell the coordinator they want dismissal and then let the coordinator
/// deal with it--but, even so, it's often the *best available* pattern.
///
@objc(HDXLSemanticContainerAwareViewController)
public protocol SemanticContainerAwareViewControllerProtocol : NSObjectProtocol {
  
  /// The parent VC (typically a coordinator VC of some kind).
  /// - note: The long name is deliberate--don't want name collisions in Objective-C.
  var primarySemanticContainerViewController: UIViewController { get }
  
}

#endif
