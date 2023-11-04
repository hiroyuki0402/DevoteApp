//
//  Array-Extension.swift
//  Devote
//
//  Created by SHIRAISHI HIROYUKI on 2023/11/04.
//

import Foundation

import Foundation
import SwiftUI

extension Array where Element == Color {

    /// 配列内の色を使用して線形グラデーションを作成するメソッド
    /// グラデーションは、開始点から終了点へと色の遷移を作り出す
    ///
    /// - Parameters:
    ///   - startpoint: グラデーションが開始する位置を表す`UnitPoint`
    ///                 デフォルトは`.topTrailing`で、ビューの右上から開始し
    ///   - endPoint: グラデーションが終了する位置を表す`UnitPoint`
    ///               デフォルトは`.bottomTrailing`で、ビューの右下に向かって終了
    ///
    /// - Returns: `self`に含まれる色を使用して構成された`LinearGradient`インスタンス
    ///            これを利用してビューに色の遷移を追加することが可能
    func addGradation(startpoint: UnitPoint = .topTrailing, endPoint: UnitPoint = .bottomTrailing) -> LinearGradient {
        return LinearGradient(
            gradient: Gradient(colors: self),
            startPoint: startpoint,
            endPoint: endPoint)
    }
}
