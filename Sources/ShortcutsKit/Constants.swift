//
//  Constatns.swift
//  Shortcuts
//
//  Created by icodesign on 2018/8/3.
//

import Foundation

struct GlobalConstants {

    static let defaultClientVersion = "654"
    static let defaultClientRelease = "2.0"
    static let defaultMinClientVersion = "411"
    static let defaultStartColor = 2846468607
    static let defaultGlyphNumber = 59818

    struct Action {
        static let parameterUUID = "UUID"
        static let parameterActionIdentifier = "WFWorkflowActionIdentifier"
        static let parameterActionParameter = "WFWorkflowActionParameters"
    }

    struct Parameter {
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

        // Action
        static let actionIdentifier = "WFWorkflowActionIdentifier"
        static let actionParameter = "WFWorkflowActionParameters"

        static let actionParameterUUID = "UUID"
        static let actionParameterValue = "Value"
        static let actionParameterKey = "WFKey"

        enum ItemType: Int {
            case text = 0
        }

        static let actionParameterItemType = "WFItemType"

        enum SerializationType: String {
            case dictionaryField = "DictionaryField"
        }

        static let actionParameterSerializationType = "WFSerializationType"
        static let actionParameterValueString = "string"
        static let actionParameterDictionaryFieldValueItems = "WFDictionaryFieldValueItems"
        static let actionParameterValueAttachmentsByRange = "attachmentsByRange"
        static let actionParameterValueOutputUUID = "OutputUUID"
        static let actionParameterValueType = "Type"
        static let actionParameterValueOutputName = "OutputName"
    }
}
