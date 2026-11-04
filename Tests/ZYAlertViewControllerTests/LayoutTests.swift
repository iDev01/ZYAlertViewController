import XCTest
import UIKit
@testable import ZYAlertViewController

@MainActor
final class LayoutTests: XCTestCase {
    func testMultilineContentStaysWithinWidthAndGrowsWhenNarrowed() {
        let content = UIView()
        let label = UILabel()
        label.numberOfLines = 0
        label.text = String(repeating: "多行文本应按弹窗宽度换行，不应超出边界。", count: 20)
        label.translatesAutoresizingMaskIntoConstraints = false
        content.addSubview(label)
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: content.leadingAnchor, constant: 24),
            label.trailingAnchor.constraint(equalTo: content.trailingAnchor, constant: -24),
            label.topAnchor.constraint(equalTo: content.topAnchor, constant: 24),
            label.bottomAnchor.constraint(equalTo: content.bottomAnchor, constant: -24)
        ])
        let alert = ZYAlertViewController(view: content, presentDirection: .crossDissolve, dismissWhenTap: true)
        alert.loadViewIfNeeded()
        layout(alert, width: 600)
        let wideHeight = content.bounds.height
        layout(alert, width: 240)
        XCTAssertEqual(content.bounds.width, 240, accuracy: 0.5)
        XCTAssertEqual(label.frame.width, 192, accuracy: 0.5)
        XCTAssertGreaterThan(content.bounds.height, wideHeight)
        XCTAssertLessThanOrEqual(label.frame.maxX, content.bounds.width)
        XCTAssertGreaterThanOrEqual(label.bounds.height + 1,
            label.sizeThatFits(CGSize(width: label.bounds.width, height: .greatestFiniteMagnitude)).height)
        let scroll = alert.view.subviews.compactMap { $0 as? UIScrollView }.first!
        XCTAssertEqual(scroll.contentSize.width, 240, accuracy: 0.5)
        XCTAssertGreaterThan(scroll.contentSize.height, scroll.bounds.height)
        layout(alert, width: 600)
        XCTAssertEqual(content.bounds.height, wideHeight, accuracy: 1)
    }

    func testFixedFrameAndRequiredDimensionsArePreserved() {
        let framed = UIView(frame: CGRect(x: 0, y: 0, width: 300, height: 400))
        let fixed = UIView()
        NSLayoutConstraint.activate([
            fixed.widthAnchor.constraint(equalToConstant: 300),
            fixed.heightAnchor.constraint(equalToConstant: 400)
        ])
        for content in [framed, fixed] {
            let alert = ZYAlertViewController(view: content, presentDirection: .coverVertical, dismissWhenTap: false)
            alert.loadViewIfNeeded()
            layout(alert, width: 240)
            XCTAssertEqual(content.bounds.height, 400, accuracy: 0.5)
            XCTAssertEqual(content.bounds.width, content === fixed ? 300 : 240, accuracy: 0.5)
        }
    }

    private func layout(_ alert: ZYAlertViewController, width: CGFloat) {
        alert.view.frame = CGRect(x: 0, y: 0, width: width, height: 100)
        alert.view.setNeedsLayout()
        alert.view.layoutIfNeeded()
    }
}
