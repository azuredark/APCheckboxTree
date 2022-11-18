//
//  APCheckboxList.swift
//  APCheckboxList
//
//  Created by mac on 09.11.2021.
//

import UIKit

open class APCheckboxList: UIView {

    // MARK: - Public properties

    /// Checkbox items
    public var items: [APCheckboxItem] = [] {
        didSet {
            reload()
        }
    }

    /// Customizable style of list
    public var style = APCheckboxListStyle()

    /// Checkbox list delegate
    public weak var delegate: APCheckboxListDelegate?

    // MARK: - Private properties

    let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        return stackView
    }()

    var nodes: [CheckboxNode] = []

    // MARK: - Init

    public override init(frame: CGRect) {
        super.init(frame: frame)

        setupView()
    }

    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Public methods

    /// Reload checkbox list
    public func reload() {
        stackView.arrangedSubviews.forEach{
            $0.removeFromSuperview()
        }

        nodes.removeAll()

        buildCheckboxList()
    }

    // MARK: - Private methods

    func setupView() {
        stackView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(stackView)

        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }

    func buildCheckboxList() {
        for item in items {
            let node = CheckboxNode(item: item,
                                    depth: 0,
                                    parentNode: nil,
                                    style: style,
                                    delegate: self)
            nodes.append(node)

            node.forEachBranchNode { childNode in
                stackView.addArrangedSubview(childNode.itemView)

                childNode.updateItemViewVisibility()
            }
        }
    }
}

extension APCheckboxList: CheckboxItemDelegate {
    func checkboxItemDidSelected(item: APCheckboxItem) {
        delegate?.checkboxListItemDidSelected(item: item)
    }
}