Ext.ns('Admin');
Admin.perPage = 10;

provider_cat_checkboxes = []
cat_lookup = {};
cat_name_lookup = {};
for( var x = 0; x < provider_categories.length; x = x + 1) {
  cat = provider_categories[x];
  provider_cat_checkboxes[x] =
    {
      itemId: cat.short_name,
      xtype:'checkbox',
      fieldLabel: cat.name,
      name: cat.short_name,
      labelStyle: 'width:150px'
    };
  cat_lookup[cat.short_name] = cat;
  cat_name_lookup[cat.name] = cat;
}


var stateCombo;

function cleanUpActionPanel() {
  actionPanel = Ext.getCmp('action-panel');
  actionPanel.removeAll();
  actionPanel.doLayout();

  return actionPanel;
}

var perPageButton;
function bbarPerPage( perPage ) {
  perPageButton.setText( perPage + ' Per Page' );
  Admin.perPage = perPage;
  perPageButton.pageSize = perPage;
}

Ext.onReady(function() {

  Ext.QuickTips.init();

  stateStore = new Ext.data.Store({
    proxy: new Ext.data.HttpProxy({url: '/admin/states.json', method: 'get'}),
    reader: new Ext.data.JsonReader({
        root:'states'
    }, [{name: 'id', mapping:'id'}, {name: 'name' , mapping:'name'}, {name: 'abrev' , mapping:'abrev'}])
  });

  stateCombo = new Ext.form.ComboBox({
    id:'stateCombo',
    name: 'state_id',
    fieldLabel: 'State',
    store: stateStore,
    mode: 'remote',
    displayField: 'name',
    allowBlank: true,
    valueField: 'id',
    hiddenName : 'state_id',
    anchor:'95%',
    triggerAction: 'all'
  });

  stateStore.load();

  var viewport = new Ext.Viewport({
    id: 'viewport',
    layout: 'border',
    height: 640,
    renderTo: Ext.getBody(),
    items: [{
      region: 'north',
      xtype: 'panel',
      title: '<span style="font-size:120%">SleepSearch Admin</span>'
    }, {
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
      width: 150,
      items: [
        {xtype: 'tbbutton',
         text: 'Providers',
         id: 'providers-button',
         width: 75},
        {xtype: 'tbbutton',
         text: 'Reviews',
         id: 'reviews-button',
         width: 75},
        {xtype: 'tbbutton',
         text: 'Users',
         id: 'users-button',
         width: 75}
      ]
    },{
      region: 'center',
      xtype: 'panel',
      layout: 'fit',
      id: 'master-center',
      autoScroll: true,
      items: []
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
      width: 200
    },{
      id: 'south',
      itemId: 'south',
      region: 'south',
      height: 30,
      xtype: 'toolbar'
    }]
  });

  Ext.get('providers-button').on('click', function(n){
    initProviderAdmin();
  });

  Ext.get('reviews-button').on('click', function(n){
    initReviewsAdmin();
  });

  Ext.get('users-button').on('click', function(n){
    initUsersAdmin();
  });

  perPageButton = new Ext.Button(
    {
      xtype: 'tbbutton',
      text: '10 Per Page',
      menu: [
        {
         text: '10 Per Page',
         handler: function() {
           bbarPerPage( 10 );
         }
        },{
         text: '20 Per Page',
         handler: function() {
           bbarPerPage( 20 );
         }
        },{
         text: '50 Per Page',
         handler: function() {
           bbarPerPage( 50 );
         }
        },{
         text: '100 Per Page',
         handler: function() {
           bbarPerPage( 100 );
         }
        },{
         text: '200 Per Page',
         handler: function() {
           bbarPerPage( 200 );
         }
        }
      ]
    }
  );

});
