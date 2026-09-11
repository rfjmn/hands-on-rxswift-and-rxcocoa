import UIKit
import RxSwift
import RxCocoa
import RxDataSources

final class ViewController: UIViewController {

    private let viewModel = FoodListViewModel(searchMenu: SearchFoodMenuUseCase(repository: SampleFoodRepository()))

    private let disposeBag = DisposeBag()

    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var searchBar: UISearchBar!

    private let dataSource = RxTableViewSectionedReloadDataSource<SectionModel>(
        configureCell: { datasource, tableView, indexPath, item in
            let cell: FoodTableViewCell = tableView.dequeueReusableCell(withIdentifier: "myCell", for: indexPath) as! FoodTableViewCell
            cell.foodLabel.text = item.name
            cell.foodImageView.image = UIImage(named: item.image)

            return cell
        },
        titleForHeaderInSection: { dataSource, index in
            return dataSource.sectionModels[index].header
        }
    )

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Menu"


        viewModel.categories(matching: searchBar.searchTextField.rx.text.orEmpty.asObservable())
            .map { $0.map { SectionModel(header: $0.header, items: $0.items) } }
            .bind(to: tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)

        tableView.rx.modelSelected(Food.self)
            .subscribe(
                onNext: { [weak self] foodObject in
                    guard let self = self, let foodVC = self.storyboard?.instantiateViewController(withIdentifier: "FoodVC") as? FoodDetailViewController else { return }
                    foodVC.imageName.accept(foodObject.image)
                    self.navigationController?.pushViewController(foodVC, animated: true)
                }
            )
            .disposed(by: disposeBag)

        tableView
            .rx
            .itemSelected
            .subscribe(
                onNext: { [weak self] indexPath in
                    self?.tableView.deselectRow(at: indexPath, animated: true)
                }
            )
            .disposed(by: disposeBag)

    }
}
