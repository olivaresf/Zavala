//
//  File.swift
//  
//
//  Created by Maurice Parker on 12/17/20.
//

import UIKit

public struct OutlineFont {
	
	public static var topicCapHeight: CGFloat {
		return topic.capHeight
	}
	
	public static var topic: UIFont {
		#if targetEnvironment(macCatalyst)
		let bodyFont = UIFont.preferredFont(forTextStyle: .body)
		return bodyFont.withSize(bodyFont.pointSize + 1)
		#else
		return UIFont.preferredFont(forTextStyle: .body)
		#endif
	}
	
	public static var note: UIFont {
		#if targetEnvironment(macCatalyst)
		return UIFont.preferredFont(forTextStyle: .body)
		#else
		let bodyFont = UIFont.preferredFont(forTextStyle: .body)
		return bodyFont.withSize(bodyFont.pointSize - 1)
		#endif
	}
	
}
