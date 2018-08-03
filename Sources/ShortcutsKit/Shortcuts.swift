//
//  Action.swift
//  Shortcuts
//
//  Created by icodesign on 2018/8/3.
//

import Foundation

public enum ShortcutsError: Error {
    case invalidPlist
    case missingActionIdentifier
    case unsupportedActionIdentifier
    case missingComment
}

public struct Shortcuts {
    
    public struct Icon {
        public var startColor: Int
        public var imageData: Data?
        public var glyphNumber: Int

        func dictRepresentation() -> [String: Any] {
            var dict: [String: Any] = [:]
            dict[Constants.Parameter.iconStartColor] = startColor
            dict[Constants.Parameter.iconImageData] = imageData ?? Data()
            dict[Constants.Parameter.iconGlyphNumber] = glyphNumber
            return dict
        }
    }

    public struct Question {
        // TODO
    }

    public enum AvaiableType: String {
        case shareSheet = "ActionExtension"
        case widget = "NCWidget"
        case watchKit = "WatchKit"
    }

    public enum ContentItem: String {
        case appStoreApp = "WFAppStoreAppContentItem"
        case article = "WFArticleContentItem"
        case contact = "WFContactContentItem"
        case date = "WFDateContentItem"
        case emailAddress = "WFEmailAddressContentItem"
        case genericFile = "WFGenericFileContentItem"
        case image = "WFImageContentItem"
        case iTunesProduct = "WFiTunesProductContentItem"
        case location = "WFLocationContentItem"
        case dcMapsLink = "WFDCMapsLinkContentItem"
        case avAsset = "WFAVAssetContentItem"
        case pdf = "WFPDFContentItem"
        case phoneNumber = "WFPhoneNumberContentItem"
        case richText = "WFRichTextContentItem"
        case safariWebPage = "WFSafariWebPageContentItem"
        case string = "WFStringContentItem"
        case url = "WFURLContentItem"
    }

    public var clientVersion = "654"

    public var clientRelease = "2.0"

    public var minClientVersion = "411"

    public var icon = Icon(startColor: Constants.defaultStartColor, imageData: nil, glyphNumber: Constants.defaultGlyphNumber)

    public var importQuestions: [Question] = []

    public var types: [AvaiableType] = [.watchKit]

    public var contentItems: [ContentItem] = []

    public var actions: [Action] = []

    public init() {

    }

    public init(json: [String: Any]) throws {
        if let clientVersion = json[Constants.Parameter.clientVersion] as? String {
            self.clientVersion = clientVersion
        }
        if let clientRelease = json[Constants.Parameter.clientRelease] as? String {
            self.clientRelease = clientRelease
        }
        if let minClientVersion = json[Constants.Parameter.minClientVersion] as? String {
            self.minClientVersion = minClientVersion
        }
        if let icon = json[Constants.Parameter.icon] as? [String: Any] {
            let startColor = icon[Constants.Parameter.iconStartColor] as? Int ?? Constants.defaultStartColor
            let imageData = icon[Constants.Parameter.iconImageData] as? Data ?? Data()
            let glyphNumber = icon[Constants.Parameter.iconGlyphNumber] as? Int ?? Constants.defaultGlyphNumber
            self.icon = Icon(startColor: startColor, imageData: imageData, glyphNumber: glyphNumber)
        }
        if let _ = json[Constants.Parameter.questions] as? String {
            // TODO
        }
        if let types = json[Constants.Parameter.types] as? [String] {
            self.types = types.compactMap { AvaiableType(rawValue: $0) }
        }
        if let contentItems = json[Constants.Parameter.contentItems] as? [String] {
            self.contentItems = contentItems.compactMap { ContentItem(rawValue: $0) }
        }
        if let actionContents = json[Constants.Parameter.actions] as? [[String: Any]] {
            var actions: [Action] = []
            for actionContent in actionContents {
                guard let identifier = actionContent[Constants.Parameter.actionIdentifier] as? String else {
                    throw ShortcutsError.missingActionIdentifier
                }
                let action = try ActionHelper.action(from: identifier, parameters: actionContent[Constants.Parameter.actionParameter] as? [String: Any])
                actions.append(action)
            }
            self.actions = actions
        }
    }

    public func dictRepresentation() -> [String: Any] {
        var dict: [String: Any] = [:]
        dict[Constants.Parameter.clientVersion] = clientVersion
        dict[Constants.Parameter.clientRelease] = clientRelease
        dict[Constants.Parameter.minClientVersion] = minClientVersion
        dict[Constants.Parameter.icon] = icon.dictRepresentation()
        dict[Constants.Parameter.questions] = []
        dict[Constants.Parameter.types] = types.map { $0.rawValue }
        dict[Constants.Parameter.contentItems] = contentItems.map { $0.rawValue }
        dict[Constants.Parameter.actions] = actions.map { $0.dictRepresentation() }
        return dict
    }

    public static func parse(plistPath: String) throws -> Shortcuts {
        guard let json = NSDictionary(contentsOfFile: plistPath) as? [String: Any] else {
            throw ShortcutsError.invalidPlist
        }
        return try Shortcuts(json: json)
    }
}
