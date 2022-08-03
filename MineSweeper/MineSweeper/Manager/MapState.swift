//
//  MapState.swift
//  MineSweeper
//
//  Created by J_Min on 2022/08/01.
//

import UIKit

enum MapState: Equatable {
    case mine
    case empty
    case nearMine(count: Int)
    case flag
    case nonTapped
    
    var nearMineCount: Int {
        switch self {
        case .nearMine(let count):
            return count
        default: break
        }
        return 0
    }
    
    var image: UIImage? {
        switch self {
        case .mine:
            return UIImage(systemName: "circle.hexagongrid")
        case .empty, .nonTapped:
            return nil
        case .nearMine(let count):
            return UIImage(systemName: "\(count).circle")
        case .flag:
            return UIImage(systemName: "flag.fill")
        }
    }
    
    var imageColor: UIColor? {
        switch self {
        case .mine:
            return .black
        case .empty:
            return nil
        case .nearMine(let count):
            switch count {
            case 1: return .blue
            case 2: return .green
            case 3: return .orange
            case 4: return .red
            case 5: return .brown
            case 6: return .cyan
            case 7: return .purple
            case 8: return .yellow
            default: return nil
            }
        case .flag:
            return .red
        case .nonTapped:
            return nil
        }
    }
}
