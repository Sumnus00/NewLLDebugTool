//定义一个Node对象
function Node(node,screenWidth, screenHeight) {
    console.log('start initNode')
    this.node = node
    this.screenWidth = screenWidth
    this.screenHeight = screenHeight
    console.log('end initNode')
}

Node.prototype.getParent = function () {
    console.log('start getParent')
    var parent = this.node.getParent()
    var parentNode = null
    if (parent) {
        parentNode = new Node(parent, this.screenWidth, this.screenHeight)
    }
    console.log('end getParent')
    return parentNode
}

Node.prototype.getChildren = function () {
    console.log('start getChildren')
    var rootNode = this.node
    var nodesArray = []
    getCurrentSceneAllNodeByRootNode(this , rootNode , nodesArray)
    console.log('end getChildren')
    return nodesArray
}

//haleli
Node.prototype.getVisibleAndTouchableChildren = function () {
    console.log('start getVisibleAndTouchableChildren')
    var rootNode = this.node
    var nodesArray = []
    getCurrentSceneVisibleAndTouchableNodeByRootNode(this , rootNode , nodesArray)
    console.log('end getVisibleAndTouchableChildren')
    return nodesArray
}

function getCurrentSceneAllNodeByRootNode(node , rootNode , nodesArray) {
    var childrens = rootNode.getChildren()
    if (childrens.length != 0) {
        for (var i in childrens) {
            nodesArray.push(new Node(childrens[i], node.screenWidth, node.screenHeight))
            if (childrens[i].getChildren().length != 0) {
                getCurrentSceneAllNodeByRootNode(node , childrens[i] , nodesArray)
            }
        }
    }
}

//haleli
function getCurrentSceneVisibleAndTouchableNodeByRootNode(node , rootNode , nodesArray) {
    var childrens = rootNode.getChildren()
    if (childrens.length != 0) {
        for (var i in childrens) {
            var child = new Node(childrens[i], node.screenWidth, node.screenHeight)
            if(child.getAttr('visible') && child.getAttr('touchable')) {
                nodesArray.push(child)
            }
            if (childrens[i].getChildren().length != 0) {
                getCurrentSceneVisibleAndTouchableNodeByRootNode(node, childrens[i], nodesArray)
            }
        }
    }
}

