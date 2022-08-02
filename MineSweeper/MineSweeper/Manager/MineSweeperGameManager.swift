//
//  MineSweeperGameManager.swift
//  MineSweeper
//
//  Created by J_Min on 2022/08/01.
//

import Foundation

// mockup map
let mockupMap: [[MapState]] = [
    [
        MapState.empty, MapState.flag, MapState.mine, MapState.nearMine(count: 3), MapState.nearMine(count: 2), MapState.empty, MapState.mine, MapState.flag
    ],
    [
        MapState.empty, MapState.flag, MapState.mine, MapState.nearMine(count: 3), MapState.nearMine(count: 2), MapState.empty, MapState.mine, MapState.flag
    ],
    [
        MapState.empty, MapState.flag, MapState.mine, MapState.nearMine(count: 3), MapState.nearMine(count: 2), MapState.empty, MapState.mine, MapState.flag
    ],
    [
        MapState.empty, MapState.flag, MapState.mine, MapState.nearMine(count: 3), MapState.nearMine(count: 2), MapState.empty, MapState.mine, MapState.flag
    ],
    [
        MapState.empty, MapState.flag, MapState.mine, MapState.nearMine(count: 3), MapState.nearMine(count: 2), MapState.empty, MapState.mine, MapState.flag
    ],
    [
        MapState.empty, MapState.flag, MapState.mine, MapState.nearMine(count: 3), MapState.nearMine(count: 2), MapState.empty, MapState.mine, MapState.flag
    ],
    [
        MapState.empty, MapState.flag, MapState.mine, MapState.nearMine(count: 3), MapState.nearMine(count: 2), MapState.empty, MapState.mine, MapState.flag
    ],
    [
        MapState.empty, MapState.flag, MapState.mine, MapState.nearMine(count: 3), MapState.nearMine(count: 2), MapState.empty, MapState.mine, MapState.flag
    ],
    [
        MapState.empty, MapState.flag, MapState.mine, MapState.nearMine(count: 3), MapState.nearMine(count: 2), MapState.empty, MapState.mine, MapState.flag
    ],
    [
        MapState.empty, MapState.flag, MapState.mine, MapState.nearMine(count: 3), MapState.nearMine(count: 2), MapState.empty, MapState.mine, MapState.flag
    ]
]

final class MineSweeperGameManager {
    
    private let row = 10
    private let column = 8
    private var mines = Set<Mine>()
    
    lazy var map = Array(repeating: Array(repeating: MapState.empty, count: column), count: row)
    
    func createRandomMine(count: Int = 10) {
        while mines.count < count {
            guard let locationRow = (0..<row).randomElement(),
                  let locationColumn = (0..<column).randomElement() else { return }
            
            mines.insert(Mine(row: locationRow, column: locationColumn))
        }
    }
    
    func randomMinesApplyToMap() {
        mines.forEach {
            map[$0.row][$0.column] = .mine
        }
    }
    
}
