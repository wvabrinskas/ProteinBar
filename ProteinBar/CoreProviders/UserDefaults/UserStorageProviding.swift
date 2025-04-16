//
//  UserStorageProvider.swift
//  ProteinBar
//
//  Created by William Vabrinskas on 4/16/25.
//

import Foundation

public protocol StorageKeying: RawRepresentable<String> {
  func defaultValue<T: Eraseable>() -> T?
}

public protocol Eraseable {
  associatedtype Value: Hashable
  func erased() -> Value
}

public protocol UserStorageProviding: Sendable {
  associatedtype Keys: StorageKeying
  func getObject<T: Eraseable>(key: Keys) -> T?
  func setObject<T: Eraseable>(key: Keys, object: T?)
  func getDataObject<T: Decodable>(key: Keys) -> T?
  func setDataObject<T: Encodable>(key: Keys, data: T?)
  func deleteObject(key:  Keys)
  init(defaults: UserDefaults)
}

// I dont think this needs to be shared.
// maybe consider instantiating this whereever we need with
// custom key classes passed in
public final class UserStorageProvider<Keys: StorageKeying>: UserStorageProviding, Sendable {
  private let userDefaults: UserDefaults // does not conform to sendable
  
  public required init(defaults: UserDefaults) {
    self.userDefaults = defaults
  }
  
  public func getObject<T: Eraseable>(key: Keys) -> T? {
    let defaultValue: T? = key.defaultValue()
    
    if let obj = userDefaults.object(forKey: key.rawValue) {
      return (obj as? T) ?? nil
    } else {
      setObject(key: key, object: defaultValue)
      return defaultValue
    }
  }
  
  public func setObject<T: Eraseable>(key:  Keys, object: T?) {
    if let object {
      userDefaults.set(object.erased(), forKey: key.rawValue)
    } else {
      userDefaults.removeObject(forKey: key.rawValue)
    }
  }
  
  public func deleteObject(key:  Keys) {
    userDefaults.removeObject(forKey: key.rawValue)
  }
  
  public func getDataObject<T: Decodable>(key: Keys) -> T? {
    if let object: Data = getObject(key: key) {
      do {
        let obj = try JSONDecoder().decode(T.self, from: object)
        return obj
      } catch {
        return nil
      }
    }
    
    return nil
  }
  
  public func setDataObject<T: Encodable>(key: Keys, data: T) {
    do {
      let encode = try JSONEncoder().encode(data)
      setObject(key: key, object: encode)
    } catch {
    }
  }
}

extension UserDefaults: @retroactive @unchecked Sendable {}

extension Date: Eraseable {
  public typealias Value = Date
  
  public func erased() -> Date {
    self
  }
}

extension Double: Eraseable  {
  public typealias Value = Double
  
  public func erased() -> Double {
    self
  }
}

extension Data: Eraseable {
  public typealias Value = Data
  
  public func erased() -> Data {
    self
  }
}

extension String: Eraseable {
  public typealias Value = String
  
  public func erased() -> String {
    self
  }
}

extension Int: Eraseable {
  public typealias Value = Int
  
  public func erased() -> Int {
    self
  }
}

extension Bool: Eraseable {
  public typealias Value = Bool
  
  public func erased() -> Bool {
    self
  }
}

extension UUID: Eraseable {
  public typealias Value = String
  
  public func erased() -> String {
    self.uuidString
  }
}
