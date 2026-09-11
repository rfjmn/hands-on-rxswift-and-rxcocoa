import RxSwift

/// 検索入力を、RxDataSourcesで表示するセクションのストリームへ変換するViewModel。
final class FoodListViewModel {
    private let searchMenu: SearchFoodMenuUseCase

    init(searchMenu: SearchFoodMenuUseCase) {
        self.searchMenu = searchMenu
    }

    /// 検索入力を300ミリ秒のthrottleで間引き、連続して同じ検索語が流れた場合は検索を繰り返しません。
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
