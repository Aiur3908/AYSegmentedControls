//
//  AYSegmentedControls.swift
//  AYSegmentedControls
//
//  Created by User on 2019/7/11.
//  Copyright © 2019 JerryYou. All rights reserved.
//

import UIKit

protocol AYSegmentedControlsDataSource: class {
    func numberOfSegments() -> Int
    func titleForSegmentIndex(index: Int) -> String
}

protocol AYSegmentedControlsDelegate: class {
    func aySegmentedControls(_ aySegmentedControls: AYSegmentedControls,
                             didSelectItemAt index: Int)
}

extension AYSegmentedControlsDelegate {
    func aySegmentedControls(_ aySegmentedControls: AYSegmentedControls,
                             didSelectItemAt index: Int) {
    }
}

@IBDesignable
class AYSegmentedControls: UIControl {
    
    weak var dataSource: AYSegmentedControlsDataSource?
    weak var delegate: AYSegmentedControlsDelegate?
    @IBInspectable var hintColor: UIColor = .red
    @IBInspectable var titleFont: UIFont = UIFont.systemFont(ofSize: 18)
    @IBInspectable var normalTitleColor: UIColor = .red
    @IBInspectable var selectedTitleColor: UIColor = .white
    @IBInspectable var borderWidth: CGFloat = 1
    @IBInspectable var bordrColor: UIColor = .red
    @IBInspectable var padding: CGFloat = 5
    @IBInspectable var selectedIndex: Int = 0
    
    private var currentPanGesturePoint: CGPoint!
    private var contentViewLeftConstraint: NSLayoutConstraint!
    private var contentViewTopConstraint: NSLayoutConstraint!
    private var contentViewRightConstraint: NSLayoutConstraint!
    private var contentViewBottomConstraint: NSLayoutConstraint!
    private var hintViewLeftConstrinat: NSLayoutConstraint!
    private var titleButtons: [UIButton]!
    
    private lazy var contentView: UIView! = {
        let contentView = UIView(frame: .zero)
        contentView.clipsToBounds = true
        addSubview(contentView)
        return contentView
    }()
    
    private lazy var itemStackView: UIStackView = {
        let itemStackView = UIStackView(frame: .zero)
        itemStackView.axis = .horizontal
        itemStackView.distribution = .fillEqually
        contentView.addSubview(itemStackView)
        return itemStackView
    }()
    
    private lazy var hintView: UIView = {
        let hintView = UIView(frame: .zero)
        hintView.backgroundColor = hintColor
        contentView.addSubview(hintView)
        return hintView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        updateLayout()
    }
    
    private func setup() {
        setupContentView()
        setupHintView()
        setupItemStackView()
        setupPanGestureRecognizer()
    }
    
    private func setupContentView() {
        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentViewTopConstraint = contentView.topAnchor.constraint(equalTo: topAnchor)
        contentViewTopConstraint.isActive = true
        contentViewLeftConstraint = contentView.leftAnchor.constraint(equalTo: leftAnchor)
        contentViewLeftConstraint.isActive = true
        contentViewRightConstraint = contentView.rightAnchor.constraint(equalTo: rightAnchor)
        contentViewRightConstraint.isActive = true
        contentViewBottomConstraint = contentView.bottomAnchor.constraint(equalTo: bottomAnchor)
        contentViewBottomConstraint.isActive = true
    }
    
    private func setupItemStackView() {
        itemStackView.translatesAutoresizingMaskIntoConstraints = false
        itemStackView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        itemStackView.leftAnchor.constraint(equalTo: contentView.leftAnchor).isActive = true
        itemStackView.rightAnchor.constraint(equalTo: contentView.rightAnchor).isActive = true
        itemStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
    }
    
    private func setupHintView() {
        hintView.translatesAutoresizingMaskIntoConstraints = false
        hintView.heightAnchor.constraint(equalTo: contentView.heightAnchor).isActive = true
        hintViewLeftConstrinat = hintView.leftAnchor.constraint(equalTo: contentView.leftAnchor)
        hintViewLeftConstrinat.isActive = true
        hintView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
    }
    
