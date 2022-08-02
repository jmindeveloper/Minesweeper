//
//  MineSweeperViewController.swift
//  MineSweeper
//
//  Created by J_Min on 2022/08/01.
//

import UIKit
import SnapKit

final class MineSweeperViewController: UIViewController {
    
    let manager = MineSweeperGameManager()
    
    // MARK: - ViewProperties
    private lazy var mineSweeperMapCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(
            MineSweeperMapCollectionViewCell.self,
            forCellWithReuseIdentifier: MineSweeperMapCollectionViewCell.identifier
        )
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        
        return collectionView
    }()
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        configureSubViews()
        setConstraintsOfMineSweeperMapCollectionView()
    }
}

// MARK: - UI
extension MineSweeperViewController {
    private func configureSubViews() {
        [mineSweeperMapCollectionView].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
    }
    
    private func setConstraintsOfMineSweeperMapCollectionView() {
        mineSweeperMapCollectionView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.equalToSuperview()
            $0.height.equalToSuperview().multipliedBy(0.7)
        }
    }
}

// MARK: - UICollectionViewDataSource
extension MineSweeperViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return manager.map.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return manager.map.first?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: MineSweeperMapCollectionViewCell.identifier,
            for: indexPath) as? MineSweeperMapCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.configureCell(with: mockupMap[indexPath.section][indexPath.item])
        return cell
    }
}

extension MineSweeperViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let frame = collectionView.frame
        let inset = collectionView.contentInset
        
        let width = (frame.width - (inset.left + inset.right)) / 8 - 1.2
        
        return CGSize(width: width, height: width)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        1.2
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 1.2, left: 0, bottom: 0, right: 0)
    }
}

// MARK: - UICollectionViewDelegate
extension MineSweeperViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(indexPath)
    }
}