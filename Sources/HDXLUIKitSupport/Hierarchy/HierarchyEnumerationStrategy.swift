//
//  HierarchyEnumerationStrategy.swift
//

import Foundation
#if os(iOS) || os(tvOS)
@objc(HDXLHierarchyEnumerationStrategy)
public enum HierarchyEnumerationStrategy : Int {
  
  case inclusive
  case exclusive
  
}
#endif
