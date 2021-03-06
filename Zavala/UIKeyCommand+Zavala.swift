//
//  UIKeyCommand+Zavala.swift
//  Zavala
//
//  Created by Muhammad Doukmak on 3/6/21.
//

import Foundation
import UIKit

let appDelegate = UIApplication.shared.delegate as! AppDelegate

extension UIKeyCommand {
    

    static let sync = UIKeyCommand(title: L10n.sync,
                                   action: #selector(appDelegate.syncCommand(_:)),
                            input: "r",
                            modifierFlags: [.command])
    
    static let exportOPMLCommand = UIKeyCommand(title: L10n.exportOPML,
                                         action: #selector(appDelegate.exportOPMLCommand(_:)),
                                         input: "e",
                                         modifierFlags: [.shift, .command])
    
    static let exportMarkdownCommand = UIKeyCommand(title: L10n.exportMarkdown,
                                             action: #selector(appDelegate.exportMarkdownCommand(_:)),
                                             input: "e",
                                             modifierFlags: [.control, .command])
    
    static let importOPMLCommand = UIKeyCommand(title: L10n.importOPML,
                                         action: #selector(appDelegate.importOPMLCommand(_:)),
                                         input: "i",
                                         modifierFlags: [.shift, .command])
    
    static let newWindowCommand = UIKeyCommand(title: L10n.newWindow,
                                        action: #selector(appDelegate.newWindow(_:)),
                                        input: "n",
                                        modifierFlags: [.alternate, .command])
    
    static let newOutlineCommand = UIKeyCommand(title: L10n.newOutline,
                                         action: #selector(appDelegate.createOutlineCommand(_:)),
                                         input: "n",
                                         modifierFlags: [.command])
    
    static let toggleSidebarCommand = UIKeyCommand(title: L10n.toggleSidebar,
                                            action: #selector(appDelegate.toggleSidebarCommand(_:)),
                                            input: "s",
                                            modifierFlags: [.control, .command])
    
    static let insertRowCommand = UIKeyCommand(title: L10n.addRowAbove,
                                        action: #selector(appDelegate.insertRowCommand(_:)),
                                        input: "\n",
                                        modifierFlags: [.shift])
    
    static let createRowCommand = UIKeyCommand(title: L10n.addRowBelow,
                                        action: #selector(appDelegate.createRowCommand(_:)),
                                        input: "\n",
                                        modifierFlags: [])
    
    static let indentRowsCommand = UIKeyCommand(title: L10n.indent,
                                         action: #selector(appDelegate.indentRowsCommand(_:)),
                                         input: "]",
                                         modifierFlags: [.command])
    
    static let outdentRowsCommand = UIKeyCommand(title: L10n.outdent,
                                          action: #selector(appDelegate.outdentRowsCommand(_:)),
                                          input: "[",
                                          modifierFlags: [.command])
    
    static let toggleCompleteRowsCommand = UIKeyCommand(title: L10n.complete,
                                                 action: #selector(appDelegate.toggleCompleteRowsCommand(_:)),
                                                 input: "\n",
                                                 modifierFlags: [.command])
    
    static let completeRowsCommand = UIKeyCommand(title: L10n.complete,
                                           action: #selector(appDelegate.toggleCompleteRowsCommand(_:)),
                                           input: "\n",
                                           modifierFlags: [.command])
    
    static let uncompleteRowsCommand = UIKeyCommand(title: L10n.uncomplete,
                                             action: #selector(appDelegate.toggleCompleteRowsCommand(_:)),
                                             input: "\n",
                                             modifierFlags: [.command])
    
    static let createRowNotesCommand = UIKeyCommand(title: L10n.addNote,
                                             action: #selector(appDelegate.createRowNotesCommand(_:)),
                                             input: "-",
                                             modifierFlags: [.control])
    
    static let deleteRowNotesCommand = UIKeyCommand(title: L10n.deleteNote,
                                             action: #selector(appDelegate.deleteRowNotesCommand(_:)),
                                             input: "-",
                                             modifierFlags: [.control, .shift])
    
    static let splitRowCommand = UIKeyCommand(title: L10n.splitRow,
                                       action: #selector(appDelegate.splitRowCommand(_:)),
                                       input: "\n",
                                       modifierFlags: [.shift, .alternate])
    
