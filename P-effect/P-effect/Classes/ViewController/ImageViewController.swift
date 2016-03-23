//
//  ImageViewController.swift
//  P-effect
//
//  Created by Illya on 1/26/16.
//  Copyright © 2016 Yalantis. All rights reserved.
//

import UIKit

class ImageViewController: UIViewController {
    
    var model: ImageViewModel!
    
    private weak var locator: ServiceLocator!
    private var effects = [EffectEditorView]()
    
    @IBOutlet private weak var rawImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        rawImageView.image = model.originalImage()
    }
    
    func setLocator(locator: ServiceLocator) {
        self.locator = locator
    }
    
}

extension ImageViewController: PhotoEditorDelegate {
    
    func photoEditor(photoEditor: PhotoEditorViewController, didChooseEffect: UIImage) {
        let userResizableView = EffectEditorView(image: didChooseEffect)
        userResizableView.center = rawImageView.center
        rawImageView.addSubview(userResizableView)
        effects.append(userResizableView)
    }
    
    func imageForPhotoEditor(photoEditor: PhotoEditorViewController, withEffects: Bool) -> UIImage {
        guard withEffects else {
            return rawImageView.image!
        }
        
        for effect in effects {
            effect.switchControls(toState: false)
        }
        let rect = rawImageView.bounds
        UIGraphicsBeginImageContextWithOptions(rect.size, view.opaque, 0.0)
        rawImageView.drawViewHierarchyInRect(rect, afterScreenUpdates: true)

        let image = UIGraphicsGetImageFromCurrentImageContext()
        for effect in effects {
            effect.switchControls(toState: true)
        }
        
        return image
    }
    
    func removeAllEffects(photoEditor: PhotoEditorViewController) {
        for effect in effects {
            effect.removeFromSuperview()
        }
    }
    
}