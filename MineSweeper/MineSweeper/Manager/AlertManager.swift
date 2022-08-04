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
    let isCancel: Bool
    
    init(
        title: String? = nil,
        message: String,
        isCancel: Bool = false
    ) {
        self.title = title
        self.message = message
        self.isCancel = isCancel
    }
    
    func createAlert(okAction: (() -> Void)? = nil) -> UIAlertController {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "확인", style: .default) { _ in
            okAction?()
        }
        alert.addAction(okAction)
        if isCancel {
            let cancelAction = UIAlertAction(title: "취소", style: .cancel)
            alert.addAction(cancelAction)
        }
        
        return alert
    }
}
