FilpCardGame-Lecture 2 Homework

要求：点击卡牌然后随机显示一张新的牌，再翻转一次又会显示新的牌

具体难题：

在演示的时候使用的卡牌的图片无法在切换时进行顺利切换

ViewController似乎无法识别已经设置了样式的标题，会把设置了样式之后的button topic认为是不同的字符串，导致要多翻一次才能进入到正常的逻辑里面



相关文档：

存放在Model文件夹里面的文件

**Card 卡牌**

`NSString *contents \\卡牌内容`

`BOOL chosen \\未定义`

`BOOL matched \\在setter里比较并且返回比较结果`

**PlayingCard : Card**

决定牌面的花色和序号，设定牌的内容



**Deck 牌堆**

`NSMutableArray *cards \\一个私有的可变数组，用来存放卡牌。`

`addCard: atTop: 或 addCard:`加到牌堆的时候可以选择放在堆顶或者是堆底

`drawRandomCard` 随机出牌，从牌堆里随机抽出一张牌，随机生成序号，然后从牌堆里取出（或删去）这张牌，并返回这张牌

（考虑可变数组的移动的时空复杂度）



**PlayingCardDeck : Deck**

在初始化的时候把一整幅牌生成并且加入到牌堆里面



主要实现方式：在ViewController里面绑定Button，然后检测Button的点击动作，在每一次触发这个响应方法的时候，检查Button的title，如果不是`@"The Back"` 就翻面，设置为`@"The Back"`，否则就随机生成一张牌，取牌的内容，设置为Button的title

在ViewController里面实现了PlayingCardDeck和Card

并且在Button的响应方法里面初始化deck，随机抽出一张Card并且输出它的contents

