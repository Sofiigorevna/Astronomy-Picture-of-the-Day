//
//  CollectionViewLayout.swift
//  Astronomy Picture of the Day
//
//  Created by 1234 on 08.02.2024.
//

import Foundation
import UIKit

struct UIHelper {

    static func createCollectionLayoutSection() -> NSCollectionLayoutSection {
        let spacing: CGFloat = 10
        
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(0.5),
            heightDimension: .fractionalHeight(1)
        )
        let item = NSCollectionLayoutItem(
            layoutSize: itemSize
        )
        item.contentInsets = .init(
            top: 4, leading: 4, bottom: 4, trailing: 4
        )
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .absolute(160)
        )
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: groupSize,
            subitems: [item]
        )
        
        let layoutSection = NSCollectionLayoutSection(group: group)
        
        layoutSection.contentInsets = .init(
            top: spacing,
            leading: spacing,
            bottom: spacing,
            trailing: spacing)
        
        layoutSection.interGroupSpacing = spacing
        
        layoutSection.orthogonalScrollingBehavior = .none
        
        // Header
        let layoutSectionHeaderSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .fractionalWidth(1.0/2.1)
        )
        let layoutSectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: layoutSectionHeaderSize,
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .top
        )
        
        layoutSectionHeader.contentInsets = .init(
            top: 0, leading: 4, bottom: 0, trailing: 4
        )
        
        layoutSection.boundarySupplementaryItems = [layoutSectionHeader]
        
        return layoutSection
        
    }
}
