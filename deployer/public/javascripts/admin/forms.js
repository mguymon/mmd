Ext.ns('MMD', 'MMD.Admin', 'MMD.Admin.Forms');


MMD.Admin.Forms.BluePrint = Ext.extend(Ext.FormPanel, {

  initComponent: function() {
    Ext.apply(this, {
      url:'/blue_prints',
      bodyStyle:'padding:5px 5px 0',
      frame: true,
      autoScroll: true,
      labelWidth: 70,
      width: 550,
      layout: 'form',
      border: false,
      items:  [
        {
          name: '_method',
          xtype: 'hidden',
          value: 'POST'
        },{         
          defaults:{
            xtype:'fieldset',
            layout:'form'
          },
          items: [
            {
              itemId: 'name',
              defaultType:'textfield',
              defaults:{
                allowBlank:true,
                anchor: '80%'
              },
              items:[
                {
                  itemId: 'nameField',
                  fieldLabel:'Name',
                  name: 'name'
                },
                {
                  itemId: 'materialField',
                  fieldLabel:'Material Efficency',
                  name: 'nam'
                }
              ]
            }
          ]
        }
      ]
    });
    // call the superclass's initComponent implementation
    MMD.Admin.Forms.BluePrint.superclass.initComponent.call(this);
  }
});
Ext.reg('inventionFormsBlueprint', MMD.Admin.Forms.BluePrint);