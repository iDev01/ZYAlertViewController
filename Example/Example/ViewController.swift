import UIKit
import ZYAlertViewController

final class ViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        let verticalButton = makeButton(title: "下方弹出Alert", action: #selector(showVerticalAlert))
        let dissolveButton = makeButton(title: "溶解弹出Alert", action: #selector(showDissolveAlert))
        NSLayoutConstraint.activate([
            verticalButton.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            verticalButton.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor, constant: -50),
            dissolveButton.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            dissolveButton.topAnchor.constraint(equalTo: verticalButton.bottomAnchor, constant: 30)
        ])
    }

    private func makeButton(title: String, action: Selector) -> UIButton {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(title, for: .normal)
        button.addTarget(self, action: action, for: .touchUpInside)
        view.addSubview(button)
        return button
    }

    @objc private func showVerticalAlert() { showAlert(direction: .coverVertical, height: 150) }
    @objc private func showDissolveAlert() { showAlert(direction: .crossDissolve, height: 500) }

    private func showAlert(direction: PresentDirection, height: CGFloat) {
        let content = UIView()
        content.translatesAutoresizingMaskIntoConstraints = false
        content.backgroundColor = .brown
        NSLayoutConstraint.activate([
            content.widthAnchor.constraint(equalToConstant: 300),
            content.heightAnchor.constraint(equalToConstant: height)
        ])
        present(ZYAlertViewController(view: content, presentDirection: direction, dismissWhenTap: true), animated: true)
    }
}
