//
//  Action.swift
//  Shortcuts
//
//  Created by icodesign on 2018/8/3.
//

import Foundation

public protocol Action {
    var identifier: String { get }
    var parameters: [String: Any] { get }
    func dictRepresentation() -> [String: Any]
}

extension Action {

    public func dictRepresentation() -> [String: Any] {
        var dict: [String: Any] = [:]
        dict[Constants.Parameter.actionIdentifier] = identifier
        dict[Constants.Parameter.actionParameter] = parameters
        return dict
    }
}

public struct ActionHelper {

    public static func action(from identifier: String, parameters: [String: Any]?) throws -> Action {
        switch identifier {
        case Constants.Identifier.comment:
            guard let comment = parameters?[Constants.Parameter.commentActionText] as? String else {
                throw ShortcutsError.missingComment
            }
            return CommentAction(comment: comment)
        default:
            throw ShortcutsError.unsupportedActionIdentifier
        }
    }
}

public struct CommentAction: Action {

    public var identifier: String {
        return Constants.Identifier.comment
    }

    public var parameters: [String: Any] {
        return [
            Constants.Parameter.commentActionText: comment
        ]
    }

    public let comment: String

    public init(comment: String) {
        self.comment = comment
    }
}
