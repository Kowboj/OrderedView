//
//  HorizontalDirection.swift
//  
//
//  Created by Kamil Chołyk on 25/05/2022.
//

import UIKit

public struct Horizontal: Direction {
    public static func isComponentAdaptable(component: Component<Self>) -> Bool {
        component.layout.horizontal.isFixedSize && component.isAdaptable
    }
    
    public static func spacerLayoutRule(withSize size: LayoutRules.Size) -> LayoutRules {
        LayoutRules(vertical: .relational(percentOfParent: 100), horizontal: size)
    }
    
    public static func heightConstraints(forComponent component: Component<Self>,
                                  inView view: UIView) -> [NSLayoutConstraint] {
        var constraints = [NSLayoutConstraint]()
        switch component.layout.vertical {
        case .fixedSize(let size):
            constraints = [component.view.heightAnchor.constraint(equalToConstant: size),
                           component.view.centerYAnchor.constraint(equalTo: view.centerYAnchor)]
        case .fixedOffset(let offset):
            constraints = [component.view.topAnchor.constraint(equalTo: view.topAnchor, constant: offset),
                           component.view.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -offset)]
        case .relational(let percent):
            constraints = [component.view.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: percent/100),
                           component.view.centerYAnchor.constraint(equalTo: view.centerYAnchor)]
        case .aspectRatio(let multiplier, let maxOffset):
            constraints = [component.view.heightAnchor.constraint(equalTo: component.view.widthAnchor, multiplier: multiplier),
                           component.view.centerYAnchor.constraint(equalTo: view.centerYAnchor)]
            if let maxOffset = maxOffset {
                constraints.append(contentsOf: [
                    component.view.topAnchor.constraint(greaterThanOrEqualTo: view.topAnchor, constant: maxOffset),
                    component.view.bottomAnchor.constraint(lessThanOrEqualTo: view.bottomAnchor, constant: -maxOffset)
                ])
            }
        case .anyButSmaller:
            constraints = [component.view.topAnchor.constraint(equalTo: view.topAnchor),
                           component.view.bottomAnchor.constraint(lessThanOrEqualTo: view.bottomAnchor)]
        case .freeFalling:
            fatalError("Horizontal OrderedView can't set that rule")
        }
        return constraints
    }
    
    public static func widthConstraints(forComponent component: Component<Self>,
                                 inView view: UIView) -> [NSLayoutConstraint] {
        var constraints = [NSLayoutConstraint]()
        switch component.layout.horizontal {
        case .fixedSize(let size):
            if Self.isComponentAdaptable(component: component) {
                component.view.setContentHuggingPriority(.defaultHigh, for: .horizontal)
                constraints = [component.view.widthAnchor.constraint(greaterThanOrEqualToConstant: size).withPriority(.defaultLow)]
            } else {
                constraints = [component.view.widthAnchor.constraint(equalToConstant: size)]
            }
        case .fixedOffset:
            fatalError("Horizontal OrderedView can't set horizontal offset - use .spacer instead")
        case .relational(let percent):
            constraints = [component.view.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: percent/100)]
        case .aspectRatio(let multiplier, let maxOffset):
            guard maxOffset == nil else { fatalError("Horizontal OrderedView can't set horizontal offset - use .spacer instead") }
            constraints = [component.view.widthAnchor.constraint(equalTo: view.heightAnchor, multiplier: multiplier)]
        case .anyButSmaller:
            fatalError("Horizontal OrderedView can't set that rule")
        case .freeFalling(let willingToGrow, let minValue, let maxValue):
            component.view.setContentHuggingPriority(willingToGrow.layoutPriority, for: .horizontal)
            constraints = [component.view.widthAnchor.constraint(greaterThanOrEqualToConstant: minValue)]
            if let maxValue = maxValue {
                constraints.append(component.view.widthAnchor.constraint(lessThanOrEqualToConstant: maxValue))
            }
        }
        return constraints
    }
    
    public static func relationConstraints(forComponent component: Component<Horizontal>,
                                    atIndex index: Int,
                                    followedBy nextComponent: Component<Horizontal>?,
                                    inView view: UIView) -> [NSLayoutConstraint] {
        var constraints = [NSLayoutConstraint]()
        if index == 0 {
            constraints.append(component.view.leadingAnchor.constraint(equalTo: view.leadingAnchor))
        }
        constraints.append(component.view.trailingAnchor.constraint(equalTo: nextComponent == nil ? view.trailingAnchor : nextComponent!.view.leadingAnchor))
        return constraints
    }
    
    public static func expansionConstraints(forComponents components: [Component<Horizontal>]) -> [NSLayoutConstraint] {
        guard components.count > 1 else { return [] }
        var constraints = [NSLayoutConstraint]()
        for component in components.enumerated() {
            guard component.offset != components.count - 1 else { break }
                if case let .fixedSize(firstSize) = component.element.layout.horizontal,
                   case let .fixedSize(secondSize) = components[component.offset + 1].layout.horizontal {
                    constraints.append(component.element.view.widthAnchor.constraint(equalTo: components[component.offset + 1].view.widthAnchor, multiplier: (firstSize) / (secondSize) ))
                }
        }
        return constraints
    }
}
