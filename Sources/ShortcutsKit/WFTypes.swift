//
//  WFTypes.swift
//  ShortcutsKit
//
//  Created by icodesign on 2018/8/7.
//  Copyright © 2018 Potatso Lab. All rights reserved.
//

import Foundation

public enum WFDictItemType: Int {
    case text = 0
    case file = 5
}

public struct WFDictItem {

    public struct Constants {
        public static let parameterKey = "WFKey"
        public static let parameterValue = "WFValue"
        public static let parameterItemType = "WFItemType"
    }

    public let itemType: WFDictItemType

    public let key: WFSerialization

    public let value: WFSerialization

    public init(itemType: WFDictItemType, key: WFSerialization, value: WFSerialization) {
        self.itemType = itemType
        self.key = key
        self.value = value
    }

    public func dictRepresentation() -> [String: Any] {
        return [
            Constants.parameterItemType: itemType.rawValue,
            Constants.parameterKey: key.dictRepresentation(),
            Constants.parameterValue: value.dictRepresentation(),
        ]
    }
}

public enum WFSerializationType: String {
    case dictionaryField = "WFDictionaryFieldValue"
    case string = "WFTextTokenString"
    case tokenAttachmentParameterState = "WFTokenAttachmentParameterState"
    case textTokenAttachment = "WFTextTokenAttachment"
}

public protocol WFSerialization {
    var type: WFSerializationType { get }
    var value: Any? { get }
    init(values: Any?)
    func dictRepresentation() -> [String: Any]
}

public class GenericWFSerialization: WFSerialization {

    private struct Constants {
        static let parameterType = "WFSerializationType"
        static let parameterValue = "Value"
    }

    public var type: WFSerializationType {
        fatalError("Should override by subclass")
    }
    public let value: Any?

    public required init(values: Any?) {
        self.value = values
    }

    public func dictRepresentation() -> [String: Any] {
        var dict: [String: Any] = [:]
        dict[Constants.parameterType] = type.rawValue
        if let value = value {
            dict[Constants.parameterValue] = value
        }
        return dict
    }

    public static func from(json: [String: Any]) throws -> WFSerialization {
        guard let typeValue = json[Constants.parameterType] as? String, let type = WFSerializationType(rawValue: typeValue) else {
            throw ShortcutsError.missingParameter(Constants.parameterType)
        }
        let values = json[Constants.parameterValue] as? [String: Any]
        switch type {
        case .dictionaryField:
            return WFSerializationDict(values: values)
        case .string:
            return WFSerializationString(values: values)
        case .textTokenAttachment:
            return WFSerializationTextTokenAttachment(values: values)
        case .tokenAttachmentParameterState:
            return WFSerializationTokenAttachmentParameterState(values: values)
        }
    }
}

public class WFSerializationDict: GenericWFSerialization {

    public struct Constants {
        public static let parameterDictFieldValueItems = "WFDictionaryFieldValueItems"
    }

    public override var type: WFSerializationType {
        return .dictionaryField
    }

    public init(items: [WFDictItem]) {
        let values = [Constants.parameterDictFieldValueItems: items.map({ $0.dictRepresentation() })]
        super.init(values: values)
    }

    public required init(values: Any?) {
        super.init(values: values)
    }
}

public class WFSerializationString: GenericWFSerialization {

    public struct Constants {
        public static let keyString = "string"
        public static let keyAttachmentsByRange = "attachmentsByRange"
    }

    public override var type: WFSerializationType {
        return .string
    }

    public init(str: String) {
        let values: [String: Any] = [
            Constants.keyString: str,
            Constants.keyAttachmentsByRange: [String: Any]()
        ]
        super.init(values: values)
    }

    public required init(values: Any?) {
        super.init(values: values)
    }
}

public class WFSerializationTokenAttachmentParameterState: GenericWFSerialization {

    public override var type: WFSerializationType {
        return .tokenAttachmentParameterState
    }

    public init(tokenAttachment: WFSerializationTextTokenAttachment) {
        super.init(values: tokenAttachment.dictRepresentation())
    }

    public required init(values: Any?) {
        super.init(values: values)
    }
}

public class WFSerializationTextTokenAttachment: GenericWFSerialization {

    public struct Constants {
        public static let keyOutputUUID = "OutputUUID"
        public static let keyType = "Type"
        public static let keyOutputName = "OutputName"

        public static let valueTypeActionOutput = "ActionOutput"
    }

    public override var type: WFSerializationType {
        return .textTokenAttachment
    }

    public init(outputUUID: String, outputName: String) {
        let values: [String: Any] = [
            Constants.keyOutputUUID: outputUUID,
            Constants.keyType: Constants.valueTypeActionOutput,
            Constants.keyOutputName: outputName
        ]
        super.init(values: values)
    }

    public required init(values: Any?) {
        super.init(values: values)
    }
}
