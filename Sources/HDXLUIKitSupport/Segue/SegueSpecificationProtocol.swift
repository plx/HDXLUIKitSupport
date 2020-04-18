//
//  SegueSpecificationProtocol.swift
//

import Foundation
#if os(iOS) || os(tvOS)
import UIKit

@objc(HDXLSegueSpecification)
public protocol SegueSpecificationProtocol : NSObjectProtocol {
  
  var segueIdentifier: String { get }
  var developerExplanation: String { get }
  
  @objc(configureDestinationForSegue:)
  func configureDestination(for segue: UIStoryboardSegue)
  
}

#endif
