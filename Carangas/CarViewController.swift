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
    
    var car: Car!

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        title = car.name
        lbBrand.text = car.brand
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencySymbol = "R$ "
        formatter.locale = Locale(identifier: "pt-BR")
        formatter.alwaysShowsDecimalSeparator = true
        
        lbPrice.text = formatter.string(for: car.price)!
        lbGasType.text = car.gas
        
        let name = (title! + "+" + car.brand).replacingOccurrences(of: " ", with: "+")
        let urlString = "https://www.google.com.br/search?q=\(name)&tbm=isch"
        print(name)
        let url = URL(string: urlString)
        let request = URLRequest(url: url!)
        
        webView.allowsBackForwardNavigationGestures = true
        webView.allowsLinkPreview = false   //Padrão true
        webView.navigationDelegate = self
        webView.uiDelegate = self
        webView.load(request)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as! AddEditViewController
        vc.car = car
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
        print("Rodou o alerta ->", message)
        /*
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
            completionHandler()
        }))
        present(alert, animated: true, completion: nil)
         */
        completionHandler()
    }
}









