//
//  TabBarPage.swift
//  ClientVk
//
//  Created by Filosuf on 17.04.2023.
//

import UIKit

enum TabBarPage: CaseIterable {
    case profile
    case contacts

    var pageTitle: String {
        switch self {
        case .profile:
            return "profile".localized
        case .contacts:
            return "contacts".localized
        }
    }

    var image: UIImage? {
        switch self {
        case .profile:
            return UIImage(systemName: "record.circle.fill")
        case .contacts:
            return UIImage(systemName: "hare.fill")
        }
    }
}
