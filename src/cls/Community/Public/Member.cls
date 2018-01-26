Include Community

Class Community.Public.Member Extends %Persistent
{

Parameter DSTIME = "AUTO";

Property Uid As %Integer [ Required ];

Index IDKEY On Uid [ IdKey, Unique ];

Property Added As %Date;

Property Name As %String(MAXLEN = 255) [ SqlComputeCode = {set {*} = {FirstName} _ " " _ {LastName}}, SqlComputed, SqlComputeOnChange = (LastName, FirstName) ];

Property FirstName As %String(MAXLEN = 255);

Property LastName As %String(MAXLEN = 255);

Property Created As %TimeStamp;

Property Link As %String(MAXLEN = 150) [ SqlComputeCode = {set {*} = $$$Server _ "user/" _ {Uid}}, SqlComputed, SqlComputeOnChange = %%INSERT ];

Index Link On Link [ Unique ];

Property Hash As %String;

Relationship Posts As Community.Post [ Cardinality = many, Inverse = Author ];

Relationship Comments As Community.Comment [ Cardinality = many, Inverse = Author ];

Relationship Votes As Community.Vote [ Cardinality = many, Inverse = Author ];

ClassMethod Update() As %Status
{
	&sql(SELECT MAX(ID) INTO :lastMember FROM Community_Public.Member)
	
	if 'lastMember set lastMember = 0
	
	&sql(INSERT INTO Community_Public.Member (Uid, Added, Name, FirstName, LastName, Created, Link, Hash)
		 SELECT Uid, Added, Name, FirstName, LastName, Created, Link, Hash
		 FROM Community.Member cm
		 WHERE cm.Uid > 0)
		 
	if '((SQLCODE = 0) || (SQLCODE = 100)) quit $$$ERROR($$$SQLError, SQLCODE, $get(%msg))
	
	&sql(DECLARE SQLCursor CURSOR FOR
		 SELECT cm.Uid, cm.Added, cm.Name, cm.FirstName, cm.LastName, cm.Created, cm.Link, cm.Hash
		 INTO :Uid, :Added, :Name, :FirstName, :LastName, :Created, :Link, :Hash
		 FROM Community.Member cm
		 	LEFT OUTER JOIN Community_Public.Member cpm ON cm.id = cpm.id
		 WHERE cm.Id <= :lastMember AND cm.Hash != cpm.Hash)
		 
	if '((SQLCODE = 0) || (SQLCODE = 100)) quit $$$ERROR($$$SQLError, SQLCODE, $get(%msg))
		 
	&sql(OPEN SQLCursor)
	&sql(FETCH SQLCursor)
	while (SQLCODE = 0) {
		&sql(UPDATE Community_Public.Member 
			 SET Added = :Added, Name = :Name, FirstName = :FirstName, LastName = :LastName, Created = :Created, Link = :Link, Hash = :Hash
			 WHERE Uid = :Uid)
		
		&sql(FETCH SQLCursor)
	}
	
	quit $$$OK
}

Storage Default
{
<Data name="MemberDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Added</Value>
</Value>
<Value name="3">
<Value>Name</Value>
</Value>
<Value name="4">
<Value>FirstName</Value>
</Value>
<Value name="5">
<Value>LastName</Value>
</Value>
<Value name="6">
<Value>Company</Value>
</Value>
<Value name="7">
<Value>Position</Value>
</Value>
<Value name="8">
<Value>Created</Value>
</Value>
<Value name="9">
<Value>Link</Value>
</Value>
<Value name="10">
<Value>SubSuspended</Value>
</Value>
<Value name="11">
<Value>Hash</Value>
</Value>
</Data>
<DataLocation>^Community.Public.MemberD</DataLocation>
<DefaultData>MemberDefaultData</DefaultData>
<IdLocation>^Community.Public.MemberD</IdLocation>
<IndexLocation>^Community.Public.MemberI</IndexLocation>
<StreamLocation>^Community.Public.MemberS</StreamLocation>
<Type>%Library.CacheStorage</Type>
}

}

