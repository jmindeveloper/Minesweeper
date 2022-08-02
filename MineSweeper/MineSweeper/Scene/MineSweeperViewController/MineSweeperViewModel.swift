//
//  MineSweeperViewModel.swift
//  MineSweeper
//
//  Created by J_Min on 2022/08/02.
//

import Foundation
import Combine

final class MineSweeperViewModel {
    
    // MARK: - Properties
    let updateMap = PassthroughSubject<Void, Never>()
    private let gameManager = MineSweeperGameManager()
    lazy var map = Array(repeating: Array(repeating: MapState.nonTapped, count: gameManager.column), count: gameManager.row)
    
    // MARK: - LifeCycle
    init() {
        gameManager.newGame()
    }
    
    // MARK: - Method
    func mapTapped(location: Location) {
        print(location)
        self.map[location.row][location.column] = gameManager.map[location.row][location.column]
        updateMap.send()
    }
}