    private func setupPanGestureRecognizer() {
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(panGestureUpdated(_:)))
        panGestureRecognizer.minimumNumberOfTouches = 1
        contentView.addGestureRecognizer(panGestureRecognizer)
    }
    
    private func updateLayout() {
        updateLayerLayout()
        updateContentViewLayout()
        updateItemsLayout()
        updateHintViewLayout()
    }
    
    private func updateLayerLayout() {
        layer.borderWidth = borderWidth
        layer.borderColor = bordrColor.cgColor
        layer.cornerRadius = frame.height / 2
    }

    private func updateContentViewLayout() {
        contentViewTopConstraint.constant = padding
        contentViewLeftConstraint.constant = padding
        contentViewBottomConstraint.constant = -padding
        contentViewRightConstraint.constant = -padding
        contentView.layer.cornerRadius = contentView.frame.size.height / 2
    }
    
    private func updateItemsLayout() {
        ///必須實作DataSource
        guard let dataSource = dataSource else {
            print("You must implement the AYSegmentedControlsDatasource.")
            
            return 
        }

        ///numberOfSegments的數量必須>=2
        guard dataSource.numberOfSegments() >= 2 else {
            print("NumberOfSegments must be greater than or equal to 2.")
            
            return
        }
        
        itemStackView.arrangedSubviews.forEach({ $0.removeFromSuperview() })
        titleButtons = []
        let titleIndices = Array(0...dataSource.numberOfSegments() - 1)
        for titleIndex in titleIndices {
            let titleButton = UIButton(frame: .zero)
            titleButton.titleLabel?.font = titleFont
            titleButton.tintColor = .clear
            titleButton.setTitle(dataSource.titleForSegmentIndex(index: titleIndex), for: .normal)
            titleButton.tag = titleIndex
            titleButton.addTarget(self,
                                  action: #selector(titleButtonTapped(_:)),
                                  for: .touchUpInside)
            itemStackView.addArrangedSubview(titleButton)
            titleButtons.append(titleButton)
            updateItemTitleColor()
        }
    }
    
    private func updateItemTitleColor() {
        titleButtons.forEach({
            let titleColor = $0.tag == selectedIndex ? selectedTitleColor : normalTitleColor
            $0.setTitleColor(titleColor, for: .normal)
        })
    }
    
    @objc private func titleButtonTapped(_ button: UIButton) {
        self.selectIndex(at: button.tag, animated: true)
        self.updateItemTitleColor()
    }
    
    @objc private func panGestureUpdated(_ panGestureRecognizer: UIPanGestureRecognizer) {
        if panGestureRecognizer.state == .began {
            ///手勢辨識開始
            currentPanGesturePoint = panGestureRecognizer.location(in: self)
            return
        }
        
        if panGestureRecognizer.state == .changed {
            ///手勢更改
            let nextPanGesturePoint = panGestureRecognizer.location(in: self)
            let dx = nextPanGesturePoint.x - currentPanGesturePoint.x
            currentPanGesturePoint = nextPanGesturePoint
            var newHintViewLeftConstant = hintViewLeftConstrinat.constant + dx
            let minX: CGFloat = 0
            let maxX: CGFloat = contentView.frame.size.width - hintView.frame.size.width
            if newHintViewLeftConstant <= minX {
                newHintViewLeftConstant = minX
            }
            if newHintViewLeftConstant >= maxX {
                newHintViewLeftConstant = maxX
            }
            hintViewLeftConstrinat.constant = newHintViewLeftConstant
            
            let floorNextSelectIndex = Int(floor(Double(hintView.frame.origin.x / hintView.frame.size.width)))
            
            if selectedIndex != floorNextSelectIndex {
                selectedIndex = floorNextSelectIndex
            }
            var nextSelectIndex: Int!
            
            if (selectedIndex + 1) > dataSource?.numberOfSegments() ?? 0 {
                nextSelectIndex = selectedIndex - 1
            } else {
                nextSelectIndex = selectedIndex + 1
            }
            
            let currentTitleColorPercentage = fmod(Double(hintView.frame.origin.x / hintView.frame.size.width), 1.0)
            let nextTitleColorPercentage = 1 - currentTitleColorPercentage
            
            if let currentTitleButton = titleButtons.filter({ $0.tag == selectedIndex }).first {
                currentTitleButton.setTitleColor(avgColor(lhs: selectedTitleColor,
                                                          rhs: normalTitleColor,
                                                          percentage: currentTitleColorPercentage),
                                                 for: .normal)
            }
            
            if let nextTitleButton = titleButtons.filter({ $0.tag == nextSelectIndex }).first {
                nextTitleButton.setTitleColor(avgColor(lhs: selectedTitleColor,
                                                       rhs: normalTitleColor,
                                                       percentage: nextTitleColorPercentage),
                                              for: .normal)
            }

            return
        }
        
        if panGestureRecognizer.state == .ended ||
           panGestureRecognizer.state == .cancelled {
            selectIndex(at: lround(Double(hintView.frame.origin.x / hintView.frame.size.width)),
                        animated: true)
            return
        }
    }
    
    private func updateHintViewLayout() {
        if let itemCount = dataSource?.numberOfSegments() {
            itemStackView.setNeedsLayout()
            itemStackView.layoutIfNeeded()
            hintView.widthAnchor.constraint(equalTo: contentView.widthAnchor,
                                            multiplier: CGFloat(1.0 / Double(itemCount))).isActive = true
            hintView.layer.cornerRadius = hintView.frame.size.height / 2
            let itemWidth = itemStackView.frame.size.width / CGFloat(itemCount)
            hintViewLeftConstrinat.constant = CGFloat(selectedIndex) * itemWidth
        }
    }
}

