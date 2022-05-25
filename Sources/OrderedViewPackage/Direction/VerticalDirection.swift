//
//  VerticalDirection.swift
//  
//
//  Created by Kamil Chołyk on 25/05/2022.
//

import UIKit

public struct Vertical: Direction {
    public static func isComponentAdaptable(component: Component<Self>) -> Bool {
        component.layout.vertical.isFixedSize && component.isAdaptable
    }
    
    public static func spacerLayoutRule(withSize size: LayoutRules.Size) -> LayoutRules {
        LayoutRules(vertical: size, horizontal: .relational(percentOfParent: 100))
    }
    
    public static func heightConstraints(forComponent component: Component<Self>,
                                  inView view: UIView) -> [NSLayoutConstraint] {
        var constraints = [NSLayoutConstraint]()
        switch component.layout.vertical {
        case .fixedSize(let size):
            if Self.isComponentAdaptable(component: component) {
                component.view.setContentHuggingPriority(.defaultHigh, for: .vertical)
                constraints = [component.view.heightAnchor.constraint(greaterThanOrEqualToConstant: size).withPriority(.defaultLow)]
            } else {
                constraints = [component.view.heightAnchor.constraint(equalToConstant: size)]
            }
        case .fixedOffset:
            fatalError("Vertical OrderedView can't set vertical offset - use .spacer instead")
        case .relational(let percent):
            constraints = [component.view.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: percent/100)]
        case .aspectRatio(let multiplier, let maxOffset):
            guard maxOffset == nil else { fatalError("Vertical OrderedView can't set vertical offset - use .spacer instead") }
            constraints = [component.view.heightAnchor.constraint(equalTo: component.view.widthAnchor, multiplier: multiplier)]
        case .anyButSmaller:
            fatalError("Vertical OrderedView can't set that rule")
        case .freeFalling(let willingToGrow, let minValue, let maxValue):
            component.view.setContentHuggingPriority(willingToGrow.layoutPriority, for: .vertical)
            constraints = [component.view.heightAnchor.constraint(greaterThanOrEqualToConstant: minValue)]
            if let maxValue = maxValue {
                constraints.append(component.view.heightAnchor.constraint(lessThanOrEqualToConstant: maxValue))
            }
        }
        return constraints
    }
    
    public static func widthConstraints(forComponent component: Component<Self>,
                                 inView view: UIView) -> [NSLayoutConstraint] {
        var constraints = [NSLayoutConstraint]()
        switch component.layout.horizontal {
        case .fixedSize(let size):
            constraints = [component.view.widthAnchor.constraint(equalToConstant: size),
                           component.view.centerXAnchor.constraint(equalTo: view.centerXAnchor)]
        case .fixedOffset(let offset):
            constraints = [component.view.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: offset),
                           component.view.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -offset)]
        case .relational(let percent):
            constraints = [component.view.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: percent/100),
                           component.view.centerXAnchor.constraint(equalTo: view.centerXAnchor)]
        case .aspectRatio(let multiplier, let maxOffset):
            constraints = [component.view.widthAnchor.constraint(equalTo: component.view.heightAnchor, multiplier: multiplier),
                           component.view.centerXAnchor.constraint(equalTo: view.centerXAnchor)]
            if let maxOffset = maxOffset {
                constraints.append(contentsOf: [
                    component.view.leadingAnchor.constraint(greaterThanOrEqualTo: view.leadingAnchor, constant: maxOffset),
                    component.view.trailingAnchor.constraint(lessThanOrEqualTo: view.trailingAnchor, constant: -maxOffset)
                ])
            }
        case .anyButSmaller:
            constraints = [component.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                           component.view.trailingAnchor.constraint(lessThanOrEqualTo: view.trailingAnchor)]
        case .freeFalling:
            fatalError("Vertical OrderedView can't set that rule")
        }
        return constraints
    }
    
    public static func relationConstraints(forComponent component: Component<Self>,
                                    atIndex index: Int,
                                    followedBy nextComponent: Component<Self>?,
                                    inView view: UIView) -> [NSLayoutConstraint] {
        var constraints = [NSLayoutConstraint]()
        if index == 0 {
            constraints.append(component.view.topAnchor.constraint(equalTo: view.topAnchor))
        }
        constraints.append(component.view.bottomAnchor.constraint(equalTo: nextComponent == nil ? view.bottomAnchor : nextComponent!.view.topAnchor))
        return constraints
    }
    
    public static func expansionConstraints(forComponents components: [Component<Vertical>]) -> [NSLayoutConstraint] {
        guard components.count > 1 else { return [] }
        var constraints = [NSLayoutConstraint]()
        for component in components.enumerated() {
            guard component.offset != components.count - 1 else { break }
            if case let .fixedSize(firstSize) = component.element.layout.vertical,
               case let .fixedSize(secondSize) = components[component.offset + 1].layout.vertical {
                constraints.append(component.element.view.heightAnchor.constraint(equalTo: components[component.offset + 1].view.heightAnchor, multiplier: (firstSize) / (secondSize) ))
            }
        }
        return constraints
    }
}
