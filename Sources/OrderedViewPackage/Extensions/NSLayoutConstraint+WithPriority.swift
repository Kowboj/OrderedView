//
//  NSLayoutConstraint+WithPriority.swift
//  
//
//  Created by Kamil Chołyk on 25/05/2022.
//

import UIKit

extension NSLayoutConstraint {
    func withPriority(_ priority: UILayoutPriority) -> NSLayoutConstraint {
        self.priority = priority
        return self
    }
}
