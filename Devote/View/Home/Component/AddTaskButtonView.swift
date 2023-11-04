//
//  AddTaskButtonView.swift
//  Devote
//
//  Created by SHIRAISHI HIROYUKI on 2023/11/04.
//

import SwiftUI

struct AddTaskButtonView: View {
    // MARK: - プロパティー
    private let buttonBackGroundColors: [Color] = [.pink, .blue]

    // MARK: - ボディー

    var body: some View {
        ZStack {
            HStack {
                Image(systemName: "plus.circle")
                    .font(.system(size: 24, weight: .bold, design: .rounded))
                Text("新規作成")
                    .font(.system(size: 24, weight: .bold, design: .rounded))
            }
        }
        .foregroundColor(.white)
        .padding(.horizontal, 20)
        .padding(.vertical, 15)
        .background(
            buttonBackGroundColors.addGradation()
                .clipShape(Capsule())
        )
        .shadow(color: Color(red: 0, green: 0, blue: 0, opacity: 0.25), radius: 8, y: 4.0)
    }
}

#Preview {
    AddTaskButtonView()
}
