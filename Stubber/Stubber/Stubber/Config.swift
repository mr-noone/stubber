//
//  Config.swift
//  Stubber
//
//  Created by Aleksey Zgurskiy on 09.07.2018.
//  Copyright © 2018 Graviti Mobail, TOV. All rights reserved.
//

import Foundation

protocol ConfigProtocol: class {
  associatedtype StubConfig: StubConfigProtocol
  associatedtype URLProtocol: Stubber.URLProtocol
  
  static var isConfigured: Bool { get }
  
  static func configure()
}

final class Config: ConfigProtocol {
  typealias StubConfig = Stubber.StubConfig
  typealias URLProtocol = StubURLProtocol<StubConfig>
  
  private(set) static var isConfigured: Bool = false
  
  static func configure() {
    if !isConfigured {
      Foundation.URLProtocol.registerClass(URLProtocol.self)
      URLSessionConfiguration.registerURLProtocol(URLProtocol.self)
      isConfigured = true
    }
  }
}
