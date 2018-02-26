/// 
Class BI.Post Extends %DeepSee.CubeDefinition [ DependsOn = Community.Post, ProcedureBlock ]
{

/// Cube definition from Architect.
XData Cube [ XMLNamespace = "http://www.intersystems.com/deepsee" ]
{
<cube xmlns="http://www.intersystems.com/deepsee" name="Post" displayName="Post" disabled="false" abstract="false" sourceClass="Community.Post" buildRestriction="Published=1 AND Deleted=0" countMeasureName="PostCount" bucketSize="8" bitmapChunkInMemory="false" precompute="0" disableListingGroups="false">
  <dimension name="Name" disabled="false" hasAll="false" allCaption="All Name" allDisplayName="Name" type="data" hidden="false" showHierarchies="default">
    <hierarchy name="H1" disabled="false" hidden="false">
      <level name="Name" disabled="false" sourceProperty="%ID" list="false" useDisplayValue="true" useAsFilter="true" hidden="false">
        <property name="Name" disabled="false" sourceProperty="Name" hidden="false" isName="true" isDescription="false" isReference="false" useDisplayValue="false">
          <additionalDescription>undefined</additionalDescription>
        </property>
        <property name="PublishedDate" disabled="false" sourceProperty="PublishedDate" hidden="false" isName="false" isDescription="false" isReference="false" useDisplayValue="false">
        </property>
      </level>
    </hierarchy>
  </dimension>
  <dimension name="Link" disabled="true" hasAll="false" allCaption="All Link" allDisplayName="Link" type="data" calendar="gregorian" iKnowType="entity" hidden="false" showHierarchies="default">
    <hierarchy name="H1" disabled="false" hidden="false">
      <level name="Link" disabled="false" sourceProperty="Link" list="false" useDisplayValue="true" useAsFilter="true" hidden="false">
      </level>
    </hierarchy>
  </dimension>
  <dimension name="AuthorName" disabled="false" hasAll="true" allCaption="All Name1" allDisplayName="Name1" type="data" calendar="gregorian" iKnowType="entity" hidden="false" showHierarchies="default">
    <hierarchy name="H1" disabled="false" hidden="false">
      <level name="AuthorName" disabled="false" sourceProperty="Author.%ID" list="false" useDisplayValue="true" useAsFilter="true" hidden="false">
        <property name="Name" disabled="false" sourceProperty="Author.Name" hidden="false" isName="true" isDescription="false" isReference="false" useDisplayValue="false">
          <additionalDescription>undefined</additionalDescription>
        </property>
      </level>
    </hierarchy>
  </dimension>
  <dimension name="CommentsAmount" disabled="false" hasAll="false" allCaption="All CommentsAmount" allDisplayName="CommentsAmount" type="data" hidden="false" showHierarchies="default">
    <hierarchy name="H1" disabled="false" hidden="false">
      <level name="CommentsAmount" disabled="false" sourceProperty="CommentsAmount" list="false" rangeExpression="0:Unanswered;(0,10000):Answered;" useDisplayValue="true" useAsFilter="true" hidden="false">
      </level>
    </hierarchy>
  </dimension>
  <dimension name="DayName" disabled="true" hasAll="false" allCaption="All Created1" allDisplayName="Created1" sourceProperty="Created" type="data" calendar="gregorian" iKnowType="entity" hidden="false" showHierarchies="default">
    <hierarchy name="H1" disabled="false" hidden="false">
      <level name="PostDayName" disabled="false" sourceExpression="$s($zd($zdh(%source.Created,3),10)=0:7,1:$zd($zdh(%source.Created,3),10))_&quot;.&quot;_$zd($zdh(%source.Created,3),12)" list="false" useDisplayValue="true" useAsFilter="true" hidden="false">
      </level>
    </hierarchy>
  </dimension>
  <dimension name="Company" disabled="true" hasAll="false" allCaption="All Company" allDisplayName="Company" type="data" calendar="gregorian" iKnowType="entity" hidden="false" showHierarchies="default">
    <hierarchy name="H1" disabled="false" hidden="false">
      <level name="Company" disabled="false" sourceProperty="Author.Company" list="false" useDisplayValue="true" useAsFilter="true" hidden="false">
      </level>
    </hierarchy>
  </dimension>
  <dimension name="Group" disabled="false" hasAll="false" allCaption="All Name1" allDisplayName="Name1" type="data" calendar="gregorian" iKnowType="entity" hidden="false" showHierarchies="default">
    <hierarchy name="H1" disabled="false" hidden="false">
      <level name="GroupName" disabled="false" sourceExpression="%cube.GetGroupName(%source.%ID,&quot;Name&quot;)" list="true" listDelimiter="," useDisplayValue="true" useAsFilter="true" hidden="false">
      </level>
      <level name="PostName" disabled="false" sourceProperty="%ID" list="false" useDisplayValue="true" useAsFilter="true" hidden="false">
        <property name="Name" disabled="false" sourceProperty="Name" hidden="false" isName="true" isDescription="false" isReference="false" useDisplayValue="false">
          <additionalDescription>undefined</additionalDescription>
        </property>
      </level>
    </hierarchy>
  </dimension>
  <dimension name="DateDimension" disabled="false" hasAll="false" allCaption="All Created1" allDisplayName="Created1" sourceProperty="Created" type="time" calendar="gregorian" iKnowType="entity" hidden="false" showHierarchies="default">
    <additionalDescription>undefined</additionalDescription>
    <hierarchy name="H2" disabled="false" hidden="false">
      <level name="MonthNum" displayName="Month" disabled="false" timeFunction="MonthNumber" list="false" useDisplayValue="true" useAsFilter="true" hidden="false">
      </level>
    </hierarchy>
    <hierarchy name="H1" disabled="false" hidden="false">
      <level name="Year" disabled="false" timeFunction="Year" list="false" useDisplayValue="true" useAsFilter="true" hidden="false">
      </level>
      <level name="MonthYear" displayName="Month Year" disabled="false" timeFunction="MonthYear" list="false" useDisplayValue="true" useAsFilter="true" hidden="false">
      </level>
      <level name="WeekYear" disabled="false" timeFunction="WeekYear" list="false" useDisplayValue="true" useAsFilter="true" hidden="false">
      </level>
      <level name="DayMonthYear" disabled="false" timeFunction="DayMonthYear" list="false" useDisplayValue="true" useAsFilter="true" hidden="false">
      </level>
    </hierarchy>
  </dimension>
  <dimension name="PostType" disabled="false" hasAll="false" allCaption="All PostType" allDisplayName="PostType" type="data" hidden="false" showHierarchies="default">
    <hierarchy name="H1" disabled="false" hidden="false">
      <level name="PostType" disabled="false" sourceProperty="PostType" list="false" nullReplacement="Unknown" useDisplayValue="true" useAsFilter="true" hidden="false">
      </level>
    </hierarchy>
  </dimension>
  <dimension name="Tags" disabled="false" hasAll="false" allCaption="All Tags" allDisplayName="Tags" type="data" hidden="false" showHierarchies="default">
    <hierarchy name="H1" disabled="false" hidden="false">
      <level name="Tags" disabled="false" sourceProperty="Tags" list="true" listDelimiter="," nullReplacement="Not determined" useDisplayValue="true" useAsFilter="true" hidden="false">
      </level>
    </hierarchy>
  </dimension>
  <dimension name="Rating" disabled="false" hasAll="false" allCaption="All New_dataDimension1" allDisplayName="New_dataDimension1" type="data" calendar="gregorian" iKnowType="entity" hidden="false" showHierarchies="default">
    <additionalDescription>undefined</additionalDescription>
    <hierarchy name="H1" disabled="false" hidden="false">
      <level name="Rating" disabled="false" sourceProperty="AvgVote" list="false" useDisplayValue="true" useAsFilter="true" hidden="false">
      </level>
    </hierarchy>
  </dimension>
  <dimension name="iKnow" disabled="false" hasAll="false" allCaption="All Text" allDisplayName="Text" type="data" calendar="gregorian" iKnowType="entity" hidden="false" showHierarchies="default">
    <hierarchy name="H1" disabled="false" hidden="false">
      <level name="iKnowConcept" displayName="iKnowConcept" disabled="false" sourceExpression="##class(Community.iKnow.Post).GetFirstSetsAndConceptsByID(%source.%ID)" list="true" listDelimiter="," useDisplayValue="true" useAsFilter="true" hidden="false">
      </level>
    </hierarchy>
  </dimension>
  <dimension name="CorrectAnswer" displayName="Correct Answer" disabled="false" hasAll="false" allCaption="All HasCorrectAnswer" allDisplayName="HasCorrectAnswer" type="data" calendar="gregorian" iKnowType="entity" hidden="false" showHierarchies="default">
    <hierarchy name="H1" disabled="false" hidden="false">
      <level name="HasCorrectAnswer" disabled="false" sourceProperty="HasCorrectAnswer" list="false" useDisplayValue="true" useAsFilter="true" hidden="false">
      </level>
    </hierarchy>
  </dimension>
  <dimension name="Published" disabled="false" hasAll="false" allCaption="All Published" allDisplayName="Published" type="data" hidden="false" showHierarchies="default">
    <hierarchy name="H1" disabled="false" hidden="false">
      <level name="Published" disabled="false" sourceProperty="Published" list="false" useDisplayValue="true" useAsFilter="true" hidden="false">
      </level>
    </hierarchy>
  </dimension>
  <dimension name="AcceptedAnswerTS" disabled="false" hasAll="false" allCaption="All AcceptedAnswerTS" allDisplayName="AcceptedAnswerTS" sourceProperty="AcceptedAnswerTS" type="time" calendar="gregorian" hidden="false" showHierarchies="default">
    <hierarchy name="H1" disabled="false" hidden="false">
      <level name="AnswerYear" disabled="false" timeFunction="Year" list="false" useDisplayValue="true" useAsFilter="true" hidden="false">
      </level>
      <level name="AnswerMonthYear" disabled="false" timeFunction="MonthYear" list="false" useDisplayValue="true" useAsFilter="true" hidden="false">
      </level>
      <level name="AnswerDayMonthYear" disabled="false" timeFunction="DayMonthYear" list="false" useDisplayValue="true" useAsFilter="true" hidden="false">
      </level>
    </hierarchy>
  </dimension>
  <measure name="CommentsAmount" disabled="false" sourceProperty="CommentsAmount" aggregate="SUM" type="number" hidden="false" searchable="false">
  </measure>
  <measure name="Posts" disabled="false" sourceProperty="%ID" aggregate="COUNT" type="number" hidden="false" searchable="false" formatString="#">
  </measure>
  <measure name="Views" disabled="false" sourceProperty="Views" aggregate="SUM" type="number" hidden="false" searchable="false" formatString="#,#">
  </measure>
  <measure name="Published" disabled="false" sourceProperty="Published" aggregate="COUNT" type="boolean" hidden="false" searchable="false">
  </measure>
  <measure name="PostRating" displayName="Post Rating" disabled="false" sourceProperty="AvgVote" aggregate="SUM" type="number" scale="0" hidden="false" searchable="false" formatString="#;;;;">
  </measure>
  <measure name="SubsCount" displayName="Subscriptions" disabled="false" sourceProperty="SubsCount" aggregate="SUM" type="number" hidden="false" searchable="false" formatString="#">
  </measure>
  <listing name="New_listing1" disabled="false" listingType="table" fieldList="Link,Name As Post,Created,Views,CommentsAmount As Comments,AvgVote as Votes,SubsCount as Favorites,Author-&gt;Name as Author">
  </listing>
</cube>
}

ClassMethod GetAddedPercent(date)
{
	set result = 0, current = 0, previous = 1
	
	set date = $zdh(date,3)
	
	set start = $piece($zdate(date,3),"-",1,2)_"-01"
	set end = $piece($zdate(date,3),"-",1)_"-"
	set:(+$piece($zdate(date,3),"-",2))<12 end = end_($piece($zdate(date,3),"-",2)+1)_"-01"
	set:(+$piece($zdate(date,3),"-",2))=12 end = (end+1)_"-01-01"
	set start = $zd($zdh(start,3),3), end = $zd($zdh(end,3),3)
	
	set sql = "Select Count(Id) As Amount From Community.Post Where Created >= ? And Created < ?"
	set rs = ##class(%SQL.Statement).%ExecDirect(,sql,start_" 00:00:00",end_" 00:00:00")
	if rs.%Next(){
		set current = rs.Amount
	}
	
	set end = start
	set start = $piece(end,"-",1)_"-"
	set:(+$piece(end,"-",2))>1 start = start_($piece($zdate(date,3),"-",2)-1)_"-01"
	set:(+$piece(end,"-",2))=1 start = (start-1)_"-12-01"
	set start = $zd($zdh(start,3),3), end = $zd($zdh(end,3),3)
	
	set rs = ##class(%SQL.Statement).%ExecDirect(,sql,start_" 00:00:00",end_" 00:00:00")
	if rs.%Next(){
		set previous = rs.Amount
	}
	
	set:previous'=0 result = (current-previous)/previous
	set:previous=0 result = current
	Quit result
}

ClassMethod GetGroupName(postId, prop As %String) As %String
{
	set result = ""
	set sql = "Select GroupClass->"_prop_" As GroupProp From Community.GroupPost Where Post = ?"
	set rs = ##class(%SQL.Statement).%ExecDirect(,sql, postId)
	while rs.%Next(){
		if result = "" {set result = rs.GroupProp}
		else{set result = result_","_rs.GroupProp}
	}
	Quit result
}

ClassMethod GetViewsHistoryDelta(date As %Date) As %Integer
{
	set date = $zdh(date,3)
	set preDateViews = 0, dateViews = 0
	set sql = "Select Sum(Views) As PreDateViews From History.Views Where DateOfData = "_(date-1)
	set rs = ##class(%SQL.Statement).%ExecDirect(,sql)
	if rs.%Next(){
		set preDateViews = rs.PreDateViews
	}
	set sql = "Select Sum(Views) As DateViews From History.Views Where DateOfData = "_date
	set rs = ##class(%SQL.Statement).%ExecDirect(,sql)
	if rs.%Next(){
		set dateViews = rs.DateViews
	}
	Quit dateViews - preDateViews
}

ClassMethod GetDaysNumber(date, id)
{
	set result = 0
	set daysAmount = $select(
		$piece($zdt($now(300),3),"-",1,2)=$piece(date,"-",1,2):$zdt($now(300)+1,3),
		$piece(date,"-",2)'=12:$piece(date,"-",1)_"-"_($piece(date,"-",2)+1)_"-01",
		1:($piece(date,"-",1)+1)_"-01-01"
		)
	set daysAmount = $piece($zdt($zdh(daysAmount,3)-1,3),"-",*)
	set minDate = $piece($piece(date," "),"-",1,2)_"-01 00:00:00"
	set maxDate = $piece($piece(date," "),"-",1,2)_"-"_daysAmount_" 23:59:59"
	
	set sql = "Select Max(Id) As MaxId From Community.Post Where Created < '"_maxDate_"' And Created > '"_minDate_"'"
	set rs = ##class(%SQL.Statement).%ExecDirect(,sql)
	if rs.%Next(){
		set maxId = rs.MaxId
	}
	if maxId = id {set result = daysAmount}
	Quit result
}

Parameter DOMAIN;

}

