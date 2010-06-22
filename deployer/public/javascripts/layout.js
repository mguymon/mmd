Ext.ns('MMD');
MMD.perPage = 10;

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

  var viewport = new Ext.Viewport({
    id: 'viewport',
    layout: 'border',
    height: 640,
    renderTo: Ext.getBody(),
    items: [{
      region: 'north',
      xtype: 'panel',
      title: '<span style="font-size:120%">Mighty Mighty Deployer</span>'
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
