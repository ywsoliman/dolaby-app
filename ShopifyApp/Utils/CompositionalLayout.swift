//
//  CompositionalLayout.swift
//  ShopifyApp
//
//  Created by Youssef Waleed on 20/06/2024.
//

import Foundation
import UIKit

enum CompositionalGroupAlignment {
    case horizontal
    case vertical
}

struct CompositionalLayout {
    
    private init() {}
    
    static func createItem(
        width: NSCollectionLayoutDimension,
        height: NSCollectionLayoutDimension,
        spacing: CGFloat
    ) -> NSCollectionLayoutItem {
        
        let item = NSCollectionLayoutItem(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: width,
                heightDimension: height
            )
        )
        
        item.contentInsets = NSDirectionalEdgeInsets(
            top: spacing / 2,
            leading: spacing,
            bottom: spacing / 2,
            trailing: spacing
        )
        
        return item
        
    }
    
    static func createGroup(
        alignment: CompositionalGroupAlignment,
        width: NSCollectionLayoutDimension,
        height: NSCollectionLayoutDimension,
        items: [NSCollectionLayoutItem]
    ) -> NSCollectionLayoutGroup {
        
        switch alignment {
        case .horizontal:
            return NSCollectionLayoutGroup.horizontal(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: width,
                    heightDimension: height
                ), subitems: items
            )
        case .vertical:
            return NSCollectionLayoutGroup.vertical(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: width,
                    heightDimension: height
                ), subitems: items
            )
        }
        
    }
    
    static func createGroup(
        alignment: CompositionalGroupAlignment,
        width: NSCollectionLayoutDimension,
        height: NSCollectionLayoutDimension,
        item: NSCollectionLayoutItem,
        count: Int
    ) -> NSCollectionLayoutGroup {
        
        switch alignment {
        case .horizontal:
            return NSCollectionLayoutGroup.horizontal(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: width,
                    heightDimension: height
                ), repeatingSubitem: item, count: count
            )
        case .vertical:
            return NSCollectionLayoutGroup.vertical(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: width,
                    heightDimension: height
                ), repeatingSubitem: item, count: count
            )
        }
        
    }
    
}
