Class History.Views Extends %Persistent [ DependsOn = Community.Post ]
{

Parameter DSTIME = "AUTO";

Property Post As Community.Post;

Property DateOfData As %Date;

Property Views As %Integer;

Property Delta As %Integer;

Index DateOfDataAndPost On (DateOfData, Post) [ Unique ];

ClassMethod InsertHistoryViews() As %Status
{
	set sc = $$$OK
	set todayDate = +$now(300) - 1
	&sql(SELECT MAX(DateOfData) INTO :TableDate FROM History.Views)
	
	set sql = "SELECT Id, Views "
			 _"FROM Community.Post "
			 _"WHERE Views > 0"
	set rs = ##class(%SQL.Statement).%ExecDirect(,sql)
	
	if ((todayDate = TableDate) && (SQLCODE=0)) quit $$$OK
	
	while rs.%Next(){
		set views = rs.Views
		set id = rs.Id
		set sc = ##class(History.Views).Insert(id,views,todayDate)
		if $$$ISERR(sc) {do $system.Status.DisplayError(sc) quit}
	}
	
	do ..DeltaCalculate()
	return sc
}

ClassMethod Insert(id, views, todayDate) As %Status
{
	&sql(
		INSERT INTO History.Views (Post,Views,DateOfData)
		VALUES (:id, :views, :todayDate)
	)
	if SQLCODE=0 quit $$$OK
	
	quit $$$ERROR($$$SQLError, SQLCODE, $g(%msg))
}

ClassMethod DeltaCalculate()
{
	&sql(SELECT MIN(DateOfData) INTO :MINDATE FROM History.Views)
	
	&sql(DECLARE SQLCURSOR1 CURSOR FOR
		SELECT DISTINCT Post
		INTO :POST
		FROM History.Views
	)
	
	&sql(OPEN SQLCURSOR1)
	&sql(FETCH SQLCURSOR1)
	
	while (SQLCODE = 0) {		
		&sql(DECLARE SQLCURSOR2 CURSOR FOR
			SELECT ID, Views, DateOfData
			INTO :ID, :VIEWS, :DATE
			FROM History.Views
			WHERE Post = :POST
			ORDER BY DateOfData
		)
		
		&sql(OPEN SQLCURSOR2)
		&sql(FETCH SQLCURSOR2)
		
		if DATE = MINDATE {
			set PrevoiusDateViews = VIEWS
			&sql(UPDATE History.Views SET Delta = 0 WHERE ID = :ID)
			&sql(FETCH SQLCURSOR2)
		} else {
			set PrevoiusDateViews = 0
		}
	
		while (SQLCODE = 0) {
			set DELTA = VIEWS - PrevoiusDateViews
			&sql(UPDATE History.Views SET Delta = :DELTA WHERE ID = :ID)
			set PrevoiusDateViews = VIEWS
			&sql(FETCH SQLCURSOR2)
		}
		
		&sql(CLOSE SQLCURSOR2)
		&sql(FETCH SQLCURSOR1)
	}
	
    &sql(CLOSE SQLCURSOR1)
}

Storage Default
{
<Data name="ViewsDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Post</Value>
</Value>
<Value name="3">
<Value>DateOfData</Value>
</Value>
<Value name="4">
<Value>Views</Value>
</Value>
<Value name="5">
<Value>Delta</Value>
</Value>
</Data>
<DataLocation>^History.ViewsD</DataLocation>
<DefaultData>ViewsDefaultData</DefaultData>
<IdLocation>^History.ViewsD</IdLocation>
<IndexLocation>^History.ViewsI</IndexLocation>
<StreamLocation>^History.ViewsS</StreamLocation>
<Type>%Library.CacheStorage</Type>
}

}

