//
//  ViewController.swift
//  MaticTest
//
//  Created by Apple on 8/25/20.
//  Copyright © 2020 Sulyman. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var networkManager = NetworkManager()
    var dateFormatter = DateFormatter()
    var repos: [Repo] = []
    var page = 0
    var spinner = UIActivityIndicatorView(style: .large)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.allowsSelection = false
        getRepos(self.page)
    }
    
    private func getRepos(_ page: Int){
        
        dateFormatter.dateFormat = "yyyy-MM-dd"
        spinner.color = .black
        spinner.translatesAutoresizingMaskIntoConstraints = false
        spinner.startAnimating()
        view.addSubview(spinner)
        spinner.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        spinner.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        let now = Date()
        let dateToUse = now.addingTimeInterval(-30 * 24 * 60 * 60)
        let dateString = dateFormatter.string(from: dateToUse)
        
        print(dateString)
        
        self.networkManager.getProducts(page: page, q: "created:>" + dateString, sort: "stars", order: "stars") { (data, error) in
            guard error == nil else{
                DispatchQueue.main.async {
                    self.spinner.removeFromSuperview()
                }
                return
            }
            guard data != nil else{
                DispatchQueue.main.async {
                    self.spinner.removeFromSuperview()
                }
                return
            }
            self.repos.append(contentsOf: data!)
            DispatchQueue.main.async {
                self.spinner.removeFromSuperview()
                self.tableView.reloadData()
            }
        }
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.repos.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuse", for: indexPath) as! RepoTableViewCell
        let repo = self.repos[indexPath.row]
        cell.setupCell(repo)
        return cell
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row >= self.repos.count - 1{
            self.page+=1
            self.getRepos(self.page)
        }
    }
}

