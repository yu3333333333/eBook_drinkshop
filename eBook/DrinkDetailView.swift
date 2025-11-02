//
//  DrinkDetailView.swift
//  eBook
//
//

import SwiftUI
import UIKit

struct DrinkDetailView: View {
    @EnvironmentObject private var model: AppModel
    let drink: Drink
    let brand: Brand

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                headerImage
                    .frame(height: 220)
                    .clipped()
                    .cornerRadius(12)

                VStack(alignment: .leading, spacing: 8) {
                    Text(drink.name)
                        .font(.title).bold()
                    Text(brand.name)
                        .font(.headline)
                        .foregroundStyle(.secondary)

                    HStack {
                        Label(drink.category.rawValue, systemImage: "tag")
                        Spacer()
                        Button {
                            model.toggleFavorite(for: drink)
                        } label: {
                            Label("收藏", systemImage: model.isFavorite(drink) ? "heart.fill" : "heart")
                                .labelStyle(.iconOnly)
                                .foregroundStyle(model.isFavorite(drink) ? .red : .primary)
                                .font(.title2)
                        }
                        .buttonStyle(.plain)
                    }

                    Divider()

                    VStack(alignment: .leading, spacing: 6) {
                        Text("價格").font(.headline)
                        if let m = drink.prices[.medium] {
                            Text("中杯：\(m) 元")
                        }
                        if let l = drink.prices[.large] {
                            Text("大杯：\(l) 元")
                        }
                        if drink.prices.isEmpty {
                            Text("價格未定").foregroundStyle(.secondary)
                        }
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal)
            }
            .padding(.top)
        }
        .navigationTitle(drink.name)
        .navigationBarTitleDisplayMode(.inline)
    }

    // 優先使用飲料圖片名稱；若無則使用品牌圖片
    @ViewBuilder
    private var headerImage: some View {
        if let drinkName = drink.imageName {
            Image(drinkName)
                .resizable()
                .scaledToFill()
        } else if let data = brand.imageData, let ui = UIImage(data: data) {
            Image(uiImage: ui)
                .resizable()
                .scaledToFill()
        } else if let brandName = brand.imageName {
            Image(brandName)
                .resizable()
                .scaledToFill()
        } else {
            ZStack {
                Color.gray.opacity(0.15)
                Image(systemName: "photo")
                    .foregroundStyle(.secondary)
                    .font(.largeTitle)
            }
        }
    }
}

