# ZYAlertViewController

使用 Swift 编写的自定义 UIKit 弹窗控制器，支持传入自定义视图、底部弹出和淡入淡出动画、点击半透明背景关闭，以及安全区域和窗口尺寸自适应。内容超出可用区域时可滚动查看。

支持 iOS 15 及以上版本。

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

- `view`：自定义内容视图。可通过初始 frame 或固定宽高约束指定大小，也可使用完整的内部 Auto Layout 约束，让内容按可用宽度自动计算高度；固定宽度超出窗口时可横向滚动。
- `presentDirection`：`.coverVertical` 从底部弹出，`.crossDissolve` 居中淡入淡出。
- `dismissWhenTap`：是否点击背景关闭弹窗。

### 自适应内容

不设置内容视图的固定宽高，通过内部约束确定高度。多行文本会按可用宽度换行，超高内容可纵向滚动：

```swift
let content = UIView()
content.backgroundColor = .secondarySystemBackground
content.layer.cornerRadius = 16

let label = UILabel()
label.text = "这是一段多行文本，弹窗宽度变化时会自动换行，并重新计算内容高度。"
label.numberOfLines = 0
label.font = .preferredFont(forTextStyle: .body)
label.adjustsFontForContentSizeCategory = true
label.translatesAutoresizingMaskIntoConstraints = false
content.addSubview(label)

NSLayoutConstraint.activate([
    label.leadingAnchor.constraint(equalTo: content.leadingAnchor, constant: 24),
    label.trailingAnchor.constraint(equalTo: content.trailingAnchor, constant: -24),
    label.topAnchor.constraint(equalTo: content.topAnchor, constant: 24),
    label.bottomAnchor.constraint(equalTo: content.bottomAnchor, constant: -24)
])

let alert = ZYAlertViewController(
    view: content,
    presentDirection: .crossDissolve,
    dismissWhenTap: true
)
present(alert, animated: true)
```

内容视图的位置由弹窗管理，无需添加到其他父视图。内部布局需有完整的水平和垂直约束；若设置 required 级别的固定宽度，内容会保留该宽度，超出窗口时横向滚动。

### 示例

完整示例见 [Example](Example)，包含固定尺寸、多行文本、超长内容滚动和输入框演示。打开 `Example/Example.xcodeproj` 即可运行，示例通过本地 SPM 依赖引用仓库源码。

## LICENSE

[MIT License](LICENSE)
