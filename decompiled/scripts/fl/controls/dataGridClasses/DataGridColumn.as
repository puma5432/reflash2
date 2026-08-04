package fl.controls.dataGridClasses
{
   import fl.controls.DataGrid;
   import fl.core.*;
   
   public class DataGridColumn
   {
      
      private var _columnName:String;
      
      private var _headerText:String;
      
      private var _minWidth:Number = 20;
      
      private var _width:Number = 100;
      
      private var _visible:Boolean = true;
      
      private var _cellRenderer:Object;
      
      private var _headerRenderer:Object;
      
      private var _labelFunction:Function;
      
      private var _sortCompareFunction:Function;
      
      private var _imeMode:String;
      
      public var owner:DataGrid;
      
      public var colNum:Number;
      
      public var explicitWidth:Number;
      
      public var sortable:Boolean = true;
      
      public var resizable:Boolean = true;
      
      public var editable:Boolean = true;
      
      public var itemEditor:Object = "fl.controls.dataGridClasses.DataGridCellEditor";
      
      public var editorDataField:String = "text";
      
      public var dataField:String;
      
      public var sortDescending:Boolean = false;
      
      public var sortOptions:uint = 0;
      
      private var forceImport:DataGridCellEditor;
      
      public function DataGridColumn(param1:String = null)
      {
         super();
         if(param1)
         {
            this.dataField = param1;
            this.headerText = param1;
         }
      }
      
      public function get cellRenderer() : Object
      {
         return this._cellRenderer;
      }
      
      public function set cellRenderer(param1:Object) : void
      {
         this._cellRenderer = param1;
         if(this.owner)
         {
            this.owner.invalidate(InvalidationType.DATA);
         }
      }
      
      public function get headerRenderer() : Object
      {
         return this._headerRenderer;
      }
      
      public function set headerRenderer(param1:Object) : void
      {
         this._headerRenderer = param1;
         if(this.owner)
         {
            this.owner.invalidate(InvalidationType.DATA);
         }
      }
      
      public function get headerText() : String
      {
         return this._headerText != null ? this._headerText : this.dataField;
      }
      
      public function set headerText(param1:String) : void
      {
         this._headerText = param1;
         if(this.owner)
         {
            this.owner.invalidate(InvalidationType.DATA);
         }
      }
      
      public function get imeMode() : String
      {
         return this._imeMode;
      }
      
      public function set imeMode(param1:String) : void
      {
         this._imeMode = param1;
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
         if(this.owner)
         {
            this.owner.invalidate(InvalidationType.DATA);
         }
      }
      
      public function get minWidth() : Number
      {
         return this._minWidth;
      }
      
      public function set minWidth(param1:Number) : void
      {
         this._minWidth = param1;
         if(this._width < param1)
         {
            this._width = param1;
         }
         if(this.owner)
         {
            this.owner.invalidate(InvalidationType.SIZE);
         }
      }
      
      public function get sortCompareFunction() : Function
      {
         return this._sortCompareFunction;
      }
      
      public function set sortCompareFunction(param1:Function) : void
      {
         this._sortCompareFunction = param1;
      }
      
      public function get visible() : Boolean
      {
         return this._visible;
      }
      
      public function set visible(param1:Boolean) : void
      {
         if(this._visible != param1)
         {
            this._visible = param1;
            if(this.owner)
            {
               this.owner.invalidate(InvalidationType.SIZE);
            }
         }
      }
      
      public function get width() : Number
      {
         return this._width;
      }
      
      public function set width(param1:Number) : void
      {
         var _loc2_:Boolean = false;
         this.explicitWidth = param1;
         if(this.owner != null)
         {
            _loc2_ = this.resizable;
            this.resizable = false;
            this.owner.resizeColumn(this.colNum,param1);
            this.resizable = _loc2_;
         }
         else
         {
            this._width = param1;
         }
      }
      
      public function setWidth(param1:Number) : void
      {
         this._width = param1;
      }
      
      public function itemToLabel(param1:Object) : String
      {
         var data:Object = param1;
         if(!data)
         {
            return " ";
         }
         if(this.labelFunction != null)
         {
            return this.labelFunction(data);
         }
         if(this.owner.labelFunction != null)
         {
            return this.owner.labelFunction(data,this);
         }
         if(typeof data == "object" || typeof data == "xml")
         {
            try
            {
               data = data[this.dataField];
            }
            catch(e:Error)
            {
               data = null;
            }
         }
         if(data is String)
         {
            return String(data);
         }
         try
         {
            return data.toString();
         }
         catch(e:Error)
         {
         }
         return " ";
      }
      
      public function toString() : String
      {
         return "[object DataGridColumn]";
      }
   }
}

