Ext.ns('MMD', 'MMD.Deploys', 'MMD.Deploys.Windows');

Ext.onReady(function() {

  MMD.Deploys.Windows.BluePrint = Ext.extend(Ext.Window, {

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
              
              reviewWindow = this;

              container = this.ownerCt.ownerCt;
              fieldSet = container.get('form');
              form = fieldSet.getForm();
              form_values = form.getFieldValues();
              record = form.record;

              data = '_method=' + form_values._method;
              data = Ext.urlEncode( {authenticity_token: FORM_TOKEN} );
              
              delete form_values._method;
              
              for( key in form_values ) {
                data += '&blueprint[' + key + ']=' + escape(form_values[key]);
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
                      MMD.Deploys.Store.blueprints.load( {} );
                      Ext.MessageBox.alert('Status', 'Blueprint has been saved');

                    } else {
                      messages = result.errors;
                      errors = "<ul><li>";
                      errors += messages.join("</li><li>" );
                      errors += "</li></ul>";
                      Ext.MessageBox.alert('Status', 'Failed to save Blueprint: <br/><br/>' + errors);
                    }
                  },
                  failure: function ( result, request) {
                    button.enable();
                    Ext.MessageBox.alert('Status', 'Failed to save Blueprint');
                  }
              });

            }
          }

        ]
      });

      // finally call the superclasses implementation
      MMD.Deploys.Windows.BluePrint.superclass.initComponent.call(this);
    }
  });
});