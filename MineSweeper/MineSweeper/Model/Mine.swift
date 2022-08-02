//
//  Mine.swift
//  MineSweeper
//
//  Created by J_Min on 2022/08/02.
//

import Foundation

struct Mine: Hashable {
    let row: Int
    let column: Int
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(row)
        hasher.combine(column)
    }
}
