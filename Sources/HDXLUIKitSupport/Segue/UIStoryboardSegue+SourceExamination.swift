//
//  UIStoryboardSegue+SourceExamination.swift
//

import Foundation
#if os(iOS) || os(tvOS)
import UIKit

// -------------------------------------------------------------------------- //
// MARK: Source Examination - Just Source
// -------------------------------------------------------------------------- //

public extension UIStoryboardSegue {

  /// Streamlined way to get at *just* the *source* VC (*as* its expected type).
  /// Motivating scenario is in the handler method for an unwind segue: the destination
  /// is where you're unwinding *to*, the *source* is the VC that originated the unwind,
  /// and possibly the *destination* wants to extract some info *from* the *source*.
  @inlinable
  func accessSource<Source:UIViewController>(
    as kind: Source.Type,
    function: StaticString = #function,
    file: StaticString = #file,
    line: UInt = #line,
    using configuration: (Source) throws -> Void) rethrows {
    guard let expectedSource = self.source as? Source else {
      fatalError("For segue \(String(reflecting: self)), we expected \(String(reflecting: kind)) for source, but *encountered* source-VC \(String(reflecting: self.source)) in `\(function)` @ \(line) in \(file).")
    }
    try configuration(expectedSource)
  }
  
  /// Objective-C compatible access to the source.
  /// Technically *this* is superfluous, but I included it since it mirrors the "contextual parent" scenario.
  @objc(hdxl_accessSourceUsingBlock:)
  func __accessSource(using configuration: (UIViewController) -> Void) {
    self.accessSource(
      as: UIViewController.self,
      using: configuration
    )
  }
  
}

// -------------------------------------------------------------------------- //
// MARK: Source Examination - Just Source & Navigation
// -------------------------------------------------------------------------- //

public extension UIStoryboardSegue {

  /// Streamlined way to get at the *source* VC *as* its expected type *and* the navigation VC (as its expected type).
  /// Motivating scenario is in the handler method for an unwind segue: the destination
  /// is where you're unwinding *to*, the *source* is the VC that originated the unwind,
  /// and possibly the *destination* wants to extract some info *from* the *source*.
  @inlinable
  func accessWrappedSource<Source:UIViewController,Navigation:UINavigationController>(
    as kind: Source.Type,
    within navigation: Navigation.Type,
    function: StaticString = #function,
    file: StaticString = #file,
    line: UInt = #line,
    using configuration: (Source,Navigation) throws -> Void) rethrows {
    guard let expectedSource = self.source as? Source else {
      fatalError("For segue \(String(reflecting: self)), we expected \(String(reflecting: kind)) for source, but *encountered* source-VC \(String(reflecting: self.source)) in `\(function)` @ \(line) in \(file).")
    }
    guard let expectedNavigation = expectedSource.navigationController as? Navigation else {
      fatalError("For segue \(String(reflecting: self)), we expected \(String(reflecting: navigation)) for source.navigationController, but *encountered* source.navigationController \(String(reflecting: expectedSource.navigationController)) in `\(function)` @ \(line) in \(file).")
    }
    try configuration(expectedSource, expectedNavigation)
  }

  /// Streamlined way to get at the *source* VC *as* its expected type *and* the navigation VC (as its expected type).
  /// Motivating scenario is in the handler method for an unwind segue: the destination
  /// is where you're unwinding *to*, the *source* is the VC that originated the unwind,
  /// and possibly the *destination* wants to extract some info *from* the *source*.
  @inlinable
  func accessWrappedSource<Source:UIViewController>(
    as kind: Source.Type,
    function: StaticString = #function,
    file: StaticString = #file,
    line: UInt = #line,
    using configuration: (Source,UINavigationController) throws -> Void) rethrows {
    try self.accessWrappedSource(
      as: kind,
      within: UINavigationController.self,
      function: function,
      file: file,
      line: line,
      using: configuration
    )
  }

  /// Objective-C compatible access to the source.
  /// Technically *this* is superfluous, but I included it since it mirrors the "contextual parent" scenario.
  @objc(hdxl_accessWrappedSourceUsingBlock:)
  func __accessSource(using configuration: (UIViewController,UINavigationController) -> Void) {
    self.accessWrappedSource(
      as: UIViewController.self,
      within: UINavigationController.self,
      using: configuration
    )
  }
  
}

// -------------------------------------------------------------------------- //
// MARK: Source Examination - With Container
// -------------------------------------------------------------------------- //

public extension UIStoryboardSegue {
  
