//
//  EditorItem.swift
//  Manhattan
//
//  Created by Maurice Parker on 11/15/20.
//

import UIKit
import Templeton

final class EditorItem:  NSObject, NSCopying, Identifiable {
	var id: String
	var text: Data?

	var plainText: String? {
		get {
			guard let text = text else { return nil }
			return String(data: text, encoding: .utf8)
		}
		set {
			text = newValue?.data(using: .utf8)
		}
	}
	
	init(id: String, text: Data?) {
		self.id = id
		self.text = text
	}
	
	static func editorItem(_ headline: Headline) -> EditorItem {
		return EditorItem(id: headline.id, text: headline.text)
	}

	override func isEqual(_ object: Any?) -> Bool {
		guard let other = object as? EditorItem else { return false }
		if self === other { return true }
		return id == other.id && text == other.text
	}
	
	override var hash: Int {
		var hasher = Hasher()
		hasher.combine(id)
		hasher.combine(text)
		return hasher.finalize()
	}
	
	func copy(with zone: NSZone? = nil) -> Any {
		return self
	}

}

