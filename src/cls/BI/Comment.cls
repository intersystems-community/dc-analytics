/// 
Class BI.Comment Extends %DeepSee.CubeDefinition [ DependsOn = Community.Comment, ProcedureBlock ]
{

/// Cube definition from Architect.
XData Cube [ XMLNamespace = "http://www.intersystems.com/deepsee" ]
{
<cube xmlns="http://www.intersystems.com/deepsee" name="Comment" displayName="Comment" disabled="false" abstract="false" sourceClass="Community.Comment" countMeasureName="%COUNT" bucketSize="8" bitmapChunkInMemory="false" precompute="0" disableListingGroups="false">
  <dimension name="Post" disabled="false" hasAll="false" allCaption="All Post" allDisplayName="Post" type="data" hidden="false" showHierarchies="default">
    <hierarchy name="H1" disabled="false" hidden="false">
      <level name="AuthorName" disabled="false" sourceProperty="Post.Author.Name" list="false" useDisplayValue="true" useAsFilter="true" hidden="false">
      </level>
    </hierarchy>
    <hierarchy name="H3" disabled="false" hidden="false">
      <level name="Link" disabled="false" sourceProperty="Post.Link" list="false" useDisplayValue="true" useAsFilter="true" hidden="false">
      </level>
    </hierarchy>
    <hierarchy name="H4" disabled="false" hidden="false">
      <level name="PostName" disabled="false" sourceProperty="Post.Name" list="false" useDisplayValue="true" useAsFilter="true" hidden="false">
      </level>
    </hierarchy>
  </dimension>
  <dimension name="Group" disabled="false" hasAll="false" allCaption="All %ID" allDisplayName="%ID" type="data" calendar="gregorian" iKnowType="entity" hidden="false" showHierarchies="default">
    <hierarchy name="H1" disabled="false" hidden="false">
      <level name="GroupName" disabled="false" sourceExpression="%cube.GetGroupName(%source.Post.%ID,&quot;Name&quot;)" list="false" useDisplayValue="true" useAsFilter="true" hidden="false">
      </level>
      <level name="PostName" disabled="false" sourceProperty="Post.Name" list="false" useDisplayValue="true" useAsFilter="true" hidden="false">
      </level>
    </hierarchy>
  </dimension>
  <dimension name="AuthorName" disabled="false" hasAll="false" allCaption="All Name" allDisplayName="Name" type="data" calendar="gregorian" iKnowType="entity" hidden="false" showHierarchies="default">
    <additionalDescription>undefined</additionalDescription>
    <hierarchy name="H1" disabled="false" hidden="false">
      <level name="AuthorName" disabled="false" sourceProperty="Author.%ID" list="false" useDisplayValue="true" useAsFilter="true" hidden="false">
        <property name="Name" disabled="false" sourceProperty="Author.Name" hidden="false" isName="true" isDescription="false" isReference="false" useDisplayValue="false">
          <additionalDescription>undefined</additionalDescription>
        </property>
        <property name="Email" disabled="false" sourceProperty="Author.Email" hidden="false" isName="false" isDescription="false" isReference="false" useDisplayValue="false">
        </property>
      </level>
    </hierarchy>
  </dimension>
  <dimension name="ISCMember" disabled="false" hasAll="false" allCaption="All ISCMember" allDisplayName="ISCMember" type="data" hidden="false" showHierarchies="default">
    <hierarchy name="H1" disabled="false" hidden="false">
      <level name="ISCMember" disabled="false" sourceProperty="Author.ISCMember" list="false" nullReplacement="No" rangeExpression="1:&quot;InterSystems&quot;;0:&quot;Customers&quot;;" useDisplayValue="true" useAsFilter="true" hidden="false">
      </level>
    </hierarchy>
  </dimension>
  <dimension name="DateDimension" disabled="false" hasAll="false" allCaption="All Created1" allDisplayName="Created1" sourceProperty="Created" type="time" calendar="gregorian" iKnowType="entity" hidden="false" showHierarchies="default">
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
  </dimension>
  <dimension name="Department" disabled="false" hasAll="false" allCaption="All Department" allDisplayName="Department" type="data" hidden="false" showHierarchies="default">
    <hierarchy name="H1" disabled="false" hidden="false">
      <level name="Department" disabled="false" sourceProperty="Author.Department" list="false" useDisplayValue="true" useAsFilter="true" hidden="false">
      </level>
    </hierarchy>
  </dimension>
  <dimension name="OfficeLocation" disabled="false" hasAll="false" allCaption="All OfficeLocation" allDisplayName="OfficeLocation" type="data" hidden="false" showHierarchies="default">
    <hierarchy name="H1" disabled="false" hidden="false">
      <level name="OfficeLocation" disabled="false" sourceProperty="Author.OfficeLocation" list="false" useDisplayValue="true" useAsFilter="true" hidden="false">
      </level>
    </hierarchy>
  </dimension>
  <dimension name="PostType" disabled="false" hasAll="false" allCaption="All PostType" allDisplayName="PostType" type="data" hidden="false" showHierarchies="default">
    <hierarchy name="H1" disabled="false" hidden="false">
      <level name="PostType" disabled="false" sourceProperty="Post.PostType" list="false" useDisplayValue="true" useAsFilter="true" hidden="false">
      </level>
    </hierarchy>
  </dimension>
  <dimension name="Type" disabled="false" hasAll="false" allCaption="All Type" allDisplayName="Type" type="data" calendar="gregorian" iKnowType="entity" hidden="false" showHierarchies="default">
    <hierarchy name="H1" disabled="false" hidden="false">
      <level name="Type" disabled="false" sourceProperty="Type" list="false" useDisplayValue="true" useAsFilter="true" hidden="false">
      </level>
    </hierarchy>
  </dimension>
  <dimension name="Tags" disabled="false" hasAll="false" allCaption="All Tags" allDisplayName="Tags" type="data" hidden="false" showHierarchies="default">
    <hierarchy name="H1" disabled="false" hidden="false">
      <level name="Tags" disabled="false" sourceProperty="Post.Tags" list="true" listDelimiter="," useDisplayValue="true" useAsFilter="true" hidden="false">
      </level>
    </hierarchy>
  </dimension>
  <measure name="CommentRating" displayName="Comment Rating" disabled="false" sourceProperty="AvgVote" aggregate="SUM" type="number" scale="0" hidden="false" searchable="false">
  </measure>
  <listing name="New_listing1" disabled="false" listingType="table" fieldList="Link,Post-&gt;Name As Post,AvgVote as Rating,Created,&apos;&lt;a href=&quot;&apos;||$Extract(Author-&gt;Link,7,Length(Author-&gt;Link))||&apos;&quot; target=&quot;_blank&quot; onclick=&quot;var e=event||window.event;e.stopPropagation();e.cancelBubble=true;&quot;&gt;&apos;||Author-&gt;Name||&apos;&lt;/a&gt;&apos; As Author">
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
	
	set sql = "Select Count(Id) As Amount From Community.Comment Where Created >= ? And Created < ?"
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

ClassMethod GSContestOrAllDate(date As %Date, groupName As %String) As %String
{
	set date = $zdh(date,3)
	set result = "NonGSContest"
	if (date<=63977)&(date>=63963)&(groupName'="Developer Community Feedback") {set result = "GSContest"} //2016-02-15 - 2016-02-29
	elseif (date<=63993)&(date>=63980)
	&(groupName'="Developer Community Feedback")
	&(groupName'="Announcements")
	&(groupName'="Alerts") {set result = "GSContest-2"} //2016-03-03 - 2016-03-16
	Quit result
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
	
	set sql = "Select Max(Id) As MaxId From Community.Comment Where Created < '"_maxDate_"' And Created > '"_minDate_"'"
	set rs = ##class(%SQL.Statement).%ExecDirect(,sql)
	if rs.%Next(){
		set maxId = rs.MaxId
	}
	if maxId = id {set result = daysAmount}
	Quit result
}

Parameter DOMAIN;

}

