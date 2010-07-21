Ext.ns('MMD', 'MMD.Deploys', 'MMD.Deploys.Store');

Ext.onReady(function(){

  MMD.Deploys.treeLoader = new Ext.tree.TreeLoader({
      dataUrl:'/clients.json',
      requestMethod: 'GET'
    })

  MMD.Deploys.clientTree = new Ext.tree.TreePanel({
    id: 'clients-tree-panel',
    autoScroll: true,
    width: 170,
    animate:true,
    containerScroll: true,

    // tree-specific configs
    singleExpand: true,
    lines: false,
    useArrows:true,
    rootVisible: false,
    loader: MMD.Deploys.treeLoader,

    root: new Ext.tree.AsyncTreeNode( { id: 'clients' } )
  });

  MMD.Deploys.clientTree.on('beforeexpandnode', function(node, deep, anim ) {
    // Collapse all nodes if client is changed
    attributes =  node.attributes;
    if ( attributes.recordType == 'client' && MMD.Deploys.clientId != attributes.recordId ) {
      MMD.Deploys.clientTree.collapseAll();
    }
  });

  MMD.Deploys.clientTree.on('expandnode', function(node, deep, anim ) {

    id = node.attributes.recordId;
    type = node.attributes.recordType;
    
    if ( id !== undefined && type !== undefined ) {
      var conn = new Ext.data.Connection();
      conn.request({
          url: '/' + type +'s/' + id + '.json',
          method: 'POST',
          params: { '_method': 'GET' },
          success: function(response, action) {
            result = Ext.util.JSON.decode(response.responseText);

            if ( result.success ) {
              MMD.Deploys.getColumn( type ).updateDetail( result.record );
            }

            if ( type == 'client' ) {
              MMD.Deploys.clientId = id;
              MMD.Deploys.getColumn( 'project' ).resetDetail();
              MMD.Deploys.getColumn( 'app' ).resetDetail();
              MMD.Deploys.getColumn( 'environment' ).resetDetail();
            } else if ( type == 'project' ) {
              MMD.Deploys.projectId = id;
              MMD.Deploys.getColumn( 'app' ).resetDetail();
              MMD.Deploys.getColumn( 'environment' ).resetDetail();
            } else if ( type == 'app' ) {
              MMD.Deploys.appId = id;
              MMD.Deploys.getColumn( 'environment' ).resetDetail();
            }
          },
          failure: function ( result, request) {
            Ext.MessageBox.alert('Status', 'Failed to retrieve ' + type + ' data');
          }
      });
    }

  });

  MMD.Deploys.clientTree.on('click', function(node, event ) {
    id = node.attributes.recordId;
    type = node.attributes.recordType;

    if ( type == 'environment' && id !== undefined ) {
      MMD.Deploys.environmentId = id;

      var conn = new Ext.data.Connection();
      conn.request({
          url: '/environments/' + id + '.json',
          method: 'POST',
          params: { '_method': 'GET' },
          success: function(response, action) {
            result = Ext.util.JSON.decode(response.responseText);

            if ( result.success ) {
              MMD.Deploys.getColumn( 'environment' ).updateDetail( result.record );
              actionPanel = MMD.Deploys.cleanUpActionPanel();
              actionPanel.add( MMD.Deploys.deployButton() );
              actionPanel.doLayout();
            }
          },
          failure: function ( result, request) {
            Ext.MessageBox.alert('Status', 'Failed to retrieve ' + type + ' data');
          }
      });

    } else if ( id !== undefined ) {
      MMD.Deploys[type + 'Id'] = id;

      var conn = new Ext.data.Connection();
      conn.request({
          url: '/' + type + 's/' + id + '.json',
          method: 'POST',
          params: { '_method': 'GET' },
          success: function(response, action) {
            result = Ext.util.JSON.decode(response.responseText);

            if ( result.success ) {
              MMD.Deploys.getColumn( type).updateDetail( result.record );
            }
          },
          failure: function ( result, request) {
            Ext.MessageBox.alert('Status', 'Failed to retrieve ' + type + ' data');
          }
      });

    }
  });

  MMD.Deploys.layout = new Ext.Panel({
    title: 'Deploys',
    id: 'deploys',
    itemId: 'deploys',
    layout: 'border',
    items: [
      {
        title: 'Area',
        region: 'west',
        collapsible: true,
        layout: {
            type:'vbox',
            padding:'5',
            align:'center'
        },
        defaults:{margins:'0 0 5 0'},
        width: 180,
        items: [
          MMD.Deploys.clientTree
        ]
      },{
        xtype: 'panel',
        region: 'center',
        itemId: 'center',
        items: [
          {
            itemId: 'columns',
            layout:'column',
            height: 200,
            items: [
              {
                itemId: 'client',
                title: 'Client',
                xtype: 'mmdDetail',
                columnWidth:0.25,
                height: 200,
                html: '<div style="padding:5px">Please select a Client</div>',
                tplMarkup: [
                  'Name: {name}<br/>',
                  'Short Name: {short_name}<br/>'
                ],
                bbar: [
                  {
                    text: 'Edit',
                    handler: function() {
                    }
                  },
                  '-',
                  {
                    text: 'Add Project',
                    handler: function(detail) {
                      popup = new MMD.Deploys.Windows.Project( {clientId: MMD.Deploys.clientId });
                      popup.show();
                    }
                  }
                ]
              },{
                itemId: 'project',
                title: 'Project',
                xtype: 'mmdDetail',
                columnWidth:0.25,
                height: 200,
                html: '<div style="padding:5px">Please select a Project</div>',
                tplMarkup: [
                  'Name: {name}<br/>',
                  'Short Name: {short_name}<br/>',
                  'Desc: {desc}<br/>'
                ],
                bbar: [
                  {
                    text: 'Edit',
                    handler: function() {
                    }
                  },
                  '-',
                  {
                    text: 'Add Application',
                    handler: function(detail) {
                      popup = new MMD.Deploys.Windows.App( {projectId: MMD.Deploys.projectId });
                      popup.show();
                    }
                  }
                ]
              },{
                itemId: 'app',
                title: 'Application',
                xtype: 'mmdDetail',
                columnWidth:0.25,
                height: 200,
                html: '<div style="padding:5px">Please select a Application</div>',
                tplMarkup: [
                  'Name: {name}<br/>',
                  'Short Name: {short_name}<br/>',
                  'Desc: {desc}<br/>'
                ],
                bbar: [
                  {
                    text: 'Edit',
                    handler: function() {
                    }
                  },
                  '-',
                  {
                    text: 'Add Environment',
                    handler: function(detail) {
                      popup = new MMD.Deploys.Windows.Environment( {appId: MMD.Deploys.appId });
                      popup.show();
                    }
                  }
                ]
              },{
                itemId: 'environment',
                title: 'Environment',
                xtype: 'mmdDetail',
                columnWidth:0.25,
                height: 200,
                html: '<div style="padding:5px">Please select a Environment</div>',
                tplMarkup: [
                  'Name: {name}<br/>',
                  'Short Name: {short_name}<br/>',
                  'Desc: {desc}<br/>'
                ],
                bbar: [
                  {
                    text: 'Edit',
                    handler: function() {
                    }
                  }
                ]
              }
            ]
          }, {
            title: 'Deploy',
            itemId: 'deploy',
            height: 350,
            autoScroll: true
          }
        ]
      },{
        title: 'Actions',
        itemId: 'action-panel',
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
        xtype: 'toolbar',
        items: [
          {
              text: 'Add Client',
              handler: function() {
                  popup = new MMD.Deploys.Windows.Client();
                  popup.show();
              }
          }
        ]
      }
    ]
  });

});


