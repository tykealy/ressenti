//
//  AppIntent.swift
//  NewsWidgets
//
//  Created by TYKEABOYLOY on 14/2/24.
//

import WidgetKit
import AppIntents

struct ConfigurationAppIntent: WidgetConfigurationIntent {
    static var title: LocalizedStringResource = "Configuration"
    static var description = IntentDescription("This is an example widget.")

    // An example configurable parameter.
    @Parameter(title: "Je suis TK", default: "😡")
    var favoriteEmoji: String
}
