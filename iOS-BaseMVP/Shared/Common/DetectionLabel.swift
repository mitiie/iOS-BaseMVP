//
//  Untitled.swift
//  iOS-BaseMVP
//
//  Created by mitie on 3/4/26.
//

import UIKit

typealias OnTappedWordsCompletion = (_ indexHighlight: Int) -> Void

class DetectionLabel: UILabel {
    
    var onTapped: OnTappedWordsCompletion?
    var tapGesture: UITapGestureRecognizer?
    
    var textHighlights: [String] = []
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    func setup() {
        self.isUserInteractionEnabled = true
        self.numberOfLines = 0
    }
    
    func updateContent(_ attributedText: String,
                       _ attributeds: [NSAttributedString.Key: Any]?,
                       _ textHighLights: [String],
                       _ attributedsHighlight: [NSAttributedString.Key: Any]?,
                       _ detectWords: Bool,
                       _ onTapped: @escaping OnTappedWordsCompletion) {
        self.onTapped = onTapped
        self.textHighlights.removeAll()
        self.textHighlights.append(contentsOf: textHighLights)
        
        let attributtedStr = NSMutableAttributedString(string: attributedText)
        if let attributeds = attributeds {
            attributtedStr.addAttributes(attributeds, range: NSRange(location: 0, length: attributedText.count))
        }
        
        for textHighlight in textHighlights {
            if let range = attributedText.range(of: textHighlight) {
                let nsRange = NSRange(range, in: attributedText)
                if let attributedsHighlight = attributedsHighlight {
                    attributtedStr.addAttributes(attributedsHighlight, range: nsRange)
                }
            }
        }
        
        self.attributedText = attributtedStr
        
        if detectWords {
            if tapGesture == nil {
                self.tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.didTap(_:)))
                self.addGestureRecognizer(tapGesture!)
            }
        }
    }
    
    func updateMoreAttributed(_ highlights: [String],
                              _ attributedsHighlight: [NSAttributedString.Key: Any]?) {
        guard let attributed = self.attributedText else { return }
        guard let content = self.text else { return }
        
        let attributtedStr = NSMutableAttributedString(attributedString: attributed)

        for highlight in highlights {
            if let range = content.range(of: highlight) {
                let nsRange = NSRange(range, in: highlight)
                if let attributedsHighlight = attributedsHighlight {
                    attributtedStr.addAttributes(attributedsHighlight, range: nsRange)
                }
            }
        }
        self.attributedText = attributtedStr
        self.textHighlights.append(contentsOf: highlights)
    }
    
    @objc func didTap(_ sender: UITapGestureRecognizer) {
        let textStorage = NSTextStorage(attributedString: self.attributedText!)
        
        // The storage class owns a layout manager
        let layoutManager = NSLayoutManager.init()
        textStorage.addLayoutManager(layoutManager)
        
        // Layout manager owns a container which basically
        // defines the bounds the text should be contained in
        let textContainer = NSTextContainer(size: self.frame.size)
        
        // For labels the fragment padding should be 0
        textContainer.lineFragmentPadding = 0
        textContainer.lineBreakMode = self.lineBreakMode
        textContainer.maximumNumberOfLines = self.numberOfLines
        
        layoutManager.addTextContainer(textContainer)
        
        // Begin computation of actual frame
        // Glyph is the final display representation
        // Eg: Ligatures have 2 characters but only 1 glyph.
        var glyphRange: NSRange = NSRange(location: 0, length: 10)
        
        // Extract the glyph range
        let touchPoint = sender.location(ofTouch: 0, in: self)
        
        for index in 0..<self.textHighlights.count {
            let clickHere = self.textHighlights[index]
            if let range = self.text!.range(of: clickHere) {
                layoutManager.characterRange(forGlyphRange: NSRange(range, in: self.text!), actualGlyphRange: &glyphRange)
            }
            let glyphRect = layoutManager.boundingRect(forGlyphRange: glyphRange, in: textContainer)
            
            if glyphRect.contains(touchPoint) {
                if let onTapped = self.onTapped {
                    onTapped(index)
                }
                break
            }
        }
        
    }
    
}
