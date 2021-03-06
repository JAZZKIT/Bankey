//
//  AccountSummaryHeaderView.swift
//  Bankey
//
//  Created by Denny on 01.02.2022.
//

import UIKit

class AccountSummaryHeaderView: UIView {

    @IBOutlet var contentView: UIView!

    @IBOutlet weak var welcomeLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!

    let shakeBellView = ShakeyBellView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    // The default size a view wants to give itself
    override var intrinsicContentSize: CGSize {
        return CGSize(width: UIView.noIntrinsicMetric, height: 144)
    }

    private func commonInit() {
        let bundle = Bundle(for: AccountSummaryHeaderView.self)
        bundle.loadNibNamed("AccountSummaryHeaderView", owner: self, options: nil)
        addSubview(contentView)
        contentView.backgroundColor = appColor

        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        contentView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        contentView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        contentView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true

        setupShakeyBell()
    }

    private func setupShakeyBell() {
        shakeBellView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(shakeBellView)

        NSLayoutConstraint.activate([
            shakeBellView.trailingAnchor.constraint(equalTo: trailingAnchor),
            shakeBellView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }

    func configure(user: User) {
        welcomeLabel.text = user.welcomeMessage
        nameLabel.text = user.name
        dateLabel.text = user.dateFormatted
    }
}
