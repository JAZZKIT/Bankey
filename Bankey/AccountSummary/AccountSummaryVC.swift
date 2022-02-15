//
//  AccountSummaryVC.swift
//  Bankey
//
//  Created by Denny on 01.02.2022.
//

import UIKit

class AccountSummaryVC: UIViewController {

    // Request Models
    var profile: Profile?
    var accounts: [Account] = []

    // View Models
    var headUserInfo =  User(welcomeMessage: "Welcom", name: "", date: Date())
    var accountsCellInfo: [AccountInfo] = []

    // Componets
    let headerView = AccountSummaryHeaderView(frame: .zero)
    var tableView = UITableView()
    let refreshControll = UIRefreshControl()

    var isLoaded = false

    lazy var logoutBarButtonItem: UIBarButtonItem = {
        let barButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(logoutTapped))
        barButtonItem.tintColor = .label
        return barButtonItem
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
}

extension AccountSummaryVC {

    private func setup() {
        setupNavigationBar()
        setupTableView()
        setupTableHeaderView()
        setupRefreshContol()
        setupSkeletons()
        fetchData()
    }

    private func setupTableView() {
        tableView.backgroundColor = appColor
        tableView.delegate = self
        tableView.dataSource = self

        tableView.register(AccountSummaryCell.self, forCellReuseIdentifier: AccountSummaryCell.reuseID)
        tableView.register(SkeletonCell.self, forCellReuseIdentifier: SkeletonCell.reuseID)
        tableView.rowHeight = AccountSummaryCell.rowHeight
        tableView.tableFooterView = UIView()

        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }

    private func setupTableHeaderView() {
        var size = headerView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
        size.width = UIScreen.main.bounds.width
        headerView.frame.size = size

        tableView.tableHeaderView = headerView
    }

    private func setupNavigationBar() {
        navigationItem.rightBarButtonItem = logoutBarButtonItem
    }

    private func setupRefreshContol() {
        refreshControll.tintColor = appColor
        refreshControll.addTarget(self, action: #selector(refreshContent), for: .valueChanged)
        tableView.refreshControl = refreshControll
    }

    private func setupSkeletons() {
        let row = Account.makeSkeleton()
        accounts = Array(repeating: row, count: 10)
        configureTableCells(with: accounts)
    }
}

// MARK: - UITableViewDataSource

extension AccountSummaryVC: UITableViewDataSource {

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard !accountsCellInfo.isEmpty else { return UITableViewCell() }
        let account = accountsCellInfo[indexPath.row]

        if isLoaded {
            let cell = tableView.dequeueReusableCell(withIdentifier: AccountSummaryCell.reuseID, for: indexPath) as! AccountSummaryCell // swiftlint:disable:this force_cast
            cell.configure(with: account)
            return cell
        }

        let cell = tableView.dequeueReusableCell(withIdentifier: SkeletonCell.reuseID, for: indexPath) as! SkeletonCell 
        return cell
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return accountsCellInfo.count
    }
}

// MARK: - UITableViewDelegate

extension AccountSummaryVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

    }
}

// MARK: - Networking
extension AccountSummaryVC {
    private func fetchData() {
        let group = DispatchGroup()

        let userId = String(Int.random(in: 1..<4))

        group.enter()
        fetchProfile(forUserId: userId) { result in
            switch result {
            case .success(let profile):
                self.profile = profile

            case .failure(let error):
                print(error.localizedDescription)
            }
            group.leave()
        }

        group.enter()
        fetchAccounts(forUserId: userId) { result in
            switch result {
            case .success(let accounts):
                self.accounts = accounts

            case .failure(let error):
                print(error.localizedDescription)
            }
            group.leave()
        }

        group.notify(queue: .main) {
            self.tableView.refreshControl?.endRefreshing()

            guard let profile = self.profile else { return }

            self.isLoaded = true
            self.configureTableHeaderView(with: profile)
            self.configureTableCells(with: self.accounts)
            self.tableView.reloadData()
        }
    }

    private func configureTableHeaderView(with profile: Profile) {
        let vm = User(welcomeMessage: "Good morning,", name: profile.firstName, date: Date())
        headerView.configure(user: vm)
    }

    private func configureTableCells(with accounts: [Account]) {
        accountsCellInfo = accounts.map {
            AccountInfo(accountType: $0.type, accountName: $0.name, balance: $0.amount)
        }
    }
}

// MARK: - Actions
extension AccountSummaryVC {
    @objc func logoutTapped(sender: UIButton) {
        NotificationCenter.default.post(name: .Logout, object: nil)
    }

    @objc func refreshContent() {
        reset()
        setupSkeletons()
        tableView.reloadData()
        fetchData()
    }

    private func reset() {
        profile = nil
        accounts = []
        isLoaded = false
    }
}
