/// 
Class BI.ChampPos Extends %DeepSee.CubeDefinition [ DependsOn = History.ChampionshipPositions, ProcedureBlock ]
{

/// Cube definition from Architect.
XData Cube [ XMLNamespace = "http://www.intersystems.com/deepsee" ]
{
<cube xmlns="http://www.intersystems.com/deepsee" name="ChampPos" displayName="ChampPos" disabled="false" abstract="false" sourceClass="History.ChampionshipPositions" countMeasureName="%COUNT" bucketSize="8" bitmapChunkInMemory="false" precompute="0" disableListingGroups="false">
  <dimension name="AuthorName" disabled="false" hasAll="true" allCaption="All Name" allDisplayName="Name" type="data" calendar="gregorian" iKnowType="entity" hidden="false" showHierarchies="default">
    <hierarchy name="H1" disabled="false" hidden="false">
      <level name="AuthorName" disabled="false" sourceProperty="Member.%ID" list="false" useDisplayValue="true" useAsFilter="true" hidden="false">
        <property name="Name" disabled="false" sourceProperty="Member.Name" hidden="false" isName="true" isDescription="false" isReference="false" useDisplayValue="false">
          <additionalDescription>undefined</additionalDescription>
        </property>
      </level>
    </hierarchy>
  </dimension>
  <dimension name="Group" disabled="true" hasAll="false" allCaption="All Name1" allDisplayName="Name1" type="data" calendar="gregorian" iKnowType="entity" hidden="false" showHierarchies="default">
    <additionalDescription>undefined</additionalDescription>
    <hierarchy name="H1" disabled="false" hidden="false">
      <level name="GroupName" disabled="false" sourceProperty="GroupClass.Name" list="false" useDisplayValue="true" useAsFilter="true" hidden="false">
      </level>
    </hierarchy>
  </dimension>
  <dimension name="DateDimension" disabled="false" hasAll="false" allCaption="All Added" allDisplayName="Added" sourceProperty="Added" type="time" calendar="gregorian" iKnowType="entity" hidden="false" showHierarchies="default">
    <hierarchy name="H2" disabled="false" hidden="false">
      <level name="MonthNum" displayName="Month" disabled="false" timeFunction="MonthNumber" list="false" useDisplayValue="true" useAsFilter="true" hidden="false">
      </level>
    </hierarchy>
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
  </dimension>
  <dimension name="Tags" disabled="true" hasAll="false" allCaption="All Tags" allDisplayName="Tags" type="data" calendar="gregorian" iKnowType="entity" hidden="false" showHierarchies="default">
    <hierarchy name="H1" disabled="false" hidden="false">
      <level name="Tags" disabled="false" sourceProperty="GroupClass.Tags" list="true" listDelimiter="," useDisplayValue="true" useAsFilter="true" hidden="false">
      </level>
    </hierarchy>
  </dimension>
  <dimension name="Language" disabled="false" hasAll="false" allCaption="All Lang" allDisplayName="Lang" type="data" calendar="gregorian" iKnowType="entity" hidden="false" showHierarchies="default">
    <hierarchy name="H1" disabled="false" hidden="false">
      <level name="Language" disabled="false" sourceProperty="Member.Lang" list="false" useDisplayValue="true" useAsFilter="true" hidden="false">
      </level>
    </hierarchy>
  </dimension>
  <measure name="Overall" disabled="false" sourceProperty="Overall" aggregate="SUM" type="number" hidden="false" searchable="false">
  </measure>
  <measure name="CommentVotes" disabled="false" sourceProperty="CommentVotes" aggregate="SUM" type="number" hidden="false" searchable="false">
  </measure>
  <measure name="Comments" disabled="false" sourceProperty="Comments" aggregate="SUM" type="number" hidden="false" searchable="false">
  </measure>
  <measure name="CommentsAmount" disabled="false" sourceProperty="CommentsAmount" aggregate="SUM" type="number" hidden="false" searchable="false">
  </measure>
  <measure name="PostVotes" disabled="false" sourceProperty="PostVotes" aggregate="SUM" type="number" hidden="false" searchable="false">
  </measure>
  <measure name="Posts" disabled="false" sourceProperty="Posts" aggregate="SUM" type="number" hidden="false" searchable="false">
  </measure>
  <measure name="Views" disabled="false" sourceProperty="Views" aggregate="SUM" type="number" hidden="false" searchable="false">
  </measure>
  <measure name="Subscriptions" disabled="false" sourceProperty="PostSubscriptions" aggregate="SUM" type="number" hidden="false" searchable="false" formatString="#">
  </measure>
  <listing name="New_listing1" disabled="false" listingType="table" fieldList="Added,CommentVotes,Comments,CommentsAmount,CorrectAnswers,Overall,PostSubscriptions,PostVotes,Posts,Views">
    <additionalDescription>undefined</additionalDescription>
  </listing>
</cube>
}

ClassMethod GetDelta(authorId, date)
{
	set result = 0
	set sql = "Select Position,Added From History.ChampionshipPositions Where "
		_"Member = ? And Added = ? Or Member = ? And Added = ? Group By Added"
	set rs = ##class(%SQL.Statement).%ExecDirect(,sql, authorId, date-1, authorId, date)
	while rs.%Next() {
		if (rs.Added = date)&(result = 0) {Quit}
		elseif (result=0){set result = rs.Position}
		else {set result = rs.Position - result}
	}
	Quit result
}

ClassMethod GSContestOrAllDate(date As %Date, groupName As %String) As %String
{
	set result = "NonGSContest"
	if (date<=63977)&(date>=63963)&(groupName'="Developer Community Feedback") {set result = "GSContest"} //2016-02-15 - 2016-02-29
	elseif (date<=63993)&(date>=63980)
	&(groupName'="Developer Community Feedback")
	&(groupName'="Announcements")
	&(groupName'="Alerts") {set result = "GSContest-2"} //2016-03-03 - 2016-03-16
	Quit result
}

Parameter DOMAIN;

ClassMethod %OnGetFilterSpec(pFilterSpec As %String) As %String
{
	if ($username = "esdevcom") {
	//if ($username = "UnknownUser") {
		quit "[Language].[H1].[Language].[es]"
	} else {
		quit "[Language].[H1].[Language].[en]"
	}
}

}

