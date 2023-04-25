//
//  ContactDetailsViewController.swift
//  ClientVk
//
//  Created by Filosuf on 21.04.2023.
//

import UIKit
import ContactsUI

protocol ContactsDetailsViewControllerProtocol: AnyObject {
    func setupView(iPhone: Contact?, vkontakte: Profile?)
}

final class ContactDetailsViewController: UIViewController, ContactsDetailsViewControllerProtocol {
    // MARK: - Properties
    private let presenter: ContactsDetailsViewPresenter
    
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

    private let updatePhotoButton: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage(systemName: "theatermasks.circle"), for: .normal)
        button.tintColor = .label
        button.clipsToBounds = true
        button.addTarget(self, action: #selector(updatePhotoButtonHandle), for: .touchUpInside)
        return button
    }()

    private let addContactButton: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage(systemName: "plus"), for: .normal)
        button.tintColor = .label
        button.clipsToBounds = true
        button.addTarget(self, action: #selector(addContactButtonHandle), for: .touchUpInside)
        return button
    }()

    // MARK: - Initialiser
    init(presenter: ContactsDetailsViewPresenter) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        layout()
        presenter.viewDidLoad()
    }

    // MARK: - Methods
    func setupView(iPhone: Contact?, vkontakte: Profile?) {
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

    @objc private func updatePhotoButtonHandle() {
        presenter.updatePhoto()
    }

    @objc private func addContactButtonHandle() {
        let contactPicker = CNContactPickerViewController()
        contactPicker.delegate = self
        present(contactPicker, animated: true)
    }

    private func layout() {
        let basicSpaceInterval: CGFloat = 12
        [photoInContacts, nameInContacts, nameInVkontakte, photoInVkontakte, updatePhotoButton, addContactButton].forEach { view in
            view.translatesAutoresizingMaskIntoConstraints = false
            self.view.addSubview(view)
        }

        NSLayoutConstraint.activate([
            photoInContacts.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            photoInContacts.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: basicSpaceInterval),
            photoInContacts.heightAnchor.constraint(equalToConstant: 50),
            photoInContacts.widthAnchor.constraint(equalToConstant: 50),

            nameInContacts.leadingAnchor.constraint(equalTo: photoInContacts.trailingAnchor, constant: basicSpaceInterval),
            nameInContacts.trailingAnchor.constraint(equalTo: photoInVkontakte.leadingAnchor, constant: basicSpaceInterval),
            nameInContacts.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: basicSpaceInterval),

            nameInVkontakte.leadingAnchor.constraint(equalTo: photoInContacts.trailingAnchor, constant: basicSpaceInterval),
            nameInVkontakte.trailingAnchor.constraint(equalTo: photoInVkontakte.leadingAnchor, constant: basicSpaceInterval),
            nameInVkontakte.topAnchor.constraint(equalTo: nameInContacts.bottomAnchor, constant: basicSpaceInterval),

            photoInVkontakte.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            photoInVkontakte.trailingAnchor.constraint(equalTo: updatePhotoButton.leadingAnchor, constant: -basicSpaceInterval),
            photoInVkontakte.heightAnchor.constraint(equalToConstant: 50),
            photoInVkontakte.widthAnchor.constraint(equalToConstant: 50),

            updatePhotoButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            updatePhotoButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -basicSpaceInterval),
            updatePhotoButton.widthAnchor.constraint(equalToConstant: 32),
            updatePhotoButton.heightAnchor.constraint(equalToConstant: 32),

            addContactButton.topAnchor.constraint(equalTo: updatePhotoButton.bottomAnchor, constant: basicSpaceInterval),
            addContactButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -basicSpaceInterval),
            addContactButton.widthAnchor.constraint(equalToConstant: 32),
            addContactButton.heightAnchor.constraint(equalToConstant: 32),

        ])
    }
}

extension ContactDetailsViewController: CNContactPickerDelegate {
    func contactPicker(_ picker: CNContactPickerViewController, didSelect contact: CNContact) {
        let contactSelected = Contact(contact: contact)
        presenter.didSelectContact(contactSelected)
    }
  }

