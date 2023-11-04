//
//  BlankView.swift
//  Devote
//
//  Created by SHIRAISHI HIROYUKI on 2023/11/04.
//

import SwiftUI

struct BlankView: View {
  // MARK: - PROPERTY

  var backgroundColor: Color
  var backgroundOpacity: Double

  // MARK: - BODY

  var body: some View {
    VStack {
      Spacer()
    }
    .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .center)
    .background(backgroundColor)
    .opacity(backgroundOpacity)
    .blendMode(.overlay)
    .edgesIgnoringSafeArea(.all)
  }
}

// MARK: - PREVIEW
#Preview {
    BlankView(backgroundColor: .black, backgroundOpacity: 0.3)
        .background(BackgroundImageView())
        .background([Color.pink, Color.blue].addGradation().ignoresSafeArea(.all))
}
