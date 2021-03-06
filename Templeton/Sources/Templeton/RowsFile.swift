//
//  RowsFile.swift
//  
//
//  Created by Maurice Parker on 11/15/20.
//

import Foundation
import os.log
import RSCore

struct OutlineRows: Codable {
	var rowOrder: [EntityID]
	var keyedRows: [EntityID: Row]
}

final class RowsFile {
	
	private var log = OSLog(subsystem: Bundle.main.bundleIdentifier!, category: "RowsFile")

	private weak var outline: Outline?
	private let fileURL: URL
	private lazy var managedFile = ManagedResourceFile(fileURL: fileURL,
													   load: { [weak self] in self?.loadCallback() },
													   save: { [weak self] in self?.saveCallback() })
	private var lastModificationDate: Date?
	
	init(outline: Outline) {
		self.outline = outline
		let localAccountFolder = AccountManager.shared.accountsFolder.appendingPathComponent(outline.account!.type.folderName)
		fileURL = localAccountFolder.appendingPathComponent("\(outline.id.documentUUID).plist")
	}
	
	func markAsDirty() {
		managedFile.markAsDirty()
	}
	
	func load() {
		managedFile.load()
	}
	
	func save() {
		managedFile.saveIfNecessary()
	}
	
	func delete() {
		let errorPointer: NSErrorPointer = nil
		let fileCoordinator = NSFileCoordinator(filePresenter: managedFile)
		
		fileCoordinator.coordinate(writingItemAt: fileURL, options: [.forDeleting], error: errorPointer, byAccessor: { writeURL in
			do {
				if FileManager.default.fileExists(atPath: writeURL.path) {
					try FileManager.default.removeItem(atPath: writeURL.path)
				}
			} catch let error as NSError {
				os_log(.error, log: log, "RowsFile delete from disk failed: %@.", error.localizedDescription)
			}
		})
		
		if let error = errorPointer?.pointee {
			os_log(.error, log: log, "RowsFile delete from disk coordination failed: %@.", error.localizedDescription)
		}
	}
	
}

private extension RowsFile {

	func loadCallback() {
		var fileData: Data? = nil
		let errorPointer: NSErrorPointer = nil
		let fileCoordinator = NSFileCoordinator(filePresenter: managedFile)
		
		fileCoordinator.coordinate(readingItemAt: fileURL, options: [], error: errorPointer, byAccessor: { readURL in
			do {
				let resourceValues = try readURL.resourceValues(forKeys: [.contentModificationDateKey])
				guard lastModificationDate != resourceValues.contentModificationDate else {
					return
				}
				lastModificationDate = resourceValues.contentModificationDate

				fileData = try Data(contentsOf: readURL)
			} catch {
				// Ignore this.  It will get called everytime we create a new Outline
			}
		})
		
		if let error = errorPointer?.pointee {
			os_log(.error, log: log, "RowsFile read from disk coordination failed: %@.", error.localizedDescription)
		}

		guard let rowsData = fileData else {
			return
		}

		let decoder = PropertyListDecoder()
		let outlineRows: OutlineRows
		do {
			outlineRows = try decoder.decode(OutlineRows.self, from: rowsData)
		} catch {
			os_log(.error, log: log, "RowsFile read deserialization failed: %@.", error.localizedDescription)
			return
		}

		outline?.rowOrder = outlineRows.rowOrder
		outline?.keyedRows = outlineRows.keyedRows
	}
	
	func saveCallback() {
		guard let rowOrder = outline?.rowOrder, let keyedRows = outline?.keyedRows else { return }
		let outlineRows = OutlineRows(rowOrder: rowOrder, keyedRows: keyedRows)

		let encoder = PropertyListEncoder()
		encoder.outputFormat = .binary

		let rowsData: Data
		do {
			rowsData = try encoder.encode(outlineRows)
		} catch {
			os_log(.error, log: log, "RowsFile read deserialization failed: %@.", error.localizedDescription)
			return
		}

		let errorPointer: NSErrorPointer = nil
		let fileCoordinator = NSFileCoordinator(filePresenter: managedFile)
		
		fileCoordinator.coordinate(writingItemAt: fileURL, options: [], error: errorPointer, byAccessor: { writeURL in
			do {
				try rowsData.write(to: writeURL)
				let resourceValues = try writeURL.resourceValues(forKeys: [.contentModificationDateKey])
				lastModificationDate = resourceValues.contentModificationDate
			} catch let error as NSError {
				os_log(.error, log: log, "RowsFile save to disk failed: %@.", error.localizedDescription)
			}
		})
		
		if let error = errorPointer?.pointee {
			os_log(.error, log: log, "RowsFile save to disk coordination failed: %@.", error.localizedDescription)
		}
	}
	
}

