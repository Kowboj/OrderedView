//
//  OrderedView.swift
//  
//
//  Created by Kamil Chołyk on 25/05/2022.
//

import UIKit

public class OrderedView<T: Direction>: UIView {
    let components: [Component<T>]
    
    public init(arrangedComponents components: [Component<T>]) {
        self.components = components
        super.init(frame: .zero)
        setupComponents()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupComponents() {
        var constraints = [NSLayoutConstraint]()
        
        for component in components.enumerated() {
            component.element.view.translatesAutoresizingMaskIntoConstraints = false
            addSubview(component.element.view)
            constraints.append(contentsOf: T.heightConstraints(forComponent: component.element,
                                                               inView: self))
            constraints.append(contentsOf: T.widthConstraints(forComponent: component.element,
                                                              inView: self))
            constraints.append(contentsOf: T.relationConstraints(forComponent: component.element,
                                                                 atIndex: component.offset,
                                                                 followedBy: components[safe: component.offset + 1],
                                                                 inView: self))
        }
        constraints.append(contentsOf: T.expansionConstraints(forComponents: components.filter { T.isComponentAdaptable(component: $0) }))
        NSLayoutConstraint.activate(constraints)
    }
}
