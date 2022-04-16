

#### FilpCardGame-Lecture 2 Homework

###### 要求：

点击卡牌然后随机显示一张新的牌，再翻转一次又会显示新的牌

###### 具体难题：

- [ ] 在演示的时候使用的卡牌的图片无法在切换时进行顺利切换*（貌似是Xcode的问题，仍然无法解决，而且答案的那份代码也跑不通（可能是版本不兼容））*

- [ ] ViewController似乎无法识别已经设置了样式的标题，***会把设置了样式之后的button topic认为是不同的字符串***，导致要多翻一次才能进入到正常的逻辑里面




##### 相关文件：

***存放在Model文件夹里面的文件***

1. **Card 卡牌**

   `NSString *contents \\卡牌内容`

   `BOOL chosen \\未定义`

   `BOOL matched \\在setter里比较并且返回比较结果`

2. **PlayingCard : Card**

   决定牌面的花色和序号，设定牌的内容

3. **Deck 牌堆**

   `NSMutableArray *cards \\一个私有的可变数组，用来存放卡牌。`

   `addCard: atTop: 或 addCard:`加到牌堆的时候可以选择放在堆顶或者是堆底

   `drawRandomCard` 随机出牌，从牌堆里随机抽出一张牌，随机生成序号，然后从牌堆里取出（或删去）这张牌，并返回这张牌

   （考虑可变数组的移动的时空复杂度）

4. **PlayingCardDeck : Deck**

   在初始化的时候把一整幅牌生成并且加入到牌堆里面

   主要实现方式：在ViewController里面绑定Button，然后检测Button的点击动作，在每一次触发这个响应方法的时候，检查Button的title，如果不是`@"The Back"` 就翻面，设置为`@"The Back"`，否则就随机生成一张牌，取牌的内容，设置为Button的title

   在ViewController里面实现了PlayingCardDeck和Card

   并且在Button的响应方法里面初始化deck，随机抽出一张Card并且输出它的contents





#### FilpCardGame-Lecture 3 Homework

###### 要求：

在一堆牌里面匹配两张或三张牌，如果不匹配，牌面同时反转，匹配，则牌翻面而且一直显示内容。

###### 具体描述：

- [x] 游戏开始时：显示一堆牌，牌面朝下。点击的时候牌面翻转向上，显示出牌的内容。

- [x] 可以选择匹配两张或三张牌。

- [x] 依次点击想要匹配的牌，如果这几张牌之间匹配，会一直牌面朝上，而且按钮禁用。

- [x] 如果这些点击的牌之间不匹配，会重新翻转，牌面朝下。

- [x] 设立得分机制，如果牌匹配，得分，依据匹配的程度不同得不同的分。如果牌不匹配，不得分，甚至每次翻开牌都要扣分。

- [x] 显示总分数。

- [x] 甚至显示点击匹配的提示：”点击的两张内容各为___的牌相互匹配“

  

##### 针对前一版本所进行的修改：

1. 检查所有的实例变量，把能用属性的用属性替代（使用`@synthesized`），让代码更简洁

