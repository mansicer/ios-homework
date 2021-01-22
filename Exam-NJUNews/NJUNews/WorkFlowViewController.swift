//
//  BusinessProcessViewController.swift
//  NJUNews
//
//  Created by CuiZihan on 2020/12/23.
//

import UIKit

class WorkFlowViewController: UIViewController {
    var workFlow = WorkFlow()
    var modifiedInfoTable = [InfoRow]()
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        workFlow.loadAndParseHTML(url: "https://jw.nju.edu.cn/24739/list.htm")
        modifiedInfoTable = workFlow.infoTable;
        searchBar.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        guard let webViewController = segue.destination as? WebViewController else {
            fatalError("Unexpected destination: \(segue.destination)")
        }
        guard let seletedCell = sender as? WorkFlowTableViewCell else {
            fatalError("Unexpected sender: \(sender ?? "Unknown sender")")
        }
        guard let index = tableView.indexPath(for: seletedCell) else {
            fatalError("Cell \(seletedCell) is not in the table")
        }
        let addr = modifiedInfoTable[index.row].url
        webViewController.addr = addr
    }
    
    func reloadInfoTable(query: String) {
        if (query.isEmpty) {
            modifiedInfoTable = workFlow.infoTable
        } else {
            modifiedInfoTable = [InfoRow]()
            for item in workFlow.infoTable {
                if item.title.contains(query) {
                    modifiedInfoTable.append(item)
                }
            }
        }
    }
}

extension WorkFlowViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return modifiedInfoTable.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "WorkFlowCell") as! WorkFlowTableViewCell
        let row = modifiedInfoTable[indexPath.row]
        cell.titleLabel.text = row.title
        cell.dateLabel.text = row.date
        return cell
    }
}

extension WorkFlowViewController: UISearchBarDelegate {
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
