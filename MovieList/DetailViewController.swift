//
//  DetailViewController.swift
//  MovieList
//
//  Created by jmlee on 2021/06/09.
//

import UIKit
import WebKit

class DetailViewController: UIViewController {
    @IBOutlet weak var webView: WKWebView!
    var movieName = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = movieName
        let urlKorString = "https://m.search.naver.com/search.naver?sm=mtp_hty.top&where=m&query="+movieName
        let urlString = urlKorString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        guard let url = URL(string: urlString) else { return }
        let request = URLRequest(url: url)
        webView.load(request)

        // Do any additional setup after loading the view.
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
