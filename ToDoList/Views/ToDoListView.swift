//
//  ToDoListView.swift
//  ToDoList
//
//  Created by Tushar Munge on 6/24/25.
//

import SwiftData
import SwiftUI

enum SortOption: String, CaseIterable {
    case asEntered = "As Entered"
    case alphabetical = "A-Z"
    case chronological = "Date"
    case completed = "Not Done"
}

struct SortedToDoListView: View {
    @Environment(\.modelContext) var modelContext

    @Query var toDos: [ToDo]

    let sortSelection: SortOption

    init(sortSelection: SortOption) {
        self.sortSelection = sortSelection

        switch self.sortSelection {
        case .asEntered:
            _toDos = Query()
        case .alphabetical:
            _toDos = Query(sort: \.item)
        case .chronological:
            _toDos = Query(sort: \.dueDate)
        case .completed:
            _toDos = Query(filter: #Predicate { $0.isCompleted == false })
        }
    }

    var body: some View {
        List {
            ForEach(toDos) { toDo in
                VStack(alignment: .leading) {
                    HStack {
                        Image(
                            systemName: toDo.isCompleted
                                ? "checkmark.rectangle" : "rectangle"
                        )
                        .onTapGesture {
                            toDo.isCompleted.toggle()

                            guard (try? modelContext.save()) != nil else {
                                print(
                                    "😡 ERROR: Save on Delete in ToDoListView Failed!"
                                )

                                return
                            }
                        }

                        NavigationLink {
                            DetailView(toDo: toDo)
                        } label: {
                            Text(toDo.item)
                        }
                        .font(.title2)
                        .swipeActions {
                            Button("Delete", role: .destructive) {
                                modelContext.delete(toDo)

                                guard (try? modelContext.save()) != nil
                                else {
                                    print(
                                        "😡 ERROR: Save on Delete in ToDoListView Failed!"
                                    )

                                    return
                                }
                            }
                        }
                    }
                    .font(.title2)

                    HStack {
                        Text(
                            toDo.dueDate.formatted(
                                date: .abbreviated,
                                time: .shortened
                            )
                        )
                        .foregroundStyle(.secondary)

                        if toDo.reminderIsOn {
                            Image(systemName: "calendar.badge.clock")
                                .symbolRenderingMode(.multicolor)
                        }
                    }
                }
            }
            /*
            // Modifier needs to be applied to the ForEach
            // This is a SwiftData technique, and this or the above
            // .swipeActions method could be adopted
            .onDelete { indexSet in
                indexSet.forEach({
                    modelContext.delete(toDos[$0])
                }
                )
            
                guard let _ = try? modelContext.save() else {
                    print(
                        "😡 ERROR: Save on Delete in ToDoListView Failed!"
                    )
            
                    return
                }
            }
            */
        }
        .listStyle(.plain)
    }
}

struct ToDoListView: View {
    @State private var sheetIsPresented = false
    @State private var sortSelection: SortOption = .asEntered

    var body: some View {
        NavigationStack {
            SortedToDoListView(sortSelection: sortSelection)
                .navigationTitle("To Do List")
                .navigationBarTitleDisplayMode(.automatic)
                .sheet(isPresented: $sheetIsPresented) {
                    // To display the Navigation buttons when the Sheet pops-up,
                    // the View is embedded in a 'NavigationStack'
                    NavigationStack {
                        DetailView(toDo: ToDo())
                    }
                }
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button {
                            sheetIsPresented.toggle()
                        } label: {
                            Image(systemName: "plus")
                        }
                    }

                    ToolbarItem(placement: .bottomBar) {
                        Picker("", selection: $sortSelection) {
                            ForEach(SortOption.allCases, id: \.self) {
                                sortOrder in
                                Text(sortOrder.rawValue)
                            }
                        }
                        .pickerStyle(.segmented)
                    }
                }
        }
    }
}

#Preview {
    ToDoListView()
        .modelContainer(ToDo.preview)
}
