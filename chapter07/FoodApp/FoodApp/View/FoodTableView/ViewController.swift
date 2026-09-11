import UIKit
import RxSwift
import RxCocoa
import RxDataSources

final class ViewController: UIViewController {

    private let viewModel = FoodListViewModel(searchMenu: SearchFoodMenuUseCase(repository: SampleFoodRepository()))

    let disposeBag = DisposeBag()

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

        // tableView.delegate = self
        // tableView.dataSource = self

        viewModel.sections(matching: searchBar.searchTextField.rx.text.orEmpty.asObservable())
            .bind(to: tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)

        tableView.rx.modelSelected(Food.self)
            .subscribe(
                onNext: { [weak self] foodObject in
                    guard let self = self, let foodVC = self.storyboard?.instantiateViewController(withIdentifier: "FoodVC") as? FoodDetailViewController else { return }
                    // foodVC.imageName = foodObject.image
                    foodVC.imageName.accept(foodObject.image)
                    self.navigationController?.pushViewController(foodVC, animated: true)
                }
            )
            .disposed(by: disposeBag)

        tableView
            .rx
            .itemSelected
            .subscribe(
                onNext: { indexPath in
                    print(indexPath.row)
                }
            )
            .disposed(by: disposeBag)

    }
}
