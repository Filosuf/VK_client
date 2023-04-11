//
//  UIImageView+Extension.swift
//  ClientVk
//
//  Created by Filosuf on 10.04.2023.
//

import UIKit

//MARK: - Load image from URL
extension UIImageView {

    func load(url: URL) {
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url),
               let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    self?.image = image
                }
            }
        }
    }
}
