//
//  ToDoListView.swift
//  ToDoList
//
//  Created by Tushar Munge on 6/24/25.
//

import SwiftUI

struct ToDoListView: View {
    var toDos = [
        "Learn Swift",
        "Change the World",
        "Bring the Awesome",
        "Take a Vacation",
    ]

    var body: some View {
        NavigationStack {
            List {
                ForEach(toDos, id: \.self) { toDo in
                    NavigationLink {
                        DetailView(passedValue: toDo)
                    } label: {
                        Text(toDo)
                    }
                }
            }
            .navigationTitle("To Do List")
            .navigationBarTitleDisplayMode(.automatic)
            .listStyle(.plain)
        }
    }
}

#Preview {
    ToDoListView()
}
