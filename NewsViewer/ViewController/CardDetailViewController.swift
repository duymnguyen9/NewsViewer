import UIKit


class CardDetailViewController: UIViewController, UIScrollViewDelegate {
    
    // This constraint limits card content to not be covered by root view.
    // This is useful to make the card content expands when presenting,
    // as intially the card is fully contained in a smaller environment (card cell).
    // When animating detail view controller to be full-screen size, it should gradually expands along the bottom edge.
    //
    // ***But we dismiss disable this after presenting***
    
    
    
    
    @IBOutlet weak var cardBottomToRootBottomConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var getNews: UIButton!
    @IBOutlet weak var newsCardContentView: NewsCardContentView!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var summary: UILabel!
    @IBOutlet weak var author: UILabel!
    
    let transitionLayer: CALayer = CALayer()
    
    var cardViewModel: NewsCardContentViewModel! {
        didSet {
            if self.newsCardContentView != nil {
                self.newsCardContentView.viewModel = cardViewModel
            }
        }
    }
    
    var unhighlightedCardViewModel: NewsCardContentViewModel!
    
    var isFontStateHighlighted: Bool = true {
        didSet{
            newsCardContentView.setFontState(isHighlighted: isFontStateHighlighted)
        }
    }
    
    var draggingDownToDismiss = false
    
    final class DismissalPanGesture: UIPanGestureRecognizer {}
    final class DismissalScreenEdgePanGesture: UIScreenEdgePanGestureRecognizer {}
    
    private lazy var dismissalPanGesture: DismissalPanGesture = {
        let pan = DismissalPanGesture()
        pan.maximumNumberOfTouches = 1
        return pan
    }()
    
    private lazy var dismissalScreenEdgePanGesture: DismissalScreenEdgePanGesture = {
        let pan = DismissalScreenEdgePanGesture()
        pan.edges = .left
        return pan
    }()
    
    // MARK: - viewDidLoad()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if GlobalConstants.isEnabledDebugAnimatingViews {
            scrollView.layer.borderWidth = 3
            scrollView.layer.borderColor = UIColor.green.cgColor
            
