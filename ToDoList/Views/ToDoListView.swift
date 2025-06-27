//
//  ToDoListView.swift
//  ToDoList
//
//  Created by Tushar Munge on 6/24/25.
//

import SwiftData
import SwiftUI

struct ToDoListView: View {
    @Environment(\.modelContext) var modelContext

    @Query var toDos: [ToDo]

    @State private var sheetIsPresented = false

    var body: some View {
        NavigationStack {
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
                
                    guard (try? modelContext.save()) != nil else {
                        print(
                            "😡 ERROR: Save on Delete in ToDoListView Failed!"
                        )
                
                        return
                    }
                }
                */
            }
            .listStyle(.plain)
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
            }
        }
    }
}

#Preview {
    ToDoListView()
        .modelContainer(ToDo.preview)
}
