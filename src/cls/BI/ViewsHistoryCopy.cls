/// 
Class BI.ViewsHistoryCopy Extends %DeepSee.CubeDefinition [ DependsOn = History.Views, ProcedureBlock ]
{

/// Cube definition from Architect.
XData Cube [ XMLNamespace = "http://www.intersystems.com/deepsee" ]
{
<cube xmlns="http://www.intersystems.com/deepsee" name="ViewsHistoryCopy" displayName="ViewsHistoryCopy" disabled="false" abstract="false" sourceClass="History.Views" countMeasureName="ViewsCount" bucketSize="8" bitmapChunkInMemory="false" precompute="0" disableListingGroups="false">
  <measure name="ViewsH" disabled="false" sourceProperty="Views" aggregate="SUM" type="number" hidden="false" searchable="false">
  </measure>
</cube>
}

Parameter DOMAIN;

}

