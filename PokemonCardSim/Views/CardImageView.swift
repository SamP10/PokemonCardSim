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
    @State private var degrees: Double = 0;
    @State private var x: Double = 0;
    @State private var y: Double = 0
    @State private var z: Double = 0
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
                self.offset = CGSize(width: 250, height: 0)
                self.zIndex = onTap()
            }
            .animation(.smooth, value: self.offset)
            .zIndex(self.zIndex)
            .gesture(
                    DragGesture()
                        .onChanged { value in
                            if(value.translation.width > -45 &&
                               value.translation.width < 45 &&
                               value.translation.height > -45 &&
                               value.translation.height < 45 &&
                               self.offset == CGSize.zero
                            ) {
                                self.degrees = Double((value.translation.width + value.translation.height) / 2)
                            }

                            self.x = value.translation.height
                            self.y = value.translation.width
                            self.z = (self.x + self.y) / 2
                            print(self.x)
                            print(self.y)
                        }
                        .onEnded { value in
                            self.degrees = 0
                            self.x = 0
                            self.y = 0
                            self.z = 0
                        }
                )
            .rotation3DEffect(
                .degrees(self.degrees),
                axis: (x: self.x, y: self.y, z: self.z),
                anchor: .center
            )
    }
}
