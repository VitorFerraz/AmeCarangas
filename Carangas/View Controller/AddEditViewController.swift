//
//  AddEditViewController.swift
//  Carangas
//
//  Created by Eric Brito on 16/10/17.
//  Copyright © 2017 Eric Brito. All rights reserved.
//

import UIKit

class AddEditViewController: UIViewController {

    @IBOutlet weak var tfBrand: UITextField!
    @IBOutlet weak var tfName: UITextField!
    @IBOutlet weak var tfPrice: UITextField!
    @IBOutlet weak var scGasType: UISegmentedControl!
    @IBOutlet weak var btAddEdit: UIButton!
    @IBOutlet weak var loading: UIActivityIndicatorView!
    
    var viewModel = AddEditCarViewModel()
    lazy var brandPickerView: UIPickerView = {
        let pickerView = UIPickerView()
        pickerView.delegate = self
        pickerView.dataSource = self
        return pickerView
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if viewModel.currentState == .edit {
            tfBrand.text = viewModel.brand
            tfName.text = viewModel.name
            tfPrice.text = viewModel.price
            scGasType.selectedSegmentIndex = viewModel.gasType
            btAddEdit.setTitle("Alterar", for: .normal)
        }
        
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 44))
        toolbar.tintColor = UIColor(named: "main")
        let btCancel = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancel))
        let btSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let btDone = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(done))
        toolbar.items = [btCancel, btSpace, btDone]
        tfBrand.inputView = brandPickerView
        tfBrand.inputAccessoryView = toolbar
        
        loadBrands()
    }
    
    @objc func cancel() {
        tfBrand.resignFirstResponder()
    }
    
    @objc func done() {
        if let brand = viewModel.getBrand(at: brandPickerView.selectedRow(inComponent: 0)) {
             tfBrand.text = brand.fipe_name
        }
       
        cancel()
    }
    
    func loadBrands() {
        viewModel.loadBrands {
            DispatchQueue.main.async {
                self.brandPickerView.reloadAllComponents()
            }
        }
    }

    @IBAction func addEdit(_ sender: UIButton) {
        
        sender.isEnabled = false
        sender.alpha = 0.5
        sender.backgroundColor = .gray
        
        loading.startAnimating()
        
        
        
        viewModel.addEditCar(brand: tfBrand.text!,
                            name: tfName.text!,
                            gasType: scGasType.selectedSegmentIndex,
                            price: tfPrice.text!, completion: { result in
                                switch result {
                                case .failure(let error):
                                    print(error.localizedDescription)
                                case .success:
                                    self.goBack()
                                }
        })
    }
    
    func goBack() {
        DispatchQueue.main.async {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
}

extension AddEditViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return viewModel.numberOfBrands
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        guard let brand = viewModel.getBrand(at: row) else { return "" }
        return brand.fipe_name
    }
}





