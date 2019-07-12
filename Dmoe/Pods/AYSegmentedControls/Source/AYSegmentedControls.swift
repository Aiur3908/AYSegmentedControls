//
//  AYSegmentedControls.swift
//  AYSegmentedControls
//
//  Created by User on 2019/7/11.
//  Copyright © 2019 JerryYou. All rights reserved.
//

import UIKit

public protocol AYSegmentedControlsDataSource: class {
    func numberOfItem(in segmentedControls: AYSegmentedControls) -> Int
    func segmentedControls(_ segmentedControls: AYSegmentedControls,
                          titleForItemAt index: Int) -> String
}

public protocol AYSegmentedControlsDelegate: class {
    func segmentedControls(_ segmentedControls: AYSegmentedControls,
                             didSelectItemAt index: Int)
}

extension AYSegmentedControlsDelegate {
    func segmentedControls(_ segmentedControls: AYSegmentedControls,
                           didSelectItemAt index: Int) {
        
    }
}

@IBDesignable
open class AYSegmentedControls: UIControl {
    
    //MARK: - Public variable

    @IBInspectable open var hintColor: UIColor = .red {
        didSet {
            updateHintViewLayout()
        }
    }
    
    @IBInspectable open var borderWidth: CGFloat = 1 {
        didSet {
            updateLayerLayout()
        }
    }
    
    @IBInspectable open var bordrColor: UIColor = .red {
        didSet {
            updateLayerLayout()
        }
    }
    
    @IBInspectable open var padding: CGFloat = 5 {
        didSet {
            updateContentViewLayout()
        }
    }
    
    @IBInspectable open var normalTitleColor: UIColor = .red {
        didSet {
            updateItemTitleColor()
        }
    }
    
    @IBInspectable open var selectedTitleColor: UIColor = .white {
        didSet {
            updateItemTitleColor()
        }
    }
    
    open var titleFont: UIFont = UIFont.systemFont(ofSize: 18) {
        didSet {
            titleButtons.forEach({ $0.titleLabel?.font = titleFont })
        }
    }
    
    open var selectedIndex: Int = 0

    weak open var dataSource: AYSegmentedControlsDataSource?
    weak open var delegate: AYSegmentedControlsDelegate?
    
    //MARK: - Private variable
    
    private var currentPanGesturePoint: CGPoint!
    private var contentViewLeftConstraint: NSLayoutConstraint!
    private var contentViewTopConstraint: NSLayoutConstraint!
    private var contentViewRightConstraint: NSLayoutConstraint!
    private var contentViewBottomConstraint: NSLayoutConstraint!
    private var hintViewLeftConstrinat: NSLayoutConstraint!
    private var titleButtons: [UIButton] = []
    
    //MARK: - View variable
    
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
    
    //MARK: - Init

    override public init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    //MARK: - View life cycle
    
    override open func layoutSubviews() {
        super.layoutSubviews()
        updateLayout()
    }
    
    //MARK: - Setup
    
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
    
    //MARK: - UpdateLayout
    
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
        guard dataSource.numberOfItem(in: self) >= 2 else {
            print("NumberOfSegments must be greater than or equal to 2.")
            
            return
        }
        
        itemStackView.arrangedSubviews.forEach({ $0.removeFromSuperview() })
        titleButtons = []
        let titleIndices = Array(0...dataSource.numberOfItem(in: self) - 1)
        for titleIndex in titleIndices {
            let titleButton = UIButton(frame: .zero)
            titleButton.titleLabel?.font = titleFont
            titleButton.tintColor = .clear
            titleButton.setTitle(dataSource.segmentedControls(self, titleForItemAt: titleIndex),
                                 for: .normal)
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
    
    private func updateHintViewLayout() {
        hintView.backgroundColor = hintColor
        if let itemCount = dataSource?.numberOfItem(in: self) {
            itemStackView.setNeedsLayout()
            itemStackView.layoutIfNeeded()
            hintView.setNeedsLayout()
            hintView.layoutIfNeeded()
            hintView.widthAnchor.constraint(equalTo: contentView.widthAnchor,
                                            multiplier: CGFloat(1.0 / Double(itemCount))).isActive = true
            hintView.layer.cornerRadius = hintView.frame.size.height / 2
            let itemWidth = itemStackView.frame.size.width / CGFloat(itemCount)
            hintViewLeftConstrinat.constant = CGFloat(selectedIndex) * itemWidth
        }
    }

    //MARK: - Action
    
    @objc private func titleButtonTapped(_ button: UIButton) {
        self.selectIndex(at: button.tag, animated: true)
        self.updateItemTitleColor()
    }
    
    //MARK: - Gesture
    
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
            
            if (selectedIndex + 1) > dataSource?.numberOfItem(in: self) ?? 0 {
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
    
    //MARK: - Color
    
    private func avgColor(lhs: UIColor, rhs: UIColor, percentage: Double) -> UIColor {
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

//MARK: - Public method

extension AYSegmentedControls {
    open func selectIndex(at: Int, animated: Bool) {
        if let itemCount = dataSource?.numberOfItem(in: self) {
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
                    self.delegate?.segmentedControls(self, didSelectItemAt: self.selectedIndex)
                })
            } else {
                delegate?.segmentedControls(self, didSelectItemAt: selectedIndex)
            }
        }
    }
}
