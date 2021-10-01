//
//  ViewController.swift
//  MovieList
//
//  Created by jmlee on 2021/05/24.
//

import UIKit
import RxSwift
import Alamofire

class ViewController: UIViewController {
    var movieData: MovieData?
    @IBOutlet weak var table: UITableView!
    var urlString = "https://kobis.or.kr/kobisopenapi/webservice/rest/boxoffice/searchDailyBoxOfficeList.json?key=8a150a341d7062dbacc7b64ba5c90a2a&targetDt="
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        table.delegate = self
        table.dataSource = self
        urlString += makeYeterdayString()
        getData()
    }
    
    //어제 박스오피스 구하는 함수.
    func makeYeterdayString() -> String {
        let y = Calendar.current.date(byAdding: .day, value: -1, to: Date())!
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyyMMdd"
        let convertDate = dateFormatter.string(from: y)
        return convertDate
    }
    
    //open api 데이터 가져오기
    func getData() {
        //HTTP Request
        AF.request(urlString).responseJSON { response in
            switch response.result {
            case .success(let res):
                do {
                    //반환 값을 Data 타입으로 변환.
                    let jsonData = try JSONSerialization.data(withJSONObject: res, options: .prettyPrinted)
                    //Data 디코팅.
                    let json = try JSONDecoder().decode(MovieData.self, from: jsonData)
                    self.movieData = json
                    DispatchQueue.main.async {
                        self.table.reloadData()
                    }
                }
                catch(let err) {
                    print(err)
                }
            case .failure(let err):
                print(err)
            }
        }
    }
    
    //Segue시작 전 실행되는 메소드
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let dest = segue.destination as? DetailViewController else { return }
        let myIndexPath = table.indexPathForSelectedRow!
        let row = myIndexPath.row
        
        dest.movieName = (movieData?.boxOfficeResult.dailyBoxOfficeList[row].movieNm)!
    }

}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "mycell", for: indexPath) as!
            MyTableViewCell
        cell.movieName.text = movieData?.boxOfficeResult.dailyBoxOfficeList[indexPath.row].movieNm
        if let aCnt = movieData?.boxOfficeResult.dailyBoxOfficeList[indexPath.row].audiCnt {
            let numF = NumberFormatter()
            numF.numberStyle = .decimal
            let aCount = Int(aCnt)!
            let result = numF.string(for: aCount)! + "명"
            cell.audiCount.text = "어제:\(result)"
        }
        if let aAcc = movieData?.boxOfficeResult.dailyBoxOfficeList[indexPath.row].audiAcc {
            let numF = NumberFormatter()
            numF.numberStyle = .decimal
            let aAccumulate = Int(aAcc)!
            let result = numF.string(for: aAccumulate)! + "명"
            cell.audiAccumulate.text = "누적:\(result)"
        }
        return cell
    }
    
    //섹션의 수
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    //헤더 부분
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "박스오피스(영화진흥위원회제공:" + makeYeterdayString() + ")"
    }
    
}
