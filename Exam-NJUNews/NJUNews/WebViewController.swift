//
//  WebViewController.swift
//  NJUNews
//
//  Created by 张福翔 on 2020/12/28.
//

import UIKit
import WebKit

class WebViewController: UIViewController {
    var addr = ""
    let webView = WKWebView()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.view = webView
        
        guard let url = URL(string: addr) else {
            fatalError("Unexpected URL: \(addr)")
        }
        let request = URLRequest(url: url)
        print(request)
        webView.load(request)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
