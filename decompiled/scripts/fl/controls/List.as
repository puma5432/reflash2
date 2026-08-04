package fl.controls
{
   import fl.controls.listClasses.*;
   import fl.core.*;
   import fl.managers.*;
   import flash.display.*;
   import flash.events.*;
   import flash.geom.Rectangle;
   import flash.ui.*;
   import flash.utils.*;
   
   public class List extends SelectableList implements IFocusManagerComponent
   {
      
      public static var createAccessibilityImplementation:Function;
      
      private static var defaultStyles:Object = {
         "focusRectSkin":null,
         "focusRectPadding":null
      };
      
      protected var _rowHeight:Number = 20;
      
      protected var _cellRenderer:Object;
      
      protected var _labelField:String = "label";
      
      protected var _labelFunction:Function;
      
      protected var _iconField:String = "icon";
      
      protected var _iconFunction:Function;
      
      public function List()
      {
         super();
      }
      
      public static function getStyleDefinition() : Object
      {
         return mergeStyles(defaultStyles,SelectableList.getStyleDefinition());
      }
      
      public function get labelField() : String
      {
         return this._labelField;
      }
      
      public function set labelField(param1:String) : void
      {
         if(param1 == this._labelField)
         {
            return;
         }
         this._labelField = param1;
         invalidate(InvalidationType.DATA);
      }
      
      public function get labelFunction() : Function
      {
         return this._labelFunction;
      }
      
      public function set labelFunction(param1:Function) : void
      {
         if(this._labelFunction == param1)
         {
            return;
         }
         this._labelFunction = param1;
         invalidate(InvalidationType.DATA);
      }
      
      public function get iconField() : String
      {
         return this._iconField;
      }
      
      public function set iconField(param1:String) : void
      {
         if(param1 == this._iconField)
         {
            return;
         }
         this._iconField = param1;
         invalidate(InvalidationType.DATA);
      }
      
      public function get iconFunction() : Function
      {
         return this._iconFunction;
      }
      
      public function set iconFunction(param1:Function) : void
      {
         if(this._iconFunction == param1)
         {
            return;
         }
         this._iconFunction = param1;
         invalidate(InvalidationType.DATA);
      }
      
      override public function get rowCount() : uint
      {
         return Math.ceil(this.calculateAvailableHeight() / this.rowHeight);
      }
      
      public function set rowCount(param1:uint) : void
      {
         var _loc2_:Number = Number(getStyleValue("contentPadding"));
         var _loc3_:Number = _horizontalScrollPolicy == ScrollPolicy.ON || _horizontalScrollPolicy == ScrollPolicy.AUTO && _maxHorizontalScrollPosition > 0 ? 15 : 0;
         height = this.rowHeight * param1 + 2 * _loc2_ + _loc3_;
      }
      
      public function get rowHeight() : Number
      {
         return this._rowHeight;
      }
      
      public function set rowHeight(param1:Number) : void
      {
         this._rowHeight = param1;
         invalidate(InvalidationType.SIZE);
      }
      
      override public function scrollToIndex(param1:int) : void
      {
         drawNow();
         var _loc2_:uint = uint(Math.floor((_verticalScrollPosition + availableHeight) / this.rowHeight) - 1);
         var _loc3_:uint = uint(Math.ceil(_verticalScrollPosition / this.rowHeight));
         if(param1 < _loc3_)
         {
            verticalScrollPosition = param1 * this.rowHeight;
         }
         else if(param1 > _loc2_)
         {
            verticalScrollPosition = (param1 + 1) * this.rowHeight - availableHeight;
         }
      }
      
      override protected function configUI() : void
      {
         useFixedHorizontalScrolling = true;
         _horizontalScrollPolicy = ScrollPolicy.AUTO;
         _verticalScrollPolicy = ScrollPolicy.AUTO;
         super.configUI();
      }
      
      protected function calculateAvailableHeight() : Number
      {
         var _loc1_:Number = Number(getStyleValue("contentPadding"));
         return height - _loc1_ * 2 - (_horizontalScrollPolicy == ScrollPolicy.ON || _horizontalScrollPolicy == ScrollPolicy.AUTO && _maxHorizontalScrollPosition > 0 ? 15 : 0);
      }
      
      override protected function setHorizontalScrollPosition(param1:Number, param2:Boolean = false) : void
      {
         list.x = -param1;
         super.setHorizontalScrollPosition(param1,true);
      }
      
      override protected function setVerticalScrollPosition(param1:Number, param2:Boolean = false) : void
      {
         invalidate(InvalidationType.SCROLL);
         super.setVerticalScrollPosition(param1,true);
      }
      
      override protected function draw() : void
      {
         var _loc1_:Boolean = contentHeight != this.rowHeight * length;
         contentHeight = this.rowHeight * length;
         if(isInvalid(InvalidationType.STYLES))
         {
            setStyles();
            drawBackground();
            if(contentPadding != getStyleValue("contentPadding"))
            {
               invalidate(InvalidationType.SIZE,false);
            }
            if(this._cellRenderer != getStyleValue("cellRenderer"))
            {
               _invalidateList();
               this._cellRenderer = getStyleValue("cellRenderer");
            }
         }
         if(isInvalid(InvalidationType.SIZE,InvalidationType.STATE) || _loc1_)
         {
            drawLayout();
         }
         if(isInvalid(InvalidationType.RENDERER_STYLES))
         {
            updateRendererStyles();
         }
         if(isInvalid(InvalidationType.STYLES,InvalidationType.SIZE,InvalidationType.DATA,InvalidationType.SCROLL,InvalidationType.SELECTED))
         {
            this.drawList();
         }
         updateChildren();
         validate();
      }
      
      override protected function drawList() : void
      {
         var _loc1_:uint = 0;
         var _loc2_:Object = null;
         var _loc3_:ICellRenderer = null;
         var _loc4_:Boolean = false;
         var _loc5_:String = null;
         var _loc6_:Object = null;
         var _loc7_:Sprite = null;
         var _loc8_:String = null;
         var _loc14_:* = undefined;
         listHolder.x = listHolder.y = contentPadding;
         var _loc9_:Rectangle = listHolder.scrollRect;
         _loc9_.x = _horizontalScrollPosition;
         _loc9_.y = Math.floor(_verticalScrollPosition) % this.rowHeight;
         listHolder.scrollRect = _loc9_;
         listHolder.cacheAsBitmap = useBitmapScrolling;
         var _loc10_:uint = uint(Math.floor(_verticalScrollPosition / this.rowHeight));
         var _loc11_:uint = Math.min(length,_loc10_ + this.rowCount + 1);
         var _loc12_:Dictionary = renderedItems = new Dictionary(true);
         _loc1_ = _loc10_;
         while(_loc1_ < _loc11_)
         {
            _loc12_[_dataProvider.getItemAt(_loc1_)] = true;
            _loc1_++;
         }
         var _loc13_:Dictionary = new Dictionary(true);
         while(activeCellRenderers.length > 0)
         {
            _loc3_ = activeCellRenderers.pop() as ICellRenderer;
            _loc2_ = _loc3_.data;
            if(_loc12_[_loc2_] == null || invalidItems[_loc2_] == true)
            {
               availableCellRenderers.push(_loc3_);
            }
            else
            {
               _loc13_[_loc2_] = _loc3_;
               invalidItems[_loc2_] = true;
            }
            list.removeChild(_loc3_ as DisplayObject);
         }
         invalidItems = new Dictionary(true);
         _loc1_ = _loc10_;
         while(_loc1_ < _loc11_)
         {
            _loc4_ = false;
            _loc2_ = _dataProvider.getItemAt(_loc1_);
            if(_loc13_[_loc2_] != null)
            {
               _loc4_ = true;
               _loc3_ = _loc13_[_loc2_];
               delete _loc13_[_loc2_];
            }
            else if(availableCellRenderers.length > 0)
            {
               _loc3_ = availableCellRenderers.pop() as ICellRenderer;
            }
            else
            {
               _loc3_ = getDisplayObjectInstance(getStyleValue("cellRenderer")) as ICellRenderer;
               _loc7_ = _loc3_ as Sprite;
               if(_loc7_ != null)
               {
                  _loc7_.addEventListener(MouseEvent.CLICK,handleCellRendererClick,false,0,true);
                  _loc7_.addEventListener(MouseEvent.ROLL_OVER,handleCellRendererMouseEvent,false,0,true);
                  _loc7_.addEventListener(MouseEvent.ROLL_OUT,handleCellRendererMouseEvent,false,0,true);
                  _loc7_.addEventListener(Event.CHANGE,handleCellRendererChange,false,0,true);
                  _loc7_.doubleClickEnabled = true;
                  _loc7_.addEventListener(MouseEvent.DOUBLE_CLICK,handleCellRendererDoubleClick,false,0,true);
                  if(_loc7_.hasOwnProperty("setStyle"))
                  {
                     for(_loc8_ in rendererStyles)
                     {
                        _loc14_ = _loc7_;
                        _loc14_["setStyle"](_loc8_,rendererStyles[_loc8_]);
                     }
                  }
               }
            }
            list.addChild(_loc3_ as Sprite);
            activeCellRenderers.push(_loc3_);
            _loc3_.y = this.rowHeight * (_loc1_ - _loc10_);
            _loc3_.setSize(availableWidth + _maxHorizontalScrollPosition,this.rowHeight);
            _loc5_ = this.itemToLabel(_loc2_);
            _loc6_ = null;
            if(this._iconFunction != null)
            {
               _loc6_ = this._iconFunction(_loc2_);
            }
            else if(this._iconField != null)
            {
               _loc6_ = _loc2_[this._iconField];
            }
            if(!_loc4_)
            {
               _loc3_.data = _loc2_;
            }
            _loc3_.listData = new ListData(_loc5_,_loc6_,this,_loc1_,_loc1_,0);
            _loc3_.selected = _selectedIndices.indexOf(_loc1_) != -1;
            if(_loc3_ is UIComponent)
            {
               (_loc3_ as UIComponent).drawNow();
            }
            _loc1_++;
         }
      }
      
      override protected function keyDownHandler(param1:KeyboardEvent) : void
      {
         var _loc2_:int = 0;
         if(!selectable)
         {
            return;
         }
         switch(param1.keyCode)
         {
            case Keyboard.UP:
            case Keyboard.DOWN:
            case Keyboard.END:
            case Keyboard.HOME:
            case Keyboard.PAGE_UP:
            case Keyboard.PAGE_DOWN:
               this.moveSelectionVertically(param1.keyCode,param1.shiftKey && _allowMultipleSelection,param1.ctrlKey && _allowMultipleSelection);
               break;
            case Keyboard.LEFT:
            case Keyboard.RIGHT:
               this.moveSelectionHorizontally(param1.keyCode,param1.shiftKey && _allowMultipleSelection,param1.ctrlKey && _allowMultipleSelection);
               break;
            case Keyboard.SPACE:
               if(caretIndex == -1)
               {
                  caretIndex = 0;
               }
               this.doKeySelection(caretIndex,param1.shiftKey,param1.ctrlKey);
               scrollToSelected();
               break;
            default:
               _loc2_ = getNextIndexAtLetter(String.fromCharCode(param1.keyCode),selectedIndex);
               if(_loc2_ > -1)
               {
                  selectedIndex = _loc2_;
                  scrollToSelected();
               }
         }
         param1.stopPropagation();
      }
      
      override protected function moveSelectionHorizontally(param1:uint, param2:Boolean, param3:Boolean) : void
      {
      }
      
      override protected function moveSelectionVertically(param1:uint, param2:Boolean, param3:Boolean) : void
      {
         var _loc6_:int = 0;
         var _loc4_:int = int(Math.max(Math.floor(this.calculateAvailableHeight() / this.rowHeight),1));
         var _loc5_:int = -1;
         switch(param1)
         {
            case Keyboard.UP:
               if(caretIndex > 0)
               {
                  _loc5_ = caretIndex - 1;
               }
               break;
            case Keyboard.DOWN:
               if(caretIndex < length - 1)
               {
                  _loc5_ = caretIndex + 1;
               }
               break;
            case Keyboard.PAGE_UP:
               if(caretIndex > 0)
               {
                  _loc5_ = Math.max(caretIndex - _loc4_,0);
               }
               break;
            case Keyboard.PAGE_DOWN:
               if(caretIndex < length - 1)
               {
                  _loc5_ = Math.min(caretIndex + _loc4_,length - 1);
               }
               break;
            case Keyboard.HOME:
               if(caretIndex > 0)
               {
                  _loc5_ = 0;
               }
               break;
            case Keyboard.END:
               if(caretIndex < length - 1)
               {
                  _loc5_ = length - 1;
               }
         }
         if(_loc5_ >= 0)
         {
            this.doKeySelection(_loc5_,param2,param3);
            scrollToSelected();
         }
      }
      
      protected function doKeySelection(param1:int, param2:Boolean, param3:Boolean) : void
      {
         var _loc4_:int = 0;
         var _loc5_:Array = null;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc8_:Boolean = false;
         if(param2)
         {
            _loc5_ = [];
            _loc6_ = lastCaretIndex;
            _loc7_ = param1;
            if(_loc6_ == -1)
            {
               _loc6_ = caretIndex != -1 ? caretIndex : param1;
            }
            if(_loc6_ > _loc7_)
            {
               _loc7_ = _loc6_;
               _loc6_ = param1;
            }
            _loc4_ = _loc6_;
            while(_loc4_ <= _loc7_)
            {
               _loc5_.push(_loc4_);
               _loc4_++;
            }
            selectedIndices = _loc5_;
            caretIndex = param1;
            _loc8_ = true;
         }
         else
         {
            selectedIndex = param1;
            caretIndex = lastCaretIndex = param1;
            _loc8_ = true;
         }
         if(_loc8_)
         {
            dispatchEvent(new Event(Event.CHANGE));
         }
         invalidate(InvalidationType.DATA);
      }
      
      override public function itemToLabel(param1:Object) : String
      {
         if(this._labelFunction != null)
         {
            return String(this._labelFunction(param1));
         }
         return param1[this._labelField] != null ? String(param1[this._labelField]) : "";
      }
      
      override protected function initializeAccessibility() : void
      {
         if(List.createAccessibilityImplementation != null)
         {
            List.createAccessibilityImplementation(this);
         }
      }
   }
}

