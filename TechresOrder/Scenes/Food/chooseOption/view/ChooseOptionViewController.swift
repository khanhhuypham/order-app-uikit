import UIKit
import Kingfisher

class ChooseOptionViewController: BaseViewController {

    @IBOutlet weak var root_view: UIView!
    @IBOutlet weak var food_image: UIImageView!
    
    @IBOutlet weak var lbl_name: UILabel!
    @IBOutlet weak var lbl_price: UILabel!

    
    @IBOutlet weak var textfield_quantity: UITextField!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var height_of_table: NSLayoutConstraint!
    @IBOutlet weak var text_view: UITextView!
    
    var delegate: ChooseOptionViewControllerDelegate?
    var item: Food = Food()
    var viewModel = ChooseOptionViewModel()
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.bind(view: self)
        registerCellAndBindTableView()
        firstSetup(item)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
       
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    
    
    @IBAction func actionCalculateQuantity(_ sender: UIButton) {
        var item = viewModel.item.value
        
        switch sender.titleLabel?.text{
            
            case "+":
                item.quantity += 1
                break
            
            case "-":
                item.quantity -= 1
                break
            
            default:
                break
        }
        viewModel.item.accept(item)
        
        textfield_quantity.text = item.quantity.toString
        lbl_price.text = (item.price_with_temporary * Int(item.quantity)).toString
    }
    
    
    
    @IBAction func actionAdd(_ sender: Any) {
        
        if let delegate = self.delegate{
            self.dismiss(animated: true, completion: {
                var item = self.viewModel.item.value
            
                item.food_options = self.viewModel.sectionArray.value.map { section in
                    var option = section.model
                    option.addition_foods = section.items
                    return option
                }
                item.select()
                
                delegate.callbackToGetItem(item: item)
            })
        }
        
    }
    
}
