//
//  ContactDetailsViewController.swift
//  ClientVk
//
//  Created by Filosuf on 21.04.2023.
//

import UIKit
import ContactsUI

protocol ContactDetailsViewControllerProtocol: AnyObject {
    func setupView(iPhone: Contact?, vkontakte: Profile?)
}

final class ContactDetailsViewController: UIViewController, ContactDetailsViewControllerProtocol {
    // MARK: - Properties
    private let presenter: ContactDetailsViewPresenterProtocol


    private let vkontakteLabel: UILabel = {
        let label = UILabel()
        label.text = "vkontakte".localized
        label.textAlignment = .center
        label.textColor = .label
        return label
    }()

    private let nameInVkontakte: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.numberOfLines = 2
        return label
    }()

    private let photoInVkontakte: UIImageView = {
        let image = UIImageView()
        image.layer.cornerRadius = 50/2
        image.clipsToBounds = true
        return image
    }()

    private let contactLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.text = "contact".localized
        label.textAlignment = .center
        return label
    }()

    private let nameInContacts: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.numberOfLines = 2
        return label
    }()

    private let photoInContacts: UIImageView = {
        let image = UIImageView()
        image.layer.cornerRadius = 50/2
        image.clipsToBounds = true
        return image
    }()

    private let arrowImage: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(systemName: "arrow.right")
        return image
    }()

    private let updatePhotoButton: UIButton = {
        let button = UIButton()
        button.setTitle("updatePhotoContact".localized, for: .normal)
        button.backgroundColor = .systemGreen
        button.tintColor = .label
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 34 / 2
        button.clipsToBounds = true
        button.addTarget(self, action: #selector(updatePhotoButtonHandle), for: .touchUpInside)
        return button
    }()

    private let addContactButton: UIButton = {
        let button = UIButton()
        button.setTitle("edit".localized, for: .normal)
        button.backgroundColor = .black
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 34 / 2
        button.clipsToBounds = true
        button.addTarget(self, action: #selector(addContactButtonHandle), for: .touchUpInside)
        return button
    }()

    // MARK: - Initialiser
    init(presenter: ContactDetailsViewPresenterProtocol) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "updateContact".localized
        view.backgroundColor = .systemBackground
        layout()
        presenter.viewDidLoad()
    }

    // MARK: - Methods
    func setupView(iPhone: Contact?, vkontakte: Profile?) {
        photoInContacts.image = UIImage(named: "noPhoto")
        nameInContacts.text = "emptyName".localized
        addContactButton.setTitle("add".localized, for: .normal)
        if let profile = iPhone {
            nameInContacts.text = profile.firstName + "\n" + profile.lastName
            if let photoData = profile.photoData {
                photoInContacts.image = UIImage(data: photoData)
            }
            addContactButton.setTitle("edit".localized, for: .normal)
        }
        if let profile = vkontakte {
            nameInVkontakte.text = profile.firstName + "\n" + profile.lastName
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
        [vkontakteLabel,
         nameInVkontakte,
         photoInVkontakte,
         contactLabel,
         nameInContacts,
         photoInContacts,
         arrowImage,
         addContactButton,
         updatePhotoButton
        ].forEach { view in
            view.translatesAutoresizingMaskIntoConstraints = false
            self.view.addSubview(view)
        }

        let safeArea = view.safeAreaLayoutGuide

        NSLayoutConstraint.activate([
            vkontakteLabel.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: basicSpaceInterval),
            vkontakteLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: basicSpaceInterval),
            vkontakteLabel.trailingAnchor.constraint(equalTo: view.centerXAnchor),

            nameInVkontakte.topAnchor.constraint(equalTo: vkontakteLabel.bottomAnchor, constant: basicSpaceInterval),
            nameInVkontakte.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: basicSpaceInterval),
            nameInVkontakte.trailingAnchor.constraint(equalTo: view.centerXAnchor),

            photoInVkontakte.topAnchor.constraint(equalTo: nameInVkontakte.bottomAnchor, constant: basicSpaceInterval),
            photoInVkontakte.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: basicSpaceInterval),
            photoInVkontakte.trailingAnchor.constraint(equalTo: arrowImage.leadingAnchor, constant: -basicSpaceInterval),
            photoInVkontakte.heightAnchor.constraint(equalTo: photoInVkontakte.widthAnchor),

            contactLabel.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: basicSpaceInterval),
            contactLabel.leadingAnchor.constraint(equalTo: view.centerXAnchor),
            contactLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -basicSpaceInterval),

            nameInContacts.topAnchor.constraint(equalTo: contactLabel.bottomAnchor, constant: basicSpaceInterval),
            nameInContacts.leadingAnchor.constraint(equalTo: view.centerXAnchor),
            nameInContacts.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -basicSpaceInterval),

            photoInContacts.topAnchor.constraint(equalTo: nameInContacts.bottomAnchor, constant: basicSpaceInterval),
            photoInContacts.leadingAnchor.constraint(equalTo: arrowImage.trailingAnchor, constant: basicSpaceInterval),
            photoInContacts.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -basicSpaceInterval),
            photoInContacts.heightAnchor.constraint(equalTo: photoInContacts.widthAnchor),

            arrowImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            arrowImage.centerYAnchor.constraint(equalTo: photoInVkontakte.centerYAnchor),
            arrowImage.widthAnchor.constraint(equalToConstant: 40),
            arrowImage.heightAnchor.constraint(equalTo: arrowImage.widthAnchor),

            addContactButton.topAnchor.constraint(equalTo: photoInContacts.bottomAnchor, constant: basicSpaceInterval),
            addContactButton.leadingAnchor.constraint(equalTo: photoInContacts.leadingAnchor),
            addContactButton.trailingAnchor.constraint(equalTo: photoInContacts.trailingAnchor),
            addContactButton.heightAnchor.constraint(equalToConstant: 32),

            updatePhotoButton.topAnchor.constraint(equalTo: addContactButton.bottomAnchor, constant: basicSpaceInterval),
            updatePhotoButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: basicSpaceInterval),
            updatePhotoButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -basicSpaceInterval),
            updatePhotoButton.heightAnchor.constraint(equalToConstant: 32),
        ])
    }
}

extension ContactDetailsViewController: CNContactPickerDelegate {
    func contactPicker(_ picker: CNContactPickerViewController, didSelect contact: CNContact) {
        let contactSelected = Contact(contact: contact)
        presenter.didSelectContact(contactSelected)
    }
  }

