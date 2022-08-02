//
//  MineSweeperViewModel.swift
//  MineSweeper
//
//  Created by J_Min on 2022/08/02.
//

import Foundation
import Combine

final class MineSweeperViewModel {
    
    enum GameFinishState {
        case clear, over
    }
    
    // MARK: - Properties
    let updateMap = PassthroughSubject<Void, Never>()
    let gameFinish = PassthroughSubject<GameFinishState, Never>()
    private let gameManager = MineSweeperGameManager()
    lazy var map = Array(repeating: Array(repeating: MapState.nonTapped, count: gameManager.column), count: gameManager.row)
    
    // MARK: - LifeCycle
    init() {
//        gameManager.newGame()
    }
    
    // MARK: - Method
    func mapTapped(location: Location) {
        if gameManager.map[location.row][location.column] == .empty {
            gameManager.findEmptyMap(location: location)
            gameManager.emptyLocations.forEach {
                self.map[$0.row][$0.column] = gameManager.map[$0.row][$0.column]
            }
            updateMap.send()
        } else if gameManager.map[location.row][location.column] == .mine {
            gameFinish.send(.over)
        } else {
            self.map[location.row][location.column] = gameManager.map[location.row][location.column]
            updateMap.send()
        }
    }
    
    func mapFirstTapped(location: Location) {
        gameManager.newGame(location)
        mapTapped(location: location)
    }
}
