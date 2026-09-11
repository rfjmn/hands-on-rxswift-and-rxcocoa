import RxSwift

final class FoodListViewModel {
    private let searchMenu: SearchFoodMenuUseCase

    init(searchMenu: SearchFoodMenuUseCase) {
        self.searchMenu = searchMenu
    }

    func sections(matching query: Observable<String>) -> Observable<[SectionModel]> {
        let searchMenu = searchMenu
        return query
            .throttle(.milliseconds(300), scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .map { query in
                searchMenu.execute(query: query).map { SectionModel(header: $0.header, items: $0.items) }
            }
    }
}
