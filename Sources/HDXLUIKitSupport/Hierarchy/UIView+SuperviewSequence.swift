//
//  UIView+SuperviewSequence.swift
//

import Foundation
#if os(iOS) || os(watchOS)
import UIKit

public extension UIView {
  
  @inlinable
  func inclusiveSuperviewSequence() -> SuperviewSequence {
    return SuperviewSequence(initialView: self)
  }

  @inlinable
  func exclusiveSuperviewSequence() -> SuperviewSequence {
    return SuperviewSequence(initialView: self.superview)
  }
  
  @inlinable
  func superviewSequence(_ strategy: HierarchyEnumerationStrategy) -> SuperviewSequence {
    switch strategy {
    case .inclusive:
      return self.inclusiveSuperviewSequence()
    case .exclusive:
      return self.exclusiveSuperviewSequence()
    }
  }
  
  @objc(hdxl_enumerateInclusiveSuperviewSequenceUsingBlock:)
  func __enumerateInclusiveSuperviewSequence(
    using block: (UIView, UnsafeMutablePointer<ObjCBool>) -> Void) {
    var stopRequested: ObjCBool = false
    for view in self.inclusiveSuperviewSequence() {
      block(view, &stopRequested)
      guard !stopRequested.boolValue else {
        return
      }
    }
  }

  @objc(hdxl_enumerateExclusiveSuperviewSequenceUsingBlock:)
  func __enumerateExclusiveSuperviewSequence(
    using block: (UIView, UnsafeMutablePointer<ObjCBool>) -> Void) {
    var stopRequested: ObjCBool = false
    for view in self.exclusiveSuperviewSequence() {
      block(view, &stopRequested)
      guard !stopRequested.boolValue else {
        return
      }
    }
  }
  
  @objc(hdxl_enumerateSuperviewSequenceWithStrategy:usingBlock:)
  func __enumerateSuperviewSequence(
    _ strategy: HierarchyEnumerationStrategy,
    using block: (UIView, UnsafeMutablePointer<ObjCBool>) -> Void) {
    switch strategy {
    case .inclusive:
      self.__enumerateInclusiveSuperviewSequence(
        using: block
      )
    case .exclusive:
      self.__enumerateExclusiveSuperviewSequence(
        using: block
      )
    }
  }


}

// -------------------------------------------------------------------------- //
// MARK: SuperviewSequence - Definition
// -------------------------------------------------------------------------- //

/// Sequence with values like `view, view.superview, view.superview.superview...`.
///
/// This is a *sequence* because we can't freeze the view hierarchy--if you need a collection, capture into an array.
///
@frozen
public struct SuperviewSequence : Sequence {
  
  public typealias Element = UIView
  public typealias Iterator = SuperviewSequenceIterator
  
  @usableFromInline
  internal let initialView: UIView?
  
  @inlinable
  internal init(initialView: UIView?) {
    self.initialView = initialView
  }
  
  @inlinable
  public var underestimatedCount: Int {
    switch self.initialView {
    case .some(_):
      return 1
    case .none:
      return 0
    }
  }
  
  @inlinable
  public func makeIterator() -> SuperviewSequenceIterator {
    return SuperviewSequenceIterator(currentView: self.initialView)
  }
  
}

// -------------------------------------------------------------------------- //
// MARK: SuperviewSequenceIterator - Definition
// -------------------------------------------------------------------------- //

/// Iterator type for `SuperviewSequence`; would like to hide this behind `some Iterator` once we can.
@frozen
public struct SuperviewSequenceIterator : IteratorProtocol {
  
  public typealias Element = UIView
  
  @usableFromInline
  internal var currentView: UIView?
  
  @inlinable
  internal init(currentView: UIView?) {
    self.currentView = currentView
  }
  
  @inlinable
  public mutating func next() -> Element? {
    guard let thisView = self.currentView else {
      return nil
    }
    self.currentView = thisView.superview
    return thisView
  }
  
}

#endif
