//
//  CarsTableViewController.swift
//  Carangas
//
//  Created by Eric Brito on 14/10/17.
//  Copyright © 2017 Eric Brito. All rights reserved.
//

import UIKit

class CarsTableViewController: UITableViewController {
    let viewModel = CarsViewModel()
    var label: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = UIColor(named: "main")
        return label
    }()
    
    override func viewDidLoad() {
        viewModel.stateChange = {
            self.label.text = self.viewModel.currentState.rawValue
        }
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadCars()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? CarViewController,
            let indexPath = tableView.indexPathForSelectedRow,
            segue.identifier! == "carSegue" {
            guard let car = viewModel.car(for: indexPath) else {return}
                vc.viewModel = CarDetailViewModel(car: car)
        }
    }
    
    func loadCars() {
        viewModel.loadCars {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tableView.backgroundView =  viewModel.currentState == .loaded ? nil : label
        return viewModel.numberOfCars
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        if let car = viewModel.car(for: indexPath) {
            cell.textLabel?.text = car.name
            cell.detailTextLabel?.text = car.brand
        }
        
        return cell
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            if let car = viewModel.car(for: indexPath) {
                viewModel.delete(car: car, at: indexPath) {
                    DispatchQueue.main.async {
                        tableView.deleteRows(at: [indexPath], with: .fade)
                    }
                }
            }
        }
    }

}
