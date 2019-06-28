//
//  ViewController.swift
//  Carangas
//
//  Created by Eric Brito on 14/10/17.
//  Copyright © 2017 Eric Brito. All rights reserved.
//

import UIKit
import WebKit

enum GasType: Int {
    case alchool
    case gasoline
    case flex
}

class CarViewController: UIViewController {
    
    @IBOutlet weak var lbBrand: UILabel!
    @IBOutlet weak var lbGasType: UILabel!
    @IBOutlet weak var lbPrice: UILabel!
    @IBOutlet weak var loading: UIActivityIndicatorView!
    
    //https://developer.apple.com/documentation/webkit/wkwebview
    @IBOutlet weak var webView: WKWebView!
    
    
    var viewModel: CarDetailViewModel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard let viewModel = viewModel else { return }
        setupUI(with: viewModel)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as! AddEditViewController
        vc.car = viewModel.car
    }
    
    func setupUI(with viewModel: CarDetailViewModel) {
        title = viewModel.name
        
        lbBrand.text = viewModel.brand
        lbPrice.text = viewModel.price
        lbGasType.text = viewModel.gas
        
        let urlString = "https://www.google.com.br/search?q=\(viewModel.nameSearch)&tbm=isch"
        let url = URL(string: urlString)
        let request = URLRequest(url: url!)
        
        webView.allowsBackForwardNavigationGestures = true
        webView.allowsLinkPreview = false   //Padrão true
        webView.navigationDelegate = self
        webView.uiDelegate = self
        webView.load(request)
    }
}

extension CarViewController: WKNavigationDelegate, WKUIDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        webView.evaluateJavaScript("alert('Terminou de carregar')") { (result, error) in
            print(result ?? "---")
        }
        loading.stopAnimating()
    }
    
    func webView(_ webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping () -> Void) {
        completionHandler()
    }
}