2. 生成一个`PlayingCardGame`类，在game类里面写游戏的核心逻辑，让它成为不需要UI界面也能实现的模型（Model）

   *Controller know model, then controll view to change.*

   数据结构：自己的牌堆（桌面上有的这些牌）`cards`、游戏得分`score`、

   方法：

   1. **`matchingCardAtIndex:`匹配牌（游戏的核心逻辑）** 

      - Card里面原有的配对逻辑（ `isMatched:`方法）要在此处改变 
        - 原来的 `isMatched:`方法里面，要两张牌的内容完全一致，才属于匹配
        - 在目前的发牌游戏里，牌堆只有一幅牌，所以不可能有两张完全一样的牌，做不到完美匹配

      - 逻辑描述：
        - 当前牌要求`matched=NO` ,然后判定：*chosen?*
          - *Yes*: `chosen=NO` 应对重复点击同一张牌的情况
            - 如果重复点击这张牌，因为第一次点击时牌已经从未被选中改为选中，那么就要将它的状态取消
            - 这部分其实是FilpCardGame Homework2逻辑的保留和延续，点击，翻开一张牌，再点击，合上这张牌

          - *No*: 寻找已经被选中而并未被匹配的牌，遍历game内部的数组去找复牌，尝试匹配，
            - 如果匹配成功，两者都标记为`matched=YES`
            - 如果匹配失败，前者取消选中
            - 无论结果如何，都将目前的卡牌标志为选中状态

      - 难点：其实`chosen` 是用来和UI界面进行交互的，是Model的改变传递到Controller，然后由Controller去操作View 的改变，这才是MVC模型的精髓，一开始无法理解，是因为我觉得，一旦点击了卡牌，就会在*ViewController*里面修改 `chosen` 状态，然后将具有这个状态的卡牌对象传入到Model，Model依据这个状态作出响应的改变， 但其实有点违背了MVC的初衷，view不可以直接影响Model的。而必须是由Controller改变这一切。
        - 在具体的UI界面设计上，`chosen` 控制的是卡牌的翻转，也就是控制它的显示效果。如果被选中了，就翻过来显示内容，不然就显示背面。
        - 在我自己的设计里面，`chosen`反而是一个已经被修改，然后用来影响后续行为的状态，而不是由核心逻辑改变的状态。要牢记MVC模型View不能改变Model这一点。

   2. `initWithCount: andDeck:` 初始化=发牌 

      传入牌的数量，用一个牌堆（Deck），将那个牌堆发的牌加入到现在的牌堆里面

      此时牌堆已经固定，相当于荷官发牌了，现在桌面上的牌是固定而且不会改变的

   3. 原来默认的`init`要返回`nil`

      designated initalizer现在是上面的那个初始化函数，不要试图在默认的init里面调用它并且传入牌数0和一个空的牌堆⚠️ 可能引起未知错误

   4. `cardAtIndex:`  返回自己牌堆中特定牌的getter

3. 修改`ViewController`的交互逻辑

   - 原来的逻辑：
     - 依托于点击事件，每一次点开时从牌堆里面抽取一张新的卡并且显示出来
     - 原来的版本中，每次点击卡牌翻面的过程，都像是从牌堆里抽取一张新牌的过程，所以可以把`darwRandomCard:` 放在点击事件里面，每一次点击按钮都会执行这个方法
   - 现在
     - 卡牌在开始游戏之后就已经是固定的了。开始游戏的时候会自动发牌，发到的牌在这一局内固定，不会再变化。
       - [x] 这部分工作由 `PlayingCardGame` 完成
       - [x] 是否需要重设？重新来一局？然后初始化重新发牌？
     - 在View里面设立一堆按钮，绑定到Controller里面的按钮组，再将这些按钮全部逐个绑定到响应方法上面。
     - 通过点击按钮， 激活这个响应方法的时候，将`sender` 传入按钮的数组，用`indexOfObject` 方法找到它所对应的下标，然后传入下标进game，让game来处理这张牌。
       - 翻面……匹配……选中状态……其实都交给了`PlayingCardGame` 来处理（面向对象的魔力，大家各司其职）
     - 处理结束之后，根据牌的状态更新UI界面（MVC的精髓！Controller响应Model的变化，然后根据Model的变化改变View～）
       - 为了方便，直接用了一个`for`循环，检查整个按钮的数组，用同样的方法获取每个按钮的下标，然后检查卡牌（先获取按钮，因为等下还要用按钮）
         - 每次使用循环虽然有些浪费资源，但为了确保每一张牌都能被检查到，循环是合理而且必要的。想想如果是按原来的设计思想，在点击的时候就在Controller改变牌的状态，那如果点击两张牌之后，大家不匹配，要前一张牌翻面呢？这就是很难做到的事情，很难获悉前一张牌的信息并且做出更改。而用循环可以避免漏网之鱼。
       - 检查卡牌的选中状态（`chosen`）以决定显示的内容：如果选中了，卡牌被翻面，显示出牌面内容；如果没有被选中，卡牌牌面朝下，什么也不干
       - 检查卡牌的匹配状态（`matched`）以决定按钮是否会被禁用：如果两张牌相互匹配了，它们不会被翻面，但是要确保用户再度点击的时候，Controller不对这两张牌作出反应，所以要禁用按钮（`button.enabled=!card.isMatched`）

