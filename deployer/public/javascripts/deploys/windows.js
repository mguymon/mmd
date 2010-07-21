Ext.ns('MMD', 'MMD.Deploys', 'MMD.Deploys.Windows');


MMD.Deploys.Windows.Client = Ext.extend(Ext.Window, {

  // override
  initComponent : function() {

    Ext.apply(this, {
      modal: true,
      layout:'vbox',
      closable: false,
      resizable: true,
      autoScroll: true,
      title: 'Client',
      width: 580,
      height: 320,
      items:[
          {
            itemId: 'form',
            xtype: 'deployFormsClient'
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

            container = this.ownerCt.ownerCt;
            fieldSet = container.get('form');
            form = fieldSet.getForm();
            form_values = form.getFieldValues();
            record = form.record;

            data = '_method=' + form_values._method;
            data = Ext.urlEncode( {authenticity_token: FORM_TOKEN} );

            delete form_values._method;

            for( key in form_values ) {
              data += '&client[' + key + ']=' + escape(form_values[key]);
            }

            var conn = new Ext.data.Connection();
            conn.request({
                url: fieldSet.url,
                method: 'POST',
                params: data,
                success: function(response, action) {
                  button.enable();
                  result = Ext.util.JSON.decode(response.responseText);

                  if ( result.success ) {

                    container.destroy();
                    Ext.MessageBox.alert('Status', 'Client has been saved');

                    MMD.Deploys.treeLoader.load(MMD.Deploys.clientTree.root);

                  } else {
                    messages = result.errors;
                    errors = "<ul><li>";
                    errors += messages.join("</li><li>" );
                    errors += "</li></ul>";
                    Ext.MessageBox.alert('Status', 'Failed to save Client: <br/><br/>' + errors);
                  }
                },
                failure: function ( result, request) {
                  button.enable();
                  Ext.MessageBox.alert('Status', 'Failed to save Client');
                }
            });

          }
        }

      ]
    });

    // finally call the superclasses implementation
    MMD.Deploys.Windows.Client.superclass.initComponent.call(this);
  }
});


MMD.Deploys.Windows.Project = Ext.extend(Ext.Window, {

  // override
  initComponent : function() {
    clientId = this.clientId;
    
    Ext.apply(this, {
      modal: true,
      layout:'vbox',
      closable: false,
      resizable: true,
      autoScroll: true,
      title: 'Project',
      width: 580,
      height: 320,
      items:[
          {
            itemId: 'form',
            xtype: 'deployFormsProject',
            clientId: clientId
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

            container = this.ownerCt.ownerCt;
            fieldSet = container.get('form');
            form = fieldSet.getForm();
            form_values = form.getFieldValues();
            record = form.record;

            data = '_method=' + form_values._method;
            data = Ext.urlEncode( {authenticity_token: FORM_TOKEN} );

            delete form_values._method;

            for( key in form_values ) {
              data += '&project[' + key + ']=' + escape(form_values[key]);
            }

            var conn = new Ext.data.Connection();
            conn.request({
                url: fieldSet.url,
                method: 'POST',
                params: data,
                success: function(response, action) {
                  button.enable();
                  result = Ext.util.JSON.decode(response.responseText);

                  if ( result.success ) {

                    container.destroy();
                    Ext.MessageBox.alert('Status', 'Project has been saved');

                    MMD.Deploys.treeLoader.load(MMD.Deploys.clientTree.root);

                  } else {
                    messages = result.errors;
                    errors = "<ul><li>";
                    errors += messages.join("</li><li>" );
                    errors += "</li></ul>";
                    Ext.MessageBox.alert('Status', 'Failed to save Project: <br/><br/>' + errors);
                  }
                },
                failure: function ( result, request) {
                  button.enable();
                  Ext.MessageBox.alert('Status', 'Failed to save Project');
                }
            });

          }
        }

      ]
    });

    // finally call the superclasses implementation
    MMD.Deploys.Windows.Client.superclass.initComponent.call(this);
  }
});


