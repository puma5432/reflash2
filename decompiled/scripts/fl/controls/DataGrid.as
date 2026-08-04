package fl.controls
{
   import fl.controls.dataGridClasses.*;
   import fl.controls.listClasses.*;
   import fl.core.*;
   import fl.data.DataProvider;
   import fl.events.*;
   import fl.managers.*;
   import flash.display.*;
   import flash.events.*;
   import flash.geom.*;
   import flash.ui.*;
   import flash.utils.*;
   
   public class DataGrid extends SelectableList implements IFocusManagerComponent
   {
      
      public static var createAccessibilityImplementation:Function;
      
      private static var defaultStyles:Object = {
         "headerUpSkin":"HeaderRenderer_upSkin",
         "headerDownSkin":"HeaderRenderer_downSkin",
         "headerOverSkin":"HeaderRenderer_overSkin",
         "headerDisabledSkin":"HeaderRenderer_disabledSkin",
         "headerSortArrowDescSkin":"HeaderSortArrow_descIcon",
         "headerSortArrowAscSkin":"HeaderSortArrow_ascIcon",
         "columnStretchCursorSkin":"ColumnStretch_cursor",
         "columnDividerSkin":null,
         "headerTextFormat":null,
         "headerDisabledTextFormat":null,
         "headerTextPadding":5,
         "headerRenderer":HeaderRenderer,
         "focusRectSkin":null,
         "focusRectPadding":null,
         "skin":"DataGrid_skin"
      };
      
      protected static const HEADER_STYLES:Object = {
         "disabledSkin":"headerDisabledSkin",
         "downSkin":"headerDownSkin",
         "overSkin":"headerOverSkin",
         "upSkin":"headerUpSkin",
         "textFormat":"headerTextFormat",
         "disabledTextFormat":"headerDisabledTextFormat",
         "textPadding":"headerTextPadding"
      };
      
      protected var _rowHeight:Number = 20;
      
      protected var _headerHeight:Number = 25;
      
      protected var _showHeaders:Boolean = true;
      
      protected var _columns:Array;
      
      protected var _minColumnWidth:Number;
      
      protected var header:Sprite;
      
      protected var headerMask:Sprite;
      
      protected var headerSortArrow:Sprite;
      
      protected var _cellRenderer:Object;
      
      protected var _headerRenderer:Object;
      
      protected var _labelFunction:Function;
      
      protected var visibleColumns:Array;
      
      protected var displayableColumns:Array;
      
      protected var columnsInvalid:Boolean = true;
      
      protected var minColumnWidthInvalid:Boolean = false;
      
      protected var activeCellRenderersMap:Dictionary;
      
      protected var availableCellRenderersMap:Dictionary;
      
      protected var dragHandlesMap:Dictionary;
      
      protected var columnStretchIndex:Number = -1;
      
      protected var columnStretchStartX:Number;
      
      protected var columnStretchStartWidth:Number;
      
      protected var columnStretchCursor:Sprite;
      
      protected var _sortIndex:int = -1;
      
      protected var lastSortIndex:int = -1;
      
      protected var _sortDescending:Boolean = false;
      
      protected var _editedItemPosition:Object;
      
      protected var editedItemPositionChanged:Boolean = false;
      
      protected var proposedEditedItemPosition:*;
      
      protected var actualRowIndex:int;
      
      protected var actualColIndex:int;
      
      protected var isPressed:Boolean = false;
      
      protected var losingFocus:Boolean = false;
      
      protected var maxHeaderHeight:Number = 25;
      
      protected var currentHoveredRow:int = -1;
      
      public var editable:Boolean = false;
      
      public var resizableColumns:Boolean = true;
      
      public var sortableColumns:Boolean = true;
      
      public var itemEditorInstance:Object;
      
      public function DataGrid()
      {
         super();
         if(this._columns == null)
         {
            this._columns = [];
         }
         _horizontalScrollPolicy = ScrollPolicy.OFF;
         this.activeCellRenderersMap = new Dictionary(true);
         this.availableCellRenderersMap = new Dictionary(true);
         addEventListener(DataGridEvent.ITEM_EDIT_BEGINNING,this.itemEditorItemEditBeginningHandler,false,-50);
         addEventListener(DataGridEvent.ITEM_EDIT_BEGIN,this.itemEditorItemEditBeginHandler,false,-50);
         addEventListener(DataGridEvent.ITEM_EDIT_END,this.itemEditorItemEditEndHandler,false,-50);
         addEventListener(MouseEvent.MOUSE_DOWN,this.mouseDownHandler);
         addEventListener(MouseEvent.MOUSE_UP,this.mouseUpHandler);
      }
      
      public static function getStyleDefinition() : Object
      {
         return mergeStyles(defaultStyles,SelectableList.getStyleDefinition(),ScrollBar.getStyleDefinition());
      }
      
      override public function set dataProvider(param1:DataProvider) : void
      {
         super.dataProvider = param1;
         if(this._columns == null)
         {
            this._columns = [];
         }
         if(this._columns.length == 0)
         {
            this.createColumnsFromDataProvider();
         }
         this.removeCellRenderers();
      }
      
      override public function set enabled(param1:Boolean) : void
      {
         super.enabled = param1;
         this.header.mouseChildren = _enabled;
      }
      
      override public function setSize(param1:Number, param2:Number) : void
      {
         super.setSize(param1,param2);
         this.columnsInvalid = true;
      }
      
      override public function get horizontalScrollPolicy() : String
      {
         return _horizontalScrollPolicy;
      }
      
      override public function set horizontalScrollPolicy(param1:String) : void
      {
         super.horizontalScrollPolicy = param1;
         this.columnsInvalid = true;
      }
      
      public function get columns() : Array
      {
         return this._columns.slice(0);
      }
      
      public function set columns(param1:Array) : void
      {
         var _loc2_:uint = 0;
         this.removeCellRenderers();
         this._columns = [];
         while(_loc2_ < param1.length)
         {
            this.addColumn(param1[_loc2_]);
            _loc2_++;
         }
      }
      
      public function get minColumnWidth() : Number
      {
         return this._minColumnWidth;
      }
      
      public function set minColumnWidth(param1:Number) : void
      {
         this._minColumnWidth = param1;
         this.columnsInvalid = true;
         this.minColumnWidthInvalid = true;
         invalidate(InvalidationType.SIZE);
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
      
      override public function get rowCount() : uint
      {
         return Math.ceil(this.calculateAvailableHeight() / this.rowHeight);
      }
      
      public function set rowCount(param1:uint) : void
      {
         var _loc2_:Number = Number(getStyleValue("contentPadding"));
         var _loc3_:Number = _horizontalScrollPolicy == ScrollPolicy.ON || _horizontalScrollPolicy == ScrollPolicy.AUTO && hScrollBar ? 15 : 0;
         height = this.rowHeight * param1 + 2 * _loc2_ + _loc3_ + (this.showHeaders ? this.headerHeight : 0);
      }
      
      public function get rowHeight() : Number
      {
         return this._rowHeight;
      }
      
      public function set rowHeight(param1:Number) : void
      {
         this._rowHeight = Math.max(0,param1);
         invalidate(InvalidationType.SIZE);
      }
      
      public function get headerHeight() : Number
      {
         return this._headerHeight;
      }
      
      public function set headerHeight(param1:Number) : void
      {
         this.maxHeaderHeight = param1;
         this._headerHeight = Math.max(0,param1);
         invalidate(InvalidationType.SIZE);
      }
      
      public function get showHeaders() : Boolean
      {
         return this._showHeaders;
      }
      
      public function set showHeaders(param1:Boolean) : void
      {
         this._showHeaders = param1;
         invalidate(InvalidationType.SIZE);
      }
      
      public function get sortIndex() : int
      {
         return this._sortIndex;
      }
      
      public function get sortDescending() : Boolean
      {
         return this._sortDescending;
      }
      
      public function get imeMode() : String
      {
         return _imeMode;
      }
      
      public function set imeMode(param1:String) : void
      {
         _imeMode = param1;
      }
      
      public function get editedItemRenderer() : ICellRenderer
      {
         if(!this.itemEditorInstance)
         {
            return null;
         }
         return this.getCellRendererAt(this.actualRowIndex,this.actualColIndex);
      }
      
      public function get editedItemPosition() : Object
      {
         if(this._editedItemPosition)
         {
            return {
               "rowIndex":this._editedItemPosition.rowIndex,
               "columnIndex":this._editedItemPosition.columnIndex
            };
         }
         return this._editedItemPosition;
      }
      
      public function set editedItemPosition(param1:Object) : void
      {
         var _loc2_:Object = {
            "rowIndex":param1.rowIndex,
            "columnIndex":param1.columnIndex
         };
         this.setEditedItemPosition(_loc2_);
      }
      
      protected function calculateAvailableHeight() : Number
      {
         var _loc1_:Number = Number(getStyleValue("contentPadding"));
         var _loc2_:Number = _horizontalScrollPolicy == ScrollPolicy.ON || _horizontalScrollPolicy == ScrollPolicy.AUTO && _maxHorizontalScrollPosition > 0 ? 15 : 0;
         return height - _loc1_ * 2 - _loc2_ - (this.showHeaders ? this.headerHeight : 0);
      }
      
      public function addColumn(param1:*) : DataGridColumn
      {
         return this.addColumnAt(param1,this._columns.length);
      }
      
      public function addColumnAt(param1:*, param2:uint) : DataGridColumn
      {
         var _loc3_:DataGridColumn = null;
         var _loc4_:uint = 0;
         if(param2 < this._columns.length)
         {
            this._columns.splice(param2,0,"");
            _loc4_ = param2 + 1;
            while(_loc4_ < this._columns.length)
            {
               _loc3_ = this._columns[_loc4_] as DataGridColumn;
               _loc3_.colNum = _loc4_;
               _loc4_++;
            }
         }
         var _loc5_:* = param1;
         if(!(_loc5_ is DataGridColumn))
         {
            if(_loc5_ is String)
            {
               _loc5_ = new DataGridColumn(_loc5_);
            }
            else
            {
               _loc5_ = new DataGridColumn();
            }
         }
         _loc3_ = _loc5_ as DataGridColumn;
         _loc3_.owner = this;
         _loc3_.colNum = param2;
         this._columns[param2] = _loc3_;
         invalidate(InvalidationType.SIZE);
         this.columnsInvalid = true;
         return _loc3_;
      }
      
      public function removeColumnAt(param1:uint) : DataGridColumn
      {
         var _loc2_:uint = 0;
         var _loc3_:DataGridColumn = this._columns[param1] as DataGridColumn;
         if(_loc3_ != null)
         {
            this.removeCellRenderersByColumn(_loc3_);
            this._columns.splice(param1,1);
            _loc2_ = param1;
            while(_loc2_ < this._columns.length)
            {
               _loc3_ = this._columns[_loc2_] as DataGridColumn;
               if(_loc3_)
               {
                  _loc3_.colNum = _loc2_;
               }
               _loc2_++;
            }
            invalidate(InvalidationType.SIZE);
            this.columnsInvalid = true;
         }
         return _loc3_;
      }
      
      public function removeAllColumns() : void
      {
         if(this._columns.length > 0)
         {
            this.removeCellRenderers();
            this._columns = [];
            invalidate(InvalidationType.SIZE);
            this.columnsInvalid = true;
         }
      }
      
      public function getColumnAt(param1:uint) : DataGridColumn
      {
         return this._columns[param1] as DataGridColumn;
      }
      
      public function getColumnIndex(param1:String) : int
      {
         var _loc2_:DataGridColumn = null;
         var _loc3_:uint = 0;
         while(_loc3_ < this._columns.length)
         {
            _loc2_ = this._columns[_loc3_] as DataGridColumn;
            if(_loc2_.dataField == param1)
            {
               return _loc3_;
            }
            _loc3_++;
         }
         return -1;
      }
      
      public function getColumnCount() : uint
      {
         return this._columns.length;
      }
      
      public function spaceColumnsEqually() : void
      {
         var _loc1_:Number = NaN;
         var _loc2_:int = 0;
         var _loc3_:DataGridColumn = null;
         drawNow();
         if(this.displayableColumns.length > 0)
         {
            _loc1_ = availableWidth / this.displayableColumns.length;
            _loc2_ = 0;
            while(_loc2_ < this.displayableColumns.length)
            {
               _loc3_ = this.displayableColumns[_loc2_] as DataGridColumn;
               _loc3_.width = _loc1_;
               _loc2_++;
            }
            invalidate(InvalidationType.SIZE);
            this.columnsInvalid = true;
         }
      }
      
      public function editField(param1:uint, param2:String, param3:Object) : void
      {
         var _loc4_:Object = getItemAt(param1);
         _loc4_[param2] = param3;
         replaceItemAt(_loc4_,param1);
      }
      
      override public function itemToCellRenderer(param1:Object) : ICellRenderer
      {
         return null;
      }
      
      override protected function configUI() : void
      {
         useFixedHorizontalScrolling = false;
         super.configUI();
         this.headerMask = new Sprite();
         var _loc1_:Graphics = this.headerMask.graphics;
         _loc1_.beginFill(0,0.3);
         _loc1_.drawRect(0,0,100,100);
         _loc1_.endFill();
         this.headerMask.visible = false;
         addChild(this.headerMask);
         this.header = new Sprite();
         addChild(this.header);
         this.header.mask = this.headerMask;
         _horizontalScrollPolicy = ScrollPolicy.OFF;
         _verticalScrollPolicy = ScrollPolicy.AUTO;
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
            if(this._cellRenderer != getStyleValue("cellRenderer") || this._headerRenderer != getStyleValue("headerRenderer"))
            {
               _invalidateList();
               this._cellRenderer = getStyleValue("cellRenderer");
               this._headerRenderer = getStyleValue("headerRenderer");
            }
         }
         if(isInvalid(InvalidationType.SIZE))
         {
            this.columnsInvalid = true;
         }
         if(isInvalid(InvalidationType.SIZE,InvalidationType.STATE) || _loc1_)
         {
            this.drawLayout();
            drawDisabledOverlay();
         }
         if(isInvalid(InvalidationType.RENDERER_STYLES))
         {
            this.updateRendererStyles();
         }
         if(isInvalid(InvalidationType.STYLES,InvalidationType.SIZE,InvalidationType.DATA,InvalidationType.SCROLL,InvalidationType.SELECTED))
         {
            this.drawList();
         }
         updateChildren();
         validate();
      }
      
      override protected function drawLayout() : void
      {
         vOffset = this.showHeaders ? this.headerHeight : 0;
         super.drawLayout();
         contentScrollRect = listHolder.scrollRect;
         if(this.showHeaders)
         {
            this.headerHeight = this.maxHeaderHeight;
            if(Math.floor(availableHeight - this.headerHeight) <= 0)
            {
               this._headerHeight = availableHeight;
            }
            list.y = this.headerHeight;
            contentScrollRect = listHolder.scrollRect;
            contentScrollRect.y = contentPadding + this.headerHeight;
            contentScrollRect.height = availableHeight - this.headerHeight;
            listHolder.y = contentPadding + this.headerHeight;
            this.headerMask.x = contentPadding;
            this.headerMask.y = contentPadding;
            this.headerMask.width = availableWidth;
            this.headerMask.height = this.headerHeight;
         }
         else
         {
            contentScrollRect.y = contentPadding;
            listHolder.y = 0;
         }
         listHolder.scrollRect = contentScrollRect;
      }
      
      override protected function drawList() : void
      {
         var _loc1_:Number = NaN;
         var _loc2_:Number = NaN;
         var _loc3_:uint = 0;
         var _loc4_:Object = null;
         var _loc5_:ICellRenderer = null;
         var _loc6_:Array = null;
         var _loc7_:DataGridColumn = null;
         var _loc8_:Sprite = null;
         var _loc9_:UIComponent = null;
         var _loc10_:Number = NaN;
         var _loc11_:DataGridColumn = null;
         var _loc12_:Object = null;
         var _loc13_:Array = null;
         var _loc14_:Dictionary = null;
         var _loc15_:Object = null;
         var _loc16_:HeaderRenderer = null;
         var _loc17_:Sprite = null;
         var _loc18_:Graphics = null;
         var _loc19_:Boolean = false;
         var _loc20_:String = null;
         var _loc28_:uint = 0;
         var _loc29_:* = undefined;
         if(this.showHeaders)
         {
            this.header.visible = true;
            this.header.x = contentPadding - _horizontalScrollPosition;
            this.header.y = contentPadding;
            listHolder.y = contentPadding + this.headerHeight;
            _loc10_ = Math.floor(availableHeight - this.headerHeight);
            _verticalScrollBar.setScrollProperties(_loc10_,0,contentHeight - _loc10_,_verticalScrollBar.pageScrollSize);
         }
         else
         {
            this.header.visible = false;
            listHolder.y = contentPadding;
         }
         listHolder.x = contentPadding;
         contentScrollRect = listHolder.scrollRect;
         contentScrollRect.x = _horizontalScrollPosition;
         contentScrollRect.y = vOffset + Math.floor(_verticalScrollPosition) % this.rowHeight;
         listHolder.scrollRect = contentScrollRect;
         listHolder.cacheAsBitmap = useBitmapScrolling;
         var _loc21_:uint = uint(Math.min(Math.max(length - 1,0),Math.floor(_verticalScrollPosition / this.rowHeight)));
         var _loc22_:uint = Math.min(Math.max(length - 1,0),_loc21_ + this.rowCount + 1);
         var _loc23_:Boolean = list.hitTestPoint(stage.mouseX,stage.mouseY);
         this.calculateColumnSizes();
         var _loc24_:Dictionary = renderedItems = new Dictionary(true);
         if(length > 0)
         {
            _loc3_ = _loc21_;
            while(_loc3_ <= _loc22_)
            {
               _loc24_[_dataProvider.getItemAt(_loc3_)] = true;
               _loc3_++;
            }
         }
         _loc1_ = 0;
         var _loc25_:DataGridColumn = this.visibleColumns[0] as DataGridColumn;
         _loc3_ = 0;
         while(_loc3_ < this.displayableColumns.length)
         {
            _loc11_ = this.displayableColumns[_loc3_] as DataGridColumn;
            if(_loc11_ == _loc25_)
            {
               break;
            }
            _loc1_ += _loc11_.width;
            _loc3_++;
         }
         while(this.header.numChildren > 0)
         {
            this.header.removeChildAt(0);
         }
         this.dragHandlesMap = new Dictionary(true);
         var _loc26_:Array = [];
         var _loc27_:uint = this.visibleColumns.length;
         while(_loc28_ < _loc27_)
         {
            _loc7_ = this.visibleColumns[_loc28_] as DataGridColumn;
            _loc26_.push(_loc7_.colNum);
            if(this.showHeaders)
            {
               _loc15_ = _loc7_.headerRenderer != null ? _loc7_.headerRenderer : this._headerRenderer;
               _loc16_ = getDisplayObjectInstance(_loc15_) as HeaderRenderer;
               if(_loc16_ != null)
               {
                  _loc16_.addEventListener(MouseEvent.CLICK,this.handleHeaderRendererClick,false,0,true);
                  _loc16_.x = _loc1_;
                  _loc16_.y = 0;
                  _loc16_.setSize(_loc7_.width,this.headerHeight);
                  _loc16_.column = _loc7_.colNum;
                  _loc16_.label = _loc7_.headerText;
                  this.header.addChildAt(_loc16_,_loc28_);
                  copyStylesToChild(_loc16_,HEADER_STYLES);
                  if(this.sortIndex == -1 && this.lastSortIndex == -1 || _loc7_.colNum != this.sortIndex)
                  {
                     _loc16_.setStyle("icon",null);
                  }
                  else
                  {
                     _loc16_.setStyle("icon",this.sortDescending ? getStyleValue("headerSortArrowAscSkin") : getStyleValue("headerSortArrowDescSkin"));
                  }
                  if(_loc28_ < _loc27_ - 1 && this.resizableColumns && _loc7_.resizable)
                  {
                     _loc17_ = new Sprite();
                     _loc18_ = _loc17_.graphics;
                     _loc18_.beginFill(0,0);
                     _loc18_.drawRect(0,0,3,this.headerHeight);
                     _loc18_.endFill();
                     _loc17_.x = _loc1_ + _loc7_.width - 2;
                     _loc17_.y = 0;
                     _loc17_.alpha = 0;
                     _loc17_.addEventListener(MouseEvent.MOUSE_OVER,this.handleHeaderResizeOver,false,0,true);
                     _loc17_.addEventListener(MouseEvent.MOUSE_OUT,this.handleHeaderResizeOut,false,0,true);
                     _loc17_.addEventListener(MouseEvent.MOUSE_DOWN,this.handleHeaderResizeDown,false,0,true);
                     this.header.addChild(_loc17_);
                     this.dragHandlesMap[_loc17_] = _loc7_.colNum;
                  }
                  if(_loc28_ == _loc27_ - 1 && _horizontalScrollPosition == 0 && availableWidth > _loc1_ + _loc7_.width)
                  {
                     _loc2_ = Math.floor(availableWidth - _loc1_);
                     _loc16_.setSize(_loc2_,this.headerHeight);
                  }
                  else
                  {
                     _loc2_ = _loc7_.width;
                  }
                  _loc16_.drawNow();
               }
            }
            _loc12_ = _loc7_.cellRenderer != null ? _loc7_.cellRenderer : this._cellRenderer;
            _loc13_ = this.availableCellRenderersMap[_loc7_];
            _loc6_ = this.activeCellRenderersMap[_loc7_];
            if(_loc6_ == null)
            {
               this.activeCellRenderersMap[_loc7_] = _loc6_ = [];
            }
            if(_loc13_ == null)
            {
               this.availableCellRenderersMap[_loc7_] = _loc13_ = [];
            }
            _loc14_ = new Dictionary(true);
            while(_loc6_.length > 0)
            {
               _loc5_ = _loc6_.pop();
               _loc4_ = _loc5_.data;
               if(_loc24_[_loc4_] == null || invalidItems[_loc4_] == true)
               {
                  _loc13_.push(_loc5_);
               }
               else
               {
                  _loc14_[_loc4_] = _loc5_;
                  invalidItems[_loc4_] = true;
               }
               list.removeChild(_loc5_ as DisplayObject);
            }
            if(length > 0)
            {
               _loc3_ = _loc21_;
               while(_loc3_ <= _loc22_)
               {
                  _loc19_ = false;
                  _loc4_ = _dataProvider.getItemAt(_loc3_);
                  if(_loc14_[_loc4_] != null)
                  {
                     _loc19_ = true;
                     _loc5_ = _loc14_[_loc4_];
                     delete _loc14_[_loc4_];
                  }
                  else if(_loc13_.length > 0)
                  {
                     _loc5_ = _loc13_.pop() as ICellRenderer;
                  }
                  else
                  {
                     _loc5_ = getDisplayObjectInstance(_loc12_) as ICellRenderer;
                     _loc8_ = _loc5_ as Sprite;
                     if(_loc8_ != null)
                     {
                        _loc8_.addEventListener(MouseEvent.CLICK,this.handleCellRendererClick,false,0,true);
                        _loc8_.addEventListener(MouseEvent.ROLL_OVER,this.handleCellRendererMouseEvent,false,0,true);
                        _loc8_.addEventListener(MouseEvent.ROLL_OUT,this.handleCellRendererMouseEvent,false,0,true);
                        _loc8_.addEventListener(Event.CHANGE,handleCellRendererChange,false,0,true);
                        _loc8_.doubleClickEnabled = true;
                        _loc8_.addEventListener(MouseEvent.DOUBLE_CLICK,handleCellRendererDoubleClick,false,0,true);
                        if(_loc8_["setStyle"] != null)
                        {
                           for(_loc20_ in rendererStyles)
                           {
                              _loc29_ = _loc8_;
                              _loc29_["setStyle"](_loc20_,rendererStyles[_loc20_]);
                           }
                        }
                     }
                  }
                  list.addChild(_loc5_ as Sprite);
                  _loc6_.push(_loc5_);
                  _loc5_.x = _loc1_;
                  _loc5_.y = this.rowHeight * (_loc3_ - _loc21_);
                  _loc5_.setSize(_loc28_ == _loc27_ - 1 ? _loc2_ : _loc7_.width,this.rowHeight);
                  if(!_loc19_)
                  {
                     _loc5_.data = _loc4_;
                  }
                  _loc5_.listData = new ListData(this.columnItemToLabel(_loc7_.colNum,_loc4_),null,this,_loc3_,_loc3_,_loc7_.colNum);
                  if(_loc23_ && this.isHovered(_loc5_))
                  {
                     _loc5_.setMouseState("over");
                     this.currentHoveredRow = _loc3_;
                  }
                  else
                  {
                     _loc5_.setMouseState("up");
                  }
                  _loc5_.selected = _selectedIndices.indexOf(_loc3_) != -1;
                  if(_loc5_ is UIComponent)
                  {
                     _loc9_ = _loc5_ as UIComponent;
                     _loc9_.drawNow();
                  }
                  _loc3_++;
               }
            }
            _loc1_ += _loc7_.width;
            _loc28_++;
         }
         _loc3_ = 0;
         while(_loc3_ < this._columns.length)
         {
            if(_loc26_.indexOf(_loc3_) == -1)
            {
               this.removeCellRenderersByColumn(this._columns[_loc3_] as DataGridColumn);
            }
            _loc3_++;
         }
         if(this.editedItemPositionChanged)
         {
            this.editedItemPositionChanged = false;
            this.commitEditedItemPosition(this.proposedEditedItemPosition);
            this.proposedEditedItemPosition = undefined;
         }
         invalidItems = new Dictionary(true);
      }
      
      override protected function updateRendererStyles() : void
      {
         var _loc1_:Object = null;
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         var _loc4_:String = null;
         var _loc5_:Array = [];
         for(_loc1_ in this.availableCellRenderersMap)
         {
            _loc5_ = _loc5_.concat(this.availableCellRenderersMap[_loc1_]);
         }
         for(_loc1_ in this.activeCellRenderersMap)
         {
            _loc5_ = _loc5_.concat(this.activeCellRenderersMap[_loc1_]);
         }
         _loc2_ = _loc5_.length;
         _loc3_ = 0;
         while(_loc3_ < _loc2_)
         {
            if(_loc5_[_loc3_]["setStyle"] != null)
            {
               for(_loc4_ in updatedRendererStyles)
               {
                  _loc5_[_loc3_].setStyle(_loc4_,updatedRendererStyles[_loc4_]);
               }
               _loc5_[_loc3_].drawNow();
            }
            _loc3_++;
         }
         updatedRendererStyles = {};
      }
      
      protected function removeCellRenderers() : void
      {
         var _loc1_:uint = 0;
         while(_loc1_ < this._columns.length)
         {
            this.removeCellRenderersByColumn(this._columns[_loc1_] as DataGridColumn);
            _loc1_++;
         }
      }
      
      protected function removeCellRenderersByColumn(param1:DataGridColumn) : void
      {
         if(param1 == null)
         {
            return;
         }
         var _loc2_:Array = this.activeCellRenderersMap[param1];
         if(_loc2_ != null)
         {
            while(_loc2_.length > 0)
            {
               list.removeChild(_loc2_.pop() as DisplayObject);
            }
         }
      }
      
      override protected function handleCellRendererMouseEvent(param1:MouseEvent) : void
      {
         var _loc2_:int = 0;
         var _loc3_:String = null;
         var _loc4_:uint = 0;
         var _loc5_:DataGridColumn = null;
         var _loc6_:ICellRenderer = null;
         var _loc7_:ICellRenderer = param1.target as ICellRenderer;
         if(_loc7_)
         {
            _loc2_ = int(_loc7_.listData.row);
            if(param1.type == MouseEvent.ROLL_OVER)
            {
               _loc3_ = "over";
            }
            else if(param1.type == MouseEvent.ROLL_OUT)
            {
               _loc3_ = "up";
            }
            if(_loc3_)
            {
               _loc4_ = 0;
               while(_loc4_ < this.visibleColumns.length)
               {
                  _loc5_ = this.visibleColumns[_loc4_] as DataGridColumn;
                  _loc6_ = this.getCellRendererAt(_loc2_,_loc5_.colNum);
                  if(_loc6_)
                  {
                     _loc6_.setMouseState(_loc3_);
                  }
                  if(_loc2_ != this.currentHoveredRow)
                  {
                     _loc6_ = this.getCellRendererAt(this.currentHoveredRow,_loc5_.colNum);
                     if(_loc6_)
                     {
                        _loc6_.setMouseState("up");
                     }
                  }
                  _loc4_++;
               }
            }
         }
         super.handleCellRendererMouseEvent(param1);
      }
      
      protected function isHovered(param1:ICellRenderer) : Boolean
      {
         var _loc2_:uint = uint(Math.min(Math.max(length - 1,0),Math.floor(_verticalScrollPosition / this.rowHeight)));
         var _loc3_:Number = (param1.listData.row - _loc2_) * this.rowHeight;
         var _loc4_:Point = list.globalToLocal(new Point(0,stage.mouseY));
         return _loc4_.y > _loc3_ && _loc4_.y < _loc3_ + this.rowHeight;
      }
      
      override protected function setHorizontalScrollPosition(param1:Number, param2:Boolean = false) : void
      {
         if(param1 == _horizontalScrollPosition)
         {
            return;
         }
         contentScrollRect = listHolder.scrollRect;
         contentScrollRect.x = param1;
         listHolder.scrollRect = contentScrollRect;
         list.x = 0;
         this.header.x = -param1;
         super.setHorizontalScrollPosition(param1,true);
         invalidate(InvalidationType.SCROLL);
         this.columnsInvalid = true;
      }
      
      override protected function setVerticalScrollPosition(param1:Number, param2:Boolean = false) : void
      {
         if(this.itemEditorInstance)
         {
            this.endEdit(DataGridEventReason.OTHER);
         }
         invalidate(InvalidationType.SCROLL);
         super.setVerticalScrollPosition(param1,true);
      }
      
      public function columnItemToLabel(param1:uint, param2:Object) : String
      {
         var _loc3_:DataGridColumn = this._columns[param1] as DataGridColumn;
         if(_loc3_ != null)
         {
            return _loc3_.itemToLabel(param2);
         }
         return " ";
      }
      
      protected function calculateColumnSizes() : void
      {
         var _loc1_:Number = NaN;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:DataGridColumn = null;
         var _loc5_:DataGridColumn = null;
         var _loc6_:Number = NaN;
         var _loc7_:int = 0;
         var _loc8_:Number = NaN;
         var _loc9_:int = 0;
         var _loc10_:Number = NaN;
         var _loc11_:Number = NaN;
         var _loc12_:Number = NaN;
         var _loc13_:Number = NaN;
         var _loc14_:Number = 0;
         if(this._columns.length == 0)
         {
            this.visibleColumns = [];
            this.displayableColumns = [];
            return;
         }
         if(this.columnsInvalid)
         {
            this.columnsInvalid = false;
            this.visibleColumns = [];
            if(this.minColumnWidthInvalid)
            {
               _loc2_ = int(this._columns.length);
               _loc3_ = 0;
               while(_loc3_ < _loc2_)
               {
                  this._columns[_loc3_].minWidth = this.minColumnWidth;
                  _loc3_++;
               }
               this.minColumnWidthInvalid = false;
            }
            this.displayableColumns = null;
            _loc2_ = int(this._columns.length);
            _loc3_ = 0;
            while(_loc3_ < _loc2_)
            {
               if(Boolean(this.displayableColumns) && Boolean(this._columns[_loc3_].visible))
               {
                  this.displayableColumns.push(this._columns[_loc3_]);
               }
               else if(!this.displayableColumns && !this._columns[_loc3_].visible)
               {
                  this.displayableColumns = new Array(_loc3_);
                  _loc7_ = 0;
                  while(_loc7_ < _loc3_)
                  {
                     this.displayableColumns[_loc7_] = this._columns[_loc7_];
                     _loc7_++;
                  }
               }
               _loc3_++;
            }
            if(!this.displayableColumns)
            {
               this.displayableColumns = this._columns;
            }
            if(this.horizontalScrollPolicy == ScrollPolicy.OFF)
            {
               _loc2_ = int(this.displayableColumns.length);
               _loc3_ = 0;
               while(_loc3_ < _loc2_)
               {
                  this.visibleColumns.push(this.displayableColumns[_loc3_]);
                  _loc3_++;
               }
            }
            else
            {
               _loc2_ = int(this.displayableColumns.length);
               _loc8_ = 0;
               _loc3_ = 0;
               while(_loc3_ < _loc2_)
               {
                  _loc4_ = this.displayableColumns[_loc3_] as DataGridColumn;
                  if(_loc8_ + _loc4_.width > _horizontalScrollPosition && _loc8_ < _horizontalScrollPosition + availableWidth)
                  {
                     this.visibleColumns.push(_loc4_);
                  }
                  _loc8_ += _loc4_.width;
                  _loc3_++;
               }
            }
         }
         if(this.horizontalScrollPolicy == ScrollPolicy.OFF)
         {
            _loc9_ = 0;
            _loc10_ = 0;
            _loc2_ = int(this.visibleColumns.length);
            _loc3_ = 0;
            while(_loc3_ < _loc2_)
            {
               _loc4_ = this.visibleColumns[_loc3_] as DataGridColumn;
               if(_loc4_.resizable)
               {
                  if(!isNaN(_loc4_.explicitWidth))
                  {
                     _loc10_ += _loc4_.width;
                  }
                  else
                  {
                     _loc9_++;
                     _loc10_ += _loc4_.minWidth;
                  }
               }
               else
               {
                  _loc10_ += _loc4_.width;
               }
               _loc14_ += _loc4_.width;
               _loc3_++;
            }
            _loc12_ = availableWidth;
            if(availableWidth > _loc10_ && Boolean(_loc9_))
            {
               _loc2_ = int(this.visibleColumns.length);
               _loc3_ = 0;
               while(_loc3_ < _loc2_)
               {
                  _loc4_ = this.visibleColumns[_loc3_] as DataGridColumn;
                  if(_loc4_.resizable && Boolean(isNaN(_loc4_.explicitWidth)))
                  {
                     _loc5_ = _loc4_;
                     if(_loc14_ > availableWidth)
                     {
                        _loc11_ = (_loc5_.width - _loc5_.minWidth) / (_loc14_ - _loc10_);
                     }
                     else
                     {
                        _loc11_ = _loc5_.width / _loc14_;
                     }
                     _loc6_ = _loc5_.width - (_loc14_ - availableWidth) * _loc11_;
                     _loc13_ = _loc4_.minWidth;
                     _loc4_.setWidth(Math.max(_loc6_,_loc13_));
                  }
                  _loc12_ -= _loc4_.width;
                  _loc3_++;
               }
               if(Boolean(_loc12_) && Boolean(_loc5_))
               {
                  _loc5_.setWidth(_loc5_.width + _loc12_);
               }
            }
            else
            {
               _loc2_ = int(this.visibleColumns.length);
               _loc3_ = 0;
               while(_loc3_ < _loc2_)
               {
                  _loc5_ = this.visibleColumns[_loc3_] as DataGridColumn;
                  _loc11_ = _loc5_.width / _loc14_;
                  _loc6_ = availableWidth * _loc11_;
                  _loc5_.setWidth(_loc6_);
                  _loc5_.explicitWidth = NaN;
                  _loc12_ -= _loc6_;
                  _loc3_++;
               }
               if(Boolean(_loc12_) && Boolean(_loc5_))
               {
                  _loc5_.setWidth(_loc5_.width + _loc12_);
               }
            }
         }
      }
      
      override protected function calculateContentWidth() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:DataGridColumn = null;
         if(this._columns.length == 0)
         {
            contentWidth = 0;
            return;
         }
         if(this.minColumnWidthInvalid)
         {
            _loc1_ = int(this._columns.length);
            _loc2_ = 0;
            while(_loc2_ < _loc1_)
            {
               _loc3_ = this._columns[_loc2_] as DataGridColumn;
               _loc3_.minWidth = this.minColumnWidth;
               _loc2_++;
            }
            this.minColumnWidthInvalid = false;
         }
         if(this.horizontalScrollPolicy == ScrollPolicy.OFF)
         {
            contentWidth = availableWidth;
         }
         else
         {
            contentWidth = 0;
            _loc1_ = int(this._columns.length);
            _loc2_ = 0;
            while(_loc2_ < _loc1_)
            {
               _loc3_ = this._columns[_loc2_] as DataGridColumn;
               if(_loc3_.visible)
               {
                  contentWidth += _loc3_.width;
               }
               _loc2_++;
            }
            if(!isNaN(_horizontalScrollPosition) && _horizontalScrollPosition + availableWidth > contentWidth)
            {
               this.setHorizontalScrollPosition(contentWidth - availableWidth);
            }
         }
      }
      
      protected function handleHeaderRendererClick(param1:MouseEvent) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:DataGridEvent = null;
         if(!_enabled)
         {
            return;
         }
         var _loc4_:HeaderRenderer = param1.currentTarget as HeaderRenderer;
         var _loc5_:uint = _loc4_.column;
         var _loc6_:DataGridColumn = this._columns[_loc5_] as DataGridColumn;
         if(this.sortableColumns && _loc6_.sortable)
         {
            _loc2_ = uint(this._sortIndex);
            this._sortIndex = _loc5_;
            _loc3_ = new DataGridEvent(DataGridEvent.HEADER_RELEASE,false,true,_loc5_,-1,_loc4_,_loc6_ ? _loc6_.dataField : null);
            if(!dispatchEvent(_loc3_) || !_selectable)
            {
               this._sortIndex = this.lastSortIndex;
               return;
            }
            this.lastSortIndex = _loc2_;
            this.sortByColumn(_loc5_);
            invalidate(InvalidationType.DATA);
         }
      }
      
      public function resizeColumn(param1:int, param2:Number) : void
      {
         var _loc3_:int = 0;
         var _loc4_:Number = NaN;
         var _loc5_:int = 0;
         var _loc6_:DataGridColumn = null;
         var _loc7_:DataGridColumn = null;
         var _loc8_:int = 0;
         var _loc9_:Number = NaN;
         var _loc10_:Number = NaN;
         var _loc11_:Number = NaN;
         if(this._columns.length == 0)
         {
            return;
         }
         var _loc12_:DataGridColumn = this._columns[param1] as DataGridColumn;
         if(!_loc12_)
         {
            return;
         }
         if(!this.visibleColumns || this.visibleColumns.length == 0)
         {
            _loc12_.setWidth(param2);
            return;
         }
         if(param2 < _loc12_.minWidth)
         {
            param2 = _loc12_.minWidth;
         }
         if(_horizontalScrollPolicy == ScrollPolicy.ON || _horizontalScrollPolicy == ScrollPolicy.AUTO)
         {
            _loc12_.setWidth(param2);
            _loc12_.explicitWidth = param2;
         }
         else
         {
            _loc3_ = this.getVisibleColumnIndex(_loc12_);
            if(_loc3_ != -1)
            {
               _loc4_ = 0;
               _loc5_ = int(this.visibleColumns.length);
               _loc8_ = _loc3_ + 1;
               while(_loc8_ < _loc5_)
               {
                  _loc6_ = this.visibleColumns[_loc8_] as DataGridColumn;
                  if(Boolean(_loc6_) && _loc6_.resizable)
                  {
                     _loc4_ += _loc6_.width;
                  }
                  _loc8_++;
               }
               _loc10_ = _loc12_.width - param2 + _loc4_;
               if(_loc4_)
               {
                  _loc12_.setWidth(param2);
                  _loc12_.explicitWidth = param2;
               }
               _loc11_ = 0;
               _loc8_ = _loc3_ + 1;
               while(_loc8_ < _loc5_)
               {
                  _loc6_ = this.visibleColumns[_loc8_] as DataGridColumn;
                  if(_loc6_.resizable)
                  {
                     _loc9_ = _loc6_.width * _loc10_ / _loc4_;
                     if(_loc9_ < _loc6_.minWidth)
                     {
                        _loc9_ = _loc6_.minWidth;
                     }
                     _loc6_.setWidth(_loc9_);
                     _loc11_ += _loc6_.width;
                     _loc7_ = _loc6_;
                  }
                  _loc8_++;
               }
               if(_loc11_ > _loc10_)
               {
                  _loc9_ = _loc12_.width - _loc11_ + _loc10_;
                  if(_loc9_ < _loc12_.minWidth)
                  {
                     _loc9_ = _loc12_.minWidth;
                  }
                  _loc12_.setWidth(_loc9_);
               }
               else if(_loc7_)
               {
                  _loc7_.setWidth(_loc7_.width - _loc11_ + _loc10_);
               }
            }
            else
            {
               _loc12_.setWidth(param2);
               _loc12_.explicitWidth = param2;
            }
         }
         this.columnsInvalid = true;
         invalidate(InvalidationType.SIZE);
      }
      
      protected function sortByColumn(param1:int) : void
      {
         var _loc2_:DataGridColumn = this.columns[param1] as DataGridColumn;
         if(!enabled || !_loc2_ || !_loc2_.sortable)
         {
            return;
         }
         var _loc3_:Boolean = _loc2_.sortDescending;
         var _loc4_:uint = _loc2_.sortOptions;
         if(_loc3_)
         {
            _loc4_ |= Array.DESCENDING;
         }
         else
         {
            _loc4_ &= ~Array.DESCENDING;
         }
         if(_loc2_.sortCompareFunction != null)
         {
            sortItems(_loc2_.sortCompareFunction,_loc4_);
         }
         else
         {
            sortItemsOn(_loc2_.dataField,_loc4_);
         }
         this._sortDescending = _loc2_.sortDescending = !_loc3_;
         if(this.lastSortIndex >= 0 && this.lastSortIndex != this.sortIndex)
         {
            _loc2_ = this.columns[this.lastSortIndex] as DataGridColumn;
            if(_loc2_ != null)
            {
               _loc2_.sortDescending = false;
            }
         }
      }
      
      protected function createColumnsFromDataProvider() : void
      {
         var _loc1_:Object = null;
         var _loc2_:String = null;
         this._columns = [];
         if(length > 0)
         {
            _loc1_ = _dataProvider.getItemAt(0);
            for(_loc2_ in _loc1_)
            {
               this.addColumn(_loc2_);
            }
         }
      }
      
      protected function getVisibleColumnIndex(param1:DataGridColumn) : int
      {
         var _loc2_:uint = 0;
         while(_loc2_ < this.visibleColumns.length)
         {
            if(param1 == this.visibleColumns[_loc2_])
            {
               return _loc2_;
            }
            _loc2_++;
         }
         return -1;
      }
      
      protected function handleHeaderResizeOver(param1:MouseEvent) : void
      {
         if(this.columnStretchIndex == -1)
         {
            this.showColumnStretchCursor();
         }
      }
      
      protected function handleHeaderResizeOut(param1:MouseEvent) : void
      {
         if(this.columnStretchIndex == -1)
         {
            this.showColumnStretchCursor(false);
         }
      }
      
      protected function handleHeaderResizeDown(param1:MouseEvent) : void
      {
         var _loc2_:Sprite = param1.currentTarget as Sprite;
         var _loc3_:Number = Number(this.dragHandlesMap[_loc2_]);
         var _loc4_:DataGridColumn = this.getColumnAt(_loc3_);
         this.columnStretchIndex = _loc3_;
         this.columnStretchStartX = param1.stageX;
         this.columnStretchStartWidth = _loc4_.width;
         var _loc5_:DisplayObjectContainer = focusManager.form;
         _loc5_.addEventListener(MouseEvent.MOUSE_MOVE,this.handleHeaderResizeMove,false,0,true);
         _loc5_.addEventListener(MouseEvent.MOUSE_UP,this.handleHeaderResizeUp,false,0,true);
      }
      
      protected function handleHeaderResizeMove(param1:MouseEvent) : void
      {
         var _loc2_:Number = param1.stageX - this.columnStretchStartX;
         var _loc3_:Number = this.columnStretchStartWidth + _loc2_;
         this.resizeColumn(this.columnStretchIndex,_loc3_);
      }
      
      protected function handleHeaderResizeUp(param1:MouseEvent) : void
      {
         var _loc2_:HeaderRenderer = null;
         var _loc5_:uint = 0;
         var _loc3_:Sprite = param1.currentTarget as Sprite;
         var _loc4_:DataGridColumn = this._columns[this.columnStretchIndex] as DataGridColumn;
         while(_loc5_ < this.header.numChildren)
         {
            _loc2_ = this.header.getChildAt(_loc5_) as HeaderRenderer;
            if(Boolean(_loc2_) && _loc2_.column == this.columnStretchIndex)
            {
               break;
            }
            _loc5_++;
         }
         var _loc6_:DataGridEvent = new DataGridEvent(DataGridEvent.COLUMN_STRETCH,false,true,this.columnStretchIndex,-1,_loc2_,_loc4_ ? _loc4_.dataField : null);
         dispatchEvent(_loc6_);
         this.columnStretchIndex = -1;
         this.showColumnStretchCursor(false);
         var _loc7_:DisplayObjectContainer = focusManager.form;
         _loc7_.removeEventListener(MouseEvent.MOUSE_MOVE,this.handleHeaderResizeMove,false);
         _loc7_.removeEventListener(MouseEvent.MOUSE_UP,this.handleHeaderResizeUp,false);
      }
      
      protected function showColumnStretchCursor(param1:Boolean = true) : void
      {
         var _loc2_:Point = null;
         if(this.columnStretchCursor == null)
         {
            this.columnStretchCursor = getDisplayObjectInstance(getStyleValue("columnStretchCursorSkin")) as Sprite;
            this.columnStretchCursor.mouseEnabled = false;
         }
         var _loc3_:DisplayObjectContainer = focusManager.form;
         if(param1)
         {
            Mouse.hide();
            _loc3_.addChild(this.columnStretchCursor);
            _loc3_.addEventListener(MouseEvent.MOUSE_MOVE,this.positionColumnStretchCursor,false,0,true);
            _loc2_ = _loc3_.globalToLocal(new Point(stage.mouseX,stage.mouseY));
            this.columnStretchCursor.x = _loc2_.x;
            this.columnStretchCursor.y = _loc2_.y;
         }
         else
         {
            _loc3_.removeEventListener(MouseEvent.MOUSE_MOVE,this.positionColumnStretchCursor,false);
            if(_loc3_.contains(this.columnStretchCursor))
            {
               _loc3_.removeChild(this.columnStretchCursor);
            }
            Mouse.show();
         }
      }
      
      protected function positionColumnStretchCursor(param1:MouseEvent) : void
      {
         var _loc2_:DisplayObjectContainer = focusManager.form;
         var _loc3_:Point = _loc2_.globalToLocal(new Point(param1.stageX,param1.stageY));
         this.columnStretchCursor.x = _loc3_.x;
         this.columnStretchCursor.y = _loc3_.y;
      }
      
      protected function setEditedItemPosition(param1:Object) : void
      {
         this.editedItemPositionChanged = true;
         this.proposedEditedItemPosition = param1;
         if(Boolean(param1) && param1.rowIndex != selectedIndex)
         {
            selectedIndex = param1.rowIndex;
         }
         invalidate(InvalidationType.DATA);
      }
      
      protected function commitEditedItemPosition(param1:Object) : void
      {
         var _loc2_:String = null;
         var _loc3_:int = 0;
         if(!enabled || !this.editable)
         {
            return;
         }
         if(Boolean(this.itemEditorInstance && param1 && this.itemEditorInstance is IFocusManagerComponent) && Boolean(this._editedItemPosition.rowIndex == param1.rowIndex) && this._editedItemPosition.columnIndex == param1.columnIndex)
         {
            IFocusManagerComponent(this.itemEditorInstance).setFocus();
            return;
         }
         if(this.itemEditorInstance)
         {
            if(!param1)
            {
               _loc2_ = DataGridEventReason.OTHER;
            }
            else if(!this.editedItemPosition || param1.rowIndex == this.editedItemPosition.rowIndex)
            {
               _loc2_ = DataGridEventReason.NEW_COLUMN;
            }
            else
            {
               _loc2_ = DataGridEventReason.NEW_ROW;
            }
            if(!this.endEdit(_loc2_) && _loc2_ != DataGridEventReason.OTHER)
            {
               return;
            }
         }
         this._editedItemPosition = param1;
         if(!param1)
         {
            return;
         }
         this.actualRowIndex = param1.rowIndex;
         this.actualColIndex = param1.columnIndex;
         if(this.displayableColumns.length != this._columns.length)
         {
            _loc3_ = 0;
            while(_loc3_ < this.displayableColumns.length)
            {
               if(this.displayableColumns[_loc3_].colNum >= this.actualColIndex)
               {
                  this.actualColIndex = this.displayableColumns[_loc3_].colNum;
                  break;
               }
               _loc3_++;
            }
            if(_loc3_ == this.displayableColumns.length)
            {
               this.actualColIndex = 0;
            }
         }
         this.scrollToPosition(this.actualRowIndex,this.actualColIndex);
         var _loc4_:ICellRenderer = this.getCellRendererAt(this.actualRowIndex,this.actualColIndex);
         var _loc5_:DataGridEvent = new DataGridEvent(DataGridEvent.ITEM_EDIT_BEGIN,false,true,this.actualColIndex,this.actualRowIndex,_loc4_);
         dispatchEvent(_loc5_);
         if(this.editedItemPositionChanged)
         {
            this.editedItemPositionChanged = false;
            this.commitEditedItemPosition(this.proposedEditedItemPosition);
            this.proposedEditedItemPosition = undefined;
         }
         if(!this.itemEditorInstance)
         {
            this.commitEditedItemPosition(null);
         }
      }
      
      protected function itemEditorItemEditBeginningHandler(param1:DataGridEvent) : void
      {
         if(!param1.isDefaultPrevented())
         {
            this.setEditedItemPosition({
               "columnIndex":param1.columnIndex,
               "rowIndex":uint(param1.rowIndex)
            });
         }
         else if(!this.itemEditorInstance)
         {
            this._editedItemPosition = null;
            this.editable = false;
            setFocus();
            this.editable = true;
         }
      }
      
      protected function itemEditorItemEditBeginHandler(param1:DataGridEvent) : void
      {
         var _loc2_:IFocusManager = null;
         addEventListener(Event.DEACTIVATE,this.deactivateHandler,false,0,true);
         if(!param1.isDefaultPrevented())
         {
            this.createItemEditor(param1.columnIndex,uint(param1.rowIndex));
            ICellRenderer(this.itemEditorInstance).listData = ICellRenderer(this.editedItemRenderer).listData;
            ICellRenderer(this.itemEditorInstance).data = this.editedItemRenderer.data;
            this.itemEditorInstance.imeMode = this.columns[param1.columnIndex].imeMode == null ? _imeMode : this.columns[param1.columnIndex].imeMode;
            _loc2_ = focusManager;
            if(this.itemEditorInstance is IFocusManagerComponent)
            {
               _loc2_.setFocus(InteractiveObject(this.itemEditorInstance));
            }
            _loc2_.defaultButtonEnabled = false;
            param1 = new DataGridEvent(DataGridEvent.ITEM_FOCUS_IN,false,false,this._editedItemPosition.columnIndex,this._editedItemPosition.rowIndex,this.itemEditorInstance);
            dispatchEvent(param1);
         }
      }
      
      protected function itemEditorItemEditEndHandler(param1:DataGridEvent) : void
      {
         var _loc2_:Boolean = false;
         var _loc3_:Object = null;
         var _loc4_:String = null;
         var _loc5_:Object = null;
         var _loc6_:String = null;
         var _loc7_:XML = null;
         var _loc8_:IFocusManager = null;
         if(!param1.isDefaultPrevented())
         {
            _loc2_ = false;
            if(Boolean(this.itemEditorInstance) && param1.reason != DataGridEventReason.CANCELLED)
            {
               _loc3_ = this.itemEditorInstance[this._columns[param1.columnIndex].editorDataField];
               _loc4_ = this._columns[param1.columnIndex].dataField;
               _loc5_ = param1.itemRenderer.data;
               _loc6_ = "";
               for each(_loc7_ in describeType(_loc5_).variable)
               {
                  if(_loc4_ == _loc7_.@name.toString())
                  {
                     _loc6_ = _loc7_.@type.toString();
                     break;
                  }
               }
               switch(_loc6_)
               {
                  case "String":
                     if(!(_loc3_ is String))
                     {
                        _loc3_ = _loc3_.toString();
                     }
                     break;
                  case "uint":
                     if(!(_loc3_ is uint))
                     {
                        _loc3_ = uint(_loc3_);
                     }
                     break;
                  case "int":
                     if(!(_loc3_ is int))
                     {
                        _loc3_ = int(_loc3_);
                     }
                     break;
                  case "Number":
                     if(!(_loc3_ is Number))
                     {
                        _loc3_ = Number(_loc3_);
                     }
               }
               if(_loc5_[_loc4_] != _loc3_)
               {
                  _loc2_ = true;
                  _loc5_[_loc4_] = _loc3_;
               }
               param1.itemRenderer.data = _loc5_;
            }
         }
         else if(param1.reason != DataGridEventReason.OTHER)
         {
            if(Boolean(this.itemEditorInstance) && Boolean(this._editedItemPosition))
            {
               if(selectedIndex != this._editedItemPosition.rowIndex)
               {
                  selectedIndex = this._editedItemPosition.rowIndex;
               }
               _loc8_ = focusManager;
               if(this.itemEditorInstance is IFocusManagerComponent)
               {
                  _loc8_.setFocus(InteractiveObject(this.itemEditorInstance));
               }
            }
         }
         if(param1.reason == DataGridEventReason.OTHER || !param1.isDefaultPrevented())
         {
            this.destroyItemEditor();
         }
      }
      
      override protected function focusInHandler(param1:FocusEvent) : void
      {
         var _loc2_:Boolean = false;
         var _loc3_:DataGridColumn = null;
         if(param1.target != this)
         {
            return;
         }
         if(this.losingFocus)
         {
            this.losingFocus = false;
            return;
         }
         setIMEMode(true);
         super.focusInHandler(param1);
         if(this.editable && !this.isPressed)
         {
            _loc2_ = this.editedItemPosition != null;
            if(!this._editedItemPosition)
            {
               this._editedItemPosition = {
                  "rowIndex":0,
                  "columnIndex":0
               };
               while(this._editedItemPosition.columnIndex < this._columns.length)
               {
                  _loc3_ = this._columns[this._editedItemPosition.columnIndex] as DataGridColumn;
                  if(_loc3_.editable && _loc3_.visible)
                  {
                     _loc2_ = true;
                     break;
                  }
                  ++this._editedItemPosition.columnIndex;
               }
            }
            if(_loc2_)
            {
               this.setEditedItemPosition(this._editedItemPosition);
            }
         }
         if(this.editable)
         {
            addEventListener(FocusEvent.KEY_FOCUS_CHANGE,this.keyFocusChangeHandler);
            addEventListener(MouseEvent.MOUSE_DOWN,this.mouseFocusChangeHandler);
         }
      }
      
      override protected function focusOutHandler(param1:FocusEvent) : void
      {
         setIMEMode(false);
         if(param1.target == this)
         {
            super.focusOutHandler(param1);
         }
         if(param1.relatedObject == this && this.itemRendererContains(this.itemEditorInstance,DisplayObject(param1.target)))
         {
            return;
         }
         if(param1.relatedObject == null && this.itemRendererContains(this.editedItemRenderer,DisplayObject(param1.target)))
         {
            return;
         }
         if(param1.relatedObject == null && this.itemRendererContains(this.itemEditorInstance,DisplayObject(param1.target)))
         {
            return;
         }
         if(Boolean(this.itemEditorInstance) && (!param1.relatedObject || !this.itemRendererContains(this.itemEditorInstance,param1.relatedObject)))
         {
            this.endEdit(DataGridEventReason.OTHER);
            removeEventListener(FocusEvent.KEY_FOCUS_CHANGE,this.keyFocusChangeHandler);
            removeEventListener(MouseEvent.MOUSE_DOWN,this.mouseFocusChangeHandler);
         }
      }
      
      protected function editorMouseDownHandler(param1:MouseEvent) : void
      {
         var _loc2_:ICellRenderer = null;
         var _loc3_:uint = 0;
         if(!this.itemRendererContains(this.itemEditorInstance,DisplayObject(param1.target)))
         {
            if(param1.target is ICellRenderer && contains(DisplayObject(param1.target)))
            {
               _loc2_ = param1.target as ICellRenderer;
               _loc3_ = _loc2_.listData.row;
               if(this._editedItemPosition.rowIndex == _loc3_)
               {
                  this.endEdit(DataGridEventReason.NEW_COLUMN);
               }
               else
               {
                  this.endEdit(DataGridEventReason.NEW_ROW);
               }
            }
            else
            {
               this.endEdit(DataGridEventReason.OTHER);
            }
         }
      }
      
      protected function editorKeyDownHandler(param1:KeyboardEvent) : void
      {
         if(param1.keyCode == Keyboard.ESCAPE)
         {
            this.endEdit(DataGridEventReason.CANCELLED);
         }
         else if(param1.ctrlKey && param1.charCode == 46)
         {
            this.endEdit(DataGridEventReason.CANCELLED);
         }
         else if(param1.charCode == Keyboard.ENTER && param1.keyCode != 229)
         {
            if(this.endEdit(DataGridEventReason.NEW_ROW))
            {
               this.findNextEnterItemRenderer(param1);
            }
         }
      }
      
      protected function findNextItemRenderer(param1:Boolean) : Boolean
      {
         var _loc2_:String = null;
         var _loc3_:DataGridEvent = null;
         var _loc6_:Boolean = false;
         if(!this._editedItemPosition)
         {
            return false;
         }
         if(this.proposedEditedItemPosition !== undefined)
         {
            return false;
         }
         var _loc4_:int = int(this._editedItemPosition.rowIndex);
         var _loc5_:int = int(this._editedItemPosition.columnIndex);
         var _loc7_:int = param1 ? -1 : 1;
         var _loc8_:int = length - 1;
         while(!_loc6_)
         {
            _loc5_ += _loc7_;
            if(_loc5_ < 0 || _loc5_ >= this._columns.length)
            {
               _loc5_ = _loc5_ < 0 ? int(this._columns.length - 1) : 0;
               _loc4_ += _loc7_;
               if(_loc4_ < 0 || _loc4_ > _loc8_)
               {
                  this.setEditedItemPosition(null);
                  this.losingFocus = true;
                  setFocus();
                  return false;
               }
            }
            if(Boolean(this._columns[_loc5_].editable) && Boolean(this._columns[_loc5_].visible))
            {
               _loc6_ = true;
               if(_loc4_ == this._editedItemPosition.rowIndex)
               {
                  _loc2_ = DataGridEventReason.NEW_COLUMN;
               }
               else
               {
                  _loc2_ = DataGridEventReason.NEW_ROW;
               }
               if(!this.itemEditorInstance || this.endEdit(_loc2_))
               {
                  _loc3_ = new DataGridEvent(DataGridEvent.ITEM_EDIT_BEGINNING,false,true,_loc5_,_loc4_);
                  _loc3_.dataField = this._columns[_loc5_].dataField;
                  dispatchEvent(_loc3_);
               }
            }
         }
         return _loc6_;
      }
      
      protected function findNextEnterItemRenderer(param1:KeyboardEvent) : void
      {
         if(this.proposedEditedItemPosition !== undefined)
         {
            return;
         }
         var _loc2_:int = int(this._editedItemPosition.rowIndex);
         var _loc3_:int = int(this._editedItemPosition.columnIndex);
         var _loc4_:int = this._editedItemPosition.rowIndex + (param1.shiftKey ? -1 : 1);
         if(_loc4_ >= 0 && _loc4_ < length)
         {
            _loc2_ = _loc4_;
         }
         var _loc5_:DataGridEvent = new DataGridEvent(DataGridEvent.ITEM_EDIT_BEGINNING,false,true,_loc3_,_loc2_);
         _loc5_.dataField = this._columns[_loc3_].dataField;
         dispatchEvent(_loc5_);
      }
      
      protected function mouseFocusChangeHandler(param1:MouseEvent) : void
      {
         if(Boolean(this.itemEditorInstance) && Boolean(!param1.isDefaultPrevented()) && this.itemRendererContains(this.itemEditorInstance,DisplayObject(param1.target)))
         {
            param1.preventDefault();
         }
      }
      
      protected function keyFocusChangeHandler(param1:FocusEvent) : void
      {
         if(param1.keyCode == Keyboard.TAB && !param1.isDefaultPrevented() && this.findNextItemRenderer(param1.shiftKey))
         {
            param1.preventDefault();
         }
      }
      
      private function itemEditorFocusOutHandler(param1:FocusEvent) : void
      {
         if(Boolean(param1.relatedObject) && contains(param1.relatedObject))
         {
            return;
         }
         if(!param1.relatedObject)
         {
            return;
         }
         if(this.itemEditorInstance)
         {
            this.endEdit(DataGridEventReason.OTHER);
         }
      }
      
      protected function deactivateHandler(param1:Event) : void
      {
         if(this.itemEditorInstance)
         {
            this.endEdit(DataGridEventReason.OTHER);
            this.losingFocus = true;
            setFocus();
         }
      }
      
      protected function mouseDownHandler(param1:MouseEvent) : void
      {
         if(!enabled || !selectable)
         {
            return;
         }
         this.isPressed = true;
      }
      
      protected function mouseUpHandler(param1:MouseEvent) : void
      {
         if(!enabled || !selectable)
         {
            return;
         }
         this.isPressed = false;
      }
      
      override protected function handleCellRendererClick(param1:MouseEvent) : void
      {
         var _loc2_:DataGridColumn = null;
         var _loc3_:DataGridEvent = null;
         super.handleCellRendererClick(param1);
         var _loc4_:ICellRenderer = param1.currentTarget as ICellRenderer;
         if(Boolean(_loc4_) && Boolean(_loc4_.data) && _loc4_ != this.itemEditorInstance)
         {
            _loc2_ = this._columns[_loc4_.listData.column] as DataGridColumn;
            if(Boolean(this.editable) && Boolean(_loc2_) && _loc2_.editable)
            {
               _loc3_ = new DataGridEvent(DataGridEvent.ITEM_EDIT_BEGINNING,false,true,_loc4_.listData.column,_loc4_.listData.row,_loc4_,_loc2_.dataField);
               dispatchEvent(_loc3_);
            }
         }
      }
      
      public function createItemEditor(param1:uint, param2:uint) : void
      {
         var _loc3_:int = 0;
         if(this.displayableColumns.length != this._columns.length)
         {
            _loc3_ = 0;
            while(_loc3_ < this.displayableColumns.length)
            {
               if(this.displayableColumns[_loc3_].colNum >= param1)
               {
                  param1 = uint(this.displayableColumns[_loc3_].colNum);
                  break;
               }
               _loc3_++;
            }
            if(_loc3_ == this.displayableColumns.length)
            {
               param1 = 0;
            }
         }
         var _loc4_:DataGridColumn = this._columns[param1] as DataGridColumn;
         var _loc5_:ICellRenderer = this.getCellRendererAt(param2,param1);
         if(!this.itemEditorInstance)
         {
            this.itemEditorInstance = getDisplayObjectInstance(_loc4_.itemEditor);
            this.itemEditorInstance.tabEnabled = false;
            list.addChild(DisplayObject(this.itemEditorInstance));
         }
         list.setChildIndex(DisplayObject(this.itemEditorInstance),list.numChildren - 1);
         var _loc6_:Sprite = _loc5_ as Sprite;
         this.itemEditorInstance.visible = true;
         this.itemEditorInstance.move(_loc6_.x,_loc6_.y);
         this.itemEditorInstance.setSize(_loc4_.width,this.rowHeight);
         this.itemEditorInstance.drawNow();
         DisplayObject(this.itemEditorInstance).addEventListener(FocusEvent.FOCUS_OUT,this.itemEditorFocusOutHandler);
         _loc6_.visible = false;
         DisplayObject(this.itemEditorInstance).addEventListener(KeyboardEvent.KEY_DOWN,this.editorKeyDownHandler);
         focusManager.form.addEventListener(MouseEvent.MOUSE_DOWN,this.editorMouseDownHandler,true,0,true);
      }
      
      public function destroyItemEditor() : void
      {
         var _loc1_:DataGridEvent = null;
         if(this.itemEditorInstance)
         {
            DisplayObject(this.itemEditorInstance).removeEventListener(KeyboardEvent.KEY_DOWN,this.editorKeyDownHandler);
            focusManager.form.removeEventListener(MouseEvent.MOUSE_DOWN,this.editorMouseDownHandler,true);
            _loc1_ = new DataGridEvent(DataGridEvent.ITEM_FOCUS_OUT,false,false,this._editedItemPosition.columnIndex,this._editedItemPosition.rowIndex,this.itemEditorInstance);
            dispatchEvent(_loc1_);
            if(Boolean(this.itemEditorInstance) && this.itemEditorInstance is UIComponent)
            {
               UIComponent(this.itemEditorInstance).drawFocus(false);
            }
            list.removeChild(DisplayObject(this.itemEditorInstance));
            DisplayObject(this.editedItemRenderer).visible = true;
            this.itemEditorInstance = null;
         }
      }
      
      protected function endEdit(param1:String) : Boolean
      {
         if(!this.editedItemRenderer)
         {
            return true;
         }
         var _loc2_:DataGridEvent = new DataGridEvent(DataGridEvent.ITEM_EDIT_END,false,true,this.editedItemPosition.columnIndex,this.editedItemPosition.rowIndex,this.editedItemRenderer,this._columns[this.editedItemPosition.columnIndex].dataField,param1);
         dispatchEvent(_loc2_);
         return !_loc2_.isDefaultPrevented();
      }
      
      public function getCellRendererAt(param1:uint, param2:uint) : ICellRenderer
      {
         var _loc3_:Array = null;
         var _loc4_:uint = 0;
         var _loc5_:ICellRenderer = null;
         var _loc6_:DataGridColumn = this._columns[param2] as DataGridColumn;
         if(_loc6_ != null)
         {
            _loc3_ = this.activeCellRenderersMap[_loc6_] as Array;
            if(_loc3_ != null)
            {
               _loc4_ = 0;
               while(_loc4_ < _loc3_.length)
               {
                  _loc5_ = _loc3_[_loc4_] as ICellRenderer;
                  if(_loc5_.listData.row == param1)
                  {
                     return _loc5_;
                  }
                  _loc4_++;
               }
            }
         }
         return null;
      }
      
      protected function itemRendererContains(param1:Object, param2:DisplayObject) : Boolean
      {
         if(!param2 || !param1 || !(param1 is DisplayObjectContainer))
         {
            return false;
         }
         return DisplayObjectContainer(param1).contains(param2);
      }
      
      override protected function handleDataChange(param1:DataChangeEvent) : void
      {
         super.handleDataChange(param1);
         if(this._columns == null)
         {
            this._columns = [];
         }
         if(this._columns.length == 0)
         {
            this.createColumnsFromDataProvider();
         }
      }
      
      override protected function keyDownHandler(param1:KeyboardEvent) : void
      {
         if(!selectable || Boolean(this.itemEditorInstance))
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
               this.scrollToIndex(caretIndex);
               this.doKeySelection(caretIndex,param1.shiftKey,param1.ctrlKey);
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
      
      override public function scrollToIndex(param1:int) : void
      {
         var _loc2_:Number = NaN;
         drawNow();
         var _loc3_:int = int(Math.floor((_verticalScrollPosition + availableHeight) / this.rowHeight) - 1);
         var _loc4_:int = int(Math.ceil(_verticalScrollPosition / this.rowHeight));
         if(param1 < _loc4_)
         {
            verticalScrollPosition = param1 * this.rowHeight;
         }
         else if(param1 >= _loc3_)
         {
            _loc2_ = _horizontalScrollPolicy == ScrollPolicy.ON || _horizontalScrollPolicy == ScrollPolicy.AUTO && hScrollBar ? 15 : 0;
            verticalScrollPosition = (param1 + 1) * this.rowHeight - availableHeight + _loc2_ + (this.showHeaders ? this.headerHeight : 0);
         }
      }
      
      protected function scrollToPosition(param1:int, param2:int) : void
      {
         var _loc3_:uint = 0;
         var _loc4_:DataGridColumn = null;
         var _loc5_:Number = verticalScrollPosition;
         var _loc6_:Number = horizontalScrollPosition;
         this.scrollToIndex(param1);
         var _loc7_:Number = 0;
         var _loc8_:DataGridColumn = this._columns[param2] as DataGridColumn;
         _loc3_ = 0;
         while(_loc3_ < this.displayableColumns.length)
         {
            _loc4_ = this.displayableColumns[_loc3_] as DataGridColumn;
            if(_loc4_ == _loc8_)
            {
               break;
            }
            _loc7_ += _loc4_.width;
            _loc3_++;
         }
         if(horizontalScrollPosition > _loc7_)
         {
            horizontalScrollPosition = _loc7_;
         }
         else if(horizontalScrollPosition + availableWidth < _loc7_ + _loc8_.width)
         {
            horizontalScrollPosition = -(availableWidth - (_loc7_ + _loc8_.width));
         }
         if(_loc5_ != verticalScrollPosition || _loc6_ != horizontalScrollPosition)
         {
            drawNow();
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
         else if(param3)
         {
            caretIndex = param1;
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
      
      override protected function initializeAccessibility() : void
      {
         if(DataGrid.createAccessibilityImplementation != null)
         {
            DataGrid.createAccessibilityImplementation(this);
         }
      }
   }
}

