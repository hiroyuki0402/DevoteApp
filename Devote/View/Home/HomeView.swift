//
//  HomeView.swift
//  Devote
//
//  Created by SHIRAISHI HIROYUKI on 2023/11/03.
//

import SwiftUI

struct HomeView: View {
    // MARK: - プロパティー

    @State var task: String = ""

    private var isButtonDisabled: Bool {
        task.isEmpty
    }

    @State private var isShowNewTaskItem: Bool = false

    /// 現在のビューコンテキストへの参照を保持するこれにより、このビューがCore Dataの操作を行えるようになる
    @Environment(\.managedObjectContext) private var viewContext

    /// Core DataのItemエンティティからデータをフェッチし、指定されたソート順で並べ替えるためのリクエスト
    @FetchRequest(
        sortDescriptors: [
            NSSortDescriptor(
                keyPath: \Item.timestamp,
                ascending: true)],
        animation: .default)

    // フェッチリクエストから返された結果のセットを保持する
    private var items: FetchedResults<Item>

    /// アイテムの日時を表示するためのフォーマッタ日付は短いスタイルで、時刻は中くらいのスタイルで表示される
    private let itemFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .medium
        return formatter
    }()

    // MARK: - ボディー
    var body: some View {
        NavigationView {
            ZStack {
                /// メイン
                VStack {
                    /// ヘッダー
                    HStack(spacing: 10) {
                        ///タイトル
                        Text("タスク")
                            .font(.system(.largeTitle, design: .rounded))
                            .fontWeight(.heavy)
                            .padding(4)
                        Spacer()

                        ///編集ボタン
                        EditButton()
                          .font(.system(size: 16, weight: .semibold, design: .rounded))
                          .padding(.horizontal, 10)
                          .frame(minWidth: 70, minHeight: 24)
                          .background(
                            Capsule().stroke(Color.white, lineWidth: 2)
                          )
                    }
                    .padding()
                    .foregroundColor(.white)

                    Spacer(minLength: 80)
                    /// 新しいタスク作成ボタン
                    Button {
                        isShowNewTaskItem = true
                        playSound(sound: "sound-ding", type: "mp3")
                    } label: {
                        AddTaskButtonView()
                    }

                    /// タスク

                    List {
                        ForEach(items) { item in
                            ListRowItemView(item: item)
                        }
                        .onDelete(perform: deleteItems)
                    }//: List
                    .listStyle(PlainListStyle())
                    .cornerRadius(10)
                    .padding()
                    .padding(.top, 30)
                    .shadow(radius: /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/)
                    .frame(maxWidth: 640)
                }//: VStack
                .blur(radius: isShowNewTaskItem ? 8.0: 0.5)
                .transition(.move(edge: .bottom))
                .animation(.easeOut(duration: 0.5), value: !isShowNewTaskItem)
                if isShowNewTaskItem {
                    BlankView(backgroundColor: .black, backgroundOpacity: 0.3)
                    NewTaskItemView(isShowing: $isShowNewTaskItem)
                }
            }//: ZStack
            .onAppear {
                UITableView.appearance().backgroundColor = .clear
            }
            .navigationBarHidden(true)
            .background(
                BackgroundImageView()
                    .blur(radius: isShowNewTaskItem ? 8.0: 0.5, opaque: false)
            )
            .background(
                [Color.pink, Color.blue]
                    .addGradation()
                    .ignoresSafeArea(.all))

        }//: NavigationView
        .navigationViewStyle(StackNavigationViewStyle())

    }//: ボディー

    // MARK: - メソッド

    /// 指定されたオフセットでアイテムを削除するメソッド
    /// - Parameter offsets: 削除するアイテムのインデックスセット
    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            // オフセットに基づいて選択されたアイテムを削除する
            offsets.map { items[$0] }.forEach(viewContext.delete)

            // 変更をビューコンテキストに保存しようとする
            do {
                try viewContext.save()
            } catch {
                // エラーが発生した場合は、クラッシュ前に詳細情報を出力する
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
}

#Preview {
    HomeView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