Node.prototype.getAttr = function (attrName) {
    console.log('start getAttr')
    switch(attrName) {
        case 'visible': {
            if (this.node.isVisible) {
                var visible = this.node.isVisible()
                if (!visible) {
                    console.log('end getAttr')
                    return false
                }
                var parent = this.node.getParent()
                while (parent) {
                    var parentVisible = parent.isVisible()
                    if (!parentVisible) {
                        console.log('end getAttr')
                        return false
                    }
                    parent = parent.getParent()
                }
                console.log('end getAttr')
                return true
            }
            else {
                console.log('end getAttr')
                return this.node._activeInHierarchy
            }
        }
        case 'name': {
            console.log('end getAttr')
            return this.node.getName() || '<no-name>'
        }
        case 'text': {
            for (var i in this.node._components) {
                var c = this.node._components[i]
                if (c.string !== undefined) {
                    console.log('end getAttr')
                    return c.string
                }
            }
        }
        case 'type': {
            var ntype = ''
            if (this.node._components) {
                for (var i = this.node._components.length - 1; i >= 0; i--) {
                    ntype = this.node._components[i].__classname__
                    if (ntype.startsWith('cc')) {
                        break
                    }
                }
            }
            if (!ntype) {
                ntype = this.node.__classname__ || this.node._className
            }
            if (!ntype) {
                if (this.node.constructor) {
                    ntype = this.node.constructor.name
                }
            }
            if (!ntype) {
                ntype = 'Object'
            }
            console.log('end getAttr')
            return ntype.replace(/\w+\./, '')
        }
        case 'pos': {
            //            // 转换成归一化坐标系，原点左上角
            //            var pos = this.node.convertToWorldSpaceAR(new cc.Vec2(0, 0))
            //            pos.x /= this.screenWidth
            //            pos.y /= this.screenHeight
            //            pos.y = 1 - pos.y
            //            console.log('end getAttr')
            //            return [pos.x, pos.y]
            //转化成屏幕坐标
            var t_matrix = this.node.getNodeToWorldTransformAR();
            if (cc.Camera.main && cc.Camera.main.containsNode(this.node)) {
                t_matrix = cc.affineTransformConcatIn(t_matrix, cc.Camera.main.viewMatrix);
            }
            var Vec2 = cc.Vec2 || cc.math.Vec2 || cc.math.Vec3;
            var point = cc.pointApplyAffineTransform(new Vec2(0, 0), t_matrix);
            
            //将GL坐标转化为屏幕坐标
            //cocos界面一般都是横屏
            //TODO 适配竖屏和刘海屏
            point.x /= this.screenWidth
            point.y /= this.screenHeight
            point.y = 1 - point.y
            return [point.x ,point.y]
            
        }
        case 'size': {
            // 转换成归一化坐标系
            var size = null
            if (this.node.getContentSize || this.node.contentSize) {
                size = new cc.Size(this.node.getContentSize())
            } else {
                size = new cc.Size(this.node.width, this.node.height)
            }
            size.width /= this.screenWidth
            size.height /= this.screenHeight
            console.log('end getAttr')
            return [size.width, size.height]
        }
        case 'scale': {
            console.log('end getAttr')
            return [this.node.getScaleX(), this.node.getScaleY()]
        }
        case 'anchorPoint': {
            var anchor = this.node.getAnchorPoint()
            console.log('end getAttr')
            return [anchor.x, 1 - anchor.y]
        }
        case 'zOrders': {
            console.log('end getAttr')
            return {
            local: this.node.getLocalZOrder(),
            global: this.node.getGlobalZOrder()
            }
        }
        case 'touchable': {
            isTouchEnabledFlag = false
            if (this.node.isTouchEnabled) {
                isTouchEnabledFlag = true
            }else if(this.node._touchListener){
                isTouchEnabledFlag = true
            }
            console.log('end getAttr')
            return isTouchEnabledFlag
        }
        case 'tag': {
            console.log('end getAttr')
            return this.node.getTag()
        }
        case 'enabled': {
            if (this.node.isEnabled) {
                console.log('end getAttr')
                return this.node.isEnabled()
            }
        }
        case 'rotation': {
            console.log('end getAttr')
            return this.node.getRotation()
        }
        default: {
            console.log('end getAttr')
            return undefined
        }
    }
}

Node.prototype.getAvailableAttributeNames = function () {
    console.log('start getAvailableAttributeNames')
    return ["name" , "type" , "visible" , "pos" , "size" , "scale" , "anchorPoint" , "zOrders",'text' , 'touchable' , 'enabled' , 'tag' , 'rotation']
    console.log('end getAvailableAttributeNames')
}

//haleli
Node.prototype.getUserDefineAttributeNames = function () {
    console.log('start getUserDefineAttributeNames')
    return ["name" , "type" , "visible" , "pos" , "touchable"]
    console.log('end getUserDefineAttributeNames')
}

Node.prototype.enumerateAttrs = function () {
    // :rettype: Iterable<string, ValueType>
    var ret = {}
    var allAttrNames = this.getAvailableAttributeNames()
    for (var i in allAttrNames) {
        var attrName = allAttrNames[i]
        var attrVal = this.getAttr(attrName)
        if (attrVal !== undefined) {
            ret[attrName] = attrVal
        }
    }
    return ret
}

//haleli
Node.prototype.enumerateUserDefineAttrs = function () {
    // :rettype: Iterable<string, ValueType>
    var ret = {}
    var allAttrNames = this.getUserDefineAttributeNames()
    for (var i in allAttrNames) {
        var attrName = allAttrNames[i]
        var attrVal = this.getAttr(attrName)
        if (attrVal !== undefined) {
            ret[attrName] = attrVal
        }
    }
    return ret
}

