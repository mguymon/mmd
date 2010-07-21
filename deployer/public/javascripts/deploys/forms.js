Ext.ns('MMD', 'MMD.Deploys', 'MMD.Deploys.Forms');


MMD.Deploys.Forms.Client = Ext.extend(Ext.FormPanel, {

  initComponent: function() {
    Ext.apply(this, {
      url:'/clients.json',
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
                  itemId: 'name',
                  fieldLabel: 'Name',
                  name: 'name'
                }, {
                  itemId: 'short_name',
                  fieldLabel: 'Short Name',
                  name: 'short_name'
                }
              ]
            }
          ]
        }
      ]
    });
    // call the superclass's initComponent implementation
    MMD.Deploys.Forms.Client.superclass.initComponent.call(this);
  }
});
Ext.reg('deployFormsClient', MMD.Deploys.Forms.Client);

MMD.Deploys.Forms.Project = Ext.extend(Ext.FormPanel, {

  initComponent: function() {
    clientId = this.clientId;

    Ext.apply(this, {
      url:'/projects.json',
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
          name: 'client_id',
          xtype: 'hidden',
          value: clientId
        }, {
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
                  itemId: 'name',
                  fieldLabel: 'Name',
                  name: 'name'
                }, {
                  itemId: 'short_name',
                  fieldLabel: 'Short Name',
                  name: 'short_name'
                }
              ]
            }
          ]
        }
      ]
    });
    // call the superclass's initComponent implementation
    MMD.Deploys.Forms.Project.superclass.initComponent.call(this);
  }
});
Ext.reg('deployFormsProject', MMD.Deploys.Forms.Project);

MMD.Deploys.Forms.App = Ext.extend(Ext.FormPanel, {

  initComponent: function() {
    projectId = this.projectId;

    Ext.apply(this, {
      url:'/apps.json',
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
          name: 'project_id',
          xtype: 'hidden',
          value: projectId
        }, {
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
                  itemId: 'name',
                  fieldLabel: 'Name',
                  name: 'name'
                }, {
                  itemId: 'short_name',
                  fieldLabel: 'Short Name',
                  name: 'short_name'
                }
              ]
            }
          ]
        }
      ]
    });
    // call the superclass's initComponent implementation
    MMD.Deploys.Forms.App.superclass.initComponent.call(this);
  }
});
Ext.reg('deployFormsApp', MMD.Deploys.Forms.App);

MMD.Deploys.Forms.Environment = Ext.extend(Ext.FormPanel, {

  initComponent: function() {
    appId = this.appId;

    Ext.apply(this, {
      url:'/environments.json',
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
          name: 'app_id',
          xtype: 'hidden',
          value: appId
        }, {
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
                  itemId: 'name',
                  fieldLabel: 'Name',
                  name: 'name'
                }, {
                  itemId: 'deploymen_mode',
                  fieldLabel: 'Deployment Mode',
                  name: 'deployment_mode'
                }
              ]
            }
          ]
        }
      ]
    });
    // call the superclass's initComponent implementation
    MMD.Deploys.Forms.App.superclass.initComponent.call(this);
  }
});
Ext.reg('deployFormsEnvironment', MMD.Deploys.Forms.Environment);