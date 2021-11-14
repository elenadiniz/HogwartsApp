//
//  UserDefaults+Extension.swift
//  HogwartsApp
//
//  Created by Maysa on 10/11/21.
//

import UIKit

extension UserDefaults{
    
    enum UserDefaultsKeys: String, CaseIterable{
        case myHouse
        case signedInUser
        func backgroundColor(name: String) -> UIColor{
            print(name)
            switch name {
            case "Grifinória":
                return UIColor(red: 0.48, green: 0.04, blue: 0.08, alpha: 1.00)
            case "Lufa-lufa":
                return UIColor(red: 0.95, green: 0.69, blue: 0.10, alpha: 1.00)
            case "Corvinal":
                return UIColor(red: 0.20, green: 0.32, blue: 0.52, alpha: 1.00)
            case "Sonserina":
                return UIColor(red: 0.03, green: 0.24, blue: 0.14, alpha: 1.00)
            default:
                return .black
            }
        
        }
    }
    
    var myHouse: String{
        get{
            string(forKey: UserDefaultsKeys.myHouse.rawValue) ?? ""
            
        }
        set {
            set(newValue, forKey: UserDefaultsKeys.myHouse.rawValue)
        }
    }
    
    var signedInUser: SaveUserFirebase? {
        
        get {
            if let data = object (forKey: UserDefaultsKeys.signedInUser.rawValue) as? Data{
                let user = try? JSONDecoder().decode(SaveUserFirebase.self, from: data)
                return user
            }
            return nil
            
        }
        set{
            if newValue == nil {
                removeObject(forKey: UserDefaultsKeys.signedInUser.rawValue)
            }else{
                let data = try? JSONEncoder().encode(newValue)
                set(data, forKey: UserDefaultsKeys.signedInUser.rawValue)
            }
        }
    }
    
    func clear(){
        
        
        UserDefaultsKeys.allCases.forEach { key in
            removeObject(forKey: key.rawValue)
        }
        
        
    }
}
