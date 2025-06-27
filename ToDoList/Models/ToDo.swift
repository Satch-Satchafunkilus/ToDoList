//
//  ToDo.swift
//  ToDoList
//
//  Created by Tushar Munge on 6/26/25.
//

import Foundation
import SwiftData

@MainActor
@Model
class ToDo {
    var item: String = ""
    var reminderIsOn = false
    var dueDate = Calendar.current.date(byAdding: .day, value: 1, to: Date.now)!
    var notes: String = ""
    var isCompleted = false

    init(
        item: String = "",
        reminderIsOn: Bool = false,
        dueDate: Date = Calendar.current.date(
            byAdding: .day,
            value: 1,
            to: Date.now
        )!,
        notes: String = "",
        isCompleted: Bool = false
    ) {
        self.item = item
        self.reminderIsOn = reminderIsOn
        self.dueDate = dueDate
        self.notes = notes
        self.isCompleted = isCompleted
    }
}

// Load Mock data for Preview only
extension ToDo {
    static var preview: ModelContainer {
        let container = try! ModelContainer(
            for: ToDo.self,
            configurations: ModelConfiguration(isStoredInMemoryOnly: true)
        )
        
        // Add Mock data
        container.mainContext.insert(
            ToDo(
                item: "Create SwiftData Lessons",
                reminderIsOn: true,
                dueDate: Date.now + (24 * 60 * 60),
                notes: "Now w/ iOS 16 and Xcode 18",
                isCompleted: false
            )
        )
        
        container.mainContext.insert(
            ToDo(
                item: "Montenegrin Education Talk",
                reminderIsOn: true,
                dueDate: Date.now + (44 * 60 * 60),
                notes: "They want to learn about Entrepreneurship",
                isCompleted: false
            )
        )
        
        container.mainContext.insert(
            ToDo(
                item: "Post flyers for Swift in Santiago",
                reminderIsOn: true,
                dueDate: Date.now + (72 * 60 * 60),
                notes: "To be held at UAH in Chile",
                isCompleted: false
            )
        )
        
        container.mainContext.insert(
            ToDo(
                item: "Prepare old iPhone or Alba",
                reminderIsOn: true,
                dueDate: Date.now + (12 * 60 * 60),
                notes: "She gets my old Pro",
                isCompleted: false
            )
        )
        
        return container
    }
}
