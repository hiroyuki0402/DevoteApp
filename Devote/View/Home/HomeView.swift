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
                VStack {
                    VStack(spacing: 20) {
                        /// 入力欄
                        TextField("New Task", text: $task)
                            .padding()
                            .background(Color(uiColor: .systemGray6))
                            .cornerRadius(10)

                        /// ボタン
                        Button {
                            addItem()
                        } label: {
                            Spacer()
                            Text("SAVE")
                            Spacer()
                        }
                        .padding()
                        .disabled(isButtonDisabled)
                        .font(.headline)
                        .foregroundColor(.white)
                        .background(isButtonDisabled ? Color(uiColor: .lightGray): Color.pink)
                        .cornerRadius(10)
                    }
                    .padding(.top, 20)
                    .padding(.horizontal, 20)
                    List {
                        ForEach(items) { item in
                            NavigationLink {
                                VStack {
                                    Text("Item at \(item.timestamp!, formatter: itemFormatter)")
                                }
                            } label: {
                                VStack(alignment: .leading) {
                                    Text(item.task ?? "")
                                        .font(.system(.title2, design: .rounded))
                                        .fontWeight(.heavy)
                                        .padding(.vertical, 12)
                                }//: VStack

                            }//: NavigationLink
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
            }//: ZStack
            .onAppear {
                UITableView.appearance().backgroundColor = .clear
            }
            .navigationBarTitle("日々のタスク", displayMode: .large)
            .background(
                BackgroundImageView()
            )
            .background(
                [Color.pink, Color.blue]
                    .addGradation()
                    .ignoresSafeArea(.all))

        }//: NavigationView
        .navigationViewStyle(StackNavigationViewStyle())

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
        }
    }

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
