//
//  LayoutRules.swift
//  
//
//  Created by Kamil Chołyk on 25/05/2022.
//

import UIKit

public struct LayoutRules {
    
    public enum WillingToGrow {
        case veryMuch
        case notThatMuch
        case nope
        
        var layoutPriority: UILayoutPriority {
            switch self {
            case .veryMuch:
                return .defaultLow
            case .notThatMuch:
                return .defaultHigh
            case .nope:
                return .required
            }
        }
    }
    
    public enum Size {
        case fixedSize(_: CGFloat)
        case fixedOffset(_: CGFloat)
        case relational(percentOfParent: CGFloat)
        case aspectRatio(multiplier: CGFloat, minOffset: CGFloat?)
        case anyButSmaller
        case freeFalling(expansion: WillingToGrow, minValue: CGFloat, maxValue: CGFloat?)
        
        var isFixedSize: Bool {
            switch self {
            case .fixedSize: return true
            case .relational, .aspectRatio, .fixedOffset, .anyButSmaller, .freeFalling: return false
            }
        }
    }
    
    let vertical: Size
    let horizontal: Size
    
    public init(vertical: Size, horizontal: Size) {
        self.vertical = vertical
        self.horizontal = horizontal
    }
}
