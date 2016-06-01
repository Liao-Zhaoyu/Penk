import UIKit
let size = UIScreen.mainScreen().bounds.size
let backimg:String = "apple"
enum DrawingState {
    case Began, Moved, Ended
}

class PKCanvas: UIImageView {
    // 存放点集的数组
    var points:[CGPoint] = [CGPoint]()
    
    // 当前半径
    var currentWidth:CGFloat = 10
    
    var customWidth:CGFloat = 1
    
    // 初始图片
    var defaultImage:UIImage?
    
    var lastImage:UIImage?
    
    // 最大和最小宽度
    let minWidth:CGFloat = 5
    let maxWidth:CGFloat = 13
    
    // 禁止多次调用clear导致undo复数次出现clear界面
    var undoclear = false
    
    //编辑模式是否开启
    var editchange:Bool = false
    
    //线条颜色
    var lineColor:UIColor?
    
    //笔帽风格
    var lineCapStyle:CGLineCap?
    
    //
    var markerpenIsOff:Bool = true
    
    //
    var markerpenAlpha:Float = 0.02
    
    var tempColor:UIColor?
    
    var lastOptIsEraser:Bool = false
    
    override init(frame: CGRect) {
        // 控件基本设定
        super.init(frame: frame)
        self.backgroundColor = UIColor.clearColor()
        self.userInteractionEnabled = true

        // 默认图片设定
        image = UIImage(named: backimg)
        defaultImage = image
        lastImage = image
        
        // 默认线条颜色设定
        lineColor = UIColor.blackColor()
        
        // 默认笔帽风格设定
        lineCapStyle = .Round
        
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    /**
     图片恢复初始化
     */
    func clear() {
        self.image = defaultImage
        lastImage = defaultImage
        if undoclear && self.drawingState == .Ended {
            self.boardUndoManager.addImage(self.image!)
            undoclear = false
        }
    }

    // UndoManager，用于实现 Undo 操作和维护图片栈的内存
    private class DBUndoManager {
        class DBImageFault: UIImage {}  // 一个 Fault 对象，与 Core Data 中的 Fault 设计类似
        
        private static let INVALID_INDEX = -1
        private var images = [UIImage]()    // 图片栈
        private var index = INVALID_INDEX   // 一个指针，指向 images 中的某一张图
        
        var initimage:UIImage? = UIImage(named: backimg)
        
        var canUndo: Bool {
            get {
                print("\(index)")
                return index != DBUndoManager.INVALID_INDEX
            }
        }
        
        var canRedo: Bool {
            get {
                return index + 1 < images.count
            }
        }
        
        func addImage(image: UIImage) {
            // 当往这个 Manager 中增加图片的时候，先把指针后面的图片全部清掉，
            // 这与我们之前在 drawingImage 方法中对 redoImages 的处理是一样的
            if index < images.count - 1 {
                images[index + 1 ... images.count - 1] = []
            }
            
            images.append(image)
            
            // 更新 index 的指向
            index = images.count - 1
            
            setNeedsCache()
        }
        
        func imageForUndo() -> UIImage? {
            if self.canUndo {
                --index
                if self.canUndo == false {
                    return initimage
                } else {
                    setNeedsCache()
                    return images[index]
                }
            } else {
                return nil
            }
        }
        
        func imageForRedo() -> UIImage? {
            var image: UIImage? = nil
            if self.canRedo {
                image = images[++index]
            }
            setNeedsCache()
            return image
        }
        
        // MARK: - Cache
        
        private static let cahcesLength = 3 // 在内存中保存图片的张数，以 index 为中心点计算：cahcesLength * 2 + 1
        private func setNeedsCache() {
            if images.count >= DBUndoManager.cahcesLength {
                let location = max(0, index - DBUndoManager.cahcesLength)
                let length = min(images.count - 1, index + DBUndoManager.cahcesLength)
                for i in location ... length {
                    autoreleasepool {
                        let image = images[i]
                        
                        if i > index - DBUndoManager.cahcesLength && i < index + DBUndoManager.cahcesLength {
                            setRealImage(image, forIndex: i) // 如果在缓存区域中，则从文件加载
                        } else {
                            setFaultImage(image, forIndex: i) // 如果不在缓存区域中，则置成 Fault 对象
                        }
                    }
                }
            }
        }
        
        private static var basePath: String = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true).first!
        private func setFaultImage(image: UIImage, forIndex: Int) {
            if !image.isKindOfClass(DBImageFault.self) {
                let imagePath = (DBUndoManager.basePath as NSString).stringByAppendingPathComponent("\(forIndex)")
                UIImagePNGRepresentation(image)!.writeToFile(imagePath, atomically: false)
                images[forIndex] = DBImageFault()
            }
        }
        
        private func setRealImage(image: UIImage, forIndex: Int) {
            if image.isKindOfClass(DBImageFault.self) {
                let imagePath = (DBUndoManager.basePath as NSString).stringByAppendingPathComponent("\(forIndex)")
                images[forIndex] = UIImage(data: NSData(contentsOfFile: imagePath)!)!
            }
        }
    }
   
