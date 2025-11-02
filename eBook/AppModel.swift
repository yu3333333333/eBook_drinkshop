//
//  AppModel.swift
//  eBook
//
//

import Foundation
import SwiftUI
import Combine

@MainActor
final class AppModel: ObservableObject {

    @Published var brands: [Brand] = []
    @Published var favoriteDrinkIDs: Set<UUID> = []

    init() {
        loadSampleData()
    }

    func toggleFavorite(for drink: Drink) {
        if favoriteDrinkIDs.contains(drink.id) {
            favoriteDrinkIDs.remove(drink.id)
        } else {
            favoriteDrinkIDs.insert(drink.id)
        }
    }

    func isFavorite(_ drink: Drink) -> Bool {
        favoriteDrinkIDs.contains(drink.id)
    }

    // 保留舊介面：只用資產名稱
    func addBrand(name: String, imageName: String) {
        guard !name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return }
        let brand = Brand(name: name, imageName: imageName, imageData: nil, drinks: [])
        brands.append(brand)
    }

    // 新增：支援相簿圖片（imageData），或同時支援 imageName
    func addBrand(name: String, imageName: String?, imageData: Data?) {
        guard !name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return }
        let brand = Brand(name: name, imageName: imageName, imageData: imageData, drinks: [])
        brands.append(brand)
    }

    func addDrink(
        to brand: Brand,
        name: String,
        category: DrinkCategory,
        priceM: Int?,
        priceL: Int?,
        imageName: String? = nil,
        isNew: Bool = false
    ) {
        guard let index = brands.firstIndex(where: { $0.id == brand.id }) else { return }
        var prices: [DrinkSize: Int] = [:]
        if let m = priceM { prices[.medium] = m }
        if let l = priceL { prices[.large] = l }
        var drink = Drink(
            name: name,
            brandID: brand.id,
            category: category,
            prices: prices,
            imageName: imageName,
            isNew: isNew
        )
        drink.id = UUID()
        brands[index].drinks.append(drink)
    }

    func drinks(for brand: Brand) -> [Drink] {
        brands.first(where: { $0.id == brand.id })?.drinks ?? []
    }

    var allDrinks: [Drink] {
        brands.flatMap { $0.drinks }
    }

    var favoriteDrinks: [Drink] {
        allDrinks.filter { favoriteDrinkIDs.contains($0.id) }
    }

    private func loadSampleData() {
        // 品牌
        var b50lan = Brand(name: "五十嵐", imageName: "50lan", imageData: nil)
        var aniceholiday = Brand(name: "一沐日", imageName: "aniceholiday", imageData: nil)
        var chingshin = Brand(name: "清心福全", imageName: "chingshin", imageData: nil)
        var coco = Brand(name: "CoCo", imageName: "coco", imageData: nil)
        var guiji = Brand(name: "龜記", imageName: "guiji", imageData: nil)
        var kebuke = Brand(name: "可不可熟成紅茶", imageName: "kebuke", imageData: nil)
        var macu = Brand(name: "麻古茶坊", imageName: "macu", imageData: nil)
        var milksha = Brand(name: "迷客夏", imageName: "milksha", imageData: nil)
        var wootea = Brand(name: "五桐號", imageName: "wootea", imageData: nil)

        func d(_ brand: inout Brand, _ name: String, _ cat: DrinkCategory, _ m: Int?, _ l: Int?, img: String? = nil, isNew: Bool = false) {
            var prices: [DrinkSize: Int] = [:]
            if let m = m { prices[.medium] = m }
            if let l = l { prices[.large] = l }
            var drink = Drink(
                name: name,
                brandID: brand.id,
                category: cat,
                prices: prices,
                imageName: img,
                isNew: isNew
            )
            drink.id = UUID()
            brand.drinks.append(drink)
        }

        // 五十嵐（含新品）
        d(&b50lan, "茉莉綠茶", .tea, 35, 40)
        d(&b50lan, "阿薩姆紅茶", .tea, 35, 40)
        d(&b50lan, "四季春青茶", .tea, 35, 40)
        d(&b50lan, "黃金烏龍", .tea, 35, 40)
        d(&b50lan, "檸檬綠", .tea, 50, 60)
        d(&b50lan, "8冰綠", .tea, 50, 60)
        d(&b50lan, "四季春＋珍波椰", .taste, 40, 50)
        d(&b50lan, "波霸奶茶", .taste, 50, 60)
        d(&b50lan, "奶茶", .milkTea, 50, 60)
        d(&b50lan, "紅茶瑪奇朵", .milkTea, 50, 60)
        d(&b50lan, "黃金烏龍奶茶", .milkTea, 50, 60)
        d(&b50lan, "檸檬梅汁", .fruit, 60, 75)
        d(&b50lan, "柚子茶", .fruit, 50, 60)
        d(&b50lan, "葡萄柚多多", .fruit, 65, 80)
        d(&b50lan, "紅茶拿鐵", .latte, 60, 75)
        d(&b50lan, "綠茶拿鐵", .latte, 60, 75)
        d(&b50lan, "黃金烏龍拿鐵", .latte, 60, 75)
        d(&b50lan, "阿華田拿鐵", .latte, 65, 80)
        d(&b50lan, "冰淇淋紅茶", .icecream, 50, 60)
        d(&b50lan, "芒果青", .icecream, 50, 60)
        d(&b50lan, "荔枝烏龍", .icecream, 50, 60)
        d(&b50lan, "冰淇淋麵茶紅茶拿鐵", .latte, 60, 70, img: "冰淇淋麵茶紅茶拿鐵", isNew: true)
        d(&b50lan, "重焙烏龍拿鐵", .latte, 60, 75, img: "重焙烏龍拿鐵", isNew: true)

        // 一沐日
        d(&aniceholiday, "清香烏龍綠", .tea, nil, 40)
        d(&aniceholiday, "糯米香茶", .tea, nil, 40)
        d(&aniceholiday, "島韻紅茶", .tea, nil, 40)
        d(&aniceholiday, "炭焙烏龍", .tea, nil, 35)
        d(&aniceholiday, "油切蕎麥茶", .tea, nil, 35)
        d(&aniceholiday, "手採高山青", .tea, nil, 35)
        d(&aniceholiday, "糯香奶茶", .milkTea, nil, 55)
        d(&aniceholiday, "粉粿黑糖奶茶", .milkTea, nil, 65)
        d(&aniceholiday, "黃金蕎麥奶茶", .milkTea, nil, 50)
        d(&aniceholiday, "逮丸奶茶", .milkTea, nil, 70)
        d(&aniceholiday, "極黑芝麻奶茶", .milkTea, nil, 65)
        d(&aniceholiday, "島韻紅奶茶", .milkTea, nil, 55)
        d(&aniceholiday, "荔枝烏龍", .fruit, nil, 55)
        d(&aniceholiday, "粉粿桂花檸檬", .fruit, nil, 65)
        d(&aniceholiday, "檸檬高山青", .fruit, nil, 60)

        // 清心福全
        d(&chingshin, "普洱紅茶", .tea, 25, 30)
        d(&chingshin, "奶蓋綠茶", .milkTea, 55, 65)
        d(&chingshin, "百香雙響炮", .fruit, 50, 60)

        // CoCo
        d(&coco, "紅茶拿鐵", .coffee, 55, 65)
        d(&coco, "珍珠奶茶", .milkTea, 50, 60)
        d(&coco, "鮮榨柳橙", .fruit, 60, 70)

        // 龜記
        d(&guiji, "熟成紅茶", .tea, 35, 45)
        d(&guiji, "焙茶拿鐵", .milkTea, 60, 70)
        d(&guiji, "冬瓜檸檬", .others, 40, 50)

        // 可不可
        d(&kebuke, "熟成檸果", .fruit, 55, 65)
        d(&kebuke, "熟成紅茶", .tea, 30, 40)
        d(&kebuke, "熟成歐蕾", .milkTea, 55, 65)

        // 麻古
        d(&macu, "芝芝莓果", .fruit, 70, 80)
        d(&macu, "鐵觀音奶茶", .milkTea, 55, 65)
        d(&macu, "葡萄柚綠", .fruit, 60, 70)

        // 迷客夏
        d(&milksha, "大正紅茶拿鐵", .latte, 55, 65)
        d(&milksha, "那杯紅茶拿鐵", .latte, 60, 70)
        d(&milksha, "蜜堤紅烏龍拿鐵", .latte, 60, 70)
        d(&milksha, "鮮奶茶", .milkTea, 55, 65)
        d(&milksha, "玉露青茶", .tea, nil, 45)
        d(&milksha, "熱帶水果氣泡", .fruit, nil, 75)

        // 五桐號
        d(&wootea, "白玉歐蕾", .milkTea, 65, 75)
        d(&wootea, "阿里山青茶", .tea, 40, 50)
        d(&wootea, "柚香綠茶", .fruit, 55, 65)
        d(&wootea, "杏仁凍焙茶冰沙", .others, nil, 89, img: "杏仁凍焙茶冰沙", isNew: true)
        d(&wootea, "紅豆粉粿抹茶冰", .others, nil, 89, img: "紅豆粉粿抹茶冰", isNew: true)
        d(&wootea, "焙茶珍珠可可", .others, nil, 69, img: "焙茶珍珠可可", isNew: true)
        d(&wootea, "鐵觀音焙奶茶", .milkTea, nil, 65, img: "鐵觀音焙奶茶", isNew: true)

        self.brands = [b50lan, aniceholiday, chingshin, coco, guiji, kebuke, macu, milksha, wootea]
    }
}
