Include Community

Class Community.Member Extends %Persistent [ DependsOn = Community.Utils.Hash ]
{

Parameter MANAGEDEXTENT = 0;

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

ClassMethod Upsert(Uid, FirstName, LastName, Company, Position, Created, SubSuspended) As %Status
{
	Set Hash = ##class(Community.Utils.Hash).Hash(Uid, FirstName, LastName, Company, Position, Created) 
 	Return:(Hash=..HashGetStored(Uid)) $$$OK
	
	If ..%ExistsId(Uid) {
		Set Member = ..%OpenId(Uid)
	} Else {
		Set Member = ..%New()
		Set Member.Uid = Uid
	}

	Set Member.Hash = Hash
	Set Member.FirstName = FirstName
	Set Member.LastName = LastName
	
	Set Member.Created = Created
	
	Set st = Member.%Save()
	
	Return st
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

