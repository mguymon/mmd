Ext.ns('MMD', 'MMD.Deploys', 'MMD.Deploys.Fields' );

MMD.Deploys.Fields.blueprintsCombo = Ext.extend(Ext.form.ComboBox, {

  initComponent: function() {
    Ext.apply(this, Ext.apply( 
      {
        xtype: 'combo',
        fieldLabel: 'Blueprint',
        store: MMD.Deploys.Store.eveBlueprints,
        value: '',
        valueField: 'typeID',
        displayField:'typeName',
        displayValue: '',
        hiddenName: 'blueprintTypeID',
        mode: 'remote',
        allowBlank: false,
        triggerAction: 'all',
        typeAhead: true,
        selectOnFocus: true
      },
      this.initialConfig )
    );
    MMD.Deploys.Fields.blueprintsCombo.superclass.initComponent.call(this);
  }
});
Ext.reg('blueprintsCombo', MMD.Deploys.Fields.blueprintsCombo);

        
MMD.Deploys.Fields.categoryCombo = Ext.extend(Ext.form.ComboBox, {

  initComponent: function() {
    Ext.apply(this, Ext.apply( 
      {
        xtype: 'combo',
        fieldLabel: 'Category',
        store: new Ext.data.ArrayStore({
            fields: [ 'name', 'id'],
            data : [
              ['All', '' ],
              ['Ammo / Charges', '11' ],
              ['Components', '1035' ],
              ['Modules', '9'],
              ['Rigs', '1111'],
              ['Ships', '2' ],
              ['Subsystems', '1112' ] ]
        }),
        value: '',
        valueField: 'id',
        displayField:'name',
        hiddenName: 'id',
        mode: 'local',
        allowBlank: false,
        triggerAction: 'all',
        lazyRender:true
      },
      this.initialConfig )
    );
    MMD.Deploys.Fields.categoryCombo.superclass.initComponent.call(this);
  }
});
Ext.reg('categoryCombo', MMD.Deploys.Fields.categoryCombo);