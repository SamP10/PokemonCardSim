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
    @State public var isRevealed: Bool = false;
    @State private var isPortrait = UIDevice.current.orientation.isPortrait;
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
                .frame(maxWidth: self.isPortrait ? 300 : 200)
                .offset(self.offset)
                .onTapGesture {
                    self.zIndex = onTap()
                    withAnimation(.smooth) {
                        self.offset = CGSize(width: self.isPortrait ? 320 : 250, height: 0)
                    }
                    self.isRevealed = true;
                }
                .zIndex(self.zIndex)
    }
}
