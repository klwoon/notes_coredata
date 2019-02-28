//
//  ColorViewController.swift
//  Notes
//
//  Created by Woon on 28/02/2019.
//  Copyright © 2019 Woon. All rights reserved.
//

import UIKit

protocol ColorViewControllerDelegate {
    func controller(_ controller: ColorViewController, didPick color: UIColor)
}

class ColorViewController: UIViewController {
    
    @IBOutlet var colorView: UIView!
    @IBOutlet var redSlider: UISlider!
    @IBOutlet var blueSlider: UISlider!
    @IBOutlet var greenSlider: UISlider!
    
    var delegate: ColorViewControllerDelegate?
    
    var color: UIColor = .white
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Choose Color"
        setupView()
    }
    
    private func setupView() {
        setupSliders()
        setupColorView()
    }
    
    private func setupSliders() {
        var r: CGFloat = 0.0
        var g: CGFloat = 0.0
        var b: CGFloat = 0.0
        var a: CGFloat = 0.0
        
        color.getRed(&r, green: &g, blue: &b, alpha: &a)
        
        redSlider.value = Float(r)
        blueSlider.value = Float(b)
        greenSlider.value = Float(g)
    }
    
    private func setupColorView() {
        updateColorView()
    }
    
    private func updateColorView() {
        let color = UIColor(red: CGFloat(redSlider.value), green: CGFloat(greenSlider.value), blue: CGFloat(blueSlider.value), alpha: 1.0)
        colorView.backgroundColor = color
    }
    
    @IBAction func colorDidChange(sender: UISlider) {
        updateColorView()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        delegate?.controller(self, didPick: (colorView.backgroundColor ?? .white))
    }
}
