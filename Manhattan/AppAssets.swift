//
//  AppAssets.swift
//  Manhattan
//
//  Created by Maurice Parker on 11/12/20.
//

import UIKit

struct AppAssets {
	
	static var createEntity: UIImage = {
		return UIImage(systemName: "plus")!
	}()

	static var removeEntity: UIImage = {
		return UIImage(systemName: "trash")!
	}()

	static var updateEntity: UIImage = {
		return UIImage(systemName: "square.and.pencil")!
	}()

	static var favoriteUnselected: UIImage = {
		return UIImage(systemName: "heart")!
	}()

	static var favoriteSelected: UIImage = {
		return UIImage(systemName: "heart.fill")!
	}()

}