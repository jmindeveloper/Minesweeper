//
//  MineSweeperGameManager.swift
//  MineSweeper
//
//  Created by J_Min on 2022/08/01.
//

import Foundation

final class MineSweeperGameManager {
    
    let row = 10
    let column = 8
    var emptyLocations = [Location]()
    
    lazy var map = Array(repeating: Array(repeating: MapState.empty, count: column), count: row)
    private lazy var visitedMap = Array(repeating: Array(repeating: false, count: column), count: row)
    
    /// 새로운 게임
    func newGame(_ firstLocation: Location) {
        let mines = createRandomMine(location: firstLocation)
        randomMinesApplyToMap(mines: mines)
    }
    
    /// 랜덤지뢰위치 생성
    func createRandomMine(count: Int = 10, location: Location) -> Set<Location> {
        var mines = Set<Location>()
        while mines.count < count {
            guard let locationRow = (0..<row).randomElement(),
                  let locationColumn = (0..<column).randomElement() else { continue }
            
            if locationRow == location.row, locationColumn == locationColumn {
                continue
            }
            
            mines.insert(Location(row: locationRow, column: locationColumn))
        }
        print(mines)
        return mines
    }
    
    /// 랜덤지뢰위치 map에 적용
    func randomMinesApplyToMap(mines: Set<Location>) {
        mines.forEach {
            map[$0.row][$0.column] = .mine
            nearMinesApplyToMap(mine: $0)
        }
    }
    
    /// 근처지뢰개수 계산
    private func nearMinesApplyToMap(mine: Location) {
        let d = [0, 1, -1]
        
        for i in 0..<3 {
            for j in 0..<3 {
                let dxy = (d[i], d[j])
                
                if dxy == (0, 0) ||
                    mine.row + dxy.0 < 0 ||
                    mine.row + dxy.0 >= row ||
                    mine.column + dxy.1 >= column ||
                    mine.column + dxy.1 < 0 { continue }
                let nearMine = Location(row: mine.row + dxy.0, column: mine.column + dxy.1)
                if map[nearMine.row][nearMine.column] != .mine {
                    map[nearMine.row][nearMine.column] = .nearMine(
                            count: map[nearMine.row][nearMine.column].nearMineCount
                        )
                }
            }
        }
    }
    
    /// 빈맵 주위에 빈맵 검색
    func findEmptyMap(location: Location) {
        let d = [0, 1, -1]
        
        if map[location.row][location.column] != .empty ||
            visitedMap[location.row][location.column] {
            if case MapState.nearMine(count: _) = map[location.row][location.column] {
                emptyLocations.append(location)
            }
            return
        }
        
        emptyLocations.append(location)
        
        for i in 0..<3 {
            for j in 0..<3 {
                
                let dxy = (d[i], d[j])
                
                if location.row + dxy.0 < 0 ||
                    location.row + dxy.0 >= row ||
                    location.column + dxy.1 >= column ||
                    location.column + dxy.1 < 0 { continue }
                print(location)
                let newLocation = Location(row: location.row + dxy.0, column: location.column + dxy.1)
                visitedMap[location.row][location.column] = true
                findEmptyMap(location: newLocation)
            }
        }
    }
}
