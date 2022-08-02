//
//  MineSweeperMapCollectionViewCell.swift
//  MineSweeper
//
//  Created by J_Min on 2022/08/01.
//

import UIKit
import SnapKit

final class MineSweeperMapCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "MineSweeperMapCollectionViewCell"
    
    // MARK: - ViewProperties
    let mineImageView: UIImageView = {
        let imageView = UIImageView()
        
        return imageView
    }()
    
    // MARK: - LifeCycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .gray
        configureSubViews()
        setConstraintsOfMineImageView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Method
    override func prepareForReuse() {
        contentView.backgroundColor = .gray
    }
    
    private func configureSubViews() {
        [mineImageView].forEach {
            contentView.addSubview($0)
        }
    }
    
    private func setConstraintsOfMineImageView() {
        mineImageView.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(4)
        }
    }
    
    func configureCell(with mapState: MapState) {
        mineImageView.image = mapState.image
        mineImageView.tintColor = mapState.imageColor
        
        if mapState == .empty {
            contentView.backgroundColor = .lightGray
        }
    }
}
