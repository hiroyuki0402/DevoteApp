//
//  ContentView.swift
//  Devote
//
//  Created by SHIRAISHI HIROYUKI on 2023/11/04.
//

import SwiftUI

struct ContentView: View {
    // MARK: - プロパティー

    /// 現在のビューコンテキストへの参照を保持するこれにより、このビューがCore Dataの操作を行えるようになる
    @Environment(\.managedObjectContext) private var viewContext

    /// Core DataのItemエンティティからデータをフェッチし、指定されたソート順で並べ替えるためのリクエスト
    @FetchRequest(
        // ソート記述子を指定して、アイテムをタイムスタンプ順にソートする
        sortDescriptors: [
            NSSortDescriptor(
                // キーパスはItemのtimestamp属性を指し、これに基づいてソートする
                keyPath: \Item.timestamp,
                // 昇順に設定しています。これにより、古いアイテムから新しいアイテムへと並ぶ
                ascending: true)],
        // フェッチリクエストの結果に変更があったときのアニメーションをデフォルトに設定する
        animation: .default)
    // フェッチリクエストから返された結果のセットを保持する
    private var items: FetchedResults<Item>

    // MARK: - ボディー
    var body: some View {
        NavigationView {
            List {
                // フェッチされたアイテムのリストを表示する
                ForEach(items) { item in
                    // 各アイテムにナビゲーションリンクを設定する
                    NavigationLink {
                        // アイテムの詳細ビューを表示する
                        Text("Item at \(item.timestamp!, formatter: itemFormatter)")
                    } label: {
                        // リストに表示されるアイテムのタイムスタンプをフォーマットして表示する
                        Text(item.timestamp!, formatter: itemFormatter)
                    }
                }
                .onDelete(perform: deleteItems)
            }//: List
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    // 編集ボタンを追加し、リストの編集を可能にする
                    EditButton()
                }
                ToolbarItem {
                    // 新しいアイテムを追加するためのボタンを配置する
                    Button(action: addItem) {
                        Label("Add Item", systemImage: "plus")
                    }
                }
            }//: toolbar
            // リストでアイテムが選択されていないときに表示されるテキスト
            Text("Select an item")
        }//: NavigationView
    }//: ボディー

    // MARK: - メソッド

    /// 新しいアイテムを追加するメソッド
    private func addItem() {
        withAnimation {
            // 新しいItemエンティティインスタンスを作成し、現在の日時を設定する
            let newItem = Item(context: viewContext)
            newItem.timestamp = Date()

            // ビューコンテキストを介して変更を保存しようとする
            do {
                try viewContext.save()
            } catch {
                // エラーが発生した場合は、クラッシュ前に詳細情報を出力する
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
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

/// アイテムの日時を表示するためのフォーマッタ日付は短いスタイルで、時刻は中くらいのスタイルで表示される
private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .medium
    return formatter
}()

#Preview {
    ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
