Ext.ns('MMD', 'MMD.Admin', 'MMD.Admin.Windows');

Ext.onReady(function() {

  MMD.Admin.Windows.BluePrint = Ext.extend(Ext.Window, {

    // override
    initComponent : function() {

      Ext.apply(this, {
        modal: true,
        layout:'vbox',
        closable: false,
        resizable: true,
        autoScroll: true,
        title: 'BluePrint',
        width: 580,
        height: 320,
        items:[
            {
              itemId: 'form',
              xtype: 'inventionFormsBlueprint'
            }
        ],
        buttons:[
          {
            text:'close',
            handler:function() {
              this.ownerCt.ownerCt.destroy();
            }
          },
          {
            text:'Save',
            handler:function(){
              button = this;
              button.disable();

            }
          }

        ]
      });

      // finally call the superclasses implementation
      MMD.Admin.Windows.BluePrint.superclass.initComponent.call(this);
    }
  });
});