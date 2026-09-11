import Foundation

/// 見出しと料理の一覧を保持するメニューの分類。
struct FoodCategory {
    let header: String
    let items: [Food]
}

/// メニューの分類と料理を提供するデータ境界。
protocol FoodRepository {
    var categories: [FoodCategory] { get }
}

/// 料理名を大文字・小文字を区別せずに検索するUseCase。
struct SearchFoodMenuUseCase {
    private let repository: FoodRepository

    init(repository: FoodRepository) {
        self.repository = repository
    }

    /// 検索語を含む料理を返します。分類の順序と空の分類は維持し、空の検索語では全料理を返します。
    func execute(query: String) -> [FoodCategory] {
        repository.categories.map { category in
            FoodCategory(header: category.header, items: category.items.filter {
                query.isEmpty || $0.name.localizedCaseInsensitiveContains(query)
            })
        }
    }
}

struct SampleFoodRepository: FoodRepository {
    let categories = [
        FoodCategory(header: "Main Courses", items: [
            Food.init(name: "Hamburger", image: "hamburger"),
            Food.init(name: "Pizza", image: "pizza"),
            Food.init(name: "Salmon", image: "salmon"),
            Food.init(name: "Spaghetti", image: "spaghetti"),
            Food.init(name: "Club-sandwich", image: "club-sandwich"),
            Food.init(name: "Curry", image: "curry"),
            Food.init(name: "Salad cheese", image: "salad-cheese"),
            Food.init(name: "Salad veggy", image: "salad-veg"),
            Food.init(name: "Ribs", image: "ribs"),
            Food.init(name: "Chana masala", image: "chana-masala"),
        ]),
        FoodCategory(header: "Desserts", items: [
            Food.init(name: "Pancakes", image: "pancakes"),
            Food.init(name: "Tiramisu", image: "tiramisu"),
            Food.init(name: "Cake", image: "cake"),
        ]),
    ]
}
