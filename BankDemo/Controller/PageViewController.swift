import UIKit

class PageViewController: UIPageViewController, UIPageViewControllerDataSource {

    var pageList = [UIViewController]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pageList.append((storyboard?.instantiateViewController(withIdentifier: "PageVC1"))!)
        pageList.append((storyboard?.instantiateViewController(withIdentifier: "PageVC2"))!)
        setViewControllers([pageList[0]], direction: .forward, animated: true, completion: nil)
        dataSource = self
        
        let pageControll = UIPageControl.appearance()
        pageControll.pageIndicatorTintColor = UIColor.yellow
        pageControll.currentPageIndicatorTintColor = UIColor.red
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        for v in view.subviews {
            if v is UIScrollView {
                v.frame = view.bounds
                break
            }
        }
    }

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        if let index = pageList.firstIndex(of: viewController) {
            if index > 0 {
                return pageList[index - 1]
            }
        }
        return nil
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        if let index = pageList.firstIndex(of: viewController) {
            if index < pageList.count - 1 {
                return pageList[index + 1]
            }
        }
        return nil
    }
    
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return pageList.count
    }
    
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        return 0
    }
}
