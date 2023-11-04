//
//  NewTaskItemView.swift
//  Devote
//
//  Created by SHIRAISHI HIROYUKI on 2023/11/04.
//

import SwiftUI

struct NewTaskItemView: View {
    // MARK: - プロパティー

    /// 現在のビューコンテキストへの参照を保持するこれにより、このビューがCore Dataの操作を行えるようになる
    @Environment(\.managedObjectContext) private var viewContext

    @State var task: String = ""

    @Binding var isShowing: Bool

    private var isButtonDisabled: Bool {
        task.isEmpty
    }
    // MARK: - ボディー

    var body: some View {
        VStack {
            Spacer()
            VStack(spacing: 20) {
                /// 入力欄
                TextField("New Task", text: $task)
                    .foregroundColor(.pink)
                    .font(.system(size: 24, weight: .bold, design: .rounded))
                    .padding()
                    .background(Color(uiColor: .systemGray6))
                    .cornerRadius(10)

                /// ボタン
                Button {
                    addItem()
                    playSound(sound: "sound-ding", type: "mp3")
                } label: {
                    Spacer()
                    Text("SAVE")
                        .font(.system(size: 24, weight: .bold, design: .rounded))
                    Spacer()
                }
                .padding()
                .disabled(isButtonDisabled)
                .font(.headline)
                .foregroundColor(.white)
                .background(isButtonDisabled ? Color(uiColor: .lightGray): Color.pink)
                .cornerRadius(10)
            }
            .padding(.horizontal)
            .padding(.vertical, 20)
            .cornerRadius(16)
            .shadow(color: Color(red: 0, green: 0, blue: 0, opacity: 0.65), radius: 24)
            .frame(maxWidth: 640)
        }//: VStack
        .padding()
    }//: ボディー

    // MARK: - メソッド

    /// 新しいアイテムを追加するメソッド
    private func addItem() {
        withAnimation {
            // 新しいItemエンティティインスタンスを作成し、現在の日時を設定する
            let newItem = Item(context: viewContext)
            newItem.timestamp = Date()
            newItem.task = task
            newItem.complision = false
            newItem.id = UUID()

            // ビューコンテキストを介して変更を保存しようとする
            do {
                try viewContext.save()
            } catch {
                // エラーが発生した場合は、クラッシュ前に詳細情報を出力する
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }

            task = ""
            hideKeyboard()
            isShowing = false
        }
    }
}

#Preview {
    NewTaskItemView(isShowing: .constant(true))
        .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}

