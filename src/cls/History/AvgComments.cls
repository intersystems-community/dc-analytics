Class History.AvgComments Extends %Persistent [ DependsOn = Community.Comment ]
{

Parameter DSTIME = "AUTO";

Property Added As %Date;

Index Added On Added [ Unique ];

Property PerDay As %Float;

ClassMethod InsertAvgCommentsHistory()
{
	set sql = "SELECT MIN(Created) AS MinCreated "
			 _"FROM Community.Comment"
			 
	set rs = ##class(%SQL.Statement).%ExecDirect(,sql)
	if rs.%Next(){
		set minCreatedODBC = rs.MinCreated
		set minCreated = $zdh(minCreatedODBC,3)
		set daysAmount = +$now(300) - minCreated + 1
	}
	
	set todayDate = $zdt($now(300),3)
	set sql = "SELECT Count(Id) AS CommentsAmount "
			 _"FROM Community.Comment "
			 _"WHERE Created <= ?"
			 
	set rs = ##class(%SQL.Statement).%ExecDirect(,sql,todayDate)
	if rs.%Next(){
		set data("Added") = +$now(300)
		set data("PerDay") = (((rs.CommentsAmount/daysAmount)*100)\1)/100
	}
		
	set sc = ##class(History.AvgComments).InsertOrUpdate(.data)
	quit sc
}

ClassMethod InsertOrUpdate(ByRef data) As %Status
{
	set sc = ##class(History.AvgComments).AddedExists(data("Added"))
	
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
		INSERT INTO History.AvgComments (Added,PerDay)
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
	&sql( UPDATE History.AvgComments 
		SET PerDay = :data("PerDay")
		WHERE Added =:data("Added")
	)
	
	quit:SQLCODE=0 $$$OK
	quit $$$ERROR($$$SQLError, SQLCODE, $get(%msg))
}

Storage Default
{
<Data name="AvgCommentsDefaultData">
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
<DataLocation>^History.AvgCommentsD</DataLocation>
<DefaultData>AvgCommentsDefaultData</DefaultData>
<IdLocation>^History.AvgCommentsD</IdLocation>
<IndexLocation>^History.AvgCommentsI</IndexLocation>
<StreamLocation>^History.AvgCommentsS</StreamLocation>
<Type>%Library.CacheStorage</Type>
}

}

