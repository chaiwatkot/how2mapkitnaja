//
//  ErrorMessageSame.swift
//  MapKitNaja
//
//  Created by CHAIWAT CHANTHASEN on 22/4/2563 BE.
//  Copyright © 2563 CHAIWAT CHANTHASEN. All rights reserved.
//

import Foundation

public struct ErrorMessageSame: Error {
  public static var error: String = "error"
  public static var errorMessage: String = "error but error message"
  public static var okJa: String = "OK"
}

public enum UserResult<T> {
  case success(result: T)
  case failure(error: UserError)
}

public struct UserError: Error {
  public let title: String
  public let message: String
  
  init(title: String = ErrorMessageSame.error, message: String = ErrorMessageSame.errorMessage) {
    self.title = title
    self.message = message
  }
}
