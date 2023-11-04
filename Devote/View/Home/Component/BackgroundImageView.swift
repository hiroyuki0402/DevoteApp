//
//  BackgroundImageView.swift
//  Devote
//
//  Created by SHIRAISHI HIROYUKI on 2023/11/04.
//

import Foundation
import SwiftUI

struct BackgroundImageView: View {
  var body: some View {
      Image(.rocket)
      .antialiased(true)
      .resizable()
      .scaledToFill()
      .ignoresSafeArea(.all)
  }
}

#Preview {
    BackgroundImageView()
  }

