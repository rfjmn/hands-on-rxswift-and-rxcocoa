import XCTest
@testable import FoodMenuCore

final class FoodMenuTests: XCTestCase {
    func testEmptyQueryKeepsAllCategoriesAndItems() {
        let useCase = SearchFoodMenuUseCase(repository: SampleFoodRepository())
        let result = useCase.execute(query: "")
        XCTAssertEqual(result.map(\.header), ["Main Courses", "Desserts"])
        XCTAssertEqual(result.map { $0.items.count }, [10, 3])
    }

    func testSearchIgnoresCaseAndKeepsSectionOrder() {
        let useCase = SearchFoodMenuUseCase(repository: SampleFoodRepository())
        let result = useCase.execute(query: "CAKE")
        XCTAssertEqual(result[0].items.count, 0)
        XCTAssertEqual(result[1].items.map(\.name), ["Pancakes", "Cake"])
    }

    func testUnmatchedQueryKeepsEmptySections() {
        let useCase = SearchFoodMenuUseCase(repository: SampleFoodRepository())
        XCTAssertTrue(useCase.execute(query: "no such food").allSatisfy { $0.items.isEmpty })
    }
}
