//
//  UIStoryBoardSegue+ConfigurationTargeting.swift
//

import Foundation
#if os(iOS) || os(tvOS)
import UIKit

// -------------------------------------------------------------------------- //
// MARK: Configuration Targeting - Just Destination
// -------------------------------------------------------------------------- //

public extension UIStoryboardSegue {

  /// Streamlined way to get at *just* the configuration-target for the destination.
  @inlinable
  func configureDestination<Destination:UIViewController>(
    as kind: Destination.Type,
    function: StaticString = #function,
    file: StaticString = #file,
    line: UInt = #line,
    using configuration: (Destination) throws -> Void) rethrows {
    guard let expectedDestination = self.destination as? Destination else {
      fatalError("For segue \(String(reflecting: self)), we expected \(String(reflecting: kind)) for destination, but *encountered* destination-VC \(String(reflecting: self.destination)) in `\(function)` @ \(line) in \(file).")
    }
    try configuration(expectedDestination)
  }
  
  /// Objective-C compatible access to the configuration target.
  ///
  /// - note (we lose some call-context and type safety).
  @objc(hdxl_configureDestinationUsingBlock:)
  func __configureDestination(using configuration: (UIViewController) -> Void) {
    self.configureDestination(
      as: UIViewController.self,
      using: configuration
    )
  }
  
}

// -------------------------------------------------------------------------- //
// MARK: Configuration Targeting - Expecting NavVC
// -------------------------------------------------------------------------- //

public extension UIStoryboardSegue {
  
  /// Streamlined way to get at both the configuration target *and* its parent navVC.
  ///
  /// - note: `Wrapped` is a poor choice, but embedded is used for the embed segue, and `configureNavigationDestination` sounds like you're confiugring the destination of a push segue.
  /// - note: Apparently we can't do `within navigation: Navigation.Type = UINavigationController.self`...so I had to have 2 variants of this method, instead.
  ///
  @inlinable
  func configureWrappedDestination<Destination:UIViewController,Navigation:UINavigationController>(
    as destination: Destination.Type,
    within navigation: Navigation.Type,
    function: StaticString = #function,
    file: StaticString = #file,
    line: UInt = #line,
    using configuration: (Destination,Navigation) throws -> Void) rethrows {
    guard let expectedNavigation = self.destination as? Navigation else {
      fatalError("For segue \(String(reflecting: self)), we expected \(String(reflecting: navigation)) for navigation-VC type, but *encountered* destination-VC \(String(reflecting: self.destination)) in `\(function)` @ \(line) in \(file).")
    }
    guard let expectedDestination = expectedNavigation.viewControllers.first as? Destination else {
      fatalError("For segue \(String(reflecting: self)), we expected \(String(reflecting: destination)) for configuration-destination-VC type, but *encountered* destination-VC \(String(reflecting: expectedNavigation.viewControllers.first)) in `\(function)` @ \(line) in \(file).")
    }
    try configuration(expectedDestination, expectedNavigation)
  }

  /// Streamlined way to get at both the configuration target *and* its parent navVC.
  ///
  /// - note: `Wrapped` is a poor choice, but embedded is used for the embed segue, and `configureNavigationDestination` sounds like you're confiugring the destination of a push segue.
  /// - note: Apparently we can't do `within navigation: Navigation.Type = UINavigationController.self`...so I had to have 2 variants of this method, instead.
  ///
  @inlinable
  func configureWrappedDestination<Destination:UIViewController>(
    as destination: Destination.Type,
    function: StaticString = #function,
    file: StaticString = #file,
    line: UInt = #line,
    using configuration: (Destination,UINavigationController) throws -> Void) rethrows {
    try self.configureWrappedDestination(
      as: destination,
      within: UINavigationController.self,
      function: function,
      file: file,
      line: line,
      using: configuration
    )
  }

  /// Objective-C compatible access to the configuration target and its parent navigation VC.
  ///
  /// - note (we lose some call-context and type safety).
  @objc(hdxl_configureWrappedDestinationUsingBlock:)
  func __configureDestination(using configuration: (UIViewController,UINavigationController) -> Void) {
    self.configureWrappedDestination(
      as: UIViewController.self,
      using: configuration
    )
  }
  
}

#endif
