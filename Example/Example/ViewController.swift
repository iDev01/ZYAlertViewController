import UIKit
import ZYAlertViewController

final class ViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "ZYAlertViewController"
        view.backgroundColor = .systemBackground
        let scroll = UIScrollView()
        scroll.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scroll)
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 16
        stack.translatesAutoresizingMaskIntoConstraints = false
        scroll.addSubview(stack)
        NSLayoutConstraint.activate([
            scroll.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scroll.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            scroll.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            scroll.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            stack.topAnchor.constraint(equalTo: scroll.contentLayoutGuide.topAnchor, constant: 24),
            stack.bottomAnchor.constraint(equalTo: scroll.contentLayoutGuide.bottomAnchor, constant: -24),
            stack.leadingAnchor.constraint(equalTo: scroll.contentLayoutGuide.leadingAnchor, constant: 24),
            stack.trailingAnchor.constraint(equalTo: scroll.contentLayoutGuide.trailingAnchor, constant: -24),
            stack.widthAnchor.constraint(equalTo: scroll.frameLayoutGuide.widthAnchor, constant: -48)
        ])
        stack.addArrangedSubview(label("弹窗示例", style: .largeTitle))
        stack.addArrangedSubview(label("展示弹窗后可旋转设备或调整窗口大小，观察内容重新排版。"))
        addButton("底部弹出 · 固定尺寸", to: stack, action: #selector(showFixed))
        addButton("居中淡入 · 多行文本", to: stack, action: #selector(showText))
        addButton("超长内容 · 滚动查看", to: stack, action: #selector(showLongContent))
        addButton("输入框 · 手动关闭", to: stack, action: #selector(showInput))
    }

    private func label(_ text: String, style: UIFont.TextStyle = .body) -> UILabel {
        let label = UILabel()
        label.text = text
        label.numberOfLines = 0
        label.font = .preferredFont(forTextStyle: style)
        label.adjustsFontForContentSizeCategory = true
        return label
    }

    private func addButton(_ title: String, to stack: UIStackView, action: Selector) {
        let button = UIButton(type: .system)
        button.setTitle(title, for: .normal)
        button.titleLabel?.font = .preferredFont(forTextStyle: .headline)
        button.titleLabel?.adjustsFontForContentSizeCategory = true
        button.titleLabel?.numberOfLines = 0
        button.heightAnchor.constraint(greaterThanOrEqualToConstant: 44).isActive = true
        button.addTarget(self, action: action, for: .touchUpInside)
        stack.addArrangedSubview(button)
    }

    private func makeContent(title: String, paragraphs: [String], input: Bool = false) -> UIView {
        let content = UIView()
        content.translatesAutoresizingMaskIntoConstraints = false
        content.backgroundColor = .secondarySystemBackground
        content.layer.cornerRadius = 16
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 16
        stack.translatesAutoresizingMaskIntoConstraints = false
        content.addSubview(stack)
        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: content.topAnchor, constant: 24),
            stack.bottomAnchor.constraint(equalTo: content.bottomAnchor, constant: -24),
            stack.leadingAnchor.constraint(equalTo: content.leadingAnchor, constant: 24),
            stack.trailingAnchor.constraint(equalTo: content.trailingAnchor, constant: -24)
        ])
        stack.addArrangedSubview(label(title, style: .title2))
        paragraphs.forEach { stack.addArrangedSubview(label($0)) }
        if input {
            let field = UITextField()
            field.borderStyle = .roundedRect
            field.placeholder = "请输入内容"
            field.accessibilityLabel = "示例输入框"
            field.font = .preferredFont(forTextStyle: .body)
            field.adjustsFontForContentSizeCategory = true
            stack.addArrangedSubview(field)
            addButton("收起键盘", to: stack, action: #selector(endEditing))
        }
        addButton("关闭", to: stack, action: #selector(closeAlert))
        return content
    }

    @objc private func showFixed() {
        let content = makeContent(title: "固定尺寸", paragraphs: ["宽 300pt、高 240pt。窗口小于内容时可滚动查看。"])
        NSLayoutConstraint.activate([
            content.widthAnchor.constraint(equalToConstant: 300),
            content.heightAnchor.constraint(equalToConstant: 240)
        ])
        show(content, direction: .coverVertical)
    }

    @objc private func showText() {
        show(makeContent(title: "多行文本", paragraphs: [
            "此视图不设置固定宽高，按照当前可用宽度测量内容高度。调整窗口宽度时，文字应重新换行，弹窗高度随之变化。",
            "支持系统深色模式与动态字体。点击背景或关闭按钮退出。"
        ]), direction: .crossDissolve)
    }

    @objc private func showLongContent() {
        let paragraphs = (1...20).map {
            "第 \($0) 段：这是一段用于验证滚动的内容。缩小窗口或旋转设备后，仍然可以滚动到底部并点击关闭按钮。"
        }
        show(makeContent(title: "超长内容", paragraphs: paragraphs), direction: .coverVertical)
    }

    @objc private func showInput() {
        show(makeContent(title: "输入框", paragraphs: ["点击背景不会关闭此弹窗，请使用关闭按钮。"], input: true),
             direction: .crossDissolve, dismissWhenTap: false)
    }

    private func show(_ content: UIView, direction: PresentDirection, dismissWhenTap: Bool = true) {
        present(ZYAlertViewController(view: content, presentDirection: direction, dismissWhenTap: dismissWhenTap), animated: true)
    }

    @objc private func endEditing() { presentedViewController?.view.endEditing(true) }
    @objc private func closeAlert() { presentedViewController?.dismiss(animated: true) }
}
