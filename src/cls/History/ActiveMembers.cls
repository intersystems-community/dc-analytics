Class History.ActiveMembers Extends %Persistent [ DependsOn = Community.Member ]
{

Parameter DSTIME = "AUTO";

Property Member As Community.Member;

Index Member On Member [ Unique ];

Property Link As %String(MAXLEN = 250);

Property Added As %Date;

ClassMethod InsertActiveMembersHistory()
{
	set sql = "SELECT ActiveMemberId, Min(Added) AS MinAdded, Link "
			 _"FROM "
				_"(SELECT Author->Id AS ActiveMemberId, Created AS Added, Link "
				_"FROM Community.Comment "
					_"UNION ALL "
				_"SELECT Author->Id, Created, Link "
				_"FROM Community.Post) "
			 _"GROUP BY ActiveMemberId "
			 _"ORDER BY MinAdded"
		
	set rs = ##class(%SQL.Statement).%ExecDirect(,sql)
	
	while rs.%Next(){
		kill data
		
		set data("Added") = $zdh(rs.MinAdded,3)
		set data("ActiveMemberId") = rs.ActiveMemberId
		set data("Link") = rs.Link
		
		set sc = ##class(History.ActiveMembers).InsertOrUpdate(.data) 
		quit:$$$ISERR(sc)
	}
		
	quit sc
}

ClassMethod InsertOrUpdate(ByRef data) As %Status
{
	set sc = ##class(History.ActiveMembers).MemberExists(data("ActiveMemberId"))
	
	if sc {
		quit $$$OK
	} else { 
		set sc = ..Insert(.data)
	}
	
	quit sc
}

ClassMethod Insert(ByRef data) As %Status
{
	&sql(
		INSERT INTO History.ActiveMembers (Added,Member,Link)
		VALUES (:data("Added"), :data("ActiveMemberId"), :data("Link"))
	)
	if SQLCODE=0 {
		set data = %ROWID 
		quit $$$OK	
	}
	
	quit $$$ERROR($$$SQLError, SQLCODE, $get(%msg))
}

Storage Default
{
<Data name="ActiveMembersDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>All</Value>
</Value>
<Value name="3">
<Value>Active</Value>
</Value>
<Value name="4">
<Value>Added</Value>
</Value>
<Value name="5">
<Value>AllMembers</Value>
</Value>
<Value name="6">
<Value>ActiveMembers</Value>
</Value>
<Value name="7">
<Value>Member</Value>
</Value>
<Value name="8">
<Value>Link</Value>
</Value>
</Data>
<DataLocation>^History.ActiveMembersD</DataLocation>
<DefaultData>ActiveMembersDefaultData</DefaultData>
<IdLocation>^History.ActiveMembersD</IdLocation>
<IndexLocation>^History.ActiveMembersI</IndexLocation>
<StreamLocation>^History.ActiveMembersS</StreamLocation>
<Type>%Library.CacheStorage</Type>
}

}

