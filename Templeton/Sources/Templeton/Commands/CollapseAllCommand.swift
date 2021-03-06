//
//  CollapseAllCommand.swift
//
//  Created by Maurice Parker on 12/20/20.
//

import Foundation
import RSCore

public final class CollapseAllCommand: OutlineCommand {
	public var undoActionName: String
	public var redoActionName: String
	public var undoManager: UndoManager
	public weak var delegate: OutlineCommandDelegate?
	public var cursorCoordinates: CursorCoordinates?
	
	public var outline: Outline
	var containers: [RowContainer]
	var collapsedRows: [Row]?
	
	public init(undoManager: UndoManager, delegate: OutlineCommandDelegate, outline: Outline, containers: [RowContainer]) {
		self.undoManager = undoManager
		self.delegate = delegate
		self.outline = outline
		self.containers = containers
		if containers.first is Outline {
			undoActionName = L10n.collapseAllInOutline
			redoActionName = L10n.collapseAllInOutline
		} else {
			undoActionName = L10n.collapseAll
			redoActionName = L10n.collapseAll
		}
	}
	
	public func perform() {
		saveCursorCoordinates()
		collapsedRows = outline.collapseAll(containers: containers)
		registerUndo()
	}
	
	public func undo() {
		guard let collapsedRows = collapsedRows else { return }
		outline.expand(rows: collapsedRows)
		registerRedo()
		restoreCursorPosition()
	}
	
}
