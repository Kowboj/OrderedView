//
//  Component.swift
//  
//
//  Created by Kamil Chołyk on 25/05/2022.
//

import UIKit

public struct Component<T: Direction> {
    let view: UIView
    let layout: LayoutRules
    
    /// Spacers can be set as adaptable - the free space inside one OrderedView will be evenly distributed among all adaptable views (e.g. 10; 20; 20 -> 35; 70; 70). Works only for fixedSize spacers.
    let isAdaptable: Bool
    
    private init(view: UIView, layout: LayoutRules, isAdaptable: Bool) {
        self.view = view
        self.layout = layout
        self.isAdaptable = isAdaptable
    }
}

extension Component where T: Direction {
    public static func spacer(ofSize size: LayoutRules.Size, isAdaptable: Bool = false) -> Self {
        Component(view: UIView(),
                  layout: T.spacerLayoutRule(withSize: size),
                  isAdaptable: isAdaptable)
    }
    
    public static func view(_ view: UIView, withLayout layout: LayoutRules) -> Self {
        Component(view: view,
                  layout: layout,
                  isAdaptable: false)
    }
}