    private var boardUndoManager = DBUndoManager() // 缓存或Undo控制器
    private var realImage: UIImage?
    
    var drawingStateChangedBlock: ((state: DrawingState) -> ())?
    private var drawingState: DrawingState!
    
    var canUndo: Bool {
        get {
            return self.boardUndoManager.canUndo
        }
    }
    
    var canRedo: Bool {
        get {
            return self.boardUndoManager.canRedo
        }
    }
    
    /*
    undo
    redo
    */
    func undo() {
        if self.canUndo == false {
            print("can undo")
            return
        }
        
        self.image = self.boardUndoManager.imageForUndo()
        
        self.realImage = self.image
        self.lastImage = self.image
        
        print("undo over")
    }
    
    func redo() {
        if self.canRedo == false {
            print("can rede")
            return
        }
        
        self.image = self.boardUndoManager.imageForRedo()
        
        self.realImage = self.image
        self.lastImage = self.image
        
        print("redo over")
    }
    
    func changeLineColor(value:UIColor) {
        lineColor! = value
//        switch value {
//        case 1:
//            lineColor = UIColor.whiteColor()
//        case 2:
//            lineColor = UIColor.blackColor()
//        case 3:
//            lineColor = UIColor.yellowColor()
//        case 4:
//            lineColor = UIColor.grayColor()
//        case 5:
//            lineColor = UIColor(red: 253/255, green: 172/255, blue: 239/255, alpha: 1.0)
//        case 6:
//            lineColor = UIColor.brownColor()
//        case 7:
//            lineColor = UIColor.orangeColor()
//        case 8:
//            lineColor = UIColor.purpleColor()
//        case 9:
//            lineColor = UIColor.redColor()
//        case 10:
//            lineColor = UIColor.blueColor()
//        case 11:
//            lineColor = UIColor.greenColor()
//        case 12:
//            lineColor = UIColor.cyanColor()
//        default:
//            lineColor = UIColor.blackColor()
//        }
        if markerpenIsOff == false {
            lineColor! = (lineColor?.colorWithAlphaComponent(CGFloat(markerpenAlpha)))!
        }
    }
    
    func changeLineSize(value:Int){
        customWidth = CGFloat(value)
        switch value {
        case 1:
            lineColor! = (lineColor?.colorWithAlphaComponent(1))!
            lineCapStyle! = .Round
            markerpenIsOff = true
        case 2:
            lineColor! = (lineColor?.colorWithAlphaComponent(1))!
            lineCapStyle! = .Round
            markerpenIsOff = true
        case 3:
            lineColor! = (lineColor?.colorWithAlphaComponent(1))!
            lineCapStyle! = .Round
            markerpenIsOff = true
        case 6:
            lineColor! = (lineColor?.colorWithAlphaComponent(1))!
            lineCapStyle! = .Round
            markerpenIsOff = true
        case 20:
            markerpenAlpha = 0.02
            lineColor! = (lineColor?.colorWithAlphaComponent(CGFloat(markerpenAlpha)))!
            lineCapStyle! = .Square
            markerpenIsOff = false
        case 30:
            markerpenAlpha = 0.02
            lineColor! = (lineColor?.colorWithAlphaComponent(CGFloat(markerpenAlpha)))!
            lineCapStyle! = .Square
            markerpenIsOff = false
        case 40:
            markerpenAlpha = 0.02
            lineColor! = (lineColor?.colorWithAlphaComponent(CGFloat(markerpenAlpha)))!
            lineCapStyle! = .Square
            markerpenIsOff = false
        default:
            lineColor! = UIColor.whiteColor()
            lineCapStyle! = .Square
            markerpenIsOff = false
        }
    }

