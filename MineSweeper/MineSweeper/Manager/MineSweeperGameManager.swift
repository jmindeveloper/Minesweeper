//
//  MineSweeperGameManager.swift
//  MineSweeper
//
//  Created by J_Min on 2022/08/01.
//

import Foundation

final class MineSweeperGameManager {
    
    private let row = 10
    private let column = 8
    private var mines = Set<Location>()
    
    lazy var map = Array(repeating: Array(repeating: MapState.empty, count: column), count: row)
    
    func createRandomMine(count: Int = 10) {
        while mines.count < count {
            guard let locationRow = (0..<row).randomElement(),
                  let locationColumn = (0..<column).randomElement() else { return }
            
            mines.insert(Location(row: locationRow, column: locationColumn))
        }
    }
    
    func randomMinesApplyToMap() {
        mines.forEach {
            map[$0.row][$0.column] = .mine
            nearMinesApplyToMap(mine: $0)
        }
    }
    
    func nearMinesApplyToMap(mine: Location) {
        let d = [0, 1, -1]
        
        for i in 0..<3 {
            for j in 0..<3 {
                let dxy = (d[i], d[j])
                if dxy == (0, 0) { continue }
                
                if mine.row + dxy.0 < 0 ||
                    mine.row + dxy.0 >= row ||
                    mine.column + dxy.1 >= column ||
                    mine.column + dxy.1 < 0 { continue }
                let nearMine = Location(row: mine.row + dxy.0, column: mine.column + dxy.1)
                if map[nearMine.row][nearMine.column] != .mine {
                    map[nearMine.row][nearMine.column] =
                        .nearMine(
                            count: map[nearMine.row][nearMine.column]
                                .nearMineCount
                        )
                }
            }
        }
    }
}
