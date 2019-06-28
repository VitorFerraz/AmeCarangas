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
    
    let repository: CarRepository = CarRemoteRepository()
    var car: Car!
    var brands: [Brand] = []
    let formatter = NumberFormatter()
    lazy var brandPickerView: UIPickerView = {
        let pickerView = UIPickerView()
        pickerView.delegate = self
        pickerView.dataSource = self
        return pickerView
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if car != nil {
            tfBrand.text = car.brand
            tfName.text = car.name
            formatter.currencySymbol = "R$ "
            tfPrice.text = formatter.string(from: NSNumber(value: car.price))
            scGasType.selectedSegmentIndex = car.gasType
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
        tfBrand.text = brands[brandPickerView.selectedRow(inComponent: 0)].fipe_name
        cancel()
    }
    
    func loadBrands() {
        repository.loadBrands { (result) in
            switch result {
            case .failure(let error):
                print(error)
            case .success(let brands):
                self.brands = brands.sorted(by: {$0.fipe_name < $1.fipe_name})
                DispatchQueue.main.async {
                    self.brandPickerView.reloadAllComponents()
                }
            }
        }
    }

    @IBAction func addEdit(_ sender: UIButton) {
        
        sender.isEnabled = false
        sender.alpha = 0.5
        sender.backgroundColor = .gray
        
        loading.startAnimating()
        
        if car == nil {
            car = Car()
        }
        car.brand = tfBrand.text!
        car.name = tfName.text!
        car.gasType = scGasType.selectedSegmentIndex
        
        let formatter = NumberFormatter()
        if let price = formatter.number(from: tfPrice.text!)?.doubleValue {
            car.price = price
        } else {
            car.price = 0
        }
        if car._id == nil {
            repository.save(car: car) { (result) in
                switch result {
                case .failure(let error):
                    print(error)
                case .success:
                    self.goBack()
                }
            }
        } else {
            repository.delete(car: car) { (result) in
                switch result {
                case .failure(let error):
                    print(error)
                case .success:
                    self.goBack()
                }
            }
        }

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
        return brands.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let brand = brands[row]
        return brand.fipe_name
    }
}





