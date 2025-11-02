# 🧋 eBook: Drink Shop App

一款以 **SwiftUI** 製作的手搖飲品牌整理 App。
使用者可以依品牌查看所有飲品與價格、收藏喜愛的品項，
並在「推薦」分頁中探索各品牌的新品。

---

## 🌟 專案簡介

**eBook Drink Shop** 讓使用者能夠一目了然地瀏覽手搖飲品牌與商品，
不論是想找新品、常喝品牌，還是建立自己的客製飲品清單，
都能透過這款 App 輕鬆完成。

---

## 📱 主要功能

### ✨ 推薦新品
- 顯示各品牌最新推出的飲品。
- 幫助使用者掌握手搖飲市場新趨勢。

### 🏷 品牌一覽
- 依商家查看所有飲品與價格。
- 可收藏喜愛的品牌或品項。

### ➕ 自訂
- 使用者可新增自訂品牌與飲料項目。
- 適合少見但個人喜愛的飲品品牌。

### ❤️ 我的收藏
- 查看已收藏的飲品，快速回訪。

---

## 🧭 專案結構

```bash
eBook_drinkshop/
└── eBook/
    ├── Assets.xcassets/             # App 圖片與圖示資源
    ├── AppModel.swift               # 管理 App 資料模型與狀態
    ├── BrandDetailView.swift        # 品牌詳細資訊頁面
    ├── BrandsListView.swift         # 品牌列表頁面
    ├── ContentView.swift            # 主架構 (TabView + NavigationStack)
    ├── CustomEditorView.swift       # 使用者自訂品牌與飲品的頁面
    ├── DrinkDetailView.swift        # 飲品詳細資訊頁面
    ├── FavoritesView.swift          # 收藏清單頁面
    ├── Models.swift                 # 資料模型定義（品牌、飲品等）
    ├── RecommendationsView.swift    # 新品推薦頁面
    └── eBookApp.swift               # App 進入點 (App 主體)

## 🛠 技術重點
- 使用 SwiftUI 打造現代化介面
- 採用 NavigationStack 與 TabView 結構導覽
- 資料模型化：品牌與飲品皆以 Struct 定義
- 支援使用者自訂與收藏功能

## 🚀 未來規劃
- ✅ 品牌資料串接 API
- 🗺 附近門市整合功能
- 🌈 主題切換與更豐富的動畫

## 📄 授權
此專案由 yu3333333333 建立。
歡迎學習、研究與改作，請遵守原始授權條款。
