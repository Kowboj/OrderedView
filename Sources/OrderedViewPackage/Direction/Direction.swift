//
//  Direction.swift
//  
//
//  Created by Kamil Chołyk on 25/05/2022.
//

import UIKit

public protocol Direction {
    static func isComponentAdaptable(component: Component<Self>) -> Bool
    static func spacerLayoutRule(withSize size: LayoutRules.Size) -> LayoutRules
    static func heightConstraints(forComponent component: Component<Self>,
                                  inView view: UIView) -> [NSLayoutConstraint]
    static func widthConstraints(forComponent component: Component<Self>,
                                 inView view: UIView) -> [NSLayoutConstraint]
    static func relationConstraints(forComponent component: Component<Self>,
                                    atIndex index: Int,
                                    followedBy nextComponent: Component<Self>?,
                                    inView view: UIView) -> [NSLayoutConstraint]
    static func expansionConstraints(forComponents components: [Component<Self>]) -> [NSLayoutConstraint]
}
