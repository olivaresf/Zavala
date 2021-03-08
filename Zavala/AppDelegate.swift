//
//  AppDelegate.swift
//  Zavala
//
//  Created by Maurice Parker on 11/5/20.
//

import UIKit
import Templeton

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
	
	override var keyCommands: [UIKeyCommand]? {
		#if targetEnvironment(macCatalyst)
		return nil
		#else
		var menuKeyCommands = [UIKeyCommand]()
		
		menuKeyCommands.append(.showPreferences)
		
		if AccountManager.shared.isSyncAvailable {
			menuKeyCommands.append(.sync)
		}

		if !(mainSplitViewController?.isOutlineFunctionsUnavailable ?? true) {
			if mainSplitViewController?.isOutlineFiltered ?? false {
				menuKeyCommands.append(.showCompletedCommand)
			} else {
				menuKeyCommands.append(.hideCompletedCommand)
			}
			if mainSplitViewController?.isOutlineNotesHidden ?? false {
				menuKeyCommands.append(.showNotesCommand)
			} else {
				menuKeyCommands.append(.hideNotesCommand)
			}
		}
		
		menuKeyCommands.append(.newOutlineCommand)
		menuKeyCommands.append(.importOPMLCommand)
		
		if !(mainSplitViewController?.isExportOutlineUnavailable ?? true) {
			menuKeyCommands.append(.exportMarkdownCommand)
			menuKeyCommands.append(.exportOPMLCommand)
		}
		
		menuKeyCommands.append(.newWindowCommand)
		menuKeyCommands.append(.toggleSidebarCommand)
		
		if !(mainSplitViewController?.isInsertRowUnavailable ?? true) {
			menuKeyCommands.append(.insertRowCommand)
		}
		
		if !(mainSplitViewController?.isCreateRowUnavailable ?? true) {
			menuKeyCommands.append(.createRowCommand)
		}
		
		if !(mainSplitViewController?.isIndentRowsUnavailable ?? true) {
			menuKeyCommands.append(.indentRowsCommand)
		}
		
		if !(mainSplitViewController?.isOutdentRowsUnavailable ?? true) {
			menuKeyCommands.append(.outdentRowsCommand)
		}
		
		if !(mainSplitViewController?.isToggleRowCompleteUnavailable ?? true) {
			if mainSplitViewController?.isCompleteRowsAvailable ?? false {
				menuKeyCommands.append(.completeRowsCommand)
			} else {
				menuKeyCommands.append(.uncompleteRowsCommand)
			}
		}
		
		if !(mainSplitViewController?.isCreateRowNotesUnavailable ?? true) {
			menuKeyCommands.append(.createRowNotesCommand)
		}

		if !(mainSplitViewController?.isDeleteRowNotesUnavailable ?? true) {
			menuKeyCommands.append(.deleteRowNotesCommand)
		}

		if !(mainSplitViewController?.isExpandAllInOutlineUnavailable ?? true) {
			menuKeyCommands.append(.expandAllInOutlineCommand)
		}
		
		if !(mainSplitViewController?.isCollapseAllInOutlineUnavailable ?? true) {
			menuKeyCommands.append(.collapseAllInOutlineCommand)
		}

		if !(mainSplitViewController?.isExpandAllUnavailable ?? true) {
			menuKeyCommands.append(.expandAllCommand)
		}
		
		if !(mainSplitViewController?.isCollapseAllUnavailable ?? true) {
			menuKeyCommands.append(.collapseAllCommand)
		}
		
		if !(mainSplitViewController?.isExpandUnavailable ?? true) {
			menuKeyCommands.append(.expandCommand)
		}
		
		if !(mainSplitViewController?.isCollapseUnavailable ?? true) {
			menuKeyCommands.append(.collapseCommand)
		}
		
		if !(mainSplitViewController?.isDeleteCompletedRowsUnavailable ?? true) {
			menuKeyCommands.append(.deleteCompletedRowsCommand)
		}

		return menuKeyCommands
		#endif
	}
		
	
	
	#if targetEnvironment(macCatalyst)
	let checkForUpdates = UICommand(title: L10n.checkForUpdates, action: #selector(checkForUpdates(_:)))
	#endif
	
	
	
	let showReleaseNotesCommand = UICommand(title: L10n.releaseNotes, action: #selector(showReleaseNotes(_:)))
	
	let showGitHubRepositoryCommand = UICommand(title: L10n.gitHubRepository, action: #selector(showGitHubRepository(_:)))
	
	let showBugTrackerCommand = UICommand(title: L10n.bugTracker, action: #selector(showBugTracker(_:)))
	
	let sendCopyCommand = UICommand(title: L10n.sendCopy,
									action: #selector(sendCopy(_:)),
									propertyList: UICommandTagShare)

	var mainSplitViewController: MainSplitViewController? {
		var keyScene: UIScene?
		let windowScenes = UIApplication.shared.connectedScenes.compactMap { $0 as? UIWindowScene }
		
		for windowScene in windowScenes {
			if !windowScene.windows.filter({ $0.isKeyWindow }).isEmpty {
				keyScene = windowScene
			}
		}
		
		return (keyScene?.delegate as? SceneDelegate)?.mainSplitViewController
	}
	
	#if targetEnvironment(macCatalyst)
	var appKitPlugin: AppKitPlugin?
	#endif

	func application(_ application: UIApplication, willFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
		let documentAccountURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
		let documentAccountsFolder = documentAccountURL.appendingPathComponent("Accounts").absoluteString
		let documentAccountsFolderPath = String(documentAccountsFolder.suffix(from: documentAccountsFolder.index(documentAccountsFolder.startIndex, offsetBy: 7)))
		
		if !AppDefaults.shared.deletedLocalForV14 {
			try? FileManager.default.removeItem(atPath: documentAccountsFolderPath)
			AppDefaults.shared.deletedLocalForV14 = true
		}
		
		AccountManager.shared = AccountManager(accountsFolderPath: documentAccountsFolderPath)
		return true
	}
	
	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
		AppDefaults.registerDefaults()

		NotificationCenter.default.addObserver(self, selector: #selector(checkForUserDefaultsChanges), name: UserDefaults.didChangeNotification, object: nil)
		NotificationCenter.default.addObserver(self, selector: #selector(willEnterForeground), name: UIApplication.willEnterForegroundNotification, object: nil)
		NotificationCenter.default.addObserver(self, selector: #selector(didEnterBackground), name: UIApplication.didEnterBackgroundNotification, object: nil)

		var menuItems = [UIMenuItem]()
		menuItems.append(UIMenuItem(title: L10n.bold, action: .toggleBoldface))
		menuItems.append(UIMenuItem(title: L10n.italic, action: .toggleItalics))
		menuItems.append(UIMenuItem(title: L10n.link, action: .editLink))
		UIMenuController.shared.menuItems = menuItems

		#if targetEnvironment(macCatalyst)
		guard let pluginPath = (Bundle.main.builtInPlugInsPath as NSString?)?.appendingPathComponent("AppKitPlugin.bundle"),
			  let bundle = Bundle(path: pluginPath),
			  let cls = bundle.principalClass as? NSObject.Type,
			  let appKitPlugin = cls.init() as? AppKitPlugin else { return true }
		
		self.appKitPlugin = appKitPlugin
		appKitPlugin.start()
		#endif
		
		UIApplication.shared.registerForRemoteNotifications()
		
		return true
	}

	func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
		DispatchQueue.main.async {
			AccountManager.shared.receiveRemoteNotification(userInfo: userInfo) {
				completionHandler(.newData)
			}
		}
	}
	
	// MARK: UISceneSession Lifecycle

	func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
		return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
	}

	// MARK: Actions

	@objc func showPreferences(_ sender: Any?) {
		#if targetEnvironment(macCatalyst)
		appKitPlugin?.showPreferences()
		#else
		mainSplitViewController?.showSettings()
		#endif
	}

	#if targetEnvironment(macCatalyst)
	@objc func checkForUpdates(_ sender: Any?) {
		appKitPlugin?.checkForUpdates()
	}
	#endif

	@objc func syncCommand(_ sender: Any?) {
		mainSplitViewController?.sync(sender)
	}

	@objc func importOPMLCommand(_ sender: Any?) {
		mainSplitViewController?.importOPML(sender)
	}

	@objc func exportMarkdownCommand(_ sender: Any?) {
		mainSplitViewController?.exportMarkdown(sender)
	}

	@objc func exportOPMLCommand(_ sender: Any?) {
		mainSplitViewController?.exportOPML(sender)
	}

	@objc func newWindow(_ sender: Any?) {
		let userActivity = NSUserActivity(activityType: "io.vincode.Zavala.create")
		UIApplication.shared.requestSceneSessionActivation(nil, userActivity: userActivity, options: nil, errorHandler: nil)
	}
	
	@objc func createOutlineCommand(_ sender: Any?) {
		mainSplitViewController?.createOutline(sender)
	}
	
	@objc func toggleSidebarCommand(_ sender: Any?) {
		mainSplitViewController?.toggleSidebar(sender)
	}
	
	@objc func insertRowCommand(_ sender: Any?) {
		mainSplitViewController?.insertRow(sender)
	}
	
	@objc func createRowCommand(_ sender: Any?) {
		mainSplitViewController?.createRow(sender)
	}
	
	@objc func indentRowsCommand(_ sender: Any?) {
		mainSplitViewController?.indentRows(sender)
	}
	
	@objc func outdentRowsCommand(_ sender: Any?) {
		mainSplitViewController?.outdentRows(sender)
	}
	
	@objc func toggleCompleteRowsCommand(_ sender: Any?) {
		mainSplitViewController?.toggleCompleteRows(sender)
	}
	
	@objc func createRowNotesCommand(_ sender: Any?) {
		mainSplitViewController?.createRowNotes(sender)
	}
	
	@objc func deleteRowNotesCommand(_ sender: Any?) {
		mainSplitViewController?.deleteRowNotes(sender)
	}
	
	@objc func splitRowCommand(_ sender: Any?) {
		mainSplitViewController?.splitRow(sender)
	}
	
	@objc func toggleBoldCommand(_ sender: Any?) {
		mainSplitViewController?.outlineToggleBoldface(sender)
	}
	
	@objc func toggleItalicsCommand(_ sender: Any?) {
		mainSplitViewController?.outlineToggleItalics(sender)
	}
	
	@objc func linkCommand(_ sender: Any?) {
		mainSplitViewController?.link(sender)
	}

	@objc func toggleOutlineFilterCommand(_ sender: Any?) {
		mainSplitViewController?.toggleOutlineFilter(sender)
	}

	@objc func toggleOutlineHideNotesCommand(_ sender: Any?) {
		mainSplitViewController?.toggleOutlineHideNotes(sender)
	}

	@objc func expandAllInOutlineCommand(_ sender: Any?) {
		mainSplitViewController?.expandAllInOutline(sender)
	}

	@objc func collapseAllInOutlineCommand(_ sender: Any?) {
		mainSplitViewController?.collapseAllInOutline(sender)
	}

	@objc func expandAllCommand(_ sender: Any?) {
		mainSplitViewController?.expandAll(sender)
	}

	@objc func collapseAllCommand(_ sender: Any?) {
		mainSplitViewController?.collapseAll(sender)
	}

	@objc func expandCommand(_ sender: Any?) {
		mainSplitViewController?.expand(sender)
	}

	@objc func collapseCommand(_ sender: Any?) {
		mainSplitViewController?.collapse(sender)
	}
	
	@objc func deleteCompletedRowsCommand(_ sender: Any?) {
		mainSplitViewController?.deleteCompletedRows(sender)
	}
	
	@objc func showReleaseNotes(_ sender: Any?) {
		mainSplitViewController?.showReleaseNotes()
	}

	@objc func showGitHubRepository(_ sender: Any?) {
		mainSplitViewController?.showGitHubRepository()
	}
	
	@objc func showBugTracker(_ sender: Any?) {
		mainSplitViewController?.showBugTracker()
	}

	@objc func sendCopy(_ sender: Any?) {
		mainSplitViewController?.sendCopy(sender)
	}

	// MARK: Validations
	
	override func validate(_ command: UICommand) {
		switch command.action {
		case #selector(syncCommand(_:)):
			if !AccountManager.shared.isSyncAvailable {
				command.attributes = .disabled
			}
		case #selector(exportMarkdownCommand(_:)), #selector(exportOPMLCommand(_:)):
			if mainSplitViewController?.isExportOutlineUnavailable ?? true {
				command.attributes = .disabled
			}
		case #selector(insertRowCommand(_:)):
			if mainSplitViewController?.isInsertRowUnavailable ?? true {
				command.attributes = .disabled
			}
		case #selector(createRowCommand(_:)):
			if mainSplitViewController?.isCreateRowUnavailable ?? true {
				command.attributes = .disabled
			}
		case #selector(indentRowsCommand(_:)):
			if mainSplitViewController?.isIndentRowsUnavailable ?? true {
				command.attributes = .disabled
			}
		case #selector(outdentRowsCommand(_:)):
			if mainSplitViewController?.isOutdentRowsUnavailable ?? true {
				command.attributes = .disabled
			}
		case #selector(toggleCompleteRowsCommand(_:)):
			if mainSplitViewController?.isCompleteRowsAvailable ?? false {
				command.title = L10n.complete
			} else {
				command.title = L10n.uncomplete
			}
			if mainSplitViewController?.isToggleRowCompleteUnavailable ?? true {
				command.attributes = .disabled
			}
		case #selector(createRowNotesCommand(_:)):
			if mainSplitViewController?.isCreateRowNotesUnavailable ?? true  {
				command.attributes = .disabled
			}
		case #selector(deleteRowNotesCommand(_:)):
			if mainSplitViewController?.isDeleteRowNotesUnavailable ?? true {
				command.attributes = .disabled
			}
		case #selector(splitRowCommand(_:)):
			if mainSplitViewController?.isSplitRowUnavailable ?? true {
				command.attributes = .disabled
			}
		case #selector(toggleBoldCommand(_:)), #selector(toggleItalicsCommand(_:)):
			if mainSplitViewController?.isFormatUnavailable ?? true {
				command.attributes = .disabled
			}
		case #selector(linkCommand(_:)):
			if mainSplitViewController?.isLinkUnavailable ?? true {
				command.attributes = .disabled
			}
		case #selector(toggleOutlineFilterCommand(_:)):
			if mainSplitViewController?.isOutlineFiltered ?? false {
				command.title = L10n.showCompleted
			} else {
				command.title = L10n.hideCompleted
			}
			if mainSplitViewController?.isOutlineFunctionsUnavailable ?? true {
				command.attributes = .disabled
			}
		case #selector(toggleOutlineHideNotesCommand(_:)):
			if mainSplitViewController?.isOutlineNotesHidden ?? false {
				command.title = L10n.showNotes
			} else {
				command.title = L10n.hideNotes
			}
			if mainSplitViewController?.isOutlineFunctionsUnavailable ?? true {
				command.attributes = .disabled
			}
		case #selector(expandAllInOutlineCommand(_:)):
			if mainSplitViewController?.isExpandAllInOutlineUnavailable ?? true {
				command.attributes = .disabled
			}
		case #selector(collapseAllInOutlineCommand(_:)):
			if mainSplitViewController?.isCollapseAllInOutlineUnavailable ?? true {
				command.attributes = .disabled
			}
		case #selector(expandAllCommand(_:)):
			if mainSplitViewController?.isExpandAllUnavailable ?? true {
				command.attributes = .disabled
			}
		case #selector(collapseAllCommand(_:)):
			if mainSplitViewController?.isCollapseAllUnavailable ?? true {
				command.attributes = .disabled
			}
		case #selector(expandCommand(_:)):
			if mainSplitViewController?.isExpandUnavailable ?? true {
				command.attributes = .disabled
			}
		case #selector(collapseCommand(_:)):
			if mainSplitViewController?.isCollapseUnavailable ?? true {
				command.attributes = .disabled
			}
		case #selector(deleteCompletedRowsCommand(_:)):
			if mainSplitViewController?.isDeleteCompletedRowsUnavailable ?? true {
				command.attributes = .disabled
			}
		default:
			break
		}
	}
		
	// MARK: Menu

	#if targetEnvironment(macCatalyst)
	override func buildMenu(with builder: UIMenuBuilder) {
		super.buildMenu(with: builder)

		guard builder.system == UIMenuSystem.main else { return }
		
		builder.remove(menu: .newScene)
		builder.remove(menu: .openRecent)
		
		// Application Menu
        let appMenu = UIMenu(title: "", options: .displayInline, children: [UIKeyCommand.showPreferences, checkForUpdates])
		builder.insertSibling(appMenu, afterMenu: .about)
		
		// File Menu
        let syncMenu = UIMenu(title: "", options: .displayInline, children: [UIKeyCommand.sync])
		builder.insertChild(syncMenu, atStartOfMenu: .file)

        let importExportMenu = UIMenu(title: "", options: .displayInline, children: [UIKeyCommand.importOPMLCommand, UIKeyCommand.exportMarkdownCommand, UIKeyCommand.exportOPMLCommand])
		builder.insertChild(importExportMenu, atStartOfMenu: .file)

        let newWindowMenu = UIMenu(title: "", options: .displayInline, children: [UIKeyCommand.newWindowCommand])
		builder.insertChild(newWindowMenu, atStartOfMenu: .file)

        let newItemsMenu = UIMenu(title: "", options: .displayInline, children: [UIKeyCommand.newOutlineCommand])
		builder.insertChild(newItemsMenu, atStartOfMenu: .file)

        let shareMenu = UIMenu(title: "", options: .displayInline, children: [sendCopyCommand])
		builder.insertChild(shareMenu, atEndOfMenu: .file)

		// Edit
        let linkMenu = UIMenu(title: "", options: .displayInline, children: [UIKeyCommand.linkCommand])
		builder.insertSibling(linkMenu, afterMenu: .standardEdit)

		// Format
		builder.remove(menu: .format)
        let formatMenu = UIMenu(title: L10n.format, children: [UIKeyCommand.toggleBoldCommand, UIKeyCommand.toggleItalicsCommand])
		builder.insertSibling(formatMenu, afterMenu: .edit)

        // View Menu
        let expandCollapseMenu = UIMenu(title: "",
                                        options: .displayInline,
                                        children: [UIKeyCommand.expandAllInOutlineCommand, UIKeyCommand.expandAllCommand, UIKeyCommand.expandCommand, UIKeyCommand.collapseAllInOutlineCommand, UIKeyCommand.collapseAllCommand, UIKeyCommand.collapseCommand])
        builder.insertChild(expandCollapseMenu, atStartOfMenu: .view)
        let toggleFilterOutlineMenu = UIMenu(title: "", options: .displayInline, children: [UIKeyCommand.toggleOutlineFilterCommand, UIKeyCommand.toggleOutlineHideNotesCommand])
		builder.insertChild(toggleFilterOutlineMenu, atStartOfMenu: .view)
        let toggleSidebarMenu = UIMenu(title: "", options: .displayInline, children: [UIKeyCommand.toggleSidebarCommand])
		builder.insertSibling(toggleSidebarMenu, afterMenu: .toolbar)
		
		// Outline Menu
        let completeMenu = UIMenu(title: "", options: .displayInline, children: [UIKeyCommand.toggleCompleteRowsCommand, UIKeyCommand.deleteCompletedRowsCommand, UIKeyCommand.createRowNotesCommand, UIKeyCommand.deleteRowNotesCommand])
        let mainOutlineMenu = UIMenu(title: "", options: .displayInline, children: [UIKeyCommand.insertRowCommand, UIKeyCommand.createRowCommand, UIKeyCommand.splitRowCommand, UIKeyCommand.indentRowsCommand, UIKeyCommand.outdentRowsCommand])
		let outlineMenu = UIMenu(title: L10n.outline, children: [mainOutlineMenu, completeMenu])
		builder.insertSibling(outlineMenu, afterMenu: .view)

		// Help Menu
		builder.replaceChildren(ofMenu: .help, from: { _ in return [showReleaseNotesCommand, showGitHubRepositoryCommand, showBugTrackerCommand] })
	}
	#endif
	
}

extension AppDelegate {
	
	@objc private func willEnterForeground() {
		checkForUserDefaultsChanges()
		AccountManager.shared.resume()
	}
	
	@objc private func didEnterBackground() {
		AccountManager.shared.suspend()
	}
	
	@objc private func checkForUserDefaultsChanges() {
		let localAccount = AccountManager.shared.localAccount
		
		if !AppDefaults.shared.hideLocalAccount != localAccount.isActive {
			if AppDefaults.shared.hideLocalAccount {
				localAccount.deactivate()
			} else {
				localAccount.activate()
			}
		}
		
		let cloudKitAccount = AccountManager.shared.cloudKitAccount
		
		if AppDefaults.shared.enableCloudKit && cloudKitAccount == nil {
			AccountManager.shared.createCloudKitAccount()
		} else if !AppDefaults.shared.enableCloudKit && cloudKitAccount != nil {
			AccountManager.shared.deleteCloudKitAccount()
		}
	}
	
}
