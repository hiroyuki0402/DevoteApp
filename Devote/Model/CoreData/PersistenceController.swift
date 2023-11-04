//
//  PersistenceController.swift
//  Devote
//
//  Created by SHIRAISHI HIROYUKI on 2023/11/04.
//

import CoreData

struct PersistenceController {
    /// シングルトンパターンを使用してアプリ全体で一つのインスタンスを共有するためのコントローラー
    static let shared = PersistenceController()

    /// 永続コンテナーこのインスタンスは、Core Dataのデータモデルを管理し、
    /// データベースとのやり取りを行うための機能を提供する
    let container: NSPersistentContainer

    /// 初期化処理コアデータスタックのセットアップやデータモデルのロードを行います
    /// - Parameter inMemory: テスト時に使用し、データを実際のデータベースではなくメモリ上に一時的に保存する
    init(inMemory: Bool = false) {
        // Devoteという名前のデータモデルを使用してNSPersistentContainerを初期化する
        container = NSPersistentContainer(name: "Devote")

        // もしinMemoryフラグがtrueの場合、データベースファイルの代わりに/dev/nullを使用してデータを保存しないようにする
        // これはテストやプレビュー用途に有用
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }

        // 永続ストアをロードし、エラーがあればアプリをクラッシュさせる
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // ストアのロードに失敗した場合、詳細なエラー情報と共にクラッシュを発生させる
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })

        // 親コンテキストからの変更を自動的に現在のビューコンテキストにマージするように設定する
        // これにより、データの整合性が保たれ、変更が反映されやすくなる
        /*
         この設定により、NSPersistentContainerのviewContext（UIにバインドされる主要なコンテキスト）は、
         他のコンテキストによって保存された変更を自動的に受け入れてマージする
         例えば、バックグラウンドスレッドでデータの大量インポートを行った場合でも、その変更はUIに自動的に反映される
         */
        container.viewContext.automaticallyMergesChangesFromParent = true
    }

    /// プレビュー用のPersistenceControllerのインスタンスを生成する
    /// データを実際のデータベースではなく、メモリ上に保存することで、
    /// UIのプレビューやテストが行えるようになる
    static var preview: PersistenceController = {
        let result = PersistenceController(inMemory: true)

        // プレビュー用のコンテキストを取得する
        let viewContext = result.container.viewContext

        // 10個の新しいItemインスタンスを生成し、現在の日付をタイムスタンプとして設定する
        for i in 0..<5 {
            let newItem = Item(context: viewContext)
            newItem.timestamp = Date()
            newItem.task = "サンプル タスク No: \(i)"
            newItem.complision = false
            newItem.id = UUID()
        }
        do {
            // コンテキスト内の変更を保存するこれにより、プレビュー用のデータが生成されます
            try viewContext.save()
        } catch {
            // エラーが発生した場合は、その内容をログに記録し、アプリをクラッシュさせる
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }

        // 初期化されたプレビューコントローラーを返する
        return result
    }()
}
