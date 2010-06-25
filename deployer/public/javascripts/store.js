Ext.ns('MMD');

MMD.Store = function(root, id, columns, config) {
	var config = config || {};
	Ext.applyIf(config, {
    reader: new Ext.data.JsonReader(
      {
        root: root,
        idProperty: id,
        totalProperty: 'total_entries'
      },
      columns)
	});
	// call the superclass's constructor
	MMD.Store.superclass.constructor.call(this, config);
};
Ext.extend(MMD.Store, Ext.data.Store);