  /// Streamlined way to get at both the originating VC *and* its semantic container.
  ///
  /// - note: `Wrapped` is a poor choice, but embedded is used for the embed segue, and `configureNavigationDestination` sounds like you're confiugring the destination of a push segue.
  /// - note: Apparently we can't do `within navigation: Navigation.Type = UINavigationController.self`...so I had to have 2 variants of this method, instead.
  ///
  @inlinable
  func accessEmbeddedSource<Source:UIViewController,Container:UIViewController>(
    as source: Source.Type,
    in container: Container.Type,
    function: StaticString = #function,
    file: StaticString = #file,
    line: UInt = #line,
    using accessor: (Source,Container) throws -> Void) rethrows {
    guard let expectedSource = self.source as? Source else {
      fatalError("For segue \(String(reflecting: self)), we expected \(String(reflecting: source)) for source-VC type, but *encountered* source-VC \(String(reflecting: self.source)) in `\(function)` @ \(line) in \(file).")
    }
    guard let expectedContainer = expectedSource.effectivePrimarySemanticContainerViewController as? Container else {
      fatalError("For segue \(String(reflecting: self)), we expected \(String(reflecting: container)) for semantic-container-VC type, but *encountered* semantic-container-VC \(String(reflecting: expectedSource.effectivePrimarySemanticContainerViewController)) in `\(function)` @ \(line) in \(file).")
    }
    try accessor(expectedSource, expectedContainer)
  }

  /// Objective-C compatible access to the configuration target and its parent navigation VC.
  ///
  /// - note (we lose some call-context and type safety).
  @objc(hdxl_accessEmbeddedSourceUsingBlock:)
  func __accessEmbeddedSource(using accessor: (UIViewController, UIViewController) -> Void) {
    self.accessEmbeddedSource(
      as: UIViewController.self,
      in: UIViewController.self,
      using: accessor
    )
  }
  
}

// -------------------------------------------------------------------------- //
// MARK: Source Examination - With Container & Navigation
// -------------------------------------------------------------------------- //

public extension UIStoryboardSegue {
  
  /// Streamlined way to get at both the originating VC *and* its semantic container.
  ///
  /// - note: `Wrapped` is a poor choice, but embedded is used for the embed segue, and `configureNavigationDestination` sounds like you're confiugring the destination of a push segue.
  /// - note: Apparently we can't do `within navigation: Navigation.Type = UINavigationController.self`...so I had to have 2 variants of this method, instead.
  ///
  @inlinable
  func accessWrappedEmbeddedSource<Source:UIViewController,Container:UIViewController,Navigation:UINavigationController>(
    as source: Source.Type,
    in container: Container.Type,
    within navigation: Navigation.Type,
    function: StaticString = #function,
    file: StaticString = #file,
    line: UInt = #line,
    using accessor: (Source,Container,Navigation) throws -> Void) rethrows {
    guard let expectedSource = self.source as? Source else {
      fatalError("For segue \(String(reflecting: self)), we expected \(String(reflecting: source)) for source-VC type, but *encountered* source-VC \(String(reflecting: self.source)) in `\(function)` @ \(line) in \(file).")
    }
    guard let expectedContainer = expectedSource.effectivePrimarySemanticContainerViewController as? Container else {
      fatalError("For segue \(String(reflecting: self)), we expected \(String(reflecting: container)) for semantic-container-VC type, but *encountered* semantic-container-VC \(String(reflecting: expectedSource.effectivePrimarySemanticContainerViewController)) in `\(function)` @ \(line) in \(file).")
    }
    guard let expectedNavigation = expectedSource.navigationController as? Navigation else {
      fatalError("For segue \(String(reflecting: self)), we expected \(String(reflecting: navigation)) for source.navigationController, but *encountered* source.navigationController \(String(reflecting: expectedSource.navigationController)) in `\(function)` @ \(line) in \(file).")
    }
    try accessor(expectedSource, expectedContainer, expectedNavigation)
  }

  /// Streamlined way to get at both the originating VC *and* its semantic container.
  ///
  /// - note: `Wrapped` is a poor choice, but embedded is used for the embed segue, and `configureNavigationDestination` sounds like you're confiugring the destination of a push segue.
  /// - note: Apparently we can't do `within navigation: Navigation.Type = UINavigationController.self`...so I had to have 2 variants of this method, instead.
  ///
  @inlinable
  func accessWrappedEmbeddedSource<Source:UIViewController,Container:UIViewController>(
    as source: Source.Type,
    in container: Container.Type,
    function: StaticString = #function,
    file: StaticString = #file,
    line: UInt = #line,
    using accessor: (Source,Container,UINavigationController) throws -> Void) rethrows {
    try self.accessWrappedEmbeddedSource(
      as: source,
      in: container,
      within: UINavigationController.self,
      function: function,
      file: file,
      line: line,
      using: accessor
    )
  }

  /// Objective-C compatible access to the source, its container, and their parent navigation VC.
  @objc(hdxl_accessWrappedEmbeddedSourceUsingBlock:)
  func __accessWrappedEmbeddedSource(using accessor: (UIViewController, UIViewController, UINavigationController) -> Void) {
    self.accessWrappedEmbeddedSource(
      as: UIViewController.self,
      in: UIViewController.self,
      within: UINavigationController.self,
      using: accessor
    )
  }
  
}

#endif
