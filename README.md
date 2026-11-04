# ZYAlertViewController

使用 Swift 编写的自定义 UIKit 弹窗控制器，支持传入自定义视图、底部弹出和淡入淡出动画、点击半透明背景关闭，以及安全区域和窗口尺寸自适应。内容超出可用区域时可滚动查看。

## 用法

在 Xcode 的 **File → Add Package Dependencies** 中添加：

```text
https://github.com/iDev01/ZYAlertViewController.git
```

将 `ZYAlertViewController` 产品添加到应用 target，然后在视图控制器中使用：

```swift
import UIKit
import ZYAlertViewController

let content = UIView(frame: CGRect(x: 0, y: 0, width: 300, height: 200))
content.backgroundColor = .white
content.layer.cornerRadius = 16

let alert = ZYAlertViewController(
    view: content,
    presentDirection: .coverVertical,
    dismissWhenTap: true
)
present(alert, animated: true)
```

- `view`：自定义内容视图，通过初始 frame 或完整的 Auto Layout 宽高约束指定大小。
- `presentDirection`：`.coverVertical` 从底部弹出，`.crossDissolve` 居中淡入淡出。
- `dismissWhenTap`：是否点击背景关闭弹窗。

完整示例见 [Example](Example)。

## LICENSE

[MIT License](LICENSE)
