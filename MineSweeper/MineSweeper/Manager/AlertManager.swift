//
//  AlertManager.swift
//  MineSweeper
//
//  Created by J_Min on 2022/08/02.
//

import UIKit

final class AlertManager {
    
    var title: String?
    let message: String
    
    init(
        title: String? = nil,
        message: String
    ) {
        self.title = title
        self.message = message
    }
    
    func createAlert(okAction: (() -> Void)? = nil) -> UIAlertController {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "확인", style: .default) { _ in
            okAction?()
        }
        
        alert.addAction(okAction)
        
        return alert
    }
}
