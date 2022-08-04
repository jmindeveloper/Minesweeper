//
//  MineSweeperViewModel.swift
//  MineSweeper
//
//  Created by J_Min on 2022/08/02.
//

import Foundation
import Combine

enum GameFinishState {
    case clear, over
}

final class MineSweeperViewModel {
    
    // MARK: - Properties
    let updateMap = PassthroughSubject<Void, Never>()
    let gameFinish = PassthroughSubject<GameFinishState, Never>()
    private let gameManager = MineSweeperGameManager()
    lazy var map = Array(repeating: Array(repeating: MapState.nonOpen, count: gameManager.column), count: gameManager.row)
    private var subscriptions = Set<AnyCancellable>()
    
    // MARK: - LifeCycle
    init() {
        bindingGameManager()
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
                   map[location.row][location.column] != .nonOpen {
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
        gameManager.checkClearCondition(nonOpenMaps: getNonOpenMapLocation())
    }
    
    private func getNonOpenMapLocation() -> [Location] {
        var locations = [Location]()
        for i in 0..<map.count {
            for j in 0..<(map.first?.count ?? 0) {
                if map[i][j] == .nonOpen {
                    let location = Location(row: i, column: j)
                    locations.append(location)
                }
            }
        }
        return locations
    }
    
    func mapFirstTapped(location: Location) {
        gameManager.newGame(location)
        mapTapped(location: location)
    }
    
    func flagModeTapped(location: Location) {
        switch map[location.row][location.column] {
        case .nonOpen:
            map[location.row][location.column] = .flag
            gameManager.flagLocations.append(location)
        case .flag:
            map[location.row][location.column] = .nonOpen
            if let index = gameManager.flagLocations.firstIndex(of: location) {
                gameManager.flagLocations.remove(at: index)
            }
        default: break
        }
        updateMap.send()
    }
    
    func mapAllOpen() {
        map = gameManager.map
        updateMap.send()
    }
    
    func flagCount() -> Int {
        return gameManager.flagLocations.count
    }
    
    func resetGame() {
        map = Array(repeating: Array(repeating: MapState.nonOpen, count: gameManager.column), count: gameManager.row)
        gameManager.resetGame()
        updateMap.send()
    }
    
    func bindingGameManager() {
        gameManager.gameFinish
            .sink { [weak self] state in
                self?.gameFinish.send(state)
            }.store(in: &subscriptions)
    }
}