function Dumper() {
    console.log('start initDumper')
    console.log('end initDumper')
}

function getCCDirector() {
    return cc.director
}

function getCurrentScene() {
    console.log('start getCurrentScene')
    var scene = null
    if (getCCDirector().getScene) {
        scene = getCCDirector().getScene()
    }
    else {
        scene = getCCDirector().getRunningScene()
    }
    console.log('end getCurrentScene')
    return scene
}

function getCurrWinsize() {
    console.log('start getCurrWinsize')
    var currentWinSizeWidth = getCCDirector().getWinSize().width
    var currentWinSizeHeight = getCCDirector().getWinSize().height
    console.log('end getCurrWinsize')
    return [currentWinSizeWidth , currentWinSizeHeight]
}

Dumper.prototype.getRoot = function () {
    console.log('start getRoot')
    var currentScene = getCurrentScene()
    var currentWinSizeWidth = getCurrWinsize()[0]
    var currentWinSizeHeight = getCurrWinsize()[1]
    var node = new Node(currentScene, currentWinSizeWidth, currentWinSizeHeight)
    console.log('end getRoot')
    return node
}

Dumper.prototype.dumpHierarchy = function () {
    return JSON.stringify(this.dumpHierarchyImpl(this.getRoot()))
}

//haleli
Dumper.prototype.dumpVisibleAndTouchableNode = function () {
    return JSON.stringify(this.dumpVisibleAndTouchableNodeImpl(this.getRoot()))
}

Dumper.prototype.dumpHierarchyImpl = function (node, onlyVisibleNode) {
    if (!node) {
        return null
    }
    if (onlyVisibleNode === undefined) {
        onlyVisibleNode = true
    }
    var payload = node.enumerateAttrs()
    var result = {}
    var children = []
    var nodeChildren = node.getChildren()
    for (var i in nodeChildren) {
        var child = nodeChildren[i]
        if (!onlyVisibleNode || (payload['visible'] || child.getAttr('visible'))) {
            children.push(this.dumpHierarchyImpl(child, onlyVisibleNode))
        }
    }
    if (children.length > 0) {
        result['children'] = children
    }
    result['name'] = payload['name'] || node.getAttr('name')
    result['payload'] = payload
    
    return result
}

//haleli
Dumper.prototype.dumpVisibleAndTouchableNodeImpl = function (node, onlyVisibleNode,onlyTouchableNode) {
    if (!node) {
        return null
    }
    if (onlyVisibleNode === undefined) {
        onlyVisibleNode = true
    }
    
    if (onlyTouchableNode === undefined) {
        onlyTouchableNode = true
    }
    
    var payload = node.enumerateUserDefineAttrs()
    var result = {}
    var children = []
    var nodeChildren = node.getVisibleAndTouchableChildren()
    for (var i in nodeChildren) {
        var child = nodeChildren[i]
        if (!onlyVisibleNode || (payload['visible'] || child.getAttr('visible'))) {
            if(!onlyTouchableNode || (payload['touchable'] || child.getAttr('touchable'))){
                if(child.getAttr('pos')[0] < 1 && child.getAttr('pos')[0] > 0 && child.getAttr('pos')[1] < 1 && child.getAttr('pos')[1] > 0){
                    var child_payload = child.enumerateUserDefineAttrs()
                    var child_result = {}
                    child_result['name'] = child_payload['name'] || child.getAttr('name')
                    child_result['payload'] = child_payload
                    children.push(child_result)
                }
            }
        }
    }
    if (children.length > 0) {
        result['children'] = children
    }
    result['name'] = payload['name'] || node.getAttr('name')
    result['payload'] = payload
    
    return result
}

//haleli
window.mydriver = {
    dumpHierarchy:function() {
        dumper = new Dumper()
        return dumper.dumpHierarchy()
    },
    
    dumpVisibleAndTouchableNode:function() {
        dumper = new Dumper()
        return dumper.dumpVisibleAndTouchableNode()
    }
}
