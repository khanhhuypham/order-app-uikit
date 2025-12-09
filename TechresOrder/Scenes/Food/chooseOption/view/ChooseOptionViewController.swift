import UIKit
import Kingfisher
import TagListView

class ChooseOptionViewController: BaseViewController {

    @IBOutlet weak var root_view: UIView!
    @IBOutlet weak var food_image: UIImageView!
    
    @IBOutlet weak var lbl_name: UILabel!
    @IBOutlet weak var lbl_price: UILabel!
    
    @IBOutlet weak var textfield_quantity: UITextField!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var height_of_table: NSLayoutConstraint!
    @IBOutlet weak var text_view: UITextView!
    
    @IBOutlet weak var height_of_tagListView: NSLayoutConstraint!
    @IBOutlet weak var tagListView: TagListView!
    
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
        tableView.removeObserver(self, forKeyPath: "contentSize")
    }
    
    
    @IBAction func actionCalculateQuantity(_ sender: UIButton) {
        
        var item = viewModel.item.value
        
        switch sender.titleLabel?.text{
            
            case "+":
                item.quantity += item.is_sell_by_weight == ACTIVE ? 0.01 : 1
                break
            
            case "-":
                item.quantity -= item.is_sell_by_weight == ACTIVE ? 0.01 : 1
                break
            
            default:
                break
        }
        
        if item.quantity <= 0 {
            item.deSelect()
        }
        
        
        viewModel.item.accept(item)
        textfield_quantity.text = item.quantity.toString
        lbl_price.text = (Float(item.price_with_temporary) * item.quantity).rounded(.up).toString

    }
    
    
    @IBAction func actionAdd(_ sender: Any) {
        
        var valid = true
        
        for section in self.viewModel.sectionArray.value{
            let option = section.model
            let items = section.items
            
            if items.filter{$0.is_selected == ACTIVE}.count < option.min_items_allowed{
                self.showWarningMessage(content: String(format: "%@ phải có số lượng tối thiểu là %d", option.name,option.min_items_allowed))
                valid = false
            }
            
        }
        
        
        if let delegate = self.delegate, valid{
            self.dismiss(animated: true, completion: {
                
                var item = self.viewModel.item.value
            
                item.food_options = self.viewModel.sectionArray.value.map { section in
                    var option = section.model
                    option.addition_foods = section.items
                    return option
                }
                if item.quantity > 0{
                    item.select()
                }else{
                    item.deSelect()
                }
                                
                delegate.callbackToGetItem(item: item)
            })
        }
    }
    
}
