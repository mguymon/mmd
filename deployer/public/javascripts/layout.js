Ext.ns('SpreadEm', 'SpreadEm.Overview');
SpreadEm.perPage = 10;


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
    items: [
      {
        region: 'north',
        xtype: 'panel',
        title: '<span style="font-size:120%">Mighty Mighty Deployer</span>'
      },
      {
        region: 'center',
        xtype: 'panel',
        layout: 'fit',
        id: 'master-center',
        autoScroll: true,
        items: [
          SpreadEm.tabs = new Ext.TabPanel({
            itemIds: 'tabs',
            activeTab: 0,
            items:
              [
                
                // Deploys
                MMD.Deploys.layout,
                
                // Admin
                MMD.Admin.layout,

              ],
            listeners: {
              'tabchange': function(comp, tab) {
              },
              scope: this
            }
          })
        ]
      }
    ]
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
