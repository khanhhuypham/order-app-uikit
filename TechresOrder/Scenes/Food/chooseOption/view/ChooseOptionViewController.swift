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

    override func viewDidLoad() {
        super.viewDidLoad()
      
        setupTableView()
        firstSetup()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
       
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    
    
    @IBAction func actionCalculateQuantity(_ sender: UIButton) {
        
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
        
        textfield_quantity.text = item.quantity.toString
        lbl_price.text = (item.price_with_temporary * Int(item.quantity)).toString
    }
    
    
    
    @IBAction func actionAdd(_ sender: Any) {
        
        if let delegate = self.delegate{
            self.dismiss(animated: true, completion: {
                var item = self.item
                item.select()
                
                delegate.callbackToGetItem(item: item)
            })
        }
        
    }
    
}