MMD.Deploys.getColumn = function( type ) {
  return Ext.getCmp('master-center').items.items[0].get('deploys').get('center').get('columns').get( type );
}

var cooldown = 1.0
var fetchNextRunning = false;
MMD.Deploys.fetchNext = function(start, deploy_id) {
  if ( fetchNextRunning == false ) {
    fetchNextRunning = true;
    $.getJSON(
      '/deploys/' + deploy_id + '.json',
      {
        start: start
      },
      function(data) {
        fetchNextRunning = false;

        var content = data.content;
        if( content.length > 0 ) {
          for (var i=0;i<content.length;i++) {
            cmp = Ext.getCmp('deploys').get('center').get('deploy');
            var old = cmp.body.dom.innerHTML;
            cmp.body.update(old + content[i].replace(/\n/, '<br />') );
            cmp.body.scroll( 'b', 350 );
          }

          cooldown = 1;
        } else {
          cooldown = cooldown + 0.3;
        }


        if(data.is_running == true) {
          setTimeout(function(){
              MMD.Deploys.fetchNext(data.end_pos, deploy_id);
            },
            9000 * cooldown );
        }
      }
    );
  }
}


MMD.Deploys.deployButton = function() {
  return {
    xtype: 'tbbutton',
    text: 'Deploy',
    width: 75,
    listeners: {
      'click':  function(field, newVal){
          Ext.getCmp('deploys').get('center').get('deploy').update( '' );
          
          Ext.Ajax.request({
            url : '/clients/' + MMD.Deploys.clientId + '/projects/' + MMD.Deploys.projectId + '/applications/' + MMD.Deploys.appId + '/environments/' + MMD.Deploys.environmentId + '/deploys.json',
            method: 'POST',
            success: function ( result, request ) {
              var deploy = Ext.util.JSON.decode(result.responseText);

              MMD.Deploys.fetchNext(0, deploy.id );

            },
            failure: function ( result, request) {
              Ext.MessageBox.alert('Failed', result.responseText);
            }
          });
      }
    }
  };
}
MMD.Deploys.cleanUpActionPanel = function () {
  actionPanel = Ext.getCmp('master-center').items.items[0].get('deploys').get('action-panel');
  actionPanel.removeAll();
  actionPanel.doLayout();

  return actionPanel;
}
