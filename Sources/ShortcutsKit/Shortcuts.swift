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
    case missingParameter(String)
}

public struct Shortcuts {

    private struct Constants {
        static let clientVersion = "WFWorkflowClientVersion"
        static let clientRelease = "WFWorkflowClientRelease"
        static let minClientVersion = "WFWorkflowMinimumClientVersion"
        static let icon = "WFWorkflowIcon"
        static let questions = "WFWorkflowImportQuestions"
        static let types = "WFWorkflowTypes"
        static let contentItems = "WFWorkflowInputContentItemClasses"
        static let actions = "WFWorkflowActions"
        static let iconStartColor = "WFWorkflowIconStartColor"
        static let iconImageData = "WFWorkflowIconImageData"
        static let iconGlyphNumber = "WFWorkflowIconGlyphNumber"

        static let defaultClientVersion = "654"
        static let defaultClientRelease = "2.0"
        static let defaultMinClientVersion = "411"
        static let defaultStartColor = 2846468607
        static let defaultGlyphNumber = 59818
    }
    
    public struct Icon {
        public var startColor: Int
        public var imageData: Data?
        public var glyphNumber: Int

        func dictRepresentation() -> [String: Any] {
            var dict: [String: Any] = [:]
            dict[Constants.iconStartColor] = startColor
            dict[Constants.iconImageData] = imageData ?? Data()
            dict[Constants.iconGlyphNumber] = glyphNumber
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

    public var clientVersion = Constants.defaultClientVersion

    public var clientRelease = Constants.defaultClientRelease

    public var minClientVersion = Constants.defaultMinClientVersion

    public var icon = Icon(startColor: Constants.defaultStartColor, imageData: nil, glyphNumber: Constants.defaultGlyphNumber)

    public var importQuestions: [Question] = []

    public var types: [AvaiableType] = [.watchKit]

    public var contentItems: [ContentItem] = []

    public var actions: [Action] = []

    public init() {

    }

    public init(json: [String: Any]) throws {
        if let clientVersion = json[Constants.clientVersion] as? String {
            self.clientVersion = clientVersion
        }
        if let clientRelease = json[Constants.clientRelease] as? String {
            self.clientRelease = clientRelease
        }
        if let minClientVersion = json[Constants.minClientVersion] as? String {
            self.minClientVersion = minClientVersion
        }
        if let icon = json[Constants.icon] as? [String: Any] {
            let startColor = icon[Constants.iconStartColor] as? Int ?? Constants.defaultStartColor
            let imageData = icon[Constants.iconImageData] as? Data ?? Data()
            let glyphNumber = icon[Constants.iconGlyphNumber] as? Int ?? Constants.defaultGlyphNumber
            self.icon = Icon(startColor: startColor, imageData: imageData, glyphNumber: glyphNumber)
        }
        if let _ = json[Constants.questions] as? String {
            // TODO
        }
        if let types = json[Constants.types] as? [String] {
            self.types = types.compactMap { AvaiableType(rawValue: $0) }
        }
        if let contentItems = json[Constants.contentItems] as? [String] {
            self.contentItems = contentItems.compactMap { ContentItem(rawValue: $0) }
        }
        if let actionJSONs = json[Constants.actions] as? [[String: Any]] {
            var actions: [Action] = []
            for json in actionJSONs {
                let action = try ActionHelper.action(from: json)
                actions.append(action)
            }
            self.actions = actions
        }
    }

    public func dictRepresentation() -> [String: Any] {
        var dict: [String: Any] = [:]
        dict[Constants.clientVersion] = clientVersion
        dict[Constants.clientRelease] = clientRelease
        dict[Constants.minClientVersion] = minClientVersion
        dict[Constants.icon] = icon.dictRepresentation()
        dict[Constants.questions] = []
        dict[Constants.types] = types.map { $0.rawValue }
        dict[Constants.contentItems] = contentItems.map { $0.rawValue }
        dict[Constants.actions] = actions.map { $0.dictRepresentation() }
        return dict
    }

    public static func parse(plistPath: String) throws -> Shortcuts {
        guard let json = NSDictionary(contentsOfFile: plistPath) as? [String: Any] else {
            throw ShortcutsError.invalidPlist
        }
        return try Shortcuts(json: json)
    }
}
