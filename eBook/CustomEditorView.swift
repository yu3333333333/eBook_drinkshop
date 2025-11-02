//
//  CustomEditorView.swift
//  eBook
//
//

import SwiftUI
import PhotosUI

struct CustomEditorView: View {
    @EnvironmentObject private var model: AppModel

    // 新增品牌
    @State private var brandName: String = ""
    @State private var brandImageName: String = "" // Assets 名稱（可選）
    @State private var pickedBrandPhoto: PhotosPickerItem?
    @State private var pickedBrandImageData: Data?
    @State private var pickedBrandUIImage: UIImage?

    // 新增飲料
    @State private var selectedBrand: Brand?
    @State private var drinkName: String = ""
    @State private var selectedCategory: DrinkCategory = .tea
    @State private var priceMText: String = ""
    @State private var priceLText: String = ""
    @State private var drinkImageName: String = ""
    @State private var isNew: Bool = false

    var body: some View {
        Form {
            Section("新增品牌") {
                TextField("品牌名稱（例如：新品牌）", text: $brandName)

                // 兩種方式擇一：輸入資產名稱 或 從相簿選圖
                TextField("品牌圖片名稱（可留空）", text: $brandImageName)

                HStack {
                    PhotosPicker(selection: $pickedBrandPhoto, matching: .images, photoLibrary: .shared()) {
                        Label("從相簿選取圖片", systemImage: "photo.on.rectangle")
                    }
                    .onChange(of: pickedBrandPhoto) { _, newItem in
                        Task {
                            if let data = try? await newItem?.loadTransferable(type: Data.self) {
                                pickedBrandImageData = data
                                pickedBrandUIImage = UIImage(data: data)
                            } else {
                                pickedBrandImageData = nil
                                pickedBrandUIImage = nil
                            }
                        }
                    }

                    if pickedBrandUIImage != nil {
                        Button(role: .destructive) {
                            pickedBrandPhoto = nil
                            pickedBrandImageData = nil
                            pickedBrandUIImage = nil
                        } label: {
                            Label("移除選取", systemImage: "trash")
                        }
                    }
                }

                // 預覽
                if let img = pickedBrandUIImage {
                    HStack {
                        Image(uiImage: img)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 72, height: 72)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                            .overlay(RoundedRectangle(cornerRadius: 12).stroke(.quaternary))
                        Text("將使用相簿圖片作為品牌圖")
                            .foregroundStyle(.secondary)
                        Spacer()
                    }
                } else if !brandImageName.trimmingCharacters(in: .whitespaces).isEmpty {
                    HStack {
                        Image(brandImageName)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 72, height: 72)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                            .overlay(RoundedRectangle(cornerRadius: 12).stroke(.quaternary))
                        Text("將使用資產名稱：\(brandImageName)")
                            .foregroundStyle(.secondary)
                        Spacer()
                    }
                } else {
                    Text("未選擇品牌圖片，將顯示預設樣式")
                        .foregroundStyle(.tertiary)
                }

                Button("加入品牌") {
                    model.addBrand(
                        name: brandName,
                        imageName: brandImageName.isEmpty ? nil : brandImageName,
                        imageData: pickedBrandImageData
                    )
                    // 清空欄位
                    brandName = ""
                    brandImageName = ""
                    pickedBrandPhoto = nil
                    pickedBrandImageData = nil
                    pickedBrandUIImage = nil
                }
                .disabled(brandName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
            }

            Section("新增飲料") {
                Picker("品牌", selection: $selectedBrand) {
                    Text("請選擇").tag(Optional<Brand>.none)
                    ForEach(model.brands) { brand in
                        Text(brand.name).tag(Optional(brand))
                    }
                }
                TextField("飲料名稱", text: $drinkName)
                Picker("分類", selection: $selectedCategory) {
                    ForEach(DrinkCategory.allCases) { cat in
                        Text(cat.rawValue).tag(cat)
                    }
                }
                HStack {
                    TextField("中杯價格", text: $priceMText)
                        .keyboardType(.numberPad)
                    TextField("大杯價格", text: $priceLText)
                        .keyboardType(.numberPad)
                }
                TextField("飲料圖片名稱（可留空）", text: $drinkImageName)
                Toggle("標記為新品", isOn: $isNew)

                Button("加入飲料") {
                    let m = Int(priceMText)
                    let l = Int(priceLText)
                    if let brand = selectedBrand {
                        model.addDrink(
                            to: brand,
                            name: drinkName,
                            category: selectedCategory,
                            priceM: m,
                            priceL: l,
                            imageName: drinkImageName.isEmpty ? nil : drinkImageName,
                            isNew: isNew
                        )
                        // 清空欄位
                        drinkName = ""
                        priceMText = ""
                        priceLText = ""
                        drinkImageName = ""
                        isNew = false
                    }
                }
                .disabled(selectedBrand == nil || drinkName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
            }
        }
    }
}
