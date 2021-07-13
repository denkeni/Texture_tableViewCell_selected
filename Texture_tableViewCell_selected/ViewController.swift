//
//  ViewController.swift
//  Texture_tableViewCell_selected
//
//  Created by Denken Chen on 2021/7/6.
//

import UIKit
import AsyncDisplayKit

final class ViewController: UIViewController {

    private let tableView = UITableView(frame: CGRect.zero, style: .plain)
    private let separatorLabel = UILabel()
    private let tableNode = ASTableNode(style: .plain)

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "👇🏻UITableView"
        if #available(iOS 13.0, *) {
            separatorLabel.backgroundColor = .systemGroupedBackground
        } else {
            separatorLabel.backgroundColor = UIColor(red: 0.95, green: 0.95, blue: 0.96, alpha: 1.00)   // #F1F1F6
        }
        separatorLabel.text = "👇🏻ASTableNode"
        separatorLabel.textAlignment = .center

        view.addSubview(tableView)
        view.addSubview(separatorLabel)
        view.addSubview(tableNode.view)

        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "UITableViewCell")

        tableNode.dataSource = self
        tableNode.delegate = self
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()

        tableView.frame = CGRect(x: 0, y: 0,
                                 width: self.view.frame.width,
                                 height: self.view.frame.height / 2 - 20)
        separatorLabel.frame = CGRect(x: 0, y: self.view.frame.height / 2 - 20,
                                      width: self.view.frame.width,
                                      height: 40)
        tableNode.view.frame = CGRect(x: 0, y: self.view.frame.height / 2 + 20,
                                      width: self.view.frame.width,
                                      height: self.view.frame.height / 2 - 20)
    }
}

// MARK: - UITableViewDataSource

extension ViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UITableViewCell", for: indexPath)
        return cell
    }
}

// MARK: - UITableViewDelegate

extension ViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 1:
            cell.backgroundColor = .systemTeal
            cell.textLabel?.text = "1: Selected"
            cell.isSelected = true
        default:
            cell.backgroundColor = .systemTeal
            cell.textLabel?.text = "0"
            cell.isSelected = false
        }
    }
}

// MARK: - ASTableDataSource

extension ViewController: ASTableDataSource {

    func tableNode(_ tableNode: ASTableNode, numberOfRowsInSection section: Int) -> Int {
        return 3
    }

    func tableNode(_ tableNode: ASTableNode, nodeBlockForRowAt indexPath: IndexPath) -> ASCellNodeBlock {
        let nodeBlock: ASCellNodeBlock = {
            let cellNode = CellNode()
            cellNode.backgroundColor = .systemTeal  // will also be used to set _ASTableViewCell.backgroundColor
            return cellNode
        }
        return nodeBlock
    }
}

// MARK: - ASTableDelegate

extension ViewController: ASTableDelegate {

    func tableNode(_ tableNode: ASTableNode, willDisplayRowWith node: ASCellNode) {
        guard let cellNode = node as? CellNode, let indexPath = cellNode.indexPath else { return }
        var attributes = [NSAttributedString.Key : Any]()
        attributes[.font] = UIFont.preferredFont(forTextStyle: .body)
        if #available(iOS 13.0, *) {
            attributes[.foregroundColor] = UIColor.label
        }
        switch indexPath.row {
        case 1:
            cellNode.textNode.attributedText = NSAttributedString(string: "1: Selected",
                                                              attributes: attributes)
            cellNode.isSelected = true
        default:
            cellNode.textNode.attributedText = NSAttributedString(string: "0",
                                                              attributes: attributes)
            cellNode.isSelected = false
        }
    }
}

// MARK: - ASCellNode

private class CellNode: ASCellNode {

    let textNode = ASTextNode()
    
    override init() {
        super.init()

        automaticallyManagesSubnodes = true
    }

    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        return ASInsetLayoutSpec(insets: UIEdgeInsets(top: 12, left: 16, bottom: 12, right: 16),
                                 child: textNode)
    }
}
