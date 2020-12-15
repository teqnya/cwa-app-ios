//
// 🦠 Corona-Warn-App
//

import Foundation
import UIKit

class DiaryAddAndEditEntryViewModel {

	// MARK: - Init

	init(
		mode: Mode,
		store: DiaryStoring,
		dismiss: @escaping () -> Void
	) {
		self.mode = mode
		self.store = store
		self.dismiss = dismiss

		switch mode {
		case .add:
			self.textInput = ""
		case .edit(let entry):
			switch entry {
			case .location(let location):
				self.textInput = location.name
			case .contactPerson(let person):
				self.textInput = person.name
			}
		}
	}

	// MARK: - Internal

	enum Mode {
		case add(DiaryDay, DiaryEntryType)
		case edit(DiaryEntry)
	}

	let mode: Mode
	let store: DiaryStoring
	let dismiss: () -> Void

	private(set) var textInput: String

	func update(_ text: String?) {
		textInput = text ?? ""
	}

	func reset() {
		textInput = ""
	}

	func save() {
		switch mode {
		case let .add(day, type):
			switch type {
			case .location:
				let id = store.addLocation(name: textInput)
				store.addLocationVisit(locationId: id, date: day.dateString)
			case .contactPerson:
				let id = store.addContactPerson(name: textInput)
				store.addContactPersonEncounter(contactPersonId: id, date: day.dateString)
			}

		case .edit(let entry):
			switch entry {
			case .location(let location):
				let id = location.id
				store.updateLocation(id: id, name: textInput)
			case .contactPerson(let person):
				let id = person.id
				store.updateContactPerson(id: id, name: textInput)
			}
		}

		dismiss()
	}

	var title: String {
		switch mode {
		case .add(_, let entryType):
			return titleText(from: entryType)
		case .edit(let entry):
			return titleText(from: entry.type)
		}
	}

	var placeholderText: String {
		switch mode {
		case .add(_, let entryType):
			return placeholderText(from: entryType)
		case .edit(let entry):
			return placeholderText(from: entry.type)
		}
	}

	// MARK: - Private

	// Unfortunately, Swift does not currently have KeyPath support for static let,
	// so we need to go that way
	private func titleText(from type: DiaryEntryType) -> String {
		switch type {
		case .location:
			return AppStrings.ContactDiary.AddEditEntry.location.title
		case .contactPerson:
			return AppStrings.ContactDiary.AddEditEntry.person.title
		}
	}

	// Unfortunately, Swift does not currently have KeyPath support for static let,
	// so we need to go that way
	private func placeholderText(from type: DiaryEntryType) -> String {
		switch type {
		case .location:
			return AppStrings.ContactDiary.AddEditEntry.location.placeholder
		case .contactPerson:
			return AppStrings.ContactDiary.AddEditEntry.person.placeholder
		}
	}

}
