package fl.controls.dataGridClasses
{
   import fl.controls.TextInput;
   import fl.controls.listClasses.*;
   
   public class DataGridCellEditor extends TextInput implements ICellRenderer
   {
      
      private static var defaultStyles:Object = {
         "textPadding":1,
         "textFormat":null,
         "upSkin":"DataGridCellEditor_skin"
      };
      
      protected var _listData:ListData;
      
      protected var _data:Object;
      
      public function DataGridCellEditor()
      {
         super();
      }
      
      public static function getStyleDefinition() : Object
      {
         return defaultStyles;
      }
      
      public function get listData() : ListData
      {
         return this._listData;
      }
      
      public function set listData(param1:ListData) : void
      {
         this._listData = param1;
         text = this._listData.label;
      }
      
      public function get data() : Object
      {
         return this._data;
      }
      
      public function set data(param1:Object) : void
      {
         this._data = param1;
      }
      
      public function get selected() : Boolean
      {
         return false;
      }
      
      public function set selected(param1:Boolean) : void
      {
      }
      
      public function setMouseState(param1:String) : void
      {
      }
   }
}

