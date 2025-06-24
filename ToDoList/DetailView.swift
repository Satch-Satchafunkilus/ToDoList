//
//  DetailView.swift
//  ToDoList
//
//  Created by Tushar Munge on 6/24/25.
//

import SwiftUI

struct DetailView: View {
    var passedValue: String

    @Environment(\.dismiss) private var dismiss

    var body: some View {
        VStack {
            Image(systemName: "swift")
                .resizable()
                .scaledToFit()
                .foregroundStyle(.orange)

            Text(
                "You Are a Swifty Legend!\nAnd you passed over the value \(passedValue)"
            )
            .font(.largeTitle)
            .multilineTextAlignment(.center)

            Spacer()

            Button("Get Back!") {
                dismiss()
            }
            .buttonStyle(.borderedProminent)
        }
        .padding()
    }
}

#Preview {
    DetailView(passedValue: "Item 1")
}
