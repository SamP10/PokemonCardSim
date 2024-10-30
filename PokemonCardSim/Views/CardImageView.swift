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
    @State private var offset = CGSize.zero
    @State private var zIndex: Double = 0;
    private var uiImage: UIImage;
    var onTap: (() -> Double);

    
    init(uiImage: UIImage, onTap: (() -> Double)? = nil) {
        self.uiImage = uiImage
        self.onTap = (onTap)!;
    }
    
    var body: some View {
            Image(uiImage: uiImage)
                .resizable()
                .scaledToFit()
                .frame(maxWidth: 200)
                .offset(self.offset)
                .onTapGesture {
                    self.zIndex = onTap()
                    withAnimation(.smooth) {
                        self.offset = CGSize(width: 250, height: 0)
                    }
                }
                .shadow(color: Color(red: 0.5, green: 0.5, blue: 0.5, opacity: 0.3), radius: 7.5, x: 2, y: 2)
                .zIndex(self.zIndex)
    }
}
