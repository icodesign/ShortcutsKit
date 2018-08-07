//
//  Actions.swift
//  Shortcuts
//
//  Created by icodesign on 2018/8/3.
//

import Foundation

public enum ActionIdentifier: String {
    case comment = "is.workflow.actions.comment"
    case imageResize = "is.workflow.actions.image.resize"
    case url = "is.workflow.actions.url"
    case downloadURL = "is.workflow.actions.downloadurl"
}

public protocol Action {
    var identifier: ActionIdentifier { get }
    var parameters: [String: Any] { get }
    init(parametersJSON: [String: Any]?) throws
    func dictRepresentation() -> [String: Any]
}

extension Action {

    public func dictRepresentation() -> [String: Any] {
        var dict: [String: Any] = [:]
        dict[GlobalConstants.Action.parameterActionIdentifier] = identifier.rawValue
        dict[GlobalConstants.Action.parameterActionParameter] = parameters
        return dict
    }
}

public struct ActionHelper {

    public static func action(from json: [String: Any]) throws -> Action {
        guard let identifier = json[GlobalConstants.Action.parameterActionIdentifier] as? String else {
            throw ShortcutsError.missingActionIdentifier
        }
        return try action(from: identifier, parameters: json[GlobalConstants.Action.parameterActionParameter] as? [String: Any])
    }

    public static func action(from identifier: String, parameters: [String: Any]?) throws -> Action {
        guard let actionID = ActionIdentifier(rawValue: identifier) else {
            throw ShortcutsError.unsupportedActionIdentifier
        }
        switch actionID {
        case .comment:
            return try CommentAction(parametersJSON: parameters)
        default:
            throw ShortcutsError.unsupportedActionIdentifier
        }
    }
}

public struct CommentAction: Action {

    private struct Constants {
        static let parameterCommentText = "WFCommentActionText"
    }

    public var identifier: ActionIdentifier {
        return .comment
    }

    public var parameters: [String: Any] {
        return [
            Constants.parameterCommentText: comment
        ]
    }

    public let comment: String

    public init(comment: String) {
        self.comment = comment
    }

    public init(parametersJSON: [String: Any]?) throws {
        guard let comment = parametersJSON?[Constants.parameterCommentText] as? String else {
            throw ShortcutsError.missingParameter(Constants.parameterCommentText)
        }
        self.init(comment: comment)
    }
}

public struct ImageResizeAction: Action {

    private struct Constants {
        static let parameterImageResizeWidth = "WFImageResizeWidth"
    }

    public var identifier: ActionIdentifier {
        return .imageResize
    }

    public var parameters: [String: Any] {
        var dict: [String: Any] = [:]
        if let width = width {
            dict[Constants.parameterImageResizeWidth] = width
        }
        dict[GlobalConstants.Action.parameterUUID] = uuid
        return dict
    }

    public let width: Int?

    public let uuid: String

    public init(width: Int?, uuid: String = UUID().uuidString) {
        self.width = width
        self.uuid = uuid
    }

    public init(parametersJSON: [String: Any]?) throws {
        let width = parametersJSON?[Constants.parameterImageResizeWidth] as? Int
        let uuid = parametersJSON?[GlobalConstants.Action.parameterUUID] as? String ??  UUID().uuidString
        self.init(width: width, uuid: uuid)
    }
}

public struct URLAction: Action {

    private struct Constants {
        static let parameterURL = "WFURLActionURL"
    }

    public var identifier: ActionIdentifier {
        return .url
    }

    public var parameters: [String: Any] {
        var dict: [String: Any] = [:]
        dict[Constants.parameterURL] = url
        dict[GlobalConstants.Action.parameterUUID] = uuid
        return dict
    }

    public let url: String

    public let uuid: String

    public init(url: String, uuid: String = UUID().uuidString) {
        self.url = url
        self.uuid = uuid
    }

    public init(parametersJSON: [String: Any]?) throws {
        guard let url = parametersJSON?[Constants.parameterURL] as? String else {
            throw ShortcutsError.missingParameter(Constants.parameterURL)
        }
        let uuid = parametersJSON?[GlobalConstants.Action.parameterUUID] as? String ?? UUID().uuidString
        self.init(url: url, uuid: uuid)
    }
}

public enum WFHTTPBodyType: String {
    case form = "Form"
}

public enum WFHTTPMethod: String {
    case post = "POST"
}

public struct HTTPFormRequestAction: Action {

    private struct Constants {
        static let parameterAdvanced = "Advanced"
        static let parameterHTTPBodyType = "WFHTTPBodyType"
        static let parameterHTTPFormValues = "WFFormValues"
        static let parameterHTTPMethod = "WFHTTPMethod"
    }

    public var identifier: ActionIdentifier {
        return .downloadURL
    }

    public var parameters: [String: Any] {
        return [
            Constants.parameterAdvanced: true,
            Constants.parameterHTTPBodyType: WFHTTPBodyType.form.rawValue,
            Constants.parameterHTTPMethod: WFHTTPMethod.post.rawValue,
            Constants.parameterHTTPFormValues: form.dictRepresentation()
        ]
    }

    public let form: WFSerializationDict

    public let uuid: String

    public init(form: WFSerializationDict, uuid: String = UUID().uuidString) {
        self.form = form
        self.uuid = uuid
    }

    public init(parametersJSON: [String: Any]?) throws {
        let form: WFSerializationDict
        if let formValues = parametersJSON?[Constants.parameterHTTPFormValues] as? [String: Any] {
            form = WFSerializationDict(values: formValues)
        } else {
            form = WFSerializationDict(values: nil)
        }
        let uuid = parametersJSON?[GlobalConstants.Action.parameterUUID] as? String ?? UUID().uuidString
        self.init(form: form, uuid: uuid)
    }
}
