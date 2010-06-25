Ext.ns('MMD', 'MMD.Admin');

MMD.Admin.layout = {
  title: 'Admin',
  xtype: 'panel',
  layout: 'border',
  items: [
    {
      title: 'Area',
      region: 'west',
      fitToFrame:true,
      collapsible: true,
      layout: {
          type:'vbox',
          padding:'5',
          align:'center'
      },
      defaults:{margins:'0 0 5 0'},
      width: 130,
      items: [
        {
          xtype: 'tbbutton',
          text: 'Modules',
          id: 'modules-button',
          width: 100
        },
        {
          xtype: 'tbbutton',
          text: 'Turrets / Bays',
          id: 'turrets-button',
          width: 100
        },
        {
          xtype: 'tbbutton',
          text: 'Ships',
          id: 'ship-button',
          width: 100
        }
      ]
    },{
      region: 'center',
      xtype: 'panel',
      layout: 'fit',
      id: 'master-center',
      autoScroll: true,
      items: [
        
      ]
    },{
      title: 'Actions',
      id: 'action-panel',
      region: 'east',
      xtype: 'panel',
      fitToFrame:true,
      collapsible: true,
      layout: {
          type:'vbox',
          padding:'5',
          align:'center'
      },
      defaults:{margins:'0 0 5 0'},
      width: 150
    },{
      id: 'south',
      itemId: 'south',
      region: 'south',
      height: 30,
      xtype: 'toolbar'
    }
  ]
}