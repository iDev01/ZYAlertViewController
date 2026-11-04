import UIKit

@objc public enum PresentDirection: Int {
    case coverVertical
    case crossDissolve
}

public final class ZYAlertViewController: UIViewController, UIViewControllerTransitioningDelegate {
    private let contentView: UIView
    private let initialContentSize: CGSize
    private let presentDirection: PresentDirection
    private let dismissWhenTap: Bool
    private let scrollView = UIScrollView()

    @objc public init(view: UIView, presentDirection: PresentDirection, dismissWhenTap: Bool) {
        contentView = view
        initialContentSize = view.bounds.size
        self.presentDirection = presentDirection
        self.dismissWhenTap = dismissWhenTap
        super.init(nibName: nil, bundle: nil)
        modalPresentationStyle = .custom
        transitioningDelegate = self
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("Use init(view:presentDirection:dismissWhenTap:)")
    }

    public override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.frame = view.bounds
        scrollView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        if #available(iOS 11.0, *) {
            scrollView.contentInsetAdjustmentBehavior = .never
        }
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
    }

    private var contentSize: CGSize {
        let fitting = contentView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
        return CGSize(width: max(0, fitting.width > 0 ? fitting.width : initialContentSize.width),
                      height: max(0, fitting.height > 0 ? fitting.height : initialContentSize.height))
    }

    fileprivate func contentSize(for width: CGFloat) -> CGSize {
        let size = contentSize
        return CGSize(width: min(size.width, width), height: size.height)
    }

    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        // Preserve required content dimensions; oversized content can scroll.
        let size = contentSize
        contentView.frame = CGRect(origin: .zero, size: CGSize(
            width: max(size.width, view.bounds.width),
            height: max(size.height, view.bounds.height)))
        scrollView.contentSize = contentView.frame.size
    }

    public func presentationController(forPresented presented: UIViewController,
                                       presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        let controller = AlertPresentationController(presentedViewController: presented, presenting: presenting)
        controller.presentDirection = presentDirection
        controller.dismissWhenTap = dismissWhenTap
        return controller
    }

    public func animationController(forPresented presented: UIViewController,
                                    presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        AlertAnimator(direction: presentDirection, presenting: true)
    }

    public func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        AlertAnimator(direction: presentDirection, presenting: false)
    }
}

private final class AlertPresentationController: UIPresentationController {
    var presentDirection: PresentDirection = .coverVertical
    var dismissWhenTap = false
    private var dimmingView: UIView?

    override var frameOfPresentedViewInContainerView: CGRect {
        guard let container = containerView,
              let alert = presentedViewController as? ZYAlertViewController else { return .zero }
        var insets = UIEdgeInsets.zero
        if #available(iOS 11.0, *) { insets = container.safeAreaInsets }
        var available = container.bounds.inset(by: insets)
        available = available.insetBy(dx: 0, dy: min(8, available.height / 2))
        var size = alert.contentSize(for: available.width)
        size.height = min(size.height, available.height)
        let y = presentDirection == .coverVertical
            ? available.maxY - size.height : available.midY - size.height / 2
        return CGRect(x: available.midX - size.width / 2, y: y, width: size.width, height: size.height)
    }

    override func containerViewWillLayoutSubviews() {
        super.containerViewWillLayoutSubviews()
        dimmingView?.frame = containerView?.bounds ?? .zero
        presentedView?.frame = frameOfPresentedViewInContainerView
        presentedView?.setNeedsLayout()
    }

    override func presentationTransitionWillBegin() {
        super.presentationTransitionWillBegin()
        guard let container = containerView else { return }
        let background = UIView(frame: container.bounds)
        background.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        background.backgroundColor = UIColor(white: 0, alpha: 0.4)
        background.alpha = 0
        if dismissWhenTap {
            background.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissAlert)))
        }
        dimmingView = background
        container.insertSubview(background, at: 0)
        if let coordinator = presentedViewController.transitionCoordinator {
            coordinator.animate(alongsideTransition: { _ in background.alpha = 1 })
        } else {
            background.alpha = 1
        }
    }

    override func dismissalTransitionWillBegin() {
        super.dismissalTransitionWillBegin()
        if let coordinator = presentedViewController.transitionCoordinator {
            coordinator.animate(alongsideTransition: { _ in
                self.dimmingView?.alpha = 0
            }, completion: { context in
                if context.isCancelled { self.dimmingView?.alpha = 1 }
            })
        } else {
            dimmingView?.alpha = 0
        }
    }

    override func presentationTransitionDidEnd(_ completed: Bool) {
        super.presentationTransitionDidEnd(completed)
        if !completed { dimmingView?.removeFromSuperview() }
    }

    override func dismissalTransitionDidEnd(_ completed: Bool) {
        super.dismissalTransitionDidEnd(completed)
        if completed { dimmingView?.removeFromSuperview() }
    }

    @objc private func dismissAlert() {
        presentedViewController.dismiss(animated: true)
    }
}

private final class AlertAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    private let direction: PresentDirection
    private let presenting: Bool

    init(direction: PresentDirection, presenting: Bool) {
        self.direction = direction
        self.presenting = presenting
        super.init()
    }

    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval { 0.25 }

    func animateTransition(using context: UIViewControllerContextTransitioning) {
        let key: UITransitionContextViewControllerKey = presenting ? .to : .from
        guard let controller = context.viewController(forKey: key), let view = controller.view else {
            context.completeTransition(false)
            return
        }
        if presenting {
            context.containerView.addSubview(view)
            view.frame = context.finalFrame(for: controller)
            view.layoutIfNeeded()
        }
        let offscreen = CGAffineTransform(translationX: 0, y: max(0, context.containerView.bounds.maxY - view.frame.minY))
        if presenting {
            if direction == .coverVertical { view.transform = offscreen }
            else { view.alpha = 0 }
        }
        UIView.animate(withDuration: transitionDuration(using: context), animations: {
            if self.direction == .coverVertical {
                view.transform = self.presenting ? .identity : offscreen
            } else {
                view.alpha = self.presenting ? 1 : 0
            }
        }, completion: { _ in
            let completed = !context.transitionWasCancelled
            if !completed || !self.presenting {
                view.transform = .identity
                view.alpha = 1
            }
            if !completed && self.presenting { view.removeFromSuperview() }
            context.completeTransition(completed)
        })
    }
}
