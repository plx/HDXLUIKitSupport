//
//  UIResponder+NextResponderSequence.swift
//

import Foundation
#if os(iOS) || os(watchOS)
import UIKit

public extension UIResponder {
  
  @inlinable
  func inclusiveNextResponderSequence() -> NextResponderSequence {
    return NextResponderSequence(initialResponder: self)
  }

  @inlinable
  func exclusiveNextResponderSequence() -> NextResponderSequence {
    return NextResponderSequence(initialResponder: self.next)
  }
  
  @inlinable
  func nextResponderSequence(_ strategy: HierarchyEnumerationStrategy) -> NextResponderSequence {
    switch strategy {
    case .inclusive:
      return self.inclusiveNextResponderSequence()
    case .exclusive:
      return self.exclusiveNextResponderSequence()
    }
  }
  
  @objc(hdxl_enumerateInclusiveNextResponderSequenceUsingBlock:)
  func __enumerateInclusiveNextResponderSequence(
    using block: (UIResponder, UnsafeMutablePointer<ObjCBool>) -> Void) {
    var stopRequested: ObjCBool = false
    for Responder in self.inclusiveNextResponderSequence() {
      block(Responder, &stopRequested)
      guard !stopRequested.boolValue else {
        return
      }
    }
  }

  @objc(hdxl_enumerateExclusiveNextResponderSequenceUsingBlock:)
  func __enumerateExclusiveNextResponderSequence(
    using block: (UIResponder, UnsafeMutablePointer<ObjCBool>) -> Void) {
    var stopRequested: ObjCBool = false
    for Responder in self.exclusiveNextResponderSequence() {
      block(Responder, &stopRequested)
      guard !stopRequested.boolValue else {
        return
      }
    }
  }
  
  @objc(hdxl_enumerateNextResponderSequenceWithStrategy:usingBlock:)
  func __enumerateNextResponderSequence(
    _ strategy: HierarchyEnumerationStrategy,
    using block: (UIResponder, UnsafeMutablePointer<ObjCBool>) -> Void) {
    switch strategy {
    case .inclusive:
      self.__enumerateInclusiveNextResponderSequence(
        using: block
      )
    case .exclusive:
      self.__enumerateExclusiveNextResponderSequence(
        using: block
      )
    }
  }


}

// -------------------------------------------------------------------------- //
// MARK: NextResponderSequence - Definition
// -------------------------------------------------------------------------- //

/// Sequence with values like `Responder, Responder.nextResponder, Responder.nextResponder.nextResponder...`.
///
/// This is a *sequence* because we can't freeze the Responder hierarchy--if you need a collection, capture into an array.
///
@frozen
public struct NextResponderSequence : Sequence {
  
  public typealias Element = UIResponder
  public typealias Iterator = NextResponderSequenceIterator
  
  @usableFromInline
  internal let initialResponder: UIResponder?
  
  @inlinable
  internal init(initialResponder: UIResponder?) {
    self.initialResponder = initialResponder
  }
  
  @inlinable
  public var underestimatedCount: Int {
    switch self.initialResponder {
    case .some(_):
      return 1
    case .none:
      return 0
    }
  }
  
  @inlinable
  public func makeIterator() -> NextResponderSequenceIterator {
    return NextResponderSequenceIterator(currentResponder: self.initialResponder)
  }
  
}

// -------------------------------------------------------------------------- //
// MARK: NextResponderSequenceIterator - Definition
// -------------------------------------------------------------------------- //

/// Iterator type for `NextResponderSequence`; would like to hide this behind `some Iterator` once we can.
@frozen
public struct NextResponderSequenceIterator : IteratorProtocol {
  
  public typealias Element = UIResponder
  
  @usableFromInline
  internal var currentResponder: UIResponder?
  
  @inlinable
  internal init(currentResponder: UIResponder?) {
    self.currentResponder = currentResponder
  }
  
  @inlinable
  public mutating func next() -> Element? {
    guard let thisResponder = self.currentResponder else {
      return nil
    }
    self.currentResponder = thisResponder.next
    return thisResponder
  }
  
}

#endif