4. 对整一个运行逻辑的描述

   - 初始状态下，原来的牌都是没有被选中的。在第一张牌被点击之后，调用`[game matchingCardAtIndex:index]`，尝试寻找先前已经被选中的牌，因为之前没有被选中的牌，所以什么也没匹配到，那就是什么都没有做，只是把牌设置为选中了，接着更新UI界面，将牌翻过来显示内容，因为牌是被选中了，所以才可以显示内容。
     - 这里是先执行操作逻辑，再进行UI改变，因为这种变化微不可察，所以对用户来说，和先进行UI改变，再执行操作逻辑相比，两者看起来是一样的。

   -  到了第二张牌被点击的时候，因为第二张牌初始也不是被选中的，所以也会进入匹配逻辑，在先前选中的牌里面找，此时牌1是被选中的，
     - 如果匹配成功，牌1的选中状态不变，牌1和牌2同时被标记 `matched=YES`
     - 如果匹配失败，牌1 的选中状态失效
     - 匹配结束之后牌2改为被选中
   - 在UI界面，选中状态的牌：翻面；没选中的牌：取消翻面（内容那面朝下）
   - 所以此时对于第一张牌来说，点击它的时候，它的状态被设置为选中，它会被翻面，显示出牌面的内容。到了第二张牌的时候，
     - 如果两张牌相互匹配，第二张牌也会显示出来，两张牌一起显示；
     - 如果两张牌不匹配，那么只有第二张牌会显示，第一张牌会翻面回去。



***Syntax Sugar：***

- 如果用了`@synthesized` 而且自己重载getter，编译器会报错。
  - Setter and getter must be 
    - both synthesized
    - both user defined
  - or the property must be `nonatomic`
- 使用 `[array indexOfObject:index]` 在数组里面查找元素，实际上是调用内置的`isEqual` 方法
  - 没有重载`isEqual` 方法的时候，比较的是两个对象的内存地址，如果要比较内容是否相同（两个`NSString` 对象或其他`NSObject` 对象 ），要自己重载方法。
  - 所以这个方法在没有重载`isEqual`方法的时候，只对本来就被编入到`NSArray` 的对象有效
- 使用 `[array indexOfObject:index]` 在数组里面查找元素时，如果元素不存在，返回的是 `NSNotFound`



##### 实现三张卡牌匹配：

1. 逻辑设计

   三张牌的匹配比两张牌的要复杂，三张牌需要两两之间相互匹配，才能够算是匹配，所以至少需要在两张牌的判定逻辑上增加两个变量：一个是对上一次匹配的状态的存储变量`NSString *matchingType`，一个是存储上一次匹配的牌的数组`NSMutableArray *cardsMatched`。

   在成功匹配的时候，要检查匹配的模式，修改匹配的这些牌的状态。

   具体逻辑如下：

   ​	***遍历检查：当前的牌和已选中的牌是否匹配？***

   - match in suit 两张牌有相同花色
     - first time 先前没有牌匹配过。
       - ***满足此情况的条件***：`cardsMatched` 数组为空，并且`matchingType=@""`
       - ***执行操作***：将此次匹配的两张牌加入到`cardsMatched` 数组，`matchingType=@"suitMatched"`
     - second time 先前有牌匹配过，而且匹配的类型和此次匹配一样
       - ***满足此情况的条件***：`cardsMatched` 数组里已经有两张卡牌，并且`matchingType=@"suitMatched"`，并且`cardsMatched` 数组里没有当前这张牌
       - ***执行操作***：将这张牌加入到`cardsMatched`数组里面，然后执行`[self allCardsMatched]`，对三张相互匹配的牌进行一些操作，并且增加得分`score`。
     - 和先前记录的匹配类型不符合
       - ***满足此情况的条件***：这两张牌相匹配，但是和之前匹配的两张牌类型不同，比如先前的类型是 `matchingType=@"rankMatched"`，而现在是match in suit，自然不吻合
       - ***执行操作***：调用`[self cleanCardsMatched]`清理`cardsMatched`数组，和`matchingType`；并且将现在匹配的这两张牌加入到`cardsMatched`里面，且`matchingType=@"suitMatched"`
   - match in rank 两张牌有相同数字（同上）
   - not match 两张牌不匹配
     - 将当前的牌设置为选中 
     - 调用`[self cleanCardsMatched]`清理`cardsMatched`数组，和`matchingType`

   

   

