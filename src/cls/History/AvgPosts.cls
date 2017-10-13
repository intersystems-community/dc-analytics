Class History.AvgPosts Extends %Persistent
{

Parameter DSTIME = "AUTO";

Property Added As %Date;

Index Added On Added [ Unique ];

Property PerDay As %Float;

ClassMethod InsertAvgPostsHistory()
{
	set sql = "SELECT MIN(Created) AS MinCreated "
			 _"FROM Community.Post"
			 
	set rs = ##class(%SQL.Statement).%ExecDirect(,sql)
	if rs.%Next(){
		set minCreatedODBC = rs.MinCreated
		set minCreated = $zdh(minCreatedODBC,3)
		set daysAmount = +$now(300) - minCreated + 1
	}
	
	set todayDate = $zdt($now(300),3)
	set sql = "SELECT COUNT(Id) AS PostsAmount "
			 _"FROM Community.Post "
			 _"WHERE Created <= ?"
			 
	set rs = ##class(%SQL.Statement).%ExecDirect(,sql,todayDate)
	if rs.%Next(){
		set data("Added") = +$now(300)
		set data("PerDay") = (((rs.PostsAmount/daysAmount)*100)\1)/100
	}
		
	set sc = ##class(History.AvgPosts).InsertOrUpdate(.data)
	quit sc
}

ClassMethod InsertOrUpdate(ByRef data) As %Status
{
	set sc = ##class(History.AvgPosts).AddedExists(data("Added"))
	
	if sc {
		set sc = ..Update(.data)
	} else {
		set sc = ..Insert(.data)
	}
	
	quit sc
}

ClassMethod Insert(ByRef data) As %Status
{
	&sql(
		INSERT INTO History.AvgPosts (Added,PerDay)
		VALUES (:data("Added"), :data("PerDay"))
	)
	
	if SQLCODE=0 {
		set data = %ROWID 
		quit $$$OK	
	}
	
	quit $$$ERROR($$$SQLError, SQLCODE, $get(%msg))
}

ClassMethod Update(ByRef data) As %Status
{
	&sql( UPDATE History.AvgPosts 
		SET PerDay = :data("PerDay")
		WHERE Added =:data("Added")
	)
	
	quit:SQLCODE=0 $$$OK
	quit $$$ERROR($$$SQLError, SQLCODE, $get(%msg))
}

Storage Default
{
<Data name="AvgPostsDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Added</Value>
</Value>
<Value name="3">
<Value>PerDay</Value>
</Value>
</Data>
<DataLocation>^History.AvgPostsD</DataLocation>
<DefaultData>AvgPostsDefaultData</DefaultData>
<IdLocation>^History.AvgPostsD</IdLocation>
<IndexLocation>^History.AvgPostsI</IndexLocation>
<StreamLocation>^History.AvgPostsS</StreamLocation>
<Type>%Library.CacheStorage</Type>
}

}

