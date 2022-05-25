//
//  Collection+Safe.swift
//  
//
//  Created by Kamil Chołyk on 25/05/2022.
//

extension Collection {
    subscript(safe index: Index) -> Element? {
        indices.contains(index) ? self[index] : nil
    }
}