    static let toggleBoldCommand = UIKeyCommand(title: L10n.bold,
                                         action: #selector(appDelegate.toggleBoldCommand(_:)),
                                         input: "b",
                                         modifierFlags: [.command])
    
    static let toggleItalicsCommand = UIKeyCommand(title: L10n.italic,
                                            action: #selector(appDelegate.toggleItalicsCommand(_:)),
                                            input: "i",
                                            modifierFlags: [.command])
    
    static let linkCommand = UIKeyCommand(title: L10n.link,
                                   action: #selector(appDelegate.linkCommand(_:)),
                                   input: "k",
                                   modifierFlags: [.command])
    
    static let toggleOutlineFilterCommand = UIKeyCommand(title: L10n.hideCompleted,
                                                  action: #selector(appDelegate.toggleOutlineFilterCommand(_:)),
                                                  input: "h",
                                                  modifierFlags: [.shift, .command])
    
    static let hideCompletedCommand = UIKeyCommand(title: L10n.hideCompleted,
                                            action: #selector(appDelegate.toggleOutlineFilterCommand(_:)),
                                            input: "h",
                                            modifierFlags: [.shift, .command])
    
    static let showCompletedCommand = UIKeyCommand(title: L10n.showCompleted,
                                            action: #selector(appDelegate.toggleOutlineFilterCommand(_:)),
                                            input: "h",
                                            modifierFlags: [.shift, .command])

    static let toggleOutlineHideNotesCommand = UIKeyCommand(title: L10n.hideNotes,
                                                  action: #selector(appDelegate.toggleOutlineHideNotesCommand(_:)),
                                                  input: "h",
                                                  modifierFlags: [.shift, .alternate, .command])
    
    static let hideNotesCommand = UIKeyCommand(title: L10n.hideNotes,
                                            action: #selector(appDelegate.toggleOutlineHideNotesCommand(_:)),
                                            input: "h",
                                            modifierFlags: [.shift, .alternate, .command])
    
    static let showNotesCommand = UIKeyCommand(title: L10n.showNotes,
                                            action: #selector(appDelegate.toggleOutlineHideNotesCommand(_:)),
                                            input: "h",
                                            modifierFlags: [.shift, .alternate, .command])
    
    static let expandAllInOutlineCommand = UIKeyCommand(title: L10n.expandAllInOutline,
                                                 action: #selector(appDelegate.expandAllInOutlineCommand(_:)),
                                                 input: "9",
                                                 modifierFlags: [.control, .command])
    
    static let collapseAllInOutlineCommand = UIKeyCommand(title: L10n.collapseAllInOutline,
                                                   action: #selector(appDelegate.collapseAllInOutlineCommand(_:)),
                                                   input: "0",
                                                   modifierFlags: [.control, .command])
    
    static let expandAllCommand = UIKeyCommand(title: L10n.expandAllInRow,
                                        action: #selector(appDelegate.expandAllCommand(_:)),
                                        input: "9",
                                        modifierFlags: [.alternate, .command])
    
    static let collapseAllCommand = UIKeyCommand(title: L10n.collapseAllInRow,
                                          action: #selector(appDelegate.collapseAllCommand(_:)),
                                          input: "0",
                                          modifierFlags: [.alternate, .command])
    
    static let expandCommand = UIKeyCommand(title: L10n.expand,
                                     action: #selector(appDelegate.expandCommand(_:)),
                                     input: "9",
                                     modifierFlags: [.command])
    
    static let collapseCommand = UIKeyCommand(title: L10n.collapse,
                                       action: #selector(appDelegate.collapseCommand(_:)),
                                       input: "0",
                                       modifierFlags: [.command])
    
    static let deleteCompletedRowsCommand = UIKeyCommand(title: L10n.deleteCompletedRows,
                                       action: #selector(appDelegate.deleteCompletedRowsCommand(_:)),
                                       input: "d",
                                       modifierFlags: [.command])
    
    static let showPreferences = UIKeyCommand(title: L10n.preferences,
                                              action: #selector(appDelegate.showPreferences(_:)),
                                         input: ",",
                                         modifierFlags: [.command])
}
