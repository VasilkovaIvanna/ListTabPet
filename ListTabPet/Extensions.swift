import Foundation
import UIKit
import SwiftUI

extension UIColor {
    class var customOrange: UIColor? { UIColor(named: "Orange") }
    class var customGreen: UIColor? { UIColor(named: "Green") }
    class var customBlue: UIColor? { UIColor(named: "Blue") }
    class var customGray: UIColor? { UIColor(named: "Gray") }
    class var lightBlue: UIColor? { UIColor(named: "LightBlue") }
}

extension Color {
    public static var lightBlue: Color { return Color(UIColor.lightBlue ?? .white) }
    public static var customOrange: Color { return Color(UIColor.customOrange ?? .orange) }
    public static var customGreen: Color { return Color(UIColor.customGreen ?? .green) }
    public static var customBlue: Color { return Color(UIColor.customBlue ?? .blue) }
    public static var customGray: Color { return Color(UIColor.customGray ?? .lightGray) }
}
