//
//  RatingPickerView.swift
//  HW4-ShoppingList
//
//  Created by 张福翔 on 2020/11/9.
//

import UIKit

@IBDesignable class RatingPickerView: UIStackView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    // MARK: properties
    private var ratingButtons = [UIButton]()
    var rating = 0 {
        didSet {
            updateButtonSelectionStates()
        }
    }
    @IBInspectable var starSize = CGSize(width: 30, height: 30) {
        didSet {
            setupButtons()
        }
    }
    @IBInspectable var starCount = 5 {
        didSet {
            setupButtons()
        }
    }
    
    // MARK: initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupButtons()
    }
    required init(coder: NSCoder) {
        super.init(coder: coder)
        setupButtons()
    }
    
    // MARK: private methods
    private func setupButtons() {
        for button in ratingButtons {
            removeArrangedSubview(button)
            button.removeFromSuperview()
        }
        ratingButtons.removeAll()
        
        let bundle = Bundle(for: type(of: self))
        let filledStar = UIImage(named: "FilledStar", in: bundle, compatibleWith: self.traitCollection)
        let emptyStar = UIImage(named: "EmptyStar", in: bundle, compatibleWith: self.traitCollection)
        let highlightedStar = UIImage(named: "HighlightedStar", in: bundle, compatibleWith: self.traitCollection)
        
        for index in 0..<starCount {
            let button = UIButton()
            
            button.setImage(emptyStar, for: .normal)
            button.setImage(filledStar, for: .selected)
            button.setImage(highlightedStar, for: .highlighted)
            button.setImage(highlightedStar, for: [.highlighted, .selected])
            
            button.accessibilityLabel = "Set \(index + 1) star rating"
            
            button.translatesAutoresizingMaskIntoConstraints = false
            button.heightAnchor.constraint(equalToConstant: starSize.height).isActive = true
            button.widthAnchor.constraint(equalToConstant: starSize.width).isActive = true
            button.addTarget(self, action: #selector(RatingPickerView.ratingButtonTapped(button:)), for: .touchUpInside)
            addArrangedSubview(button)
            
            ratingButtons.append(button)
        }
        updateButtonSelectionStates()
    }
    private func updateButtonSelectionStates() {
        for (index, button) in ratingButtons.enumerated() {
            button.isSelected = index < rating
            
            let hintString: String?
            if rating == index + 1 {
                hintString = "Tap to reset the rating to 0"
            } else {
                hintString = nil
            }
            let valueString: String
            switch rating {
            case 0:
                valueString = "No rating set"
            case 1:
                valueString = "1 star set"
            default:
                valueString = "\(rating) stars set"
            }
            button.accessibilityHint = hintString
            button.accessibilityValue = valueString
        }
    }
    
    // MARK: button actions
    @objc func ratingButtonTapped(button: UIButton) {
        let index = ratingButtons.firstIndex(of: button)!
        let selectedRating = index + 1
        if selectedRating == rating {
            rating = 0
        } else {
            rating = selectedRating
        }
    }
}
