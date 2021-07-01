//
//  DestinationHeaderContainer.swift
//  SocialFood
//
//  Created by Thịnh Nguyễn on 27/06/2021.
//

import SwiftUI
import Kingfisher
import SDWebImageSwiftUI

struct DestinationHeaderContainer: UIViewControllerRepresentable {
    let imageUrlStrings: [String]
    
    func makeUIViewController(context: Context) -> UIViewController {
        let pvc = CustomPageViewController(imageUrlStrings: imageUrlStrings)
        return pvc
    }
    
    typealias UIViewControllerType = UIViewController
    
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {}
}




class CustomPageViewController: UIPageViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {

    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        allControllers.count
    }
    
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        0
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let index = allControllers.firstIndex(of: viewController) else {return nil}
        
        if index == 0 {return nil}
        
        return allControllers[index - 1]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let index = allControllers.firstIndex(of: viewController) else {return nil}
        
        if index == allControllers.count - 1 {return nil}
        
        return allControllers[index + 1]
    }
    
    var allControllers: [UIViewController] = []
    
    init(imageUrlStrings: [String]) {
        UIPageControl.appearance().pageIndicatorTintColor = UIColor.systemGray5
        UIPageControl.appearance().currentPageIndicatorTintColor = .red
        
        super.init(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        
        // pages that we swipe through
        allControllers = imageUrlStrings.map({ imageName in
            let hostingController = UIHostingController(rootView:
//                                                                WebImage(url: URL(string: imageName))
//                                                                    .resizable()
//                                                                    .indicator(.activity) // Activity Indicator
//                                                                        .transition(.fade(duration: 0.5)) // Fade Transition with duration
//                                                                    .scaledToFit()
                                                            KFImage(URL(string: imageName))
                                                                .resizable()
                                                                .scaledToFit()
                                                        
            )
            hostingController.view.clipsToBounds = true
            return hostingController
        })
        
        if let first = allControllers.first {
            
            setViewControllers([first], direction: .forward, animated: true, completion: nil)
            
        }
        
        self.dataSource = self
        self.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

