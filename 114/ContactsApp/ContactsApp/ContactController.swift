//
//  ViewController.swift
//  ContactsApp
//
//  Created by Teacher on 24.12.2022.
//

import UIKit

extension UIViewController {
    class func fromStoryboard() -> Self {
        UIStoryboard(name: "Main", bundle: nil)
            .instantiateViewController(identifier: String(describing: self))
    }
}

class ContactController: UITableViewController {
    @IBOutlet private var nameField: UITextField!
    @IBOutlet private var phoneNumberField: UITextField!
    @IBOutlet private var bffNameLabel: UILabel!
    @IBOutlet private var parentsLabel: UILabel!
    @IBOutlet private var childrenLabel: UILabel!
    @IBOutlet private var friendsLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.rightBarButtonItem = UIBarButtonItem(
            systemItem: .save,
            primaryAction: UIAction { [unowned self] action in
                save()
            }
        )

        if let contact {
            nameField.text = contact.name
            phoneNumberField.text = contact.phoneNumber
        } else {
            contact = Contact(
                entity: Contact.entity(),
                insertInto: CoreDataStack.shared.viewContext
            )
        }
    }

    var contact: Contact?
    var close: (() -> Void)?

    private func showContactSelector(kind: ContactSelectorController.Kind) {
        let contactSelectorController = ContactSelectorController.fromStoryboard()
        contactSelectorController.sourceContact = contact
        contactSelectorController.kind = kind
        contactSelectorController.close = { [weak self] in
            guard let self = self else { return }

            self.navigationController?.popToViewController(self, animated: true)
        }
        navigationController?.pushViewController(contactSelectorController, animated: true)
    }

    @IBAction private func changeBFF() {}
    @IBAction private func changeParents() {}
    @IBAction private func changeChildren() {}
    @IBAction private func changeFriends() {
        showContactSelector(kind: .friends)
    }

    private func save() {
        contact?.name = nameField.text
        contact?.phoneNumber = phoneNumberField.text
        CoreDataStack.shared.save()
        close?()
    }
}

