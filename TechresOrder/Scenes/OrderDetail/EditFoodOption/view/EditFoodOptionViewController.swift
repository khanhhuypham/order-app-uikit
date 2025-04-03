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
        setupTableView()
        firstSetup()
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
                item.setQuantity(quantity: item.quantity + 1)
                break
            
            case "-":
                item.setQuantity(quantity: item.quantity - 1)
                break
            
            default:
                break
        }
        
        textfield_quantity.text = item.quantity.toString
        viewModel.orderItem.accept(item)
        
    }
    
    
    
    @IBAction func actionConfirm(_ sender: Any) {
        let item = viewModel.orderItem.value
        var array:[FoodUpdate] = []
        
        var updateItem = FoodUpdate.init()
        updateItem.order_detail_id = item.id
        updateItem.quantity = item.quantity
        
        if updateItem.quantity == 0{
            updateItem.quantity = 1
        }
        
        updateItem.note = item.note
                
        for option in item.order_detail_options{
            
            for optItem in option.food_option_foods {
                var option = OptionUpdate.init(id: optItem.id, status: optItem.status)
                updateItem.order_detail_food_options.append(option)
            }
        
        }
        
        array.append(updateItem)
        
        updateFoodsToOrder(updateFood: array)

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
