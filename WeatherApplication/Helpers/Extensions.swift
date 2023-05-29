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


extension UITextField {
    func addLeftPadding(_ padding: CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: padding, height: frame.height))
        leftView = paddingView
        leftViewMode = .always
    }
}
extension UIDevice {
    var hasNotch: Bool {
        let bottom = UIApplication.shared.keyWindow?.safeAreaInsets.bottom ?? 0
        return bottom > 0
    }
}