    func colorlag (value:String) {
        
        if lastOptIsEraser {
            lineColor = tempColor!
            lastOptIsEraser = false
        }
        switch value {
        case "E":
            tempColor = lineColor!
            lastOptIsEraser = true
        default: break
        }
        
    }
    
    /**
     画图
     */
    func changeImage(){
        
        if let drawingStateChangedBlock = self.drawingStateChangedBlock {
            drawingStateChangedBlock(state: self.drawingState)
        }
        
        UIGraphicsBeginImageContextWithOptions(frame.size, false, 0)
        lastImage!.drawInRect(self.bounds)
        
        // 贝赛尔曲线的起始点和末尾点
        let tempPoint1 = CGPointMake((points[0].x+points[1].x)/2, (points[0].y+points[1].y)/2)
        let tempPoint2 = CGPointMake((points[1].x+points[2].x)/2, (points[1].y+points[2].y)/2)
        
        // 贝赛尔曲线的估算长度
        let x1 = abs(tempPoint1.x-tempPoint2.x)
        let x2 = abs(tempPoint1.y-tempPoint2.y)
        let len = Int(sqrt(pow(x1, 2) + pow(x2,2))*10)
        
        // 如果仅仅点击一下
        if len == 0 {
            let zeroPath = UIBezierPath(arcCenter: points[1], /* radius: maxWidth/2-2,*/ radius: customWidth/2, startAngle: 0, endAngle: CGFloat(M_PI)*2.0, clockwise: true)
            lineColor!.setFill()
            zeroPath.fill()
            // 绘图
            image = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            return
        }
        
        // 如果距离过短，直接画线
        if len < 1 {
            let zeroPath = UIBezierPath()
            zeroPath.moveToPoint(tempPoint1)
            zeroPath.addLineToPoint(tempPoint2)
            
            currentWidth += 0.05
            if currentWidth > maxWidth {currentWidth = maxWidth}
            if currentWidth < minWidth {currentWidth = minWidth}
            
            // 画线
            zeroPath.lineWidth = customWidth
            zeroPath.lineCapStyle = lineCapStyle!
            zeroPath.lineJoinStyle = .Round
            //            UIColor(white: 0, alpha: (currentWidth-minWidth)/maxWidth*0.6+0.2).setStroke()
            lineColor!.setStroke()
            zeroPath.stroke()
            
            image = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            return
        }
        
        // 目标半径
        let aimWidth:CGFloat = CGFloat(300)/CGFloat(len)*(maxWidth-minWidth)
        
        // 获取贝塞尔点集
        let curvePoints = AFBezierPath.curveFactorization(tempPoint1, toPoint: tempPoint2, controlPoints: [points[1]], count: len)
        
        // 画每条线段
        var lastPoint:CGPoint = tempPoint1
        for(var i=0;i<len+1;i++)
        {
            let bPath = UIBezierPath()
            bPath.moveToPoint(lastPoint)
            
            // 省略多余的点
            let delta = sqrt(pow(curvePoints[i].x-lastPoint.x, 2) + pow(curvePoints[i].y-lastPoint.y, 2))
            if delta < 1 {continue}
            
            lastPoint = CGPointMake(curvePoints[i].x, curvePoints[i].y)
            
            bPath.addLineToPoint(CGPointMake(curvePoints[i].x, curvePoints[i].y))
            
            // 计算当前点
            if currentWidth > aimWidth {
                currentWidth -= 0.05
            }else{
                currentWidth += 0.05
            }
            if currentWidth > maxWidth {currentWidth = maxWidth}
            if currentWidth < minWidth {currentWidth=minWidth}
            
            // 画线
//            bPath.lineWidth = currentWidth  //根据currentWidth 调整画出来线条的粗细
            bPath.lineWidth = customWidth
            bPath.lineCapStyle = lineCapStyle!
            bPath.lineJoinStyle = .Round
//            UIColor(white: 0, alpha: (currentWidth-minWidth)/maxWidth*0.3+0.1).setStroke() // 根据currentWidth 调整线条的透明度
            lineColor!.setStroke()
            bPath.stroke()
            
        }
        lastImage = UIGraphicsGetImageFromCurrentImageContext()
        let pointCount = Int(sqrt(pow(tempPoint2.x-points[2].x,2)+pow(tempPoint2.y-points[2].y,2)))*2
        let delX = (tempPoint2.x-points[2].x)/CGFloat(pointCount)
        let delY = (tempPoint2.y-points[2].y)/CGFloat(pointCount)
        
        var addRadius = currentWidth
        
        // 尾部线段
        for(var i=0;i<pointCount;i++)
        {
            let bpath = UIBezierPath()
            bpath.moveToPoint(lastPoint)
            
            let newPoint = CGPointMake(lastPoint.x-delX, lastPoint.y-delY)
            lastPoint = newPoint
            
            bpath.addLineToPoint(newPoint)
            
            // 计算当前点
            if addRadius > aimWidth {
                addRadius -= 0.02
            }else{
                addRadius += 0.02
            }
            if addRadius > maxWidth {addRadius = maxWidth}
            if addRadius < 0 {addRadius=0}
            
            // 画线
            //            bpath.lineWidth = addRadius
            bpath.lineWidth = customWidth
            bpath.lineCapStyle = lineCapStyle!
            bpath.lineJoinStyle = .Round
            //            UIColor(white: 0, alpha: (currentWidth-minWidth)/maxWidth*0.05+0.05).setStroke()
            lineColor!.setStroke()
            bpath.stroke()
        }
        
        image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
    }
}

