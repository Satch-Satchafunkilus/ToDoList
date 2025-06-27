//
//  DetailView.swift
//  ToDoList
//
//  Created by Tushar Munge on 6/24/25.
//

import SwiftData
import SwiftUI

struct DetailView: View {
    @Environment(\.modelContext) var modelContext
    @Environment(\.dismiss) private var dismiss
    
    @State var toDo: ToDo // Passed as a Parameter to this View
    @State private var item = ""
    @State private var reminderIsOn = false
    @State private var dueDate = Calendar.current.date(
        byAdding: .day,
        value: 1,
        to: Date.now
    )!
    @State private var notes: String = ""
    @State private var isCompleted = false

    var body: some View {
        List {
            Group {
                TextField("Enter To Do here", text: $item)
                    .font(.title)
                    .textFieldStyle(.roundedBorder)
                    .padding(.vertical)

                Toggle("Set Reminder:", isOn: $reminderIsOn)
                    .padding(.top)

                DatePicker("Date:", selection: $dueDate)
                    .padding(.bottom)
                    .disabled(!reminderIsOn)
                
                Text("Notes:")
                    .padding(.top)
                
                TextField("Notes", text: $notes, axis: .vertical)
                    .textFieldStyle(.roundedBorder)
                
                Toggle("Completed:", isOn: $isCompleted)
                    .padding(.top)
            }
            .listRowSeparator(.hidden)
        }
        .listStyle(.plain)
        .onAppear() {
            // Move data from 'toDo' Object to Local vars
            item = toDo.item
            reminderIsOn = toDo.reminderIsOn
            dueDate = toDo.dueDate
            notes = toDo.notes
            isCompleted = toDo.isCompleted
        }
        .navigationBarBackButtonHidden()
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button("Cancel") {
                    dismiss()
                }
            }
            ToolbarItem(placement: .topBarTrailing) {
                Button("Save") {
                    // Move data from Local vars to 'toDo' Object
                    toDo.item = item
                    toDo.reminderIsOn = reminderIsOn
                    toDo.dueDate = dueDate
                    toDo.notes = notes
                    toDo.isCompleted = isCompleted
                    
                    modelContext.insert(toDo)
                    
                    guard let _ = try? modelContext.save() else {
                        print("😡 ERROR: Save on DetailView Failed!")
                        
                        return
                    }
                    
                    dismiss()
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        DetailView(toDo: ToDo())
            .modelContainer(for: ToDo.self, inMemory: true)
    }
}
