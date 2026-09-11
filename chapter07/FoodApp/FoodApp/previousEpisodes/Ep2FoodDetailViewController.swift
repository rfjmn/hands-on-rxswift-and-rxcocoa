import Foundation
import UIKit

final class Ep2FoodDetailViewController: UIViewController {
    @IBOutlet weak var foodImageView: UIImageView!

    var imageName: String = "";

    override func viewDidLoad() {
        super.viewDidLoad()

        foodImageView.image = UIImage(named: imageName)
    }
}
