//
//  UIViewController+LoadingSupport.swift
//

import Foundation
#if os(iOS) || os(tvOS)
import UIKit

public extension UIViewController {
  
  /// Recursively force-loads the view, the views of all child VCs, and so on.
  ///
  /// The original motivation was from doing segue configuration: at one point,
  /// at least, the "source VC" would get `prepareForSegue:sender:` called on it
  /// *before* the *destination VC* had loaded its view--or at least that load
  /// wasn't *guaranteed* (and thus often wasn't).
  ///
  /// Where this bit me, repeatedly, was when I implemented complicated scenes
  /// as  "coordinator-container + modules":
  ///
  /// - a custom container VC organizes the components on-screen and coordinates between them
  /// - the actual UI, logic, etc., is contained within the individual component VCs
  ///
  /// ...with the container/component setup handled automagically via embed segues.
  ///
  /// Here's the issue: the *components* don't exist until the *parent* loads its
  /// view, which means that to make this pattern work we need to force-load it
  /// around the time we're preparing for a segue. If the child VCs, themselves,
  /// *are also in this pattern*, then we need recursion...whence this mehtod.
  ///
  /// I really don't see the harm in it, tbh, b/c the views are going to get loaded
  /// moments later when the segue, itself, starts (just sayin').
  @inlinable
  func recursivelyLoadViewsIfNeeded() {
    self.loadViewIfNeeded()
    for childVC in self.children {
      childVC.recursivelyLoadViewsIfNeeded()
    }
    // not sure I'd ever need this, but maybe it's necessary when restoring UI state?
    self.presentedViewController?.recursivelyLoadViewsIfNeeded()
  }
  
}
#endif
