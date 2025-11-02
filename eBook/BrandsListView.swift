//
//  BrandsListView.swift
//  eBook
//
//

import SwiftUI
import UIKit

struct BrandsListView: View {
    @EnvironmentObject private var model: AppModel

    var body: some View {
        List {
            ForEach(model.brands) { brand in
                NavigationLink {
                    BrandDetailView(brand: brand)
                } label: {
                    HStack(spacing: 12) {
                        brandThumbnail(for: brand)
                            .frame(width: 56, height: 56)
                            .clipShape(RoundedRectangle(cornerRadius: 8))

                        VStack(alignment: .leading, spacing: 4) {
                            Text(brand.name)
                                .font(.headline)
                            Text("\(brand.drinks.count) 項飲料")
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                        }
                        Spacer()
                        Image(systemName: "chevron.right")
                            .foregroundStyle(.tertiary)
                    }
                    .padding(.vertical, 4)
                }
            }
        }
        .listStyle(.inset)
    }

    @ViewBuilder
    private func brandThumbnail(for brand: Brand) -> some View {
        if let data = brand.imageData, let uiImage = UIImage(data: data) {
            Image(uiImage: uiImage)
                .resizable()
                .scaledToFill()
        } else if let name = brand.imageName {
            Image(name)
                .resizable()
                .scaledToFill()
        } else {
            ZStack {
                Color.gray.opacity(0.15)
                Image(systemName: "photo")
                    .foregroundStyle(.secondary)
            }
        }
    }
}
