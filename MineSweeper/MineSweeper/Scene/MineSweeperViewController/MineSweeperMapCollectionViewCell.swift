//
//  MineSweeperMapCollectionViewCell.swift
//  MineSweeper
//
//  Created by J_Min on 2022/08/01.
//

import UIKit

final class MineSweeperMapCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "MineSweeperMapCollectionViewCell"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .yellow
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
