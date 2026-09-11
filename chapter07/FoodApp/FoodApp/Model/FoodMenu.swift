import Foundation

struct FoodCategory {
    let header: String
    let items: [Food]
}

protocol FoodRepository {
    var categories: [FoodCategory] { get }
}

struct SearchFoodMenuUseCase {
    private let repository: FoodRepository

    init(repository: FoodRepository) {
        self.repository = repository
    }

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
