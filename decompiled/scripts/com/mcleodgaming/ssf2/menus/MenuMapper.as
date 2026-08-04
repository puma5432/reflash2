package com.mcleodgaming.ssf2.menus
{
   public class MenuMapper
   {
      
      public var currentNode:MenuMapperNode;
      
      public var startNode:MenuMapperNode;
      
      public var hoverFunction:Function;
      
      public var outFunction:Function;
      
      public function MenuMapper(param1:MenuMapperNode)
      {
         super();
         this.currentNode = param1;
         this.startNode = param1;
      }
      
      public function init() : void
      {
         this.currentNode = this.startNode;
      }
      
      public function clear() : void
      {
         this.currentNode = null;
      }
      
      public function up() : void
      {
         if(Boolean(this.currentNode) && this.currentNode.preFunctionMode)
         {
            this.currentNode.upFunction();
         }
         if(Boolean(this.currentNode) && Boolean(this.currentNode.Up) && this.currentNode.Up.length > 0)
         {
            this.currentNode.outFunction();
            this.currentNode.Up[0].pushToFront(this.currentNode);
            this.currentNode = this.currentNode.Up[0];
            this.currentNode.hoverFunction();
         }
         if(Boolean(this.currentNode) && !this.currentNode.preFunctionMode)
         {
            this.currentNode.upFunction();
         }
         if(!this.currentNode)
         {
            this.currentNode = this.startNode;
            if(this.currentNode)
            {
               this.currentNode.hoverFunction();
            }
         }
      }
      
      public function down() : void
      {
         if(Boolean(this.currentNode) && this.currentNode.preFunctionMode)
         {
            this.currentNode.downFunction();
         }
         if(Boolean(this.currentNode) && Boolean(this.currentNode.Down) && this.currentNode.Down.length > 0)
         {
            this.currentNode.outFunction();
            this.currentNode.Down[0].pushToFront(this.currentNode);
            this.currentNode = this.currentNode.Down[0];
            this.currentNode.hoverFunction();
         }
         if(Boolean(this.currentNode) && !this.currentNode.preFunctionMode)
         {
            this.currentNode.downFunction();
         }
         if(!this.currentNode)
         {
            this.currentNode = this.startNode;
            if(this.currentNode)
            {
               this.currentNode.hoverFunction();
            }
         }
      }
      
      public function left() : void
      {
         if(Boolean(this.currentNode) && this.currentNode.preFunctionMode)
         {
            this.currentNode.leftFunction();
         }
         if(Boolean(this.currentNode) && Boolean(this.currentNode.Left) && this.currentNode.Left.length > 0)
         {
            this.currentNode.outFunction();
            this.currentNode.Left[0].pushToFront(this.currentNode);
            this.currentNode = this.currentNode.Left[0];
            this.currentNode.hoverFunction();
         }
         if(Boolean(this.currentNode) && !this.currentNode.preFunctionMode)
         {
            this.currentNode.leftFunction();
         }
         if(!this.currentNode)
         {
            this.currentNode = this.startNode;
            if(this.currentNode)
            {
               this.currentNode.hoverFunction();
            }
         }
      }
      
      public function right() : void
      {
         if(Boolean(this.currentNode) && this.currentNode.preFunctionMode)
         {
            this.currentNode.rightFunction();
         }
         if(Boolean(this.currentNode) && Boolean(this.currentNode.Right) && this.currentNode.Right.length > 0)
         {
            this.currentNode.outFunction();
            this.currentNode.Right[0].pushToFront(this.currentNode);
            this.currentNode = this.currentNode.Right[0];
            this.currentNode.hoverFunction();
         }
         if(Boolean(this.currentNode) && !this.currentNode.preFunctionMode)
         {
            this.currentNode.rightFunction();
         }
         if(!this.currentNode)
         {
            this.currentNode = this.startNode;
            if(this.currentNode)
            {
               this.currentNode.hoverFunction();
            }
         }
      }
      
      public function press() : void
      {
         if(Boolean(this.currentNode) && this.currentNode.preFunctionMode)
         {
            this.currentNode.pressFunction();
         }
         if(!this.currentNode)
         {
            this.currentNode = this.startNode;
            if(this.currentNode)
            {
               this.currentNode.hoverFunction();
            }
         }
         if(Boolean(this.currentNode) && !this.currentNode.preFunctionMode)
         {
            this.currentNode.pressFunction();
         }
      }
      
      public function back() : void
      {
         if(Boolean(this.currentNode) && this.currentNode.preFunctionMode)
         {
            this.currentNode.backFunction();
         }
         if(!this.currentNode)
         {
            this.currentNode = this.startNode;
            if(this.currentNode)
            {
               this.currentNode.hoverFunction();
            }
         }
         if(Boolean(this.currentNode) && !this.currentNode.preFunctionMode)
         {
            this.currentNode.backFunction();
         }
      }
   }
}

