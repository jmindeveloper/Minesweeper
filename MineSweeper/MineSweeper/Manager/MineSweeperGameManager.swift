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
    
    lazy var map = Array(repeating: Array(repeating: MapState.nonTapped, count: column), count: row)
    
}
