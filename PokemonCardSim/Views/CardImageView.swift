//
//  ImageView.swift
//  PokemonCardPackSim
//
//  Created by Sam Plant on 22/10/2024.
//

import SwiftUI
import Combine
import UIKit

struct CardImageView: View {
    @State private var zindex: Double = 0;
    @State private var offset = CGSize.zero
    private var uiImage: UIImage;

    
    init(uiImage: UIImage) {
        self.uiImage = uiImage
    }
    
    var body: some View {
        Image(uiImage: uiImage)
            .resizable()
            .scaledToFit()
            .frame(maxWidth: 200)
            .offset(self.offset)
            .onTapGesture {
                self.offset = CGSize(width: 250, height: 0)
                self.zindex = 1
            }
            .animation(.bouncy, value: offset)
            .zIndex(self.zindex)
    }
}
