//
//  ConfigurationTargetingViewControllerProtocol.swift
//

import Foundation

#if os(iOS) || os(tvOS)
import UIKit

/// Protocol abstracting a work-around for e.g. modally-presenting a VC wrapped
/// inside a `UINavigationController`: you want to configure the nav VC's root,
/// the segue destination is the navigation VC, how clean can we get this?
///
/// As a design note, in previous iterations of this design I've included things
/// like (a) a dictionary of auxiliary components (also available to configure),
/// (b) an array of uniform content items (e.g. prepopulated nav stack, or a finite
/// list of VCs to use as page-controller pages)...but I've concluded that's an
/// anti-pattern. The right approach is just to have a single configuration target,
/// a single "configure me" call, and then *allow* that configuration target to
/// take care of configuring its children--anything else goes against the law of demeter.
///
/// Also note that with the new `@IBSegueAction` the need for these configuration
/// requirements are increasingly-reduced: it looks like most use cases *can* be
/// handled via that API, and I think this is going to get relegated to the job
/// of pushing connections to global application state / infrastructure through
/// the VC hierarchy... 
@objc(HDXLConfigurationTargetingViewController)
public protocol ConfigurationTargetingViewControllerProtocol : NSObjectProtocol {
  
  /// The child view controller that *should be targeted* for configuration.
  ///
  /// - note: The long name is deliberate--don't want name collisions in Objective-C.
  var primaryConfigurationTargetViewController: UIViewController { get }
  
}

#endif
