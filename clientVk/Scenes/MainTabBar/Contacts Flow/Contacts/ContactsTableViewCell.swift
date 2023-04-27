//
//  ContactsTableViewCell.swift
//  ClientVk
//
//  Created by Filosuf on 19.04.2023.
//

import UIKit

final class ContactsTableViewCell: UITableViewCell {

    static let identifier = "ContactsTableViewCell"

    private let nameInContacts: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.minimumScaleFactor = 0.7
        label.adjustsFontSizeToFitWidth = true
        label.textAlignment = .right
        return label
    }()

    private let photoInContacts: UIImageView = {
        let image = UIImageView()
        image.layer.cornerRadius = 50/2
        image.clipsToBounds = true
        return image
    }()

    private let nameInVkontakte: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.minimumScaleFactor = 0.7
        label.adjustsFontSizeToFitWidth = true
        return label
    }()

    private let photoInVkontakte: UIImageView = {
        let image = UIImageView()
        image.layer.cornerRadius = 50/2
        image.clipsToBounds = true
        return image
    }()

    private let goToDetails: UILabel = {
        let button = UILabel()
        button.text = ">"
        button.font = UIFont.boldSystemFont(ofSize: 23)
        button.textColor = .gray
        button.clipsToBounds = true
        return button
    }()


    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .systemBackground
        layout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupCell(iPhone: Contact?, vkontakte: Profile?) {
        photoInContacts.image = UIImage(named: "noPhoto")
        nameInContacts.text = ""
        if let profile = iPhone {
            nameInContacts.text = "iPhone: \(profile.fullName)"
            if let photoData = profile.photoData {
                photoInContacts.image = UIImage(data: photoData)
            }
        }
        if let profile = vkontakte {
            nameInVkontakte.text = profile.fullName
            if let photoUrl = URL(string: profile.photoUrl) {
                photoInVkontakte.load(url: photoUrl)
            }
        }
    }

    private func layout() {
        let basicSpaceInterval: CGFloat = 12
        [photoInContacts, nameInContacts, nameInVkontakte, photoInVkontakte, goToDetails].forEach { view in
            view.translatesAutoresizingMaskIntoConstraints = false
            self.contentView.addSubview(view)
        }

        NSLayoutConstraint.activate([
            photoInVkontakte.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            photoInVkontakte.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: basicSpaceInterval),
            photoInVkontakte.heightAnchor.constraint(equalToConstant: 50),
            photoInVkontakte.widthAnchor.constraint(equalToConstant: 50),

            nameInVkontakte.leadingAnchor.constraint(equalTo: photoInVkontakte.trailingAnchor, constant: basicSpaceInterval),
            nameInVkontakte.trailingAnchor.constraint(equalTo: photoInContacts.leadingAnchor, constant: -basicSpaceInterval),
            nameInVkontakte.topAnchor.constraint(equalTo: contentView.topAnchor, constant: basicSpaceInterval),

            nameInContacts.leadingAnchor.constraint(equalTo: photoInVkontakte.trailingAnchor, constant: basicSpaceInterval),
            nameInContacts.trailingAnchor.constraint(equalTo: photoInContacts.leadingAnchor, constant: -basicSpaceInterval),
            nameInContacts.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -basicSpaceInterval),

            photoInContacts.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            photoInContacts.trailingAnchor.constraint(equalTo: goToDetails.leadingAnchor, constant: -basicSpaceInterval),
            photoInContacts.heightAnchor.constraint(equalToConstant: 50),
            photoInContacts.widthAnchor.constraint(equalToConstant: 50),

            goToDetails.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            goToDetails.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            goToDetails.widthAnchor.constraint(equalToConstant: 32),
            goToDetails.heightAnchor.constraint(equalToConstant: 32),

        ])
    }
}
