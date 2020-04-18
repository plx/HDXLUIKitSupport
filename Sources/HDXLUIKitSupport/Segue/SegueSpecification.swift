//
//  SegueSpecification.swift
//

import Foundation
#if os(iOS) || os(tvOS)
import UIKit

open class SegueSpecification<Destination:UIViewController> : NSObject, SegueSpecificationProtocol {
  
  public typealias Configuration = (UIViewController,Destination) -> Void
  
  public let segueIdentifier: String
  public let developerExplanation: String
  
  internal let functionOfOrigin: String
  internal let fileOfOrigin: String
  internal let lineOfOrigin: UInt
  
  @usableFromInline
  internal let configuration: Configuration
  
  @usableFromInline
  internal fileprivate(set) var configurationCount: Int = 0
  
  required public init(
    segueIdentifier: String,
    developerExplanation: String,
    expectedDestination: Destination.Type,
    functionOfOrigin: StaticString = #function,
    fileOfOrigin: StaticString = #file,
    lineOfOrigin: UInt = #line,
    configuration: @escaping Configuration) {
    self.segueIdentifier = segueIdentifier
    self.developerExplanation = developerExplanation
    self.functionOfOrigin = "\(functionOfOrigin)"
    self.fileOfOrigin = "\(fileOfOrigin)"
    self.lineOfOrigin = lineOfOrigin
    self.configuration = configuration
  }
  
  deinit {
    precondition(self.configurationCount == 1)
  }
  
  @objc
  public func configureDestination(for segue: UIStoryboardSegue) {
    dispatchPrecondition(condition: .onQueue(.main))
    precondition(self.configurationCount == 1)
    defer { self.configurationCount += 1}
    segue.configureDestination(as: Destination.self) {
      (semanticDestination: Destination) -> Void
      in
      self.configuration(segue.destination, semanticDestination)
    }
  }

  
}

#endif