2. 细节修改

   1. 在`Deck` 里增加了 `(NSUInteger)cardsCount` 返回牌堆里剩下的牌数。

   2. 在`PlayingCardGame` 里

      1. 增加一个`BOOL`变量：`matchTwoCard`，用于标识当前游戏的状态，是匹配两张卡牌还是三张卡牌，初始化时设置成`YES`，表示初始是匹配两张卡牌。
      2. 增加一个`reset` 方法：用来对游戏进行重新加载，比如重新发牌，重新设置分数，清空当前卡牌的匹配类型；重新发牌前会检查牌堆的数目，如果不够牌了，生成一个新的牌堆
         - *注意内存管理问题*：是否应该在这里生成一个新牌堆？
         - 改成给从Controller里获取来的牌堆`deck`发送信息，让它自己重设。
           - 在`PlayingCardDeck`增加一个`resetDeck`方法，重新生成 一幅牌加入到牌堆里面。根据数据封装原则，牌堆里记录卡牌的数组`cards`是属于`Deck`的私有变量，`PlayingCardDeck`作为一个子类是无法访问的，没有办法清空这个数组，<u>只能在`Deck`的`addCard`里增加一个添加卡牌时的判断：判断卡牌是否存在，如果存在就不加入到牌堆中。</u>**如果新版本允许相同的两张牌存在，可以省略这一判断。**
           - 而且根据OC的特性，要在`PlayingCardGame`所有涉及这个变量的地方，将类型从`Deck` 改为`PlayingCardDeck`
      3. 在`matchingCardAtIndex:`里增加判定，判定是匹配两张卡还是三张卡，走不同的判定逻辑。
      4. 新增`allCardsMatched`方法：对`cardsMatched`数组里面的卡牌，设置为`matched=YES`,`chosen=YES`，然后清空这个数组，将`matchingType`也清空
      5. 新增`cleanCardsMatched`方法：对`cardsMatched`数组里面的卡牌，设置为`matched=NO`,`chosen=NO`，然后清空这个数组，将`matchingType`也清空

   3. 在界面的修改

      1. 增加了二选一按钮（Segmented Control），用以选择匹配两张牌还是三张牌
      2. 增加了重新加载游戏的按钮

   4. 在ViewController的修改

      1. 针对二选一按钮

         获取当前值（使用`sender.selectedSegmentIndex`），判定并且：

         1. 重设游戏：` [self.game reset]`
         2. 更新UI：` [self updateUI]`
         3. 设置游戏类型： `[self.game setMatchTwoCard:YES]` 或`[self.game setMatchTwoCard:NO]`

      2. 针对重新加载按钮：

         调用`[self.game reset]`和`[self updateUI]`，重新设定游戏并且更新UI

3. 相比上一次修改完善的功能

   1. 可以选择匹配两张或三张牌。
   2. 可以重设，初始化重新发牌，重新来一局。

4. 一些还没有实现的功能

   - [ ] 用Label显示匹配成功的提示
   - [ ] 检查所有卡牌，如果卡牌无法再匹配，显示游戏结束和得分









