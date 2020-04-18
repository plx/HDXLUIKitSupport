//
//  UIViewController+ParentViewControllerSequence.swift
//

import Foundation
#if os(iOS) || os(watchOS)
import UIKit

public extension UIViewController {
  
  @inlinable
  func inclusiveParentViewControllerSequence() -> ParentViewControllerSequence {
    return ParentViewControllerSequence(initialViewController: self)
  }

  @inlinable
  func exclusiveParentViewControllerSequence() -> ParentViewControllerSequence {
    return ParentViewControllerSequence(initialViewController: self.parent)
  }
  
  @inlinable
  func parentViewControllerSequence(_ strategy: HierarchyEnumerationStrategy) -> ParentViewControllerSequence {
    switch strategy {
    case .inclusive:
      return self.inclusiveParentViewControllerSequence()
    case .exclusive:
      return self.exclusiveParentViewControllerSequence()
    }
  }
  
  @objc(hdxl_enumerateInclusiveParentViewControllerSequenceUsingBlock:)
  func __enumerateInclusiveParentViewControllerSequence(
    using block: (UIViewController, UnsafeMutablePointer<ObjCBool>) -> Void) {
    var stopRequested: ObjCBool = false
    for view in self.inclusiveParentViewControllerSequence() {
      block(view, &stopRequested)
      guard !stopRequested.boolValue else {
        return
      }
    }
  }

  @objc(hdxl_enumerateExclusiveParentViewControllerSequenceUsingBlock:)
  func __enumerateExclusiveParentViewControllerSequence(
    using block: (UIViewController, UnsafeMutablePointer<ObjCBool>) -> Void) {
    var stopRequested: ObjCBool = false
    for view in self.exclusiveParentViewControllerSequence() {
      block(view, &stopRequested)
      guard !stopRequested.boolValue else {
        return
      }
    }
  }
  
  @objc(hdxl_enumerateParentViewControllerSequenceWithStrategy:usingBlock:)
  func __enumerateParentViewControllerSequence(
    _ strategy: HierarchyEnumerationStrategy,
    using block: (UIViewController, UnsafeMutablePointer<ObjCBool>) -> Void) {
    switch strategy {
    case .inclusive:
      self.__enumerateInclusiveParentViewControllerSequence(
        using: block
      )
    case .exclusive:
      self.__enumerateExclusiveParentViewControllerSequence(
        using: block
      )
    }
  }


}

// -------------------------------------------------------------------------- //
// MARK: ParentViewControllerSequence - Definition
// -------------------------------------------------------------------------- //

/// Sequence with values like `view, view.parentViewController, view.parentViewController.parentViewController...`.
///
/// This is a *sequence* because we can't freeze the view hierarchy--if you need a collection, capture into an array.
///
@frozen
public struct ParentViewControllerSequence : Sequence {
  
  public typealias Element = UIViewController
  public typealias Iterator = ParentViewControllerSequenceIterator
  
  @usableFromInline
  internal let initialViewController: UIViewController?
  
  @inlinable
  internal init(initialViewController: UIViewController?) {
    self.initialViewController = initialViewController
  }
  
  @inlinable
  public var underestimatedCount: Int {
    switch self.initialViewController {
    case .some(_):
      return 1
    case .none:
      return 0
    }
  }
  
  @inlinable
  public func makeIterator() -> ParentViewControllerSequenceIterator {
    return ParentViewControllerSequenceIterator(currentViewcontroller: self.initialViewController)
  }
  
}

// -------------------------------------------------------------------------- //
// MARK: ParentViewControllerSequenceIterator - Definition
// -------------------------------------------------------------------------- //

/// Iterator type for `ParentViewControllerSequence`; would like to hide this behind `some Iterator` once we can.
@frozen
public struct ParentViewControllerSequenceIterator : IteratorProtocol {
  
  public typealias Element = UIViewController
  
  @usableFromInline
  internal var currentViewcontroller: UIViewController?
  
  @inlinable
  internal init(currentViewcontroller: UIViewController?) {
    self.currentViewcontroller = currentViewcontroller
  }
  
  @inlinable
  public mutating func next() -> Element? {
    guard let thisViewController = self.currentViewcontroller else {
      return nil
    }
    self.currentViewcontroller = thisViewController.parent
    return thisViewController
  }
  
}

#endif
