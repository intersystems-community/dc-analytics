/// 
Class BI.ViewsHistory Extends %DeepSee.CubeDefinition [ DependsOn = History.Views, ProcedureBlock ]
{

/// Cube definition from Architect.
XData Cube [ XMLNamespace = "http://www.intersystems.com/deepsee" ]
{
<cube xmlns="http://www.intersystems.com/deepsee" name="ViewsHistory" displayName="ViewsHistory" disabled="false" abstract="false" sourceClass="History.Views" buildRestriction="Post-&gt;Published=1 AND Post-&gt;Deleted=0" countMeasureName="%COUNT" bucketSize="8" bitmapChunkInMemory="false" precompute="0" disableListingGroups="false">
  <dimension name="DateDimension" disabled="false" hasAll="false" allCaption="All DateOfData1" allDisplayName="DateOfData1" sourceProperty="DateOfData" type="time" calendar="gregorian" iKnowType="entity" hidden="false" showHierarchies="default">
    <additionalDescription>undefined</additionalDescription>
    <hierarchy name="H1" disabled="false" hidden="false">
      <level name="Year" disabled="false" timeFunction="Year" list="false" useDisplayValue="true" useAsFilter="true" hidden="false">
      </level>
      <level name="MonthYear" disabled="false" timeFunction="MonthYear" list="false" useDisplayValue="true" useAsFilter="true" hidden="false">
      </level>
      <level name="WeekYear" disabled="false" timeFunction="WeekYear" list="false" useDisplayValue="true" useAsFilter="true" hidden="false">
      </level>
      <level name="DayMonthYear" disabled="false" timeFunction="DayMonthYear" list="false" useDisplayValue="true" useAsFilter="true" hidden="false">
      </level>
    </hierarchy>
    <hierarchy name="H2" disabled="false" hidden="false">
      <level name="MonthYear" disabled="false" timeFunction="MonthYear" list="false" useDisplayValue="true" useAsFilter="true" hidden="false">
      </level>
      <level name="Day" disabled="false" timeFunction="DayMonthYear" list="false" useDisplayValue="true" useAsFilter="true" hidden="false">
      </level>
    </hierarchy>
  </dimension>
  <dimension name="Name" disabled="false" hasAll="false" allCaption="All Name" allDisplayName="Name" type="data" hidden="false" showHierarchies="default">
    <hierarchy name="H1" disabled="false" hidden="false">
      <level name="Name" disabled="false" sourceProperty="Post.Name" list="false" useDisplayValue="true" dependsOn="[Author].[H1].[Author],[PostType].[H1].[PostType]" useAsFilter="true" hidden="false">
      </level>
    </hierarchy>
  </dimension>
  <dimension name="Tags" disabled="false" hasAll="false" allCaption="All Tags" allDisplayName="Tags" type="data" hidden="false" showHierarchies="default">
    <hierarchy name="H1" disabled="false" hidden="false">
      <level name="Tags" disabled="false" sourceProperty="Post.Tags" list="true" listDelimiter="," useDisplayValue="true" useAsFilter="true" hidden="false">
      </level>
    </hierarchy>
  </dimension>
  <dimension name="PostType" disabled="false" hasAll="false" allCaption="All PostType" allDisplayName="PostType" type="data" hidden="false" showHierarchies="default">
    <hierarchy name="H1" disabled="false" hidden="false">
      <level name="PostType" disabled="false" sourceProperty="Post.PostType" list="false" nullReplacement="Unknown" useDisplayValue="true" useAsFilter="true" hidden="false">
      </level>
    </hierarchy>
  </dimension>
  <dimension name="Author" disabled="false" hasAll="false" allCaption="All Name1" allDisplayName="Name1" type="data" calendar="gregorian" iKnowType="entity" hidden="false" showHierarchies="default">
    <hierarchy name="H1" disabled="false" hidden="false">
      <level name="Author" disabled="false" sourceProperty="Post.Author.Name" list="false" useDisplayValue="true" useAsFilter="true" hidden="false">
      </level>
    </hierarchy>
  </dimension>
  <dimension name="PublishedDimension" disabled="false" hasAll="false" allCaption="All PublishedDate" allDisplayName="PublishedDate" sourceProperty="Post.PublishedDate" type="time" calendar="gregorian" iKnowType="entity" hidden="false" showHierarchies="default">
    <additionalDescription>undefined</additionalDescription>
    <hierarchy name="H1" disabled="false" hidden="false">
      <level name="Year" disabled="false" timeFunction="Year" list="false" useDisplayValue="true" useAsFilter="true" hidden="false">
      </level>
      <level name="MonthYear" displayName="Month" disabled="false" timeFunction="MonthYear" list="false" useDisplayValue="true" useAsFilter="true" hidden="false">
      </level>
      <level name="WeekYear" displayName="Week" disabled="false" timeFunction="WeekYear" list="false" useDisplayValue="true" useAsFilter="true" hidden="false">
      </level>
      <level name="DayMonthYear" displayName="Day" disabled="false" timeFunction="DayMonthYear" list="false" useDisplayValue="true" useAsFilter="true" hidden="false">
      </level>
    </hierarchy>
  </dimension>
  <dimension name="Language" disabled="false" hasAll="false" allCaption="All Lang" allDisplayName="Lang" type="data" calendar="gregorian" iKnowType="entity" hidden="false" showHierarchies="default">
    <hierarchy name="H1" disabled="false" hidden="false">
      <level name="Language" disabled="false" sourceProperty="Lang" list="false" useDisplayValue="true" useAsFilter="true" hidden="false">
      </level>
    </hierarchy>
  </dimension>
  <measure name="ViewsH" disabled="false" sourceProperty="Views" aggregate="SUM" type="number" hidden="false" searchable="false" formatString="#">
  </measure>
  <measure name="Delta" disabled="false" sourceProperty="Delta" aggregate="SUM" type="number" hidden="false" searchable="false" formatString="#,#">
  </measure>
  <measure name="ViewsMax" disabled="false" sourceProperty="Views" aggregate="MAX" type="number" hidden="false" searchable="false" formatString="#,###;;;;">
  </measure>
  <calculatedMember name="ViewsAVG" disabled="false" dimension="Measures" valueExpression="Measures.VIewsH/Measures.%Count" hidden="false">
  </calculatedMember>
  <calculatedMember name="ViewsMonthlyAVGRT" disabled="false" dimension="Measures" valueExpression="AGGREGATE([DateDimension].[H2].[MonthYear].CurrentMember.LASTCHILD,MEASURES.ViewsAVG) " formatString="#" hidden="false">
  </calculatedMember>
  <listing name="New_listing1" disabled="false" listingType="table" fieldList="Post-&gt;Link,Post-&gt;Name,Post-&gt;Created,Post-&gt;Views">
    <additionalDescription>undefined</additionalDescription>
  </listing>
</cube>
}

/*ClassMethod %OnGetFilterSpec(pFilterSpec As %String) As %String
{
	if ($username = "esdevcom") {
	//if ($username = "UnknownUser") {
		quit "[Language].[H1].[Language].[es]"
	} else {
		quit "[Language].[H1].[Language].[en]"
	}
}*/

Parameter DOMAIN;

}

