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
        if map[location.row][location.column] != .flag {
            if gameManager.map[location.row][location.column] == .empty {
                gameManager.emptyLocations.removeAll()
                gameManager.findEmptyMap(location: location)
                gameManager.emptyLocations.forEach {
                    self.map[$0.row][$0.column] = gameManager.map[$0.row][$0.column]
                }
                updateMap.send()
            } else if gameManager.map[location.row][location.column] == .mine {
                gameFinish.send(.over)
            } else {
                if case MapState.nearMine(count: _) = gameManager.map[location.row][location.column],
                   map[location.row][location.column] != .nonTapped {
                    gameManager.findEmptyMapAndValidNearMineMap(location: location)
                    
                    gameManager.emptyLocations.forEach {
                        if map[$0.row][$0.column] != .flag {
                            self.map[$0.row][$0.column] = gameManager.map[$0.row][$0.column]
                        }
                    }
                    
                }
                self.map[location.row][location.column] = gameManager.map[location.row][location.column]
                updateMap.send()
            }
        }
    }
    
    func mapFirstTapped(location: Location) {
        gameManager.newGame(location)
        mapTapped(location: location)
    }
    
    func flagModeTapped(location: Location) {
        switch map[location.row][location.column] {
        case .nonTapped:
            map[location.row][location.column] = .flag
            gameManager.flagLocations.append(location)
        case .flag:
            map[location.row][location.column] = .nonTapped
            if let index = gameManager.flagLocations.firstIndex(of: location) {
                gameManager.flagLocations.remove(at: index)
            }
        default: break
        }
        updateMap.send()
    }
}