// 触摸事件
extension PKCanvas {
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
            let touch = touches.first
            let p = touch!.locationInView(self)
        
        if editchange {
            points = [p,p,p]
            currentWidth = 13

            self.drawingState = .Began
            changeImage()
        }
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        let touch = touches.first
        let p = touch!.locationInView(self)
        
        if editchange {
            points = [points[1],points[2],p]
        
            self.drawingState = .Moved
        
            changeImage()
        }
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if editchange {
            lastImage = image
            self.drawingState = .Ended
            undoclear = true
        
            // 用 Ended 事件代替原先的 Began 事件
            if self.drawingState == .Ended {
                self.boardUndoManager.addImage(self.image!)
            }
        }
    }

    
}

/**
 *分解贝塞尔曲线
 */
class AFBezierPath {
    
    /**
     fromPoint:起始点
     toPoint:终止点
     controlPoints:控制点数组
     count:分解数量
     返回:分解的点集
     */
    class func curveFactorization(fromPoint:CGPoint, toPoint: CGPoint, controlPoints:[CGPoint], var count:Int) -> [CGPoint]{
        
        //如果分解数量为0，生成默认分解数量
        if count == 0 {
            let x1 = abs(fromPoint.x-toPoint.x)
            let x2 = abs(fromPoint.y-toPoint.y)
            count = Int(sqrt(pow(x1, 2) + pow(x2,2)))
        }
        
        // 贝赛尔曲线的计算
        var s:CGFloat = 0.0
        var t:[CGFloat] = [CGFloat]()
        let pc:CGFloat = 1/CGFloat(count)
        
        let power = controlPoints.count + 1
        
        for _ in 0...count+1 {t.append(s);s=s+pc}
        
        var newPoint:[CGPoint] = [CGPoint]()
        
        for i in 0...count+1 {
            
            var resultX = fromPoint.x * bezMaker(power, k:0, t:t[i])
                + toPoint.x * bezMaker(power, k:power, t:t[i])
            
            for j in 1...power-1 {
                resultX += controlPoints[j-1].x * bezMaker(power, k:j, t:t[i])
            }
            
            var resultY = fromPoint.y * bezMaker(power, k:0, t:t[i])
                + toPoint.y * bezMaker(power, k:power, t:t[i])
            
            for j in 1...power-1 {
                resultY += controlPoints[j-1].y * bezMaker(power, k:j, t:t[i])
            }
            
            newPoint.append(CGPointMake(resultX, resultY))
            
        }
        
        return newPoint
    }
    
    private class func comp(n:Int, k:Int) -> CGFloat{
        var s1:Int = 1
        var s2:Int = 1
        
        if k == 0 {return 1}
        
        for(var i=n;i>=n-k+1;i--) {s1=s1*i}
        for(var i=k;i>=2;i--) {s2=s2*i}
        
        return CGFloat(s1/s2)
    }
    
    private class func realPow(n:CGFloat, k:Int) -> CGFloat{
        if k==0 {return 1.0}
        return pow(n, CGFloat(k))
    }
    
    private class func bezMaker(n:Int, k:Int, t:CGFloat) -> CGFloat{
        return comp(n, k: k) * realPow(1-t, k: n-k) * realPow(t, k: k)
    }
}

