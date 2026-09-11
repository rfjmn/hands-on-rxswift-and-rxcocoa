import Foundation
import UIKit
import RxSwift
import RxCocoa

final class FoodDetailViewController: UIViewController {
    @IBOutlet weak var foodImageView: UIImageView!

    // var imageName: String = ""

    let disposeBag = DisposeBag()
    let imageName: BehaviorRelay = BehaviorRelay<String>(value: "")

    override func viewDidLoad() {
        super.viewDidLoad()

        // foodImageView.image = UIImage(named: imageName)

        imageName
            .map { name in
                UIImage.init(named: name)
            }
            .bind(to: foodImageView.rx.image)
            .disposed(by: disposeBag)
    }
}
