//
//  VFUserGuidesProtocol.swift
//  EverisVodafoneFoundation
//
//  Created by Everis on 16/9/21.
//

import Foundation

/// A protocol which acts as a delegate that manages user interactions with the user guides's contents,
/// including view appearance and step's button press.
public protocol VFUserGuidesProtocol: AnyObject {
    /// A method that gets invoked when the component appears.
    func viewIsReady(userGuides: UserGuides)
    /// A method that gets invoked when the component is closed.
    func viewWillClose(userGuides: UserGuides, page: UserGuidesPage)
    /// A method that gets invoked when the button is pressed in the last step.
    func sectionActionRequested(userGuides: UserGuides, page: UserGuidesPage)
    /// A method that gets invoked when the button is pressed in a step that is not the last one.
    func nextActionRequested(userGuides: UserGuides, page: UserGuidesPage)
}
