//
//  WorkFlow.swift
//  NJUNews
//
//  Created by 张福翔 on 2020/12/28.
//

import Foundation
import SwiftSoup

class WorkFlow {
    var infoTable = [InfoRow]()
    
    func loadAndParseHTML(url: String) {
        if let url = URL(string: url) {
            do {
                let html = try String(contentsOf: url)
                let doc = try SwiftSoup.parse(html)
                
                let table = try doc.select("#wp_news_w6")
                for elements in try table.select("li") {
                    let span1 = try elements.select("span").get(0)
                    let span2 = try elements.select("span").get(1)
                    let title = try span1.text()
                    let addr = try "https://jw.nju.edu.cn" + span1.select("a").attr("href")
                    let date = try span2.text()
                    infoTable.append(InfoRow(title: title, url: addr, date: date))
                }
            } catch Exception.Error(let type, let message) {
                print(type, message)
            } catch {
                print("error")
            }
        }
    }
}
