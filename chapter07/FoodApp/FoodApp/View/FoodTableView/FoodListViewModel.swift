import RxSwift

/// 検索入力をメニューの分類へ変換する表示層。UI部品やRxDataSourcesには依存しません。
final class FoodListViewModel {
    private let searchMenu: SearchFoodMenuUseCase
    private let scheduler: SchedulerType
    private let interval: RxTimeInterval

    init(searchMenu: SearchFoodMenuUseCase, scheduler: SchedulerType = MainScheduler.instance, interval: RxTimeInterval = .milliseconds(300)) {
        self.searchMenu = searchMenu
        self.scheduler = scheduler
        self.interval = interval
    }

    /// 最初の入力と各間隔の最新入力を検索します。連続する同じ検索語は再検索しません。
    /// 購読を破棄すると、保留中の検索も破棄されます。
    func categories(matching query: Observable<String>) -> Observable<[FoodCategory]> {
        let searchMenu = searchMenu
        return query
            .throttle(interval, scheduler: scheduler)
            .distinctUntilChanged()
            .map(searchMenu.execute)
    }
}
