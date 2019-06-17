/// 
Class BI.ViewsHistoryCopy Extends %DeepSee.CubeDefinition [ DependsOn = (History.Views, BI.Post), ProcedureBlock ]
{

/// Cube definition from Architect.
XData Cube [ XMLNamespace = "http://www.intersystems.com/deepsee" ]
{
<cube xmlns="http://www.intersystems.com/deepsee" name="ViewsHistoryCopy" displayName="ViewsHistoryCopy" disabled="false" abstract="false" sourceClass="History.Views" countMeasureName="ViewsCount" bucketSize="8" bitmapChunkInMemory="false" precompute="0" disableListingGroups="false">
  <dimension name="Language" disabled="false" sharesFrom="Post" hasAll="false" allCaption="All Language" allDisplayName="Language" type="data" hidden="false" showHierarchies="default">
  </dimension>
  <measure name="ViewsH" disabled="false" sourceProperty="Views" aggregate="SUM" type="number" hidden="false" searchable="false">
  </measure>
</cube>
}

/*
ClassMethod %OnGetFilterSpec(pFilterSpec As %String) As %String
{
	if ($username = "esdevcom") {
	//if ($username = "UnknownUser") {
		quit "[Language].[H1].[Language].[es]"
	} else {
		quit "[Language].[H1].[Language].[en]"
	}
}
*/
Parameter DOMAIN;

}