MMD.Deploys.Windows.App = Ext.extend(Ext.Window, {

  // override
  initComponent : function() {
    projectId = this.projectId;

    Ext.apply(this, {
      modal: true,
      layout:'vbox',
      closable: false,
      resizable: true,
      autoScroll: true,
      title: 'Project',
      width: 580,
      height: 320,
      items:[
          {
            itemId: 'form',
            xtype: 'deployFormsApp',
            projectId: projectId
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

            container = this.ownerCt.ownerCt;
            fieldSet = container.get('form');
            form = fieldSet.getForm();
            form_values = form.getFieldValues();
            record = form.record;

            data = '_method=' + form_values._method;
            data = Ext.urlEncode( {authenticity_token: FORM_TOKEN} );

            delete form_values._method;

            for( key in form_values ) {
              data += '&app[' + key + ']=' + escape(form_values[key]);
            }

            var conn = new Ext.data.Connection();
            conn.request({
                url: fieldSet.url,
                method: 'POST',
                params: data,
                success: function(response, action) {
                  button.enable();
                  result = Ext.util.JSON.decode(response.responseText);

                  if ( result.success ) {

                    container.destroy();
                    Ext.MessageBox.alert('Status', 'Application has been saved');

                    MMD.Deploys.treeLoader.load(MMD.Deploys.clientTree.root);

                  } else {
                    messages = result.errors;
                    errors = "<ul><li>";
                    errors += messages.join("</li><li>" );
                    errors += "</li></ul>";
                    Ext.MessageBox.alert('Status', 'Failed to save Application: <br/><br/>' + errors);
                  }
                },
                failure: function ( result, request) {
                  button.enable();
                  Ext.MessageBox.alert('Status', 'Failed to save Application');
                }
            });

          }
        }

      ]
    });

    // finally call the superclasses implementation
    MMD.Deploys.Windows.App.superclass.initComponent.call(this);
  }
});

MMD.Deploys.Windows.Environment = Ext.extend(Ext.Window, {

  // override
  initComponent : function() {
    appId = this.appId;

    Ext.apply(this, {
      modal: true,
      layout:'vbox',
      closable: false,
      resizable: true,
      autoScroll: true,
      title: 'Project',
      width: 580,
      height: 320,
      items:[
          {
            itemId: 'form',
            xtype: 'deployFormsEnvironment',
            appId: appId
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

            container = this.ownerCt.ownerCt;
            fieldSet = container.get('form');
            form = fieldSet.getForm();
            form_values = form.getFieldValues();
            record = form.record;

            data = '_method=' + form_values._method;
            data = Ext.urlEncode( {authenticity_token: FORM_TOKEN} );

            delete form_values._method;

            for( key in form_values ) {
              data += '&environment[' + key + ']=' + escape(form_values[key]);
            }

            var conn = new Ext.data.Connection();
            conn.request({
                url: fieldSet.url,
                method: 'POST',
                params: data,
                success: function(response, action) {
                  button.enable();
                  result = Ext.util.JSON.decode(response.responseText);

                  if ( result.success ) {

                    container.destroy();
                    Ext.MessageBox.alert('Status', 'Environment has been saved');

                    MMD.Deploys.treeLoader.load(MMD.Deploys.clientTree.root);

                  } else {
                    messages = result.errors;
                    errors = "<ul><li>";
                    errors += messages.join("</li><li>" );
                    errors += "</li></ul>";
                    Ext.MessageBox.alert('Status', 'Failed to save Environment: <br/><br/>' + errors);
                  }
                },
                failure: function ( result, request) {
                  button.enable();
                  Ext.MessageBox.alert('Status', 'Failed to save Environment');
                }
            });

          }
        }

      ]
    });

    // finally call the superclasses implementation
    MMD.Deploys.Windows.App.superclass.initComponent.call(this);
  }
});