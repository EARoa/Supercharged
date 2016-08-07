//
//  SuperchargerAnnotationView.swift
//  Supercharged
//
//  Created by Efrain Ayllon on 8/7/16.
//  Copyright © 2016 Efrain Ayllon. All rights reserved.
//

import UIKit
import MapKit


class SuperchargerAnnotationView: MKAnnotationView {

    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        setupAnnotationView()
    }
    
    private func setupAnnotationView() {
        
        self.frame.size = CGSize(width: 60, height: 60)
        self.centerOffset = CGPoint(x: -15, y: -15)
        
        let imageView = UIImageView(image: UIImage(named: "pinpoint"))
        imageView.frame = self.frame
        self.addSubview(imageView)
        
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
