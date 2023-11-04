//
//  ListRowItemView.swift
//  Devote
//
//  Created by SHIRAISHI HIROYUKI on 2023/11/04.
//

import SwiftUI

struct ListRowItemView: View {
    // MARK: - プロパティー
    @Environment(\.managedObjectContext) var viewContext
    @ObservedObject var item: Item

    // MARK: - ボディー
    var body: some View {
        Toggle(isOn: $item.complision) {
          Text(item.task ?? "")
            .font(.system(.title2, design: .rounded))
            .fontWeight(.heavy)
            .foregroundColor(item.complision ? Color.pink : Color.primary)
            .padding(.vertical, 12)
        } //: TOGGLE
        .toggleStyle(CheckboxStyle())
        .onReceive(item.objectWillChange, perform: { _ in
          if self.viewContext.hasChanges {
            try? self.viewContext.save()
          }
        })
    }
}

