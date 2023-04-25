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
//        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
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
//        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        return label
    }()

    private let photoInVkontakte: UIImageView = {
        let image = UIImageView()
        image.layer.cornerRadius = 50/2
        image.clipsToBounds = true
        return image
    }()

    private let goToDetails: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage(systemName: "chevron.right"), for: .normal)
        button.tintColor = .label
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
            nameInContacts.text = profile.fullName
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
            photoInContacts.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            photoInContacts.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: basicSpaceInterval),
            photoInContacts.heightAnchor.constraint(equalToConstant: 50),
            photoInContacts.widthAnchor.constraint(equalToConstant: 50),

            nameInContacts.leadingAnchor.constraint(equalTo: photoInContacts.trailingAnchor, constant: basicSpaceInterval),
            nameInContacts.trailingAnchor.constraint(equalTo: photoInVkontakte.leadingAnchor, constant: basicSpaceInterval),
            nameInContacts.topAnchor.constraint(equalTo: contentView.topAnchor, constant: basicSpaceInterval),

            nameInVkontakte.leadingAnchor.constraint(equalTo: photoInContacts.trailingAnchor, constant: basicSpaceInterval),
            nameInVkontakte.trailingAnchor.constraint(equalTo: photoInVkontakte.leadingAnchor, constant: basicSpaceInterval),
            nameInVkontakte.topAnchor.constraint(equalTo: nameInContacts.bottomAnchor, constant: basicSpaceInterval),

            photoInVkontakte.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            photoInVkontakte.trailingAnchor.constraint(equalTo: goToDetails.leadingAnchor, constant: -basicSpaceInterval),
            photoInVkontakte.heightAnchor.constraint(equalToConstant: 50),
            photoInVkontakte.widthAnchor.constraint(equalToConstant: 50),

            goToDetails.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            goToDetails.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -basicSpaceInterval),
            goToDetails.widthAnchor.constraint(equalToConstant: 32),
            goToDetails.heightAnchor.constraint(equalToConstant: 32),

        ])
    }
}
