/// 
Class BI.Member Extends %DeepSee.CubeDefinition [ DependsOn = Community.Member, ProcedureBlock ]
{

/// Cube definition from Architect.
XData Cube [ XMLNamespace = "http://www.intersystems.com/deepsee" ]
{
<cube xmlns="http://www.intersystems.com/deepsee" name="Member" displayName="Member" disabled="false" abstract="false" sourceClass="Community.Member" countMeasureName="%COUNT" bucketSize="8" bitmapChunkInMemory="false" precompute="0" disableListingGroups="false">
  <dimension name="Link" disabled="false" hasAll="false" allCaption="All Link" allDisplayName="Link" type="data" hidden="false" showHierarchies="default">
    <hierarchy name="H1" disabled="false" hidden="false">
      <level name="Link" disabled="false" sourceProperty="Link" list="false" useDisplayValue="true" useAsFilter="true" hidden="false">
      </level>
    </hierarchy>
  </dimension>
  <dimension name="Name" disabled="false" hasAll="false" allCaption="All Name" allDisplayName="Name" type="data" hidden="false" showHierarchies="default">
    <hierarchy name="H1" disabled="false" hidden="false">
      <level name="Name" disabled="false" sourceProperty="Name" factName="DxName" list="false" useDisplayValue="true" useAsFilter="true" hidden="false">
        <property name="Created" disabled="false" sourceExpression="$P(%source.Created,&quot; &quot;)" hidden="false" isName="false" isDescription="false" isReference="false" useDisplayValue="false">
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
      <level name="MonthYear" disabled="false" timeFunction="MonthYear" list="false" useDisplayValue="true" useAsFilter="true" hidden="false">
      </level>
      <level name="WeekYear" disabled="false" timeFunction="WeekYear" list="false" useDisplayValue="true" useAsFilter="true" hidden="false">
      </level>
      <level name="DayMonthYear" disabled="false" timeFunction="DayMonthYear" list="false" useDisplayValue="true" useAsFilter="true" hidden="false">
      </level>
    </hierarchy>
  </dimension>
  <measure name="MembersAmountBeforeDate" disabled="true" sourceExpression="%cube.GetMembersAmountBeforeDate(%source.Created)" aggregate="MAX" type="integer" hidden="false" searchable="false">
  </measure>
  <measure name="Views" disabled="true" sourceExpression="%cube.GetViewsOfAuthor(%source.%ID)" aggregate="SUM" type="number" hidden="false" searchable="false">
  </measure>
  <measure name="CreatedPercent" disabled="true" sourceExpression="%cube.GetCreatedPercent(%source.Created)" aggregate="MAX" type="number" hidden="false" searchable="false" formatString="#%">
  </measure>
  <measure name="MembersAmountBeforeDateMonth" disabled="true" sourceExpression="%cube.GetMembersAmountBeforeDate($zdateh($piece($zdate(%source.Created,3),&quot;-&quot;,1,2)_&quot;-01&quot;,3))" aggregate="AVG" type="integer" hidden="false" searchable="false">
  </measure>
  <listing name="New_listing1" disabled="false" listingType="table" fieldList="Name,Link">
  </listing>
</cube>
}

ClassMethod GetMembersAmountBeforeDate(date)
{
	set result = 0
	set sql = "Select Count(Id) As Amount From Community.Member Where Created <= ?"
#;	set:$data(ISC) sql = sql_" And ISCMember = "_ISC
	set rs = ##class(%SQL.Statement).%ExecDirect(,sql,date)
	if rs.%Next(){
		set result = rs.Amount
	}
	Quit result
}

ClassMethod GetCreatedPercent(date)
{
	set result = 0, current = 0, previous = 1
	
	set start = $zdateh($piece($zdate(date,3),"-",1,2)_"-01",3)
	set end = $piece($zdate(date,3),"-",1)_"-"
	set:(+$piece($zdate(date,3),"-",2))<12 end = end_($piece($zdate(date,3),"-",2)+1)_"-01"
	set:(+$piece($zdate(date,3),"-",2))=12 end = (end+1)_"-01-01"
	set end = $zdateh(end,3)
	
	set sql = "Select Count(Id) As Amount From Community.Member Where Created >= ? And Created < ?"
	set rs = ##class(%SQL.Statement).%ExecDirect(,sql,start,end)
	if rs.%Next(){
		set current = rs.Amount
	}
	
	set end = start
	set start = $piece($zdate(end,3),"-",1)_"-"
	set:(+$piece($zdate(end,3),"-",2))>1 start = start_($piece($zdate(date,3),"-",2)-1)_"-01"
	set:(+$piece($zdate(end,3),"-",2))=1 start = (start-1)_"-12-01"
	set start = $zdateh(start,3)
	
	set rs = ##class(%SQL.Statement).%ExecDirect(,sql,start,end)
	if rs.%Next(){
		set previous = rs.Amount
	}
	
	set:previous'=0 result = (current-previous)/previous
	set:previous=0 result = current
	Quit result
}

ClassMethod GetStartDate(added) As %Boolean
{
	set result = 0
	set sql = "Select Count(Id) As MembersAmount From Community.Member Where Created < ?"
	set rs = ##class(%SQL.Statement).%ExecDirect(,sql,added)
	if rs.%Next(){
		set result = rs.MembersAmount
		}
	Quit 'result
}

ClassMethod GetViewsOfAuthor(authorId) As %Integer
{
	set result = 0
	set sql = "Select Sum(Views) As Views From Community.Post Where Author = ?"
	set rs = ##class(%SQL.Statement).%ExecDirect(,sql,authorId)
	if rs.%Next(){
		set result = rs.Views
		}
	Quit result
}

Parameter DOMAIN;

}

