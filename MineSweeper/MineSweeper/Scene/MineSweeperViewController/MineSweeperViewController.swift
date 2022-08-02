//
//  MineSweeperViewController.swift
//  MineSweeper
//
//  Created by J_Min on 2022/08/01.
//

import UIKit
import SnapKit
import Combine

final class MineSweeperViewController: UIViewController {
    
    enum GameState {
        case start, ing, finish
    }
    
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
    
    // MARK: - Properties
    private var subscriptions = Set<AnyCancellable>()
    private var gameState = GameState.start
    let viewModel = MineSweeperViewModel()
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        configureSubViews()
        setConstraintsOfMineSweeperMapCollectionView()
        bindingViewModel()
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

// MARK: - Binding
extension MineSweeperViewController {
    private func bindingViewModel() {
        viewModel.updateMap
            .sink { [weak self] in
                self?.mineSweeperMapCollectionView.reloadData()
            }.store(in: &subscriptions)
        
        viewModel.gameFinish
            .sink { [weak self] finishState in
                switch finishState {
                case .clear:
                    let alert = AlertManager(message: "모든 지뢰를 다 찾았습니다!!\n운좋네ㅋ")
                        .createAlert()
                    self?.present(alert, animated: true)
                case .over:
                    let alert = AlertManager(message: "지뢰가 터졌습니다!!\n님 뒤짐ㅋ")
                        .createAlert()
                    self?.present(alert, animated: true)
                }
            }.store(in: &subscriptions)
    }
}

// MARK: - UICollectionViewDataSource
extension MineSweeperViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return viewModel.map.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.map.first?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: MineSweeperMapCollectionViewCell.identifier,
            for: indexPath) as? MineSweeperMapCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.configureCell(with: viewModel.map[indexPath.section][indexPath.item])
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
        let tapLocation = Location(row: indexPath.section, column: indexPath.item)
        switch gameState {
        case .start:
            viewModel.mapFirstTapped(location: tapLocation)
            gameState = .ing
        case .ing:
            viewModel.mapTapped(location: tapLocation)
        case .finish: break
        }
    }
}
