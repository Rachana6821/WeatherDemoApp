//
//  Extensions.swift
//  WeatherApplication
//
//  Created by Rachana  on 28/05/23.
//

import Foundation
import UIKit

extension UIStoryboard {
    func instantiate<T>() -> T {
        return instantiateViewController(withIdentifier: String(describing: T.self)) as! T
    }

    static let main = UIStoryboard(name: "Main", bundle: nil)
}
