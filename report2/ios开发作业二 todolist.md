# ios开发作业二 代办事项

|  姓名  |   学号    |       邮箱        |
| :----: | :-------: | :---------------: |
| 吕玉龙 | 191220076 | 1931015836@qq.com |

本次工程需要设计一个todolist app。这个app所需要的要求如下：

1.实现待办事项添加并保存，并以表格实现代办事项列表展示；

2.实现待办事项更新；

3.支持以表格中单元格右划的方式完成某个代办事项删除；

4.对界面进行个性化/美化设计；

自行实现的部分还包括对于todolist中的cell进行移动，对于cell的选中来改变对于栏目的状态，以及左滑删除的功能，由于实践视频的内容非常全面，所以这次项目的有些部分的实现不会在报告中一一提到，这里只谈一下相对比较重要的部分。



### 目录

+ Part one ToDoTableViewController的实现
+ Part two ItemViewController的实现



### Part one ToDoTableViewController的实现

首先根据参考视频，完成对于UI界面的设计之后，重点便来到了对于tableview的实现上。首先实例化了三个ToDoItem作为一开始对于tableview的测试，随即就到了课上谈到的三个函数的处理，这三个函数的处理都没有什么特别之处。之后，通过查询appledeveloper上对于[`UITableViewDelegate`](https://developer.apple.com/documentation/uikit/uitableviewdelegate)的文档，找到自己需要实现的功能对应的函数。例如，要求三中的swipe操作。

```swift
override func tableView(_ tableView: UITableView,
               leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
    let action = UIContextualAction(style: .normal,
                                    title: "Delete") { [weak self] (action, view, completionHandler) in
                                        self?.handleMarkAsFavourite(indexPath: indexPath)
                                        completionHandler(true)
    }
    action.backgroundColor = .systemCyan
    
    return UISwipeActionsConfiguration(actions: [action])
}
```

这里是左滑的代码，实际上右滑的处理几乎一样，只不过右滑不只是delete还有置顶功能，所以会有一些小小的不同。handleMarkAsFavourite实际上对这个swipe的处理函数，置顶的话，处理函数则是moveToFirst函数。

```swift
private func moveToFirst(indexPath: IndexPath) {
    let newitem = items[indexPath.row]
    items.remove(at: indexPath.row)
    let toIndexPath = IndexPath(row: 0, section: 0)
    items.insert(newitem, at: toIndexPath.row)
    self.tableView.moveRow(at: indexPath, to: toIndexPath)
    print("move to first")
}
```

对于置顶的处理不比直接删除的处理，它首先需要对于items中的ToDoitem进行对应的操作，才可以调用moveRow函数，否则会一直报错。

接下来说一下对于背景图片的操作，网上的搜索实际上出来的处理方式大多数比较模糊，实际上需要先把需要的图片导入至Assets.xcassets中，随后对于图片的操作代码才能生效，插入的代码则是很简单，网友给出了不少方式，这里贴一下我采用的方式，一种是在tableviewcontroller中采用的，另一种是在itemviewcontroller中使用的

```swift
let bg = UIImage(named: "nixeu")
let bgView = UIImageView(image: bg)
bgView.contentMode = UIView.ContentMode.scaleAspectFill
self.tableView.backgroundView = bgView

let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
backgroundImage.image = UIImage(named: "nixeu")
backgroundImage.contentMode = UIView.ContentMode.scaleAspectFill
self.view.insertSubview(backgroundImage, at: 0)
```

对于选中某一个row并且进行修改，同样查阅appledeveloper上对于[`UITableViewDelegate`](https://developer.apple.com/documentation/uikit/uitableviewdelegate)的文档，发现

```swift
override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
```

正是我们需要的，接下来只需要拿出选中的cell进行修改即可

```swift
tableView.deselectRow(at: indexPath, animated: false)
let cell = tableView.cellForRow(at: indexPath) as! ToDoTableViewCell
let item = items[indexPath.row]
    
if item.isChecked{
    item.isChecked = false
    cell.status.text! = " "
}
else{
    item.isChecked = true
    cell.status.text! = "✅"
}
    
```

使用磁盘加载则按照实践视屏中的方式即可。



### Part two ItemViewController的实现

ItemViewController与ToDoTableViewController是这个工程两个最重要的部分，不止是它们各自要做不同的界面设计，更在于它们两个之间的segue联系以及需要完成的protocol和extension来实现它们之间的交互。实践视频演示的委托是十分精妙的，首先创建了两个protocol来分别进行修改和添加的处理。这里直接来看对于edit的处理。

```swift
	else if segue.identifier == "edititem"{
        let editItemViewController = segue.destination as! ItemViewController
        let cell = sender as! ToDoTableViewCell
        var isChecked:Bool
        if cell.status.text! == "✅"{
            isChecked = true
        }
        else{
            isChecked = false
        }
        let item = ToDoitem(title: cell.title.text!, isChecked: isChecked)
        editItemViewController.itemToEdit = item
        editItemViewController.itemIndex = tableView.indexPath(for: cell)!.row
        editItemViewController.editItemDelegate = self
    }
```

注意到它首先判断这个segue是否是edititem，即是否是在要求edit，如果是，那么取出需要编辑的cell，让ItemViewController实例化的editItemViewController中的itemtoEdit进行赋值，与此同时，我们看一下ItemViewController中的代码

```swift
override func viewDidLoad() {
    super.viewDidLoad()

    // Do any additional setup after loading the view.
    doneButton.isEnabled = false
    if itemToEdit != nil{
        doneButton.isEnabled = true
        self.titleInput.text! = itemToEdit!.title
        self.isChecked.isOn = itemToEdit!.isChecked
    }
    
    let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
    backgroundImage.image = UIImage(named: "nixeu")
    backgroundImage.contentMode = UIView.ContentMode.scaleAspectFill
    self.view.insertSubview(backgroundImage, at: 0)
    
}
@IBAction func Closed(_ sender: Any) {
    if itemToEdit == nil{
        self.addItemDelegate?.addItem(item: ToDoitem(title: titleInput.text!, isChecked: isChecked.isOn))
    }
    else{
        self.editItemDelegate?.editItem(newitem: ToDoitem(title: titleInput.text!, isChecked: isChecked.isOn), itemIndex: self.itemIndex)
    }
    //self.addItemDelegate?.addItem(item: ToDoitem(title: titleInput.text!, isChecked: isChecked.isOn))
    self.dismiss(animated: true, completion: nil)
}
```

edititem因为有了复制，故不为空，donebutton可以被点击，closed函数（当你点击了done按钮）也会去调用protocol中定义的函数

```swift
protocol EditItemDelegate{
    func editItem(newitem:ToDoitem, itemIndex: Int)
}
```

```swift
extension ToDoTableViewController:EditItemDelegate{
    func editItem(newitem: ToDoitem, itemIndex: Int) {
        self.items[itemIndex] = newitem
        self.tableView.reloadData()
    }
}
```

会让ToDoTableViewController重新更新cell，这样就完成了ToDoTableViewController和ItemViewController的交互。



演示效果如下

B站bv号BV1sP4y1b7bL
