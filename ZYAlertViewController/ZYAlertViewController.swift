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
    private let contentContainer = UIView()

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
        scrollView.contentInsetAdjustmentBehavior = .never
        view.addSubview(scrollView)
        scrollView.addSubview(contentContainer)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentContainer.addSubview(contentView)
        // Anchor content to a frame-managed wrapper. Leaving an unconstrained
        // Auto Layout view directly in a scroll view lets its intrinsic width
        // override the measured width, causing multiline text to overflow.
        NSLayoutConstraint.activate([
            contentView.leadingAnchor.constraint(equalTo: contentContainer.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: contentContainer.trailingAnchor),
            contentView.topAnchor.constraint(equalTo: contentContainer.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: contentContainer.bottomAnchor)
        ])
    }

    // A required width is kept intact and may scroll horizontally. Otherwise
    // content is measured at the available width so multiline text can wrap.
    private func measuredContentSize(for availableWidth: CGFloat) -> CGSize {
        let fixedWidth = contentView.constraints.first {
            $0.isActive && $0.priority == .required && $0.relation == .equal &&
            $0.firstItem === contentView && $0.firstAttribute == .width && $0.secondItem == nil
        }?.constant
        let preferredWidth = fixedWidth ?? (initialContentSize.width > 0 ? initialContentSize.width : availableWidth)
        let width = max(0, fixedWidth ?? min(preferredWidth, availableWidth))
        let fitting = contentView.systemLayoutSizeFitting(
            CGSize(width: width, height: UIView.layoutFittingCompressedSize.height),
            withHorizontalFittingPriority: .required,
            verticalFittingPriority: .fittingSizeLevel
        )
        let height = fitting.height > 0 ? fitting.height : initialContentSize.height
        return CGSize(width: width, height: max(0, ceil(height)))
    }

    fileprivate func contentSize(for width: CGFloat) -> CGSize {
        let size = measuredContentSize(for: width)
        return CGSize(width: min(size.width, width), height: size.height)
    }

    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let size = measuredContentSize(for: view.bounds.width)
        contentContainer.frame = CGRect(origin: .zero, size: CGSize(
            width: size.width,
            height: max(size.height, view.bounds.height)))
        contentContainer.setNeedsLayout()
        contentContainer.layoutIfNeeded()
        scrollView.contentSize = contentContainer.bounds.size
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
        var available = container.bounds.inset(by: container.safeAreaInsets)
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
