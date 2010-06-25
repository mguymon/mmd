Ext.ns('MMD', 'MMD.Deploys', 'MMD.Deploys.Forms');


MMD.Deploys.Forms.BluePrint = Ext.extend(Ext.FormPanel, {

  initComponent: function() {
    Ext.apply(this, {
      url:'/blueprints.json',
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
                  xtype: 'blueprintsCombo',
                  value: ''
                },
                {
                  itemId: 'matEff',
                  fieldLabel: 'Material Efficiency',
                  name: 'material_efficiency',
                  xtype: 'numberfield'
                }  ,
                  {
                    itemId: 'timeEff',
                    fieldLabel: 'Time Efficiency',
                    name: 'time_efficiency',
                    xtype: 'numberfield'
                  }
              ]
            }
          ]
        }
      ]
    });
    // call the superclass's initComponent implementation
    MMD.Deploys.Forms.BluePrint.superclass.initComponent.call(this);
  }
});
Ext.reg('inventionFormsBlueprint', MMD.Deploys.Forms.BluePrint);


MMD.Deploys.Forms.Filter = Ext.extend(Ext.FormPanel, {

  initComponent: function() {
    Ext.apply(this, {
      url:'/blueprints.json',
      frame: true,
      autoScroll: false,
      labelWidth: 70,
      layout: 'form',
      border: false,
      items:  [
        {
          layout:'column',
          items: [
            {
              layout: 'form',
              border: false,
              columnWidth:0.3,
              items: [
                {
                  xtype: 'categoryCombo'
                }
              ]
            },{
              layout: 'form',
              border: false,
              columnWidth:0.3,
              items: [
                {
                  xtype: 'categoryCombo'
                }
              ]
            }
          ]
        }
      ]
    });
    // call the superclass's initComponent implementation
    MMD.Deploys.Forms.Filter.superclass.initComponent.call(this);
  }
});
Ext.reg('blueprintsFilter', MMD.Deploys.Forms.Filter);