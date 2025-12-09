//
//  EditFoodOptionViewController.swift
//  TECHRES-ORDER
//
//  Created by Pham Khanh Huy on 26/02/2025.
//



class EditFoodOptionViewController:BaseViewController {

    @IBOutlet weak var root_view: UIView!

    @IBOutlet weak var lbl_name: UILabel!
    @IBOutlet weak var lbl_price: UILabel!
   
    
    @IBOutlet weak var textfield_quantity: UITextField!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var text_view: UITextView!

    var orderId:Int = 0
    var item: OrderItem = OrderItem()
    var viewModel = EditFoodOptionViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.bind(view: self)
        registerCellAndBindTableView()
        firstSetup(item: item)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
       
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        
    }
    
    
    
    @IBAction func actionCalculateQuantity(_ sender: UIButton) {
        var item = viewModel.orderItem.value
        
        switch sender.titleLabel?.text{
            
            case "+":
                item.setQuantity(quantity: item.quantity + (item.is_sell_by_weight == ACTIVE ? 0.01 : 1))
                break
            
            case "-":
                item.setQuantity(quantity: item.quantity - (item.is_sell_by_weight == ACTIVE  ? 0.01 : 1))
                break
            
            default:
                break
        }
        
        viewModel.orderItem.accept(item)
        textfield_quantity.text = item.quantity.toString
        self.lbl_price.text = self.calculateTotalAmount(
            item:self.viewModel.orderItem.value,
            list: viewModel.sectionArray.value.flatMap{$0.items}
        ).rounded(.up).toString
    }
    
    
    
    @IBAction func actionConfirm(_ sender: Any) {
       
        var valid = true
        
        for section in self.viewModel.sectionArray.value{
            let option = section.model
            let items = section.items
            
            if items.filter{$0.status == ACTIVE}.count < option.min_items_allowed{
                self.showWarningMessage(content: String(format: "%@ phải có số lượng tối thiểu là %d", option.name,option.min_items_allowed))
                valid = false
            }
        }
        
        if valid{
            
            let item = viewModel.orderItem.value
            var array:[FoodUpdate] = []
            
            var updateItem = FoodUpdate.init()
            updateItem.order_detail_id = item.id
            updateItem.quantity = item.quantity
            
            if updateItem.quantity == 0{
                updateItem.quantity = 1
            }
            updateItem.price = item.price
            updateItem.note = item.note
                    
            for section in viewModel.sectionArray.value{
                for optionItem in section.items{
                    let option = OptionUpdate.init(
                        food_option_id:section.model.id,
                        id: optionItem.id,
                        quantity: optionItem.quantity,
                        status: optionItem.status)
                    updateItem.order_detail_food_options.append(option)
                }
            }
            
            array.append(updateItem)
            
            updateFoodsToOrder(updateFood: array)
        }
        
    }
    
    @IBAction func actionCancel(_ sender: Any) {
        
        self.dismiss(animated: true)

    }
    
    @objc private func keyboardWillShow(notification: NSNotification ) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue{
            if text_view.isFirstResponder || textfield_quantity.isFirstResponder{
                root_view.transform = CGAffineTransform(translationX: 0, y: -keyboardSize.height)
            }
        }
    }
        
    
    @objc private func keyboardWillHide(notification: NSNotification) {
        if text_view.isFirstResponder || textfield_quantity.isFirstResponder {
            root_view.transform = .identity
        }
    }
    
    
    
}
