//
//  MovieData.swift
//  MovieList
//
//  Created by 이정민 on 2021/09/23.
//

import Foundation

struct MovieData: Codable {
    let boxOfficeResult: BoxOfficeResult
}
struct BoxOfficeResult: Codable {
    let dailyBoxOfficeList: [DailyBoxOfficeList]
}
struct DailyBoxOfficeList: Codable {
    let movieNm : String    //영화명
    let audiCnt : String    //해당 일 관객 수
    let audiAcc : String    //누적 관객 수
    let openDt  : String    //개봉일
}
