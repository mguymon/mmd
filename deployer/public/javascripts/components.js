Ext.ns('MMD');

MMD.Detail = Ext.extend(Ext.Panel, {
	
	initComponent: function() {
    Ext.apply(this, Ext.apply(
      {
        tplMarkup: [
          ''
        ],
        bodyStyle: {
          background: '#ffffff',
          padding: '7px'
        },
        html: ''
      },
      this.initialConfig )
    );

    this.defaultHtml = this.html;

		this.tpl = new Ext.Template(this.tplMarkup);

		// call the superclass's initComponent implementation
		MMD.Detail.superclass.initComponent.call(this);
	},
	// add a method which updates the details
	updateDetail: function(data) {
		this.tpl.overwrite(this.body, data);
	},
  resetDetail: function(override) {
    if ( override === undefined ) {
      this.update( this.defaultHtml );
    } else {
      this.update( override );
    }
  }
});
Ext.reg('mmdDetail', MMD.Detail);
