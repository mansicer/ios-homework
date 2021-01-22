//
//  TeachingNewsViewController.swift
//  NJUNews
//
//  Created by CuiZihan on 2020/12/23.
//

import UIKit

class TeachingNewsViewController: UIViewController {
    var teachingNews = TeachingNews()
    var modifiedInfoTable = [InfoRow]()
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!

    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        teachingNews.loadAndParseHTML(url: "https://jw.nju.edu.cn/24774/list.htm")
        modifiedInfoTable = teachingNews.infoTable;
        searchBar.delegate = self
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        guard let webViewController = segue.destination as? WebViewController else {
            fatalError("Unexpected destination: \(segue.destination)")
        }
        guard let seletedCell = sender as? TeachingNewsTableViewCell else {
            fatalError("Unexpected sender: \(sender ?? "Unknown sender")")
        }
        guard let index = tableView.indexPath(for: seletedCell) else {
            fatalError("Cell \(seletedCell) is not in the table")
        }
        let addr = modifiedInfoTable[index.row].url
        webViewController.addr = addr
        print(addr)
    }
    
    func reloadInfoTable(query: String) {
        if (query.isEmpty) {
            modifiedInfoTable = teachingNews.infoTable
        } else {
            modifiedInfoTable = [InfoRow]()
            for item in teachingNews.infoTable {
                if item.title.contains(query) {
                    modifiedInfoTable.append(item)
                }
            }
        }
    }
}

extension TeachingNewsViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return modifiedInfoTable.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TeachingNewsCell") as! TeachingNewsTableViewCell
        let row = modifiedInfoTable[indexPath.row]
        cell.titleLabel.text = row.title
        cell.dateLabel.text = row.date
        return cell
    }
}

extension TeachingNewsViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        reloadInfoTable(query: searchText)
        tableView.reloadData()
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        tableView.reloadData()
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}
