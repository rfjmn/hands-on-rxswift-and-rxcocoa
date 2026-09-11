import Foundation
import XCTest
import RxSwift
@testable import FoodMenuCore

final class FoodListViewModelTests: XCTestCase {
    func testThrottleUsesLatestQueryAndSkipsDuplicates() {
        let clock = HistoricalScheduler(initialClock: Date(timeIntervalSince1970: 0))
        let repository = RepositorySpy()
        let model = FoodListViewModel(searchMenu: SearchFoodMenuUseCase(repository: repository), scheduler: clock)
        let query = PublishSubject<String>()
        var names: [[String]] = []
        let subscription = model.categories(matching: query).subscribe(onNext: { names.append($0.flatMap { $0.items }.map { $0.name }) })
        query.onNext("")
        query.onNext("P")
        query.onNext("Pizza")
        XCTAssertEqual(repository.reads, 1)
        clock.advanceTo(Date(timeIntervalSince1970: 0.3))
        XCTAssertEqual(names, [["Pizza", "Cake"], ["Pizza"]])
        query.onNext("Pizza")
        clock.advanceTo(Date(timeIntervalSince1970: 0.6))
        XCTAssertEqual(repository.reads, 2)
        subscription.dispose()
    }

    func testDisposalCancelsPendingSearchAndViewModelCanBeReleased() {
        let clock = HistoricalScheduler(initialClock: Date(timeIntervalSince1970: 0))
        let repository = RepositorySpy()
        var model: FoodListViewModel? = FoodListViewModel(searchMenu: SearchFoodMenuUseCase(repository: repository), scheduler: clock)
        weak var weakModel = model
        let query = PublishSubject<String>()
        let subscription = model!.categories(matching: query).subscribe()
        query.onNext("")
        query.onNext("Cake")
        subscription.dispose()
        XCTAssertFalse(query.hasObservers)
        clock.advanceTo(Date(timeIntervalSince1970: 1))
        XCTAssertEqual(repository.reads, 1)
        model = nil
        XCTAssertNil(weakModel)
    }
}

private final class RepositorySpy: FoodRepository {
    var reads = 0
    var categories: [FoodCategory] {
        reads += 1
        return [FoodCategory(header: "Menu", items: [Food(name: "Pizza", image: "pizza"), Food(name: "Cake", image: "cake")])]
    }
}
