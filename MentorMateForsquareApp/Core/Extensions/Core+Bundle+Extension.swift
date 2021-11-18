//
//  Core+Bundle+Extension.swift
//  MentorMateForsquareApp
//
//  Created by Tornike Gomareli on 11.11.21.
//

import Foundation

extension Bundle {
  enum BundleInfoKey: String {
    case clientId = "clientId"
    case clientSecret = "clientSecret"
  }
    
  func getConfig<Type>(key: Bundle.BundleInfoKey, orDefault defaultValue: Type) -> Type {
    return infoDictionary?[key.rawValue] as? Type ?? defaultValue
  }
}