extension AYSegmentedControls {
    func selectIndex(at: Int, animated: Bool) {
        if let itemCount = dataSource?.numberOfSegments() {
            if at >= itemCount {
                fatalError("fatal error: Index out of range")
            }
            selectedIndex = at
            updateHintViewLayout()
            updateItemTitleColor()
            if animated {
                UIView.animate(withDuration: 0.25, animations: {
                    self.layoutIfNeeded()
                }, completion: { _ in
                    self.delegate?.aySegmentedControls(self, didSelectItemAt: self.selectedIndex)
                })
            } else {
                delegate?.aySegmentedControls(self, didSelectItemAt: selectedIndex)
            }
        }
    }
}

extension AYSegmentedControls {
    func avgColor(lhs: UIColor, rhs: UIColor, percentage: Double) -> UIColor {
        var lhsRed: CGFloat = 0
        var rhsRed: CGFloat = 0
        var lhsGreen: CGFloat = 0
        var rhsGreen: CGFloat = 0
        var lhsBlue: CGFloat = 0
        var rhsBlue: CGFloat = 0
        var lhsAlpha: CGFloat = 0
        var rhsAlpha: CGFloat = 0
        lhs.getRed(&lhsRed, green: &lhsGreen, blue: &lhsBlue, alpha: &lhsAlpha)
        rhs.getRed(&rhsRed, green: &rhsGreen, blue: &rhsBlue, alpha: &rhsAlpha)
        let newRed   = lhsRed   + ((rhsRed - lhsRed) / 100.0 * CGFloat(percentage) * 100.0)
        let newGreen = lhsGreen + ((rhsGreen - lhsGreen) / 100.0 * CGFloat(percentage) * 100.0)
        let newBlue  = lhsBlue  + ((rhsBlue - lhsBlue) / 100.0 * CGFloat(percentage) * 100.0)
        return UIColor(displayP3Red: newRed, green: newGreen, blue: newBlue, alpha: 1)
    }
}

