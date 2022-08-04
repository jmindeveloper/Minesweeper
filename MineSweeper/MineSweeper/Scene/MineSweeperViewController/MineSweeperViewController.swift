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
    
    private lazy var flagButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "flag"), for: .normal)
        button.setImage(UIImage(systemName: "flag.fill"), for: .selected)
        button.setPreferredSymbolConfiguration(.init(pointSize: 40, weight: .regular, scale: .default), forImageIn: .normal)
        button.tintColor = .red
        button.addTarget(nil, action: #selector(flagButtonTapped(_:)), for: .touchUpInside)
        
        return button
    }()
    
    private let mineCountLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 30)
        label.text = "\(0)/10"
        
        return label
    }()
    
    private lazy var resetButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("reset", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 30)
        button.addTarget(nil, action: #selector(resetButtonTapped(_:)), for: .touchUpInside)
        
        return button
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
        setConstraintsOfFlagButton()
        setConstraintsOfMineCountLabel()
        setConstraintsOfResetButton()
        bindingViewModel()
    }
}

// MARK: - UI
extension MineSweeperViewController {
    private func configureSubViews() {
        [mineSweeperMapCollectionView, flagButton,
         mineCountLabel, resetButton].forEach {
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
    
    private func setConstraintsOfFlagButton() {
        flagButton.snp.makeConstraints {
            $0.bottom.equalTo(mineSweeperMapCollectionView.snp.top).offset(-10)
            $0.leading.equalToSuperview().offset(30)
            $0.size.equalTo(40)
        }
    }
    
    private func setConstraintsOfMineCountLabel() {
        mineCountLabel.snp.makeConstraints {
            $0.centerY.equalTo(flagButton.snp.centerY)
            $0.leading.equalTo(flagButton.snp.trailing).offset(8)
        }
    }
    
    private func setConstraintsOfResetButton() {
        resetButton.snp.makeConstraints {
            $0.centerY.equalTo(flagButton.snp.centerY)
            $0.trailing.equalToSuperview().offset(-30)
        }
    }
}

// MARK: - TargetMethod
extension MineSweeperViewController {
    @objc private func flagButtonTapped(_ sender: UIButton) {
        sender.isSelected.toggle()
    }
    
    @objc private func resetButtonTapped(_ sender: UIButton) {
        let alert = AlertManager(message: "게임을 다시시작하겠습니까?", isCancel: true)
            .createAlert { [weak self] in
                self?.gameState = .start
                self?.mineCountLabel.text = "0/10"
                self?.viewModel.resetGame()
            }
        self.present(alert, animated: true)
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
                    self?.viewModel.mapAllOpen()
                }
                self?.gameState = .finish
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
        if gameState != .finish {
            if flagButton.isSelected {
                viewModel.flagModeTapped(location: tapLocation)
                mineCountLabel.text = "\(viewModel.flagCount())/10"
                return
            }
        }
        
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
