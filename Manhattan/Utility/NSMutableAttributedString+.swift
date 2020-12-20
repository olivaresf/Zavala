//
//  NSMutableAttributedString+.swift
//  Manhattan
//
//  Created by Maurice Parker on 12/20/20.
//

import UIKit

extension NSMutableAttributedString {
	
	func replaceFont(with font: UIFont) {
		beginEditing()
		self.enumerateAttribute(.font, in: NSRange(location: 0, length: self.length)) { (value, range, stop) in
			if let f = value as? UIFont {
				let ufd = f.fontDescriptor.withFamily(font.familyName).withSymbolicTraits(f.fontDescriptor.symbolicTraits)!
				let newFont = UIFont(descriptor: ufd, size: font.pointSize)
				removeAttribute(.font, range: range)
				addAttribute(.font, value: newFont, range: range)
			}
		}
		endEditing()
	}
	
}