//
//  EditorMoveHeadlineCommand.swift
//  Zavala
//
//  Created by Maurice Parker on 12/1/20.
//

import Foundation
import RSCore
import Templeton

final class EditorMoveHeadlineCommand: EditorOutlineCommand {
	var undoActionName: String
	var redoActionName: String
	var undoManager: UndoManager
	weak var delegate: EditorOutlineCommandDelegate?
	var cursorCoordinates: CursorCoordinates?
	
	var outline: Outline
	var headline: TextRow
	var oldParent: RowContainer?
	var oldChildIndex: Int?
	var toParent: RowContainer
	var toChildIndex: Int
	
	init(undoManager: UndoManager,
		 delegate: EditorOutlineCommandDelegate,
		 outline: Outline,
		 headline: TextRow,
		 toParent: RowContainer,
		 toChildIndex: Int) {
		
		self.undoManager = undoManager
		self.delegate = delegate
		self.outline = outline
		self.headline = headline
		self.toParent = toParent
		self.toChildIndex = toChildIndex
		self.undoActionName = L10n.move
		self.redoActionName = L10n.move

		oldParent = headline.parent
		oldChildIndex = oldParent?.rows?.firstIndex(of: headline)
	}
	
	func perform() {
		saveCursorCoordinates()
		let changes = outline.moveRow(headline, toParent: toParent, childIndex: toChildIndex)
		delegate?.applyChangesRestoringCursor(changes)
		registerUndo()
	}
	
	func undo() {
		if let oldParent = oldParent, let oldChildIndex = oldChildIndex {
			let changes = outline.moveRow(headline, toParent: oldParent, childIndex: oldChildIndex)
			delegate?.applyChangesRestoringCursor(changes)
		}
		registerRedo()
		restoreCursorPosition()
	}
	
}
