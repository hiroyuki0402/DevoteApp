//
//  DevoteApp.swift
//  Devote
//
//  Created by SHIRAISHI HIROYUKI on 2023/11/03.
//

import SwiftUI

@main
struct DevoteApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            HomeView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}



/// `.environment`
///  このViewModifierは、環境に値を注入する、環境値は、ビュー階層内のすべてのビューでアクセス可能な値でここで注入された値は子ビューが参照できるようなる

/// `.\.managedObjectContext`
///  これは環境キーパスの一種で、SwiftUIの環境に対するmanagedObjectContextの参照を指す
///  managedObjectContextは、Core Dataオブジェクトを作成、読み込み、更新、削除するためのアクセスポイント

/// `persistenceController.container.viewContext` persistenceControllerのcontainerプロパティはNSPersistentContainerインスタンスを保持しており、viewContextはそのメインスレッドに対応したNSManagedObjectContext
/// このコンテキストは、通常、ユーザーインターフェースが直接触れるデータを操作する際に使用される