            scrollView.subviews.first!.layer.borderWidth = 3
            scrollView.subviews.first!.layer.borderColor = UIColor.purple.cgColor
        }
        
        
        scrollView.delegate = self
        scrollView.contentInsetAdjustmentBehavior = .never
        newsCardContentView.viewModel = cardViewModel
        
        //        textView.text = cardViewModel.textContent
        setSummaryText()
        setTextViewText()
        author.text = cardViewModel.author
        
        getNews?.addTarget(self, action: #selector(navigateToNewsSite), for: .touchUpInside)
        
        dismissalPanGesture.addTarget(self, action: #selector(handleDismissalPan(gesture:)))
        dismissalPanGesture.delegate = self
        
        dismissalScreenEdgePanGesture.addTarget(self, action: #selector(handleDismissalPan(gesture:)))
        dismissalScreenEdgePanGesture.delegate = self
        
        // Make drag down/scroll pan gesture waits til screen edge pan to fail first to begin
        dismissalPanGesture.require(toFail: dismissalScreenEdgePanGesture)
        scrollView.panGestureRecognizer.require(toFail: dismissalScreenEdgePanGesture)
        
        loadViewIfNeeded()
        view.addGestureRecognizer(dismissalPanGesture)
        view.addGestureRecognizer(dismissalScreenEdgePanGesture)
        
    }
    
    
    
    func didSuccessfullyDragDownToDismiss() {
        cardViewModel = unhighlightedCardViewModel
        dismiss(animated: true)
    }
    
    func userWillCancelDimissalByDraggingToTop(velocityY: CGFloat) {}
    
    func didCancelDismissalTransition() {
        // Clean up
        interactiveStartingPoint = nil
        dismissalAnimator = nil
        draggingDownToDismiss = false
    }
    
    var interactiveStartingPoint: CGPoint?
    var dismissalAnimator: UIViewPropertyAnimator?
    
    
    // This handles both screen edge and dragdown pan. As screen edge pan is a subclass of pan gesture, this input param works.
    @objc func handleDismissalPan(gesture: UIPanGestureRecognizer) {
        
        let isScreenEdgePan = gesture.isKind(of: DismissalScreenEdgePanGesture.self)
        let canStartDragDownToDismissPan = !isScreenEdgePan && !draggingDownToDismiss
        
        // Don't do anything when it's not in the drag down mode
        if canStartDragDownToDismissPan { return }
        
        let targetAnimatedView = gesture.view!
        let startingPoint: CGPoint
        
        if let p = interactiveStartingPoint {
            startingPoint = p
        } else {
            // Initial location
            startingPoint = gesture.location(in: nil)
            interactiveStartingPoint = startingPoint
        }
        
        let currentLocation = gesture.location(in: nil)
        let progress = isScreenEdgePan ? (gesture.translation(in: targetAnimatedView).x / 100) : (currentLocation.y - startingPoint.y) / 100
        let targetShrinkScale: CGFloat = 0.86
        let targetCornerRadius: CGFloat = GlobalConstants.cardCornerRadius
        
        func createInteractiveDismissalAnimatorIfNeeded() -> UIViewPropertyAnimator {
            if let animator = dismissalAnimator {
                return animator
            } else {
                let animator = UIViewPropertyAnimator(duration: 0, curve: .linear, animations: {
                    targetAnimatedView.transform = .init(scaleX: targetShrinkScale, y: targetShrinkScale)
                    targetAnimatedView.layer.cornerRadius = targetCornerRadius
                })
                animator.isReversed = false
                animator.pauseAnimation()
                animator.fractionComplete = progress
                return animator
            }
        }
        
        switch gesture.state {
        case .began:
            dismissalAnimator = createInteractiveDismissalAnimatorIfNeeded()
            
        case .changed:
            dismissalAnimator = createInteractiveDismissalAnimatorIfNeeded()
            
            let actualProgress = progress
            let isDismissalSuccess = actualProgress >= 1.0
            
            dismissalAnimator!.fractionComplete = actualProgress
            
            if isDismissalSuccess {
                dismissalAnimator!.stopAnimation(false)
                dismissalAnimator!.addCompletion { [unowned self] (pos) in
                    switch pos {
                    case .end:
                        self.didSuccessfullyDragDownToDismiss()
                    default:
                        fatalError("Must finish dismissal at end!")
                    }
                }
                dismissalAnimator!.finishAnimation(at: .end)
            }
            
        case .ended, .cancelled:
            if dismissalAnimator == nil {
                // Gesture's too quick that it doesn't have dismissalAnimator!
                print("Too quick there's no animator!")
                didCancelDismissalTransition()
                return
            }
            // NOTE:
            // If user lift fingers -> ended
            // If gesture.isEnabled -> cancelled
            
            // Ended, Animate back to start
            dismissalAnimator!.pauseAnimation()
            dismissalAnimator!.isReversed = true
            
            // Disable gesture until reverse closing animation finishes.
            gesture.isEnabled = false
            dismissalAnimator!.addCompletion { [unowned self] (pos) in
                self.didCancelDismissalTransition()
                gesture.isEnabled = true
            }
            dismissalAnimator!.startAnimation()
        default:
            fatalError("Impossible gesture state? \(gesture.state.rawValue)")
        }
    }
    
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        scrollView.scrollIndicatorInsets = .init(top: newsCardContentView.bounds.height, left: 0, bottom: 0, right: 0)
        
        if GlobalConstants.isEnabledTopSafeAreaInsetsFixOnCardDetailViewController {
            self.additionalSafeAreaInsets = .init(top: max(-view.safeAreaInsets.top,0), left: 0, bottom: 0, right: 0)
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if draggingDownToDismiss || (scrollView.isTracking && scrollView.contentOffset.y < 0){
            draggingDownToDismiss = true
            scrollView.contentOffset = .zero
        }
        
        scrollView.showsVerticalScrollIndicator = !draggingDownToDismiss
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        // Without this, when user drag down and lift the finger fast at the top, there'll be some scrolling going on.
        // This check prevents that.
        if velocity.y > 0 && scrollView.contentOffset.y <= 0 {
            scrollView.contentOffset = .zero
        }
    }
    
    func setSummaryText() {
        let paragraphStyle = NSMutableParagraphStyle()//line height size
        paragraphStyle.lineSpacing = 5.0
        let attrString = NSMutableAttributedString(string: cardViewModel.summary)
        attrString.addAttribute(NSAttributedString.Key.paragraphStyle,
                                value:paragraphStyle,
                                range:NSMakeRange(0, attrString.length))
        
        summary.attributedText = attrString
    }
    
    func setTextViewText() {
        let paragraphStyle = NSMutableParagraphStyle()//line height size
        paragraphStyle.lineSpacing = 8.0
        
        let textAttribute = [NSAttributedString.Key.paragraphStyle: paragraphStyle ,
                             NSAttributedString.Key.font: UIFont.systemFont(ofSize: 19.0)]
        
        let attrString = NSMutableAttributedString(string: cardViewModel.textContent)
        
        attrString.addAttributes(textAttribute, range:NSMakeRange(0, attrString.length))
        
        textView.attributedText = attrString
    }
    
    // MARK: - Navigation
    
    @objc func navigateToNewsSite() {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "WebViewController") as? WebViewController {
            vc.url = URL(string: cardViewModel.url)!
            
            vc.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "<", style: .done, target: self, action: #selector(returnToCardDetail))
            
            let nvc = UINavigationController(rootViewController: vc)
            nvc.modalPresentationStyle = .overFullScreen
            
            transitionLayer.frame = CGRect(x: 0.0, y: 0.0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
            transitionLayer.backgroundColor = UIColor.white.cgColor
            
            view.window!.layer.addSublayer(transitionLayer)
            
            view.window!.layer.add(transitionSetup(isPush: true), forKey: kCATransition)
            
            present(nvc, animated: false)
            
        }
    }
    
    @objc func returnToCardDetail() {
        transitionLayer.removeFromSuperlayer()
        view.window!.layer.add(transitionSetup(isPush: false), forKey: kCATransition)
        
        dismiss(animated: false, completion: nil)
    }
    
    func transitionSetup(isPush: Bool) -> CATransition{
        
        let transition = CATransition()
        transition.duration = 0.2
        transition.type = .push

        transition.subtype = isPush ? .fromRight : .fromLeft
        transition.timingFunction = CAMediaTimingFunction(name: .easeIn)
        return transition
    }
    
    
}

extension CardDetailViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
